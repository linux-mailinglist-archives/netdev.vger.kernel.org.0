Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9010543A511
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 22:54:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234065AbhJYU5D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 16:57:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:34246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233150AbhJYU47 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Oct 2021 16:56:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 67FA360FDC;
        Mon, 25 Oct 2021 20:54:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635195276;
        bh=RFADSKoFY1MkkBTEn8kgL738K5CpaJ5S63y77msYUxE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LDG0iYu7w1uGcW+qlvxUEr8preDgctw229/+0AlUCJ4d+jAU+wEH0pEOuS2qepPfk
         98KsRSoDz27o7mkHdXFYgrKYV0JvRqldWfH/LEH1IbhIxco9uU4aE9P1xOQ8dF9hGh
         fuaRCyzyBTFkitJviCIFzP3ouaCxMveBONZaaSFEXsWYntfg0IGiRozbjPAF62leVz
         Bku2Ru8J19gltJszIcr32rqbuAZotLVLU6sMBAuhfi0QEtRrqqXXLc1RdK4f0zfMMe
         CCqPjvEX3JWF+jZuLiUikcGCGns2pRtYjewnWGf98MT/8JVtq4JD/3IogVTPw1l2vS
         KH29j3UDLsLLg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Aya Levin <ayal@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 07/14] net/mlx5: Add periodic update of host time to firmware
Date:   Mon, 25 Oct 2021 13:54:24 -0700
Message-Id: <20211025205431.365080-8-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211025205431.365080-1-saeed@kernel.org>
References: <20211025205431.365080-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@nvidia.com>

Firmware logs its asserts also to non-volatile memory. In order to
reduce drift between the NIC and the host, the driver sets the host
epoch-time to the firmware every hour.

Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/health.c  | 30 +++++++++++++++++++
 include/linux/mlx5/driver.h                   |  2 ++
 include/linux/mlx5/mlx5_ifc.h                 | 12 ++++++++
 3 files changed, 44 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/health.c b/drivers/net/ethernet/mellanox/mlx5/core/health.c
index c35a27255232..64f1abc4dc36 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/health.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/health.c
@@ -752,6 +752,31 @@ void mlx5_trigger_health_work(struct mlx5_core_dev *dev)
 	spin_unlock_irqrestore(&health->wq_lock, flags);
 }
 
+#define MLX5_MSEC_PER_HOUR (MSEC_PER_SEC * 60 * 60)
+static void mlx5_health_log_ts_update(struct work_struct *work)
+{
+	struct delayed_work *dwork = to_delayed_work(work);
+	u32 out[MLX5_ST_SZ_DW(mrtc_reg)] = {};
+	u32 in[MLX5_ST_SZ_DW(mrtc_reg)] = {};
+	struct mlx5_core_health *health;
+	struct mlx5_core_dev *dev;
+	struct mlx5_priv *priv;
+	u64 now_us;
+
+	health = container_of(dwork, struct mlx5_core_health, update_fw_log_ts_work);
+	priv = container_of(health, struct mlx5_priv, health);
+	dev = container_of(priv, struct mlx5_core_dev, priv);
+
+	now_us =  ktime_to_us(ktime_get_real());
+
+	MLX5_SET(mrtc_reg, in, time_h, now_us >> 32);
+	MLX5_SET(mrtc_reg, in, time_l, now_us & 0xFFFFFFFF);
+	mlx5_core_access_reg(dev, in, sizeof(in), out, sizeof(out), MLX5_REG_MRTC, 0, 1);
+
+	queue_delayed_work(health->wq, &health->update_fw_log_ts_work,
+			   msecs_to_jiffies(MLX5_MSEC_PER_HOUR));
+}
+
 static void poll_health(struct timer_list *t)
 {
 	struct mlx5_core_dev *dev = from_timer(dev, t, priv.health.timer);
@@ -834,6 +859,7 @@ void mlx5_drain_health_wq(struct mlx5_core_dev *dev)
 	spin_lock_irqsave(&health->wq_lock, flags);
 	set_bit(MLX5_DROP_NEW_HEALTH_WORK, &health->flags);
 	spin_unlock_irqrestore(&health->wq_lock, flags);
+	cancel_delayed_work_sync(&health->update_fw_log_ts_work);
 	cancel_work_sync(&health->report_work);
 	cancel_work_sync(&health->fatal_report_work);
 }
@@ -849,6 +875,7 @@ void mlx5_health_cleanup(struct mlx5_core_dev *dev)
 {
 	struct mlx5_core_health *health = &dev->priv.health;
 
+	cancel_delayed_work_sync(&health->update_fw_log_ts_work);
 	destroy_workqueue(health->wq);
 	mlx5_fw_reporters_destroy(dev);
 }
@@ -874,6 +901,9 @@ int mlx5_health_init(struct mlx5_core_dev *dev)
 	spin_lock_init(&health->wq_lock);
 	INIT_WORK(&health->fatal_report_work, mlx5_fw_fatal_reporter_err_work);
 	INIT_WORK(&health->report_work, mlx5_fw_reporter_err_work);
+	INIT_DELAYED_WORK(&health->update_fw_log_ts_work, mlx5_health_log_ts_update);
+	if (mlx5_core_is_pf(dev))
+		queue_delayed_work(health->wq, &health->update_fw_log_ts_work, 0);
 
 	return 0;
 
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 3f4c0f2314a5..f617dfbcd9fd 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -134,6 +134,7 @@ enum {
 	MLX5_REG_MCIA		 = 0x9014,
 	MLX5_REG_MFRL		 = 0x9028,
 	MLX5_REG_MLCR		 = 0x902b,
+	MLX5_REG_MRTC		 = 0x902d,
 	MLX5_REG_MTRC_CAP	 = 0x9040,
 	MLX5_REG_MTRC_CONF	 = 0x9041,
 	MLX5_REG_MTRC_STDB	 = 0x9042,
@@ -440,6 +441,7 @@ struct mlx5_core_health {
 	struct work_struct		report_work;
 	struct devlink_health_reporter *fw_reporter;
 	struct devlink_health_reporter *fw_fatal_reporter;
+	struct delayed_work		update_fw_log_ts_work;
 };
 
 struct mlx5_qp_table {
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 6d292b5b8992..746381eccccf 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -10358,6 +10358,17 @@ struct mlx5_ifc_pddr_reg_bits {
 	union mlx5_ifc_pddr_reg_page_data_auto_bits page_data;
 };
 
+struct mlx5_ifc_mrtc_reg_bits {
+	u8         time_synced[0x1];
+	u8         reserved_at_1[0x1f];
+
+	u8         reserved_at_20[0x20];
+
+	u8         time_h[0x20];
+
+	u8         time_l[0x20];
+};
+
 union mlx5_ifc_ports_control_registers_document_bits {
 	struct mlx5_ifc_bufferx_reg_bits bufferx_reg;
 	struct mlx5_ifc_eth_2819_cntrs_grp_data_layout_bits eth_2819_cntrs_grp_data_layout;
@@ -10419,6 +10430,7 @@ union mlx5_ifc_ports_control_registers_document_bits {
 	struct mlx5_ifc_mirc_reg_bits mirc_reg;
 	struct mlx5_ifc_mfrl_reg_bits mfrl_reg;
 	struct mlx5_ifc_mtutc_reg_bits mtutc_reg;
+	struct mlx5_ifc_mrtc_reg_bits mrtc_reg;
 	u8         reserved_at_0[0x60e0];
 };
 
-- 
2.31.1

