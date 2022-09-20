Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 356C55BE2A2
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 12:05:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230453AbiITKFd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 06:05:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230288AbiITKF3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 06:05:29 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92E2F543C2;
        Tue, 20 Sep 2022 03:05:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1663668328; x=1695204328;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=GG2RXi3r898YXId0gl5WrvmwwRFHWYCl4xEP6t46DK8=;
  b=wq8g+k9Kh55kOJ67eoxq99xRAlVIoOauqCCLWZ+r5a1+yX6YjGGTHZ00
   QKd2FGwxDsoGSH2o1Y5jxyv92Lm6CE+NAb7Ke8KNSNrA1mfw+QJanFbCA
   4Rds1i7740CuozGY+LMe1lNMHOgCG7cvpjyWmacxmCBKjbsbwyY0+AAa1
   MtcyEzGHX6NwP8TaUFP4VMn0d6UPJbWJqlO1p+o2INnG64kuhViEXI/wp
   JTx5Zse04dnOyTEFM00a8BqZgRrx24M/oUaQFof9h11s7FbCsYQONZxB5
   VuHj2DJUpR9F0nGQWd2p1nyWmYrfXZqLlQlHQrz0DBwt1PmJ58Xz4469C
   A==;
X-IronPort-AV: E=Sophos;i="5.93,330,1654585200"; 
   d="scan'208";a="181220989"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 20 Sep 2022 03:05:28 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Tue, 20 Sep 2022 03:05:27 -0700
Received: from DEN-LT-70577.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Tue, 20 Sep 2022 03:05:25 -0700
From:   Daniel Machon <daniel.machon@microchip.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <Steen.Hegelund@microchip.com>,
        <daniel.machon@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <casper.casan@gmail.com>, <horatiu.vultur@microchip.com>,
        <rmk+kernel@armlinux.org.uk>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Steen Hegelund <steen.hegelund@microchip.com>
Subject: [PATCH net-next v2 2/5] net: microchip: sparx5: add support for offloading mqprio qdisc
Date:   Tue, 20 Sep 2022 12:14:29 +0200
Message-ID: <20220920101432.139323-3-daniel.machon@microchip.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220920101432.139323-1-daniel.machon@microchip.com>
References: <20220920101432.139323-1-daniel.machon@microchip.com>
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

Add support for offloading mqprio qdisc to sparx5 switch.

The offloaded mqprio qdisc currently does nothing by itself, but serves
as an attachment point for other qdiscs (tbf, ets etc.)

Signed-off-by: Daniel Machon <daniel.machon@microchip.com>
Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
---
 .../net/ethernet/microchip/sparx5/Makefile    |  2 +-
 .../ethernet/microchip/sparx5/sparx5_netdev.c |  6 ++-
 .../ethernet/microchip/sparx5/sparx5_qos.c    | 39 +++++++++++++++++++
 .../ethernet/microchip/sparx5/sparx5_qos.h    | 16 ++++++++
 .../net/ethernet/microchip/sparx5/sparx5_tc.c | 16 ++++++++
 5 files changed, 77 insertions(+), 2 deletions(-)
 create mode 100644 drivers/net/ethernet/microchip/sparx5/sparx5_qos.c
 create mode 100644 drivers/net/ethernet/microchip/sparx5/sparx5_qos.h

diff --git a/drivers/net/ethernet/microchip/sparx5/Makefile b/drivers/net/ethernet/microchip/sparx5/Makefile
index 1d21d8ef891a..d1c6ad966747 100644
--- a/drivers/net/ethernet/microchip/sparx5/Makefile
+++ b/drivers/net/ethernet/microchip/sparx5/Makefile
@@ -8,4 +8,4 @@ obj-$(CONFIG_SPARX5_SWITCH) += sparx5-switch.o
 sparx5-switch-objs  := sparx5_main.o sparx5_packet.o \
  sparx5_netdev.o sparx5_phylink.o sparx5_port.o sparx5_mactable.o sparx5_vlan.o \
  sparx5_switchdev.o sparx5_calendar.o sparx5_ethtool.o sparx5_fdma.o \
- sparx5_ptp.o sparx5_pgid.o sparx5_tc.o
+ sparx5_ptp.o sparx5_pgid.o sparx5_tc.o sparx5_qos.o
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_netdev.c b/drivers/net/ethernet/microchip/sparx5/sparx5_netdev.c
index c1a357f45a06..19516ccad533 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_netdev.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_netdev.c
@@ -242,10 +242,14 @@ struct net_device *sparx5_create_netdev(struct sparx5 *sparx5, u32 portno)
 	struct sparx5_port *spx5_port;
 	struct net_device *ndev;
 
