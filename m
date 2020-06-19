Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE7C9200542
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 11:35:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732053AbgFSJdx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 05:33:53 -0400
Received: from foss.arm.com ([217.140.110.172]:49316 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731822AbgFSJbg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Jun 2020 05:31:36 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A1CDD1435;
        Fri, 19 Jun 2020 02:31:35 -0700 (PDT)
Received: from entos-d05.shanghai.arm.com (entos-d05.shanghai.arm.com [10.169.40.35])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 73F663F71F;
        Fri, 19 Jun 2020 02:31:29 -0700 (PDT)
From:   Jianyong Wu <jianyong.wu@arm.com>
To:     netdev@vger.kernel.org, yangbo.lu@nxp.com, john.stultz@linaro.org,
        tglx@linutronix.de, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, maz@kernel.org,
        richardcochran@gmail.com, Mark.Rutland@arm.com, will@kernel.org,
        suzuki.poulose@arm.com, steven.price@arm.com
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Steve.Capper@arm.com, Kaly.Xin@arm.com, justin.he@arm.com,
        Wei.Chen@arm.com, jianyong.wu@arm.com, nd@arm.com
Subject: [RFC PATCH v13 7/9] arm64/kvm: Add hypercall service for kvm ptp.
Date:   Fri, 19 Jun 2020 17:30:31 +0800
Message-Id: <20200619093033.58344-8-jianyong.wu@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200619093033.58344-1-jianyong.wu@arm.com>
References: <20200619093033.58344-1-jianyong.wu@arm.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ptp_kvm will get this service through smccc call.
The service offers wall time and counter cycle of host for guest.
caller must explicitly determines which cycle of virtual counter or
physical counter to return if it needs counter cycle.

Signed-off-by: Jianyong Wu <jianyong.wu@arm.com>
---
 arch/arm64/kvm/Kconfig      |  6 +++++
 arch/arm64/kvm/hypercalls.c | 50 +++++++++++++++++++++++++++++++++++++
 include/linux/arm-smccc.h   | 30 ++++++++++++++++++++++
 3 files changed, 86 insertions(+)

diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index 13489aff4440..79091f6e5e7a 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -60,6 +60,12 @@ config KVM_ARM_PMU
 config KVM_INDIRECT_VECTORS
 	def_bool HARDEN_BRANCH_PREDICTOR || HARDEN_EL2_VECTORS
 
+config ARM64_KVM_PTP_HOST
+	bool "KVM PTP host service for arm64"
+	default y
+	help
+	  virtual kvm ptp clock hypercall service for arm64
+
 endif # KVM
 
 endif # VIRTUALIZATION
diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
index db6dce3d0e23..366b0646c360 100644
--- a/arch/arm64/kvm/hypercalls.c
+++ b/arch/arm64/kvm/hypercalls.c
@@ -3,6 +3,7 @@
 
 #include <linux/arm-smccc.h>
 #include <linux/kvm_host.h>
+#include <linux/clocksource_ids.h>
 
 #include <asm/kvm_emulate.h>
 
@@ -11,6 +12,10 @@
 
 int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
 {
+#ifdef CONFIG_ARM64_KVM_PTP_HOST
+	struct system_time_snapshot systime_snapshot;
+	u64 cycles = 0;
+#endif
 	u32 func_id = smccc_get_function(vcpu);
 	u32 val[4] = {SMCCC_RET_NOT_SUPPORTED};
 	u32 feature;
@@ -70,7 +75,52 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
 		break;
 	case ARM_SMCCC_VENDOR_HYP_KVM_FEATURES_FUNC_ID:
 		val[0] = BIT(ARM_SMCCC_KVM_FUNC_FEATURES);
+
+#ifdef CONFIG_ARM64_KVM_PTP_HOST
+		val[0] |= BIT(ARM_SMCCC_KVM_FUNC_KVM_PTP);
+#endif
+		break;
+
+#ifdef CONFIG_ARM64_KVM_PTP_HOST
+	/*
+	 * This serves virtual kvm_ptp.
+	 * Four values will be passed back.
+	 * reg0 stores high 32-bit host ktime;
+	 * reg1 stores low 32-bit host ktime;
+	 * reg2 stores high 32-bit difference of host cycles and cntvoff;
+	 * reg3 stores low 32-bit difference of host cycles and cntvoff.
+	 */
+	case ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID:
+		/*
+		 * system time and counter value must captured in the same
+		 * time to keep consistency and precision.
+		 */
+		ktime_get_snapshot(&systime_snapshot);
+		if (systime_snapshot.cs_id != CSID_ARM_ARCH_COUNTER)
+			break;
+		val[0] = upper_32_bits(systime_snapshot.real);
+		val[1] = lower_32_bits(systime_snapshot.real);
+		/*
+		 * which of virtual counter or physical counter being
+		 * asked for is decided by the first argument of smccc
+		 * call. If no first argument or invalid argument, zero
+		 * counter value will return;
+		 */
+		feature = smccc_get_arg1(vcpu);
+		switch (feature) {
+		case ARM_PTP_VIRT_COUNTER:
+			cycles = systime_snapshot.cycles -
+			vcpu_vtimer(vcpu)->cntvoff;
+			break;
+		case ARM_PTP_PHY_COUNTER:
+			cycles = systime_snapshot.cycles;
+			break;
+		}
+		val[2] = upper_32_bits(cycles);
+		val[3] = lower_32_bits(cycles);
 		break;
+#endif
+
 	default:
 		return kvm_psci_call(vcpu);
 	}
diff --git a/include/linux/arm-smccc.h b/include/linux/arm-smccc.h
index 86ff30131e7b..e593ec515f82 100644
--- a/include/linux/arm-smccc.h
+++ b/include/linux/arm-smccc.h
@@ -98,6 +98,9 @@
 
 /* KVM "vendor specific" services */
 #define ARM_SMCCC_KVM_FUNC_FEATURES		0
+#define ARM_SMCCC_KVM_FUNC_KVM_PTP		1
+#define ARM_SMCCC_KVM_FUNC_KVM_PTP_PHY		2
+#define ARM_SMCCC_KVM_FUNC_KVM_PTP_VIRT		3
 #define ARM_SMCCC_KVM_FUNC_FEATURES_2		127
 #define ARM_SMCCC_KVM_NUM_FUNCS			128
 
@@ -107,6 +110,33 @@
 			   ARM_SMCCC_OWNER_VENDOR_HYP,			\
 			   ARM_SMCCC_KVM_FUNC_FEATURES)
 
