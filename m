Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1620DAF5A4
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 08:17:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726792AbfIKGQ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 02:16:26 -0400
Received: from mga04.intel.com ([192.55.52.120]:26661 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726018AbfIKGQZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Sep 2019 02:16:25 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Sep 2019 23:16:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,492,1559545200"; 
   d="scan'208";a="185731681"
Received: from pipin.fi.intel.com ([10.237.72.175])
  by fmsmga007.fm.intel.com with ESMTP; 10 Sep 2019 23:16:23 -0700
From:   Felipe Balbi <felipe.balbi@linux.intel.com>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     Christopher S Hall <christopher.s.hall@intel.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Felipe Balbi <felipe.balbi@linux.intel.com>
Subject: [PATCH v4 1/2] PTP: introduce new versions of IOCTLs
Date:   Wed, 11 Sep 2019 09:16:21 +0300
Message-Id: <20190911061622.774006-1-felipe.balbi@linux.intel.com>
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

Changes since v3:
	- Remove bogus bitwise negation

Changes since v2:
	- Define PTP_{PEROUT,EXTTS}_VALID_FLAGS
	- Fix comment above PTP_*_FLAGS

Changes since v1:
	- Add a blank line after memset()
	- Move memset(req) to the three places where it's needed
	- Fix the accidental removal of GETFUNC and SETFUNC

 drivers/ptp/ptp_chardev.c      | 63 ++++++++++++++++++++++++++++++++++
 include/uapi/linux/ptp_clock.h | 24 ++++++++++++-
 2 files changed, 86 insertions(+), 1 deletion(-)

diff --git a/drivers/ptp/ptp_chardev.c b/drivers/ptp/ptp_chardev.c
index 18ffe449efdf..9c18476d8d10 100644
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
+		if (((req.extts.flags & ~PTP_EXTTS_VALID_FLAGS) ||
+			req.extts.rsv[0] || req.extts.rsv[1]) &&
+			cmd == PTP_EXTTS_REQUEST2) {
+			err = -EINVAL;
+			break;
+		} else if (cmd == PTP_EXTTS_REQUEST) {
+			req.extts.flags &= ~PTP_EXTTS_VALID_FLAGS;
+			req.extts.rsv[0] = 0;
+			req.extts.rsv[1] = 0;
+		}
 		if (req.extts.index >= ops->n_ext_ts) {
 			err = -EINVAL;
 			break;
@@ -154,11 +169,27 @@ long ptp_ioctl(struct posix_clock *pc, unsigned int cmd, unsigned long arg)
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
+		if (((req.perout.flags & ~PTP_PEROUT_VALID_FLAGS) ||
+			req.perout.rsv[0] || req.perout.rsv[1] ||
+			req.perout.rsv[2] || req.perout.rsv[3]) &&
+			cmd == PTP_PEROUT_REQUEST2) {
+			err = -EINVAL;
+			break;
+		} else if (cmd == PTP_PEROUT_REQUEST) {
+			req.perout.flags &= ~PTP_PEROUT_VALID_FLAGS;
+			req.perout.rsv[0] = 0;
+			req.perout.rsv[1] = 0;
+			req.perout.rsv[2] = 0;
+			req.perout.rsv[3] = 0;
+		}
 		if (req.perout.index >= ops->n_per_out) {
 			err = -EINVAL;
 			break;
@@ -169,6 +200,9 @@ long ptp_ioctl(struct posix_clock *pc, unsigned int cmd, unsigned long arg)
 		break;
 
 	case PTP_ENABLE_PPS:
+	case PTP_ENABLE_PPS2:
+		memset(&req, 0, sizeof(req));
+
 		if (!capable(CAP_SYS_TIME))
 			return -EPERM;
 		req.type = PTP_CLK_REQ_PPS;
@@ -177,6 +211,7 @@ long ptp_ioctl(struct posix_clock *pc, unsigned int cmd, unsigned long arg)
 		break;
 
 	case PTP_SYS_OFFSET_PRECISE:
+	case PTP_SYS_OFFSET_PRECISE2:
 		if (!ptp->info->getcrosststamp) {
 			err = -EOPNOTSUPP;
 			break;
@@ -201,6 +236,7 @@ long ptp_ioctl(struct posix_clock *pc, unsigned int cmd, unsigned long arg)
 		break;
 
 	case PTP_SYS_OFFSET_EXTENDED:
+	case PTP_SYS_OFFSET_EXTENDED2:
 		if (!ptp->info->gettimex64) {
 			err = -EOPNOTSUPP;
 			break;
@@ -232,6 +268,7 @@ long ptp_ioctl(struct posix_clock *pc, unsigned int cmd, unsigned long arg)
 		break;
 
 	case PTP_SYS_OFFSET:
+	case PTP_SYS_OFFSET2:
 		sysoff = memdup_user((void __user *)arg, sizeof(*sysoff));
 		if (IS_ERR(sysoff)) {
 			err = PTR_ERR(sysoff);
@@ -266,10 +303,23 @@ long ptp_ioctl(struct posix_clock *pc, unsigned int cmd, unsigned long arg)
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
@@ -285,10 +335,23 @@ long ptp_ioctl(struct posix_clock *pc, unsigned int cmd, unsigned long arg)
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
index 1bc794ad957a..9a0af3511b68 100644
--- a/include/uapi/linux/ptp_clock.h
+++ b/include/uapi/linux/ptp_clock.h
@@ -25,10 +25,20 @@
 #include <linux/ioctl.h>
 #include <linux/types.h>
 
-/* PTP_xxx bits, for the flags field within the request structures. */
+/*
+ * Bits of the ptp_extts_request.flags field:
+ */
 #define PTP_ENABLE_FEATURE (1<<0)
 #define PTP_RISING_EDGE    (1<<1)
 #define PTP_FALLING_EDGE   (1<<2)
+#define PTP_EXTTS_VALID_FLAGS	(PTP_ENABLE_FEATURE |	\
+				 PTP_RISING_EDGE |	\
+				 PTP_FALLING_EDGE)
+
+/*
+ * Bits of the ptp_perout_request.flags field:
+ */
+#define PTP_PEROUT_VALID_FLAGS (0)
 
 /*
  * struct ptp_clock_time - represents a time value
@@ -149,6 +159,18 @@ struct ptp_pin_desc {
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

