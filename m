Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C90F46281A9
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 14:52:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229816AbiKNNwS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 08:52:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236250AbiKNNwR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 08:52:17 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 316C922BE0;
        Mon, 14 Nov 2022 05:52:16 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2F2EF23A;
        Mon, 14 Nov 2022 05:52:22 -0800 (PST)
Received: from [10.57.70.90] (unknown [10.57.70.90])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BC19B3F73D;
        Mon, 14 Nov 2022 05:52:14 -0800 (PST)
Message-ID: <796b5eac-8408-d1ef-352a-4722c3196295@arm.com>
Date:   Mon, 14 Nov 2022 13:52:09 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [PATCH -next] iommu/dma: avoid expensive indirect calls for sync
 operations
Content-Language: en-GB
From:   Robin Murphy <robin.murphy@arm.com>
To:     Eric Dumazet <edumazet@google.com>, Joerg Roedel <joro@8bytes.org>,
        Will Deacon <will@kernel.org>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        iommu@lists.linux.dev
References: <20221112040452.644234-1-edumazet@google.com>
 <1602bacc-d6c6-3780-a0ae-68137746fcf2@arm.com>
In-Reply-To: <1602bacc-d6c6-3780-a0ae-68137746fcf2@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-11-14 13:30, Robin Murphy wrote:
> On 2022-11-12 04:04, Eric Dumazet wrote:
>> Quite often, NIC devices do not need dma_sync operations
>> on x86_64 at least.
>>
>> Indeed, when dev_is_dma_coherent(dev) is true and
>> dev_use_swiotlb(dev) is false, iommu_dma_sync_single_for_cpu()
>> and friends do nothing.
>>
>> However, indirectly calling them when CONFIG_RETPOLINE=y
>> consumes about 10% of cycles on a cpu receiving packets
>> from softirq at ~100Gbit rate, as shown in [1]
>>
>> Even if/when CONFIG_RETPOLINE is not set, there
>> is a cost of about 3%.
>>
>> This patch adds a copy of iommu_dma_ops structure,
>> where sync_single_for_cpu, sync_single_for_device,
>> sync_sg_for_cpu and sync_sg_for_device are unset.
> 
> TBH I reckon it might be worthwhile to add another top-level bitfield to 
> struct device to indicate when syncs can be optimised out completely, so 
> we can handle it at the DMA API dispatch level and short-circuit a bit 
> more of the dma-direct path too.
> 
>> perf profile before the patch:
>>
>>      18.53%  [kernel]       [k] gq_rx_skb
>>      14.77%  [kernel]       [k] napi_reuse_skb
>>       8.95%  [kernel]       [k] skb_release_data
>>       5.42%  [kernel]       [k] dev_gro_receive
>>       5.37%  [kernel]       [k] memcpy
>> <*>  5.26%  [kernel]       [k] iommu_dma_sync_sg_for_cpu
>>       4.78%  [kernel]       [k] tcp_gro_receive
>> <*>  4.42%  [kernel]       [k] iommu_dma_sync_sg_for_device
>>       4.12%  [kernel]       [k] ipv6_gro_receive
>>       3.65%  [kernel]       [k] gq_pool_get
>>       3.25%  [kernel]       [k] skb_gro_receive
>>       2.07%  [kernel]       [k] napi_gro_frags
>>       1.98%  [kernel]       [k] tcp6_gro_receive
>>       1.27%  [kernel]       [k] gq_rx_prep_buffers
>>       1.18%  [kernel]       [k] gq_rx_napi_handler
>>       0.99%  [kernel]       [k] csum_partial
>>       0.74%  [kernel]       [k] csum_ipv6_magic
>>       0.72%  [kernel]       [k] free_pcp_prepare
>>       0.60%  [kernel]       [k] __napi_poll
>>       0.58%  [kernel]       [k] net_rx_action
>>       0.56%  [kernel]       [k] read_tsc
>> <*>  0.50%  [kernel]       [k] __x86_indirect_thunk_r11
>>       0.45%  [kernel]       [k] memset
>>
>> After patch, lines with <*> no longer show up, and overall
>> cpu usage looks much better (~60% instead of ~72%)
>>
>>      25.56%  [kernel]       [k] gq_rx_skb
>>       9.90%  [kernel]       [k] napi_reuse_skb
>>       7.39%  [kernel]       [k] dev_gro_receive
>>       6.78%  [kernel]       [k] memcpy
>>       6.53%  [kernel]       [k] skb_release_data
>>       6.39%  [kernel]       [k] tcp_gro_receive
>>       5.71%  [kernel]       [k] ipv6_gro_receive
>>       4.35%  [kernel]       [k] napi_gro_frags
>>       4.34%  [kernel]       [k] skb_gro_receive
>>       3.50%  [kernel]       [k] gq_pool_get
>>       3.08%  [kernel]       [k] gq_rx_napi_handler
>>       2.35%  [kernel]       [k] tcp6_gro_receive
>>       2.06%  [kernel]       [k] gq_rx_prep_buffers
>>       1.32%  [kernel]       [k] csum_partial
>>       0.93%  [kernel]       [k] csum_ipv6_magic
>>       0.65%  [kernel]       [k] net_rx_action
>>
>> Signed-off-by: Eric Dumazet <edumazet@google.com>
>> Cc: Robin Murphy <robin.murphy@arm.com>
>> Cc: Joerg Roedel <joro@8bytes.org>
>> Cc: Will Deacon <will@kernel.org>
>> Cc: iommu@lists.linux.dev
>> ---
>>   drivers/iommu/dma-iommu.c | 67 +++++++++++++++++++++++++++------------
>>   1 file changed, 47 insertions(+), 20 deletions(-)
>>
>> diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
>> index 
>> 9297b741f5e80e2408e864fc3f779410d6b04d49..976ba20a55eab5fd94e9bec2d38a2a60e0690444 100644
>> --- a/drivers/iommu/dma-iommu.c
>> +++ b/drivers/iommu/dma-iommu.c
>> @@ -522,6 +522,11 @@ static bool dev_use_swiotlb(struct device *dev)
>>       return IS_ENABLED(CONFIG_SWIOTLB) && dev_is_untrusted(dev);
>>   }
>> +static bool dev_is_dma_sync_needed(struct device *dev)
>> +{
>> +    return !dev_is_dma_coherent(dev) || dev_use_swiotlb(dev);
>> +}
>> +
>>   /**
>>    * iommu_dma_init_domain - Initialise a DMA mapping domain
>>    * @domain: IOMMU domain previously prepared by iommu_get_dma_cookie()
>> @@ -914,7 +919,7 @@ static void iommu_dma_sync_single_for_cpu(struct 
>> device *dev,
>>   {
>>       phys_addr_t phys;
>> -    if (dev_is_dma_coherent(dev) && !dev_use_swiotlb(dev))
>> +    if (!dev_is_dma_sync_needed(dev))
>>           return;
>>       phys = iommu_iova_to_phys(iommu_get_dma_domain(dev), dma_handle);
>> @@ -930,7 +935,7 @@ static void 
>> iommu_dma_sync_single_for_device(struct device *dev,
>>   {
>>       phys_addr_t phys;
>> -    if (dev_is_dma_coherent(dev) && !dev_use_swiotlb(dev))
>> +    if (!dev_is_dma_sync_needed(dev))
>>           return;
>>       phys = iommu_iova_to_phys(iommu_get_dma_domain(dev), dma_handle);
>> @@ -1544,30 +1549,51 @@ static size_t iommu_dma_opt_mapping_size(void)
>>       return iova_rcache_range();
>>   }
>> +#define iommu_dma_ops_common_fields \
>> +    .flags            = DMA_F_PCI_P2PDMA_SUPPORTED,        \
>> +    .alloc            = iommu_dma_alloc,            \
>> +    .free            = iommu_dma_free,            \
>> +    .alloc_pages        = dma_common_alloc_pages,        \
>> +    .free_pages        = dma_common_free_pages,        \
>> +    .alloc_noncontiguous    = iommu_dma_alloc_noncontiguous,    \
>> +    .free_noncontiguous    = iommu_dma_free_noncontiguous,        \
>> +    .mmap            = iommu_dma_mmap,            \
>> +    .get_sgtable        = iommu_dma_get_sgtable,        \
>> +    .map_page        = iommu_dma_map_page,            \
>> +    .unmap_page        = iommu_dma_unmap_page,            \
>> +    .map_sg            = iommu_dma_map_sg,            \
>> +    .unmap_sg        = iommu_dma_unmap_sg,            \
>> +    .map_resource        = iommu_dma_map_resource,        \
>> +    .unmap_resource        = iommu_dma_unmap_resource,        \
>> +    .get_merge_boundary    = iommu_dma_get_merge_boundary,        \
>> +    .opt_mapping_size    = iommu_dma_opt_mapping_size,
>> +
>>   static const struct dma_map_ops iommu_dma_ops = {
>> -    .flags            = DMA_F_PCI_P2PDMA_SUPPORTED,
>> -    .alloc            = iommu_dma_alloc,
>> -    .free            = iommu_dma_free,
>> -    .alloc_pages        = dma_common_alloc_pages,
>> -    .free_pages        = dma_common_free_pages,
>> -    .alloc_noncontiguous    = iommu_dma_alloc_noncontiguous,
>> -    .free_noncontiguous    = iommu_dma_free_noncontiguous,
>> -    .mmap            = iommu_dma_mmap,
>> -    .get_sgtable        = iommu_dma_get_sgtable,
>> -    .map_page        = iommu_dma_map_page,
>> -    .unmap_page        = iommu_dma_unmap_page,
>> -    .map_sg            = iommu_dma_map_sg,
>> -    .unmap_sg        = iommu_dma_unmap_sg,
>> +    iommu_dma_ops_common_fields
>> +
>>       .sync_single_for_cpu    = iommu_dma_sync_single_for_cpu,
>>       .sync_single_for_device    = iommu_dma_sync_single_for_device,
>>       .sync_sg_for_cpu    = iommu_dma_sync_sg_for_cpu,
>>       .sync_sg_for_device    = iommu_dma_sync_sg_for_device,
>> -    .map_resource        = iommu_dma_map_resource,
>> -    .unmap_resource        = iommu_dma_unmap_resource,
>> -    .get_merge_boundary    = iommu_dma_get_merge_boundary,
>> -    .opt_mapping_size    = iommu_dma_opt_mapping_size,
>>   };
>> +/* Special instance of iommu_dma_ops for devices satisfying this 
>> condition:
>> + *   !dev_is_dma_sync_needed(dev)
>> + *
>> + * iommu_dma_sync_single_for_cpu(), iommu_dma_sync_single_for_device(),
>> + * iommu_dma_sync_sg_for_cpu(), iommu_dma_sync_sg_for_device()
>> + * do nothing special and can be avoided, saving indirect calls.
>> + */
>> +static const struct dma_map_ops iommu_nosync_dma_ops = {
>> +    iommu_dma_ops_common_fields
>> +
>> +    .sync_single_for_cpu    = NULL,
>> +    .sync_single_for_device    = NULL,
>> +    .sync_sg_for_cpu    = NULL,
>> +    .sync_sg_for_device    = NULL,
>> +};
>> +#undef iommu_dma_ops_common_fields
>> +
>>   /*
>>    * The IOMMU core code allocates the default DMA domain, which the 
>> underlying
>>    * IOMMU driver needs to support via the dma-iommu layer.
>> @@ -1586,7 +1612,8 @@ void iommu_setup_dma_ops(struct device *dev, u64 
>> dma_base, u64 dma_limit)
>>       if (iommu_is_dma_domain(domain)) {
>>           if (iommu_dma_init_domain(domain, dma_base, dma_limit, dev))
>>               goto out_err;
>> -        dev->dma_ops = &iommu_dma_ops;
>> +        dev->dma_ops = dev_is_dma_sync_needed(dev) ?
>> +                &iommu_dma_ops : &iommu_nosync_dma_ops;
> 
> This doesn't work, because at this point we don't know whether a 
> coherent device is still going to need SWIOTLB for DMA mask reasons or not.

Wait, no, now I've completely confused myself... :(

This probably *is* OK since it's specifically iommu_dma_ops, not DMA ops 
in general, and we don't support IOMMUs with addressing limitations of 
their own. Plus the other reasons for hooking into SWIOTLB here that 
have also muddled my brain have been for non-coherent stuff, so still 
probably shouldn't make a difference.

Either way I do think it would be neatest to handle this higher up in 
the API (not to mention apparently easier to reason about...)

Thanks,
Robin.
