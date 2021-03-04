Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13BE332D9D3
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 19:59:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235802AbhCDS63 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 13:58:29 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:7993 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235691AbhCDS6L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Mar 2021 13:58:11 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B60412d9b0001>; Thu, 04 Mar 2021 10:57:31 -0800
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 4 Mar
 2021 18:57:31 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 4 Mar 2021 18:57:28 +0000
From:   Moshe Shemesh <moshe@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Adrian Pop <pop.adrian61@gmail.com>,
        "Michal Kubecek" <mkubecek@suse.cz>,
        Don Bollinger <don@thebollingers.org>, <netdev@vger.kernel.org>
CC:     Vladyslav Tarasiuk <vladyslavt@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>
Subject: [RFC PATCH V2 net-next 2/5] net/mlx5: Refactor module EEPROM query
Date:   Thu, 4 Mar 2021 20:57:05 +0200
Message-ID: <1614884228-8542-3-git-send-email-moshe@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1614884228-8542-1-git-send-email-moshe@nvidia.com>
References: <1614884228-8542-1-git-send-email-moshe@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1614884251; bh=XjJrGI0gx7yLAatxbRqvEgXBS5lBriQHj5Zp2JAXHPE=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Type;
        b=pqQlo4dbUYbeZqsPUTHUiiJQazrl9TZOFzK6ZlGqyKLXyA1KOZO8YnD90r9WSBKiY
         X4pCrofFugLjE/SrGQDUETFQyc1eHWpKp/i97tg9HMaiy8QAjMEPlDPrPIQN1XwChc
         qrWBU8ko/Ww0oF91auI46qJjUFoHtGy7fEZoZCR0LlL5NoCEPMAeH9tBuWvTGY/N0y
         orzWJm8zK5PwbWUFWKZFJea7prwqjg5u3K4ysWaUKiq9Y+LFzl78l9nYKqxT8a8Pw5
         xGdIKpr3odAMzY8PkGvMWR3EXnynFTAy7CauW3G6u+1uMOOaOsHgLXR89HF+Nc16wQ
         8qcEMZ+cOvuVQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladyslav Tarasiuk <vladyslavt@nvidia.com>

Prepare for ethtool_ops::get_module_eeprom_data() implementation by
extracting common part of mlx5_query_module_eeprom() into a separate
function.

Signed-off-by: Vladyslav Tarasiuk <vladyslavt@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/port.c    | 79 +++++++++++--------
 include/linux/mlx5/port.h                     |  9 +++
 2 files changed, 54 insertions(+), 34 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/port.c b/drivers/net/ethernet/mellanox/mlx5/core/port.c
index 4bb219565c58..9b9f870d67a4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/port.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/port.c
@@ -353,67 +353,78 @@ static void mlx5_sfp_eeprom_params_set(u16 *i2c_addr, int *page_num, u16 *offset
 	*offset -= MLX5_EEPROM_PAGE_LENGTH;
 }
 
