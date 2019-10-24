Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D830CE2FD4
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 13:03:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405952AbfJXLDF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 07:03:05 -0400
Received: from foss.arm.com ([217.140.110.172]:47536 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393452AbfJXLDE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Oct 2019 07:03:04 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A6C8A7AD;
        Thu, 24 Oct 2019 04:02:50 -0700 (PDT)
Received: from entos-d05.shanghai.arm.com (entos-d05.shanghai.arm.com [10.169.40.35])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id C545E3F71A;
        Thu, 24 Oct 2019 04:02:45 -0700 (PDT)
From:   Jianyong Wu <jianyong.wu@arm.com>
To:     netdev@vger.kernel.org, yangbo.lu@nxp.com, john.stultz@linaro.org,
        tglx@linutronix.de, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, maz@kernel.org,
        richardcochran@gmail.com, Mark.Rutland@arm.com, will@kernel.org,
        suzuki.poulose@arm.com
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Steve.Capper@arm.com, Kaly.Xin@arm.com, justin.he@arm.com,
        jianyong.wu@arm.com, nd@arm.com
Subject: [RFC PATCH v6 5/7] psci: Add hvc call service for ptp_kvm.
Date:   Thu, 24 Oct 2019 19:02:07 +0800
Message-Id: <20191024110209.21328-6-jianyong.wu@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191024110209.21328-1-jianyong.wu@arm.com>
References: <20191024110209.21328-1-jianyong.wu@arm.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is the base of ptp_kvm for arm64.
ptp_kvm modules will call hvc to get this service.
The service offers real time and counter cycle of host for guest.

Signed-off-by: Jianyong Wu <jianyong.wu@arm.com>
---
 drivers/clocksource/arm_arch_timer.c |  2 ++
 include/clocksource/arm_arch_timer.h |  4 ++++
 include/linux/arm-smccc.h            | 12 ++++++++++++
 virt/kvm/arm/psci.c                  | 22 ++++++++++++++++++++++
 4 files changed, 40 insertions(+)

diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
index 07e57a49d1e8..e4ad38042ef6 100644
--- a/drivers/clocksource/arm_arch_timer.c
+++ b/drivers/clocksource/arm_arch_timer.c
@@ -29,6 +29,7 @@
 #include <asm/virt.h>
 
 #include <clocksource/arm_arch_timer.h>
+#include <linux/clocksource_ids.h>
 
 #define CNTTIDR		0x08
 #define CNTTIDR_VIRT(n)	(BIT(1) << ((n) * 4))
@@ -188,6 +189,7 @@ static u64 arch_counter_read_cc(const struct cyclecounter *cc)
 static struct clocksource clocksource_counter = {
 	.name	= "arch_sys_counter",
 	.rating	= 400,
+	.id	= CSID_ARM_ARCH_COUNTER,
 	.read	= arch_counter_read,
 	.mask	= CLOCKSOURCE_MASK(56),
 	.flags	= CLOCK_SOURCE_IS_CONTINUOUS,
diff --git a/include/clocksource/arm_arch_timer.h b/include/clocksource/arm_arch_timer.h
index 1d68d5613dae..426d749e8cf8 100644
--- a/include/clocksource/arm_arch_timer.h
+++ b/include/clocksource/arm_arch_timer.h
@@ -104,6 +104,10 @@ static inline bool arch_timer_evtstrm_available(void)
 	return false;
 }
 
+bool is_arm_arch_counter(void *unuse)
+{
+	return false;
+}
 #endif
 
 #endif
diff --git a/include/linux/arm-smccc.h b/include/linux/arm-smccc.h
index 6f82c87308ed..aafb6bac167d 100644
--- a/include/linux/arm-smccc.h
+++ b/include/linux/arm-smccc.h
@@ -94,6 +94,7 @@
 
 /* KVM "vendor specific" services */
 #define ARM_SMCCC_KVM_FUNC_FEATURES		0
+#define ARM_SMCCC_KVM_PTP			1
 #define ARM_SMCCC_KVM_FUNC_FEATURES_2		127
 #define ARM_SMCCC_KVM_NUM_FUNCS			128
 
@@ -103,6 +104,17 @@
 			   ARM_SMCCC_OWNER_VENDOR_HYP,			\
 			   ARM_SMCCC_KVM_FUNC_FEATURES)
 
+/*
+ * This ID used for virtual ptp kvm clock and it will pass second value
+ * and nanosecond value of host real time and system counter by vcpu
+ * register to guest.
+ */
+#define ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID				\
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,				\
+			   ARM_SMCCC_SMC_32,				\
+			   ARM_SMCCC_OWNER_VENDOR_HYP,			\
+			   ARM_SMCCC_KVM_PTP)
+
 #ifndef __ASSEMBLY__
 
 #include <linux/linkage.h>
diff --git a/virt/kvm/arm/psci.c b/virt/kvm/arm/psci.c
index 0debf49bf259..339bcbafac7b 100644
--- a/virt/kvm/arm/psci.c
+++ b/virt/kvm/arm/psci.c
@@ -15,6 +15,7 @@
 #include <asm/kvm_host.h>
 
 #include <kvm/arm_psci.h>
+#include <linux/clocksource_ids.h>
 
 /*
  * This is an implementation of the Power State Coordination Interface
@@ -392,6 +393,8 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
 	u32 func_id = smccc_get_function(vcpu);
 	u32 val[4] = {};
 	u32 option;
+	u64 cycles;
+	struct system_time_snapshot systime_snapshot;
 
 	val[0] = SMCCC_RET_NOT_SUPPORTED;
 
@@ -431,6 +434,25 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
 	case ARM_SMCCC_VENDOR_HYP_KVM_FEATURES_FUNC_ID:
 		val[0] = BIT(ARM_SMCCC_KVM_FUNC_FEATURES);
 		break;
+	/*
+	 * This will used for virtual ptp kvm clock. three
+	 * values will be passed back.
+	 * reg0 stores high 32-bit host ktime;
+	 * reg1 stores low 32-bit host ktime;
+	 * reg2 stores high 32-bit difference of host cycles and cntvoff;
+	 * reg3 stores low 32-bit difference of host cycles and cntvoff.
+	 */
+	case ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID:
+		ktime_get_snapshot(&systime_snapshot);
+		if (systime_snapshot.cs_id != CSID_ARM_ARCH_COUNTER)
+			return kvm_psci_call(vcpu);
+		val[0] = systime_snapshot.real >> 32;
+		val[1] = systime_snapshot.real << 32 >> 32;
+		cycles = systime_snapshot.cycles -
+			 vcpu_vtimer(vcpu)->cntvoff;
+		val[2] = cycles >> 32;
+		val[3] = cycles << 32 >> 32;
+		break;
 	default:
 		return kvm_psci_call(vcpu);
 	}
-- 
2.17.1