+/*
+ * kvm_ptp is a feature used for time sync between vm and host.
+ * kvm_ptp module in guest kernel will get service from host using
+ * this hypercall ID.
+ */
+#define ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID				\
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,				\
+			   ARM_SMCCC_SMC_32,				\
+			   ARM_SMCCC_OWNER_VENDOR_HYP,			\
+			   ARM_SMCCC_KVM_FUNC_KVM_PTP)
+
+/*
+ * kvm_ptp may get counter cycle from host and should ask for which of
+ * physical counter or virtual counter by using ARM_PTP_PHY_COUNTER and
+ * ARM_PTP_VIRT_COUNTER explicitly.
+ */
+#define ARM_PTP_PHY_COUNTER						\
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,				\
+			   ARM_SMCCC_SMC_32,				\
+			   ARM_SMCCC_OWNER_VENDOR_HYP,			\
+			   ARM_SMCCC_KVM_FUNC_KVM_PTP_PHY)
+
+#define ARM_PTP_VIRT_COUNTER						\
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,				\
+			   ARM_SMCCC_SMC_32,				\
+			   ARM_SMCCC_OWNER_VENDOR_HYP,			\
+			   ARM_SMCCC_KVM_FUNC_KVM_PTP_VIRT)
 #ifndef __ASSEMBLY__
 
 #include <linux/linkage.h>
-- 
2.17.1

