Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF1F634EB47
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 16:55:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232388AbhC3OzX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 10:55:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:55612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231967AbhC3Oyw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Mar 2021 10:54:52 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AF2D0619C8;
        Tue, 30 Mar 2021 14:54:50 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1lRFlY-004hoo-Q6; Tue, 30 Mar 2021 15:54:49 +0100
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
Subject: [PATCH v19 6/7] KVM: arm64: Add support for the KVM PTP service
Date:   Tue, 30 Mar 2021 15:54:29 +0100
Message-Id: <20210330145430.996981-7-maz@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210330145430.996981-1-maz@kernel.org>
References: <20210330145430.996981-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: netdev@vger.kernel.org, yangbo.lu@nxp.com, john.stultz@linaro.org, tglx@linutronix.de, pbonzini@redhat.com, seanjc@google.com, richardcochran@gmail.com, Mark.Rutland@arm.com, will@kernel.org, suzuki.poulose@arm.com, Andre.Przywara@arm.com, steven.price@arm.com, lorenzo.pieralisi@arm.com, sudeep.holla@arm.com, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, Steve.Capper@arm.com, justin.he@arm.com, jianyong.wu@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jianyong Wu <jianyong.wu@arm.com>

Implement the hypervisor side of the KVM PTP interface.

The service offers wall time and cycle count from host to guest.
The caller must specify whether they want the host's view of
either the virtual or physical counter.

Signed-off-by: Jianyong Wu <jianyong.wu@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20201209060932.212364-7-jianyong.wu@arm.com
---
 Documentation/virt/kvm/api.rst         | 10 +++++
 Documentation/virt/kvm/arm/index.rst   |  1 +
 Documentation/virt/kvm/arm/ptp_kvm.rst | 25 ++++++++++++
 arch/arm64/kvm/arm.c                   |  1 +
 arch/arm64/kvm/hypercalls.c            | 53 ++++++++++++++++++++++++++
 include/linux/arm-smccc.h              | 16 ++++++++
 include/uapi/linux/kvm.h               |  1 +
 7 files changed, 107 insertions(+)
 create mode 100644 Documentation/virt/kvm/arm/ptp_kvm.rst

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 38e327d4b479..987d99e39887 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6724,3 +6724,13 @@ vcpu_info is set.
 The KVM_XEN_HVM_CONFIG_RUNSTATE flag indicates that the runstate-related
 features KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_ADDR/_CURRENT/_DATA/_ADJUST are
 supported by the KVM_XEN_VCPU_SET_ATTR/KVM_XEN_VCPU_GET_ATTR ioctls.
+
+8.31 KVM_CAP_PTP_KVM
+--------------------
+
+:Architectures: arm64
+
+This capability indicates that the KVM virtual PTP service is
+supported in the host. A VMM can check whether the service is
+available to the guest on migration.
+
diff --git a/Documentation/virt/kvm/arm/index.rst b/Documentation/virt/kvm/arm/index.rst
index 3e2b2aba90fc..78a9b670aafe 100644
--- a/Documentation/virt/kvm/arm/index.rst
+++ b/Documentation/virt/kvm/arm/index.rst
@@ -10,3 +10,4 @@ ARM
    hyp-abi
    psci
    pvtime
+   ptp_kvm
diff --git a/Documentation/virt/kvm/arm/ptp_kvm.rst b/Documentation/virt/kvm/arm/ptp_kvm.rst
new file mode 100644
index 000000000000..68cffb50d8bf
--- /dev/null
+++ b/Documentation/virt/kvm/arm/ptp_kvm.rst
@@ -0,0 +1,25 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+PTP_KVM support for arm/arm64
+=============================
+
+PTP_KVM is used for high precision time sync between host and guests.
+It relies on transferring the wall clock and counter value from the
+host to the guest using a KVM-specific hypercall.
+
+* ARM_SMCCC_HYP_KVM_PTP_FUNC_ID: 0x86000001
+
+This hypercall uses the SMC32/HVC32 calling convention:
+
+ARM_SMCCC_HYP_KVM_PTP_FUNC_ID
+    =============    ==========    ==========
+    Function ID:     (uint32)      0x86000001
+    Arguments:       (uint32)      KVM_PTP_VIRT_COUNTER(0)
+                                   KVM_PTP_PHYS_COUNTER(1)
+    Return Values:   (int32)       NOT_SUPPORTED(-1) on error, or
+                     (uint32)      Upper 32 bits of wall clock time (r0)
+                     (uint32)      Lower 32 bits of wall clock time (r1)
+                     (uint32)      Upper 32 bits of counter (r2)
+                     (uint32)      Lower 32 bits of counter (r3)
+    Endianness:                    No Restrictions.
+    =============    ==========    ==========
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 7f06ba76698d..46401798c644 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -206,6 +206,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_ARM_INJECT_EXT_DABT:
 	case KVM_CAP_SET_GUEST_DEBUG:
 	case KVM_CAP_VCPU_ATTRIBUTES:
