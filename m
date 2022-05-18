Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1D5652B263
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 08:37:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231421AbiERGfQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 02:35:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231350AbiERGfI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 02:35:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90246E7332
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 23:34:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7EE4B617C0
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 06:34:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3148C385A9;
        Wed, 18 May 2022 06:34:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652855689;
        bh=IjPXK5B54R1w7/ADHY8HrgaoFPYK+ITZ7rk+PK1Vrrw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lHvNPbbw4/zBNxkHiV4lGVGyc6MCz62LVaXM09T1KlC54RtJ8OLvybG1K+jxQR2Xb
         zHCCIm1a7W6KeeTBKMkuHe5HKEcpxpKPAive4MnIXeuZU0rpND+0KQrBfevWeC8zie
         33t1w3JW42Mt+V666ArN9StvSmPfXlQ9B89MGrhA5ZGHkE1VR8e0DSlqpnacShgNd9
         nYIputPRKEpiD+dnzj72f+CWweZXjkC97CkGhSHcd3SPoPH58LY7GW+O4Sl9xYOU73
         E1OG76R4yiwxJ/+aeJO7xC819E9OQipCJ4EWibwxVTgsevmsH2YaGG+vsn6EOobcZN
         V/6vwjXX+9kqA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Shay Drory <shayd@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 11/11] net/mlx5: Drain fw_reset when removing device
Date:   Tue, 17 May 2022 23:34:27 -0700
Message-Id: <20220518063427.123758-12-saeed@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220518063427.123758-1-saeed@kernel.org>
References: <20220518063427.123758-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shay Drory <shayd@nvidia.com>

In case fw sync reset is called in parallel to device removal, device
might stuck in the following deadlock:
         CPU 0                        CPU 1
         -----                        -----
                                  remove_one
                                   uninit_one (locks intf_state_mutex)
mlx5_sync_reset_now_event()
work in fw_reset->wq.
 mlx5_enter_error_state()
  mutex_lock (intf_state_mutex)
                                   cleanup_once
                                    fw_reset_cleanup()
                                     destroy_workqueue(fw_reset->wq)

Drain the fw_reset WQ, and make sure no new work is being queued, before
entering uninit_one().
The Drain is done before devlink_unregister() since fw_reset, in some
flows, is using devlink API devlink_remote_reload_actions_performed().

Fixes: 38b9f903f22b ("net/mlx5: Handle sync reset request event")
Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/fw_reset.c    | 25 ++++++++++++++++---
 .../ethernet/mellanox/mlx5/core/fw_reset.h    |  1 +
 .../net/ethernet/mellanox/mlx5/core/main.c    |  4 +++
 3 files changed, 27 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
index ca1aba845dd6..81eb67fb95b0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
@@ -8,7 +8,8 @@
 enum {
 	MLX5_FW_RESET_FLAGS_RESET_REQUESTED,
 	MLX5_FW_RESET_FLAGS_NACK_RESET_REQUEST,
-	MLX5_FW_RESET_FLAGS_PENDING_COMP
+	MLX5_FW_RESET_FLAGS_PENDING_COMP,
+	MLX5_FW_RESET_FLAGS_DROP_NEW_REQUESTS
 };
 
 struct mlx5_fw_reset {
@@ -208,7 +209,10 @@ static void poll_sync_reset(struct timer_list *t)
 
 	if (fatal_error) {
 		mlx5_core_warn(dev, "Got Device Reset\n");
-		queue_work(fw_reset->wq, &fw_reset->reset_reload_work);
+		if (!test_bit(MLX5_FW_RESET_FLAGS_DROP_NEW_REQUESTS, &fw_reset->reset_flags))
+			queue_work(fw_reset->wq, &fw_reset->reset_reload_work);
+		else
+			mlx5_core_err(dev, "Device is being removed, Drop new reset work\n");
 		return;
 	}
 
@@ -433,9 +437,12 @@ static int fw_reset_event_notifier(struct notifier_block *nb, unsigned long acti
 	struct mlx5_fw_reset *fw_reset = mlx5_nb_cof(nb, struct mlx5_fw_reset, nb);
 	struct mlx5_eqe *eqe = data;
 
+	if (test_bit(MLX5_FW_RESET_FLAGS_DROP_NEW_REQUESTS, &fw_reset->reset_flags))
+		return NOTIFY_DONE;
+
 	switch (eqe->sub_type) {
 	case MLX5_GENERAL_SUBTYPE_FW_LIVE_PATCH_EVENT:
-			queue_work(fw_reset->wq, &fw_reset->fw_live_patch_work);
+		queue_work(fw_reset->wq, &fw_reset->fw_live_patch_work);
 		break;
 	case MLX5_GENERAL_SUBTYPE_PCI_SYNC_FOR_FW_UPDATE_EVENT:
 		mlx5_sync_reset_events_handle(fw_reset, eqe);
@@ -479,6 +486,18 @@ void mlx5_fw_reset_events_stop(struct mlx5_core_dev *dev)
 	mlx5_eq_notifier_unregister(dev, &dev->priv.fw_reset->nb);
 }
 
+void mlx5_drain_fw_reset(struct mlx5_core_dev *dev)
+{
+	struct mlx5_fw_reset *fw_reset = dev->priv.fw_reset;
+
+	set_bit(MLX5_FW_RESET_FLAGS_DROP_NEW_REQUESTS, &fw_reset->reset_flags);
+	cancel_work_sync(&fw_reset->fw_live_patch_work);
+	cancel_work_sync(&fw_reset->reset_request_work);
+	cancel_work_sync(&fw_reset->reset_reload_work);
+	cancel_work_sync(&fw_reset->reset_now_work);
+	cancel_work_sync(&fw_reset->reset_abort_work);
+}
+
 int mlx5_fw_reset_init(struct mlx5_core_dev *dev)
 {
 	struct mlx5_fw_reset *fw_reset = kzalloc(sizeof(*fw_reset), GFP_KERNEL);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.h b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.h
index 694fc7cb2684..dc141c7e641a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.h
@@ -16,6 +16,7 @@ int mlx5_fw_reset_set_live_patch(struct mlx5_core_dev *dev);
 int mlx5_fw_reset_wait_reset_done(struct mlx5_core_dev *dev);
 void mlx5_fw_reset_events_start(struct mlx5_core_dev *dev);
 void mlx5_fw_reset_events_stop(struct mlx5_core_dev *dev);
+void mlx5_drain_fw_reset(struct mlx5_core_dev *dev);
 int mlx5_fw_reset_init(struct mlx5_core_dev *dev);
 void mlx5_fw_reset_cleanup(struct mlx5_core_dev *dev);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index c6737720bf3a..ef196cb764e2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1627,6 +1627,10 @@ static void remove_one(struct pci_dev *pdev)
 	struct mlx5_core_dev *dev  = pci_get_drvdata(pdev);
 	struct devlink *devlink = priv_to_devlink(dev);
 
+	/* mlx5_drain_fw_reset() is using devlink APIs. Hence, we must drain
+	 * fw_reset before unregistering the devlink.
+	 */
+	mlx5_drain_fw_reset(dev);
 	devlink_unregister(devlink);
 	mlx5_sriov_disable(pdev);
 	mlx5_crdump_disable(dev);
-- 
2.36.1

