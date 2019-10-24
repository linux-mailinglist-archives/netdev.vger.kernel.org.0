Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1922E2FB0
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 13:01:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392201AbfJXLB4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 07:01:56 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:43716 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730032AbfJXLBz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 07:01:55 -0400
Received: by mail-wr1-f66.google.com with SMTP id c2so20328978wrr.10
        for <netdev@vger.kernel.org>; Thu, 24 Oct 2019 04:01:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=8N5nevwEJM5d4IQj5te+zX+w8iVgZYqc5b+7HP41GH8=;
        b=c0IFnEEJmzfeeBbpxn8KqFPtUF3LS7ujf8Px/Gf7ntdImYJsYJmf+eC8qbBWfwaBo8
         Cl+9MIVKH03C5d+/As8t0TjnQ/qptLFuIMGJQU8VySA3Gmra/nfyiBEWSDbVmSMdDNSH
         FiOUwgWDFize0tFUQASgerMJjvPUoGG1dHb60FKGBi1D6hlf1tHacN4T64ShZ/yI5z8R
         WtixLR0kvhg2Grwm+GR+Y5fqtEKdTtnwKH0YKpuKkJro0wRW6tIpwcNQX7WrLiP44vLG
         3HVptu9FB+OfQU0xUNAx55R78fuFNMM0+4LMsa6I+Mdbgr9+kbx5JqMCk2jg1rt4vE9Q
         u2hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=8N5nevwEJM5d4IQj5te+zX+w8iVgZYqc5b+7HP41GH8=;
        b=HgmQZqcfqSayEj7OHLYWpzLYOIWOb17N6duZk4X94eiu9IAQrMA8UbafXWWru2ZOoP
         V39XFhJaCFQuwr1uJBLQRfRgexzjI4zNC4Zhr+61V6n9erDcLM0jgRvH4vXb3QAX08ey
         PxIbwVi8O19jiAPky5yL+8+WFzz4ejRwfpN24NvhKJ0GD1SkmvAnBgej/raGNrvy0ZKx
         krmWMZSmOcmmx/zvDZc+f+lNguX00X3CrcWvvnLnv2YXl91y54npnhENc9lF6GVTQBRr
         uIQkjavf5v3iZWtz1vTaYZCQGluQn3UQkWLyBDRYAsHNYMEcD2mmYy8djGEzwEyVHRU+
         0anQ==
X-Gm-Message-State: APjAAAUpp7Mx09u0LOv30nylbXvKauf00tR67DqoD20+uERqBGtfvmy1
        shSL3Lpi1YEZXltNztg2/YPJfw==
X-Google-Smtp-Source: APXvYqwRiJP0az4dZQO0wgDxEVhlnM40iNHxqGz7OdHr1mSYKA5cMoP76dJcA4cNTlO2kTn7gm6iUw==
X-Received: by 2002:a05:6000:1051:: with SMTP id c17mr3202058wrx.124.1571914911394;
        Thu, 24 Oct 2019 04:01:51 -0700 (PDT)
Received: from jhurley-Precision-Tower-3420.netronome.com ([80.76.204.157])
        by smtp.gmail.com with ESMTPSA id v9sm10450372wro.51.2019.10.24.04.01.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 24 Oct 2019 04:01:50 -0700 (PDT)
From:   John Hurley <john.hurley@netronome.com>
To:     vladbu@mellanox.com
Cc:     jiri@mellanox.com, netdev@vger.kernel.org,
        simon.horman@netronome.com, jakub.kicinski@netronome.com,
        louis.peens@netronome.com, oss-drivers@netronome.com,
        John Hurley <john.hurley@netronome.com>
Subject: [RFC net-next 1/1] net: sched: prevent duplicate flower rules from tcf_proto destroy race
Date:   Thu, 24 Oct 2019 12:01:27 +0100
Message-Id: <1571914887-1364-1-git-send-email-john.hurley@netronome.com>
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

Fixes: 8b64678e0af8 ("net: sched: refactor tp insert/delete for concurrent execution")
Signed-off-by: John Hurley <john.hurley@netronome.com>
Reviewed-by: Simon Horman <simon.horman@netronome.com>
Reported-by: Louis Peens <louis.peens@netronome.com>
---
 include/net/sch_generic.h |   3 ++
 net/sched/cls_api.c       | 108 ++++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 107 insertions(+), 4 deletions(-)

diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index 637548d..363d2de 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -414,6 +414,9 @@ struct tcf_block {
 		struct list_head filter_chain_list;
 	} chain0;
 	struct rcu_head rcu;
+	struct rhashtable proto_destroy_ht;
+	struct rhashtable_params proto_destroy_ht_params;
+	struct mutex proto_destroy_lock; /* Lock for proto_destroy hashtable. */
 };
 
 #ifdef CONFIG_PROVE_LOCKING
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 8717c0b..7f7095a 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -47,6 +47,77 @@ static LIST_HEAD(tcf_proto_base);
 /* Protects list of registered TC modules. It is pure SMP lock. */
 static DEFINE_RWLOCK(cls_mod_lock);
 
