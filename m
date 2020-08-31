Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A388F25769C
	for <lists+netdev@lfdr.de>; Mon, 31 Aug 2020 11:37:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726503AbgHaJhJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 05:37:09 -0400
Received: from correo.us.es ([193.147.175.20]:40368 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726248AbgHaJg6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 31 Aug 2020 05:36:58 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 8071815AEB0
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 11:36:56 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 70C05DA84D
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 11:36:56 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 660DBDA84A; Mon, 31 Aug 2020 11:36:56 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WELCOMELIST,USER_IN_WHITELIST
        autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1A541DA78C;
        Mon, 31 Aug 2020 11:36:54 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 31 Aug 2020 11:36:54 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id E330342EF4E0;
        Mon, 31 Aug 2020 11:36:53 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH 2/8] netfilter: nfnetlink: nfnetlink_unicast() reports EAGAIN instead of ENOBUFS
Date:   Mon, 31 Aug 2020 11:36:42 +0200
Message-Id: <20200831093648.20765-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200831093648.20765-1-pablo@netfilter.org>
References: <20200831093648.20765-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Frontend callback reports EAGAIN to nfnetlink to retry a command, this
is used to signal that module autoloading is required. Unfortunately,
nlmsg_unicast() reports EAGAIN in case the receiver socket buffer gets
full, so it enters a busy-loop.

This patch updates nfnetlink_unicast() to turn EAGAIN into ENOBUFS and
to use nlmsg_unicast(). Remove the flags field in nfnetlink_unicast()
since this is always MSG_DONTWAIT in the existing code which is exactly
what nlmsg_unicast() passes to netlink_unicast() as parameter.

Fixes: 96518518cc41 ("netfilter: add nftables")
Reported-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter/nfnetlink.h |  3 +-
 net/netfilter/nf_tables_api.c       | 61 ++++++++++++++---------------
 net/netfilter/nfnetlink.c           | 11 ++++--
 net/netfilter/nfnetlink_log.c       |  3 +-
 net/netfilter/nfnetlink_queue.c     |  2 +-
 5 files changed, 40 insertions(+), 40 deletions(-)

diff --git a/include/linux/netfilter/nfnetlink.h b/include/linux/netfilter/nfnetlink.h
index 851425c3178f..89016d08f6a2 100644
--- a/include/linux/netfilter/nfnetlink.h
+++ b/include/linux/netfilter/nfnetlink.h
@@ -43,8 +43,7 @@ int nfnetlink_has_listeners(struct net *net, unsigned int group);
 int nfnetlink_send(struct sk_buff *skb, struct net *net, u32 portid,
 		   unsigned int group, int echo, gfp_t flags);
 int nfnetlink_set_err(struct net *net, u32 portid, u32 group, int error);
-int nfnetlink_unicast(struct sk_buff *skb, struct net *net, u32 portid,
-		      int flags);
+int nfnetlink_unicast(struct sk_buff *skb, struct net *net, u32 portid);
 
 static inline u16 nfnl_msg_type(u8 subsys, u8 msg_type)
 {
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 71e501c5ad21..b7dc1cbf40ea 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -815,11 +815,11 @@ static int nf_tables_gettable(struct net *net, struct sock *nlsk,
 					nlh->nlmsg_seq, NFT_MSG_NEWTABLE, 0,
 					family, table);
 	if (err < 0)
-		goto err;
+		goto err_fill_table_info;
 
-	return nlmsg_unicast(nlsk, skb2, NETLINK_CB(skb).portid);
+	return nfnetlink_unicast(skb2, net, NETLINK_CB(skb).portid);
 
-err:
+err_fill_table_info:
 	kfree_skb(skb2);
 	return err;
 }
@@ -1563,11 +1563,11 @@ static int nf_tables_getchain(struct net *net, struct sock *nlsk,
 					nlh->nlmsg_seq, NFT_MSG_NEWCHAIN, 0,
 					family, table, chain);
 	if (err < 0)
-		goto err;
+		goto err_fill_chain_info;
 
-	return nlmsg_unicast(nlsk, skb2, NETLINK_CB(skb).portid);
+	return nfnetlink_unicast(skb2, net, NETLINK_CB(skb).portid);
 
-err:
+err_fill_chain_info:
 	kfree_skb(skb2);
 	return err;
 }
@@ -3008,11 +3008,11 @@ static int nf_tables_getrule(struct net *net, struct sock *nlsk,
 				       nlh->nlmsg_seq, NFT_MSG_NEWRULE, 0,
 				       family, table, chain, rule, NULL);
 	if (err < 0)
-		goto err;
+		goto err_fill_rule_info;
 
-	return nlmsg_unicast(nlsk, skb2, NETLINK_CB(skb).portid);
+	return nfnetlink_unicast(skb2, net, NETLINK_CB(skb).portid);
 
-err:
+err_fill_rule_info:
 	kfree_skb(skb2);
 	return err;
 }
@@ -3968,11 +3968,11 @@ static int nf_tables_getset(struct net *net, struct sock *nlsk,
 
 	err = nf_tables_fill_set(skb2, &ctx, set, NFT_MSG_NEWSET, 0);
 	if (err < 0)
-		goto err;
+		goto err_fill_set_info;
 
-	return nlmsg_unicast(nlsk, skb2, NETLINK_CB(skb).portid);
+	return nfnetlink_unicast(skb2, net, NETLINK_CB(skb).portid);
 
-err:
+err_fill_set_info:
 	kfree_skb(skb2);
 	return err;
 }
