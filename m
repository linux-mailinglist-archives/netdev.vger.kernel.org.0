Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01043230789
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 12:20:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728718AbgG1KUu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 06:20:50 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:43235 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728713AbgG1KUs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 06:20:48 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id B8C315C0167;
        Tue, 28 Jul 2020 06:20:47 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 28 Jul 2020 06:20:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=1OWKB6KZqxRIQ+9dcwtYZyc/+lr46iiyBjsBfyRvp6E=; b=tC8QzOcF
        5Rhns07rC4EebjxURiU6ifPEt9HOHqITH0+m24k9k26WfdE0UzVpGwnBqqqQAIAl
        4AmXnGAfNbT3yecDV6LN3F7VJBhwpDWrtclp6YOWhD/eipoCyC0j+MkrajmMQ/NA
        D9oQnj8CX+HZyulPt+6rKFzIJexqvgljITx8E4uW7kaRqzwMfd5XEJZ0ruSV5dxb
        cryVvvvhg97+2uK8mMFDNbGbNdWqvwTYk69nPl6qYGVMYjSo4et9bfXV8ycEDFpv
        FuZ4dnk529WjDIbOVy+2Esg4VIUWZXsGdjoACfNGEyqF1jll5hp3euKt1QtY0ZvH
        ZPNNuuhWoLJlQg==
X-ME-Sender: <xms:__sfX_omxqrqfI5BEjGf6Ss3CTQ5KjwVhwDA00zrJbAcDylqECb-qQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedriedvgddvhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhe
    fgtdfftefhledvjefggfehgfevjeekhfenucfkphepjeelrddukedurddvrddujeelnecu
    vehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstg
    hhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:__sfX5pQ0b_SflxAzF0v9NxVT6QbwGINst9HlnSclEn9AhUpcfpqeA>
    <xmx:__sfX8MF4osKVzr--2yUhx_SiPM--PVm1k51WUsgJODAjp7WYOI2bA>
    <xmx:__sfXy4SEU9a7-6yzBl1VTZV9lLen1SNYCcNDjBmnYHSL5TnJ7ZRQQ>
    <xmx:__sfX535my1XSV89Rjyy0fK1zbAbRj_0J7wFPjGuL8Jnvov7l02VoQ>
Received: from shredder.mtl.com (bzq-79-181-2-179.red.bezeqint.net [79.181.2.179])
        by mail.messagingengine.com (Postfix) with ESMTPA id 92F4730600B1;
        Tue, 28 Jul 2020 06:20:45 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        vadimp@mellanox.com, andrew@lunn.ch, popadrian1996@gmail.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v2 1/2] mlxsw: core: Add ethtool support for QSFP-DD transceivers
Date:   Tue, 28 Jul 2020 13:20:15 +0300
Message-Id: <20200728102016.1960193-2-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200728102016.1960193-1-idosch@idosch.org>
References: <20200728102016.1960193-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vadim Pasternak <vadimp@mellanox.com>

The Quad Small Form Factor Pluggable Double Density (QSFP-DD) hardware
specification defines a form factor that supports up to 400 Gbps in
aggregate over an 8x50-Gbps electrical interface. The QSFP-DD supports
both optical and copper interfaces.

Implementation is based on Common Management Interface Specification;
Rev 4.0 May 8, 2019. Table 8-2 "Identifier and Status Summary (Lower
Page)" from this spec defines "Id and Status" fields located at offsets
00h - 02h. Bit 2 at offset 02h ("Flat_mem") specifies QSFP EEPROM memory
mode, which could be "upper memory flat" or "paged". Flat memory mode is
coded "1", and indicates that only page 00h is implemented in EEPROM.
Paged memory is coded "0" and indicates that pages 00h, 01h, 02h, 10h
and 11h are implemented. Pages 10h and 11h are currently not supported
by the driver.

"Flat" memory mode is used for the passive copper transceivers. For this
type only page 00h (256 bytes) is available. "Paged" memory is used for
the optical transceivers. For this type pages 00h (256 bytes), 01h (128
bytes) and 02h (128 bytes) are available. Upper page 01h contains static
advertising field, while upper page 02h contains the module-defined
thresholds and lane-specific monitors.

