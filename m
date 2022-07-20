Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2709557BDE0
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 20:34:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231873AbiGTSew (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 14:34:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232429AbiGTSev (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 14:34:51 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E81C87173A
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 11:34:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658342090; x=1689878090;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2lFtIpxPzZPCz4lsFPRgzsTrIT1tgnhvjwl6v6FHnGw=;
  b=YuZOQsF5Of4KlaC0b495YJhQQ4BFhPt4pk3uTdkc/bZIb2Mr1dp5uyqE
   IbzLMoJBWY8faNDi5de1QaqoYhfJc5DdzQs2Or3mYbacT6ZVgP79ukIvA
   Fh8zbSzJ3QuS0ODS/2slPBHs6y+e0xFd67Ud2zSpkQSgBMxnhXE8FbBcm
   yflqVOsdiZI8KeOJmvQMiHQqq5R25sXT9n36IZeF0LvkVpjDwPzQ2jqtZ
   UuUjhJt8EfkKZuNrE7eS9mm7YnNudwVGGqiOqpSOZQ2LoOxAWf1haUdXy
   aiH0IQQlA9O9dPhbK9597SqGnd5TQonPh0vpNuHod2/svO1x2Oe/YPUs+
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10414"; a="350846112"
X-IronPort-AV: E=Sophos;i="5.92,287,1650956400"; 
   d="scan'208";a="350846112"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2022 11:34:46 -0700
X-IronPort-AV: E=Sophos;i="5.92,287,1650956400"; 
   d="scan'208";a="656389765"
Received: from jekeller-desk.amr.corp.intel.com ([10.166.241.7])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2022 11:34:46 -0700
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: [net-next PATCH 1/2] devlink: add dry run attribute to flash update
Date:   Wed, 20 Jul 2022 11:34:32 -0700
Message-Id: <20220720183433.2070122-2-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.35.1.456.ga9c7032d4631
In-Reply-To: <20220720183433.2070122-1-jacob.e.keller@intel.com>
References: <20220720183433.2070122-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Users use the devlink flash interface to request a device driver program or
update the device flash chip. In some cases, a user (or script) may want to
verify that a given flash update command is supported without actually
committing to immediately updating the device. For example, a system
administrator may want to validate that a particular flash binary image
will be accepted by the device, or simply validate a command before finally
committing to it.

The current flash update interface lacks a method to support such a dry
run. Add a new DEVLINK_ATTR_DRY_RUN attribute which shall be used by a
devlink command to indicate that a request is a dry run which should not
perform device configuration. Instead, the command should report whether
the command or configuration request is valid.

While we can validate the initial arguments of the devlink command, a
proper dry run must be processed by the device driver. This is required
because only the driver can perform validation of the flash binary file.

Add a new dry_run parameter to the devlink_flash_update_params struct,
along with the associated bit to indicate if a driver supports verifying a
dry run.

We always check the dry run attribute last in order to allow as much
verification of other parameters as possible. For example, even if a driver
does not support the dry_run option, we can still validate the other
optional parameters such as the overwrite_mask and per-component update
name.

Document that userspace should take care when issuing a dry run to older
kernels, as the flash update command is not strictly verified. Thus,
unknown attributes will be ignored and this could cause a request for a dry
run to perform an actual update. We can't fix old kernels to verify unknown
attributes, but userspace can check the maximum attribute and reject the
dry run request if it is not supported by the kernel.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
---
 .../networking/devlink/devlink-flash.rst      | 23 +++++++++++++++++++
 include/net/devlink.h                         |  2 ++
 include/uapi/linux/devlink.h                  |  8 +++++++
 net/core/devlink.c                            | 19 ++++++++++++++-
 4 files changed, 51 insertions(+), 1 deletion(-)

diff --git a/Documentation/networking/devlink/devlink-flash.rst b/Documentation/networking/devlink/devlink-flash.rst
index 603e732f00cc..1dc373229a54 100644
--- a/Documentation/networking/devlink/devlink-flash.rst
+++ b/Documentation/networking/devlink/devlink-flash.rst
@@ -44,6 +44,29 @@ preserved across the update. A device may not support every combination and
 the driver for such a device must reject any combination which cannot be
 faithfully implemented.
 
+Dry run
+=======
+
+Users can request a "dry run" of a flash update by adding the
+``DEVLINK_ATTR_DRY_RUN`` attribute to the ``DEVLINK_CMD_FLASH_UPDATE``
+command. If the attribute is present, the kernel will only verify that the
+provided command is valid. During a dry run, an update is not performed.
+
+If supported by the driver, the flash image contents are also validated and
+the driver may indicate whether the file is a valid flash image for the
+device.
+
+.. code:: shell
+
+   $ devlink dev flash pci/0000:af:00.0 file image.bin dry-run
+   Validating flash binary
+
+Note that user space should take care when adding this attribute. Older
+kernels which do not recognize the attribute may accept the command with an
+unknown attribute. This could lead to a request for a dry run which performs
+an unexpected update. To avoid this, user space should check the policy dump
+and verify that the attribute is recognized before adding it to the command.
+
 Firmware Loading
 ================
 
diff --git a/include/net/devlink.h b/include/net/devlink.h
index 88c701b375a2..ff5b1e60ad6a 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -622,10 +622,12 @@ struct devlink_flash_update_params {
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
index b3d40a5d72ff..e24a5a808a12 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -576,6 +576,14 @@ enum devlink_attr {
 	DEVLINK_ATTR_LINECARD_TYPE,		/* string */
 	DEVLINK_ATTR_LINECARD_SUPPORTED_TYPES,	/* nested */
 
+	/* Before adding this attribute to a command, user space should check
+	 * the policy dump and verify the kernel recognizes the attribute.
+	 * Otherwise older kernels which do not recognize the attribute may
+	 * silently accept the unknown attribute while not actually performing
+	 * a dry run.
+	 */
+	DEVLINK_ATTR_DRY_RUN,			/* flag */
+
 	/* add new attributes above here, update the policy in devlink.c */
 
 	__DEVLINK_ATTR_MAX,
diff --git a/net/core/devlink.c b/net/core/devlink.c
index a9776ea923ae..7d403151bee2 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -4736,7 +4736,8 @@ EXPORT_SYMBOL_GPL(devlink_flash_update_timeout_notify);
 static int devlink_nl_cmd_flash_update(struct sk_buff *skb,
 				       struct genl_info *info)
 {
-	struct nlattr *nla_component, *nla_overwrite_mask, *nla_file_name;
+	struct nlattr *nla_component, *nla_overwrite_mask, *nla_file_name,
+		      *nla_dry_run;
 	struct devlink_flash_update_params params = {};
 	struct devlink *devlink = info->user_ptr[0];
 	const char *file_name;
@@ -4782,6 +4783,21 @@ static int devlink_nl_cmd_flash_update(struct sk_buff *skb,
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
@@ -8997,6 +9013,7 @@ static const struct nla_policy devlink_nl_policy[DEVLINK_ATTR_MAX + 1] = {
 	[DEVLINK_ATTR_RATE_PARENT_NODE_NAME] = { .type = NLA_NUL_STRING },
 	[DEVLINK_ATTR_LINECARD_INDEX] = { .type = NLA_U32 },
 	[DEVLINK_ATTR_LINECARD_TYPE] = { .type = NLA_NUL_STRING },
+	[DEVLINK_ATTR_DRY_RUN] = { .type = NLA_FLAG },
 };
 
 static const struct genl_small_ops devlink_nl_ops[] = {
-- 
2.35.1.456.ga9c7032d4631

