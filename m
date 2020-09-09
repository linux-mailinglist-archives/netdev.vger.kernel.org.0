Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 834452638F6
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 00:28:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728443AbgIIW16 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 18:27:58 -0400
Received: from mga07.intel.com ([134.134.136.100]:30341 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726426AbgIIW1w (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Sep 2020 18:27:52 -0400
IronPort-SDR: r4nsOiFdPtlXLr+7NkzClN7IkV6nd6CSehe/OEpvI/UJKI6/E9UHrgPYy8j3VpGRd68jbvQUWM
 SAB7hPU4RH4Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9739"; a="222627348"
X-IronPort-AV: E=Sophos;i="5.76,410,1592895600"; 
   d="scan'208";a="222627348"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2020 15:27:48 -0700
IronPort-SDR: SDck4ZORq2A1065nfPFkgo0gvY18AfxCMGBvpG0Nj025RiWo+mcEDac47fS51nEsl2/IGU2leU
 bpDTBQIE3c+Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,410,1592895600"; 
   d="scan'208";a="285017347"
Received: from jekeller-desk.amr.corp.intel.com ([10.166.241.4])
  by fmsmga007.fm.intel.com with ESMTP; 09 Sep 2020 15:27:48 -0700
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>
Subject: [net-next v4 3/5] devlink: introduce flash update overwrite mask
Date:   Wed,  9 Sep 2020 15:26:51 -0700
Message-Id: <20200909222653.32994-4-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.28.0.218.ge27853923b9d.dirty
In-Reply-To: <20200909222653.32994-1-jacob.e.keller@intel.com>
References: <20200909222653.32994-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sections of device flash may contain settings or device identifying
information. When performing a flash update, it is generally expected
that these settings and identifiers are not overwritten.

However, it may sometimes be useful to allow overwriting these fields
when performing a flash update. Some examples include, 1) customizing
the initial device config on first programming, such as overwriting
default device identifying information, or 2) reverting a device
configuration to known good state provided in the new firmware image, or
3) in case it is suspected that current firmware logic for managing the
preservation of fields during an update is broken.

Although some devices are able to completely separate these types of
settings and fields into separate components, this is not true for all
hardware.

To support controlling this behavior, a new
DEVLINK_ATTR_FLASH_UPDATE_OVERWRITE_MASK is defined. This is an
nla_bitfield32 which will define what subset of fields in a component
should be overwritten during an update.

If no bits are specified, or of the overwrite mask is not provided, then
an update should not overwrite anything, and should maintain the
settings and identifiers as they are in the previous image.

If the overwrite mask has the DEVLINK_FLASH_OVERWRITE_SETTINGS bit set,
then the device should be configured to overwrite any of the settings in
the requested component with settings found in the provided image.

Similarly, if the DEVLINK_FLASH_OVERWRITE_IDENTIFIERS bit is set, the
device should be configured to overwrite any device identifiers in the
requested component with the identifiers from the image.

Multiple overwrite modes may be combined to indicate that a combination
of the set of fields that should be overwritten.

Drivers which support the new overwrite mask must set the
DEVLINK_SUPPORT_FLASH_UPDATE_OVERWRITE_MASK in the
supported_flash_update_params field of their devlink_ops.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
---
Changes since v3
* split netdevsim driver changes to a new patch
* fixed a double-the typo in the documentation

 .../networking/devlink/devlink-flash.rst      | 28 +++++++++++++++++++
 include/net/devlink.h                         |  4 ++-
 include/uapi/linux/devlink.h                  | 25 +++++++++++++++++
 net/core/devlink.c                            | 17 ++++++++++-
 4 files changed, 72 insertions(+), 2 deletions(-)

diff --git a/Documentation/networking/devlink/devlink-flash.rst b/Documentation/networking/devlink/devlink-flash.rst
index 40a87c0222cb..603e732f00cc 100644
--- a/Documentation/networking/devlink/devlink-flash.rst
+++ b/Documentation/networking/devlink/devlink-flash.rst
@@ -16,6 +16,34 @@ Note that the file name is a path relative to the firmware loading path
 (usually ``/lib/firmware/``). Drivers may send status updates to inform
 user space about the progress of the update operation.
 
+Overwrite Mask
+==============
+
+The ``devlink-flash`` command allows optionally specifying a mask indicating
+how the device should handle subsections of flash components when updating.
+This mask indicates the set of sections which are allowed to be overwritten.
+
+.. list-table:: List of overwrite mask bits
+   :widths: 5 95
+
+   * - Name
+     - Description
+   * - ``DEVLINK_FLASH_OVERWRITE_SETTINGS``
+     - Indicates that the device should overwrite settings in the components
+       being updated with the settings found in the provided image.
+   * - ``DEVLINK_FLASH_OVERWRITE_IDENTIFIERS``
+     - Indicates that the device should overwrite identifiers in the
+       components being updated with the identifiers found in the provided
+       image. This includes MAC addresses, serial IDs, and similar device
+       identifiers.
+
+Multiple overwrite bits may be combined and requested together. If no bits
+are provided, it is expected that the device only update firmware binaries
+in the components being updated. Settings and identifiers are expected to be
+preserved across the update. A device may not support every combination and
+the driver for such a device must reject any combination which cannot be
+faithfully implemented.
+
 Firmware Loading
 ================
 
