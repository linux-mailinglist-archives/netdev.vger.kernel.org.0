Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C82B230CBD8
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 20:41:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239903AbhBBThQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 14:37:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:43126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233346AbhBBNzM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Feb 2021 08:55:12 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A4B2764FDB;
        Tue,  2 Feb 2021 13:44:49 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1l6vz5-00BVMI-JP; Tue, 02 Feb 2021 13:44:47 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 02 Feb 2021 13:44:47 +0000
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
Subject: Re: [PATCH v16 9/9] arm64: Add kvm capability check extension for
 ptp_kvm
In-Reply-To: <20201209060932.212364-10-jianyong.wu@arm.com>
References: <20201209060932.212364-1-jianyong.wu@arm.com>
 <20201209060932.212364-10-jianyong.wu@arm.com>
User-Agent: Roundcube Webmail/1.4.10
Message-ID: <13893254f802799ba44b9a35317b32f5@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: jianyong.wu@arm.com, netdev@vger.kernel.org, yangbo.lu@nxp.com, john.stultz@linaro.org, tglx@linutronix.de, pbonzini@redhat.com, sean.j.christopherson@intel.com, richardcochran@gmail.com, Mark.Rutland@arm.com, will@kernel.org, suzuki.poulose@arm.com, Andre.Przywara@arm.com, steven.price@arm.com, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, Steve.Capper@arm.com, justin.he@arm.com, nd@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-12-09 06:09, Jianyong Wu wrote:
> Let userspace check if there is kvm ptp service in host.
> Before VMs migrate to another host, VMM may check if this
> cap is available to determine the next behavior.
> 
> Signed-off-by: Jianyong Wu <jianyong.wu@arm.com>
> Suggested-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/arm.c     | 1 +
>  include/uapi/linux/kvm.h | 1 +
>  2 files changed, 2 insertions(+)
> 
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index f60f4a5e1a22..1bb1f64f9bb5 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -199,6 +199,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, 
> long ext)
>  	case KVM_CAP_ARM_INJECT_EXT_DABT:
>  	case KVM_CAP_SET_GUEST_DEBUG:
>  	case KVM_CAP_VCPU_ATTRIBUTES:
> +	case KVM_CAP_PTP_KVM:
>  		r = 1;
>  		break;
>  	case KVM_CAP_ARM_SET_DEVICE_ADDR:
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index ca41220b40b8..797c40bbc31f 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1053,6 +1053,7 @@ struct kvm_ppc_resize_hpt {
>  #define KVM_CAP_X86_USER_SPACE_MSR 188
>  #define KVM_CAP_X86_MSR_FILTER 189
>  #define KVM_CAP_ENFORCE_PV_FEATURE_CPUID 190
> +#define KVM_CAP_PTP_KVM 191
> 
>  #ifdef KVM_CAP_IRQ_ROUTING

This really should be squashed with the patch implementing
the hypercall.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
