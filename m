Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E98A3A2DDD
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 16:17:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231274AbhFJOS5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 10:18:57 -0400
Received: from mail-pf1-f180.google.com ([209.85.210.180]:41944 "EHLO
        mail-pf1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229941AbhFJOS4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 10:18:56 -0400
Received: by mail-pf1-f180.google.com with SMTP id x73so1729697pfc.8;
        Thu, 10 Jun 2021 07:17:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Z06P6xfCZfBoLzLGshR2eXD11imPLnqUoouenixaYFw=;
        b=APiM6yjkYAKij1RjMOo9hW4vLGKN36RaoDPpCZzJkgCIWIc5bNnUPRKfG+5uelh6im
         ZwmwB/K2y2Z+UnBHFw6Ok84giPqAWtESqJu7RLH3vi1s6Wmdl12YoCN5FEDC7FxVL8S3
         xBQJ/O0hMPtGsBtUowS8mRCmJHg4qC1j99bvIODTP9XmlSIGPDf9QrQ49kI/Ur72auK8
         XR3tyDiPInVQQ5Wc5igpAdJ+WpQK2Nh7QdvgHpHFXPPDhb1Z06nj6QGPTXJjDDNCczPn
         w4fJFgDDWFpzxBgC5Dh+DND5ldxosu/Bv7P7MHz+0qfPe5TrP3iyAg6tpfZqrx3I67eW
         JLfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Z06P6xfCZfBoLzLGshR2eXD11imPLnqUoouenixaYFw=;
        b=XaP2yxf6p0EKCIuof+I1AqN4D/9Nx4D2xw7u8xYntXSH91lcr4myNhjC4mmDZC96RG
         U1bO1045DXmOevKYWy9O744XeV7r+vMCKIGzaB20RRJYzrACfpgc/g0l5wuaV1Rd2Ugn
         SY5ujf2YsrLo8rJyU7L4oAUUB4zD7wuka/HXYvh12QAgLobHx3FKsCJLX3cXVOCqro8O
         QU/6MTNKZl90+coDG1RqvWTbsVWFQ7VsTPNcNxNJIkhFHumA4Dk0TIPyw0paIUrMzfAU
         zndeZwTJKW6yJtUJuUNF9d1WLFK+XWuc/7h8k5R/DVh2qloFW5EFxFqruoRY8dzI8T+h
         t4YA==
X-Gm-Message-State: AOAM530QGmpWMdaEDaWdIkTebSHZMq8xdXNpxUFwmOZnCTnt6C8wSKp1
        4Fl1mygSDSxHdoRe8RgENSE=
X-Google-Smtp-Source: ABdhPJzmTLyJiMIH7/kQoP6L+VhlUA+7RnmijLx7oWBaXhPdpzGgcAEZV6BSepEVhxfy3ZoxIY2hkg==
X-Received: by 2002:a63:4e20:: with SMTP id c32mr5182730pgb.104.1623334560354;
        Thu, 10 Jun 2021 07:16:00 -0700 (PDT)
Received: from ?IPv6:2404:f801:0:5:8000::4b1? ([2404:f801:9000:1a:efea::4b1])
        by smtp.gmail.com with ESMTPSA id f6sm2629239pfb.28.2021.06.10.07.15.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Jun 2021 07:15:59 -0700 (PDT)
Subject: Re: [RFC PATCH V3 04/11] HV: Add Write/Read MSR registers via ghcb
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
 <20210530150628.2063957-5-ltykernel@gmail.com> <YMC4JdtYO+eLDKh5@8bytes.org>
From:   Tianyu Lan <ltykernel@gmail.com>
Message-ID: <bd84a1a1-1dae-1dc0-8175-ed8bf19e705c@gmail.com>
Date:   Thu, 10 Jun 2021 22:15:46 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <YMC4JdtYO+eLDKh5@8bytes.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/9/2021 8:46 PM, Joerg Roedel wrote:
> On Sun, May 30, 2021 at 11:06:21AM -0400, Tianyu Lan wrote:
>> +void hv_ghcb_msr_write(u64 msr, u64 value)
>> +{
>> +	union hv_ghcb *hv_ghcb;
>> +	void **ghcb_base;
>> +	unsigned long flags;
>> +
>> +	if (!ms_hyperv.ghcb_base)
>> +		return;
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
>> +
>> +	hv_ghcb->ghcb.protocol_version = 1;
>> +	hv_ghcb->ghcb.ghcb_usage = 0;
>> +
>> +	ghcb_set_sw_exit_code(&hv_ghcb->ghcb, SVM_EXIT_MSR);
>> +	ghcb_set_rcx(&hv_ghcb->ghcb, msr);
>> +	ghcb_set_rax(&hv_ghcb->ghcb, lower_32_bits(value));
>> +	ghcb_set_rdx(&hv_ghcb->ghcb, value >> 32);
>> +	ghcb_set_sw_exit_info_1(&hv_ghcb->ghcb, 1);
>> +	ghcb_set_sw_exit_info_2(&hv_ghcb->ghcb, 0);
>> +
>> +	VMGEXIT();
> 
> This is not safe to use from NMI context. You need at least some
> checking or WARN_ON/assertion/whatever to catch cases where this is
> violated. Otherwise it will result in some hard to debug bug reports.
> 

Nice catch. Will update in the next version.

Thanks.
