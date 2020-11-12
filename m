Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D1CE2AFF7E
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 06:51:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726279AbgKLFu6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 00:50:58 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:48260 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725966AbgKLFu4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 00:50:56 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from moshe@mellanox.com)
        with SMTP; 12 Nov 2020 07:50:53 +0200
Received: from vnc1.mtl.labs.mlnx (vnc1.mtl.labs.mlnx [10.7.2.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 0AC5orIE030691;
        Thu, 12 Nov 2020 07:50:53 +0200
Received: from vnc1.mtl.labs.mlnx (localhost [127.0.0.1])
        by vnc1.mtl.labs.mlnx (8.14.4/8.14.4) with ESMTP id 0AC5or78008540;
        Thu, 12 Nov 2020 07:50:53 +0200
Received: (from moshe@localhost)
        by vnc1.mtl.labs.mlnx (8.14.4/8.14.4/Submit) id 0AC5ordf008539;
        Thu, 12 Nov 2020 07:50:53 +0200
From:   Moshe Shemesh <moshe@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Adrian Pop <pop.adrian61@gmail.com>,
        Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev@vger.kernel.org, Vladyslav Tarasiuk <vladyslavt@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>
Subject: [PATCH net-next 2/2] net/mlx5e: Add DSFP EEPROM dump support to ethtool
Date:   Thu, 12 Nov 2020 07:49:41 +0200
Message-Id: <1605160181-8137-3-git-send-email-moshe@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1605160181-8137-1-git-send-email-moshe@mellanox.com>
References: <1605160181-8137-1-git-send-email-moshe@mellanox.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladyslav Tarasiuk <vladyslavt@nvidia.com>

DSFP is a new cable module type, which EEPROM uses memory layout
described in CMIS 4.0 document. Use corresponding standard value for
userspace ethtool to distinguish DSFP's layout from older standards.

Add DSFP module ID in accordance to SFF-8024.

DSFP module memory can be flat or paged, which is indicated by a
flat_mem bit. In first case, only page 00 is available, and in second -
multiple pages: 00h, 01h, 02h, 10h and 11h.

Signed-off-by: Vladyslav Tarasiuk <vladyslavt@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en_ethtool.c  | 12 ++++-
 .../net/ethernet/mellanox/mlx5/core/port.c    | 52 ++++++++++++++++---
 include/linux/mlx5/port.h                     |  1 +
 3 files changed, 57 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index 42e61dc28ead..e6e80f1b0e94 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -1659,8 +1659,8 @@ static int mlx5e_get_module_info(struct net_device *netdev,
 	int size_read = 0;
 	u8 data[4] = {0};
 
-	size_read = mlx5_query_module_eeprom(dev, 0, 2, data);
-	if (size_read < 2)
+	size_read = mlx5_query_module_eeprom(dev, 0, 3, data);
+	if (size_read < 3)
 		return -EIO;
 
 	/* data[0] = identifier byte */
@@ -1680,6 +1680,14 @@ static int mlx5e_get_module_info(struct net_device *netdev,
 			modinfo->eeprom_len = ETH_MODULE_SFF_8436_MAX_LEN;
 		}
 		break;
+	case MLX5_MODULE_ID_DSFP:
+		modinfo->type = ETH_MODULE_CMIS_4;
+		/* check flat_mem bit, zero indicates paged memory */
+		if (data[2] & 0x80)
+			modinfo->eeprom_len = ETH_MODULE_CMIS_4_LEN;
+		else
+			modinfo->eeprom_len = ETH_MODULE_CMIS_4_MAX_LEN;
+		break;
 	case MLX5_MODULE_ID_SFP:
 		modinfo->type       = ETH_MODULE_SFF_8472;
 		modinfo->eeprom_len = ETH_MODULE_SFF_8472_LEN;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/port.c b/drivers/net/ethernet/mellanox/mlx5/core/port.c
index 4bb219565c58..df8e3d024479 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/port.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/port.c
@@ -311,13 +311,9 @@ static int mlx5_query_module_id(struct mlx5_core_dev *dev, int module_num,
 	return 0;
 }
 
-static int mlx5_qsfp_eeprom_page(u16 offset)
+static int mlx5_eeprom_high_page_num(u16 offset)
 {
-	if (offset < MLX5_EEPROM_PAGE_LENGTH)
-		/* Addresses between 0-255 - page 00 */
-		return 0;
-
-	/* Addresses between 256 - 639 belongs to pages 01, 02 and 03
+	/* Addresses 256 and higher belong to pages 01, 02, etc.
 	 * For example, offset = 400 belongs to page 02:
 	 * 1 + ((400 - 256)/128) = 2
 	 */
@@ -325,6 +321,16 @@ static int mlx5_qsfp_eeprom_page(u16 offset)
 		    MLX5_EEPROM_HIGH_PAGE_LENGTH);
 }
 
+static int mlx5_qsfp_eeprom_page(u16 offset)
+{
+	if (offset < MLX5_EEPROM_PAGE_LENGTH)
+		/* Addresses between 0-255 - page 00 */
+		return 0;
+
+	/* Addresses between 256 - 639 belong to pages 01, 02 and 03 */
+	return mlx5_eeprom_high_page_num(offset);
+}
+
 static int mlx5_qsfp_eeprom_high_page_offset(int page_num)
 {
 	if (!page_num) /* Page 0 always start from low page */
@@ -341,6 +347,37 @@ static void mlx5_qsfp_eeprom_params_set(u16 *i2c_addr, int *page_num, u16 *offse
 	*offset -=  mlx5_qsfp_eeprom_high_page_offset(*page_num);
 }
 
+static int mlx5_dsfp_eeprom_high_page_offset(int page_num)
+{
+	if (!page_num)
+		return 0;
+
+	return (page_num < 0x10 ? page_num : page_num - 13) * MLX5_EEPROM_HIGH_PAGE_LENGTH;
+}
+
+static int mlx5_dsfp_eeprom_page(u16 offset)
+{
+	if (offset < MLX5_EEPROM_PAGE_LENGTH)
+		return 0;
+
+	if (offset < MLX5_EEPROM_PAGE_LENGTH + (MLX5_EEPROM_HIGH_PAGE_LENGTH * 2))
+		/* Addresses 0 - 511 - pages 00, 01 and 02 */
+		return mlx5_eeprom_high_page_num(offset);
+
+	/* Offsets 512 - 767 belong to pages 10h and 11h.
+	 * For example, offset = 700 belongs to page 11:
+	 * 13 + 1 + ((700 - 256) / 128) = 17 = 0x11
+	 */
+	return 13 + mlx5_eeprom_high_page_num(offset);
+}
+
+static void mlx5_dsfp_eeprom_params_set(u16 *i2c_addr, int *page_num, u16 *offset)
+{
+	*i2c_addr = MLX5_I2C_ADDR_LOW;
+	*page_num = mlx5_dsfp_eeprom_page(*offset);
+	*offset -= mlx5_dsfp_eeprom_high_page_offset(*page_num);
+}
+
 static void mlx5_sfp_eeprom_params_set(u16 *i2c_addr, int *page_num, u16 *offset)
 {
 	*i2c_addr = MLX5_I2C_ADDR_LOW;
@@ -380,6 +417,9 @@ int mlx5_query_module_eeprom(struct mlx5_core_dev *dev,
 	case MLX5_MODULE_ID_QSFP28:
 		mlx5_qsfp_eeprom_params_set(&i2c_addr, &page_num, &offset);
 		break;
+	case MLX5_MODULE_ID_DSFP:
+		mlx5_dsfp_eeprom_params_set(&i2c_addr, &page_num, &offset);
+		break;
 	default:
 		mlx5_core_err(dev, "Module ID not recognized: 0x%x\n", module_id);
 		return -EINVAL;
diff --git a/include/linux/mlx5/port.h b/include/linux/mlx5/port.h
index 23edd2db4803..ad4b2e778d46 100644
--- a/include/linux/mlx5/port.h
+++ b/include/linux/mlx5/port.h
@@ -45,6 +45,7 @@ enum mlx5_module_id {
 	MLX5_MODULE_ID_QSFP             = 0xC,
 	MLX5_MODULE_ID_QSFP_PLUS        = 0xD,
 	MLX5_MODULE_ID_QSFP28           = 0x11,
+	MLX5_MODULE_ID_DSFP             = 0x1B,
 };
 
 enum mlx5_an_status {
-- 
2.18.2

