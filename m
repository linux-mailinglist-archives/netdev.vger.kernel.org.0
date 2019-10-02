Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5320BC8DFB
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 18:13:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728303AbfJBQM5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 12:12:57 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:55898 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728010AbfJBQMv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 12:12:51 -0400
Received: by mail-wm1-f65.google.com with SMTP id a6so7813971wma.5
        for <netdev@vger.kernel.org>; Wed, 02 Oct 2019 09:12:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=c2tErON4SWBUK4cfgbHOpcPPOqqGK3mBq7qFouxL/pM=;
        b=BdJwikzssXt6KimyvOwppdfJIXchBTiaOJi3USJPhgSJqfv7c4/aBggEPpRWjFZCZu
         hGjoFi8k+0H22WiV7v8M7fVU+VAZ3ziHGlIpAY3mapCHepemag5xiZPiD301CCVn86PG
         sXNASIVa5KnGzGdXEyAIUVZzu67xZ2kM7a/+yFv18eiseeYCXpI9i4+VqW0zEtNlavVc
         jQVoU5V7dQX4ij4H/nvGnMMEuIXVerJHJpVaEJJrcNIM91GjdHeuh89dmU46acQ9CAwF
         Bp2GMMLCuO5Bk12TANoJyYnq1BbNVX+BTIhXwYV3cXkz26ZNsM0MfpGqggV0mHwvjlbd
         Ez6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=c2tErON4SWBUK4cfgbHOpcPPOqqGK3mBq7qFouxL/pM=;
        b=uSOTkW8ECITPZcYhP1iLNdb4JFi32g7+JFrnKGbidMC7ZyELUZnlLQaU+x3QK195wL
         NeJQkRfo0V2mTsUH/cHXlHnLwZRbDjoMKG5JKAUCFdCeqEBFXpmJfkb26o7Ks0UjXVqt
         7x0TZ7Zv6QcpzDXS62HZ5n2SOqq5Q6MWj2b/0Xak3a4wC8NCln2yd4pyyw9gyzWyUJ4o
         k+6ZInSqGutBqH7TbmwenKn5Sd7adCPXvBgls4tiAf/UJVpYojBGye+Idkxk19j/Oif6
         Z1YFCYBhOS09GJKT02eYMdMLeHUtnG4m5xB67OKZbhipbFz/Nfb32xRsCnkAnsMMkjlY
         DuUw==
X-Gm-Message-State: APjAAAVdTRgUjFR7n0DBTRLl8aeDyxFCnunMX/PgpqFJAbnBYk3RSMvS
        dm2I4eXS9vLrutu+t1jp7/wT7dV6TyM=
X-Google-Smtp-Source: APXvYqx9z3+2WmX6LfeP3hj/xCEu7lurxir0hWM3tb6t4stmN2r/fnNat+t+Kw8LkstwRhH1UNlzeQ==
X-Received: by 2002:a1c:1aca:: with SMTP id a193mr3642591wma.120.1570032768089;
        Wed, 02 Oct 2019 09:12:48 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id o188sm14366857wma.14.2019.10.02.09.12.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Oct 2019 09:12:47 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, idosch@mellanox.com, dsahern@gmail.com,
        jakub.kicinski@netronome.com, tariqt@mellanox.com,
        saeedm@mellanox.com, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        shuah@kernel.org, mlxsw@mellanox.com
Subject: [patch net-next v2 14/15] net: devlink: allow to change namespaces during reload
Date:   Wed,  2 Oct 2019 18:12:30 +0200
Message-Id: <20191002161231.2987-15-jiri@resnulli.us>
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

All devlink instances are created in init_net and stay there for a
lifetime. Allow user to be able to move devlink instances into
namespaces during devlink reload operation. That ensures proper
re-instantiation of driver objects, including netdevices.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
v1->v2:
- removed unused devlink arg from devlink_netns_get()
- pass "netns_change" indication flag to reload_down() op and fix driver
  being able to say "no" to netns change
