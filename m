Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A8E0224344
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 20:41:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728022AbgGQSlw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 14:41:52 -0400
Received: from mga17.intel.com ([192.55.52.151]:34716 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728252AbgGQSlw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Jul 2020 14:41:52 -0400
IronPort-SDR: +PQCQXniV/6DuXISNPhnkMXhIQt4nf2HHrKXDlnd3gd2aThY0LzviSyz9uZs+z5Dr2ux9kR/sY
 elilTlWZ0/sg==
X-IronPort-AV: E=McAfee;i="6000,8403,9685"; a="129736666"
X-IronPort-AV: E=Sophos;i="5.75,364,1589266800"; 
   d="scan'208";a="129736666"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2020 11:35:46 -0700
IronPort-SDR: hV1n1NVkLDLOldOLZjvGelHAmxmJvK35NiGTeJLz/IY/WFzEgZCRkKr5vetzNFvzFtuqYLcDH/
 eFM1KM0w9Fzg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,364,1589266800"; 
   d="scan'208";a="486542520"
Received: from jekeller-desk.amr.corp.intel.com ([10.166.241.33])
  by fmsmga006.fm.intel.com with ESMTP; 17 Jul 2020 11:35:45 -0700
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kubakici@wp.pl>, Jiri Pirko <jiri@resnulli.us>,
        Tom Herbert <tom@herbertland.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Michael Chan <michael.chan@broadcom.com>,
        Bin Luo <luobin9@huawei.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>,
        Ido Schimmel <idosch@mellanox.com>,
        Danielle Ratson <danieller@mellanox.com>
Subject: [RFC PATCH net-next v2 6/6] devlink: add overwrite mode to flash update
Date:   Fri, 17 Jul 2020 11:35:41 -0700
Message-Id: <20200717183541.797878-7-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.27.0.353.gb9a2d1a0207f
In-Reply-To: <20200717183541.797878-1-jacob.e.keller@intel.com>
References: <20200717183541.797878-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A flash image may contain settings or device identifying information.
When performing a flash update, these settings and information may
conflict with contents already in the flash. Devices may handle this
conflict in multiple ways.

Add a new attribute to the devlink command,
DEVLINK_ATTR_FLASH_UPDATE_OVERWRITE_MODE, which specifies how the device
should handle these settings and fields.

DEVLINK_FLASH_UPDATE_OVERWRITE_NOTHING, the default, requests that all
settings and device identifiers within the current flash are kept. That
is, no settings or fields will be overwritten. This is the expected
behavior for most updates, and appears to be how all of the drivers are
implemented today.

DEVLINK_FLASH_UPDATE_OVERWRITE_SETTINGS, requests that the device
overwrite any device settings in the flash section with the settings
from the flash image, but to preserve identifiers such as the MAC
address and serial identifier. This may be useful as a way to restore
a device to known-good settings from a new flash image.

DEVLINK_FLASH_UPDATE_OVERWRITE_EVERYTHING, requests that all content in
the flash image be preserved over content of flash on the device. This
mode requests the device to completely overwrite the flash section,
possibly changing settings and device identifiers. The primary
motivation is to support writing initial device identifiers during
manufacturing. It is not expected to be necessary in normal end-user
flash updates.

For the ice driver, implement support for the overwrite mode by
selecting the associated preservation level to request from firmware.

For all other drivers that support flash update, require that the mode
be DEVLINK_FLASH_UPDATE_OVERWRITE_NOTHING, which is the expected
default.

Update the documentation to explain the overwrite mode attribute.

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
 .../networking/devlink/devlink-flash.rst      | 31 +++++++++++++++++++
 Documentation/networking/devlink/ice.rst      | 27 ++++++++++++++++
 .../net/ethernet/broadcom/bnxt/bnxt_devlink.c |  7 ++++-
 .../net/ethernet/huawei/hinic/hinic_devlink.c |  3 ++
 drivers/net/ethernet/intel/ice/ice_devlink.c  |  6 ++--
 .../net/ethernet/intel/ice/ice_fw_update.c    | 24 +++++++++++++-
 .../net/ethernet/intel/ice/ice_fw_update.h    |  1 +
 .../net/ethernet/mellanox/mlx5/core/devlink.c |  4 +++
 drivers/net/ethernet/mellanox/mlxsw/core.c    |  3 +-
 drivers/net/ethernet/mellanox/mlxsw/core.h    |  1 +
 .../net/ethernet/mellanox/mlxsw/spectrum.c    |  4 +++
 .../net/ethernet/netronome/nfp/nfp_devlink.c  |  6 +++-
 drivers/net/netdevsim/dev.c                   |  1 +
 include/net/devlink.h                         |  1 +
 include/uapi/linux/devlink.h                  | 16 ++++++++++
 net/core/devlink.c                            | 16 ++++++++--
 16 files changed, 142 insertions(+), 9 deletions(-)

diff --git a/Documentation/networking/devlink/devlink-flash.rst b/Documentation/networking/devlink/devlink-flash.rst
index 40a87c0222cb..75f7e284a97a 100644
--- a/Documentation/networking/devlink/devlink-flash.rst
+++ b/Documentation/networking/devlink/devlink-flash.rst
@@ -16,6 +16,37 @@ Note that the file name is a path relative to the firmware loading path
 (usually ``/lib/firmware/``). Drivers may send status updates to inform
 user space about the progress of the update operation.
 
+Overwrite Mode
+==============
+
+The ``devlink-flash`` command allows optionally specifying an overwrite mode
+indicating how the device should handle static settings and fields in the
+device flash when updating.
+
+.. list-table:: List of overwrite modes
+   :widths: 5 95
+
+   * - Name
+     - Description
+   * - ``DEVLINK_FLASH_UPDATE_OVERWRITE_NOTHING``
+     - Do not overwrite any settings or fields in the device flash; only
+       update the associated firmware binaries. This preserves settings
+       stored in the flash, as well as device identifiers. This is the
+       default if no overwrite mode is specified.
+   * - ``DEVLINK_FLASH_UPDATE_OVERWRITE_SETTINGS``
+     - Overwrite device settings stored in the flash with settings from the
+       provided image, but do not overwrite device identifiers such as MAC
+       addresses or serial identifiers. This may be useful to restore a
+       device to default settings from a new image.
+   * - ``DEVLINK_FLASH_UPDATE_OVERWRITE_EVERYTHING``
+     - Overwrite everything in the device flash including settings and
+       device identifiers with the contents from the provided flash image.
+       Unless the provided image has been customized for this device, it
+       will result in clearing the identifying information in the device
+       flash. This mode is primarily intended for device manufacturers
+       performing initial device programming, and is not expected to be
+       necessary when performing regular flash updates.
+
 Firmware Loading
 ================
 
diff --git a/Documentation/networking/devlink/ice.rst b/Documentation/networking/devlink/ice.rst
index 237848d56f9b..0f4428d7e693 100644
--- a/Documentation/networking/devlink/ice.rst
+++ b/Documentation/networking/devlink/ice.rst
@@ -81,6 +81,33 @@ The ``ice`` driver reports the following versions
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
+   * - Name
+     - Behavior
+   * - ``DEVLINK_FLASH_UPDATE_OVERWRITE_NOTHING``
+     - Do not overwrite any settings or device identifying information.
+   * - ``DEVLINK_FLASH_UPDATE_OVERWRITE_SETTINGS``
+     - Overwrite device settings, but not identifying information. This
+       includes overwriting the port configuration that determines the
+       number of physical functions the device will initialize with.
+   * - ``DEVLINK_FLASH_UPDATE_OVERWRITE_EVERYTHING``
+     - Overwrite everything in the flash with the contents from the provided
+       flash image. This includes overwriting all settings as well as device
+       identifying information such as the MAC address and device serial
+       number. It is expected that this be used with an image customized for
+       the specific device, and is not necessary or expected in most
+       circumstances.
+
 Regions
 =======
 
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
index 3a854195d5b0..eec99acd9d39 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
@@ -18,7 +18,9 @@
 
 static int
 bnxt_dl_flash_update(struct devlink *dl, const char *filename,
-		     const char *region, struct netlink_ext_ack *extack)
+		     const char *region,
+		     enum devlink_flash_update_overwrite_mode mode,
+		     struct netlink_ext_ack *extack)
 {
 	struct bnxt *bp = bnxt_get_bp_from_dl(dl);
 	int rc;
@@ -26,6 +28,9 @@ bnxt_dl_flash_update(struct devlink *dl, const char *filename,
 	if (region)
 		return -EOPNOTSUPP;
 
+	if (mode != DEVLINK_FLASH_UPDATE_OVERWRITE_NOTHING)
+		return -EOPNOTSUPP;
+
 	if (!BNXT_PF(bp)) {
 		NL_SET_ERR_MSG_MOD(extack,
 				   "flash update not supported from a VF");
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_devlink.c b/drivers/net/ethernet/huawei/hinic/hinic_devlink.c
index a40a10ac1ee9..7994b5615b0e 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_devlink.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_devlink.c
@@ -283,6 +283,7 @@ static int hinic_firmware_update(struct hinic_devlink_priv *priv,
 static int hinic_devlink_flash_update(struct devlink *devlink,
 				      const char *file_name,
 				      const char *component,
+				      enum devlink_flash_update_overwrite_mode mode,
 				      struct netlink_ext_ack *extack)
 {
 	struct hinic_devlink_priv *priv = devlink_priv(devlink);
@@ -291,6 +292,8 @@ static int hinic_devlink_flash_update(struct devlink *devlink,
 
 	if (component)
 		return -EOPNOTSUPP;
+	if (mode != DEVLINK_FLASH_UPDATE_OVERWRITE_NOTHING)
+		return -EOPNOTSUPP;
 
 	err = request_firmware_direct(&fw, file_name,
 				      &priv->hwdev->hwif->pdev->dev);
diff --git a/drivers/net/ethernet/intel/ice/ice_devlink.c b/drivers/net/ethernet/intel/ice/ice_devlink.c
index dbbd8b6f9d1a..d53e5d86857a 100644
--- a/drivers/net/ethernet/intel/ice/ice_devlink.c
+++ b/drivers/net/ethernet/intel/ice/ice_devlink.c
@@ -244,7 +244,9 @@ static int ice_devlink_info_get(struct devlink *devlink,
  */
 static int
 ice_devlink_flash_update(struct devlink *devlink, const char *path,
-			 const char *component, struct netlink_ext_ack *extack)
+			 const char *component,
+			 enum devlink_flash_update_overwrite_mode mode,
+			 struct netlink_ext_ack *extack)
 {
 	struct ice_pf *pf = devlink_priv(devlink);
 	struct device *dev = &pf->pdev->dev;
@@ -274,7 +276,7 @@ ice_devlink_flash_update(struct devlink *devlink, const char *path,
 	devlink_flash_update_begin_notify(devlink);
 	devlink_flash_update_status_notify(devlink, "Preparing to flash",
 					   component, 0, 0);
-	err = ice_flash_pldm_image(pf, fw, extack);
+	err = ice_flash_pldm_image(pf, fw, mode, extack);
 	devlink_flash_update_end_notify(devlink);
 
 	release_firmware(fw);
diff --git a/drivers/net/ethernet/intel/ice/ice_fw_update.c b/drivers/net/ethernet/intel/ice/ice_fw_update.c
index 51b575ba197d..7d053e4879db 100644
--- a/drivers/net/ethernet/intel/ice/ice_fw_update.c
+++ b/drivers/net/ethernet/intel/ice/ice_fw_update.c
@@ -630,6 +630,7 @@ static const struct pldmfw_ops ice_fwu_ops = {
  * ice_flash_pldm_image - Write a PLDM-formatted firmware image to the device
  * @pf: private device driver structure
  * @fw: firmware object pointing to the relevant firmware file
+ * @mode: flash overwrite mode
  * @extack: netlink extended ACK structure
  *
  * Parse the data for a given firmware file, verifying that it is a valid PLDM
@@ -643,6 +644,7 @@ static const struct pldmfw_ops ice_fwu_ops = {
  * Returns: zero on success or a negative error code on failure.
  */
 int ice_flash_pldm_image(struct ice_pf *pf, const struct firmware *fw,
+			 enum devlink_flash_update_overwrite_mode mode,
 			 struct netlink_ext_ack *extack)
 {
 	struct device *dev = ice_pf_to_dev(pf);
@@ -657,7 +659,27 @@ int ice_flash_pldm_image(struct ice_pf *pf, const struct firmware *fw,
 	priv.context.dev = dev;
 	priv.extack = extack;
 	priv.pf = pf;
-	priv.activate_flags = ICE_AQC_NVM_PRESERVE_ALL;
+
+	/* Based on the requested overwrite mode, determine what preservation
+	 * level to specify when activating the NVM banks at the end of the
+	 * update.
+	 */
+	switch (mode) {
+	case DEVLINK_FLASH_UPDATE_OVERWRITE_NOTHING:
+		/* Preserve all settings and fields in the existing flash */
+		priv.activate_flags = ICE_AQC_NVM_PRESERVE_ALL;
+		break;
+	case DEVLINK_FLASH_UPDATE_OVERWRITE_SETTINGS:
+		/* Overwrite settings, but preserve limited fields */
+		priv.activate_flags = ICE_AQC_NVM_PRESERVE_SELECTED;
+		break;
+	case DEVLINK_FLASH_UPDATE_OVERWRITE_EVERYTHING:
+		/* Overwrite everything in the flash */
+		priv.activate_flags = ICE_AQC_NVM_NO_PRESERVATION;
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
 
 	status = ice_acquire_nvm(hw, ICE_RES_WRITE);
 	if (status) {
diff --git a/drivers/net/ethernet/intel/ice/ice_fw_update.h b/drivers/net/ethernet/intel/ice/ice_fw_update.h
index 79472cc618b4..66d539ae87d6 100644
--- a/drivers/net/ethernet/intel/ice/ice_fw_update.h
+++ b/drivers/net/ethernet/intel/ice/ice_fw_update.h
@@ -5,6 +5,7 @@
 #define _ICE_FW_UPDATE_H_
 
 int ice_flash_pldm_image(struct ice_pf *pf, const struct firmware *fw,
+			 enum devlink_flash_update_overwrite_mode mode,
 			 struct netlink_ext_ack *extack);
 int ice_check_for_pending_update(struct ice_pf *pf, const char *component,
 				 struct netlink_ext_ack *extack);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index c709e9a385f6..8c7472ff0376 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -10,6 +10,7 @@
 static int mlx5_devlink_flash_update(struct devlink *devlink,
 				     const char *file_name,
 				     const char *component,
+				     enum devlink_flash_update_overwrite_mode mode,
 				     struct netlink_ext_ack *extack)
 {
 	struct mlx5_core_dev *dev = devlink_priv(devlink);
@@ -19,6 +20,9 @@ static int mlx5_devlink_flash_update(struct devlink *devlink,
 	if (component)
 		return -EOPNOTSUPP;
 
+	if (mode != DEVLINK_FLASH_UPDATE_OVERWRITE_NOTHING)
+		return -EOPNOTSUPP;
+
 	err = request_firmware_direct(&fw, file_name, &dev->pdev->dev);
 	if (err)
 		return err;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index 1363168b3c82..310a863f0b69 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -1139,6 +1139,7 @@ mlxsw_devlink_core_bus_device_reload_up(struct devlink *devlink,
 static int mlxsw_devlink_flash_update(struct devlink *devlink,
 				      const char *file_name,
 				      const char *component,
+				      enum devlink_flash_update_overwrite_mode mode,
 				      struct netlink_ext_ack *extack)
 {
 	struct mlxsw_core *mlxsw_core = devlink_priv(devlink);
@@ -1147,7 +1148,7 @@ static int mlxsw_devlink_flash_update(struct devlink *devlink,
 	if (!mlxsw_driver->flash_update)
 		return -EOPNOTSUPP;
 	return mlxsw_driver->flash_update(mlxsw_core, file_name,
-					  component, extack);
+					  component, mode, extack);
 }
 
 static int mlxsw_devlink_trap_init(struct devlink *devlink,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.h b/drivers/net/ethernet/mellanox/mlxsw/core.h
index c1c1e039323a..d4ec9cb6e5f3 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.h
@@ -319,6 +319,7 @@ struct mlxsw_driver {
 				       u32 *p_cur, u32 *p_max);
 	int (*flash_update)(struct mlxsw_core *mlxsw_core,
 			    const char *file_name, const char *component,
+			    enum devlink_flash_update_overwrite_mode mode,
 			    struct netlink_ext_ack *extack);
 	int (*trap_init)(struct mlxsw_core *mlxsw_core,
 			 const struct devlink_trap *trap, void *trap_ctx);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 519eb44e4097..52f099659827 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -419,6 +419,7 @@ static int mlxsw_sp_fw_rev_validate(struct mlxsw_sp *mlxsw_sp)
 
 static int mlxsw_sp_flash_update(struct mlxsw_core *mlxsw_core,
 				 const char *file_name, const char *component,
+				 enum devlink_flash_update_overwrite_mode mode,
 				 struct netlink_ext_ack *extack)
 {
 	struct mlxsw_sp *mlxsw_sp = mlxsw_core_driver_priv(mlxsw_core);
@@ -428,6 +429,9 @@ static int mlxsw_sp_flash_update(struct mlxsw_core *mlxsw_core,
 	if (component)
 		return -EOPNOTSUPP;
 
+	if (mode != DEVLINK_FLASH_UPDATE_OVERWRITE_NOTHING)
+		return -EOPNOTSUPP;
+
 	err = request_firmware_direct(&firmware, file_name,
 				      mlxsw_sp->bus_info->dev);
 	if (err)
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_devlink.c b/drivers/net/ethernet/netronome/nfp/nfp_devlink.c
index be52510d446b..37401cde9fe9 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_devlink.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_devlink.c
@@ -330,10 +330,14 @@ nfp_devlink_info_get(struct devlink *devlink, struct devlink_info_req *req,
 
 static int
 nfp_devlink_flash_update(struct devlink *devlink, const char *path,
-			 const char *component, struct netlink_ext_ack *extack)
+			 const char *component,
+			 enum devlink_flash_update_overwrite_mode mode,
+			 struct netlink_ext_ack *extack)
 {
 	if (component)
 		return -EOPNOTSUPP;
+	if (mode != DEVLINK_FLASH_UPDATE_OVERWRITE_NOTHING)
+		return -EOPNOTSUPP;
 	return nfp_flash_update_common(devlink_priv(devlink), path, extack);
 }
 
diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index ce719c830a77..a75b1421d179 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -742,6 +742,7 @@ static int nsim_dev_info_get(struct devlink *devlink,
 
 static int nsim_dev_flash_update(struct devlink *devlink, const char *file_name,
 				 const char *component,
+				 enum devlink_flash_update_overwrite_mode mode,
 				 struct netlink_ext_ack *extack)
 {
 	struct nsim_dev *nsim_dev = devlink_priv(devlink);
diff --git a/include/net/devlink.h b/include/net/devlink.h
index 913e8679ae35..a851209c7145 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -1045,6 +1045,7 @@ struct devlink_ops {
 			struct netlink_ext_ack *extack);
 	int (*flash_update)(struct devlink *devlink, const char *file_name,
 			    const char *component,
+			    enum devlink_flash_update_overwrite_mode mode,
 			    struct netlink_ext_ack *extack);
 	/**
 	 * @trap_init: Trap initialization function.
diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index cfef4245ea5a..b5341fe5fa61 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -228,6 +228,20 @@ enum {
 	DEVLINK_ATTR_STATS_MAX = __DEVLINK_ATTR_STATS_MAX - 1
 };
 
+/* All flash update overwrite modes must be documented in
+ * Documentation/networking/devlink/devlink-flash.rst
+ */
+enum devlink_flash_update_overwrite_mode {
+	DEVLINK_FLASH_UPDATE_OVERWRITE_NOTHING,
+	DEVLINK_FLASH_UPDATE_OVERWRITE_SETTINGS,
+	DEVLINK_FLASH_UPDATE_OVERWRITE_EVERYTHING,
+
+	/* Add new flash overwrite modes above */
+	__DEVLINK_FLASH_UPDATE_OVERWRITE_MODE_MAX,
+	DEVLINK_FLASH_UPDATE_OVERWRITE_MODE_MAX =
+		__DEVLINK_FLASH_UPDATE_OVERWRITE_MODE_MAX - 1,
+};
+
 /**
  * enum devlink_trap_action - Packet trap action.
  * @DEVLINK_TRAP_ACTION_DROP: Packet is dropped by the device and a copy is not
@@ -458,6 +472,8 @@ enum devlink_attr {
 	DEVLINK_ATTR_PORT_LANES,			/* u32 */
 	DEVLINK_ATTR_PORT_SPLITTABLE,			/* u8 */
 
+	DEVLINK_ATTR_FLASH_UPDATE_OVERWRITE_MODE,	/* u8 */
+
 	/* add new attributes above here, update the policy in devlink.c */
 
 	__DEVLINK_ATTR_MAX,
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 6335e1851088..48b3a5739363 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -3097,9 +3097,10 @@ EXPORT_SYMBOL_GPL(devlink_flash_update_status_notify);
 static int devlink_nl_cmd_flash_update(struct sk_buff *skb,
 				       struct genl_info *info)
 {
+	enum devlink_flash_update_overwrite_mode mode;
 	struct devlink *devlink = info->user_ptr[0];
+	struct nlattr *nla_component, *nla_mode;
 	const char *file_name, *component;
-	struct nlattr *nla_component;
 
 	if (!devlink->ops->flash_update)
 		return -EOPNOTSUPP;
@@ -3111,7 +3112,13 @@ static int devlink_nl_cmd_flash_update(struct sk_buff *skb,
 	nla_component = info->attrs[DEVLINK_ATTR_FLASH_UPDATE_COMPONENT];
 	component = nla_component ? nla_data(nla_component) : NULL;
 
-	return devlink->ops->flash_update(devlink, file_name, component,
+	nla_mode = info->attrs[DEVLINK_ATTR_FLASH_UPDATE_OVERWRITE_MODE];
+	mode = nla_mode ? nla_get_u8(nla_mode) : DEVLINK_FLASH_UPDATE_OVERWRITE_NOTHING;
+
+	if (mode > DEVLINK_FLASH_UPDATE_OVERWRITE_MODE_MAX)
+		return -EINVAL;
+
+	return devlink->ops->flash_update(devlink, file_name, component, mode,
 					  info->extack);
 }
 
@@ -6999,6 +7006,7 @@ static const struct nla_policy devlink_nl_policy[DEVLINK_ATTR_MAX + 1] = {
 	[DEVLINK_ATTR_HEALTH_REPORTER_AUTO_RECOVER] = { .type = NLA_U8 },
 	[DEVLINK_ATTR_FLASH_UPDATE_FILE_NAME] = { .type = NLA_NUL_STRING },
 	[DEVLINK_ATTR_FLASH_UPDATE_COMPONENT] = { .type = NLA_NUL_STRING },
+	[DEVLINK_ATTR_FLASH_UPDATE_OVERWRITE_MODE] = { .type = NLA_U8 },
 	[DEVLINK_ATTR_TRAP_NAME] = { .type = NLA_NUL_STRING },
 	[DEVLINK_ATTR_TRAP_ACTION] = { .type = NLA_U8 },
 	[DEVLINK_ATTR_TRAP_GROUP_NAME] = { .type = NLA_NUL_STRING },
@@ -9564,7 +9572,9 @@ int devlink_compat_flash_update(struct net_device *dev, const char *file_name)
 	}
 
 	mutex_lock(&devlink->lock);
-	ret = devlink->ops->flash_update(devlink, file_name, NULL, NULL);
+	ret = devlink->ops->flash_update(devlink, file_name, NULL,
+					 DEVLINK_FLASH_UPDATE_OVERWRITE_NOTHING,
+					 NULL);
 	mutex_unlock(&devlink->lock);
 
 out:
-- 
2.27.0.353.gb9a2d1a0207f

