Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF1EADE97E
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 12:31:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728062AbfJUKbl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 06:31:41 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:34699 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726725AbfJUKbk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 06:31:40 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 965D121540;
        Mon, 21 Oct 2019 06:31:39 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 21 Oct 2019 06:31:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=bFl2p2PTNUXCRrEkNbnXa/NvWfMRlPUvRANAp9BoVso=; b=pbnQERpm
        DBB6rGxcbK3ERslJabeftq2Iwv+bVtM7WaHuuB31Q7LgoGSHGiMbqwaqBU6/5lgT
        CiPIRYXQdjFQ1suOs6kyziFwOv2rjMnT1mlvEGpBcT+VejCBeHTOc7CSul3s964n
        0nlaGhrF/SArkhghgMd1gElHFg6FseMWLUMGLmzTxHb8yU/r24yZyq/0Gmdi282E
        AK4CfCcwwjlI/7Nx0DwNEuuQa8t1BMmdPJPOLNd27VEcPWLN5iMwxgnZaspQFJe2
        hVCqNTYg4OGL4dfAS27djtvFKAfqCKq8Rsq+cA9Zkbc5qfi5RXdSWcVmD4Bpnaf8
        OT4RVhGBdPYMtA==
X-ME-Sender: <xms:C4mtXUOxf-5In9hE3rAWcqca8H1tuQdzes3t86bTtiA7JZFvTVoE7Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrkeehgdefvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepuddtledrieehrddvtddrvdegieenucfrrghrrghmpehmrg
    hilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghrufhi
    iigvpedt
X-ME-Proxy: <xmx:C4mtXbLHuYbyxWC5gseZh5ABnwMMImD_mgwFe8gZnTnfWbdaCBfdUw>
    <xmx:C4mtXd5Xfw4BxEZboGwQRAjz0sKDZoo7fR8am38yALfOdjM61TEnbA>
    <xmx:C4mtXYTUUXAFNDlqk6Vc7NidM4Z-L71SQ-BplIuW_8SFVsWnMI0inA>
    <xmx:C4mtXV2f1gbmY7qYEoZ4eMhHClV78eG_uQYqD2Dd4K_XCvYcZxm4eg>
Received: from localhost.localdomain (bzq-109-65-20-246.red.bezeqint.net [109.65.20.246])
        by mail.messagingengine.com (Postfix) with ESMTPA id 98E94D60062;
        Mon, 21 Oct 2019 06:31:37 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, vadimp@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 2/2] mlxsw: core: Extend QSFP EEPROM size for ethtool
Date:   Mon, 21 Oct 2019 13:30:31 +0300
Message-Id: <20191021103031.32163-3-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191021103031.32163-1-idosch@idosch.org>
References: <20191021103031.32163-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vadim Pasternak <vadimp@mellanox.com>

Extend the size of QSFP EEPROM for the cable types SSF8436 and SFF8636
from 256 to 640 bytes in order to expose all the EEPROM pages by
ethtool.

For SFF-8636 and SFF-8436 specifications, the driver exposes 256 bytes
of data for ethtool's get_module_eeprom() callback. This is because the
driver uses the below defines to specify SFF module length in ethtool's
get_module_info() callback:
'ETH_MODULE_SFF_8636_LEN' and 'ETH_MODULE_SFF_8436_LEN' (both are 256).

As a result of exposing 256 bytes only, ethtool shows wrong "zero" info
for pages 1, 2, 3.

The patch changes the length returned by callback for get_module_info()
to the values from the next defines: 'ETH_MODULE_SFF_8636_MAX_LEN' and
'ETH_MODULE_SFF_8436_MAX_LEN' (both are 640) to allow exposing of upper
page 1, 2 and 3.