+struct tcf_destroy_proto {
+	struct destroy_key {
+		u32 chain_index;
+		u32 prio;
+		__be16 protocol;
+	} key;
+	struct rhash_head ht_node;
+};
+
+static const struct rhashtable_params destroy_ht_params = {
+	.key_offset = offsetof(struct tcf_destroy_proto, key),
+	.key_len = offsetofend(struct destroy_key, protocol),
+	.head_offset = offsetof(struct tcf_destroy_proto, ht_node),
+	.automatic_shrinking = true,
+};
+
+static void
+tcf_proto_signal_destroying(struct tcf_chain *chain, struct tcf_proto *tp)
+{
+	struct tcf_block *block = chain->block;
+	struct tcf_destroy_proto *entry;
+
+	entry = kzalloc(sizeof(*entry), GFP_KERNEL);
+	if (!entry)
+		return;
+
+	entry->key.chain_index = chain->index;
+	entry->key.prio = tp->prio;
+	entry->key.protocol = tp->protocol;
+
+	mutex_lock(&block->proto_destroy_lock);
+	/* If key already exists or lookup errors out then free new entry. */
+	if (rhashtable_lookup_get_insert_fast(&block->proto_destroy_ht,
+					      &entry->ht_node,
+					      block->proto_destroy_ht_params))
+		kfree(entry);
+	mutex_unlock(&block->proto_destroy_lock);
+}
+
+static struct tcf_destroy_proto *
+tcf_proto_lookup_destroying(struct tcf_block *block, u32 chain_idx, u32 prio,
+			    __be16 proto)
+{
+	struct destroy_key key;
+
+	key.chain_index = chain_idx;
+	key.prio = prio;
+	key.protocol = proto;
+
+	return rhashtable_lookup_fast(&block->proto_destroy_ht, &key,
+				      block->proto_destroy_ht_params);
+}
+
+static void
+tcf_proto_signal_destroyed(struct tcf_chain *chain, struct tcf_proto *tp)
+{
+	struct tcf_block *block = chain->block;
+	struct tcf_destroy_proto *entry;
+
+	mutex_lock(&block->proto_destroy_lock);
+	entry = tcf_proto_lookup_destroying(block, chain->index, tp->prio,
+					    tp->protocol);
+	if (entry) {
+		rhashtable_remove_fast(&block->proto_destroy_ht,
+				       &entry->ht_node,
+				       block->proto_destroy_ht_params);
+		kfree(entry);
+	}
+	mutex_unlock(&block->proto_destroy_lock);
+}
+
 /* Find classifier type by string name */
 
 static const struct tcf_proto_ops *__tcf_proto_lookup_ops(const char *kind)
@@ -234,9 +305,11 @@ static void tcf_proto_get(struct tcf_proto *tp)
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
@@ -246,7 +319,7 @@ static void tcf_proto_put(struct tcf_proto *tp, bool rtnl_held,
 			  struct netlink_ext_ack *extack)
 {
 	if (refcount_dec_and_test(&tp->refcnt))
-		tcf_proto_destroy(tp, rtnl_held, extack);
+		tcf_proto_destroy(tp, rtnl_held, true, extack);
 }
 
 static int walker_check_empty(struct tcf_proto *tp, void *fh,
@@ -370,6 +443,8 @@ static bool tcf_chain_detach(struct tcf_chain *chain)
 static void tcf_block_destroy(struct tcf_block *block)
 {
 	mutex_destroy(&block->lock);
+	rhashtable_destroy(&block->proto_destroy_ht);
+	mutex_destroy(&block->proto_destroy_lock);
 	kfree_rcu(block, rcu);
 }
 
@@ -545,6 +620,12 @@ static void tcf_chain_flush(struct tcf_chain *chain, bool rtnl_held)
 
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
@@ -857,6 +938,16 @@ static struct tcf_block *tcf_block_create(struct net *net, struct Qdisc *q,
 	/* Don't store q pointer for blocks which are shared */
 	if (!tcf_block_shared(block))
 		block->q = q;
+
+	block->proto_destroy_ht_params = destroy_ht_params;
+	if (rhashtable_init(&block->proto_destroy_ht,
+			    &block->proto_destroy_ht_params)) {
+		NL_SET_ERR_MSG(extack, "Failed to initialise block proto destroy hashtable");
+		kfree(block);
+		return ERR_PTR(-ENOMEM);
+	}
+	mutex_init(&block->proto_destroy_lock);
+
 	return block;
 }
 
@@ -1621,6 +1712,13 @@ static struct tcf_proto *tcf_chain_tp_insert_unique(struct tcf_chain *chain,
 
 	mutex_lock(&chain->filter_chain_lock);
 
+	if (tcf_proto_lookup_destroying(chain->block, chain->index, prio,
+					protocol)) {
+		mutex_unlock(&chain->filter_chain_lock);
+		tcf_proto_destroy(tp_new, rtnl_held, false, NULL);
+		return ERR_PTR(-EAGAIN);
+	}
+
 	tp = tcf_chain_tp_find(chain, &chain_info,
 			       protocol, prio, false);
 	if (!tp)
@@ -1628,10 +1726,10 @@ static struct tcf_proto *tcf_chain_tp_insert_unique(struct tcf_chain *chain,
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
 
@@ -1669,6 +1767,7 @@ static void tcf_chain_tp_delete_empty(struct tcf_chain *chain,
 		return;
 	}
 
+	tcf_proto_signal_destroying(chain, tp);
 	next = tcf_chain_dereference(chain_info.next, chain);
 	if (tp == chain->filter_chain)
 		tcf_chain0_head_change(chain, next);
@@ -2188,6 +2287,7 @@ static int tc_del_tfilter(struct sk_buff *skb, struct nlmsghdr *n,
 		err = -EINVAL;
 		goto errout_locked;
 	} else if (t->tcm_handle == 0) {
+		tcf_proto_signal_destroying(chain, tp);
 		tcf_chain_tp_remove(chain, &chain_info, tp);
 		mutex_unlock(&chain->filter_chain_lock);
 
-- 
2.7.4

