Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E27563C8CDB
	for <lists+netdev@lfdr.de>; Wed, 14 Jul 2021 21:40:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235553AbhGNTm4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Jul 2021 15:42:56 -0400
Received: from mga17.intel.com ([192.55.52.151]:64649 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234615AbhGNTma (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Jul 2021 15:42:30 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10045"; a="190793492"
X-IronPort-AV: E=Sophos;i="5.84,240,1620716400"; 
   d="scan'208";a="190793492"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2021 12:39:38 -0700
X-IronPort-AV: E=Sophos;i="5.84,240,1620716400"; 
   d="scan'208";a="505434238"
Received: from jekeller-desk.amr.corp.intel.com ([10.166.241.4])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2021 12:39:25 -0700
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kubakici@wp.pl>,
        Jiri Pirko <jiri@resnulli.us>
Cc:     Jacob Keller <jacob.e.keller@intel.com>
Subject: [PATCH net-next RFC] devlink: add commands to query flash and reload support
Date:   Wed, 14 Jul 2021 12:39:18 -0700
Message-Id: <20210714193918.1151083-1-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.31.1.331.gb0c09ab8796f
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Most devlink commands operate on objects, such as regions, devices for
information, etc. These commands have non-destructive operations that
can confirm whether a given device supports some operation.

The DEVLINK_CMD_FLASH_UPDATE and DEVLINK_CMD_RELOAD do not have any
non-destructive way to check if a given device supports the operation.
A user must issue a command that could have consequences to determine
whether support is available.

In some cases a user (or script!) might want to know whether a flash
update or driver reload is possible without actually triggering it yet.
In addition, users might want to be aware of what options a driver
supports for these commands.

To allow this, introduce DEVLINK_CMD_FLASH_SUPPORT and
DEVLINK_CMD_RELOAD_SUPPORT. These commands query the driver support for
these operations and return a message indicating if there is support,
and also what flags the driver supports.

For flash update, we return whether or not the driver accepts
per-component updates, and whether or not the driver accepts overwrite
mask settings.

For reload, we return the reload actions supported and the reload limits
supported.

This allows querying the capability of these functions without
triggering any side effects.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
---
I'm not sure if this is the best direction to go for implementing this.
At first I considered a single "DEVINK_CMD_SUPPORT" or similar which could
return a large list of every operation type that could be handled by the
driver. It turns out this is not that useful for most operations because
there already exist non-destructive queries like _GET

However, this implementation basically requires us to always remember to
update the support query and its not really tied explicitly to the command
implementation. These could diverge over time.

I still think it's valuable because a system administrator may want to be
able to tell whether or not an operation will succeed before potentially
triggering it, especially in scripts. I've been asked a few times by some of
the folks here "how do I tell if the device supports flash update?" and I've
had to say "well, you try it, and if it fails you know it doesn't!"

Technically in some cases we can sort of fake a query by issuing something
like a flash update with invalid file parameters. A user might be able to
tell based on the feedback of the error code. This relies on the order of
the checks and could fail if we ever refactored to make the command validate
file name first.

In addition, there's no simple way to just query "what all actions does this
driver support?" etc.

I think the ability to query the support for these commands is very useful.
I am not totally convinced that this is the best implementation, since it
really makes it easy to forget to update the _SUPPORT command when we add
new attributes in the future.

Thoughts?

 include/uapi/linux/devlink.h |   6 +
 net/core/devlink.c           | 237 +++++++++++++++++++++++++++++++++++
 2 files changed, 243 insertions(+)

diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index 32f53a0069d6..c886d939d29d 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -131,6 +131,9 @@ enum devlink_command {
 	DEVLINK_CMD_RATE_NEW,
 	DEVLINK_CMD_RATE_DEL,
 
+	DEVLINK_CMD_FLASH_SUPPORT,	/* can dump */
+	DEVLINK_CMD_RELOAD_SUPPORT,	/* can dump */
+
 	/* add new commands above here */
 	__DEVLINK_CMD_MAX,
 	DEVLINK_CMD_MAX = __DEVLINK_CMD_MAX - 1
@@ -551,6 +554,9 @@ enum devlink_attr {
 	DEVLINK_ATTR_RATE_NODE_NAME,		/* string */
 	DEVLINK_ATTR_RATE_PARENT_NODE_NAME,	/* string */
 
+	DEVLINK_ATTR_FLASH_SUPPORT_COMPONENT,		/* flag */
+	DEVLINK_ATTR_FLASH_SUPPORT_OVERWRITE_MASK,	/* flag */
+
 	/* add new attributes above here, update the policy in devlink.c */
 
 	__DEVLINK_ATTR_MAX,
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 8fdd04f00fd7..7f8f285af6ec 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -4044,6 +4044,118 @@ static int devlink_nl_cmd_reload(struct sk_buff *skb, struct genl_info *info)
 						       DEVLINK_CMD_RELOAD, info);
 }
 
+static int
+devlink_nl_reload_support_fill(struct sk_buff *msg, struct devlink *devlink,
+			       enum devlink_command cmd, u32 portid, u32 seq,
+			       int flags, struct netlink_ext_ack *extack)
+{
+	u32 supported_actions, supported_limits;
+	void *hdr;
+	int err;
+
+	hdr = genlmsg_put(msg, portid, seq, &devlink_nl_family, flags, cmd);
+	if (!hdr)
+		return -EMSGSIZE;
+
+	if (devlink_nl_put_handle(msg, devlink)) {
+		err = -EMSGSIZE;
+		goto err_cancel_msg;
+	}
+
+	supported_actions = devlink->ops->reload_actions;
+	supported_limits = devlink->ops->reload_limits;
+
+	if (nla_put_bitfield32(msg, DEVLINK_ATTR_RELOAD_ACTIONS_PERFORMED,
+			       supported_actions, supported_actions)) {
+		err = -EMSGSIZE;
+		goto err_cancel_msg;
+	}
+
+	if (nla_put_bitfield32(msg, DEVLINK_ATTR_RELOAD_LIMITS,
+			       supported_limits, supported_limits)) {
+		err = -EMSGSIZE;
+		goto err_cancel_msg;
+	}
+
+	genlmsg_end(msg, hdr);
+	return 0;
+
+err_cancel_msg:
+	genlmsg_cancel(msg, hdr);
+	return err;
+}
+
+static int
+devlink_nl_cmd_reload_support_doit(struct sk_buff *skb, struct genl_info *info)
+{
+	struct devlink *devlink = info->user_ptr[0];
+	struct sk_buff *msg;
+	int err;
+
+	if (!devlink_reload_supported(devlink->ops))
+		/* This indicates that reload update is not supported */
+		return -EOPNOTSUPP;
+
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (!msg)
+		return -ENOMEM;
+
+	err = devlink_nl_reload_support_fill(msg, devlink,
+					     DEVLINK_CMD_RELOAD_SUPPORT,
+					     info->snd_portid, info->snd_seq,
+					     0, info->extack);
+	if (err) {
+		nlmsg_free(msg);
+		return err;
+	}
+
+	return genlmsg_reply(msg, info);
+}
+
+static int
+devlink_nl_cmd_reload_support_dumpit(struct sk_buff *msg,
+				     struct netlink_callback *cb)
+{
+	struct devlink *devlink;
+	int start = cb->args[0];
+	int idx = 0;
+	int err = 0;
+
+	mutex_lock(&devlink_mutex);
+	list_for_each_entry(devlink, &devlink_list, list) {
+		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
+			continue;
+		if (idx < start) {
+			idx++;
+			continue;
+		}
+
+		if (!devlink_reload_supported(devlink->ops)) {
+			idx++;
+			continue;
+		}
+
+		mutex_lock(&devlink->lock);
+		err = devlink_nl_reload_support_fill(msg, devlink,
+						     DEVLINK_CMD_RELOAD_SUPPORT,
+						     NETLINK_CB(cb->skb).portid,
+						     cb->nlh->nlmsg_seq,
+						     NLM_F_MULTI,
+						     cb->extack);
+		mutex_unlock(&devlink->lock);
+		if (err)
+			break;
+		idx++;
+	}
+	mutex_unlock(&devlink_mutex);
+
+	if (err != -EMSGSIZE)
+		return err;
+
+	cb->args[0] = idx;
+	return msg->len;
+}
+
 static int devlink_nl_flash_update_fill(struct sk_buff *msg,
 					struct devlink *devlink,
 					enum devlink_command cmd,
@@ -4227,6 +4339,119 @@ static int devlink_nl_cmd_flash_update(struct sk_buff *skb,
 	return ret;
 }
 
+static int
+devlink_nl_flash_support_fill(struct sk_buff *msg, struct devlink *devlink,
+			      enum devlink_command cmd, u32 portid, u32 seq,
+			      int flags, struct netlink_ext_ack *extack)
+{
+	u32 supported_params;
+	void *hdr;
+	int err;
+
+	hdr = genlmsg_put(msg, portid, seq, &devlink_nl_family, flags, cmd);
+	if (!hdr)
+		return -EMSGSIZE;
+
+	if (devlink_nl_put_handle(msg, devlink)) {
+		err = -EMSGSIZE;
+		goto err_cancel_msg;
+	}
+
+	supported_params = devlink->ops->supported_flash_update_params;
+
+	if (supported_params & DEVLINK_SUPPORT_FLASH_UPDATE_COMPONENT) {
+		if (nla_put_flag(msg, DEVLINK_ATTR_FLASH_SUPPORT_COMPONENT)) {
+			err = -EMSGSIZE;
+			goto err_cancel_msg;
+		}
+	}
+
+	if (supported_params & DEVLINK_SUPPORT_FLASH_UPDATE_OVERWRITE_MASK) {
+		if (nla_put_flag(msg, DEVLINK_ATTR_FLASH_SUPPORT_OVERWRITE_MASK)) {
+			err = -EMSGSIZE;
+			goto err_cancel_msg;
+		}
+	}
+
+	genlmsg_end(msg, hdr);
+	return 0;
+
+err_cancel_msg:
+	genlmsg_cancel(msg, hdr);
+	return err;
+}
+
+static int
+devlink_nl_cmd_flash_support_doit(struct sk_buff *skb, struct genl_info *info)
+{
+	struct devlink *devlink = info->user_ptr[0];
+	struct sk_buff *msg;
+	int err;
+
+	if (!devlink->ops->flash_update)
+		/* This indicates that flash update is not supported */
+		return -EOPNOTSUPP;
+
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (!msg)
+		return -ENOMEM;
+
+	err = devlink_nl_flash_support_fill(msg, devlink,
+					    DEVLINK_CMD_FLASH_SUPPORT,
+					    info->snd_portid, info->snd_seq, 0,
+					    info->extack);
+	if (err) {
+		nlmsg_free(msg);
+		return err;
+	}
+
+	return genlmsg_reply(msg, info);
+}
+
+static int
+devlink_nl_cmd_flash_support_dumpit(struct sk_buff *msg,
+				     struct netlink_callback *cb)
+{
+	struct devlink *devlink;
+	int start = cb->args[0];
+	int idx = 0;
+	int err = 0;
+
+	mutex_lock(&devlink_mutex);
+	list_for_each_entry(devlink, &devlink_list, list) {
+		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
+			continue;
+		if (idx < start) {
+			idx++;
+			continue;
+		}
+
+		if (!devlink->ops->flash_update) {
+			idx++;
+			continue;
+		}
+
+		mutex_lock(&devlink->lock);
+		err = devlink_nl_flash_support_fill(msg, devlink,
+						    DEVLINK_CMD_FLASH_SUPPORT,
+						    NETLINK_CB(cb->skb).portid,
+						    cb->nlh->nlmsg_seq,
+						    NLM_F_MULTI,
+						    cb->extack);
+		mutex_unlock(&devlink->lock);
+		if (err)
+			break;
+		idx++;
+	}
+	mutex_unlock(&devlink_mutex);
+
+	if (err != -EMSGSIZE)
+		return err;
+
+	cb->args[0] = idx;
+	return msg->len;
+}
+
 static const struct devlink_param devlink_param_generic[] = {
 	{
 		.id = DEVLINK_PARAM_GENERIC_ID_INT_ERR_RESET,
@@ -8563,6 +8788,12 @@ static const struct genl_small_ops devlink_nl_ops[] = {
 		.flags = GENL_ADMIN_PERM,
 		.internal_flags = DEVLINK_NL_FLAG_NO_LOCK,
 	},
+	{
+		.cmd = DEVLINK_CMD_RELOAD_SUPPORT,
+		.doit = devlink_nl_cmd_reload_support_doit,
+		.dumpit = devlink_nl_cmd_reload_support_dumpit,
+		/* can be retrieved by unprivileged users */
+	},
 	{
 		.cmd = DEVLINK_CMD_PARAM_GET,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
@@ -8688,6 +8919,12 @@ static const struct genl_small_ops devlink_nl_ops[] = {
 		.doit = devlink_nl_cmd_flash_update,
 		.flags = GENL_ADMIN_PERM,
 	},
+	{
+		.cmd = DEVLINK_CMD_FLASH_SUPPORT,
+		.doit = devlink_nl_cmd_flash_support_doit,
+		.dumpit = devlink_nl_cmd_flash_support_dumpit,
+		/* can be retrieved by unprivileged users */
+	},
 	{
 		.cmd = DEVLINK_CMD_TRAP_GET,
 		.doit = devlink_nl_cmd_trap_get_doit,

base-commit: 5e437416ff66981d8154687cfdf7de50b1d82bfc
-- 
2.31.1.331.gb0c09ab8796f

