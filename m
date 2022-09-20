Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FCFD5BE29E
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 12:05:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230158AbiITKF3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 06:05:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230122AbiITKF1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 06:05:27 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC8714D176;
        Tue, 20 Sep 2022 03:05:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1663668325; x=1695204325;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Qbukx3qf1IM8ITrfV7Uk6zZZN+zzo2s2msSilYCaRxw=;
  b=lpS094vrj9S6vXFINqzvGuv5MyoTnjfwVc7V9y0SfAs3VvepPIg/kT/F
   zv44SoWDrzGcGeCiYTlQwnkl88q53Jc8QtVbfBSTUUKYWkLQgmIQZiZx2
   ANyNNfnQxTgdu4Di6vdsKzmpgg7YJZ3NyoA0Zw3JsPgFbJ1eKl+cjX2yC
   sTvPrChcEj8yZJNiqWv8lW7mWJwXPfbCk24Mdgl0/7oD8/WGtM4kNi9Eu
   zLSyErMGoqx1olKDwrPWlQ/5wk0EVmI66RuIg+/4IUtMYmceqgtVkeTS1
   c/Ra1yOSDI6Z6Eh7IsZxJ9WGh5lPwoAvZQkn+PR+fngbWFrBaMQjc9nEk
   Q==;
X-IronPort-AV: E=Sophos;i="5.93,330,1654585200"; 
   d="scan'208";a="191591341"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 20 Sep 2022 03:05:25 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Tue, 20 Sep 2022 03:05:24 -0700
Received: from DEN-LT-70577.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Tue, 20 Sep 2022 03:05:22 -0700
From:   Daniel Machon <daniel.machon@microchip.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <Steen.Hegelund@microchip.com>,
        <daniel.machon@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <casper.casan@gmail.com>, <horatiu.vultur@microchip.com>,
        <rmk+kernel@armlinux.org.uk>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Steen Hegelund <steen.hegelund@microchip.com>
Subject: [PATCH net-next v2 1/5] net: microchip: sparx5: add tc setup hook
Date:   Tue, 20 Sep 2022 12:14:28 +0200
Message-ID: <20220920101432.139323-2-daniel.machon@microchip.com>
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

Add tc setup hook for QoS features.

Signed-off-by: Daniel Machon <daniel.machon@microchip.com>
Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
---
 .../net/ethernet/microchip/sparx5/Makefile    |  2 +-
 .../ethernet/microchip/sparx5/sparx5_netdev.c |  2 ++
 .../net/ethernet/microchip/sparx5/sparx5_tc.c | 19 +++++++++++++++++++
 .../net/ethernet/microchip/sparx5/sparx5_tc.h | 15 +++++++++++++++
 4 files changed, 37 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/ethernet/microchip/sparx5/sparx5_tc.c
 create mode 100644 drivers/net/ethernet/microchip/sparx5/sparx5_tc.h

diff --git a/drivers/net/ethernet/microchip/sparx5/Makefile b/drivers/net/ethernet/microchip/sparx5/Makefile
index 4402c3ed1dc5..1d21d8ef891a 100644
--- a/drivers/net/ethernet/microchip/sparx5/Makefile
+++ b/drivers/net/ethernet/microchip/sparx5/Makefile
@@ -8,4 +8,4 @@ obj-$(CONFIG_SPARX5_SWITCH) += sparx5-switch.o
 sparx5-switch-objs  := sparx5_main.o sparx5_packet.o \
  sparx5_netdev.o sparx5_phylink.o sparx5_port.o sparx5_mactable.o sparx5_vlan.o \
  sparx5_switchdev.o sparx5_calendar.o sparx5_ethtool.o sparx5_fdma.o \
- sparx5_ptp.o sparx5_pgid.o
+ sparx5_ptp.o sparx5_pgid.o sparx5_tc.o
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_netdev.c b/drivers/net/ethernet/microchip/sparx5/sparx5_netdev.c
index af4d3e1f1a6d..c1a357f45a06 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_netdev.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_netdev.c
@@ -7,6 +7,7 @@
 #include "sparx5_main_regs.h"
 #include "sparx5_main.h"
 #include "sparx5_port.h"
+#include "sparx5_tc.h"
 
 /* The IFH bit position of the first VSTAX bit. This is because the
  * VSTAX bit positions in Data sheet is starting from zero.
@@ -228,6 +229,7 @@ static const struct net_device_ops sparx5_port_netdev_ops = {
 	.ndo_get_stats64        = sparx5_get_stats64,
 	.ndo_get_port_parent_id = sparx5_get_port_parent_id,
 	.ndo_eth_ioctl          = sparx5_port_ioctl,
+	.ndo_setup_tc           = sparx5_port_setup_tc,
 };
 
 bool sparx5_netdevice_check(const struct net_device *dev)
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_tc.c b/drivers/net/ethernet/microchip/sparx5/sparx5_tc.c
new file mode 100644
index 000000000000..1bafca0be795
--- /dev/null
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_tc.c
@@ -0,0 +1,19 @@
+// SPDX-License-Identifier: GPL-2.0+
+/* Microchip Sparx5 Switch driver
+ *
+ * Copyright (c) 2022 Microchip Technology Inc. and its subsidiaries.
+ */
+
+#include "sparx5_tc.h"
+#include "sparx5_main.h"
+
+int sparx5_port_setup_tc(struct net_device *ndev, enum tc_setup_type type,
+			 void *type_data)
+{
+	switch (type) {
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_tc.h b/drivers/net/ethernet/microchip/sparx5/sparx5_tc.h
new file mode 100644
index 000000000000..5b55e11b77e1
--- /dev/null
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_tc.h
@@ -0,0 +1,15 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
+/* Microchip Sparx5 Switch driver
+ *
+ * Copyright (c) 2022 Microchip Technology Inc. and its subsidiaries.
+ */
+
+#ifndef __SPARX5_TC_H__
+#define __SPARX5_TC_H__
+
+#include <linux/netdevice.h>
+
+int sparx5_port_setup_tc(struct net_device *ndev, enum tc_setup_type type,
+			 void *type_data);
+
+#endif	/* __SPARX5_TC_H__ */
-- 
2.34.1