---
 drivers/net/ethernet/mellanox/mlx4/main.c  |   6 +-
 drivers/net/ethernet/mellanox/mlxsw/core.c |   1 +
 drivers/net/netdevsim/dev.c                |   2 +-
 include/net/devlink.h                      |   2 +-
 include/uapi/linux/devlink.h               |   4 +
 net/core/devlink.c                         | 154 +++++++++++++++++++--
 6 files changed, 158 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/main.c b/drivers/net/ethernet/mellanox/mlx4/main.c
index fce9b3a24347..22c72fb7206a 100644
--- a/drivers/net/ethernet/mellanox/mlx4/main.c
+++ b/drivers/net/ethernet/mellanox/mlx4/main.c
@@ -3935,13 +3935,17 @@ static void mlx4_restart_one_down(struct pci_dev *pdev);
 static int mlx4_restart_one_up(struct pci_dev *pdev, bool reload,
 			       struct devlink *devlink);
 
-static int mlx4_devlink_reload_down(struct devlink *devlink,
+static int mlx4_devlink_reload_down(struct devlink *devlink, bool netns_change,
 				    struct netlink_ext_ack *extack)
 {
 	struct mlx4_priv *priv = devlink_priv(devlink);
 	struct mlx4_dev *dev = &priv->dev;
 	struct mlx4_dev_persistent *persist = dev->persist;
 
+	if (netns_change) {
+		NL_SET_ERR_MSG_MOD(extack, "Namespace change is not supported");
+		return -EOPNOTSUPP;
+	}
 	if (persist->num_vfs)
 		mlx4_warn(persist->dev, "Reload performed on PF, will cause reset on operating Virtual Functions\n");
 	mlx4_restart_one_down(persist->pdev);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index 1e61a012ca43..1c29522a2af3 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -985,6 +985,7 @@ mlxsw_devlink_info_get(struct devlink *devlink, struct devlink_info_req *req,
 
 static int
 mlxsw_devlink_core_bus_device_reload_down(struct devlink *devlink,
+					  bool netns_change,
 					  struct netlink_ext_ack *extack)
 {
 	struct mlxsw_core *mlxsw_core = devlink_priv(devlink);
diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index c04312359e4f..8bfd89054016 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -474,7 +474,7 @@ nsim_dev_create(struct nsim_bus_dev *nsim_bus_dev, struct nsim_dev *nsim_dev,
 		struct netlink_ext_ack *extack);
 static void nsim_dev_destroy(struct nsim_dev *nsim_dev, bool reload);
 
-static int nsim_dev_reload_down(struct devlink *devlink,
+static int nsim_dev_reload_down(struct devlink *devlink, bool netns_change,
 				struct netlink_ext_ack *extack)
 {
 	struct nsim_dev *nsim_dev = devlink_priv(devlink);
diff --git a/include/net/devlink.h b/include/net/devlink.h
index 5ac2be0f0857..3c9d4a063c98 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -643,7 +643,7 @@ enum devlink_trap_group_generic_id {
 	}
 
 struct devlink_ops {
-	int (*reload_down)(struct devlink *devlink,
+	int (*reload_down)(struct devlink *devlink, bool netns_change,
 			   struct netlink_ext_ack *extack);
 	int (*reload_up)(struct devlink *devlink,
 			 struct netlink_ext_ack *extack);
diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index 580b7a2e40e1..b558ea88b766 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -421,6 +421,10 @@ enum devlink_attr {
 
 	DEVLINK_ATTR_RELOAD_FAILED,			/* u8 0 or 1 */
 
+	DEVLINK_ATTR_NETNS_FD,			/* u32 */
+	DEVLINK_ATTR_NETNS_PID,			/* u32 */
+	DEVLINK_ATTR_NETNS_ID,			/* u32 */
+
 	/* add new attributes above here, update the policy in devlink.c */
 
 	__DEVLINK_ATTR_MAX,
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 362cbbcca225..c4d8c4ab0fb5 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -435,8 +435,16 @@ static void devlink_nl_post_doit(const struct genl_ops *ops,
 {
 	struct devlink *devlink;
 
-	devlink = devlink_get_from_info(info);
-	if (~ops->internal_flags & DEVLINK_NL_FLAG_NO_LOCK)
+	/* When devlink changes netns, it would not be found
+	 * by devlink_get_from_info(). So try if it is stored first.
+	 */
+	if (ops->internal_flags & DEVLINK_NL_FLAG_NEED_DEVLINK) {
+		devlink = info->user_ptr[0];
+	} else {
+		devlink = devlink_get_from_info(info);
+		WARN_ON(IS_ERR(devlink));
+	}
+	if (!IS_ERR(devlink) && ~ops->internal_flags & DEVLINK_NL_FLAG_NO_LOCK)
 		mutex_unlock(&devlink->lock);
 	mutex_unlock(&devlink_mutex);
 }
@@ -2675,6 +2683,72 @@ devlink_resources_validate(struct devlink *devlink,
 	return err;
 }
 
+static struct net *devlink_netns_get(struct sk_buff *skb,
+				     struct genl_info *info)
+{
+	struct nlattr *netns_pid_attr = info->attrs[DEVLINK_ATTR_NETNS_PID];
+	struct nlattr *netns_fd_attr = info->attrs[DEVLINK_ATTR_NETNS_FD];
+	struct nlattr *netns_id_attr = info->attrs[DEVLINK_ATTR_NETNS_ID];
+	struct net *net;
+
+	if (!!netns_pid_attr + !!netns_fd_attr + !!netns_id_attr > 1) {
+		NL_SET_ERR_MSG(info->extack, "multiple netns identifying attributes specified");
+		return ERR_PTR(-EINVAL);
+	}
+
+	if (netns_pid_attr) {
+		net = get_net_ns_by_pid(nla_get_u32(netns_pid_attr));
+	} else if (netns_fd_attr) {
+		net = get_net_ns_by_fd(nla_get_u32(netns_fd_attr));
+	} else if (netns_id_attr) {
+		net = get_net_ns_by_id(sock_net(skb->sk),
+				       nla_get_u32(netns_id_attr));
+		if (!net)
+			net = ERR_PTR(-EINVAL);
+	} else {
+		WARN_ON(1);
+		net = ERR_PTR(-EINVAL);
+	}
+	if (IS_ERR(net)) {
+		NL_SET_ERR_MSG(info->extack, "Unknown network namespace");
+		return ERR_PTR(-EINVAL);
+	}
+	if (!netlink_ns_capable(skb, net->user_ns, CAP_NET_ADMIN)) {
+		put_net(net);
+		return ERR_PTR(-EPERM);
+	}
+	return net;
+}
+
+static void devlink_param_notify(struct devlink *devlink,
+				 unsigned int port_index,
+				 struct devlink_param_item *param_item,
+				 enum devlink_command cmd);
+
+static void devlink_reload_netns_change(struct devlink *devlink,
+					struct net *dest_net)
+{
+	struct devlink_param_item *param_item;
+
+	/* Userspace needs to be notified about devlink objects
+	 * removed from original and entering new network namespace.
+	 * The rest of the devlink objects are re-created during
+	 * reload process so the notifications are generated separatelly.
+	 */
+
+	list_for_each_entry(param_item, &devlink->param_list, list)
+		devlink_param_notify(devlink, 0, param_item,
+				     DEVLINK_CMD_PARAM_DEL);
+	devlink_notify(devlink, DEVLINK_CMD_DEL);
+
+	devlink_net_set(devlink, dest_net);
+
+	devlink_notify(devlink, DEVLINK_CMD_NEW);
+	list_for_each_entry(param_item, &devlink->param_list, list)
+		devlink_param_notify(devlink, 0, param_item,
+				     DEVLINK_CMD_PARAM_NEW);
+}
+
 static bool devlink_reload_supported(struct devlink *devlink)
 {
 	return devlink->ops->reload_down && devlink->ops->reload_up;
@@ -2695,9 +2769,27 @@ bool devlink_is_reload_failed(const struct devlink *devlink)
 }
 EXPORT_SYMBOL_GPL(devlink_is_reload_failed);
 
+static int devlink_reload(struct devlink *devlink, struct net *dest_net,
+			  struct netlink_ext_ack *extack)
+{
+	int err;
+
+	err = devlink->ops->reload_down(devlink, !!dest_net, extack);
+	if (err)
+		return err;
+
+	if (dest_net && !net_eq(dest_net, devlink_net(devlink)))
+		devlink_reload_netns_change(devlink, dest_net);
+
+	err = devlink->ops->reload_up(devlink, extack);
+	devlink_reload_failed_set(devlink, !!err);
+	return err;
+}
+
 static int devlink_nl_cmd_reload(struct sk_buff *skb, struct genl_info *info)
 {
 	struct devlink *devlink = info->user_ptr[0];
+	struct net *dest_net = NULL;
 	int err;
 
 	if (!devlink_reload_supported(devlink))
@@ -2708,11 +2800,20 @@ static int devlink_nl_cmd_reload(struct sk_buff *skb, struct genl_info *info)
 		NL_SET_ERR_MSG_MOD(info->extack, "resources size validation failed");
 		return err;
 	}
-	err = devlink->ops->reload_down(devlink, info->extack);
-	if (err)
-		return err;
-	err = devlink->ops->reload_up(devlink, info->extack);
-	devlink_reload_failed_set(devlink, !!err);
+
+	if (info->attrs[DEVLINK_ATTR_NETNS_PID] ||
+	    info->attrs[DEVLINK_ATTR_NETNS_FD] ||
+	    info->attrs[DEVLINK_ATTR_NETNS_ID]) {
+		dest_net = devlink_netns_get(skb, info);
+		if (IS_ERR(dest_net))
+			return PTR_ERR(dest_net);
+	}
+
+	err = devlink_reload(devlink, dest_net, info->extack);
+
+	if (dest_net)
+		put_net(dest_net);
+
 	return err;
 }
 
@@ -5794,6 +5895,9 @@ static const struct nla_policy devlink_nl_policy[DEVLINK_ATTR_MAX + 1] = {
 	[DEVLINK_ATTR_TRAP_NAME] = { .type = NLA_NUL_STRING },
 	[DEVLINK_ATTR_TRAP_ACTION] = { .type = NLA_U8 },
 	[DEVLINK_ATTR_TRAP_GROUP_NAME] = { .type = NLA_NUL_STRING },
+	[DEVLINK_ATTR_NETNS_PID] = { .type = NLA_U32 },
+	[DEVLINK_ATTR_NETNS_FD] = { .type = NLA_U32 },
+	[DEVLINK_ATTR_NETNS_ID] = { .type = NLA_U32 },
 };
 
 static const struct genl_ops devlink_nl_ops[] = {
@@ -8061,9 +8165,43 @@ int devlink_compat_switch_id_get(struct net_device *dev,
 	return 0;
 }
 
+static void __net_exit devlink_pernet_pre_exit(struct net *net)
+{
+	struct devlink *devlink;
+	int err;
+
+	/* In case network namespace is getting destroyed, reload
+	 * all devlink instances from this namespace into init_net.
+	 */
+	mutex_lock(&devlink_mutex);
+	list_for_each_entry(devlink, &devlink_list, list) {
+		if (net_eq(devlink_net(devlink), net)) {
+			if (WARN_ON(!devlink_reload_supported(devlink)))
+				continue;
+			err = devlink_reload(devlink, &init_net, NULL);
+			if (err)
+				pr_warn("Failed to reload devlink instance into init_net\n");
+		}
+	}
+	mutex_unlock(&devlink_mutex);
+}
+
+static struct pernet_operations devlink_pernet_ops __net_initdata = {
+	.pre_exit = devlink_pernet_pre_exit,
+};
+
 static int __init devlink_init(void)
 {
-	return genl_register_family(&devlink_nl_family);
+	int err;
+
+	err = genl_register_family(&devlink_nl_family);
+	if (err)
+		goto out;
+	err = register_pernet_subsys(&devlink_pernet_ops);
+
+out:
+	WARN_ON(err);
+	return err;
 }
 
 subsys_initcall(devlink_init);
-- 
2.21.0

