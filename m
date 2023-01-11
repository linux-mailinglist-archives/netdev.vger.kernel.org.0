Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B7416653CB
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 06:39:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235911AbjAKFjC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 00:39:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231828AbjAKFhy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 00:37:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A604CB4C
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 21:30:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E0D34B81AC7
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 05:30:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75088C433D2;
        Wed, 11 Jan 2023 05:30:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673415050;
        bh=Au0r7I1o8CFDtL3efsDWpijizSB/XSEq38JPCxJBZxc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ntnVyVq6kYnFgB8PAGj0700gDz/dnAtuWlgY0Aqm4OMo3wG2E8IZCfnft+DUXYJMo
         vP9Ykdp9jxqONEuXyuyYlDW1GcgtDfITZ+Mn0ncAHktr9KvllMe5v5WhNsKlr7J0Qc
         c1IUrRmRIhgQ0/+/4k9zMY1Pop4Nit5DF8fq6JPWj4ySSEr6tNFXWnCw8g5TSB13ID
         r64th24dmQkJQwgr+qfk+C7R+88NZXIFStYhkX9I2ADVrq0Q3WHo27cRkjIeZU+geM
         GMWW+EBLrUWv0hsyuw+Ll6+RimF2hjiaPeLTBGD8+KKX8PbaLaUzo/VrvZUaoWZbRO
         YqWN6KIEACthA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Maher Sanalla <msanalla@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>
Subject: [net-next 02/15] net/mlx5e: Add API to query/modify SBPR and SBCM registers
Date:   Tue, 10 Jan 2023 21:30:32 -0800
Message-Id: <20230111053045.413133-3-saeed@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230111053045.413133-1-saeed@kernel.org>
References: <20230111053045.413133-1-saeed@kernel.org>
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

From: Maher Sanalla <msanalla@nvidia.com>

To allow users to configure shared receive buffer parameters through
dcbnl callbacks, expose an API to query and modify SBPR and SBCM registers,
which will be used in the upcoming patch.

Signed-off-by: Maher Sanalla <msanalla@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/port.c | 72 +++++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/en/port.h |  6 ++
 2 files changed, 78 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/port.c b/drivers/net/ethernet/mellanox/mlx5/core/en/port.c
index 89510cac46c2..505ba41195b9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/port.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/port.c
@@ -287,6 +287,78 @@ int mlx5e_port_set_pbmc(struct mlx5_core_dev *mdev, void *in)
 	return err;
 }
 
