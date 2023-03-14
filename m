Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D3D16B8AB9
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 06:43:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230290AbjCNFnZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 01:43:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230111AbjCNFnP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 01:43:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BAFC85A75
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 22:42:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0A479B8121B
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 05:42:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97F28C433D2;
        Tue, 14 Mar 2023 05:42:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678772567;
        bh=OdiQZ3mLJQqq7IUhtR1z+kysAP7j+Hg7FaxZ1WlT8g8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pLwTaoddhmnI/GrxxnZh3UTv3KLSTK1J96RsrSVD+OftAiEHUHGIP4WG0noczsIaH
         oH7bwMqz7D93k30Ti1MUz5QzIoI0mxjC/eaiEPUwLNlsZEJXzFvBVD2gibBQEegAbo
         1XC/y7Tk+MRpAiGdcT0jGN+W6kI/XpywANBxUe+f2G53dNdeXtcktFNKkKrlI2hIGq
         8yKIKeYbRx5FrKQG9+y2Jx3meMS2YwfaBJ2si4bn41o7TjThqT8fondAcSNo0y1urs
         sfAlihZPP2tUywcMoi/alFJnoL2P4dDFGQ85BYMKRI7yYWze/icf59DVmTfdN+hmSc
         iRNBjYq1gHEeA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Sandipan Patra <spatra@nvidia.com>,
        Gal Pressman <gal@nvidia.com>
Subject: [net-next 04/15] net/mlx5: Implement thermal zone
Date:   Mon, 13 Mar 2023 22:42:23 -0700
Message-Id: <20230314054234.267365-5-saeed@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230314054234.267365-1-saeed@kernel.org>
References: <20230314054234.267365-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sandipan Patra <spatra@nvidia.com>

Implement thermal zone support for mlx5 based HW. The NIC
uses temperature sensor provided by ASIC to report current temperature
to thermal core.

Signed-off-by: Sandipan Patra <spatra@nvidia.com>
Reviewed-by: Gal Pressman <gal@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/Makefile  |   1 +
 .../net/ethernet/mellanox/mlx5/core/main.c    |   6 +
 .../net/ethernet/mellanox/mlx5/core/thermal.c | 108 ++++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/thermal.h |  20 ++++
 include/linux/mlx5/driver.h                   |   3 +
 include/linux/mlx5/mlx5_ifc.h                 |  26 +++++
 6 files changed, 164 insertions(+)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/thermal.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/thermal.h

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
index 8d4e25cc54ea..6c2f1d4a58ab 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -77,6 +77,7 @@ mlx5_core-$(CONFIG_MLX5_ESWITCH)   += esw/acl/helper.o \
 
 mlx5_core-$(CONFIG_MLX5_BRIDGE)    += esw/bridge.o en/rep/bridge.o
 
+mlx5_core-$(CONFIG_THERMAL)        += thermal.o
 mlx5_core-$(CONFIG_MLX5_MPFS)      += lib/mpfs.o
 mlx5_core-$(CONFIG_VXLAN)          += lib/vxlan.o
 mlx5_core-$(CONFIG_PTP_1588_CLOCK) += lib/clock.o
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 0ff0eb660495..644c889f9a32 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -52,6 +52,7 @@
 #include <linux/version.h>
 #include <net/devlink.h>
 #include "mlx5_core.h"
+#include "thermal.h"
 #include "lib/eq.h"
 #include "fs_core.h"
 #include "lib/mpfs.h"
@@ -1768,6 +1769,10 @@ static int probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (err)
 		dev_err(&pdev->dev, "mlx5_crdump_enable failed with error code %d\n", err);
 
+	err = mlx5_thermal_init(dev);
+	if (err)
+		dev_err(&pdev->dev, "mlx5_thermal_init failed with error code %d\n", err);
+
 	pci_save_state(pdev);
 	devlink_register(devlink);
 	return 0;
@@ -1796,6 +1801,7 @@ static void remove_one(struct pci_dev *pdev)
 	set_bit(MLX5_BREAK_FW_WAIT, &dev->intf_state);
 	devlink_unregister(devlink);
 	mlx5_sriov_disable(pdev);
