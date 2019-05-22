Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E184426A7C
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 21:05:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729707AbfEVTFG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 15:05:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:35062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729641AbfEVTE7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 May 2019 15:04:59 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CF4F8217F9;
        Wed, 22 May 2019 19:04:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558551898;
        bh=ngtFcyO/eM0a2DYgpvx+qpEEgnBZZvNw0/3LTnNC8G4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o5mteEeA8FPOuUhgTky2bSAx4NAveNvOraCVOQAFrEHtEc7pS7TOhB9YC2nt0J+VS
         I5Ny130DblWSEGbUEqOkW9BEflexSBrqHpjLOW47aa4/CO1YzfND6+QeHoJcGlFMYR
         dJ5yi0UQVprPuosxUnKxYEa7kBdcoVG+00eWbOhE=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     idosch@mellanox.com, David Ahern <dsahern@gmail.com>
Subject: [PATCH v2 net-next 8/8] ipv4: Rename and export nh_update_mtu
Date:   Wed, 22 May 2019 12:04:46 -0700
Message-Id: <20190522190446.15486-9-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190522190446.15486-1-dsahern@kernel.org>
References: <20190522190446.15486-1-dsahern@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Rename nh_update_mtu to fib_nhc_update_mtu and export for use by the
nexthop code.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 include/net/ip_fib.h     | 1 +
 net/ipv4/fib_semantics.c | 4 ++--
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/net/ip_fib.h b/include/net/ip_fib.h
index 8511ebb6f7be..70ba0302c8c9 100644
--- a/include/net/ip_fib.h
+++ b/include/net/ip_fib.h
@@ -432,6 +432,7 @@ int fib_sync_down_dev(struct net_device *dev, unsigned long event, bool force);
 int fib_sync_down_addr(struct net_device *dev, __be32 local);
 int fib_sync_up(struct net_device *dev, unsigned char nh_flags);
 void fib_sync_mtu(struct net_device *dev, u32 orig_mtu);
+void fib_nhc_update_mtu(struct fib_nh_common *nhc, u32 new, u32 orig);
 
 #ifdef CONFIG_IP_ROUTE_MULTIPATH
 int fib_multipath_hash(const struct net *net, const struct flowi4 *fl4,
diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index bd8c51d2c59b..78648072783e 100644
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -1712,7 +1712,7 @@ static int call_fib_nh_notifiers(struct fib_nh *nh,
  * - if the new MTU is greater than the PMTU, don't make any change
  * - otherwise, unlock and set PMTU
  */
-static void nh_update_mtu(struct fib_nh_common *nhc, u32 new, u32 orig)
+void fib_nhc_update_mtu(struct fib_nh_common *nhc, u32 new, u32 orig)
 {
 	struct fnhe_hash_bucket *bucket;
 	int i;
@@ -1748,7 +1748,7 @@ void fib_sync_mtu(struct net_device *dev, u32 orig_mtu)
 
 	hlist_for_each_entry(nh, head, nh_hash) {
 		if (nh->fib_nh_dev == dev)
-			nh_update_mtu(&nh->nh_common, dev->mtu, orig_mtu);
+			fib_nhc_update_mtu(&nh->nh_common, dev->mtu, orig_mtu);
 	}
 }
 
-- 
2.11.0

