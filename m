Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACA256A2D7
	for <lists+netdev@lfdr.de>; Tue, 16 Jul 2019 09:22:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731006AbfGPHVI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jul 2019 03:21:08 -0400
Received: from mga09.intel.com ([134.134.136.24]:64897 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730443AbfGPHVF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Jul 2019 03:21:05 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Jul 2019 00:20:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,496,1557212400"; 
   d="scan'208";a="194796221"
Received: from pipin.fi.intel.com ([10.237.72.175])
  by fmsmga002.fm.intel.com with ESMTP; 16 Jul 2019 00:20:53 -0700
From:   Felipe Balbi <felipe.balbi@linux.intel.com>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     netdev@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        "Christopher S . Hall" <christopher.s.hall@intel.com>,
        Felipe Balbi <felipe.balbi@linux.intel.com>
Subject: [RFC PATCH 3/5] PTP: implement PTP_EVENT_COUNT_TSTAMP ioctl
Date:   Tue, 16 Jul 2019 10:20:36 +0300
Message-Id: <20190716072038.8408-4-felipe.balbi@linux.intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190716072038.8408-1-felipe.balbi@linux.intel.com>
References: <20190716072038.8408-1-felipe.balbi@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With this, we can request the underlying driver to count the number of
events that have been captured.

Signed-off-by: Felipe Balbi <felipe.balbi@linux.intel.com>
---
 drivers/ptp/ptp_chardev.c      | 15 +++++++++++++++
 include/uapi/linux/ptp_clock.h |  2 ++
 2 files changed, 17 insertions(+)

diff --git a/drivers/ptp/ptp_chardev.c b/drivers/ptp/ptp_chardev.c
index 18ffe449efdf..a3e163a6acdc 100644
--- a/drivers/ptp/ptp_chardev.c
+++ b/drivers/ptp/ptp_chardev.c
@@ -114,6 +114,7 @@ long ptp_ioctl(struct posix_clock *pc, unsigned int cmd, unsigned long arg)
 	struct system_device_crosststamp xtstamp;
 	struct ptp_clock_info *ops = ptp->info;
 	struct ptp_sys_offset *sysoff = NULL;
+	struct ptp_event_count_tstamp counttstamp;
 	struct ptp_system_timestamp sts;
 	struct ptp_clock_request req;
 	struct ptp_clock_caps caps;
@@ -301,6 +302,20 @@ long ptp_ioctl(struct posix_clock *pc, unsigned int cmd, unsigned long arg)
 		mutex_unlock(&ptp->pincfg_mux);
 		break;
 
+	case PTP_EVENT_COUNT_TSTAMP:
+		if (!ops->counttstamp)
+			return -ENOTSUPP;
+		if (copy_from_user(&req.perout, (void __user *)arg,
+				   sizeof(counttstamp))) {
+			err = -EFAULT;
+			break;
+		}
+		err = ops->counttstamp(ops, &counttstamp);
+		if (!err && copy_to_user((void __user *)arg, &counttstamp,
+						sizeof(counttstamp)))
+			err = -EFAULT;
+		break;
+
 	default:
 		err = -ENOTTY;
 		break;
diff --git a/include/uapi/linux/ptp_clock.h b/include/uapi/linux/ptp_clock.h
index 1bc794ad957a..674db7de64f3 100644
--- a/include/uapi/linux/ptp_clock.h
+++ b/include/uapi/linux/ptp_clock.h
@@ -148,6 +148,8 @@ struct ptp_pin_desc {
 	_IOWR(PTP_CLK_MAGIC, 8, struct ptp_sys_offset_precise)
 #define PTP_SYS_OFFSET_EXTENDED \
 	_IOWR(PTP_CLK_MAGIC, 9, struct ptp_sys_offset_extended)
+#define PTP_EVENT_COUNT_TSTAMP \
+	_IOWR(PTP_CLK_MAGIC, 6, struct ptp_event_count_tstamp)
 
 struct ptp_extts_event {
 	struct ptp_clock_time t; /* Time event occured. */
-- 
2.22.0

