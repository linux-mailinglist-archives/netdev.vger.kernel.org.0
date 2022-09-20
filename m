Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E54665BE0FB
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 10:59:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231513AbiITI6Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 04:58:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230494AbiITI5p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 04:57:45 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9EBE4D83F;
        Tue, 20 Sep 2022 01:57:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1663664258; x=1695200258;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8OC9b3jGtLTo5fQqF/gbyYlo9oJbmcCkXp8d0PC3Uu4=;
  b=RXb1KSsL28RGYKHKmWgXRp9G9dEghI3KqB3VAAB5Z/elu1oKz50OtNyX
   DS1ZXd69+QA11/QD68ZtTD0wwBVVeTSfKZoFIkj2+9ZpmRXHJgjTCg225
   CW++B3z+kC8qwSNjsyTwt3UAoKQKdtmdhHGHvlepmi7kvp3iHcQ45+G/T
   9vJMIblLtq3ofoipmu1hmfSnyTyA+sfqMeF/cGdVQh0H29DKVHKUWFmnJ
   Fbi/QarOOpRc7B9fun9+ZRs56MlZLBezSsOQLEsykVhUW8lMY3fGPnBL8
   qweES09c1cFQawIR0gy7tQXM9PUYtx0vrKYEFIDScyerz/qmaoREUCGGg
   w==;
X-IronPort-AV: E=Sophos;i="5.93,330,1654585200"; 
   d="scan'208";a="191583103"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 20 Sep 2022 01:57:38 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Tue, 20 Sep 2022 01:57:38 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Tue, 20 Sep 2022 01:57:36 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <UNGLinuxDriver@microchip.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next 2/4] net: lan966x: Add offload support for mqprio
Date:   Tue, 20 Sep 2022 11:00:08 +0200
Message-ID: <20220920090010.305172-3-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220920090010.305172-1-horatiu.vultur@microchip.com>
References: <20220920090010.305172-1-horatiu.vultur@microchip.com>
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

Implement mqprio qdisc support using tc command.
The HW supports 8 priority queues from highest (7) to lowest (0).

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 .../net/ethernet/microchip/lan966x/Makefile   |  3 +-
 .../ethernet/microchip/lan966x/lan966x_main.c |  5 ++-
 .../ethernet/microchip/lan966x/lan966x_main.h |  6 ++++
 .../microchip/lan966x/lan966x_mqprio.c        | 28 +++++++++++++++++
 .../ethernet/microchip/lan966x/lan966x_tc.c   | 31 +++++++++++++++++++
 5 files changed, 71 insertions(+), 2 deletions(-)
 create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_mqprio.c
 create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_tc.c

diff --git a/drivers/net/ethernet/microchip/lan966x/Makefile b/drivers/net/ethernet/microchip/lan966x/Makefile
index 0c22c86bdaa9d..2ea66b94abac9 100644
--- a/drivers/net/ethernet/microchip/lan966x/Makefile
+++ b/drivers/net/ethernet/microchip/lan966x/Makefile
@@ -8,4 +8,5 @@ obj-$(CONFIG_LAN966X_SWITCH) += lan966x-switch.o
 lan966x-switch-objs  := lan966x_main.o lan966x_phylink.o lan966x_port.o \
 			lan966x_mac.o lan966x_ethtool.o lan966x_switchdev.o \
 			lan966x_vlan.o lan966x_fdb.o lan966x_mdb.o \
-			lan966x_ptp.o lan966x_fdma.o lan966x_lag.o
+			lan966x_ptp.o lan966x_fdma.o lan966x_lag.o \
+			lan966x_tc.o lan966x_mqprio.o
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
index ee9b8ebba6d0a..033120a5b056c 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
@@ -466,6 +466,7 @@ static const struct net_device_ops lan966x_port_netdev_ops = {
 	.ndo_set_mac_address		= lan966x_port_set_mac_address,
 	.ndo_get_port_parent_id		= lan966x_port_get_parent_id,
 	.ndo_eth_ioctl			= lan966x_port_ioctl,
+	.ndo_setup_tc			= lan966x_tc_setup,
 };
 
 bool lan966x_netdevice_check(const struct net_device *dev)
