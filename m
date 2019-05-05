Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1EF6914124
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 18:39:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727846AbfEEQjo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 12:39:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:39792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727771AbfEEQjm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 May 2019 12:39:42 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8443520C01;
        Sun,  5 May 2019 16:39:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557074381;
        bh=NHYwx/lArxHWha4AoCpgHlXLpISiIEpclrFvtMtsAU4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A9yw4irXxkmhl6G1D7wE36Vvl6Zi1eYjmBA2x6kP+ZeT/gByt35Bddln6cpuoMop1
         HaaUHTw0opY8G8hI7jR7NgRWs9QkZiXdoHNIJmG4a01M6oNkFCuLb4oTQmWCb7sOG2
         t1MAcD1Sn638HCcAEfcIib9NQzMpOESB1tO/t3bI=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     idosch@mellanox.com, David Ahern <dsahern@gmail.com>
Subject: [PATCH net-next 5/7] ipv4: export fib_check_nh
Date:   Sun,  5 May 2019 09:40:54 -0700
Message-Id: <20190505164056.1742-6-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190505164056.1742-1-dsahern@kernel.org>
References: <20190505164056.1742-1-dsahern@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Change fib_check_nh to take net, table and scope as input arguments
over struct fib_config and export for use by nexthop code.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 include/net/ip_fib.h     |  2 ++
 net/ipv4/fib_semantics.c | 12 ++++++------
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/include/net/ip_fib.h b/include/net/ip_fib.h
index ec6496c08f48..27d7c89ca9c4 100644
--- a/include/net/ip_fib.h
+++ b/include/net/ip_fib.h
@@ -436,6 +436,8 @@ void fib_sync_mtu(struct net_device *dev, u32 orig_mtu);
 int fib_multipath_hash(const struct net *net, const struct flowi4 *fl4,
 		       const struct sk_buff *skb, struct flow_keys *flkeys);
 #endif
+int fib_check_nh(struct net *net, struct fib_nh *nh, u32 table, u8 scope,
+		 struct netlink_ext_ack *extack);
 void fib_select_multipath(struct fib_result *res, int hash);
 void fib_select_path(struct net *net, struct fib_result *res,
 		     struct flowi4 *fl4, const struct sk_buff *skb);
diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index d3da6a10f86f..4541121426fb 100644
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -1092,15 +1092,13 @@ static int fib_check_nh_nongw(struct net *net, struct fib_nh *nh,
 	return err;
 }
 
-static int fib_check_nh(struct fib_config *cfg, struct fib_nh *nh,
-			struct netlink_ext_ack *extack)
+int fib_check_nh(struct net *net, struct fib_nh *nh, u32 table, u8 scope,
+		 struct netlink_ext_ack *extack)
 {
-	struct net *net = cfg->fc_nlinfo.nl_net;
-	u32 table = cfg->fc_table;
 	int err;
 
 	if (nh->fib_nh_gw_family == AF_INET)
-		err = fib_check_nh_v4_gw(net, nh, table, cfg->fc_scope, extack);
+		err = fib_check_nh_v4_gw(net, nh, table, scope, extack);
 	else if (nh->fib_nh_gw_family == AF_INET6)
 		err = fib_check_nh_v6_gw(net, nh, table, extack);
 	else
@@ -1377,7 +1375,9 @@ struct fib_info *fib_create_info(struct fib_config *cfg,
 		int linkdown = 0;
 
 		change_nexthops(fi) {
-			err = fib_check_nh(cfg, nexthop_nh, extack);
+			err = fib_check_nh(cfg->fc_nlinfo.nl_net, nexthop_nh,
+					   cfg->fc_table, cfg->fc_scope,
+					   extack);
 			if (err != 0)
 				goto failure;
 			if (nexthop_nh->fib_nh_flags & RTNH_F_LINKDOWN)
-- 
2.11.0

