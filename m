Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94D5F84677
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 09:56:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387521AbfHGH4Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 03:56:25 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:58286 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727413AbfHGH4Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Aug 2019 03:56:25 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x777sVrp042116;
        Wed, 7 Aug 2019 07:56:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=vb94Xu/WRdFxAZR3eQGfCToyPrjki8zHPtft8A3HtDI=;
 b=Wh70IRXxx4ZxP4r2wEFpWJx5eB0HIE3YqCkGEcmEBs1hMlRjDxwAyc0ViDxpxJaddqkQ
 iicMxYAuK1i+FUlrVeBdydzSZMbB7ABmO0VXqkuqRMqvGTYe6xIgyA+kSA83/LTbRiwE
 8c4Sh0FkT2zRg0Jzd4iO3wASvjO2UfbjER4q4tUCXOw8Y4f65V9Jae3B1xqRtSre6asb
 tqHQRDrIgJnwtVo9hrTpQruobh52IwCG3LHLZrvQ8i+3IjIQyXoBCwMs2ci9S+ZEhFrK
 efAHUYIwWdZ9VGrDMHVstAr8Y5z+3AFKoEvPQbuGUSZ8V9lnBaxprl4+e+8ivOcM4Rst sA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2u527ptk8p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 07 Aug 2019 07:56:12 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x777qf6X126164;
        Wed, 7 Aug 2019 07:56:11 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2u75bw6j0q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 07 Aug 2019 07:56:11 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x777uApC001488;
        Wed, 7 Aug 2019 07:56:11 GMT
Received: from [10.191.27.28] (/10.191.27.28)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 07 Aug 2019 00:56:10 -0700
Subject: Re: [PATCH v2 1/1] ixgbe: sync the first fragment unconditionally
To:     Firo Yang <firo.yang@suse.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Cc:     "alexander.h.duyck@linux.intel.com" 
        <alexander.h.duyck@linux.intel.com>,
        "jeffrey.t.kirsher@intel.com" <jeffrey.t.kirsher@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20190807024917.27682-1-firo.yang@suse.com>
From:   Jacob Wen <jian.w.wen@oracle.com>
Message-ID: <85aaefdf-d454-1823-5840-d9e2f71ffb19@oracle.com>
Date:   Wed, 7 Aug 2019 15:56:07 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190807024917.27682-1-firo.yang@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9341 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908070085
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9341 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908070085
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I think the description is not correct. Consider using something like below.


In Xen environment, due to memory fragmentation ixgbe may allocate a 
'DMA' buffer with pages that are not physically contiguous.

A NIC doesn't support directly write such buffer. So xen-swiotlb would 
use the pages, which are physically contiguous, from the swiotlb buffer 
for the NIC.

The unmap operation is used to copy the swiotlb buffer to the pages that 
are allocated by ixgbe.

On 8/7/19 10:49 AM, Firo Yang wrote:
> In Xen environment, if Xen-swiotlb is enabled, ixgbe driver
> could possibly allocate a page, DMA memory buffer, for the first
> fragment which is not suitable for Xen-swiotlb to do DMA operations.
> Xen-swiotlb have to internally allocate another page for doing DMA
> operations. It requires syncing between those two pages. However,
> since commit f3213d932173 ("ixgbe: Update driver to make use of DMA
> attributes in Rx path"), the unmap operation is performed with
> DMA_ATTR_SKIP_CPU_SYNC. As a result, the sync is not performed.
>
> To fix this problem, always sync before possibly performing a page
> unmap operation.
>
> Fixes: f3213d932173 ("ixgbe: Update driver to make use of DMA
> attributes in Rx path")
> Reviewed-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> Signed-off-by: Firo Yang <firo.yang@suse.com>
> ---
>
> Changes from v1:
>   * Imporved the patch description.
>   * Added Reviewed-by: and Fixes: as suggested by Alexander Duyck
>
>   drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 16 +++++++++-------
>   1 file changed, 9 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> index cbaf712d6529..200de9838096 100644
> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> @@ -1825,13 +1825,7 @@ static void ixgbe_pull_tail(struct ixgbe_ring *rx_ring,
>   static void ixgbe_dma_sync_frag(struct ixgbe_ring *rx_ring,
>   				struct sk_buff *skb)
>   {
> -	/* if the page was released unmap it, else just sync our portion */
> -	if (unlikely(IXGBE_CB(skb)->page_released)) {
> -		dma_unmap_page_attrs(rx_ring->dev, IXGBE_CB(skb)->dma,
> -				     ixgbe_rx_pg_size(rx_ring),
> -				     DMA_FROM_DEVICE,
> -				     IXGBE_RX_DMA_ATTR);
> -	} else if (ring_uses_build_skb(rx_ring)) {
> +	if (ring_uses_build_skb(rx_ring)) {
>   		unsigned long offset = (unsigned long)(skb->data) & ~PAGE_MASK;
>   
>   		dma_sync_single_range_for_cpu(rx_ring->dev,
> @@ -1848,6 +1842,14 @@ static void ixgbe_dma_sync_frag(struct ixgbe_ring *rx_ring,
>   					      skb_frag_size(frag),
>   					      DMA_FROM_DEVICE);
>   	}
> +
> +	/* If the page was released, just unmap it. */
> +	if (unlikely(IXGBE_CB(skb)->page_released)) {
> +		dma_unmap_page_attrs(rx_ring->dev, IXGBE_CB(skb)->dma,
> +				     ixgbe_rx_pg_size(rx_ring),
> +				     DMA_FROM_DEVICE,
> +				     IXGBE_RX_DMA_ATTR);
> +	}
>   }
>   
>   /**
