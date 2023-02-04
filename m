Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8224768A957
	for <lists+netdev@lfdr.de>; Sat,  4 Feb 2023 11:09:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233094AbjBDKJx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Feb 2023 05:09:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233426AbjBDKJh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Feb 2023 05:09:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C917669B04
        for <netdev@vger.kernel.org>; Sat,  4 Feb 2023 02:09:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 720BFB80AB0
        for <netdev@vger.kernel.org>; Sat,  4 Feb 2023 10:09:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12487C4339E;
        Sat,  4 Feb 2023 10:09:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675505366;
        bh=df6tt75fVyYggD7Hp2NmS9MBw6XcsXYHABtX/RuSKaA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oKBLBIohO0wAdtTzSbcntcIoghrxMylYey+Bu7aVMBqsVSHuK8MDI0LIcOXO/qGOO
         A+xSFCcohjJqP5vhELEynEHalZoBdXNci+p3BTDNKZj9qCz15MQtplweXLezczb7bt
         jqus/2M/AabqjlAYSbTxnGloPXXujEPoxNNIfVEZgaCXRw+iqq3SuXCX3C91iVAxOj
         CO2wlwxcPHbPeR/laE9iRvnHAlL1hNNv94iWvUUb9e/xHGomULWgCXGMpZar39CS7+
         97ZlzXaSf9R1h8fo7lMMqPOcj/UoqC8czfKaFElkJ9+BWYXO+LogOdCFawnJerwUFm
         vwc4fKd5q77bg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Rahul Rameshbabu <rrameshbabu@nvidia.com>,
        Gal Pressman <gal@nvidia.com>
Subject: [net-next 11/15] net/mlx5: Add firmware support for MTUTC scaled_ppm frequency adjustments
Date:   Sat,  4 Feb 2023 02:08:50 -0800
Message-Id: <20230204100854.388126-12-saeed@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230204100854.388126-1-saeed@kernel.org>
References: <20230204100854.388126-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rahul Rameshbabu <rrameshbabu@nvidia.com>

When device is capable of handling scaled ppm values for adjusting
frequency, conversion to ppb will not be done by the driver. Instead, the
scaled ppm value will be passed directly to the device for the frequency
adjustment operation.

Signed-off-by: Rahul Rameshbabu <rrameshbabu@nvidia.com>
Reviewed-by: Gal Pressman <gal@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/lib/clock.c   | 15 ++++++++++++---
 include/linux/mlx5/mlx5_ifc.h                     | 12 ++++++++++--
 2 files changed, 22 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
index 75510a12ab02..4c9a40211059 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
@@ -362,7 +362,7 @@ static int mlx5_ptp_adjphase(struct ptp_clock_info *ptp, s32 delta)
 	return mlx5_ptp_adjtime(ptp, delta);
 }
 
-static int mlx5_ptp_adjfreq_real_time(struct mlx5_core_dev *mdev, s32 freq)
+static int mlx5_ptp_freq_adj_real_time(struct mlx5_core_dev *mdev, long scaled_ppm)
 {
 	u32 in[MLX5_ST_SZ_DW(mtutc_reg)] = {};
 
@@ -370,7 +370,15 @@ static int mlx5_ptp_adjfreq_real_time(struct mlx5_core_dev *mdev, s32 freq)
 		return 0;
 
 	MLX5_SET(mtutc_reg, in, operation, MLX5_MTUTC_OPERATION_ADJUST_FREQ_UTC);
-	MLX5_SET(mtutc_reg, in, freq_adjustment, freq);
+
+	if (MLX5_CAP_MCAM_FEATURE(mdev, mtutc_freq_adj_units)) {
+		MLX5_SET(mtutc_reg, in, freq_adj_units,
+			 MLX5_MTUTC_FREQ_ADJ_UNITS_SCALED_PPM);
+		MLX5_SET(mtutc_reg, in, freq_adjustment, scaled_ppm);
+	} else {
+		MLX5_SET(mtutc_reg, in, freq_adj_units, MLX5_MTUTC_FREQ_ADJ_UNITS_PPB);
+		MLX5_SET(mtutc_reg, in, freq_adjustment, scaled_ppm_to_ppb(scaled_ppm));
+	}
 
 	return mlx5_set_mtutc(mdev, in, sizeof(in));
 }
@@ -385,7 +393,8 @@ static int mlx5_ptp_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
 	int err;
 
 	mdev = container_of(clock, struct mlx5_core_dev, clock);
-	err = mlx5_ptp_adjfreq_real_time(mdev, scaled_ppm_to_ppb(scaled_ppm));
+
+	err = mlx5_ptp_freq_adj_real_time(mdev, scaled_ppm);
 	if (err)
 		return err;
 
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 1b6201bb04c1..7cf6a78fea07 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -9925,6 +9925,11 @@ struct mlx5_ifc_mpegc_reg_bits {
 	u8         reserved_at_60[0x100];
 };
 
+enum {
+	MLX5_MTUTC_FREQ_ADJ_UNITS_PPB          = 0x0,
+	MLX5_MTUTC_FREQ_ADJ_UNITS_SCALED_PPM   = 0x1,
+};
+
 enum {
 	MLX5_MTUTC_OPERATION_SET_TIME_IMMEDIATE   = 0x1,
 	MLX5_MTUTC_OPERATION_ADJUST_TIME          = 0x2,
@@ -9932,7 +9937,9 @@ enum {
 };
 
 struct mlx5_ifc_mtutc_reg_bits {
-	u8         reserved_at_0[0x1c];
+	u8         reserved_at_0[0x5];
+	u8         freq_adj_units[0x3];
+	u8         reserved_at_8[0x14];
 	u8         operation[0x4];
 
 	u8         freq_adjustment[0x20];
@@ -10005,7 +10012,8 @@ struct mlx5_ifc_pcam_reg_bits {
 };
 
 struct mlx5_ifc_mcam_enhanced_features_bits {
-	u8         reserved_at_0[0x51];
+	u8         reserved_at_0[0x50];
+	u8         mtutc_freq_adj_units[0x1];
 	u8         mtutc_time_adjustment_extended_range[0x1];
 	u8         reserved_at_52[0xb];
 	u8         mcia_32dwords[0x1];
-- 
2.39.1

