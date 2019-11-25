Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF751108C16
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 11:46:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727682AbfKYKp4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 05:45:56 -0500
Received: from foss.arm.com ([217.140.110.172]:48114 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727594AbfKYKpz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Nov 2019 05:45:55 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C38E2328;
        Mon, 25 Nov 2019 02:45:54 -0800 (PST)
Received: from entos-d05.shanghai.arm.com (entos-d05.shanghai.arm.com [10.169.40.35])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 9DC963F52E;
        Mon, 25 Nov 2019 02:45:49 -0800 (PST)
From:   Jianyong Wu <jianyong.wu@arm.com>
To:     netdev@vger.kernel.org, yangbo.lu@nxp.com, john.stultz@linaro.org,
        tglx@linutronix.de, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, maz@kernel.org,
        richardcochran@gmail.com, Mark.Rutland@arm.com, will@kernel.org,
        suzuki.poulose@arm.com
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Steve.Capper@arm.com, Kaly.Xin@arm.com, justin.he@arm.com,
        jianyong.wu@arm.com, nd@arm.com
Subject: [RFC PATCH v8 4/8] time: Add mechanism to recognize clocksource in time_get_snapshot
Date:   Mon, 25 Nov 2019 18:45:02 +0800
Message-Id: <20191125104506.36850-5-jianyong.wu@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191125104506.36850-1-jianyong.wu@arm.com>
References: <20191125104506.36850-1-jianyong.wu@arm.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

System time snapshots are not conveying information about the current
clocksource which was used, but callers like the PTP KVM guest
implementation have the requirement to evaluate the clocksource type to
select the appropriate mechanism.

Introduce a clocksource id field in struct clocksource which is by default
set to CSID_GENERIC (0). Clocksource implementations can set that field to
a value which allows to identify the clocksource.

Store the clocksource id of the current clocksource in the
system_time_snapshot so callers can evaluate which clocksource was used to
take the snapshot and act accordingly.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Jianyong Wu <jianyong.wu@arm.com>
---
 include/linux/clocksource.h     |  6 ++++++
 include/linux/clocksource_ids.h | 12 ++++++++++++
 include/linux/timekeeping.h     | 12 +++++++-----
 kernel/time/clocksource.c       |  3 +++
 kernel/time/timekeeping.c       |  1 +
 5 files changed, 29 insertions(+), 5 deletions(-)
 create mode 100644 include/linux/clocksource_ids.h

diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
index b21db536fd52..96e85b6f9ca0 100644
--- a/include/linux/clocksource.h
+++ b/include/linux/clocksource.h
@@ -17,6 +17,7 @@
 #include <linux/timer.h>
 #include <linux/init.h>
 #include <linux/of.h>
+#include <linux/clocksource_ids.h>
 #include <asm/div64.h>
 #include <asm/io.h>
 
@@ -49,6 +50,10 @@ struct module;
  *			400-499: Perfect
  *				The ideal clocksource. A must-use where
  *				available.
+ * @id:			Defaults to CSID_GENERIC. The id value is captured
+ *			in certain snapshot functions to allow callers to
+ *			validate the clocksource from which the snapshot was
+ *			taken.
  * @read:		returns a cycle value, passes clocksource as argument
  * @enable:		optional function to enable the clocksource
  * @disable:		optional function to disable the clocksource
@@ -91,6 +96,7 @@ struct clocksource {
 	const char *name;
 	struct list_head list;
 	int rating;
+	enum clocksource_ids id;
 	int (*enable)(struct clocksource *cs);
 	void (*disable)(struct clocksource *cs);
 	unsigned long flags;
diff --git a/include/linux/clocksource_ids.h b/include/linux/clocksource_ids.h
new file mode 100644
index 000000000000..5595ab843c3d
--- /dev/null
+++ b/include/linux/clocksource_ids.h
@@ -0,0 +1,12 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_CLOCKSOURCE_IDS_H
+#define _LINUX_CLOCKSOURCE_IDS_H
+
+/* Enum to give clocksources a unique identifier */
+enum clocksource_ids {
+	CSID_GENERIC		= 0,
+	CSID_MAX,
+};
+
+#endif
+
diff --git a/include/linux/timekeeping.h b/include/linux/timekeeping.h
index a8ab0f143ac4..ecce56269a7e 100644
--- a/include/linux/timekeeping.h
+++ b/include/linux/timekeeping.h
@@ -2,6 +2,7 @@
 #ifndef _LINUX_TIMEKEEPING_H
 #define _LINUX_TIMEKEEPING_H
 
+#include <linux/clocksource_ids.h>
 #include <linux/errno.h>
 
 /* Included from linux/ktime.h */
@@ -204,11 +205,12 @@ extern void timekeeping_inject_sleeptime64(const struct timespec64 *delta);
  * @cs_was_changed_seq:	The sequence number of clocksource change events
  */
 struct system_time_snapshot {
-	u64		cycles;
-	ktime_t		real;
-	ktime_t		raw;
-	unsigned int	clock_was_set_seq;
-	u8		cs_was_changed_seq;
+	u64			cycles;
+	ktime_t			real;
+	ktime_t			raw;
+	enum clocksource_ids	cs_id;
+	unsigned int		clock_was_set_seq;
+	u8			cs_was_changed_seq;
 };
 
 /*
diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index 3bcc19ceb073..26a3add61771 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -921,6 +921,9 @@ int __clocksource_register_scale(struct clocksource *cs, u32 scale, u32 freq)
 
 	clocksource_arch_init(cs);
 
+	if (WARN_ON_ONCE((unsigned int)cs->id >= CSID_MAX))
+		cs->id = CSID_GENERIC;
+
 	/* Initialize mult/shift and max_idle_ns */
 	__clocksource_update_freq_scale(cs, scale, freq);
 
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 44b726bab4bd..88078cff7fe2 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -974,6 +974,7 @@ void ktime_get_snapshot(struct system_time_snapshot *systime_snapshot)
 	do {
 		seq = read_seqcount_begin(&tk_core.seq);
 		now = tk_clock_read(&tk->tkr_mono);
+		systime_snapshot->cs_id = tk->tkr_mono.clock->id;
 		systime_snapshot->cs_was_changed_seq = tk->cs_was_changed_seq;
 		systime_snapshot->clock_was_set_seq = tk->clock_was_set_seq;
 		base_real = ktime_add(tk->tkr_mono.base,
-- 
2.17.1

