Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC45DC9B04
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 11:50:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729258AbfJCJts (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 05:49:48 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:35349 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728743AbfJCJtr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 05:49:47 -0400
Received: by mail-wm1-f68.google.com with SMTP id y21so1775236wmi.0
        for <netdev@vger.kernel.org>; Thu, 03 Oct 2019 02:49:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FApVj4fJ1cHF1yo1sZsdHND/ccOQkceOxVDLMRP9Kcs=;
        b=hNsFrG2PjJ/GCvbQYIzofH/oXQNRL74A50Efw2Cwrg8WjFMrBtKOcBHgKxPzXKmO/D
         KmbfzF55CNTm6cU10OsJbye8zO4jdUp7jeLg8HDkXjyySbiMR8+tmJRwBSlg6A2tUQF0
         lwF23A+MAI/r1zILbnsPhHTaLGe/NmLLFe0ybSN6B48pM29k6ESH0bMS6s/6KKD84V32
         vCdrd2/MvmSbsN/d9AGVFQcJwbyTKiof/LkK7XST03b8OZdG1RtvhUbFoBy+PzvrV3Wy
         YJF5Cz1J8aEGi57Svh8HGcn3gFwcb1cEdtBHUeh39xObDoLQNTm4gleGJ37a+su7ohYX
         gdFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FApVj4fJ1cHF1yo1sZsdHND/ccOQkceOxVDLMRP9Kcs=;
        b=fWjaW9MlCtWgp3oFz4NqQdpb/F/y2+UY9RBUGJlxLmtZ8jCX5Q9oizXmt1h9Mw5148
         2vXX8w5h3CTH0Y1eSjbGo/N85UExbxzeTWvYddcYUeUo7R9F6HA6PujSEkxOBfyHXbVL
         0VWY82nrv0KZAE0wo+QO22kc+dDL90on/OV3bQtHABSKpI/y+PXDB5stQWguHFqaPTSc
         HkpEVEyEv7vkkrcNyJQl10R4N28xWxwoIOB9WIXr0VUKBuOf+k0kzKb4VFLTqCIQh66+
         vjwFnscaW2oqe8HN+ILg75dYJZarUTm2Yo8c5Y3ndZ0pquRDdZ3xpUwMXsDIrDgkdgKR
         3mnw==
X-Gm-Message-State: APjAAAXPgcCBVfjyscKbIlHyq1MGoAbsn9tDuXkjejUkmhcGWBg7bY7r
        JQ0xwJSsDK9muga2blECg0EMeLctzRI=
X-Google-Smtp-Source: APXvYqz/UbtwFv3oUBoJNyV5xD67+ylAOjhkmwfuHt93USD8VwXlOzW9ywhAk5RnI6PTRIJRB+dPkw==
X-Received: by 2002:a1c:e906:: with SMTP id q6mr5860526wmc.136.1570096184340;
        Thu, 03 Oct 2019 02:49:44 -0700 (PDT)
Received: from localhost ([85.163.43.78])
        by smtp.gmail.com with ESMTPSA id c4sm2946656wru.31.2019.10.03.02.49.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Oct 2019 02:49:43 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, idosch@mellanox.com, dsahern@gmail.com,
        jakub.kicinski@netronome.com, tariqt@mellanox.com,
        saeedm@mellanox.com, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        shuah@kernel.org, mlxsw@mellanox.com
Subject: [patch net-next v3 02/15] net: fib_notifier: make FIB notifier per-netns
Date:   Thu,  3 Oct 2019 11:49:27 +0200
Message-Id: <20191003094940.9797-3-jiri@resnulli.us>
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

Currently all users of FIB notifier only cares about events in init_net.
Later in this patchset, users get interested in other namespaces too.
However, for every registered block user is interested only about one
namespace. Make the FIB notifier registration per-netns and avoid
unnecessary calls of notifier block for other namespaces.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
v1->v2:
- s/cares/care/ in the patch description
- remove forgotten struct net pointer from struct fib_notifier_info
- remove forgotten net initialization from mr_call_vif_notifiers(),
  mr_call_mfc_notifiers()
- remove forgotten info->net use in mlxsw_sp_router_fib_rule_event()
- move removal of "int err" from fib_net_dump inner loop from the next
  patch
---
 .../net/ethernet/mellanox/mlx5/core/lag_mp.c  |  7 +-
 .../ethernet/mellanox/mlxsw/spectrum_router.c |  9 +-
 drivers/net/ethernet/rocker/rocker_main.c     |  9 +-
 drivers/net/netdevsim/fib.c                   |  8 +-
 include/linux/mroute_base.h                   | 10 +--
 include/net/fib_notifier.h                    |  7 +-
 include/net/ip6_fib.h                         |  2 +-
 include/net/ip_fib.h                          |  2 +-
 net/core/fib_notifier.c                       | 87 +++++++++----------
 net/core/fib_rules.c                          |  7 +-
 net/ipv4/fib_notifier.c                       |  4 +-
 net/ipv4/fib_trie.c                           | 17 ++--
 net/ipv4/ipmr_base.c                          |  4 +-
 net/ipv6/fib6_notifier.c                      |  4 +-
 net/ipv6/ip6_fib.c                            |  6 +-
 15 files changed, 78 insertions(+), 105 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c b/drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c
index 5d20d615663e..fe0cc969cf94 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c
@@ -248,9 +248,6 @@ static int mlx5_lag_fib_event(struct notifier_block *nb,
 	struct net_device *fib_dev;
 	struct fib_info *fi;
 
-	if (!net_eq(info->net, &init_net))
-		return NOTIFY_DONE;
-
 	if (info->family != AF_INET)
 		return NOTIFY_DONE;
 
@@ -311,7 +308,7 @@ int mlx5_lag_mp_init(struct mlx5_lag *ldev)
 		return 0;
 
 	mp->fib_nb.notifier_call = mlx5_lag_fib_event;
-	err = register_fib_notifier(&mp->fib_nb,
+	err = register_fib_notifier(&init_net, &mp->fib_nb,
 				    mlx5_lag_fib_event_flush);
 	if (err)
 		mp->fib_nb.notifier_call = NULL;
@@ -326,6 +323,6 @@ void mlx5_lag_mp_cleanup(struct mlx5_lag *ldev)
 	if (!mp->fib_nb.notifier_call)
 		return;
 
-	unregister_fib_notifier(&mp->fib_nb);
+	unregister_fib_notifier(&init_net, &mp->fib_nb);
 	mp->fib_nb.notifier_call = NULL;
 }
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index a330b369e899..d0db9ea71323 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -6213,7 +6213,7 @@ static int mlxsw_sp_router_fib_rule_event(unsigned long event,
 	rule = fr_info->rule;
 
 	/* Rule only affects locally generated traffic */
-	if (rule->iifindex == info->net->loopback_dev->ifindex)
+	if (rule->iifindex == init_net.loopback_dev->ifindex)
 		return 0;
 
 	switch (info->family) {
@@ -6250,8 +6250,7 @@ static int mlxsw_sp_router_fib_event(struct notifier_block *nb,
 	struct mlxsw_sp_router *router;
 	int err;
 
-	if (!net_eq(info->net, &init_net) ||
-	    (info->family != AF_INET && info->family != AF_INET6 &&
+	if ((info->family != AF_INET && info->family != AF_INET6 &&
 	     info->family != RTNL_FAMILY_IPMR &&
 	     info->family != RTNL_FAMILY_IP6MR))
 		return NOTIFY_DONE;
@@ -8155,7 +8154,7 @@ int mlxsw_sp_router_init(struct mlxsw_sp *mlxsw_sp)
 		goto err_dscp_init;
 
 	mlxsw_sp->router->fib_nb.notifier_call = mlxsw_sp_router_fib_event;
-	err = register_fib_notifier(&mlxsw_sp->router->fib_nb,
+	err = register_fib_notifier(&init_net, &mlxsw_sp->router->fib_nb,
 				    mlxsw_sp_router_fib_dump_flush);
 	if (err)
 		goto err_register_fib_notifier;
@@ -8195,7 +8194,7 @@ int mlxsw_sp_router_init(struct mlxsw_sp *mlxsw_sp)
 
 void mlxsw_sp_router_fini(struct mlxsw_sp *mlxsw_sp)
 {
-	unregister_fib_notifier(&mlxsw_sp->router->fib_nb);
+	unregister_fib_notifier(&init_net, &mlxsw_sp->router->fib_nb);
 	unregister_netevent_notifier(&mlxsw_sp->router->netevent_nb);
 	mlxsw_sp_neigh_fini(mlxsw_sp);
 	mlxsw_sp_vrs_fini(mlxsw_sp);
diff --git a/drivers/net/ethernet/rocker/rocker_main.c b/drivers/net/ethernet/rocker/rocker_main.c
index 786b158bd305..e54f6341a785 100644
--- a/drivers/net/ethernet/rocker/rocker_main.c
+++ b/drivers/net/ethernet/rocker/rocker_main.c
@@ -2189,9 +2189,6 @@ static int rocker_router_fib_event(struct notifier_block *nb,
 	struct rocker_fib_event_work *fib_work;
 	struct fib_notifier_info *info = ptr;
 
-	if (!net_eq(info->net, &init_net))
-		return NOTIFY_DONE;
-
 	if (info->family != AF_INET)
 		return NOTIFY_DONE;
 
@@ -2994,7 +2991,7 @@ static int rocker_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	 * the device, so no need to pass a callback.
 	 */
 	rocker->fib_nb.notifier_call = rocker_router_fib_event;
-	err = register_fib_notifier(&rocker->fib_nb, NULL);
+	err = register_fib_notifier(&init_net, &rocker->fib_nb, NULL);
 	if (err)
 		goto err_register_fib_notifier;
 
@@ -3021,7 +3018,7 @@ static int rocker_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 err_register_switchdev_blocking_notifier:
 	unregister_switchdev_notifier(&rocker_switchdev_notifier);
 err_register_switchdev_notifier:
-	unregister_fib_notifier(&rocker->fib_nb);
+	unregister_fib_notifier(&init_net, &rocker->fib_nb);
 err_register_fib_notifier:
 	rocker_remove_ports(rocker);
 err_probe_ports:
@@ -3057,7 +3054,7 @@ static void rocker_remove(struct pci_dev *pdev)
 	unregister_switchdev_blocking_notifier(nb);
 
 	unregister_switchdev_notifier(&rocker_switchdev_notifier);
-	unregister_fib_notifier(&rocker->fib_nb);
+	unregister_fib_notifier(&init_net, &rocker->fib_nb);
 	rocker_remove_ports(rocker);
 	rocker_write32(rocker, CONTROL, ROCKER_CONTROL_RESET);
 	destroy_workqueue(rocker->rocker_owq);
diff --git a/drivers/net/netdevsim/fib.c b/drivers/net/netdevsim/fib.c
index 7de17e42d77a..01ee9cc54605 100644
--- a/drivers/net/netdevsim/fib.c
+++ b/drivers/net/netdevsim/fib.c
@@ -182,9 +182,6 @@ static int nsim_fib_event_nb(struct notifier_block *nb, unsigned long event,
 	struct fib_notifier_info *info = ptr;
 	int err = 0;
 
-	if (!net_eq(info->net, &init_net))
-		return NOTIFY_DONE;
-
 	switch (event) {
 	case FIB_EVENT_RULE_ADD: /* fall through */
 	case FIB_EVENT_RULE_DEL:
@@ -258,7 +255,8 @@ struct nsim_fib_data *nsim_fib_create(struct devlink *devlink)
 	data->ipv6.rules.max = (u64)-1;
 
 	data->fib_nb.notifier_call = nsim_fib_event_nb;
-	err = register_fib_notifier(&data->fib_nb, nsim_fib_dump_inconsistent);
+	err = register_fib_notifier(&init_net, &data->fib_nb,
+				    nsim_fib_dump_inconsistent);
 	if (err) {
 		pr_err("Failed to register fib notifier\n");
 		goto err_out;
@@ -297,6 +295,6 @@ void nsim_fib_destroy(struct devlink *devlink, struct nsim_fib_data *data)
 					    NSIM_RESOURCE_IPV4_FIB_RULES);
 	devlink_resource_occ_get_unregister(devlink,
 					    NSIM_RESOURCE_IPV4_FIB);
-	unregister_fib_notifier(&data->fib_nb);
+	unregister_fib_notifier(&init_net, &data->fib_nb);
 	kfree(data);
 }
diff --git a/include/linux/mroute_base.h b/include/linux/mroute_base.h
index 34de06b426ef..0931631bbc13 100644
--- a/include/linux/mroute_base.h
+++ b/include/linux/mroute_base.h
@@ -47,7 +47,6 @@ struct vif_entry_notifier_info {
 };
 
 static inline int mr_call_vif_notifier(struct notifier_block *nb,
-				       struct net *net,
 				       unsigned short family,
 				       enum fib_event_type event_type,
 				       struct vif_device *vif,
@@ -56,7 +55,6 @@ static inline int mr_call_vif_notifier(struct notifier_block *nb,
 	struct vif_entry_notifier_info info = {
 		.info = {
 			.family = family,
-			.net = net,
 		},
 		.dev = vif->dev,
 		.vif_index = vif_index,
@@ -64,7 +62,7 @@ static inline int mr_call_vif_notifier(struct notifier_block *nb,
 		.tb_id = tb_id,
 	};
 
-	return call_fib_notifier(nb, net, event_type, &info.info);
+	return call_fib_notifier(nb, event_type, &info.info);
 }
 
 static inline int mr_call_vif_notifiers(struct net *net,
@@ -77,7 +75,6 @@ static inline int mr_call_vif_notifiers(struct net *net,
 	struct vif_entry_notifier_info info = {
 		.info = {
 			.family = family,
-			.net = net,
 		},
 		.dev = vif->dev,
 		.vif_index = vif_index,
@@ -173,7 +170,6 @@ struct mfc_entry_notifier_info {
 };
 
 static inline int mr_call_mfc_notifier(struct notifier_block *nb,
-				       struct net *net,
 				       unsigned short family,
 				       enum fib_event_type event_type,
 				       struct mr_mfc *mfc, u32 tb_id)
@@ -181,13 +177,12 @@ static inline int mr_call_mfc_notifier(struct notifier_block *nb,
 	struct mfc_entry_notifier_info info = {
 		.info = {
 			.family = family,
-			.net = net,
 		},
 		.mfc = mfc,
 		.tb_id = tb_id
 	};
 
-	return call_fib_notifier(nb, net, event_type, &info.info);
+	return call_fib_notifier(nb, event_type, &info.info);
 }
 
 static inline int mr_call_mfc_notifiers(struct net *net,
@@ -199,7 +194,6 @@ static inline int mr_call_mfc_notifiers(struct net *net,
 	struct mfc_entry_notifier_info info = {
 		.info = {
 			.family = family,
-			.net = net,
 		},
 		.mfc = mfc,
 		.tb_id = tb_id
diff --git a/include/net/fib_notifier.h b/include/net/fib_notifier.h
index c49d7bfb5c30..23353f67b2b0 100644
--- a/include/net/fib_notifier.h
+++ b/include/net/fib_notifier.h
@@ -8,7 +8,6 @@
 struct module;
 
 struct fib_notifier_info {
-	struct net *net;
 	int family;
 	struct netlink_ext_ack  *extack;
 };
@@ -35,14 +34,14 @@ struct fib_notifier_ops {
 	struct rcu_head rcu;
 };
 
-int call_fib_notifier(struct notifier_block *nb, struct net *net,
+int call_fib_notifier(struct notifier_block *nb,
 		      enum fib_event_type event_type,
 		      struct fib_notifier_info *info);
 int call_fib_notifiers(struct net *net, enum fib_event_type event_type,
 		       struct fib_notifier_info *info);
-int register_fib_notifier(struct notifier_block *nb,
+int register_fib_notifier(struct net *net, struct notifier_block *nb,
 			  void (*cb)(struct notifier_block *nb));
-int unregister_fib_notifier(struct notifier_block *nb);
+int unregister_fib_notifier(struct net *net, struct notifier_block *nb);
 struct fib_notifier_ops *
 fib_notifier_ops_register(const struct fib_notifier_ops *tmpl, struct net *net);
 void fib_notifier_ops_unregister(struct fib_notifier_ops *ops);
diff --git a/include/net/ip6_fib.h b/include/net/ip6_fib.h
index 4b5656c71abc..14e9fca0e326 100644
--- a/include/net/ip6_fib.h
+++ b/include/net/ip6_fib.h
@@ -478,7 +478,7 @@ struct ipv6_route_iter {
 
 extern const struct seq_operations ipv6_route_seq_ops;
 
-int call_fib6_notifier(struct notifier_block *nb, struct net *net,
+int call_fib6_notifier(struct notifier_block *nb,
 		       enum fib_event_type event_type,
 		       struct fib_notifier_info *info);
 int call_fib6_notifiers(struct net *net, enum fib_event_type event_type,
diff --git a/include/net/ip_fib.h b/include/net/ip_fib.h
index ab1ca9e238d2..a9df85304f40 100644
--- a/include/net/ip_fib.h
+++ b/include/net/ip_fib.h
@@ -219,7 +219,7 @@ struct fib_nh_notifier_info {
 	struct fib_nh *fib_nh;
 };
 
-int call_fib4_notifier(struct notifier_block *nb, struct net *net,
+int call_fib4_notifier(struct notifier_block *nb,
 		       enum fib_event_type event_type,
 		       struct fib_notifier_info *info);
 int call_fib4_notifiers(struct net *net, enum fib_event_type event_type,
diff --git a/net/core/fib_notifier.c b/net/core/fib_notifier.c
index 470a606d5e8d..fbd029425638 100644
--- a/net/core/fib_notifier.c
+++ b/net/core/fib_notifier.c
@@ -12,17 +12,15 @@ static unsigned int fib_notifier_net_id;
 
 struct fib_notifier_net {
 	struct list_head fib_notifier_ops;
+	struct atomic_notifier_head fib_chain;
 };
 
-static ATOMIC_NOTIFIER_HEAD(fib_chain);
-
-int call_fib_notifier(struct notifier_block *nb, struct net *net,
+int call_fib_notifier(struct notifier_block *nb,
 		      enum fib_event_type event_type,
 		      struct fib_notifier_info *info)
 {
 	int err;
 
-	info->net = net;
 	err = nb->notifier_call(nb, event_type, info);
 	return notifier_to_errno(err);
 }
@@ -31,35 +29,29 @@ EXPORT_SYMBOL(call_fib_notifier);
 int call_fib_notifiers(struct net *net, enum fib_event_type event_type,
 		       struct fib_notifier_info *info)
 {
+	struct fib_notifier_net *fn_net = net_generic(net, fib_notifier_net_id);
 	int err;
 
-	info->net = net;
-	err = atomic_notifier_call_chain(&fib_chain, event_type, info);
+	err = atomic_notifier_call_chain(&fn_net->fib_chain, event_type, info);
 	return notifier_to_errno(err);
 }
 EXPORT_SYMBOL(call_fib_notifiers);
 
-static unsigned int fib_seq_sum(void)
+static unsigned int fib_seq_sum(struct net *net)
 {
-	struct fib_notifier_net *fn_net;
+	struct fib_notifier_net *fn_net = net_generic(net, fib_notifier_net_id);
 	struct fib_notifier_ops *ops;
 	unsigned int fib_seq = 0;
-	struct net *net;
 
 	rtnl_lock();
-	down_read(&net_rwsem);
-	for_each_net(net) {
-		fn_net = net_generic(net, fib_notifier_net_id);
-		rcu_read_lock();
-		list_for_each_entry_rcu(ops, &fn_net->fib_notifier_ops, list) {
-			if (!try_module_get(ops->owner))
-				continue;
-			fib_seq += ops->fib_seq_read(net);
-			module_put(ops->owner);
-		}
-		rcu_read_unlock();
+	rcu_read_lock();
+	list_for_each_entry_rcu(ops, &fn_net->fib_notifier_ops, list) {
+		if (!try_module_get(ops->owner))
+			continue;
+		fib_seq += ops->fib_seq_read(net);
+		module_put(ops->owner);
 	}
-	up_read(&net_rwsem);
+	rcu_read_unlock();
 	rtnl_unlock();
 
 	return fib_seq;
@@ -69,68 +61,66 @@ static int fib_net_dump(struct net *net, struct notifier_block *nb)
 {
 	struct fib_notifier_net *fn_net = net_generic(net, fib_notifier_net_id);
 	struct fib_notifier_ops *ops;
+	int err = 0;
 
+	rcu_read_lock();
 	list_for_each_entry_rcu(ops, &fn_net->fib_notifier_ops, list) {
-		int err;
-
 		if (!try_module_get(ops->owner))
 			continue;
 		err = ops->fib_dump(net, nb);
 		module_put(ops->owner);
 		if (err)
-			return err;
+			goto unlock;
 	}
 
-	return 0;
+unlock:
+	rcu_read_unlock();
+
+	return err;
 }
 
-static bool fib_dump_is_consistent(struct notifier_block *nb,
+static bool fib_dump_is_consistent(struct net *net, struct notifier_block *nb,
 				   void (*cb)(struct notifier_block *nb),
 				   unsigned int fib_seq)
 {
-	atomic_notifier_chain_register(&fib_chain, nb);
-	if (fib_seq == fib_seq_sum())
+	struct fib_notifier_net *fn_net = net_generic(net, fib_notifier_net_id);
+
+	atomic_notifier_chain_register(&fn_net->fib_chain, nb);
+	if (fib_seq == fib_seq_sum(net))
 		return true;
-	atomic_notifier_chain_unregister(&fib_chain, nb);
+	atomic_notifier_chain_unregister(&fn_net->fib_chain, nb);
 	if (cb)
 		cb(nb);
 	return false;
 }
 
 #define FIB_DUMP_MAX_RETRIES 5
-int register_fib_notifier(struct notifier_block *nb,
+int register_fib_notifier(struct net *net, struct notifier_block *nb,
 			  void (*cb)(struct notifier_block *nb))
 {
 	int retries = 0;
 	int err;
 
 	do {
-		unsigned int fib_seq = fib_seq_sum();
-		struct net *net;
-
-		rcu_read_lock();
-		for_each_net_rcu(net) {
-			err = fib_net_dump(net, nb);
-			if (err)
-				goto err_fib_net_dump;
-		}
-		rcu_read_unlock();
-
-		if (fib_dump_is_consistent(nb, cb, fib_seq))
+		unsigned int fib_seq = fib_seq_sum(net);
+
+		err = fib_net_dump(net, nb);
+		if (err)
+			return err;
+
+		if (fib_dump_is_consistent(net, nb, cb, fib_seq))
 			return 0;
 	} while (++retries < FIB_DUMP_MAX_RETRIES);
 
 	return -EBUSY;
-
-err_fib_net_dump:
-	rcu_read_unlock();
-	return err;
 }
 EXPORT_SYMBOL(register_fib_notifier);
 
-int unregister_fib_notifier(struct notifier_block *nb)
+int unregister_fib_notifier(struct net *net, struct notifier_block *nb)
 {
-	return atomic_notifier_chain_unregister(&fib_chain, nb);
+	struct fib_notifier_net *fn_net = net_generic(net, fib_notifier_net_id);
+
+	return atomic_notifier_chain_unregister(&fn_net->fib_chain, nb);
 }
 EXPORT_SYMBOL(unregister_fib_notifier);
 
@@ -181,6 +171,7 @@ static int __net_init fib_notifier_net_init(struct net *net)
 	struct fib_notifier_net *fn_net = net_generic(net, fib_notifier_net_id);
 
 	INIT_LIST_HEAD(&fn_net->fib_notifier_ops);
+	ATOMIC_INIT_NOTIFIER_HEAD(&fn_net->fib_chain);
 	return 0;
 }
 
diff --git a/net/core/fib_rules.c b/net/core/fib_rules.c
index dd220ce7ca7a..28cbf07102bc 100644
--- a/net/core/fib_rules.c
+++ b/net/core/fib_rules.c
@@ -321,7 +321,7 @@ int fib_rules_lookup(struct fib_rules_ops *ops, struct flowi *fl,
 }
 EXPORT_SYMBOL_GPL(fib_rules_lookup);
 
-static int call_fib_rule_notifier(struct notifier_block *nb, struct net *net,
+static int call_fib_rule_notifier(struct notifier_block *nb,
 				  enum fib_event_type event_type,
 				  struct fib_rule *rule, int family)
 {
@@ -330,7 +330,7 @@ static int call_fib_rule_notifier(struct notifier_block *nb, struct net *net,
 		.rule = rule,
 	};
 
-	return call_fib_notifier(nb, net, event_type, &info.info);
+	return call_fib_notifier(nb, event_type, &info.info);
 }
 
 static int call_fib_rule_notifiers(struct net *net,
@@ -359,8 +359,7 @@ int fib_rules_dump(struct net *net, struct notifier_block *nb, int family)
 	if (!ops)
 		return -EAFNOSUPPORT;
 	list_for_each_entry_rcu(rule, &ops->rules_list, list)
-		call_fib_rule_notifier(nb, net, FIB_EVENT_RULE_ADD, rule,
-				       family);
+		call_fib_rule_notifier(nb, FIB_EVENT_RULE_ADD, rule, family);
 	rules_ops_put(ops);
 
 	return 0;
diff --git a/net/ipv4/fib_notifier.c b/net/ipv4/fib_notifier.c
index b804ccbdb241..1a128c1346fb 100644
--- a/net/ipv4/fib_notifier.c
+++ b/net/ipv4/fib_notifier.c
@@ -9,12 +9,12 @@
 #include <net/netns/ipv4.h>
 #include <net/ip_fib.h>
 
-int call_fib4_notifier(struct notifier_block *nb, struct net *net,
+int call_fib4_notifier(struct notifier_block *nb,
 		       enum fib_event_type event_type,
 		       struct fib_notifier_info *info)
 {
 	info->family = AF_INET;
-	return call_fib_notifier(nb, net, event_type, info);
+	return call_fib_notifier(nb, event_type, info);
 }
 
 int call_fib4_notifiers(struct net *net, enum fib_event_type event_type,
diff --git a/net/ipv4/fib_trie.c b/net/ipv4/fib_trie.c
index 1ab2fb6bb37d..5b600b2a2aa3 100644
--- a/net/ipv4/fib_trie.c
+++ b/net/ipv4/fib_trie.c
@@ -74,7 +74,7 @@
 #include <trace/events/fib.h>
 #include "fib_lookup.h"
 
-static int call_fib_entry_notifier(struct notifier_block *nb, struct net *net,
+static int call_fib_entry_notifier(struct notifier_block *nb,
 				   enum fib_event_type event_type, u32 dst,
 				   int dst_len, struct fib_alias *fa)
 {
@@ -86,7 +86,7 @@ static int call_fib_entry_notifier(struct notifier_block *nb, struct net *net,
 		.type = fa->fa_type,
 		.tb_id = fa->tb_id,
 	};
-	return call_fib4_notifier(nb, net, event_type, &info.info);
+	return call_fib4_notifier(nb, event_type, &info.info);
 }
 
 static int call_fib_entry_notifiers(struct net *net,
@@ -2015,8 +2015,8 @@ void fib_info_notify_update(struct net *net, struct nl_info *info)
 	}
 }
 
-static void fib_leaf_notify(struct net *net, struct key_vector *l,
-			    struct fib_table *tb, struct notifier_block *nb)
+static void fib_leaf_notify(struct key_vector *l, struct fib_table *tb,
+			    struct notifier_block *nb)
 {
 	struct fib_alias *fa;
 
@@ -2032,20 +2032,19 @@ static void fib_leaf_notify(struct net *net, struct key_vector *l,
 		if (tb->tb_id != fa->tb_id)
 			continue;
 
-		call_fib_entry_notifier(nb, net, FIB_EVENT_ENTRY_ADD, l->key,
+		call_fib_entry_notifier(nb, FIB_EVENT_ENTRY_ADD, l->key,
 					KEYLENGTH - fa->fa_slen, fa);
 	}
 }
 
-static void fib_table_notify(struct net *net, struct fib_table *tb,
-			     struct notifier_block *nb)
+static void fib_table_notify(struct fib_table *tb, struct notifier_block *nb)
 {
 	struct trie *t = (struct trie *)tb->tb_data;
 	struct key_vector *l, *tp = t->kv;
 	t_key key = 0;
 
 	while ((l = leaf_walk_rcu(&tp, key)) != NULL) {
-		fib_leaf_notify(net, l, tb, nb);
+		fib_leaf_notify(l, tb, nb);
 
 		key = l->key + 1;
 		/* stop in case of wrap around */
@@ -2063,7 +2062,7 @@ void fib_notify(struct net *net, struct notifier_block *nb)
 		struct fib_table *tb;
 
 		hlist_for_each_entry_rcu(tb, head, tb_hlist)
-			fib_table_notify(net, tb, nb);
+			fib_table_notify(tb, nb);
 	}
 }
 
diff --git a/net/ipv4/ipmr_base.c b/net/ipv4/ipmr_base.c
index ea48bd15a575..4dcc3214e3cc 100644
--- a/net/ipv4/ipmr_base.c
+++ b/net/ipv4/ipmr_base.c
@@ -409,7 +409,7 @@ int mr_dump(struct net *net, struct notifier_block *nb, unsigned short family,
 			if (!v->dev)
 				continue;
 
-			mr_call_vif_notifier(nb, net, family,
+			mr_call_vif_notifier(nb, family,
 					     FIB_EVENT_VIF_ADD,
 					     v, vifi, mrt->id);
 		}
@@ -417,7 +417,7 @@ int mr_dump(struct net *net, struct notifier_block *nb, unsigned short family,
 
 		/* Notify on table MFC entries */
 		list_for_each_entry_rcu(mfc, &mrt->mfc_cache_list, list)
-			mr_call_mfc_notifier(nb, net, family,
+			mr_call_mfc_notifier(nb, family,
 					     FIB_EVENT_ENTRY_ADD,
 					     mfc, mrt->id);
 	}
diff --git a/net/ipv6/fib6_notifier.c b/net/ipv6/fib6_notifier.c
index 05f82baaa99e..4fe79296999a 100644
--- a/net/ipv6/fib6_notifier.c
+++ b/net/ipv6/fib6_notifier.c
@@ -7,12 +7,12 @@
 #include <net/netns/ipv6.h>
 #include <net/ip6_fib.h>
 
-int call_fib6_notifier(struct notifier_block *nb, struct net *net,
+int call_fib6_notifier(struct notifier_block *nb,
 		       enum fib_event_type event_type,
 		       struct fib_notifier_info *info)
 {
 	info->family = AF_INET6;
-	return call_fib_notifier(nb, net, event_type, info);
+	return call_fib_notifier(nb, event_type, info);
 }
 
 int call_fib6_notifiers(struct net *net, enum fib_event_type event_type,
diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
index 6e2af411cd9c..f6fae48b2e18 100644
--- a/net/ipv6/ip6_fib.c
+++ b/net/ipv6/ip6_fib.c
@@ -357,7 +357,7 @@ unsigned int fib6_tables_seq_read(struct net *net)
 	return fib_seq;
 }
 
-static int call_fib6_entry_notifier(struct notifier_block *nb, struct net *net,
+static int call_fib6_entry_notifier(struct notifier_block *nb,
 				    enum fib_event_type event_type,
 				    struct fib6_info *rt)
 {
@@ -365,7 +365,7 @@ static int call_fib6_entry_notifier(struct notifier_block *nb, struct net *net,
 		.rt = rt,
 	};
 
-	return call_fib6_notifier(nb, net, event_type, &info.info);
+	return call_fib6_notifier(nb, event_type, &info.info);
 }
 
 int call_fib6_entry_notifiers(struct net *net,
@@ -407,7 +407,7 @@ static void fib6_rt_dump(struct fib6_info *rt, struct fib6_dump_arg *arg)
 {
 	if (rt == arg->net->ipv6.fib6_null_entry)
 		return;
-	call_fib6_entry_notifier(arg->nb, arg->net, FIB_EVENT_ENTRY_ADD, rt);
+	call_fib6_entry_notifier(arg->nb, FIB_EVENT_ENTRY_ADD, rt);
 }
 
 static int fib6_node_dump(struct fib6_walker *w)
-- 
2.21.0

