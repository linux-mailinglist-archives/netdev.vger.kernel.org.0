Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DB5F14E8DE
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 07:40:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728103AbgAaGks (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 01:40:48 -0500
Received: from mga02.intel.com ([134.134.136.20]:64027 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725815AbgAaGkr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jan 2020 01:40:47 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 30 Jan 2020 22:40:47 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,384,1574150400"; 
   d="scan'208";a="309925502"
Received: from wtczc53028gn.jf.intel.com (HELO localhost.localdomain) ([10.54.87.17])
  by orsmga001.jf.intel.com with ESMTP; 30 Jan 2020 22:40:46 -0800
From:   christopher.s.hall@intel.com
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hpa@zytor.com, mingo@redhat.com,
        x86@kernel.org, jacob.e.keller@intel.com, richardcochran@gmail.com,
        davem@davemloft.net, sean.v.kelley@intel.com
Cc:     Christopher Hall <christopher.s.hall@intel.com>
Subject: [Intel PMC TGPIO Driver 2/5] drivers/ptp: Add PEROUT2 ioctl frequency adjustment interface
Date:   Wed, 11 Dec 2019 13:48:49 -0800
Message-Id: <20191211214852.26317-3-christopher.s.hall@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191211214852.26317-1-christopher.s.hall@intel.com>
References: <20191211214852.26317-1-christopher.s.hall@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christopher Hall <christopher.s.hall@intel.com>

The Intel PMC TGPIO controller logic is driven by ART which is not adjust-
able. Rather than adjusting the clock frequency, an output frequency
adjustment method is added that doesn't require restarting or resetting
output.

Output frequency adjustment is achieved by adding a flag to be passed in
the PEROUT2 ioctl argument. In this case, the driver should disregard the
'start' time field and adjust the hardware output frequency if periodic
output is already "running".

For devices with an adjustable clock, the OFFSET_PRECISE* ioctl is used to
compute the device clock offset with respect to the system clock. For
non-adjustable clocks, the EVENT_COUNT_TSTAMP2 ioctl adds an analogous
relation between output edges and elapsed time device time. This tuple is
captured simultaneously in hardware and is used to precisely compute the
*actual* average cumulative output frequency relative to the device clock.
The actual average is used to adjust the output period to achieve the
*desired* cumulative output frequency.

Signed-off-by: Christopher Hall <christopher.s.hall@intel.com>
---
 drivers/ptp/ptp_chardev.c        | 26 ++++++++++++++++++++++++++
 include/linux/ptp_clock_kernel.h |  2 ++
 include/uapi/linux/ptp_clock.h   | 25 +++++++++++++++++++++++--
 3 files changed, 51 insertions(+), 2 deletions(-)

diff --git a/drivers/ptp/ptp_chardev.c b/drivers/ptp/ptp_chardev.c
index f9ad6df57fa5..04c51878723d 100644
--- a/drivers/ptp/ptp_chardev.c
+++ b/drivers/ptp/ptp_chardev.c
@@ -134,6 +134,7 @@ long ptp_ioctl(struct posix_clock *pc, unsigned int cmd, unsigned long arg)
 	struct ptp_clock *ptp = container_of(pc, struct ptp_clock, clock);
 	struct ptp_sys_offset_extended *extoff = NULL;
 	struct ptp_sys_offset_precise precise_offset;
+	struct ptp_event_count_tstamp counttstamp;
 	struct system_device_crosststamp xtstamp;
 	struct ptp_clock_info *ops = ptp->info;
 	struct ptp_sys_offset *sysoff = NULL;
@@ -218,6 +219,13 @@ long ptp_ioctl(struct posix_clock *pc, unsigned int cmd, unsigned long arg)
 			req.perout.flags &= PTP_PEROUT_V1_VALID_FLAGS;
 			zero_rsv_field(req.perout.rsv);
 		}
+		/* These flags don't make sense together */
+		if (cmd == PTP_PEROUT_REQUEST2 &&
+		    req.perout.flags & PTP_PEROUT_FREQ_ADJ &&
+		    req.perout.flags & PTP_PEROUT_ONE_SHOT) {
+			err = -EINVAL;
+			break;
+		}
 		if (req.perout.index >= ops->n_per_out) {
 			err = -EINVAL;
 			break;
@@ -227,6 +235,24 @@ long ptp_ioctl(struct posix_clock *pc, unsigned int cmd, unsigned long arg)
 		err = ops->enable(ops, &req, enable);
 		break;
 
+	case PTP_EVENT_COUNT_TSTAMP2:
+		if (!ops->counttstamp)
+			return -ENOTSUPP;
+		if (copy_from_user(&counttstamp, (void __user *)arg,
+				   sizeof(counttstamp))) {
+			err = -EFAULT;
+			break;
+		}
+		if (check_rsv_field(counttstamp.rsv)) {
+			err = -EINVAL;
+			break;
+		}
+		err = ops->counttstamp(ops, &counttstamp);
+		if (!err && copy_to_user((void __user *)arg, &counttstamp,
+						sizeof(counttstamp)))
+			err = -EFAULT;
+		break;
+
 	case PTP_ENABLE_PPS:
 	case PTP_ENABLE_PPS2:
 		memset(&req, 0, sizeof(req));
diff --git a/include/linux/ptp_clock_kernel.h b/include/linux/ptp_clock_kernel.h
index 93cc4f1d444a..8223f6f656dd 100644
--- a/include/linux/ptp_clock_kernel.h
+++ b/include/linux/ptp_clock_kernel.h
@@ -134,6 +134,8 @@ struct ptp_clock_info {
 			  struct ptp_system_timestamp *sts);
 	int (*getcrosststamp)(struct ptp_clock_info *ptp,
 			      struct system_device_crosststamp *cts);
+	int (*counttstamp)(struct ptp_clock_info *ptp,
+			   struct ptp_event_count_tstamp *count);
 	int (*settime64)(struct ptp_clock_info *p, const struct timespec64 *ts);
 	int (*enable)(struct ptp_clock_info *ptp,
 		      struct ptp_clock_request *request, int on);
diff --git a/include/uapi/linux/ptp_clock.h b/include/uapi/linux/ptp_clock.h
index 9dc9d0079e98..ecb4c4e49205 100644
--- a/include/uapi/linux/ptp_clock.h
+++ b/include/uapi/linux/ptp_clock.h
@@ -34,6 +34,11 @@
 #define PTP_STRICT_FLAGS   (1<<3)
 #define PTP_EXTTS_EDGES    (PTP_RISING_EDGE | PTP_FALLING_EDGE)
 
+/*
+ * Bits of the ptp_pin_desc.flags field:
+ */
+#define PTP_PINDESC_EVTCNTVALID	(1<<0)
+
 /*
  * flag fields valid for the new PTP_EXTTS_REQUEST2 ioctl.
  */
@@ -54,11 +59,13 @@
  * Bits of the ptp_perout_request.flags field:
  */
 #define PTP_PEROUT_ONE_SHOT (1<<0)
+#define PTP_PEROUT_FREQ_ADJ (1<<1)
 
 /*
  * flag fields valid for the new PTP_PEROUT_REQUEST2 ioctl.
  */
-#define PTP_PEROUT_VALID_FLAGS	(PTP_PEROUT_ONE_SHOT)
+#define PTP_PEROUT_VALID_FLAGS	(PTP_PEROUT_ONE_SHOT |	\
+				 PTP_PEROUT_FREQ_ADJ)
 
 /*
  * No flags are valid for the original PTP_PEROUT_REQUEST ioctl
@@ -106,6 +113,14 @@ struct ptp_perout_request {
 	unsigned int rsv[4];          /* Reserved for future use. */
 };
 
