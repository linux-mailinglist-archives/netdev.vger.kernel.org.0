Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B054167E633
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 14:10:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234651AbjA0NKb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 08:10:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234668AbjA0NJ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 08:09:58 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED42815CA5;
        Fri, 27 Jan 2023 05:09:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1674824967; x=1706360967;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0Y6yU7r41RQbR5swmTXQsH1uvFLJG6/Cy5IVJuAvwGk=;
  b=fHjwIBMcJcuwFkS5TUtVjk8/HM2qS02sK45lAxpFLf+2CYO6S1LTQJdm
   s/3lXREk6iF1aENX10jOa6/95VqN8NSFuyNAwaHvhJar/jurVIrdPxYYn
   Cpp0kvJkXd21MGUIPB2xCSWP+499yPjT/vQYyfEAZdab2537xcvWiPNuG
   uIeySB0YIigg4z4YyKjjDldbffftttCbfaq1yFDtktigNlvTMIJdbqjkc
   CLsmkO6evZ5HRTxRee3M6lxhpAqMXXoO0ksJztKNzZ+YjMSA5Obi3sBys
   qVNQobaSc12mvfQIvdp2zsUMO5EXCJG6YJUNmr8VcMLv0cChE7QIFbaqe
   g==;
X-IronPort-AV: E=Sophos;i="5.97,251,1669100400"; 
   d="scan'208";a="198504238"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 27 Jan 2023 06:09:03 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 27 Jan 2023 06:09:02 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Fri, 27 Jan 2023 06:08:57 -0700
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Steen Hegelund <steen.hegelund@microchip.com>,
        <UNGLinuxDriver@microchip.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        "Casper Andersson" <casper.casan@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Wan Jiabing <wanjiabing@vivo.com>,
        "Nathan Huckleberry" <nhuck@google.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        "Steen Hegelund" <Steen.Hegelund@microchip.com>,
        Daniel Machon <daniel.machon@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Dan Carpenter <error27@gmail.com>,
        Michael Walle <michael@walle.cc>
Subject: [PATCH net-next 4/8] net: microchip: sparx5: Add ES2 VCAP model and updated KUNIT VCAP model
Date:   Fri, 27 Jan 2023 14:08:26 +0100
Message-ID: <20230127130830.1481526-5-steen.hegelund@microchip.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230127130830.1481526-1-steen.hegelund@microchip.com>
References: <20230127130830.1481526-1-steen.hegelund@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,UPPERCASE_50_75 autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This provides the VCAP model for the Sparx5 ES2 (Egress Stage 2) VCAP.

This VCAP provides tagging and remarking functionality

This also renames a VCAP keyfield: VCAP_KF_MIRROR_ENA becomes
VCAP_KF_MIRROR_PROBE, as the first name was caused by a mistake in the
model transformation.

Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
---
 .../ethernet/microchip/sparx5/sparx5_main.c   |    1 +
 .../microchip/sparx5/sparx5_main_regs.h       |  227 +++-
 .../microchip/sparx5/sparx5_vcap_ag_api.c     | 1166 ++++++++++++++++-
 .../net/ethernet/microchip/vcap/vcap_ag_api.h |   11 +-
 .../microchip/vcap/vcap_model_kunit.c         |   14 +-
 5 files changed, 1401 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_main.c b/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
