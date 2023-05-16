Return-Path: <netdev+bounces-3112-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A544705871
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 22:14:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 51B411C20B14
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 20:14:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3786A271E8;
	Tue, 16 May 2023 20:14:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2300A271E6
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 20:14:22 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76E9F3A9D;
	Tue, 16 May 2023 13:14:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1684268060; x=1715804060;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=69Dlfl7230M9A59HAhr8bAJJvfZf/FBMqo1z6Z4ZdWc=;
  b=VYJOWDKr34x22Xzwd3iuhKX7IwHsopti+4Cq8l40lz2EhR2gQKpyVZmn
   bcbBDzXRWaMtEDJ2CacixTVYXrr0cLmdUlXa91zUCj/5GMDWdy4j6ZGdi
   qbgu1306MrmWT1jpFjKanaVXltNX7s1ZC+JkSJZJbVup0ii8xcfi0qVbo
   t6FrUgQNdiQtSTN6muf0ZR8DzqbtuDoGpPaTF0B5PcqSNbat9IibvaHh7
   0Hpt5wfbxDcdBqRCZQ/zhoXQOC1+yZ8DxFTXxd89lWAjTrt11ta/H8MZf
   KCkIHyM4acUDUPOiVkxRlG3nRtS/7/VmsXiO2LygegyNpbepY0gFoOzTO
   A==;
X-IronPort-AV: E=Sophos;i="5.99,278,1677567600"; 
   d="scan'208";a="225639957"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 16 May 2023 13:14:19 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 16 May 2023 13:14:18 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2507.21 via Frontend Transport; Tue, 16 May 2023 13:14:16 -0700
From: Horatiu Vultur <horatiu.vultur@microchip.com>
To: <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC: <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
	<pabeni@redhat.com>, <UNGLinuxDriver@microchip.com>,
	<daniel.machon@microchip.com>, <piotr.raczynski@intel.com>, Horatiu Vultur
	<horatiu.vultur@microchip.com>
Subject: [PATCH net-next v2 1/7] net: lan966x: Add registers to configure PCP, DEI, DSCP
Date: Tue, 16 May 2023 22:14:02 +0200
Message-ID: <20230516201408.3172428-2-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20230516201408.3172428-1-horatiu.vultur@microchip.com>
References: <20230516201408.3172428-1-horatiu.vultur@microchip.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,
	UPPERCASE_50_75,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Add the registers that are needed to configure the PCP, DEI and DSCP
of the switch both at ingress and also at egress.

Reviewed-by: Daniel Machon <daniel.machon@microchip.com>
Reviewed-by: Piotr Raczynski <piotr.raczynski@intel.com>
Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 .../ethernet/microchip/lan966x/lan966x_regs.h | 132 ++++++++++++++++++
 1 file changed, 132 insertions(+)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_regs.h b/drivers/net/ethernet/microchip/lan966x/lan966x_regs.h
