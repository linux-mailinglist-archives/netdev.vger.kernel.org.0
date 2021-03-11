Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50831336AA7
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 04:27:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230450AbhCKD02 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 22:26:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:49354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230122AbhCKD0R (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Mar 2021 22:26:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 75EA164F9F;
        Thu, 11 Mar 2021 03:26:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615433176;
        bh=KUEW2t6cH7hWlD+QXDaWwlVzpmeN19XinrPOSNGScNE=;
        h=From:To:Cc:Subject:Date:Reply-To:From;
        b=sc62NkeBpY9PA7CkhUb5mJTZ0WjnPiR29CC0VAH7hZmm4va6QnP8oxgB1jAQgF2PM
         UeB4aFFUGKUlJUdk2e4ohPmFGWWYicLu3AlzsMPPzyy+eUuO8KG9HISzU1Zrv/ulJh
         OfAMBlMYnGI4hMx22pSvYcIA69+eG88HDAA9L6+gT0DzGDQvT1iu6HA6r/Jysle+TJ
         pGiRrpLPB+IRvkNfmcSFNTB6XhIi6XaVGOmwDvInaMbMOV39ednekLe1zdubDzySmA
         yB2kbjbKGyoSDVN9IV72gvcS1ZkSEqmwimovKbM7ZKItIDXS7JpHh2BetC4gvRNSI2
         6kgTFbG92FLcA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     netdev@vger.kernel.org
Cc:     jiri@resnulli.us, saeedm@nvidia.com,
        andrew.gospodarek@broadcom.com, jacob.e.keller@intel.com,
        guglielmo.morandin@broadcom.com, eugenem@fb.com,
        eranbe@mellanox.com, Jakub Kicinski <kuba@kernel.org>
Subject: [RFC net-next v2 1/3] devlink: move health state to uAPI
Date:   Wed, 10 Mar 2021 19:26:11 -0800
Message-Id: <20210311032613.1533100-1-kuba@kernel.org>
X-Mailer: git-send-email 2.29.2
Reply-To: f242ed68-d31b-527d-562f-c5a35123861a@intel.com
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move the health states into uAPI, so applications can use them.

Note that we need to change the name of the enum because
user space is likely already defining the same values.
E.g. iproute2 does.

Use this opportunity to shorten the names.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 .../net/ethernet/broadcom/bnxt/bnxt_devlink.c  |  4 ++--
 .../ethernet/mellanox/mlx5/core/en/health.c    |  4 ++--
 include/net/devlink.h                          |  7 +------
 include/uapi/linux/devlink.h                   | 12 ++++++++++++
 net/core/devlink.c                             | 18 +++++++++---------
 5 files changed, 26 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
index 64381be935a8..cafc98ab4b5e 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
@@ -252,9 +252,9 @@ void bnxt_dl_health_status_update(struct bnxt *bp, bool healthy)
 	u8 state;
 
 	if (healthy)
-		state = DEVLINK_HEALTH_REPORTER_STATE_HEALTHY;
+		state = DL_HEALTH_STATE_HEALTHY;
 	else
-		state = DEVLINK_HEALTH_REPORTER_STATE_ERROR;
+		state = DL_HEALTH_STATE_ERROR;
 
 	if (health->fatal)
 		devlink_health_reporter_state_update(health->fw_fatal_reporter,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/health.c b/drivers/net/ethernet/mellanox/mlx5/core/en/health.c
index 84e501e057b4..c526e31e562c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/health.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/health.c
@@ -151,10 +151,10 @@ void mlx5e_health_channels_update(struct mlx5e_priv *priv)
 {
 	if (priv->tx_reporter)
 		devlink_health_reporter_state_update(priv->tx_reporter,
-						     DEVLINK_HEALTH_REPORTER_STATE_HEALTHY);
+						     DL_HEALTH_STATE_HEALTHY);
 	if (priv->rx_reporter)
 		devlink_health_reporter_state_update(priv->rx_reporter,
-						     DEVLINK_HEALTH_REPORTER_STATE_HEALTHY);
+						     DL_HEALTH_STATE_HEALTHY);
 }
 
 int mlx5e_health_sq_to_ready(struct mlx5_core_dev *mdev, struct net_device *dev, u32 sqn)
