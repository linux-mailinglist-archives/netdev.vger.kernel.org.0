Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C43812491CE
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 02:28:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726968AbgHSA2u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 20:28:50 -0400
Received: from mga05.intel.com ([192.55.52.43]:48087 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726410AbgHSA2p (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Aug 2020 20:28:45 -0400
IronPort-SDR: DHvpE5ChTSCDKZzPqdSggdYYl/Ft1zafgMopAXNBPh7hU65KI2o6PQuYGcQBCwywoT7FFte8n8
 tQWRkOFpQHtQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9717"; a="239856128"
X-IronPort-AV: E=Sophos;i="5.76,329,1592895600"; 
   d="scan'208";a="239856128"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2020 17:28:38 -0700
IronPort-SDR: I5xkQuAhIKpApTE0fQ2kAiVbzi9ZiM25RIFzbBksONSK2o3k6G2Xds/cDI0mdgMxm5bLShQC26
 psk7qOOnvxnQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,329,1592895600"; 
   d="scan'208";a="320283570"
Received: from jekeller-desk.amr.corp.intel.com ([10.166.241.33])
  by fmsmga004.fm.intel.com with ESMTP; 18 Aug 2020 17:28:38 -0700
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>
Subject: [net-next v3 3/4] devlink: introduce flash update overwrite mask
Date:   Tue, 18 Aug 2020 17:28:17 -0700
Message-Id: <20200819002821.2657515-4-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.28.0.218.ge27853923b9d.dirty
In-Reply-To: <20200819002821.2657515-1-jacob.e.keller@intel.com>
References: <20200819002821.2657515-1-jacob.e.keller@intel.com>
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

To provide some simple tests of the interface, modify the netdevsim
driver to enable support for this parameter and add a few self tests
used to make sure the attribute works. A new debugfs hook is used to
control what set of overwrite mask values the netdevsim driver will
accept.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
---
Changes since v2:
* re-wrote commit message, including additional clarification on the concept
  and reasoning.
* removed use of GENMASK in the uapi header. We can do a simple BIT()-1
  calculation instead, simplifying use in the devlink userspace program, and
  other programs which may not wish to pull in linux headers for GENMASK
  support.
* converted the overwrite mask to an nla_bitfield32. Both the selector
  and value bits must be set in order to be honored, as the bitmask sent to
  the driver is the bitwise AND of the two.

 .../networking/devlink/devlink-flash.rst      | 29 +++++++++++++++++++
 drivers/net/netdevsim/dev.c                   | 10 ++++++-
 drivers/net/netdevsim/netdevsim.h             |  1 +
 include/net/devlink.h                         |  4 ++-
 include/uapi/linux/devlink.h                  | 24 +++++++++++++++
 net/core/devlink.c                            | 17 ++++++++++-
 .../drivers/net/netdevsim/devlink.sh          | 18 ++++++++++++
 7 files changed, 100 insertions(+), 3 deletions(-)

diff --git a/Documentation/networking/devlink/devlink-flash.rst b/Documentation/networking/devlink/devlink-flash.rst
index 40a87c0222cb..bf97f5c8d4bd 100644
--- a/Documentation/networking/devlink/devlink-flash.rst
+++ b/Documentation/networking/devlink/devlink-flash.rst
@@ -16,6 +16,35 @@ Note that the file name is a path relative to the firmware loading path
 (usually ``/lib/firmware/``). Drivers may send status updates to inform
 user space about the progress of the update operation.
 
+Overwrite Mask
+==============
+
+The ``devlink-flash`` command allows optionally specifying a mask indicating
+the how the device should handle subsections of flash components when
+updating. This mask indicates the set of sections which are allowed to be
+overwritten.
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
 
diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index ebfc4a698809..74a869fbaa67 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -201,6 +201,8 @@ static int nsim_dev_debugfs_init(struct nsim_dev *nsim_dev)
 		return PTR_ERR(nsim_dev->ports_ddir);
 	debugfs_create_bool("fw_update_status", 0600, nsim_dev->ddir,
 			    &nsim_dev->fw_update_status);
+	debugfs_create_u32("fw_update_overwrite_mask", 0600, nsim_dev->ddir,
+			    &nsim_dev->fw_update_overwrite_mask);
 	debugfs_create_u32("max_macs", 0600, nsim_dev->ddir,
 			   &nsim_dev->max_macs);
 	debugfs_create_bool("test1", 0600, nsim_dev->ddir,
@@ -747,6 +749,9 @@ static int nsim_dev_flash_update(struct devlink *devlink,
 	struct nsim_dev *nsim_dev = devlink_priv(devlink);
 	int i;
 
+	if ((params->overwrite_mask & ~nsim_dev->fw_update_overwrite_mask) != 0)
+		return -EOPNOTSUPP;
+
 	if (nsim_dev->fw_update_status) {
 		devlink_flash_update_begin_notify(devlink);
 		devlink_flash_update_status_notify(devlink,
@@ -875,7 +880,8 @@ nsim_dev_devlink_trap_policer_counter_get(struct devlink *devlink,
 }
 
 static const struct devlink_ops nsim_dev_devlink_ops = {
-	.supported_flash_update_params = DEVLINK_SUPPORT_FLASH_UPDATE_COMPONENT,
+	.supported_flash_update_params = DEVLINK_SUPPORT_FLASH_UPDATE_COMPONENT |
+					 DEVLINK_SUPPORT_FLASH_UPDATE_OVERWRITE_MASK,
 	.reload_down = nsim_dev_reload_down,
 	.reload_up = nsim_dev_reload_up,
 	.info_get = nsim_dev_info_get,
@@ -990,6 +996,7 @@ static int nsim_dev_reload_create(struct nsim_dev *nsim_dev,
 	INIT_LIST_HEAD(&nsim_dev->port_list);
 	mutex_init(&nsim_dev->port_list_lock);
 	nsim_dev->fw_update_status = true;
+	nsim_dev->fw_update_overwrite_mask = 0;
 
 	nsim_dev->fib_data = nsim_fib_create(devlink, extack);
 	if (IS_ERR(nsim_dev->fib_data))
@@ -1048,6 +1055,7 @@ int nsim_dev_probe(struct nsim_bus_dev *nsim_bus_dev)
 	INIT_LIST_HEAD(&nsim_dev->port_list);
 	mutex_init(&nsim_dev->port_list_lock);
 	nsim_dev->fw_update_status = true;
+	nsim_dev->fw_update_overwrite_mask = 0;
 	nsim_dev->max_macs = NSIM_DEV_MAX_MACS_DEFAULT;
 	nsim_dev->test1 = NSIM_DEV_TEST1_DEFAULT;
 	spin_lock_init(&nsim_dev->fa_cookie_lock);
diff --git a/drivers/net/netdevsim/netdevsim.h b/drivers/net/netdevsim/netdevsim.h
index 284f7092241d..48ba33501450 100644
--- a/drivers/net/netdevsim/netdevsim.h
+++ b/drivers/net/netdevsim/netdevsim.h
@@ -185,6 +185,7 @@ struct nsim_dev {
 	struct list_head port_list;
 	struct mutex port_list_lock; /* protects port list */
 	bool fw_update_status;
+	u32 fw_update_overwrite_mask;
 	u32 max_macs;
 	bool test1;
 	bool dont_allow_reload;
diff --git a/include/net/devlink.h b/include/net/devlink.h
index a9aab735aef2..39fa60e127d9 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -523,9 +523,11 @@ enum devlink_param_generic_id {
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
index cfef4245ea5a..1d8bbe9c1ae1 100644
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
@@ -458,6 +480,8 @@ enum devlink_attr {
 	DEVLINK_ATTR_PORT_LANES,			/* u32 */
 	DEVLINK_ATTR_PORT_SPLITTABLE,			/* u8 */
 
+	DEVLINK_ATTR_FLASH_UPDATE_OVERWRITE_MASK,	/* bitfield32 */
+
 	/* add new attributes above here, update the policy in devlink.c */
 
 	__DEVLINK_ATTR_MAX,
diff --git a/net/core/devlink.c b/net/core/devlink.c
index dd6567775b24..cf74bd6468a3 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -3120,8 +3120,8 @@ static int devlink_nl_cmd_flash_update(struct sk_buff *skb,
 				       struct genl_info *info)
 {
 	struct devlink_flash_update_params params = {};
+	struct nlattr *nla_component, *nla_overwrite;
 	struct devlink *devlink = info->user_ptr[0];
-	struct nlattr *nla_component;
 	u32 supported_params;
 
 	if (!devlink->ops->flash_update)
@@ -3144,6 +3144,19 @@ static int devlink_nl_cmd_flash_update(struct sk_buff *skb,
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
 
@@ -7038,6 +7051,8 @@ static const struct nla_policy devlink_nl_policy[DEVLINK_ATTR_MAX + 1] = {
 	[DEVLINK_ATTR_HEALTH_REPORTER_AUTO_RECOVER] = { .type = NLA_U8 },
 	[DEVLINK_ATTR_FLASH_UPDATE_FILE_NAME] = { .type = NLA_NUL_STRING },
 	[DEVLINK_ATTR_FLASH_UPDATE_COMPONENT] = { .type = NLA_NUL_STRING },
+	[DEVLINK_ATTR_FLASH_UPDATE_OVERWRITE_MASK] =
+		NLA_POLICY_BITFIELD32(DEVLINK_SUPPORTED_FLASH_OVERWRITE_SECTIONS),
 	[DEVLINK_ATTR_TRAP_NAME] = { .type = NLA_NUL_STRING },
 	[DEVLINK_ATTR_TRAP_ACTION] = { .type = NLA_U8 },
 	[DEVLINK_ATTR_TRAP_GROUP_NAME] = { .type = NLA_NUL_STRING },
diff --git a/tools/testing/selftests/drivers/net/netdevsim/devlink.sh b/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
index 1e7541688978..40909c254365 100755
--- a/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
+++ b/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
@@ -26,6 +26,24 @@ fw_flash_test()
 	devlink dev flash $DL_HANDLE file dummy component fw.mgmt
 	check_err $? "Failed to flash with component attribute"
 
+	devlink dev flash $DL_HANDLE file dummy overwrite settings
+	check_fail $? "Flash with overwrite settings should be rejected"
+
+	echo "1"> $DEBUGFS_DIR/fw_update_overwrite_mask
+	check_err $? "Failed to change allowed overwrite mask"
+
+	devlink dev flash $DL_HANDLE file dummy overwrite settings
+	check_err $? "Failed to flash with settings overwrite enabled"
+
+	devlink dev flash $DL_HANDLE file dummy overwrite identifiers
+	check_fail $? "Flash with overwrite settings should be identifiers"
+
+	echo "3"> $DEBUGFS_DIR/fw_update_overwrite_mask
+	check_err $? "Failed to change allowed overwrite mask"
+
+	devlink dev flash $DL_HANDLE file dummy overwrite identifiers overwrite settings
+	check_err $? "Failed to flash with settings and identifiers overwrite enabled"
+
 	echo "n"> $DEBUGFS_DIR/fw_update_status
 	check_err $? "Failed to disable status updates"
 
-- 
2.28.0.218.ge27853923b9d.dirty

