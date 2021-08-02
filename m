Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C50F03DD6CA
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 15:18:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233826AbhHBNSq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 09:18:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233621AbhHBNSp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Aug 2021 09:18:45 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAE61C06175F;
        Mon,  2 Aug 2021 06:18:34 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id k2so2014040plk.13;
        Mon, 02 Aug 2021 06:18:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=NCI3lHDyDwNRa9nHRAWUMeIv6E94OBk/ArQgKFFM5dk=;
        b=PML2k1Dht8uODKlH3PjAFdc6s/CTDMJQb0vSXp+tWKBkOZKDTm+GB/eR8aVXQ70FAX
         jEcnBX+WXP5rLcq4W5X5HFrW9hJ51Vmvgvy8hGNIdNIWJPbXr/Z0woDD3x3PwhBautYj
         f/s264QOiroQXi9rnewmDedviFD+3T3gC4ei7Z5FsKr/y65Ls/dYfdoaKAM+Ec2wHvVd
         aA36ny4fOTLJxiB1mC/JAk1BfVfacZyAbJGrI98dEdqVsjhB5uZtuVM6yydcCZZA8s9D
         eyWMrETGzJOpt/w2FVnHDuzrREi+J5sEiaxqqYpsUx4zqF5/iQRjwnI3UJJpHaysMi13
         lAfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NCI3lHDyDwNRa9nHRAWUMeIv6E94OBk/ArQgKFFM5dk=;
        b=khpHzfdb9tFSzqyN0wiW5r4TqwVMhp2UUlSP/aVzzTwFp5M3PTr+4Mz+visrQkvPQS
         TQO+X45KPzP8NnmaRUw3n8xHw8pvEo0sCPHWZ6eixqIdSeXnuDD1EVVBKl6zwi9C0sSn
         N71ZpMrkNueSj7AVFI42RQf9AlyrMNdfhtQcLtLyyxes9baPlo1Ctb9jJ2hBCkyWgVvk
         MCBr88ZhSEPQ6N7MTUVhOEsSQAujk1Vd5m5Vb2QjcQrUH/K1s5vG965mOrHT/BV7gCQM
         kpVahJwmwY6bpf1b5ZlarLPEx/e77pWavTvA2nT3GeNxAb54M57xjuev2N3iCG+CCnQi
         utnw==
X-Gm-Message-State: AOAM533mFDFVR8VbjYD4p5efbmsQMovwecA9fHQaED3gQ9aMZdLJkLd9
        6YMPVNhnCAW7Vk/pQ8llkk0=
X-Google-Smtp-Source: ABdhPJzFSB7pHIeqEWjNLoxbHlaMRkkWu5nfzAixwCVuwFPeXy4oAXbwBpyGfDBS8UB6XOVjOVOqpg==
X-Received: by 2002:a62:5587:0:b029:3af:776c:2d02 with SMTP id j129-20020a6255870000b02903af776c2d02mr16019093pfb.11.1627910314492;
        Mon, 02 Aug 2021 06:18:34 -0700 (PDT)
Received: from ?IPv6:2404:f801:0:5:8000::4b1? ([2404:f801:9000:1a:efea::4b1])
        by smtp.gmail.com with ESMTPSA id e13sm12540053pfd.11.2021.08.02.06.18.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Aug 2021 06:18:32 -0700 (PDT)
Subject: Re: [PATCH 05/13] HV: Add Write/Read MSR registers via ghcb page
To:     Joerg Roedel <joro@8bytes.org>
Cc:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        konrad.wilk@oracle.com, boris.ostrovsky@oracle.com,
        jgross@suse.com, sstabellini@kernel.org, will@kernel.org,
        davem@davemloft.net, kuba@kernel.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, arnd@arndb.de, hch@lst.de,
        m.szyprowski@samsung.com, robin.murphy@arm.com,
        thomas.lendacky@amd.com, brijesh.singh@amd.com, ardb@kernel.org,
        Tianyu.Lan@microsoft.com, rientjes@google.com,
        martin.b.radev@gmail.com, akpm@linux-foundation.org,
        rppt@kernel.org, kirill.shutemov@linux.intel.com,
        aneesh.kumar@linux.ibm.com, krish.sadhukhan@oracle.com,
        saravanand@fb.com, xen-devel@lists.xenproject.org,
        pgonda@google.com, david@redhat.com, keescook@chromium.org,
        hannes@cmpxchg.org, sfr@canb.auug.org.au,
        michael.h.kelley@microsoft.com, iommu@lists.linux-foundation.org,
        linux-arch@vger.kernel.org, linux-hyperv@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        netdev@vger.kernel.org, vkuznets@redhat.com, anparri@microsoft.com
