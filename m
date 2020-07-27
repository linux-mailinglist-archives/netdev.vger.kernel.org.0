Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDAF122E8D1
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 11:23:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728062AbgG0JXg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 05:23:36 -0400
Received: from mga03.intel.com ([134.134.136.65]:48794 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726315AbgG0JXf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jul 2020 05:23:35 -0400
IronPort-SDR: rXdAnPCGbHBXGz+zDR+nGPtps4IAmLJ+IzadL8DsAy580XenKd1MNsWtkIW0iDAvTQSEI+O1P4
 nNxsyGO67bpg==
X-IronPort-AV: E=McAfee;i="6000,8403,9694"; a="150962788"
X-IronPort-AV: E=Sophos;i="5.75,402,1589266800"; 
   d="scan'208";a="150962788"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jul 2020 02:23:33 -0700
IronPort-SDR: rz6WvxkuVVDxz9wU5c7RZtQu6M00To/E+Z1yThkoKTFg9uprg0/IJYwewtfHoBLoaPtEFpe7dY
 +f/inosEGK6w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,402,1589266800"; 
   d="scan'208";a="303393918"
Received: from pg-nxl3.altera.com ([10.142.129.93])
  by orsmga002.jf.intel.com with ESMTP; 27 Jul 2020 02:23:30 -0700
From:   "Ooi, Joyce" <joyce.ooi@intel.com>
To:     Thor Thayer <thor.thayer@linux.intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dalon Westergreen <dalon.westergreen@linux.intel.com>,
        Joyce Ooi <joyce.ooi@intel.com>,
        Tan Ley Foon <ley.foon.tan@intel.com>,
        See Chin Liang <chin.liang.see@intel.com>,
        Dinh Nguyen <dinh.nguyen@intel.com>,
        Dalon Westergreen <dalon.westergreen@intel.com>
Subject: [PATCH v5 05/10] net: eth: altera: Move common functions to altera_utils
Date:   Mon, 27 Jul 2020 17:21:52 +0800
Message-Id: <20200727092157.115937-6-joyce.ooi@intel.com>
X-Mailer: git-send-email 2.13.0
In-Reply-To: <20200727092157.115937-1-joyce.ooi@intel.com>
References: <20200727092157.115937-1-joyce.ooi@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dalon Westergreen <dalon.westergreen@intel.com>

Move request_and_map and other shared functions to altera_utils. This
is the first step to moving common code out of tse specific code so
that it can be shared with future altera ethernet ip.

Signed-off-by: Dalon Westergreen <dalon.westergreen@intel.com>
Signed-off-by: Joyce Ooi <joyce.ooi@intel.com>
Reviewed-by: Thor Thayer <thor.thayer@linux.intel.com>
---
v2: no change
v3: no change
v4: no change
v5: no change
---
 drivers/net/ethernet/altera/altera_tse.h         | 45 ---------------------
 drivers/net/ethernet/altera/altera_tse_ethtool.c |  1 +
 drivers/net/ethernet/altera/altera_tse_main.c    | 32 +--------------
 drivers/net/ethernet/altera/altera_utils.c       | 29 ++++++++++++++
 drivers/net/ethernet/altera/altera_utils.h       | 51 ++++++++++++++++++++++++
 5 files changed, 82 insertions(+), 76 deletions(-)

diff --git a/drivers/net/ethernet/altera/altera_tse.h b/drivers/net/ethernet/altera/altera_tse.h
index 26c5541fda27..fa24ab3c7d6a 100644
--- a/drivers/net/ethernet/altera/altera_tse.h
+++ b/drivers/net/ethernet/altera/altera_tse.h
@@ -489,49 +489,4 @@ struct altera_tse_private {
  */
 void altera_tse_set_ethtool_ops(struct net_device *);
 
-static inline
-u32 csrrd32(void __iomem *mac, size_t offs)
-{
-	void __iomem *paddr = (void __iomem *)((uintptr_t)mac + offs);
-	return readl(paddr);
-}
-
-static inline
-u16 csrrd16(void __iomem *mac, size_t offs)
-{
-	void __iomem *paddr = (void __iomem *)((uintptr_t)mac + offs);
-	return readw(paddr);
-}
-
-static inline
-u8 csrrd8(void __iomem *mac, size_t offs)
-{
-	void __iomem *paddr = (void __iomem *)((uintptr_t)mac + offs);
-	return readb(paddr);
-}
-
-static inline
-void csrwr32(u32 val, void __iomem *mac, size_t offs)
-{
-	void __iomem *paddr = (void __iomem *)((uintptr_t)mac + offs);
-
-	writel(val, paddr);
-}
-
-static inline
-void csrwr16(u16 val, void __iomem *mac, size_t offs)
-{
-	void __iomem *paddr = (void __iomem *)((uintptr_t)mac + offs);
-
-	writew(val, paddr);
-}
-
-static inline
-void csrwr8(u8 val, void __iomem *mac, size_t offs)
-{
-	void __iomem *paddr = (void __iomem *)((uintptr_t)mac + offs);
-
-	writeb(val, paddr);
-}
-
 #endif /* __ALTERA_TSE_H__ */
diff --git a/drivers/net/ethernet/altera/altera_tse_ethtool.c b/drivers/net/ethernet/altera/altera_tse_ethtool.c
index 4299f1301149..420d77f00eab 100644
--- a/drivers/net/ethernet/altera/altera_tse_ethtool.c
+++ b/drivers/net/ethernet/altera/altera_tse_ethtool.c
@@ -22,6 +22,7 @@
 #include <linux/phy.h>
 
 #include "altera_tse.h"
+#include "altera_utils.h"
 
 #define TSE_STATS_LEN	31
 #define TSE_NUM_REGS	128
diff --git a/drivers/net/ethernet/altera/altera_tse_main.c b/drivers/net/ethernet/altera/altera_tse_main.c
index 0a724e4d2c8c..c9100ce24b0a 100644
--- a/drivers/net/ethernet/altera/altera_tse_main.c
+++ b/drivers/net/ethernet/altera/altera_tse_main.c
@@ -23,7 +23,6 @@
 #include <linux/if_vlan.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
-#include <linux/io.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/mii.h>
@@ -33,7 +32,7 @@
 #include <linux/of_net.h>
 #include <linux/of_platform.h>
 #include <linux/phy.h>
-#include <linux/platform_device.h>
+#include <linux/ptp_classify.h>
 #include <linux/skbuff.h>
 #include <asm/cacheflush.h>
 
@@ -1320,35 +1319,6 @@ static struct net_device_ops altera_tse_netdev_ops = {
 	.ndo_validate_addr	= eth_validate_addr,
 };
 
-static int request_and_map(struct platform_device *pdev, const char *name,
-			   struct resource **res, void __iomem **ptr)
-{
-	struct resource *region;
-	struct device *device = &pdev->dev;
-
-	*res = platform_get_resource_byname(pdev, IORESOURCE_MEM, name);
-	if (*res == NULL) {
-		dev_err(device, "resource %s not defined\n", name);
-		return -ENODEV;
-	}
-
-	region = devm_request_mem_region(device, (*res)->start,
-					 resource_size(*res), dev_name(device));
-	if (region == NULL) {
-		dev_err(device, "unable to request %s\n", name);
-		return -EBUSY;
-	}
-
-	*ptr = devm_ioremap(device, region->start,
-				    resource_size(region));
-	if (*ptr == NULL) {
-		dev_err(device, "ioremap of %s failed!", name);
-		return -ENOMEM;
-	}
-
-	return 0;
-}
-
 /* Probe Altera TSE MAC device
  */
 static int altera_tse_probe(struct platform_device *pdev)
diff --git a/drivers/net/ethernet/altera/altera_utils.c b/drivers/net/ethernet/altera/altera_utils.c
index e6a7fc9d8fb1..c9bc7d0ea02a 100644
--- a/drivers/net/ethernet/altera/altera_utils.c
+++ b/drivers/net/ethernet/altera/altera_utils.c
@@ -31,3 +31,32 @@ int tse_bit_is_clear(void __iomem *ioaddr, size_t offs, u32 bit_mask)
 	u32 value = csrrd32(ioaddr, offs);
 	return (value & bit_mask) ? 0 : 1;
 }
+
+int request_and_map(struct platform_device *pdev, const char *name,
+		    struct resource **res, void __iomem **ptr)
+{
+	struct resource *region;
+	struct device *device = &pdev->dev;
+
+	*res = platform_get_resource_byname(pdev, IORESOURCE_MEM, name);
+	if (!*res) {
+		dev_err(device, "resource %s not defined\n", name);
+		return -ENODEV;
+	}
+
+	region = devm_request_mem_region(device, (*res)->start,
+					 resource_size(*res), dev_name(device));
+	if (!region) {
+		dev_err(device, "unable to request %s\n", name);
+		return -EBUSY;
+	}
+
+	*ptr = devm_ioremap(device, region->start,
+			    resource_size(region));
+	if (!*ptr) {
+		dev_err(device, "ioremap of %s failed!", name);
+		return -ENOMEM;
+	}
+
+	return 0;
+}
diff --git a/drivers/net/ethernet/altera/altera_utils.h b/drivers/net/ethernet/altera/altera_utils.h
index b7d772f2dcbb..fbe985099a44 100644
--- a/drivers/net/ethernet/altera/altera_utils.h
+++ b/drivers/net/ethernet/altera/altera_utils.h
@@ -3,7 +3,9 @@
  * Copyright (C) 2014 Altera Corporation. All rights reserved
  */
 
+#include <linux/platform_device.h>
 #include <linux/kernel.h>
+#include <linux/io.h>
 
 #ifndef __ALTERA_UTILS_H__
 #define __ALTERA_UTILS_H__
@@ -12,5 +14,54 @@ void tse_set_bit(void __iomem *ioaddr, size_t offs, u32 bit_mask);
 void tse_clear_bit(void __iomem *ioaddr, size_t offs, u32 bit_mask);
 int tse_bit_is_set(void __iomem *ioaddr, size_t offs, u32 bit_mask);
 int tse_bit_is_clear(void __iomem *ioaddr, size_t offs, u32 bit_mask);
+int request_and_map(struct platform_device *pdev, const char *name,
+		    struct resource **res, void __iomem **ptr);
 
+static inline
+u32 csrrd32(void __iomem *mac, size_t offs)
+{
+	void __iomem *paddr = (void __iomem *)((uintptr_t)mac + offs);
+
+	return readl(paddr);
+}
+
+static inline
+u16 csrrd16(void __iomem *mac, size_t offs)
+{
+	void __iomem *paddr = (void __iomem *)((uintptr_t)mac + offs);
+
+	return readw(paddr);
+}
+
+static inline
+u8 csrrd8(void __iomem *mac, size_t offs)
+{
+	void __iomem *paddr = (void __iomem *)((uintptr_t)mac + offs);
+
+	return readb(paddr);
+}
+
+static inline
+void csrwr32(u32 val, void __iomem *mac, size_t offs)
+{
+	void __iomem *paddr = (void __iomem *)((uintptr_t)mac + offs);
+
+	writel(val, paddr);
+}
+
+static inline
+void csrwr16(u16 val, void __iomem *mac, size_t offs)
+{
+	void __iomem *paddr = (void __iomem *)((uintptr_t)mac + offs);
+
+	writew(val, paddr);
+}
+
+static inline
+void csrwr8(u8 val, void __iomem *mac, size_t offs)
+{
+	void __iomem *paddr = (void __iomem *)((uintptr_t)mac + offs);
+
+	writeb(val, paddr);
+}
 #endif /* __ALTERA_UTILS_H__*/
-- 
2.13.0

