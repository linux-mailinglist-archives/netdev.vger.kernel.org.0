Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C08DA5BCB22
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 13:54:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229937AbiISLxo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 07:53:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229942AbiISLxb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 07:53:31 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFB602C131;
        Mon, 19 Sep 2022 04:53:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1663588401; x=1695124401;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Yqei1NKyB0Sw81Ri4kU0qsOFjaHWss4ZJx3oJu3FQLs=;
  b=cd7aak/OfpeOF3gr3tT9ta4Bx6CvD+d1xm+qAvWcUmsh4OWIjpDgQKLm
   yzUFX1dx7dhjF49ix7Shu0HriHLYjG9KQyuHyy5KAIyllzff4c/yK9q8U
   B8CmSQ5ODs4YreYY8/j6EHnQ+mkSm2TThPP3IH1G+EBbfxK9AVRFWLKQR
   qjaUFpYAPQTehAD7t3KhXkeqboNDnhHsGgKx9TLjxurvqjBhhtbCobxmg
   pZWnKAWi2rmqzE1Pc2gcIZnto09gJZaAJUhEy4MooezcV85wAihHf0/6O
   UyaAhzITI17bVOvkvWPyfW6hwCjSwL1leJnkMujnkfCs0KZYfMvDizF4t
   g==;
X-IronPort-AV: E=Sophos;i="5.93,327,1654585200"; 
   d="scan'208";a="180955254"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 19 Sep 2022 04:53:20 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Mon, 19 Sep 2022 04:53:19 -0700
Received: from DEN-LT-70577.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Mon, 19 Sep 2022 04:53:16 -0700
From:   Daniel Machon <daniel.machon@microchip.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <lars.povlsen@microchip.com>,
        <Steen.Hegelund@microchip.com>, <daniel.machon@microchip.com>,
        <UNGLinuxDriver@microchip.com>, <horatiu.vultur@microchip.com>,
        <casper.casan@gmail.com>, <rmk+kernel@armlinux.org.uk>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        "Steen Hegelund" <steen.hegelund@microchip.com>
Subject: [PATCH net-next 4/5] net: microchip: sparx5: add support for offloading ets qdisc
Date:   Mon, 19 Sep 2022 14:02:14 +0200
Message-ID: <20220919120215.3815696-5-daniel.machon@microchip.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220919120215.3815696-1-daniel.machon@microchip.com>
References: <20220919120215.3815696-1-daniel.machon@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for offloading ets qdisc to sparx5 switch.

The ets qdisc makes it possible to configure a mix og strict and
bandwidth-sharing bands. The ets qdisc must be attached as a root qdisc.

Signed-off-by: Daniel Machon <daniel.machon@microchip.com>
Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
---
 .../microchip/sparx5/sparx5_main_regs.h       | 15 ++++
 .../ethernet/microchip/sparx5/sparx5_qos.c    | 74 +++++++++++++++++++
 .../ethernet/microchip/sparx5/sparx5_qos.h    | 15 ++++
 .../net/ethernet/microchip/sparx5/sparx5_tc.c | 51 +++++++++++++
 4 files changed, 155 insertions(+)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_main_regs.h b/drivers/net/ethernet/microchip/sparx5/sparx5_main_regs.h
