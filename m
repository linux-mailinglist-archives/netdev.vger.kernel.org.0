Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C8184C0B7C
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 06:10:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237962AbiBWFLK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 00:11:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237927AbiBWFKz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 00:10:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C26F652DE;
        Tue, 22 Feb 2022 21:10:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 38816B80E5B;
        Wed, 23 Feb 2022 05:10:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7197BC340EB;
        Wed, 23 Feb 2022 05:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645593020;
        bh=ujBXg24anTsk/Axomrs9N7clARdmQuZhd4PVBUI6iIs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qLtMNd+5JoaCCmyWr18OeUsQJEiJHKXpyKh10yBilEaTV6I962eAbv8wBiOH8Wop/
         Oh6ESv+NtisHTJU3WVh3eb/d3fGDiY8iCYh3+8Vryov2ojHQew61PEH547SY4Ee5eu
         3uIed+Fx8cWMv/OCLKmIV0AYCOlLQITva6N9+XLobo/tDyeSgI0xmDcFuclXzEaW+7
         7Hf6iEZlVhnWUGSi+te2ugu/VZiW7S5Np52c7nwhQvymmZHoVDdS1i6UrpxDBe3/p0
         rtWx4aLStgVnZxsWaHosdyd5qrKdyOYQHIgAoALHhwjj6lmr/yKDH6lEk2PVezilYo
         uvI1DBVIjMwDg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, Moshe Shemesh <moshe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [mlx5-next 17/17] net/mlx5: Add clarification on sync reset failure
Date:   Tue, 22 Feb 2022 21:09:32 -0800
Message-Id: <20220223050932.244668-18-saeed@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220223050932.244668-1-saeed@kernel.org>
References: <20220223050932.244668-1-saeed@kernel.org>
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

From: Moshe Shemesh <moshe@nvidia.com>

In case devlink reload action fw_activate failed in sync reset stage,
use the new MFRL field reset_state to find why it failed and share this
clarification with the user.

Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/devlink.c | 10 +---
 .../ethernet/mellanox/mlx5/core/fw_reset.c    | 57 ++++++++++++++++---
 .../ethernet/mellanox/mlx5/core/fw_reset.h    |  3 +-
 .../net/ethernet/mellanox/mlx5/core/port.c    | 20 +++++--
 include/linux/mlx5/driver.h                   |  3 +
 5 files changed, 74 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index d1093bb2d436..057dde6f4417 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -100,15 +100,11 @@ static int mlx5_devlink_reload_fw_activate(struct devlink *devlink, struct netli
 	}
 
 	net_port_alive = !!(reset_type & MLX5_MFRL_REG_RESET_TYPE_NET_PORT_ALIVE);
-	err = mlx5_fw_reset_set_reset_sync(dev, net_port_alive);
+	err = mlx5_fw_reset_set_reset_sync(dev, net_port_alive, extack);
 	if (err)
-		goto out;
+		return err;
 
