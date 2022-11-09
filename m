Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68A56623747
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 00:10:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231934AbiKIXKI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 18:10:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231925AbiKIXJ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 18:09:57 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F9792124F
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 15:09:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668035396; x=1699571396;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=3J4EuVIz7rqCE0hF7rr0kDNESFfxRrZCYTF/KEgAIWU=;
  b=Mc7jSlHm2LWcKPy4iwrNqSQaY+jFVsdcW9qr/bdaUDHLDDIpsxNZan9T
   ZZA4RJzkS3tQkNA3cfQEeRzEwG+5c91ZhtHackyHNz2gocS29Y8XjUD6J
   dInbn/xFv8xgi22pMLdKE7ElE0YuVhtVJjJoZ80aWPNnV3P9++XH+HiyE
   di72y9GCb1t8Fo+XQwSRMYehYrT9ByNcd7Hm8mMbA7MuehcE/re7fvcrS
   +K994iztUT7jvcra1VXhwQL06nIRGx3WMKtKwNgg+WHrqQ8FA4tYU2QQc
   mZHeorlQg3ZFkR+Qu8JQkQ0dok8l2UVlqjsETSndDiRZrjXuiMd67ANTn
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10526"; a="309860533"
X-IronPort-AV: E=Sophos;i="5.96,152,1665471600"; 
   d="scan'208";a="309860533"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2022 15:09:54 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10526"; a="636930566"
X-IronPort-AV: E=Sophos;i="5.96,152,1665471600"; 
   d="scan'208";a="636930566"
Received: from jekeller-desk.amr.corp.intel.com (HELO jekeller-desk.jekeller.internal) ([10.166.241.7])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2022 15:09:53 -0800
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Cc:     Richard Cochran <richardcochran@gmail.com>,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: [PATCH net-next 9/9] ptp: remove the .adjfreq interface function
Date:   Wed,  9 Nov 2022 15:09:45 -0800
Message-Id: <20221109230945.545440-10-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.38.0.83.gd420dda05763
In-Reply-To: <20221109230945.545440-1-jacob.e.keller@intel.com>
References: <20221109230945.545440-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that all drivers have been converted to .adjfine, we can remove the
.adjfreq from the interface structure.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Cc: Richard Cochran <richardcochran@gmail.com>
---
 drivers/ptp/ptp_clock.c          | 5 +----
 include/linux/ptp_clock_kernel.h | 7 -------
 2 files changed, 1 insertion(+), 11 deletions(-)

diff --git a/drivers/ptp/ptp_clock.c b/drivers/ptp/ptp_clock.c
index 51cae72bb6db..62d4d29e7c05 100644
--- a/drivers/ptp/ptp_clock.c
+++ b/drivers/ptp/ptp_clock.c
@@ -131,10 +131,7 @@ static int ptp_clock_adjtime(struct posix_clock *pc, struct __kernel_timex *tx)
 		long ppb = scaled_ppm_to_ppb(tx->freq);
 		if (ppb > ops->max_adj || ppb < -ops->max_adj)
 			return -ERANGE;
-		if (ops->adjfine)
-			err = ops->adjfine(ops, tx->freq);
-		else
-			err = ops->adjfreq(ops, ppb);
+		err = ops->adjfine(ops, tx->freq);
 		ptp->dialed_frequency = tx->freq;
 	} else if (tx->modes & ADJ_OFFSET) {
 		if (ops->adjphase) {
diff --git a/include/linux/ptp_clock_kernel.h b/include/linux/ptp_clock_kernel.h
index f4781c5766d6..fdffa6a98d79 100644
--- a/include/linux/ptp_clock_kernel.h
+++ b/include/linux/ptp_clock_kernel.h
@@ -77,12 +77,6 @@ struct ptp_system_timestamp {
  *            nominal frequency in parts per million, but with a
  *            16 bit binary fractional field.
  *
- * @adjfreq:  Adjusts the frequency of the hardware clock.
- *            This method is deprecated.  New drivers should implement
- *            the @adjfine method instead.
- *            parameter delta: Desired frequency offset from nominal frequency
- *            in parts per billion
- *
  * @adjphase:  Adjusts the phase offset of the hardware clock.
  *             parameter delta: Desired change in nanoseconds.
  *
@@ -174,7 +168,6 @@ struct ptp_clock_info {
 	int pps;
 	struct ptp_pin_desc *pin_config;
 	int (*adjfine)(struct ptp_clock_info *ptp, long scaled_ppm);
-	int (*adjfreq)(struct ptp_clock_info *ptp, s32 delta);
 	int (*adjphase)(struct ptp_clock_info *ptp, s32 phase);
 	int (*adjtime)(struct ptp_clock_info *ptp, s64 delta);
 	int (*gettime64)(struct ptp_clock_info *ptp, struct timespec64 *ts);
-- 
2.38.0.83.gd420dda05763

