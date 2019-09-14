Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74348B2A2E
	for <lists+netdev@lfdr.de>; Sat, 14 Sep 2019 08:46:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726920AbfINGqc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Sep 2019 02:46:32 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:46830 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726849AbfINGq0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Sep 2019 02:46:26 -0400
Received: by mail-wr1-f66.google.com with SMTP id o18so2806586wrv.13
        for <netdev@vger.kernel.org>; Fri, 13 Sep 2019 23:46:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oBhD9DWPtgDdh1dsZgNWrATmrCjwo9RRT9sNa/Oon00=;
        b=UQCSW0AO2RQnlXlHcHeTyFqa1Ppbwhlb9QlyPvAOK7fFr6iQIuqItnqKELyetJlEjw
         hFRcodeM7UEismV6fYN+q07Al4+1hc2fG4ne6mg0tJrgDmdVjYwYL5ilyzphxZuLmRG4
         8ud2QkX4uZ3ktKHJni/ILkQeV1vR/PB1Ce4tH+GETGM+44UYx2f0e6s46htZ9VKIuuSZ
         6jfHy6LPbQVpm2nzey7E48XqJZHmqCPCtKudG9xolgBEAW/TokJW3kynthh7Wxuw/0r4
         192/OlP4vQVPRX2JCWXH7B9qE94LKWuoJf2CeaJuxfsFOT7ITMb00DwhVgeHyloJB9IB
         h0yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oBhD9DWPtgDdh1dsZgNWrATmrCjwo9RRT9sNa/Oon00=;
        b=ncfq8hk1PqQ8IBMR3CFWj1XEGzrqjganXXSQkJGGoScKgGQNHEGldFRA0jeIxcUbB7
         7K2OC5fj25r3uMxO3kYYgoQOprGAcyfW87C5PdpE2C0RbeJYcHdsHbuzTDUaYsYSK2yN
         Y3TnWqguNsXYCL/uuhkndjERgPLiDLOuXvlh7zl5vMRQiUFeYpis1+MX1OgzuWb9jaZN
         PkXnG6EEeINnCcNhLICOMr0JoXZqQbv/MS4JLwUCf5u8OFuI9fMAxJmQ6k5ZhZUUKM/d
         LDzT8vQROm7hDisBdSTC7Baxv/MYIwZPuwnw71x75DqqYGyLfPEdLFakXJVt7KraL38Q
         zQog==
X-Gm-Message-State: APjAAAUfelhDFm7Y2+wRcxD2v0CwFW0vIQ/EzjJccKZDLqBFbawYCn/t
        l+0Bi0w5qkvoqiX9e4FKX3SyxMAbXXM=
X-Google-Smtp-Source: APXvYqyaNjHzdNtjaBXcW1r5gAJIKaZ8eRetfD1CKZU5b3o750VMHFKcF905MAybyq/BUBMThmluOg==
X-Received: by 2002:adf:f801:: with SMTP id s1mr12899660wrp.320.1568443583714;
        Fri, 13 Sep 2019 23:46:23 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id q15sm39096601wrg.65.2019.09.13.23.46.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Sep 2019 23:46:23 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, idosch@mellanox.com, dsahern@gmail.com,
        jakub.kicinski@netronome.com, tariqt@mellanox.com,
        saeedm@mellanox.com, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        shuah@kernel.org, mlxsw@mellanox.com
Subject: [patch net-next 14/15] net: devlink: allow to change namespaces during reload
Date:   Sat, 14 Sep 2019 08:46:07 +0200
Message-Id: <20190914064608.26799-15-jiri@resnulli.us>
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

All devlink instances are created in init_net and stay there for a
lifetime. Allow user to be able to move devlink instances into
namespaces during devlink reload operation. That ensures proper
re-instantiation of driver objects, including netdevices.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx4/main.c |   4 +
 include/uapi/linux/devlink.h              |   4 +
 net/core/devlink.c                        | 155 ++++++++++++++++++++--
 3 files changed, 155 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/main.c b/drivers/net/ethernet/mellanox/mlx4/main.c
index ef3f3d06ff1e..989d0882aaa9 100644
--- a/drivers/net/ethernet/mellanox/mlx4/main.c
+++ b/drivers/net/ethernet/mellanox/mlx4/main.c
@@ -3942,6 +3942,10 @@ static int mlx4_devlink_reload_down(struct devlink *devlink,
 	struct mlx4_dev *dev = &priv->dev;
 	struct mlx4_dev_persistent *persist = dev->persist;
 
+	if (!net_eq(devlink_net(devlink), &init_net)) {
+		NL_SET_ERR_MSG_MOD(extack, "Namespace change is not supported");
+		return -EOPNOTSUPP;
+	}
 	if (persist->num_vfs)
 		mlx4_warn(persist->dev, "Reload performed on PF, will cause reset on operating Virtual Functions\n");
 	mlx4_restart_one_down(persist->pdev);
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
index 362cbbcca225..2a5db95cce3c 100644
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
@@ -2675,6 +2683,73 @@ devlink_resources_validate(struct devlink *devlink,
 	return err;
 }
 
+static struct net *devlink_netns_get(struct sk_buff *skb,
+				     struct devlink *devlink,
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
@@ -2695,9 +2770,27 @@ bool devlink_is_reload_failed(const struct devlink *devlink)
 }
 EXPORT_SYMBOL_GPL(devlink_is_reload_failed);
 
+static int devlink_reload(struct devlink *devlink, struct net *dest_net,
+			  struct netlink_ext_ack *extack)
+{
+	int err;
+
+	err = devlink->ops->reload_down(devlink, extack);
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
@@ -2708,11 +2801,20 @@ static int devlink_nl_cmd_reload(struct sk_buff *skb, struct genl_info *info)
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
+		dest_net = devlink_netns_get(skb, devlink, info);
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
 
@@ -5794,6 +5896,9 @@ static const struct nla_policy devlink_nl_policy[DEVLINK_ATTR_MAX + 1] = {
 	[DEVLINK_ATTR_TRAP_NAME] = { .type = NLA_NUL_STRING },
 	[DEVLINK_ATTR_TRAP_ACTION] = { .type = NLA_U8 },
 	[DEVLINK_ATTR_TRAP_GROUP_NAME] = { .type = NLA_NUL_STRING },
+	[DEVLINK_ATTR_NETNS_PID] = { .type = NLA_U32 },
+	[DEVLINK_ATTR_NETNS_FD] = { .type = NLA_U32 },
+	[DEVLINK_ATTR_NETNS_ID] = { .type = NLA_U32 },
 };
 
 static const struct genl_ops devlink_nl_ops[] = {
@@ -8061,9 +8166,43 @@ int devlink_compat_switch_id_get(struct net_device *dev,
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

