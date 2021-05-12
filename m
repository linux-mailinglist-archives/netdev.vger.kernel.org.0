Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C77A137CC47
	for <lists+netdev@lfdr.de>; Wed, 12 May 2021 19:03:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233053AbhELQnu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 12:43:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241766AbhELQ2A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 May 2021 12:28:00 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 669DEC08C5E3;
        Wed, 12 May 2021 09:01:14 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id gc22-20020a17090b3116b02901558435aec1so3545617pjb.4;
        Wed, 12 May 2021 09:01:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5/MplZ6oYXtQw2JFwTKJsqNpcX+apjnkiw44w1Cqcuo=;
        b=EQwntmF6pP3DBJ88bmhariOI9t4IKKtCPxB2phWGOC74jrMotb3ZCiTXXW16g67V0h
         8HVeJ0GheMO0pRAFNX4jKbmzmE+Qf8EKG3s79mh2+TjoJ77eNPmt01t4bFBgCEpZMQYS
         LtqGvaxjzI7bnbkr39ucdoF9COsZV+kpDzrwJ3LopkNaVGle3wN8WsASeqDSWcrxUXNq
         l5Oqo36f1zOS36IgBY0vrE19xWxnxCnuQZW0ACKwM1vfnoNVDWJ5KT6c8CBkMQmT0Avv
         j0Aoqpt+TzspMyc0v3GAvNXVY/RSbD7UNpll9CI5ElGs5Xyk4zXN78+QI0vIQtbqXWFj
         2nGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5/MplZ6oYXtQw2JFwTKJsqNpcX+apjnkiw44w1Cqcuo=;
        b=iTNPI9+g6uEyvSg1ZjeXqt0vqhPzmchPxSYMFRukTiAHsmoWETaA1S8X3kxLwUrqRL
         LJjTP+s/RGkWBAe/cuaOtoKspqcZvNbG59O3wuV9bSAh/r8tYKXgENQic7gDVg+jrIbu
         VjVLQ9QgxmME9YJm150963ttpogsvzEtWZKdT0UVsCGzkAVHeDa29Syu0nvFfKHn7Uje
         Kh0Fpi+icBkxkJ6lP1h86pRAO434JjRP9d3cZkHSSMRvRI5VzezBREXPMQoTWFNWii9t
         q3jXYOnnV7v52dFqng77nneWVlgZhBqemQBF6dLrQ99cRHQkJNLhvj5UtkO9z1LD5YEU
         d3HQ==
X-Gm-Message-State: AOAM530qYfh5IN4C5iOnHJHfstm89JzzZDccu6mAiPbNRaDTsAI7poR6
        15wdC8Hl7bSzZa2uBeQrkPo=
X-Google-Smtp-Source: ABdhPJxtWg7IxeHd7M+hWJJqKPqAcUV/yJEzGw/b/vFIZdhJW26Hi6Inh2Unritq+GbozDcH9ke1gw==
X-Received: by 2002:a17:90a:7442:: with SMTP id o2mr2519021pjk.44.1620835273807;
        Wed, 12 May 2021 09:01:13 -0700 (PDT)
Received: from ?IPv6:2404:f801:0:5:8000::4b1? ([2404:f801:9000:1a:efea::4b1])
        by smtp.gmail.com with ESMTPSA id i24sm238402pfd.35.2021.05.12.09.01.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 May 2021 09:01:13 -0700 (PDT)
Subject: Re: [Resend RFC PATCH V2 10/12] HV/IOMMU: Add Hyper-V dma ops support
To:     Christoph Hellwig <hch@lst.de>, konrad.wilk@oracle.com
Cc:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, x86@kernel.org, hpa@zytor.com, arnd@arndb.de,
        akpm@linux-foundation.org, gregkh@linuxfoundation.org,
        konrad.wilk@oracle.com, m.szyprowski@samsung.com,
        robin.murphy@arm.com, joro@8bytes.org, will@kernel.org,
        davem@davemloft.net, kuba@kernel.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, Tianyu Lan <Tianyu.Lan@microsoft.com>,
        iommu@lists.linux-foundation.org, linux-arch@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-scsi@vger.kernel.org,
        netdev@vger.kernel.org, vkuznets@redhat.com,
        thomas.lendacky@amd.com, brijesh.singh@amd.com,
        sunilmut@microsoft.com
References: <20210414144945.3460554-1-ltykernel@gmail.com>
 <20210414144945.3460554-11-ltykernel@gmail.com>
 <20210414154729.GD32045@lst.de>
From:   Tianyu Lan <ltykernel@gmail.com>
Message-ID: <a316af73-2c96-f307-6285-593597e05123@gmail.com>
Date:   Thu, 13 May 2021 00:01:01 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210414154729.GD32045@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Christoph and Konrad:
      Current Swiotlb bounce buffer uses a pool for all devices. There
is a high overhead to get or free bounce buffer during performance test.
Swiotlb code now use a global spin lock to protect bounce buffer data.
Several device queues try to acquire the spin lock and this introduce
additional overhead.

For performance and security perspective, each devices should have a
separate swiotlb bounce buffer pool and so this part needs to rework.
I want to check this is right way to resolve performance issues with 
swiotlb bounce buffer. If you have some other suggestions,welcome.

Thanks.

On 4/14/2021 11:47 PM, Christoph Hellwig wrote:
>> +static dma_addr_t hyperv_map_page(struct device *dev, struct page *page,
>> +				  unsigned long offset, size_t size,
>> +				  enum dma_data_direction dir,
>> +				  unsigned long attrs)
>> +{
>> +	phys_addr_t map, phys = (page_to_pfn(page) << PAGE_SHIFT) + offset;
>> +
>> +	if (!hv_is_isolation_supported())
>> +		return phys;
>> +
>> +	map = swiotlb_tbl_map_single(dev, phys, size, HV_HYP_PAGE_SIZE, dir,
>> +				     attrs);
>> +	if (map == (phys_addr_t)DMA_MAPPING_ERROR)
>> +		return DMA_MAPPING_ERROR;
>> +
>> +	return map;
>> +}
> 
> This largerly duplicates what dma-direct + swiotlb does.  Please use
> force_dma_unencrypted to force bounce buffering and just use the generic
> code.
> 
>> +	if (hv_isolation_type_snp()) {
>> +		ret = hv_set_mem_host_visibility(
>> +				phys_to_virt(hyperv_io_tlb_start),
>> +				hyperv_io_tlb_size,
>> +				VMBUS_PAGE_VISIBLE_READ_WRITE);
>> +		if (ret)
>> +			panic("%s: Fail to mark Hyper-v swiotlb buffer visible to host. err=%d\n",
>> +			      __func__, ret);
>> +
>> +		hyperv_io_tlb_remap = ioremap_cache(hyperv_io_tlb_start
>> +					    + ms_hyperv.shared_gpa_boundary,
>> +						    hyperv_io_tlb_size);
>> +		if (!hyperv_io_tlb_remap)
>> +			panic("%s: Fail to remap io tlb.\n", __func__);
>> +
>> +		memset(hyperv_io_tlb_remap, 0x00, hyperv_io_tlb_size);
>> +		swiotlb_set_bounce_remap(hyperv_io_tlb_remap);
> 
> And this really needs to go into a common hook where we currently just
> call set_memory_decrypted so that all the different schemes for these
> trusted VMs (we have about half a dozen now) can share code rather than
> reinventing it.
> 
