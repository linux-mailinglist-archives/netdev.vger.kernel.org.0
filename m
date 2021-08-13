Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 817EE3EB585
	for <lists+netdev@lfdr.de>; Fri, 13 Aug 2021 14:30:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240562AbhHMMaT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 08:30:19 -0400
Received: from mga12.intel.com ([192.55.52.136]:18562 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240525AbhHMMaP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Aug 2021 08:30:15 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10074"; a="195137569"
X-IronPort-AV: E=Sophos;i="5.84,318,1620716400"; 
   d="scan'208";a="195137569"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2021 05:29:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,318,1620716400"; 
   d="scan'208";a="674339317"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga006.fm.intel.com with ESMTP; 13 Aug 2021 05:29:38 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id 8FE1D238; Fri, 13 Aug 2021 15:29:37 +0300 (EEST)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Richard Cochran <richardcochran@gmail.com>
Subject: [PATCH v1 net-next 3/7] ptp_pch: Use ioread64_hi_lo() / iowrite64_hi_lo()
Date:   Fri, 13 Aug 2021 15:29:28 +0300
Message-Id: <20210813122932.46152-3-andriy.shevchenko@linux.intel.com>
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
 drivers/ptp/ptp_pch.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/ptp/ptp_pch.c b/drivers/ptp/ptp_pch.c
index 501155b72b12..e7e31d4357e7 100644
--- a/drivers/ptp/ptp_pch.c
+++ b/drivers/ptp/ptp_pch.c
@@ -14,6 +14,7 @@
 #include <linux/interrupt.h>
 #include <linux/io.h>
 #include <linux/io-64-nonatomic-lo-hi.h>
+#include <linux/io-64-nonatomic-hi-lo.h>
 #include <linux/irq.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
@@ -298,19 +299,16 @@ static irqreturn_t isr(int irq, void *priv)
 	struct pch_dev *pch_dev = priv;
 	struct pch_ts_regs __iomem *regs = pch_dev->regs;
 	struct ptp_clock_event event;
-	u32 ack = 0, lo, hi, val;
+	u32 ack = 0, val;
 
 	val = ioread32(&regs->event);
 
 	if (val & PCH_TSE_SNS) {
 		ack |= PCH_TSE_SNS;
 		if (pch_dev->exts0_enabled) {
-			hi = ioread32(&regs->asms_hi);
-			lo = ioread32(&regs->asms_lo);
 			event.type = PTP_CLOCK_EXTTS;
 			event.index = 0;
-			event.timestamp = ((u64) hi) << 32;
-			event.timestamp |= lo;
+			event.timestamp = ioread64_hi_lo(&regs->asms_hi);
 			event.timestamp <<= TICKS_NS_SHIFT;
 			ptp_clock_event(pch_dev->ptp_clock, &event);
 		}
@@ -319,12 +317,9 @@ static irqreturn_t isr(int irq, void *priv)
 	if (val & PCH_TSE_SNM) {
 		ack |= PCH_TSE_SNM;
 		if (pch_dev->exts1_enabled) {
-			hi = ioread32(&regs->amms_hi);
-			lo = ioread32(&regs->amms_lo);
 			event.type = PTP_CLOCK_EXTTS;
 			event.index = 1;
-			event.timestamp = ((u64) hi) << 32;
-			event.timestamp |= lo;
+			event.timestamp = ioread64_hi_lo(&regs->asms_hi);
 			event.timestamp <<= TICKS_NS_SHIFT;
 			ptp_clock_event(pch_dev->ptp_clock, &event);
 		}
-- 
2.30.2

