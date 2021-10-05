Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4A164225BD
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 13:52:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234133AbhJELyq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 07:54:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232658AbhJELyp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 07:54:45 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3910C061749
        for <netdev@vger.kernel.org>; Tue,  5 Oct 2021 04:52:54 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1mXj08-0003RT-Ih; Tue, 05 Oct 2021 13:52:52 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>,
        Christian Brauner <christian.brauner@ubuntu.com>
Subject: [PATCH net-next] netlink: remove netlink_broadcast_filtered
Date:   Tue,  5 Oct 2021 13:52:42 +0200
Message-Id: <20211005115242.9630-1-fw@strlen.de>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

No users in tree since commit a3498436b3a0 ("netns: restrict uevents"),
so remove this functionality.

Cc: Christian Brauner <christian.brauner@ubuntu.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/linux/netlink.h  |  4 ----
 net/netlink/af_netlink.c | 23 ++---------------------
 2 files changed, 2 insertions(+), 25 deletions(-)

diff --git a/include/linux/netlink.h b/include/linux/netlink.h
index 61b1c7fcc401..1ec631838af9 100644
--- a/include/linux/netlink.h
+++ b/include/linux/netlink.h
@@ -156,10 +156,6 @@ bool netlink_strict_get_check(struct sk_buff *skb);
 int netlink_unicast(struct sock *ssk, struct sk_buff *skb, __u32 portid, int nonblock);
 int netlink_broadcast(struct sock *ssk, struct sk_buff *skb, __u32 portid,
 		      __u32 group, gfp_t allocation);
-int netlink_broadcast_filtered(struct sock *ssk, struct sk_buff *skb,
-			       __u32 portid, __u32 group, gfp_t allocation,
-			       int (*filter)(struct sock *dsk, struct sk_buff *skb, void *data),
-			       void *filter_data);
 int netlink_set_err(struct sock *ssk, __u32 portid, __u32 group, int code);
 int netlink_register_notifier(struct notifier_block *nb);
 int netlink_unregister_notifier(struct notifier_block *nb);
diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 24b7cf447bc5..4f5f93fd6802 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -1407,8 +1407,6 @@ struct netlink_broadcast_data {
 	int delivered;
 	gfp_t allocation;
 	struct sk_buff *skb, *skb2;
-	int (*tx_filter)(struct sock *dsk, struct sk_buff *skb, void *data);
-	void *tx_data;
 };
 
 static void do_one_broadcast(struct sock *sk,
@@ -1462,11 +1460,6 @@ static void do_one_broadcast(struct sock *sk,
 			p->delivery_failure = 1;
 		goto out;
 	}
-	if (p->tx_filter && p->tx_filter(sk, p->skb2, p->tx_data)) {
-		kfree_skb(p->skb2);
-		p->skb2 = NULL;
-		goto out;
-	}
 	if (sk_filter(sk, p->skb2)) {
 		kfree_skb(p->skb2);
 		p->skb2 = NULL;
@@ -1489,10 +1482,8 @@ static void do_one_broadcast(struct sock *sk,
 	sock_put(sk);
 }
 
-int netlink_broadcast_filtered(struct sock *ssk, struct sk_buff *skb, u32 portid,
-	u32 group, gfp_t allocation,
-	int (*filter)(struct sock *dsk, struct sk_buff *skb, void *data),
-	void *filter_data)
+int netlink_broadcast(struct sock *ssk, struct sk_buff *skb, u32 portid,
+		      u32 group, gfp_t allocation)
 {
 	struct net *net = sock_net(ssk);
 	struct netlink_broadcast_data info;
@@ -1511,8 +1502,6 @@ int netlink_broadcast_filtered(struct sock *ssk, struct sk_buff *skb, u32 portid
 	info.allocation = allocation;
 	info.skb = skb;
 	info.skb2 = NULL;
-	info.tx_filter = filter;
-	info.tx_data = filter_data;
 
 	/* While we sleep in clone, do not allow to change socket list */
 
@@ -1538,14 +1527,6 @@ int netlink_broadcast_filtered(struct sock *ssk, struct sk_buff *skb, u32 portid
 	}
 	return -ESRCH;
 }
-EXPORT_SYMBOL(netlink_broadcast_filtered);
-
-int netlink_broadcast(struct sock *ssk, struct sk_buff *skb, u32 portid,
-		      u32 group, gfp_t allocation)
-{
-	return netlink_broadcast_filtered(ssk, skb, portid, group, allocation,
-		NULL, NULL);
-}
 EXPORT_SYMBOL(netlink_broadcast);
 
 struct netlink_set_err_data {
-- 
2.32.0

