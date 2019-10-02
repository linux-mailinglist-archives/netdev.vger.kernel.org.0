Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A45BC8DF3
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 18:13:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727574AbfJBQMj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 12:12:39 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:40867 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726710AbfJBQMi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 12:12:38 -0400
Received: by mail-wr1-f68.google.com with SMTP id l3so20335311wru.7
        for <netdev@vger.kernel.org>; Wed, 02 Oct 2019 09:12:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ol9KUunLvnAxchD1Qx/vQy+/eK3G3BcW0ijtCS2vrao=;
        b=SQh1WvyaqSzbwqdDhxtLGHZxoiEqOJdY0+mt/el7sqI61PNoG7BzSwGNA3jeiF+xak
         zs63SJG/QZUwoWwjyPMD2wnPP0DIO7CpkRDA1RS0A7qMO6BiIHwN+LlcaQCyiNAEnLfd
         xnC9Z5mAjn2EJVylpzMmbKEcxWUelnMT9efgaouYK+zgN5qHlJh2TjaCwXr6sMw3dBJY
         fEtW8nB+h/kBL/9KIeut6BAE9rJ/4ON2NO2Jdofc6huekqNCnHbQQ3cq9lSFA3oJxelO
         wzhgobs1lpwK1jeqZUZHCEO537Cv2Sau8sneL0lHqDIj4f6saei61GpDWeIWRvY/jacs
         XUMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ol9KUunLvnAxchD1Qx/vQy+/eK3G3BcW0ijtCS2vrao=;
        b=UHRnDLvWHgwGmS9C1goUWHIa7W9Ea39/XsJ9BmM6nMlDxSgfmyn1pWx8M4q4YwOzDM
         O/SxIopSr/PhgANlkL3yT08Oy4iZ04lFszKridIFBO3SqTxl1NVevwHaH1BSJVB48tXz
         xnhFA1Bsi/2vfkiaLYoy9XD0dtpTzpTmMNUc/0eV85CUjcmk+mkDtj0pNULeJ5/Z4wYK
         dqphtkoMLAVgEpD9brlOZ5MDJd+roCj0t2FztP9B96dmY7YH53FRG7JcHJcSbbQ5JrPm
         Cm6RVyOcLg4KPIlxu3V+wgs91DrM4l36yWBpniha8jBh3lF3Q5v4P8PLV6dVkNBqYoaJ
         6X7A==
X-Gm-Message-State: APjAAAUvFF3yasaKFO83pHJF/22s9b2rVra3MNKxvpvLiUwiD12FYe37
        k8lZPMx0XVmmyxrWecF2CVPCXX9Bn0o=
X-Google-Smtp-Source: APXvYqzZk1bf2OxsXvN1btx18/FgOprCRMncxmj0n8Rq7OqGUq5n8RMuFPfdwqLtAmO89yDCeaTSVw==
X-Received: by 2002:adf:e40b:: with SMTP id g11mr3442648wrm.226.1570032755753;
        Wed, 02 Oct 2019 09:12:35 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id w4sm21100081wrv.66.2019.10.02.09.12.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Oct 2019 09:12:35 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, idosch@mellanox.com, dsahern@gmail.com,
        jakub.kicinski@netronome.com, tariqt@mellanox.com,
        saeedm@mellanox.com, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        shuah@kernel.org, mlxsw@mellanox.com
Subject: [patch net-next v2 03/15] net: fib_notifier: propagate possible error during fib notifier registration
Date:   Wed,  2 Oct 2019 18:12:19 +0200
Message-Id: <20191002161231.2987-4-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191002161231.2987-1-jiri@resnulli.us>
References: <20191002161231.2987-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Unlike events for registered notifier, during the registration, the
errors that happened for the block being registered are not propagated
up to the caller. Make sure the error is propagated for FIB rules and
entries.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
v1->v2:
- move removal of "int err" from fib_net_dump inner loop to the previous
  patch
- adjusted patch description
---
 include/net/ip_fib.h    |  2 +-
 net/core/fib_rules.c    | 11 ++++++++---
 net/ipv4/fib_notifier.c |  4 +---
 net/ipv4/fib_trie.c     | 31 ++++++++++++++++++++++---------
 net/ipv4/ipmr_base.c    | 22 +++++++++++++++-------
 net/ipv6/ip6_fib.c      | 36 ++++++++++++++++++++++++------------
 6 files changed, 71 insertions(+), 35 deletions(-)

diff --git a/include/net/ip_fib.h b/include/net/ip_fib.h
index a9df85304f40..05c1fd9c5e23 100644
--- a/include/net/ip_fib.h
+++ b/include/net/ip_fib.h
@@ -229,7 +229,7 @@ int __net_init fib4_notifier_init(struct net *net);
 void __net_exit fib4_notifier_exit(struct net *net);
 
 void fib_info_notify_update(struct net *net, struct nl_info *info);