diff --git a/include/net/devlink.h b/include/net/devlink.h
index 3384e901bbf0..ff4638f7e547 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -543,9 +543,11 @@ enum devlink_param_generic_id {
 struct devlink_flash_update_params {
 	const char *file_name;
 	const char *component;
+	u32 overwrite_mask;
 };
 
-#define DEVLINK_SUPPORT_FLASH_UPDATE_COMPONENT	BIT(0)
+#define DEVLINK_SUPPORT_FLASH_UPDATE_COMPONENT		BIT(0)
+#define DEVLINK_SUPPORT_FLASH_UPDATE_OVERWRITE_MASK	BIT(1)
 
 struct devlink_region;
 struct devlink_info_req;
diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index 40d35145c879..19a573566359 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -228,6 +228,28 @@ enum {
 	DEVLINK_ATTR_STATS_MAX = __DEVLINK_ATTR_STATS_MAX - 1
 };
 
+/* Specify what sections of a flash component can be overwritten when
+ * performing an update. Overwriting of firmware binary sections is always
+ * implicitly assumed to be allowed.
+ *
+ * Each section must be documented in
+ * Documentation/networking/devlink/devlink-flash.rst
+ *
+ */
+enum {
+	DEVLINK_FLASH_OVERWRITE_SETTINGS_BIT,
+	DEVLINK_FLASH_OVERWRITE_IDENTIFIERS_BIT,
+
+	__DEVLINK_FLASH_OVERWRITE_MAX_BIT,
+	DEVLINK_FLASH_OVERWRITE_MAX_BIT = __DEVLINK_FLASH_OVERWRITE_MAX_BIT - 1
+};
+
+#define DEVLINK_FLASH_OVERWRITE_SETTINGS BIT(DEVLINK_FLASH_OVERWRITE_SETTINGS_BIT)
+#define DEVLINK_FLASH_OVERWRITE_IDENTIFIERS BIT(DEVLINK_FLASH_OVERWRITE_IDENTIFIERS_BIT)
+
+#define DEVLINK_SUPPORTED_FLASH_OVERWRITE_SECTIONS \
+	(BIT(__DEVLINK_FLASH_OVERWRITE_MAX_BIT) - 1)
+
 /**
  * enum devlink_trap_action - Packet trap action.
  * @DEVLINK_TRAP_ACTION_DROP: Packet is dropped by the device and a copy is not
@@ -460,6 +482,9 @@ enum devlink_attr {
 
 	DEVLINK_ATTR_PORT_EXTERNAL,		/* u8 */
 	DEVLINK_ATTR_PORT_CONTROLLER_NUMBER,	/* u32 */
+
+	DEVLINK_ATTR_FLASH_UPDATE_OVERWRITE_MASK,	/* bitfield32 */
+
 	/* add new attributes above here, update the policy in devlink.c */
 
 	__DEVLINK_ATTR_MAX,
diff --git a/net/core/devlink.c b/net/core/devlink.c
index c61f9c8205f6..d0d38ca17ea8 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -3125,8 +3125,8 @@ static int devlink_nl_cmd_flash_update(struct sk_buff *skb,
 				       struct genl_info *info)
 {
 	struct devlink_flash_update_params params = {};
+	struct nlattr *nla_component, *nla_overwrite;
 	struct devlink *devlink = info->user_ptr[0];
-	struct nlattr *nla_component;
 	u32 supported_params;
 
 	if (!devlink->ops->flash_update)
@@ -3149,6 +3149,19 @@ static int devlink_nl_cmd_flash_update(struct sk_buff *skb,
 		params.component = nla_data(nla_component);
 	}
 
+	nla_overwrite = info->attrs[DEVLINK_ATTR_FLASH_UPDATE_OVERWRITE_MASK];
+	if (nla_overwrite) {
+		struct nla_bitfield32 sections;
+
+		if (!(supported_params & DEVLINK_SUPPORT_FLASH_UPDATE_OVERWRITE_MASK)) {
+			NL_SET_ERR_MSG_ATTR(info->extack, nla_overwrite,
+					    "overwrite is not supported");
+			return -EOPNOTSUPP;
+		}
+		sections = nla_get_bitfield32(nla_overwrite);
+		params.overwrite_mask = sections.value & sections.selector;
+	}
+
 	return devlink->ops->flash_update(devlink, &params, info->extack);
 }
 
@@ -7046,6 +7059,8 @@ static const struct nla_policy devlink_nl_policy[DEVLINK_ATTR_MAX + 1] = {
 	[DEVLINK_ATTR_HEALTH_REPORTER_AUTO_RECOVER] = { .type = NLA_U8 },
 	[DEVLINK_ATTR_FLASH_UPDATE_FILE_NAME] = { .type = NLA_NUL_STRING },
 	[DEVLINK_ATTR_FLASH_UPDATE_COMPONENT] = { .type = NLA_NUL_STRING },
+	[DEVLINK_ATTR_FLASH_UPDATE_OVERWRITE_MASK] =
+		NLA_POLICY_BITFIELD32(DEVLINK_SUPPORTED_FLASH_OVERWRITE_SECTIONS),
 	[DEVLINK_ATTR_TRAP_NAME] = { .type = NLA_NUL_STRING },
 	[DEVLINK_ATTR_TRAP_ACTION] = { .type = NLA_U8 },
 	[DEVLINK_ATTR_TRAP_GROUP_NAME] = { .type = NLA_NUL_STRING },
-- 
2.28.0.218.ge27853923b9d.dirty

