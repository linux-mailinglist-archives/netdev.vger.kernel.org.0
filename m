Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12A2C30BFC3
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 14:43:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232716AbhBBNkk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 08:40:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:34408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232566AbhBBNiM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Feb 2021 08:38:12 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 15CB864DDA;
        Tue,  2 Feb 2021 13:37:31 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1l6vs0-00BVCV-8p; Tue, 02 Feb 2021 13:37:29 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 02 Feb 2021 13:37:28 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Jianyong Wu <jianyong.wu@arm.com>
Cc:     netdev@vger.kernel.org, yangbo.lu@nxp.com, john.stultz@linaro.org,
        tglx@linutronix.de, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, richardcochran@gmail.com,
        Mark.Rutland@arm.com, will@kernel.org, suzuki.poulose@arm.com,
        Andre.Przywara@arm.com, steven.price@arm.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Steve.Capper@arm.com, justin.he@arm.com, nd@arm.com
Subject: Re: [PATCH v16 7/9] ptp: arm/arm64: Enable ptp_kvm for arm/arm64
In-Reply-To: <20201209060932.212364-8-jianyong.wu@arm.com>
References: <20201209060932.212364-1-jianyong.wu@arm.com>
 <20201209060932.212364-8-jianyong.wu@arm.com>
User-Agent: Roundcube Webmail/1.4.10
Message-ID: <b79a3502c215a1d2182c53e4b71f370c@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: jianyong.wu@arm.com, netdev@vger.kernel.org, yangbo.lu@nxp.com, john.stultz@linaro.org, tglx@linutronix.de, pbonzini@redhat.com, sean.j.christopherson@intel.com, richardcochran@gmail.com, Mark.Rutland@arm.com, will@kernel.org, suzuki.poulose@arm.com, Andre.Przywara@arm.com, steven.price@arm.com, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, Steve.Capper@arm.com, justin.he@arm.com, nd@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-12-09 06:09, Jianyong Wu wrote:
> Currently, there is no mechanism to keep time sync between guest and 
> host
> in arm/arm64 virtualization environment. Time in guest will drift 
> compared
> with host after boot up as they may both use third party time sources
> to correct their time respectively. The time deviation will be in order
> of milliseconds. But in some scenarios,like in cloud environment, we 
> ask
> for higher time precision.
> 
> kvm ptp clock, which chooses the host clock source as a reference
> clock to sync time between guest and host, has been adopted by x86
> which takes the time sync order from milliseconds to nanoseconds.
> 
> This patch enables kvm ptp clock for arm/arm64 and improves clock sync 
> precision
> significantly.
> 
> Test result comparisons between with kvm ptp clock and without it in 
> arm/arm64
> are as follows. This test derived from the result of command 'chronyc
> sources'. we should take more care of the last sample column which 
> shows
> the offset between the local clock and the source at the last 
> measurement.
> 
> no kvm ptp in guest:
> MS Name/IP address   Stratum Poll Reach LastRx Last sample
> ========================================================================
> ^* dns1.synet.edu.cn      2   6   377    13  +1040us[+1581us] +/-   
> 21ms
> ^* dns1.synet.edu.cn      2   6   377    21  +1040us[+1581us] +/-   
> 21ms
> ^* dns1.synet.edu.cn      2   6   377    29  +1040us[+1581us] +/-   
> 21ms
> ^* dns1.synet.edu.cn      2   6   377    37  +1040us[+1581us] +/-   
> 21ms
> ^* dns1.synet.edu.cn      2   6   377    45  +1040us[+1581us] +/-   
> 21ms
> ^* dns1.synet.edu.cn      2   6   377    53  +1040us[+1581us] +/-   
> 21ms
> ^* dns1.synet.edu.cn      2   6   377    61  +1040us[+1581us] +/-   
> 21ms
> ^* dns1.synet.edu.cn      2   6   377     4   -130us[ +796us] +/-   
> 21ms
> ^* dns1.synet.edu.cn      2   6   377    12   -130us[ +796us] +/-   
> 21ms
> ^* dns1.synet.edu.cn      2   6   377    20   -130us[ +796us] +/-   
> 21ms
> 
> in host:
> MS Name/IP address   Stratum Poll Reach LastRx Last sample
> ========================================================================
> ^* 120.25.115.20          2   7   377    72   -470us[ -603us] +/-   
> 18ms
> ^* 120.25.115.20          2   7   377    92   -470us[ -603us] +/-   
> 18ms
> ^* 120.25.115.20          2   7   377   112   -470us[ -603us] +/-   
> 18ms
> ^* 120.25.115.20          2   7   377     2   +872ns[-6808ns] +/-   
> 17ms
> ^* 120.25.115.20          2   7   377    22   +872ns[-6808ns] +/-   
> 17ms
> ^* 120.25.115.20          2   7   377    43   +872ns[-6808ns] +/-   
> 17ms
> ^* 120.25.115.20          2   7   377    63   +872ns[-6808ns] +/-   
> 17ms
> ^* 120.25.115.20          2   7   377    83   +872ns[-6808ns] +/-   
> 17ms
> ^* 120.25.115.20          2   7   377   103   +872ns[-6808ns] +/-   
> 17ms
> ^* 120.25.115.20          2   7   377   123   +872ns[-6808ns] +/-   
> 17ms
> 
> The dns1.synet.edu.cn is the network reference clock for guest and
> 120.25.115.20 is the network reference clock for host. we can't get the
> clock error between guest and host directly, but a roughly estimated 
> value
> will be in order of hundreds of us to ms.
> 
> with kvm ptp in guest:
> chrony has been disabled in host to remove the disturb by network 
> clock.
> 
> MS Name/IP address         Stratum Poll Reach LastRx Last sample
> ========================================================================
> * PHC0                    0   3   377     8     -7ns[   +1ns] +/-    
> 3ns
> * PHC0                    0   3   377     8     +1ns[  +16ns] +/-    
> 3ns
> * PHC0                    0   3   377     6     -4ns[   -0ns] +/-    
> 6ns
> * PHC0                    0   3   377     6     -8ns[  -12ns] +/-    
> 5ns
> * PHC0                    0   3   377     5     +2ns[   +4ns] +/-    
> 4ns
> * PHC0                    0   3   377    13     +2ns[   +4ns] +/-    
> 4ns
> * PHC0                    0   3   377    12     -4ns[   -6ns] +/-    
> 4ns
> * PHC0                    0   3   377    11     -8ns[  -11ns] +/-    
> 6ns
> * PHC0                    0   3   377    10    -14ns[  -20ns] +/-    
> 4ns
> * PHC0                    0   3   377     8     +4ns[   +5ns] +/-    
> 4ns
> 
> The PHC0 is the ptp clock which choose the host clock as its source
> clock. So we can see that the clock difference between host and guest
> is in order of ns.
> 
> Signed-off-by: Jianyong Wu <jianyong.wu@arm.com>
> ---
>  drivers/clocksource/arm_arch_timer.c | 29 ++++++++++++++++++
>  drivers/ptp/Kconfig                  |  2 +-
>  drivers/ptp/Makefile                 |  1 +
>  drivers/ptp/ptp_kvm_arm.c            | 45 ++++++++++++++++++++++++++++
>  4 files changed, 76 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/ptp/ptp_kvm_arm.c
> 
> diff --git a/drivers/clocksource/arm_arch_timer.c
> b/drivers/clocksource/arm_arch_timer.c
> index d55acffb0b90..16cd0a663587 100644
> --- a/drivers/clocksource/arm_arch_timer.c
> +++ b/drivers/clocksource/arm_arch_timer.c
> @@ -25,6 +25,8 @@
>  #include <linux/sched/clock.h>
>  #include <linux/sched_clock.h>
>  #include <linux/acpi.h>
> +#include <linux/arm-smccc.h>
> +#include <linux/ptp_kvm.h>
> 
>  #include <asm/arch_timer.h>
>  #include <asm/virt.h>
> @@ -1650,3 +1652,30 @@ static int __init arch_timer_acpi_init(struct
> acpi_table_header *table)
>  }
>  TIMER_ACPI_DECLARE(arch_timer, ACPI_SIG_GTDT, arch_timer_acpi_init);
>  #endif
> +
> +int kvm_arch_ptp_get_crosststamp(u64 *cycle, struct timespec64 *ts,
> +			      struct clocksource **cs)
> +{
> +	struct arm_smccc_res hvc_res;
> +	ktime_t ktime;
> +	u32 ptp_counter;
> +
> +	if (arch_timer_uses_ppi == ARCH_TIMER_VIRT_PPI)
> +		ptp_counter = ARM_PTP_VIRT_COUNTER;
> +	else
> +		ptp_counter = ARM_PTP_PHY_COUNTER;
> +
> +	arm_smccc_1_1_invoke(ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID,
> +			     ptp_counter, &hvc_res);
> +
> +	if ((int)(hvc_res.a0) < 0)
> +		return -EOPNOTSUPP;
> +
> +	ktime = (u64)hvc_res.a0 << 32 | hvc_res.a1;
> +	*ts = ktime_to_timespec64(ktime);
> +	*cycle = (u64)hvc_res.a2 << 32 | hvc_res.a3;
> +	*cs = &clocksource_counter;
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(kvm_arch_ptp_get_crosststamp);
> diff --git a/drivers/ptp/Kconfig b/drivers/ptp/Kconfig
> index 942f72d8151d..677c7f696b70 100644
> --- a/drivers/ptp/Kconfig
> +++ b/drivers/ptp/Kconfig
> @@ -106,7 +106,7 @@ config PTP_1588_CLOCK_PCH
>  config PTP_1588_CLOCK_KVM
>  	tristate "KVM virtual PTP clock"
>  	depends on PTP_1588_CLOCK
> -	depends on KVM_GUEST && X86
> +	depends on KVM_GUEST && X86 || (HAVE_ARM_SMCCC_DISCOVERY && 
> ARM_ARCH_TIMER)
>  	default y
>  	help
>  	  This driver adds support for using kvm infrastructure as a PTP
> diff --git a/drivers/ptp/Makefile b/drivers/ptp/Makefile
> index 699a4e4d19c2..9fa5ede44b2b 100644
> --- a/drivers/ptp/Makefile
> +++ b/drivers/ptp/Makefile
> @@ -5,6 +5,7 @@
> 
>  ptp-y					:= ptp_clock.o ptp_chardev.o ptp_sysfs.o
>  ptp_kvm-$(CONFIG_X86)			:= ptp_kvm_x86.o ptp_kvm_common.o
> +ptp_kvm-$(CONFIG_HAVE_ARM_SMCCC)	:= ptp_kvm_arm.o ptp_kvm_common.o
>  obj-$(CONFIG_PTP_1588_CLOCK)		+= ptp.o
>  obj-$(CONFIG_PTP_1588_CLOCK_DTE)	+= ptp_dte.o
>  obj-$(CONFIG_PTP_1588_CLOCK_INES)	+= ptp_ines.o
> diff --git a/drivers/ptp/ptp_kvm_arm.c b/drivers/ptp/ptp_kvm_arm.c
> new file mode 100644
> index 000000000000..ecb5ef273be5
> --- /dev/null
> +++ b/drivers/ptp/ptp_kvm_arm.c
> @@ -0,0 +1,45 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + *  Virtual PTP 1588 clock for use with KVM guests
> + *  Copyright (C) 2019 ARM Ltd.
> + *  All Rights Reserved
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/err.h>
> +#include <asm/hypervisor.h>
> +#include <linux/module.h>
> +#include <linux/psci.h>
> +#include <linux/arm-smccc.h>
> +#include <linux/timecounter.h>
> +#include <linux/ptp_kvm.h>
> +#include <linux/sched/clock.h>
> +#include <asm/arch_timer.h>
> +#include <asm/hypervisor.h>
> +
> +int kvm_arch_ptp_init(void)
> +{
> +	int ret;
> +
> +	ret = kvm_arm_hyp_service_available(ARM_SMCCC_KVM_FUNC_PTP);
> +	if (ret <= 0)
> +		return -EOPNOTSUPP;
> +
> +	return 0;
> +}
> +
> +int kvm_arch_ptp_get_clock(struct timespec64 *ts)
> +{
> +	ktime_t ktime;
> +	struct arm_smccc_res hvc_res;
> +
> +	arm_smccc_1_1_invoke(ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID,
> +			     ARM_PTP_VIRT_COUNTER, &hvc_res);
> +	if ((int)(hvc_res.a0) < 0)
> +		return -EOPNOTSUPP;
> +
> +	ktime = (u64)hvc_res.a0 << 32 | hvc_res.a1;
> +	*ts = ktime_to_timespec64(ktime);

This whole function can be trivially replaced with a call to
kvm_arch_ptp_get_crosststamp with minimal changes to that function:

diff --git a/drivers/clocksource/arm_arch_timer.c 
b/drivers/clocksource/arm_arch_timer.c
index e3a5ebbfb3d0..e7b07166e771 100644
--- a/drivers/clocksource/arm_arch_timer.c
+++ b/drivers/clocksource/arm_arch_timer.c
@@ -1663,16 +1663,16 @@ TIMER_ACPI_DECLARE(arch_timer, ACPI_SIG_GTDT, 
arch_timer_acpi_init);
  #endif

  int kvm_arch_ptp_get_crosststamp(u64 *cycle, struct timespec64 *ts,
-			      struct clocksource **cs)
+				 struct clocksource **cs)
  {
  	struct arm_smccc_res hvc_res;
-	ktime_t ktime;
  	u32 ptp_counter;
+	ktime_t ktime;

  	if (arch_timer_uses_ppi == ARCH_TIMER_VIRT_PPI)
-		ptp_counter = ARM_PTP_VIRT_COUNTER;
+		ptp_counter = KVM_PTP_VIRT_COUNTER;
  	else
-		ptp_counter = ARM_PTP_PHY_COUNTER;
+		ptp_counter = KVM_PTP_PHYS_COUNTER;

  	arm_smccc_1_1_invoke(ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID,
  			     ptp_counter, &hvc_res);
@@ -1682,8 +1682,10 @@ int kvm_arch_ptp_get_crosststamp(u64 *cycle, 
struct timespec64 *ts,

  	ktime = (u64)hvc_res.a0 << 32 | hvc_res.a1;
  	*ts = ktime_to_timespec64(ktime);
-	*cycle = (u64)hvc_res.a2 << 32 | hvc_res.a3;
-	*cs = &clocksource_counter;
+	if (cycle)
+		*cycle = (u64)hvc_res.a2 << 32 | hvc_res.a3;
+	if (cs)
+		*cs = &clocksource_counter;

  	return 0;
  }
diff --git a/drivers/ptp/ptp_kvm_arm.c b/drivers/ptp/ptp_kvm_arm.c
index ecb5ef273be5..b7d28c8dfb84 100644
--- a/drivers/ptp/ptp_kvm_arm.c
+++ b/drivers/ptp/ptp_kvm_arm.c
@@ -5,15 +5,9 @@
   *  All Rights Reserved
   */

-#include <linux/kernel.h>
-#include <linux/err.h>
-#include <asm/hypervisor.h>
-#include <linux/module.h>
-#include <linux/psci.h>
  #include <linux/arm-smccc.h>
-#include <linux/timecounter.h>
  #include <linux/ptp_kvm.h>
-#include <linux/sched/clock.h>
+
  #include <asm/arch_timer.h>
  #include <asm/hypervisor.h>

@@ -30,16 +24,5 @@ int kvm_arch_ptp_init(void)

  int kvm_arch_ptp_get_clock(struct timespec64 *ts)
  {
-	ktime_t ktime;
-	struct arm_smccc_res hvc_res;
-
-	arm_smccc_1_1_invoke(ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID,
-			     ARM_PTP_VIRT_COUNTER, &hvc_res);
-	if ((int)(hvc_res.a0) < 0)
-		return -EOPNOTSUPP;
-
-	ktime = (u64)hvc_res.a0 << 32 | hvc_res.a1;
-	*ts = ktime_to_timespec64(ktime);
-
-	return 0;
+	return kvm_arch_ptp_get_crosststamp(NULL, ts, NULL);
  }

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
