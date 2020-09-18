Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3F97270936
	for <lists+netdev@lfdr.de>; Sat, 19 Sep 2020 01:43:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726276AbgIRXnT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 19:43:19 -0400
Received: from mga03.intel.com ([134.134.136.65]:59399 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726250AbgIRXnQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Sep 2020 19:43:16 -0400
IronPort-SDR: 6NZ22YJiUkQD6My9Tg3jlsqpXbe0lbGDOLlnRMGr/HWvuCpNaIPETCVGFuI9bMBp06wBQt0jIv
 1CuAXgidWGWQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9748"; a="160113145"
X-IronPort-AV: E=Sophos;i="5.77,276,1596524400"; 
   d="scan'208";a="160113145"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2020 16:43:05 -0700
IronPort-SDR: bBhSA0cc21QCc4/UcQJeaNvWwH6/WVIw6hPKL0LPBSNetvU/gE/J8Sr7ihRS3LNS4VOfleb97A
 plHBLACTZpdA==
X-IronPort-AV: E=Sophos;i="5.77,276,1596524400"; 
   d="scan'208";a="332840560"
Received: from jekeller-desk.amr.corp.intel.com ([10.166.241.4])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2020 16:43:04 -0700
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Michael Chan <michael.chan@broadcom.com>,
        Bin Luo <luobin9@huawei.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>,
        Ido Schimmel <idosch@mellanox.com>,
        Danielle Ratson <danieller@mellanox.com>
Subject: [net-next v7 2/5] devlink: convert flash_update to use params structure
Date:   Fri, 18 Sep 2020 16:42:05 -0700
Message-Id: <20200918234208.1060371-3-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.28.0.497.g54e85e7af1ac
In-Reply-To: <20200918234208.1060371-1-jacob.e.keller@intel.com>
References: <20200918234208.1060371-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The devlink core recently gained support for checking whether the driver
supports a flash_update parameter, via `supported_flash_update_params`.
However, parameters are specified as function arguments. Adding a new
parameter still requires modifying the signature of the .flash_update
callback in all drivers.

Convert the .flash_update function to take a new `struct
devlink_flash_update_params` instead. By using this structure, and the
`supported_flash_update_params` bit field, a new parameter to
flash_update can be added without requiring modification to existing
drivers.

As before, all parameters except file_name will require driver opt-in.
Because file_name is a necessary field to for the flash_update to make
sense, no "SUPPORTED" bitflag is provided and it is always considered
valid. All future additional parameters will require a new bit in the
supported_flash_update_params bitfield.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Jakub Kicinski <kuba@kernel.org>
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
Changes since v6
* Applied param changes to the ionic driver
* Applied mlxsw changes to core.c instead of spectrum.c

 .../net/ethernet/broadcom/bnxt/bnxt_devlink.c  |  7 ++++---
 .../net/ethernet/huawei/hinic/hinic_devlink.c  |  5 ++---
 drivers/net/ethernet/intel/ice/ice_devlink.c   | 10 +++++-----
 .../net/ethernet/mellanox/mlx5/core/devlink.c  |  5 ++---
 drivers/net/ethernet/mellanox/mlxsw/core.c     |  9 ++++-----
 .../net/ethernet/netronome/nfp/nfp_devlink.c   |  7 ++++---
 .../ethernet/pensando/ionic/ionic_devlink.c    |  5 ++---
 drivers/net/netdevsim/dev.c                    | 14 +++++++-------
 include/net/devlink.h                          | 18 ++++++++++++++++--
 net/core/devlink.c                             | 14 ++++++++------
 .../selftests/drivers/net/netdevsim/devlink.sh |  3 +++
 11 files changed, 57 insertions(+), 40 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
index a17764db1419..d436134bdc40 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
@@ -17,8 +17,9 @@
 #include "bnxt_ethtool.h"
 
 static int
-bnxt_dl_flash_update(struct devlink *dl, const char *filename,
-		     const char *region, struct netlink_ext_ack *extack)
+bnxt_dl_flash_update(struct devlink *dl,
+		     struct devlink_flash_update_params *params,
+		     struct netlink_ext_ack *extack)
 {
 	struct bnxt *bp = bnxt_get_bp_from_dl(dl);
 	int rc;
@@ -31,7 +32,7 @@ bnxt_dl_flash_update(struct devlink *dl, const char *filename,
 
 	devlink_flash_update_begin_notify(dl);
 	devlink_flash_update_status_notify(dl, "Preparing to flash", NULL, 0, 0);
-	rc = bnxt_flash_package_from_file(bp->dev, filename, 0);
+	rc = bnxt_flash_package_from_file(bp->dev, params->file_name, 0);
 	if (!rc)
 		devlink_flash_update_status_notify(dl, "Flashing done", NULL, 0, 0);
 	else
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_devlink.c b/drivers/net/ethernet/huawei/hinic/hinic_devlink.c
index 662a27a514ae..2630d667f393 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_devlink.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_devlink.c
@@ -281,15 +281,14 @@ static int hinic_firmware_update(struct hinic_devlink_priv *priv,
 }
 
 static int hinic_devlink_flash_update(struct devlink *devlink,
-				      const char *file_name,
-				      const char *component,
+				      struct devlink_flash_update_params *params,
 				      struct netlink_ext_ack *extack)
 {
 	struct hinic_devlink_priv *priv = devlink_priv(devlink);
 	const struct firmware *fw;
 	int err;
 
-	err = request_firmware_direct(&fw, file_name,
+	err = request_firmware_direct(&fw, params->file_name,
 				      &priv->hwdev->hwif->pdev->dev);
 	if (err)
 		return err;
diff --git a/drivers/net/ethernet/intel/ice/ice_devlink.c b/drivers/net/ethernet/intel/ice/ice_devlink.c
index 6cdccd901637..4f8f9e229080 100644
--- a/drivers/net/ethernet/intel/ice/ice_devlink.c
+++ b/drivers/net/ethernet/intel/ice/ice_devlink.c
@@ -233,8 +233,7 @@ static int ice_devlink_info_get(struct devlink *devlink,
 /**
  * ice_devlink_flash_update - Update firmware stored in flash on the device
  * @devlink: pointer to devlink associated with device to update
- * @path: the path of the firmware file to use via request_firmware
- * @component: name of the component to update, or NULL
+ * @params: flash update parameters
  * @extack: netlink extended ACK structure
  *
  * Perform a device flash update. The bulk of the update logic is contained
@@ -243,8 +242,9 @@ static int ice_devlink_info_get(struct devlink *devlink,
  * Returns: zero on success, or an error code on failure.
  */
 static int
-ice_devlink_flash_update(struct devlink *devlink, const char *path,
-			 const char *component, struct netlink_ext_ack *extack)
+ice_devlink_flash_update(struct devlink *devlink,
+			 struct devlink_flash_update_params *params,
+			 struct netlink_ext_ack *extack)
 {
 	struct ice_pf *pf = devlink_priv(devlink);
 	struct device *dev = &pf->pdev->dev;
@@ -261,7 +261,7 @@ ice_devlink_flash_update(struct devlink *devlink, const char *path,
 	if (err)
 		return err;
 
-	err = request_firmware(&fw, path, dev);
+	err = request_firmware(&fw, params->file_name, dev);
 	if (err) {
 		NL_SET_ERR_MSG_MOD(extack, "Unable to read file from disk");
 		return err;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index fccae4b802b6..9b14e3f805a2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -8,15 +8,14 @@
 #include "eswitch.h"
 
 static int mlx5_devlink_flash_update(struct devlink *devlink,
-				     const char *file_name,
-				     const char *component,
+				     struct devlink_flash_update_params *params,
 				     struct netlink_ext_ack *extack)
 {
 	struct mlx5_core_dev *dev = devlink_priv(devlink);
 	const struct firmware *fw;
 	int err;
 
-	err = request_firmware_direct(&fw, file_name, &dev->pdev->dev);
+	err = request_firmware_direct(&fw, params->file_name, &dev->pdev->dev);
 	if (err)
 		return err;
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index 3ffd03ef9c0e..f8dddcf461f5 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -1102,13 +1102,13 @@ static int mlxsw_core_fw_rev_validate(struct mlxsw_core *mlxsw_core,
 }
 
 static int mlxsw_core_fw_flash_update(struct mlxsw_core *mlxsw_core,
-				      const char *file_name, const char *component,
+				      struct devlink_flash_update_params *params,
 				      struct netlink_ext_ack *extack)
 {
 	const struct firmware *firmware;
 	int err;
 
-	err = request_firmware_direct(&firmware, file_name, mlxsw_core->bus_info->dev);
+	err = request_firmware_direct(&firmware, params->file_name, mlxsw_core->bus_info->dev);
 	if (err)
 		return err;
 	err = mlxsw_core_fw_flash(mlxsw_core, firmware, extack);
@@ -1431,13 +1431,12 @@ mlxsw_devlink_core_bus_device_reload_up(struct devlink *devlink,
 }
 
 static int mlxsw_devlink_flash_update(struct devlink *devlink,
-				      const char *file_name,
-				      const char *component,
+				      struct devlink_flash_update_params *params,
 				      struct netlink_ext_ack *extack)
 {
 	struct mlxsw_core *mlxsw_core = devlink_priv(devlink);
 
-	return mlxsw_core_fw_flash_update(mlxsw_core, file_name, component, extack);
+	return mlxsw_core_fw_flash_update(mlxsw_core, params, extack);
 }
 
 static int mlxsw_devlink_trap_init(struct devlink *devlink,
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_devlink.c b/drivers/net/ethernet/netronome/nfp/nfp_devlink.c
index c93cb9a27e25..97d2b03208de 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_devlink.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_devlink.c
@@ -329,10 +329,11 @@ nfp_devlink_info_get(struct devlink *devlink, struct devlink_info_req *req,
 }
 
 static int
-nfp_devlink_flash_update(struct devlink *devlink, const char *path,
-			 const char *component, struct netlink_ext_ack *extack)
+nfp_devlink_flash_update(struct devlink *devlink,
+			 struct devlink_flash_update_params *params,
+			 struct netlink_ext_ack *extack)
 {
-	return nfp_flash_update_common(devlink_priv(devlink), path, extack);
+	return nfp_flash_update_common(devlink_priv(devlink), params->file_name, extack);
 }
 
 const struct devlink_ops nfp_devlink_ops = {
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_devlink.c b/drivers/net/ethernet/pensando/ionic/ionic_devlink.c
index c125988b0954..51d64718ed9f 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_devlink.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_devlink.c
@@ -10,13 +10,12 @@
 #include "ionic_devlink.h"
 
 static int ionic_dl_flash_update(struct devlink *dl,
-				 const char *fwname,
-				 const char *component,
+				 struct devlink_flash_update_params *params,
 				 struct netlink_ext_ack *extack)
 {
 	struct ionic *ionic = devlink_priv(dl);
 
-	return ionic_firmware_update(ionic->lif, fwname, extack);
+	return ionic_firmware_update(ionic->lif, params->file_name, extack);
 }
 
 static int ionic_dl_info_get(struct devlink *dl, struct devlink_info_req *req,
diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index 079df309ca4b..505f6edfc1d1 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -740,8 +740,8 @@ static int nsim_dev_info_get(struct devlink *devlink,
 #define NSIM_DEV_FLASH_CHUNK_SIZE 1000
 #define NSIM_DEV_FLASH_CHUNK_TIME_MS 10
 
-static int nsim_dev_flash_update(struct devlink *devlink, const char *file_name,
-				 const char *component,
+static int nsim_dev_flash_update(struct devlink *devlink,
+				 struct devlink_flash_update_params *params,
 				 struct netlink_ext_ack *extack)
 {
 	struct nsim_dev *nsim_dev = devlink_priv(devlink);
@@ -751,13 +751,13 @@ static int nsim_dev_flash_update(struct devlink *devlink, const char *file_name,
 		devlink_flash_update_begin_notify(devlink);
 		devlink_flash_update_status_notify(devlink,
 						   "Preparing to flash",
-						   component, 0, 0);
+						   params->component, 0, 0);
 	}
 
 	for (i = 0; i < NSIM_DEV_FLASH_SIZE / NSIM_DEV_FLASH_CHUNK_SIZE; i++) {
 		if (nsim_dev->fw_update_status)
 			devlink_flash_update_status_notify(devlink, "Flashing",
-							   component,
+							   params->component,
 							   i * NSIM_DEV_FLASH_CHUNK_SIZE,
 							   NSIM_DEV_FLASH_SIZE);
 		msleep(NSIM_DEV_FLASH_CHUNK_TIME_MS);
@@ -765,13 +765,13 @@ static int nsim_dev_flash_update(struct devlink *devlink, const char *file_name,
 
 	if (nsim_dev->fw_update_status) {
 		devlink_flash_update_status_notify(devlink, "Flashing",
-						   component,
+						   params->component,
 						   NSIM_DEV_FLASH_SIZE,
 						   NSIM_DEV_FLASH_SIZE);
 		devlink_flash_update_timeout_notify(devlink, "Flash select",
-						    component, 81);
+						    params->component, 81);
 		devlink_flash_update_status_notify(devlink, "Flashing done",
-						   component, 0, 0);
+						   params->component, 0, 0);
 		devlink_flash_update_end_notify(devlink);
 	}
 
diff --git a/include/net/devlink.h b/include/net/devlink.h
index 8f9324a45e13..61a08fed7ed5 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -550,6 +550,20 @@ enum devlink_param_generic_id {
 /* Firmware bundle identifier */
 #define DEVLINK_INFO_VERSION_GENERIC_FW_BUNDLE_ID	"fw.bundle_id"
 
+/**
+ * struct devlink_flash_update_params - Flash Update parameters
+ * @file_name: the name of the flash firmware file to update from
+ * @component: the flash component to update
+ *
+ * With the exception of file_name, drivers must opt-in to parameters by
+ * setting the appropriate bit in the supported_flash_update_params field in
+ * their devlink_ops structure.
+ */
+struct devlink_flash_update_params {
+	const char *file_name;
+	const char *component;
+};
+
 #define DEVLINK_SUPPORT_FLASH_UPDATE_COMPONENT	BIT(0)
 
 struct devlink_region;
@@ -1108,8 +1122,8 @@ struct devlink_ops {
 	 * parameters supported by the driver should be set in
 	 * supported_flash_update_params.
 	 */
-	int (*flash_update)(struct devlink *devlink, const char *file_name,
-			    const char *component,
+	int (*flash_update)(struct devlink *devlink,
+			    struct devlink_flash_update_params *params,
 			    struct netlink_ext_ack *extack);
 	/**
 	 * @trap_init: Trap initialization function.
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 11ef03a62c37..52c830b41561 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -3149,8 +3149,8 @@ EXPORT_SYMBOL_GPL(devlink_flash_update_timeout_notify);
 static int devlink_nl_cmd_flash_update(struct sk_buff *skb,
 				       struct genl_info *info)
 {
+	struct devlink_flash_update_params params = {};
 	struct devlink *devlink = info->user_ptr[0];
-	const char *file_name, *component = NULL;
 	struct nlattr *nla_component;
 	u32 supported_params;
 
@@ -3162,7 +3162,7 @@ static int devlink_nl_cmd_flash_update(struct sk_buff *skb,
 
 	supported_params = devlink->ops->supported_flash_update_params;
 
-	file_name = nla_data(info->attrs[DEVLINK_ATTR_FLASH_UPDATE_FILE_NAME]);
+	params.file_name = nla_data(info->attrs[DEVLINK_ATTR_FLASH_UPDATE_FILE_NAME]);
 
 	nla_component = info->attrs[DEVLINK_ATTR_FLASH_UPDATE_COMPONENT];
 	if (nla_component) {
@@ -3171,11 +3171,10 @@ static int devlink_nl_cmd_flash_update(struct sk_buff *skb,
 					    "component update is not supported by this device");
 			return -EOPNOTSUPP;
 		}
-		component = nla_data(nla_component);
+		params.component = nla_data(nla_component);
 	}
 
-	return devlink->ops->flash_update(devlink, file_name, component,
-					  info->extack);
+	return devlink->ops->flash_update(devlink, &params, info->extack);
 }
 
 static const struct devlink_param devlink_param_generic[] = {
@@ -9651,6 +9650,7 @@ void devlink_compat_running_version(struct net_device *dev,
 
 int devlink_compat_flash_update(struct net_device *dev, const char *file_name)
 {
+	struct devlink_flash_update_params params = {};
 	struct devlink *devlink;
 	int ret;
 
@@ -9663,8 +9663,10 @@ int devlink_compat_flash_update(struct net_device *dev, const char *file_name)
 		goto out;
 	}
 
+	params.file_name = file_name;
+
 	mutex_lock(&devlink->lock);
-	ret = devlink->ops->flash_update(devlink, file_name, NULL, NULL);
+	ret = devlink->ops->flash_update(devlink, &params, NULL);
 	mutex_unlock(&devlink->lock);
 
 out:
diff --git a/tools/testing/selftests/drivers/net/netdevsim/devlink.sh b/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
index de4b32fc4223..1e7541688978 100755
--- a/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
+++ b/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
@@ -23,6 +23,9 @@ fw_flash_test()
 	devlink dev flash $DL_HANDLE file dummy
 	check_err $? "Failed to flash with status updates on"
 
+	devlink dev flash $DL_HANDLE file dummy component fw.mgmt
+	check_err $? "Failed to flash with component attribute"
+
 	echo "n"> $DEBUGFS_DIR/fw_update_status
 	check_err $? "Failed to disable status updates"
 
-- 
2.28.0.497.g54e85e7af1ac

