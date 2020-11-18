Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9F6F2B8463
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 20:09:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726614AbgKRTIH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 14:08:07 -0500
Received: from mga05.intel.com ([192.55.52.43]:46633 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725794AbgKRTIH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Nov 2020 14:08:07 -0500
IronPort-SDR: 7f+whCEagu1PKi0YGRkpZCffKYSF55MI6sq2VVtNBrPSsZKMULDhCNiEf4Wiin9lLok+LjJ5mo
 hqtfNbNH2TMg==
X-IronPort-AV: E=McAfee;i="6000,8403,9809"; a="255880099"
X-IronPort-AV: E=Sophos;i="5.77,488,1596524400"; 
   d="scan'208";a="255880099"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2020 11:08:01 -0800
IronPort-SDR: BFFb7gQeDYCle2DI/u5xvartTPTk8Xpekcn9z+lwBdtLthJo32lA/5DYm5CckVn7e3UAEX+iKc
 Ut7vUnNVXtmg==
X-IronPort-AV: E=Sophos;i="5.77,488,1596524400"; 
   d="scan'208";a="341410222"
Received: from jekeller-desk.amr.corp.intel.com ([10.166.241.4])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2020 11:08:01 -0800
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Jiri Pirko <jiri@nvidia.com>,
        Shannon Nelson <snelson@pensando.io>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Boris Pismenny <borisp@nvidia.com>,
        Bin Luo <luobin9@huawei.com>, Jakub Kicinksi <kuba@kernel.org>
Subject: [net-next v4 2/2] devlink: move flash end and begin to core devlink
Date:   Wed, 18 Nov 2020 11:06:36 -0800
Message-Id: <20201118190636.1235045-3-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20201118190636.1235045-1-jacob.e.keller@intel.com>
References: <20201118190636.1235045-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When performing a flash update via devlink, device drivers may inform
user space of status updates via
devlink_flash_update_(begin|end|timeout|status)_notify functions.

It is expected that drivers do not send any status notifications unless
they send a begin and end message. If a driver sends a status
notification without sending the appropriate end notification upon
finishing (regardless of success or failure), the current implementation
of the devlink userspace program can get stuck endlessly waiting for the
end notification that will never come.

The current ice driver implementation may send such a status message
without the appropriate end notification in rare cases.

Fixing the ice driver is relatively simple: we just need to send the
begin_notify at the start of the function and always send an end_notify
no matter how the function exits.

Rather than assuming driver authors will always get this right in the
future, lets just fix the API so that it is not possible to get wrong.
Make devlink_flash_update_begin_notify and
devlink_flash_update_end_notify static, and call them in devlink.c core
code. Always send the begin_notify just before calling the driver's
flash_update routine. Always send the end_notify just after the routine
returns regardless of success or failure.

Doing this makes the status notification easier to use from the driver,
as it no longer needs to worry about catching failures and cleaning up
by calling devlink_flash_update_end_notify. It is now no longer possible
to do the wrong thing in this regard. We also save a couple of lines of
code in each driver.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Acked-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Cc: Shannon Nelson <snelson@pensando.io>
Cc: Saeed Mahameed <saeedm@nvidia.com>
Cc: Boris Pismenny <borisp@nvidia.com>
Cc: Bin Luo <luobin9@huawei.com>
Cc: Jakub Kicinksi <kuba@kernel.org>
---

Changes since v3
* picked up acked-by and reviewed-by comments, no functional changes

 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c |  2 --
 drivers/net/ethernet/intel/ice/ice_devlink.c      |  5 +----
 drivers/net/ethernet/mellanox/mlxfw/mlxfw_fsm.c   |  3 ---
 drivers/net/ethernet/pensando/ionic/ionic_fw.c    |  2 --
 drivers/net/netdevsim/dev.c                       |  2 --
 include/net/devlink.h                             |  2 --
 net/core/devlink.c                                | 10 ++++++----
 7 files changed, 7 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
index 4ebae8a236fd..6b7b69ed62db 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
@@ -30,14 +30,12 @@ bnxt_dl_flash_update(struct devlink *dl,
 		return -EPERM;
 	}
 
-	devlink_flash_update_begin_notify(dl);
 	devlink_flash_update_status_notify(dl, "Preparing to flash", NULL, 0, 0);
 	rc = bnxt_flash_package_from_fw_obj(bp->dev, params->fw, 0);
 	if (!rc)
 		devlink_flash_update_status_notify(dl, "Flashing done", NULL, 0, 0);
 	else
 		devlink_flash_update_status_notify(dl, "Flashing failed", NULL, 0, 0);
-	devlink_flash_update_end_notify(dl);
 	return rc;
 }
 
