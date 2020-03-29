Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BA3B196CCB
	for <lists+netdev@lfdr.de>; Sun, 29 Mar 2020 13:06:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728113AbgC2LGE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Mar 2020 07:06:04 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:51311 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727938AbgC2LGC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Mar 2020 07:06:02 -0400
Received: from Internal Mail-Server by MTLPINE2 (envelope-from eranbe@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 29 Mar 2020 14:05:58 +0300
Received: from dev-l-vrt-198.mtl.labs.mlnx (dev-l-vrt-198.mtl.labs.mlnx [10.134.198.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 02TB5wV9006555;
        Sun, 29 Mar 2020 14:05:58 +0300
From:   Eran Ben Elisha <eranbe@mellanox.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@mellanox.com>
Cc:     Eran Ben Elisha <eranbe@mellanox.com>
Subject: [PATCH net-next v2 2/3] devlink: Implicitly set auto recover flag when registering health reporter
Date:   Sun, 29 Mar 2020 14:05:54 +0300
Message-Id: <1585479955-29828-3-git-send-email-eranbe@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1585479955-29828-1-git-send-email-eranbe@mellanox.com>
References: <1585479955-29828-1-git-send-email-eranbe@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When health reporter is registered to devlink, devlink will implicitly set
auto recover if and only if the reporter has a recover method. No reason
to explicitly get the auto recover flag from the driver.

Remove this flag from all drivers that called
devlink_health_reporter_create.

All existing health reporters set auto recovery to true if they have a
recover method.

Yet, administrator can unset auto recover via netlink command as prior to
this patch.

Signed-off-by: Eran Ben Elisha <eranbe@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Reviewed-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c        | 6 +++---
 drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/health.c         | 4 ++--
 drivers/net/netdevsim/health.c                           | 4 ++--
 include/net/devlink.h                                    | 3 +--
 net/core/devlink.c                                       | 9 +++------
 7 files changed, 13 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
index 8e09a52a9c06..a812beb46325 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
@@ -150,7 +150,7 @@ void bnxt_dl_fw_reporters_create(struct bnxt *bp)
 	health->fw_reset_reporter =
 		devlink_health_reporter_create(bp->dl,
 					       &bnxt_dl_fw_reset_reporter_ops,
-					       0, true, bp);
+					       0, bp);
 	if (IS_ERR(health->fw_reset_reporter)) {
 		netdev_warn(bp->dev, "Failed to create FW fatal health reporter, rc = %ld\n",
 			    PTR_ERR(health->fw_reset_reporter));
@@ -166,7 +166,7 @@ void bnxt_dl_fw_reporters_create(struct bnxt *bp)
 		health->fw_reporter =
 			devlink_health_reporter_create(bp->dl,
 						       &bnxt_dl_fw_reporter_ops,
-						       0, false, bp);
+						       0, bp);
 		if (IS_ERR(health->fw_reporter)) {
 			netdev_warn(bp->dev, "Failed to create FW health reporter, rc = %ld\n",
 				    PTR_ERR(health->fw_reporter));
@@ -182,7 +182,7 @@ void bnxt_dl_fw_reporters_create(struct bnxt *bp)
 	health->fw_fatal_reporter =
 		devlink_health_reporter_create(bp->dl,
 					       &bnxt_dl_fw_fatal_reporter_ops,
-					       0, true, bp);
+					       0, bp);
 	if (IS_ERR(health->fw_fatal_reporter)) {
 		netdev_warn(bp->dev, "Failed to create FW fatal health reporter, rc = %ld\n",
 			    PTR_ERR(health->fw_fatal_reporter));
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
index af77c86c9aea..c209579fc213 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
@@ -571,7 +571,7 @@ int mlx5e_reporter_rx_create(struct mlx5e_priv *priv)
 	reporter = devlink_health_reporter_create(devlink,
 						  &mlx5_rx_reporter_ops,
 						  MLX5E_REPORTER_RX_GRACEFUL_PERIOD,
-						  true, priv);
+						  priv);
 	if (IS_ERR(reporter)) {
 		netdev_warn(priv->netdev, "Failed to create rx reporter, err = %ld\n",
 			    PTR_ERR(reporter));
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
index 2028ce9b151f..9805fc085512 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
@@ -416,7 +416,7 @@ int mlx5e_reporter_tx_create(struct mlx5e_priv *priv)
 	reporter =
 		devlink_health_reporter_create(devlink, &mlx5_tx_reporter_ops,
 					       MLX5_REPORTER_TX_GRACEFUL_PERIOD,
-					       true, priv);
+					       priv);
 	if (IS_ERR(reporter)) {
 		netdev_warn(priv->netdev,
 			    "Failed to create tx reporter, err = %ld\n",
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/health.c b/drivers/net/ethernet/mellanox/mlx5/core/health.c
index d9f4e8c59c1f..fa1665caac46 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/health.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/health.c
@@ -627,7 +627,7 @@ static void mlx5_fw_reporters_create(struct mlx5_core_dev *dev)
 
 	health->fw_reporter =
 		devlink_health_reporter_create(devlink, &mlx5_fw_reporter_ops,
-					       0, false, dev);
+					       0, dev);
 	if (IS_ERR(health->fw_reporter))
 		mlx5_core_warn(dev, "Failed to create fw reporter, err = %ld\n",
 			       PTR_ERR(health->fw_reporter));
@@ -636,7 +636,7 @@ static void mlx5_fw_reporters_create(struct mlx5_core_dev *dev)
 		devlink_health_reporter_create(devlink,
 					       &mlx5_fw_fatal_reporter_ops,
 					       MLX5_REPORTER_FW_GRACEFUL_PERIOD,
-					       true, dev);
+					       dev);
 	if (IS_ERR(health->fw_fatal_reporter))
 		mlx5_core_warn(dev, "Failed to create fw fatal reporter, err = %ld\n",
 			       PTR_ERR(health->fw_fatal_reporter));
diff --git a/drivers/net/netdevsim/health.c b/drivers/net/netdevsim/health.c
index 9ff345d5524b..62958b238d50 100644
--- a/drivers/net/netdevsim/health.c
+++ b/drivers/net/netdevsim/health.c
@@ -271,14 +271,14 @@ int nsim_dev_health_init(struct nsim_dev *nsim_dev, struct devlink *devlink)
 	health->empty_reporter =
 		devlink_health_reporter_create(devlink,
 					       &nsim_dev_empty_reporter_ops,
-					       0, false, health);
+					       0, health);
 	if (IS_ERR(health->empty_reporter))
 		return PTR_ERR(health->empty_reporter);
 
 	health->dummy_reporter =
 		devlink_health_reporter_create(devlink,
 					       &nsim_dev_dummy_reporter_ops,
-					       0, true, health);
+					       0, health);
 	if (IS_ERR(health->dummy_reporter)) {
 		err = PTR_ERR(health->dummy_reporter);
 		goto err_empty_reporter_destroy;
diff --git a/include/net/devlink.h b/include/net/devlink.h
index 3be50346c69b..3f5cf62e4de8 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -1040,8 +1040,7 @@ int devlink_fmsg_binary_pair_put(struct devlink_fmsg *fmsg, const char *name,
 struct devlink_health_reporter *
 devlink_health_reporter_create(struct devlink *devlink,
 			       const struct devlink_health_reporter_ops *ops,
-			       u64 graceful_period, bool auto_recover,
-			       void *priv);
+			       u64 graceful_period, void *priv);
 void
 devlink_health_reporter_destroy(struct devlink_health_reporter *reporter);
 
diff --git a/net/core/devlink.c b/net/core/devlink.c
index d20efdc8cc73..0763b0494401 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -5124,14 +5124,12 @@ devlink_health_reporter_find_by_name(struct devlink *devlink,
  *	@devlink: devlink
  *	@ops: ops
  *	@graceful_period: to avoid recovery loops, in msecs
- *	@auto_recover: auto recover when error occurs
  *	@priv: priv
  */
 struct devlink_health_reporter *
 devlink_health_reporter_create(struct devlink *devlink,
 			       const struct devlink_health_reporter_ops *ops,
-			       u64 graceful_period, bool auto_recover,
-			       void *priv)
+			       u64 graceful_period, void *priv)
 {
 	struct devlink_health_reporter *reporter;
 
@@ -5141,8 +5139,7 @@ devlink_health_reporter_create(struct devlink *devlink,
 		goto unlock;
 	}
 
-	if (WARN_ON(auto_recover && !ops->recover) ||
-	    WARN_ON(graceful_period && !ops->recover)) {
+	if (WARN_ON(graceful_period && !ops->recover)) {
 		reporter = ERR_PTR(-EINVAL);
 		goto unlock;
 	}
@@ -5157,7 +5154,7 @@ devlink_health_reporter_create(struct devlink *devlink,
 	reporter->ops = ops;
 	reporter->devlink = devlink;
 	reporter->graceful_period = graceful_period;
-	reporter->auto_recover = auto_recover;
+	reporter->auto_recover = !!ops->recover;
 	mutex_init(&reporter->dump_lock);
 	refcount_set(&reporter->refcount, 1);
 	list_add_tail(&reporter->list, &devlink->reporter_list);
-- 
2.17.1