+	case KVM_CAP_PTP_KVM:
 		r = 1;
 		break;
 	case KVM_CAP_ARM_SET_DEVICE_ADDR:
diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
index 78d32c34d49c..30da78f72b3b 100644
--- a/arch/arm64/kvm/hypercalls.c
+++ b/arch/arm64/kvm/hypercalls.c
@@ -9,6 +9,55 @@
 #include <kvm/arm_hypercalls.h>
 #include <kvm/arm_psci.h>
 
+static void kvm_ptp_get_time(struct kvm_vcpu *vcpu, u64 *val)
+{
+	struct system_time_snapshot systime_snapshot;
+	u64 cycles = ~0UL;
+	u32 feature;
+
+	/*
+	 * system time and counter value must captured at the same
+	 * time to keep consistency and precision.
+	 */
+	ktime_get_snapshot(&systime_snapshot);
+
+	/*
+	 * This is only valid if the current clocksource is the
+	 * architected counter, as this is the only one the guest
+	 * can see.
+	 */
+	if (systime_snapshot.cs_id != CSID_ARM_ARCH_COUNTER)
+		return;
+
+	/*
+	 * The guest selects one of the two reference counters
+	 * (virtual or physical) with the first argument of the SMCCC
+	 * call. In case the identifier is not supported, error out.
+	 */
+	feature = smccc_get_arg1(vcpu);
+	switch (feature) {
+	case KVM_PTP_VIRT_COUNTER:
+		cycles = systime_snapshot.cycles - vcpu_read_sys_reg(vcpu, CNTVOFF_EL2);
+		break;
+	case KVM_PTP_PHYS_COUNTER:
+		cycles = systime_snapshot.cycles;
+		break;
+	default:
+		return;
+	}
+
+	/*
+	 * This relies on the top bit of val[0] never being set for
+	 * valid values of system time, because that is *really* far
+	 * in the future (about 292 years from 1970, and at that stage
+	 * nobody will give a damn about it).
+	 */
+	val[0] = upper_32_bits(systime_snapshot.real);
+	val[1] = lower_32_bits(systime_snapshot.real);
+	val[2] = upper_32_bits(cycles);
+	val[3] = lower_32_bits(cycles);
+}
+
 int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
 {
 	u32 func_id = smccc_get_function(vcpu);
@@ -79,6 +128,10 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
 		break;
 	case ARM_SMCCC_VENDOR_HYP_KVM_FEATURES_FUNC_ID:
 		val[0] = BIT(ARM_SMCCC_KVM_FUNC_FEATURES);
+		val[0] |= BIT(ARM_SMCCC_KVM_FUNC_PTP);
+		break;
+	case ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID:
+		kvm_ptp_get_time(vcpu, val);
 		break;
 	case ARM_SMCCC_TRNG_VERSION:
 	case ARM_SMCCC_TRNG_FEATURES:
diff --git a/include/linux/arm-smccc.h b/include/linux/arm-smccc.h
index 1a27bd9493fe..6861489a1890 100644
--- a/include/linux/arm-smccc.h
+++ b/include/linux/arm-smccc.h
@@ -103,6 +103,7 @@
 
 /* KVM "vendor specific" services */
 #define ARM_SMCCC_KVM_FUNC_FEATURES		0
+#define ARM_SMCCC_KVM_FUNC_PTP			1
 #define ARM_SMCCC_KVM_FUNC_FEATURES_2		127
 #define ARM_SMCCC_KVM_NUM_FUNCS			128
 
@@ -114,6 +115,21 @@
 
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
+			   ARM_SMCCC_KVM_FUNC_PTP)
+
+/* ptp_kvm counter type ID */
+#define KVM_PTP_VIRT_COUNTER			0
+#define KVM_PTP_PHYS_COUNTER			1
+
 /* Paravirtualised time calls (defined by ARM DEN0057A) */
 #define ARM_SMCCC_HV_PV_TIME_FEATURES				\
 	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,			\
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index f6afee209620..0e0f70c0d0dc 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1078,6 +1078,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_DIRTY_LOG_RING 192
 #define KVM_CAP_X86_BUS_LOCK_EXIT 193
 #define KVM_CAP_PPC_DAWR1 194
+#define KVM_CAP_PTP_KVM 195
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
2.29.2

