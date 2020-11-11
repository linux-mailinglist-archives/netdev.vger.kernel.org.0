Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8CA62AE8CD
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 07:23:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726149AbgKKGXP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 01:23:15 -0500
Received: from foss.arm.com ([217.140.110.172]:41784 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726105AbgKKGXD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Nov 2020 01:23:03 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 420D3143D;
        Tue, 10 Nov 2020 22:23:03 -0800 (PST)
Received: from localhost.localdomain (entos-thunderx2-desktop.shanghai.arm.com [10.169.212.215])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id E63E83F6CF;
        Tue, 10 Nov 2020 22:22:56 -0800 (PST)
From:   Jianyong Wu <jianyong.wu@arm.com>
To:     netdev@vger.kernel.org, yangbo.lu@nxp.com, john.stultz@linaro.org,
        tglx@linutronix.de, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, maz@kernel.org,
        richardcochran@gmail.com, Mark.Rutland@arm.com, will@kernel.org,
        suzuki.poulose@arm.com, Andre.Przywara@arm.com,
        steven.price@arm.com
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Steve.Capper@arm.com, justin.he@arm.com, jianyong.wu@arm.com,
        nd@arm.com
Subject: [PATCH v15 4/9] time: Add mechanism to recognize clocksource in time_get_snapshot
Date:   Wed, 11 Nov 2020 14:22:06 +0800
Message-Id: <20201111062211.33144-5-jianyong.wu@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201111062211.33144-1-jianyong.wu@arm.com>
References: <20201111062211.33144-1-jianyong.wu@arm.com>
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
 include/linux/clocksource_ids.h | 11 +++++++++++
 include/linux/timekeeping.h     | 12 +++++++-----
 kernel/time/clocksource.c       |  2 ++
 kernel/time/timekeeping.c       |  1 +
 5 files changed, 27 insertions(+), 5 deletions(-)
 create mode 100644 include/linux/clocksource_ids.h

diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
index 86d143db6523..1290d0dce840 100644
--- a/include/linux/clocksource.h
+++ b/include/linux/clocksource.h
@@ -17,6 +17,7 @@
 #include <linux/timer.h>
 #include <linux/init.h>
 #include <linux/of.h>
+#include <linux/clocksource_ids.h>
 #include <asm/div64.h>
 #include <asm/io.h>
 
@@ -62,6 +63,10 @@ struct module;
  *			400-499: Perfect
  *				The ideal clocksource. A must-use where
  *				available.
+ * @id:			Defaults to CSID_GENERIC. The id value is captured
+ *			in certain snapshot functions to allow callers to
+ *			validate the clocksource from which the snapshot was
+ *			taken.
  * @flags:		Flags describing special properties
  * @enable:		Optional function to enable the clocksource
  * @disable:		Optional function to disable the clocksource
@@ -100,6 +105,7 @@ struct clocksource {
 	const char		*name;
 	struct list_head	list;
 	int			rating;
+	enum clocksource_ids	id;
 	enum vdso_clock_mode	vdso_clock_mode;
 	unsigned long		flags;
 
diff --git a/include/linux/clocksource_ids.h b/include/linux/clocksource_ids.h
new file mode 100644
index 000000000000..4d8e19e05328
--- /dev/null
+++ b/include/linux/clocksource_ids.h
@@ -0,0 +1,11 @@
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
diff --git a/include/linux/timekeeping.h b/include/linux/timekeeping.h
index 7f7e4a3f4394..2ee05355333f 100644
--- a/include/linux/timekeeping.h
+++ b/include/linux/timekeeping.h
@@ -3,6 +3,7 @@
 #define _LINUX_TIMEKEEPING_H
 
 #include <linux/errno.h>
+#include <linux/clocksource_ids.h>
 
 /* Included from linux/ktime.h */
 
@@ -244,11 +245,12 @@ struct ktime_timestamps {
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
 
 /**
diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index 02441ead3c3b..6b38d4993214 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -928,6 +928,8 @@ int __clocksource_register_scale(struct clocksource *cs, u32 scale, u32 freq)
 
 	clocksource_arch_init(cs);
 
+	if (WARN_ON_ONCE((unsigned int)cs->id >= CSID_MAX))
+		cs->id = CSID_GENERIC;
 	if (cs->vdso_clock_mode < 0 ||
 	    cs->vdso_clock_mode >= VDSO_CLOCKMODE_MAX) {
 		pr_warn("clocksource %s registered with invalid VDSO mode %d. Disabling VDSO support.\n",
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 6858a31364b6..eb04a2d74911 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -1053,6 +1053,7 @@ void ktime_get_snapshot(struct system_time_snapshot *systime_snapshot)
 	do {
 		seq = read_seqcount_begin(&tk_core.seq);
 		now = tk_clock_read(&tk->tkr_mono);
+		systime_snapshot->cs_id = tk->tkr_mono.clock->id;
 		systime_snapshot->cs_was_changed_seq = tk->cs_was_changed_seq;
 		systime_snapshot->clock_was_set_seq = tk->clock_was_set_seq;
 		base_real = ktime_add(tk->tkr_mono.base,
-- 
2.17.1