Signed-off-by: Vadim Pasternak <vadimp@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../net/ethernet/mellanox/mlxsw/core_env.c    | 23 ++++++++++++++-----
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_env.c b/drivers/net/ethernet/mellanox/mlxsw/core_env.c
index d2c7ce67c300..08215fed193d 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_env.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_env.c
@@ -50,6 +50,7 @@ mlxsw_env_query_module_eeprom(struct mlxsw_core *mlxsw_core, int module,
 	char eeprom_tmp[MLXSW_REG_MCIA_EEPROM_SIZE];
 	char mcia_pl[MLXSW_REG_MCIA_LEN];
 	u16 i2c_addr;
+	u8 page = 0;
 	int status;
 	int err;
 
@@ -62,11 +63,21 @@ mlxsw_env_query_module_eeprom(struct mlxsw_core *mlxsw_core, int module,
 
 	i2c_addr = MLXSW_REG_MCIA_I2C_ADDR_LOW;
 	if (offset >= MLXSW_REG_MCIA_EEPROM_PAGE_LENGTH) {
-		i2c_addr = MLXSW_REG_MCIA_I2C_ADDR_HIGH;
-		offset -= MLXSW_REG_MCIA_EEPROM_PAGE_LENGTH;
+		page = MLXSW_REG_MCIA_PAGE_GET(offset);
+		offset -= MLXSW_REG_MCIA_EEPROM_UP_PAGE_LENGTH * page;
+		/* When reading upper pages 1, 2 and 3 the offset starts at
+		 * 128. Please refer to "QSFP+ Memory Map" figure in SFF-8436
+		 * specification for graphical depiction.
+		 * MCIA register accepts buffer size <= 48. Page of size 128
+		 * should be read by chunks of size 48, 48, 32. Align the size
+		 * of the last chunk to avoid reading after the end of the
+		 * page.
+		 */
+		if (offset + size > MLXSW_REG_MCIA_EEPROM_PAGE_LENGTH)
+			size = MLXSW_REG_MCIA_EEPROM_PAGE_LENGTH - offset;
 	}
 
-	mlxsw_reg_mcia_pack(mcia_pl, module, 0, 0, offset, size, i2c_addr);
+	mlxsw_reg_mcia_pack(mcia_pl, module, 0, page, offset, size, i2c_addr);
 
 	err = mlxsw_reg_query(mlxsw_core, MLXSW_REG(mcia), mcia_pl);
 	if (err)
@@ -168,7 +179,7 @@ int mlxsw_env_get_module_info(struct mlxsw_core *mlxsw_core, int module,
 	switch (module_id) {
 	case MLXSW_REG_MCIA_EEPROM_MODULE_INFO_ID_QSFP:
 		modinfo->type       = ETH_MODULE_SFF_8436;
-		modinfo->eeprom_len = ETH_MODULE_SFF_8436_LEN;
+		modinfo->eeprom_len = ETH_MODULE_SFF_8436_MAX_LEN;
 		break;
 	case MLXSW_REG_MCIA_EEPROM_MODULE_INFO_ID_QSFP_PLUS: /* fall-through */
 	case MLXSW_REG_MCIA_EEPROM_MODULE_INFO_ID_QSFP28:
@@ -176,10 +187,10 @@ int mlxsw_env_get_module_info(struct mlxsw_core *mlxsw_core, int module,
 		    module_rev_id >=
 		    MLXSW_REG_MCIA_EEPROM_MODULE_INFO_REV_ID_8636) {
 			modinfo->type       = ETH_MODULE_SFF_8636;
-			modinfo->eeprom_len = ETH_MODULE_SFF_8636_LEN;
+			modinfo->eeprom_len = ETH_MODULE_SFF_8636_MAX_LEN;
 		} else {
 			modinfo->type       = ETH_MODULE_SFF_8436;
-			modinfo->eeprom_len = ETH_MODULE_SFF_8436_LEN;
+			modinfo->eeprom_len = ETH_MODULE_SFF_8436_MAX_LEN;
 		}
 		break;
 	case MLXSW_REG_MCIA_EEPROM_MODULE_INFO_ID_SFP:
-- 
2.21.0

