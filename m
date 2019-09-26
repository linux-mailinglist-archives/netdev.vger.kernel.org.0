Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77062BF1F6
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 13:42:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726666AbfIZLmq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Sep 2019 07:42:46 -0400
Received: from foss.arm.com ([217.140.110.172]:47150 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726463AbfIZLmo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Sep 2019 07:42:44 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 86AC61570;
        Thu, 26 Sep 2019 04:42:43 -0700 (PDT)
Received: from entos-d05.shanghai.arm.com (entos-d05.shanghai.arm.com [10.169.40.35])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id EE8633F67D;
        Thu, 26 Sep 2019 04:42:38 -0700 (PDT)
From:   Jianyong Wu <jianyong.wu@arm.com>
To:     netdev@vger.kernel.org, yangbo.lu@nxp.com, john.stultz@linaro.org,
        tglx@linutronix.de, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, maz@kernel.org,
        richardcochran@gmail.com, Mark.Rutland@arm.com,
        Will.Deacon@arm.com, suzuki.poulose@arm.com
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Steve.Capper@arm.com, Kaly.Xin@arm.com, justin.he@arm.com,
        jianyong.wu@arm.com, nd@arm.com
Subject: [RFC PATCH v4 4/5] ptp: arm64: Enable ptp_kvm for arm64
Date:   Thu, 26 Sep 2019 19:42:11 +0800
Message-Id: <20190926114212.5322-5-jianyong.wu@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190926114212.5322-1-jianyong.wu@arm.com>
References: <20190926114212.5322-1-jianyong.wu@arm.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently in arm64 virtualization environment, there is no mechanism to
keep time sync between guest and host. Time in guest will drift compared
with host after boot up as they may both use third party time sources
to correct their time respectively. The time deviation will be in order
of milliseconds but some scenarios ask for higher time precision, like
in cloud envirenment, we want all the VMs running in the host aquire the
same level accuracy from host clock.

Use of kvm ptp clock, which choose the host clock source clock as a
reference clock to sync time clock between guest and host has been adopted
by x86 which makes the time sync order from milliseconds to nanoseconds.

This patch enable kvm ptp on arm64 and we get the similar clock drift as
found with x86 with kvm ptp.

Test result comparison between with kvm ptp and without it in arm64 are
as follows. This test derived from the result of command 'chronyc
sources'. we should take more cure of the last sample column which shows
the offset between the local clock and the source at the last measurement.

no kvm ptp in guest:
MS Name/IP address   Stratum Poll Reach LastRx Last sample
========================================================================
^* dns1.synet.edu.cn      2   6   377    13  +1040us[+1581us] +/-   21ms
^* dns1.synet.edu.cn      2   6   377    21  +1040us[+1581us] +/-   21ms
^* dns1.synet.edu.cn      2   6   377    29  +1040us[+1581us] +/-   21ms
^* dns1.synet.edu.cn      2   6   377    37  +1040us[+1581us] +/-   21ms
^* dns1.synet.edu.cn      2   6   377    45  +1040us[+1581us] +/-   21ms
^* dns1.synet.edu.cn      2   6   377    53  +1040us[+1581us] +/-   21ms
^* dns1.synet.edu.cn      2   6   377    61  +1040us[+1581us] +/-   21ms
^* dns1.synet.edu.cn      2   6   377     4   -130us[ +796us] +/-   21ms
^* dns1.synet.edu.cn      2   6   377    12   -130us[ +796us] +/-   21ms
^* dns1.synet.edu.cn      2   6   377    20   -130us[ +796us] +/-   21ms

in host:
MS Name/IP address   Stratum Poll Reach LastRx Last sample
========================================================================
^* 120.25.115.20          2   7   377    72   -470us[ -603us] +/-   18ms
^* 120.25.115.20          2   7   377    92   -470us[ -603us] +/-   18ms
^* 120.25.115.20          2   7   377   112   -470us[ -603us] +/-   18ms
^* 120.25.115.20          2   7   377     2   +872ns[-6808ns] +/-   17ms
^* 120.25.115.20          2   7   377    22   +872ns[-6808ns] +/-   17ms
^* 120.25.115.20          2   7   377    43   +872ns[-6808ns] +/-   17ms
^* 120.25.115.20          2   7   377    63   +872ns[-6808ns] +/-   17ms
^* 120.25.115.20          2   7   377    83   +872ns[-6808ns] +/-   17ms
^* 120.25.115.20          2   7   377   103   +872ns[-6808ns] +/-   17ms
^* 120.25.115.20          2   7   377   123   +872ns[-6808ns] +/-   17ms

The dns1.synet.edu.cn is the network reference clock for guest and
120.25.115.20 is the network reference clock for host. we can't get the
clock error between guest and host directly, but a roughly estimated value
will be in order of hundreds of us to ms.

with kvm ptp in guest:
chrony has been disabled in host to remove the disturb by network clock.

MS Name/IP address         Stratum Poll Reach LastRx Last sample
========================================================================
* PHC0                    0   3   377     8     -7ns[   +1ns] +/-    3ns
* PHC0                    0   3   377     8     +1ns[  +16ns] +/-    3ns
* PHC0                    0   3   377     6     -4ns[   -0ns] +/-    6ns
* PHC0                    0   3   377     6     -8ns[  -12ns] +/-    5ns
* PHC0                    0   3   377     5     +2ns[   +4ns] +/-    4ns
* PHC0                    0   3   377    13     +2ns[   +4ns] +/-    4ns
* PHC0                    0   3   377    12     -4ns[   -6ns] +/-    4ns
* PHC0                    0   3   377    11     -8ns[  -11ns] +/-    6ns
* PHC0                    0   3   377    10    -14ns[  -20ns] +/-    4ns
* PHC0                    0   3   377     8     +4ns[   +5ns] +/-    4ns

The PHC0 is the ptp clock which choose the host clock as its source
clock. So we can be sure to say that the clock error between host and guest
is in order of ns.

Signed-off-by: Jianyong Wu <jianyong.wu@arm.com>
---
 drivers/clocksource/arm_arch_timer.c | 28 +++++++++++
 drivers/ptp/Kconfig                  |  2 +-
 drivers/ptp/kvm_ptp.c                |  4 +-
 drivers/ptp/ptp_kvm_arm64.c          | 73 ++++++++++++++++++++++++++++
 include/asm-generic/ptp_kvm.h        |  2 +-
 5 files changed, 106 insertions(+), 3 deletions(-)
 create mode 100644 drivers/ptp/ptp_kvm_arm64.c

diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
index 07e57a49d1e8..7a99673e4149 100644
--- a/drivers/clocksource/arm_arch_timer.c
+++ b/drivers/clocksource/arm_arch_timer.c
@@ -1633,4 +1633,32 @@ static int __init arch_timer_acpi_init(struct acpi_table_header *table)
 	return arch_timer_common_init();
 }
 TIMER_ACPI_DECLARE(arch_timer, ACPI_SIG_GTDT, arch_timer_acpi_init);