index 2220391802766..4b553927d2e0e 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_regs.h
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_regs.h
@@ -283,6 +283,18 @@ enum lan966x_target {
 #define ANA_VLAN_CFG_VLAN_POP_CNT_GET(x)\
 	FIELD_GET(ANA_VLAN_CFG_VLAN_POP_CNT, x)
 
+#define ANA_VLAN_CFG_VLAN_PCP                    GENMASK(15, 13)
+#define ANA_VLAN_CFG_VLAN_PCP_SET(x)\
+	FIELD_PREP(ANA_VLAN_CFG_VLAN_PCP, x)
+#define ANA_VLAN_CFG_VLAN_PCP_GET(x)\
+	FIELD_GET(ANA_VLAN_CFG_VLAN_PCP, x)
+
+#define ANA_VLAN_CFG_VLAN_DEI                    BIT(12)
+#define ANA_VLAN_CFG_VLAN_DEI_SET(x)\
+	FIELD_PREP(ANA_VLAN_CFG_VLAN_DEI, x)
+#define ANA_VLAN_CFG_VLAN_DEI_GET(x)\
+	FIELD_GET(ANA_VLAN_CFG_VLAN_DEI, x)
+
 #define ANA_VLAN_CFG_VLAN_VID                    GENMASK(11, 0)
 #define ANA_VLAN_CFG_VLAN_VID_SET(x)\
 	FIELD_PREP(ANA_VLAN_CFG_VLAN_VID, x)
@@ -316,6 +328,39 @@ enum lan966x_target {
 #define ANA_DROP_CFG_DROP_MC_SMAC_ENA_GET(x)\
 	FIELD_GET(ANA_DROP_CFG_DROP_MC_SMAC_ENA, x)
 
+/*      ANA:PORT:QOS_CFG */
+#define ANA_QOS_CFG(g)            __REG(TARGET_ANA, 0, 1, 28672, g, 9, 128, 8, 0, 1, 4)
+
+#define ANA_QOS_CFG_DP_DEFAULT_VAL               BIT(8)
+#define ANA_QOS_CFG_DP_DEFAULT_VAL_SET(x)\
+	FIELD_PREP(ANA_QOS_CFG_DP_DEFAULT_VAL, x)
+#define ANA_QOS_CFG_DP_DEFAULT_VAL_GET(x)\
+	FIELD_GET(ANA_QOS_CFG_DP_DEFAULT_VAL, x)
+
+#define ANA_QOS_CFG_QOS_DEFAULT_VAL              GENMASK(7, 5)
+#define ANA_QOS_CFG_QOS_DEFAULT_VAL_SET(x)\
+	FIELD_PREP(ANA_QOS_CFG_QOS_DEFAULT_VAL, x)
+#define ANA_QOS_CFG_QOS_DEFAULT_VAL_GET(x)\
+	FIELD_GET(ANA_QOS_CFG_QOS_DEFAULT_VAL, x)
+
+#define ANA_QOS_CFG_QOS_DSCP_ENA                 BIT(4)
+#define ANA_QOS_CFG_QOS_DSCP_ENA_SET(x)\
+	FIELD_PREP(ANA_QOS_CFG_QOS_DSCP_ENA, x)
+#define ANA_QOS_CFG_QOS_DSCP_ENA_GET(x)\
+	FIELD_GET(ANA_QOS_CFG_QOS_DSCP_ENA, x)
+
+#define ANA_QOS_CFG_QOS_PCP_ENA                  BIT(3)
+#define ANA_QOS_CFG_QOS_PCP_ENA_SET(x)\
+	FIELD_PREP(ANA_QOS_CFG_QOS_PCP_ENA, x)
+#define ANA_QOS_CFG_QOS_PCP_ENA_GET(x)\
+	FIELD_GET(ANA_QOS_CFG_QOS_PCP_ENA, x)
+
+#define ANA_QOS_CFG_DSCP_REWR_CFG                GENMASK(1, 0)
+#define ANA_QOS_CFG_DSCP_REWR_CFG_SET(x)\
+	FIELD_PREP(ANA_QOS_CFG_DSCP_REWR_CFG, x)
+#define ANA_QOS_CFG_DSCP_REWR_CFG_GET(x)\
+	FIELD_GET(ANA_QOS_CFG_DSCP_REWR_CFG, x)
+
 /*      ANA:PORT:VCAP_CFG */
 #define ANA_VCAP_CFG(g)           __REG(TARGET_ANA, 0, 1, 28672, g, 9, 128, 12, 0, 1, 4)
 
@@ -415,6 +460,21 @@ enum lan966x_target {
 #define ANA_VCAP_S2_CFG_OAM_DIS_GET(x)\
 	FIELD_GET(ANA_VCAP_S2_CFG_OAM_DIS, x)
 
+/*      ANA:PORT:QOS_PCP_DEI_MAP_CFG */
+#define ANA_PCP_DEI_CFG(g, r)     __REG(TARGET_ANA, 0, 1, 28672, g, 9, 128, 32, r, 16, 4)
+
+#define ANA_PCP_DEI_CFG_DP_PCP_DEI_VAL           BIT(3)
+#define ANA_PCP_DEI_CFG_DP_PCP_DEI_VAL_SET(x)\
+	FIELD_PREP(ANA_PCP_DEI_CFG_DP_PCP_DEI_VAL, x)
+#define ANA_PCP_DEI_CFG_DP_PCP_DEI_VAL_GET(x)\
+	FIELD_GET(ANA_PCP_DEI_CFG_DP_PCP_DEI_VAL, x)
+
+#define ANA_PCP_DEI_CFG_QOS_PCP_DEI_VAL          GENMASK(2, 0)
+#define ANA_PCP_DEI_CFG_QOS_PCP_DEI_VAL_SET(x)\
+	FIELD_PREP(ANA_PCP_DEI_CFG_QOS_PCP_DEI_VAL, x)
+#define ANA_PCP_DEI_CFG_QOS_PCP_DEI_VAL_GET(x)\
+	FIELD_GET(ANA_PCP_DEI_CFG_QOS_PCP_DEI_VAL, x)
+
 /*      ANA:PORT:CPU_FWD_CFG */
 #define ANA_CPU_FWD_CFG(g)        __REG(TARGET_ANA, 0, 1, 28672, g, 9, 128, 96, 0, 1, 4)
 
@@ -478,6 +538,15 @@ enum lan966x_target {
 #define ANA_PORT_CFG_PORTID_VAL_GET(x)\
 	FIELD_GET(ANA_PORT_CFG_PORTID_VAL, x)
 
+/*      ANA:COMMON:DSCP_REWR_CFG */
+#define ANA_DSCP_REWR_CFG(r)      __REG(TARGET_ANA, 0, 1, 31232, 0, 1, 552, 332, r, 16, 4)
+
+#define ANA_DSCP_REWR_CFG_DSCP_QOS_REWR_VAL      GENMASK(5, 0)
+#define ANA_DSCP_REWR_CFG_DSCP_QOS_REWR_VAL_SET(x)\
+	FIELD_PREP(ANA_DSCP_REWR_CFG_DSCP_QOS_REWR_VAL, x)
+#define ANA_DSCP_REWR_CFG_DSCP_QOS_REWR_VAL_GET(x)\
+	FIELD_GET(ANA_DSCP_REWR_CFG_DSCP_QOS_REWR_VAL, x)
+
 /*      ANA:PORT:POL_CFG */
 #define ANA_POL_CFG(g)            __REG(TARGET_ANA, 0, 1, 28672, g, 9, 128, 116, 0, 1, 4)
 
@@ -547,6 +616,33 @@ enum lan966x_target {
 #define ANA_AGGR_CFG_AC_IP4_TCPUDP_ENA_GET(x)\
 	FIELD_GET(ANA_AGGR_CFG_AC_IP4_TCPUDP_ENA, x)
 
+/*      ANA:COMMON:DSCP_CFG */
+#define ANA_DSCP_CFG(r)           __REG(TARGET_ANA, 0, 1, 31232, 0, 1, 552, 76, r, 64, 4)
+
+#define ANA_DSCP_CFG_DP_DSCP_VAL                 BIT(11)
+#define ANA_DSCP_CFG_DP_DSCP_VAL_SET(x)\
+	FIELD_PREP(ANA_DSCP_CFG_DP_DSCP_VAL, x)
+#define ANA_DSCP_CFG_DP_DSCP_VAL_GET(x)\
+	FIELD_GET(ANA_DSCP_CFG_DP_DSCP_VAL, x)
+
+#define ANA_DSCP_CFG_QOS_DSCP_VAL                GENMASK(10, 8)
+#define ANA_DSCP_CFG_QOS_DSCP_VAL_SET(x)\
+	FIELD_PREP(ANA_DSCP_CFG_QOS_DSCP_VAL, x)
+#define ANA_DSCP_CFG_QOS_DSCP_VAL_GET(x)\
+	FIELD_GET(ANA_DSCP_CFG_QOS_DSCP_VAL, x)
+
+#define ANA_DSCP_CFG_DSCP_TRUST_ENA              BIT(1)
+#define ANA_DSCP_CFG_DSCP_TRUST_ENA_SET(x)\
+	FIELD_PREP(ANA_DSCP_CFG_DSCP_TRUST_ENA, x)
+#define ANA_DSCP_CFG_DSCP_TRUST_ENA_GET(x)\
+	FIELD_GET(ANA_DSCP_CFG_DSCP_TRUST_ENA, x)
+
+#define ANA_DSCP_CFG_DSCP_REWR_ENA               BIT(0)
+#define ANA_DSCP_CFG_DSCP_REWR_ENA_SET(x)\
+	FIELD_PREP(ANA_DSCP_CFG_DSCP_REWR_ENA, x)
+#define ANA_DSCP_CFG_DSCP_REWR_ENA_GET(x)\
+	FIELD_GET(ANA_DSCP_CFG_DSCP_REWR_ENA, x)
+
 /*      ANA:POL:POL_PIR_CFG */
 #define ANA_POL_PIR_CFG(g)        __REG(TARGET_ANA, 0, 1, 16384, g, 345, 32, 0, 0, 1, 4)
 
@@ -1468,6 +1564,18 @@ enum lan966x_target {
 #define REW_TAG_CFG_TAG_TPID_CFG_GET(x)\
 	FIELD_GET(REW_TAG_CFG_TAG_TPID_CFG, x)
 
+#define REW_TAG_CFG_TAG_PCP_CFG                  GENMASK(3, 2)
+#define REW_TAG_CFG_TAG_PCP_CFG_SET(x)\
+	FIELD_PREP(REW_TAG_CFG_TAG_PCP_CFG, x)
+#define REW_TAG_CFG_TAG_PCP_CFG_GET(x)\
+	FIELD_GET(REW_TAG_CFG_TAG_PCP_CFG, x)
+
+#define REW_TAG_CFG_TAG_DEI_CFG                  GENMASK(1, 0)
+#define REW_TAG_CFG_TAG_DEI_CFG_SET(x)\
+	FIELD_PREP(REW_TAG_CFG_TAG_DEI_CFG, x)
+#define REW_TAG_CFG_TAG_DEI_CFG_GET(x)\
+	FIELD_GET(REW_TAG_CFG_TAG_DEI_CFG, x)
+
 /*      REW:PORT:PORT_CFG */
 #define REW_PORT_CFG(g)           __REG(TARGET_REW, 0, 1, 0, g, 10, 128, 8, 0, 1, 4)
 
@@ -1483,6 +1591,30 @@ enum lan966x_target {
 #define REW_PORT_CFG_NO_REWRITE_GET(x)\
 	FIELD_GET(REW_PORT_CFG_NO_REWRITE, x)
 
+/*      REW:PORT:DSCP_CFG */
+#define REW_DSCP_CFG(g)           __REG(TARGET_REW, 0, 1, 0, g, 10, 128, 12, 0, 1, 4)
+
+#define REW_DSCP_CFG_DSCP_REWR_CFG               GENMASK(1, 0)
+#define REW_DSCP_CFG_DSCP_REWR_CFG_SET(x)\
+	FIELD_PREP(REW_DSCP_CFG_DSCP_REWR_CFG, x)
+#define REW_DSCP_CFG_DSCP_REWR_CFG_GET(x)\
+	FIELD_GET(REW_DSCP_CFG_DSCP_REWR_CFG, x)
+
+/*      REW:PORT:PCP_DEI_QOS_MAP_CFG */
+#define REW_PCP_DEI_CFG(g, r)     __REG(TARGET_REW, 0, 1, 0, g, 10, 128, 16, r, 16, 4)
+
+#define REW_PCP_DEI_CFG_DEI_QOS_VAL              BIT(3)
+#define REW_PCP_DEI_CFG_DEI_QOS_VAL_SET(x)\
+	FIELD_PREP(REW_PCP_DEI_CFG_DEI_QOS_VAL, x)
+#define REW_PCP_DEI_CFG_DEI_QOS_VAL_GET(x)\
+	FIELD_GET(REW_PCP_DEI_CFG_DEI_QOS_VAL, x)
+
+#define REW_PCP_DEI_CFG_PCP_QOS_VAL              GENMASK(2, 0)
+#define REW_PCP_DEI_CFG_PCP_QOS_VAL_SET(x)\
+	FIELD_PREP(REW_PCP_DEI_CFG_PCP_QOS_VAL, x)
+#define REW_PCP_DEI_CFG_PCP_QOS_VAL_GET(x)\
+	FIELD_GET(REW_PCP_DEI_CFG_PCP_QOS_VAL, x)
+
 /*      REW:COMMON:STAT_CFG */
 #define REW_STAT_CFG              __REG(TARGET_REW, 0, 1, 3072, 0, 1, 528, 520, 0, 1, 4)
 
-- 
2.38.0


