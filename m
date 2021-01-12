Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16A0B2F3453
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 16:39:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391806AbhALPjE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 10:39:04 -0500
Received: from mga14.intel.com ([192.55.52.115]:12585 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390851AbhALPjE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 10:39:04 -0500
IronPort-SDR: LodLkzXmCVV5Cs98JIqp6F626S9tWoq+05NKQFTEPYI3+yz8eh+BSJxmDkanFwXX9I4ad2v6uf
 bmHpmgHsZBPQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9862"; a="177280012"
X-IronPort-AV: E=Sophos;i="5.79,341,1602572400"; 
   d="scan'208";a="177280012"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2021 07:37:17 -0800
IronPort-SDR: akgMo6XR+8tzhNtWbWQLzgknr1gHR52ficSsRH7EcFyLANSNYGjQxYq3ntLw+7oYa1+U2zqX22
 kCTqZmukDoDw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,341,1602572400"; 
   d="scan'208";a="348488753"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga003.jf.intel.com with ESMTP; 12 Jan 2021 07:37:13 -0800
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id 42E0E11C; Tue, 12 Jan 2021 17:37:11 +0200 (EET)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Vinod Koul <vkoul@kernel.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Yangbo Lu <yangbo.lu@nxp.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Gwendal Grignou <gwendal@chromium.org>,
        linux-iio <linux-iio@vger.kernel.org>
Subject: [PATCH v1 1/1] time64.h: Consolidated PSEC_PER_SEC definition
Date:   Tue, 12 Jan 2021 17:37:09 +0200
Message-Id: <20210112153709.1074-1-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We have currently three users of the PSEC_PER_SEC each of them defining it
individually. Instead, move it to time64.h to be available for everyone.

There is a new user coming with the same constant in use. It will also
make its life easier.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/net/ethernet/mscc/ocelot_ptp.c           | 2 ++
 drivers/phy/phy-core-mipi-dphy.c                 | 2 --
 drivers/phy/rockchip/phy-rockchip-inno-dsidphy.c | 8 ++++----
 include/soc/mscc/ocelot_ptp.h                    | 2 --
 include/vdso/time64.h                            | 1 +
 5 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_ptp.c b/drivers/net/ethernet/mscc/ocelot_ptp.c
index a33ab315cc6b..87ad2137ba06 100644
--- a/drivers/net/ethernet/mscc/ocelot_ptp.c
+++ b/drivers/net/ethernet/mscc/ocelot_ptp.c
@@ -4,6 +4,8 @@
  * Copyright (c) 2017 Microsemi Corporation
  * Copyright 2020 NXP
  */
+#include <linux/time64.h>
+
 #include <soc/mscc/ocelot_ptp.h>
 #include <soc/mscc/ocelot_sys.h>
 #include <soc/mscc/ocelot.h>
diff --git a/drivers/phy/phy-core-mipi-dphy.c b/drivers/phy/phy-core-mipi-dphy.c
index 14e0551cd319..77fe65367ce5 100644
--- a/drivers/phy/phy-core-mipi-dphy.c
+++ b/drivers/phy/phy-core-mipi-dphy.c
@@ -12,8 +12,6 @@
 #include <linux/phy/phy.h>
 #include <linux/phy/phy-mipi-dphy.h>
 
-#define PSEC_PER_SEC	1000000000000LL
-
 /*
  * Minimum D-PHY timings based on MIPI D-PHY specification. Derived
  * from the valid ranges specified in Section 6.9, Table 14, Page 41
diff --git a/drivers/phy/rockchip/phy-rockchip-inno-dsidphy.c b/drivers/phy/rockchip/phy-rockchip-inno-dsidphy.c
index 8af8c6c5cc02..347dc79a18c1 100644
--- a/drivers/phy/rockchip/phy-rockchip-inno-dsidphy.c
+++ b/drivers/phy/rockchip/phy-rockchip-inno-dsidphy.c
@@ -11,16 +11,16 @@
 #include <linux/clk-provider.h>
 #include <linux/delay.h>
 #include <linux/init.h>
+#include <linux/mfd/syscon.h>
 #include <linux/module.h>
 #include <linux/of_device.h>
 #include <linux/platform_device.h>
+#include <linux/pm_runtime.h>
 #include <linux/reset.h>
+#include <linux/time64.h>
+
 #include <linux/phy/phy.h>
 #include <linux/phy/phy-mipi-dphy.h>
-#include <linux/pm_runtime.h>
-#include <linux/mfd/syscon.h>
-
-#define PSEC_PER_SEC	1000000000000LL
 
 #define UPDATE(x, h, l)	(((x) << (l)) & GENMASK((h), (l)))
 
diff --git a/include/soc/mscc/ocelot_ptp.h b/include/soc/mscc/ocelot_ptp.h
index 6a7388fa7cc5..ded497d72bdb 100644
--- a/include/soc/mscc/ocelot_ptp.h
+++ b/include/soc/mscc/ocelot_ptp.h
@@ -37,8 +37,6 @@ enum {
 
 #define PTP_CFG_MISC_PTP_EN		BIT(2)
 
-#define PSEC_PER_SEC			1000000000000LL
-
 #define PTP_CFG_CLK_ADJ_CFG_ENA		BIT(0)
 #define PTP_CFG_CLK_ADJ_CFG_DIR		BIT(1)
 
diff --git a/include/vdso/time64.h b/include/vdso/time64.h
index 9d43c3f5e89d..b40cfa2aa33c 100644
--- a/include/vdso/time64.h
+++ b/include/vdso/time64.h
@@ -9,6 +9,7 @@
 #define NSEC_PER_MSEC	1000000L
 #define USEC_PER_SEC	1000000L
 #define NSEC_PER_SEC	1000000000L
+#define PSEC_PER_SEC	1000000000000LL
 #define FSEC_PER_SEC	1000000000000000LL
 
 #endif /* __VDSO_TIME64_H */
-- 
2.29.2

