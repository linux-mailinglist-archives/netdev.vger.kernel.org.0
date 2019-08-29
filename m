Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C450BA1540
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 11:58:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726973AbfH2J6a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 05:58:30 -0400
Received: from mga17.intel.com ([192.55.52.151]:61740 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725782AbfH2J6a (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Aug 2019 05:58:30 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Aug 2019 02:58:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,442,1559545200"; 
   d="scan'208";a="380719659"
Received: from pipin.fi.intel.com ([10.237.72.175])
  by fmsmga005.fm.intel.com with ESMTP; 29 Aug 2019 02:58:27 -0700
From:   Felipe Balbi <felipe.balbi@linux.intel.com>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     Christopher S Hall <christopher.s.hall@intel.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Felipe Balbi <felipe.balbi@linux.intel.com>
Subject: [PATCH v2 1/2] PTP: introduce new versions of IOCTLs
Date:   Thu, 29 Aug 2019 12:58:24 +0300
Message-Id: <20190829095825.2108-1-felipe.balbi@linux.intel.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current version of the IOCTL have a small problem which prevents us
from extending the API by making use of reserved fields. In these new
IOCTLs, we are now making sure that flags and rsv fields are zero which
will allow us to extend the API in the future.

Reviewed-by: Richard Cochran <richardcochran@gmail.com>
Signed-off-by: Felipe Balbi <felipe.balbi@linux.intel.com>
---

Changes since v1:
	- Add a blank line after memset()
	- Move memset(req) to the three places where it's needed
	- Fix the accidental removal of GETFUNC and SETFUNC

 drivers/ptp/ptp_chardev.c      | 62 ++++++++++++++++++++++++++++++++++
 include/uapi/linux/ptp_clock.h | 12 +++++++
 2 files changed, 74 insertions(+)

diff --git a/drivers/ptp/ptp_chardev.c b/drivers/ptp/ptp_chardev.c
index 18ffe449efdf..98ec1395544e 100644
--- a/drivers/ptp/ptp_chardev.c
+++ b/drivers/ptp/ptp_chardev.c
@@ -126,7 +126,9 @@ long ptp_ioctl(struct posix_clock *pc, unsigned int cmd, unsigned long arg)
 	switch (cmd) {
 
 	case PTP_CLOCK_GETCAPS:
+	case PTP_CLOCK_GETCAPS2:
 		memset(&caps, 0, sizeof(caps));
+
 		caps.max_adj = ptp->info->max_adj;
 		caps.n_alarm = ptp->info->n_alarm;
 		caps.n_ext_ts = ptp->info->n_ext_ts;
@@ -139,11 +141,24 @@ long ptp_ioctl(struct posix_clock *pc, unsigned int cmd, unsigned long arg)
 		break;
 
 	case PTP_EXTTS_REQUEST:
+	case PTP_EXTTS_REQUEST2:
+		memset(&req, 0, sizeof(req));
+
 		if (copy_from_user(&req.extts, (void __user *)arg,
 				   sizeof(req.extts))) {
 			err = -EFAULT;
 			break;
 		}
+		if ((req.extts.flags || req.extts.rsv[0] || req.extts.rsv[1])
+			&& cmd == PTP_EXTTS_REQUEST2) {
+			err = -EINVAL;
+			break;
+		} else if (cmd == PTP_EXTTS_REQUEST) {
+			req.extts.flags = 0;
+			req.extts.rsv[0] = 0;
+			req.extts.rsv[1] = 0;
+		}
+			
 		if (req.extts.index >= ops->n_ext_ts) {
 			err = -EINVAL;
 			break;
@@ -154,11 +169,26 @@ long ptp_ioctl(struct posix_clock *pc, unsigned int cmd, unsigned long arg)
 		break;
 
 	case PTP_PEROUT_REQUEST:
+	case PTP_PEROUT_REQUEST2:
+		memset(&req, 0, sizeof(req));
+
 		if (copy_from_user(&req.perout, (void __user *)arg,
 				   sizeof(req.perout))) {
 			err = -EFAULT;
 			break;
 		}
+		if ((req.perout.flags || req.perout.rsv[0] || req.perout.rsv[1]
+				|| req.perout.rsv[2] || req.perout.rsv[3])
+			&& cmd == PTP_PEROUT_REQUEST2) {
+			err = -EINVAL;
+			break;
+		} else if (cmd == PTP_PEROUT_REQUEST) {
+			req.perout.flags = 0;
+			req.perout.rsv[0] = 0;
+			req.perout.rsv[1] = 0;
+			req.perout.rsv[2] = 0;
+			req.perout.rsv[3] = 0;
+		}
 		if (req.perout.index >= ops->n_per_out) {
 			err = -EINVAL;
 			break;
@@ -169,6 +199,9 @@ long ptp_ioctl(struct posix_clock *pc, unsigned int cmd, unsigned long arg)
 		break;
 
 	case PTP_ENABLE_PPS:
+	case PTP_ENABLE_PPS2:
+		memset(&req, 0, sizeof(req));
+
 		if (!capable(CAP_SYS_TIME))
 			return -EPERM;
 		req.type = PTP_CLK_REQ_PPS;
@@ -177,6 +210,7 @@ long ptp_ioctl(struct posix_clock *pc, unsigned int cmd, unsigned long arg)
 		break;
 
 	case PTP_SYS_OFFSET_PRECISE:
+	case PTP_SYS_OFFSET_PRECISE2:
 		if (!ptp->info->getcrosststamp) {
 			err = -EOPNOTSUPP;
 			break;
@@ -201,6 +235,7 @@ long ptp_ioctl(struct posix_clock *pc, unsigned int cmd, unsigned long arg)
 		break;
 
 	case PTP_SYS_OFFSET_EXTENDED:
+	case PTP_SYS_OFFSET_EXTENDED2:
 		if (!ptp->info->gettimex64) {
 			err = -EOPNOTSUPP;
 			break;
@@ -232,6 +267,7 @@ long ptp_ioctl(struct posix_clock *pc, unsigned int cmd, unsigned long arg)
 		break;
 
 	case PTP_SYS_OFFSET:
+	case PTP_SYS_OFFSET2:
 		sysoff = memdup_user((void __user *)arg, sizeof(*sysoff));
 		if (IS_ERR(sysoff)) {
 			err = PTR_ERR(sysoff);
@@ -266,10 +302,23 @@ long ptp_ioctl(struct posix_clock *pc, unsigned int cmd, unsigned long arg)
 		break;
 
 	case PTP_PIN_GETFUNC:
+	case PTP_PIN_GETFUNC2:
 		if (copy_from_user(&pd, (void __user *)arg, sizeof(pd))) {
 			err = -EFAULT;
 			break;
 		}
+		if ((pd.rsv[0] || pd.rsv[1] || pd.rsv[2]
+				|| pd.rsv[3] || pd.rsv[4])
+			&& cmd == PTP_PIN_GETFUNC2) {
+			err = -EINVAL;
+			break;
+		} else if (cmd == PTP_PIN_GETFUNC) {
+			pd.rsv[0] = 0;
+			pd.rsv[1] = 0;
+			pd.rsv[2] = 0;
+			pd.rsv[3] = 0;
+			pd.rsv[4] = 0;
+		}
 		pin_index = pd.index;
 		if (pin_index >= ops->n_pins) {
 			err = -EINVAL;
@@ -285,10 +334,23 @@ long ptp_ioctl(struct posix_clock *pc, unsigned int cmd, unsigned long arg)
 		break;
 
 	case PTP_PIN_SETFUNC:
+	case PTP_PIN_SETFUNC2:
 		if (copy_from_user(&pd, (void __user *)arg, sizeof(pd))) {
 			err = -EFAULT;
 			break;
 		}
+		if ((pd.rsv[0] || pd.rsv[1] || pd.rsv[2]
+				|| pd.rsv[3] || pd.rsv[4])
+			&& cmd == PTP_PIN_SETFUNC2) {
+			err = -EINVAL;
+			break;
+		} else if (cmd == PTP_PIN_SETFUNC) {
+			pd.rsv[0] = 0;
+			pd.rsv[1] = 0;
+			pd.rsv[2] = 0;
+			pd.rsv[3] = 0;
+			pd.rsv[4] = 0;
+		}
 		pin_index = pd.index;
 		if (pin_index >= ops->n_pins) {
 			err = -EINVAL;
diff --git a/include/uapi/linux/ptp_clock.h b/include/uapi/linux/ptp_clock.h
index 1bc794ad957a..039cd62ec706 100644
--- a/include/uapi/linux/ptp_clock.h
+++ b/include/uapi/linux/ptp_clock.h
@@ -149,6 +149,18 @@ struct ptp_pin_desc {
 #define PTP_SYS_OFFSET_EXTENDED \
 	_IOWR(PTP_CLK_MAGIC, 9, struct ptp_sys_offset_extended)
 
+#define PTP_CLOCK_GETCAPS2  _IOR(PTP_CLK_MAGIC, 10, struct ptp_clock_caps)
+#define PTP_EXTTS_REQUEST2  _IOW(PTP_CLK_MAGIC, 11, struct ptp_extts_request)
+#define PTP_PEROUT_REQUEST2 _IOW(PTP_CLK_MAGIC, 12, struct ptp_perout_request)
+#define PTP_ENABLE_PPS2     _IOW(PTP_CLK_MAGIC, 13, int)
+#define PTP_SYS_OFFSET2     _IOW(PTP_CLK_MAGIC, 14, struct ptp_sys_offset)
+#define PTP_PIN_GETFUNC2    _IOWR(PTP_CLK_MAGIC, 15, struct ptp_pin_desc)
+#define PTP_PIN_SETFUNC2    _IOW(PTP_CLK_MAGIC, 16, struct ptp_pin_desc)
+#define PTP_SYS_OFFSET_PRECISE2 \
+	_IOWR(PTP_CLK_MAGIC, 17, struct ptp_sys_offset_precise)
+#define PTP_SYS_OFFSET_EXTENDED2 \
+	_IOWR(PTP_CLK_MAGIC, 18, struct ptp_sys_offset_extended)
+
 struct ptp_extts_event {
 	struct ptp_clock_time t; /* Time event occured. */
 	unsigned int index;      /* Which channel produced the event. */
-- 
2.23.0