References: <20210728145232.285861-1-ltykernel@gmail.com>
 <20210728145232.285861-6-ltykernel@gmail.com> <YQfk9G+k0Tj8ihyu@8bytes.org>
From:   Tianyu Lan <ltykernel@gmail.com>
Message-ID: <988f20e4-821f-b493-c25d-ca9107a6e891@gmail.com>
Date:   Mon, 2 Aug 2021 21:18:15 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <YQfk9G+k0Tj8ihyu@8bytes.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/2/2021 8:28 PM, Joerg Roedel wrote:
> On Wed, Jul 28, 2021 at 10:52:20AM -0400, Tianyu Lan wrote:
>> +void hv_ghcb_msr_write(u64 msr, u64 value)
>> +{
>> +	union hv_ghcb *hv_ghcb;
>> +	void **ghcb_base;
>> +	unsigned long flags;
>> +
>> +	if (!ms_hyperv.ghcb_base)
>> +		return;
>> +
>> +	WARN_ON(in_nmi());
>> +
>> +	local_irq_save(flags);
>> +	ghcb_base = (void **)this_cpu_ptr(ms_hyperv.ghcb_base);
>> +	hv_ghcb = (union hv_ghcb *)*ghcb_base;
>> +	if (!hv_ghcb) {
>> +		local_irq_restore(flags);
>> +		return;
>> +	}
>> +
>> +	memset(hv_ghcb, 0x00, HV_HYP_PAGE_SIZE);
> 
> Do you really need to zero out the whole 4k? The validation bitmap
> should be enough, there are no secrets on the page anyway.
> Same in hv_ghcb_msr_read().

OK. Thanks for suggestion. I will have a try.

> 
>> +enum es_result sev_es_ghcb_hv_call(struct ghcb *ghcb,
>> +				   struct es_em_ctxt *ctxt,
>> +				   u64 exit_code, u64 exit_info_1,
>> +				   u64 exit_info_2)
>>   {
>>   	enum es_result ret;
>>   
>> @@ -109,7 +109,16 @@ static enum es_result sev_es_ghcb_hv_call(struct ghcb *ghcb,
>>   	ghcb_set_sw_exit_info_1(ghcb, exit_info_1);
>>   	ghcb_set_sw_exit_info_2(ghcb, exit_info_2);
>>   
>> -	sev_es_wr_ghcb_msr(__pa(ghcb));
>> +	/*
>> +	 * Hyper-V runs paravisor with SEV. Ghcb page is allocated by
>> +	 * paravisor and not needs to be updated in the Linux guest.
>> +	 * Otherwise, the ghcb page's PA reported by paravisor is above
>> +	 * VTOM. Hyper-V use this function with NULL for ctxt point and
>> +	 * skip setting ghcb page in such case.
>> +	 */
>> +	if (ctxt)
>> +		sev_es_wr_ghcb_msr(__pa(ghcb));
> 
> No, do not make this function work with ctxt==NULL. Instead, factor out
> a helper function which contains what Hyper-V needs and use that in
> sev_es_ghcb_hv_call() and Hyper-V code.
> 

OK. Will update.

>> +union hv_ghcb {
>> +	struct ghcb ghcb;
>> +} __packed __aligned(PAGE_SIZE);
> 
> I am curious what this will end up being good for.
> 

Hyper-V introduces a specific hypercall request in GHCB page and use 
same union in the Linux Hyper-V code to read/write MSR and call the new 
hypercall request.
