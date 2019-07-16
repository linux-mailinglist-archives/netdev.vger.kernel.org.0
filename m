Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A3806A2D2
	for <lists+netdev@lfdr.de>; Tue, 16 Jul 2019 09:22:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730676AbfGPHUy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jul 2019 03:20:54 -0400
Received: from mga09.intel.com ([134.134.136.24]:64887 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730443AbfGPHUx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Jul 2019 03:20:53 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Jul 2019 00:20:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,496,1557212400"; 
   d="scan'208";a="194796206"
Received: from pipin.fi.intel.com ([10.237.72.175])
  by fmsmga002.fm.intel.com with ESMTP; 16 Jul 2019 00:20:50 -0700
From:   Felipe Balbi <felipe.balbi@linux.intel.com>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     netdev@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        "Christopher S . Hall" <christopher.s.hall@intel.com>,
        Felipe Balbi <felipe.balbi@linux.intel.com>
Subject: [RFC PATCH 2/5] PTP: add a callback for counting timestamp events
Date:   Tue, 16 Jul 2019 10:20:35 +0300
Message-Id: <20190716072038.8408-3-felipe.balbi@linux.intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190716072038.8408-1-felipe.balbi@linux.intel.com>
References: <20190716072038.8408-1-felipe.balbi@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This will be used for frequency discipline adjustments.

Signed-off-by: Felipe Balbi <felipe.balbi@linux.intel.com>
---
 include/linux/ptp_clock_kernel.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/include/linux/ptp_clock_kernel.h b/include/linux/ptp_clock_kernel.h
index 28eb9c792522..1a4e3f916128 100644
--- a/include/linux/ptp_clock_kernel.h
+++ b/include/linux/ptp_clock_kernel.h
@@ -35,6 +35,16 @@ struct ptp_system_timestamp {
 	struct timespec64 post_ts;
 };
 
+/**
+ * struct ptp_event_count_tstamp - device time vs event count for frequency discipline
+ */
+struct ptp_event_count_tstamp {
+	unsigned int index;
+
+	struct ptp_clock_time device_time;
+	u64 event_count;
+};
+
 /**
  * struct ptp_clock_info - decribes a PTP hardware clock
  *
@@ -134,6 +144,8 @@ struct ptp_clock_info {
 			  struct ptp_system_timestamp *sts);
 	int (*getcrosststamp)(struct ptp_clock_info *ptp,
 			      struct system_device_crosststamp *cts);
+	int (*counttstamp)(struct ptp_clock_info *ptp,
+			   struct ptp_event_count_tstamp *count);
 	int (*settime64)(struct ptp_clock_info *p, const struct timespec64 *ts);
 	int (*enable)(struct ptp_clock_info *ptp,
 		      struct ptp_clock_request *request, int on);
-- 
2.22.0

