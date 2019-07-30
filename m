Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20FB87A375
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 10:58:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731232AbfG3I5k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 04:57:40 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:36502 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728354AbfG3I5i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 04:57:38 -0400
Received: by mail-wr1-f67.google.com with SMTP id n4so64920263wrs.3
        for <netdev@vger.kernel.org>; Tue, 30 Jul 2019 01:57:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3leAndAH837WMQgJh9n53OJsGfvBKnmuLPOKhPx3G8U=;
        b=UdPWzzcRwGh6VCq4KhEgq/poESYz29jdr7Yqz86kWbARhh9lTs3QwWVFXGj4ec+AaO
         dkfsLeFpJUxR5ALWZJwoMOHQIGvEzYCGR/pCxj6WX9/QYaHdbseNM3kJNmKKGjGSOtLz
         6sOB3BoxnF6/d0+Esw7othgfZLKpJpaU8YMWC5iFaURMl2CuPDTqygPTchMYO0SZjJtb
         Tth7tHcknyXpyuaTDI3q3Dmr9x0SOAtEbfEJ/IxiFd66D9zPeVtDuFz7+Ds1YgAZ1VEW
         tqCccbiE9LxWuSFbfxLd7rbyyVUHRuu+BKXfkcwXSrSf5en2LH7sKlMKrFavOqem56k7
         /HmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3leAndAH837WMQgJh9n53OJsGfvBKnmuLPOKhPx3G8U=;
        b=pSztCpDrmId38UCJJ6/Idfd+q65qwpmWdZigNN9q1R4x7WTVFqzNOqjxEhMfLDsrBU
         7OwDiIgxWcXPTgU3YuLQBomyUJWYRf3c0EKuUF4Vf4/PaPftrIkpXXsWTOGx4w8tJqBS
         k9FF9wGyZJQqAXbVak35+jHJQALMM5pXf03TB2W1akwCoaJWGwSFUmsykZmM/dM6mn6H
         j2KWZGMOYxsVL83L07EzYc44pTovxh6NDdX8DirAaizNY6diYrp9UjYHMcpKbZo12THk
         wDdJApTy7VYEvtQXrwEV7xJyqUndF8otxXf702JNkoi6knUPWcpkR5hpnTIOoqQTZF6I
         OZQQ==
X-Gm-Message-State: APjAAAVrddl1d1xccRf90QSWNA3pSXNkY2siZ+dUK68inf6ILhEi+aEF
        Xd9pxIpO9JOfX7ICi3hEqY2Kpy80
X-Google-Smtp-Source: APXvYqzr2h2EmE+Zgy32G3JzB6dHiK4RXpShQfCzGjO1GYnChE1Z5zn1r2Fhysf+Niz+Kv//9iR5Pw==
X-Received: by 2002:adf:f206:: with SMTP id p6mr54595672wro.216.1564477056515;
        Tue, 30 Jul 2019 01:57:36 -0700 (PDT)
Received: from localhost (mail.chocen-mesto.cz. [85.163.43.2])
        by smtp.gmail.com with ESMTPSA id h16sm68466092wrv.88.2019.07.30.01.57.36
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 30 Jul 2019 01:57:36 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        sthemmin@microsoft.com, dsahern@gmail.com, mlxsw@mellanox.com
Subject: [patch net-next v2 1/3] net: devlink: allow to change namespaces
Date:   Tue, 30 Jul 2019 10:57:32 +0200
Message-Id: <20190730085734.31504-2-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190730085734.31504-1-jiri@resnulli.us>
References: <20190730085734.31504-1-jiri@resnulli.us>
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
v1->v2:
- change the check for multiple attributes
- add warnon in case there is no attribute passed
---
 include/uapi/linux/devlink.h |   4 ++
 net/core/devlink.c           | 113 ++++++++++++++++++++++++++++++++++-
 2 files changed, 114 insertions(+), 3 deletions(-)

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
index 4f40aeace902..e1cbfd90f788 100644
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
@@ -645,6 +653,71 @@ static int devlink_nl_cmd_get_doit(struct sk_buff *skb, struct genl_info *info)
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
@@ -5184,6 +5257,9 @@ static const struct nla_policy devlink_nl_policy[DEVLINK_ATTR_MAX + 1] = {
 	[DEVLINK_ATTR_HEALTH_REPORTER_AUTO_RECOVER] = { .type = NLA_U8 },
 	[DEVLINK_ATTR_FLASH_UPDATE_FILE_NAME] = { .type = NLA_NUL_STRING },
 	[DEVLINK_ATTR_FLASH_UPDATE_COMPONENT] = { .type = NLA_NUL_STRING },
+	[DEVLINK_ATTR_NETNS_PID] = { .type = NLA_U32 },
+	[DEVLINK_ATTR_NETNS_FD] = { .type = NLA_U32 },
+	[DEVLINK_ATTR_NETNS_ID] = { .type = NLA_U32 },
 };
 
 static const struct genl_ops devlink_nl_ops[] = {
@@ -5195,6 +5271,13 @@ static const struct genl_ops devlink_nl_ops[] = {
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
@@ -6955,9 +7038,33 @@ int devlink_compat_switch_id_get(struct net_device *dev,
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

