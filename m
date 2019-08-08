Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B222F857E0
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 03:58:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730676AbfHHB5a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 21:57:30 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:59974 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730038AbfHHB5a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Aug 2019 21:57:30 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x781rc2L140843;
        Thu, 8 Aug 2019 01:56:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=mime-version :
 message-id : date : from : to : cc : subject : references : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=nxHPjhBSdBDeh86IhhICSfev/ouC2k6huYkxfQs4BLo=;
 b=GvG34bFI9XzVNJDT0ICkv33AVz3IV2DhorAAdpOR+i73G0+WAcY8NTRzcCeEu+3q3AHc
 OiG3lWFtQpI7SfqL4HUq4RpHO3ysYfEA0JN9o5+xoYwmCGMpFahqT69eIBRy8cercMPX
 t+9RLn1gMuv+zxC4El28nYlnIFliUyuTNHicnjvHRsMNJO8JddEEixMoRJq+3lIWifh5
 PDwCB4znt2tOdZ+lN66PlkzxwbLe64COYZDKFI0AMvJaoyRINYt7EKVaJiuibkf2wPkI
 cT7vuJC8ySSUPfAR7Zpd4qZbhurkSnKvPs7dwLI976LEM6zINbcNt+1L8EQMZyor8py6 CQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2u527pyhcj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Aug 2019 01:56:17 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x781r9Eo154011;
        Thu, 8 Aug 2019 01:56:17 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2u7668a62h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Aug 2019 01:56:16 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x781uEDR005349;
        Thu, 8 Aug 2019 01:56:14 GMT
Received: from [10.191.2.135] (/10.191.2.135) by default (Oracle Beehive
 Gateway v4.0) with ESMTP ; Wed, 07 Aug 2019 18:56:04 -0700
USER-AGENT: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Content-Language: en-US
MIME-Version: 1.0
Message-ID: <901704f1-163d-9dd8-4d20-93fa19f4435d@oracle.com>
Date:   Wed, 7 Aug 2019 18:56:00 -0700 (PDT)
From:   Jacob Wen <jian.w.wen@oracle.com>
To:     Firo Yang <firo.yang@suse.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "jeffrey.t.kirsher@intel.com" <jeffrey.t.kirsher@intel.com>,
        "alexander.h.duyck@linux.intel.com" 
        <alexander.h.duyck@linux.intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v2 1/1] ixgbe: sync the first fragment unconditionally
References: <20190807024917.27682-1-firo.yang@suse.com>
 <85aaefdf-d454-1823-5840-d9e2f71ffb19@oracle.com>
 <20190807083831.GA6811@linux-6qg8>
In-Reply-To: <20190807083831.GA6811@linux-6qg8>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9342 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908080017
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9342 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908080017
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 8/7/19 4:38 PM, Firo Yang wrote:
> The 08/07/2019 15:56, Jacob Wen wrote:
>> I think the description is not correct. Consider using something like below.
> Thank you for comments.
>
>> In Xen environment, due to memory fragmentation ixgbe may allocate a 'DMA'
>> buffer with pages that are not physically contiguous.
> Actually, I didn't look into the reason why ixgbe got a DMA buffer which
> was mapped to Xen-swiotlb area.
Yes. I was wrong. You don't need to tell the exact reason.
>
> But I don't think this issue relates to phsical memory contiguity because, in
> our case, one ixgbe_rx_buffer only associates at most one page.

This is interesting.

I guess the performance of the NIC in your environment is not good due 
to the extra cost of bounce buffer.

>
> If you take a look at the related code, you will find there are several reasons
> for mapping a DMA buffer to Xen-swiotlb area:
> static dma_addr_t xen_swiotlb_map_page(struct device *dev, struct page *page,
>           */
>          if (dma_capable(dev, dev_addr, size) &&
>              !range_straddles_page_boundary(phys, size) &&
>                  !xen_arch_need_swiotlb(dev, phys, dev_addr) &&
>                  swiotlb_force != SWIOTLB_FORCE)
>                  goto done;
>
> // Firo
>> A NIC doesn't support directly write such buffer. So xen-swiotlb would use
>> the pages, which are physically contiguous, from the swiotlb buffer for the
>> NIC.
>>
>> The unmap operation is used to copy the swiotlb buffer to the pages that are
>> allocated by ixgbe.
>>
>> On 8/7/19 10:49 AM, Firo Yang wrote:
>>> In Xen environment, if Xen-swiotlb is enabled, ixgbe driver
>>> could possibly allocate a page, DMA memory buffer, for the first
>>> fragment which is not suitable for Xen-swiotlb to do DMA operations.
>>> Xen-swiotlb have to internally allocate another page for doing DMA
>>> operations. It requires syncing between those two pages. However,
>>> since commit f3213d932173 ("ixgbe: Update driver to make use of DMA
>>> attributes in Rx path"), the unmap operation is performed with
>>> DMA_ATTR_SKIP_CPU_SYNC. As a result, the sync is not performed.
>>>
>>> To fix this problem, always sync before possibly performing a page
>>> unmap operation.
>>>
>>> Fixes: f3213d932173 ("ixgbe: Update driver to make use of DMA
>>> attributes in Rx path")
>>> Reviewed-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
>>> Signed-off-by: Firo Yang <firo.yang@suse.com>
>>> ---
>>>
>>> Changes from v1:
>>>    * Imporved the patch description.
>>>    * Added Reviewed-by: and Fixes: as suggested by Alexander Duyck
>>>
>>>    drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 16 +++++++++-------
>>>    1 file changed, 9 insertions(+), 7 deletions(-)
>>>
>>> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
>>> index cbaf712d6529..200de9838096 100644
>>> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
>>> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
>>> @@ -1825,13 +1825,7 @@ static void ixgbe_pull_tail(struct ixgbe_ring *rx_ring,
>>>    static void ixgbe_dma_sync_frag(struct ixgbe_ring *rx_ring,
>>>    				struct sk_buff *skb)
>>>    {
>>> -	/* if the page was released unmap it, else just sync our portion */
>>> -	if (unlikely(IXGBE_CB(skb)->page_released)) {
>>> -		dma_unmap_page_attrs(rx_ring->dev, IXGBE_CB(skb)->dma,
>>> -				     ixgbe_rx_pg_size(rx_ring),
>>> -				     DMA_FROM_DEVICE,
>>> -				     IXGBE_RX_DMA_ATTR);
>>> -	} else if (ring_uses_build_skb(rx_ring)) {
>>> +	if (ring_uses_build_skb(rx_ring)) {
>>>    		unsigned long offset = (unsigned long)(skb->data) & ~PAGE_MASK;
>>>    		dma_sync_single_range_for_cpu(rx_ring->dev,
>>> @@ -1848,6 +1842,14 @@ static void ixgbe_dma_sync_frag(struct ixgbe_ring *rx_ring,
>>>    					      skb_frag_size(frag),
>>>    					      DMA_FROM_DEVICE);
>>>    	}
>>> +
>>> +	/* If the page was released, just unmap it. */
>>> +	if (unlikely(IXGBE_CB(skb)->page_released)) {
>>> +		dma_unmap_page_attrs(rx_ring->dev, IXGBE_CB(skb)->dma,
>>> +				     ixgbe_rx_pg_size(rx_ring),
>>> +				     DMA_FROM_DEVICE,
>>> +				     IXGBE_RX_DMA_ATTR);
>>> +	}
>>>    }
>>>    /**