-	ndev = devm_alloc_etherdev(sparx5->dev, sizeof(struct sparx5_port));
+	ndev = devm_alloc_etherdev_mqs(sparx5->dev, sizeof(struct sparx5_port),
+				       SPX5_PRIOS, 1);
 	if (!ndev)
 		return ERR_PTR(-ENOMEM);
 
+	ndev->hw_features |= NETIF_F_HW_TC;
+	ndev->features |= NETIF_F_HW_TC;
+
 	SET_NETDEV_DEV(ndev, sparx5->dev);
 	spx5_port = netdev_priv(ndev);
 	spx5_port->ndev = ndev;
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_qos.c b/drivers/net/ethernet/microchip/sparx5/sparx5_qos.c
new file mode 100644
index 000000000000..3c6d67256166
--- /dev/null
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_qos.c
@@ -0,0 +1,39 @@
+// SPDX-License-Identifier: GPL-2.0+
+/* Microchip Sparx5 Switch driver
+ *
+ * Copyright (c) 2022 Microchip Technology Inc. and its subsidiaries.
+ */
+
+#include "sparx5_main.h"
+#include "sparx5_qos.h"
+
+int sparx5_tc_mqprio_add(struct net_device *ndev, u8 num_tc)
+{
+	int i;
+
+	if (num_tc != SPX5_PRIOS) {
+		netdev_err(ndev, "Only %d traffic classes supported\n",
+			   SPX5_PRIOS);
+		return -EINVAL;
+	}
+
+	netdev_set_num_tc(ndev, num_tc);
+
+	for (i = 0; i < num_tc; i++)
+		netdev_set_tc_queue(ndev, i, 1, i);
+
+	netdev_dbg(ndev, "dev->num_tc %u dev->real_num_tx_queues %u\n",
+		   ndev->num_tc, ndev->real_num_tx_queues);
+
+	return 0;
+}
+
+int sparx5_tc_mqprio_del(struct net_device *ndev)
+{
+	netdev_reset_tc(ndev);
+
+	netdev_dbg(ndev, "dev->num_tc %u dev->real_num_tx_queues %u\n",
+		   ndev->num_tc, ndev->real_num_tx_queues);
+
+	return 0;
+}
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_qos.h b/drivers/net/ethernet/microchip/sparx5/sparx5_qos.h
new file mode 100644
index 000000000000..0572fb41c949
--- /dev/null
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_qos.h
@@ -0,0 +1,16 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
+/* Microchip Sparx5 Switch driver
+ *
+ * Copyright (c) 2022 Microchip Technology Inc. and its subsidiaries.
+ */
+
+#ifndef __SPARX5_QOS_H__
+#define __SPARX5_QOS_H__
+
+#include <linux/netdevice.h>
+
+/* Multi-Queue Priority */
+int sparx5_tc_mqprio_add(struct net_device *ndev, u8 num_tc);
+int sparx5_tc_mqprio_del(struct net_device *ndev);
+
+#endif	/* __SPARX5_QOS_H__ */
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_tc.c b/drivers/net/ethernet/microchip/sparx5/sparx5_tc.c
index 1bafca0be795..6e01a7c7c821 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_tc.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_tc.c
@@ -4,13 +4,29 @@
  * Copyright (c) 2022 Microchip Technology Inc. and its subsidiaries.
  */
 
+#include <net/pkt_cls.h>
+
 #include "sparx5_tc.h"
 #include "sparx5_main.h"
+#include "sparx5_qos.h"
+
+static int sparx5_tc_setup_qdisc_mqprio(struct net_device *ndev,
+					struct tc_mqprio_qopt_offload *m)
+{
+	m->qopt.hw = TC_MQPRIO_HW_OFFLOAD_TCS;
+
+	if (m->qopt.num_tc == 0)
+		return sparx5_tc_mqprio_del(ndev);
+	else
+		return sparx5_tc_mqprio_add(ndev, m->qopt.num_tc);
+}
 
 int sparx5_port_setup_tc(struct net_device *ndev, enum tc_setup_type type,
 			 void *type_data)
 {
 	switch (type) {
+	case TC_SETUP_QDISC_MQPRIO:
+		return sparx5_tc_setup_qdisc_mqprio(ndev, type_data);
 	default:
 		return -EOPNOTSUPP;
 	}
-- 
2.34.1

