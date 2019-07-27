Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89F2D777F8
	for <lists+netdev@lfdr.de>; Sat, 27 Jul 2019 11:45:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387523AbfG0JpD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jul 2019 05:45:03 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:34783 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728574AbfG0JpD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jul 2019 05:45:03 -0400
Received: by mail-wm1-f65.google.com with SMTP id w9so39552304wmd.1
        for <netdev@vger.kernel.org>; Sat, 27 Jul 2019 02:45:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6wD5WYR/QbYqYrUCHsbpk3pk1O5XY95h14ZUE4YjHPE=;
        b=vP4T+5wtGp1zkmalrFkPbP3Gb9TmjXMquhETpeljB+cmpNQPRhDJjxLMzfWzY7hS3S
         1tmS4V7v0+MuiMUWVjFXtu2K2to61cmeV6pD789Ei8z8oj5VkOU6/2ysubCIycEGU/NJ
         nooi8jgkMs4CFC+7/rxiJ1IwA4tvCLO2DvN9CBCCLjP0zgYoT5P5SH08op7hzJLqpCGK
         7U2FxfVZ66mNQr+K8YdfI5/Ur/EZiAxXACleM1ahXz2GQ5lNoZL4yPQ9/zy1Swwyro2b
         ab5AnUzHPr7QPZBdza6IBiKgz8AfG4wVy2AIDP+6yy2yBYQiaT/+ZzfsCXH9OLLBR1e+
         srpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6wD5WYR/QbYqYrUCHsbpk3pk1O5XY95h14ZUE4YjHPE=;
        b=okU/2rosBQcldHlJAGKYHeNo57RvDxkwc0HD5zDpQrPCrdGpwq/GehD3aSJ5xUM7rg
         XLSxV3zABuI585UumD6jagUM8vYUucAMkJMto6TUrxWMs2DoSHcgZ+f5+DcApjsjd9bg
         gdWsVrFA++CHADXQlq83WjxCiGfzSjplJAmVrVdhx5P+m5M2fTUoG9aEN650OihbcHOc
         XZ/aD1O3FIDaRD6l+wEtJEFRl3H5cQqrpN4+VUshOHx0/e0WODdgs2bXw4Mjud305rq3
         wRODmAzXB7ySe2sGYSF02gPn3YyfbuPHyGqvo0aAG+JN/6Hzdgsc9dbjtpIkIwBru9Ik
         4T6w==
X-Gm-Message-State: APjAAAVz0kZRTZQpiEn6PnJlde1pymE7M3yi5TsfVm6ImmF5LQozQUC1
        Cg7o4BB4x3ZSqj6tJjQ72zDCRsu/
X-Google-Smtp-Source: APXvYqxQ9oT56vgjsRNXmyBNI8POLnL//y4C/m6mzNRothc7URiryrjO6q8taWle6maspImjDKgmiQ==
X-Received: by 2002:a7b:c748:: with SMTP id w8mr16161649wmk.36.1564220701291;
        Sat, 27 Jul 2019 02:45:01 -0700 (PDT)
Received: from localhost (ip-78-102-222-119.net.upcbroadband.cz. [78.102.222.119])
        by smtp.gmail.com with ESMTPSA id w24sm43677269wmc.30.2019.07.27.02.45.00
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sat, 27 Jul 2019 02:45:00 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        sthemmin@microsoft.com, dsahern@gmail.com, mlxsw@mellanox.com
Subject: [patch net-next 1/3] net: devlink: allow to change namespaces
Date:   Sat, 27 Jul 2019 11:44:57 +0200
Message-Id: <20190727094459.26345-2-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190727094459.26345-1-jiri@resnulli.us>
References: <20190727094459.26345-1-jiri@resnulli.us>
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
 include/uapi/linux/devlink.h |   4 ++
 net/core/devlink.c           | 112 ++++++++++++++++++++++++++++++++++-
 2 files changed, 113 insertions(+), 3 deletions(-)

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
index 4f40aeace902..ec024462e7d4 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -439,8 +439,16 @@ static void devlink_nl_post_doit(const struct genl_ops *ops,
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
@@ -645,6 +653,70 @@ static int devlink_nl_cmd_get_doit(struct sk_buff *skb, struct genl_info *info)
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
+	if ((netns_pid_attr && (netns_fd_attr || netns_id_attr)) ||
+	    (netns_fd_attr && (netns_pid_attr || netns_id_attr)) ||
+	    (netns_id_attr && (netns_pid_attr || netns_fd_attr))) {
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
+static void devlink_netns_change(struct devlink *devlink, struct net *net)
+{
+	if (net_eq(devlink_net(devlink), net))
+		return;
+	devlink_notify(devlink, DEVLINK_CMD_DEL);
+	devlink_net_set(devlink, net);
+	devlink_notify(devlink, DEVLINK_CMD_NEW);
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
@@ -5184,6 +5256,9 @@ static const struct nla_policy devlink_nl_policy[DEVLINK_ATTR_MAX + 1] = {
 	[DEVLINK_ATTR_HEALTH_REPORTER_AUTO_RECOVER] = { .type = NLA_U8 },
 	[DEVLINK_ATTR_FLASH_UPDATE_FILE_NAME] = { .type = NLA_NUL_STRING },
 	[DEVLINK_ATTR_FLASH_UPDATE_COMPONENT] = { .type = NLA_NUL_STRING },
+	[DEVLINK_ATTR_NETNS_PID] = { .type = NLA_U32 },
+	[DEVLINK_ATTR_NETNS_FD] = { .type = NLA_U32 },
+	[DEVLINK_ATTR_NETNS_ID] = { .type = NLA_U32 },
 };
 
 static const struct genl_ops devlink_nl_ops[] = {
@@ -5195,6 +5270,13 @@ static const struct genl_ops devlink_nl_ops[] = {
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
@@ -6955,9 +7037,33 @@ int devlink_compat_switch_id_get(struct net_device *dev,
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

