Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F9B1A153E
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 11:58:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727124AbfH2J6d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 05:58:33 -0400
Received: from mga17.intel.com ([192.55.52.151]:61740 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725782AbfH2J6b (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Aug 2019 05:58:31 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Aug 2019 02:58:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,442,1559545200"; 
   d="scan'208";a="380719665"
Received: from pipin.fi.intel.com ([10.237.72.175])
  by fmsmga005.fm.intel.com with ESMTP; 29 Aug 2019 02:58:29 -0700
From:   Felipe Balbi <felipe.balbi@linux.intel.com>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     Christopher S Hall <christopher.s.hall@intel.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Felipe Balbi <felipe.balbi@linux.intel.com>
Subject: [PATCH v2 2/2] PTP: add support for one-shot output
Date:   Thu, 29 Aug 2019 12:58:25 +0300
Message-Id: <20190829095825.2108-2-felipe.balbi@linux.intel.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190829095825.2108-1-felipe.balbi@linux.intel.com>
References: <20190829095825.2108-1-felipe.balbi@linux.intel.com>
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

Changes since v1:
	- remove comment from .flags field

 drivers/ptp/ptp_chardev.c      | 5 ++---
 include/uapi/linux/ptp_clock.h | 4 +++-
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/ptp/ptp_chardev.c b/drivers/ptp/ptp_chardev.c
index 98ec1395544e..a407e5f76e2d 100644
--- a/drivers/ptp/ptp_chardev.c
+++ b/drivers/ptp/ptp_chardev.c
@@ -177,9 +177,8 @@ long ptp_ioctl(struct posix_clock *pc, unsigned int cmd, unsigned long arg)
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
index 039cd62ec706..95840e5f5c53 100644
--- a/include/uapi/linux/ptp_clock.h
+++ b/include/uapi/linux/ptp_clock.h
@@ -67,7 +67,9 @@ struct ptp_perout_request {
 	struct ptp_clock_time start;  /* Absolute start time. */
 	struct ptp_clock_time period; /* Desired period, zero means disable. */
 	unsigned int index;           /* Which channel to configure. */
-	unsigned int flags;           /* Reserved for future use. */
+
+#define PTP_PEROUT_ONE_SHOT BIT(0)
+	unsigned int flags;
 	unsigned int rsv[4];          /* Reserved for future use. */
 };
 
-- 
2.23.0

