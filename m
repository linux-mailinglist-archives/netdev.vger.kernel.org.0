Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87E6913F823
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 20:17:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437563AbgAPTP4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 14:15:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:41512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732375AbgAPQzu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 11:55:50 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C360521D56;
        Thu, 16 Jan 2020 16:55:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193749;
        bh=3NByrXuXSyoPe6ZyQRibnoFzk53sfcBbC68pP99LweI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D60dxBqXNBT50pIdNepRcA5oiDmHX9VuPiJvSRpCy/zU+wuKfF7hAyL3QiAyz/Om0
         S6kNBWzZBMAceJzWzVI+4IosvcZkXaodAjoKPLNYvYEz1kXE5llhB+seHqbrc9gicU
         95NvEY0ONh5OlNfTOaNER9N1yrlUsrwliV2tPf30=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jon Maloy <jon.maloy@ericsson.com>,
        Tuong Lien Tong <tuong.t.lien@dektech.com.au>,
        Ying Xue <ying.xue@windriver.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net
Subject: [PATCH AUTOSEL 4.19 039/671] tipc: eliminate message disordering during binding table update
Date:   Thu, 16 Jan 2020 11:44:30 -0500
Message-Id: <20200116165502.8838-39-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116165502.8838-1-sashal@kernel.org>
References: <20200116165502.8838-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jon Maloy <jon.maloy@ericsson.com>

[ Upstream commit 988f3f1603d4650409db5334355cbf7b13ef50c3 ]

We have seen the following race scenario:
1) named_distribute() builds a "bulk" message, containing a PUBLISH
   item for a certain publication. This is based on the contents of
   the binding tables's 'cluster_scope' list.
2) tipc_named_withdraw() removes the same publication from the list,
   bulds a WITHDRAW message and distributes it to all cluster nodes.
3) tipc_named_node_up(), which was calling named_distribute(), sends
   out the bulk message built under 1)
4) The WITHDRAW message arrives at the just detected node, finds
   no corresponding publication, and is dropped.
5) The PUBLISH item arrives at the same node, is added to its binding
   table, and remains there forever.

This arrival disordering was earlier taken care of by the backlog queue,
originally added for a different purpose, which was removed in the
commit referred to below, but we now need a different solution.
In this commit, we replace the rcu lock protecting the 'cluster_scope'
list with a regular RW lock which comprises even the sending of the
bulk message. This both guarantees both the list integrity and the
message sending order. We will later add a commit which cleans up
this code further.

Note that this commit needs recently added commit d3092b2efca1 ("tipc:
fix unsafe rcu locking when accessing publication list") to apply
cleanly.

Fixes: 37922ea4a310 ("tipc: permit overlapping service ranges in name table")
Reported-by: Tuong Lien Tong <tuong.t.lien@dektech.com.au>
Acked-by: Ying Xue <ying.xue@windriver.com>
Signed-off-by: Jon Maloy <jon.maloy@ericsson.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tipc/name_distr.c | 18 ++++++++++--------
 net/tipc/name_table.c |  1 +
 net/tipc/name_table.h |  1 +
 3 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/net/tipc/name_distr.c b/net/tipc/name_distr.c
index e0a3dd424d8c..836e629e8f4a 100644
--- a/net/tipc/name_distr.c
+++ b/net/tipc/name_distr.c
@@ -94,8 +94,9 @@ struct sk_buff *tipc_named_publish(struct net *net, struct publication *publ)
 		list_add_tail_rcu(&publ->binding_node, &nt->node_scope);
 		return NULL;
 	}
-	list_add_tail_rcu(&publ->binding_node, &nt->cluster_scope);
-
+	write_lock_bh(&nt->cluster_scope_lock);
+	list_add_tail(&publ->binding_node, &nt->cluster_scope);
+	write_unlock_bh(&nt->cluster_scope_lock);
 	skb = named_prepare_buf(net, PUBLICATION, ITEM_SIZE, 0);
 	if (!skb) {
 		pr_warn("Publication distribution failure\n");
@@ -112,11 +113,13 @@ struct sk_buff *tipc_named_publish(struct net *net, struct publication *publ)
  */
 struct sk_buff *tipc_named_withdraw(struct net *net, struct publication *publ)
 {
+	struct name_table *nt = tipc_name_table(net);
 	struct sk_buff *buf;
 	struct distr_item *item;
 
-	list_del_rcu(&publ->binding_node);
-
+	write_lock_bh(&nt->cluster_scope_lock);
+	list_del(&publ->binding_node);
+	write_unlock_bh(&nt->cluster_scope_lock);
 	if (publ->scope == TIPC_NODE_SCOPE)
 		return NULL;
 
@@ -147,7 +150,7 @@ static void named_distribute(struct net *net, struct sk_buff_head *list,
 			ITEM_SIZE) * ITEM_SIZE;
 	u32 msg_rem = msg_dsz;
 
-	list_for_each_entry_rcu(publ, pls, binding_node) {
+	list_for_each_entry(publ, pls, binding_node) {
 		/* Prepare next buffer: */
 		if (!skb) {
 			skb = named_prepare_buf(net, PUBLICATION, msg_rem,
@@ -189,11 +192,10 @@ void tipc_named_node_up(struct net *net, u32 dnode)
 
 	__skb_queue_head_init(&head);
 
-	rcu_read_lock();
+	read_lock_bh(&nt->cluster_scope_lock);
 	named_distribute(net, &head, dnode, &nt->cluster_scope);
-	rcu_read_unlock();
-
 	tipc_node_xmit(net, &head, dnode, 0);
+	read_unlock_bh(&nt->cluster_scope_lock);
 }
 
 /**
diff --git a/net/tipc/name_table.c b/net/tipc/name_table.c
index d72985ca1d55..89993afe0fbd 100644
--- a/net/tipc/name_table.c
+++ b/net/tipc/name_table.c
@@ -744,6 +744,7 @@ int tipc_nametbl_init(struct net *net)
 
 	INIT_LIST_HEAD(&nt->node_scope);
 	INIT_LIST_HEAD(&nt->cluster_scope);
+	rwlock_init(&nt->cluster_scope_lock);
 	tn->nametbl = nt;
 	spin_lock_init(&tn->nametbl_lock);
 	return 0;
diff --git a/net/tipc/name_table.h b/net/tipc/name_table.h
index 892bd750b85f..f79066334cc8 100644
--- a/net/tipc/name_table.h
+++ b/net/tipc/name_table.h
@@ -100,6 +100,7 @@ struct name_table {
 	struct hlist_head services[TIPC_NAMETBL_SIZE];
 	struct list_head node_scope;
 	struct list_head cluster_scope;
+	rwlock_t cluster_scope_lock;
 	u32 local_publ_count;
 };
 
-- 
2.20.1