index 3c5d4fe99373..300fb7247bb3 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
@@ -198,6 +198,7 @@ static const struct sparx5_main_io_resource sparx5_main_iomap[] =  {
 	{ TARGET_QSYS,               0x110a0000, 2 }, /* 0x6110a0000 */
 	{ TARGET_QFWD,               0x110b0000, 2 }, /* 0x6110b0000 */
 	{ TARGET_XQS,                0x110c0000, 2 }, /* 0x6110c0000 */
+	{ TARGET_VCAP_ES2,           0x110d0000, 2 }, /* 0x6110d0000 */
 	{ TARGET_CLKGEN,             0x11100000, 2 }, /* 0x611100000 */
 	{ TARGET_ANA_AC_POL,         0x11200000, 2 }, /* 0x611200000 */
 	{ TARGET_QRES,               0x11280000, 2 }, /* 0x611280000 */
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_main_regs.h b/drivers/net/ethernet/microchip/sparx5/sparx5_main_regs.h
index e3bf0460333d..4813433b435c 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_main_regs.h
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_main_regs.h
@@ -4,8 +4,8 @@
  * Copyright (c) 2021 Microchip Technology Inc.
  */
 
-/* This file is autogenerated by cml-utils 2022-12-06 15:28:38 +0100.
- * Commit ID: 3db2ac730f134c160496f2b9f10915e347d871cb
+/* This file is autogenerated by cml-utils 2023-01-17 17:04:43 +0100.
+ * Commit ID: cc027a9bd71002aebf074df5ad8584fe1545e05e
  */
 
 #ifndef _SPARX5_MAIN_REGS_H_
@@ -46,6 +46,7 @@ enum sparx5_target {
 	TARGET_QS = 177,
 	TARGET_QSYS = 178,
 	TARGET_REW = 179,
+	TARGET_VCAP_ES2 = 324,
 	TARGET_VCAP_SUPER = 326,
 	TARGET_VOP = 327,
 	TARGET_XQS = 331,
@@ -3120,6 +3121,36 @@ enum sparx5_target {
 #define DSM_TAXI_CAL_CFG_CAL_PGM_ENA_GET(x)\
 	FIELD_GET(DSM_TAXI_CAL_CFG_CAL_PGM_ENA, x)
 
+/*      EACL:ES2_KEY_SELECT_PROFILE:VCAP_ES2_KEY_SEL */
+#define EACL_VCAP_ES2_KEY_SEL(g, r) __REG(TARGET_EACL, 0, 1, 149504, g, 138, 8, 0, r, 2, 4)
+
+#define EACL_VCAP_ES2_KEY_SEL_IP6_KEY_SEL        GENMASK(7, 5)
+#define EACL_VCAP_ES2_KEY_SEL_IP6_KEY_SEL_SET(x)\
+	FIELD_PREP(EACL_VCAP_ES2_KEY_SEL_IP6_KEY_SEL, x)
+#define EACL_VCAP_ES2_KEY_SEL_IP6_KEY_SEL_GET(x)\
+	FIELD_GET(EACL_VCAP_ES2_KEY_SEL_IP6_KEY_SEL, x)
+
+#define EACL_VCAP_ES2_KEY_SEL_IP4_KEY_SEL        GENMASK(4, 2)
+#define EACL_VCAP_ES2_KEY_SEL_IP4_KEY_SEL_SET(x)\
+	FIELD_PREP(EACL_VCAP_ES2_KEY_SEL_IP4_KEY_SEL, x)
+#define EACL_VCAP_ES2_KEY_SEL_IP4_KEY_SEL_GET(x)\
+	FIELD_GET(EACL_VCAP_ES2_KEY_SEL_IP4_KEY_SEL, x)
+
+#define EACL_VCAP_ES2_KEY_SEL_ARP_KEY_SEL        BIT(1)
+#define EACL_VCAP_ES2_KEY_SEL_ARP_KEY_SEL_SET(x)\
+	FIELD_PREP(EACL_VCAP_ES2_KEY_SEL_ARP_KEY_SEL, x)
+#define EACL_VCAP_ES2_KEY_SEL_ARP_KEY_SEL_GET(x)\
+	FIELD_GET(EACL_VCAP_ES2_KEY_SEL_ARP_KEY_SEL, x)
+
+#define EACL_VCAP_ES2_KEY_SEL_KEY_ENA            BIT(0)
+#define EACL_VCAP_ES2_KEY_SEL_KEY_ENA_SET(x)\
+	FIELD_PREP(EACL_VCAP_ES2_KEY_SEL_KEY_ENA, x)
+#define EACL_VCAP_ES2_KEY_SEL_KEY_ENA_GET(x)\
+	FIELD_GET(EACL_VCAP_ES2_KEY_SEL_KEY_ENA, x)
+
+/*      EACL:CNT_TBL:ES2_CNT */
+#define EACL_ES2_CNT(g)           __REG(TARGET_EACL, 0, 1, 122880, g, 2048, 4, 0, 0, 1, 4)
+
 /*      EACL:POL_CFG:POL_EACL_CFG */
 #define EACL_POL_EACL_CFG         __REG(TARGET_EACL, 0, 1, 150608, 0, 1, 780, 768, 0, 1, 4)
 
@@ -3159,6 +3190,57 @@ enum sparx5_target {
 #define EACL_POL_EACL_CFG_EACL_FORCE_INIT_GET(x)\
 	FIELD_GET(EACL_POL_EACL_CFG_EACL_FORCE_INIT, x)
 
+/*      EACL:ES2_STICKY:SEC_LOOKUP_STICKY */
+#define EACL_SEC_LOOKUP_STICKY(r) __REG(TARGET_EACL, 0, 1, 118696, 0, 1, 8, 0, r, 2, 4)
+
+#define EACL_SEC_LOOKUP_STICKY_SEC_TYPE_IP_7TUPLE_STICKY BIT(7)
+#define EACL_SEC_LOOKUP_STICKY_SEC_TYPE_IP_7TUPLE_STICKY_SET(x)\
+	FIELD_PREP(EACL_SEC_LOOKUP_STICKY_SEC_TYPE_IP_7TUPLE_STICKY, x)
+#define EACL_SEC_LOOKUP_STICKY_SEC_TYPE_IP_7TUPLE_STICKY_GET(x)\
+	FIELD_GET(EACL_SEC_LOOKUP_STICKY_SEC_TYPE_IP_7TUPLE_STICKY, x)
+
+#define EACL_SEC_LOOKUP_STICKY_SEC_TYPE_IP6_VID_STICKY BIT(6)
+#define EACL_SEC_LOOKUP_STICKY_SEC_TYPE_IP6_VID_STICKY_SET(x)\
+	FIELD_PREP(EACL_SEC_LOOKUP_STICKY_SEC_TYPE_IP6_VID_STICKY, x)
+#define EACL_SEC_LOOKUP_STICKY_SEC_TYPE_IP6_VID_STICKY_GET(x)\
+	FIELD_GET(EACL_SEC_LOOKUP_STICKY_SEC_TYPE_IP6_VID_STICKY, x)
+
+#define EACL_SEC_LOOKUP_STICKY_SEC_TYPE_IP6_STD_STICKY BIT(5)
+#define EACL_SEC_LOOKUP_STICKY_SEC_TYPE_IP6_STD_STICKY_SET(x)\
+	FIELD_PREP(EACL_SEC_LOOKUP_STICKY_SEC_TYPE_IP6_STD_STICKY, x)
+#define EACL_SEC_LOOKUP_STICKY_SEC_TYPE_IP6_STD_STICKY_GET(x)\
+	FIELD_GET(EACL_SEC_LOOKUP_STICKY_SEC_TYPE_IP6_STD_STICKY, x)
+
+#define EACL_SEC_LOOKUP_STICKY_SEC_TYPE_IP4_TCPUDP_STICKY BIT(4)
+#define EACL_SEC_LOOKUP_STICKY_SEC_TYPE_IP4_TCPUDP_STICKY_SET(x)\
+	FIELD_PREP(EACL_SEC_LOOKUP_STICKY_SEC_TYPE_IP4_TCPUDP_STICKY, x)
+#define EACL_SEC_LOOKUP_STICKY_SEC_TYPE_IP4_TCPUDP_STICKY_GET(x)\
+	FIELD_GET(EACL_SEC_LOOKUP_STICKY_SEC_TYPE_IP4_TCPUDP_STICKY, x)
+
+#define EACL_SEC_LOOKUP_STICKY_SEC_TYPE_IP4_VID_STICKY BIT(3)
+#define EACL_SEC_LOOKUP_STICKY_SEC_TYPE_IP4_VID_STICKY_SET(x)\
+	FIELD_PREP(EACL_SEC_LOOKUP_STICKY_SEC_TYPE_IP4_VID_STICKY, x)
+#define EACL_SEC_LOOKUP_STICKY_SEC_TYPE_IP4_VID_STICKY_GET(x)\
+	FIELD_GET(EACL_SEC_LOOKUP_STICKY_SEC_TYPE_IP4_VID_STICKY, x)
+
+#define EACL_SEC_LOOKUP_STICKY_SEC_TYPE_IP4_OTHER_STICKY BIT(2)
+#define EACL_SEC_LOOKUP_STICKY_SEC_TYPE_IP4_OTHER_STICKY_SET(x)\
+	FIELD_PREP(EACL_SEC_LOOKUP_STICKY_SEC_TYPE_IP4_OTHER_STICKY, x)
+#define EACL_SEC_LOOKUP_STICKY_SEC_TYPE_IP4_OTHER_STICKY_GET(x)\
+	FIELD_GET(EACL_SEC_LOOKUP_STICKY_SEC_TYPE_IP4_OTHER_STICKY, x)
+
+#define EACL_SEC_LOOKUP_STICKY_SEC_TYPE_ARP_STICKY BIT(1)
+#define EACL_SEC_LOOKUP_STICKY_SEC_TYPE_ARP_STICKY_SET(x)\
+	FIELD_PREP(EACL_SEC_LOOKUP_STICKY_SEC_TYPE_ARP_STICKY, x)
+#define EACL_SEC_LOOKUP_STICKY_SEC_TYPE_ARP_STICKY_GET(x)\
+	FIELD_GET(EACL_SEC_LOOKUP_STICKY_SEC_TYPE_ARP_STICKY, x)
+
+#define EACL_SEC_LOOKUP_STICKY_SEC_TYPE_MAC_ETYPE_STICKY BIT(0)
+#define EACL_SEC_LOOKUP_STICKY_SEC_TYPE_MAC_ETYPE_STICKY_SET(x)\
+	FIELD_PREP(EACL_SEC_LOOKUP_STICKY_SEC_TYPE_MAC_ETYPE_STICKY, x)
+#define EACL_SEC_LOOKUP_STICKY_SEC_TYPE_MAC_ETYPE_STICKY_GET(x)\
+	FIELD_GET(EACL_SEC_LOOKUP_STICKY_SEC_TYPE_MAC_ETYPE_STICKY, x)
+
 /*      EACL:RAM_CTRL:RAM_INIT */
 #define EACL_RAM_INIT             __REG(TARGET_EACL, 0, 1, 118736, 0, 1, 4, 0, 0, 1, 4)
 
@@ -5612,6 +5694,147 @@ enum sparx5_target {
 #define REW_RAM_INIT_RAM_CFG_HOOK_GET(x)\
 	FIELD_GET(REW_RAM_INIT_RAM_CFG_HOOK, x)
 
+/*      VCAP_ES2:VCAP_CORE_CFG:VCAP_UPDATE_CTRL */
+#define VCAP_ES2_CTRL             __REG(TARGET_VCAP_ES2, 0, 1, 0, 0, 1, 8, 0, 0, 1, 4)
+
+#define VCAP_ES2_CTRL_UPDATE_CMD                 GENMASK(24, 22)
+#define VCAP_ES2_CTRL_UPDATE_CMD_SET(x)\
+	FIELD_PREP(VCAP_ES2_CTRL_UPDATE_CMD, x)
+#define VCAP_ES2_CTRL_UPDATE_CMD_GET(x)\
+	FIELD_GET(VCAP_ES2_CTRL_UPDATE_CMD, x)
+
+#define VCAP_ES2_CTRL_UPDATE_ENTRY_DIS           BIT(21)
+#define VCAP_ES2_CTRL_UPDATE_ENTRY_DIS_SET(x)\
+	FIELD_PREP(VCAP_ES2_CTRL_UPDATE_ENTRY_DIS, x)
+#define VCAP_ES2_CTRL_UPDATE_ENTRY_DIS_GET(x)\
+	FIELD_GET(VCAP_ES2_CTRL_UPDATE_ENTRY_DIS, x)
+
+#define VCAP_ES2_CTRL_UPDATE_ACTION_DIS          BIT(20)
+#define VCAP_ES2_CTRL_UPDATE_ACTION_DIS_SET(x)\
+	FIELD_PREP(VCAP_ES2_CTRL_UPDATE_ACTION_DIS, x)
+#define VCAP_ES2_CTRL_UPDATE_ACTION_DIS_GET(x)\
+	FIELD_GET(VCAP_ES2_CTRL_UPDATE_ACTION_DIS, x)
+
+#define VCAP_ES2_CTRL_UPDATE_CNT_DIS             BIT(19)
+#define VCAP_ES2_CTRL_UPDATE_CNT_DIS_SET(x)\
+	FIELD_PREP(VCAP_ES2_CTRL_UPDATE_CNT_DIS, x)
+#define VCAP_ES2_CTRL_UPDATE_CNT_DIS_GET(x)\
+	FIELD_GET(VCAP_ES2_CTRL_UPDATE_CNT_DIS, x)
+
+#define VCAP_ES2_CTRL_UPDATE_ADDR                GENMASK(18, 3)
+#define VCAP_ES2_CTRL_UPDATE_ADDR_SET(x)\
+	FIELD_PREP(VCAP_ES2_CTRL_UPDATE_ADDR, x)
+#define VCAP_ES2_CTRL_UPDATE_ADDR_GET(x)\
+	FIELD_GET(VCAP_ES2_CTRL_UPDATE_ADDR, x)
+
+#define VCAP_ES2_CTRL_UPDATE_SHOT                BIT(2)
+#define VCAP_ES2_CTRL_UPDATE_SHOT_SET(x)\
+	FIELD_PREP(VCAP_ES2_CTRL_UPDATE_SHOT, x)
+#define VCAP_ES2_CTRL_UPDATE_SHOT_GET(x)\
+	FIELD_GET(VCAP_ES2_CTRL_UPDATE_SHOT, x)
+
+#define VCAP_ES2_CTRL_CLEAR_CACHE                BIT(1)
+#define VCAP_ES2_CTRL_CLEAR_CACHE_SET(x)\
+	FIELD_PREP(VCAP_ES2_CTRL_CLEAR_CACHE, x)
+#define VCAP_ES2_CTRL_CLEAR_CACHE_GET(x)\
+	FIELD_GET(VCAP_ES2_CTRL_CLEAR_CACHE, x)
+
+#define VCAP_ES2_CTRL_MV_TRAFFIC_IGN             BIT(0)
+#define VCAP_ES2_CTRL_MV_TRAFFIC_IGN_SET(x)\
+	FIELD_PREP(VCAP_ES2_CTRL_MV_TRAFFIC_IGN, x)
+#define VCAP_ES2_CTRL_MV_TRAFFIC_IGN_GET(x)\
+	FIELD_GET(VCAP_ES2_CTRL_MV_TRAFFIC_IGN, x)
+
+/*      VCAP_ES2:VCAP_CORE_CFG:VCAP_MV_CFG */
+#define VCAP_ES2_CFG              __REG(TARGET_VCAP_ES2, 0, 1, 0, 0, 1, 8, 4, 0, 1, 4)
+
+#define VCAP_ES2_CFG_MV_NUM_POS                  GENMASK(31, 16)
+#define VCAP_ES2_CFG_MV_NUM_POS_SET(x)\
+	FIELD_PREP(VCAP_ES2_CFG_MV_NUM_POS, x)
+#define VCAP_ES2_CFG_MV_NUM_POS_GET(x)\
+	FIELD_GET(VCAP_ES2_CFG_MV_NUM_POS, x)
+
+#define VCAP_ES2_CFG_MV_SIZE                     GENMASK(15, 0)
+#define VCAP_ES2_CFG_MV_SIZE_SET(x)\
+	FIELD_PREP(VCAP_ES2_CFG_MV_SIZE, x)
+#define VCAP_ES2_CFG_MV_SIZE_GET(x)\
+	FIELD_GET(VCAP_ES2_CFG_MV_SIZE, x)
+
+/*      VCAP_ES2:VCAP_CORE_CACHE:VCAP_ENTRY_DAT */
+#define VCAP_ES2_VCAP_ENTRY_DAT(r) __REG(TARGET_VCAP_ES2, 0, 1, 8, 0, 1, 904, 0, r, 64, 4)
+
+/*      VCAP_ES2:VCAP_CORE_CACHE:VCAP_MASK_DAT */
+#define VCAP_ES2_VCAP_MASK_DAT(r) __REG(TARGET_VCAP_ES2, 0, 1, 8, 0, 1, 904, 256, r, 64, 4)
+
+/*      VCAP_ES2:VCAP_CORE_CACHE:VCAP_ACTION_DAT */
+#define VCAP_ES2_VCAP_ACTION_DAT(r) __REG(TARGET_VCAP_ES2, 0, 1, 8, 0, 1, 904, 512, r, 64, 4)
+
+/*      VCAP_ES2:VCAP_CORE_CACHE:VCAP_CNT_DAT */
+#define VCAP_ES2_VCAP_CNT_DAT(r)  __REG(TARGET_VCAP_ES2, 0, 1, 8, 0, 1, 904, 768, r, 32, 4)
+
+/*      VCAP_ES2:VCAP_CORE_CACHE:VCAP_CNT_FW_DAT */
+#define VCAP_ES2_VCAP_CNT_FW_DAT  __REG(TARGET_VCAP_ES2, 0, 1, 8, 0, 1, 904, 896, 0, 1, 4)
+
+/*      VCAP_ES2:VCAP_CORE_CACHE:VCAP_TG_DAT */
+#define VCAP_ES2_VCAP_TG_DAT      __REG(TARGET_VCAP_ES2, 0, 1, 8, 0, 1, 904, 900, 0, 1, 4)
+
+/*      VCAP_ES2:VCAP_CORE_MAP:VCAP_CORE_IDX */
+#define VCAP_ES2_IDX              __REG(TARGET_VCAP_ES2, 0, 1, 912, 0, 1, 8, 0, 0, 1, 4)
+
+#define VCAP_ES2_IDX_CORE_IDX                    GENMASK(3, 0)
+#define VCAP_ES2_IDX_CORE_IDX_SET(x)\
+	FIELD_PREP(VCAP_ES2_IDX_CORE_IDX, x)
+#define VCAP_ES2_IDX_CORE_IDX_GET(x)\
+	FIELD_GET(VCAP_ES2_IDX_CORE_IDX, x)
+
+/*      VCAP_ES2:VCAP_CORE_MAP:VCAP_CORE_MAP */
+#define VCAP_ES2_MAP              __REG(TARGET_VCAP_ES2, 0, 1, 912, 0, 1, 8, 4, 0, 1, 4)
+
+#define VCAP_ES2_MAP_CORE_MAP                    GENMASK(2, 0)
+#define VCAP_ES2_MAP_CORE_MAP_SET(x)\
+	FIELD_PREP(VCAP_ES2_MAP_CORE_MAP, x)
+#define VCAP_ES2_MAP_CORE_MAP_GET(x)\
+	FIELD_GET(VCAP_ES2_MAP_CORE_MAP, x)
+
+/*      VCAP_ES2:VCAP_CORE_STICKY:VCAP_STICKY */
+#define VCAP_ES2_VCAP_STICKY      __REG(TARGET_VCAP_ES2, 0, 1, 920, 0, 1, 4, 0, 0, 1, 4)
+
+#define VCAP_ES2_VCAP_STICKY_VCAP_ROW_DELETED_STICKY BIT(0)
+#define VCAP_ES2_VCAP_STICKY_VCAP_ROW_DELETED_STICKY_SET(x)\
+	FIELD_PREP(VCAP_ES2_VCAP_STICKY_VCAP_ROW_DELETED_STICKY, x)
+#define VCAP_ES2_VCAP_STICKY_VCAP_ROW_DELETED_STICKY_GET(x)\
+	FIELD_GET(VCAP_ES2_VCAP_STICKY_VCAP_ROW_DELETED_STICKY, x)
+
+/*      VCAP_ES2:VCAP_CONST:VCAP_VER */
+#define VCAP_ES2_VCAP_VER         __REG(TARGET_VCAP_ES2, 0, 1, 924, 0, 1, 40, 0, 0, 1, 4)
+
+/*      VCAP_ES2:VCAP_CONST:ENTRY_WIDTH */
+#define VCAP_ES2_ENTRY_WIDTH      __REG(TARGET_VCAP_ES2, 0, 1, 924, 0, 1, 40, 4, 0, 1, 4)
+
+/*      VCAP_ES2:VCAP_CONST:ENTRY_CNT */
+#define VCAP_ES2_ENTRY_CNT        __REG(TARGET_VCAP_ES2, 0, 1, 924, 0, 1, 40, 8, 0, 1, 4)
+
+/*      VCAP_ES2:VCAP_CONST:ENTRY_SWCNT */
+#define VCAP_ES2_ENTRY_SWCNT      __REG(TARGET_VCAP_ES2, 0, 1, 924, 0, 1, 40, 12, 0, 1, 4)
+
+/*      VCAP_ES2:VCAP_CONST:ENTRY_TG_WIDTH */
+#define VCAP_ES2_ENTRY_TG_WIDTH   __REG(TARGET_VCAP_ES2, 0, 1, 924, 0, 1, 40, 16, 0, 1, 4)
+
+/*      VCAP_ES2:VCAP_CONST:ACTION_DEF_CNT */
+#define VCAP_ES2_ACTION_DEF_CNT   __REG(TARGET_VCAP_ES2, 0, 1, 924, 0, 1, 40, 20, 0, 1, 4)
+
+/*      VCAP_ES2:VCAP_CONST:ACTION_WIDTH */
+#define VCAP_ES2_ACTION_WIDTH     __REG(TARGET_VCAP_ES2, 0, 1, 924, 0, 1, 40, 24, 0, 1, 4)
+
+/*      VCAP_ES2:VCAP_CONST:CNT_WIDTH */
+#define VCAP_ES2_CNT_WIDTH        __REG(TARGET_VCAP_ES2, 0, 1, 924, 0, 1, 40, 28, 0, 1, 4)
+
+/*      VCAP_ES2:VCAP_CONST:CORE_CNT */
+#define VCAP_ES2_CORE_CNT         __REG(TARGET_VCAP_ES2, 0, 1, 924, 0, 1, 40, 32, 0, 1, 4)
+
+/*      VCAP_ES2:VCAP_CONST:IF_CNT */
+#define VCAP_ES2_IF_CNT           __REG(TARGET_VCAP_ES2, 0, 1, 924, 0, 1, 40, 36, 0, 1, 4)
+
 /*      VCAP_SUPER:VCAP_CORE_CFG:VCAP_UPDATE_CTRL */
 #define VCAP_SUPER_CTRL           __REG(TARGET_VCAP_SUPER, 0, 1, 0, 0, 1, 8, 0, 0, 1, 4)
 
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_ag_api.c b/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_ag_api.c
index 41e50743f3ac..561001ee0516 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_ag_api.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_ag_api.c
@@ -1,10 +1,10 @@
 // SPDX-License-Identifier: BSD-3-Clause
-/* Copyright (C) 2022 Microchip Technology Inc. and its subsidiaries.
+/* Copyright (C) 2023 Microchip Technology Inc. and its subsidiaries.
  * Microchip VCAP API
  */
 
-/* This file is autogenerated by cml-utils 2022-12-06 12:43:54 +0100.
- * Commit ID: 3db2ac730f134c160496f2b9f10915e347d871cb
+/* This file is autogenerated by cml-utils 2023-01-17 16:55:38 +0100.
+ * Commit ID: cc027a9bd71002aebf074df5ad8584fe1545e05e
  */
 
 #include <linux/types.h>
@@ -1333,6 +1333,909 @@ static const struct vcap_field is2_ip_7tuple_keyfield[] = {
 	},
 };
 
+static const struct vcap_field es2_mac_etype_keyfield[] = {
+	[VCAP_KF_TYPE] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 0,
+		.width = 3,
+	},
+	[VCAP_KF_LOOKUP_FIRST_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 3,
+		.width = 1,
+	},
+	[VCAP_KF_L2_MC_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 13,
+		.width = 1,
+	},
+	[VCAP_KF_L2_BC_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 14,
+		.width = 1,
+	},
+	[VCAP_KF_ISDX_GT0_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 15,
+		.width = 1,
+	},
+	[VCAP_KF_ISDX_CLS] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 16,
+		.width = 12,
+	},
+	[VCAP_KF_8021Q_VLAN_TAGGED_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 28,
+		.width = 1,
+	},
+	[VCAP_KF_8021Q_VID_CLS] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 29,
+		.width = 13,
+	},
+	[VCAP_KF_IF_EGR_PORT_MASK_RNG] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 42,
+		.width = 3,
+	},
+	[VCAP_KF_IF_EGR_PORT_MASK] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 45,
+		.width = 32,
+	},
+	[VCAP_KF_IF_IGR_PORT_SEL] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 77,
+		.width = 1,
+	},
+	[VCAP_KF_IF_IGR_PORT] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 78,
+		.width = 9,
+	},
+	[VCAP_KF_8021Q_PCP_CLS] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 87,
+		.width = 3,
+	},
+	[VCAP_KF_8021Q_DEI_CLS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 90,
+		.width = 1,
+	},
+	[VCAP_KF_COSID_CLS] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 91,
+		.width = 3,
+	},
+	[VCAP_KF_L3_DPL_CLS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 94,
+		.width = 1,
+	},
+	[VCAP_KF_L3_RT_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 95,
+		.width = 1,
+	},
+	[VCAP_KF_L2_DMAC] = {
+		.type = VCAP_FIELD_U48,
+		.offset = 99,
+		.width = 48,
+	},
+	[VCAP_KF_L2_SMAC] = {
+		.type = VCAP_FIELD_U48,
+		.offset = 147,
+		.width = 48,
+	},
+	[VCAP_KF_ETYPE_LEN_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 195,
+		.width = 1,
+	},
+	[VCAP_KF_ETYPE] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 196,
+		.width = 16,
+	},
+	[VCAP_KF_L2_PAYLOAD_ETYPE] = {
+		.type = VCAP_FIELD_U64,
+		.offset = 212,
+		.width = 64,
+	},
+	[VCAP_KF_OAM_CCM_CNTS_EQ0] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 276,
+		.width = 1,
+	},
+	[VCAP_KF_OAM_Y1731_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 277,
+		.width = 1,
+	},
+};
+
+static const struct vcap_field es2_arp_keyfield[] = {
+	[VCAP_KF_TYPE] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 0,
+		.width = 3,
+	},
+	[VCAP_KF_LOOKUP_FIRST_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 3,
+		.width = 1,
+	},
+	[VCAP_KF_L2_MC_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 13,
+		.width = 1,
+	},
+	[VCAP_KF_L2_BC_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 14,
+		.width = 1,
+	},
+	[VCAP_KF_ISDX_GT0_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 15,
+		.width = 1,
+	},
+	[VCAP_KF_ISDX_CLS] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 16,
+		.width = 12,
+	},
+	[VCAP_KF_8021Q_VLAN_TAGGED_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 28,
+		.width = 1,
+	},
+	[VCAP_KF_8021Q_VID_CLS] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 29,
+		.width = 13,
+	},
+	[VCAP_KF_IF_EGR_PORT_MASK_RNG] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 42,
+		.width = 3,
+	},
+	[VCAP_KF_IF_EGR_PORT_MASK] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 45,
+		.width = 32,
+	},
+	[VCAP_KF_IF_IGR_PORT_SEL] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 77,
+		.width = 1,
+	},
+	[VCAP_KF_IF_IGR_PORT] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 78,
+		.width = 9,
+	},
+	[VCAP_KF_8021Q_PCP_CLS] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 87,
+		.width = 3,
+	},
+	[VCAP_KF_8021Q_DEI_CLS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 90,
+		.width = 1,
+	},
+	[VCAP_KF_COSID_CLS] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 91,
+		.width = 3,
+	},
+	[VCAP_KF_L3_DPL_CLS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 94,
+		.width = 1,
+	},
+	[VCAP_KF_L2_SMAC] = {
+		.type = VCAP_FIELD_U48,
+		.offset = 98,
+		.width = 48,
+	},
+	[VCAP_KF_ARP_ADDR_SPACE_OK_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 146,
+		.width = 1,
+	},
+	[VCAP_KF_ARP_PROTO_SPACE_OK_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 147,
+		.width = 1,
+	},
+	[VCAP_KF_ARP_LEN_OK_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 148,
+		.width = 1,
+	},
+	[VCAP_KF_ARP_TGT_MATCH_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 149,
+		.width = 1,
+	},
+	[VCAP_KF_ARP_SENDER_MATCH_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 150,
+		.width = 1,
+	},
+	[VCAP_KF_ARP_OPCODE_UNKNOWN_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 151,
+		.width = 1,
+	},
+	[VCAP_KF_ARP_OPCODE] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 152,
+		.width = 2,
+	},
+	[VCAP_KF_L3_IP4_DIP] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 154,
+		.width = 32,
+	},
+	[VCAP_KF_L3_IP4_SIP] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 186,
+		.width = 32,
+	},
+	[VCAP_KF_L3_DIP_EQ_SIP_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 218,
+		.width = 1,
+	},
+};
+
+static const struct vcap_field es2_ip4_tcp_udp_keyfield[] = {
+	[VCAP_KF_TYPE] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 0,
+		.width = 3,
+	},
+	[VCAP_KF_LOOKUP_FIRST_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 3,
+		.width = 1,
+	},
+	[VCAP_KF_L2_MC_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 13,
+		.width = 1,
+	},
+	[VCAP_KF_L2_BC_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 14,
+		.width = 1,
+	},
+	[VCAP_KF_ISDX_GT0_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 15,
+		.width = 1,
+	},
+	[VCAP_KF_ISDX_CLS] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 16,
+		.width = 12,
+	},
+	[VCAP_KF_8021Q_VLAN_TAGGED_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 28,
+		.width = 1,
+	},
+	[VCAP_KF_8021Q_VID_CLS] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 29,
+		.width = 13,
+	},
+	[VCAP_KF_IF_EGR_PORT_MASK_RNG] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 42,
+		.width = 3,
+	},
+	[VCAP_KF_IF_EGR_PORT_MASK] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 45,
+		.width = 32,
+	},
+	[VCAP_KF_IF_IGR_PORT_SEL] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 77,
+		.width = 1,
+	},
+	[VCAP_KF_IF_IGR_PORT] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 78,
+		.width = 9,
+	},
+	[VCAP_KF_8021Q_PCP_CLS] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 87,
+		.width = 3,
+	},
+	[VCAP_KF_8021Q_DEI_CLS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 90,
+		.width = 1,
+	},
+	[VCAP_KF_COSID_CLS] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 91,
+		.width = 3,
+	},
+	[VCAP_KF_L3_DPL_CLS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 94,
+		.width = 1,
+	},
+	[VCAP_KF_L3_RT_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 95,
+		.width = 1,
+	},
+	[VCAP_KF_IP4_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 99,
+		.width = 1,
+	},
+	[VCAP_KF_L3_FRAGMENT_TYPE] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 100,
+		.width = 2,
+	},
+	[VCAP_KF_L3_OPTIONS_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 102,
+		.width = 1,
+	},
+	[VCAP_KF_L3_TTL_GT0] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 103,
+		.width = 1,
+	},
+	[VCAP_KF_L3_TOS] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 104,
+		.width = 8,
+	},
+	[VCAP_KF_L3_IP4_DIP] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 112,
+		.width = 32,
+	},
+	[VCAP_KF_L3_IP4_SIP] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 144,
+		.width = 32,
+	},
+	[VCAP_KF_L3_DIP_EQ_SIP_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 176,
+		.width = 1,
+	},
+	[VCAP_KF_TCP_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 177,
+		.width = 1,
+	},
+	[VCAP_KF_L4_DPORT] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 178,
+		.width = 16,
+	},
+	[VCAP_KF_L4_SPORT] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 194,
+		.width = 16,
+	},
+	[VCAP_KF_L4_RNG] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 210,
+		.width = 16,
+	},
+	[VCAP_KF_L4_SPORT_EQ_DPORT_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 226,
+		.width = 1,
+	},
+	[VCAP_KF_L4_SEQUENCE_EQ0_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 227,
+		.width = 1,
+	},
+	[VCAP_KF_L4_FIN] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 228,
+		.width = 1,
+	},
+	[VCAP_KF_L4_SYN] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 229,
+		.width = 1,
+	},
+	[VCAP_KF_L4_RST] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 230,
+		.width = 1,
+	},
+	[VCAP_KF_L4_PSH] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 231,
+		.width = 1,
+	},
+	[VCAP_KF_L4_ACK] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 232,
+		.width = 1,
+	},
+	[VCAP_KF_L4_URG] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 233,
+		.width = 1,
+	},
+	[VCAP_KF_L4_PAYLOAD] = {
+		.type = VCAP_FIELD_U64,
+		.offset = 234,
+		.width = 64,
+	},
+};
+
+static const struct vcap_field es2_ip4_other_keyfield[] = {
+	[VCAP_KF_TYPE] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 0,
+		.width = 3,
+	},
+	[VCAP_KF_LOOKUP_FIRST_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 3,
+		.width = 1,
+	},
+	[VCAP_KF_L2_MC_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 13,
+		.width = 1,
+	},
+	[VCAP_KF_L2_BC_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 14,
+		.width = 1,
+	},
+	[VCAP_KF_ISDX_GT0_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 15,
+		.width = 1,
+	},
+	[VCAP_KF_ISDX_CLS] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 16,
+		.width = 12,
+	},
+	[VCAP_KF_8021Q_VLAN_TAGGED_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 28,
+		.width = 1,
+	},
+	[VCAP_KF_8021Q_VID_CLS] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 29,
+		.width = 13,
+	},
+	[VCAP_KF_IF_EGR_PORT_MASK_RNG] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 42,
+		.width = 3,
+	},
+	[VCAP_KF_IF_EGR_PORT_MASK] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 45,
+		.width = 32,
+	},
+	[VCAP_KF_IF_IGR_PORT_SEL] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 77,
+		.width = 1,
+	},
+	[VCAP_KF_IF_IGR_PORT] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 78,
+		.width = 9,
+	},
+	[VCAP_KF_8021Q_PCP_CLS] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 87,
+		.width = 3,
+	},
+	[VCAP_KF_8021Q_DEI_CLS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 90,
+		.width = 1,
+	},
+	[VCAP_KF_COSID_CLS] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 91,
+		.width = 3,
+	},
+	[VCAP_KF_L3_DPL_CLS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 94,
+		.width = 1,
+	},
+	[VCAP_KF_L3_RT_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 95,
+		.width = 1,
+	},
+	[VCAP_KF_IP4_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 99,
+		.width = 1,
+	},
+	[VCAP_KF_L3_FRAGMENT_TYPE] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 100,
+		.width = 2,
+	},
+	[VCAP_KF_L3_OPTIONS_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 102,
+		.width = 1,
+	},
+	[VCAP_KF_L3_TTL_GT0] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 103,
+		.width = 1,
+	},
+	[VCAP_KF_L3_TOS] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 104,
+		.width = 8,
+	},
+	[VCAP_KF_L3_IP4_DIP] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 112,
+		.width = 32,
+	},
+	[VCAP_KF_L3_IP4_SIP] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 144,
+		.width = 32,
+	},
+	[VCAP_KF_L3_DIP_EQ_SIP_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 176,
+		.width = 1,
+	},
+	[VCAP_KF_L3_IP_PROTO] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 177,
+		.width = 8,
+	},
+	[VCAP_KF_L3_PAYLOAD] = {
+		.type = VCAP_FIELD_U112,
+		.offset = 185,
+		.width = 96,
+	},
+};
+
+static const struct vcap_field es2_ip_7tuple_keyfield[] = {
+	[VCAP_KF_LOOKUP_FIRST_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 0,
+		.width = 1,
+	},
+	[VCAP_KF_L2_MC_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 10,
+		.width = 1,
+	},
+	[VCAP_KF_L2_BC_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 11,
+		.width = 1,
+	},
+	[VCAP_KF_ISDX_GT0_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 12,
+		.width = 1,
+	},
+	[VCAP_KF_ISDX_CLS] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 13,
+		.width = 12,
+	},
+	[VCAP_KF_8021Q_VLAN_TAGGED_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 25,
+		.width = 1,
+	},
+	[VCAP_KF_8021Q_VID_CLS] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 26,
+		.width = 13,
+	},
+	[VCAP_KF_IF_EGR_PORT_MASK_RNG] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 39,
+		.width = 3,
+	},
+	[VCAP_KF_IF_EGR_PORT_MASK] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 42,
+		.width = 32,
+	},
+	[VCAP_KF_IF_IGR_PORT_SEL] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 74,
+		.width = 1,
+	},
+	[VCAP_KF_IF_IGR_PORT] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 75,
+		.width = 9,
+	},
+	[VCAP_KF_8021Q_PCP_CLS] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 84,
+		.width = 3,
+	},
+	[VCAP_KF_8021Q_DEI_CLS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 87,
+		.width = 1,
+	},
+	[VCAP_KF_COSID_CLS] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 88,
+		.width = 3,
+	},
+	[VCAP_KF_L3_DPL_CLS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 91,
+		.width = 1,
+	},
+	[VCAP_KF_L3_RT_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 92,
+		.width = 1,
+	},
+	[VCAP_KF_L2_DMAC] = {
+		.type = VCAP_FIELD_U48,
+		.offset = 96,
+		.width = 48,
+	},
+	[VCAP_KF_L2_SMAC] = {
+		.type = VCAP_FIELD_U48,
+		.offset = 144,
+		.width = 48,
+	},
+	[VCAP_KF_IP4_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 192,
+		.width = 1,
+	},
+	[VCAP_KF_L3_TTL_GT0] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 193,
+		.width = 1,
+	},
+	[VCAP_KF_L3_TOS] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 194,
+		.width = 8,
+	},
+	[VCAP_KF_L3_IP6_DIP] = {
+		.type = VCAP_FIELD_U128,
+		.offset = 202,
+		.width = 128,
+	},
+	[VCAP_KF_L3_IP6_SIP] = {
+		.type = VCAP_FIELD_U128,
+		.offset = 330,
+		.width = 128,
+	},
+	[VCAP_KF_L3_DIP_EQ_SIP_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 458,
+		.width = 1,
+	},
+	[VCAP_KF_TCP_UDP_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 459,
+		.width = 1,
+	},
+	[VCAP_KF_TCP_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 460,
+		.width = 1,
+	},
+	[VCAP_KF_L4_DPORT] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 461,
+		.width = 16,
+	},
+	[VCAP_KF_L4_SPORT] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 477,
+		.width = 16,
+	},
+	[VCAP_KF_L4_RNG] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 493,
+		.width = 16,
+	},
+	[VCAP_KF_L4_SPORT_EQ_DPORT_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 509,
+		.width = 1,
+	},
+	[VCAP_KF_L4_SEQUENCE_EQ0_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 510,
+		.width = 1,
+	},
+	[VCAP_KF_L4_FIN] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 511,
+		.width = 1,
+	},
+	[VCAP_KF_L4_SYN] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 512,
+		.width = 1,
+	},
+	[VCAP_KF_L4_RST] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 513,
+		.width = 1,
+	},
+	[VCAP_KF_L4_PSH] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 514,
+		.width = 1,
+	},
+	[VCAP_KF_L4_ACK] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 515,
+		.width = 1,
+	},
+	[VCAP_KF_L4_URG] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 516,
+		.width = 1,
+	},
+	[VCAP_KF_L4_PAYLOAD] = {
+		.type = VCAP_FIELD_U64,
+		.offset = 517,
+		.width = 64,
+	},
+};
+
+static const struct vcap_field es2_ip6_std_keyfield[] = {
+	[VCAP_KF_TYPE] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 0,
+		.width = 3,
+	},
+	[VCAP_KF_LOOKUP_FIRST_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 3,
+		.width = 1,
+	},
+	[VCAP_KF_L2_MC_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 13,
+		.width = 1,
+	},
+	[VCAP_KF_L2_BC_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 14,
+		.width = 1,
+	},
+	[VCAP_KF_ISDX_GT0_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 15,
+		.width = 1,
+	},
+	[VCAP_KF_ISDX_CLS] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 16,
+		.width = 12,
+	},
+	[VCAP_KF_8021Q_VLAN_TAGGED_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 28,
+		.width = 1,
+	},
+	[VCAP_KF_8021Q_VID_CLS] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 29,
+		.width = 13,
+	},
+	[VCAP_KF_IF_EGR_PORT_MASK_RNG] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 42,
+		.width = 3,
+	},
+	[VCAP_KF_IF_EGR_PORT_MASK] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 45,
+		.width = 32,
+	},
+	[VCAP_KF_IF_IGR_PORT_SEL] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 77,
+		.width = 1,
+	},
+	[VCAP_KF_IF_IGR_PORT] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 78,
+		.width = 9,
+	},
+	[VCAP_KF_8021Q_PCP_CLS] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 87,
+		.width = 3,
+	},
+	[VCAP_KF_8021Q_DEI_CLS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 90,
+		.width = 1,
+	},
+	[VCAP_KF_COSID_CLS] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 91,
+		.width = 3,
+	},
+	[VCAP_KF_L3_DPL_CLS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 94,
+		.width = 1,
+	},
+	[VCAP_KF_L3_RT_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 95,
+		.width = 1,
+	},
+	[VCAP_KF_L3_TTL_GT0] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 99,
+		.width = 1,
+	},
+	[VCAP_KF_L3_IP6_SIP] = {
+		.type = VCAP_FIELD_U128,
+		.offset = 100,
+		.width = 128,
+	},
+	[VCAP_KF_L3_DIP_EQ_SIP_IS] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 228,
+		.width = 1,
+	},
+	[VCAP_KF_L3_IP_PROTO] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 229,
+		.width = 8,
+	},
+	[VCAP_KF_L4_RNG] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 237,
+		.width = 16,
+	},
+	[VCAP_KF_L3_PAYLOAD] = {
+		.type = VCAP_FIELD_U48,
+		.offset = 253,
+		.width = 40,
+	},
+};
+
 /* keyfield_set */
 static const struct vcap_set is0_keyfield_set[] = {
 	[VCAP_KFS_NORMAL_7TUPLE] = {
@@ -1380,6 +2283,39 @@ static const struct vcap_set is2_keyfield_set[] = {
 	},
 };
 
+static const struct vcap_set es2_keyfield_set[] = {
+	[VCAP_KFS_MAC_ETYPE] = {
+		.type_id = 0,
+		.sw_per_item = 6,
+		.sw_cnt = 2,
+	},
+	[VCAP_KFS_ARP] = {
+		.type_id = 1,
+		.sw_per_item = 6,
+		.sw_cnt = 2,
+	},
+	[VCAP_KFS_IP4_TCP_UDP] = {
+		.type_id = 2,
+		.sw_per_item = 6,
+		.sw_cnt = 2,
+	},
+	[VCAP_KFS_IP4_OTHER] = {
+		.type_id = 3,
+		.sw_per_item = 6,
+		.sw_cnt = 2,
+	},
+	[VCAP_KFS_IP_7TUPLE] = {
+		.type_id = -1,
+		.sw_per_item = 12,
+		.sw_cnt = 1,
+	},
+	[VCAP_KFS_IP6_STD] = {
+		.type_id = 4,
+		.sw_per_item = 6,
+		.sw_cnt = 2,
+	},
+};
+
 /* keyfield_set map */
 static const struct vcap_field *is0_keyfield_set_map[] = {
 	[VCAP_KFS_NORMAL_7TUPLE] = is0_normal_7tuple_keyfield,
@@ -1395,6 +2331,15 @@ static const struct vcap_field *is2_keyfield_set_map[] = {
 	[VCAP_KFS_IP_7TUPLE] = is2_ip_7tuple_keyfield,
 };
 
+static const struct vcap_field *es2_keyfield_set_map[] = {
+	[VCAP_KFS_MAC_ETYPE] = es2_mac_etype_keyfield,
+	[VCAP_KFS_ARP] = es2_arp_keyfield,
+	[VCAP_KFS_IP4_TCP_UDP] = es2_ip4_tcp_udp_keyfield,
+	[VCAP_KFS_IP4_OTHER] = es2_ip4_other_keyfield,
+	[VCAP_KFS_IP_7TUPLE] = es2_ip_7tuple_keyfield,
+	[VCAP_KFS_IP6_STD] = es2_ip6_std_keyfield,
+};
+
 /* keyfield_set map sizes */
 static int is0_keyfield_set_map_size[] = {
 	[VCAP_KFS_NORMAL_7TUPLE] = ARRAY_SIZE(is0_normal_7tuple_keyfield),
@@ -1410,6 +2355,15 @@ static int is2_keyfield_set_map_size[] = {
 	[VCAP_KFS_IP_7TUPLE] = ARRAY_SIZE(is2_ip_7tuple_keyfield),
 };
 
+static int es2_keyfield_set_map_size[] = {
+	[VCAP_KFS_MAC_ETYPE] = ARRAY_SIZE(es2_mac_etype_keyfield),
+	[VCAP_KFS_ARP] = ARRAY_SIZE(es2_arp_keyfield),
+	[VCAP_KFS_IP4_TCP_UDP] = ARRAY_SIZE(es2_ip4_tcp_udp_keyfield),
+	[VCAP_KFS_IP4_OTHER] = ARRAY_SIZE(es2_ip4_other_keyfield),
+	[VCAP_KFS_IP_7TUPLE] = ARRAY_SIZE(es2_ip_7tuple_keyfield),
+	[VCAP_KFS_IP6_STD] = ARRAY_SIZE(es2_ip6_std_keyfield),
+};
+
 /* actionfields */
 static const struct vcap_field is0_classification_actionfield[] = {
 	[VCAP_AF_TYPE] = {
@@ -1798,6 +2752,79 @@ static const struct vcap_field is2_base_type_actionfield[] = {
 	},
 };
 
+static const struct vcap_field es2_base_type_actionfield[] = {
+	[VCAP_AF_HIT_ME_ONCE] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 0,
+		.width = 1,
+	},
+	[VCAP_AF_INTR_ENA] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 1,
+		.width = 1,
+	},
+	[VCAP_AF_FWD_MODE] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 2,
+		.width = 2,
+	},
+	[VCAP_AF_COPY_QUEUE_NUM] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 4,
+		.width = 16,
+	},
+	[VCAP_AF_COPY_PORT_NUM] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 20,
+		.width = 7,
+	},
+	[VCAP_AF_MIRROR_PROBE_ID] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 27,
+		.width = 2,
+	},
+	[VCAP_AF_CPU_COPY_ENA] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 29,
+		.width = 1,
+	},
+	[VCAP_AF_CPU_QUEUE_NUM] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 30,
+		.width = 3,
+	},
+	[VCAP_AF_POLICE_ENA] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 33,
+		.width = 1,
+	},
+	[VCAP_AF_POLICE_REMARK] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 34,
+		.width = 1,
+	},
+	[VCAP_AF_POLICE_IDX] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 35,
+		.width = 6,
+	},
+	[VCAP_AF_ES2_REW_CMD] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 41,
+		.width = 3,
+	},
+	[VCAP_AF_CNT_ID] = {
+		.type = VCAP_FIELD_U32,
+		.offset = 44,
+		.width = 11,
+	},
+	[VCAP_AF_IGNORE_PIPELINE_CTRL] = {
+		.type = VCAP_FIELD_BIT,
+		.offset = 55,
+		.width = 1,
+	},
+};
+
 /* actionfield_set */
 static const struct vcap_set is0_actionfield_set[] = {
 	[VCAP_AFS_CLASSIFICATION] = {
@@ -1825,6 +2852,14 @@ static const struct vcap_set is2_actionfield_set[] = {
 	},
 };
 
+static const struct vcap_set es2_actionfield_set[] = {
+	[VCAP_AFS_BASE_TYPE] = {
+		.type_id = -1,
+		.sw_per_item = 3,
+		.sw_cnt = 4,
+	},
+};
+
 /* actionfield_set map */
 static const struct vcap_field *is0_actionfield_set_map[] = {
 	[VCAP_AFS_CLASSIFICATION] = is0_classification_actionfield,
@@ -1836,6 +2871,10 @@ static const struct vcap_field *is2_actionfield_set_map[] = {
 	[VCAP_AFS_BASE_TYPE] = is2_base_type_actionfield,
 };
 
+static const struct vcap_field *es2_actionfield_set_map[] = {
+	[VCAP_AFS_BASE_TYPE] = es2_base_type_actionfield,
+};
+
 /* actionfield_set map size */
 static int is0_actionfield_set_map_size[] = {
 	[VCAP_AFS_CLASSIFICATION] = ARRAY_SIZE(is0_classification_actionfield),
@@ -1847,6 +2886,10 @@ static int is2_actionfield_set_map_size[] = {
 	[VCAP_AFS_BASE_TYPE] = ARRAY_SIZE(is2_base_type_actionfield),
 };
 
+static int es2_actionfield_set_map_size[] = {
+	[VCAP_AFS_BASE_TYPE] = ARRAY_SIZE(es2_base_type_actionfield),
+};
+
 /* Type Groups */
 static const struct vcap_typegroup is0_x12_keyfield_set_typegroups[] = {
 	{
@@ -2004,6 +3047,52 @@ static const struct vcap_typegroup is2_x1_keyfield_set_typegroups[] = {
 	{}
 };
 
+static const struct vcap_typegroup es2_x12_keyfield_set_typegroups[] = {
+	{
+		.offset = 0,
+		.width = 3,
+		.value = 4,
+	},
+	{
+		.offset = 156,
+		.width = 1,
+		.value = 0,
+	},
+	{
+		.offset = 312,
+		.width = 2,
+		.value = 0,
+	},
+	{
+		.offset = 468,
+		.width = 1,
+		.value = 0,
+	},
+	{}
+};
+
+static const struct vcap_typegroup es2_x6_keyfield_set_typegroups[] = {
+	{
+		.offset = 0,
+		.width = 2,
+		.value = 2,
+	},
+	{
+		.offset = 156,
+		.width = 1,
+		.value = 0,
+	},
+	{}
+};
+
+static const struct vcap_typegroup es2_x3_keyfield_set_typegroups[] = {
+	{}
+};
+
+static const struct vcap_typegroup es2_x1_keyfield_set_typegroups[] = {
+	{}
+};
+
 static const struct vcap_typegroup *is0_keyfield_set_typegroups[] = {
 	[12] = is0_x12_keyfield_set_typegroups,
 	[6] = is0_x6_keyfield_set_typegroups,
@@ -2021,6 +3110,14 @@ static const struct vcap_typegroup *is2_keyfield_set_typegroups[] = {
 	[13] = NULL,
 };
 
+static const struct vcap_typegroup *es2_keyfield_set_typegroups[] = {
+	[12] = es2_x12_keyfield_set_typegroups,
+	[6] = es2_x6_keyfield_set_typegroups,
+	[3] = es2_x3_keyfield_set_typegroups,
+	[1] = es2_x1_keyfield_set_typegroups,
+	[13] = NULL,
+};
+
 static const struct vcap_typegroup is0_x3_actionfield_set_typegroups[] = {
 	{
 		.offset = 0,
@@ -2086,6 +3183,29 @@ static const struct vcap_typegroup is2_x1_actionfield_set_typegroups[] = {
 	{}
 };
 
+static const struct vcap_typegroup es2_x3_actionfield_set_typegroups[] = {
+	{
+		.offset = 0,
+		.width = 2,
+		.value = 2,
+	},
+	{
+		.offset = 21,
+		.width = 1,
+		.value = 0,
+	},
+	{
+		.offset = 42,
+		.width = 1,
+		.value = 0,
+	},
+	{}
+};
+
+static const struct vcap_typegroup es2_x1_actionfield_set_typegroups[] = {
+	{}
+};
+
 static const struct vcap_typegroup *is0_actionfield_set_typegroups[] = {
 	[3] = is0_x3_actionfield_set_typegroups,
 	[2] = is0_x2_actionfield_set_typegroups,
@@ -2099,6 +3219,12 @@ static const struct vcap_typegroup *is2_actionfield_set_typegroups[] = {
 	[13] = NULL,
 };
 
+static const struct vcap_typegroup *es2_actionfield_set_typegroups[] = {
+	[3] = es2_x3_actionfield_set_typegroups,
+	[1] = es2_x1_actionfield_set_typegroups,
+	[13] = NULL,
+};
+
 /* Keyfieldset names */
 static const char * const vcap_keyfield_set_names[] = {
 	[VCAP_KFS_NO_VALUE]                      =  "(None)",
@@ -2156,14 +3282,18 @@ static const char * const vcap_keyfield_names[] = {
 	[VCAP_KF_ARP_PROTO_SPACE_OK_IS]          =  "ARP_PROTO_SPACE_OK_IS",
 	[VCAP_KF_ARP_SENDER_MATCH_IS]            =  "ARP_SENDER_MATCH_IS",
 	[VCAP_KF_ARP_TGT_MATCH_IS]               =  "ARP_TGT_MATCH_IS",
+	[VCAP_KF_COSID_CLS]                      =  "COSID_CLS",
 	[VCAP_KF_ETYPE]                          =  "ETYPE",
 	[VCAP_KF_ETYPE_LEN_IS]                   =  "ETYPE_LEN_IS",
 	[VCAP_KF_HOST_MATCH]                     =  "HOST_MATCH",
+	[VCAP_KF_IF_EGR_PORT_MASK]               =  "IF_EGR_PORT_MASK",
+	[VCAP_KF_IF_EGR_PORT_MASK_RNG]           =  "IF_EGR_PORT_MASK_RNG",
 	[VCAP_KF_IF_IGR_PORT]                    =  "IF_IGR_PORT",
 	[VCAP_KF_IF_IGR_PORT_MASK]               =  "IF_IGR_PORT_MASK",
 	[VCAP_KF_IF_IGR_PORT_MASK_L3]            =  "IF_IGR_PORT_MASK_L3",
 	[VCAP_KF_IF_IGR_PORT_MASK_RNG]           =  "IF_IGR_PORT_MASK_RNG",
 	[VCAP_KF_IF_IGR_PORT_MASK_SEL]           =  "IF_IGR_PORT_MASK_SEL",
+	[VCAP_KF_IF_IGR_PORT_SEL]                =  "IF_IGR_PORT_SEL",
 	[VCAP_KF_IP4_IS]                         =  "IP4_IS",
 	[VCAP_KF_IP_MC_IS]                       =  "IP_MC_IS",
 	[VCAP_KF_IP_PAYLOAD_5TUPLE]              =  "IP_PAYLOAD_5TUPLE",
@@ -2183,6 +3313,7 @@ static const char * const vcap_keyfield_names[] = {
 	[VCAP_KF_L2_SMAC]                        =  "L2_SMAC",
 	[VCAP_KF_L2_SNAP]                        =  "L2_SNAP",
 	[VCAP_KF_L3_DIP_EQ_SIP_IS]               =  "L3_DIP_EQ_SIP_IS",
+	[VCAP_KF_L3_DPL_CLS]                     =  "L3_DPL_CLS",
 	[VCAP_KF_L3_DSCP]                        =  "L3_DSCP",
 	[VCAP_KF_L3_DST_IS]                      =  "L3_DST_IS",
 	[VCAP_KF_L3_FRAGMENT]                    =  "L3_FRAGMENT",
@@ -2236,6 +3367,8 @@ static const char * const vcap_actionfield_names[] = {
 	[VCAP_AF_ACL_ID]                         =  "ACL_ID",
 	[VCAP_AF_CLS_VID_SEL]                    =  "CLS_VID_SEL",
 	[VCAP_AF_CNT_ID]                         =  "CNT_ID",
+	[VCAP_AF_COPY_PORT_NUM]                  =  "COPY_PORT_NUM",
+	[VCAP_AF_COPY_QUEUE_NUM]                 =  "COPY_QUEUE_NUM",
 	[VCAP_AF_CPU_COPY_ENA]                   =  "CPU_COPY_ENA",
 	[VCAP_AF_CPU_QUEUE_NUM]                  =  "CPU_QUEUE_NUM",
 	[VCAP_AF_DEI_ENA]                        =  "DEI_ENA",
@@ -2244,7 +3377,9 @@ static const char * const vcap_actionfield_names[] = {
 	[VCAP_AF_DP_VAL]                         =  "DP_VAL",
 	[VCAP_AF_DSCP_ENA]                       =  "DSCP_ENA",
 	[VCAP_AF_DSCP_VAL]                       =  "DSCP_VAL",
+	[VCAP_AF_ES2_REW_CMD]                    =  "ES2_REW_CMD",
 	[VCAP_AF_FWD_KILL_ENA]                   =  "FWD_KILL_ENA",
+	[VCAP_AF_FWD_MODE]                       =  "FWD_MODE",
 	[VCAP_AF_HIT_ME_ONCE]                    =  "HIT_ME_ONCE",
 	[VCAP_AF_HOST_MATCH]                     =  "HOST_MATCH",
 	[VCAP_AF_IGNORE_PIPELINE_CTRL]           =  "IGNORE_PIPELINE_CTRL",
@@ -2261,6 +3396,7 @@ static const char * const vcap_actionfield_names[] = {
 	[VCAP_AF_MATCH_ID_MASK]                  =  "MATCH_ID_MASK",
 	[VCAP_AF_MIRROR_ENA]                     =  "MIRROR_ENA",
 	[VCAP_AF_MIRROR_PROBE]                   =  "MIRROR_PROBE",
+	[VCAP_AF_MIRROR_PROBE_ID]                =  "MIRROR_PROBE_ID",
 	[VCAP_AF_NXT_IDX]                        =  "NXT_IDX",
 	[VCAP_AF_NXT_IDX_CTRL]                   =  "NXT_IDX_CTRL",
 	[VCAP_AF_PAG_OVERRIDE_MASK]              =  "PAG_OVERRIDE_MASK",
@@ -2271,6 +3407,7 @@ static const char * const vcap_actionfield_names[] = {
 	[VCAP_AF_PIPELINE_PT]                    =  "PIPELINE_PT",
 	[VCAP_AF_POLICE_ENA]                     =  "POLICE_ENA",
 	[VCAP_AF_POLICE_IDX]                     =  "POLICE_IDX",
+	[VCAP_AF_POLICE_REMARK]                  =  "POLICE_REMARK",
 	[VCAP_AF_POLICE_VCAP_ONLY]               =  "POLICE_VCAP_ONLY",
 	[VCAP_AF_PORT_MASK]                      =  "PORT_MASK",
 	[VCAP_AF_QOS_ENA]                        =  "QOS_ENA",
@@ -2325,11 +3462,32 @@ const struct vcap_info sparx5_vcaps[] = {
 		.keyfield_set_typegroups = is2_keyfield_set_typegroups,
 		.actionfield_set_typegroups = is2_actionfield_set_typegroups,
 	},
+	[VCAP_TYPE_ES2] = {
+		.name = "es2",
+		.rows = 1024,
+		.sw_count = 12,
+		.sw_width = 52,
+		.sticky_width = 1,
+		.act_width = 21,
+		.default_cnt = 74,
+		.require_cnt_dis = 0,
+		.version = 1,
+		.keyfield_set = es2_keyfield_set,
+		.keyfield_set_size = ARRAY_SIZE(es2_keyfield_set),
+		.actionfield_set = es2_actionfield_set,
+		.actionfield_set_size = ARRAY_SIZE(es2_actionfield_set),
+		.keyfield_set_map = es2_keyfield_set_map,
+		.keyfield_set_map_size = es2_keyfield_set_map_size,
+		.actionfield_set_map = es2_actionfield_set_map,
+		.actionfield_set_map_size = es2_actionfield_set_map_size,
+		.keyfield_set_typegroups = es2_keyfield_set_typegroups,
+		.actionfield_set_typegroups = es2_actionfield_set_typegroups,
+	},
 };
 
 const struct vcap_statistics sparx5_vcap_stats = {
 	.name = "sparx5",
-	.count = 2,
+	.count = 3,
 	.keyfield_set_names = vcap_keyfield_set_names,
 	.actionfield_set_names = vcap_actionfield_set_names,
 	.keyfield_names = vcap_keyfield_names,
diff --git a/drivers/net/ethernet/microchip/vcap/vcap_ag_api.h b/drivers/net/ethernet/microchip/vcap/vcap_ag_api.h
index 962383f20f1b..9c6766c4b75d 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_ag_api.h
+++ b/drivers/net/ethernet/microchip/vcap/vcap_ag_api.h
@@ -1,10 +1,10 @@
 /* SPDX-License-Identifier: BSD-3-Clause */
-/* Copyright (C) 2022 Microchip Technology Inc. and its subsidiaries.
+/* Copyright (C) 2023 Microchip Technology Inc. and its subsidiaries.
  * Microchip VCAP API
  */
 
-/* This file is autogenerated by cml-utils 2022-12-06 09:49:28 +0100.
- * Commit ID: cd9451f1b9d8cafa58f845de66a6e373658019ef
+/* This file is autogenerated by cml-utils 2023-01-17 16:52:16 +0100.
+ * Commit ID: 229ec79be5df142c1f335a01d0e63232d4feb2ba
  */
 
 #ifndef __VCAP_AG_API__
@@ -276,7 +276,8 @@ enum vcap_keyfield_set {
  *   Select the mode of the Generic Index
  * VCAP_KF_LOOKUP_PAG: W8, sparx5: is2, lan966x: is2
  *   Classified Policy Association Group: chains rules from IS1/CLM to IS2
- * VCAP_KF_MIRROR_ENA: *** No docstring ***
+ * VCAP_KF_MIRROR_PROBE: W2, sparx5: es2
+ *   Identifies frame copies generated as a result of mirroring
  * VCAP_KF_OAM_CCM_CNTS_EQ0: W1, sparx5: is2/es2, lan966x: is2
  *   Dual-ended loss measurement counters in CCM frames are all zero
  * VCAP_KF_OAM_DETECTED: W1, lan966x: is2
@@ -407,7 +408,7 @@ enum vcap_key_field {
 	VCAP_KF_LOOKUP_GEN_IDX,
 	VCAP_KF_LOOKUP_GEN_IDX_SEL,
 	VCAP_KF_LOOKUP_PAG,
-	VCAP_KF_MIRROR_ENA,
+	VCAP_KF_MIRROR_PROBE,
 	VCAP_KF_OAM_CCM_CNTS_EQ0,
 	VCAP_KF_OAM_DETECTED,
 	VCAP_KF_OAM_FLAGS,
diff --git a/drivers/net/ethernet/microchip/vcap/vcap_model_kunit.c b/drivers/net/ethernet/microchip/vcap/vcap_model_kunit.c
index 85a8d8566aa2..6d5d73d00562 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_model_kunit.c
+++ b/drivers/net/ethernet/microchip/vcap/vcap_model_kunit.c
@@ -1709,7 +1709,7 @@ static const struct vcap_field es2_mac_etype_keyfield[] = {
 		.offset = 96,
 		.width = 1,
 	},
-	[VCAP_KF_MIRROR_ENA] = {
+	[VCAP_KF_MIRROR_PROBE] = {
 		.type = VCAP_FIELD_U32,
 		.offset = 97,
 		.width = 2,
@@ -1847,7 +1847,7 @@ static const struct vcap_field es2_arp_keyfield[] = {
 		.offset = 95,
 		.width = 1,
 	},
-	[VCAP_KF_MIRROR_ENA] = {
+	[VCAP_KF_MIRROR_PROBE] = {
 		.type = VCAP_FIELD_U32,
 		.offset = 96,
 		.width = 2,
@@ -2010,7 +2010,7 @@ static const struct vcap_field es2_ip4_tcp_udp_keyfield[] = {
 		.offset = 96,
 		.width = 1,
 	},
-	[VCAP_KF_MIRROR_ENA] = {
+	[VCAP_KF_MIRROR_PROBE] = {
 		.type = VCAP_FIELD_U32,
 		.offset = 97,
 		.width = 2,
@@ -2223,7 +2223,7 @@ static const struct vcap_field es2_ip4_other_keyfield[] = {
 		.offset = 96,
 		.width = 1,
 	},
-	[VCAP_KF_MIRROR_ENA] = {
+	[VCAP_KF_MIRROR_PROBE] = {
 		.type = VCAP_FIELD_U32,
 		.offset = 97,
 		.width = 2,
@@ -2376,7 +2376,7 @@ static const struct vcap_field es2_ip_7tuple_keyfield[] = {
 		.offset = 93,
 		.width = 1,
 	},
-	[VCAP_KF_MIRROR_ENA] = {
+	[VCAP_KF_MIRROR_PROBE] = {
 		.type = VCAP_FIELD_U32,
 		.offset = 94,
 		.width = 2,
@@ -2569,7 +2569,7 @@ static const struct vcap_field es2_ip4_vid_keyfield[] = {
 		.offset = 48,
 		.width = 1,
 	},
-	[VCAP_KF_MIRROR_ENA] = {
+	[VCAP_KF_MIRROR_PROBE] = {
 		.type = VCAP_FIELD_U32,
 		.offset = 49,
 		.width = 2,
@@ -3847,7 +3847,7 @@ static const char * const vcap_keyfield_names[] = {
 	[VCAP_KF_LOOKUP_GEN_IDX]                 =  "LOOKUP_GEN_IDX",
 	[VCAP_KF_LOOKUP_GEN_IDX_SEL]             =  "LOOKUP_GEN_IDX_SEL",
 	[VCAP_KF_LOOKUP_PAG]                     =  "LOOKUP_PAG",
-	[VCAP_KF_MIRROR_ENA]                     =  "MIRROR_ENA",
+	[VCAP_KF_MIRROR_PROBE]                   =  "MIRROR_PROBE",
 	[VCAP_KF_OAM_CCM_CNTS_EQ0]               =  "OAM_CCM_CNTS_EQ0",
 	[VCAP_KF_OAM_DETECTED]                   =  "OAM_DETECTED",
 	[VCAP_KF_OAM_FLAGS]                      =  "OAM_FLAGS",
-- 
2.39.1

