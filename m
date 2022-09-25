Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4C385E9572
	for <lists+netdev@lfdr.de>; Sun, 25 Sep 2022 20:44:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233010AbiIYSoB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Sep 2022 14:44:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232817AbiIYSn7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Sep 2022 14:43:59 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 168D92B624;
        Sun, 25 Sep 2022 11:43:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1664131436; x=1695667436;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ZNDPR9uAe6HU45Nk1EW8geesTcDItDm7wVeVFuXKyaM=;
  b=KTLI6miZ6VQafajz/8jICVpzVJi9RFEMUE1/fi43FTLew0uhIPndCC+Z
   jqblJvFR3nnawGBj8XsP+E7ANKfSazuluZP8nsxlzu8aVnMCMVIWWZrp5
   HHsIFBgT6HbHPwCnIVaFsc9UR7iyDWnsdL9qhybZBrZiMR+PNC4vf/vvH
   YgXRaar28/cl/m1VynrVqcitb1S1vdFYm42HHreVCJucgiepq8c1vOCqY
   /mOqYViZHtUd5r8qZE595QE/HH604uBY2GNkj4g1vMpBuXfrCgmyEAYJc
   p7v4VyAy5UkyTMApp9mXTK+EX5phBxlWFLgLCY1jl34uiZPCkIDrv9oTo
   A==;
X-IronPort-AV: E=Sophos;i="5.93,344,1654585200"; 
   d="scan'208";a="115319824"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 25 Sep 2022 11:43:55 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Sun, 25 Sep 2022 11:43:55 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Sun, 25 Sep 2022 11:43:53 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <UNGLinuxDriver@microchip.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next 1/3] net: lan966x: Add offload support for tbf
Date:   Sun, 25 Sep 2022 20:46:31 +0200
Message-ID: <20220925184633.4148143-2-horatiu.vultur@microchip.com>
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

The tbf qdisc allows to attach a shaper on traffic egress on a port or
on a queue. On port they are attached directly to the root and on queue
they are attached on one of the classes of the parent qdisc.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 .../net/ethernet/microchip/lan966x/Makefile   |  3 +-
 .../ethernet/microchip/lan966x/lan966x_main.h |  9 ++
 .../ethernet/microchip/lan966x/lan966x_regs.h | 30 +++++++
 .../ethernet/microchip/lan966x/lan966x_tbf.c  | 85 +++++++++++++++++++
 .../ethernet/microchip/lan966x/lan966x_tc.c   | 17 ++++
 5 files changed, 143 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_tbf.c

diff --git a/drivers/net/ethernet/microchip/lan966x/Makefile b/drivers/net/ethernet/microchip/lan966x/Makefile
index cac8b3901eaef..a3a519d10c73d 100644
--- a/drivers/net/ethernet/microchip/lan966x/Makefile
+++ b/drivers/net/ethernet/microchip/lan966x/Makefile
@@ -9,4 +9,5 @@ lan966x-switch-objs  := lan966x_main.o lan966x_phylink.o lan966x_port.o \
 			lan966x_mac.o lan966x_ethtool.o lan966x_switchdev.o \
 			lan966x_vlan.o lan966x_fdb.o lan966x_mdb.o \
 			lan966x_ptp.o lan966x_fdma.o lan966x_lag.o \
-			lan966x_tc.o lan966x_mqprio.o lan966x_taprio.o
+			lan966x_tc.o lan966x_mqprio.o lan966x_taprio.o \
+			lan966x_tbf.o
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
index 935c116715939..59f5a6b2b3bc0 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
@@ -9,6 +9,7 @@
 #include <linux/phy.h>
 #include <linux/phylink.h>
 #include <linux/ptp_clock_kernel.h>
+#include <net/pkt_cls.h>
 #include <net/pkt_sched.h>
 #include <net/switchdev.h>
 
@@ -81,6 +82,9 @@
 #define FDMA_INJ_CHANNEL		0
 #define FDMA_DCB_MAX			512
 