diff --git a/include/net/devlink.h b/include/net/devlink.h
index 853420db5d32..b424328af658 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -656,11 +656,6 @@ struct devlink_port_region_ops {
 struct devlink_fmsg;
 struct devlink_health_reporter;
 
-enum devlink_health_reporter_state {
-	DEVLINK_HEALTH_REPORTER_STATE_HEALTHY,
-	DEVLINK_HEALTH_REPORTER_STATE_ERROR,
-};
-
 /**
  * struct devlink_health_reporter_ops - Reporter operations
  * @name: reporter name
@@ -1675,7 +1670,7 @@ int devlink_health_report(struct devlink_health_reporter *reporter,
 			  const char *msg, void *priv_ctx);
 void
 devlink_health_reporter_state_update(struct devlink_health_reporter *reporter,
-				     enum devlink_health_reporter_state state);
+				     enum devlink_health_state state);
 void
 devlink_health_reporter_recovery_done(struct devlink_health_reporter *reporter);
 
diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index f6008b2fa60f..41a6ea3b2256 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -608,4 +608,16 @@ enum devlink_port_fn_opstate {
 	DEVLINK_PORT_FN_OPSTATE_ATTACHED,
 };
 
+/**
+ * enum devlink_health_state - indicates the state of a health reporter
+ * @DL_HEALTH_STATE_HEALTHY: fully operational, working state
+ * @DL_HEALTH_STATE_ERROR: error state, running health reporter's recovery
+ *			may fix the issue, otherwise user needs to try
+ *			power cycling or other forms of reset
+ */
+enum devlink_health_state {
+	DL_HEALTH_STATE_HEALTHY,
+	DL_HEALTH_STATE_ERROR,
+};
+
 #endif /* _UAPI_LINUX_DEVLINK_H_ */
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 737b61c2976e..8e4e4bd7bb36 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -6346,7 +6346,7 @@ devlink_health_reporter_recover(struct devlink_health_reporter *reporter,
 {
 	int err;
 
-	if (reporter->health_state == DEVLINK_HEALTH_REPORTER_STATE_HEALTHY)
+	if (reporter->health_state == DL_HEALTH_STATE_HEALTHY)
 		return 0;
 
 	if (!reporter->ops->recover)
@@ -6357,7 +6357,7 @@ devlink_health_reporter_recover(struct devlink_health_reporter *reporter,
 		return err;
 
 	devlink_health_reporter_recovery_done(reporter);
-	reporter->health_state = DEVLINK_HEALTH_REPORTER_STATE_HEALTHY;
+	reporter->health_state = DL_HEALTH_STATE_HEALTHY;
 	devlink_recover_notify(reporter, DEVLINK_CMD_HEALTH_REPORTER_RECOVER);
 
 	return 0;
@@ -6416,7 +6416,7 @@ static int devlink_health_do_dump(struct devlink_health_reporter *reporter,
 int devlink_health_report(struct devlink_health_reporter *reporter,
 			  const char *msg, void *priv_ctx)
 {
-	enum devlink_health_reporter_state prev_health_state;
+	enum devlink_health_state prev_health_state;
 	struct devlink *devlink = reporter->devlink;
 	unsigned long recover_ts_threshold;
 
@@ -6425,14 +6425,14 @@ int devlink_health_report(struct devlink_health_reporter *reporter,
 	trace_devlink_health_report(devlink, reporter->ops->name, msg);
 	reporter->error_count++;
 	prev_health_state = reporter->health_state;
-	reporter->health_state = DEVLINK_HEALTH_REPORTER_STATE_ERROR;
+	reporter->health_state = DL_HEALTH_STATE_ERROR;
 	devlink_recover_notify(reporter, DEVLINK_CMD_HEALTH_REPORTER_RECOVER);
 
 	/* abort if the previous error wasn't recovered */
 	recover_ts_threshold = reporter->last_recovery_ts +
 			       msecs_to_jiffies(reporter->graceful_period);
 	if (reporter->auto_recover &&
-	    (prev_health_state != DEVLINK_HEALTH_REPORTER_STATE_HEALTHY ||
+	    (prev_health_state != DL_HEALTH_STATE_HEALTHY ||
 	     (reporter->last_recovery_ts && reporter->recovery_count &&
 	      time_is_after_jiffies(recover_ts_threshold)))) {
 		trace_devlink_health_recover_aborted(devlink,
@@ -6443,7 +6443,7 @@ int devlink_health_report(struct devlink_health_reporter *reporter,
 		return -ECANCELED;
 	}
 
-	reporter->health_state = DEVLINK_HEALTH_REPORTER_STATE_ERROR;
+	reporter->health_state = DL_HEALTH_STATE_ERROR;
 
 	if (reporter->auto_dump) {
 		mutex_lock(&reporter->dump_lock);
@@ -6520,10 +6520,10 @@ devlink_health_reporter_get_from_cb(struct netlink_callback *cb)
 
 void
 devlink_health_reporter_state_update(struct devlink_health_reporter *reporter,
-				     enum devlink_health_reporter_state state)
+				     enum devlink_health_state state)
 {
-	if (WARN_ON(state != DEVLINK_HEALTH_REPORTER_STATE_HEALTHY &&
-		    state != DEVLINK_HEALTH_REPORTER_STATE_ERROR))
+	if (WARN_ON(state != DL_HEALTH_STATE_HEALTHY &&
+		    state != DL_HEALTH_STATE_ERROR))
 		return;
 
 	if (reporter->health_state == state)
-- 
2.29.2

