Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51EF4EB7C4
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 20:08:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729379AbfJaTIn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 15:08:43 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:36180 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729296AbfJaTIn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 15:08:43 -0400
Received: by mail-wr1-f67.google.com with SMTP id w18so7496640wrt.3
        for <netdev@vger.kernel.org>; Thu, 31 Oct 2019 12:08:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=aXOy2TvsbHCfCV8bHD1gghWXeFaPs6cLhsaIAPH0Ly4=;
        b=dva/iCo7mOpyv36guzgDzuznLQQ4t0c8Jcb2ZC3x86NhIY2A9iV/pg1yE9au51cMuF
         cK/34w0LZfWSq13Va2QchTUU85n6nJGdHihd80WZtGqXq4vfTRxUNW6lhX5bqa3AlSHd
         iAhBR1y1Y7syHoUrfsXRPtaIUeRKR1tlXCYAnkDxgNa1hrwRpvtsjqGH6AC/NBk7JBLx
         vXprUlg4LH3Aduk3eCtI1V9gwFqWUKK+q8JZE8BLPfvOT8Qzg+CiTA6A9Z5pLAMzqDvC
         CSEpwcvbxgIJoDk+6GTb4YakqQXUxkSvrqQxQMGWB/Pn853N+ZnDwWRAy13gZPtgKzDG
         blGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=aXOy2TvsbHCfCV8bHD1gghWXeFaPs6cLhsaIAPH0Ly4=;
        b=JFUUlJ9NPuOje5IxoOxuxaTPEr71NQnI46SRGVJUv1dKIi0O3PV1FlNmGOdC2UcQes
         cnr8brCmskAR3u57qqUWpCHN/Sa9nC6kbEWqAHt/H83LrO7v7gkQW1Vr/MHXcdlHC9zS
         C0s3Wt5H4QlaQQVn68bj4R9HHt5BTDSFu/GJZS8TPXOY2wNdplTdS1LsTulaMYeXaezu
         yuHr75nVgvcrn6427fALJQiy9wnvLWi+XhCFsIqX7dmG4JxW7q/T7kNAB2qhJ6QTCbHo
         kyINOoAPmTGqsyDc4tIGLc9fkbO1DWNrFWxWoaWHfnlitXz3QNkU9ImM5/BwcLQ3JvFM
         qr4w==
X-Gm-Message-State: APjAAAX2kN+l8qexBpsC6PgqMWWV1004pE79fHe1dxs9KIk4PaUIkBwM
        wmmPSFfCuKffWK8P/GQJhJBWaw==
X-Google-Smtp-Source: APXvYqyNr/9kN8Srxau2m+Gm0+PrbNSgJ4v/2SMEONIwj2qDeoc5XbjeA8NvNFxWLhcaMKkWfmCXtw==
X-Received: by 2002:a5d:4f8b:: with SMTP id d11mr7404039wru.25.1572548918929;
        Thu, 31 Oct 2019 12:08:38 -0700 (PDT)
Received: from jhurley-Precision-Tower-3420.netronome.com ([80.76.204.157])
        by smtp.gmail.com with ESMTPSA id w81sm3701834wmg.5.2019.10.31.12.08.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 31 Oct 2019 12:08:38 -0700 (PDT)
From:   John Hurley <john.hurley@netronome.com>
To:     vladbu@mellanox.com
Cc:     jiri@mellanox.com, netdev@vger.kernel.org,
        simon.horman@netronome.com, jakub.kicinski@netronome.com,
        louis.peens@netronome.com, oss-drivers@netronome.com,
        John Hurley <john.hurley@netronome.com>
Subject: [RFC net-next v2 1/1] net: sched: prevent duplicate flower rules from tcf_proto destroy race
Date:   Thu, 31 Oct 2019 19:08:24 +0000
Message-Id: <1572548904-3975-1-git-send-email-john.hurley@netronome.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a new filter is added to cls_api, the function
tcf_chain_tp_insert_unique() looks up the protocol/priority/chain to
determine if the tcf_proto is duplicated in the chain's hashtable. It then
creates a new entry or continues with an existing one. In cls_flower, this
allows the function fl_ht_insert_unque to determine if a filter is a
duplicate and reject appropriately, meaning that the duplicate will not be
passed to drivers via the offload hooks. However, when a tcf_proto is
destroyed it is removed from its chain before a hardware remove hook is
hit. This can lead to a race whereby the driver has not received the
remove message but duplicate flows can be accepted. This, in turn, can
lead to the offload driver receiving incorrect duplicate flows and out of
order add/delete messages.

Prevent duplicates by utilising an approach suggested by Vlad Buslov. A
hash table per block stores each unique chain/protocol/prio being
destroyed. This entry is only removed when the full destroy (and hardware
offload) has completed. If a new flow is being added with the same
identiers as a tc_proto being detroyed, then the add request is replayed
until the destroy is complete.

v1->v2:
- put tcf_proto into block->proto_destroy_ht rather than creating new key
  (Vlad Buslov)
