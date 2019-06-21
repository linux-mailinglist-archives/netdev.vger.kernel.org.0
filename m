Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B2374EC7D
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 17:47:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726520AbfFUPrV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jun 2019 11:47:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59050 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726469AbfFUPrU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Jun 2019 11:47:20 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7CAD4356F8;
        Fri, 21 Jun 2019 15:47:20 +0000 (UTC)
Received: from epycfail.redhat.com (unknown [10.36.112.13])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EC86119C4F;
        Fri, 21 Jun 2019 15:47:16 +0000 (UTC)
From:   Stefano Brivio <sbrivio@redhat.com>
To:     David Miller <davem@davemloft.net>, David Ahern <dsahern@gmail.com>
Cc:     Jianlin Shi <jishi@redhat.com>, Wei Wang <weiwan@google.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Eric Dumazet <edumazet@google.com>,
        Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
        netdev@vger.kernel.org
Subject: [PATCH net-next v7 09/11] ip6_fib: Don't discard nodes with valid routing information in fib6_locate_1()
Date:   Fri, 21 Jun 2019 17:45:28 +0200
Message-Id: <25dbd936ec0f3266aceccdf51056eb8aa093e05b.1561131177.git.sbrivio@redhat.com>
In-Reply-To: <cover.1561131177.git.sbrivio@redhat.com>
References: <cover.1561131177.git.sbrivio@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.30]); Fri, 21 Jun 2019 15:47:20 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When we perform an inexact match on FIB nodes via fib6_locate_1(), longer
prefixes will be preferred to shorter ones. However, it might happen that
a node, with higher fn_bit value than some other, has no valid routing
information.

In this case, we'll pick that node, but it will be discarded by the check
on RTN_RTINFO in fib6_locate(), and we might miss nodes with valid routing
information but with lower fn_bit value.

This is apparent when a routing exception is created for a default route:
 # ip -6 route list
 fc00:1::/64 dev veth_A-R1 proto kernel metric 256 pref medium
 fc00:2::/64 dev veth_A-R2 proto kernel metric 256 pref medium
 fc00:4::1 via fc00:2::2 dev veth_A-R2 metric 1024 pref medium
 fe80::/64 dev veth_A-R1 proto kernel metric 256 pref medium
 fe80::/64 dev veth_A-R2 proto kernel metric 256 pref medium
 default via fc00:1::2 dev veth_A-R1 metric 1024 pref medium
 # ip -6 route list cache
 fc00:4::1 via fc00:2::2 dev veth_A-R2 metric 1024 expires 593sec mtu 1500 pref medium
 fc00:3::1 via fc00:1::2 dev veth_A-R1 metric 1024 expires 593sec mtu 1500 pref medium
 # ip -6 route flush cache    # node for default route is discarded
 Failed to send flush request: No such process
 # ip -6 route list cache
 fc00:3::1 via fc00:1::2 dev veth_A-R1 metric 1024 expires 586sec mtu 1500 pref medium

Check right away if the node has a RTN_RTINFO flag, before replacing the
'prev' pointer, that indicates the longest matching prefix found so far.

Fixes: 38fbeeeeccdb ("ipv6: prepare fib6_locate() for exception table")
Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
---
v7: No changes

v6: Rebased onto net-next, no changes

v5: No changes

v4: No changes

v3: No changes

v2: No changes

 net/ipv6/ip6_fib.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
index 92a6bde57594..8f36e6742c36 100644
--- a/net/ipv6/ip6_fib.c
+++ b/net/ipv6/ip6_fib.c
@@ -1595,7 +1595,8 @@ static struct fib6_node *fib6_locate_1(struct fib6_node *root,
 		if (plen == fn->fn_bit)
 			return fn;
 
-		prev = fn;
+		if (fn->fn_flags & RTN_RTINFO)
+			prev = fn;
 
 next:
 		/*
-- 
2.20.1

