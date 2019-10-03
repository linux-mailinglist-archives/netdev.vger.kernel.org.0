Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2950BC9B06
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 11:50:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729291AbfJCJtw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 05:49:52 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:36766 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728743AbfJCJtv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 05:49:51 -0400
Received: by mail-wm1-f66.google.com with SMTP id m18so1771698wmc.1
        for <netdev@vger.kernel.org>; Thu, 03 Oct 2019 02:49:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qAKvr64xWmHfD8yMoG9Z+XKl987+vY2jIaXwT4IV//w=;
        b=0bmbNOP0GfUlY7LfOsF+d/6CrgpgfCd0gZYcIJQTh4Fxvc+ZS0ms7PS5kT9xncQL8u
         xHtb1FDp8S9HrS8sANq0Y8IirLxlBJS7EtCzG0jBrwcj1KSbxwjWSF3nX6NxoaSXwGRv
         7tPu6+eH5Q1LxDln2I+leKo8QMGImAlZ2S2aQsONZ7aGtwQGQD/BHphWFTgGsb8UJxQE
         pEDYReZAVlNBfA2g3cgfJiUm6LLLB6WBqN/MFu8l750y2KEXPomziHjy3RlwmVr4yxk0
         dqNt6pJfuPdjrK7TjphJh/Rjj8d/Sf0sg7DzilFwNV0Ya4PVlMyPQvUcRh2rPCXsbWka
         PR0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qAKvr64xWmHfD8yMoG9Z+XKl987+vY2jIaXwT4IV//w=;
        b=mmw4RhsxuV30dL+P5goTL+Sgl5g2nBxjfb4gk7H5DFwSgeEdFWJ40KsAQzlcWtb401
         ovQ16GqnF0pVexlpDVJo+7qy81WpDmswic/IZhtqHF4xUhHy9RefGuhis2Oq8nDTn6Fj
         BrvcuOoXh7cwyODElR2ioXzs6n7tOiuIYKWL1Su1EGTzVyyqJDITavEzG+tbgH8pE+9O
         l3vu1sTPjHzlWAT8us72zsG3g5TqRT+vwIBp4enhDF94wuCjNtPvzoqM7OegawakarQU
         //vFm1x5W9XhUwNKp1DZg5B3RkQuWgLlngmYTd1knWIq5i5XKiBwLTkdHWLXMurAj/OW
         49pA==
X-Gm-Message-State: APjAAAXpG6lV2Q9UsuAL0M9jXagbwf/ATJL/xy7nTilr4FGAeODnWT9f
        n8jWEsb9gXt4XNcF0faOao6pKaL9lsA=
X-Google-Smtp-Source: APXvYqydmLSKLHQTiG+DQtDgLZag8JJ12xoFo7+eEm6aA66fnxVDhEHxHVrAyNrLRu77oiARHRkOBQ==
X-Received: by 2002:a7b:c757:: with SMTP id w23mr6152271wmk.31.1570096188390;
        Thu, 03 Oct 2019 02:49:48 -0700 (PDT)
Received: from localhost ([85.163.43.78])
        by smtp.gmail.com with ESMTPSA id h125sm3756686wmf.31.2019.10.03.02.49.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Oct 2019 02:49:48 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, idosch@mellanox.com, dsahern@gmail.com,
        jakub.kicinski@netronome.com, tariqt@mellanox.com,
        saeedm@mellanox.com, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        shuah@kernel.org, mlxsw@mellanox.com