-int mlx5_query_module_eeprom(struct mlx5_core_dev *dev,
-			     u16 offset, u16 size, u8 *data)
+static int mlx5_query_mcia(struct mlx5_core_dev *dev,
+			   struct mlx5_module_eeprom_query_params *params, u8 *data)
 {
-	int module_num, status, err, page_num = 0;
 	u32 in[MLX5_ST_SZ_DW(mcia_reg)] = {};
 	u32 out[MLX5_ST_SZ_DW(mcia_reg)];
-	u16 i2c_addr = 0;
-	u8 module_id;
+	int status, err;
 	void *ptr;
+	u16 size;
+
+	size = min_t(int, params->size, MLX5_EEPROM_MAX_BYTES);
+
+	MLX5_SET(mcia_reg, in, l, 0);
+	MLX5_SET(mcia_reg, in, size, size);
+	MLX5_SET(mcia_reg, in, module, params->module_number);
+	MLX5_SET(mcia_reg, in, device_address, params->offset);
+	MLX5_SET(mcia_reg, in, page_number, params->page);
+	MLX5_SET(mcia_reg, in, i2c_device_address, params->i2c_address);
 
-	err = mlx5_query_module_num(dev, &module_num);
+	err = mlx5_core_access_reg(dev, in, sizeof(in), out,
+				   sizeof(out), MLX5_REG_MCIA, 0, 0);
 	if (err)
 		return err;
 
-	err = mlx5_query_module_id(dev, module_num, &module_id);
+	status = MLX5_GET(mcia_reg, out, status);
+	if (status) {
+		mlx5_core_err(dev, "query_mcia_reg failed: status: 0x%x\n",
+			      status);
+		return -EIO;
+	}
+
+	ptr = MLX5_ADDR_OF(mcia_reg, out, dword_0);
+	memcpy(data, ptr, size);
+
+	return size;
+}
+
+int mlx5_query_module_eeprom(struct mlx5_core_dev *dev,
+			     u16 offset, u16 size, u8 *data)
+{
+	struct mlx5_module_eeprom_query_params query = {0};
+	u8 module_id;
+	int err;
+
+	err = mlx5_query_module_num(dev, &query.module_number);
+	if (err)
+		return err;
+
+	err = mlx5_query_module_id(dev, query.module_number, &module_id);
 	if (err)
 		return err;
 
 	switch (module_id) {
 	case MLX5_MODULE_ID_SFP:
-		mlx5_sfp_eeprom_params_set(&i2c_addr, &page_num, &offset);
+		mlx5_sfp_eeprom_params_set(&query.i2c_address, &query.page, &query.offset);
 		break;
 	case MLX5_MODULE_ID_QSFP:
 	case MLX5_MODULE_ID_QSFP_PLUS:
 	case MLX5_MODULE_ID_QSFP28:
-		mlx5_qsfp_eeprom_params_set(&i2c_addr, &page_num, &offset);
+		mlx5_qsfp_eeprom_params_set(&query.i2c_address, &query.page, &query.offset);
 		break;
 	default:
 		mlx5_core_err(dev, "Module ID not recognized: 0x%x\n", module_id);
 		return -EINVAL;
 	}
 
-	if (offset + size > MLX5_EEPROM_PAGE_LENGTH)
+	if (query.offset + size > MLX5_EEPROM_PAGE_LENGTH)
 		/* Cross pages read, read until offset 256 in low page */
 		size -= offset + size - MLX5_EEPROM_PAGE_LENGTH;
 
-	size = min_t(int, size, MLX5_EEPROM_MAX_BYTES);
+	query.size = size;
 
-	MLX5_SET(mcia_reg, in, l, 0);
-	MLX5_SET(mcia_reg, in, module, module_num);
-	MLX5_SET(mcia_reg, in, i2c_device_address, i2c_addr);
-	MLX5_SET(mcia_reg, in, page_number, page_num);
-	MLX5_SET(mcia_reg, in, device_address, offset);
-	MLX5_SET(mcia_reg, in, size, size);
-
-	err = mlx5_core_access_reg(dev, in, sizeof(in), out,
-				   sizeof(out), MLX5_REG_MCIA, 0, 0);
-	if (err)
-		return err;
-
-	status = MLX5_GET(mcia_reg, out, status);
-	if (status) {
-		mlx5_core_err(dev, "query_mcia_reg failed: status: 0x%x\n",
-			      status);
-		return -EIO;
-	}
-
-	ptr = MLX5_ADDR_OF(mcia_reg, out, dword_0);
-	memcpy(data, ptr, size);
-
-	return size;
+	return mlx5_query_mcia(dev, &query, data);
 }
 EXPORT_SYMBOL_GPL(mlx5_query_module_eeprom);
 
diff --git a/include/linux/mlx5/port.h b/include/linux/mlx5/port.h
index 23edd2db4803..90b87aa82db3 100644
--- a/include/linux/mlx5/port.h
+++ b/include/linux/mlx5/port.h
@@ -62,6 +62,15 @@ enum mlx5_an_status {
 #define MLX5_EEPROM_PAGE_LENGTH		256
 #define MLX5_EEPROM_HIGH_PAGE_LENGTH	128
 
+struct mlx5_module_eeprom_query_params {
+	u16 size;
+	u16 offset;
+	u16 i2c_address;
+	u32 page;
+	u32 bank;
+	u32 module_number;
+};
+
 enum mlx5e_link_mode {
 	MLX5E_1000BASE_CX_SGMII	 = 0,
 	MLX5E_1000BASE_KX	 = 1,
-- 
2.18.2

