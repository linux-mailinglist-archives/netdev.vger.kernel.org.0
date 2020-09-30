Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A6C027E70E
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 12:51:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728514AbgI3KvV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 06:51:21 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:42389 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725872AbgI3KvT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 06:51:19 -0400
X-Originating-IP: 90.65.88.165
Received: from localhost (lfbn-lyo-1-1908-165.w90-65.abo.wanadoo.fr [90.65.88.165])
        (Authenticated sender: alexandre.belloni@bootlin.com)
        by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id 958276000E;
        Wed, 30 Sep 2020 10:51:16 +0000 (UTC)
From:   Alexandre Belloni <alexandre.belloni@bootlin.com>
To:     Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next] net: macb: move pdata to private header
Date:   Wed, 30 Sep 2020 12:50:59 +0200
Message-Id: <20200930105100.2956042-1-alexandre.belloni@bootlin.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Flag: yes
X-Spam-Level: **************************
X-GND-Spam-Score: 400
X-GND-Status: SPAM
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

struct macb_platform_data is only used by macb_pci to register the platform
device, move its definition to cadence/macb.h and remove platform_data/macb.h

Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
---
 drivers/net/ethernet/cadence/macb.h      | 11 +++++++++++
 drivers/net/ethernet/cadence/macb_main.c |  1 -
 drivers/net/ethernet/cadence/macb_pci.c  |  1 -
 include/linux/platform_data/macb.h       | 20 --------------------
 4 files changed, 11 insertions(+), 22 deletions(-)
 delete mode 100644 include/linux/platform_data/macb.h

diff --git a/drivers/net/ethernet/cadence/macb.h b/drivers/net/ethernet/cadence/macb.h
index 4f1b41569260..3fd5c6cc23af 100644
--- a/drivers/net/ethernet/cadence/macb.h
+++ b/drivers/net/ethernet/cadence/macb.h
@@ -7,6 +7,7 @@
 #ifndef _MACB_H
 #define _MACB_H
 
+#include <linux/clk.h>
 #include <linux/phylink.h>
 #include <linux/ptp_clock_kernel.h>
 #include <linux/net_tstamp.h>
@@ -1298,4 +1299,14 @@ static inline bool gem_has_ptp(struct macb *bp)
 	return !!(bp->caps & MACB_CAPS_GEM_HAS_PTP);
 }
 
+/**
+ * struct macb_platform_data - platform data for MACB Ethernet used for PCI registration
+ * @pclk:		platform clock
+ * @hclk:		AHB clock
+ */
+struct macb_platform_data {
+	struct clk	*pclk;
+	struct clk	*hclk;
+};
+
 #endif /* _MACB_H */
diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index f00ad73ea8e3..4b42b2d6398c 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -23,7 +23,6 @@
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
 #include <linux/dma-mapping.h>
-#include <linux/platform_data/macb.h>
 #include <linux/platform_device.h>
 #include <linux/phylink.h>
 #include <linux/of.h>
diff --git a/drivers/net/ethernet/cadence/macb_pci.c b/drivers/net/ethernet/cadence/macb_pci.c
index 35316c91f523..353393dea639 100644
--- a/drivers/net/ethernet/cadence/macb_pci.c
+++ b/drivers/net/ethernet/cadence/macb_pci.c
@@ -13,7 +13,6 @@
 #include <linux/etherdevice.h>
 #include <linux/module.h>
 #include <linux/pci.h>
-#include <linux/platform_data/macb.h>
 #include <linux/platform_device.h>
 #include "macb.h"
 
diff --git a/include/linux/platform_data/macb.h b/include/linux/platform_data/macb.h
deleted file mode 100644
index aa5b5562d6f7..000000000000
--- a/include/linux/platform_data/macb.h
+++ /dev/null
@@ -1,20 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0-only */
-/*
- * Copyright (C) 2004-2006 Atmel Corporation
- */
-#ifndef __MACB_PDATA_H__
-#define __MACB_PDATA_H__
-
-#include <linux/clk.h>
-
-/**
- * struct macb_platform_data - platform data for MACB Ethernet
- * @pclk:		platform clock
- * @hclk:		AHB clock
- */
-struct macb_platform_data {
-	struct clk	*pclk;
-	struct clk	*hclk;
-};
-
-#endif /* __MACB_PDATA_H__ */
-- 
2.26.2

