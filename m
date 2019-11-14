Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DDAFFC618
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 13:15:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727298AbfKNMPF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 07:15:05 -0500
Received: from foss.arm.com ([217.140.110.172]:42028 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727224AbfKNMPD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Nov 2019 07:15:03 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1BB8AC86;
        Thu, 14 Nov 2019 04:15:03 -0800 (PST)
Received: from entos-d05.shanghai.arm.com (entos-d05.shanghai.arm.com [10.169.40.35])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 553653F6C4;
        Thu, 14 Nov 2019 04:14:57 -0800 (PST)
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
Subject: [RFC PATCH v7 7/7] kvm: arm64: Add capability check extension for ptp_kvm
Date:   Thu, 14 Nov 2019 20:13:58 +0800
Message-Id: <20191114121358.6684-8-jianyong.wu@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191114121358.6684-1-jianyong.wu@arm.com>
References: <20191114121358.6684-1-jianyong.wu@arm.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Let userspace check if there is kvm ptp service in host.
before VMs migrate to a another host, VMM may check if this
cap is available to determine the migration behaviour.

Signed-off-by: Jianyong Wu <jianyong.wu@arm.com>
Suggested-by: Marc Zyngier <maz@kernel.org>
---
 drivers/clocksource/arm_arch_timer.c | 4 ++--
 drivers/ptp/ptp_kvm_arm64.c          | 1 -
 include/uapi/linux/kvm.h             | 1 +
 virt/kvm/arm/arm.c                   | 1 +
 4 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
index b931ae94764f..e407e774ff36 100644
--- a/drivers/clocksource/arm_arch_timer.c
+++ b/drivers/clocksource/arm_arch_timer.c
@@ -1639,7 +1639,7 @@ TIMER_ACPI_DECLARE(arch_timer, ACPI_SIG_GTDT, arch_timer_acpi_init);
 
 #if IS_ENABLED(CONFIG_PTP_1588_CLOCK_KVM)
 #include <linux/arm-smccc.h>
-int kvm_arch_ptp_get_clock_fn(unsigned long *cycle, struct timespec64 *ts,
+int kvm_arch_ptp_get_crosststamp(unsigned long *cycle, struct timespec64 *ts,
 			      struct clocksource **cs)
 {
 	struct arm_smccc_res hvc_res;
@@ -1656,5 +1656,5 @@ int kvm_arch_ptp_get_clock_fn(unsigned long *cycle, struct timespec64 *ts,
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(kvm_arch_ptp_get_clock_fn);
+EXPORT_SYMBOL_GPL(kvm_arch_ptp_get_crosststamp);
 #endif
diff --git a/drivers/ptp/ptp_kvm_arm64.c b/drivers/ptp/ptp_kvm_arm64.c
index 7c697f20904f..f3f957117865 100644
--- a/drivers/ptp/ptp_kvm_arm64.c
+++ b/drivers/ptp/ptp_kvm_arm64.c
@@ -30,7 +30,6 @@ int kvm_arch_ptp_init(void)
 int kvm_arch_ptp_get_clock_generic(struct timespec64 *ts,
 				   struct arm_smccc_res *hvc_res)
 {
-	u64 ns;
 	ktime_t ktime_overall;
 
 	arm_smccc_1_1_invoke(ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID,
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 2fe12b40d503..a0bff6002bd9 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -993,6 +993,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_ARM_SVE 170
 #define KVM_CAP_ARM_PTRAUTH_ADDRESS 171
 #define KVM_CAP_ARM_PTRAUTH_GENERIC 172
+#define KVM_CAP_ARM_KVM_PTP 173
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index bd5c55916d0d..80999985160b 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -201,6 +201,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_MP_STATE:
 	case KVM_CAP_IMMEDIATE_EXIT:
 	case KVM_CAP_VCPU_EVENTS:
+	case KVM_CAP_ARM_KVM_PTP:
 		r = 1;
 		break;
 	case KVM_CAP_ARM_SET_DEVICE_ADDR:
-- 
2.17.1