-	err = mlx5_fw_reset_wait_reset_done(dev);
-out:
-	if (err)
-		NL_SET_ERR_MSG_MOD(extack, "FW activate command failed");
-	return err;
+	return mlx5_fw_reset_wait_reset_done(dev);
 }
 
 static int mlx5_devlink_trigger_fw_live_patch(struct devlink *devlink,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
index 0b0234f9d694..d438d7a61500 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
@@ -57,7 +57,8 @@ static int mlx5_reg_mfrl_set(struct mlx5_core_dev *dev, u8 reset_level,
 	return mlx5_core_access_reg(dev, in, sizeof(in), out, sizeof(out), MLX5_REG_MFRL, 0, 1);
 }
 
-static int mlx5_reg_mfrl_query(struct mlx5_core_dev *dev, u8 *reset_level, u8 *reset_type)
+static int mlx5_reg_mfrl_query(struct mlx5_core_dev *dev, u8 *reset_level,
+			       u8 *reset_type, u8 *reset_state)
 {
 	u32 out[MLX5_ST_SZ_DW(mfrl_reg)] = {};
 	u32 in[MLX5_ST_SZ_DW(mfrl_reg)] = {};
@@ -71,25 +72,67 @@ static int mlx5_reg_mfrl_query(struct mlx5_core_dev *dev, u8 *reset_level, u8 *r
 		*reset_level = MLX5_GET(mfrl_reg, out, reset_level);
 	if (reset_type)
 		*reset_type = MLX5_GET(mfrl_reg, out, reset_type);
+	if (reset_state)
+		*reset_state = MLX5_GET(mfrl_reg, out, reset_state);
 
 	return 0;
 }
 
 int mlx5_fw_reset_query(struct mlx5_core_dev *dev, u8 *reset_level, u8 *reset_type)
 {
-	return mlx5_reg_mfrl_query(dev, reset_level, reset_type);
+	return mlx5_reg_mfrl_query(dev, reset_level, reset_type, NULL);
 }
 
-int mlx5_fw_reset_set_reset_sync(struct mlx5_core_dev *dev, u8 reset_type_sel)
+static int mlx5_fw_reset_get_reset_state_err(struct mlx5_core_dev *dev,
+					     struct netlink_ext_ack *extack)
+{
+	u8 reset_state;
+
+	if (mlx5_reg_mfrl_query(dev, NULL, NULL, &reset_state))
+		goto out;
+
+	switch (reset_state) {
+	case MLX5_MFRL_REG_RESET_STATE_IN_NEGOTIATION:
+	case MLX5_MFRL_REG_RESET_STATE_RESET_IN_PROGRESS:
+		NL_SET_ERR_MSG_MOD(extack, "Sync reset was already triggered");
+		return -EBUSY;
+	case MLX5_MFRL_REG_RESET_STATE_TIMEOUT:
+		NL_SET_ERR_MSG_MOD(extack, "Sync reset got timeout");
+		return -ETIMEDOUT;
+	case MLX5_MFRL_REG_RESET_STATE_NACK:
+		NL_SET_ERR_MSG_MOD(extack, "One of the hosts disabled reset");
+		return -EPERM;
+	}
+
+out:
+	NL_SET_ERR_MSG_MOD(extack, "Sync reset failed");
+	return -EIO;
+}
+
+int mlx5_fw_reset_set_reset_sync(struct mlx5_core_dev *dev, u8 reset_type_sel,
+				 struct netlink_ext_ack *extack)
 {
 	struct mlx5_fw_reset *fw_reset = dev->priv.fw_reset;
+	u32 out[MLX5_ST_SZ_DW(mfrl_reg)] = {};
+	u32 in[MLX5_ST_SZ_DW(mfrl_reg)] = {};
 	int err;
 
 	set_bit(MLX5_FW_RESET_FLAGS_PENDING_COMP, &fw_reset->reset_flags);
-	err = mlx5_reg_mfrl_set(dev, MLX5_MFRL_REG_RESET_LEVEL3, reset_type_sel, 0, true);
-	if (err)
-		clear_bit(MLX5_FW_RESET_FLAGS_PENDING_COMP, &fw_reset->reset_flags);
-	return err;
+
+	MLX5_SET(mfrl_reg, in, reset_level, MLX5_MFRL_REG_RESET_LEVEL3);
+	MLX5_SET(mfrl_reg, in, rst_type_sel, reset_type_sel);
+	MLX5_SET(mfrl_reg, in, pci_sync_for_fw_update_start, 1);
+	err = mlx5_access_reg(dev, in, sizeof(in), out, sizeof(out),
+			      MLX5_REG_MFRL, 0, 1, false);
+	if (!err)
+		return 0;
+
+	clear_bit(MLX5_FW_RESET_FLAGS_PENDING_COMP, &fw_reset->reset_flags);
+	if (err == -EREMOTEIO && MLX5_CAP_MCAM_FEATURE(dev, reset_state))
+		return mlx5_fw_reset_get_reset_state_err(dev, extack);
+
+	NL_SET_ERR_MSG_MOD(extack, "Sync reset command failed");
+	return mlx5_cmd_check(dev, err, in, out);
 }
 
 int mlx5_fw_reset_set_live_patch(struct mlx5_core_dev *dev)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.h b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.h
index 7761ee5fc7d0..694fc7cb2684 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.h
@@ -9,7 +9,8 @@
 void mlx5_fw_reset_enable_remote_dev_reset_set(struct mlx5_core_dev *dev, bool enable);
 bool mlx5_fw_reset_enable_remote_dev_reset_get(struct mlx5_core_dev *dev);
 int mlx5_fw_reset_query(struct mlx5_core_dev *dev, u8 *reset_level, u8 *reset_type);
-int mlx5_fw_reset_set_reset_sync(struct mlx5_core_dev *dev, u8 reset_type_sel);
+int mlx5_fw_reset_set_reset_sync(struct mlx5_core_dev *dev, u8 reset_type_sel,
+				 struct netlink_ext_ack *extack);
 int mlx5_fw_reset_set_live_patch(struct mlx5_core_dev *dev);
 
 int mlx5_fw_reset_wait_reset_done(struct mlx5_core_dev *dev);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/port.c b/drivers/net/ethernet/mellanox/mlx5/core/port.c
index 1ef2b6a848c1..d15b417d3e07 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/port.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/port.c
@@ -33,9 +33,10 @@
 #include <linux/mlx5/port.h>
 #include "mlx5_core.h"
 
-int mlx5_core_access_reg(struct mlx5_core_dev *dev, void *data_in,
-			 int size_in, void *data_out, int size_out,
-			 u16 reg_id, int arg, int write)
+/* calling with verbose false will not print error to log */
+int mlx5_access_reg(struct mlx5_core_dev *dev, void *data_in, int size_in,
+		    void *data_out, int size_out, u16 reg_id, int arg,
+		    int write, bool verbose)
 {
 	int outlen = MLX5_ST_SZ_BYTES(access_register_out) + size_out;
 	int inlen = MLX5_ST_SZ_BYTES(access_register_in) + size_in;
@@ -57,7 +58,9 @@ int mlx5_core_access_reg(struct mlx5_core_dev *dev, void *data_in,
 	MLX5_SET(access_register_in, in, argument, arg);
 	MLX5_SET(access_register_in, in, register_id, reg_id);
 
-	err = mlx5_cmd_exec(dev, in, inlen, out, outlen);
+	err = mlx5_cmd_do(dev, in, inlen, out, outlen);
+	if (verbose)
+		err = mlx5_cmd_check(dev, err, in, out);
 	if (err)
 		goto out;
 
@@ -69,6 +72,15 @@ int mlx5_core_access_reg(struct mlx5_core_dev *dev, void *data_in,
 	kvfree(in);
 	return err;
 }
+EXPORT_SYMBOL_GPL(mlx5_access_reg);
+
+int mlx5_core_access_reg(struct mlx5_core_dev *dev, void *data_in,
+			 int size_in, void *data_out, int size_out,
+			 u16 reg_id, int arg, int write)
+{
+	return mlx5_access_reg(dev, data_in, size_in, data_out, size_out,
+			       reg_id, arg, write, true);
+}
 EXPORT_SYMBOL_GPL(mlx5_core_access_reg);
 
 int mlx5_query_pcam_reg(struct mlx5_core_dev *dev, u32 *pcam, u8 feature_group,
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 432151d7d0bf..d3b1a6a1f8d2 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -1031,6 +1031,9 @@ int mlx5_core_detach_mcg(struct mlx5_core_dev *dev, union ib_gid *mgid, u32 qpn)
 
 void mlx5_qp_debugfs_init(struct mlx5_core_dev *dev);
 void mlx5_qp_debugfs_cleanup(struct mlx5_core_dev *dev);
+int mlx5_access_reg(struct mlx5_core_dev *dev, void *data_in, int size_in,
+		    void *data_out, int size_out, u16 reg_id, int arg,
+		    int write, bool verbose);
 int mlx5_core_access_reg(struct mlx5_core_dev *dev, void *data_in,
 			 int size_in, void *data_out, int size_out,
 			 u16 reg_num, int arg, int write);
-- 
2.35.1

