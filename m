Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E32883EB582
	for <lists+netdev@lfdr.de>; Fri, 13 Aug 2021 14:29:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229474AbhHMMaP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 08:30:15 -0400
Received: from mga18.intel.com ([134.134.136.126]:25646 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240271AbhHMMaG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Aug 2021 08:30:06 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10074"; a="202711826"
X-IronPort-AV: E=Sophos;i="5.84,318,1620716400"; 
   d="scan'208";a="202711826"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2021 05:29:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,318,1620716400"; 
   d="scan'208";a="422219020"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga006.jf.intel.com with ESMTP; 13 Aug 2021 05:29:38 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id 81438B1; Fri, 13 Aug 2021 15:29:37 +0300 (EEST)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Richard Cochran <richardcochran@gmail.com>
Subject: [PATCH v1 net-next 2/7] ptp_pch: Use ioread64_lo_hi() / iowrite64_lo_hi()
Date:   Fri, 13 Aug 2021 15:29:27 +0300
Message-Id: <20210813122932.46152-2-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210813122932.46152-1-andriy.shevchenko@linux.intel.com>
References: <20210813122932.46152-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is already helper functions to do 64-bit I/O on 32-bit machines or
buses, thus we don't need to reinvent the wheel.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/ptp/ptp_pch.c | 46 ++++++++++---------------------------------
 1 file changed, 10 insertions(+), 36 deletions(-)

diff --git a/drivers/ptp/ptp_pch.c b/drivers/ptp/ptp_pch.c
index 76ba94f419ff..501155b72b12 100644
--- a/drivers/ptp/ptp_pch.c
+++ b/drivers/ptp/ptp_pch.c
@@ -13,6 +13,7 @@
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/io.h>
+#include <linux/io-64-nonatomic-lo-hi.h>
 #include <linux/irq.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
@@ -147,28 +148,15 @@ static inline void pch_eth_enable_set(struct pch_dev *chip)
 static u64 pch_systime_read(struct pch_ts_regs __iomem *regs)
 {
 	u64 ns;
-	u32 lo, hi;
 
-	lo = ioread32(&regs->systime_lo);
-	hi = ioread32(&regs->systime_hi);
+	ns = ioread64_lo_hi(&regs->systime_lo);
 
-	ns = ((u64) hi) << 32;
-	ns |= lo;
-	ns <<= TICKS_NS_SHIFT;
-
-	return ns;
+	return ns << TICKS_NS_SHIFT;
 }
 
 static void pch_systime_write(struct pch_ts_regs __iomem *regs, u64 ns)
 {
-	u32 hi, lo;
-
-	ns >>= TICKS_NS_SHIFT;
-	hi = ns >> 32;
-	lo = ns & 0xffffffff;
-
-	iowrite32(lo, &regs->systime_lo);
-	iowrite32(hi, &regs->systime_hi);
+	iowrite64_lo_hi(ns >> TICKS_NS_SHIFT, &regs->systime_lo);
 }
 
 static inline void pch_block_reset(struct pch_dev *chip)
@@ -234,16 +222,10 @@ u64 pch_rx_snap_read(struct pci_dev *pdev)
 {
 	struct pch_dev *chip = pci_get_drvdata(pdev);
 	u64 ns;
-	u32 lo, hi;
 
-	lo = ioread32(&chip->regs->rx_snap_lo);
-	hi = ioread32(&chip->regs->rx_snap_hi);
+	ns = ioread64_lo_hi(&chip->regs->rx_snap_lo);
 
-	ns = ((u64) hi) << 32;
-	ns |= lo;
-	ns <<= TICKS_NS_SHIFT;
-
-	return ns;
+	return ns << TICKS_NS_SHIFT;
 }
 EXPORT_SYMBOL(pch_rx_snap_read);
 
@@ -251,16 +233,10 @@ u64 pch_tx_snap_read(struct pci_dev *pdev)
 {
 	struct pch_dev *chip = pci_get_drvdata(pdev);
 	u64 ns;
-	u32 lo, hi;
-
-	lo = ioread32(&chip->regs->tx_snap_lo);
-	hi = ioread32(&chip->regs->tx_snap_hi);
 
-	ns = ((u64) hi) << 32;
-	ns |= lo;
-	ns <<= TICKS_NS_SHIFT;
+	ns = ioread64_lo_hi(&chip->regs->tx_snap_lo);
 
-	return ns;
+	return ns << TICKS_NS_SHIFT;
 }
 EXPORT_SYMBOL(pch_tx_snap_read);
 
@@ -309,8 +285,7 @@ int pch_set_station_address(u8 *addr, struct pci_dev *pdev)
 	}
 
 	dev_dbg(&pdev->dev, "invoking pch_station_set\n");
-	iowrite32(lower_32_bits(mac), &chip->regs->ts_st[0]);
-	iowrite32(upper_32_bits(mac), &chip->regs->ts_st[4]);
+	iowrite64_lo_hi(mac, &chip->regs->ts_st);
 	return 0;
 }
 EXPORT_SYMBOL(pch_set_station_address);
@@ -577,8 +552,7 @@ pch_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	pch_reset(chip);
 
 	iowrite32(DEFAULT_ADDEND, &chip->regs->addend);
-	iowrite32(1, &chip->regs->trgt_lo);
-	iowrite32(0, &chip->regs->trgt_hi);
+	iowrite64_lo_hi(1, &chip->regs->trgt_lo);
 	iowrite32(PCH_TSE_TTIPEND, &chip->regs->event);
 
 	pch_eth_enable_set(chip);
-- 
2.30.2

