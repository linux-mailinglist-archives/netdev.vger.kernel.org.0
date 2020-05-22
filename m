Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E5881DE24B
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 10:39:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729997AbgEVIir (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 04:38:47 -0400
Received: from foss.arm.com ([217.140.110.172]:59512 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729432AbgEVIio (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 May 2020 04:38:44 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A98C21042;
        Fri, 22 May 2020 01:38:43 -0700 (PDT)
Received: from entos-d05.shanghai.arm.com (entos-d05.shanghai.arm.com [10.169.40.35])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id CE0E13F52E;
        Fri, 22 May 2020 01:38:37 -0700 (PDT)
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
Subject: [RFC PATCH v12 10/11] arm64: add mechanism to let user choose which counter to return
Date:   Fri, 22 May 2020 16:37:23 +0800
Message-Id: <20200522083724.38182-11-jianyong.wu@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200522083724.38182-1-jianyong.wu@arm.com>
References: <20200522083724.38182-1-jianyong.wu@arm.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In general, vm inside will use virtual counter compered with host use
phyical counter. But in some special scenarios, like nested
virtualization, phyical counter maybe used by vm. A interface added in
ptp_kvm driver to offer a mechanism to let user choose which counter
should be return from host.
To use this feature, you should call PTP_EXTTS_REQUEST(2) ioctl with flag
set bit PTP_KVM_ARM_PHY_COUNTER in its argument then call
PTP_SYS_OFFSET_PRECISE(2) ioctl to get the cross timestamp and phyical
counter will return. If the bit not set or no call for PTP_EXTTS_REQUEST2,
virtual counter will return by default.

Signed-off-by: Jianyong Wu <jianyong.wu@arm.com>
Suggested-by: Marc Zyngier <maz@kernel.org>
---
 drivers/clocksource/arm_arch_timer.c | 13 ++++++++++++-
 drivers/ptp/ptp_chardev.c            | 25 +++++++++++++++++++++++++
 drivers/ptp/ptp_kvm_common.c         |  7 ++++---
 include/uapi/linux/ptp_clock.h       |  4 +++-
 4 files changed, 44 insertions(+), 5 deletions(-)

diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
index 06959b901b0d..75a3bb118201 100644
--- a/drivers/clocksource/arm_arch_timer.c
+++ b/drivers/clocksource/arm_arch_timer.c
@@ -1650,7 +1650,18 @@ int kvm_arch_ptp_get_crosststamp(unsigned long *cycle, struct timespec64 *ts,
 	struct arm_smccc_res hvc_res;
 	ktime_t ktime_overall;
 
-	arm_smccc_1_1_invoke(ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID, &hvc_res);
+	/*
+	 * an argument will be passed by a0 to determine weather virtual
+	 * counter or phyical counter should be passed back.
+	 */
+	if (ctx && *ctx)
+		arm_smccc_1_1_invoke(ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID,
+				     ARM_SMCCC_VENDOR_HYP_KVM_PTP_PHY_FUNC_ID,
+				     &hvc_res);
+	else
+		arm_smccc_1_1_invoke(ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID,
+				     &hvc_res);
+
 	if ((int)(hvc_res.a0) < 0)
 		return -EOPNOTSUPP;
 
diff --git a/drivers/ptp/ptp_chardev.c b/drivers/ptp/ptp_chardev.c
index fef72f29f3c8..8b0a7b328bcd 100644
--- a/drivers/ptp/ptp_chardev.c
+++ b/drivers/ptp/ptp_chardev.c
@@ -123,6 +123,9 @@ long ptp_ioctl(struct posix_clock *pc, unsigned int cmd, unsigned long arg)
 	struct timespec64 ts;
 	int enable, err = 0;
 
+#ifdef CONFIG_ARM64
+	static long flag;
+#endif
 	switch (cmd) {
 
 	case PTP_CLOCK_GETCAPS:
@@ -149,6 +152,24 @@ long ptp_ioctl(struct posix_clock *pc, unsigned int cmd, unsigned long arg)
 			err = -EFAULT;
 			break;
 		}
+
+#ifdef CONFIG_ARM64
+		/*
+		 * Just using this ioctl to tell kvm ptp driver to get PHC
+		 * with physical counter, so if bit PTP_KVM_ARM_PHY_COUNTER
+		 * is set then just exit directly.
+		 * In most cases, we just need virtual counter from host and
+		 * there is limited scenario using this to get physical counter
+		 * in guest.
+		 * Be careful to use this as there is no way to set it back
+		 * unless you reinstall the module.
+		 * This is only for arm64.
+		 */
+		if (req.extts.flags & PTP_KVM_ARM_PHY_COUNTER) {
+			flag = 1;
+			break;
+		}
+#endif
 		if (cmd == PTP_EXTTS_REQUEST2) {
 			/* Tell the drivers to check the flags carefully. */
 			req.extts.flags |= PTP_STRICT_FLAGS;
@@ -235,7 +256,11 @@ long ptp_ioctl(struct posix_clock *pc, unsigned int cmd, unsigned long arg)
 			err = -EOPNOTSUPP;
 			break;
 		}
+#ifdef CONFIG_ARM64
+		err = ptp->info->getcrosststamp(ptp->info, &xtstamp, &flag);
+#else
 		err = ptp->info->getcrosststamp(ptp->info, &xtstamp, NULL);
+#endif
 		if (err)
 			break;
 
diff --git a/drivers/ptp/ptp_kvm_common.c b/drivers/ptp/ptp_kvm_common.c
index 4fdd8ab11a28..39367e230176 100644
--- a/drivers/ptp/ptp_kvm_common.c
+++ b/drivers/ptp/ptp_kvm_common.c
@@ -36,7 +36,7 @@ static int ptp_kvm_get_time_fn(ktime_t *device_time,
 	spin_lock(&kvm_ptp_lock);
 
 	preempt_disable_notrace();
-	ret = kvm_arch_ptp_get_crosststamp(&cycle, &tspec, &cs);
+	ret = kvm_arch_ptp_get_crosststamp(&cycle, &tspec, &cs, ctx);
 	if (ret != 0) {
 		pr_err_ratelimited("clock pairing hypercall ret %lu\n", ret);
 		spin_unlock(&kvm_ptp_lock);
@@ -57,9 +57,10 @@ static int ptp_kvm_get_time_fn(ktime_t *device_time,
 }
 
 static int ptp_kvm_getcrosststamp(struct ptp_clock_info *ptp,
-				  struct system_device_crosststamp *xtstamp)
+				  struct system_device_crosststamp *xtstamp,
+				  long *flag)
 {
-	return get_device_system_crosststamp(ptp_kvm_get_time_fn, NULL,
+	return get_device_system_crosststamp(ptp_kvm_get_time_fn, flag,
 					     NULL, xtstamp);
 }
 
diff --git a/include/uapi/linux/ptp_clock.h b/include/uapi/linux/ptp_clock.h
index 9dc9d0079e98..71e388a82244 100644
--- a/include/uapi/linux/ptp_clock.h
+++ b/include/uapi/linux/ptp_clock.h
@@ -32,6 +32,7 @@
 #define PTP_RISING_EDGE    (1<<1)
 #define PTP_FALLING_EDGE   (1<<2)
 #define PTP_STRICT_FLAGS   (1<<3)
+#define PTP_KVM_ARM_PHY_COUNTER (1<<4)
 #define PTP_EXTTS_EDGES    (PTP_RISING_EDGE | PTP_FALLING_EDGE)
 
 /*
@@ -40,7 +41,8 @@
 #define PTP_EXTTS_VALID_FLAGS	(PTP_ENABLE_FEATURE |	\
 				 PTP_RISING_EDGE |	\
 				 PTP_FALLING_EDGE |	\
-				 PTP_STRICT_FLAGS)
+				 PTP_STRICT_FLAGS |	\
+				 PTP_KVM_ARM_PHY_COUNTER)
 
 /*
  * flag fields valid for the original PTP_EXTTS_REQUEST ioctl.
-- 
2.17.1