- add error log for cases when hash entry fails. Previously it failed
  silently with no indication. (Vlad Buslov)

Fixes: 8b64678e0af8 ("net: sched: refactor tp insert/delete for concurrent execution")
Signed-off-by: John Hurley <john.hurley@netronome.com>
Reviewed-by: Simon Horman <simon.horman@netronome.com>
Reported-by: Louis Peens <louis.peens@netronome.com>
---
 include/net/sch_generic.h |   4 ++
 net/sched/cls_api.c       | 123 ++++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 123 insertions(+), 4 deletions(-)

diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index 637548d..56c9b2c 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -362,6 +362,7 @@ struct tcf_proto {
 	bool			deleting;
 	refcount_t		refcnt;
 	struct rcu_head		rcu;
+	struct rhash_head	destroy_ht_node;
 };
 
 struct qdisc_skb_cb {
@@ -414,6 +415,9 @@ struct tcf_block {
 		struct list_head filter_chain_list;
 	} chain0;
 	struct rcu_head rcu;
+	struct rhashtable proto_destroy_ht;
+	struct rhashtable_params proto_destroy_ht_params;
+	struct mutex proto_destroy_lock; /* Lock for proto_destroy hashtable. */
 };
 
 #ifdef CONFIG_PROVE_LOCKING
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 8717c0b..4970fad 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -47,6 +47,93 @@ static LIST_HEAD(tcf_proto_base);
 /* Protects list of registered TC modules. It is pure SMP lock. */
 static DEFINE_RWLOCK(cls_mod_lock);
 
+struct destroy_ht_key {
+	u32 chain_index;
+	u32 prio;
+	__be16 protocol;
+};
+
+static inline void destroy_fill_ht_key(struct destroy_ht_key *key,
+				       const struct tcf_proto *tp)
+{
+	key->chain_index = tp->chain->index;
+	key->prio = tp->prio;
+	key->protocol = tp->protocol;
+}
+
+static inline int destroy_obj_cmpfn(struct rhashtable_compare_arg *arg,
+				    const void *obj)
+{
+	const struct destroy_ht_key *key = arg->key;
+	const struct tcf_proto *tp = obj;
+
+	return key->chain_index != tp->chain->index ||
+	       key->prio != tp->prio ||
+	       key->protocol != tp->protocol;
+}
+
+static inline u32 detroy_obj_hashfn(const void *data, u32 len, u32 seed)
+{
+	const struct tcf_proto *tp = data;
+	struct destroy_ht_key key;
+
+	destroy_fill_ht_key(&key, tp);
+	return jhash(&key, offsetofend(struct destroy_ht_key, protocol), seed);
+}
+
+static const struct rhashtable_params destroy_ht_params = {
+	.head_offset = offsetof(struct tcf_proto, destroy_ht_node),
+	.key_len = offsetofend(struct destroy_ht_key, protocol),
+	.obj_hashfn = detroy_obj_hashfn,
+	.obj_cmpfn = destroy_obj_cmpfn,
+	.automatic_shrinking = true,
+};
+
+static void tcf_proto_signal_destroying(struct tcf_chain *chain,
+					struct tcf_proto *tp)
+{
+	struct tcf_block *block = chain->block;
+	struct destroy_ht_key key;
+	struct tcf_proto *ret;
+
+	destroy_fill_ht_key(&key, tp);
+	mutex_lock(&block->proto_destroy_lock);
+	ret = rhashtable_lookup_get_insert_key(&block->proto_destroy_ht, &key,
+					       &tp->destroy_ht_node,
+					       block->proto_destroy_ht_params);
+	mutex_unlock(&block->proto_destroy_lock);
+
+	if (IS_ERR(ret))
+		net_err_ratelimited("mem failure on destroy hash insert - chain: %u, prio: %u, proto: %u",
+				    key.chain_index, key.prio, key.protocol);
+}
+
+static struct tcf_proto *
+tcf_proto_lookup_destroying(struct tcf_chain *chain, struct tcf_proto *tp)
+{
+	struct tcf_block *block = chain->block;
+	struct destroy_ht_key key;
+
+	destroy_fill_ht_key(&key, tp);
+	return rhashtable_lookup_fast(&block->proto_destroy_ht, &key,
+				      block->proto_destroy_ht_params);
+}
+
+static void
+tcf_proto_signal_destroyed(struct tcf_chain *chain, struct tcf_proto *tp)
+{
+	struct tcf_block *block = chain->block;
+	struct tcf_proto *entry;
+
+	mutex_lock(&block->proto_destroy_lock);
+	entry = tcf_proto_lookup_destroying(chain, tp);
+	if (entry)
+		rhashtable_remove_fast(&block->proto_destroy_ht,
+				       &entry->destroy_ht_node,
+				       block->proto_destroy_ht_params);
+	mutex_unlock(&block->proto_destroy_lock);
+}
+
 /* Find classifier type by string name */
 
 static const struct tcf_proto_ops *__tcf_proto_lookup_ops(const char *kind)