+
+#if IS_ENABLED(CONFIG_PTP_1588_CLOCK_KVM)
+#include <linux/arm-smccc.h>
+int kvm_arch_ptp_get_clock_fn(long *cycle, struct timespec64 *ts,
+			      struct clocksource **cs)
+{
+	u64 t1, t2;
+	struct arm_smccc_res hvc_res;
+	ktime_t ktime_overall;
+
+	t1 = sched_clock();
+	arm_smccc_1_1_invoke(ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID, &hvc_res);
+	t2 = sched_clock();
+	t2 -= t1;
+	t2 /= 2;
+	if ((long)(hvc_res.a0) < 0)
+		return -EOPNOTSUPP;
+
+	ktime_overall = hvc_res.a0 << 32 | hvc_res.a1;
+	*ts = ktime_to_timespec64(ktime_overall);
+	timespec64_add_ns(ts, t2);
+	*cycle = hvc_res.a2 << 32 | hvc_res.a3;
+	*cs = &clocksource_counter;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(kvm_arch_ptp_get_clock_fn);
+#endif
 #endif
diff --git a/drivers/ptp/Kconfig b/drivers/ptp/Kconfig
index 9b8fee5178e8..3c31ff8eb05f 100644
--- a/drivers/ptp/Kconfig
+++ b/drivers/ptp/Kconfig
@@ -110,7 +110,7 @@ config PTP_1588_CLOCK_PCH
 config PTP_1588_CLOCK_KVM
 	tristate "KVM virtual PTP clock"
 	depends on PTP_1588_CLOCK
-	depends on KVM_GUEST && X86
+	depends on KVM_GUEST && X86 || ARM64 && ARM_ARCH_TIMER
 	default y
 	help
 	  This driver adds support for using kvm infrastructure as a PTP
diff --git a/drivers/ptp/kvm_ptp.c b/drivers/ptp/kvm_ptp.c
index d8f215186904..b467e1674a71 100644
--- a/drivers/ptp/kvm_ptp.c
+++ b/drivers/ptp/kvm_ptp.c
@@ -22,6 +22,8 @@ struct kvm_ptp_clock {
 	struct ptp_clock_info caps;
 };
 
+//extern int kvm_arch_ptp_get_clock_fn(long *cycle, struct timespec64 *ts,
+//			      struct clocksource **cs)
 DEFINE_SPINLOCK(kvm_ptp_lock);
 
 static int ptp_kvm_get_time_fn(ktime_t *device_time,
@@ -138,7 +140,7 @@ static int __init ptp_kvm_init(void)
 	int ret;
 
 	ret = kvm_arch_ptp_init();
-	if (!ret)
+	if (ret)
 		return -EOPNOTSUPP;
 
 	kvm_ptp_clock.caps = ptp_kvm_caps;
diff --git a/drivers/ptp/ptp_kvm_arm64.c b/drivers/ptp/ptp_kvm_arm64.c
new file mode 100644
index 000000000000..e0c993847293
--- /dev/null
+++ b/drivers/ptp/ptp_kvm_arm64.c
@@ -0,0 +1,73 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ *  Virtual PTP 1588 clock for use with KVM guests
+ *  Copyright (C) 2019 ARM Ltd.
+ *  All Rights Reserved
+ */
+
+#include <linux/kernel.h>
+#include <linux/err.h>
+#include <asm/hypervisor.h>
+#include <linux/module.h>
+#include <linux/psci.h>
+#include <linux/arm-smccc.h>
+#include <linux/timecounter.h>
+#include <linux/sched/clock.h>
+#include <asm/arch_timer.h>
+
+struct system_counterval_t ptp_sc;
+
+/*
+ * as trap call cause delay, this function will return the delay in nanosecond
+ */
+static u64 arm_smccc_1_1_invoke_delay(u32 id, struct arm_smccc_res *res)
+{
+	u64 t1, t2;
+
+	t1 = sched_clock();
+	arm_smccc_1_1_invoke(id, res);
+	t2 = sched_clock();
+	t2 -= t1;
+	t2 /= 2;
+
+	return t2;
+}
+
+int kvm_arch_ptp_init(void)
+{
+	struct arm_smccc_res hvc_res;
+
+	arm_smccc_1_1_invoke_delay(ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID,
+					&hvc_res);
+	if ((long)(hvc_res.a0) < 0)
+		return -EOPNOTSUPP;
+
+	return 0;
+}
+
+int kvm_arch_ptp_get_clock_generic(struct timespec64 *ts,
+				   struct arm_smccc_res *hvc_res)
+{
+	u64 ns;
+	ktime_t ktime_overall;
+
+	ns = arm_smccc_1_1_invoke_delay(ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID,
+					hvc_res);
+	if ((long)(hvc_res->a0) < 0)
+		return -EOPNOTSUPP;
+
+	ktime_overall = hvc_res->a0 << 32 | hvc_res->a1;
+	*ts = ktime_to_timespec64(ktime_overall);
+	timespec64_add_ns(ts, ns);
+
+	return 0;
+}
+
+int kvm_arch_ptp_get_clock(struct timespec64 *ts)
+{
+	struct arm_smccc_res hvc_res;
+
+	kvm_arch_ptp_get_clock_generic(ts, &hvc_res);
+
+	return 0;
+}
diff --git a/include/asm-generic/ptp_kvm.h b/include/asm-generic/ptp_kvm.h
index 208e842bfa64..829d76bdb905 100644
--- a/include/asm-generic/ptp_kvm.h
+++ b/include/asm-generic/ptp_kvm.h
@@ -8,5 +8,5 @@
 
 int kvm_arch_ptp_init(void);
 int kvm_arch_ptp_get_clock(struct timespec64 *ts);
-int kvm_arch_ptp_get_clock_fn(long *cycle,
+int kvm_arch_ptp_get_clock_fn(unsigned long *cycle,
 		struct timespec64 *tspec, void *cs);
-- 
2.17.1

