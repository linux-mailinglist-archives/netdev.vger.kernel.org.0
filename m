Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96D0CF289C
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 09:01:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727423AbfKGIBn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 03:01:43 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:46430 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726791AbfKGIBn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 03:01:43 -0500
Received: from p5b06da22.dip0.t-ipconnect.de ([91.6.218.34] helo=nanos)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1iScjQ-0000io-4h; Thu, 07 Nov 2019 09:01:28 +0100
Date:   Thu, 7 Nov 2019 09:01:26 +0100 (CET)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Jianyong Wu <jianyong.wu@arm.com>
cc:     netdev@vger.kernel.org, yangbo.lu@nxp.com, john.stultz@linaro.org,
        pbonzini@redhat.com, sean.j.christopherson@intel.com,
        maz@kernel.org, richardcochran@gmail.com, Mark.Rutland@arm.com,
        will@kernel.org, suzuki.poulose@arm.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Steve.Capper@arm.com, Kaly.Xin@arm.com, justin.he@arm.com,
        nd@arm.com
Subject: Re: [RFC PATCH v6 5/7] psci: Add hvc call service for ptp_kvm.
In-Reply-To: <20191024110209.21328-6-jianyong.wu@arm.com>
Message-ID: <alpine.DEB.2.21.1911070856100.1869@nanos.tec.linutronix.de>
References: <20191024110209.21328-1-jianyong.wu@arm.com> <20191024110209.21328-6-jianyong.wu@arm.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 24 Oct 2019, Jianyong Wu wrote:

> This patch is the base of ptp_kvm for arm64.

This patch ...

> ptp_kvm modules will call hvc to get this service.
> The service offers real time and counter cycle of host for guest.
> 
> Signed-off-by: Jianyong Wu <jianyong.wu@arm.com>
> ---
>  drivers/clocksource/arm_arch_timer.c |  2 ++
>  include/clocksource/arm_arch_timer.h |  4 ++++
>  include/linux/arm-smccc.h            | 12 ++++++++++++
>  virt/kvm/arm/psci.c                  | 22 ++++++++++++++++++++++
>  4 files changed, 40 insertions(+)
> 
> diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
> index 07e57a49d1e8..e4ad38042ef6 100644
> --- a/drivers/clocksource/arm_arch_timer.c
> +++ b/drivers/clocksource/arm_arch_timer.c
> @@ -29,6 +29,7 @@
>  #include <asm/virt.h>
>  
>  #include <clocksource/arm_arch_timer.h>
> +#include <linux/clocksource_ids.h>

Same ordering issue and lack of file.
 
> diff --git a/include/clocksource/arm_arch_timer.h b/include/clocksource/arm_arch_timer.h
> index 1d68d5613dae..426d749e8cf8 100644
> --- a/include/clocksource/arm_arch_timer.h
> +++ b/include/clocksource/arm_arch_timer.h
> @@ -104,6 +104,10 @@ static inline bool arch_timer_evtstrm_available(void)
>  	return false;
>  }
>  
> +bool is_arm_arch_counter(void *unuse)

A global function in a header file? You might want to make this static
inline. And while at it please s/unuse/unused/

> +{
> +	return false;
> +}
>  #endif
>  #include <linux/linkage.h>
> diff --git a/virt/kvm/arm/psci.c b/virt/kvm/arm/psci.c
> index 0debf49bf259..339bcbafac7b 100644
> --- a/virt/kvm/arm/psci.c
> +++ b/virt/kvm/arm/psci.c
> @@ -15,6 +15,7 @@
>  #include <asm/kvm_host.h>
>  
>  #include <kvm/arm_psci.h>
> +#include <linux/clocksource_ids.h>

Sigh.
  
>  /*
>   * This is an implementation of the Power State Coordination Interface
> @@ -392,6 +393,8 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
>  	u32 func_id = smccc_get_function(vcpu);
>  	u32 val[4] = {};
>  	u32 option;
> +	u64 cycles;
> +	struct system_time_snapshot systime_snapshot;

Also here you might notice that the variables are not randomly ordered.

Thanks,

	tglx
