Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C68F0313384
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 14:44:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231265AbhBHNlw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 08:41:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:59036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229706AbhBHNlR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Feb 2021 08:41:17 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 07DAF64DE9;
        Mon,  8 Feb 2021 13:40:36 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1l96mI-00Cn0C-6K; Mon, 08 Feb 2021 13:40:34 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     netdev@vger.kernel.org, yangbo.lu@nxp.com, john.stultz@linaro.org,
        tglx@linutronix.de, pbonzini@redhat.com, seanjc@google.com,
        richardcochran@gmail.com, Mark.Rutland@arm.com, will@kernel.org,
        suzuki.poulose@arm.com, Andre.Przywara@arm.com,
        steven.price@arm.com, lorenzo.pieralisi@arm.com,
        sudeep.holla@arm.com
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Steve.Capper@arm.com, justin.he@arm.com, jianyong.wu@arm.com,
        kernel-team@android.com
Subject: [PATCH v18 1/7] arm/arm64: Probe for the presence of KVM hypervisor
Date:   Mon,  8 Feb 2021 13:40:23 +0000
Message-Id: <20210208134029.3269384-2-maz@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210208134029.3269384-1-maz@kernel.org>
References: <20210208134029.3269384-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: netdev@vger.kernel.org, yangbo.lu@nxp.com, john.stultz@linaro.org, tglx@linutronix.de, pbonzini@redhat.com, seanjc@google.com, richardcochran@gmail.com, Mark.Rutland@arm.com, will@kernel.org, suzuki.poulose@arm.com, Andre.Przywara@arm.com, steven.price@arm.com, lorenzo.pieralisi@arm.com, sudeep.holla@arm.com, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, Steve.Capper@arm.com, justin.he@arm.com, jianyong.wu@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Will Deacon <will@kernel.org>

Although the SMCCC specification provides some limited functionality for
describing the presence of hypervisor and firmware services, this is
generally applicable only to functions designated as "Arm Architecture
Service Functions" and no portable discovery mechanism is provided for
standard hypervisor services, despite having a designated range of
function identifiers reserved by the specification.

In an attempt to avoid the need for additional firmware changes every
time a new function is added, introduce a UID to identify the service
provider as being compatible with KVM. Once this has been established,
additional services can be discovered via a feature bitmap.

Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Jianyong Wu <jianyong.wu@arm.com>
[maz: move code to its own file, plug it into PSCI]
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20201209060932.212364-2-jianyong.wu@arm.com
---
 arch/arm/include/asm/hypervisor.h   |  3 ++
 arch/arm64/include/asm/hypervisor.h |  3 ++
 drivers/firmware/psci/psci.c        |  2 ++
 drivers/firmware/smccc/Makefile     |  2 +-
 drivers/firmware/smccc/kvm_guest.c  | 50 +++++++++++++++++++++++++++++
 drivers/firmware/smccc/smccc.c      |  1 +
 include/linux/arm-smccc.h           | 25 +++++++++++++++
 7 files changed, 85 insertions(+), 1 deletion(-)
 create mode 100644 drivers/firmware/smccc/kvm_guest.c

diff --git a/arch/arm/include/asm/hypervisor.h b/arch/arm/include/asm/hypervisor.h
index df8524365637..bd61502b9715 100644
--- a/arch/arm/include/asm/hypervisor.h
+++ b/arch/arm/include/asm/hypervisor.h
@@ -4,4 +4,7 @@
 
 #include <asm/xen/hypervisor.h>
 
+void kvm_init_hyp_services(void);
+bool kvm_arm_hyp_service_available(u32 func_id);
+
 #endif
diff --git a/arch/arm64/include/asm/hypervisor.h b/arch/arm64/include/asm/hypervisor.h
index f9cc1d021791..0ae427f352c8 100644
--- a/arch/arm64/include/asm/hypervisor.h
+++ b/arch/arm64/include/asm/hypervisor.h
@@ -4,4 +4,7 @@
 
 #include <asm/xen/hypervisor.h>
 
+void kvm_init_hyp_services(void);
+bool kvm_arm_hyp_service_available(u32 func_id);
+
 #endif
diff --git a/drivers/firmware/psci/psci.c b/drivers/firmware/psci/psci.c
index f5fc429cae3f..69e296f02902 100644
--- a/drivers/firmware/psci/psci.c
+++ b/drivers/firmware/psci/psci.c
@@ -23,6 +23,7 @@
 
 #include <asm/cpuidle.h>
 #include <asm/cputype.h>
+#include <asm/hypervisor.h>
 #include <asm/system_misc.h>
 #include <asm/smp_plat.h>
 #include <asm/suspend.h>
@@ -498,6 +499,7 @@ static int __init psci_probe(void)
 		psci_init_cpu_suspend();
 		psci_init_system_suspend();
 		psci_init_system_reset2();
+		kvm_init_hyp_services();
 	}
 
 	return 0;
diff --git a/drivers/firmware/smccc/Makefile b/drivers/firmware/smccc/Makefile
index 72ab84042832..40d19144a860 100644
--- a/drivers/firmware/smccc/Makefile
+++ b/drivers/firmware/smccc/Makefile
@@ -1,4 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0
 #
-obj-$(CONFIG_HAVE_ARM_SMCCC_DISCOVERY)	+= smccc.o
+obj-$(CONFIG_HAVE_ARM_SMCCC_DISCOVERY)	+= smccc.o kvm_guest.o
 obj-$(CONFIG_ARM_SMCCC_SOC_ID)	+= soc_id.o
