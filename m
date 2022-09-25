Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7769C5E9574
	for <lists+netdev@lfdr.de>; Sun, 25 Sep 2022 20:44:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233060AbiIYSoC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Sep 2022 14:44:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232911AbiIYSn7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Sep 2022 14:43:59 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 356052BB11;
        Sun, 25 Sep 2022 11:43:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1664131439; x=1695667439;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VBQtjjcrTK7mwX/oS7iE3MG3Uz5ZFhiEyItlldgGuhw=;
  b=B8viJUZLuqjNlOJEio6UvSh42qVg73+IYTesc8Mm+Sl6bR8sOUMZ0bBd
   RFrz6kVTb4ydGPtRn9H73gsGziKSiOnwE8eNfKA6JgBGM0x3f+gB9HayR
   4QmVro70ky1DvC06GTXtnqo296Wq6e88K7X+86J25rpCY6ptjnfv6APEh
   GwozVvte3/AUaDgk1L4jjVl74203hYWG3PFb1AXuJHXhUPLYnSPKncNOX
   DvH+uTXUdgNZDpFhxYodpXa7W/Swc2SZeyggGj2QaSsj8Q1Ip1vdP2CBw
   jx3S5D2roFRBg+nlTFh8ldtZfOV6TOWjVQtSkKy4CSJ+bCBwKEvDBg148
   Q==;
X-IronPort-AV: E=Sophos;i="5.93,344,1654585200"; 
   d="scan'208";a="175499144"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 25 Sep 2022 11:43:58 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Sun, 25 Sep 2022 11:43:57 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Sun, 25 Sep 2022 11:43:55 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <UNGLinuxDriver@microchip.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next 2/3] net: lan966x: Add offload support for cbs
Date:   Sun, 25 Sep 2022 20:46:32 +0200
Message-ID: <20220925184633.4148143-3-horatiu.vultur@microchip.com>
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

Lan966x switch supports credit based shaper in hardware according to
IEEE Std 802.1Q-2018 Section 8.6.8.2. Add support for cbs configuration
on egress port of lan966x switch.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 .../net/ethernet/microchip/lan966x/Makefile   |  2 +-
 .../ethernet/microchip/lan966x/lan966x_cbs.c  | 70 +++++++++++++++++++
 .../ethernet/microchip/lan966x/lan966x_main.h |  5 ++
 .../ethernet/microchip/lan966x/lan966x_tc.c   |  9 +++
 4 files changed, 85 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_cbs.c

diff --git a/drivers/net/ethernet/microchip/lan966x/Makefile b/drivers/net/ethernet/microchip/lan966x/Makefile
index a3a519d10c73d..bc76949d1fd8f 100644
--- a/drivers/net/ethernet/microchip/lan966x/Makefile
+++ b/drivers/net/ethernet/microchip/lan966x/Makefile
@@ -10,4 +10,4 @@ lan966x-switch-objs  := lan966x_main.o lan966x_phylink.o lan966x_port.o \
 			lan966x_vlan.o lan966x_fdb.o lan966x_mdb.o \
 			lan966x_ptp.o lan966x_fdma.o lan966x_lag.o \
 			lan966x_tc.o lan966x_mqprio.o lan966x_taprio.o \
-			lan966x_tbf.o
+			lan966x_tbf.o lan966x_cbs.o
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_cbs.c b/drivers/net/ethernet/microchip/lan966x/lan966x_cbs.c
new file mode 100644
index 0000000000000..70cbbf8d2b67b
--- /dev/null
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_cbs.c
@@ -0,0 +1,70 @@
+// SPDX-License-Identifier: GPL-2.0+
+
+#include "lan966x_main.h"
+
+int lan966x_cbs_add(struct lan966x_port *port,
+		    struct tc_cbs_qopt_offload *qopt)
+{
+	struct lan966x *lan966x = port->lan966x;
+	u32 cir, cbs;
+	u8 se_idx;
+
+	/* Check for invalid values */
+	if (qopt->idleslope <= 0 ||
+	    qopt->sendslope >= 0 ||
+	    qopt->locredit >= qopt->hicredit)
+		return -EINVAL;
+
+	se_idx = SE_IDX_QUEUE + port->chip_port * NUM_PRIO_QUEUES + qopt->queue;
+	cir = qopt->idleslope;
+	cbs = (qopt->idleslope - qopt->sendslope) *
+		(qopt->hicredit - qopt->locredit) /
+		-qopt->sendslope;
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
+	lan_rmw(QSYS_SE_CFG_SE_AVB_ENA_SET(1) |
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
+int lan966x_cbs_del(struct lan966x_port *port,
+		    struct tc_cbs_qopt_offload *qopt)
+{
+	struct lan966x *lan966x = port->lan966x;
+	u8 se_idx;
+
+	se_idx = SE_IDX_QUEUE + port->chip_port * NUM_PRIO_QUEUES + qopt->queue;
+
+	lan_rmw(QSYS_SE_CFG_SE_AVB_ENA_SET(1) |
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
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
index 59f5a6b2b3bc0..168456f693bb7 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
@@ -471,6 +471,11 @@ int lan966x_tbf_add(struct lan966x_port *port,
 int lan966x_tbf_del(struct lan966x_port *port,
 		    struct tc_tbf_qopt_offload *qopt);
 
+int lan966x_cbs_add(struct lan966x_port *port,
+		    struct tc_cbs_qopt_offload *qopt);
+int lan966x_cbs_del(struct lan966x_port *port,
+		    struct tc_cbs_qopt_offload *qopt);
+
 static inline void __iomem *lan_addr(void __iomem *base[],
 				     int id, int tinst, int tcnt,
 				     int gbase, int ginst,
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_tc.c b/drivers/net/ethernet/microchip/lan966x/lan966x_tc.c
index ca03b7842f05f..4b05535c9e029 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_tc.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_tc.c
@@ -37,6 +37,13 @@ static int lan966x_tc_setup_qdisc_tbf(struct lan966x_port *port,
 	return -EOPNOTSUPP;
 }
 
+static int lan966x_tc_setup_qdisc_cbs(struct lan966x_port *port,
+				      struct tc_cbs_qopt_offload *qopt)
+{
+	return qopt->enable ? lan966x_cbs_add(port, qopt) :
+			      lan966x_cbs_del(port, qopt);
+}
+
 int lan966x_tc_setup(struct net_device *dev, enum tc_setup_type type,
 		     void *type_data)
 {
@@ -49,6 +56,8 @@ int lan966x_tc_setup(struct net_device *dev, enum tc_setup_type type,
 		return lan966x_tc_setup_qdisc_taprio(port, type_data);
 	case TC_SETUP_QDISC_TBF:
 		return lan966x_tc_setup_qdisc_tbf(port, type_data);
+	case TC_SETUP_QDISC_CBS:
+		return lan966x_tc_setup_qdisc_cbs(port, type_data);
 	default:
 		return -EOPNOTSUPP;
 	}
-- 
2.33.0

