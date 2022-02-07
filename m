Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF9494ACAEC
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 22:09:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233942AbiBGVHX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 16:07:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236135AbiBGVHT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 16:07:19 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D9C3C061A73;
        Mon,  7 Feb 2022 13:07:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644268039; x=1675804039;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=BL+ZEBn189MRfMZJQiXZQjIrsymlysUOzyPFoRQzQTo=;
  b=NjctjUigcuKOn1P/MB3ozvkdbV6ysV9Thi/Todidz+InBZXMYcgnYhv4
   cvFMp8hwzVvBZoFWfB1Mvo6nKQ+KOmU515AGvvtPunu1xO8YGyEeQC8I/
   TuFPQnXKgjSnaqm1DShAp7v1tRHGkpwNsb0yxGZPeSK1GpBsqO0rlcRHw
   MR/ECfgoY4kDR+HycbeqVF/RlqEnjTy5KDFc80KDkuLipsQvO1DItTtXL
   9EK50sF4smKfIQVHQaesINpe9q6ldReGE3bb8OnvC5cee567q/BKErBgp
   qG+vHUm0FalvNPLl6NCVjELp12W9lfZ3SIE8VLVnUwZ1y8qTG3NHR1Md9
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10251"; a="248758269"
X-IronPort-AV: E=Sophos;i="5.88,350,1635231600"; 
   d="scan'208";a="248758269"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2022 13:07:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,350,1635231600"; 
   d="scan'208";a="481712552"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga003.jf.intel.com with ESMTP; 07 Feb 2022 13:07:16 -0800
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id 56740509; Mon,  7 Feb 2022 23:07:31 +0200 (EET)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Richard Cochran <richardcochran@gmail.com>
Subject: [PATCH v2 net-next 3/6] ptp_pch: Use ioread64_hi_lo() / iowrite64_hi_lo()
Date:   Mon,  7 Feb 2022 23:07:27 +0200
Message-Id: <20220207210730.75252-3-andriy.shevchenko@linux.intel.com>
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
v2: no changes
 drivers/ptp/ptp_pch.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/ptp/ptp_pch.c b/drivers/ptp/ptp_pch.c
index f7b54256d94f..2eef90147dfe 100644
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
2.34.1

