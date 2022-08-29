Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBA055A45B3
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 11:06:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229493AbiH2JGP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 05:06:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbiH2JGO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 05:06:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D2BF1A3B7;
        Mon, 29 Aug 2022 02:06:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 17C95B80DD6;
        Mon, 29 Aug 2022 09:06:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0E61C433C1;
        Mon, 29 Aug 2022 09:06:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661763970;
        bh=YxiSEiU77AdSBWd5wKKmc+hVh2H8m4okfNHl0r7sunw=;
        h=From:To:Cc:Subject:Date:From;
        b=dNgP346bm9X914Gn21n2UWqpMfES9xOcNa/OUgCvtGxwHG4B7Mytn1S6F+ACoxLp7
         clMS0VATqpxjYpgxwxuasf3c1A810wm1hxCT2gZ5yT3eWZXsXVZU9pPPkplh4DZkam
         9A7qVwdvWGh0XOuCRUDFBO3nn98XpslHPfA7ZAWwwlcV/cjkznTeHkd6cU1S2t3Hy3
         yfUqNy01x41pTGXY6v1sNTCMLFRX0QWciTgvtFMPYZlEn+T61mI9WRofgaWASS2kRa
         Al0cBVPCZKsup9wB4R8om+AIvQQyUVgHEn0OutaoLP2fa2z0IhXWiaTwNlV/RvrFO+
         HX1anmVoIlk0g==
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Chris Mi <cmi@nvidia.com>, Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Roi Dayan <roid@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH mlx5-next] RDMA/mlx5: Move function mlx5_core_query_ib_ppcnt() to mlx5_ib
Date:   Mon, 29 Aug 2022 12:06:04 +0300
Message-Id: <fd47b9138412bd94ed30f838026cbb4cf3878150.1661763871.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.37.2
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

From: Chris Mi <cmi@nvidia.com>

This patch doesn't change any functionality, but move one function
to mlx5_ib because it is not used by mlx5_core.

The actual fix is in the next patch.

Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Chris Mi <cmi@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/hw/mlx5/mad.c              | 25 +++++++++++++++++--
 .../net/ethernet/mellanox/mlx5/core/port.c    | 23 -----------------
 include/linux/mlx5/driver.h                   |  2 --
 3 files changed, 23 insertions(+), 27 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/mad.c b/drivers/infiniband/hw/mlx5/mad.c
index 293ed709e5ed..d834ec13b1b3 100644
--- a/drivers/infiniband/hw/mlx5/mad.c
+++ b/drivers/infiniband/hw/mlx5/mad.c
@@ -147,6 +147,28 @@ static void pma_cnt_assign(struct ib_pma_portcounters *pma_cnt,
 			     vl_15_dropped);
 }
 
+static int query_ib_ppcnt(struct mlx5_core_dev *dev, u8 port_num, void *out,
+			  size_t sz)
+{
+	u32 *in;
+	int err;
+
+	in  = kvzalloc(sz, GFP_KERNEL);
+	if (!in) {
+		err = -ENOMEM;
+		return err;
+	}
+
+	MLX5_SET(ppcnt_reg, in, local_port, port_num);
+
+	MLX5_SET(ppcnt_reg, in, grp, MLX5_INFINIBAND_PORT_COUNTERS_GROUP);
+	err = mlx5_core_access_reg(dev, in, sz, out,
+				   sz, MLX5_REG_PPCNT, 0, 0);
+
+	kvfree(in);
+	return err;
+}
+
 static int process_pma_cmd(struct mlx5_ib_dev *dev, u32 port_num,
 			   const struct ib_mad *in_mad, struct ib_mad *out_mad)
 {
@@ -202,8 +224,7 @@ static int process_pma_cmd(struct mlx5_ib_dev *dev, u32 port_num,
 			goto done;
 		}
 
-		err = mlx5_core_query_ib_ppcnt(mdev, mdev_port_num,
-					       out_cnt, sz);
+		err = query_ib_ppcnt(mdev, mdev_port_num, out_cnt, sz);
 		if (!err)
 			pma_cnt_assign(pma_cnt, out_cnt);
 	}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/port.c b/drivers/net/ethernet/mellanox/mlx5/core/port.c
index e1bd54574ea5..a1548e6bfb35 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/port.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/port.c
@@ -493,29 +493,6 @@ int mlx5_query_port_vl_hw_cap(struct mlx5_core_dev *dev,
 }
 EXPORT_SYMBOL_GPL(mlx5_query_port_vl_hw_cap);
 
-int mlx5_core_query_ib_ppcnt(struct mlx5_core_dev *dev,
-			     u8 port_num, void *out, size_t sz)
-{
-	u32 *in;
-	int err;
-
-	in  = kvzalloc(sz, GFP_KERNEL);
-	if (!in) {
-		err = -ENOMEM;
-		return err;
-	}
-
-	MLX5_SET(ppcnt_reg, in, local_port, port_num);
-
-	MLX5_SET(ppcnt_reg, in, grp, MLX5_INFINIBAND_PORT_COUNTERS_GROUP);
-	err = mlx5_core_access_reg(dev, in, sz, out,
-				   sz, MLX5_REG_PPCNT, 0, 0);
-
-	kvfree(in);
-	return err;
-}
-EXPORT_SYMBOL_GPL(mlx5_core_query_ib_ppcnt);
-
 static int mlx5_query_pfcc_reg(struct mlx5_core_dev *dev, u32 *out,
 			       u32 out_size)
 {
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 96b16fbe1aa4..9ccfd9dd0d0f 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -1084,8 +1084,6 @@ int mlx5_core_destroy_psv(struct mlx5_core_dev *dev, int psv_num);
 void mlx5_core_put_rsc(struct mlx5_core_rsc_common *common);
 int mlx5_query_odp_caps(struct mlx5_core_dev *dev,
 			struct mlx5_odp_caps *odp_caps);
-int mlx5_core_query_ib_ppcnt(struct mlx5_core_dev *dev,
-			     u8 port_num, void *out, size_t sz);
 
 int mlx5_init_rl_table(struct mlx5_core_dev *dev);
 void mlx5_cleanup_rl_table(struct mlx5_core_dev *dev);
-- 
2.37.2