-void fib_notify(struct net *net, struct notifier_block *nb);
+int fib_notify(struct net *net, struct notifier_block *nb);
 
 struct fib_table {
 	struct hlist_node	tb_hlist;
diff --git a/net/core/fib_rules.c b/net/core/fib_rules.c
index 28cbf07102bc..592d8aef90e3 100644
--- a/net/core/fib_rules.c
+++ b/net/core/fib_rules.c
@@ -354,15 +354,20 @@ int fib_rules_dump(struct net *net, struct notifier_block *nb, int family)
 {
 	struct fib_rules_ops *ops;
 	struct fib_rule *rule;
+	int err = 0;
 
 	ops = lookup_rules_ops(net, family);
 	if (!ops)
 		return -EAFNOSUPPORT;
-	list_for_each_entry_rcu(rule, &ops->rules_list, list)
-		call_fib_rule_notifier(nb, FIB_EVENT_RULE_ADD, rule, family);
+	list_for_each_entry_rcu(rule, &ops->rules_list, list) {
+		err = call_fib_rule_notifier(nb, FIB_EVENT_RULE_ADD,
+					     rule, family);
+		if (err)
+			break;
+	}
 	rules_ops_put(ops);
 
-	return 0;
+	return err;
 }
 EXPORT_SYMBOL_GPL(fib_rules_dump);
 
diff --git a/net/ipv4/fib_notifier.c b/net/ipv4/fib_notifier.c
index 1a128c1346fb..0c57f68a9340 100644
--- a/net/ipv4/fib_notifier.c
+++ b/net/ipv4/fib_notifier.c
@@ -42,9 +42,7 @@ static int fib4_dump(struct net *net, struct notifier_block *nb)
 	if (err)
 		return err;
 
-	fib_notify(net, nb);
-
-	return 0;
+	return fib_notify(net, nb);
 }
 
 static const struct fib_notifier_ops fib4_notifier_ops_template = {
diff --git a/net/ipv4/fib_trie.c b/net/ipv4/fib_trie.c
index 5b600b2a2aa3..568e59423773 100644
--- a/net/ipv4/fib_trie.c
+++ b/net/ipv4/fib_trie.c
@@ -2015,10 +2015,11 @@ void fib_info_notify_update(struct net *net, struct nl_info *info)
 	}
 }
 
-static void fib_leaf_notify(struct key_vector *l, struct fib_table *tb,
-			    struct notifier_block *nb)
+static int fib_leaf_notify(struct key_vector *l, struct fib_table *tb,
+			   struct notifier_block *nb)
 {
 	struct fib_alias *fa;
+	int err;
 
 	hlist_for_each_entry_rcu(fa, &l->leaf, fa_list) {
 		struct fib_info *fi = fa->fa_info;
@@ -2032,38 +2033,50 @@ static void fib_leaf_notify(struct key_vector *l, struct fib_table *tb,
 		if (tb->tb_id != fa->tb_id)
 			continue;
 
-		call_fib_entry_notifier(nb, FIB_EVENT_ENTRY_ADD, l->key,
-					KEYLENGTH - fa->fa_slen, fa);
+		err = call_fib_entry_notifier(nb, FIB_EVENT_ENTRY_ADD, l->key,
+					      KEYLENGTH - fa->fa_slen, fa);
+		if (err)
+			return err;
 	}
+	return 0;
 }
 
-static void fib_table_notify(struct fib_table *tb, struct notifier_block *nb)
+static int fib_table_notify(struct fib_table *tb, struct notifier_block *nb)
 {
 	struct trie *t = (struct trie *)tb->tb_data;
 	struct key_vector *l, *tp = t->kv;
 	t_key key = 0;
+	int err;
 
 	while ((l = leaf_walk_rcu(&tp, key)) != NULL) {
-		fib_leaf_notify(l, tb, nb);
+		err = fib_leaf_notify(l, tb, nb);
+		if (err)
+			return err;
 
 		key = l->key + 1;
 		/* stop in case of wrap around */
 		if (key < l->key)
 			break;
 	}
+	return 0;
 }
 
-void fib_notify(struct net *net, struct notifier_block *nb)
+int fib_notify(struct net *net, struct notifier_block *nb)
 {
 	unsigned int h;
+	int err;
 
 	for (h = 0; h < FIB_TABLE_HASHSZ; h++) {
 		struct hlist_head *head = &net->ipv4.fib_table_hash[h];
 		struct fib_table *tb;
 
-		hlist_for_each_entry_rcu(tb, head, tb_hlist)
-			fib_table_notify(tb, nb);
+		hlist_for_each_entry_rcu(tb, head, tb_hlist) {
+			err = fib_table_notify(tb, nb);
+			if (err)
+				return err;
+		}
 	}
+	return 0;
 }
 
 static void __trie_free_rcu(struct rcu_head *head)
diff --git a/net/ipv4/ipmr_base.c b/net/ipv4/ipmr_base.c
index 4dcc3214e3cc..c4e23c2a0d5c 100644
--- a/net/ipv4/ipmr_base.c
+++ b/net/ipv4/ipmr_base.c
@@ -409,17 +409,25 @@ int mr_dump(struct net *net, struct notifier_block *nb, unsigned short family,
 			if (!v->dev)
 				continue;
 
-			mr_call_vif_notifier(nb, family,
-					     FIB_EVENT_VIF_ADD,
-					     v, vifi, mrt->id);
+			err = mr_call_vif_notifier(nb, family,
+						   FIB_EVENT_VIF_ADD,
+						   v, vifi, mrt->id);
+			if (err)
+				break;
 		}
 		read_unlock(mrt_lock);
 
+		if (err)
+			return err;
+
 		/* Notify on table MFC entries */
-		list_for_each_entry_rcu(mfc, &mrt->mfc_cache_list, list)
-			mr_call_mfc_notifier(nb, family,
-					     FIB_EVENT_ENTRY_ADD,
-					     mfc, mrt->id);
+		list_for_each_entry_rcu(mfc, &mrt->mfc_cache_list, list) {
+			err = mr_call_mfc_notifier(nb, family,
+						   FIB_EVENT_ENTRY_ADD,
+						   mfc, mrt->id);
+			if (err)
+				return err;
+		}
 	}
 
 	return 0;
diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
index f6fae48b2e18..76124a909395 100644
--- a/net/ipv6/ip6_fib.c
+++ b/net/ipv6/ip6_fib.c
@@ -403,30 +403,37 @@ struct fib6_dump_arg {
 	struct notifier_block *nb;
 };
 
-static void fib6_rt_dump(struct fib6_info *rt, struct fib6_dump_arg *arg)
+static int fib6_rt_dump(struct fib6_info *rt, struct fib6_dump_arg *arg)
 {
 	if (rt == arg->net->ipv6.fib6_null_entry)
-		return;
-	call_fib6_entry_notifier(arg->nb, FIB_EVENT_ENTRY_ADD, rt);
+		return 0;
+	return call_fib6_entry_notifier(arg->nb, FIB_EVENT_ENTRY_ADD, rt);
 }
 
 static int fib6_node_dump(struct fib6_walker *w)
 {
 	struct fib6_info *rt;
+	int err = 0;
 
-	for_each_fib6_walker_rt(w)
-		fib6_rt_dump(rt, w->args);
+	for_each_fib6_walker_rt(w) {
+		err = fib6_rt_dump(rt, w->args);
+		if (err)
+			break;
+	}
 	w->leaf = NULL;
-	return 0;
+	return err;
 }
 
-static void fib6_table_dump(struct net *net, struct fib6_table *tb,
-			    struct fib6_walker *w)
+static int fib6_table_dump(struct net *net, struct fib6_table *tb,
+			   struct fib6_walker *w)
 {
+	int err;
+
 	w->root = &tb->tb6_root;
 	spin_lock_bh(&tb->tb6_lock);
-	fib6_walk(net, w);
+	err = fib6_walk(net, w);
 	spin_unlock_bh(&tb->tb6_lock);
+	return err;
 }
 
 /* Called with rcu_read_lock() */
@@ -435,6 +442,7 @@ int fib6_tables_dump(struct net *net, struct notifier_block *nb)
 	struct fib6_dump_arg arg;
 	struct fib6_walker *w;
 	unsigned int h;
+	int err = 0;
 
 	w = kzalloc(sizeof(*w), GFP_ATOMIC);
 	if (!w)
@@ -449,13 +457,17 @@ int fib6_tables_dump(struct net *net, struct notifier_block *nb)
 		struct hlist_head *head = &net->ipv6.fib_table_hash[h];
 		struct fib6_table *tb;
 
-		hlist_for_each_entry_rcu(tb, head, tb6_hlist)
-			fib6_table_dump(net, tb, w);
+		hlist_for_each_entry_rcu(tb, head, tb6_hlist) {
+			err = fib6_table_dump(net, tb, w);
+			if (err < 0)
+				goto out;
+		}
 	}
 
+out:
 	kfree(w);
 
-	return 0;
+	return err;
 }
 
 static int fib6_dump_node(struct fib6_walker *w)
-- 
2.21.0