Subject: [patch net-next v3 05/15] net: fib_notifier: propagate extack down to the notifier block callback
Date:   Thu,  3 Oct 2019 11:49:30 +0200
Message-Id: <20191003094940.9797-6-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191003094940.9797-1-jiri@resnulli.us>
References: <20191003094940.9797-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Since errors are propagated all the way up to the caller, propagate
possible extack of the caller all the way down to the notifier block
callback.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/lag_mp.c  |  2 +-
 .../ethernet/mellanox/mlxsw/spectrum_router.c |  2 +-
 drivers/net/ethernet/rocker/rocker_main.c     |  2 +-
 drivers/net/netdevsim/fib.c                   |  2 +-
 include/linux/mroute_base.h                   | 18 +++++++++++------
 include/net/fib_notifier.h                    |  6 ++++--
 include/net/fib_rules.h                       |  3 ++-
 include/net/ip6_fib.h                         |  9 ++++++---
 include/net/ip_fib.h                          |  9 ++++++---
 net/core/fib_notifier.c                       | 10 ++++++----
 net/core/fib_rules.c                          |  9 ++++++---
 net/ipv4/fib_notifier.c                       |  7 ++++---
 net/ipv4/fib_rules.c                          |  5 +++--
 net/ipv4/fib_trie.c                           | 20 ++++++++++++-------
 net/ipv4/ipmr.c                               | 13 +++++++-----
 net/ipv4/ipmr_base.c                          | 12 ++++++-----
 net/ipv6/fib6_notifier.c                      |  7 ++++---
 net/ipv6/fib6_rules.c                         |  5 +++--
 net/ipv6/ip6_fib.c                            | 12 ++++++++---
 net/ipv6/ip6mr.c                              | 13 +++++++-----
 20 files changed, 105 insertions(+), 61 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c b/drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c
index fe0cc969cf94..13e2944b1274 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c
@@ -309,7 +309,7 @@ int mlx5_lag_mp_init(struct mlx5_lag *ldev)
 
 	mp->fib_nb.notifier_call = mlx5_lag_fib_event;
 	err = register_fib_notifier(&init_net, &mp->fib_nb,
-				    mlx5_lag_fib_event_flush);
+				    mlx5_lag_fib_event_flush, NULL);
 	if (err)
 		mp->fib_nb.notifier_call = NULL;
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 1eeff1d23b13..445e2daa54ac 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -8135,7 +8135,7 @@ int mlxsw_sp_router_init(struct mlxsw_sp *mlxsw_sp)
 
 	mlxsw_sp->router->fib_nb.notifier_call = mlxsw_sp_router_fib_event;
 	err = register_fib_notifier(&init_net, &mlxsw_sp->router->fib_nb,
-				    mlxsw_sp_router_fib_dump_flush);
+				    mlxsw_sp_router_fib_dump_flush, NULL);
 	if (err)
 		goto err_register_fib_notifier;
 
diff --git a/drivers/net/ethernet/rocker/rocker_main.c b/drivers/net/ethernet/rocker/rocker_main.c
index e54f6341a785..bc4f951315da 100644
--- a/drivers/net/ethernet/rocker/rocker_main.c
+++ b/drivers/net/ethernet/rocker/rocker_main.c
@@ -2991,7 +2991,7 @@ static int rocker_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	 * the device, so no need to pass a callback.
 	 */
 	rocker->fib_nb.notifier_call = rocker_router_fib_event;
-	err = register_fib_notifier(&init_net, &rocker->fib_nb, NULL);
+	err = register_fib_notifier(&init_net, &rocker->fib_nb, NULL, NULL);
 	if (err)
 		goto err_register_fib_notifier;
 
