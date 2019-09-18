Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0150B5EB6
	for <lists+netdev@lfdr.de>; Wed, 18 Sep 2019 10:08:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729739AbfIRIIB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Sep 2019 04:08:01 -0400
Received: from foss.arm.com ([217.140.110.172]:36866 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729698AbfIRIH6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Sep 2019 04:07:58 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A7EF91570;
        Wed, 18 Sep 2019 01:07:57 -0700 (PDT)
Received: from entos-d05.shanghai.arm.com (entos-d05.shanghai.arm.com [10.169.40.35])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id E69913F59C;
        Wed, 18 Sep 2019 01:07:52 -0700 (PDT)
From:   Jianyong Wu <jianyong.wu@arm.com>
To:     netdev@vger.kernel.org, yangbo.lu@nxp.com, john.stultz@linaro.org,
        tglx@linutronix.de, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, maz@kernel.org,
        richardcochran@gmail.com, Mark.Rutland@arm.com,
        Will.Deacon@arm.com, suzuki.poulose@arm.com
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Steve.Capper@arm.com, Kaly.Xin@arm.com, justin.he@arm.com,
        jianyong.wu@arm.com, nd@arm.com,
        linux-arm-kernel@lists.infradead.org
Subject: [RFC PATCH v3 5/6] ptp: arm64: Enable ptp_kvm for arm64
Date:   Wed, 18 Sep 2019 04:07:15 -0400
Message-Id: <20190918080716.64242-6-jianyong.wu@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190918080716.64242-1-jianyong.wu@arm.com>
References: <20190918080716.64242-1-jianyong.wu@arm.com>
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
 drivers/ptp/Kconfig         |  2 +-
 drivers/ptp/kvm_ptp.c       |  2 +-
 drivers/ptp/ptp_kvm_arm64.c | 82 +++++++++++++++++++++++++++++++++++++
 3 files changed, 84 insertions(+), 2 deletions(-)
 create mode 100644 drivers/ptp/ptp_kvm_arm64.c

diff --git a/drivers/ptp/Kconfig b/drivers/ptp/Kconfig
index 9b8fee5178e8..e032fafdafa7 100644
--- a/drivers/ptp/Kconfig
+++ b/drivers/ptp/Kconfig
@@ -110,7 +110,7 @@ config PTP_1588_CLOCK_PCH
 config PTP_1588_CLOCK_KVM
 	tristate "KVM virtual PTP clock"
 	depends on PTP_1588_CLOCK
-	depends on KVM_GUEST && X86
+	depends on KVM_GUEST && X86 || ARM64
 	default y
 	help
 	  This driver adds support for using kvm infrastructure as a PTP
diff --git a/drivers/ptp/kvm_ptp.c b/drivers/ptp/kvm_ptp.c
index d8f215186904..c0b445fa6144 100644
--- a/drivers/ptp/kvm_ptp.c
+++ b/drivers/ptp/kvm_ptp.c
@@ -138,7 +138,7 @@ static int __init ptp_kvm_init(void)
 	int ret;
 
 	ret = kvm_arch_ptp_init();
-	if (!ret)
+	if (ret)
 		return -EOPNOTSUPP;
 
 	kvm_ptp_clock.caps = ptp_kvm_caps;
diff --git a/drivers/ptp/ptp_kvm_arm64.c b/drivers/ptp/ptp_kvm_arm64.c
new file mode 100644
index 000000000000..630144186c08
--- /dev/null
+++ b/drivers/ptp/ptp_kvm_arm64.c
@@ -0,0 +1,82 @@
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
+
+	return t2;
+}
+
+int kvm_arch_ptp_init(void)
+{
+	if (!kvm_arm_hyp_service_available(
+			ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID)) {
+		return -EOPNOTSUPP;
+	}
+	get_current_counterval(&ptp_sc);
+
+	return 0;
+}
+
+int kvm_arch_ptp_get_clock_generic(struct timespec64 *ts,
+				   struct arm_smccc_res *hvc_res)
+{
+	u64 ns;
+
+	ns = arm_smccc_1_1_invoke_delay(ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID,
+					hvc_res);
+	if ((long)(hvc_res->a0) < 0)
+		return -EOPNOTSUPP;
+
+	ts->tv_sec = hvc_res->a0;
+	ts->tv_nsec = hvc_res->a1;
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
+
+int kvm_arch_ptp_get_clock_fn(long *cycle, struct timespec64 *ts,
+			      struct clocksource **cs)
+{
+	struct arm_smccc_res hvc_res;
+
+	kvm_arch_ptp_get_clock_generic(ts, &hvc_res);
+	*cycle = hvc_res.a2;
+	*cs = ptp_sc.cs;
+
+	return 0;
+}
-- 
2.17.1

