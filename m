Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C11C25E9576
	for <lists+netdev@lfdr.de>; Sun, 25 Sep 2022 20:44:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233133AbiIYSoY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Sep 2022 14:44:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232971AbiIYSoR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Sep 2022 14:44:17 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 696BF2B626;
        Sun, 25 Sep 2022 11:44:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1664131440; x=1695667440;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ZeBdoyiAZEs1mfEiuIsTvIMTWuauHO+Y0b3VWyuwV14=;
  b=eSbsHKGetscC+VP9y1NIOJ4/lOsw3UIXTQSYnfdtmUdEnAAIMIjgQmjP
   g+Rv2qWBNwW5JsCGm++h/0I3mh6YrtWPg6pY9hYm04Lzwa0fzjuPfyB0f
   sStX6r1bywaGp/CwKOhI+qzsga/X8zWgf7pvSKVeG/xvmV8rYBlyHxn7M
   VBlXxsugHDfzScGuCZr0URwPDwrgXoBb9UegsjU0jSN50TkOGMtXguWGS
   iVwB6YHg+OwA/5pgcXMJOnTnstxB10O9Raqe3sGu967aIFeKV1M1k9Odn
   OD6Somkh85fr24btIVR75Da4LnPIin/tVmWPNfHGJKFfpC/UJMfMS9sbJ
   A==;
X-IronPort-AV: E=Sophos;i="5.93,344,1654585200"; 
   d="scan'208";a="115319833"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 25 Sep 2022 11:43:59 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Sun, 25 Sep 2022 11:43:59 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Sun, 25 Sep 2022 11:43:57 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <UNGLinuxDriver@microchip.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next 3/3] net: lan966x: Add offload support for ets
Date:   Sun, 25 Sep 2022 20:46:33 +0200
Message-ID: <20220925184633.4148143-4-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220925184633.4148143-1-horatiu.vultur@microchip.com>
References: <20220925184633.4148143-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add ets qdisc which allows to mix strict priority with bandwidth-sharing
bands. The ets qdisc needs to be attached as root qdisc.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 .../net/ethernet/microchip/lan966x/Makefile   |  2 +-
 .../ethernet/microchip/lan966x/lan966x_ets.c  | 96 +++++++++++++++++++
 .../ethernet/microchip/lan966x/lan966x_main.h |  5 +
 .../ethernet/microchip/lan966x/lan966x_regs.h | 20 ++++
 .../ethernet/microchip/lan966x/lan966x_tc.c   | 17 ++++
 5 files changed, 139 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_ets.c

diff --git a/drivers/net/ethernet/microchip/lan966x/Makefile b/drivers/net/ethernet/microchip/lan966x/Makefile
index bc76949d1fd8f..7360c1c7b53c3 100644
--- a/drivers/net/ethernet/microchip/lan966x/Makefile
+++ b/drivers/net/ethernet/microchip/lan966x/Makefile
@@ -10,4 +10,4 @@ lan966x-switch-objs  := lan966x_main.o lan966x_phylink.o lan966x_port.o \
 			lan966x_vlan.o lan966x_fdb.o lan966x_mdb.o \
 			lan966x_ptp.o lan966x_fdma.o lan966x_lag.o \
 			lan966x_tc.o lan966x_mqprio.o lan966x_taprio.o \
