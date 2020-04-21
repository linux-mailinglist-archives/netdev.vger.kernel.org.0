Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 063FF1B1CB0
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 05:24:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728420AbgDUDYS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 23:24:18 -0400
Received: from foss.arm.com ([217.140.110.172]:57530 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728394AbgDUDYP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 23:24:15 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D680F31B;
        Mon, 20 Apr 2020 20:24:14 -0700 (PDT)
Received: from entos-d05.shanghai.arm.com (entos-d05.shanghai.arm.com [10.169.40.35])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id D7E983F6CF;
        Mon, 20 Apr 2020 20:24:07 -0700 (PDT)
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
Subject: [RFC PATCH v11 7/9] ptp: extend input argument for getcrosstimestamp API
Date:   Tue, 21 Apr 2020 11:23:02 +0800
Message-Id: <20200421032304.26300-8-jianyong.wu@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200421032304.26300-1-jianyong.wu@arm.com>
References: <20200421032304.26300-1-jianyong.wu@arm.com>
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
index 7a33993c0d05..47d69b3f2d9a 100644
--- a/drivers/clocksource/arm_arch_timer.c
+++ b/drivers/clocksource/arm_arch_timer.c
@@ -1645,7 +1645,7 @@ TIMER_ACPI_DECLARE(arch_timer, ACPI_SIG_GTDT, arch_timer_acpi_init);
 #if IS_ENABLED(CONFIG_PTP_1588_CLOCK_KVM)
 #include <linux/arm-smccc.h>
 int kvm_arch_ptp_get_crosststamp(unsigned long *cycle, struct timespec64 *ts,
-			      struct clocksource **cs)
+				 struct clocksource **cs, long *ctx)
 {
 	struct arm_smccc_res hvc_res;
 	ktime_t ktime_overall;
diff --git a/drivers/net/ethernet/intel/e1000e/ptp.c b/drivers/net/ethernet/intel/e1000e/ptp.c
index 439fda2f5368..e9270d98a497 100644
--- a/drivers/net/ethernet/intel/e1000e/ptp.c
+++ b/drivers/net/ethernet/intel/e1000e/ptp.c
@@ -150,7 +150,8 @@ static int e1000e_phc_get_syncdevicetime(ktime_t *device,
  * clock values in ns.
  **/
 static int e1000e_phc_getcrosststamp(struct ptp_clock_info *ptp,
-				     struct system_device_crosststamp *xtstamp)
+				     struct system_device_crosststamp *xtstamp,
+				     long *__unused)
 {
 	struct e1000_adapter *adapter = container_of(ptp, struct e1000_adapter,
 						     ptp_clock_info);
diff --git a/drivers/ptp/ptp_chardev.c b/drivers/ptp/ptp_chardev.c
index 93d574faf1fe..fef72f29f3c8 100644
--- a/drivers/ptp/ptp_chardev.c
+++ b/drivers/ptp/ptp_chardev.c
@@ -235,7 +235,7 @@ long ptp_ioctl(struct posix_clock *pc, unsigned int cmd, unsigned long arg)
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
index 55417b3b282d..f372555671eb 100644
--- a/drivers/ptp/ptp_kvm_x86.c
+++ b/drivers/ptp/ptp_kvm_x86.c
@@ -55,7 +55,7 @@ int kvm_arch_ptp_get_clock(struct timespec64 *ts)
 }
 
 int kvm_arch_ptp_get_crosststamp(unsigned long *cycle, struct timespec64 *tspec,
-			      struct clocksource **cs)
+			      struct clocksource **cs, void *ctx)
 {
 	unsigned long ret;
 	unsigned int version;
diff --git a/include/linux/ptp_clock_kernel.h b/include/linux/ptp_clock_kernel.h
index 121a7eda4593..1638ad75b5e5 100644
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

