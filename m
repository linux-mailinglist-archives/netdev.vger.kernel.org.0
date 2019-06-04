Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C88433CC8
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 03:37:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726174AbfFDBhF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 21:37:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:37076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726033AbfFDBhF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Jun 2019 21:37:05 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 664F9243D6;
        Tue,  4 Jun 2019 01:37:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559612224;
        bh=oNlFGsFyynyqg/jA1origqu0r2/ozsxeIVArPIqhHMw=;
        h=From:To:Cc:Subject:Date:From;
        b=dCKTxJRbD3VCaVoRC9Ln8yDnjZg2C8zCy8Kzk1Lcj+wVWcz/potJ0RlUFIgCh/o77
         CNpI59a+DphsCxkj9KQXefsUCD/ZTX/ZV3cmg9FRJ4zQciW82r18G9U3biLb8gqTFX
         PvXvpRC3Ncojn6tOb0fu7QPbGUrDuEMYOee9H8sk=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>
Subject: [PATCH net-next] ipv6: Always allocate pcpu memory in a fib6_nh
Date:   Mon,  3 Jun 2019 18:37:03 -0700
Message-Id: <20190604013703.2043-1-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

A recent commit had an unintended side effect with reject routes:
rt6i_pcpu is expected to always be initialized for all fib6_info except
the null entry. The commit mentioned below skips it for reject routes
and ends up leaking references to the loopback device. For example,

    ip netns add foo
    ip -netns foo li set lo up
    ip -netns foo -6 ro add blackhole 2001:db8:1::1
    ip netns exec foo ping6 2001:db8:1::1
    ip netns del foo

ends up spewing:
    unregister_netdevice: waiting for lo to become free. Usage count = 3

The fib_nh_common_init is not needed for reject routes (no ipv4 caching
or encaps), so move the alloc_percpu_gfp after it and adjust the goto label.

Fixes: f40b6ae2b612 ("ipv6: Move pcpu cached routes to fib6_nh")
Signed-off-by: David Ahern <dsahern@gmail.com>
---
 net/ipv6/route.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 29c2f5086116..d5777e92609d 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -3400,7 +3400,7 @@ int fib6_nh_init(struct net *net, struct fib6_nh *fib6_nh,
 				goto out;
 			}
 		}
-		goto set_dev;
+		goto pcpu_alloc;
 	}
 
 	if (cfg->fc_flags & RTF_GATEWAY) {
@@ -3432,17 +3432,18 @@ int fib6_nh_init(struct net *net, struct fib6_nh *fib6_nh,
 	    !netif_carrier_ok(dev))
 		fib6_nh->fib_nh_flags |= RTNH_F_LINKDOWN;
 
+	err = fib_nh_common_init(&fib6_nh->nh_common, cfg->fc_encap,
+				 cfg->fc_encap_type, cfg, gfp_flags, extack);
+	if (err)
+		goto out;
+
+pcpu_alloc:
 	fib6_nh->rt6i_pcpu = alloc_percpu_gfp(struct rt6_info *, gfp_flags);
 	if (!fib6_nh->rt6i_pcpu) {
 		err = -ENOMEM;
 		goto out;
 	}
 
-	err = fib_nh_common_init(&fib6_nh->nh_common, cfg->fc_encap,
-				 cfg->fc_encap_type, cfg, gfp_flags, extack);
-	if (err)
-		goto out;
-set_dev:
 	fib6_nh->fib_nh_dev = dev;
 	fib6_nh->fib_nh_oif = dev->ifindex;
 	err = 0;
-- 
2.11.0

