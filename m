Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21CC33F9E2A
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 19:42:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237357AbhH0Rmp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Aug 2021 13:42:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:53732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230367AbhH0Rmo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Aug 2021 13:42:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7637B60EE4;
        Fri, 27 Aug 2021 17:41:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630086115;
        bh=ZsFbmBg1xrV855YRdCxqtna6KwKkyi+rrK0yjGIPz1U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tAoRxLGO5DnbrNK6U9xEs9WlHAvzjRip71ZReY2rVojbEHBxz5UZCAhzNuSfQrq+H
         NW+m9//bXB9q8WmPpnjwe7GaHGSsWoaCI2kiaLUV22U2rWtqqEyfxPGxudzsUZIsk1
         7ymJ9YdMdMPv0H2UDG2Oy5uVcz9iAViPwTG6WK/0=
Date:   Fri, 27 Aug 2021 19:41:46 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Tianyu Lan <ltykernel@gmail.com>
Cc:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, catalin.marinas@arm.com,
        will@kernel.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        konrad.wilk@oracle.com, boris.ostrovsky@oracle.com,
        jgross@suse.com, sstabellini@kernel.org, joro@8bytes.org,
        davem@davemloft.net, kuba@kernel.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, arnd@arndb.de, hch@lst.de,
        m.szyprowski@samsung.com, robin.murphy@arm.com,
        brijesh.singh@amd.com, thomas.lendacky@amd.com,
        Tianyu.Lan@microsoft.com, pgonda@google.com,
        martin.b.radev@gmail.com, akpm@linux-foundation.org,
        kirill.shutemov@linux.intel.com, rppt@kernel.org,
        hannes@cmpxchg.org, aneesh.kumar@linux.ibm.com,
        krish.sadhukhan@oracle.com, saravanand@fb.com,
        linux-arm-kernel@lists.infradead.org,
        xen-devel@lists.xenproject.org, rientjes@google.com,
        ardb@kernel.org, michael.h.kelley@microsoft.com,
        iommu@lists.linux-foundation.org, linux-arch@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, netdev@vger.kernel.org,
        vkuznets@redhat.com, parri.andrea@gmail.com, dave.hansen@intel.com
Subject: Re: [PATCH V4 05/13] hyperv: Add Write/Read MSR registers via ghcb
 page
Message-ID: <YSkj2kvYoYW8kDiF@kroah.com>
References: <20210827172114.414281-1-ltykernel@gmail.com>
 <20210827172114.414281-6-ltykernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210827172114.414281-6-ltykernel@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 27, 2021 at 01:21:03PM -0400, Tianyu Lan wrote:
> From: Tianyu Lan <Tianyu.Lan@microsoft.com>
> 
> Hyperv provides GHCB protocol to write Synthetic Interrupt
> Controller MSR registers in Isolation VM with AMD SEV SNP
> and these registers are emulated by hypervisor directly.
> Hyperv requires to write SINTx MSR registers twice. First
> writes MSR via GHCB page to communicate with hypervisor
> and then writes wrmsr instruction to talk with paravisor
> which runs in VMPL0. Guest OS ID MSR also needs to be set
> via GHCB page.
> 
> Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
> ---
> Change since v1:
>          * Introduce sev_es_ghcb_hv_call_simple() and share code
>            between SEV and Hyper-V code.
> Change since v3:
>          * Pass old_msg_type to hv_signal_eom() as parameter.
> 	 * Use HV_REGISTER_* marcro instead of HV_X64_MSR_*
> 	 * Add hv_isolation_type_snp() weak function.
> 	 * Add maros to set syinc register in ARM code.
> ---
>  arch/arm64/include/asm/mshyperv.h |  23 ++++++
>  arch/x86/hyperv/hv_init.c         |  36 ++--------
>  arch/x86/hyperv/ivm.c             | 112 ++++++++++++++++++++++++++++++
>  arch/x86/include/asm/mshyperv.h   |  80 ++++++++++++++++++++-
>  arch/x86/include/asm/sev.h        |   3 +
>  arch/x86/kernel/sev-shared.c      |  63 ++++++++++-------
>  drivers/hv/hv.c                   | 112 ++++++++++++++++++++----------
>  drivers/hv/hv_common.c            |   6 ++
>  include/asm-generic/mshyperv.h    |   4 +-
>  9 files changed, 345 insertions(+), 94 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/mshyperv.h b/arch/arm64/include/asm/mshyperv.h
> index 20070a847304..ced83297e009 100644
> --- a/arch/arm64/include/asm/mshyperv.h
> +++ b/arch/arm64/include/asm/mshyperv.h
> @@ -41,6 +41,29 @@ static inline u64 hv_get_register(unsigned int reg)
>  	return hv_get_vpreg(reg);
>  }
>  
> +#define hv_get_simp(val)	{ val = hv_get_register(HV_REGISTER_SIMP); }
> +#define hv_set_simp(val)	hv_set_register(HV_REGISTER_SIMP, val)
> +
> +#define hv_get_siefp(val)	{ val = hv_get_register(HV_REGISTER_SIEFP); }
> +#define hv_set_siefp(val)	hv_set_register(HV_REGISTER_SIEFP, val)
> +
> +#define hv_get_synint_state(int_num, val) {			\
> +	val = hv_get_register(HV_REGISTER_SINT0 + int_num);	\
> +	}
> +
> +#define hv_set_synint_state(int_num, val)			\
> +	hv_set_register(HV_REGISTER_SINT0 + int_num, val)
> +
> +#define hv_get_synic_state(val) {			\
> +	val = hv_get_register(HV_REGISTER_SCONTROL);	\
> +	}
> +
> +#define hv_set_synic_state(val)			\
> +	hv_set_register(HV_REGISTER_SCONTROL, val)
> +
> +#define hv_signal_eom(old_msg_type)		 \
> +	hv_set_register(HV_REGISTER_EOM, 0)

Please just use real inline functions and not #defines if you really
need it.

thanks,

greg k-h
