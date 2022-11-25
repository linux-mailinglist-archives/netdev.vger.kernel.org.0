Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3493763869F
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 10:49:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229877AbiKYJtI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 04:49:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230029AbiKYJsA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 04:48:00 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 064763F074;
        Fri, 25 Nov 2022 01:46:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1669369583; x=1700905583;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0yb8KDhtrwZLN4fcLDMjKesaqLK5244W/5XgjSefTec=;
  b=oImcYSRD8qmf4v9AqDsvxg1tc2LGzUjPRV5hURXKgmJsZq7Yq0KUsKwD
   JOjZ4jeCFc+ius14ObCJtbdYhevRliMU2YvgFcQWy7mVWzf8vh9FICSTv
   6iWj/il/nJvpqdbty1zPPsBPz9Gl+b43mc12WYYPG7HjRFVrLYzTaCNRa
   mbRQBc9KeqqIMdRheLfxoLmAs2WahodoR1WFJstsrpM/aZzsUbRr19nkG
   CCPjOkNmDjASz3ZbIngD2/cSVVZEZy2gBJHXygMNGcAnHSalDI/fhSbpB
   EjOFZWk9vfzvTDTiWDeJaYPqhuNL39GV4TMRIjobGuHw2/imNK/piQoEt
   g==;
X-IronPort-AV: E=Sophos;i="5.96,193,1665471600"; 
   d="scan'208";a="125074998"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 25 Nov 2022 02:46:21 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Fri, 25 Nov 2022 02:46:19 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Fri, 25 Nov 2022 02:46:17 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <lars.povlsen@microchip.com>,
        <Steen.Hegelund@microchip.com>, <daniel.machon@microchip.com>,
        <UNGLinuxDriver@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next 5/9] net: lan966x: add vcap registers
Date:   Fri, 25 Nov 2022 10:50:06 +0100
Message-ID: <20221125095010.124458-6-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221125095010.124458-1-horatiu.vultur@microchip.com>
References: <20221125095010.124458-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,UPPERCASE_50_75 autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add registers used to access vcap controller.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 .../ethernet/microchip/lan966x/lan966x_main.c |   3 +
 .../ethernet/microchip/lan966x/lan966x_regs.h | 196 ++++++++++++++++++
 2 files changed, 199 insertions(+)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
