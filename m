Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A6B38A003
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 15:48:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727542AbfHLNr5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 09:47:57 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:38053 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727299AbfHLNr5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 09:47:57 -0400
Received: by mail-wr1-f65.google.com with SMTP id g17so104611422wrr.5
        for <netdev@vger.kernel.org>; Mon, 12 Aug 2019 06:47:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cKx////intTmrbbXVoH4NOyK0apFrCv71qErrMIic90=;
        b=2CV3JcxWjToX05Oy82iWyl1Xxxanzrs3UeL89iKLvzm6nIagRgeE77v4zaJHI8nral
         gbawxgfSM6WmZ887wCOvN3M/0wz/FwBPeYm7+K6trzNlsdnYDSnLwyVUrLDenKoj8A2B
         S+3HqUpUTJuy0Y2BrbxVys8akA2XkMbuniQk9IFjisYDMSIjaj258LDsbLWJ0BKYlkNB
         kLh6igRHGk5zs9Wif7n9AjCvyV4AZc31W8GfiaHvnwaXZ7i+5CMcGanrJBBosrx1bm8Y
         7xo4tqR833iJEhA9jyTg1Q1ZAZqWhFnyWYcGQSr59Pa9nQayRNHePdloHnzL2aV1U9/8
         uwWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cKx////intTmrbbXVoH4NOyK0apFrCv71qErrMIic90=;
        b=lf0zrLgnFhjiiyAHOz5u90D0DIvJapxmAv3YzHWZKZSlnb4EyaPuy8uChIwA7QJ8m6
         ZQaMjjE+/AdKAZn+HErY6U5Hj8YgLzbWl7HuGWYg+9eVE6uZ9TS4YNjn2iTd+MzylXFx
         /jzh7WKntLWQPfElbORX/McU6ysYoehc5Fzm6Xj26VkS+DjR0Z1ZFFHkgb1WVkFeB2sV
         ezcHQhxQh5qVIMtdM42+1DzA/m0qywR+WFIxodiFIu+H9LQZmU8009+3JcqynDBzPdRb
         FQNWhzwK45ROPoY26fuJK3gk6ex60PFzTeMXy4FITOMI6elwrqs3DW/pRSfa/U/qEml5
         vy7A==
X-Gm-Message-State: APjAAAXha/Mze9hkuK6k0CFwEYJbqtBlI2teDTnr7/G+k+1mkDvZaZf+
        is/g883HTWNOQEFbd4nIXNez2UogMLQ=
X-Google-Smtp-Source: APXvYqxS5jcCZz45uhazNCm3DLneVrub/wt1TsKyvbndMgVOddOET4R/MnzmuCEahf1NgmMmw5C06w==
X-Received: by 2002:a5d:470c:: with SMTP id y12mr25975599wrq.136.1565617673951;
        Mon, 12 Aug 2019 06:47:53 -0700 (PDT)
Received: from localhost (ip-78-45-163-186.net.upcbroadband.cz. [78.45.163.186])
        by smtp.gmail.com with ESMTPSA id f192sm17226086wmg.30.2019.08.12.06.47.53
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 12 Aug 2019 06:47:53 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        stephen@networkplumber.org, dsahern@gmail.com, mlxsw@mellanox.com
Subject: [patch net-next v3 1/3] net: devlink: allow to change namespaces
Date:   Mon, 12 Aug 2019 15:47:49 +0200
Message-Id: <20190812134751.30838-2-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190812134751.30838-1-jiri@resnulli.us>
References: <20190812134751.30838-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

