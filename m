Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 563143BF6CE
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 10:16:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231175AbhGHITP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 04:19:15 -0400
Received: from mga09.intel.com ([134.134.136.24]:46664 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230414AbhGHITO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Jul 2021 04:19:14 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10038"; a="209427698"
X-IronPort-AV: E=Sophos;i="5.84,222,1620716400"; 
   d="scan'208";a="209427698"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2021 01:16:32 -0700
X-IronPort-AV: E=Sophos;i="5.84,222,1620716400"; 
   d="scan'208";a="487463340"
Received: from xiaoyaol-mobl.ccr.corp.intel.com (HELO [10.239.13.111]) ([10.239.13.111])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2021 01:16:27 -0700
Subject: Re: [PATCH v2 1/6] x86/tdx: Add TDREPORT TDX Module call support
To:     Kuppuswamy Sathyanarayanan 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@kernel.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Mark Gross <mgross@linux.intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Peter H Anvin <hpa@zytor.com>, Dave Hansen <dave.hansen@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Kirill Shutemov <kirill.shutemov@linux.intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Kuppuswamy Sathyanarayanan <knsathya@kernel.org>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        platform-driver-x86@vger.kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org
References: <20210707204249.3046665-1-sathyanarayanan.kuppuswamy@linux.intel.com>
 <20210707204249.3046665-2-sathyanarayanan.kuppuswamy@linux.intel.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
Message-ID: <d9aac97c-aa08-de9f-fa44-91b7dde61ce3@intel.com>
Date:   Thu, 8 Jul 2021 16:16:25 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210707204249.3046665-2-sathyanarayanan.kuppuswamy@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/8/2021 4:42 AM, Kuppuswamy Sathyanarayanan wrote:
> The TDX Guest-Host Communication Interface (GHCI) includes a module
> call (TDREPORT TDCALL) that a guest can make to acquire a copy of the
> attestation data that it needs to verify its trustworthiness.
> 
> Add a wrapper function tdx_mcall_tdreport() that makes the module
> call to get this data.
> 
> See GHCI section 2.4.5 "TDCALL [TDG.MR.REPORT] leaf" for additional
> details.
> 
> [Xiaoyao: Proposed error code fix]
> Reviewed-by: Tony Luck <tony.luck@intel.com>
> Reviewed-by: Andi Kleen <ak@linux.intel.com>
> Signed-off-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
> ---
>   arch/x86/include/asm/tdx.h |  2 ++
>   arch/x86/kernel/tdx.c      | 33 +++++++++++++++++++++++++++++++++
>   2 files changed, 35 insertions(+)
> 
> diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
> index 48927fac9e12..4f1b5c14a09b 100644
> --- a/arch/x86/include/asm/tdx.h
> +++ b/arch/x86/include/asm/tdx.h
> @@ -96,6 +96,8 @@ extern int tdx_hcall_gpa_intent(phys_addr_t gpa, int numpages,
>   
>   bool tdg_filter_enabled(void);
>   
> +int tdx_mcall_tdreport(u64 data, u64 reportdata);
> +
>   /*
>    * To support I/O port access in decompressor or early kernel init
>    * code, since #VE exception handler cannot be used, use paravirt
> diff --git a/arch/x86/kernel/tdx.c b/arch/x86/kernel/tdx.c
> index f76af7661046..0f797803f4c8 100644
> --- a/arch/x86/kernel/tdx.c
> +++ b/arch/x86/kernel/tdx.c
> @@ -23,6 +23,7 @@
>   /* TDX Module call Leaf IDs */
>   #define TDINFO				1
>   #define TDGETVEINFO			3
> +#define TDREPORT			4
>   #define TDACCEPTPAGE			6
>   
>   /* TDX hypercall Leaf IDs */
> @@ -30,6 +31,11 @@
>   
>   /* TDX Module call error codes */
>   #define TDX_PAGE_ALREADY_ACCEPTED       0x8000000000000001
> +#define TDCALL_RETURN_CODE_MASK		0xFFFFFFFF00000000
> +#define TDCALL_OPERAND_BUSY		0x8000020000000000
> +#define TDCALL_INVALID_OPERAND		0x8000000000000000
> +#define TDCALL_RETURN_CODE(a)		((a) & TDCALL_RETURN_CODE_MASK)
> +
>   
>   #define VE_IS_IO_OUT(exit_qual)		(((exit_qual) & 8) ? 0 : 1)
>   #define VE_GET_IO_SIZE(exit_qual)	(((exit_qual) & 7) + 1)
> @@ -139,6 +145,33 @@ static bool tdg_perfmon_enabled(void)
>   	return td_info.attributes & BIT(63);
>   }
>   
> +/*
> + * tdx_mcall_tdreport() - Generate TDREPORT_STRUCT using TDCALL.
> + *
> + * @data        : Physical address of 1024B aligned data to store
> + *                TDREPORT_STRUCT.
> + * @reportdata  : Physical address of 64B aligned report data
> + *
> + * return 0 on success or failure error number.
> + */
> +int tdx_mcall_tdreport(u64 data, u64 reportdata)
> +{
> +	u64 ret;
> +
> +	if (!data || !reportdata || !prot_guest_has(PR_GUEST_TDX))
> +		return -EINVAL;
> +
> +	ret = __trace_tdx_module_call(TDREPORT, data, reportdata, 0, 0, NULL);
> +
> +	if (TDCALL_RETURN_CODE(ret) == TDCALL_INVALID_OPERAND)
> +		return -EINVAL;
> +	else if (TDCALL_RETURN_CODE(ret) == TDCALL_OPERAND_BUSY)
> +		return -EBUSY;

Sorry I guess I didn't state it clearly during internal review.

I suggest something like this

if (ret != TDCALL_SUCCESS) {
	if (TDCALL_RETURN_CODE(ret) == TDCALL_INVALID_OPERAND)
		return -EINVAL;
	else if (TDCALL_RETURN_CODE(ret) == TDCALL_OPERAND_BUSY)
		return -EBUSY;
	else
		return -EFAULT; //I'm not sure if -EFAULT is proper.
}

> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(tdx_mcall_tdreport);
> +
>   static void tdg_get_info(void)
>   {
>   	u64 ret;
> 