+struct ptp_event_count_tstamp {
+	struct ptp_clock_time device_time;
+	unsigned long long event_count;
+	unsigned int index;
+	unsigned int flags;
+	unsigned int rsv[4];          /* Reserved for future use. */
+};
+
 #define PTP_MAX_SAMPLES 25 /* Maximum allowed offset measurement samples. */
 
 struct ptp_sys_offset {
@@ -164,10 +179,14 @@ struct ptp_pin_desc {
 	 * PTP_EXTTS_REQUEST and PTP_PEROUT_REQUEST ioctls.
 	 */
 	unsigned int chan;
+	/*
+	 * Per pin capability flag
+	 */
+	unsigned int flags;
 	/*
 	 * Reserved for future use.
 	 */
-	unsigned int rsv[5];
+	unsigned int rsv[4];
 };
 
 #define PTP_CLK_MAGIC '='
@@ -195,6 +214,8 @@ struct ptp_pin_desc {
 	_IOWR(PTP_CLK_MAGIC, 17, struct ptp_sys_offset_precise)
 #define PTP_SYS_OFFSET_EXTENDED2 \
 	_IOWR(PTP_CLK_MAGIC, 18, struct ptp_sys_offset_extended)
+#define PTP_EVENT_COUNT_TSTAMP2 \
+	_IOWR(PTP_CLK_MAGIC, 19, struct ptp_event_count_tstamp)
 
 struct ptp_extts_event {
 	struct ptp_clock_time t; /* Time event occured. */
-- 
2.21.0

