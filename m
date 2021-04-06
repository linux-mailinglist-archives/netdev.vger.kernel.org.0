Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9CB83553BB
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 14:23:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344060AbhDFMW7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 08:22:59 -0400
Received: from mail.netfilter.org ([217.70.188.207]:34446 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343948AbhDFMWE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Apr 2021 08:22:04 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 9161063E40;
        Tue,  6 Apr 2021 14:21:34 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 18/28] netfilter: nfnetlink: add and use nfnetlink_broadcast
Date:   Tue,  6 Apr 2021 14:21:23 +0200
Message-Id: <20210406122133.1644-19-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210406122133.1644-1-pablo@netfilter.org>
References: <20210406122133.1644-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

This removes the only reference of net->nfnl outside of the nfnetlink
module.  This allows to move net->nfnl to net_generic infra.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter/nfnetlink.h | 2 ++
 net/netfilter/nfnetlink.c           | 7 +++++++
 net/netfilter/nfnetlink_acct.c      | 3 +--
 3 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/include/linux/netfilter/nfnetlink.h b/include/linux/netfilter/nfnetlink.h
index 791d516e1e88..d4c14257db5d 100644
--- a/include/linux/netfilter/nfnetlink.h
+++ b/include/linux/netfilter/nfnetlink.h
@@ -51,6 +51,8 @@ int nfnetlink_send(struct sk_buff *skb, struct net *net, u32 portid,
 		   unsigned int group, int echo, gfp_t flags);
 int nfnetlink_set_err(struct net *net, u32 portid, u32 group, int error);
 int nfnetlink_unicast(struct sk_buff *skb, struct net *net, u32 portid);
+void nfnetlink_broadcast(struct net *net, struct sk_buff *skb, __u32 portid,
+			 __u32 group, gfp_t allocation);
 
 static inline u16 nfnl_msg_type(u8 subsys, u8 msg_type)
 {
diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
index d3df66a39b5e..06e106b3ed85 100644
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -178,6 +178,13 @@ int nfnetlink_unicast(struct sk_buff *skb, struct net *net, u32 portid)
 }
 EXPORT_SYMBOL_GPL(nfnetlink_unicast);
 
+void nfnetlink_broadcast(struct net *net, struct sk_buff *skb, __u32 portid,
+			 __u32 group, gfp_t allocation)
+{
+	netlink_broadcast(net->nfnl, skb, portid, group, allocation);
+}
+EXPORT_SYMBOL_GPL(nfnetlink_broadcast);
+
 /* Process one complete nfnetlink message. */
 static int nfnetlink_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh,
 			     struct netlink_ext_ack *extack)
diff --git a/net/netfilter/nfnetlink_acct.c b/net/netfilter/nfnetlink_acct.c
index bb930f3b06c7..6895f31c5fbb 100644
--- a/net/netfilter/nfnetlink_acct.c
+++ b/net/netfilter/nfnetlink_acct.c
@@ -469,8 +469,7 @@ static void nfnl_overquota_report(struct net *net, struct nf_acct *nfacct)
 		kfree_skb(skb);
 		return;
 	}
-	netlink_broadcast(net->nfnl, skb, 0, NFNLGRP_ACCT_QUOTA,
-			  GFP_ATOMIC);
+	nfnetlink_broadcast(net, skb, 0, NFNLGRP_ACCT_QUOTA, GFP_ATOMIC);
 }
 
 int nfnl_acct_overquota(struct net *net, struct nf_acct *nfacct)
-- 
2.30.2

