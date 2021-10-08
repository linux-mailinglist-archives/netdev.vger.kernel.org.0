Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE524426816
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 12:42:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239978AbhJHKn5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 06:43:57 -0400
Received: from mga02.intel.com ([134.134.136.20]:45104 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239818AbhJHKnu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Oct 2021 06:43:50 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10130"; a="213622804"
X-IronPort-AV: E=Sophos;i="5.85,357,1624345200"; 
   d="scan'208";a="213622804"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2021 03:41:54 -0700
X-IronPort-AV: E=Sophos;i="5.85,357,1624345200"; 
   d="scan'208";a="478934491"
Received: from jekeller-desk.amr.corp.intel.com ([10.166.244.138])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2021 03:41:54 -0700
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jiri Pirko <jiri@resnulli.us>, Jakub Kicinski <kubakici@wp.pl>,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: [net-next 3/4] devlink: add dry run attribute to flash update
Date:   Fri,  8 Oct 2021 03:41:14 -0700
Message-Id: <20211008104115.1327240-4-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.31.1.331.gb0c09ab8796f
In-Reply-To: <20211008104115.1327240-1-jacob.e.keller@intel.com>
References: <20211008104115.1327240-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The devlink flash interface is used to request programming of a device
flash chip. In some cases, a user (or script) might want to verify
whether or not a device update is supported without actually committing
to update the device. For example, a system administrator might want to
validate that a given file will be accepted by a device driver, or may
want to validate a command before finally committing to it.

There currently is no good method to support this use. To do this, add
a new DEVLINK_ATTR_DRY_RUN attribute. This attribute shall be used by
a command to indicate that the request is just a "dry run" to verify
that things will work.

Ultimately, a proper dry run must be handled by device drivers, as we
want to also validate things such as the flash file. Add
a dry_run parameter to the devlink_flash_update_params, and an
associated bit to indicate if a driver supports verifying a dry_run.

If a driver does not support dry run verification, we will return
-EOPNOTSUPP, but with an appropriate extended ACK message that indicates
to the user that a flash update is supported.

We check for the dry run attribute last in order to allow as much
verification of parameters as possible. For example, even if a driver
does not support dry_run, we can still validate that all of the other
optional parameters such as overwrite_mask and per-component update are
valid.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
---
 include/net/devlink.h        |  2 ++
 include/uapi/linux/devlink.h |  2 ++
 net/core/devlink.c           | 19 ++++++++++++++++++-
 3 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index a7852a257bf6..d67183a739cf 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -640,10 +640,12 @@ struct devlink_flash_update_params {
 	const struct firmware *fw;
 	const char *component;
 	u32 overwrite_mask;
+	bool dry_run;
 };
 
 #define DEVLINK_SUPPORT_FLASH_UPDATE_COMPONENT		BIT(0)
 #define DEVLINK_SUPPORT_FLASH_UPDATE_OVERWRITE_MASK	BIT(1)
+#define DEVLINK_SUPPORT_FLASH_UPDATE_DRY_RUN		BIT(2)
 
 struct devlink_region;
 struct devlink_info_req;
diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index b897b80770f6..d5faaa942c1b 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -553,6 +553,8 @@ enum devlink_attr {
 
 	DEVLINK_ATTR_REGION_MAX_SNAPSHOTS,	/* u32 */
 
+	DEVLINK_ATTR_DRY_RUN,			/* flag */
+
 	/* add new attributes above here, update the policy in devlink.c */
 
 	__DEVLINK_ATTR_MAX,
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 4917112406a0..8d11b0838a0a 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -4232,7 +4232,8 @@ EXPORT_SYMBOL_GPL(devlink_flash_update_timeout_notify);
 static int devlink_nl_cmd_flash_update(struct sk_buff *skb,
 				       struct genl_info *info)
 {
-	struct nlattr *nla_component, *nla_overwrite_mask, *nla_file_name;
+	struct nlattr *nla_component, *nla_overwrite_mask, *nla_file_name,
+		      *nla_dry_run;
 	struct devlink_flash_update_params params = {};
 	struct devlink *devlink = info->user_ptr[0];
 	const char *file_name;
@@ -4278,6 +4279,21 @@ static int devlink_nl_cmd_flash_update(struct sk_buff *skb,
 		return ret;
 	}
 
+	/* Always check dry run last, in order to allow verification of other
+	 * parameter support even if the particular driver does not yet
+	 * support a full dry-run
+	 */
+	nla_dry_run = info->attrs[DEVLINK_ATTR_DRY_RUN];
+	if (nla_dry_run) {
+		if (!(supported_params & DEVLINK_SUPPORT_FLASH_UPDATE_DRY_RUN)) {
+			NL_SET_ERR_MSG_ATTR(info->extack, nla_dry_run,
+					    "flash update is supported, but dry run is not supported for this device");
+			release_firmware(params.fw);
+			return -EOPNOTSUPP;
+		}
+		params.dry_run = true;
+	}
+
 	devlink_flash_update_begin_notify(devlink);
 	ret = devlink->ops->flash_update(devlink, &params, info->extack);
 	devlink_flash_update_end_notify(devlink);
@@ -8514,6 +8530,7 @@ static const struct nla_policy devlink_nl_policy[DEVLINK_ATTR_MAX + 1] = {
 	[DEVLINK_ATTR_RATE_TX_MAX] = { .type = NLA_U64 },
 	[DEVLINK_ATTR_RATE_NODE_NAME] = { .type = NLA_NUL_STRING },
 	[DEVLINK_ATTR_RATE_PARENT_NODE_NAME] = { .type = NLA_NUL_STRING },
+	[DEVLINK_ATTR_DRY_RUN] = { .type = NLA_FLAG },
 };
 
 static const struct genl_small_ops devlink_nl_ops[] = {
-- 
2.31.1.331.gb0c09ab8796f

