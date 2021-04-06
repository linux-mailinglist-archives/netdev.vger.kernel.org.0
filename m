Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 652123550BF
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 12:22:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245064AbhDFKWw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 06:22:52 -0400
Received: from mga09.intel.com ([134.134.136.24]:7876 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236042AbhDFKWv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Apr 2021 06:22:51 -0400
IronPort-SDR: nd4DcoC8MdSf1UiF3gRGrOJ5nWY8PwMnMyv+Dw+KIoS5lmAUKnaK+rDED9cGeNRnURcfKd684J
 NTuqVwSakeYQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9945"; a="193148087"
X-IronPort-AV: E=Sophos;i="5.81,309,1610438400"; 
   d="scan'208";a="193148087"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2021 03:22:42 -0700
IronPort-SDR: Ce8QKxGNyzHd2lPlXwfiSMXekdbtn8cBvZCtxDo1xUlIs0JyxUBkEIKqyZyXArDNTyhE52Y3TN
 FnFXKJeLrUTQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,309,1610438400"; 
   d="scan'208";a="448512067"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga002.fm.intel.com with ESMTP; 06 Apr 2021 03:22:38 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id D7376202; Tue,  6 Apr 2021 13:22:53 +0300 (EEST)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Yangbo Lu <yangbo.lu@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-phy@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org
Cc:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Jakub Kicinski <kuba@kernel.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Vinod Koul <vkoul@kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>
Subject: [PATCH v2 1/1] time64.h: Consolidated PSEC_PER_SEC definition
Date:   Tue,  6 Apr 2021 13:22:51 +0300
Message-Id: <20210406102251.60301-1-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.30.2
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
Acked-by: Heiko Stuebner <heiko@sntech.de>
---
v2: added tag (Heiko), rebased on top of newest rc

Since it touches PHY stuff, I assume that the PHY tree is the best
to suck this.

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
2.30.2

