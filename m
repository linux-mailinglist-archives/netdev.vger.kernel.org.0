Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB498ECF1B
	for <lists+netdev@lfdr.de>; Sat,  2 Nov 2019 15:18:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726907AbfKBOSG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Nov 2019 10:18:06 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:50475 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726406AbfKBOSG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Nov 2019 10:18:06 -0400
Received: by mail-wm1-f68.google.com with SMTP id 11so12232570wmk.0
        for <netdev@vger.kernel.org>; Sat, 02 Nov 2019 07:18:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=zqKBaDl1EGEE1jW1tGspQn8HkQ5igeW2JC90PO14wCY=;
        b=Lc+5uZdn26vRFqnN9p1/EYl4WZVBVOtcg3jDxDRpaqiTz4B+7j5Zv0Wac+KdW/Jg8E
         GrJFg9oObaFDqu8ZEU4EicXw702Vu1+UcoJ6EXySk6FXD5guaYO1IvARlfcs72ppfgMs
         BxJzLZW1lIJ/k7+RUiaR7g2o2Qa2JA1fsXB74AeMQKApH5CmKsDjS1Cz/KLivuU/CJ6M
         luk1ZLKhXK5/RRNr3+gznakKF2twDThszadM7HX/ygmId4Dgv8jWoMUnbx+FmfoMQhAv
         oLDWjNElBuf/E5tkObrNXQVmih/ZBc22bWMlDAA8jc06gCPSL8OaJWdAV9vVxvVGuFLp
         1ryQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=zqKBaDl1EGEE1jW1tGspQn8HkQ5igeW2JC90PO14wCY=;
        b=Xe+Ls2OleejxqlYHxv7ZnsuRjbax24haDqXPmJAa3DJFSEiIj+YzWS27jGnj7ICwBm
         Ts8ntVQj3Wua6k9hLPZD5mkZPyza2EEQTDpiUY8fgZyhadBPwOinhtmeCbGEjvDdEn84
         vKHZWRlUCcCynf9y1wrtczo3UPSMZWl1yP13c5EQywi5bZ8JpeI7yKt1uHnmdwxETlz6
         mDunrbhq7oiyeHjQX7nI3xuc4r+BqxG2adVYtg5CabyIwB2uKsPclmp1otqzzS8kJ3WZ
         0ANuvbULWBGMflcIT/4YSdu74OFGsdwb/GGFN7D6Zxg8ALM6YDWpInB6itLBcyRfwgVK
         VbEg==
X-Gm-Message-State: APjAAAVdq9b9ZklmBXhKaQRQClnGgkREzNRl3sudCoN15/PWmG6hUc3N
        IOq0MTYDAw/qD8bhslF5mz4kiLcf36ahBeu/HStbuqzD4fI8Fzvkbwjmht30cm6sZ0SKngT0ycT
        y1gdR+t72qCyXWFQopyTUibr/Vbr/+UnWEZwMLekaJhLkQByt6aKvwnL/ULeJzUq52V4A4Doa9Q
        ==
X-Google-Smtp-Source: APXvYqw5A8Q2evtjl/GHc7UFTf+iNy1CiwqEQ1WY0o6773yLvDOsKNfRrB2SocfMZcoDeOFtl9IPYA==
X-Received: by 2002:a1c:2d4b:: with SMTP id t72mr16277497wmt.112.1572704283484;
        Sat, 02 Nov 2019 07:18:03 -0700 (PDT)
Received: from jhurley-Precision-Tower-3420.netronome.com ([80.76.204.157])
        by smtp.gmail.com with ESMTPSA id 16sm12998062wmf.0.2019.11.02.07.18.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sat, 02 Nov 2019 07:18:02 -0700 (PDT)
From:   John Hurley <john.hurley@netronome.com>
To:     netdev@vger.kernel.org
Cc:     vladbu@mellanox.com, jiri@mellanox.com, simon.horman@netronome.com,
        jakub.kicinski@netronome.com, louis.peens@netronome.com,
        oss-drivers@netronome.com, John Hurley <john.hurley@netronome.com>
Subject: [PATCH net 1/1] net: sched: prevent duplicate flower rules from tcf_proto destroy race
Date:   Sat,  2 Nov 2019 14:17:47 +0000
Message-Id: <1572704267-29705-1-git-send-email-john.hurley@netronome.com>
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
Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
Reviewed-by: Simon Horman <simon.horman@netronome.com>
Reported-by: Louis Peens <louis.peens@netronome.com>
---
 include/net/sch_generic.h |  4 +++
 net/sched/cls_api.c       | 83 ++++++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 83 insertions(+), 4 deletions(-)

diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index a8b0a9a..6a7ee96 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -15,6 +15,7 @@
 #include <linux/mutex.h>
 #include <linux/rwsem.h>
 #include <linux/atomic.h>
+#include <linux/hashtable.h>
 #include <net/gen_stats.h>
 #include <net/rtnetlink.h>
 #include <net/flow_offload.h>
@@ -362,6 +363,7 @@ struct tcf_proto {
 	bool			deleting;
 	refcount_t		refcnt;
 	struct rcu_head		rcu;
+	struct hlist_node	destroy_ht_node;
 };
 
 struct qdisc_skb_cb {
@@ -414,6 +416,8 @@ struct tcf_block {
 		struct list_head filter_chain_list;
 	} chain0;
 	struct rcu_head rcu;
+	DECLARE_HASHTABLE(proto_destroy_ht, 7);
+	struct mutex proto_destroy_lock; /* Lock for proto_destroy hashtable. */
 };
 
 #ifdef CONFIG_PROVE_LOCKING
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 8717c0b..20d60b8 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -21,6 +21,7 @@
 #include <linux/slab.h>
 #include <linux/idr.h>
 #include <linux/rhashtable.h>
