Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B118F32D9D2
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 19:59:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235821AbhCDS63 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 13:58:29 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:4905 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235699AbhCDS6O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Mar 2021 13:58:14 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B60412d9e0001>; Thu, 04 Mar 2021 10:57:34 -0800
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 4 Mar
 2021 18:57:34 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 4 Mar 2021 18:57:31 +0000
From:   Moshe Shemesh <moshe@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Adrian Pop <pop.adrian61@gmail.com>,
        "Michal Kubecek" <mkubecek@suse.cz>,
        Don Bollinger <don@thebollingers.org>, <netdev@vger.kernel.org>
CC:     Vladyslav Tarasiuk <vladyslavt@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>
Subject: [RFC PATCH V2 net-next 3/5] net/mlx5: Implement get_module_eeprom_data_by_page()
Date:   Thu, 4 Mar 2021 20:57:06 +0200
Message-ID: <1614884228-8542-4-git-send-email-moshe@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1614884228-8542-1-git-send-email-moshe@nvidia.com>
References: <1614884228-8542-1-git-send-email-moshe@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1614884254; bh=oakLmDywDT4j4XF+8Zb0cz+hBRrtv2GpQyF3HPsd1D4=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Type;
        b=AA1lVvnLaPi43sPjQRSoo3DS9jAbp8Ly2Hlou9LJfIMwT7eVdtZAf+cWnLPqEI/Mz
         6rUwRrTpVkdxWvG1eIF2KytB0lTiQBWT5goOdQS8BNszXra2NKNUwvEEvLw5JSpFuT
         R4Gbopx9j2LrKXFuijyoLpmJd4eVU7pMZQ+SZ5JOW5RQUBohrQf8V7Yr4lKU5F16uS
         KD/lIt2t3boyiqytkL+lRqdSqr/Aym8wzUHJNZ4PqJW7C47iAxZUUJ7yGE2SSVdA7p
         ofprrMRz49OUDmsWU2EnTV952ixtwBjVNjNpclV1+EsEwL2j8Xr1SngvvPv1M71KQU
         yUSSlu8o6Bwpw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladyslav Tarasiuk <vladyslavt@nvidia.com>

Implement ethtool_ops::get_module_eeprom_data_by_page() to enable
support of new SFP standards.

Signed-off-by: Vladyslav Tarasiuk <vladyslavt@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en_ethtool.c  | 42 +++++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/port.c    | 33 +++++++++++++++
 include/linux/mlx5/port.h                     |  2 +
 3 files changed, 77 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index abdf721bb264..6766ffb07c81 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -1769,6 +1769,47 @@ static int mlx5e_get_module_eeprom(struct net_device *netdev,
 	return 0;
 }
 
+static int mlx5e_get_module_eeprom_data_by_page(struct net_device *netdev,
+						const struct ethtool_eeprom_data *page_data,
+						struct netlink_ext_ack *extack)
+{
+	struct mlx5e_priv *priv = netdev_priv(netdev);
+	struct mlx5_module_eeprom_query_params query;
+	struct mlx5_core_dev *mdev = priv->mdev;
+	u8 *data = page_data->data;
+	int size_read;
+	int i = 0;
+
+	if (!page_data->length)
+		return -EINVAL;
+
+	memset(data, 0, page_data->length);
+
+	query.offset = page_data->offset;
+	query.i2c_address = page_data->i2c_address;
+	query.bank = page_data->bank;
+	query.page = page_data->page;
+	while (i < page_data->length) {
+		query.size = page_data->length - i;
+		size_read = mlx5_query_module_eeprom_data(mdev, &query, data + i);
+
+		/* Done reading */
+		if (!size_read)
+			return 0;
+
+		if (size_read < 0) {
+			netdev_err(priv->netdev, "%s: mlx5_query_module_eeprom_data failed:0x%x\n",
+				   __func__, size_read);
+			return 0;
+		}
+
+		i += size_read;
+		query.offset += size_read;
+	}
+
+	return 0;
+}
+
 int mlx5e_ethtool_flash_device(struct mlx5e_priv *priv,
 			       struct ethtool_flash *flash)
 {
@@ -2148,6 +2189,7 @@ const struct ethtool_ops mlx5e_ethtool_ops = {
 	.set_wol	   = mlx5e_set_wol,
 	.get_module_info   = mlx5e_get_module_info,
 	.get_module_eeprom = mlx5e_get_module_eeprom,
+	.get_module_eeprom_data_by_page = mlx5e_get_module_eeprom_data_by_page,
 	.flash_device      = mlx5e_flash_device,
 	.get_priv_flags    = mlx5e_get_priv_flags,
 	.set_priv_flags    = mlx5e_set_priv_flags,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/port.c b/drivers/net/ethernet/mellanox/mlx5/core/port.c
index 9b9f870d67a4..f7a16fdfb8d3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/port.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/port.c
@@ -428,6 +428,39 @@ int mlx5_query_module_eeprom(struct mlx5_core_dev *dev,
 }
 EXPORT_SYMBOL_GPL(mlx5_query_module_eeprom);
 
+int mlx5_query_module_eeprom_data(struct mlx5_core_dev *dev,
+				  struct mlx5_module_eeprom_query_params *params,
+				  u8 *data)
+{
+	u8 module_id;
+	int err;
+
+	err = mlx5_query_module_num(dev, &params->module_number);
+	if (err)
+		return err;
+
+	err = mlx5_query_module_id(dev, params->module_number, &module_id);
+	if (err)
+		return err;
+
+	if (module_id != MLX5_MODULE_ID_SFP &&
+	    module_id != MLX5_MODULE_ID_QSFP &&
+	    module_id != MLX5_MODULE_ID_QSFP28 &&
+	    module_id != MLX5_MODULE_ID_QSFP_PLUS) {
+		mlx5_core_err(dev, "Module ID not recognized: 0x%x\n", module_id);
+		return -EINVAL;
+	}
+
+	if (params->i2c_address != MLX5_I2C_ADDR_HIGH &&
+	    params->i2c_address != MLX5_I2C_ADDR_LOW) {
+		mlx5_core_err(dev, "I2C address not recognized: 0x%x\n", params->i2c_address);
+		return -EINVAL;
+	}
+
+	return mlx5_query_mcia(dev, params, data);
+}
+EXPORT_SYMBOL_GPL(mlx5_query_module_eeprom_data);
+
 static int mlx5_query_port_pvlc(struct mlx5_core_dev *dev, u32 *pvlc,
 				int pvlc_size,  u8 local_port)
 {
diff --git a/include/linux/mlx5/port.h b/include/linux/mlx5/port.h
index 90b87aa82db3..887cd43b41e8 100644
--- a/include/linux/mlx5/port.h
+++ b/include/linux/mlx5/port.h
@@ -209,6 +209,8 @@ void mlx5_query_port_fcs(struct mlx5_core_dev *mdev, bool *supported,
 			 bool *enabled);
 int mlx5_query_module_eeprom(struct mlx5_core_dev *dev,
 			     u16 offset, u16 size, u8 *data);
+int mlx5_query_module_eeprom_data(struct mlx5_core_dev *dev,
+				  struct mlx5_module_eeprom_query_params *params, u8 *data);
 
 int mlx5_query_port_dcbx_param(struct mlx5_core_dev *mdev, u32 *out);
 int mlx5_set_port_dcbx_param(struct mlx5_core_dev *mdev, u32 *in);
-- 
2.18.2

