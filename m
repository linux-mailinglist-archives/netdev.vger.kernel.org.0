Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 918F5233C11
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 01:20:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730835AbgG3XUi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 19:20:38 -0400
Received: from mga07.intel.com ([134.134.136.100]:4794 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730291AbgG3XU3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Jul 2020 19:20:29 -0400
IronPort-SDR: q4zmivgOpk0G/Sxl2v+/qv2DgWGd5xQRSqvr56qVwFWqt0qkOGGU9X5ElMfw+MPKnT27cMql5y
 aXWQ36WqKKPw==
X-IronPort-AV: E=McAfee;i="6000,8403,9698"; a="216166662"
X-IronPort-AV: E=Sophos;i="5.75,415,1589266800"; 
   d="scan'208";a="216166662"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2020 16:20:27 -0700
IronPort-SDR: ovT0LJWOovI8Cqj6zg+ZhoK86D3IJbHz/HG1M22SXHedWgrQfzg9oba68A6nYmxNEEF0AGWSD0
 5UU8iHcEgzUw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,415,1589266800"; 
   d="scan'208";a="395156801"
Received: from jekeller-desk.amr.corp.intel.com ([10.166.241.33])
  by fmsmga001.fm.intel.com with ESMTP; 30 Jul 2020 16:20:27 -0700
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Michael Chan <michael.chan@broadcom.com>,
        Bin Luo <luobin9@huawei.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>,
        Ido Schimmel <idosch@mellanox.com>,
        Danielle Ratson <danieller@mellanox.com>
Subject: [net-next 2/4] devlink: introduce flash update overwrite mask
Date:   Thu, 30 Jul 2020 16:20:06 -0700
Message-Id: <20200730232008.2648488-3-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.28.0.163.g6104cc2f0b60
In-Reply-To: <20200730232008.2648488-1-jacob.e.keller@intel.com>
References: <20200730232008.2648488-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sections of device flash may contain settings or device identifying
information. When performing a flash update, it is generally expected
that these settings and identifiers are not overwritten.

Sometimes it is useful to be able to overwrite these fields when
performing a flash update. To support this, a new attribute, the
DEVLINK_ATTR_FLASH_UPDATE_OVERWRITE_MASK is defined. This mask defines
the subsections of flash components that should be overwritten when
updating.

By default, only the flash binaries are updated. Two bits are defined
for specifying overwriting of the settings and device identifiers.

I chose to use a u32 instead of an nla_bitfield32 primarily because we
do not need the selector. This isn't a request to set bits in a stored
bitmask. Also, nla_bitfields aren't supported by libmnl currently, so it
would complicate enabling this in iproute2/devlink.

Modify most of the existing device drivers to reject overwrite mask
bits. It is assumed that they all preserve settings and identifiers
across updates.

Modify the ice driver to interpret the overwrite mode to an equivalent
preservation level request. Either overwriting settings, or overwriting
both settings and identifiers is supported. Due to the firmware
interface, a request for just overwriting identifiers is rejected.

For testing, I also modified the netdevsim driver to be able to
optionally control what overwrite mask it will accept.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Cc: Jiri Pirko <jiri@mellanox.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Michael Chan <michael.chan@broadcom.com>
Cc: Bin Luo <luobin9@huawei.com>
Cc: Saeed Mahameed <saeedm@mellanox.com>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Ido Schimmel <idosch@mellanox.com>
Cc: Danielle Ratson <danieller@mellanox.com>
---
 .../networking/devlink/devlink-flash.rst      | 29 +++++++++++++++++
 Documentation/networking/devlink/ice.rst      | 31 +++++++++++++++++++
 .../net/ethernet/broadcom/bnxt/bnxt_devlink.c |  2 +-
 .../net/ethernet/huawei/hinic/hinic_devlink.c |  2 +-
 drivers/net/ethernet/intel/ice/ice_devlink.c  | 18 ++++++++++-
 .../net/ethernet/intel/ice/ice_fw_update.c    | 16 ++++++++--
 .../net/ethernet/intel/ice/ice_fw_update.h    |  2 +-
 .../net/ethernet/mellanox/mlx5/core/devlink.c |  2 +-
 .../net/ethernet/mellanox/mlxsw/spectrum.c    |  2 +-
 .../net/ethernet/netronome/nfp/nfp_devlink.c  |  2 +-
 drivers/net/netdevsim/dev.c                   |  7 +++++
 drivers/net/netdevsim/netdevsim.h             |  1 +
 include/net/devlink.h                         |  1 +
 include/uapi/linux/devlink.h                  | 24 ++++++++++++++
 net/core/devlink.c                            |  8 ++++-
 .../drivers/net/netdevsim/devlink.sh          | 18 +++++++++++
 16 files changed, 155 insertions(+), 10 deletions(-)

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
 
diff --git a/Documentation/networking/devlink/ice.rst b/Documentation/networking/devlink/ice.rst
index 237848d56f9b..8eb50ba41f1a 100644
--- a/Documentation/networking/devlink/ice.rst
+++ b/Documentation/networking/devlink/ice.rst
@@ -81,6 +81,37 @@ The ``ice`` driver reports the following versions
       - 0xee16ced7
       - The first 4 bytes of the hash of the netlist module contents.
 
+Flash Update
+============
+
+The ``ice`` driver implements support for flash update using the
+``devlink-flash`` interface. It supports updating the device flash using a
+combined flash image that contains the ``fw.mgmt``, ``fw.undi``, and
+``fw.netlist`` components.
+
+.. list-table:: List of supported overwrite modes
+   :widths: 5 95
+
+   * - Bits
+     - Behavior
+   * - ``DEVLINK_FLASH_OVERWRITE_SETTINGS``
+     - Do not preserve settings stored in the flash components being
+       updated. This includes overwriting the port configuration that
+       determines the number of physical functions the device will
+       initialize with.
+   * - ``DEVLINK_FLASH_OVERWRITE_SETTINGS`` and ``DEVLINK_FLASH_OVERWRITE_IDENTIFIERS``
+     - Do not preserve either settings or identifiers. Overwrite everything
+       in the flash with the contents from the provided image, without
+       performing any preservation. This includes overwriting device
+       identifying fields such as the MAC address, VPD area, and device
+       serial number. It is expected that this combination be used with an
+       image customized for the specific device.
+
+The ice hardware does not support overwriting only identifiers while
+preserving settings, and thus ``DEVLINK_FLASH_OVERWRITE_IDENTIFIERS`` on its
+own will be rejected. If no overwrite mask is provided, the firmware will be
+instructed to preserve all settings and identifying fields when updating.
+
 Regions
 =======
 
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
index 1bdac16baf25..25389f28d763 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
@@ -24,7 +24,7 @@ bnxt_dl_flash_update(struct devlink *dl,
 	struct bnxt *bp = bnxt_get_bp_from_dl(dl);
 	int rc;
 
-	if (params->component)
+	if (params->component || params->overwrite_mask)
 		return -EOPNOTSUPP;
 
 	if (!BNXT_PF(bp)) {
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_devlink.c b/drivers/net/ethernet/huawei/hinic/hinic_devlink.c
index a252142b3523..e38cd61e948a 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_devlink.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_devlink.c
@@ -288,7 +288,7 @@ static int hinic_devlink_flash_update(struct devlink *devlink,
 	const struct firmware *fw;
 	int err;
 
-	if (params->component)
+	if (params->component || params->overwrite_mask)
 		return -EOPNOTSUPP;
 
 	err = request_firmware_direct(&fw, params->file_name,
diff --git a/drivers/net/ethernet/intel/ice/ice_devlink.c b/drivers/net/ethernet/intel/ice/ice_devlink.c
index c283b76a711f..f7fe59e60813 100644
--- a/drivers/net/ethernet/intel/ice/ice_devlink.c
+++ b/drivers/net/ethernet/intel/ice/ice_devlink.c
@@ -250,12 +250,28 @@ ice_devlink_flash_update(struct devlink *devlink,
 	struct device *dev = &pf->pdev->dev;
 	struct ice_hw *hw = &pf->hw;
 	const struct firmware *fw;
+	u8 preservation;
 	int err;
 
 	/* individual component update is not yet supported */
 	if (params->component)
 		return -EOPNOTSUPP;
 
+	if (!params->overwrite_mask) {
+		/* preserve all settings and identifiers */
+		preservation = ICE_AQC_NVM_PRESERVE_ALL;
+	} else if (params->overwrite_mask == DEVLINK_FLASH_OVERWRITE_SETTINGS) {
+		/* overwrite settings, but preserve the vital device identifiers */
+		preservation = ICE_AQC_NVM_PRESERVE_SELECTED;
+	} else if (params->overwrite_mask == (DEVLINK_FLASH_OVERWRITE_SETTINGS |
+					      DEVLINK_FLASH_OVERWRITE_IDENTIFIERS)) {
+		/* overwrite both settings and identifiers, preserve nothing */
+		preservation = ICE_AQC_NVM_NO_PRESERVATION;
+	} else {
+		NL_SET_ERR_MSG_MOD(extack, "Requested overwrite mask is not supported");
+		return -EOPNOTSUPP;
+	}
+
 	if (!hw->dev_caps.common_cap.nvm_unified_update) {
 		NL_SET_ERR_MSG_MOD(extack, "Current firmware does not support unified update");
 		return -EOPNOTSUPP;
@@ -274,7 +290,7 @@ ice_devlink_flash_update(struct devlink *devlink,
 	devlink_flash_update_begin_notify(devlink);
 	devlink_flash_update_status_notify(devlink, "Preparing to flash",
 					   params->component, 0, 0);
-	err = ice_flash_pldm_image(pf, fw, extack);
+	err = ice_flash_pldm_image(pf, fw, preservation, extack);
 	devlink_flash_update_end_notify(devlink);
 
 	release_firmware(fw);
diff --git a/drivers/net/ethernet/intel/ice/ice_fw_update.c b/drivers/net/ethernet/intel/ice/ice_fw_update.c
index deaefe00c9c0..c81273000d88 100644
--- a/drivers/net/ethernet/intel/ice/ice_fw_update.c
+++ b/drivers/net/ethernet/intel/ice/ice_fw_update.c
@@ -630,6 +630,7 @@ static const struct pldmfw_ops ice_fwu_ops = {
  * ice_flash_pldm_image - Write a PLDM-formatted firmware image to the device
  * @pf: private device driver structure
  * @fw: firmware object pointing to the relevant firmware file
+ * @preservation: preservation level to request from firmware
  * @extack: netlink extended ACK structure
  *
  * Parse the data for a given firmware file, verifying that it is a valid PLDM
@@ -643,7 +644,7 @@ static const struct pldmfw_ops ice_fwu_ops = {
  * Returns: zero on success or a negative error code on failure.
  */
 int ice_flash_pldm_image(struct ice_pf *pf, const struct firmware *fw,
-			 struct netlink_ext_ack *extack)
+			 u8 preservation, struct netlink_ext_ack *extack)
 {
 	struct device *dev = ice_pf_to_dev(pf);
 	struct ice_hw *hw = &pf->hw;
@@ -651,13 +652,24 @@ int ice_flash_pldm_image(struct ice_pf *pf, const struct firmware *fw,
 	enum ice_status status;
 	int err;
 
+	switch (preservation) {
+	case ICE_AQC_NVM_PRESERVE_ALL:
+	case ICE_AQC_NVM_PRESERVE_SELECTED:
+	case ICE_AQC_NVM_NO_PRESERVATION:
+	case ICE_AQC_NVM_FACTORY_DEFAULT:
+		break;
+	default:
+		WARN(1, "Unexpected preservation level request %u", preservation);
+		return -EINVAL;
+	}
+
 	memset(&priv, 0, sizeof(priv));
 
 	priv.context.ops = &ice_fwu_ops;
 	priv.context.dev = dev;
 	priv.extack = extack;
 	priv.pf = pf;
-	priv.activate_flags = ICE_AQC_NVM_PRESERVE_ALL;
+	priv.activate_flags = preservation;
 
 	status = ice_acquire_nvm(hw, ICE_RES_WRITE);
 	if (status) {
diff --git a/drivers/net/ethernet/intel/ice/ice_fw_update.h b/drivers/net/ethernet/intel/ice/ice_fw_update.h
index 79472cc618b4..c6390f6851ff 100644
--- a/drivers/net/ethernet/intel/ice/ice_fw_update.h
+++ b/drivers/net/ethernet/intel/ice/ice_fw_update.h
@@ -5,7 +5,7 @@
 #define _ICE_FW_UPDATE_H_
 
 int ice_flash_pldm_image(struct ice_pf *pf, const struct firmware *fw,
-			 struct netlink_ext_ack *extack);
+			 u8 preservation, struct netlink_ext_ack *extack);
 int ice_check_for_pending_update(struct ice_pf *pf, const char *component,
 				 struct netlink_ext_ack *extack);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index 785b3cdbe817..3399adbadb1f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -15,7 +15,7 @@ static int mlx5_devlink_flash_update(struct devlink *devlink,
 	const struct firmware *fw;
 	int err;
 
-	if (params->component)
+	if (params->component || params->overwrite_mask)
 		return -EOPNOTSUPP;
 
 	err = request_firmware_direct(&fw, params->file_name, &dev->pdev->dev);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 913d7800bc3e..cf4033a7a9d3 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -425,7 +425,7 @@ static int mlxsw_sp_flash_update(struct mlxsw_core *mlxsw_core,
 	const struct firmware *firmware;
 	int err;
 
-	if (params->component)
+	if (params->component || params->overwrite_mask)
 		return -EOPNOTSUPP;
 
 	err = request_firmware_direct(&firmware, params->file_name,
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_devlink.c b/drivers/net/ethernet/netronome/nfp/nfp_devlink.c
index e3a8e9e11346..da18fcbcbe72 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_devlink.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_devlink.c
@@ -333,7 +333,7 @@ nfp_devlink_flash_update(struct devlink *devlink,
 			 struct devlink_flash_update_params *params,
 			 struct netlink_ext_ack *extack)
 {
-	if (params->component)
+	if (params->component || params->overwrite_mask)
 		return -EOPNOTSUPP;
 	return nfp_flash_update_common(devlink_priv(devlink), params->file_name, extack);
 }
diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index d820d9422054..073801596095 100644
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
@@ -987,6 +992,7 @@ static int nsim_dev_reload_create(struct nsim_dev *nsim_dev,
 	INIT_LIST_HEAD(&nsim_dev->port_list);
 	mutex_init(&nsim_dev->port_list_lock);
 	nsim_dev->fw_update_status = true;
+	nsim_dev->fw_update_overwrite_mask = 0;
 
 	nsim_dev->fib_data = nsim_fib_create(devlink, extack);
 	if (IS_ERR(nsim_dev->fib_data))
@@ -1045,6 +1051,7 @@ int nsim_dev_probe(struct nsim_bus_dev *nsim_bus_dev)
 	INIT_LIST_HEAD(&nsim_dev->port_list);
 	mutex_init(&nsim_dev->port_list_lock);
 	nsim_dev->fw_update_status = true;
+	nsim_dev->fw_update_overwrite_mask = 0;
 	nsim_dev->max_macs = NSIM_DEV_MAX_MACS_DEFAULT;
 	nsim_dev->test1 = NSIM_DEV_TEST1_DEFAULT;
 	spin_lock_init(&nsim_dev->fa_cookie_lock);
diff --git a/drivers/net/netdevsim/netdevsim.h b/drivers/net/netdevsim/netdevsim.h
index d164052e0393..6ad1250c9362 100644
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
index 3113a6c22d89..95ce11c80ca9 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -519,6 +519,7 @@ enum devlink_param_generic_id {
 struct devlink_flash_update_params {
 	const char *file_name;
 	const char *component;
+	u32 overwrite_mask;
 };
 
 struct devlink_region;
diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index cfef4245ea5a..12cfd84c6956 100644
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
+	GENMASK(DEVLINK_FLASH_OVERWRITE_MAX_BIT, 0)
+
 /**
  * enum devlink_trap_action - Packet trap action.
  * @DEVLINK_TRAP_ACTION_DROP: Packet is dropped by the device and a copy is not
@@ -458,6 +480,8 @@ enum devlink_attr {
 	DEVLINK_ATTR_PORT_LANES,			/* u32 */
 	DEVLINK_ATTR_PORT_SPLITTABLE,			/* u8 */
 
+	DEVLINK_ATTR_FLASH_UPDATE_OVERWRITE_MASK,	/* u32 */
+
 	/* add new attributes above here, update the policy in devlink.c */
 
 	__DEVLINK_ATTR_MAX,
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 7a6483d52195..11bdc3ad150e 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -3115,7 +3115,7 @@ static int devlink_nl_cmd_flash_update(struct sk_buff *skb,
 {
 	struct devlink_flash_update_params params = {};
 	struct devlink *devlink = info->user_ptr[0];
-	struct nlattr *nla_component;
+	struct nlattr *nla_component, *nla_mask;
 
 	if (!devlink->ops->flash_update)
 		return -EOPNOTSUPP;
@@ -3128,6 +3128,10 @@ static int devlink_nl_cmd_flash_update(struct sk_buff *skb,
 	nla_component = info->attrs[DEVLINK_ATTR_FLASH_UPDATE_COMPONENT];
 	params.component = nla_component ? nla_data(nla_component) : NULL;
 
+	nla_mask = info->attrs[DEVLINK_ATTR_FLASH_UPDATE_OVERWRITE_MASK];
+	if (nla_mask)
+		params.overwrite_mask = nla_get_u32(nla_mask);
+
 	return devlink->ops->flash_update(devlink, &params, info->extack);
 }
 
@@ -7015,6 +7019,8 @@ static const struct nla_policy devlink_nl_policy[DEVLINK_ATTR_MAX + 1] = {
 	[DEVLINK_ATTR_HEALTH_REPORTER_AUTO_RECOVER] = { .type = NLA_U8 },
 	[DEVLINK_ATTR_FLASH_UPDATE_FILE_NAME] = { .type = NLA_NUL_STRING },
 	[DEVLINK_ATTR_FLASH_UPDATE_COMPONENT] = { .type = NLA_NUL_STRING },
+	[DEVLINK_ATTR_FLASH_UPDATE_OVERWRITE_MASK] =
+		NLA_POLICY_MAX(NLA_U32, DEVLINK_SUPPORTED_FLASH_OVERWRITE_SECTIONS),
 	[DEVLINK_ATTR_TRAP_NAME] = { .type = NLA_NUL_STRING },
 	[DEVLINK_ATTR_TRAP_ACTION] = { .type = NLA_U8 },
 	[DEVLINK_ATTR_TRAP_GROUP_NAME] = { .type = NLA_NUL_STRING },
diff --git a/tools/testing/selftests/drivers/net/netdevsim/devlink.sh b/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
index de4b32fc4223..48aadb1efd8b 100755
--- a/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
+++ b/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
@@ -23,6 +23,24 @@ fw_flash_test()
 	devlink dev flash $DL_HANDLE file dummy
 	check_err $? "Failed to flash with status updates on"
 
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
2.28.0.163.g6104cc2f0b60

