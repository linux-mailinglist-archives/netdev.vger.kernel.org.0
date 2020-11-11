Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E2642AE8D2
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 07:23:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726196AbgKKGX0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 01:23:26 -0500
Received: from foss.arm.com ([217.140.110.172]:41840 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726156AbgKKGXR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Nov 2020 01:23:17 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 01C901477;
        Tue, 10 Nov 2020 22:23:17 -0800 (PST)
Received: from localhost.localdomain (entos-thunderx2-desktop.shanghai.arm.com [10.169.212.215])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id A707C3F6CF;
        Tue, 10 Nov 2020 22:23:10 -0800 (PST)
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
Subject: [PATCH v15 6/9] arm64/kvm: Add hypercall service for kvm ptp.
Date:   Wed, 11 Nov 2020 14:22:08 +0800
Message-Id: <20201111062211.33144-7-jianyong.wu@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201111062211.33144-1-jianyong.wu@arm.com>
References: <20201111062211.33144-1-jianyong.wu@arm.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ptp_kvm will get this service through SMCC call.
The service offers wall time and cycle count of host to guest.
The caller must specify whether they want the host cycle count
or the difference between host cycle count and cntvoff.

Signed-off-by: Jianyong Wu <jianyong.wu@arm.com>
---
 arch/arm64/kvm/hypercalls.c | 61 +++++++++++++++++++++++++++++++++++++
 include/linux/arm-smccc.h   | 17 +++++++++++
 2 files changed, 78 insertions(+)

diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
index b9d8607083eb..f7d189563f3d 100644
--- a/arch/arm64/kvm/hypercalls.c
+++ b/arch/arm64/kvm/hypercalls.c
@@ -9,6 +9,51 @@
 #include <kvm/arm_hypercalls.h>
 #include <kvm/arm_psci.h>
 
+static void kvm_ptp_get_time(struct kvm_vcpu *vcpu, u64 *val)
+{
+	struct system_time_snapshot systime_snapshot;
+	u64 cycles = ~0UL;
+	u32 feature;
+
+	/*
+	 * system time and counter value must captured in the same
+	 * time to keep consistency and precision.
+	 */
+	ktime_get_snapshot(&systime_snapshot);
+
+	// binding ptp_kvm clocksource to arm_arch_counter
+	if (systime_snapshot.cs_id != CSID_ARM_ARCH_COUNTER)
+		return;
+
+	val[0] = upper_32_bits(systime_snapshot.real);
+	val[1] = lower_32_bits(systime_snapshot.real);
+
+	/*
+	 * which of virtual counter or physical counter being
+	 * asked for is decided by the r1 value of SMCCC
+	 * call. If no invalid r1 value offered, default cycle
+	 * value(-1) will be returned.
+	 * Note: keep in mind that feature is u32 and smccc_get_arg1
+	 * will return u64, so need auto cast here.
+	 */
+	feature = smccc_get_arg1(vcpu);
+	switch (feature) {
+	case ARM_PTP_VIRT_COUNTER:
+		cycles = systime_snapshot.cycles - vcpu_read_sys_reg(vcpu, CNTVOFF_EL2);
+		break;
+	case ARM_PTP_PHY_COUNTER:
+		cycles = systime_snapshot.cycles;
+		break;
+	case ARM_PTP_NONE_COUNTER:
+		break;
+	default:
+		val[0] = SMCCC_RET_NOT_SUPPORTED;
+		break;
+	}
+	val[2] = upper_32_bits(cycles);
+	val[3] = lower_32_bits(cycles);
+}
+
 int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
 {
 	u32 func_id = smccc_get_function(vcpu);
@@ -79,6 +124,22 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
 		break;
 	case ARM_SMCCC_VENDOR_HYP_KVM_FEATURES_FUNC_ID:
 		val[0] = BIT(ARM_SMCCC_KVM_FUNC_FEATURES);
+		val[0] |= BIT(ARM_SMCCC_KVM_FUNC_KVM_PTP);
+		break;
+	/*
+	 * This serves virtual kvm_ptp.
+	 * Four values will be passed back.
+	 * reg0 stores high 32-bits of host ktime;
+	 * reg1 stores low 32-bits of host ktime;
+	 * For ARM_PTP_VIRT_COUNTER:
+	 * reg2 stores high 32-bits of difference of host cycles and cntvoff;
+	 * reg3 stores low 32-bits of difference of host cycles and cntvoff.
+	 * For ARM_PTP_PHY_COUNTER:
+	 * reg2 stores the high 32-bits of host cycles;
+	 * reg3 stores the low 32-bits of host cycles.
+	 */
+	case ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID:
+		kvm_ptp_get_time(vcpu, val);
 		break;
 	default:
 		return kvm_psci_call(vcpu);
diff --git a/include/linux/arm-smccc.h b/include/linux/arm-smccc.h
index d75408141137..a03c5dd409d3 100644
--- a/include/linux/arm-smccc.h
+++ b/include/linux/arm-smccc.h
@@ -103,6 +103,7 @@
 
 /* KVM "vendor specific" services */
 #define ARM_SMCCC_KVM_FUNC_FEATURES		0
+#define ARM_SMCCC_KVM_FUNC_KVM_PTP		1
 #define ARM_SMCCC_KVM_FUNC_FEATURES_2		127
 #define ARM_SMCCC_KVM_NUM_FUNCS			128
 
@@ -114,6 +115,22 @@
 
 #define SMCCC_ARCH_WORKAROUND_RET_UNAFFECTED	1
 
+/*
+ * ptp_kvm is a feature used for time sync between vm and host.
+ * ptp_kvm module in guest kernel will get service from host using
+ * this hypercall ID.
+ */
+#define ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID				\
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,				\
+			   ARM_SMCCC_SMC_32,				\
+			   ARM_SMCCC_OWNER_VENDOR_HYP,			\
+			   ARM_SMCCC_KVM_FUNC_KVM_PTP)
+
+/* ptp_kvm counter type ID */
+#define ARM_PTP_VIRT_COUNTER			0
+#define ARM_PTP_PHY_COUNTER			1
+#define ARM_PTP_NONE_COUNTER			2
+
 /* Paravirtualised time calls (defined by ARM DEN0057A) */
 #define ARM_SMCCC_HV_PV_TIME_FEATURES				\
 	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,			\
-- 
2.17.1

