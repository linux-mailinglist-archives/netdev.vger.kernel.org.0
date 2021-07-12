Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF8883C5A3E
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 13:03:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237833AbhGLJnY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 05:43:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237774AbhGLJnT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Jul 2021 05:43:19 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF164C0613E5;
        Mon, 12 Jul 2021 02:40:27 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id p4so4614513plo.11;
        Mon, 12 Jul 2021 02:40:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=k4GGfq+hVsQvPEL9sGnkKkX1T5cHEpElvgl+H/D8GGg=;
        b=EkbTRNsENXQloBh/r+302XMpUfivY4n/w5cVp65wMsO8W0nGbNZWXtUpGIviZUFMAy
         hVFPC6f41UQksp8J6hOtkXkI1ILbHE9sNZcJkJnKx0RudbrlBVNOQLGk52plindDLFMf
         0HidNEe5dnhfekaP3FOVdL3ce/SvQgBj9ik/lEvFt5vP9q7wJ5ZuDvmEpmvcF5JRom1t
         2eapWgs0Md02bchF5N+TVdbkrIOrWMIsIpK0TzcTloe094d/by9NBbGKhQB62sMXf/ds
         jqItDVYo/8NVUWioCBvu/2MyBq3LvV1RB8PjsNypw3SWcxG1OHtv43K0i0bJE0RuT+wZ
         vSmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=k4GGfq+hVsQvPEL9sGnkKkX1T5cHEpElvgl+H/D8GGg=;
        b=KnP1sN2evsKEsm/t9sSHosV4Vs/C8PVO8iFYGv9NXf+nVgq94saknqwyVtnDnYRp8G
         5UdLUBNQ1hMJ4LWvsvEGb18f/x6Gbw7xACZHr9hqUCuJ/gN2jyu/3GJ7eFDjiSLPhnLm
         4XkcIZvPqUM9QC7w9V8lPMH/pgQvHva2sjcvY+Z6KY5eDdyaSjbQuEAzfy/68pcjUE0o
         ppy89XrE7XP2DQ3lL9riXPgyVIH+ajNW0fKygVi4cqFhadsTp9IfkNU90WQgUyX8x1kY
         WeYdckF9+pC5JN78NiwMfYvT52thrwhwze1MlmZL7ACvj4DIrLHqadID9PjQHrkBxeSm
         yW9Q==
X-Gm-Message-State: AOAM532vPCjvcsVPN2QiRe7dWyAl38hkI9PtGJhD98Ysnl/A22QuUxEY
        i1yeEeIFnbcr/8GIwCD12QQ=
X-Google-Smtp-Source: ABdhPJwRdZQLr6WcRQHTJmvy3QekS6aYpqqDhr3YMzQ3fQO9CQGmdbyBFz8czGBJt97d+duRqdeEsg==
X-Received: by 2002:a17:90b:4a4d:: with SMTP id lb13mr13276916pjb.221.1626082827215;
        Mon, 12 Jul 2021 02:40:27 -0700 (PDT)
Received: from ?IPv6:2404:f801:0:5:8000::4b1? ([2404:f801:9000:1a:efea::4b1])
        by smtp.gmail.com with ESMTPSA id 31sm16879517pgu.17.2021.07.12.02.40.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Jul 2021 02:40:26 -0700 (PDT)
Subject: Re: [RFC PATCH V3 08/11] swiotlb: Add bounce buffer remap address
 setting function
From:   Tianyu Lan <ltykernel@gmail.com>
To:     Christoph Hellwig <hch@lst.de>, Robin Murphy <robin.murphy@arm.com>
Cc:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        arnd@arndb.de, dave.hansen@linux.intel.com, luto@kernel.org,
        peterz@infradead.org, akpm@linux-foundation.org,
        kirill.shutemov@linux.intel.com, rppt@kernel.org,
        hannes@cmpxchg.org, cai@lca.pw, krish.sadhukhan@oracle.com,
        saravanand@fb.com, Tianyu.Lan@microsoft.com,
        konrad.wilk@oracle.com, m.szyprowski@samsung.com,
        boris.ostrovsky@oracle.com, jgross@suse.com,
        sstabellini@kernel.org, joro@8bytes.org, will@kernel.org,
        xen-devel@lists.xenproject.org, davem@davemloft.net,
        kuba@kernel.org, jejb@linux.ibm.com, martin.petersen@oracle.com,
        iommu@lists.linux-foundation.org, linux-arch@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, netdev@vger.kernel.org,
        vkuznets@redhat.com, thomas.lendacky@amd.com,
        brijesh.singh@amd.com, sunilmut@microsoft.com
References: <20210530150628.2063957-1-ltykernel@gmail.com>
 <20210530150628.2063957-9-ltykernel@gmail.com>
 <20210607064312.GB24478@lst.de>
 <94038087-a33c-93c5-27bf-7ec1f6f5f0e3@arm.com> <20210614153252.GA1741@lst.de>
 <9e347c4c-d4b9-129c-10d2-0d7ff1b917cc@gmail.com>
Message-ID: <873a6872-e2f5-7c6c-ec57-d21305380cd9@gmail.com>
Date:   Mon, 12 Jul 2021 17:40:12 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <9e347c4c-d4b9-129c-10d2-0d7ff1b917cc@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Christoph and Robin:
      I introduced new interface set_memory_decrypted_map() to hide all
the hypervisor code behind it in the latest version. In current generic
code, only swiotlb bounce buffer needs to be decrypted and remapped in 
the same time and so keep set_memory_decrypted(). If there were more 
requests of set_memory_decrypted_map() for other platform, we may
replace set_memory_decrypted() step by step. Please have a look.
       https://lkml.org/lkml/2021/7/7/570

Thanks.

On 6/15/2021 11:24 PM, Tianyu Lan wrote:
> On 6/14/2021 11:32 PM, Christoph Hellwig wrote:
>> On Mon, Jun 14, 2021 at 02:49:51PM +0100, Robin Murphy wrote:
>>> FWIW, I think a better generalisation for this would be allowing
>>> set_memory_decrypted() to return an address rather than implicitly
>>> operating in-place, and hide all the various hypervisor hooks behind 
>>> that.
>>
>> Yes, something like that would be a good idea.  As-is
>> set_memory_decrypted is a pretty horribly API anyway due to passing
>> the address as void, and taking a size parameter while it works in units
>> of pages.  So I'd very much welcome a major overhaul of this API.
>>
> 
> Hi Christoph and Robin:
>      Thanks for your suggestion. I will try this idea in the next 
> version. Besides make the address translation into set_memory_
> decrypted() and return address, do you want to make other changes to the 
> API in order to make it more reasonable(e.g size parameter)?
> 
> Thanks
