Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06A544A8801
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 16:49:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351966AbiBCPst (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 10:48:49 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:49096 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1351953AbiBCPso (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 10:48:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643903324;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ffBtinprILClSos7PKEgxhbKzcDIt4pUY7Pu1Nz+eII=;
        b=KX2kbrgQ+JtfXMOqQ2exrLPYS06GmVzXH26l8l+CJ2NHj7JIIChSN3+qvaVnleYMa2LrGv
        RNDLGvZLAAcMIdM5L6pD2J5TbsMrBadF8NFa08sBnL9zLEF8n4IKEqHMeFLiaJjdmCt9AK
        qdK+UmB1ilahT7l0H75Q2In4ejmtgG8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-481--0rrdKbMMpypBF_4hQFqrw-1; Thu, 03 Feb 2022 10:48:41 -0500
X-MC-Unique: -0rrdKbMMpypBF_4hQFqrw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0A190101F002;
        Thu,  3 Feb 2022 15:48:40 +0000 (UTC)
Received: from gerbillo.redhat.com (unknown [10.39.193.191])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9775910841E4;
        Thu,  3 Feb 2022 15:48:38 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Eric Dumazet <edumazet@google.com>
Subject: [PATCH net-next 3/3] net: gro: register gso and gro offload on separate lists
Date:   Thu,  3 Feb 2022 16:48:23 +0100
Message-Id: <550566fedb425275bb9d351a565a0220f67d498b.1643902527.git.pabeni@redhat.com>
In-Reply-To: <cover.1643902526.git.pabeni@redhat.com>
References: <cover.1643902526.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

So that we know each element in gro_list has valid gro callbacks
(and the same for gso). This allows dropping a bunch of conditional
in fastpath.

Before:
objdump -t net/core/gro.o | grep " F .text"
0000000000000bb0 l     F .text  000000000000033c dev_gro_receive

After:
0000000000000bb0 l     F .text  0000000000000325 dev_gro_receive

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 include/linux/netdevice.h |  3 +-
 net/core/gro.c            | 90 +++++++++++++++++++++++----------------
 2 files changed, 56 insertions(+), 37 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 3213c7227b59..406cb457d788 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2564,7 +2564,8 @@ struct packet_offload {
 	__be16			 type;	/* This is really htons(ether_type). */
 	u16			 priority;
 	struct offload_callbacks callbacks;
-	struct list_head	 list;
+	struct list_head	 gro_list;
+	struct list_head	 gso_list;
 };
 
 /* often modified stats are per-CPU, other are shared (netdev->stats) */
diff --git a/net/core/gro.c b/net/core/gro.c
index fc56be9408c7..bd619d494fdd 100644
--- a/net/core/gro.c
+++ b/net/core/gro.c
@@ -10,10 +10,21 @@
 #define GRO_MAX_HEAD (MAX_HEADER + 128)
 
 static DEFINE_SPINLOCK(offload_lock);
-static struct list_head offload_base __read_mostly = LIST_HEAD_INIT(offload_base);
+static struct list_head gro_offload_base __read_mostly = LIST_HEAD_INIT(gro_offload_base);
+static struct list_head gso_offload_base __read_mostly = LIST_HEAD_INIT(gso_offload_base);
 /* Maximum number of GRO_NORMAL skbs to batch up for list-RX */
 int gro_normal_batch __read_mostly = 8;
 
+#define offload_list_insert(head, poff, list)		\
+({							\
+	struct packet_offload *elem;			\
+	list_for_each_entry(elem, head, list) {		\
+		if ((poff)->priority < elem->priority)	\
+			break;				\
+	}						\
+	list_add_rcu(&(poff)->list, elem->list.prev);	\
+})
+
 /**
  *	dev_add_offload - register offload handlers
  *	@po: protocol offload declaration
@@ -28,18 +39,33 @@ int gro_normal_batch __read_mostly = 8;
  */
 void dev_add_offload(struct packet_offload *po)
 {
-	struct packet_offload *elem;
-
 	spin_lock(&offload_lock);
-	list_for_each_entry(elem, &offload_base, list) {
-		if (po->priority < elem->priority)
-			break;
-	}
-	list_add_rcu(&po->list, elem->list.prev);
+	if (po->callbacks.gro_receive && po->callbacks.gro_complete)
+		offload_list_insert(&gro_offload_base, po, gro_list);
+	else if (po->callbacks.gro_complete)
+		pr_warn("missing gro_receive callback");
+	else if (po->callbacks.gro_receive)
+		pr_warn("missing gro_complete callback");
+
+	if (po->callbacks.gso_segment)
+		offload_list_insert(&gso_offload_base, po, gso_list);
 	spin_unlock(&offload_lock);
 }
 EXPORT_SYMBOL(dev_add_offload);
 
+#define offload_list_remove(type, head, poff, list)	\
+({							\
+	struct packet_offload *elem;			\
+	list_for_each_entry(elem, head, list) {		\
+		if ((poff) == elem) {			\
+			list_del_rcu(&(poff)->list);	\
+			break;				\
+		}					\
+	}						\
+	if (elem != (poff))				\
+		pr_warn("dev_remove_offload: %p not found in %s list\n", (poff), type); \
+})
+
 /**
  *	__dev_remove_offload	 - remove offload handler
  *	@po: packet offload declaration
@@ -55,20 +81,12 @@ EXPORT_SYMBOL(dev_add_offload);
  */
 static void __dev_remove_offload(struct packet_offload *po)
 {
-	struct list_head *head = &offload_base;
-	struct packet_offload *po1;
-
 	spin_lock(&offload_lock);
+	if (po->callbacks.gro_receive)
+		offload_list_remove("gro", &gro_offload_base, po, gso_list);
 
-	list_for_each_entry(po1, head, list) {
-		if (po == po1) {
-			list_del_rcu(&po->list);
-			goto out;
-		}
-	}
-
-	pr_warn("dev_remove_offload: %p not found\n", po);
-out:
+	if (po->callbacks.gso_segment)
+		offload_list_remove("gso", &gso_offload_base, po, gro_list);
 	spin_unlock(&offload_lock);
 }
 
@@ -111,8 +129,8 @@ struct sk_buff *skb_mac_gso_segment(struct sk_buff *skb,
 	__skb_pull(skb, vlan_depth);
 
 	rcu_read_lock();
-	list_for_each_entry_rcu(ptype, &offload_base, list) {
-		if (ptype->type == type && ptype->callbacks.gso_segment) {
+	list_for_each_entry_rcu(ptype, &gso_offload_base, gso_list) {
+		if (ptype->type == type) {
 			segs = ptype->callbacks.gso_segment(skb, features);
 			break;
 		}
@@ -250,7 +268,7 @@ static void napi_gro_complete(struct napi_struct *napi, struct sk_buff *skb)
 {
 	struct packet_offload *ptype;
 	__be16 type = skb->protocol;
-	struct list_head *head = &offload_base;
+	struct list_head *head = &gro_offload_base;
 	int err = -ENOENT;
 
 	BUILD_BUG_ON(sizeof(struct napi_gro_cb) > sizeof(skb->cb));
@@ -261,8 +279,8 @@ static void napi_gro_complete(struct napi_struct *napi, struct sk_buff *skb)
 	}
 
 	rcu_read_lock();
-	list_for_each_entry_rcu(ptype, head, list) {
-		if (ptype->type != type || !ptype->callbacks.gro_complete)
+	list_for_each_entry_rcu(ptype, head, gro_list) {
+		if (ptype->type != type)
 			continue;
 
 		err = INDIRECT_CALL_INET(ptype->callbacks.gro_complete,
@@ -273,7 +291,7 @@ static void napi_gro_complete(struct napi_struct *napi, struct sk_buff *skb)
 	rcu_read_unlock();
 
 	if (err) {
-		WARN_ON(&ptype->list == head);
+		WARN_ON(&ptype->gro_list == head);
 		kfree_skb(skb);
 		return;
 	}
@@ -442,7 +460,7 @@ static enum gro_result dev_gro_receive(struct napi_struct *napi, struct sk_buff
 {
 	u32 bucket = skb_get_hash_raw(skb) & (GRO_HASH_BUCKETS - 1);
 	struct gro_list *gro_list = &napi->gro_hash[bucket];
-	struct list_head *head = &offload_base;
+	struct list_head *head = &gro_offload_base;
 	struct packet_offload *ptype;
 	__be16 type = skb->protocol;
 	struct sk_buff *pp = NULL;
@@ -456,8 +474,8 @@ static enum gro_result dev_gro_receive(struct napi_struct *napi, struct sk_buff
 	gro_list_prepare(&gro_list->list, skb);
 
 	rcu_read_lock();
-	list_for_each_entry_rcu(ptype, head, list) {
-		if (ptype->type != type || !ptype->callbacks.gro_receive)
+	list_for_each_entry_rcu(ptype, head, gro_list) {
+		if (ptype->type != type)
 			continue;
 
 		skb_set_network_header(skb, skb_gro_offset(skb));
@@ -487,7 +505,7 @@ static enum gro_result dev_gro_receive(struct napi_struct *napi, struct sk_buff
 	}
 	rcu_read_unlock();
 
-	if (&ptype->list == head)
+	if (&ptype->gro_list == head)
 		goto normal;
 
 	if (PTR_ERR(pp) == -EINPROGRESS) {
@@ -543,11 +561,11 @@ static enum gro_result dev_gro_receive(struct napi_struct *napi, struct sk_buff
 
 struct packet_offload *gro_find_receive_by_type(__be16 type)
 {
-	struct list_head *offload_head = &offload_base;
+	struct list_head *offload_head = &gro_offload_base;
 	struct packet_offload *ptype;
 
-	list_for_each_entry_rcu(ptype, offload_head, list) {
-		if (ptype->type != type || !ptype->callbacks.gro_receive)
+	list_for_each_entry_rcu(ptype, offload_head, gro_list) {
+		if (ptype->type != type)
 			continue;
 		return ptype;
 	}
@@ -557,11 +575,11 @@ EXPORT_SYMBOL(gro_find_receive_by_type);
 
 struct packet_offload *gro_find_complete_by_type(__be16 type)
 {
-	struct list_head *offload_head = &offload_base;
+	struct list_head *offload_head = &gro_offload_base;
 	struct packet_offload *ptype;
 
-	list_for_each_entry_rcu(ptype, offload_head, list) {
-		if (ptype->type != type || !ptype->callbacks.gro_complete)
+	list_for_each_entry_rcu(ptype, offload_head, gro_list) {
+		if (ptype->type != type)
 			continue;
 		return ptype;
 	}
-- 
2.34.1