+int mlx5e_port_query_sbpr(struct mlx5_core_dev *mdev, u32 desc, u8 dir,
+			  u8 pool_idx, void *out, int size_out)
+{
+	u32 in[MLX5_ST_SZ_DW(sbpr_reg)] = {};
+
+	MLX5_SET(sbpr_reg, in, desc, desc);
+	MLX5_SET(sbpr_reg, in, dir, dir);
+	MLX5_SET(sbpr_reg, in, pool, pool_idx);
+
+	return mlx5_core_access_reg(mdev, in, sizeof(in), out, size_out, MLX5_REG_SBPR, 0, 0);
+}
+
+int mlx5e_port_set_sbpr(struct mlx5_core_dev *mdev, u32 desc, u8 dir,
+			u8 pool_idx, u32 infi_size, u32 size)
+{
+	u32 out[MLX5_ST_SZ_DW(sbpr_reg)] = {};
+	u32 in[MLX5_ST_SZ_DW(sbpr_reg)] = {};
+
+	MLX5_SET(sbpr_reg, in, desc, desc);
+	MLX5_SET(sbpr_reg, in, dir, dir);
+	MLX5_SET(sbpr_reg, in, pool, pool_idx);
+	MLX5_SET(sbpr_reg, in, infi_size, infi_size);
+	MLX5_SET(sbpr_reg, in, size, size);
+	MLX5_SET(sbpr_reg, in, mode, 1);
+
+	return mlx5_core_access_reg(mdev, in, sizeof(in), out, sizeof(out), MLX5_REG_SBPR, 0, 1);
+}
+
+static int mlx5e_port_query_sbcm(struct mlx5_core_dev *mdev, u32 desc,
+				 u8 pg_buff_idx, u8 dir, void *out,
+				 int size_out)
+{
+	u32 in[MLX5_ST_SZ_DW(sbcm_reg)] = {};
+
+	MLX5_SET(sbcm_reg, in, desc, desc);
+	MLX5_SET(sbcm_reg, in, local_port, 1);
+	MLX5_SET(sbcm_reg, in, pg_buff, pg_buff_idx);
+	MLX5_SET(sbcm_reg, in, dir, dir);
+
+	return mlx5_core_access_reg(mdev, in, sizeof(in), out, size_out, MLX5_REG_SBCM, 0, 0);
+}
+
+int mlx5e_port_set_sbcm(struct mlx5_core_dev *mdev, u32 desc, u8 pg_buff_idx,
+			u8 dir, u8 infi_size, u32 max_buff, u8 pool_idx)
+{
+	u32 out[MLX5_ST_SZ_DW(sbcm_reg)] = {};
+	u32 in[MLX5_ST_SZ_DW(sbcm_reg)] = {};
+	u32 min_buff;
+	int err;
+	u8 exc;
+
+	err = mlx5e_port_query_sbcm(mdev, desc, pg_buff_idx, dir, out,
+				    sizeof(out));
+	if (err)
+		return err;
+
+	exc = MLX5_GET(sbcm_reg, out, exc);
+	min_buff = MLX5_GET(sbcm_reg, out, min_buff);
+
+	MLX5_SET(sbcm_reg, in, desc, desc);
+	MLX5_SET(sbcm_reg, in, local_port, 1);
+	MLX5_SET(sbcm_reg, in, pg_buff, pg_buff_idx);
+	MLX5_SET(sbcm_reg, in, dir, dir);
+	MLX5_SET(sbcm_reg, in, exc, exc);
+	MLX5_SET(sbcm_reg, in, min_buff, min_buff);
+	MLX5_SET(sbcm_reg, in, infi_max, infi_size);
+	MLX5_SET(sbcm_reg, in, max_buff, max_buff);
+	MLX5_SET(sbcm_reg, in, pool, pool_idx);
+
+	return mlx5_core_access_reg(mdev, in, sizeof(in), out, sizeof(out), MLX5_REG_SBCM, 0, 1);
+}
+
 /* buffer[i]: buffer that priority i mapped to */
 int mlx5e_port_query_priority2buffer(struct mlx5_core_dev *mdev, u8 *buffer)
 {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/port.h b/drivers/net/ethernet/mellanox/mlx5/core/en/port.h
index 7a7defe60792..3f474e370828 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/port.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/port.h
@@ -57,6 +57,12 @@ u32 mlx5e_port_speed2linkmodes(struct mlx5_core_dev *mdev, u32 speed,
 bool mlx5e_ptys_ext_supported(struct mlx5_core_dev *mdev);
 int mlx5e_port_query_pbmc(struct mlx5_core_dev *mdev, void *out);
 int mlx5e_port_set_pbmc(struct mlx5_core_dev *mdev, void *in);
+int mlx5e_port_query_sbpr(struct mlx5_core_dev *mdev, u32 desc, u8 dir,
+			  u8 pool_idx, void *out, int size_out);
+int mlx5e_port_set_sbpr(struct mlx5_core_dev *mdev, u32 desc, u8 dir,
+			u8 pool_idx, u32 infi_size, u32 size);
+int mlx5e_port_set_sbcm(struct mlx5_core_dev *mdev, u32 desc, u8 pg_buff_idx,
+			u8 dir, u8 infi_size, u32 max_buff, u8 pool_idx);
 int mlx5e_port_query_priority2buffer(struct mlx5_core_dev *mdev, u8 *buffer);
 int mlx5e_port_set_priority2buffer(struct mlx5_core_dev *mdev, u8 *buffer);
 
-- 
2.39.0