All devlink instances are created in init_net and stay there for a
lifetime. Allow user to be able to move devlink instances into
namespaces.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
v2->v3:
- added notifications for all objects
v1->v2:
- change the check for multiple attributes
- add warnon in case there is no attribute passed
---
 include/uapi/linux/devlink.h |   4 +
 net/core/devlink.c           | 166 ++++++++++++++++++++++++++++++++++-
 2 files changed, 167 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index ffc993256527..95f0a1edab99 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -348,6 +348,10 @@ enum devlink_attr {
 	DEVLINK_ATTR_PORT_PCI_PF_NUMBER,	/* u16 */
 	DEVLINK_ATTR_PORT_PCI_VF_NUMBER,	/* u16 */
 
+	DEVLINK_ATTR_NETNS_FD,			/* u32 */
+	DEVLINK_ATTR_NETNS_PID,			/* u32 */
+	DEVLINK_ATTR_NETNS_ID,			/* u32 */
+
 	/* add new attributes above here, update the policy in devlink.c */
 
 	__DEVLINK_ATTR_MAX,
diff --git a/net/core/devlink.c b/net/core/devlink.c
index e3a1ae44f93d..6f8c1b2cdfb2 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -430,8 +430,16 @@ static void devlink_nl_post_doit(const struct genl_ops *ops,
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
@@ -636,6 +644,74 @@ static int devlink_nl_cmd_get_doit(struct sk_buff *skb, struct genl_info *info)
 	return genlmsg_reply(msg, info);
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
+static void devlink_all_add_notify(struct devlink *devlink);
+static void devlink_all_del_notify(struct devlink *devlink);
+
+static void devlink_netns_change(struct devlink *devlink, struct net *net)
+{
+	if (net_eq(devlink_net(devlink), net))
+		return;
+	devlink_all_del_notify(devlink);
+	devlink_net_set(devlink, net);
+	devlink_all_add_notify(devlink);
+}
+
+static int devlink_nl_cmd_set_doit(struct sk_buff *skb, struct genl_info *info)
+{
+	struct devlink *devlink = info->user_ptr[0];
+
+	if (info->attrs[DEVLINK_ATTR_NETNS_PID] ||
+	    info->attrs[DEVLINK_ATTR_NETNS_FD] ||
+	    info->attrs[DEVLINK_ATTR_NETNS_ID]) {
+		struct net *net;
+
+		net = devlink_netns_get(skb, devlink, info);
+		if (IS_ERR(net))
+			return PTR_ERR(net);
+		devlink_netns_change(devlink, net);
+		put_net(net);
+	}
+	return 0;
+}
+
 static int devlink_nl_cmd_get_dumpit(struct sk_buff *msg,
 				     struct netlink_callback *cb)
 {
@@ -5184,6 +5260,9 @@ static const struct nla_policy devlink_nl_policy[DEVLINK_ATTR_MAX + 1] = {
 	[DEVLINK_ATTR_HEALTH_REPORTER_AUTO_RECOVER] = { .type = NLA_U8 },
 	[DEVLINK_ATTR_FLASH_UPDATE_FILE_NAME] = { .type = NLA_NUL_STRING },
 	[DEVLINK_ATTR_FLASH_UPDATE_COMPONENT] = { .type = NLA_NUL_STRING },
+	[DEVLINK_ATTR_NETNS_PID] = { .type = NLA_U32 },
+	[DEVLINK_ATTR_NETNS_FD] = { .type = NLA_U32 },
+	[DEVLINK_ATTR_NETNS_ID] = { .type = NLA_U32 },
 };
 
 static const struct genl_ops devlink_nl_ops[] = {
@@ -5195,6 +5274,13 @@ static const struct genl_ops devlink_nl_ops[] = {
 		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK,
 		/* can be retrieved by unprivileged users */
 	},
+	{
+		.cmd = DEVLINK_CMD_SET,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
+		.doit = devlink_nl_cmd_set_doit,
+		.flags = GENL_ADMIN_PERM,
+		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK,
+	},
 	{
 		.cmd = DEVLINK_CMD_PORT_GET,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
@@ -6834,6 +6920,56 @@ int devlink_region_snapshot_create(struct devlink_region *region,
 }
 EXPORT_SYMBOL_GPL(devlink_region_snapshot_create);
 
+static void devlink_all_del_notify(struct devlink *devlink)
+{
+	struct devlink_port *devlink_port;
+	struct devlink_region *region;
+	struct devlink_param_item *param_item;
+	struct devlink_snapshot *snapshot;
+
+	list_for_each_entry(region, &devlink->region_list, list) {
+		list_for_each_entry(snapshot, &region->snapshot_list, list)
+			devlink_nl_region_notify(region, snapshot,
+						 DEVLINK_CMD_REGION_DEL);
+		devlink_nl_region_notify(region, NULL, DEVLINK_CMD_REGION_DEL);
+	}
+	list_for_each_entry(devlink_port, &devlink->port_list, list) {
+		list_for_each_entry(param_item, &devlink_port->param_list, list)
+			devlink_param_notify(devlink, devlink_port->index,
+					     param_item, DEVLINK_CMD_PARAM_DEL);
+		devlink_port_notify(devlink_port, DEVLINK_CMD_PORT_DEL);
+	}
+	list_for_each_entry(param_item, &devlink->param_list, list)
+		devlink_param_notify(devlink, 0, param_item,
+				     DEVLINK_CMD_PARAM_DEL);
+	devlink_notify(devlink, DEVLINK_CMD_DEL);
+}
+
+static void devlink_all_add_notify(struct devlink *devlink)
+{
+	struct devlink_port *devlink_port;
+	struct devlink_region *region;
+	struct devlink_param_item *param_item;
+	struct devlink_snapshot *snapshot;
+
+	devlink_notify(devlink, DEVLINK_CMD_NEW);
+	list_for_each_entry(param_item, &devlink->param_list, list)
+		devlink_param_notify(devlink, 0, param_item,
+				     DEVLINK_CMD_PARAM_NEW);
+	list_for_each_entry(devlink_port, &devlink->port_list, list) {
+		devlink_port_notify(devlink_port, DEVLINK_CMD_PORT_NEW);
+		list_for_each_entry(param_item, &devlink_port->param_list, list)
+			devlink_param_notify(devlink, devlink_port->index,
+					     param_item, DEVLINK_CMD_PARAM_NEW);
+	}
+	list_for_each_entry(region, &devlink->region_list, list) {
+		devlink_nl_region_notify(region, NULL, DEVLINK_CMD_REGION_NEW);
+		list_for_each_entry(snapshot, &region->snapshot_list, list)
+			devlink_nl_region_notify(region, snapshot,
+						 DEVLINK_CMD_REGION_NEW);
+	}
+}
+
 static void __devlink_compat_running_version(struct devlink *devlink,
 					     char *buf, size_t len)
 {
@@ -6953,9 +7089,33 @@ int devlink_compat_switch_id_get(struct net_device *dev,
 	return 0;
 }
 
+static void __net_exit devlink_pernet_exit(struct net *net)
+{
+	struct devlink *devlink;
+
+	mutex_lock(&devlink_mutex);
+	list_for_each_entry(devlink, &devlink_list, list)
+		if (net_eq(devlink_net(devlink), net))
+			devlink_netns_change(devlink, &init_net);
+	mutex_unlock(&devlink_mutex);
+}
+
+static struct pernet_operations __net_initdata devlink_pernet_ops = {
+	.exit = devlink_pernet_exit,
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
+	err = register_pernet_device(&devlink_pernet_ops);
+
+out:
+	WARN_ON(err);
+	return err;
 }
 
 subsys_initcall(devlink_init);
-- 
2.21.0

