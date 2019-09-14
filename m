Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87D59B2A26
	for <lists+netdev@lfdr.de>; Sat, 14 Sep 2019 08:46:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726755AbfINGqR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Sep 2019 02:46:17 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:33618 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726410AbfINGqQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Sep 2019 02:46:16 -0400
Received: by mail-wm1-f65.google.com with SMTP id r17so3310216wme.0
        for <netdev@vger.kernel.org>; Fri, 13 Sep 2019 23:46:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hKw+zxPhHwn6HET9MLA1oXBCQCqmnQZqECdjVz6ZHg0=;
        b=VJ9LvkJD9HEIXMdDBGe/VK3Tzjg7AKLY9ZIvrNcnoDaCG96BVKSSFCnT6U5mocnFnG
         sD2JUGJsh98hqX9ifX09iDeiZrPJEAzmOXKnvEoAgsDR11z5+kfV+iQ4IO9v8g3dmsc/
         HfTtSSJVDOMWq9qlPWIzuTC6HmPooEuZSgFbb5gwGsLE3HTsMvVHbnTxu0DpuEXDxCYO
         twWSj0yv3fWz84jMtxw/vBMF+dqFfyRaork6x1MtyOZ7RuqeqBbVBE7Hv02iV43k2zJF
         od0Kk0mxdS0kyI5jIkYAyy5HjroIBqlmpWFQZkAzunzRFZCoAQzvKU0kDRJO3snf0WKl
         JS/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hKw+zxPhHwn6HET9MLA1oXBCQCqmnQZqECdjVz6ZHg0=;
        b=IiQ/i9umvTkch348WrXC9I0ls0OLRLvMMBynxMmfYzSMNHnrCYBTZ+nDKUs0+Kx+Ut
         23xXeIY073oLDojTJ+aVwGkwRD1d3+dnB4e7cvyKqUzGX/fe8jnH89EeJOmiaOnnc4Ep
         9IIQvXTBLLWhGbhVF8fpO2qwas3RQAGgwWSDpfCnfSVHnHDaNld16MKzwOTYs48rTkU6
         d2KMLk3ML3/cLRwR5GyC82Y6LKaxRnSfMMGciQcvfHaRVzfrY+Ry42OcaSa/dYvYG2zH
         OO42d0rV0VJZoMe4Ft44r5Jum4da83OyBOCNC5jLLwqE3fyf+vreigD9cIJ7EpOgVd+U
         Z2bw==
X-Gm-Message-State: APjAAAU9Tji8LBp2SBWgxWxWSjMi8T4Rb7HwZv1gJ5UiO7kOgCPyCZwR
        Y72LtkLDs0akplnUs0C6qy7FSOK0SIE=
X-Google-Smtp-Source: APXvYqzsvqNaBtp5CvAjkbtCvQSiVmhiYFvtoiywogGYGyTXXnB5V5z9K3JXSA8p5rRtW7pTNnN84Q==
X-Received: by 2002:a1c:20cf:: with SMTP id g198mr6505224wmg.66.1568443572477;
        Fri, 13 Sep 2019 23:46:12 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id b194sm7073674wmg.46.2019.09.13.23.46.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Sep 2019 23:46:12 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, idosch@mellanox.com, dsahern@gmail.com,
        jakub.kicinski@netronome.com, tariqt@mellanox.com,
        saeedm@mellanox.com, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        shuah@kernel.org, mlxsw@mellanox.com
Subject: [patch net-next 03/15] net: fib_notifier: propagate possible error during fib notifier registration
Date:   Sat, 14 Sep 2019 08:45:56 +0200
Message-Id: <20190914064608.26799-4-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190914064608.26799-1-jiri@resnulli.us>
References: <20190914064608.26799-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Unlike events for registered notifier, during the registration, the
errors that happened for the block being registered are not propagated
up to the caller. For fib rules, this is already present, but not for
fib entries. So make sure the error is propagated for those as well.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
 include/net/ip_fib.h    |  2 +-
 net/core/fib_notifier.c |  2 --
 net/core/fib_rules.c    | 11 ++++++++---
 net/ipv4/fib_notifier.c |  4 +---
 net/ipv4/fib_trie.c     | 31 ++++++++++++++++++++++---------
 net/ipv4/ipmr_base.c    | 22 +++++++++++++++-------
 net/ipv6/ip6_fib.c      | 36 ++++++++++++++++++++++++------------
 7 files changed, 71 insertions(+), 37 deletions(-)

diff --git a/include/net/ip_fib.h b/include/net/ip_fib.h
index 4cec9ecaa95e..caae0fa610aa 100644
--- a/include/net/ip_fib.h
+++ b/include/net/ip_fib.h
@@ -229,7 +229,7 @@ int __net_init fib4_notifier_init(struct net *net);
 void __net_exit fib4_notifier_exit(struct net *net);
 
 void fib_info_notify_update(struct net *net, struct nl_info *info);
-void fib_notify(struct net *net, struct notifier_block *nb);
+int fib_notify(struct net *net, struct notifier_block *nb);
 
 struct fib_table {
 	struct hlist_node	tb_hlist;
diff --git a/net/core/fib_notifier.c b/net/core/fib_notifier.c
index b965f3c0ec9a..fbd029425638 100644
--- a/net/core/fib_notifier.c
+++ b/net/core/fib_notifier.c
@@ -65,8 +65,6 @@ static int fib_net_dump(struct net *net, struct notifier_block *nb)
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(ops, &fn_net->fib_notifier_ops, list) {
-		int err;
-
 		if (!try_module_get(ops->owner))
 			continue;
 		err = ops->fib_dump(net, nb);
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
index a6d500023457..4acca152843a 100644
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

