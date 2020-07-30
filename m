Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB7B8233C0C
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 01:20:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730803AbgG3XUa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 19:20:30 -0400
Received: from mga07.intel.com ([134.134.136.100]:4793 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730794AbgG3XU2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Jul 2020 19:20:28 -0400
IronPort-SDR: S8/qyI4FwQM+V35APG4jYRGrPt5uVAe7BrRB8k2P1uy36Q6HS5HhPJ5ofP7GecHeZVi2M7cI12
 MgTwofEmJK5Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9698"; a="216166658"
X-IronPort-AV: E=Sophos;i="5.75,415,1589266800"; 
   d="scan'208";a="216166658"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2020 16:20:26 -0700
IronPort-SDR: uVhUWQRIviWe1+0449tgMRPWo89PpP255d6L6lxYNuBMyX4IHRphOYvdbLGp5YpxQURVLl4N98
 +Wqktb3VLJ9A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,415,1589266800"; 
   d="scan'208";a="395156797"
Received: from jekeller-desk.amr.corp.intel.com ([10.166.241.33])
  by fmsmga001.fm.intel.com with ESMTP; 30 Jul 2020 16:20:26 -0700
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>
Subject: [net-next 1/4] devlink: convert flash_update to use params structure
Date:   Thu, 30 Jul 2020 16:20:05 -0700
Message-Id: <20200730232008.2648488-2-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.28.0.163.g6104cc2f0b60
In-Reply-To: <20200730232008.2648488-1-jacob.e.keller@intel.com>
References: <20200730232008.2648488-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A future change is going to introduce a new parameter for specifying how
devices should handle overwrite behavior when updating the flash. This
will introduce a new argument specifying a bitmask of component
subsections to allow overwriting behavior.

Prepare for this by converting flash_update to use a new
devlink_flash_update_params structure. For now this just holds the
file_name and component, but this enables more easily extending the
function with new parameters in the future.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
---
 .../net/ethernet/broadcom/bnxt/bnxt_devlink.c    | 15 ++++++++-------
 .../net/ethernet/huawei/hinic/hinic_devlink.c    |  7 +++----
 drivers/net/ethernet/intel/ice/ice_devlink.c     | 16 ++++++++--------
 .../net/ethernet/mellanox/mlx5/core/devlink.c    |  7 +++----
 drivers/net/ethernet/mellanox/mlxsw/core.c       |  6 ++----
 drivers/net/ethernet/mellanox/mlxsw/core.h       |  2 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c   |  6 +++---
 drivers/net/ethernet/netronome/nfp/nfp_devlink.c |  9 +++++----
 drivers/net/netdevsim/dev.c                      | 12 ++++++------
 include/net/devlink.h                            | 14 ++++++++++++--
 net/core/devlink.c                               | 15 +++++++++------
 11 files changed, 60 insertions(+), 49 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
index 3a854195d5b0..1bdac16baf25 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
@@ -17,13 +17,14 @@
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
 
-	if (region)
+	if (params->component)
 		return -EOPNOTSUPP;
 
 	if (!BNXT_PF(bp)) {
@@ -33,15 +34,15 @@ bnxt_dl_flash_update(struct devlink *dl, const char *filename,
 	}
 
 	devlink_flash_update_begin_notify(dl);
-	devlink_flash_update_status_notify(dl, "Preparing to flash", region, 0,
+	devlink_flash_update_status_notify(dl, "Preparing to flash", params->component, 0,
 					   0);
-	rc = bnxt_flash_package_from_file(bp->dev, filename, 0);
+	rc = bnxt_flash_package_from_file(bp->dev, params->file_name, 0);
 	if (!rc)
-		devlink_flash_update_status_notify(dl, "Flashing done", region,
+		devlink_flash_update_status_notify(dl, "Flashing done", params->component,
 						   0, 0);
 	else
 		devlink_flash_update_status_notify(dl, "Flashing failed",
-						   region, 0, 0);
+						   params->component, 0, 0);
 	devlink_flash_update_end_notify(dl);
 	return rc;
 }
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_devlink.c b/drivers/net/ethernet/huawei/hinic/hinic_devlink.c
index c6adc776f3c8..a252142b3523 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_devlink.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_devlink.c
@@ -281,18 +281,17 @@ static int hinic_firmware_update(struct hinic_devlink_priv *priv,
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
 
-	if (component)
+	if (params->component)
 		return -EOPNOTSUPP;
 
-	err = request_firmware_direct(&fw, file_name,
+	err = request_firmware_direct(&fw, params->file_name,
 				      &priv->hwdev->hwif->pdev->dev);
 	if (err)
 		return err;
diff --git a/drivers/net/ethernet/intel/ice/ice_devlink.c b/drivers/net/ethernet/intel/ice/ice_devlink.c
index dbbd8b6f9d1a..c283b76a711f 100644
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
@@ -253,7 +253,7 @@ ice_devlink_flash_update(struct devlink *devlink, const char *path,
 	int err;
 
 	/* individual component update is not yet supported */
-	if (component)
+	if (params->component)
 		return -EOPNOTSUPP;
 
 	if (!hw->dev_caps.common_cap.nvm_unified_update) {
@@ -261,11 +261,11 @@ ice_devlink_flash_update(struct devlink *devlink, const char *path,
 		return -EOPNOTSUPP;
 	}
 
-	err = ice_check_for_pending_update(pf, component, extack);
+	err = ice_check_for_pending_update(pf, params->component, extack);
 	if (err)
 		return err;
 
-	err = request_firmware(&fw, path, dev);
+	err = request_firmware(&fw, params->file_name, dev);
 	if (err) {
 		NL_SET_ERR_MSG_MOD(extack, "Unable to read file from disk");
 		return err;
@@ -273,7 +273,7 @@ ice_devlink_flash_update(struct devlink *devlink, const char *path,
 
 	devlink_flash_update_begin_notify(devlink);
 	devlink_flash_update_status_notify(devlink, "Preparing to flash",
-					   component, 0, 0);
+					   params->component, 0, 0);
 	err = ice_flash_pldm_image(pf, fw, extack);
 	devlink_flash_update_end_notify(devlink);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index c709e9a385f6..785b3cdbe817 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -8,18 +8,17 @@
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
 
-	if (component)
+	if (params->component)
 		return -EOPNOTSUPP;
 
-	err = request_firmware_direct(&fw, file_name, &dev->pdev->dev);
+	err = request_firmware_direct(&fw, params->file_name, &dev->pdev->dev);
 	if (err)
 		return err;
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index b01f8f2fab63..6db938708a0d 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -1138,8 +1138,7 @@ mlxsw_devlink_core_bus_device_reload_up(struct devlink *devlink,
 }
 
 static int mlxsw_devlink_flash_update(struct devlink *devlink,
-				      const char *file_name,
-				      const char *component,
+				      struct devlink_flash_update_params *params,
 				      struct netlink_ext_ack *extack)
 {
 	struct mlxsw_core *mlxsw_core = devlink_priv(devlink);
@@ -1147,8 +1146,7 @@ static int mlxsw_devlink_flash_update(struct devlink *devlink,
 
 	if (!mlxsw_driver->flash_update)
 		return -EOPNOTSUPP;
-	return mlxsw_driver->flash_update(mlxsw_core, file_name,
-					  component, extack);
+	return mlxsw_driver->flash_update(mlxsw_core, params, extack);
 }
 
 static int mlxsw_devlink_trap_init(struct devlink *devlink,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.h b/drivers/net/ethernet/mellanox/mlxsw/core.h
index c1c1e039323a..b6e3faf38305 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.h
@@ -318,7 +318,7 @@ struct mlxsw_driver {
 				       enum devlink_sb_pool_type pool_type,
 				       u32 *p_cur, u32 *p_max);
 	int (*flash_update)(struct mlxsw_core *mlxsw_core,
-			    const char *file_name, const char *component,
+			    struct devlink_flash_update_params *params,
 			    struct netlink_ext_ack *extack);
 	int (*trap_init)(struct mlxsw_core *mlxsw_core,
 			 const struct devlink_trap *trap, void *trap_ctx);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 519eb44e4097..913d7800bc3e 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -418,17 +418,17 @@ static int mlxsw_sp_fw_rev_validate(struct mlxsw_sp *mlxsw_sp)
 }
 
 static int mlxsw_sp_flash_update(struct mlxsw_core *mlxsw_core,
-				 const char *file_name, const char *component,
+				 struct devlink_flash_update_params *params,
 				 struct netlink_ext_ack *extack)
 {
 	struct mlxsw_sp *mlxsw_sp = mlxsw_core_driver_priv(mlxsw_core);
 	const struct firmware *firmware;
 	int err;
 
-	if (component)
+	if (params->component)
 		return -EOPNOTSUPP;
 
-	err = request_firmware_direct(&firmware, file_name,
+	err = request_firmware_direct(&firmware, params->file_name,
 				      mlxsw_sp->bus_info->dev);
 	if (err)
 		return err;
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_devlink.c b/drivers/net/ethernet/netronome/nfp/nfp_devlink.c
index be52510d446b..e3a8e9e11346 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_devlink.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_devlink.c
@@ -329,12 +329,13 @@ nfp_devlink_info_get(struct devlink *devlink, struct devlink_info_req *req,
 }
 
 static int
-nfp_devlink_flash_update(struct devlink *devlink, const char *path,
-			 const char *component, struct netlink_ext_ack *extack)
+nfp_devlink_flash_update(struct devlink *devlink,
+			 struct devlink_flash_update_params *params,
+			 struct netlink_ext_ack *extack)
 {
-	if (component)
+	if (params->component)
 		return -EOPNOTSUPP;
-	return nfp_flash_update_common(devlink_priv(devlink), path, extack);
+	return nfp_flash_update_common(devlink_priv(devlink), params->file_name, extack);
 }
 
 const struct devlink_ops nfp_devlink_ops = {
diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index ce719c830a77..d820d9422054 100644
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
@@ -765,11 +765,11 @@ static int nsim_dev_flash_update(struct devlink *devlink, const char *file_name,
 
 	if (nsim_dev->fw_update_status) {
 		devlink_flash_update_status_notify(devlink, "Flashing",
-						   component,
+						   params->component,
 						   NSIM_DEV_FLASH_SIZE,
 						   NSIM_DEV_FLASH_SIZE);
 		devlink_flash_update_status_notify(devlink, "Flashing done",
-						   component, 0, 0);
+						   params->component, 0, 0);
 		devlink_flash_update_end_notify(devlink);
 	}
 
diff --git a/include/net/devlink.h b/include/net/devlink.h
index 19d990c8edcc..3113a6c22d89 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -511,6 +511,16 @@ enum devlink_param_generic_id {
 /* Firmware bundle identifier */
 #define DEVLINK_INFO_VERSION_GENERIC_FW_BUNDLE_ID	"fw.bundle_id"
 
+/**
+ * struct devlink_flash_update_params - Flash Update parameters
+ * @file_name: the name of the flash firmware file to update from
+ * @component: the flash component to update
+ */
+struct devlink_flash_update_params {
+	const char *file_name;
+	const char *component;
+};
+
 struct devlink_region;
 struct devlink_info_req;
 
@@ -1045,8 +1055,8 @@ struct devlink_ops {
 				      struct netlink_ext_ack *extack);
 	int (*info_get)(struct devlink *devlink, struct devlink_info_req *req,
 			struct netlink_ext_ack *extack);
-	int (*flash_update)(struct devlink *devlink, const char *file_name,
-			    const char *component,
+	int (*flash_update)(struct devlink *devlink,
+			    struct devlink_flash_update_params *params,
 			    struct netlink_ext_ack *extack);
 	/**
 	 * @trap_init: Trap initialization function.
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 0ca89196a367..7a6483d52195 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -3113,8 +3113,8 @@ EXPORT_SYMBOL_GPL(devlink_flash_update_status_notify);
 static int devlink_nl_cmd_flash_update(struct sk_buff *skb,
 				       struct genl_info *info)
 {
+	struct devlink_flash_update_params params = {};
 	struct devlink *devlink = info->user_ptr[0];
-	const char *file_name, *component;
 	struct nlattr *nla_component;
 
 	if (!devlink->ops->flash_update)
@@ -3122,13 +3122,13 @@ static int devlink_nl_cmd_flash_update(struct sk_buff *skb,
 
 	if (!info->attrs[DEVLINK_ATTR_FLASH_UPDATE_FILE_NAME])
 		return -EINVAL;
-	file_name = nla_data(info->attrs[DEVLINK_ATTR_FLASH_UPDATE_FILE_NAME]);
+
+	params.file_name = nla_data(info->attrs[DEVLINK_ATTR_FLASH_UPDATE_FILE_NAME]);
 
 	nla_component = info->attrs[DEVLINK_ATTR_FLASH_UPDATE_COMPONENT];
-	component = nla_component ? nla_data(nla_component) : NULL;
+	params.component = nla_component ? nla_data(nla_component) : NULL;
 
-	return devlink->ops->flash_update(devlink, file_name, component,
-					  info->extack);
+	return devlink->ops->flash_update(devlink, &params, info->extack);
 }
 
 static const struct devlink_param devlink_param_generic[] = {
@@ -9527,6 +9527,7 @@ void devlink_compat_running_version(struct net_device *dev,
 
 int devlink_compat_flash_update(struct net_device *dev, const char *file_name)
 {
+	struct devlink_flash_update_params params = {};
 	struct devlink *devlink;
 	int ret;
 
@@ -9539,8 +9540,10 @@ int devlink_compat_flash_update(struct net_device *dev, const char *file_name)
 		goto out;
 	}
 
+	params.file_name = file_name;
+
 	mutex_lock(&devlink->lock);
-	ret = devlink->ops->flash_update(devlink, file_name, NULL, NULL);
+	ret = devlink->ops->flash_update(devlink, &params, NULL);
 	mutex_unlock(&devlink->lock);
 
 out:
-- 
2.28.0.163.g6104cc2f0b60

