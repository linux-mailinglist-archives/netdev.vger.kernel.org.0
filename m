Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BF4A637175
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 05:23:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229673AbiKXEXm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 23:23:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229750AbiKXEXf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 23:23:35 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3C163AC13;
        Wed, 23 Nov 2022 20:23:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669263813; x=1700799813;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=SJdkNeoyHI9xJFDb93l0EehAs69+xowOv7c6ux2VLLI=;
  b=JfboAtjGpSs4zt0uPCKW/j2Fe4RC/0FgY1GxlHKA5/xDDq7X1f1CEAd9
   VPD3LPCkHPJU9tghpICcbLeLtGkKGXe28YGUe3UsPP18JYfm0uqnUamqN
   1uQOG7BHS93/m8yQpuh15fJ8Lc47ezEJ0b8hyyYEfSxAC5ovMVJf9dnnI
   DPVPrIQelTqiJEQml0nThhZFPyhGm2iWs1PBnScNcEQWNemeqdD/qspfr
   gWLq5huYzMnqBovcz44nEuxDYRUhQI9/Ck6lrbXzVPvPXEz0RKts6Xnx1
   /+t4yGWL+G1m1KNjk7w1jx6cNZbFILw5YRipcNVa0ogG3ln9T5wyYLxCy
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="378471604"
X-IronPort-AV: E=Sophos;i="5.96,189,1665471600"; 
   d="scan'208";a="378471604"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2022 20:23:33 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="971104795"
X-IronPort-AV: E=Sophos;i="5.96,189,1665471600"; 
   d="scan'208";a="971104795"
Received: from zhaohaif-mobl.ccr.corp.intel.com (HELO [10.254.212.205]) ([10.254.212.205])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2022 20:23:30 -0800
Message-ID: <73b5ba7e-a4e2-ee95-d16b-942343a04d03@linux.intel.com>
Date:   Thu, 24 Nov 2022 12:23:28 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH -next] iommu/dma: avoid expensive indirect calls for sync
 operations