+#define SE_IDX_QUEUE			0  /* 0-79 : Queue scheduler elements */
+#define SE_IDX_PORT			80 /* 80-89 : Port schedular elements */
+
 /* MAC table entry types.
  * ENTRYTYPE_NORMAL is subject to aging.
  * ENTRYTYPE_LOCKED is not subject to aging.
@@ -462,6 +466,11 @@ int lan966x_taprio_add(struct lan966x_port *port,
 int lan966x_taprio_del(struct lan966x_port *port);
 int lan966x_taprio_speed_set(struct lan966x_port *port, int speed);
 
+int lan966x_tbf_add(struct lan966x_port *port,
+		    struct tc_tbf_qopt_offload *qopt);
+int lan966x_tbf_del(struct lan966x_port *port,
+		    struct tc_tbf_qopt_offload *qopt);
+
 static inline void __iomem *lan_addr(void __iomem *base[],
 				     int id, int tinst, int tcnt,
 				     int gbase, int ginst,
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_regs.h b/drivers/net/ethernet/microchip/lan966x/lan966x_regs.h
index 684b08c6ff34e..01fa6bb680b92 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_regs.h
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_regs.h
@@ -1018,6 +1018,36 @@ enum lan966x_target {
 /*      QSYS:RES_CTRL:RES_CFG */
 #define QSYS_RES_CFG(g)           __REG(TARGET_QSYS, 0, 1, 32768, g, 1024, 8, 0, 0, 1, 4)
 