index 546f3ad9f2951..6da60ba4a3262 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
@@ -47,6 +47,9 @@ static const struct lan966x_main_io_resource lan966x_main_iomap[] =  {
 	{ TARGET_PTP,                    0xc000, 1 }, /* 0xe200c000 */
 	{ TARGET_CHIP_TOP,              0x10000, 1 }, /* 0xe2010000 */
 	{ TARGET_REW,                   0x14000, 1 }, /* 0xe2014000 */
+	{ TARGET_VCAP,                  0x18000, 1 }, /* 0xe2018000 */
+	{ TARGET_VCAP + 1,              0x20000, 1 }, /* 0xe2020000 */
+	{ TARGET_VCAP + 2,              0x24000, 1 }, /* 0xe2024000 */
 	{ TARGET_SYS,                   0x28000, 1 }, /* 0xe2028000 */
 	{ TARGET_DEV,                   0x34000, 1 }, /* 0xe2034000 */
 	{ TARGET_DEV +  1,              0x38000, 1 }, /* 0xe2038000 */
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_regs.h b/drivers/net/ethernet/microchip/lan966x/lan966x_regs.h
index fb5087fef22e1..9767b5a1c9580 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_regs.h
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_regs.h
@@ -25,6 +25,7 @@ enum lan966x_target {
 	TARGET_QSYS = 46,
 	TARGET_REW = 47,
 	TARGET_SYS = 52,
+	TARGET_VCAP = 61,
 	NUM_TARGETS = 66
 };
 
@@ -315,6 +316,69 @@ enum lan966x_target {
 #define ANA_DROP_CFG_DROP_MC_SMAC_ENA_GET(x)\
 	FIELD_GET(ANA_DROP_CFG_DROP_MC_SMAC_ENA, x)
 
+/*      ANA:PORT:VCAP_S2_CFG */
+#define ANA_VCAP_S2_CFG(g)        __REG(TARGET_ANA, 0, 1, 28672, g, 9, 128, 28, 0, 1, 4)
+
+#define ANA_VCAP_S2_CFG_ISDX_ENA                 GENMASK(20, 19)
+#define ANA_VCAP_S2_CFG_ISDX_ENA_SET(x)\
+	FIELD_PREP(ANA_VCAP_S2_CFG_ISDX_ENA, x)
+#define ANA_VCAP_S2_CFG_ISDX_ENA_GET(x)\
+	FIELD_GET(ANA_VCAP_S2_CFG_ISDX_ENA, x)
+
+#define ANA_VCAP_S2_CFG_UDP_PAYLOAD_ENA          GENMASK(18, 17)
+#define ANA_VCAP_S2_CFG_UDP_PAYLOAD_ENA_SET(x)\
+	FIELD_PREP(ANA_VCAP_S2_CFG_UDP_PAYLOAD_ENA, x)
+#define ANA_VCAP_S2_CFG_UDP_PAYLOAD_ENA_GET(x)\
+	FIELD_GET(ANA_VCAP_S2_CFG_UDP_PAYLOAD_ENA, x)
+
+#define ANA_VCAP_S2_CFG_ETYPE_PAYLOAD_ENA        GENMASK(16, 15)
+#define ANA_VCAP_S2_CFG_ETYPE_PAYLOAD_ENA_SET(x)\
+	FIELD_PREP(ANA_VCAP_S2_CFG_ETYPE_PAYLOAD_ENA, x)
+#define ANA_VCAP_S2_CFG_ETYPE_PAYLOAD_ENA_GET(x)\
+	FIELD_GET(ANA_VCAP_S2_CFG_ETYPE_PAYLOAD_ENA, x)
+
+#define ANA_VCAP_S2_CFG_ENA                      BIT(14)
+#define ANA_VCAP_S2_CFG_ENA_SET(x)\
+	FIELD_PREP(ANA_VCAP_S2_CFG_ENA, x)
+#define ANA_VCAP_S2_CFG_ENA_GET(x)\
+	FIELD_GET(ANA_VCAP_S2_CFG_ENA, x)
+
+#define ANA_VCAP_S2_CFG_SNAP_DIS                 GENMASK(13, 12)
+#define ANA_VCAP_S2_CFG_SNAP_DIS_SET(x)\
+	FIELD_PREP(ANA_VCAP_S2_CFG_SNAP_DIS, x)
+#define ANA_VCAP_S2_CFG_SNAP_DIS_GET(x)\
+	FIELD_GET(ANA_VCAP_S2_CFG_SNAP_DIS, x)
+
+#define ANA_VCAP_S2_CFG_ARP_DIS                  GENMASK(11, 10)
+#define ANA_VCAP_S2_CFG_ARP_DIS_SET(x)\
+	FIELD_PREP(ANA_VCAP_S2_CFG_ARP_DIS, x)
+#define ANA_VCAP_S2_CFG_ARP_DIS_GET(x)\
+	FIELD_GET(ANA_VCAP_S2_CFG_ARP_DIS, x)
+
+#define ANA_VCAP_S2_CFG_IP_TCPUDP_DIS            GENMASK(9, 8)
+#define ANA_VCAP_S2_CFG_IP_TCPUDP_DIS_SET(x)\
+	FIELD_PREP(ANA_VCAP_S2_CFG_IP_TCPUDP_DIS, x)
+#define ANA_VCAP_S2_CFG_IP_TCPUDP_DIS_GET(x)\
+	FIELD_GET(ANA_VCAP_S2_CFG_IP_TCPUDP_DIS, x)
+
+#define ANA_VCAP_S2_CFG_IP_OTHER_DIS             GENMASK(7, 6)
+#define ANA_VCAP_S2_CFG_IP_OTHER_DIS_SET(x)\
+	FIELD_PREP(ANA_VCAP_S2_CFG_IP_OTHER_DIS, x)
+#define ANA_VCAP_S2_CFG_IP_OTHER_DIS_GET(x)\
+	FIELD_GET(ANA_VCAP_S2_CFG_IP_OTHER_DIS, x)
+
+#define ANA_VCAP_S2_CFG_IP6_CFG                  GENMASK(5, 2)
+#define ANA_VCAP_S2_CFG_IP6_CFG_SET(x)\
+	FIELD_PREP(ANA_VCAP_S2_CFG_IP6_CFG, x)
+#define ANA_VCAP_S2_CFG_IP6_CFG_GET(x)\
+	FIELD_GET(ANA_VCAP_S2_CFG_IP6_CFG, x)
+
+#define ANA_VCAP_S2_CFG_OAM_DIS                  GENMASK(1, 0)
+#define ANA_VCAP_S2_CFG_OAM_DIS_SET(x)\
+	FIELD_PREP(ANA_VCAP_S2_CFG_OAM_DIS, x)
+#define ANA_VCAP_S2_CFG_OAM_DIS_GET(x)\
+	FIELD_GET(ANA_VCAP_S2_CFG_OAM_DIS, x)
+
 /*      ANA:PORT:CPU_FWD_CFG */
 #define ANA_CPU_FWD_CFG(g)        __REG(TARGET_ANA, 0, 1, 28672, g, 9, 128, 96, 0, 1, 4)
 
@@ -1506,4 +1570,136 @@ enum lan966x_target {
 #define SYS_RAM_INIT_RAM_INIT_GET(x)\
 	FIELD_GET(SYS_RAM_INIT_RAM_INIT, x)
 
+/*      VCAP:VCAP_CORE_CFG:VCAP_UPDATE_CTRL */
+#define VCAP_UPDATE_CTRL(t)       __REG(TARGET_VCAP, t, 3, 0, 0, 1, 8, 0, 0, 1, 4)
+
+#define VCAP_UPDATE_CTRL_UPDATE_CMD              GENMASK(24, 22)
+#define VCAP_UPDATE_CTRL_UPDATE_CMD_SET(x)\
+	FIELD_PREP(VCAP_UPDATE_CTRL_UPDATE_CMD, x)
+#define VCAP_UPDATE_CTRL_UPDATE_CMD_GET(x)\
+	FIELD_GET(VCAP_UPDATE_CTRL_UPDATE_CMD, x)
+
+#define VCAP_UPDATE_CTRL_UPDATE_ENTRY_DIS        BIT(21)
+#define VCAP_UPDATE_CTRL_UPDATE_ENTRY_DIS_SET(x)\
+	FIELD_PREP(VCAP_UPDATE_CTRL_UPDATE_ENTRY_DIS, x)
+#define VCAP_UPDATE_CTRL_UPDATE_ENTRY_DIS_GET(x)\
+	FIELD_GET(VCAP_UPDATE_CTRL_UPDATE_ENTRY_DIS, x)
+
+#define VCAP_UPDATE_CTRL_UPDATE_ACTION_DIS       BIT(20)
+#define VCAP_UPDATE_CTRL_UPDATE_ACTION_DIS_SET(x)\
+	FIELD_PREP(VCAP_UPDATE_CTRL_UPDATE_ACTION_DIS, x)
+#define VCAP_UPDATE_CTRL_UPDATE_ACTION_DIS_GET(x)\
+	FIELD_GET(VCAP_UPDATE_CTRL_UPDATE_ACTION_DIS, x)
+
+#define VCAP_UPDATE_CTRL_UPDATE_CNT_DIS          BIT(19)
+#define VCAP_UPDATE_CTRL_UPDATE_CNT_DIS_SET(x)\
+	FIELD_PREP(VCAP_UPDATE_CTRL_UPDATE_CNT_DIS, x)
+#define VCAP_UPDATE_CTRL_UPDATE_CNT_DIS_GET(x)\
+	FIELD_GET(VCAP_UPDATE_CTRL_UPDATE_CNT_DIS, x)
+
+#define VCAP_UPDATE_CTRL_UPDATE_ADDR             GENMASK(18, 3)
+#define VCAP_UPDATE_CTRL_UPDATE_ADDR_SET(x)\
+	FIELD_PREP(VCAP_UPDATE_CTRL_UPDATE_ADDR, x)
+#define VCAP_UPDATE_CTRL_UPDATE_ADDR_GET(x)\
+	FIELD_GET(VCAP_UPDATE_CTRL_UPDATE_ADDR, x)
+
+#define VCAP_UPDATE_CTRL_UPDATE_SHOT             BIT(2)
+#define VCAP_UPDATE_CTRL_UPDATE_SHOT_SET(x)\
+	FIELD_PREP(VCAP_UPDATE_CTRL_UPDATE_SHOT, x)
+#define VCAP_UPDATE_CTRL_UPDATE_SHOT_GET(x)\
+	FIELD_GET(VCAP_UPDATE_CTRL_UPDATE_SHOT, x)
+
+#define VCAP_UPDATE_CTRL_CLEAR_CACHE             BIT(1)
+#define VCAP_UPDATE_CTRL_CLEAR_CACHE_SET(x)\
+	FIELD_PREP(VCAP_UPDATE_CTRL_CLEAR_CACHE, x)
+#define VCAP_UPDATE_CTRL_CLEAR_CACHE_GET(x)\
+	FIELD_GET(VCAP_UPDATE_CTRL_CLEAR_CACHE, x)
+
+#define VCAP_UPDATE_CTRL_MV_TRAFFIC_IGN          BIT(0)
+#define VCAP_UPDATE_CTRL_MV_TRAFFIC_IGN_SET(x)\
+	FIELD_PREP(VCAP_UPDATE_CTRL_MV_TRAFFIC_IGN, x)
+#define VCAP_UPDATE_CTRL_MV_TRAFFIC_IGN_GET(x)\
+	FIELD_GET(VCAP_UPDATE_CTRL_MV_TRAFFIC_IGN, x)
+
+/*      VCAP:VCAP_CORE_CFG:VCAP_MV_CFG */
+#define VCAP_MV_CFG(t)            __REG(TARGET_VCAP, t, 3, 0, 0, 1, 8, 4, 0, 1, 4)
+
+#define VCAP_MV_CFG_MV_NUM_POS                   GENMASK(31, 16)
+#define VCAP_MV_CFG_MV_NUM_POS_SET(x)\
+	FIELD_PREP(VCAP_MV_CFG_MV_NUM_POS, x)
+#define VCAP_MV_CFG_MV_NUM_POS_GET(x)\
+	FIELD_GET(VCAP_MV_CFG_MV_NUM_POS, x)
+
+#define VCAP_MV_CFG_MV_SIZE                      GENMASK(15, 0)
+#define VCAP_MV_CFG_MV_SIZE_SET(x)\
+	FIELD_PREP(VCAP_MV_CFG_MV_SIZE, x)
+#define VCAP_MV_CFG_MV_SIZE_GET(x)\
+	FIELD_GET(VCAP_MV_CFG_MV_SIZE, x)
+
+/*      VCAP:VCAP_CORE_CACHE:VCAP_ENTRY_DAT */
+#define VCAP_ENTRY_DAT(t, r)      __REG(TARGET_VCAP, t, 3, 8, 0, 1, 904, 0, r, 64, 4)
+
+/*      VCAP:VCAP_CORE_CACHE:VCAP_MASK_DAT */
+#define VCAP_MASK_DAT(t, r)       __REG(TARGET_VCAP, t, 3, 8, 0, 1, 904, 256, r, 64, 4)
+
+/*      VCAP:VCAP_CORE_CACHE:VCAP_ACTION_DAT */
+#define VCAP_ACTION_DAT(t, r)     __REG(TARGET_VCAP, t, 3, 8, 0, 1, 904, 512, r, 64, 4)
+
+/*      VCAP:VCAP_CORE_CACHE:VCAP_CNT_DAT */
+#define VCAP_CNT_DAT(t, r)        __REG(TARGET_VCAP, t, 3, 8, 0, 1, 904, 768, r, 32, 4)
+
+/*      VCAP:VCAP_CORE_CACHE:VCAP_CNT_FW_DAT */
+#define VCAP_CNT_FW_DAT(t)        __REG(TARGET_VCAP, t, 3, 8, 0, 1, 904, 896, 0, 1, 4)
+
+/*      VCAP:VCAP_CORE_CACHE:VCAP_TG_DAT */
+#define VCAP_TG_DAT(t)            __REG(TARGET_VCAP, t, 3, 8, 0, 1, 904, 900, 0, 1, 4)
+
+/*      VCAP:VCAP_CORE_MAP:VCAP_CORE_IDX */
+#define VCAP_CORE_IDX(t)          __REG(TARGET_VCAP, t, 3, 912, 0, 1, 8, 0, 0, 1, 4)
+
+#define VCAP_CORE_IDX_CORE_IDX                   GENMASK(3, 0)
+#define VCAP_CORE_IDX_CORE_IDX_SET(x)\
+	FIELD_PREP(VCAP_CORE_IDX_CORE_IDX, x)
+#define VCAP_CORE_IDX_CORE_IDX_GET(x)\
+	FIELD_GET(VCAP_CORE_IDX_CORE_IDX, x)
+
+/*      VCAP:VCAP_CORE_MAP:VCAP_CORE_MAP */
+#define VCAP_CORE_MAP(t)          __REG(TARGET_VCAP, t, 3, 912, 0, 1, 8, 4, 0, 1, 4)
+
+#define VCAP_CORE_MAP_CORE_MAP                   GENMASK(2, 0)
+#define VCAP_CORE_MAP_CORE_MAP_SET(x)\
+	FIELD_PREP(VCAP_CORE_MAP_CORE_MAP, x)
+#define VCAP_CORE_MAP_CORE_MAP_GET(x)\
+	FIELD_GET(VCAP_CORE_MAP_CORE_MAP, x)
+
+/*      VCAP:VCAP_CONST:VCAP_VER */
+#define VCAP_VER(t)               __REG(TARGET_VCAP, t, 3, 924, 0, 1, 40, 0, 0, 1, 4)
+
+/*      VCAP:VCAP_CONST:ENTRY_WIDTH */
+#define VCAP_ENTRY_WIDTH(t)       __REG(TARGET_VCAP, t, 3, 924, 0, 1, 40, 4, 0, 1, 4)
+
+/*      VCAP:VCAP_CONST:ENTRY_CNT */
+#define VCAP_ENTRY_CNT(t)         __REG(TARGET_VCAP, t, 3, 924, 0, 1, 40, 8, 0, 1, 4)
+
+/*      VCAP:VCAP_CONST:ENTRY_SWCNT */
+#define VCAP_ENTRY_SWCNT(t)       __REG(TARGET_VCAP, t, 3, 924, 0, 1, 40, 12, 0, 1, 4)
+
+/*      VCAP:VCAP_CONST:ENTRY_TG_WIDTH */
+#define VCAP_ENTRY_TG_WIDTH(t)    __REG(TARGET_VCAP, t, 3, 924, 0, 1, 40, 16, 0, 1, 4)
+
+/*      VCAP:VCAP_CONST:ACTION_DEF_CNT */
+#define VCAP_ACTION_DEF_CNT(t)    __REG(TARGET_VCAP, t, 3, 924, 0, 1, 40, 20, 0, 1, 4)
+
+/*      VCAP:VCAP_CONST:ACTION_WIDTH */
+#define VCAP_ACTION_WIDTH(t)      __REG(TARGET_VCAP, t, 3, 924, 0, 1, 40, 24, 0, 1, 4)
+
+/*      VCAP:VCAP_CONST:CNT_WIDTH */
+#define VCAP_CNT_WIDTH(t)         __REG(TARGET_VCAP, t, 3, 924, 0, 1, 40, 28, 0, 1, 4)
+
+/*      VCAP:VCAP_CONST:CORE_CNT */
+#define VCAP_CORE_CNT(t)          __REG(TARGET_VCAP, t, 3, 924, 0, 1, 40, 32, 0, 1, 4)
+
+/*      VCAP:VCAP_CONST:IF_CNT */
+#define VCAP_IF_CNT(t)            __REG(TARGET_VCAP, t, 3, 924, 0, 1, 40, 36, 0, 1, 4)
+
 #endif /* _LAN966X_REGS_H_ */
-- 
2.38.0

