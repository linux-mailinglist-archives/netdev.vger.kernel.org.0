Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1BC0398DBB
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 17:01:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232027AbhFBPDg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 11:03:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230072AbhFBPDf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 11:03:35 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABA77C061574;
        Wed,  2 Jun 2021 08:01:52 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id y15so2405396pfl.4;
        Wed, 02 Jun 2021 08:01:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+az3hl/4w22b3I/rRlTcQ1/sSF9KD2GATy/NbYn2SjU=;
        b=LFh9HsM5N4yAOGzJ85RpIVWyAjUPznHirCf8/j7G4yx59JLH20/Uh4u7wbdu1FOv1R
         BMS/VcyQyPaNyIBLyV79xaZ6CaUNzIjmBxRj8Fe+1khO8KcH3zpgVSaCPqyrS/mPSxUA
         SxH1O0RaYnJym4R1ouc54zGTJI9ko785LbI0cE/6JrbOl++1vJMUiWvQ+YxS/x02SX1A
         GtQ9eZiWdQ81n3fEqhZUgWSVZqHZymyGyts8taigNA7xByYUg2QhaEC1Sqw034dlDQ+n
         EaQjVI9wbITemQxMjxw+B5xkVM7JxSTIPhVvW43gJtVIEw3fB0lKjLuGjHRyUK5Iy7k4
         pXzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+az3hl/4w22b3I/rRlTcQ1/sSF9KD2GATy/NbYn2SjU=;
        b=sI4Vy4nBU5dmDoIiGcLaXTloMRiWF4DKdtAQg7+ctEWccFnHxPdQbnEDEUXl1/riRL
         QRW69aWC2NaBnC8kzGtJC1478CWNkidr3flpUP+JOHkt5/OaR7n1sEJyBZYh2mu+ReBZ
         hfI1YLOxlMGN/k1W6pqMXBchH/Pq6zchuIWztQwEWIHhTSYunAjQ4dEnTq89K20Gpr/y
         qc5I3smFTAVL7U/j3d2V5ldbc1838nBrknSsEj364zr47K5hYbTIspwUSt3T0nQtuJhY
         7CfRfOKniqRSZosM8eWdbhLIUeKdhbSmUD849Cu8Mn6/6Ei0z3KoNjSMRhwWteQKEcm7
         xmVw==
X-Gm-Message-State: AOAM532io0b+Ywbz+UNz2fJuj15tdtXTZEzT/s50ib0LwpWZ5LGA9kLr
        H38eIB4ZGDZzmldiXuhZs7w=
X-Google-Smtp-Source: ABdhPJztpeXS5x/Q7Ocwttmq+13ab9HvNAwDx8hEcPtnl/lWI6mAldnzn4lX5IPnQcCsuOUMA5JO9w==
X-Received: by 2002:a62:4e96:0:b029:2ea:2244:5e31 with SMTP id c144-20020a624e960000b02902ea22445e31mr3354423pfb.43.1622646112263;
        Wed, 02 Jun 2021 08:01:52 -0700 (PDT)
Received: from ?IPv6:2404:f801:0:5:8000::4b1? ([2404:f801:9000:1a:efea::4b1])
        by smtp.gmail.com with ESMTPSA id y13sm97917pgp.16.2021.06.02.08.01.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Jun 2021 08:01:51 -0700 (PDT)
Subject: Re: [RFC PATCH V3 09/11] HV/IOMMU: Enable swiotlb bounce buffer for
 Isolation VM
To:     Boris Ostrovsky <boris.ostrovsky@oracle.com>, kys@microsoft.com,
        haiyangz@microsoft.com, sthemmin@microsoft.com, wei.liu@kernel.org,
        decui@microsoft.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, x86@kernel.org, hpa@zytor.com, arnd@arndb.de,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        akpm@linux-foundation.org, kirill.shutemov@linux.intel.com,
        rppt@kernel.org, hannes@cmpxchg.org, cai@lca.pw,
        krish.sadhukhan@oracle.com, saravanand@fb.com,
        Tianyu.Lan@microsoft.com, konrad.wilk@oracle.com, hch@lst.de,
        m.szyprowski@samsung.com, robin.murphy@arm.com, jgross@suse.com,
        sstabellini@kernel.org, joro@8bytes.org, will@kernel.org,
        xen-devel@lists.xenproject.org, davem@davemloft.net,
        kuba@kernel.org, jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     iommu@lists.linux-foundation.org, linux-arch@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, netdev@vger.kernel.org,
        vkuznets@redhat.com, thomas.lendacky@amd.com,
        brijesh.singh@amd.com, sunilmut@microsoft.com
References: <20210530150628.2063957-1-ltykernel@gmail.com>
 <20210530150628.2063957-10-ltykernel@gmail.com>
 <9488c114-81ad-eb67-79c0-5ed319703d3e@oracle.com>
From:   Tianyu Lan <ltykernel@gmail.com>
Message-ID: <a023ee3f-ce85-b54f-79c3-146926bf3279@gmail.com>
Date:   Wed, 2 Jun 2021 23:01:36 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <9488c114-81ad-eb67-79c0-5ed319703d3e@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Boris:
	Thanks for your review.

On 6/2/2021 9:16 AM, Boris Ostrovsky wrote:
> 
> On 5/30/21 11:06 AM, Tianyu Lan wrote:
>> @@ -91,6 +92,6 @@ int pci_xen_swiotlb_init_late(void)
>>   EXPORT_SYMBOL_GPL(pci_xen_swiotlb_init_late);
>>   
>>   IOMMU_INIT_FINISH(2,
>> -		  NULL,
>> +		  hyperv_swiotlb_detect,
>>   		  pci_xen_swiotlb_init,
>>   		  NULL);
> 
> 
> Could you explain this change?

Hyper-V allocates its own swiotlb bounce buffer and the default
swiotlb buffer should not be allocated. swiotlb_init() in 
pci_swiotlb_init() is to allocate default swiotlb buffer.
To achieve this, put hyperv_swiotlb_detect() as the first entry in the 
iommu_table_entry list. The detect loop in the pci_iommu_alloc() will 
exit once hyperv_swiotlb_detect() is called in Hyper-V VM and other 
iommu_table_entry callback will not be called.
