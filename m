Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 735FE2491D7
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 02:32:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726803AbgHSAcm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 20:32:42 -0400
Received: from mga05.intel.com ([192.55.52.43]:48092 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726847AbgHSAck (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Aug 2020 20:32:40 -0400
IronPort-SDR: zzPW1MKqiIkm16p2CAoElRzvZjBtwM1QVa+WqNQSPpNw49v6GTNiFEWxiI7Zu63DLtI4r4x/OY
 KLe3gWmKyhVg==
X-IronPort-AV: E=McAfee;i="6000,8403,9717"; a="239856126"
X-IronPort-AV: E=Sophos;i="5.76,329,1592895600"; 
   d="scan'208";a="239856126"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2020 17:28:38 -0700
IronPort-SDR: ZU3K2ohQCs/7XDFwfNYSBN/tjkabaUwzMIVBdsPg5r9GYuJgM+G9Jy0ik/HFlH3EAcWfWXTOm+
 Z8it+4jNpYXA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,329,1592895600"; 
   d="scan'208";a="320283565"
Received: from jekeller-desk.amr.corp.intel.com ([10.166.241.33])
  by fmsmga004.fm.intel.com with ESMTP; 18 Aug 2020 17:28:37 -0700
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
Subject: [net-next v3 2/4] devlink: convert flash_update to use params structure
Date:   Tue, 18 Aug 2020 17:28:16 -0700
Message-Id: <20200819002821.2657515-3-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.28.0.218.ge27853923b9d.dirty
In-Reply-To: <20200819002821.2657515-1-jacob.e.keller@intel.com>
References: <20200819002821.2657515-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
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
Changes since v2:
* split this conversion to a params struct into a separate patch, as
  suggested by Jiri.

 .../net/ethernet/broadcom/bnxt/bnxt_devlink.c  |  7 ++++---
 .../net/ethernet/huawei/hinic/hinic_devlink.c  |  5 ++---
 drivers/net/ethernet/intel/ice/ice_devlink.c   | 10 +++++-----
 .../net/ethernet/mellanox/mlx5/core/devlink.c  |  5 ++---
 drivers/net/ethernet/mellanox/mlxsw/core.c     |  6 ++----
 drivers/net/ethernet/mellanox/mlxsw/core.h     |  2 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c |  4 ++--
 .../net/ethernet/netronome/nfp/nfp_devlink.c   |  7 ++++---
 drivers/net/netdevsim/dev.c                    | 12 ++++++------
 include/net/devlink.h                          | 18 ++++++++++++++++--
 net/core/devlink.c                             | 14 ++++++++------
 .../selftests/drivers/net/netdevsim/devlink.sh |  3 +++
 12 files changed, 55 insertions(+), 38 deletions(-)

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
index 08d101138fbe..cba99f270192 100644
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
index 11af3308f8cc..9630b2482b22 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.h
@@ -325,7 +325,7 @@ struct mlxsw_driver {
 				       enum devlink_sb_pool_type pool_type,
 				       u32 *p_cur, u32 *p_max);
 	int (*flash_update)(struct mlxsw_core *mlxsw_core,
-			    const char *file_name, const char *component,
+			    struct devlink_flash_update_params *params,
 			    struct netlink_ext_ack *extack);
 	int (*trap_init)(struct mlxsw_core *mlxsw_core,
 			 const struct devlink_trap *trap, void *trap_ctx);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 95ddc1212d0e..297ec13218b4 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -418,14 +418,14 @@ static int mlxsw_sp_fw_rev_validate(struct mlxsw_sp *mlxsw_sp)
 }
 
 static int mlxsw_sp_flash_update(struct mlxsw_core *mlxsw_core,
-				 const char *file_name, const char *component,
+				 struct devlink_flash_update_params *params,
 				 struct netlink_ext_ack *extack)
 {
 	struct mlxsw_sp *mlxsw_sp = mlxsw_core_driver_priv(mlxsw_core);
 	const struct firmware *firmware;
 	int err;
 
-	err = request_firmware_direct(&firmware, file_name,
+	err = request_firmware_direct(&firmware, params->file_name,
 				      mlxsw_sp->bus_info->dev);
 	if (err)
 		return err;
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
diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index 1219637ab36e..ebfc4a698809 100644
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
index 1ef4b832f37b..a9aab735aef2 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -511,6 +511,20 @@ enum devlink_param_generic_id {
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
@@ -1066,8 +1080,8 @@ struct devlink_ops {
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
index b596b45c8fd8..dd6567775b24 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -3119,8 +3119,8 @@ EXPORT_SYMBOL_GPL(devlink_flash_update_status_notify);
 static int devlink_nl_cmd_flash_update(struct sk_buff *skb,
 				       struct genl_info *info)
 {
+	struct devlink_flash_update_params params = {};
 	struct devlink *devlink = info->user_ptr[0];
-	const char *file_name, *component = NULL;
 	struct nlattr *nla_component;
 	u32 supported_params;
 
@@ -3132,7 +3132,7 @@ static int devlink_nl_cmd_flash_update(struct sk_buff *skb,
 
 	supported_params = devlink->ops->supported_flash_update_params;
 
-	file_name = nla_data(info->attrs[DEVLINK_ATTR_FLASH_UPDATE_FILE_NAME]);
+	params.file_name = nla_data(info->attrs[DEVLINK_ATTR_FLASH_UPDATE_FILE_NAME]);
 
 	nla_component = info->attrs[DEVLINK_ATTR_FLASH_UPDATE_COMPONENT];
 	if (nla_component) {
@@ -3141,11 +3141,10 @@ static int devlink_nl_cmd_flash_update(struct sk_buff *skb,
 					    "component update is not supported");
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
@@ -9554,6 +9553,7 @@ void devlink_compat_running_version(struct net_device *dev,
 
 int devlink_compat_flash_update(struct net_device *dev, const char *file_name)
 {
+	struct devlink_flash_update_params params = {};
 	struct devlink *devlink;
 	int ret;
 
@@ -9566,8 +9566,10 @@ int devlink_compat_flash_update(struct net_device *dev, const char *file_name)
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
2.28.0.218.ge27853923b9d.dirty