@@ -755,7 +756,9 @@ static int lan966x_probe_port(struct lan966x *lan966x, u32 p,
 	dev->netdev_ops = &lan966x_port_netdev_ops;
 	dev->ethtool_ops = &lan966x_ethtool_ops;
 	dev->features |= NETIF_F_HW_VLAN_CTAG_TX |
-			 NETIF_F_HW_VLAN_STAG_TX;
+			 NETIF_F_HW_VLAN_STAG_TX |
+			 NETIF_F_HW_TC;
+	dev->hw_features |= NETIF_F_HW_TC;
 	dev->needed_headroom = IFH_LEN * sizeof(u32);
 
 	eth_hw_addr_gen(dev, lan966x->base_mac, p + 1);
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
index a5d5987852d46..b037b1feec8f3 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
@@ -446,6 +446,12 @@ void lan966x_port_ageing_set(struct lan966x_port *port,
 			     unsigned long ageing_clock_t);
 void lan966x_update_fwd_mask(struct lan966x *lan966x);
 
+int lan966x_tc_setup(struct net_device *dev, enum tc_setup_type type,
+		     void *type_data);
+
+int lan966x_mqprio_add(struct lan966x_port *port, u8 num_tc);
+int lan966x_mqprio_del(struct lan966x_port *port);
+
 static inline void __iomem *lan_addr(void __iomem *base[],
 				     int id, int tinst, int tcnt,
 				     int gbase, int ginst,
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_mqprio.c b/drivers/net/ethernet/microchip/lan966x/lan966x_mqprio.c
new file mode 100644
index 0000000000000..950ea4807eb6a
--- /dev/null
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_mqprio.c
@@ -0,0 +1,28 @@
+// SPDX-License-Identifier: GPL-2.0+
+
+#include "lan966x_main.h"
+
+int lan966x_mqprio_add(struct lan966x_port *port, u8 num_tc)
+{
+	u8 i;
+
+	if (num_tc != NUM_PRIO_QUEUES) {
+		netdev_err(port->dev, "Only %d tarffic classes supported\n",
+			   NUM_PRIO_QUEUES);
+		return -EINVAL;
+	}
+
+	netdev_set_num_tc(port->dev, num_tc);
+
+	for (i = 0; i < num_tc; ++i)
+		netdev_set_tc_queue(port->dev, i, 1, i);
+
+	return 0;
+}
+
+int lan966x_mqprio_del(struct lan966x_port *port)
+{
+	netdev_reset_tc(port->dev);
+
+	return 0;
+}
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_tc.c b/drivers/net/ethernet/microchip/lan966x/lan966x_tc.c
new file mode 100644
index 0000000000000..3fea0937076e1
--- /dev/null
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_tc.c
@@ -0,0 +1,31 @@
+// SPDX-License-Identifier: GPL-2.0+
+
+#include <net/pkt_cls.h>
+
+#include "lan966x_main.h"
+
+static int lan966x_tc_setup_qdisc_mqprio(struct lan966x_port *port,
+					 struct tc_mqprio_qopt_offload *mqprio)
+{
+	u8 num_tc = mqprio->qopt.num_tc;
+
+	mqprio->qopt.hw = TC_MQPRIO_HW_OFFLOAD_TCS;
+
+	return num_tc ? lan966x_mqprio_add(port, num_tc) :
+			lan966x_mqprio_del(port);
+}
+
+int lan966x_tc_setup(struct net_device *dev, enum tc_setup_type type,
+		     void *type_data)
+{
+	struct lan966x_port *port = netdev_priv(dev);
+
+	switch (type) {
+	case TC_SETUP_QDISC_MQPRIO:
+		return lan966x_tc_setup_qdisc_mqprio(port, type_data);
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
-- 
2.33.0