+#include <linux/jhash.h>
 #include <net/net_namespace.h>
 #include <net/sock.h>
 #include <net/netlink.h>
@@ -47,6 +48,62 @@ static LIST_HEAD(tcf_proto_base);
 /* Protects list of registered TC modules. It is pure SMP lock. */
 static DEFINE_RWLOCK(cls_mod_lock);
 
+static u32 destroy_obj_hashfn(const struct tcf_proto *tp)
+{
+	return jhash_3words(tp->chain->index, tp->prio,
+			    (__force __u32)tp->protocol, 0);
+}
+
+static void tcf_proto_signal_destroying(struct tcf_chain *chain,
+					struct tcf_proto *tp)
+{
+	struct tcf_block *block = chain->block;
+
+	mutex_lock(&block->proto_destroy_lock);
+	hash_add_rcu(block->proto_destroy_ht, &tp->destroy_ht_node,
+		     destroy_obj_hashfn(tp));
+	mutex_unlock(&block->proto_destroy_lock);
+}
+
+static bool tcf_proto_cmp(const struct tcf_proto *tp1,
+			  const struct tcf_proto *tp2)
+{
+	return tp1->chain->index == tp2->chain->index &&
+	       tp1->prio == tp2->prio &&
+	       tp1->protocol == tp2->protocol;
+}
+
+static bool tcf_proto_exists_destroying(struct tcf_chain *chain,
+					struct tcf_proto *tp)
+{
+	u32 hash = destroy_obj_hashfn(tp);
+	struct tcf_proto *iter;
+	bool found = false;
+
+	rcu_read_lock();
+	hash_for_each_possible_rcu(chain->block->proto_destroy_ht, iter,
+				   destroy_ht_node, hash) {
+		if (tcf_proto_cmp(tp, iter)) {
+			found = true;
+			break;
+		}
+	}
+	rcu_read_unlock();
+
+	return found;
+}
+
+static void
+tcf_proto_signal_destroyed(struct tcf_chain *chain, struct tcf_proto *tp)
+{
+	struct tcf_block *block = chain->block;
+
+	mutex_lock(&block->proto_destroy_lock);
+	if (hash_hashed(&tp->destroy_ht_node))
+		hash_del_rcu(&tp->destroy_ht_node);
+	mutex_unlock(&block->proto_destroy_lock);
+}
+
 /* Find classifier type by string name */
 
 static const struct tcf_proto_ops *__tcf_proto_lookup_ops(const char *kind)
@@ -234,9 +291,11 @@ static void tcf_proto_get(struct tcf_proto *tp)
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
@@ -246,7 +305,7 @@ static void tcf_proto_put(struct tcf_proto *tp, bool rtnl_held,
 			  struct netlink_ext_ack *extack)
 {
 	if (refcount_dec_and_test(&tp->refcnt))
-		tcf_proto_destroy(tp, rtnl_held, extack);
+		tcf_proto_destroy(tp, rtnl_held, true, extack);
 }
 
 static int walker_check_empty(struct tcf_proto *tp, void *fh,
@@ -370,6 +429,7 @@ static bool tcf_chain_detach(struct tcf_chain *chain)
 static void tcf_block_destroy(struct tcf_block *block)
 {
 	mutex_destroy(&block->lock);
+	mutex_destroy(&block->proto_destroy_lock);
 	kfree_rcu(block, rcu);
 }
 
@@ -545,6 +605,12 @@ static void tcf_chain_flush(struct tcf_chain *chain, bool rtnl_held)
 
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
@@ -844,6 +910,7 @@ static struct tcf_block *tcf_block_create(struct net *net, struct Qdisc *q,
 		return ERR_PTR(-ENOMEM);
 	}
 	mutex_init(&block->lock);
+	mutex_init(&block->proto_destroy_lock);
 	init_rwsem(&block->cb_lock);
 	flow_block_init(&block->flow_block);
 	INIT_LIST_HEAD(&block->chain_list);
@@ -1621,6 +1688,12 @@ static struct tcf_proto *tcf_chain_tp_insert_unique(struct tcf_chain *chain,
 
 	mutex_lock(&chain->filter_chain_lock);
 
+	if (tcf_proto_exists_destroying(chain, tp_new)) {
+		mutex_unlock(&chain->filter_chain_lock);
+		tcf_proto_destroy(tp_new, rtnl_held, false, NULL);
+		return ERR_PTR(-EAGAIN);
+	}
+
 	tp = tcf_chain_tp_find(chain, &chain_info,
 			       protocol, prio, false);
 	if (!tp)
@@ -1628,10 +1701,10 @@ static struct tcf_proto *tcf_chain_tp_insert_unique(struct tcf_chain *chain,
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
 
@@ -1669,6 +1742,7 @@ static void tcf_chain_tp_delete_empty(struct tcf_chain *chain,
 		return;
 	}
 
+	tcf_proto_signal_destroying(chain, tp);
 	next = tcf_chain_dereference(chain_info.next, chain);
 	if (tp == chain->filter_chain)
 		tcf_chain0_head_change(chain, next);
@@ -2188,6 +2262,7 @@ static int tc_del_tfilter(struct sk_buff *skb, struct nlmsghdr *n,
 		err = -EINVAL;
 		goto errout_locked;
 	} else if (t->tcm_handle == 0) {
+		tcf_proto_signal_destroying(chain, tp);
 		tcf_chain_tp_remove(chain, &chain_info, tp);
 		mutex_unlock(&chain->filter_chain_lock);
 
-- 
2.7.4

