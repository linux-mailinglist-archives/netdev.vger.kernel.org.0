Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5C5F20B3F7
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 16:48:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729455AbgFZOsW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 10:48:22 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:36775 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727112AbgFZOsV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 10:48:21 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 330FD5C0097;
        Fri, 26 Jun 2020 10:48:20 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Fri, 26 Jun 2020 10:48:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=r7cImagPxxy5mFqnz0ursrw8g/5Z4n4hy/HRO0fSiyU=; b=UBWwyr4t
        bgk5p7fbrHrU8C4PBQBz2FyKkOPBDk9oHw/LxIBdbnSVNDKvATrM/QZ1OEwtboS+
        ILqiUsCDsDxWULPNgmQ8CJJ9U+Q0W31JtfdoTUkwhPBbZg5wlj3rPTTP5DlpsBco
        Ul/+F/GhEcSrgHuAgDAECn6q88T5xjvnrG7nUR407f3qCugfNtAF/eKLfOkPlxKl
        hBItnE10GbVWw1U/TQDAyTRJw4POHuGxgfOwjxeoMsftzcqusanEM5eekv7iH3Tr
        VrA/ddON092wgX8Hp/OcKzVKJJCPc74Hr+fNtgY1ttIgdjmYbdO7RNOfHRavFjGf
        MEvQZRONBApakg==
X-ME-Sender: <xms:tAr2XpGfk9IBp6nB-tC7ooqw26vJBIYxddhMtFd_KjGXH_DlRUKRSg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudeluddgkedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppedutdelrdeiiedrudelrddufeef
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:tAr2XuVS2WmLCZtnVPa63ZoymJu2lFu0BJXU2J89grXQSVBpYNNsQA>
    <xmx:tAr2XrJhfkpvGTkzUYkvdh5Dmq4LTb7e76P_QX8WxjMgniRUpRJL1Q>
    <xmx:tAr2XvHwkPQUKgYEPdZMjvYNJtCi5VY6vIsl3Dqp1UWYxSWPyFbKVQ>
    <xmx:tAr2XlzCgxhhn9aeizRTIWaSOgMHmz-uGmRfZMf5B263SSX41TYxpA>
Received: from shredder.mtl.com (bzq-109-66-19-133.red.bezeqint.net [109.66.19.133])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6769C306790C;
        Fri, 26 Jun 2020 10:48:17 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        vadimp@mellanox.com, andrew@lunn.ch, popadrian1996@gmail.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 1/2] mlxsw: core: Add ethtool support for QSFP-DD transceivers
Date:   Fri, 26 Jun 2020 17:47:23 +0300
Message-Id: <20200626144724.224372-2-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200626144724.224372-1-idosch@idosch.org>
References: <20200626144724.224372-1-idosch@idosch.org>
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
 .../net/ethernet/mellanox/mlxsw/core_env.c    | 19 ++++++++++++++++++-
 drivers/net/ethernet/mellanox/mlxsw/reg.h     |  2 ++
 2 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_env.c b/drivers/net/ethernet/mellanox/mlxsw/core_env.c
index 08215fed193d..68f198afc9b0 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_env.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_env.c
@@ -67,7 +67,8 @@ mlxsw_env_query_module_eeprom(struct mlxsw_core *mlxsw_core, int module,
 		offset -= MLXSW_REG_MCIA_EEPROM_UP_PAGE_LENGTH * page;
 		/* When reading upper pages 1, 2 and 3 the offset starts at
 		 * 128. Please refer to "QSFP+ Memory Map" figure in SFF-8436
-		 * specification for graphical depiction.
+		 * specification and to "CMIS Module Memory Map" Figure in
+		 * CMIS specification for graphical depiction.
 		 * MCIA register accepts buffer size <= 48. Page of size 128
 		 * should be read by chunks of size 48, 48, 32. Align the size
 		 * of the last chunk to avoid reading after the end of the
@@ -210,6 +211,22 @@ int mlxsw_env_get_module_info(struct mlxsw_core *mlxsw_core, int module,
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
index fcb88d4271bf..73cc7fd5020c 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -8548,6 +8548,7 @@ MLXSW_ITEM32(reg, mcia, size, 0x08, 0, 16);
 #define MLXSW_REG_MCIA_TH_PAGE_NUM		3
 #define MLXSW_REG_MCIA_PAGE0_LO			0
 #define MLXSW_REG_MCIA_TH_PAGE_OFF		0x80
+#define MLXSW_REG_MCIA_EEPROM_CMIS_FLAT_MEMORY	BIT(7)
 
 enum mlxsw_reg_mcia_eeprom_module_info_rev_id {
 	MLXSW_REG_MCIA_EEPROM_MODULE_INFO_REV_ID_UNSPC	= 0x00,
@@ -8566,6 +8567,7 @@ enum mlxsw_reg_mcia_eeprom_module_info_id {
 enum mlxsw_reg_mcia_eeprom_module_info {
 	MLXSW_REG_MCIA_EEPROM_MODULE_INFO_ID,
 	MLXSW_REG_MCIA_EEPROM_MODULE_INFO_REV_ID,
+	MLXSW_REG_MCIA_EEPROM_MODULE_INFO_TYPE_ID,
 	MLXSW_REG_MCIA_EEPROM_MODULE_INFO_SIZE,
 };
 
-- 
2.26.2

