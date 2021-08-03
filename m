Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 814813DF853
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 01:20:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233325AbhHCXUa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 19:20:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:38930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232530AbhHCXU3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Aug 2021 19:20:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C8CDD60F70;
        Tue,  3 Aug 2021 23:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628032818;
        bh=tWDjMxjmGW41hmG5vH5C9xA8Y17SgNmUJici0G0fYnw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hsOoK2PVGo0GDze7vHbPrA/XQfZDgPxFMdUOdDk6609Sb6XacWk/CEnM6YVBuKIqe
         /Uxl/dQrDQxMTBpocpl0gJk+LPG9t5KYj9NBr07Txb9PcAJ6J8EJQc+HRgJM1jFMqS
         J+9NxGqHqJAOVB3O+RH/jzyuuMdbovJ9NS+If6OErbJc/Rlmm14XKNapXUYQnNhR2t
         wD+d/1AM+g/jatA38O4Ne0UbpOh8Nu1qK1xw6NXsHF/vyeWCbja0GKX2KUXK+hDPeW
         RvbgjrMDQvyn57HHJutyEW4K+37T7VTFrBw6b9erIYPPAXWomuvb9m6H+FG/sTifEv
         iUrmuSSVes35A==
From:   Saeed Mahameed <saeed@kernel.org>
To:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        Mark Bloch <mbloch@nvidia.com>,
        Mark Zhang <markzhang@nvidia.com>
Subject: [PATCH mlx5-next 01/14] net/mlx5: Return mdev from eswitch
Date:   Tue,  3 Aug 2021 16:19:46 -0700
Message-Id: <20210803231959.26513-2-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210803231959.26513-1-saeed@kernel.org>
References: <20210803231959.26513-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mark Bloch <mbloch@nvidia.com>

Export a function so users can retrieve the mellanox device that manages
the eswitch from the eswitch device.

Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Mark Zhang <markzhang@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c | 12 ++++++++++++
 include/linux/mlx5/eswitch.h                      |  6 ++++++
 2 files changed, 18 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index 97e6cb6f13c1..b65a472067d2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -2384,3 +2384,15 @@ u16 mlx5_eswitch_get_total_vports(const struct mlx5_core_dev *dev)
 	return mlx5_esw_allowed(esw) ? esw->total_vports : 0;
 }
 EXPORT_SYMBOL_GPL(mlx5_eswitch_get_total_vports);
+
+/**
+ * mlx5_eswitch_get_core_dev - Get the mdev device
+ * @esw : eswitch device.
+ *
+ * Return the mellanox core device which manages the eswitch.
+ */
+struct mlx5_core_dev *mlx5_eswitch_get_core_dev(struct mlx5_eswitch *esw)
+{
+	return mlx5_esw_allowed(esw) ? esw->dev : NULL;
+}
+EXPORT_SYMBOL(mlx5_eswitch_get_core_dev);
diff --git a/include/linux/mlx5/eswitch.h b/include/linux/mlx5/eswitch.h
index bc7db2e059eb..c2a34ff85188 100644
--- a/include/linux/mlx5/eswitch.h
+++ b/include/linux/mlx5/eswitch.h
@@ -128,6 +128,7 @@ u32 mlx5_eswitch_get_vport_metadata_for_set(struct mlx5_eswitch *esw,
 
 u8 mlx5_eswitch_mode(struct mlx5_core_dev *dev);
 u16 mlx5_eswitch_get_total_vports(const struct mlx5_core_dev *dev);
+struct mlx5_core_dev *mlx5_eswitch_get_core_dev(struct mlx5_eswitch *esw);
 
 #else  /* CONFIG_MLX5_ESWITCH */
 
@@ -171,6 +172,11 @@ static inline u16 mlx5_eswitch_get_total_vports(const struct mlx5_core_dev *dev)
 	return 0;
 }
 
+static inline struct mlx5_core_dev *mlx5_eswitch_get_core_dev(struct mlx5_eswitch *esw)
+{
+	return NULL;
+}
+
 #endif /* CONFIG_MLX5_ESWITCH */
 
 static inline bool is_mdev_switchdev_mode(struct mlx5_core_dev *dev)
-- 
2.31.1

