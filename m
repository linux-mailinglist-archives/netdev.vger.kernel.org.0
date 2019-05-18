Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CC4522401
	for <lists+netdev@lfdr.de>; Sat, 18 May 2019 17:59:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729504AbfERP7S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 May 2019 11:59:18 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:40217 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728337AbfERP7S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 May 2019 11:59:18 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 6FF9F294A9;
        Sat, 18 May 2019 11:59:17 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sat, 18 May 2019 11:59:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=l1luFwaYjbYHhb9OSxwWXbD4wiV8+1uGDGz6xUC0ImM=; b=vFEUKzId
        KJlEA7n48CvPQKyEgaCqO7S7EMvpcF6wR50F+5e8xAXCZBot7fOZMPWEtauv1zXg
        VmvIi1CRe8fzLcvZuTSIVJF7XdXNrpaIsdzYcSwF/e88mL7ONibGhxxF26WqhrKi
        ulXi7N6kjFhdFJfIL5Z5eAqiK/ZrgFE/mmNW3ACxpjhu/NuS/GxZIlIB9P3TYPJB
        QN9idxYWskteq8hPJ+aIfPRCi54WXGlhCTDCoUz14PyiIeNvgZOaZoqD1MwWzYEP
        KKF3I0Y8uJgcNxolbmXUmggpZYiOhfA3w04O2b9vGGCVJ1CgcIpob2EA97sUJzRI
        XdAbAPHUOTrI3A==
X-ME-Sender: <xms:1SvgXMc1Ngfs-M9Z76OpNENNVZ7KdyBNVSi2fiKisNxAu5kc9fbD5A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddruddtgedgieelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppedutdelrdeihedrfeefrddufedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfu
    ihiivgeptd
X-ME-Proxy: <xmx:1SvgXKichK3-GQEKpB4RPswUYs9Qmb37hvzE5Nd6dZs3nGfesn_pIQ>
    <xmx:1SvgXAStFDAq5JBHD2-Ojla7konioZkJ9exaflIsDtplrRhU3d1d5Q>
    <xmx:1SvgXDzigtzERmpcXJQrVd6puoR2E4_Im62PVi-xup0oj9JxaZVFvA>
    <xmx:1SvgXGt0-STKsY_0jw9jAuvADu7ghLJ6LS9Jwo02K5IDqUwbIyBoSA>
Received: from splinter.mtl.com (bzq-109-65-33-130.red.bezeqint.net [109.65.33.130])
        by mail.messagingengine.com (Postfix) with ESMTPA id A085380060;
        Sat, 18 May 2019 11:59:15 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, vadimp@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net 2/2] mlxsw: core: Prevent reading unsupported slave address from SFP EEPROM
Date:   Sat, 18 May 2019 18:58:29 +0300
Message-Id: <20190518155829.31055-3-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190518155829.31055-1-idosch@idosch.org>
References: <20190518155829.31055-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vadim Pasternak <vadimp@mellanox.com>

Prevent reading unsupported slave address from SFP EEPROM by testing
Diagnostic Monitoring Type byte in EEPROM. Read only page zero of
EEPROM, in case this byte is zero.

If some SFP transceiver does not support Digital Optical Monitoring
(DOM), reading SFP EEPROM slave address 0x51 could return an error.
Availability of DOM support is verified by reading from zero page
Diagnostic Monitoring Type byte describing how diagnostic monitoring is
implemented by transceiver. If bit 6 of this byte is set, it indicates
that digital diagnostic monitoring has been implemented. Otherwise it is
not and transceiver could fail to reply to transaction for slave address
0x51 [1010001X (A2h)], which is used to access measurements page.

Such issue has been observed when reading cable MCP2M00-xxxx,
MCP7F00-xxxx, and few others.

Fixes: 2ea109039cd3 ("mlxsw: spectrum: Add support for access cable info via ethtool")
Fixes: 4400081b631a ("mlxsw: spectrum: Fix EEPROM access in case of SFP/SFP+")
Signed-off-by: Vadim Pasternak <vadimp@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core_env.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_env.c b/drivers/net/ethernet/mellanox/mlxsw/core_env.c
index c1c1965d7acc..72539a9a3847 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_env.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_env.c
@@ -3,6 +3,7 @@
 
 #include <linux/kernel.h>
 #include <linux/err.h>
+#include <linux/sfp.h>
 
 #include "core.h"
 #include "core_env.h"
@@ -162,7 +163,7 @@ int mlxsw_env_get_module_info(struct mlxsw_core *mlxsw_core, int module,
 {
 	u8 module_info[MLXSW_REG_MCIA_EEPROM_MODULE_INFO_SIZE];
 	u16 offset = MLXSW_REG_MCIA_EEPROM_MODULE_INFO_SIZE;
-	u8 module_rev_id, module_id;
+	u8 module_rev_id, module_id, diag_mon;
 	unsigned int read_size;
 	int err;
 
@@ -195,8 +196,21 @@ int mlxsw_env_get_module_info(struct mlxsw_core *mlxsw_core, int module,
 		}
 		break;
 	case MLXSW_REG_MCIA_EEPROM_MODULE_INFO_ID_SFP:
+		/* Verify if transceiver provides diagnostic monitoring page */
+		err = mlxsw_env_query_module_eeprom(mlxsw_core, module,
+						    SFP_DIAGMON, 1, &diag_mon,
+						    &read_size);
+		if (err)
+			return err;
+
+		if (read_size < 1)
+			return -EIO;
+
 		modinfo->type       = ETH_MODULE_SFF_8472;
-		modinfo->eeprom_len = ETH_MODULE_SFF_8472_LEN;
+		if (diag_mon)
+			modinfo->eeprom_len = ETH_MODULE_SFF_8472_LEN;
+		else
+			modinfo->eeprom_len = ETH_MODULE_SFF_8472_LEN / 2;
 		break;
 	default:
 		return -EINVAL;
-- 
2.20.1