@@ -4860,24 +4860,18 @@ static int nft_get_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 	err = -ENOMEM;
 	skb = nlmsg_new(NLMSG_GOODSIZE, GFP_ATOMIC);
 	if (skb == NULL)
-		goto err1;
+		return err;
 
 	err = nf_tables_fill_setelem_info(skb, ctx, ctx->seq, ctx->portid,
 					  NFT_MSG_NEWSETELEM, 0, set, &elem);
 	if (err < 0)
-		goto err2;
+		goto err_fill_setelem;
 
-	err = nfnetlink_unicast(skb, ctx->net, ctx->portid, MSG_DONTWAIT);
-	/* This avoids a loop in nfnetlink. */
-	if (err < 0)
-		goto err1;
+	return nfnetlink_unicast(skb, ctx->net, ctx->portid);
 
-	return 0;
-err2:
+err_fill_setelem:
 	kfree_skb(skb);
-err1:
-	/* this avoids a loop in nfnetlink. */
-	return err == -EAGAIN ? -ENOBUFS : err;
+	return err;
 }
 
 /* called with rcu_read_lock held */
@@ -6182,10 +6176,11 @@ static int nf_tables_getobj(struct net *net, struct sock *nlsk,
 				      nlh->nlmsg_seq, NFT_MSG_NEWOBJ, 0,
 				      family, table, obj, reset);
 	if (err < 0)
-		goto err;
+		goto err_fill_obj_info;
 
-	return nlmsg_unicast(nlsk, skb2, NETLINK_CB(skb).portid);
-err:
+	return nfnetlink_unicast(skb2, net, NETLINK_CB(skb).portid);
+
+err_fill_obj_info:
 	kfree_skb(skb2);
 	return err;
 }
@@ -7045,10 +7040,11 @@ static int nf_tables_getflowtable(struct net *net, struct sock *nlsk,
 					    NFT_MSG_NEWFLOWTABLE, 0, family,
 					    flowtable, &flowtable->hook_list);
 	if (err < 0)
-		goto err;
+		goto err_fill_flowtable_info;
 
-	return nlmsg_unicast(nlsk, skb2, NETLINK_CB(skb).portid);
-err:
+	return nfnetlink_unicast(skb2, net, NETLINK_CB(skb).portid);
+
+err_fill_flowtable_info:
 	kfree_skb(skb2);
 	return err;
 }
@@ -7234,10 +7230,11 @@ static int nf_tables_getgen(struct net *net, struct sock *nlsk,
 	err = nf_tables_fill_gen_info(skb2, net, NETLINK_CB(skb).portid,
 				      nlh->nlmsg_seq);
 	if (err < 0)
-		goto err;
+		goto err_fill_gen_info;
 
-	return nlmsg_unicast(nlsk, skb2, NETLINK_CB(skb).portid);
-err:
+	return nfnetlink_unicast(skb2, net, NETLINK_CB(skb).portid);
+
+err_fill_gen_info:
 	kfree_skb(skb2);
 	return err;
 }
diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
index 5f24edf95830..3a2e64e13b22 100644
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -149,10 +149,15 @@ int nfnetlink_set_err(struct net *net, u32 portid, u32 group, int error)
 }
 EXPORT_SYMBOL_GPL(nfnetlink_set_err);
 
-int nfnetlink_unicast(struct sk_buff *skb, struct net *net, u32 portid,
-		      int flags)
+int nfnetlink_unicast(struct sk_buff *skb, struct net *net, u32 portid)
 {
-	return netlink_unicast(net->nfnl, skb, portid, flags);
+	int err;
+
+	err = nlmsg_unicast(net->nfnl, skb, portid);
+	if (err == -EAGAIN)
+		err = -ENOBUFS;
+
+	return err;
 }
 EXPORT_SYMBOL_GPL(nfnetlink_unicast);
 
diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index f02992419850..b35e8d9a5b37 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -356,8 +356,7 @@ __nfulnl_send(struct nfulnl_instance *inst)
 			goto out;
 		}
 	}
-	nfnetlink_unicast(inst->skb, inst->net, inst->peer_portid,
-			  MSG_DONTWAIT);
+	nfnetlink_unicast(inst->skb, inst->net, inst->peer_portid);
 out:
 	inst->qlen = 0;
 	inst->skb = NULL;
diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index dadfc06245a3..d1d8bca03b4f 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -681,7 +681,7 @@ __nfqnl_enqueue_packet(struct net *net, struct nfqnl_instance *queue,
 	*packet_id_ptr = htonl(entry->id);
 
 	/* nfnetlink_unicast will either free the nskb or add it to a socket */
-	err = nfnetlink_unicast(nskb, net, queue->peer_portid, MSG_DONTWAIT);
+	err = nfnetlink_unicast(nskb, net, queue->peer_portid);
 	if (err < 0) {
 		if (queue->flags & NFQA_CFG_F_FAIL_OPEN) {
 			failopen = 1;
-- 
2.20.1