To:     Eric Dumazet <edumazet@google.com>, Joerg Roedel <joro@8bytes.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Will Deacon <will@kernel.org>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        iommu@lists.linux.dev
References: <20221112040452.644234-1-edumazet@google.com>
From:   Ethan Zhao <haifeng.zhao@linux.intel.com>
In-Reply-To: <20221112040452.644234-1-edumazet@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 2022/11/12 12:04, Eric Dumazet wrote:
> Quite often, NIC devices do not need dma_sync operations
> on x86_64 at least.
>
> Indeed, when dev_is_dma_coherent(dev) is true and
> dev_use_swiotlb(dev) is false, iommu_dma_sync_single_for_cpu()
> and friends do nothing.
>
> However, indirectly calling them when CONFIG_RETPOLINE=y
> consumes about 10% of cycles on a cpu receiving packets
> from softirq at ~100Gbit rate, as shown in [1]
>
> Even if/when CONFIG_RETPOLINE is not set, there
> is a cost of about 3%.
>
> This patch adds a copy of iommu_dma_ops structure,
> where sync_single_for_cpu, sync_single_for_device,
> sync_sg_for_cpu and sync_sg_for_device are unset.
>
> perf profile before the patch:
>
>      18.53%  [kernel]       [k] gq_rx_skb
>      14.77%  [kernel]       [k] napi_reuse_skb
>       8.95%  [kernel]       [k] skb_release_data
>       5.42%  [kernel]       [k] dev_gro_receive
>       5.37%  [kernel]       [k] memcpy
> <*>  5.26%  [kernel]       [k] iommu_dma_sync_sg_for_cpu
>       4.78%  [kernel]       [k] tcp_gro_receive
> <*>  4.42%  [kernel]       [k] iommu_dma_sync_sg_for_device
>       4.12%  [kernel]       [k] ipv6_gro_receive
>       3.65%  [kernel]       [k] gq_pool_get
>       3.25%  [kernel]       [k] skb_gro_receive
>       2.07%  [kernel]       [k] napi_gro_frags
>       1.98%  [kernel]       [k] tcp6_gro_receive
>       1.27%  [kernel]       [k] gq_rx_prep_buffers
>       1.18%  [kernel]       [k] gq_rx_napi_handler
>       0.99%  [kernel]       [k] csum_partial
>       0.74%  [kernel]       [k] csum_ipv6_magic
>       0.72%  [kernel]       [k] free_pcp_prepare
>       0.60%  [kernel]       [k] __napi_poll
>       0.58%  [kernel]       [k] net_rx_action
>       0.56%  [kernel]       [k] read_tsc
> <*>  0.50%  [kernel]       [k] __x86_indirect_thunk_r11
>       0.45%  [kernel]       [k] memset
>
> After patch, lines with <*> no longer show up, and overall
> cpu usage looks much better (~60% instead of ~72%)
>
>      25.56%  [kernel]       [k] gq_rx_skb
>       9.90%  [kernel]       [k] napi_reuse_skb
>       7.39%  [kernel]       [k] dev_gro_receive
>       6.78%  [kernel]       [k] memcpy
>       6.53%  [kernel]       [k] skb_release_data
>       6.39%  [kernel]       [k] tcp_gro_receive
>       5.71%  [kernel]       [k] ipv6_gro_receive
>       4.35%  [kernel]       [k] napi_gro_frags
>       4.34%  [kernel]       [k] skb_gro_receive
>       3.50%  [kernel]       [k] gq_pool_get
>       3.08%  [kernel]       [k] gq_rx_napi_handler
>       2.35%  [kernel]       [k] tcp6_gro_receive
>       2.06%  [kernel]       [k] gq_rx_prep_buffers
>       1.32%  [kernel]       [k] csum_partial
>       0.93%  [kernel]       [k] csum_ipv6_magic
>       0.65%  [kernel]       [k] net_rx_action
>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Robin Murphy <robin.murphy@arm.com>
> Cc: Joerg Roedel <joro@8bytes.org>
> Cc: Will Deacon <will@kernel.org>
> Cc: iommu@lists.linux.dev
> ---
>   drivers/iommu/dma-iommu.c | 67 +++++++++++++++++++++++++++------------
>   1 file changed, 47 insertions(+), 20 deletions(-)
>
> diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
> index 9297b741f5e80e2408e864fc3f779410d6b04d49..976ba20a55eab5fd94e9bec2d38a2a60e0690444 100644
> --- a/drivers/iommu/dma-iommu.c
> +++ b/drivers/iommu/dma-iommu.c
> @@ -522,6 +522,11 @@ static bool dev_use_swiotlb(struct device *dev)
>   	return IS_ENABLED(CONFIG_SWIOTLB) && dev_is_untrusted(dev);
>   }
>   
> +static bool dev_is_dma_sync_needed(struct device *dev)
> +{
> +	return !dev_is_dma_coherent(dev) || dev_use_swiotlb(dev);
> +}
> +
>   /**
>    * iommu_dma_init_domain - Initialise a DMA mapping domain
>    * @domain: IOMMU domain previously prepared by iommu_get_dma_cookie()
> @@ -914,7 +919,7 @@ static void iommu_dma_sync_single_for_cpu(struct device *dev,
>   {
>   	phys_addr_t phys;
>   
> -	if (dev_is_dma_coherent(dev) && !dev_use_swiotlb(dev))
> +	if (!dev_is_dma_sync_needed(dev))

Seems this function is also called by iommu_dma_map_page()  pair and it 
already checked

if the device is coherent,  so do we need this duplicate 
dev_is_dma_sync_needed(dev) ?

How about we move this checking to iommu_dma_map_page() 
/iommu_dma_unmap_page()

then no need checking here anymore ?


Thanks,

Ethan


>   		return;
>   
>   	phys = iommu_iova_to_phys(iommu_get_dma_domain(dev), dma_handle);
> @@ -930,7 +935,7 @@ static void iommu_dma_sync_single_for_device(struct device *dev,
>   {
>   	phys_addr_t phys;
>   
> -	if (dev_is_dma_coherent(dev) && !dev_use_swiotlb(dev))
> +	if (!dev_is_dma_sync_needed(dev))
>   		return;
>   
>   	phys = iommu_iova_to_phys(iommu_get_dma_domain(dev), dma_handle);
> @@ -1544,30 +1549,51 @@ static size_t iommu_dma_opt_mapping_size(void)
>   	return iova_rcache_range();
>   }
>   
> +#define iommu_dma_ops_common_fields \
> +	.flags			= DMA_F_PCI_P2PDMA_SUPPORTED,		\
> +	.alloc			= iommu_dma_alloc,			\
> +	.free			= iommu_dma_free,			\
> +	.alloc_pages		= dma_common_alloc_pages,		\
> +	.free_pages		= dma_common_free_pages,		\
> +	.alloc_noncontiguous	= iommu_dma_alloc_noncontiguous,	\
> +	.free_noncontiguous	= iommu_dma_free_noncontiguous,		\
> +	.mmap			= iommu_dma_mmap,			\
> +	.get_sgtable		= iommu_dma_get_sgtable,		\
> +	.map_page		= iommu_dma_map_page,			\
> +	.unmap_page		= iommu_dma_unmap_page,			\
> +	.map_sg			= iommu_dma_map_sg,			\
> +	.unmap_sg		= iommu_dma_unmap_sg,			\
> +	.map_resource		= iommu_dma_map_resource,		\
> +	.unmap_resource		= iommu_dma_unmap_resource,		\
> +	.get_merge_boundary	= iommu_dma_get_merge_boundary,		\
> +	.opt_mapping_size	= iommu_dma_opt_mapping_size,
> +
>   static const struct dma_map_ops iommu_dma_ops = {
> -	.flags			= DMA_F_PCI_P2PDMA_SUPPORTED,
> -	.alloc			= iommu_dma_alloc,
> -	.free			= iommu_dma_free,
> -	.alloc_pages		= dma_common_alloc_pages,
> -	.free_pages		= dma_common_free_pages,
> -	.alloc_noncontiguous	= iommu_dma_alloc_noncontiguous,
> -	.free_noncontiguous	= iommu_dma_free_noncontiguous,
> -	.mmap			= iommu_dma_mmap,
> -	.get_sgtable		= iommu_dma_get_sgtable,
> -	.map_page		= iommu_dma_map_page,
> -	.unmap_page		= iommu_dma_unmap_page,
> -	.map_sg			= iommu_dma_map_sg,
> -	.unmap_sg		= iommu_dma_unmap_sg,
> +	iommu_dma_ops_common_fields
> +
>   	.sync_single_for_cpu	= iommu_dma_sync_single_for_cpu,
>   	.sync_single_for_device	= iommu_dma_sync_single_for_device,
>   	.sync_sg_for_cpu	= iommu_dma_sync_sg_for_cpu,
>   	.sync_sg_for_device	= iommu_dma_sync_sg_for_device,
> -	.map_resource		= iommu_dma_map_resource,
> -	.unmap_resource		= iommu_dma_unmap_resource,
> -	.get_merge_boundary	= iommu_dma_get_merge_boundary,
> -	.opt_mapping_size	= iommu_dma_opt_mapping_size,
>   };
>   
> +/* Special instance of iommu_dma_ops for devices satisfying this condition:
> + *   !dev_is_dma_sync_needed(dev)
> + *
> + * iommu_dma_sync_single_for_cpu(), iommu_dma_sync_single_for_device(),
> + * iommu_dma_sync_sg_for_cpu(), iommu_dma_sync_sg_for_device()
> + * do nothing special and can be avoided, saving indirect calls.
> + */
> +static const struct dma_map_ops iommu_nosync_dma_ops = {
> +	iommu_dma_ops_common_fields
> +
> +	.sync_single_for_cpu	= NULL,
> +	.sync_single_for_device	= NULL,
> +	.sync_sg_for_cpu	= NULL,
> +	.sync_sg_for_device	= NULL,
> +};
> +#undef iommu_dma_ops_common_fields
> +
>   /*
>    * The IOMMU core code allocates the default DMA domain, which the underlying
>    * IOMMU driver needs to support via the dma-iommu layer.
> @@ -1586,7 +1612,8 @@ void iommu_setup_dma_ops(struct device *dev, u64 dma_base, u64 dma_limit)
>   	if (iommu_is_dma_domain(domain)) {
>   		if (iommu_dma_init_domain(domain, dma_base, dma_limit, dev))
>   			goto out_err;
> -		dev->dma_ops = &iommu_dma_ops;
> +		dev->dma_ops = dev_is_dma_sync_needed(dev) ?
> +				&iommu_dma_ops : &iommu_nosync_dma_ops;
>   	}
>   
>   	return;