Extend enumerator 'mlxsw_reg_mcia_eeprom_module_info_id' with additional
field 'MLXSW_REG_MCIA_EEPROM_MODULE_INFO_TYPE_ID'. This field is used to
indicate for QSFP-DD transceiver type which memory mode is to be used.

Expose 256 bytes buffer for QSFP-DD passive copper transceiver and
512 bytes buffer for optical.

Signed-off-by: Vadim Pasternak <vadimp@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../net/ethernet/mellanox/mlxsw/core_env.c    | 21 +++++++++++++++++--
 drivers/net/ethernet/mellanox/mlxsw/reg.h     |  2 ++
 2 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_env.c b/drivers/net/ethernet/mellanox/mlxsw/core_env.c
index a7d86df7123f..1828dc569524 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_env.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_env.c
@@ -70,8 +70,9 @@ mlxsw_env_query_module_eeprom(struct mlxsw_core *mlxsw_core, int module,
 		if (qsfp) {
 			/* When reading upper pages 1, 2 and 3 the offset
 			 * starts at 128. Please refer to "QSFP+ Memory Map"
-			 * figure in SFF-8436 specification for graphical
-			 * depiction.
+			 * figure in SFF-8436 specification and to "CMIS Module
+			 * Memory Map" figure in CMIS specification for
+			 * graphical depiction.
 			 */
 			page = MLXSW_REG_MCIA_PAGE_GET(offset);
 			offset -= MLXSW_REG_MCIA_EEPROM_UP_PAGE_LENGTH * page;
@@ -221,6 +222,22 @@ int mlxsw_env_get_module_info(struct mlxsw_core *mlxsw_core, int module,
 		else
 			modinfo->eeprom_len = ETH_MODULE_SFF_8472_LEN / 2;
 		break;
+	case MLXSW_REG_MCIA_EEPROM_MODULE_INFO_ID_QSFP_DD:
+		/* Use SFF_8636 as base type. ethtool should recognize specific
+		 * type through the identifier value.
+		 */
+		modinfo->type       = ETH_MODULE_SFF_8636;
+		/* Verify if module EEPROM is a flat memory. In case of flat
+		 * memory only page 00h (0-255 bytes) can be read. Otherwise
+		 * upper pages 01h and 02h can also be read. Upper pages 10h
+		 * and 11h are currently not supported by the driver.
+		 */
+		if (module_info[MLXSW_REG_MCIA_EEPROM_MODULE_INFO_TYPE_ID] &
+		    MLXSW_REG_MCIA_EEPROM_CMIS_FLAT_MEMORY)
+			modinfo->eeprom_len = ETH_MODULE_SFF_8636_LEN;
+		else
+			modinfo->eeprom_len = ETH_MODULE_SFF_8472_LEN;
+		break;
 	default:
 		return -EINVAL;
 	}
diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index 3c5b25495751..0638dfb23b7e 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -8607,6 +8607,7 @@ MLXSW_ITEM32(reg, mcia, size, 0x08, 0, 16);
 #define MLXSW_REG_MCIA_TH_PAGE_NUM		3
 #define MLXSW_REG_MCIA_PAGE0_LO			0
 #define MLXSW_REG_MCIA_TH_PAGE_OFF		0x80
+#define MLXSW_REG_MCIA_EEPROM_CMIS_FLAT_MEMORY	BIT(7)
 
 enum mlxsw_reg_mcia_eeprom_module_info_rev_id {
 	MLXSW_REG_MCIA_EEPROM_MODULE_INFO_REV_ID_UNSPC	= 0x00,
@@ -8625,6 +8626,7 @@ enum mlxsw_reg_mcia_eeprom_module_info_id {
 enum mlxsw_reg_mcia_eeprom_module_info {
 	MLXSW_REG_MCIA_EEPROM_MODULE_INFO_ID,
 	MLXSW_REG_MCIA_EEPROM_MODULE_INFO_REV_ID,
+	MLXSW_REG_MCIA_EEPROM_MODULE_INFO_TYPE_ID,
 	MLXSW_REG_MCIA_EEPROM_MODULE_INFO_SIZE,
 };
 
-- 
2.26.2

