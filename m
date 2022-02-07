Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43EC24ACAE3
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 22:09:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236285AbiBGVHW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 16:07:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233955AbiBGVHT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 16:07:19 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CD41C06109E;
        Mon,  7 Feb 2022 13:07:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644268038; x=1675804038;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PhWHJ1SCcif8/L+QoTftNGVZGlzfgg65vt4fSWV91Ug=;
  b=FfkS6Xn4EwFnykGKXhHswq4RyV3tmuvkuUwvWl9MVylXD85M8Sw/6rFd
   VgC9xxzRcuFWn4dqmIyqP8I/U5oDFNEv/e9BlEGYgrc92TuzXPRA9PJvL
   5i+mNneH2oEwAZqQ5L8wJ9v1P5SNmUc5HRLWAeQ7ZkQFfJA4H/27Jw1nt
   LrJEXf9pFuTWrmAqmv8J6xkhm12FXsjKpytkU0WNATVPe7n5nLyooBSxJ
   P0Cg7qeE1lKjsT3SAjgrgdvqAkm6DqcTUiKam5th3CLFtaz1ztWGPLRpT
   Ho9LZYs5tD5UwB5HH8dnAF4a2mKcnnj1B9OzrzimP43rtLV2TAoM+Rxsc
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10251"; a="248758267"
X-IronPort-AV: E=Sophos;i="5.88,350,1635231600"; 
   d="scan'208";a="248758267"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2022 13:07:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,350,1635231600"; 
   d="scan'208";a="525281844"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga007.jf.intel.com with ESMTP; 07 Feb 2022 13:07:16 -0800
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id 4DD4B94; Mon,  7 Feb 2022 23:07:31 +0200 (EET)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Richard Cochran <richardcochran@gmail.com>
Subject: [PATCH v2 net-next 2/6] ptp_pch: Use ioread64_lo_hi() / iowrite64_lo_hi()
Date:   Mon,  7 Feb 2022 23:07:26 +0200
Message-Id: <20220207210730.75252-2-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220207210730.75252-1-andriy.shevchenko@linux.intel.com>
References: <20220207210730.75252-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is already helper functions to do 64-bit I/O on 32-bit machines or
buses, thus we don't need to reinvent the wheel.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
v2: no changes, but LKP may complain on parisc, fix had been sent
https://lore.kernel.org/linux-parisc/20220207151639.75086-1-andriy.shevchenko@linux.intel.com/t/#u

 drivers/ptp/ptp_pch.c | 46 ++++++++++---------------------------------
 1 file changed, 10 insertions(+), 36 deletions(-)

diff --git a/drivers/ptp/ptp_pch.c b/drivers/ptp/ptp_pch.c
index cbf7ce3db93a..f7b54256d94f 100644
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
2.34.1

