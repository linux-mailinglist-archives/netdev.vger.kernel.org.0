Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94EA65A45A7
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 11:03:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229919AbiH2JDE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 05:03:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229884AbiH2JCx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 05:02:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7D205A3ED;
        Mon, 29 Aug 2022 02:02:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8F4E860F49;
        Mon, 29 Aug 2022 09:02:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78811C433C1;
        Mon, 29 Aug 2022 09:02:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661763767;
        bh=SK79t5xTPnCsfiuUia3Kovnbd8ReQTcyoQ4SnlPI59A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JiJEZcbU6FfEow2NpdxGIgVlhEcicC3aBU4l8zHRUCMuMUE2lMT+3r0o6u2fp1XGU
         cQokEQdKlCtxX7edRw/jp7lSdNAc6iL7DIG87JGZKkwbo+uh04jdjeNBSL6ZGVGRLF
         vdl+4wGijf0f8mzqqIa8rJtYHMEVDDTqkGn8NnP5GDt/VRtMvQkj2WGMZ8C50Zkxcz
         +9kvqX0UzL16CDDMQmLyhM6dl4GZtYd+pzwhgJ2QIcapMIPqUhC2sKsk6RWCX8l1YL
         u/NqDZ2gSWAcj5gbztuz+DkAi0TMX+xUOX5HMKTmnFKiD5mzXPcBn95qS8vLHoAvPv
         dvpCLXoWidlDg==
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Maher Sanalla <msanalla@nvidia.com>, Chris Mi <cmi@nvidia.com>,
        linux-rdma@vger.kernel.org, Maor Gottlieb <maorg@nvidia.com>,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Shay Drory <shayd@nvidia.com>,
        Michael Guralnik <michaelgur@nvidia.com>
Subject: [PATCH rdma-rc 1/3] RDMA/mlx5: Rely on RoCE fw cap instead of devlink when setting profile
Date:   Mon, 29 Aug 2022 12:02:27 +0300
Message-Id: <cb34ce9a1df4a24c135cb804db87f7d2418bd6cc.1661763459.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <cover.1661763459.git.leonro@nvidia.com>
References: <cover.1661763459.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maher Sanalla <msanalla@nvidia.com>

When the RDMA auxiliary driver probes, it sets its profile based on
devlink driverinit value. The latter might not be in sync with FW yet
(In case devlink reload is not performed), thus causing a mismatch
between RDMA driver and FW. This results in the following FW syndrome
when the RDMA driver tries to adjust RoCE state, which fails the probe:

"0xC1F678 | modify_nic_vport_context: roce_en set on a vport that
doesn't support roce"

To prevent this, select the PF profile based on FW RoCE capability
instead of relying on devlink driverinit value.
To provide backward compatibility of the RoCE disable feature, on older
FW's where roce_rw is not set (FW RoCE capability is read-only), keep
the current behavior e.g., rely on devlink driverinit value.

Fixes: fbfa97b4d79f ("net/mlx5: Disable roce at HCA level")
Reviewed-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Michael Guralnik <michaelgur@nvidia.com>
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Maher Sanalla <msanalla@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/hw/mlx5/main.c             |  2 +-
 .../net/ethernet/mellanox/mlx5/core/main.c    | 23 +++++++++++++++++--
 include/linux/mlx5/driver.h                   | 19 +++++++--------
 3 files changed, 32 insertions(+), 12 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index fc94a1b25485..883d7c60143e 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -4336,7 +4336,7 @@ static int mlx5r_probe(struct auxiliary_device *adev,
 	dev->mdev = mdev;
 	dev->num_ports = num_ports;
 
-	if (ll == IB_LINK_LAYER_ETHERNET && !mlx5_is_roce_init_enabled(mdev))
+	if (ll == IB_LINK_LAYER_ETHERNET && !mlx5_get_roce_state(mdev))
 		profile = &raw_eth_profile;
 	else
 		profile = &pf_profile;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index bec8d6d0b5f6..4870a88cecb7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -494,6 +494,24 @@ static int max_uc_list_get_devlink_param(struct mlx5_core_dev *dev)
 	return err;
 }
 
+bool mlx5_is_roce_on(struct mlx5_core_dev *dev)
+{
+	struct devlink *devlink = priv_to_devlink(dev);
+	union devlink_param_value val;
+	int err;
+
+	err = devlink_param_driverinit_value_get(devlink,
+						 DEVLINK_PARAM_GENERIC_ID_ENABLE_ROCE,
+						 &val);
+
+	if (!err)
+		return val.vbool;
+
+	mlx5_core_dbg(dev, "Failed to get param. err = %d\n", err);
+	return MLX5_CAP_GEN(dev, roce);
+}
+EXPORT_SYMBOL(mlx5_is_roce_on);
+
 static int handle_hca_cap_2(struct mlx5_core_dev *dev, void *set_ctx)
 {
 	void *set_hca_cap;
@@ -597,7 +615,8 @@ static int handle_hca_cap(struct mlx5_core_dev *dev, void *set_ctx)
 			 MLX5_CAP_GEN_MAX(dev, num_total_dynamic_vf_msix));
 
 	if (MLX5_CAP_GEN(dev, roce_rw_supported))
-		MLX5_SET(cmd_hca_cap, set_hca_cap, roce, mlx5_is_roce_init_enabled(dev));
+		MLX5_SET(cmd_hca_cap, set_hca_cap, roce,
+			 mlx5_is_roce_on(dev));
 
 	max_uc_list = max_uc_list_get_devlink_param(dev);
 	if (max_uc_list > 0)
@@ -623,7 +642,7 @@ static int handle_hca_cap(struct mlx5_core_dev *dev, void *set_ctx)
  */
 static bool is_roce_fw_disabled(struct mlx5_core_dev *dev)
 {
-	return (MLX5_CAP_GEN(dev, roce_rw_supported) && !mlx5_is_roce_init_enabled(dev)) ||
+	return (MLX5_CAP_GEN(dev, roce_rw_supported) && !mlx5_is_roce_on(dev)) ||
 		(!MLX5_CAP_GEN(dev, roce_rw_supported) && !MLX5_CAP_GEN(dev, roce));
 }
 
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 96b16fbe1aa4..d6338fb449c8 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -1279,16 +1279,17 @@ enum {
 	MLX5_TRIGGERED_CMD_COMP = (u64)1 << 32,
 };
 
-static inline bool mlx5_is_roce_init_enabled(struct mlx5_core_dev *dev)
+bool mlx5_is_roce_on(struct mlx5_core_dev *dev);
+
+static inline bool mlx5_get_roce_state(struct mlx5_core_dev *dev)
 {
-	struct devlink *devlink = priv_to_devlink(dev);
-	union devlink_param_value val;
-	int err;
-
-	err = devlink_param_driverinit_value_get(devlink,
-						 DEVLINK_PARAM_GENERIC_ID_ENABLE_ROCE,
-						 &val);
-	return err ? MLX5_CAP_GEN(dev, roce) : val.vbool;
+	if (MLX5_CAP_GEN(dev, roce_rw_supported))
+		return MLX5_CAP_GEN(dev, roce);
+
+	/* If RoCE cap is read-only in FW, get RoCE state from devlink
+	 * in order to support RoCE enable/disable feature
+	 */
+	return mlx5_is_roce_on(dev);
 }
 
 #endif /* MLX5_DRIVER_H */
-- 
2.37.2

