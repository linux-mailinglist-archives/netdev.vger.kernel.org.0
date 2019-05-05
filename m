Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A14614128
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 18:39:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727913AbfEEQju (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 12:39:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:39776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727806AbfEEQjm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 May 2019 12:39:42 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0160121479;
        Sun,  5 May 2019 16:39:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557074382;
        bh=nL2uiPeXfEQSeWHp2p9uhMk/PBLIrRkch+zPeg2mv44=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0I+LpCC+OtcwrMzmvCgkJ6W3adgZ8i/QecDmsyrWMuqJvcAujrauzhVlIS9eRvMrr
         CF3s69KLY3/ZbUiVGZlZdYwZvK+tM1aZ/lNUeLcrSXrfl/i2A2cYp4DSBx6jpG0iwP
         Ih9HO5uXgG6MWG+A9lM5PBTkyRToST4Mt27v3up0=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     idosch@mellanox.com, David Ahern <dsahern@gmail.com>
Subject: [PATCH net-next 7/7] ipv4: export fib_info_update_nh_saddr
Date:   Sun,  5 May 2019 09:40:56 -0700
Message-Id: <20190505164056.1742-8-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190505164056.1742-1-dsahern@kernel.org>
References: <20190505164056.1742-1-dsahern@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Add scope as input argument versus relying on fib_info reference in
fib_nh, and export fib_info_update_nh_saddr.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 include/net/ip_fib.h     |  3 ++-
 net/ipv4/fib_semantics.c | 11 +++++------
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/include/net/ip_fib.h b/include/net/ip_fib.h
index 79c18bd6a059..8511ebb6f7be 100644
--- a/include/net/ip_fib.h
+++ b/include/net/ip_fib.h
@@ -201,7 +201,8 @@ static inline struct fib_nh_common *fib_info_nhc(struct fib_info *fi, int nhsel)
 #define FIB_TABLE_HASHSZ 2
 #endif
 
-__be32 fib_info_update_nh_saddr(struct net *net, struct fib_nh *nh);
+__be32 fib_info_update_nh_saddr(struct net *net, struct fib_nh *nh,
+				unsigned char scope);
 __be32 fib_result_prefsrc(struct net *net, struct fib_result *res);
 
 #define FIB_RES_NHC(res)		((res).nhc)
diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index 4541121426fb..bd8c51d2c59b 100644
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -1189,11 +1189,10 @@ static void fib_info_hash_move(struct hlist_head *new_info_hash,
 	fib_info_hash_free(old_laddrhash, bytes);
 }
 
-__be32 fib_info_update_nh_saddr(struct net *net, struct fib_nh *nh)
+__be32 fib_info_update_nh_saddr(struct net *net, struct fib_nh *nh,
+				unsigned char scope)
 {
-	nh->nh_saddr = inet_select_addr(nh->fib_nh_dev,
-					nh->fib_nh_gw4,
-					nh->nh_parent->fib_scope);
+	nh->nh_saddr = inet_select_addr(nh->fib_nh_dev, nh->fib_nh_gw4, scope);
 	nh->nh_saddr_genid = atomic_read(&net->ipv4.dev_addr_genid);
 
 	return nh->nh_saddr;
@@ -1211,7 +1210,7 @@ __be32 fib_result_prefsrc(struct net *net, struct fib_result *res)
 	if (nh->nh_saddr_genid == atomic_read(&net->ipv4.dev_addr_genid))
 		return nh->nh_saddr;
 
-	return fib_info_update_nh_saddr(net, nh);
+	return fib_info_update_nh_saddr(net, nh, res->fi->fib_scope);
 }
 
 static bool fib_valid_prefsrc(struct fib_config *cfg, __be32 fib_prefsrc)
@@ -1393,7 +1392,7 @@ struct fib_info *fib_create_info(struct fib_config *cfg,
 	}
 
 	change_nexthops(fi) {
-		fib_info_update_nh_saddr(net, nexthop_nh);
+		fib_info_update_nh_saddr(net, nexthop_nh, fi->fib_scope);
 		if (nexthop_nh->fib_nh_gw_family == AF_INET6)
 			fi->fib_nh_is_v6 = true;
 	} endfor_nexthops(fi)
-- 
2.11.0

