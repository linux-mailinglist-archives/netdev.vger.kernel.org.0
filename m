Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33F4E5BCB28
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 13:54:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230097AbiISLxf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 07:53:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230007AbiISLxU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 07:53:20 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21C2A2BB3B;
        Mon, 19 Sep 2022 04:53:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1663588397; x=1695124397;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=EfaflvEpenFsQE2Lnx7ITrf0SKmjT2JWJ55AfXPiwH8=;
  b=XiF0Qzvt7kAPZfFWf6oLpXW7ZrHD/cAtcU27fiMKj5cixBWhHYs6gWQu
   8oEG1TuZUrif9viFeMJPLzYtQqpR81eBqroQ8lSsW32h9qqmbjpx50dVs
   Z+9azBg72ioGs8uEmICKnMgLV6XradjxWdE16u4yw1uPBhws2pZzXMhwa
   chxyGBvFMv3DFNyhxOJdueXuUSv9ujfb7EHA4ttFW0j5KSlwaYnyoMzDx
   Mt6nXiHPc30pqg+q0Dstn+kbcykao1BaxY1htt5SQgsLga3GD8PXUwa6j
   c2MI2u1xVHurQUfNI+MVvt18fiYYFCig9/KUvez5+i9xBvy6tUNv30YnR
   Q==;
X-IronPort-AV: E=Sophos;i="5.93,327,1654585200"; 
   d="scan'208";a="181069831"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 19 Sep 2022 04:53:16 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Mon, 19 Sep 2022 04:53:16 -0700
Received: from DEN-LT-70577.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Mon, 19 Sep 2022 04:53:13 -0700
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
Subject: [PATCH net-next 3/5] net: microchip: sparx5: add support for offloading tbf qdisc
Date:   Mon, 19 Sep 2022 14:02:13 +0200
Message-ID: <20220919120215.3815696-4-daniel.machon@microchip.com>
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

Add support for offloading tbf qdisc to sparx5 qdisc.

The tbf qdisc makes it possible to attach a shaper on traffic egressing
from a port or a queue. Per-port tbf qdiscs are attached as a root qdisc
directly and queue tbf qdiscs are attached to one of the classes of a
parent qdisc (such as mqprio).

Signed-off-by: Daniel Machon <daniel.machon@microchip.com>
Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
---
 .../ethernet/microchip/sparx5/sparx5_main.c   |   7 +
 .../microchip/sparx5/sparx5_main_regs.h       | 150 +++++++
 .../ethernet/microchip/sparx5/sparx5_qos.c    | 402 ++++++++++++++++++
 .../ethernet/microchip/sparx5/sparx5_qos.h    |  51 +++
 .../net/ethernet/microchip/sparx5/sparx5_tc.c |  39 ++
 5 files changed, 649 insertions(+)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_main.c b/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
index bbe41734360e..62a325e96345 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
@@ -27,6 +27,7 @@
 #include "sparx5_main_regs.h"
 #include "sparx5_main.h"
 #include "sparx5_port.h"
+#include "sparx5_qos.h"
 
 #define QLIM_WM(fraction) \
 	((SPX5_BUFFER_MEMORY / SPX5_BUFFER_CELL_SZ - 100) * (fraction) / 100)
@@ -868,6 +869,12 @@ static int mchp_sparx5_probe(struct platform_device *pdev)
 		goto cleanup_ports;
 	}
 