+	mlx5_thermal_uninit(dev);
 	mlx5_crdump_disable(dev);
 	mlx5_drain_health_wq(dev);
 	mlx5_uninit_one(dev);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/thermal.c b/drivers/net/ethernet/mellanox/mlx5/core/thermal.c
new file mode 100644
index 000000000000..e47fa6fb836f
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/thermal.c
@@ -0,0 +1,108 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+// Copyright (c) 2023, NVIDIA CORPORATION & AFFILIATES.
+
+#include <linux/kernel.h>
+#include <linux/types.h>
+#include <linux/device.h>
+#include <linux/thermal.h>
+#include <linux/err.h>
+#include <linux/mlx5/driver.h>
+#include "mlx5_core.h"
+#include "thermal.h"
+
+#define MLX5_THERMAL_POLL_INT_MSEC	1000
+#define MLX5_THERMAL_NUM_TRIPS		0
+#define MLX5_THERMAL_ASIC_SENSOR_INDEX	0
+
+/* Bit string indicating the writeablility of trip points if any */
+#define MLX5_THERMAL_TRIP_MASK	(BIT(MLX5_THERMAL_NUM_TRIPS) - 1)
+
+struct mlx5_thermal {
+	struct mlx5_core_dev *mdev;
+	struct thermal_zone_device *tzdev;
+};
+
+static int mlx5_thermal_get_mtmp_temp(struct mlx5_core_dev *mdev, u32 id, int *p_temp)
+{
+	u32 mtmp_out[MLX5_ST_SZ_DW(mtmp_reg)] = {};
+	u32 mtmp_in[MLX5_ST_SZ_DW(mtmp_reg)] = {};
+	int err;
+
+	MLX5_SET(mtmp_reg, mtmp_in, sensor_index, id);
+
+	err = mlx5_core_access_reg(mdev, mtmp_in,  sizeof(mtmp_in),
+				   mtmp_out, sizeof(mtmp_out),
+				   MLX5_REG_MTMP, 0, 0);
+
+	if (err)
+		return err;
+
+	*p_temp = MLX5_GET(mtmp_reg, mtmp_out, temperature);
+
+	return 0;
+}
+
+static int mlx5_thermal_get_temp(struct thermal_zone_device *tzdev,
+				 int *p_temp)
+{
+	struct mlx5_thermal *thermal = tzdev->devdata;
+	struct mlx5_core_dev *mdev = thermal->mdev;
+	int err;
+
+	err = mlx5_thermal_get_mtmp_temp(mdev, MLX5_THERMAL_ASIC_SENSOR_INDEX, p_temp);
+
+	if (err)
+		return err;
+
+	/* The unit of temp returned is in 0.125 C. The thermal
+	 * framework expects the value in 0.001 C.
+	 */
+	*p_temp *= 125;
+
+	return 0;
+}
+
+static struct thermal_zone_device_ops mlx5_thermal_ops = {
+	.get_temp = mlx5_thermal_get_temp,
+};
+
+int mlx5_thermal_init(struct mlx5_core_dev *mdev)
+{
+	struct mlx5_thermal *thermal;
+	struct thermal_zone_device *tzd;
+	const char *data = "mlx5";
+
+	tzd = thermal_zone_get_zone_by_name(data);
+	if (!IS_ERR(tzd))
+		return 0;
+
+	thermal = kzalloc(sizeof(*thermal), GFP_KERNEL);
+	if (!thermal)
+		return -ENOMEM;
+
+	thermal->mdev = mdev;
+	thermal->tzdev = thermal_zone_device_register(data,
+						      MLX5_THERMAL_NUM_TRIPS,
+						      MLX5_THERMAL_TRIP_MASK,
+						      thermal,
+						      &mlx5_thermal_ops,
+						      NULL, 0, MLX5_THERMAL_POLL_INT_MSEC);
+	if (IS_ERR(thermal->tzdev)) {
+		dev_err(mdev->device, "Failed to register thermal zone device (%s) %ld\n",
+			data, PTR_ERR(thermal->tzdev));
+		kfree(thermal);
+		return -EINVAL;
+	}
+
+	mdev->thermal = thermal;
+	return 0;
+}
+
+void mlx5_thermal_uninit(struct mlx5_core_dev *mdev)
+{
+	if (!mdev->thermal)
+		return;
+
+	thermal_zone_device_unregister(mdev->thermal->tzdev);
+	kfree(mdev->thermal);
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/thermal.h b/drivers/net/ethernet/mellanox/mlx5/core/thermal.h
new file mode 100644
index 000000000000..7d752c122192
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/thermal.h
@@ -0,0 +1,20 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+ * Copyright (c) 2023, NVIDIA CORPORATION & AFFILIATES.
+ */
+#ifndef __MLX5_THERMAL_DRIVER_H
+#define __MLX5_THERMAL_DRIVER_H
+
+#if IS_ENABLED(CONFIG_THERMAL)
+int mlx5_thermal_init(struct mlx5_core_dev *mdev);
+void mlx5_thermal_uninit(struct mlx5_core_dev *mdev);
+#else
+static inline int mlx5_thermal_init(struct mlx5_core_dev *mdev)
+{
+	mdev->thermal = NULL;
+	return 0;
+}
+
+static inline void mlx5_thermal_uninit(struct mlx5_core_dev *mdev) { }
+#endif
+
+#endif /* __MLX5_THERMAL_DRIVER_H */
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index f33389b42209..7a898113b6b7 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -134,6 +134,7 @@ enum {
 	MLX5_REG_PCAM		 = 0x507f,
 	MLX5_REG_NODE_DESC	 = 0x6001,
 	MLX5_REG_HOST_ENDIANNESS = 0x7004,
+	MLX5_REG_MTMP		 = 0x900A,
 	MLX5_REG_MCIA		 = 0x9014,
 	MLX5_REG_MFRL		 = 0x9028,
 	MLX5_REG_MLCR		 = 0x902b,
@@ -731,6 +732,7 @@ struct mlx5_fw_tracer;
 struct mlx5_vxlan;
 struct mlx5_geneve;
 struct mlx5_hv_vhca;
+struct mlx5_thermal;
 
 #define MLX5_LOG_SW_ICM_BLOCK_SIZE(dev) (MLX5_CAP_DEV_MEM(dev, log_sw_icm_alloc_granularity))
 #define MLX5_SW_ICM_BLOCK_SIZE(dev) (1 << MLX5_LOG_SW_ICM_BLOCK_SIZE(dev))
@@ -808,6 +810,7 @@ struct mlx5_core_dev {
 	struct mlx5_rsc_dump    *rsc_dump;
 	u32                      vsc_addr;
 	struct mlx5_hv_vhca	*hv_vhca;
+	struct mlx5_thermal	*thermal;
 };
 
 struct mlx5_db {
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 66d76e97a087..d2c164f0778c 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -10869,6 +10869,31 @@ struct mlx5_ifc_mrtc_reg_bits {
 	u8         time_l[0x20];
 };
 
+struct mlx5_ifc_mtmp_reg_bits {
+	u8         reserved_at_0[0x14];
+	u8         sensor_index[0xc];
+
+	u8         reserved_at_20[0x10];
+	u8         temperature[0x10];
+
+	u8         mte[0x1];
+	u8         mtr[0x1];
+	u8         reserved_at_42[0xe];
+	u8         max_temperature[0x10];
+
+	u8         tee[0x2];
+	u8         reserved_at_62[0xe];
+	u8         temp_threshold_hi[0x10];
+
+	u8         reserved_at_80[0x10];
+	u8         temp_threshold_lo[0x10];
+
+	u8         reserved_at_a0[0x20];
+
+	u8         sensor_name_hi[0x20];
+	u8         sensor_name_lo[0x20];
+};
+
 union mlx5_ifc_ports_control_registers_document_bits {
 	struct mlx5_ifc_bufferx_reg_bits bufferx_reg;
 	struct mlx5_ifc_eth_2819_cntrs_grp_data_layout_bits eth_2819_cntrs_grp_data_layout;
@@ -10931,6 +10956,7 @@ union mlx5_ifc_ports_control_registers_document_bits {
 	struct mlx5_ifc_mfrl_reg_bits mfrl_reg;
 	struct mlx5_ifc_mtutc_reg_bits mtutc_reg;
 	struct mlx5_ifc_mrtc_reg_bits mrtc_reg;
+	struct mlx5_ifc_mtmp_reg_bits mtmp_reg;
 	u8         reserved_at_0[0x60e0];
 };
 
-- 
2.39.2