+/*      QSYS:HSCH:CIR_CFG */
+#define QSYS_CIR_CFG(g)           __REG(TARGET_QSYS, 0, 1, 16384, g, 90, 128, 0, 0, 1, 4)
+
+#define QSYS_CIR_CFG_CIR_RATE                    GENMASK(20, 6)
+#define QSYS_CIR_CFG_CIR_RATE_SET(x)\
+	FIELD_PREP(QSYS_CIR_CFG_CIR_RATE, x)
+#define QSYS_CIR_CFG_CIR_RATE_GET(x)\
+	FIELD_GET(QSYS_CIR_CFG_CIR_RATE, x)
+
+#define QSYS_CIR_CFG_CIR_BURST                   GENMASK(5, 0)
+#define QSYS_CIR_CFG_CIR_BURST_SET(x)\
+	FIELD_PREP(QSYS_CIR_CFG_CIR_BURST, x)
+#define QSYS_CIR_CFG_CIR_BURST_GET(x)\
+	FIELD_GET(QSYS_CIR_CFG_CIR_BURST, x)
+
+/*      QSYS:HSCH:SE_CFG */
+#define QSYS_SE_CFG(g)            __REG(TARGET_QSYS, 0, 1, 16384, g, 90, 128, 8, 0, 1, 4)
+
+#define QSYS_SE_CFG_SE_AVB_ENA                   BIT(4)
+#define QSYS_SE_CFG_SE_AVB_ENA_SET(x)\
+	FIELD_PREP(QSYS_SE_CFG_SE_AVB_ENA, x)
+#define QSYS_SE_CFG_SE_AVB_ENA_GET(x)\
+	FIELD_GET(QSYS_SE_CFG_SE_AVB_ENA, x)
+
+#define QSYS_SE_CFG_SE_FRM_MODE                  GENMASK(3, 2)
+#define QSYS_SE_CFG_SE_FRM_MODE_SET(x)\
+	FIELD_PREP(QSYS_SE_CFG_SE_FRM_MODE, x)
+#define QSYS_SE_CFG_SE_FRM_MODE_GET(x)\
+	FIELD_GET(QSYS_SE_CFG_SE_FRM_MODE, x)
+
 /*      QSYS:TAS_CONFIG:TAS_CFG_CTRL */
 #define QSYS_TAS_CFG_CTRL         __REG(TARGET_QSYS, 0, 1, 57372, 0, 1, 12, 0, 0, 1, 4)
 
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_tbf.c b/drivers/net/ethernet/microchip/lan966x/lan966x_tbf.c
new file mode 100644
index 0000000000000..4555a35d0d288
--- /dev/null
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_tbf.c
@@ -0,0 +1,85 @@
+// SPDX-License-Identifier: GPL-2.0+
+
+#include "lan966x_main.h"
+
+int lan966x_tbf_add(struct lan966x_port *port,
+		    struct tc_tbf_qopt_offload *qopt)
+{
+	struct lan966x *lan966x = port->lan966x;
+	bool root = qopt->parent == TC_H_ROOT;
+	u32 queue = 0;
+	u32 cir, cbs;
+	u32 se_idx;
+
+	if (!root) {
+		queue = TC_H_MIN(qopt->parent) - 1;
+		if (queue >= NUM_PRIO_QUEUES)
+			return -EOPNOTSUPP;
+	}
+
+	if (root)
+		se_idx = SE_IDX_PORT + port->chip_port;
+	else
+		se_idx = SE_IDX_QUEUE + port->chip_port * NUM_PRIO_QUEUES + queue;
+
+	cir = div_u64(qopt->replace_params.rate.rate_bytes_ps, 1000) * 8;
+	cbs = qopt->replace_params.max_size;
+
+	/* Rate unit is 100 kbps */
+	cir = DIV_ROUND_UP(cir, 100);
+	/* Avoid using zero rate */
+	cir = cir ?: 1;
+	/* Burst unit is 4kB */
+	cbs = DIV_ROUND_UP(cbs, 4096);
+	/* Avoid using zero burst */
+	cbs = cbs ?: 1;
+
+	/* Check that actually the result can be written */
+	if (cir > GENMASK(15, 0) ||
+	    cbs > GENMASK(6, 0))
+		return -EINVAL;
+
+	lan_rmw(QSYS_SE_CFG_SE_AVB_ENA_SET(0) |
+		QSYS_SE_CFG_SE_FRM_MODE_SET(1),
+		QSYS_SE_CFG_SE_AVB_ENA |
+		QSYS_SE_CFG_SE_FRM_MODE,
+		lan966x, QSYS_SE_CFG(se_idx));
+
+	lan_wr(QSYS_CIR_CFG_CIR_RATE_SET(cir) |
+	       QSYS_CIR_CFG_CIR_BURST_SET(cbs),
+	       lan966x, QSYS_CIR_CFG(se_idx));
+
+	return 0;
+}
+
+int lan966x_tbf_del(struct lan966x_port *port,
+		    struct tc_tbf_qopt_offload *qopt)
+{
+	struct lan966x *lan966x = port->lan966x;
+	bool root = qopt->parent == TC_H_ROOT;
+	u32 queue = 0;
+	u32 se_idx;
+
+	if (!root) {
+		queue = TC_H_MIN(qopt->parent) - 1;
+		if (queue >= NUM_PRIO_QUEUES)
+			return -EOPNOTSUPP;
+	}
+
+	if (root)
+		se_idx = SE_IDX_PORT + port->chip_port;
+	else
+		se_idx = SE_IDX_QUEUE + port->chip_port * NUM_PRIO_QUEUES + queue;
+
+	lan_rmw(QSYS_SE_CFG_SE_AVB_ENA_SET(0) |
+		QSYS_SE_CFG_SE_FRM_MODE_SET(0),
+		QSYS_SE_CFG_SE_AVB_ENA |
+		QSYS_SE_CFG_SE_FRM_MODE,
+		lan966x, QSYS_SE_CFG(se_idx));
+
+	lan_wr(QSYS_CIR_CFG_CIR_RATE_SET(0) |
+	       QSYS_CIR_CFG_CIR_BURST_SET(0),
+	       lan966x, QSYS_CIR_CFG(se_idx));
+
+	return 0;
+}
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_tc.c b/drivers/net/ethernet/microchip/lan966x/lan966x_tc.c
index cabc563f67685..ca03b7842f05f 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_tc.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_tc.c
@@ -22,6 +22,21 @@ static int lan966x_tc_setup_qdisc_taprio(struct lan966x_port *port,
 				lan966x_taprio_del(port);
 }
 
+static int lan966x_tc_setup_qdisc_tbf(struct lan966x_port *port,
+				      struct tc_tbf_qopt_offload *qopt)
+{
+	switch (qopt->command) {
+	case TC_TBF_REPLACE:
+		return lan966x_tbf_add(port, qopt);
+	case TC_TBF_DESTROY:
+		return lan966x_tbf_del(port, qopt);
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	return -EOPNOTSUPP;
+}
+
 int lan966x_tc_setup(struct net_device *dev, enum tc_setup_type type,
 		     void *type_data)
 {
@@ -32,6 +47,8 @@ int lan966x_tc_setup(struct net_device *dev, enum tc_setup_type type,
 		return lan966x_tc_setup_qdisc_mqprio(port, type_data);
 	case TC_SETUP_QDISC_TAPRIO:
 		return lan966x_tc_setup_qdisc_taprio(port, type_data);
+	case TC_SETUP_QDISC_TBF:
+		return lan966x_tc_setup_qdisc_tbf(port, type_data);
 	default:
 		return -EOPNOTSUPP;
 	}
-- 
2.33.0

