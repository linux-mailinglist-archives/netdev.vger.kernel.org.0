Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C71A1DE239
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 10:38:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729878AbgEVIi1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 04:38:27 -0400
Received: from foss.arm.com ([217.140.110.172]:59426 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729072AbgEVIiZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 May 2020 04:38:25 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DBDC555D;
        Fri, 22 May 2020 01:38:24 -0700 (PDT)
Received: from entos-d05.shanghai.arm.com (entos-d05.shanghai.arm.com [10.169.40.35])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id BCC243F52E;
        Fri, 22 May 2020 01:38:18 -0700 (PDT)
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
Subject: [RFC PATCH v12 07/11] psci: Add hypercall service for kvm ptp.
Date:   Fri, 22 May 2020 16:37:20 +0800
Message-Id: <20200522083724.38182-8-jianyong.wu@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200522083724.38182-1-jianyong.wu@arm.com>
References: <20200522083724.38182-1-jianyong.wu@arm.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ptp_kvm modules will get this service through smccc call.
The service offers real time and counter cycle of host for guest.
Also let caller determine which cycle of virtual counter or physical counter
to return.

Signed-off-by: Jianyong Wu <jianyong.wu@arm.com>
---
 include/linux/arm-smccc.h | 14 ++++++++++++
 virt/kvm/Kconfig          |  4 ++++
 virt/kvm/arm/hypercalls.c | 47 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 65 insertions(+)

diff --git a/include/linux/arm-smccc.h b/include/linux/arm-smccc.h
index bdc0124a064a..badadc390809 100644
--- a/include/linux/arm-smccc.h
+++ b/include/linux/arm-smccc.h
@@ -94,6 +94,8 @@
 
 /* KVM "vendor specific" services */
 #define ARM_SMCCC_KVM_FUNC_FEATURES		0
+#define ARM_SMCCC_KVM_FUNC_KVM_PTP		1
+#define ARM_SMCCC_KVM_FUNC_KVM_PTP_PHY		2
 #define ARM_SMCCC_KVM_FUNC_FEATURES_2		127
 #define ARM_SMCCC_KVM_NUM_FUNCS			128
 
@@ -103,6 +105,18 @@
 			   ARM_SMCCC_OWNER_VENDOR_HYP,			\
 			   ARM_SMCCC_KVM_FUNC_FEATURES)
 
+#define ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID				\
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,				\
+			   ARM_SMCCC_SMC_32,				\
+			   ARM_SMCCC_OWNER_VENDOR_HYP,			\
+			   ARM_SMCCC_KVM_FUNC_KVM_PTP)
+
+#define ARM_SMCCC_VENDOR_HYP_KVM_PTP_PHY_FUNC_ID			\
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,				\
+			   ARM_SMCCC_SMC_32,				\
+			   ARM_SMCCC_OWNER_VENDOR_HYP,			\
+			   ARM_SMCCC_KVM_FUNC_KVM_PTP_PHY)
+
 #ifndef __ASSEMBLY__
 
 #include <linux/linkage.h>
diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
index aad9284c043a..bf820811e815 100644
--- a/virt/kvm/Kconfig
+++ b/virt/kvm/Kconfig
@@ -60,3 +60,7 @@ config HAVE_KVM_VCPU_RUN_PID_CHANGE
 
 config HAVE_KVM_NO_POLL
        bool
+
+config ARM64_KVM_PTP_HOST
+       def_bool y
+       depends on ARM64 && KVM
diff --git a/virt/kvm/arm/hypercalls.c b/virt/kvm/arm/hypercalls.c
index db6dce3d0e23..c964122f8dae 100644
--- a/virt/kvm/arm/hypercalls.c
+++ b/virt/kvm/arm/hypercalls.c
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
+	u64 cycles;
+#endif
 	u32 func_id = smccc_get_function(vcpu);
 	u32 val[4] = {SMCCC_RET_NOT_SUPPORTED};
 	u32 feature;
@@ -70,7 +75,49 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
 		break;
 	case ARM_SMCCC_VENDOR_HYP_KVM_FEATURES_FUNC_ID:
 		val[0] = BIT(ARM_SMCCC_KVM_FUNC_FEATURES);
+
+#ifdef CONFIG_ARM64_KVM_PTP_HOST
+		val[0] |= BIT(ARM_SMCCC_KVM_FUNC_KVM_PTP);
+#endif
 		break;
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
+		 * asked for is decided by the first argument.
+		 */
+		feature = smccc_get_arg1(vcpu);
+		switch (feature) {
+		case ARM_SMCCC_VENDOR_HYP_KVM_PTP_PHY_FUNC_ID:
+			cycles = systime_snapshot.cycles;
+			break;
+		default:
+			cycles = systime_snapshot.cycles -
+				 vcpu_vtimer(vcpu)->cntvoff;
+		}
+		val[2] = upper_32_bits(cycles);
+		val[3] = lower_32_bits(cycles);
+		break;
+#endif
+
 	default:
 		return kvm_psci_call(vcpu);
 	}
-- 
2.17.1

