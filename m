Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 619273A2DD0
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 16:14:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231259AbhFJOP5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 10:15:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230153AbhFJOP4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 10:15:56 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8AE7C061574;
        Thu, 10 Jun 2021 07:13:47 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id u18so1715544pfk.11;
        Thu, 10 Jun 2021 07:13:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=uVvPHfIwriaeCqaGS4SWF2JfjGEeCNMTseqgcHKL0PY=;
        b=ot0iffXK2/znAlvDWUx0DvEHPs9Hu42jQhvk3aHGx+T2NhWFpnwKA1vIkYGIy+cgYb
         LxEbfgCrbULtFd7nVuJsfQAH+IMqZIL2R35dwiAl9sJZz1GKTswJr7viHRHzd8ec6z9L
         cpBdHTN6hAjfnZCW/MdapYStRdZ2pSAmS2zSYAlKj+wqby1v1sKfa0Z3IJGU1Q2S8YcP
         HqfC/opPsY22Z36tiTPSUNG8yLuAg9Bq77HzKuJDM2mT1cANyfp9SOlXy6wpSwett2B6
         yucBibCk75zJ2NzA/8lMhfuq11vR41IllnpzmIyKLTH/P3wGLWQCIUfWmxQ4zGD/3HTx
         tacA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uVvPHfIwriaeCqaGS4SWF2JfjGEeCNMTseqgcHKL0PY=;
        b=Ob5AjVJlmewWgR91C2iGfH32rqVp9W5EnF11+BLWmpEgtRimFpEQMaBysOyo7RcTVj
         kvxM2SaGFg8t5sfZ0L6oqoxpQjkqb7ySAyb9AFHodVAL9+Q8Z5jiZKjH9JAeNUFNeeKq
         oYwL/EVQzB5PZX307pQc+Z1dcVZr09VYTuAbSCmARcFaDgDyZwFTv/oUze7mKDo27IId
         zdrUSWdvZ6rQZ+a0M5xP8L82dq/cSAqGONkxuMCVmtwV/exS+dccGbDtkwIXsz+8T8Om
         lyrwZspUfEnEq4X191QY4ap5ptVgz2zhFRZnhbEP0NbU0nTigIrw9MXypsXQAf8jnKP1
         MC/w==
X-Gm-Message-State: AOAM530It9T+D/oLpTv3sg30GnJpQoKABxSxMfca/I5TP5FZrDaRkoBG
        bk4gPaWYunVAN/RQi3+Ix3s=
X-Google-Smtp-Source: ABdhPJz4FYgWX1XRVYnd1fLznm93BCcmg2/a4wkuQ7x2l90mgEwjIr25Q5mcrDlHBGTMoQXHYCH6CA==
X-Received: by 2002:a05:6a00:2353:b029:2f2:987a:5da2 with SMTP id j19-20020a056a002353b02902f2987a5da2mr3220673pfj.58.1623334427380;
        Thu, 10 Jun 2021 07:13:47 -0700 (PDT)
Received: from ?IPv6:2404:f801:0:5:8000::4b1? ([2404:f801:9000:1a:efea::4b1])
        by smtp.gmail.com with ESMTPSA id h12sm3035510pgn.54.2021.06.10.07.13.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Jun 2021 07:13:46 -0700 (PDT)
Subject: Re: [RFC PATCH V3 01/11] x86/HV: Initialize GHCB page in Isolation VM
To:     Joerg Roedel <joro@8bytes.org>
Cc:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        arnd@arndb.de, dave.hansen@linux.intel.com, luto@kernel.org,
        peterz@infradead.org, akpm@linux-foundation.org,
        kirill.shutemov@linux.intel.com, rppt@kernel.org,
        hannes@cmpxchg.org, cai@lca.pw, krish.sadhukhan@oracle.com,
        saravanand@fb.com, Tianyu.Lan@microsoft.com,
        konrad.wilk@oracle.com, hch@lst.de, m.szyprowski@samsung.com,
        robin.murphy@arm.com, boris.ostrovsky@oracle.com, jgross@suse.com,
        sstabellini@kernel.org, will@kernel.org,
        xen-devel@lists.xenproject.org, davem@davemloft.net,
        kuba@kernel.org, jejb@linux.ibm.com, martin.petersen@oracle.com,
        iommu@lists.linux-foundation.org, linux-arch@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, netdev@vger.kernel.org,
        vkuznets@redhat.com, thomas.lendacky@amd.com,
        brijesh.singh@amd.com, sunilmut@microsoft.com
References: <20210530150628.2063957-1-ltykernel@gmail.com>
 <20210530150628.2063957-2-ltykernel@gmail.com> <YMC2RSr/J1WYCvtz@8bytes.org>
From:   Tianyu Lan <ltykernel@gmail.com>
Message-ID: <c9a7eaa8-a8b3-3ed3-c52c-7a2cea3c95bc@gmail.com>
Date:   Thu, 10 Jun 2021 22:13:32 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <YMC2RSr/J1WYCvtz@8bytes.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Joerg：
	Thanks for your review.


On 6/9/2021 8:38 PM, Joerg Roedel wrote:
> On Sun, May 30, 2021 at 11:06:18AM -0400, Tianyu Lan wrote:
>> From: Tianyu Lan <Tianyu.Lan@microsoft.com>
>>
>> Hyper-V exposes GHCB page via SEV ES GHCB MSR for SNP guest
>> to communicate with hypervisor. Map GHCB page for all
>> cpus to read/write MSR register and submit hvcall request
>> via GHCB.
>>
>> Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
>> ---
>>   arch/x86/hyperv/hv_init.c       | 60 ++++++++++++++++++++++++++++++---
>>   arch/x86/include/asm/mshyperv.h |  2 ++
>>   include/asm-generic/mshyperv.h  |  2 ++
>>   3 files changed, 60 insertions(+), 4 deletions(-)
>>
>> diff --git a/arch/x86/hyperv/hv_init.c b/arch/x86/hyperv/hv_init.c
>> index bb0ae4b5c00f..dc74d01cb859 100644
>> --- a/arch/x86/hyperv/hv_init.c
>> +++ b/arch/x86/hyperv/hv_init.c
>> @@ -60,6 +60,9 @@ static int hv_cpu_init(unsigned int cpu)
>>   	struct hv_vp_assist_page **hvp = &hv_vp_assist_page[smp_processor_id()];
>>   	void **input_arg;
>>   	struct page *pg;
>> +	u64 ghcb_gpa;
>> +	void *ghcb_va;
>> +	void **ghcb_base;
> 
> Any reason you can't reuse the SEV-ES support code in the Linux kernel?
> It already has code to setup GHCBs for all vCPUs.
> 
> I see that you don't need #VC handling in your SNP VMs because of the
> paravisor running underneath it, but just re-using the GHCB setup code
> shouldn't be too hard.
> 

Thanks for your suggestion. I will have a try to use SEV-ES code.

