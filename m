Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3BA08CD2B
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 09:47:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726944AbfHNHrT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 03:47:19 -0400
Received: from mga09.intel.com ([134.134.136.24]:30572 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725280AbfHNHrS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Aug 2019 03:47:18 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Aug 2019 00:47:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,384,1559545200"; 
   d="scan'208";a="188041249"
Received: from pipin.fi.intel.com ([10.237.72.175])
  by orsmga002.jf.intel.com with ESMTP; 14 Aug 2019 00:47:16 -0700
From:   Felipe Balbi <felipe.balbi@linux.intel.com>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     Christopher S Hall <christopher.s.hall@intel.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Felipe Balbi <felipe.balbi@linux.intel.com>
Subject: [PATCH 2/2] PTP: add support for one-shot output
Date:   Wed, 14 Aug 2019 10:47:12 +0300
Message-Id: <20190814074712.10684-2-felipe.balbi@linux.intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190814074712.10684-1-felipe.balbi@linux.intel.com>
References: <20190814074712.10684-1-felipe.balbi@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some controllers allow for a one-shot output pulse, in contrast to
periodic output. Now that we have extensible versions of our IOCTLs, we
can finally make use of the 'flags' field to pass a bit telling driver
that if we want one-shot pulse output.

Signed-off-by: Felipe Balbi <felipe.balbi@linux.intel.com>
---
 drivers/ptp/ptp_chardev.c      | 5 ++---
 include/uapi/linux/ptp_clock.h | 4 +++-
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/ptp/ptp_chardev.c b/drivers/ptp/ptp_chardev.c
index 204212fc3f8c..b75a65880056 100644
--- a/drivers/ptp/ptp_chardev.c
+++ b/drivers/ptp/ptp_chardev.c
@@ -173,9 +173,8 @@ long ptp_ioctl(struct posix_clock *pc, unsigned int cmd, unsigned long arg)
 			err = -EFAULT;
 			break;
 		}
-		if ((req.perout.flags || req.perout.rsv[0] || req.perout.rsv[1]
-				|| req.perout.rsv[2] || req.perout.rsv[3])
-			&& cmd == PTP_PEROUT_REQUEST2) {
+		if ((req.perout.rsv[0] || req.perout.rsv[1] || req.perout.rsv[2]
+			|| req.perout.rsv[3]) && cmd == PTP_PEROUT_REQUEST2) {
 			err = -EINVAL;
 			break;
 		} else if (cmd == PTP_PEROUT_REQUEST) {
diff --git a/include/uapi/linux/ptp_clock.h b/include/uapi/linux/ptp_clock.h
index 039cd62ec706..9412b16cc8ed 100644
--- a/include/uapi/linux/ptp_clock.h
+++ b/include/uapi/linux/ptp_clock.h
@@ -67,7 +67,9 @@ struct ptp_perout_request {
 	struct ptp_clock_time start;  /* Absolute start time. */
 	struct ptp_clock_time period; /* Desired period, zero means disable. */
 	unsigned int index;           /* Which channel to configure. */
-	unsigned int flags;           /* Reserved for future use. */
+
+#define PTP_PEROUT_ONE_SHOT BIT(0)
+	unsigned int flags;           /* Bit 0 -> oneshot output. */
 	unsigned int rsv[4];          /* Reserved for future use. */
 };
 
-- 
2.22.0

