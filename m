Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA75F32D9D5
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 19:59:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235848AbhCDS6a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 13:58:30 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:4920 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235730AbhCDS6R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Mar 2021 13:58:17 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B60412da10001>; Thu, 04 Mar 2021 10:57:37 -0800
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 4 Mar
 2021 18:57:36 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 4 Mar 2021 18:57:34 +0000
From:   Moshe Shemesh <moshe@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Adrian Pop <pop.adrian61@gmail.com>,
        "Michal Kubecek" <mkubecek@suse.cz>,
        Don Bollinger <don@thebollingers.org>, <netdev@vger.kernel.org>
CC:     Vladyslav Tarasiuk <vladyslavt@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>
Subject: [RFC PATCH V2 net-next 4/5] net/mlx5: Add support for DSFP module EEPROM dumps
Date:   Thu, 4 Mar 2021 20:57:07 +0200
Message-ID: <1614884228-8542-5-git-send-email-moshe@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1614884228-8542-1-git-send-email-moshe@nvidia.com>
References: <1614884228-8542-1-git-send-email-moshe@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1614884257; bh=sMPig98lT6bUKgNLtfmNT5ef6l+6uoZMWfyYh5gcHxc=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Type;
        b=SBGYCc1KDmPDUGpLEztCSrfSohqnw8+IwsfMilafONGBZ8xtC8heEHJhTbSmkPtvd
         ni+fNgCuaO/ERPWVJH+N5S3wyH+2k2zjfLkqM9Zvjexx8UJGfC+MtH2uWZbf+Q5TeU
         zFpM4RXx7SPhre/UIAMemnNG0qU6aswQjwjAALejWECANCwmqXJVRIOmjgfab5gh9g
         AYa2BvMjfnN3D0zCQ08vdYMTzwt1qoBCj8M8xBvjx0fx8Sfr61k/jti84dgLx9zcCb
         l+5w1zL4CF/SxV0xVgsWlyv6cyCL7AMKHmCwEzy+/gpYMtIjC3SJmPXUN1xgDr7OCJ
         Ivcg1ecIFFrPA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladyslav Tarasiuk <vladyslavt@nvidia.com>

Allow the driver to recognise DSFP transceiver module ID and therefore
allow its EEPROM dumps using ethtool.

Signed-off-by: Vladyslav Tarasiuk <vladyslavt@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/port.c | 3 ++-
 include/linux/mlx5/port.h                      | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/port.c b/drivers/net/ethernet/mellanox/mlx5/core/port.c
index f7a16fdfb8d3..3a7aa6b05198 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/port.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/port.c
@@ -446,7 +446,8 @@ int mlx5_query_module_eeprom_data(struct mlx5_core_dev *dev,
 	if (module_id != MLX5_MODULE_ID_SFP &&
 	    module_id != MLX5_MODULE_ID_QSFP &&
 	    module_id != MLX5_MODULE_ID_QSFP28 &&
-	    module_id != MLX5_MODULE_ID_QSFP_PLUS) {
+	    module_id != MLX5_MODULE_ID_QSFP_PLUS &&
+	    module_id != MLX5_MODULE_ID_DSFP) {
 		mlx5_core_err(dev, "Module ID not recognized: 0x%x\n", module_id);
 		return -EINVAL;
 	}
diff --git a/include/linux/mlx5/port.h b/include/linux/mlx5/port.h
index 887cd43b41e8..71b4373cb96c 100644
--- a/include/linux/mlx5/port.h
+++ b/include/linux/mlx5/port.h
@@ -45,6 +45,7 @@ enum mlx5_module_id {
 	MLX5_MODULE_ID_QSFP             = 0xC,
 	MLX5_MODULE_ID_QSFP_PLUS        = 0xD,
 	MLX5_MODULE_ID_QSFP28           = 0x11,
+	MLX5_MODULE_ID_DSFP		= 0x1B,
 };
 
 enum mlx5_an_status {
-- 
2.18.2