@@ -234,9 +321,11 @@ static void tcf_proto_get(struct tcf_proto *tp)
 static void tcf_chain_put(struct tcf_chain *chain);
 
 static void tcf_proto_destroy(struct tcf_proto *tp, bool rtnl_held,
-			      struct netlink_ext_ack *extack)
+			      bool sig_destroy, struct netlink_ext_ack *extack)
 {
 	tp->ops->destroy(tp, rtnl_held, extack);
+	if (sig_destroy)
+		tcf_proto_signal_destroyed(tp->chain, tp);
 	tcf_chain_put(tp->chain);
 	module_put(tp->ops->owner);
 	kfree_rcu(tp, rcu);
@@ -246,7 +335,7 @@ static void tcf_proto_put(struct tcf_proto *tp, bool rtnl_held,
 			  struct netlink_ext_ack *extack)
 {
 	if (refcount_dec_and_test(&tp->refcnt))
-		tcf_proto_destroy(tp, rtnl_held, extack);
+		tcf_proto_destroy(tp, rtnl_held, true, extack);
 }
 
 static int walker_check_empty(struct tcf_proto *tp, void *fh,
@@ -370,6 +459,8 @@ static bool tcf_chain_detach(struct tcf_chain *chain)
 static void tcf_block_destroy(struct tcf_block *block)
 {
 	mutex_destroy(&block->lock);
+	rhashtable_destroy(&block->proto_destroy_ht);
+	mutex_destroy(&block->proto_destroy_lock);
 	kfree_rcu(block, rcu);
 }
 
@@ -545,6 +636,12 @@ static void tcf_chain_flush(struct tcf_chain *chain, bool rtnl_held)
 
 	mutex_lock(&chain->filter_chain_lock);
 	tp = tcf_chain_dereference(chain->filter_chain, chain);
+	while (tp) {
+		tp_next = rcu_dereference_protected(tp->next, 1);
+		tcf_proto_signal_destroying(chain, tp);
+		tp = tp_next;
+	}
+	tp = tcf_chain_dereference(chain->filter_chain, chain);
 	RCU_INIT_POINTER(chain->filter_chain, NULL);
 	tcf_chain0_head_change(chain, NULL);
 	chain->flushing = true;
@@ -857,6 +954,16 @@ static struct tcf_block *tcf_block_create(struct net *net, struct Qdisc *q,
 	/* Don't store q pointer for blocks which are shared */
 	if (!tcf_block_shared(block))
 		block->q = q;
+
+	block->proto_destroy_ht_params = destroy_ht_params;
+	if (rhashtable_init(&block->proto_destroy_ht,
+			    &block->proto_destroy_ht_params)) {
+		NL_SET_ERR_MSG(extack, "Failed to initialise blocks proto destroy hashtable");
+		kfree(block);
+		return ERR_PTR(-ENOMEM);
+	}
+	mutex_init(&block->proto_destroy_lock);
+
 	return block;
 }
 
@@ -1621,6 +1728,12 @@ static struct tcf_proto *tcf_chain_tp_insert_unique(struct tcf_chain *chain,
 
 	mutex_lock(&chain->filter_chain_lock);
 
+	if (tcf_proto_lookup_destroying(chain, tp_new)) {
+		mutex_unlock(&chain->filter_chain_lock);
+		tcf_proto_destroy(tp_new, rtnl_held, false, NULL);
+		return ERR_PTR(-EAGAIN);
+	}
+
 	tp = tcf_chain_tp_find(chain, &chain_info,
 			       protocol, prio, false);
 	if (!tp)
@@ -1628,10 +1741,10 @@ static struct tcf_proto *tcf_chain_tp_insert_unique(struct tcf_chain *chain,
 	mutex_unlock(&chain->filter_chain_lock);
 
 	if (tp) {
-		tcf_proto_destroy(tp_new, rtnl_held, NULL);
+		tcf_proto_destroy(tp_new, rtnl_held, false, NULL);
 		tp_new = tp;
 	} else if (err) {
-		tcf_proto_destroy(tp_new, rtnl_held, NULL);
+		tcf_proto_destroy(tp_new, rtnl_held, false, NULL);
 		tp_new = ERR_PTR(err);
 	}
 
@@ -1669,6 +1782,7 @@ static void tcf_chain_tp_delete_empty(struct tcf_chain *chain,
 		return;
 	}
 
+	tcf_proto_signal_destroying(chain, tp);
 	next = tcf_chain_dereference(chain_info.next, chain);
 	if (tp == chain->filter_chain)
 		tcf_chain0_head_change(chain, next);
@@ -2188,6 +2302,7 @@ static int tc_del_tfilter(struct sk_buff *skb, struct nlmsghdr *n,
 		err = -EINVAL;
 		goto errout_locked;
 	} else if (t->tcm_handle == 0) {
+		tcf_proto_signal_destroying(chain, tp);
 		tcf_chain_tp_remove(chain, &chain_info, tp);
 		mutex_unlock(&chain->filter_chain_lock);
 
-- 
2.7.4

