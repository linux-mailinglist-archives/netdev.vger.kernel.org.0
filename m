Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FBF0157117
	for <lists+netdev@lfdr.de>; Mon, 10 Feb 2020 09:50:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727791AbgBJIuH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Feb 2020 03:50:07 -0500
Received: from foss.arm.com ([217.140.110.172]:57632 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727778AbgBJIuH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Feb 2020 03:50:07 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B2D57328;
        Mon, 10 Feb 2020 00:50:06 -0800 (PST)
Received: from entos-d05.shanghai.arm.com (entos-d05.shanghai.arm.com [10.169.40.35])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 8E1CD3F68F;
        Mon, 10 Feb 2020 00:50:01 -0800 (PST)
From:   Jianyong Wu <jianyong.wu@arm.com>
To:     netdev@vger.kernel.org, yangbo.lu@nxp.com, john.stultz@linaro.org,
        tglx@linutronix.de, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, maz@kernel.org,
        richardcochran@gmail.com, Mark.Rutland@arm.com, will@kernel.org,
        suzuki.poulose@arm.com, steven.price@arm.com
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Steve.Capper@arm.com, Kaly.Xin@arm.com, justin.he@arm.com,
        jianyong.wu@arm.com, nd@arm.com
Subject: [RFC PATCH 7/9] ptp: extend input argument for getcrosstimestamp API
Date:   Mon, 10 Feb 2020 16:49:04 +0800
Message-Id: <20200210084906.24870-8-jianyong.wu@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200210084906.24870-1-jianyong.wu@arm.com>
References: <20200210084906.24870-1-jianyong.wu@arm.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sometimes we may need tell getcrosstimestamp call back how to perform
itself. Extending input arguments for getcrosstimestamp API to offer more
exquisite control for the operation.

Signed-off-by: Jianyong Wu <jianyong.wu@arm.com>
---
 drivers/clocksource/arm_arch_timer.c    | 2 +-
 drivers/net/ethernet/intel/e1000e/ptp.c | 3 ++-
 drivers/ptp/ptp_chardev.c               | 2 +-
 drivers/ptp/ptp_kvm.h                   | 2 +-
 drivers/ptp/ptp_kvm_x86.c               | 2 +-
 include/linux/ptp_clock_kernel.h        | 3 ++-
 6 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
index 4e57ab66165c..b1bc8bd198c2 100644
--- a/drivers/clocksource/arm_arch_timer.c
+++ b/drivers/clocksource/arm_arch_timer.c
@@ -1629,7 +1629,7 @@ TIMER_ACPI_DECLARE(arch_timer, ACPI_SIG_GTDT, arch_timer_acpi_init);
 #if IS_ENABLED(CONFIG_PTP_1588_CLOCK_KVM)
 #include <linux/arm-smccc.h>
 int kvm_arch_ptp_get_crosststamp(unsigned long *cycle, struct timespec64 *ts,
-			      struct clocksource **cs)
+				 struct clocksource **cs, long *ctx)
 {
 	struct arm_smccc_res hvc_res;
 	ktime_t ktime_overall;
diff --git a/drivers/net/ethernet/intel/e1000e/ptp.c b/drivers/net/ethernet/intel/e1000e/ptp.c
index eaa5a0fb99f0..7a45d9634962 100644
--- a/drivers/net/ethernet/intel/e1000e/ptp.c
+++ b/drivers/net/ethernet/intel/e1000e/ptp.c
@@ -150,7 +150,8 @@ static int e1000e_phc_get_syncdevicetime(ktime_t *device,
  * clock values in ns.
  **/
 static int e1000e_phc_getcrosststamp(struct ptp_clock_info *ptp,
-				     struct system_device_crosststamp *xtstamp)
+				     struct system_device_crosststamp *xtstamp,
+				     NULL)
 {
 	struct e1000_adapter *adapter = container_of(ptp, struct e1000_adapter,
 						     ptp_clock_info);
diff --git a/drivers/ptp/ptp_chardev.c b/drivers/ptp/ptp_chardev.c
index 9d72ab593f13..09c3f1e5382d 100644
--- a/drivers/ptp/ptp_chardev.c
+++ b/drivers/ptp/ptp_chardev.c
@@ -226,7 +226,7 @@ long ptp_ioctl(struct posix_clock *pc, unsigned int cmd, unsigned long arg)
 			err = -EOPNOTSUPP;
 			break;
 		}
-		err = ptp->info->getcrosststamp(ptp->info, &xtstamp);
+		err = ptp->info->getcrosststamp(ptp->info, &xtstamp, NULL);
 		if (err)
 			break;
 
diff --git a/drivers/ptp/ptp_kvm.h b/drivers/ptp/ptp_kvm.h
index 4bf1802bbeb8..ccceacbe8398 100644
--- a/drivers/ptp/ptp_kvm.h
+++ b/drivers/ptp/ptp_kvm.h
@@ -8,4 +8,4 @@
 int kvm_arch_ptp_init(void);
 int kvm_arch_ptp_get_clock(struct timespec64 *ts);
 int kvm_arch_ptp_get_crosststamp(unsigned long *cycle,
-		struct timespec64 *tspec, void *cs);
+		struct timespec64 *tspec, struct clocksource **cs, long *ctx);
diff --git a/drivers/ptp/ptp_kvm_x86.c b/drivers/ptp/ptp_kvm_x86.c
index 6c891d7299c6..ff95d2791078 100644
--- a/drivers/ptp/ptp_kvm_x86.c
+++ b/drivers/ptp/ptp_kvm_x86.c
@@ -53,7 +53,7 @@ int kvm_arch_ptp_get_clock(struct timespec64 *ts)
 }
 
 int kvm_arch_ptp_get_crosststamp(unsigned long *cycle, struct timespec64 *tspec,
-			      struct clocksource **cs)
+			      struct clocksource **cs, void *ctx)
 {
 	unsigned long ret;
 	unsigned int version;
diff --git a/include/linux/ptp_clock_kernel.h b/include/linux/ptp_clock_kernel.h
index c64a1ef87240..29c5fff7aeda 100644
--- a/include/linux/ptp_clock_kernel.h
+++ b/include/linux/ptp_clock_kernel.h
@@ -133,7 +133,8 @@ struct ptp_clock_info {
 	int (*gettimex64)(struct ptp_clock_info *ptp, struct timespec64 *ts,
 			  struct ptp_system_timestamp *sts);
 	int (*getcrosststamp)(struct ptp_clock_info *ptp,
-			      struct system_device_crosststamp *cts);
+			      struct system_device_crosststamp *cts,
+			      long *flag);
 	int (*settime64)(struct ptp_clock_info *p, const struct timespec64 *ts);
 	int (*enable)(struct ptp_clock_info *ptp,
 		      struct ptp_clock_request *request, int on);
-- 
2.17.1