diff --git a/drivers/net/ethernet/intel/ice/ice_devlink.c b/drivers/net/ethernet/intel/ice/ice_devlink.c
index 0036d3e7df0b..29d6192b15f3 100644
--- a/drivers/net/ethernet/intel/ice/ice_devlink.c
+++ b/drivers/net/ethernet/intel/ice/ice_devlink.c
@@ -275,12 +275,9 @@ ice_devlink_flash_update(struct devlink *devlink,
 	if (err)
 		return err;
 
-	devlink_flash_update_begin_notify(devlink);
 	devlink_flash_update_status_notify(devlink, "Preparing to flash", NULL, 0, 0);
-	err = ice_flash_pldm_image(pf, params->fw, preservation, extack);
-	devlink_flash_update_end_notify(devlink);
 
-	return err;
+	return ice_flash_pldm_image(pf, params->fw, preservation, extack);
 }
 
 static const struct devlink_ops ice_devlink_ops = {
diff --git a/drivers/net/ethernet/mellanox/mlxfw/mlxfw_fsm.c b/drivers/net/ethernet/mellanox/mlxfw/mlxfw_fsm.c
index bcd166911d44..46245e0b2462 100644
--- a/drivers/net/ethernet/mellanox/mlxfw/mlxfw_fsm.c
+++ b/drivers/net/ethernet/mellanox/mlxfw/mlxfw_fsm.c
@@ -368,7 +368,6 @@ int mlxfw_firmware_flash(struct mlxfw_dev *mlxfw_dev,
 	}
 
 	mlxfw_info(mlxfw_dev, "Initialize firmware flash process\n");
-	devlink_flash_update_begin_notify(mlxfw_dev->devlink);
 	mlxfw_status_notify(mlxfw_dev, "Initializing firmware flash process",
 			    NULL, 0, 0);
 	err = mlxfw_dev->ops->fsm_lock(mlxfw_dev, &fwhandle);
@@ -417,7 +416,6 @@ int mlxfw_firmware_flash(struct mlxfw_dev *mlxfw_dev,
 	mlxfw_info(mlxfw_dev, "Firmware flash done\n");
 	mlxfw_status_notify(mlxfw_dev, "Firmware flash done", NULL, 0, 0);
 	mlxfw_mfa2_file_fini(mfa2_file);
-	devlink_flash_update_end_notify(mlxfw_dev->devlink);
 	return 0;
 
 err_state_wait_activate_to_locked:
@@ -429,7 +427,6 @@ int mlxfw_firmware_flash(struct mlxfw_dev *mlxfw_dev,
 	mlxfw_dev->ops->fsm_release(mlxfw_dev, fwhandle);
 err_fsm_lock:
 	mlxfw_mfa2_file_fini(mfa2_file);
-	devlink_flash_update_end_notify(mlxfw_dev->devlink);
 	return err;
 }
 EXPORT_SYMBOL(mlxfw_firmware_flash);
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_fw.c b/drivers/net/ethernet/pensando/ionic/ionic_fw.c
index 8922c316abe3..5f40324cd243 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_fw.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_fw.c
@@ -107,7 +107,6 @@ int ionic_firmware_update(struct ionic_lif *lif, const struct firmware *fw,
 	netdev_info(netdev, "Installing firmware\n");
 
 	dl = priv_to_devlink(ionic);
-	devlink_flash_update_begin_notify(dl);
 	devlink_flash_update_status_notify(dl, "Preparing to flash", NULL, 0, 0);
 
 	buf_sz = sizeof(idev->dev_cmd_regs->data);
@@ -193,6 +192,5 @@ int ionic_firmware_update(struct ionic_lif *lif, const struct firmware *fw,
 		devlink_flash_update_status_notify(dl, "Flash failed", NULL, 0, 0);
 	else
 		devlink_flash_update_status_notify(dl, "Flash done", NULL, 0, 0);
-	devlink_flash_update_end_notify(dl);
 	return err;
 }
diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index 49cc1fea9e02..5731d8b6566b 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -764,7 +764,6 @@ static int nsim_dev_flash_update(struct devlink *devlink,
 		return -EOPNOTSUPP;
 
 	if (nsim_dev->fw_update_status) {
-		devlink_flash_update_begin_notify(devlink);
 		devlink_flash_update_status_notify(devlink,
 						   "Preparing to flash",
 						   params->component, 0, 0);
@@ -788,7 +787,6 @@ static int nsim_dev_flash_update(struct devlink *devlink,
 						    params->component, 81);
 		devlink_flash_update_status_notify(devlink, "Flashing done",
 						   params->component, 0, 0);
-		devlink_flash_update_end_notify(devlink);
 	}
 
 	return 0;
diff --git a/include/net/devlink.h b/include/net/devlink.h
index d1d125a33322..457c537d0ef2 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -1577,8 +1577,6 @@ void devlink_remote_reload_actions_performed(struct devlink *devlink,
 					     enum devlink_reload_limit limit,
 					     u32 actions_performed);
 
-void devlink_flash_update_begin_notify(struct devlink *devlink);
-void devlink_flash_update_end_notify(struct devlink *devlink);
 void devlink_flash_update_status_notify(struct devlink *devlink,
 					const char *status_msg,
 					const char *component,
diff --git a/net/core/devlink.c b/net/core/devlink.c
index b0121d79ac75..bf160d9b1106 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -3370,7 +3370,7 @@ static void __devlink_flash_update_notify(struct devlink *devlink,
 	nlmsg_free(msg);
 }
 
-void devlink_flash_update_begin_notify(struct devlink *devlink)
+static void devlink_flash_update_begin_notify(struct devlink *devlink)
 {
 	struct devlink_flash_notify params = { 0 };
 
@@ -3378,9 +3378,8 @@ void devlink_flash_update_begin_notify(struct devlink *devlink)
 				      DEVLINK_CMD_FLASH_UPDATE,
 				      &params);
 }
-EXPORT_SYMBOL_GPL(devlink_flash_update_begin_notify);
 
-void devlink_flash_update_end_notify(struct devlink *devlink)
+static void devlink_flash_update_end_notify(struct devlink *devlink)
 {
 	struct devlink_flash_notify params = { 0 };
 
@@ -3388,7 +3387,6 @@ void devlink_flash_update_end_notify(struct devlink *devlink)
 				      DEVLINK_CMD_FLASH_UPDATE_END,
 				      &params);
 }
-EXPORT_SYMBOL_GPL(devlink_flash_update_end_notify);
 
 void devlink_flash_update_status_notify(struct devlink *devlink,
 					const char *status_msg,
@@ -3475,7 +3473,9 @@ static int devlink_nl_cmd_flash_update(struct sk_buff *skb,
 		return ret;
 	}
 
+	devlink_flash_update_begin_notify(devlink);
 	ret = devlink->ops->flash_update(devlink, &params, info->extack);
+	devlink_flash_update_end_notify(devlink);
 
 	release_firmware(params.fw);
 
@@ -10242,7 +10242,9 @@ int devlink_compat_flash_update(struct net_device *dev, const char *file_name)
 		goto out;
 
 	mutex_lock(&devlink->lock);
+	devlink_flash_update_begin_notify(devlink);
 	ret = devlink->ops->flash_update(devlink, &params, NULL);
+	devlink_flash_update_end_notify(devlink);
 	mutex_unlock(&devlink->lock);
 
 	release_firmware(params.fw);
-- 
2.29.0

