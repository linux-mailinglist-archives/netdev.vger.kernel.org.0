Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 496DF157115
	for <lists+netdev@lfdr.de>; Mon, 10 Feb 2020 09:50:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727761AbgBJIuD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Feb 2020 03:50:03 -0500
Received: from foss.arm.com ([217.140.110.172]:57604 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727754AbgBJIuB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Feb 2020 03:50:01 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2703931B;
        Mon, 10 Feb 2020 00:50:01 -0800 (PST)
Received: from entos-d05.shanghai.arm.com (entos-d05.shanghai.arm.com [10.169.40.35])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 6FF9C3F68F;
        Mon, 10 Feb 2020 00:49:55 -0800 (PST)
From:   Jianyong Wu <jianyong.wu@arm.com>
To:     netdev@vger.kernel.org, yangbo.lu@nxp.com, john.stultz@linaro.org,
        tglx@linutronix.de, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, maz@kernel.org,
        richardcochran@gmail.com, Mark.Rutland@arm.com, will@kernel.org,
        suzuki.poulose@arm.com, steven.price@arm.com
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Steve.Capper@arm.com, Kaly.Xin@arm.com, justin.he@arm.com,
        jianyong.wu@arm.com, nd@arm.com
Subject: [RFC PATCH 6/9] ptp: arm/arm64: Enable ptp_kvm for arm/arm64
Date:   Mon, 10 Feb 2020 16:49:03 +0800
Message-Id: <20200210084906.24870-7-jianyong.wu@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200210084906.24870-1-jianyong.wu@arm.com>
References: <20200210084906.24870-1-jianyong.wu@arm.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, there is no mechanism to keep time sync between guest and host
in arm/arm64 virtualization environment. Time in guest will drift compared
with host after boot up as they may both use third party time sources
to correct their time respectively. The time deviation will be in order
of milliseconds. But in some scenarios,like in cloud envirenment, we ask
for higher time precision.

kvm ptp clock, which choose the host clock source clock as a reference
clock to sync time clock between guest and host has been adopted by x86
which makes the time sync order from milliseconds to nanoseconds.

This patch enables kvm ptp on arm/arm64 and improve clock sync precison
significantly.

Test result comparison between with kvm ptp and without it in arm/arm64 is
as follows. This test derived from the result of command 'chronyc
sources'. we should take more care of the last sample column which shows
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
 drivers/clocksource/arm_arch_timer.c | 22 ++++++++++++
 drivers/ptp/Kconfig                  |  2 +-
 drivers/ptp/Makefile                 |  6 +++-
 drivers/ptp/ptp_kvm_arm.c            | 53 ++++++++++++++++++++++++++++
 4 files changed, 81 insertions(+), 2 deletions(-)
 create mode 100644 drivers/ptp/ptp_kvm_arm.c

diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
index 4eb014fefa5b..4e57ab66165c 100644
--- a/drivers/clocksource/arm_arch_timer.c
+++ b/drivers/clocksource/arm_arch_timer.c
@@ -1625,3 +1625,25 @@ static int __init arch_timer_acpi_init(struct acpi_table_header *table)
 }
 TIMER_ACPI_DECLARE(arch_timer, ACPI_SIG_GTDT, arch_timer_acpi_init);
 #endif
+
+#if IS_ENABLED(CONFIG_PTP_1588_CLOCK_KVM)
+#include <linux/arm-smccc.h>
+int kvm_arch_ptp_get_crosststamp(unsigned long *cycle, struct timespec64 *ts,
+			      struct clocksource **cs)
+{
+	struct arm_smccc_res hvc_res;
+	ktime_t ktime_overall;
+
+	arm_smccc_1_1_invoke(ARM_SMCCC_HYP_KVM_PTP_FUNC_ID, &hvc_res);
+	if ((int)(hvc_res.a0) < 0)
+		return -EOPNOTSUPP;
+
+	ktime_overall = (long long)hvc_res.a0 << 32 | hvc_res.a1;
+	*ts = ktime_to_timespec64(ktime_overall);
+	*cycle = (long long)hvc_res.a2 << 32 | hvc_res.a3;
+	*cs = &clocksource_counter;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(kvm_arch_ptp_get_crosststamp);
+#endif
diff --git a/drivers/ptp/Kconfig b/drivers/ptp/Kconfig
index 475c60dccaa4..dfb536d14b44 100644
--- a/drivers/ptp/Kconfig
+++ b/drivers/ptp/Kconfig
@@ -106,7 +106,7 @@ config PTP_1588_CLOCK_PCH
 config PTP_1588_CLOCK_KVM
 	tristate "KVM virtual PTP clock"
 	depends on PTP_1588_CLOCK
-	depends on KVM_GUEST && X86
+	depends on KVM_GUEST && X86 || (ARM || ARM64) && ARM_ARCH_TIMER && ARM_PSCI_FW
 	default y
 	help
 	  This driver adds support for using kvm infrastructure as a PTP
diff --git a/drivers/ptp/Makefile b/drivers/ptp/Makefile
index 06837d089347..f6688de74a8e 100644
--- a/drivers/ptp/Makefile
+++ b/drivers/ptp/Makefile
@@ -3,8 +3,12 @@
 # Makefile for PTP 1588 clock support.
 #
 
+ifeq ($(ARCH), arm64)
+	ptp_kvm-y := ptp_kvm_arm.o ptp_kvm_common.o
+else
+	ptp_kvm-y := ptp_kvm_$(ARCH).o ptp_kvm_common.o
+endif
 ptp-y					:= ptp_clock.o ptp_chardev.o ptp_sysfs.o
-ptp_kvm-y				:= ptp_kvm_$(ARCH).o ptp_kvm_common.o
 obj-$(CONFIG_PTP_1588_CLOCK)		+= ptp.o
 obj-$(CONFIG_PTP_1588_CLOCK_DTE)	+= ptp_dte.o
 obj-$(CONFIG_PTP_1588_CLOCK_INES)	+= ptp_ines.o
diff --git a/drivers/ptp/ptp_kvm_arm.c b/drivers/ptp/ptp_kvm_arm.c
new file mode 100644
index 000000000000..9752e849e0ae
--- /dev/null
+++ b/drivers/ptp/ptp_kvm_arm.c
@@ -0,0 +1,53 @@
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
+int kvm_arch_ptp_init(void)
+{
+	struct arm_smccc_res hvc_res;
+
+	arm_smccc_1_1_invoke(ARM_SMCCC_HYP_KVM_PTP_FUNC_ID,
+			     &hvc_res);
+	if ((int)(hvc_res.a0) < 0)
+		return -EOPNOTSUPP;
+
+	return 0;
+}
+
+int kvm_arch_ptp_get_clock_generic(struct timespec64 *ts,
+				   struct arm_smccc_res *hvc_res)
+{
+	ktime_t ktime_overall;
+
+	arm_smccc_1_1_invoke(ARM_SMCCC_HYP_KVM_PTP_FUNC_ID,
+				  hvc_res);
+	if ((int)(hvc_res->a0) < 0)
+		return -EOPNOTSUPP;
+
+	ktime_overall = (long long)hvc_res->a0 << 32 | hvc_res->a1;
+	*ts = ktime_to_timespec64(ktime_overall);
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
-- 
2.17.1

