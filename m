Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CAEE2AE8C8
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 07:23:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726056AbgKKGWy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 01:22:54 -0500
Received: from foss.arm.com ([217.140.110.172]:41698 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726015AbgKKGWo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Nov 2020 01:22:44 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9FA0B1063;
        Tue, 10 Nov 2020 22:22:42 -0800 (PST)
Received: from localhost.localdomain (entos-thunderx2-desktop.shanghai.arm.com [10.169.212.215])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 5179C3F6CF;
        Tue, 10 Nov 2020 22:22:36 -0800 (PST)
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
Subject: [PATCH v15 1/9] arm64: Probe for the presence of KVM hypervisor
Date:   Wed, 11 Nov 2020 14:22:03 +0800
Message-Id: <20201111062211.33144-2-jianyong.wu@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201111062211.33144-1-jianyong.wu@arm.com>
References: <20201111062211.33144-1-jianyong.wu@arm.com>
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

Change from Jianyong Wu:
mv kvm_arm_hyp_service_available to common place to let both arm/arm64 touch it.
add kvm_init_hyp_services also under arm arch to let arm kvm guest use this service.

Cc: Marc Zyngier <maz@kernel.org>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Jianyong Wu <jianyong.wu@arm.com>
---
 arch/arm/kernel/setup.c        |  1 +
 arch/arm64/kernel/setup.c      |  1 +
 drivers/firmware/smccc/smccc.c | 37 +++++++++++++++++++++++++++++
 include/linux/arm-smccc.h      | 43 ++++++++++++++++++++++++++++++++++
 4 files changed, 82 insertions(+)

diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
index 3f65d0ac9f63..bbe2e88f8415 100644
--- a/arch/arm/kernel/setup.c
+++ b/arch/arm/kernel/setup.c
@@ -1145,6 +1145,7 @@ void __init setup_arch(char **cmdline_p)
 
 	arm_dt_init_cpu_maps();
 	psci_dt_init();
+	kvm_init_hyp_services();
 #ifdef CONFIG_SMP
 	if (is_smp()) {
 		if (!mdesc->smp_init || !mdesc->smp_init()) {
diff --git a/arch/arm64/kernel/setup.c b/arch/arm64/kernel/setup.c
index 133257ffd859..d1dbe41620df 100644
--- a/arch/arm64/kernel/setup.c
+++ b/arch/arm64/kernel/setup.c
@@ -353,6 +353,7 @@ void __init __no_sanitize_address setup_arch(char **cmdline_p)
 	else
 		psci_acpi_init();
 
+	kvm_init_hyp_services();
 	init_bootcpu_ops();
 	smp_init_cpus();
 	smp_build_mpidr_hash();
diff --git a/drivers/firmware/smccc/smccc.c b/drivers/firmware/smccc/smccc.c
index 00c88b809c0c..e153c71ece99 100644
--- a/drivers/firmware/smccc/smccc.c
+++ b/drivers/firmware/smccc/smccc.c
@@ -7,10 +7,47 @@
 
 #include <linux/init.h>
 #include <linux/arm-smccc.h>
+#include <linux/kernel.h>
+#include <linux/string.h>
 
 static u32 smccc_version = ARM_SMCCC_VERSION_1_0;
 static enum arm_smccc_conduit smccc_conduit = SMCCC_CONDUIT_NONE;
 
+DECLARE_BITMAP(__kvm_arm_hyp_services, ARM_SMCCC_KVM_NUM_FUNCS) = { };
+EXPORT_SYMBOL_GPL(__kvm_arm_hyp_services);
+
+void __init kvm_init_hyp_services(void)
+{
+	int i;
+	struct arm_smccc_res res;
+
+	if (arm_smccc_get_version() == ARM_SMCCC_VERSION_1_0)
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
+	for (i = 0; i < 32; ++i) {
+		if (res.a0 & (i))
+			set_bit(i + (32 * 0), __kvm_arm_hyp_services);
+		if (res.a1 & (i))
+			set_bit(i + (32 * 1), __kvm_arm_hyp_services);
+		if (res.a2 & (i))
+			set_bit(i + (32 * 2), __kvm_arm_hyp_services);
+		if (res.a3 & (i))
+			set_bit(i + (32 * 3), __kvm_arm_hyp_services);
+	}
+
+	pr_info("KVM hypervisor services detected (0x%08lx 0x%08lx 0x%08lx 0x%08lx)\n",
+		 res.a3, res.a2, res.a1, res.a0);
+}
+
 void __init arm_smccc_version_init(u32 version, enum arm_smccc_conduit conduit)
 {
 	smccc_version = version;
diff --git a/include/linux/arm-smccc.h b/include/linux/arm-smccc.h
index f860645f6512..d75408141137 100644
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
@@ -391,5 +416,23 @@ asmlinkage void __arm_smccc_hvc(unsigned long a0, unsigned long a1,
 		method;							\
 	})
 
+void __init kvm_init_hyp_services(void);
+
+/*
+ * This helper will be called in guest. We put it here then both arm and arm64
+ * guest can touch it.
+ */
+#include <linux/kernel.h>
+#include <linux/err.h>
+static inline bool kvm_arm_hyp_service_available(u32 func_id)
+{
+	extern DECLARE_BITMAP(__kvm_arm_hyp_services, ARM_SMCCC_KVM_NUM_FUNCS);
+
+	if (func_id >= ARM_SMCCC_KVM_NUM_FUNCS)
+		return -EINVAL;
+
+	return test_bit(func_id, __kvm_arm_hyp_services);
+}
+
 #endif /*__ASSEMBLY__*/
 #endif /*__LINUX_ARM_SMCCC_H*/
-- 
2.17.1

