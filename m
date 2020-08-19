Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4D7C2491CC
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 02:28:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726918AbgHSA2p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 20:28:45 -0400
Received: from mga05.intel.com ([192.55.52.43]:48087 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726835AbgHSA2k (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Aug 2020 20:28:40 -0400
IronPort-SDR: JGg7meSk3ovBY2jUNNkQKVSZ5rMoEkDEyWAJ03inZ/O0otLc6FItK6Nhy4co6UCeR2WQ/2OrSh
 oIWogCr5coPg==
X-IronPort-AV: E=McAfee;i="6000,8403,9717"; a="239856124"
X-IronPort-AV: E=Sophos;i="5.76,329,1592895600"; 
   d="scan'208";a="239856124"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2020 17:28:37 -0700
IronPort-SDR: oqOL1NiKyhM+ebjD2P/pIPDk++xMqq82tjb052pUTMjDEcTP3g1bMW6280qFPGi/VCK3R7a34V
 BtsTSFJWHepg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,329,1592895600"; 
   d="scan'208";a="320283556"
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
Subject: [net-next v3 1/4] devlink: check flash_update parameter support in net core
Date:   Tue, 18 Aug 2020 17:28:15 -0700
Message-Id: <20200819002821.2657515-2-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.28.0.218.ge27853923b9d.dirty
In-Reply-To: <20200819002821.2657515-1-jacob.e.keller@intel.com>
References: <20200819002821.2657515-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When implementing .flash_update, drivers which do not support
per-component update are manually checking the component parameter to
verify that it is NULL. Without this check, the driver might accept an
update request with a component specified even though it will not honor
such a request.

Instead of having each driver check this, move the logic into
net/core/devlink.c, and use a new `supported_flash_update_params` field
in the devlink_ops. Drivers which will support per-component update must
now specify this by setting DEVLINK_SUPPORT_FLASH_UPDATE_COMPONENT in
the supported_flash_update_params in their devlink_ops.

This helps ensure that drivers do not forget to check for a NULL
component if they do not support per-component update. This also enables
a slightly better error message by enabling the core stack to set the
netlink bad attribute message to indicate precisely the unsupported
attribute in the message.

Going forward, any new additional parameter to flash update will require
a bit in the supported_flash_update_params bitfield.

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
* split this to its own patch, now with just the conversion to
  supported_flash_update_params, as suggested by Jiri.

 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c | 12 +++---------
 drivers/net/ethernet/huawei/hinic/hinic_devlink.c |  3 ---
 drivers/net/ethernet/intel/ice/ice_devlink.c      |  9 ++-------
 drivers/net/ethernet/mellanox/mlx5/core/devlink.c |  3 ---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c    |  3 ---
 drivers/net/ethernet/netronome/nfp/nfp_devlink.c  |  2 --
 drivers/net/netdevsim/dev.c                       |  1 +
 include/net/devlink.h                             | 15 +++++++++++++++
 net/core/devlink.c                                | 15 +++++++++++++--
 9 files changed, 34 insertions(+), 29 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
index 3a854195d5b0..a17764db1419 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
@@ -23,9 +23,6 @@ bnxt_dl_flash_update(struct devlink *dl, const char *filename,
 	struct bnxt *bp = bnxt_get_bp_from_dl(dl);
 	int rc;
 
-	if (region)
-		return -EOPNOTSUPP;
-
 	if (!BNXT_PF(bp)) {
 		NL_SET_ERR_MSG_MOD(extack,
 				   "flash update not supported from a VF");
@@ -33,15 +30,12 @@ bnxt_dl_flash_update(struct devlink *dl, const char *filename,
 	}
 
 	devlink_flash_update_begin_notify(dl);
-	devlink_flash_update_status_notify(dl, "Preparing to flash", region, 0,
-					   0);
+	devlink_flash_update_status_notify(dl, "Preparing to flash", NULL, 0, 0);
 	rc = bnxt_flash_package_from_file(bp->dev, filename, 0);
 	if (!rc)
-		devlink_flash_update_status_notify(dl, "Flashing done", region,
-						   0, 0);
+		devlink_flash_update_status_notify(dl, "Flashing done", NULL, 0, 0);
 	else
-		devlink_flash_update_status_notify(dl, "Flashing failed",
-						   region, 0, 0);
+		devlink_flash_update_status_notify(dl, "Flashing failed", NULL, 0, 0);
 	devlink_flash_update_end_notify(dl);
 	return rc;
 }
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_devlink.c b/drivers/net/ethernet/huawei/hinic/hinic_devlink.c
index 16bda7381ba0..662a27a514ae 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_devlink.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_devlink.c
@@ -289,9 +289,6 @@ static int hinic_devlink_flash_update(struct devlink *devlink,
 	const struct firmware *fw;
 	int err;
 
-	if (component)
-		return -EOPNOTSUPP;
-
 	err = request_firmware_direct(&fw, file_name,
 				      &priv->hwdev->hwif->pdev->dev);
 	if (err)
diff --git a/drivers/net/ethernet/intel/ice/ice_devlink.c b/drivers/net/ethernet/intel/ice/ice_devlink.c
index 111d6bfe4222..6cdccd901637 100644
--- a/drivers/net/ethernet/intel/ice/ice_devlink.c
+++ b/drivers/net/ethernet/intel/ice/ice_devlink.c
@@ -252,16 +252,12 @@ ice_devlink_flash_update(struct devlink *devlink, const char *path,
 	const struct firmware *fw;
 	int err;
 
-	/* individual component update is not yet supported */
-	if (component)
-		return -EOPNOTSUPP;
-
 	if (!hw->dev_caps.common_cap.nvm_unified_update) {
 		NL_SET_ERR_MSG_MOD(extack, "Current firmware does not support unified update");
 		return -EOPNOTSUPP;
 	}
 
-	err = ice_check_for_pending_update(pf, component, extack);
+	err = ice_check_for_pending_update(pf, NULL, extack);
 	if (err)
 		return err;
 
@@ -272,8 +268,7 @@ ice_devlink_flash_update(struct devlink *devlink, const char *path,
 	}
 
 	devlink_flash_update_begin_notify(devlink);
-	devlink_flash_update_status_notify(devlink, "Preparing to flash",
-					   component, 0, 0);
+	devlink_flash_update_status_notify(devlink, "Preparing to flash", NULL, 0, 0);
 	err = ice_flash_pldm_image(pf, fw, extack);
 	devlink_flash_update_end_notify(devlink);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index c709e9a385f6..fccae4b802b6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -16,9 +16,6 @@ static int mlx5_devlink_flash_update(struct devlink *devlink,
 	const struct firmware *fw;
 	int err;
 
-	if (component)
-		return -EOPNOTSUPP;
-
 	err = request_firmware_direct(&fw, file_name, &dev->pdev->dev);
 	if (err)
 		return err;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index fdf9aa8314b2..95ddc1212d0e 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -425,9 +425,6 @@ static int mlxsw_sp_flash_update(struct mlxsw_core *mlxsw_core,
 	const struct firmware *firmware;
 	int err;
 
-	if (component)
-		return -EOPNOTSUPP;
-
 	err = request_firmware_direct(&firmware, file_name,
 				      mlxsw_sp->bus_info->dev);
 	if (err)
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_devlink.c b/drivers/net/ethernet/netronome/nfp/nfp_devlink.c
index be52510d446b..c93cb9a27e25 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_devlink.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_devlink.c
@@ -332,8 +332,6 @@ static int
 nfp_devlink_flash_update(struct devlink *devlink, const char *path,
 			 const char *component, struct netlink_ext_ack *extack)
 {
-	if (component)
-		return -EOPNOTSUPP;
 	return nfp_flash_update_common(devlink_priv(devlink), path, extack);
 }
 
diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index 32f339fedb21..1219637ab36e 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -875,6 +875,7 @@ nsim_dev_devlink_trap_policer_counter_get(struct devlink *devlink,
 }
 
 static const struct devlink_ops nsim_dev_devlink_ops = {
+	.supported_flash_update_params = DEVLINK_SUPPORT_FLASH_UPDATE_COMPONENT,
 	.reload_down = nsim_dev_reload_down,
 	.reload_up = nsim_dev_reload_up,
 	.info_get = nsim_dev_info_get,
diff --git a/include/net/devlink.h b/include/net/devlink.h
index 8f3c8a443238..1ef4b832f37b 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -511,6 +511,8 @@ enum devlink_param_generic_id {
 /* Firmware bundle identifier */
 #define DEVLINK_INFO_VERSION_GENERIC_FW_BUNDLE_ID	"fw.bundle_id"
 
+#define DEVLINK_SUPPORT_FLASH_UPDATE_COMPONENT	BIT(0)
+
 struct devlink_region;
 struct devlink_info_req;
 
@@ -991,6 +993,12 @@ enum devlink_trap_group_generic_id {
 	}
 
 struct devlink_ops {
+	/**
+	 * @supported_flash_update_params:
+	 * mask of parameters supported by the driver's .flash_update
+	 * implemementation.
+	 */
+	u32 supported_flash_update_params;
 	int (*reload_down)(struct devlink *devlink, bool netns_change,
 			   struct netlink_ext_ack *extack);
 	int (*reload_up)(struct devlink *devlink,
@@ -1051,6 +1059,13 @@ struct devlink_ops {
 				      struct netlink_ext_ack *extack);
 	int (*info_get)(struct devlink *devlink, struct devlink_info_req *req,
 			struct netlink_ext_ack *extack);
+	/**
+	 * @flash_update: Device flash update function
+	 *
+	 * Used to perform a flash update for the device. The set of
+	 * parameters supported by the driver should be set in
+	 * supported_flash_update_params.
+	 */
 	int (*flash_update)(struct devlink *devlink, const char *file_name,
 			    const char *component,
 			    struct netlink_ext_ack *extack);
diff --git a/net/core/devlink.c b/net/core/devlink.c
index e5feb87beca7..b596b45c8fd8 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -3120,18 +3120,29 @@ static int devlink_nl_cmd_flash_update(struct sk_buff *skb,
 				       struct genl_info *info)
 {
 	struct devlink *devlink = info->user_ptr[0];
-	const char *file_name, *component;
+	const char *file_name, *component = NULL;
 	struct nlattr *nla_component;
+	u32 supported_params;
 
 	if (!devlink->ops->flash_update)
 		return -EOPNOTSUPP;
 
 	if (!info->attrs[DEVLINK_ATTR_FLASH_UPDATE_FILE_NAME])
 		return -EINVAL;
+
+	supported_params = devlink->ops->supported_flash_update_params;
+
 	file_name = nla_data(info->attrs[DEVLINK_ATTR_FLASH_UPDATE_FILE_NAME]);
 
 	nla_component = info->attrs[DEVLINK_ATTR_FLASH_UPDATE_COMPONENT];
-	component = nla_component ? nla_data(nla_component) : NULL;
+	if (nla_component) {
+		if (!(supported_params & DEVLINK_SUPPORT_FLASH_UPDATE_COMPONENT)) {
+			NL_SET_ERR_MSG_ATTR(info->extack, nla_component,
+					    "component update is not supported");
+			return -EOPNOTSUPP;
+		}
+		component = nla_data(nla_component);
+	}
 
 	return devlink->ops->flash_update(devlink, file_name, component,
 					  info->extack);
-- 
2.28.0.218.ge27853923b9d.dirty

