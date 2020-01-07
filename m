Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A753613224D
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 10:29:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727735AbgAGJ3d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 04:29:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:58446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727616AbgAGJ3c (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Jan 2020 04:29:32 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 173BA2073D;
        Tue,  7 Jan 2020 09:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578389371;
        bh=EzepXcOh6NNd+CModDYitbngAr5w/T80SpUwJ7cBNS8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=am+oPwxfbwzq+wL8gwB7ktpHLYqN9T2T165OVDrwWX63EEHla0tcTBmmldG58hkdy
         fFMZ5jsJ4XJFWqzHD+/S4Zs14ojmHnNkq2kEQu2Oi0+ca0mJv3X1vJ7+2aM+mG+GhH
         XSTfyBAZZuOS29De993l+MuKeJyXlI1kpycDq5WI=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1iolB3-0000wX-EC; Tue, 07 Jan 2020 09:29:29 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 07 Jan 2020 09:29:29 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Jianyong Wu <jianyong.wu@arm.com>
Cc:     netdev@vger.kernel.org, yangbo.lu@nxp.com, john.stultz@linaro.org,
        tglx@linutronix.de, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, richardcochran@gmail.com,
        Mark.Rutland@arm.com, will@kernel.org, suzuki.poulose@arm.com,
        steven.price@arm.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Steve.Capper@arm.com, Kaly.Xin@arm.com,
        justin.he@arm.com, nd@arm.com
Subject: Re: [RFC PATCH v9 7/8] ptp: arm64: Enable ptp_kvm for arm64
In-Reply-To: <20191210034026.45229-8-jianyong.wu@arm.com>
References: <20191210034026.45229-1-jianyong.wu@arm.com>
 <20191210034026.45229-8-jianyong.wu@arm.com>
Message-ID: <ca162efb3a0de530e119f5237c006515@kernel.org>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/1.3.8
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: jianyong.wu@arm.com, netdev@vger.kernel.org, yangbo.lu@nxp.com, john.stultz@linaro.org, tglx@linutronix.de, pbonzini@redhat.com, sean.j.christopherson@intel.com, richardcochran@gmail.com, Mark.Rutland@arm.com, will@kernel.org, suzuki.poulose@arm.com, steven.price@arm.com, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, Steve.Capper@arm.com, Kaly.Xin@arm.com, justin.he@arm.com, nd@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-12-10 03:40, Jianyong Wu wrote:
> Currently in arm64 virtualization environment, there is no mechanism to
> keep time sync between guest and host. Time in guest will drift 
> compared
> with host after boot up as they may both use third party time sources
> to correct their time respectively. The time deviation will be in order
> of milliseconds but some scenarios ask for higher time precision, like
> in cloud envirenment, we want all the VMs running in the host aquire 
> the
> same level accuracy from host clock.
> 
> Use of kvm ptp clock, which choose the host clock source clock as a
> reference clock to sync time clock between guest and host has been 
> adopted
> by x86 which makes the time sync order from milliseconds to 
> nanoseconds.
> 
> This patch enable kvm ptp on arm64 and we get the similar clock drift 
> as
> found with x86 with kvm ptp.
> 
> Test result comparison between with kvm ptp and without it in arm64 are
> as follows. This test derived from the result of command 'chronyc
> sources'. we should take more cure of the last sample column which 
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
> clock. So we can be sure to say that the clock error between host and 
> guest
> is in order of ns.
> 
> Signed-off-by: Jianyong Wu <jianyong.wu@arm.com>
> ---
>  drivers/clocksource/arm_arch_timer.c | 22 ++++++++++++
>  drivers/ptp/Kconfig                  |  2 +-
>  drivers/ptp/ptp_kvm_arm64.c          | 53 ++++++++++++++++++++++++++++
>  3 files changed, 76 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/ptp/ptp_kvm_arm64.c
> 
> diff --git a/drivers/clocksource/arm_arch_timer.c
> b/drivers/clocksource/arm_arch_timer.c
> index 277846decd33..72260b66f02e 100644
> --- a/drivers/clocksource/arm_arch_timer.c
> +++ b/drivers/clocksource/arm_arch_timer.c
> @@ -1636,3 +1636,25 @@ static int __init arch_timer_acpi_init(struct
> acpi_table_header *table)
>  }
>  TIMER_ACPI_DECLARE(arch_timer, ACPI_SIG_GTDT, arch_timer_acpi_init);
>  #endif
> +
> +#if IS_ENABLED(CONFIG_PTP_1588_CLOCK_KVM)
> +#include <linux/arm-smccc.h>
> +int kvm_arch_ptp_get_crosststamp(unsigned long *cycle, struct 
> timespec64 *ts,
> +			      struct clocksource **cs)
> +{
> +	struct arm_smccc_res hvc_res;
> +	ktime_t ktime_overall;
> +
> +	arm_smccc_1_1_invoke(ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID, &hvc_res);
> +	if ((long)(hvc_res.a0) < 0)
> +		return -EOPNOTSUPP;
> +
> +	ktime_overall = hvc_res.a0 << 32 | hvc_res.a1;
> +	*ts = ktime_to_timespec64(ktime_overall);
> +	*cycle = hvc_res.a2 << 32 | hvc_res.a3;

So why isn't that just a read of the virtual counter, given that what 
you do
in the hypervisor seems to be "cntpct - cntvoff"?

What am I missing here?

> +	*cs = &clocksource_counter;
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(kvm_arch_ptp_get_crosststamp);
> +#endif
> diff --git a/drivers/ptp/Kconfig b/drivers/ptp/Kconfig
> index 9b8fee5178e8..3c31ff8eb05f 100644
> --- a/drivers/ptp/Kconfig
> +++ b/drivers/ptp/Kconfig
> @@ -110,7 +110,7 @@ config PTP_1588_CLOCK_PCH
>  config PTP_1588_CLOCK_KVM
>  	tristate "KVM virtual PTP clock"
>  	depends on PTP_1588_CLOCK
> -	depends on KVM_GUEST && X86
> +	depends on KVM_GUEST && X86 || ARM64 && ARM_ARCH_TIMER
>  	default y
>  	help
>  	  This driver adds support for using kvm infrastructure as a PTP
> diff --git a/drivers/ptp/ptp_kvm_arm64.c b/drivers/ptp/ptp_kvm_arm64.c
> new file mode 100644
> index 000000000000..f3f957117865
> --- /dev/null
> +++ b/drivers/ptp/ptp_kvm_arm64.c
> @@ -0,0 +1,53 @@
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
> +#include <linux/sched/clock.h>
> +#include <asm/arch_timer.h>
> +
> +int kvm_arch_ptp_init(void)
> +{
> +	struct arm_smccc_res hvc_res;
> +
> +	arm_smccc_1_1_invoke(ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID,
> +			     &hvc_res);
> +	if ((long)(hvc_res.a0) < 0)
> +		return -EOPNOTSUPP;
> +
> +	return 0;
> +}
> +
> +int kvm_arch_ptp_get_clock_generic(struct timespec64 *ts,
> +				   struct arm_smccc_res *hvc_res)
> +{
> +	ktime_t ktime_overall;
> +
> +	arm_smccc_1_1_invoke(ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID,
> +				  hvc_res);
> +	if ((long)(hvc_res->a0) < 0)
> +		return -EOPNOTSUPP;
> +
> +	ktime_overall = hvc_res->a0 << 32 | hvc_res->a1;
> +	*ts = ktime_to_timespec64(ktime_overall);
> +
> +	return 0;
> +}
> +
> +int kvm_arch_ptp_get_clock(struct timespec64 *ts)
> +{
> +	struct arm_smccc_res hvc_res;
> +
> +	kvm_arch_ptp_get_clock_generic(ts, &hvc_res);
> +
> +	return 0;
> +}

I also wonder why this is all arm64 specific, while everything
should also work just fine on 32bit.

         M.
-- 
Jazz is not dead. It just smells funny...
