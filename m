Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC1F12AE8DD
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 07:24:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726253AbgKKGYG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 01:24:06 -0500
Received: from foss.arm.com ([217.140.110.172]:41866 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726176AbgKKGXY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Nov 2020 01:23:24 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D695C1478;
        Tue, 10 Nov 2020 22:23:23 -0800 (PST)
Received: from localhost.localdomain (entos-thunderx2-desktop.shanghai.arm.com [10.169.212.215])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 875FE3F6CF;
        Tue, 10 Nov 2020 22:23:17 -0800 (PST)
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
Subject: [PATCH v15 7/9] ptp: arm/arm64: Enable ptp_kvm for arm/arm64
Date:   Wed, 11 Nov 2020 14:22:09 +0800
Message-Id: <20201111062211.33144-8-jianyong.wu@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201111062211.33144-1-jianyong.wu@arm.com>
References: <20201111062211.33144-1-jianyong.wu@arm.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, there is no mechanism to keep time sync between guest and host
in arm/arm64 virtualization environment. Time in guest will drift compared
with host after boot up as they may both use third party time sources
to correct their time respectively. The time deviation will be in order
of milliseconds. But in some scenarios,like in cloud envirenment, we ask
for higher time precision.

kvm ptp clock, which chooses the host clock source as a reference
clock to sync time between guest and host, has been adopted by x86
which takes the time sync order from milliseconds to nanoseconds.

This patch enables kvm ptp clock for arm/arm64 and improves clock sync precison
significantly.

Test result comparisons between with kvm ptp clock and without it in arm/arm64
are as follows. This test derived from the result of command 'chronyc
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
clock. So we can see that the clock difference between host and guest
is in order of ns.

Signed-off-by: Jianyong Wu <jianyong.wu@arm.com>
---
 drivers/clocksource/arm_arch_timer.c | 28 ++++++++++++++++++
 drivers/ptp/Kconfig                  |  2 +-
 drivers/ptp/Makefile                 |  1 +
 drivers/ptp/ptp_kvm_arm.c            | 44 ++++++++++++++++++++++++++++
 4 files changed, 74 insertions(+), 1 deletion(-)
 create mode 100644 drivers/ptp/ptp_kvm_arm.c

diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
index d55acffb0b90..b33c5a663d30 100644
--- a/drivers/clocksource/arm_arch_timer.c
+++ b/drivers/clocksource/arm_arch_timer.c
@@ -25,6 +25,7 @@
 #include <linux/sched/clock.h>
 #include <linux/sched_clock.h>
 #include <linux/acpi.h>
+#include <linux/arm-smccc.h>
 
 #include <asm/arch_timer.h>
 #include <asm/virt.h>
@@ -1650,3 +1651,30 @@ static int __init arch_timer_acpi_init(struct acpi_table_header *table)
 }
 TIMER_ACPI_DECLARE(arch_timer, ACPI_SIG_GTDT, arch_timer_acpi_init);
 #endif
+
+int kvm_arch_ptp_get_crosststamp(u64 *cycle, struct timespec64 *ts,
+			      struct clocksource **cs)
+{
+	struct arm_smccc_res hvc_res;
+	ktime_t ktime;
+	u32 ptp_counter;
+
+	if (arch_timer_uses_ppi == ARCH_TIMER_VIRT_PPI)
+		ptp_counter = ARM_PTP_VIRT_COUNTER;
+	else
+		ptp_counter = ARM_PTP_PHY_COUNTER;
+
+	arm_smccc_1_1_invoke(ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID,
+			     ptp_counter, &hvc_res);
+
+	if ((int)(hvc_res.a0) < 0)
+		return -EOPNOTSUPP;
+
+	ktime = (u64)hvc_res.a0 << 32 | hvc_res.a1;
+	*ts = ktime_to_timespec64(ktime);
+	*cycle = (u64)hvc_res.a2 << 32 | hvc_res.a3;
+	*cs = &clocksource_counter;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(kvm_arch_ptp_get_crosststamp);
diff --git a/drivers/ptp/Kconfig b/drivers/ptp/Kconfig
index 942f72d8151d..677c7f696b70 100644
--- a/drivers/ptp/Kconfig
+++ b/drivers/ptp/Kconfig
@@ -106,7 +106,7 @@ config PTP_1588_CLOCK_PCH
 config PTP_1588_CLOCK_KVM
 	tristate "KVM virtual PTP clock"
 	depends on PTP_1588_CLOCK
-	depends on KVM_GUEST && X86
+	depends on KVM_GUEST && X86 || (HAVE_ARM_SMCCC_DISCOVERY && ARM_ARCH_TIMER)
 	default y
 	help
 	  This driver adds support for using kvm infrastructure as a PTP
diff --git a/drivers/ptp/Makefile b/drivers/ptp/Makefile
index 699a4e4d19c2..9fa5ede44b2b 100644
--- a/drivers/ptp/Makefile
+++ b/drivers/ptp/Makefile
@@ -5,6 +5,7 @@
 
 ptp-y					:= ptp_clock.o ptp_chardev.o ptp_sysfs.o
 ptp_kvm-$(CONFIG_X86)			:= ptp_kvm_x86.o ptp_kvm_common.o
+ptp_kvm-$(CONFIG_HAVE_ARM_SMCCC)	:= ptp_kvm_arm.o ptp_kvm_common.o
 obj-$(CONFIG_PTP_1588_CLOCK)		+= ptp.o
 obj-$(CONFIG_PTP_1588_CLOCK_DTE)	+= ptp_dte.o
 obj-$(CONFIG_PTP_1588_CLOCK_INES)	+= ptp_ines.o
diff --git a/drivers/ptp/ptp_kvm_arm.c b/drivers/ptp/ptp_kvm_arm.c
new file mode 100644
index 000000000000..2212827c0384
--- /dev/null
+++ b/drivers/ptp/ptp_kvm_arm.c
@@ -0,0 +1,44 @@
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
+#include <asm/hypervisor.h>
+
+int kvm_arch_ptp_init(void)
+{
+	int ret;
+
+	ret = kvm_arm_hyp_service_available(ARM_SMCCC_KVM_FUNC_KVM_PTP);
+	if (ret <= 0)
+		return -EOPNOTSUPP;
+
+	return 0;
+}
+
+int kvm_arch_ptp_get_clock(struct timespec64 *ts)
+{
+	ktime_t ktime;
+	struct arm_smccc_res hvc_res;
+
+	arm_smccc_1_1_invoke(ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID,
+			     ARM_PTP_NONE_COUNTER, &hvc_res);
+	if ((int)(hvc_res.a0) < 0)
+		return -EOPNOTSUPP;
+
+	ktime = (u64)hvc_res.a0 << 32 | hvc_res.a1;
+	*ts = ktime_to_timespec64(ktime);
+
+	return 0;
+}
-- 
2.17.1