index 87a5b169c812..fa2eb70f487a 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_main_regs.h
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_main_regs.h
@@ -3098,6 +3098,21 @@ enum sparx5_target {
 #define HSCH_SE_DLB_SENSE_SE_DLB_DPORT_ENA_GET(x)\
 	FIELD_GET(HSCH_SE_DLB_SENSE_SE_DLB_DPORT_ENA, x)
 
+/*      HSCH:HSCH_DWRR:DWRR_ENTRY */
+#define HSCH_DWRR_ENTRY(g)        __REG(TARGET_HSCH, 0, 1, 162816, g, 72, 4, 0, 0, 1, 4)
+
+#define HSCH_DWRR_ENTRY_DWRR_COST                GENMASK(24, 20)
+#define HSCH_DWRR_ENTRY_DWRR_COST_SET(x)\
+	FIELD_PREP(HSCH_DWRR_ENTRY_DWRR_COST, x)
+#define HSCH_DWRR_ENTRY_DWRR_COST_GET(x)\
+	FIELD_GET(HSCH_DWRR_ENTRY_DWRR_COST, x)
+
+#define HSCH_DWRR_ENTRY_DWRR_BALANCE             GENMASK(19, 0)
+#define HSCH_DWRR_ENTRY_DWRR_BALANCE_SET(x)\
+	FIELD_PREP(HSCH_DWRR_ENTRY_DWRR_BALANCE, x)
+#define HSCH_DWRR_ENTRY_DWRR_BALANCE_GET(x)\
+	FIELD_GET(HSCH_DWRR_ENTRY_DWRR_BALANCE, x)
+
 /*      HSCH:HSCH_MISC:HSCH_CFG_CFG */
 #define HSCH_HSCH_CFG_CFG         __REG(TARGET_HSCH, 0, 1, 163104, 0, 1, 648, 284, 0, 1, 4)
 
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_qos.c b/drivers/net/ethernet/microchip/sparx5/sparx5_qos.c
index 3f3872ab2921..96e4540f0497 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_qos.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_qos.c
@@ -296,6 +296,36 @@ static int sparx5_shaper_conf_set(struct sparx5_port *port,
 	return 0;
 }
 
+static u32 sparx5_weight_to_hw_cost(u32 weight_min, u32 weight)
+{
+	return ((((SPX5_DWRR_COST_MAX << 4) * weight_min / weight) + 8) >> 4) -
+	       1;
+}
+
+static int sparx5_dwrr_conf_set(struct sparx5_port *port,
+				struct sparx5_dwrr *dwrr)
+{
+	int i;
+
+	spx5_rmw(HSCH_HSCH_CFG_CFG_HSCH_LAYER_SET(2) |
+		 HSCH_HSCH_CFG_CFG_CFG_SE_IDX_SET(port->portno),
+		 HSCH_HSCH_CFG_CFG_HSCH_LAYER | HSCH_HSCH_CFG_CFG_CFG_SE_IDX,
+		 port->sparx5, HSCH_HSCH_CFG_CFG);
+
+	/* Number of *lower* indexes that are arbitrated dwrr */
+	spx5_rmw(HSCH_SE_CFG_SE_DWRR_CNT_SET(dwrr->count),
+		 HSCH_SE_CFG_SE_DWRR_CNT, port->sparx5,
+		 HSCH_SE_CFG(port->portno));
+
+	for (i = 0; i < dwrr->count; i++) {
+		spx5_rmw(HSCH_DWRR_ENTRY_DWRR_COST_SET(dwrr->cost[i]),
+			 HSCH_DWRR_ENTRY_DWRR_COST, port->sparx5,
+			 HSCH_DWRR_ENTRY(i));
+	}
+
+	return 0;
+}
+
 static int sparx5_leak_groups_init(struct sparx5 *sparx5)
 {
 	struct sparx5_layer *layer;
@@ -438,3 +468,47 @@ int sparx5_tc_tbf_del(struct sparx5_port *port, u32 layer, u32 idx)
 
 	return sparx5_shaper_conf_set(port, &sh, layer, idx, group);
 }
+
+int sparx5_tc_ets_add(struct sparx5_port *port,
+		      struct tc_ets_qopt_offload_replace_params *params)
+{
+	struct sparx5_dwrr dwrr = {0};
+	/* Minimum weight for each iteration */
+	unsigned int w_min = 100;
+	int i;
+
+	/* Find minimum weight for all dwrr bands */
+	for (i = 0; i < SPX5_PRIOS; i++) {
+		if (params->quanta[i] == 0)
+			continue;
+		w_min = min(w_min, params->weights[i]);
+	}
+
+	for (i = 0; i < SPX5_PRIOS; i++) {
+		/* Strict band; skip */
+		if (params->quanta[i] == 0)
+			continue;
+
+		dwrr.count++;
+
+		/**
+		 * On the sparx5, bands with higher indexes are preferred and
+		 * arbitrated strict. Strict bands are put in the lower indexes,
+		 * by tc, so we reverse the bands here.
+		 *
+		 * Also convert the weight to something the hardware
+		 * understands.
+		 */
+		dwrr.cost[SPX5_PRIOS - i - 1] =
+			sparx5_weight_to_hw_cost(w_min, params->weights[i]);
+	}
+
+	return sparx5_dwrr_conf_set(port, &dwrr);
+}
+
+int sparx5_tc_ets_del(struct sparx5_port *port)
+{
+	struct sparx5_dwrr dwrr = {0};
+
+	return sparx5_dwrr_conf_set(port, &dwrr);
+}
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_qos.h b/drivers/net/ethernet/microchip/sparx5/sparx5_qos.h
index 49662ad86018..ced35033a6c5 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_qos.h
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_qos.h
@@ -34,6 +34,9 @@
 #define SPX5_SE_BURST_MIN 1
 #define SPX5_SE_BURST_UNIT 4096
 
+/* Dwrr */
+#define SPX5_DWRR_COST_MAX 63
+
 struct sparx5_shaper {
 	u32 mode;
 	u32 rate;
@@ -51,6 +54,11 @@ struct sparx5_layer {
 	struct sparx5_lg leak_groups[SPX5_HSCH_LEAK_GRP_CNT];
 };
 
+struct sparx5_dwrr {
+	u32 count; /* Number of inputs running dwrr */
+	u8 cost[SPX5_PRIOS];
+};
+
 int sparx5_qos_init(struct sparx5 *sparx5);
 
 /* Multi-Queue Priority */
@@ -64,4 +72,11 @@ int sparx5_tc_tbf_add(struct sparx5_port *port,
 		      u32 layer, u32 idx);
 int sparx5_tc_tbf_del(struct sparx5_port *port, u32 layer, u32 idx);
 
+/* Enhanced Transmission Selection */
+struct tc_ets_qopt_offload_replace_params;
+int sparx5_tc_ets_add(struct sparx5_port *port,
+		      struct tc_ets_qopt_offload_replace_params *params);
+
+int sparx5_tc_ets_del(struct sparx5_port *port);
+
 #endif	/* __SPARX5_QOS_H__ */
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_tc.c b/drivers/net/ethernet/microchip/sparx5/sparx5_tc.c
index 42b102009e7e..e05429c751ee 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_tc.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_tc.c
@@ -58,6 +58,55 @@ static int sparx5_tc_setup_qdisc_tbf(struct net_device *ndev,
 	return -EOPNOTSUPP;
 }
 
+static int sparx5_tc_setup_qdisc_ets(struct net_device *ndev,
+				     struct tc_ets_qopt_offload *qopt)
+{
+	struct tc_ets_qopt_offload_replace_params *params =
+		&qopt->replace_params;
+	struct sparx5_port *port = netdev_priv(ndev);
+	int i;
+
+	/* Only allow ets on ports  */
+	if (qopt->parent != TC_H_ROOT)
+		return -EOPNOTSUPP;
+
+	switch (qopt->command) {
+	case TC_ETS_REPLACE:
+
+		/* We support eight priorities */
+		if (params->bands != SPX5_PRIOS)
+			return -EOPNOTSUPP;
+
+		/* Sanity checks */
+		for (i = 0; i < SPX5_PRIOS; ++i) {
+			/* Priority map is *always* reverse e.g: 7 6 5 .. 0 */
+			if (params->priomap[i] != (7 - i))
+				return -EOPNOTSUPP;
+			/* Throw an error if we receive zero weights by tc */
+			if (params->quanta[i] && params->weights[i] == 0) {
+				pr_err("Invalid ets configuration; band %d has weight zero",
+				       i);
+				return -EINVAL;
+			}
+		}
+
+		sparx5_tc_ets_add(port, params);
+		break;
+	case TC_ETS_DESTROY:
+
+		sparx5_tc_ets_del(port);
+
+		break;
+	case TC_ETS_GRAFT:
+		return -EOPNOTSUPP;
+
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	return -EOPNOTSUPP;
+}
+
 int sparx5_port_setup_tc(struct net_device *ndev, enum tc_setup_type type,
 			 void *type_data)
 {
@@ -66,6 +115,8 @@ int sparx5_port_setup_tc(struct net_device *ndev, enum tc_setup_type type,
 		return sparx5_tc_setup_qdisc_mqprio(ndev, type_data);
 	case TC_SETUP_QDISC_TBF:
 		return sparx5_tc_setup_qdisc_tbf(ndev, type_data);
+	case TC_SETUP_QDISC_ETS:
+		return sparx5_tc_setup_qdisc_ets(ndev, type_data);
 	default:
 		return -EOPNOTSUPP;
 	}
-- 
2.34.1