+	err = sparx5_qos_init(sparx5);
+	if (err) {
+		dev_err(sparx5->dev, "Failed to initialize QoS\n");
+		goto cleanup_ports;
+	}
+
 	err = sparx5_ptp_init(sparx5);
 	if (err) {
 		dev_err(sparx5->dev, "PTP failed\n");
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_main_regs.h b/drivers/net/ethernet/microchip/sparx5/sparx5_main_regs.h
index c94de436b281..87a5b169c812 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_main_regs.h
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_main_regs.h
@@ -2993,6 +2993,132 @@ enum sparx5_target {
 #define GCB_SIO_CLOCK_SYS_CLK_PERIOD_GET(x)\
 	FIELD_GET(GCB_SIO_CLOCK_SYS_CLK_PERIOD, x)
 
+/*      HSCH:HSCH_CFG:CIR_CFG */
+#define HSCH_CIR_CFG(g)           __REG(TARGET_HSCH, 0, 1, 0, g, 5040, 32, 0, 0, 1, 4)
+
+#define HSCH_CIR_CFG_CIR_RATE                    GENMASK(22, 6)
+#define HSCH_CIR_CFG_CIR_RATE_SET(x)\
+	FIELD_PREP(HSCH_CIR_CFG_CIR_RATE, x)
+#define HSCH_CIR_CFG_CIR_RATE_GET(x)\
+	FIELD_GET(HSCH_CIR_CFG_CIR_RATE, x)
+
+#define HSCH_CIR_CFG_CIR_BURST                   GENMASK(5, 0)
+#define HSCH_CIR_CFG_CIR_BURST_SET(x)\
+	FIELD_PREP(HSCH_CIR_CFG_CIR_BURST, x)
+#define HSCH_CIR_CFG_CIR_BURST_GET(x)\
+	FIELD_GET(HSCH_CIR_CFG_CIR_BURST, x)
+
+/*      HSCH:HSCH_CFG:EIR_CFG */
+#define HSCH_EIR_CFG(g)           __REG(TARGET_HSCH, 0, 1, 0, g, 5040, 32, 4, 0, 1, 4)
+
+#define HSCH_EIR_CFG_EIR_RATE                    GENMASK(22, 6)
+#define HSCH_EIR_CFG_EIR_RATE_SET(x)\
+	FIELD_PREP(HSCH_EIR_CFG_EIR_RATE, x)
+#define HSCH_EIR_CFG_EIR_RATE_GET(x)\
+	FIELD_GET(HSCH_EIR_CFG_EIR_RATE, x)
+
+#define HSCH_EIR_CFG_EIR_BURST                   GENMASK(5, 0)
+#define HSCH_EIR_CFG_EIR_BURST_SET(x)\
+	FIELD_PREP(HSCH_EIR_CFG_EIR_BURST, x)
+#define HSCH_EIR_CFG_EIR_BURST_GET(x)\
+	FIELD_GET(HSCH_EIR_CFG_EIR_BURST, x)
+
+/*      HSCH:HSCH_CFG:SE_CFG */
+#define HSCH_SE_CFG(g)            __REG(TARGET_HSCH, 0, 1, 0, g, 5040, 32, 8, 0, 1, 4)
+
+#define HSCH_SE_CFG_SE_DWRR_CNT                  GENMASK(12, 6)
+#define HSCH_SE_CFG_SE_DWRR_CNT_SET(x)\
+	FIELD_PREP(HSCH_SE_CFG_SE_DWRR_CNT, x)
+#define HSCH_SE_CFG_SE_DWRR_CNT_GET(x)\
+	FIELD_GET(HSCH_SE_CFG_SE_DWRR_CNT, x)
+
+#define HSCH_SE_CFG_SE_AVB_ENA                   BIT(5)
+#define HSCH_SE_CFG_SE_AVB_ENA_SET(x)\
+	FIELD_PREP(HSCH_SE_CFG_SE_AVB_ENA, x)
+#define HSCH_SE_CFG_SE_AVB_ENA_GET(x)\
+	FIELD_GET(HSCH_SE_CFG_SE_AVB_ENA, x)
+
+#define HSCH_SE_CFG_SE_FRM_MODE                  GENMASK(4, 3)
+#define HSCH_SE_CFG_SE_FRM_MODE_SET(x)\
+	FIELD_PREP(HSCH_SE_CFG_SE_FRM_MODE, x)
+#define HSCH_SE_CFG_SE_FRM_MODE_GET(x)\
+	FIELD_GET(HSCH_SE_CFG_SE_FRM_MODE, x)
+
+#define HSCH_SE_CFG_SE_DWRR_FRM_MODE             GENMASK(2, 1)
+#define HSCH_SE_CFG_SE_DWRR_FRM_MODE_SET(x)\
+	FIELD_PREP(HSCH_SE_CFG_SE_DWRR_FRM_MODE, x)
+#define HSCH_SE_CFG_SE_DWRR_FRM_MODE_GET(x)\
+	FIELD_GET(HSCH_SE_CFG_SE_DWRR_FRM_MODE, x)
+
+#define HSCH_SE_CFG_SE_STOP                      BIT(0)
+#define HSCH_SE_CFG_SE_STOP_SET(x)\
+	FIELD_PREP(HSCH_SE_CFG_SE_STOP, x)
+#define HSCH_SE_CFG_SE_STOP_GET(x)\
+	FIELD_GET(HSCH_SE_CFG_SE_STOP, x)
+
+/*      HSCH:HSCH_CFG:SE_CONNECT */
+#define HSCH_SE_CONNECT(g)        __REG(TARGET_HSCH, 0, 1, 0, g, 5040, 32, 12, 0, 1, 4)
+
+#define HSCH_SE_CONNECT_SE_LEAK_LINK             GENMASK(15, 0)
+#define HSCH_SE_CONNECT_SE_LEAK_LINK_SET(x)\
+	FIELD_PREP(HSCH_SE_CONNECT_SE_LEAK_LINK, x)
+#define HSCH_SE_CONNECT_SE_LEAK_LINK_GET(x)\
+	FIELD_GET(HSCH_SE_CONNECT_SE_LEAK_LINK, x)
+
+/*      HSCH:HSCH_CFG:SE_DLB_SENSE */
+#define HSCH_SE_DLB_SENSE(g)      __REG(TARGET_HSCH, 0, 1, 0, g, 5040, 32, 16, 0, 1, 4)
+
+#define HSCH_SE_DLB_SENSE_SE_DLB_PRIO            GENMASK(12, 10)
+#define HSCH_SE_DLB_SENSE_SE_DLB_PRIO_SET(x)\
+	FIELD_PREP(HSCH_SE_DLB_SENSE_SE_DLB_PRIO, x)
+#define HSCH_SE_DLB_SENSE_SE_DLB_PRIO_GET(x)\
+	FIELD_GET(HSCH_SE_DLB_SENSE_SE_DLB_PRIO, x)
+
+#define HSCH_SE_DLB_SENSE_SE_DLB_DPORT           GENMASK(9, 3)
+#define HSCH_SE_DLB_SENSE_SE_DLB_DPORT_SET(x)\
+	FIELD_PREP(HSCH_SE_DLB_SENSE_SE_DLB_DPORT, x)
+#define HSCH_SE_DLB_SENSE_SE_DLB_DPORT_GET(x)\
+	FIELD_GET(HSCH_SE_DLB_SENSE_SE_DLB_DPORT, x)
+
+#define HSCH_SE_DLB_SENSE_SE_DLB_SE_ENA          BIT(2)
+#define HSCH_SE_DLB_SENSE_SE_DLB_SE_ENA_SET(x)\
+	FIELD_PREP(HSCH_SE_DLB_SENSE_SE_DLB_SE_ENA, x)
+#define HSCH_SE_DLB_SENSE_SE_DLB_SE_ENA_GET(x)\
+	FIELD_GET(HSCH_SE_DLB_SENSE_SE_DLB_SE_ENA, x)
+
+#define HSCH_SE_DLB_SENSE_SE_DLB_PRIO_ENA        BIT(1)
+#define HSCH_SE_DLB_SENSE_SE_DLB_PRIO_ENA_SET(x)\
+	FIELD_PREP(HSCH_SE_DLB_SENSE_SE_DLB_PRIO_ENA, x)
+#define HSCH_SE_DLB_SENSE_SE_DLB_PRIO_ENA_GET(x)\
+	FIELD_GET(HSCH_SE_DLB_SENSE_SE_DLB_PRIO_ENA, x)
+
+#define HSCH_SE_DLB_SENSE_SE_DLB_DPORT_ENA       BIT(0)
+#define HSCH_SE_DLB_SENSE_SE_DLB_DPORT_ENA_SET(x)\
+	FIELD_PREP(HSCH_SE_DLB_SENSE_SE_DLB_DPORT_ENA, x)
+#define HSCH_SE_DLB_SENSE_SE_DLB_DPORT_ENA_GET(x)\
+	FIELD_GET(HSCH_SE_DLB_SENSE_SE_DLB_DPORT_ENA, x)
+
+/*      HSCH:HSCH_MISC:HSCH_CFG_CFG */
+#define HSCH_HSCH_CFG_CFG         __REG(TARGET_HSCH, 0, 1, 163104, 0, 1, 648, 284, 0, 1, 4)
+
+#define HSCH_HSCH_CFG_CFG_CFG_SE_IDX             GENMASK(26, 14)
+#define HSCH_HSCH_CFG_CFG_CFG_SE_IDX_SET(x)\
+	FIELD_PREP(HSCH_HSCH_CFG_CFG_CFG_SE_IDX, x)
+#define HSCH_HSCH_CFG_CFG_CFG_SE_IDX_GET(x)\
+	FIELD_GET(HSCH_HSCH_CFG_CFG_CFG_SE_IDX, x)
+
+#define HSCH_HSCH_CFG_CFG_HSCH_LAYER             GENMASK(13, 12)
+#define HSCH_HSCH_CFG_CFG_HSCH_LAYER_SET(x)\
+	FIELD_PREP(HSCH_HSCH_CFG_CFG_HSCH_LAYER, x)
+#define HSCH_HSCH_CFG_CFG_HSCH_LAYER_GET(x)\
+	FIELD_GET(HSCH_HSCH_CFG_CFG_HSCH_LAYER, x)
+
+#define HSCH_HSCH_CFG_CFG_CSR_GRANT              GENMASK(11, 0)
+#define HSCH_HSCH_CFG_CFG_CSR_GRANT_SET(x)\
+	FIELD_PREP(HSCH_HSCH_CFG_CFG_CSR_GRANT, x)
+#define HSCH_HSCH_CFG_CFG_CSR_GRANT_GET(x)\
+	FIELD_GET(HSCH_HSCH_CFG_CFG_CSR_GRANT, x)
+
 /*      HSCH:HSCH_MISC:SYS_CLK_PER */
 #define HSCH_SYS_CLK_PER          __REG(TARGET_HSCH, 0, 1, 163104, 0, 1, 648, 640, 0, 1, 4)
 
@@ -3002,6 +3128,30 @@ enum sparx5_target {
 #define HSCH_SYS_CLK_PER_SYS_CLK_PER_100PS_GET(x)\
 	FIELD_GET(HSCH_SYS_CLK_PER_SYS_CLK_PER_100PS, x)
 
+/*      HSCH:HSCH_LEAK_LISTS:HSCH_TIMER_CFG */
+#define HSCH_HSCH_TIMER_CFG(g, r) __REG(TARGET_HSCH, 0, 1, 161664, g, 4, 32, 0, r, 4, 4)
+
+#define HSCH_HSCH_TIMER_CFG_LEAK_TIME            GENMASK(17, 0)
+#define HSCH_HSCH_TIMER_CFG_LEAK_TIME_SET(x)\
+	FIELD_PREP(HSCH_HSCH_TIMER_CFG_LEAK_TIME, x)
+#define HSCH_HSCH_TIMER_CFG_LEAK_TIME_GET(x)\
+	FIELD_GET(HSCH_HSCH_TIMER_CFG_LEAK_TIME, x)
+
+/*      HSCH:HSCH_LEAK_LISTS:HSCH_LEAK_CFG */
+#define HSCH_HSCH_LEAK_CFG(g, r)  __REG(TARGET_HSCH, 0, 1, 161664, g, 4, 32, 16, r, 4, 4)
+
+#define HSCH_HSCH_LEAK_CFG_LEAK_FIRST            GENMASK(16, 1)
+#define HSCH_HSCH_LEAK_CFG_LEAK_FIRST_SET(x)\
+	FIELD_PREP(HSCH_HSCH_LEAK_CFG_LEAK_FIRST, x)
+#define HSCH_HSCH_LEAK_CFG_LEAK_FIRST_GET(x)\
+	FIELD_GET(HSCH_HSCH_LEAK_CFG_LEAK_FIRST, x)
+
+#define HSCH_HSCH_LEAK_CFG_LEAK_ERR              BIT(0)
+#define HSCH_HSCH_LEAK_CFG_LEAK_ERR_SET(x)\
+	FIELD_PREP(HSCH_HSCH_LEAK_CFG_LEAK_ERR, x)
+#define HSCH_HSCH_LEAK_CFG_LEAK_ERR_GET(x)\
+	FIELD_GET(HSCH_HSCH_LEAK_CFG_LEAK_ERR, x)
+
 /*      HSCH:SYSTEM:FLUSH_CTRL */
 #define HSCH_FLUSH_CTRL           __REG(TARGET_HSCH, 0, 1, 184000, 0, 1, 312, 4, 0, 1, 4)
 
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_qos.c b/drivers/net/ethernet/microchip/sparx5/sparx5_qos.c
index 1febc3cdc571..3f3872ab2921 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_qos.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_qos.c
@@ -4,7 +4,363 @@
  * Copyright (c) 2022 Microchip Technology Inc. and its subsidiaries.
  */
 
+#include <net/pkt_cls.h>
+
 #include "sparx5_main.h"
+#include "sparx5_qos.h"
+
+/* Max rates for leak groups */
+static const u32 spx5_hsch_max_group_rate[SPX5_HSCH_LEAK_GRP_CNT] = {
+	1048568, /*  1.049 Gbps */
+	2621420, /*  2.621 Gbps */
+	10485680, /* 10.486 Gbps */
+	26214200 /* 26.214 Gbps */
+};
+
+static struct sparx5_layer layers[SPX5_HSCH_LAYER_CNT];
+
+static u32 sparx5_lg_get_leak_time(struct sparx5 *sparx5, u32 layer, u32 group)
+{
+	u32 value;
+
+	value = spx5_rd(sparx5, HSCH_HSCH_TIMER_CFG(layer, group));
+	return HSCH_HSCH_TIMER_CFG_LEAK_TIME_GET(value);
+}
+
+static void sparx5_lg_set_leak_time(struct sparx5 *sparx5, u32 layer, u32 group,
+				    u32 leak_time)
+{
+	spx5_wr(HSCH_HSCH_TIMER_CFG_LEAK_TIME_SET(leak_time), sparx5,
+		HSCH_HSCH_TIMER_CFG(layer, group));
+}
+
+static u32 sparx5_lg_get_first(struct sparx5 *sparx5, u32 layer, u32 group)
+{
+	u32 value;
+
+	value = spx5_rd(sparx5, HSCH_HSCH_LEAK_CFG(layer, group));
+	return HSCH_HSCH_LEAK_CFG_LEAK_FIRST_GET(value);
+}
+
+static u32 sparx5_lg_get_next(struct sparx5 *sparx5, u32 layer, u32 group,
+			      u32 idx)
+
+{
+	u32 value;
+
+	value = spx5_rd(sparx5, HSCH_SE_CONNECT(idx));
+	return HSCH_SE_CONNECT_SE_LEAK_LINK_GET(value);
+}
+
+static u32 sparx5_lg_get_last(struct sparx5 *sparx5, u32 layer, u32 group)
+{
+	u32 itr, next;
+
+	itr = sparx5_lg_get_first(sparx5, layer, group);
+
+	for (;;) {
+		next = sparx5_lg_get_next(sparx5, layer, group, itr);
+		if (itr == next)
+			return itr;
+
+		itr = next;
+	}
+}
+
+static bool sparx5_lg_is_last(struct sparx5 *sparx5, u32 layer, u32 group,
+			      u32 idx)
+{
+	return idx == sparx5_lg_get_next(sparx5, layer, group, idx);
+}
+
+static bool sparx5_lg_is_first(struct sparx5 *sparx5, u32 layer, u32 group,
+			       u32 idx)
+{
+	return idx == sparx5_lg_get_first(sparx5, layer, group);
+}
+
+static bool sparx5_lg_is_empty(struct sparx5 *sparx5, u32 layer, u32 group)
+{
+	return sparx5_lg_get_leak_time(sparx5, layer, group) == 0;
+}
+
+static bool sparx5_lg_is_singular(struct sparx5 *sparx5, u32 layer, u32 group)
+{
+	if (sparx5_lg_is_empty(sparx5, layer, group))
+		return false;
+
+	return sparx5_lg_get_first(sparx5, layer, group) ==
+	       sparx5_lg_get_last(sparx5, layer, group);
+}
+
+static void sparx5_lg_enable(struct sparx5 *sparx5, u32 layer, u32 group,
+			     u32 leak_time)
+{
+	sparx5_lg_set_leak_time(sparx5, layer, group, leak_time);
+}
+
+static void sparx5_lg_disable(struct sparx5 *sparx5, u32 layer, u32 group)
+{
+	sparx5_lg_set_leak_time(sparx5, layer, group, 0);
+}
+
+static int sparx5_lg_get_group_by_index(struct sparx5 *sparx5, u32 layer,
+					u32 idx, u32 *group)
+{
+	u32 itr, next;
+	int i;
+
+	for (i = 0; i < SPX5_HSCH_LEAK_GRP_CNT; i++) {
+		if (sparx5_lg_is_empty(sparx5, layer, i))
+			continue;
+
+		itr = sparx5_lg_get_first(sparx5, layer, i);
+
+		for (;;) {
+			next = sparx5_lg_get_next(sparx5, layer, i, itr);
+
+			if (itr == idx) {
+				*group = i;
+				return 0; /* Found it */
+			}
+			if (itr == next)
+				break; /* Was not found */
+
+			itr = next;
+		}
+	}
+
+	return -1;
+}
+
+static int sparx5_lg_get_group_by_rate(u32 layer, u32 rate, u32 *group)
+{
+	struct sparx5_layer *l = &layers[layer];
+	struct sparx5_lg *lg;
+	u32 i;
+
+	for (i = 0; i < SPX5_HSCH_LEAK_GRP_CNT; i++) {
+		lg = &l->leak_groups[i];
+		if (rate <= lg->max_rate) {
+			*group = i;
+			return 0;
+		}
+	}
+
+	return -1;
+}
+
+static int sparx5_lg_get_adjacent(struct sparx5 *sparx5, u32 layer, u32 group,
+				  u32 idx, u32 *prev, u32 *next, u32 *first)
+{
+	u32 itr;
+
+	*first = sparx5_lg_get_first(sparx5, layer, group);
+	*prev = *first;
+	*next = *first;
+	itr = *first;
+
+	for (;;) {
+		*next = sparx5_lg_get_next(sparx5, layer, group, itr);
+
+		if (itr == idx)
+			return 0; /* Found it */
+
+		if (itr == *next)
+			return -1; /* Was not found */
+
+		*prev = itr;
+		itr = *next;
+	}
+
+	return -1;
+}
+
+static int sparx5_lg_conf_set(struct sparx5 *sparx5, u32 layer, u32 group,
+			      u32 se_first, u32 idx, u32 idx_next, bool empty)
+{
+	u32 leak_time = layers[layer].leak_groups[group].leak_time;
+
+	/* Stop leaking */
+	sparx5_lg_disable(sparx5, layer, group);
+
+	if (empty)
+		return 0;
+
+	/* Select layer */
+	spx5_rmw(HSCH_HSCH_CFG_CFG_HSCH_LAYER_SET(layer),
+		 HSCH_HSCH_CFG_CFG_HSCH_LAYER, sparx5, HSCH_HSCH_CFG_CFG);
+
+	/* Link elements */
+	spx5_wr(HSCH_SE_CONNECT_SE_LEAK_LINK_SET(idx_next), sparx5,
+		HSCH_SE_CONNECT(idx));
+
+	/* Set the first element. */
+	spx5_rmw(HSCH_HSCH_LEAK_CFG_LEAK_FIRST_SET(se_first),
+		 HSCH_HSCH_LEAK_CFG_LEAK_FIRST, sparx5,
+		 HSCH_HSCH_LEAK_CFG(layer, group));
+
+	/* Start leaking */
+	sparx5_lg_enable(sparx5, layer, group, leak_time);
+
+	return 0;
+}
+
+static int sparx5_lg_del(struct sparx5 *sparx5, u32 layer, u32 group, u32 idx)
+{
+	u32 first, next, prev;
+	bool empty = false;
+
+	/* idx *must* be present in the leak group */
+	WARN_ON(sparx5_lg_get_adjacent(sparx5, layer, group, idx, &prev, &next,
+				       &first) < 0);
+
+	if (sparx5_lg_is_singular(sparx5, layer, group)) {
+		empty = true;
+	} else if (sparx5_lg_is_last(sparx5, layer, group, idx)) {
+		/* idx is removed, prev is now last */
+		idx = prev;
+		next = prev;
+	} else if (sparx5_lg_is_first(sparx5, layer, group, idx)) {
+		/* idx is removed and points to itself, first is next */
+		first = next;
+		next = idx;
+	} else {
+		/* Next is not touched */
+		idx = prev;
+	}
+
+	return sparx5_lg_conf_set(sparx5, layer, group, first, idx, next,
+				  empty);
+}
+
+static int sparx5_lg_add(struct sparx5 *sparx5, u32 layer, u32 new_group,
+			 u32 idx)
+{
+	u32 first, next, old_group;
+
+	pr_debug("ADD: layer: %d, new_group: %d, idx: %d", layer, new_group,
+		 idx);
+
+	/* Is this SE already shaping ? */
+	if (sparx5_lg_get_group_by_index(sparx5, layer, idx, &old_group) >= 0) {
+		if (old_group != new_group) {
+			/* Delete from old group */
+			sparx5_lg_del(sparx5, layer, old_group, idx);
+		} else {
+			/* Nothing to do here */
+			return 0;
+		}
+	}
+
+	/* We always add to head of the list */
+	first = idx;
+
+	if (sparx5_lg_is_empty(sparx5, layer, new_group))
+		next = idx;
+	else
+		next = sparx5_lg_get_first(sparx5, layer, new_group);
+
+	return sparx5_lg_conf_set(sparx5, layer, new_group, first, idx, next,
+				  false);
+}
+
+static int sparx5_shaper_conf_set(struct sparx5_port *port,
+				  const struct sparx5_shaper *sh, u32 layer,
+				  u32 idx, u32 group)
+{
+	int (*sparx5_lg_action)(struct sparx5 *, u32, u32, u32);
+	struct sparx5 *sparx5 = port->sparx5;
+
+	if (!sh->rate && !sh->burst)
+		sparx5_lg_action = &sparx5_lg_del;
+	else
+		sparx5_lg_action = &sparx5_lg_add;
+
+	/* Select layer */
+	spx5_rmw(HSCH_HSCH_CFG_CFG_HSCH_LAYER_SET(layer),
+		 HSCH_HSCH_CFG_CFG_HSCH_LAYER, sparx5, HSCH_HSCH_CFG_CFG);
+
+	/* Set frame mode */
+	spx5_rmw(HSCH_SE_CFG_SE_FRM_MODE_SET(sh->mode), HSCH_SE_CFG_SE_FRM_MODE,
+		 sparx5, HSCH_SE_CFG(idx));
+
+	/* Set committed rate and burst */
+	spx5_wr(HSCH_CIR_CFG_CIR_RATE_SET(sh->rate) |
+			HSCH_CIR_CFG_CIR_BURST_SET(sh->burst),
+		sparx5, HSCH_CIR_CFG(idx));
+
+	/* This has to be done after the shaper configuration has been set */
+	sparx5_lg_action(sparx5, layer, group, idx);
+
+	return 0;
+}
+
+static int sparx5_leak_groups_init(struct sparx5 *sparx5)
+{
+	struct sparx5_layer *layer;
+	u32 sys_clk_per_100ps;
+	struct sparx5_lg *lg;
+	u32 leak_time_us;
+	int i, ii;
+
+	sys_clk_per_100ps = spx5_rd(sparx5, HSCH_SYS_CLK_PER);
+
+	for (i = 0; i < SPX5_HSCH_LAYER_CNT; i++) {
+		layer = &layers[i];
+		for (ii = 0; ii < SPX5_HSCH_LEAK_GRP_CNT; ii++) {
+			lg = &layer->leak_groups[ii];
+			lg->max_rate = spx5_hsch_max_group_rate[ii];
+
+			/* Calculate the leak time in us, to serve a maximum
+			 * rate of 'max_rate' for this group
+			 */
+			leak_time_us = (SPX5_SE_RATE_MAX * 1000) / lg->max_rate;
+
+			/* Hardware wants leak time in ns */
+			lg->leak_time = 1000 * leak_time_us;
+
+			/* Calculate resolution */
+			lg->resolution = 1000 / leak_time_us;
+
+			/* Maximum number of shapers that can be served by
+			 * this leak group
+			 */
+			lg->max_ses = (1000 * leak_time_us) / sys_clk_per_100ps;
+
+			/* Example:
+			 * Wanted bandwidth is 100Mbit:
+			 *
+			 * 100 mbps can be served by leak group zero.
+			 *
+			 * leak_time is 125000 ns.
+			 * resolution is: 8
+			 *
+			 * cir          = 100000 / 8 = 12500
+			 * leaks_pr_sec = 125000 / 10^9 = 8000
+			 * bw           = 12500 * 8000 = 10^8 (100 Mbit)
+			 */
+
+			/* Disable by default - this also indicates an empty
+			 * leak group
+			 */
+			sparx5_lg_disable(sparx5, i, ii);
+		}
+	}
+
+	return 0;
+}
+
+int sparx5_qos_init(struct sparx5 *sparx5)
+{
+	int ret;
+
+	ret = sparx5_leak_groups_init(sparx5);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
 
 int sparx5_tc_mqprio_add(struct net_device *ndev, u8 num_tc)
 {
@@ -36,3 +392,49 @@ int sparx5_tc_mqprio_del(struct net_device *ndev)
 
 	return 0;
 }
+
+int sparx5_tc_tbf_add(struct sparx5_port *port,
+		      struct tc_tbf_qopt_offload_replace_params *params,
+		      u32 layer, u32 idx)
+{
+	struct sparx5_shaper sh = {
+		.mode = SPX5_SE_MODE_DATARATE,
+		.rate = div_u64(params->rate.rate_bytes_ps, 1000) * 8,
+		.burst = params->max_size,
+	};
+	struct sparx5_lg *lg;
+	u32 group;
+
+	/* Find suitable group for this se */
+	if (sparx5_lg_get_group_by_rate(layer, sh.rate, &group) < 0) {
+		pr_debug("Could not find leak group for se with rate: %d",
+			 sh.rate);
+		return -EINVAL;
+	}
+
+	lg = &layers[layer].leak_groups[group];
+
+	pr_debug("Found matching group (speed: %d)\n", lg->max_rate);
+
+	if (sh.rate < SPX5_SE_RATE_MIN || sh.burst < SPX5_SE_BURST_MIN)
+		return -EINVAL;
+
+	/* Calculate committed rate and burst */
+	sh.rate = DIV_ROUND_UP(sh.rate, lg->resolution);
+	sh.burst = DIV_ROUND_UP(sh.burst, SPX5_SE_BURST_UNIT);
+
+	if (sh.rate > SPX5_SE_RATE_MAX || sh.burst > SPX5_SE_BURST_MAX)
+		return -EINVAL;
+
+	return sparx5_shaper_conf_set(port, &sh, layer, idx, group);
+}
+
+int sparx5_tc_tbf_del(struct sparx5_port *port, u32 layer, u32 idx)
+{
+	struct sparx5_shaper sh = {0};
+	u32 group;
+
+	sparx5_lg_get_group_by_index(port->sparx5, layer, idx, &group);
+
+	return sparx5_shaper_conf_set(port, &sh, layer, idx, group);
+}
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_qos.h b/drivers/net/ethernet/microchip/sparx5/sparx5_qos.h
index 0572fb41c949..49662ad86018 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_qos.h
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_qos.h
@@ -9,8 +9,59 @@
 
 #include <linux/netdevice.h>
 
+/* Number of Layers */
+#define SPX5_HSCH_LAYER_CNT 3
+
+/* Scheduling elements per layer */
+#define SPX5_HSCH_L0_SE_CNT 5040
+#define SPX5_HSCH_L1_SE_CNT 64
+#define SPX5_HSCH_L2_SE_CNT 64
+
+/* Calculate Layer 0 Scheduler Element when using normal hierarchy */
+#define SPX5_HSCH_L0_GET_IDX(port, queue) ((64 * (port)) + (8 * (queue)))
+
+/* Number of leak groups */
+#define SPX5_HSCH_LEAK_GRP_CNT 4
+
+/* Scheduler modes */
+#define SPX5_SE_MODE_LINERATE 0
+#define SPX5_SE_MODE_DATARATE 1
+
+/* Rate and burst */
+#define SPX5_SE_RATE_MAX 262143
+#define SPX5_SE_BURST_MAX 127
+#define SPX5_SE_RATE_MIN 1
+#define SPX5_SE_BURST_MIN 1
+#define SPX5_SE_BURST_UNIT 4096
+
+struct sparx5_shaper {
+	u32 mode;
+	u32 rate;
+	u32 burst;
+};
+
+struct sparx5_lg {
+	u32 max_rate;
+	u32 resolution;
+	u32 leak_time;
+	u32 max_ses;
+};
+
+struct sparx5_layer {
+	struct sparx5_lg leak_groups[SPX5_HSCH_LEAK_GRP_CNT];
+};
+
+int sparx5_qos_init(struct sparx5 *sparx5);
+
 /* Multi-Queue Priority */
 int sparx5_tc_mqprio_add(struct net_device *ndev, u8 num_tc);
 int sparx5_tc_mqprio_del(struct net_device *ndev);
 
+/* Token Bucket Filter */
+struct tc_tbf_qopt_offload_replace_params;
+int sparx5_tc_tbf_add(struct sparx5_port *port,
+		      struct tc_tbf_qopt_offload_replace_params *params,
+		      u32 layer, u32 idx);
+int sparx5_tc_tbf_del(struct sparx5_port *port, u32 layer, u32 idx);
+
 #endif	/* __SPARX5_QOS_H__ */
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_tc.c b/drivers/net/ethernet/microchip/sparx5/sparx5_tc.c
index 6e01a7c7c821..42b102009e7e 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_tc.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_tc.c
@@ -10,6 +10,19 @@
 #include "sparx5_main.h"
 #include "sparx5_qos.h"
 
+static void sparx5_tc_get_layer_and_idx(u32 parent, u32 portno, u32 *layer,
+					u32 *idx)
+{
+	if (parent == TC_H_ROOT) {
+		*layer = 2;
+		*idx = portno;
+	} else {
+		u32 queue = TC_H_MIN(parent) - 1;
+		*layer = 0;
+		*idx = SPX5_HSCH_L0_GET_IDX(portno, queue);
+	}
+}
+
 static int sparx5_tc_setup_qdisc_mqprio(struct net_device *ndev,
 					struct tc_mqprio_qopt_offload *m)
 {
@@ -21,12 +34,38 @@ static int sparx5_tc_setup_qdisc_mqprio(struct net_device *ndev,
 		return sparx5_tc_mqprio_add(ndev, m->qopt.num_tc);
 }
 
+static int sparx5_tc_setup_qdisc_tbf(struct net_device *ndev,
+				     struct tc_tbf_qopt_offload *qopt)
+{
+	struct sparx5_port *port = netdev_priv(ndev);
+	u32 layer, se_idx;
+
+	sparx5_tc_get_layer_and_idx(qopt->parent, port->portno, &layer,
+				    &se_idx);
+
+	switch (qopt->command) {
+	case TC_TBF_REPLACE:
+		return sparx5_tc_tbf_add(port, &qopt->replace_params, layer,
+					 se_idx);
+	case TC_TBF_DESTROY:
+		return sparx5_tc_tbf_del(port, layer, se_idx);
+	case TC_TBF_STATS:
+		return -EOPNOTSUPP;
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
 	switch (type) {
 	case TC_SETUP_QDISC_MQPRIO:
 		return sparx5_tc_setup_qdisc_mqprio(ndev, type_data);
+	case TC_SETUP_QDISC_TBF:
+		return sparx5_tc_setup_qdisc_tbf(ndev, type_data);
 	default:
 		return -EOPNOTSUPP;
 	}
-- 
2.34.1

