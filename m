Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F894108C12
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 11:45:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727663AbfKYKpv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 05:45:51 -0500
Received: from foss.arm.com ([217.140.110.172]:48082 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727594AbfKYKpu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Nov 2019 05:45:50 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2FDA855D;
        Mon, 25 Nov 2019 02:45:49 -0800 (PST)
Received: from entos-d05.shanghai.arm.com (entos-d05.shanghai.arm.com [10.169.40.35])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id E7B533F52E;
        Mon, 25 Nov 2019 02:45:43 -0800 (PST)
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
Subject: [RFC PATCH v8 3/8] ptp: Reorganize ptp_kvm modules to make it arch-independent.
Date:   Mon, 25 Nov 2019 18:45:01 +0800
Message-Id: <20191125104506.36850-4-jianyong.wu@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191125104506.36850-1-jianyong.wu@arm.com>
References: <20191125104506.36850-1-jianyong.wu@arm.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, ptp_kvm modules implementation is only for x86 which includs
large part of arch-specific code.  This patch move all of those code
into new arch related file in the same directory.

Signed-off-by: Jianyong Wu <jianyong.wu@arm.com>
---
 drivers/ptp/Makefile                        |  1 +
 drivers/ptp/{ptp_kvm.c => ptp_kvm_common.c} | 77 +++++-------------
 drivers/ptp/ptp_kvm_x86.c                   | 87 +++++++++++++++++++++
 include/asm-generic/ptp_kvm.h               | 12 +++
 4 files changed, 118 insertions(+), 59 deletions(-)
 rename drivers/ptp/{ptp_kvm.c => ptp_kvm_common.c} (63%)
 create mode 100644 drivers/ptp/ptp_kvm_x86.c
 create mode 100644 include/asm-generic/ptp_kvm.h

diff --git a/drivers/ptp/Makefile b/drivers/ptp/Makefile
index 677d1d178a3e..3b7554f56ad9 100644
--- a/drivers/ptp/Makefile
+++ b/drivers/ptp/Makefile
@@ -4,6 +4,7 @@
 #
 
 ptp-y					:= ptp_clock.o ptp_chardev.o ptp_sysfs.o
+ptp_kvm-y				:= ptp_kvm_$(ARCH).o ptp_kvm_common.o
 obj-$(CONFIG_PTP_1588_CLOCK)		+= ptp.o
 obj-$(CONFIG_PTP_1588_CLOCK_DTE)	+= ptp_dte.o
 obj-$(CONFIG_PTP_1588_CLOCK_IXP46X)	+= ptp_ixp46x.o
diff --git a/drivers/ptp/ptp_kvm.c b/drivers/ptp/ptp_kvm_common.c
similarity index 63%
rename from drivers/ptp/ptp_kvm.c
rename to drivers/ptp/ptp_kvm_common.c
index fc7d0b77e118..0cd855d475f3 100644
--- a/drivers/ptp/ptp_kvm.c
+++ b/drivers/ptp/ptp_kvm_common.c
@@ -8,12 +8,12 @@
 #include <linux/err.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
+#include <linux/slab.h>
 #include <linux/module.h>
 #include <uapi/linux/kvm_para.h>
 #include <asm/kvm_para.h>
-#include <asm/pvclock.h>
-#include <asm/kvmclock.h>
 #include <uapi/asm/kvm_para.h>
+#include <asm-generic/ptp_kvm.h>
 
 #include <linux/ptp_clock_kernel.h>
 
@@ -24,56 +24,29 @@ struct kvm_ptp_clock {
 
 DEFINE_SPINLOCK(kvm_ptp_lock);
 
-static struct pvclock_vsyscall_time_info *hv_clock;
-
-static struct kvm_clock_pairing clock_pair;
-static phys_addr_t clock_pair_gpa;
-
 static int ptp_kvm_get_time_fn(ktime_t *device_time,
 			       struct system_counterval_t *system_counter,
 			       void *ctx)
 {
-	unsigned long ret;
+	unsigned long ret, cycle;
 	struct timespec64 tspec;
-	unsigned version;
-	int cpu;
-	struct pvclock_vcpu_time_info *src;
+	struct clocksource *cs;
 
 	spin_lock(&kvm_ptp_lock);
 
 	preempt_disable_notrace();
-	cpu = smp_processor_id();
-	src = &hv_clock[cpu].pvti;
-
-	do {
-		/*
-		 * We are using a TSC value read in the hosts
-		 * kvm_hc_clock_pairing handling.
-		 * So any changes to tsc_to_system_mul
-		 * and tsc_shift or any other pvclock
-		 * data invalidate that measurement.
-		 */
-		version = pvclock_read_begin(src);
-
-		ret = kvm_hypercall2(KVM_HC_CLOCK_PAIRING,
-				     clock_pair_gpa,
-				     KVM_CLOCK_PAIRING_WALLCLOCK);
-		if (ret != 0) {
-			pr_err_ratelimited("clock pairing hypercall ret %lu\n", ret);
-			spin_unlock(&kvm_ptp_lock);
-			preempt_enable_notrace();
-			return -EOPNOTSUPP;
-		}
-
-		tspec.tv_sec = clock_pair.sec;
-		tspec.tv_nsec = clock_pair.nsec;
-		ret = __pvclock_read_cycles(src, clock_pair.tsc);
-	} while (pvclock_read_retry(src, version));
+	ret = kvm_arch_ptp_get_crosststamp(&cycle, &tspec, &cs);
+	if (ret != 0) {
+		pr_err_ratelimited("clock pairing hypercall ret %lu\n", ret);
+		spin_unlock(&kvm_ptp_lock);
+		preempt_enable_notrace();
+		return -EOPNOTSUPP;
+	}
 
 	preempt_enable_notrace();
 
-	system_counter->cycles = ret;
-	system_counter->cs = &kvm_clock;
+	system_counter->cycles = cycle;
+	system_counter->cs = cs;
 
 	*device_time = timespec64_to_ktime(tspec);
 
@@ -116,17 +89,13 @@ static int ptp_kvm_gettime(struct ptp_clock_info *ptp, struct timespec64 *ts)
 
 	spin_lock(&kvm_ptp_lock);
 
-	ret = kvm_hypercall2(KVM_HC_CLOCK_PAIRING,
-			     clock_pair_gpa,
-			     KVM_CLOCK_PAIRING_WALLCLOCK);
+	ret = kvm_arch_ptp_get_clock(&tspec);
 	if (ret != 0) {
 		pr_err_ratelimited("clock offset hypercall ret %lu\n", ret);
 		spin_unlock(&kvm_ptp_lock);
 		return -EOPNOTSUPP;
 	}
 
-	tspec.tv_sec = clock_pair.sec;
-	tspec.tv_nsec = clock_pair.nsec;
 	spin_unlock(&kvm_ptp_lock);
 
 	memcpy(ts, &tspec, sizeof(struct timespec64));
@@ -166,21 +135,11 @@ static void __exit ptp_kvm_exit(void)
 
 static int __init ptp_kvm_init(void)
 {
-	long ret;
-
-	if (!kvm_para_available())
-		return -ENODEV;
-
-	clock_pair_gpa = slow_virt_to_phys(&clock_pair);
-	hv_clock = pvclock_get_pvti_cpu0_va();
+	int ret;
 
-	if (!hv_clock)
-		return -ENODEV;
-
-	ret = kvm_hypercall2(KVM_HC_CLOCK_PAIRING, clock_pair_gpa,
-			KVM_CLOCK_PAIRING_WALLCLOCK);
-	if (ret == -KVM_ENOSYS || ret == -KVM_EOPNOTSUPP)
-		return -ENODEV;
+	ret = kvm_arch_ptp_init();
+	if (ret)
+		return -EOPNOTSUPP;
 
 	kvm_ptp_clock.caps = ptp_kvm_caps;
 
diff --git a/drivers/ptp/ptp_kvm_x86.c b/drivers/ptp/ptp_kvm_x86.c
new file mode 100644
index 000000000000..6c891d7299c6
--- /dev/null
+++ b/drivers/ptp/ptp_kvm_x86.c
@@ -0,0 +1,87 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Virtual PTP 1588 clock for use with KVM guests
+ *
+ * Copyright (C) 2017 Red Hat Inc.
+ */
+
+#include <asm/pvclock.h>
+#include <asm/kvmclock.h>
+#include <linux/module.h>
+#include <uapi/asm/kvm_para.h>
+#include <uapi/linux/kvm_para.h>
+#include <linux/ptp_clock_kernel.h>
+
+phys_addr_t clock_pair_gpa;
+struct kvm_clock_pairing clock_pair;
+struct pvclock_vsyscall_time_info *hv_clock;
+
+int kvm_arch_ptp_init(void)
+{
+	int ret;
+
+	if (!kvm_para_available())
+		return -ENODEV;
+
+	clock_pair_gpa = slow_virt_to_phys(&clock_pair);
+	hv_clock = pvclock_get_pvti_cpu0_va();
+	if (!hv_clock)
+		return -ENODEV;
+
+	ret = kvm_hypercall2(KVM_HC_CLOCK_PAIRING, clock_pair_gpa,
+			     KVM_CLOCK_PAIRING_WALLCLOCK);
+	if (ret == -KVM_ENOSYS || ret == -KVM_EOPNOTSUPP)
+		return -ENODEV;
+
+	return 0;
+}
+
+int kvm_arch_ptp_get_clock(struct timespec64 *ts)
+{
+	long ret;
+
+	ret = kvm_hypercall2(KVM_HC_CLOCK_PAIRING,
+			     clock_pair_gpa,
+			     KVM_CLOCK_PAIRING_WALLCLOCK);
+	if (ret != 0)
+		return -EOPNOTSUPP;
+
+	ts->tv_sec = clock_pair.sec;
+	ts->tv_nsec = clock_pair.nsec;
+
+	return 0;
+}
+
+int kvm_arch_ptp_get_crosststamp(unsigned long *cycle, struct timespec64 *tspec,
+			      struct clocksource **cs)
+{
+	unsigned long ret;
+	unsigned int version;
+	int cpu;
+	struct pvclock_vcpu_time_info *src;
+
+	cpu = smp_processor_id();
+	src = &hv_clock[cpu].pvti;
+
+	do {
+		/*
+		 * We are using a TSC value read in the hosts
+		 * kvm_hc_clock_pairing handling.
+		 * So any changes to tsc_to_system_mul
+		 * and tsc_shift or any other pvclock
+		 * data invalidate that measurement.
+		 */
+		version = pvclock_read_begin(src);
+
+		ret = kvm_hypercall2(KVM_HC_CLOCK_PAIRING,
+				     clock_pair_gpa,
+				     KVM_CLOCK_PAIRING_WALLCLOCK);
+		tspec->tv_sec = clock_pair.sec;
+		tspec->tv_nsec = clock_pair.nsec;
+		*cycle = __pvclock_read_cycles(src, clock_pair.tsc);
+	} while (pvclock_read_retry(src, version));
+
+	*cs = &kvm_clock;
+
+	return 0;
+}
diff --git a/include/asm-generic/ptp_kvm.h b/include/asm-generic/ptp_kvm.h
new file mode 100644
index 000000000000..e5dd386f6664
--- /dev/null
+++ b/include/asm-generic/ptp_kvm.h
@@ -0,0 +1,12 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ *  Virtual PTP 1588 clock for use with KVM guests
+ *
+ *  Copyright (C) 2019 ARM Ltd.
+ *  All Rights Reserved
+ */
+
+int kvm_arch_ptp_init(void);
+int kvm_arch_ptp_get_clock(struct timespec64 *ts);
+int kvm_arch_ptp_get_crosststamp(unsigned long *cycle,
+		struct timespec64 *tspec, void *cs);
-- 
2.17.1