diff --git a/drivers/firmware/smccc/kvm_guest.c b/drivers/firmware/smccc/kvm_guest.c
new file mode 100644
index 000000000000..08836f2f39ee
--- /dev/null
+++ b/drivers/firmware/smccc/kvm_guest.c
@@ -0,0 +1,50 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#define pr_fmt(fmt) "smccc: KVM: " fmt
+
+#include <linux/arm-smccc.h>
+#include <linux/bitmap.h>
+#include <linux/kernel.h>
+#include <linux/string.h>
+
+#include <asm/hypervisor.h>
+
+static DECLARE_BITMAP(__kvm_arm_hyp_services, ARM_SMCCC_KVM_NUM_FUNCS) __ro_after_init = { };
+
+void __init kvm_init_hyp_services(void)
+{
+	struct arm_smccc_res res;
+	u32 val[4];
+
+	if (arm_smccc_1_1_get_conduit() != SMCCC_CONDUIT_HVC)
+		return;
+
+	arm_smccc_1_1_invoke(ARM_SMCCC_VENDOR_HYP_CALL_UID_FUNC_ID, &res);
+	if (res.a0 != ARM_SMCCC_VENDOR_HYP_UID_KVM_REG_0 ||
+	    res.a1 != ARM_SMCCC_VENDOR_HYP_UID_KVM_REG_1 ||
+	    res.a2 != ARM_SMCCC_VENDOR_HYP_UID_KVM_REG_2 ||
+	    res.a3 != ARM_SMCCC_VENDOR_HYP_UID_KVM_REG_3)
+		return;
+
+	memset(&res, 0, sizeof(res));
+	arm_smccc_1_1_invoke(ARM_SMCCC_VENDOR_HYP_KVM_FEATURES_FUNC_ID, &res);
+
+	val[0] = lower_32_bits(res.a0);
+	val[1] = lower_32_bits(res.a1);
+	val[2] = lower_32_bits(res.a2);
+	val[3] = lower_32_bits(res.a3);
+
+	bitmap_from_arr32(__kvm_arm_hyp_services, val, ARM_SMCCC_KVM_NUM_FUNCS);
+
+	pr_info("hypervisor services detected (0x%08lx 0x%08lx 0x%08lx 0x%08lx)\n",
+		 res.a3, res.a2, res.a1, res.a0);
+}
+
+bool kvm_arm_hyp_service_available(u32 func_id)
+{
+	if (func_id >= ARM_SMCCC_KVM_NUM_FUNCS)
+		return -EINVAL;
+
+	return test_bit(func_id, __kvm_arm_hyp_services);
+}
+EXPORT_SYMBOL_GPL(kvm_arm_hyp_service_available);
diff --git a/drivers/firmware/smccc/smccc.c b/drivers/firmware/smccc/smccc.c
index 00c88b809c0c..94eca6ffda05 100644
--- a/drivers/firmware/smccc/smccc.c
+++ b/drivers/firmware/smccc/smccc.c
@@ -7,6 +7,7 @@
 
 #include <linux/init.h>
 #include <linux/arm-smccc.h>
+#include <linux/kernel.h>
 
 static u32 smccc_version = ARM_SMCCC_VERSION_1_0;
 static enum arm_smccc_conduit smccc_conduit = SMCCC_CONDUIT_NONE;
diff --git a/include/linux/arm-smccc.h b/include/linux/arm-smccc.h
index f860645f6512..74e90b65b489 100644
--- a/include/linux/arm-smccc.h
+++ b/include/linux/arm-smccc.h
@@ -55,6 +55,8 @@
 #define ARM_SMCCC_OWNER_TRUSTED_OS	50
 #define ARM_SMCCC_OWNER_TRUSTED_OS_END	63
 
+#define ARM_SMCCC_FUNC_QUERY_CALL_UID  0xff01
+
 #define ARM_SMCCC_QUIRK_NONE		0
 #define ARM_SMCCC_QUIRK_QCOM_A6		1 /* Save/restore register a6 */
 
@@ -87,6 +89,29 @@
 			   ARM_SMCCC_SMC_32,				\
 			   0, 0x7fff)
 
+#define ARM_SMCCC_VENDOR_HYP_CALL_UID_FUNC_ID				\
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,				\
+			   ARM_SMCCC_SMC_32,				\
+			   ARM_SMCCC_OWNER_VENDOR_HYP,			\
+			   ARM_SMCCC_FUNC_QUERY_CALL_UID)
+
+/* KVM UID value: 28b46fb6-2ec5-11e9-a9ca-4b564d003a74 */
+#define ARM_SMCCC_VENDOR_HYP_UID_KVM_REG_0	0xb66fb428U
+#define ARM_SMCCC_VENDOR_HYP_UID_KVM_REG_1	0xe911c52eU
+#define ARM_SMCCC_VENDOR_HYP_UID_KVM_REG_2	0x564bcaa9U
+#define ARM_SMCCC_VENDOR_HYP_UID_KVM_REG_3	0x743a004dU
+
+/* KVM "vendor specific" services */
+#define ARM_SMCCC_KVM_FUNC_FEATURES		0
+#define ARM_SMCCC_KVM_FUNC_FEATURES_2		127
+#define ARM_SMCCC_KVM_NUM_FUNCS			128
+
+#define ARM_SMCCC_VENDOR_HYP_KVM_FEATURES_FUNC_ID			\
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,				\
+			   ARM_SMCCC_SMC_32,				\
+			   ARM_SMCCC_OWNER_VENDOR_HYP,			\
+			   ARM_SMCCC_KVM_FUNC_FEATURES)
+
 #define SMCCC_ARCH_WORKAROUND_RET_UNAFFECTED	1
 
 /* Paravirtualised time calls (defined by ARM DEN0057A) */
-- 
2.29.2