diff --git a/drivers/net/netdevsim/fib.c b/drivers/net/netdevsim/fib.c
index 01ee9cc54605..d2aeac0f4c2c 100644
--- a/drivers/net/netdevsim/fib.c
+++ b/drivers/net/netdevsim/fib.c
@@ -256,7 +256,7 @@ struct nsim_fib_data *nsim_fib_create(struct devlink *devlink)
 
 	data->fib_nb.notifier_call = nsim_fib_event_nb;
 	err = register_fib_notifier(&init_net, &data->fib_nb,
-				    nsim_fib_dump_inconsistent);
+				    nsim_fib_dump_inconsistent, NULL);
 	if (err) {
 		pr_err("Failed to register fib notifier\n");
 		goto err_out;
diff --git a/include/linux/mroute_base.h b/include/linux/mroute_base.h
index 0931631bbc13..8071148f29a6 100644
--- a/include/linux/mroute_base.h
+++ b/include/linux/mroute_base.h
@@ -50,11 +50,13 @@ static inline int mr_call_vif_notifier(struct notifier_block *nb,
 				       unsigned short family,
 				       enum fib_event_type event_type,
 				       struct vif_device *vif,
-				       unsigned short vif_index, u32 tb_id)
+				       unsigned short vif_index, u32 tb_id,
+				       struct netlink_ext_ack *extack)
 {
 	struct vif_entry_notifier_info info = {
 		.info = {
 			.family = family,
+			.extack = extack,
 		},
 		.dev = vif->dev,
 		.vif_index = vif_index,
@@ -172,11 +174,13 @@ struct mfc_entry_notifier_info {
 static inline int mr_call_mfc_notifier(struct notifier_block *nb,
 				       unsigned short family,
 				       enum fib_event_type event_type,
-				       struct mr_mfc *mfc, u32 tb_id)
+				       struct mr_mfc *mfc, u32 tb_id,
+				       struct netlink_ext_ack *extack)
 {
 	struct mfc_entry_notifier_info info = {
 		.info = {
 			.family = family,
+			.extack = extack,
 		},
 		.mfc = mfc,
 		.tb_id = tb_id
@@ -295,10 +299,11 @@ int mr_rtm_dumproute(struct sk_buff *skb, struct netlink_callback *cb,
 
 int mr_dump(struct net *net, struct notifier_block *nb, unsigned short family,
 	    int (*rules_dump)(struct net *net,
-			      struct notifier_block *nb),
+			      struct notifier_block *nb,
+			      struct netlink_ext_ack *extack),
 	    struct mr_table *(*mr_iter)(struct net *net,
 					struct mr_table *mrt),
-	    rwlock_t *mrt_lock);
+	    rwlock_t *mrt_lock, struct netlink_ext_ack *extack);
 #else
 static inline void vif_device_init(struct vif_device *v,
 				   struct net_device *dev,
@@ -349,10 +354,11 @@ mr_rtm_dumproute(struct sk_buff *skb, struct netlink_callback *cb,
 static inline int mr_dump(struct net *net, struct notifier_block *nb,
 			  unsigned short family,
 			  int (*rules_dump)(struct net *net,
-					    struct notifier_block *nb),
+					    struct notifier_block *nb,
+					    struct netlink_ext_ack *extack),
 			  struct mr_table *(*mr_iter)(struct net *net,
 						      struct mr_table *mrt),
-			  rwlock_t *mrt_lock)
+			  rwlock_t *mrt_lock, struct netlink_ext_ack *extack)
 {
 	return -EINVAL;
 }
diff --git a/include/net/fib_notifier.h b/include/net/fib_notifier.h
index 23353f67b2b0..6d59221ff05a 100644
--- a/include/net/fib_notifier.h
+++ b/include/net/fib_notifier.h
@@ -29,7 +29,8 @@ struct fib_notifier_ops {
 	int family;
 	struct list_head list;
 	unsigned int (*fib_seq_read)(struct net *net);
-	int (*fib_dump)(struct net *net, struct notifier_block *nb);
+	int (*fib_dump)(struct net *net, struct notifier_block *nb,
+			struct netlink_ext_ack *extack);
 	struct module *owner;
 	struct rcu_head rcu;
 };
@@ -40,7 +41,8 @@ int call_fib_notifier(struct notifier_block *nb,
 int call_fib_notifiers(struct net *net, enum fib_event_type event_type,
 		       struct fib_notifier_info *info);
 int register_fib_notifier(struct net *net, struct notifier_block *nb,
-			  void (*cb)(struct notifier_block *nb));
+			  void (*cb)(struct notifier_block *nb),
+			  struct netlink_ext_ack *extack);
 int unregister_fib_notifier(struct net *net, struct notifier_block *nb);
 struct fib_notifier_ops *
 fib_notifier_ops_register(const struct fib_notifier_ops *tmpl, struct net *net);
diff --git a/include/net/fib_rules.h b/include/net/fib_rules.h
index 20dcadd8eed9..54e227e6b06a 100644
--- a/include/net/fib_rules.h
+++ b/include/net/fib_rules.h
@@ -194,7 +194,8 @@ int fib_rules_lookup(struct fib_rules_ops *, struct flowi *, int flags,
 int fib_default_rule_add(struct fib_rules_ops *, u32 pref, u32 table,
 			 u32 flags);
 bool fib_rule_matchall(const struct fib_rule *rule);
-int fib_rules_dump(struct net *net, struct notifier_block *nb, int family);
+int fib_rules_dump(struct net *net, struct notifier_block *nb, int family,
+		   struct netlink_ext_ack *extack);
 unsigned int fib_rules_seq_read(struct net *net, int family);
 
 int fib_nl_newrule(struct sk_buff *skb, struct nlmsghdr *nlh,
diff --git a/include/net/ip6_fib.h b/include/net/ip6_fib.h
index 14e9fca0e326..5d1615463138 100644
--- a/include/net/ip6_fib.h
+++ b/include/net/ip6_fib.h
@@ -488,7 +488,8 @@ int __net_init fib6_notifier_init(struct net *net);
 void __net_exit fib6_notifier_exit(struct net *net);
 
 unsigned int fib6_tables_seq_read(struct net *net);
-int fib6_tables_dump(struct net *net, struct notifier_block *nb);
+int fib6_tables_dump(struct net *net, struct notifier_block *nb,
+		     struct netlink_ext_ack *extack);
 
 void fib6_update_sernum(struct net *net, struct fib6_info *rt);
 void fib6_update_sernum_upto_root(struct net *net, struct fib6_info *rt);
@@ -504,7 +505,8 @@ static inline bool fib6_metric_locked(struct fib6_info *f6i, int metric)
 int fib6_rules_init(void);
 void fib6_rules_cleanup(void);
 bool fib6_rule_default(const struct fib_rule *rule);
-int fib6_rules_dump(struct net *net, struct notifier_block *nb);
+int fib6_rules_dump(struct net *net, struct notifier_block *nb,
+		    struct netlink_ext_ack *extack);
 unsigned int fib6_rules_seq_read(struct net *net);
 
 static inline bool fib6_rules_early_flow_dissect(struct net *net,
@@ -537,7 +539,8 @@ static inline bool fib6_rule_default(const struct fib_rule *rule)
 {
 	return true;
 }
-static inline int fib6_rules_dump(struct net *net, struct notifier_block *nb)
+static inline int fib6_rules_dump(struct net *net, struct notifier_block *nb,
+				  struct netlink_ext_ack *extack)
 {
 	return 0;
 }
diff --git a/include/net/ip_fib.h b/include/net/ip_fib.h
index 05c1fd9c5e23..52b2406a5dfc 100644
--- a/include/net/ip_fib.h
+++ b/include/net/ip_fib.h
@@ -229,7 +229,8 @@ int __net_init fib4_notifier_init(struct net *net);
 void __net_exit fib4_notifier_exit(struct net *net);
 
 void fib_info_notify_update(struct net *net, struct nl_info *info);
-int fib_notify(struct net *net, struct notifier_block *nb);
+int fib_notify(struct net *net, struct notifier_block *nb,
+	       struct netlink_ext_ack *extack);
 
 struct fib_table {
 	struct hlist_node	tb_hlist;
@@ -315,7 +316,8 @@ static inline bool fib4_rule_default(const struct fib_rule *rule)
 	return true;
 }
 
-static inline int fib4_rules_dump(struct net *net, struct notifier_block *nb)
+static inline int fib4_rules_dump(struct net *net, struct notifier_block *nb,
+				  struct netlink_ext_ack *extack)
 {
 	return 0;
 }
@@ -377,7 +379,8 @@ static inline int fib_lookup(struct net *net, struct flowi4 *flp,
 }
 
 bool fib4_rule_default(const struct fib_rule *rule);
-int fib4_rules_dump(struct net *net, struct notifier_block *nb);
+int fib4_rules_dump(struct net *net, struct notifier_block *nb,
+		    struct netlink_ext_ack *extack);
 unsigned int fib4_rules_seq_read(struct net *net);
 
 static inline bool fib4_rules_early_flow_dissect(struct net *net,
diff --git a/net/core/fib_notifier.c b/net/core/fib_notifier.c
index fbd029425638..fc96259807b6 100644
--- a/net/core/fib_notifier.c
+++ b/net/core/fib_notifier.c
@@ -57,7 +57,8 @@ static unsigned int fib_seq_sum(struct net *net)
 	return fib_seq;
 }
 
-static int fib_net_dump(struct net *net, struct notifier_block *nb)
+static int fib_net_dump(struct net *net, struct notifier_block *nb,
+			struct netlink_ext_ack *extack)
 {
 	struct fib_notifier_net *fn_net = net_generic(net, fib_notifier_net_id);
 	struct fib_notifier_ops *ops;
@@ -67,7 +68,7 @@ static int fib_net_dump(struct net *net, struct notifier_block *nb)
 	list_for_each_entry_rcu(ops, &fn_net->fib_notifier_ops, list) {
 		if (!try_module_get(ops->owner))
 			continue;
-		err = ops->fib_dump(net, nb);
+		err = ops->fib_dump(net, nb, extack);
 		module_put(ops->owner);
 		if (err)
 			goto unlock;
@@ -96,7 +97,8 @@ static bool fib_dump_is_consistent(struct net *net, struct notifier_block *nb,
 
 #define FIB_DUMP_MAX_RETRIES 5
 int register_fib_notifier(struct net *net, struct notifier_block *nb,
-			  void (*cb)(struct notifier_block *nb))
+			  void (*cb)(struct notifier_block *nb),
+			  struct netlink_ext_ack *extack)
 {
 	int retries = 0;
 	int err;
@@ -104,7 +106,7 @@ int register_fib_notifier(struct net *net, struct notifier_block *nb,
 	do {
 		unsigned int fib_seq = fib_seq_sum(net);
 
-		err = fib_net_dump(net, nb);
+		err = fib_net_dump(net, nb, extack);
 		if (err)
 			return err;
 
diff --git a/net/core/fib_rules.c b/net/core/fib_rules.c
index 592d8aef90e3..3e7e15278c46 100644
--- a/net/core/fib_rules.c
+++ b/net/core/fib_rules.c
@@ -323,10 +323,12 @@ EXPORT_SYMBOL_GPL(fib_rules_lookup);
 
 static int call_fib_rule_notifier(struct notifier_block *nb,
 				  enum fib_event_type event_type,
-				  struct fib_rule *rule, int family)
+				  struct fib_rule *rule, int family,
+				  struct netlink_ext_ack *extack)
 {
 	struct fib_rule_notifier_info info = {
 		.info.family = family,
+		.info.extack = extack,
 		.rule = rule,
 	};
 
@@ -350,7 +352,8 @@ static int call_fib_rule_notifiers(struct net *net,
 }
 
 /* Called with rcu_read_lock() */
-int fib_rules_dump(struct net *net, struct notifier_block *nb, int family)
+int fib_rules_dump(struct net *net, struct notifier_block *nb, int family,
+		   struct netlink_ext_ack *extack)
 {
 	struct fib_rules_ops *ops;
 	struct fib_rule *rule;
@@ -361,7 +364,7 @@ int fib_rules_dump(struct net *net, struct notifier_block *nb, int family)
 		return -EAFNOSUPPORT;
 	list_for_each_entry_rcu(rule, &ops->rules_list, list) {
 		err = call_fib_rule_notifier(nb, FIB_EVENT_RULE_ADD,
-					     rule, family);
+					     rule, family, extack);
 		if (err)
 			break;
 	}
diff --git a/net/ipv4/fib_notifier.c b/net/ipv4/fib_notifier.c
index 0c57f68a9340..0c28bd469a68 100644
--- a/net/ipv4/fib_notifier.c
+++ b/net/ipv4/fib_notifier.c
@@ -34,15 +34,16 @@ static unsigned int fib4_seq_read(struct net *net)
 	return net->ipv4.fib_seq + fib4_rules_seq_read(net);
 }
 
-static int fib4_dump(struct net *net, struct notifier_block *nb)
+static int fib4_dump(struct net *net, struct notifier_block *nb,
+		     struct netlink_ext_ack *extack)
 {
 	int err;
 
-	err = fib4_rules_dump(net, nb);
+	err = fib4_rules_dump(net, nb, extack);
 	if (err)
 		return err;
 
-	return fib_notify(net, nb);
+	return fib_notify(net, nb, extack);
 }
 
 static const struct fib_notifier_ops fib4_notifier_ops_template = {
diff --git a/net/ipv4/fib_rules.c b/net/ipv4/fib_rules.c
index b43a7ba5c6a4..f99e3bac5cab 100644
--- a/net/ipv4/fib_rules.c
+++ b/net/ipv4/fib_rules.c
@@ -65,9 +65,10 @@ bool fib4_rule_default(const struct fib_rule *rule)
 }
 EXPORT_SYMBOL_GPL(fib4_rule_default);
 
-int fib4_rules_dump(struct net *net, struct notifier_block *nb)
+int fib4_rules_dump(struct net *net, struct notifier_block *nb,
+		    struct netlink_ext_ack *extack)
 {
-	return fib_rules_dump(net, nb, AF_INET);
+	return fib_rules_dump(net, nb, AF_INET, extack);
 }
 
 unsigned int fib4_rules_seq_read(struct net *net)
diff --git a/net/ipv4/fib_trie.c b/net/ipv4/fib_trie.c
index 568e59423773..b9df9c09b84e 100644
--- a/net/ipv4/fib_trie.c
+++ b/net/ipv4/fib_trie.c
@@ -76,9 +76,11 @@
 
 static int call_fib_entry_notifier(struct notifier_block *nb,
 				   enum fib_event_type event_type, u32 dst,
-				   int dst_len, struct fib_alias *fa)
+				   int dst_len, struct fib_alias *fa,
+				   struct netlink_ext_ack *extack)
 {
 	struct fib_entry_notifier_info info = {
+		.info.extack = extack,
 		.dst = dst,
 		.dst_len = dst_len,
 		.fi = fa->fa_info,
@@ -2016,7 +2018,8 @@ void fib_info_notify_update(struct net *net, struct nl_info *info)
 }
 
 static int fib_leaf_notify(struct key_vector *l, struct fib_table *tb,
-			   struct notifier_block *nb)
+			   struct notifier_block *nb,
+			   struct netlink_ext_ack *extack)
 {
 	struct fib_alias *fa;
 	int err;
@@ -2034,14 +2037,16 @@ static int fib_leaf_notify(struct key_vector *l, struct fib_table *tb,
 			continue;
 
 		err = call_fib_entry_notifier(nb, FIB_EVENT_ENTRY_ADD, l->key,
-					      KEYLENGTH - fa->fa_slen, fa);
+					      KEYLENGTH - fa->fa_slen,
+					      fa, extack);
 		if (err)
 			return err;
 	}
 	return 0;
 }
 
-static int fib_table_notify(struct fib_table *tb, struct notifier_block *nb)
+static int fib_table_notify(struct fib_table *tb, struct notifier_block *nb,
+			    struct netlink_ext_ack *extack)
 {
 	struct trie *t = (struct trie *)tb->tb_data;
 	struct key_vector *l, *tp = t->kv;
@@ -2049,7 +2054,7 @@ static int fib_table_notify(struct fib_table *tb, struct notifier_block *nb)
 	int err;
 
 	while ((l = leaf_walk_rcu(&tp, key)) != NULL) {
-		err = fib_leaf_notify(l, tb, nb);
+		err = fib_leaf_notify(l, tb, nb, extack);
 		if (err)
 			return err;
 
@@ -2061,7 +2066,8 @@ static int fib_table_notify(struct fib_table *tb, struct notifier_block *nb)
 	return 0;
 }
 
-int fib_notify(struct net *net, struct notifier_block *nb)
+int fib_notify(struct net *net, struct notifier_block *nb,
+	       struct netlink_ext_ack *extack)
 {
 	unsigned int h;
 	int err;
@@ -2071,7 +2077,7 @@ int fib_notify(struct net *net, struct notifier_block *nb)
 		struct fib_table *tb;
 
 		hlist_for_each_entry_rcu(tb, head, tb_hlist) {
-			err = fib_table_notify(tb, nb);
+			err = fib_table_notify(tb, nb, extack);
 			if (err)
 				return err;
 		}
diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
index 313470f6bb14..051f365b64d2 100644
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -278,9 +278,10 @@ static void __net_exit ipmr_rules_exit(struct net *net)
 	rtnl_unlock();
 }
 
-static int ipmr_rules_dump(struct net *net, struct notifier_block *nb)
+static int ipmr_rules_dump(struct net *net, struct notifier_block *nb,
+			   struct netlink_ext_ack *extack)
 {
-	return fib_rules_dump(net, nb, RTNL_FAMILY_IPMR);
+	return fib_rules_dump(net, nb, RTNL_FAMILY_IPMR, extack);
 }
 
 static unsigned int ipmr_rules_seq_read(struct net *net)
@@ -336,7 +337,8 @@ static void __net_exit ipmr_rules_exit(struct net *net)
 	rtnl_unlock();
 }
 
-static int ipmr_rules_dump(struct net *net, struct notifier_block *nb)
+static int ipmr_rules_dump(struct net *net, struct notifier_block *nb,
+			   struct netlink_ext_ack *extack)
 {
 	return 0;
 }
@@ -3040,10 +3042,11 @@ static unsigned int ipmr_seq_read(struct net *net)
 	return net->ipv4.ipmr_seq + ipmr_rules_seq_read(net);
 }
 
-static int ipmr_dump(struct net *net, struct notifier_block *nb)
+static int ipmr_dump(struct net *net, struct notifier_block *nb,
+		     struct netlink_ext_ack *extack)
 {
 	return mr_dump(net, nb, RTNL_FAMILY_IPMR, ipmr_rules_dump,
-		       ipmr_mr_table_iter, &mrt_lock);
+		       ipmr_mr_table_iter, &mrt_lock, extack);
 }
 
 static const struct fib_notifier_ops ipmr_notifier_ops_template = {
diff --git a/net/ipv4/ipmr_base.c b/net/ipv4/ipmr_base.c
index c4e23c2a0d5c..aa8738a91210 100644
--- a/net/ipv4/ipmr_base.c
+++ b/net/ipv4/ipmr_base.c
@@ -386,15 +386,17 @@ EXPORT_SYMBOL(mr_rtm_dumproute);
 
 int mr_dump(struct net *net, struct notifier_block *nb, unsigned short family,
 	    int (*rules_dump)(struct net *net,
-			      struct notifier_block *nb),
+			      struct notifier_block *nb,
+			      struct netlink_ext_ack *extack),
 	    struct mr_table *(*mr_iter)(struct net *net,
 					struct mr_table *mrt),
-	    rwlock_t *mrt_lock)
+	    rwlock_t *mrt_lock,
+	    struct netlink_ext_ack *extack)
 {
 	struct mr_table *mrt;
 	int err;
 
-	err = rules_dump(net, nb);
+	err = rules_dump(net, nb, extack);
 	if (err)
 		return err;
 
@@ -411,7 +413,7 @@ int mr_dump(struct net *net, struct notifier_block *nb, unsigned short family,
 
 			err = mr_call_vif_notifier(nb, family,
 						   FIB_EVENT_VIF_ADD,
-						   v, vifi, mrt->id);
+						   v, vifi, mrt->id, extack);
 			if (err)
 				break;
 		}
@@ -424,7 +426,7 @@ int mr_dump(struct net *net, struct notifier_block *nb, unsigned short family,
 		list_for_each_entry_rcu(mfc, &mrt->mfc_cache_list, list) {
 			err = mr_call_mfc_notifier(nb, family,
 						   FIB_EVENT_ENTRY_ADD,
-						   mfc, mrt->id);
+						   mfc, mrt->id, extack);
 			if (err)
 				return err;
 		}
diff --git a/net/ipv6/fib6_notifier.c b/net/ipv6/fib6_notifier.c
index 4fe79296999a..f87ae33e1d01 100644
--- a/net/ipv6/fib6_notifier.c
+++ b/net/ipv6/fib6_notifier.c
@@ -27,15 +27,16 @@ static unsigned int fib6_seq_read(struct net *net)
 	return fib6_tables_seq_read(net) + fib6_rules_seq_read(net);
 }
 
-static int fib6_dump(struct net *net, struct notifier_block *nb)
+static int fib6_dump(struct net *net, struct notifier_block *nb,
+		     struct netlink_ext_ack *extack)
 {
 	int err;
 
-	err = fib6_rules_dump(net, nb);
+	err = fib6_rules_dump(net, nb, extack);
 	if (err)
 		return err;
 
-	return fib6_tables_dump(net, nb);
+	return fib6_tables_dump(net, nb, extack);
 }
 
 static const struct fib_notifier_ops fib6_notifier_ops_template = {
diff --git a/net/ipv6/fib6_rules.c b/net/ipv6/fib6_rules.c
index f9e8fe3ff0c5..fafe556d21e0 100644
--- a/net/ipv6/fib6_rules.c
+++ b/net/ipv6/fib6_rules.c
@@ -47,9 +47,10 @@ bool fib6_rule_default(const struct fib_rule *rule)
 }
 EXPORT_SYMBOL_GPL(fib6_rule_default);
 
-int fib6_rules_dump(struct net *net, struct notifier_block *nb)
+int fib6_rules_dump(struct net *net, struct notifier_block *nb,
+		    struct netlink_ext_ack *extack)
 {
-	return fib_rules_dump(net, nb, AF_INET6);
+	return fib_rules_dump(net, nb, AF_INET6, extack);
 }
 
 unsigned int fib6_rules_seq_read(struct net *net)
diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
index 76124a909395..f66bc2af4e9d 100644
--- a/net/ipv6/ip6_fib.c
+++ b/net/ipv6/ip6_fib.c
@@ -359,9 +359,11 @@ unsigned int fib6_tables_seq_read(struct net *net)
 
 static int call_fib6_entry_notifier(struct notifier_block *nb,
 				    enum fib_event_type event_type,
-				    struct fib6_info *rt)
+				    struct fib6_info *rt,
+				    struct netlink_ext_ack *extack)
 {
 	struct fib6_entry_notifier_info info = {
+		.info.extack = extack,
 		.rt = rt,
 	};
 
@@ -401,13 +403,15 @@ int call_fib6_multipath_entry_notifiers(struct net *net,
 struct fib6_dump_arg {
 	struct net *net;
 	struct notifier_block *nb;
+	struct netlink_ext_ack *extack;
 };
 
 static int fib6_rt_dump(struct fib6_info *rt, struct fib6_dump_arg *arg)
 {
 	if (rt == arg->net->ipv6.fib6_null_entry)
 		return 0;
-	return call_fib6_entry_notifier(arg->nb, FIB_EVENT_ENTRY_ADD, rt);
+	return call_fib6_entry_notifier(arg->nb, FIB_EVENT_ENTRY_ADD,
+					rt, arg->extack);
 }
 
 static int fib6_node_dump(struct fib6_walker *w)
@@ -437,7 +441,8 @@ static int fib6_table_dump(struct net *net, struct fib6_table *tb,
 }
 
 /* Called with rcu_read_lock() */
-int fib6_tables_dump(struct net *net, struct notifier_block *nb)
+int fib6_tables_dump(struct net *net, struct notifier_block *nb,
+		     struct netlink_ext_ack *extack)
 {
 	struct fib6_dump_arg arg;
 	struct fib6_walker *w;
@@ -451,6 +456,7 @@ int fib6_tables_dump(struct net *net, struct notifier_block *nb)
 	w->func = fib6_node_dump;
 	arg.net = net;
 	arg.nb = nb;
+	arg.extack = extack;
 	w->args = &arg;
 
 	for (h = 0; h < FIB6_TABLE_HASHSZ; h++) {
diff --git a/net/ipv6/ip6mr.c b/net/ipv6/ip6mr.c
index 857a89ad4d6c..bfa49ff70531 100644
--- a/net/ipv6/ip6mr.c
+++ b/net/ipv6/ip6mr.c
@@ -265,9 +265,10 @@ static void __net_exit ip6mr_rules_exit(struct net *net)
 	rtnl_unlock();
 }
 
-static int ip6mr_rules_dump(struct net *net, struct notifier_block *nb)
+static int ip6mr_rules_dump(struct net *net, struct notifier_block *nb,
+			    struct netlink_ext_ack *extack)
 {
-	return fib_rules_dump(net, nb, RTNL_FAMILY_IP6MR);
+	return fib_rules_dump(net, nb, RTNL_FAMILY_IP6MR, extack);
 }
 
 static unsigned int ip6mr_rules_seq_read(struct net *net)
@@ -324,7 +325,8 @@ static void __net_exit ip6mr_rules_exit(struct net *net)
 	rtnl_unlock();
 }
 
-static int ip6mr_rules_dump(struct net *net, struct notifier_block *nb)
+static int ip6mr_rules_dump(struct net *net, struct notifier_block *nb,
+			    struct netlink_ext_ack *extack)
 {
 	return 0;
 }
@@ -1256,10 +1258,11 @@ static unsigned int ip6mr_seq_read(struct net *net)
 	return net->ipv6.ipmr_seq + ip6mr_rules_seq_read(net);
 }
 
-static int ip6mr_dump(struct net *net, struct notifier_block *nb)
+static int ip6mr_dump(struct net *net, struct notifier_block *nb,
+		      struct netlink_ext_ack *extack)
 {
 	return mr_dump(net, nb, RTNL_FAMILY_IP6MR, ip6mr_rules_dump,
-		       ip6mr_mr_table_iter, &mrt_lock);
+		       ip6mr_mr_table_iter, &mrt_lock, extack);
 }
 
 static struct notifier_block ip6_mr_notifier = {
-- 
2.21.0

