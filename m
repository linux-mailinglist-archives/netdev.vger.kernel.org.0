Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E689E3A83E4
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 17:25:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231520AbhFOP1Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 11:27:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231307AbhFOP1P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 11:27:15 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3C46C061574;
        Tue, 15 Jun 2021 08:25:09 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id v7so3002476pgl.2;
        Tue, 15 Jun 2021 08:25:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=phyWWBHzkBpxWNeuQJLinu+go2K8vm0IQjBk4bPOC5o=;
        b=lLzyvAx1eLMBBQ9Nv6UWlyfS7bq09JfNMuTSA72Pidzs3ADzEJh5UZNx1+KXAA3QS7
         9qLwmHEZw5Xk+RHIQHD4WFV677p8Yi8BHKdEaKAbO078PZhHBwsAaiGPsQh7STbxJ28j
         3L9M/FShV9IoCoZ9A/Eh9ROBNoQr5F07JQAgtoeaUjtdIexg1Nk9GrQcrUXxHc9NNgOV
         D2nJiITYw2LCAuwzkpdFMOLcTULHsDylV5FWGHXPlqFv03pjAoTRz+TNqy9uLL90+fK0
         edPtBl2ZDPRtYC3zVnWadcZFdsLes9V2OCmaC/x9ZwogRVqJGjkXmr9UDyWpPbPkMxE8
         xgYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=phyWWBHzkBpxWNeuQJLinu+go2K8vm0IQjBk4bPOC5o=;
        b=r/+D0eo5vByu6Z5a5LdMbGRd1WPYAHS+JolUben3rfWchrPihzES/s2APVCiLTXZgY
         xEWRlLhc2MaMrHSkbU5nPyIyKrHfbgZ2OAdCGP23qV74boRXi8Lr7WE0ht4PNaDXYktT
         Fr2GutsYE2nChwuvTMCbp1HM4cxTfS0sMSQQhEctxDgj6sRrJ/3OCkFsbGu/AMecZoQa
         W9rvqtMPILmZtrICGHcaO4J1QM2mEgAwmaG+9MUB3C6Oc8Pm0bKulf7ZYhfxJqidBHrW
         UtKjAnwEsK+WJxqsFRPAcoDkRjvzRO9zlQ+3D/qf2hfTjFVp839p2VHn+yqA/iN01rUz
         +guA==
X-Gm-Message-State: AOAM533/8P0U7U6zvTbi75I1f3Bxx1m4Dn0I6HneBCii/K9iZhBS40R+
        ghBTh0MhWDSnKsLGIu1DtBk=
X-Google-Smtp-Source: ABdhPJwV2uWurEEhhhqeCwFEjPg+6PpMse5GS6lAolB+VF7P2QpHJP+RpOWgZ5BBFF0RzwB+7lXyqg==
X-Received: by 2002:a65:6481:: with SMTP id e1mr85503pgv.140.1623770709416;
        Tue, 15 Jun 2021 08:25:09 -0700 (PDT)
Received: from ?IPv6:2404:f801:0:5:8000::4b1? ([2404:f801:9000:1a:efea::4b1])
        by smtp.gmail.com with ESMTPSA id u2sm15258266pfg.67.2021.06.15.08.24.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Jun 2021 08:25:09 -0700 (PDT)
Subject: Re: [RFC PATCH V3 08/11] swiotlb: Add bounce buffer remap address
 setting function
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
From:   Tianyu Lan <ltykernel@gmail.com>
Message-ID: <9e347c4c-d4b9-129c-10d2-0d7ff1b917cc@gmail.com>
Date:   Tue, 15 Jun 2021 23:24:57 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210614153252.GA1741@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/14/2021 11:32 PM, Christoph Hellwig wrote:
> On Mon, Jun 14, 2021 at 02:49:51PM +0100, Robin Murphy wrote:
>> FWIW, I think a better generalisation for this would be allowing
>> set_memory_decrypted() to return an address rather than implicitly
>> operating in-place, and hide all the various hypervisor hooks behind that.
> 
> Yes, something like that would be a good idea.  As-is
> set_memory_decrypted is a pretty horribly API anyway due to passing
> the address as void, and taking a size parameter while it works in units
> of pages.  So I'd very much welcome a major overhaul of this API.
> 

Hi Christoph and Robin:
	Thanks for your suggestion. I will try this idea in the next version. 
Besides make the address translation into set_memory_
decrypted() and return address, do you want to make other changes to the 
API in order to make it more reasonable(e.g size parameter)?

Thanks