-			lan966x_tbf.o lan966x_cbs.o
+			lan966x_tbf.o lan966x_cbs.o lan966x_ets.o
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_ets.c b/drivers/net/ethernet/microchip/lan966x/lan966x_ets.c
new file mode 100644
index 0000000000000..8310d3f35404e
--- /dev/null
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_ets.c
@@ -0,0 +1,96 @@
+// SPDX-License-Identifier: GPL-2.0+
+
+#include "lan966x_main.h"
+
+#define DWRR_COST_BIT_WIDTH	BIT(5)
+
+static u32 lan966x_ets_hw_cost(u32 w_min, u32 weight)
+{
+	u32 res;
+
+	/* Round half up: Multiply with 16 before division,
+	 * add 8 and divide result with 16 again
+	 */
+	res = (((DWRR_COST_BIT_WIDTH << 4) * w_min / weight) + 8) >> 4;
+	return max_t(u32, 1, res) - 1;
+}
+
+int lan966x_ets_add(struct lan966x_port *port,
+		    struct tc_ets_qopt_offload *qopt)
+{
+	struct tc_ets_qopt_offload_replace_params *params;
+	struct lan966x *lan966x = port->lan966x;
+	u32 w_min = 100;
+	u8 count = 0;
+	u32 se_idx;
+	u8 i;
+
+	/* Check the input */
+	if (qopt->parent != TC_H_ROOT)
+		return -EINVAL;
+
+	params = &qopt->replace_params;
+	if (params->bands != NUM_PRIO_QUEUES)
+		return -EINVAL;
+
+	for (i = 0; i < params->bands; ++i) {
+		/* In the switch the DWRR is always on the lowest consecutive
+		 * priorities. Due to this, the first priority must map to the
+		 * first DWRR band.
+		 */
+		if (params->priomap[i] != (7 - i))
+			return -EINVAL;
+
+		if (params->quanta[i] && params->weights[i] == 0)
+			return -EINVAL;
+	}
+
+	se_idx = SE_IDX_PORT + port->chip_port;
+
+	/* Find minimum weight */
+	for (i = 0; i < params->bands; ++i) {
+		if (params->quanta[i] == 0)
+			continue;
+
+		w_min = min(w_min, params->weights[i]);
+	}
+
+	for (i = 0; i < params->bands; ++i) {
+		if (params->quanta[i] == 0)
+			continue;
+
+		++count;
+
+		lan_wr(lan966x_ets_hw_cost(w_min, params->weights[i]),
+		       lan966x, QSYS_SE_DWRR_CFG(se_idx, 7 - i));
+	}
+
+	lan_rmw(QSYS_SE_CFG_SE_DWRR_CNT_SET(count) |
+		QSYS_SE_CFG_SE_RR_ENA_SET(0),
+		QSYS_SE_CFG_SE_DWRR_CNT |
+		QSYS_SE_CFG_SE_RR_ENA,
+		lan966x, QSYS_SE_CFG(se_idx));
+
+	return 0;
+}
+
+int lan966x_ets_del(struct lan966x_port *port,
+		    struct tc_ets_qopt_offload *qopt)
+{
+	struct lan966x *lan966x = port->lan966x;
+	u32 se_idx;
+	int i;
+
+	se_idx = SE_IDX_PORT + port->chip_port;
+
+	for (i = 0; i < NUM_PRIO_QUEUES; ++i)
+		lan_wr(0, lan966x, QSYS_SE_DWRR_CFG(se_idx, i));
+
+	lan_rmw(QSYS_SE_CFG_SE_DWRR_CNT_SET(0) |
+		QSYS_SE_CFG_SE_RR_ENA_SET(0),
+		QSYS_SE_CFG_SE_DWRR_CNT |
+		QSYS_SE_CFG_SE_RR_ENA,
+		lan966x, QSYS_SE_CFG(se_idx));
+
+	return 0;
+}
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
index 168456f693bb7..78665eb9a3f11 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
@@ -476,6 +476,11 @@ int lan966x_cbs_add(struct lan966x_port *port,
 int lan966x_cbs_del(struct lan966x_port *port,
 		    struct tc_cbs_qopt_offload *qopt);
 
+int lan966x_ets_add(struct lan966x_port *port,
+		    struct tc_ets_qopt_offload *qopt);
+int lan966x_ets_del(struct lan966x_port *port,
+		    struct tc_ets_qopt_offload *qopt);
+
 static inline void __iomem *lan_addr(void __iomem *base[],
 				     int id, int tinst, int tcnt,
 				     int gbase, int ginst,
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_regs.h b/drivers/net/ethernet/microchip/lan966x/lan966x_regs.h
index 01fa6bb680b92..4f00f95d66b68 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_regs.h
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_regs.h
@@ -1036,6 +1036,18 @@ enum lan966x_target {
 /*      QSYS:HSCH:SE_CFG */
 #define QSYS_SE_CFG(g)            __REG(TARGET_QSYS, 0, 1, 16384, g, 90, 128, 8, 0, 1, 4)
 
+#define QSYS_SE_CFG_SE_DWRR_CNT                  GENMASK(9, 6)
+#define QSYS_SE_CFG_SE_DWRR_CNT_SET(x)\
+	FIELD_PREP(QSYS_SE_CFG_SE_DWRR_CNT, x)
+#define QSYS_SE_CFG_SE_DWRR_CNT_GET(x)\
+	FIELD_GET(QSYS_SE_CFG_SE_DWRR_CNT, x)
+
+#define QSYS_SE_CFG_SE_RR_ENA                    BIT(5)
+#define QSYS_SE_CFG_SE_RR_ENA_SET(x)\
+	FIELD_PREP(QSYS_SE_CFG_SE_RR_ENA, x)
+#define QSYS_SE_CFG_SE_RR_ENA_GET(x)\
+	FIELD_GET(QSYS_SE_CFG_SE_RR_ENA, x)
+
 #define QSYS_SE_CFG_SE_AVB_ENA                   BIT(4)
 #define QSYS_SE_CFG_SE_AVB_ENA_SET(x)\
 	FIELD_PREP(QSYS_SE_CFG_SE_AVB_ENA, x)
@@ -1048,6 +1060,14 @@ enum lan966x_target {
 #define QSYS_SE_CFG_SE_FRM_MODE_GET(x)\
 	FIELD_GET(QSYS_SE_CFG_SE_FRM_MODE, x)
 
+#define QSYS_SE_DWRR_CFG(g, r)    __REG(TARGET_QSYS, 0, 1, 16384, g, 90, 128, 12, r, 12, 4)
+
+#define QSYS_SE_DWRR_CFG_DWRR_COST               GENMASK(4, 0)
+#define QSYS_SE_DWRR_CFG_DWRR_COST_SET(x)\
+	FIELD_PREP(QSYS_SE_DWRR_CFG_DWRR_COST, x)
+#define QSYS_SE_DWRR_CFG_DWRR_COST_GET(x)\
+	FIELD_GET(QSYS_SE_DWRR_CFG_DWRR_COST, x)
+
 /*      QSYS:TAS_CONFIG:TAS_CFG_CTRL */
 #define QSYS_TAS_CFG_CTRL         __REG(TARGET_QSYS, 0, 1, 57372, 0, 1, 12, 0, 0, 1, 4)
 
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_tc.c b/drivers/net/ethernet/microchip/lan966x/lan966x_tc.c
index 4b05535c9e029..336eb7ee0d608 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_tc.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_tc.c
@@ -44,6 +44,21 @@ static int lan966x_tc_setup_qdisc_cbs(struct lan966x_port *port,
 			      lan966x_cbs_del(port, qopt);
 }
 
+static int lan966x_tc_setup_qdisc_ets(struct lan966x_port *port,
+				      struct tc_ets_qopt_offload *qopt)
+{
+	switch (qopt->command) {
+	case TC_ETS_REPLACE:
+		return lan966x_ets_add(port, qopt);
+	case TC_ETS_DESTROY:
+		return lan966x_ets_del(port, qopt);
+	default:
+		return -EOPNOTSUPP;
+	};
+
+	return -EOPNOTSUPP;
+}
+
 int lan966x_tc_setup(struct net_device *dev, enum tc_setup_type type,
 		     void *type_data)
 {
@@ -58,6 +73,8 @@ int lan966x_tc_setup(struct net_device *dev, enum tc_setup_type type,
 		return lan966x_tc_setup_qdisc_tbf(port, type_data);
 	case TC_SETUP_QDISC_CBS:
 		return lan966x_tc_setup_qdisc_cbs(port, type_data);
+	case TC_SETUP_QDISC_ETS:
+		return lan966x_tc_setup_qdisc_ets(port, type_data);
 	default:
 		return -EOPNOTSUPP;
 	}
-- 
2.33.0

