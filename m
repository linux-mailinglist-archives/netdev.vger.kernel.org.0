Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F6734ED818
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 13:00:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234124AbiCaLCK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 07:02:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231893AbiCaLCI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 07:02:08 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 734A81F0CB1
        for <netdev@vger.kernel.org>; Thu, 31 Mar 2022 04:00:19 -0700 (PDT)
Received: from dggpemm500020.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4KTgLQ6Krtz1GDKZ;
        Thu, 31 Mar 2022 18:59:58 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggpemm500020.china.huawei.com (7.185.36.49) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 31 Mar 2022 19:00:17 +0800
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2308.21; Thu, 31 Mar
 2022 19:00:17 +0800
Subject: Re: [PATCH net v3] skbuff: fix coalescing for page_pool fragment
 recycling
To:     Jean-Philippe Brucker <jean-philippe@linaro.org>,
        <ilias.apalodimas@linaro.org>, <alexanderduyck@fb.com>
CC:     <hawk@kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>
References: <20220331102440.1673-1-jean-philippe@linaro.org>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <88cc93a8-ea3d-2e92-98de-8f44ea1e49f8@huawei.com>
Date:   Thu, 31 Mar 2022 19:00:17 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <20220331102440.1673-1-jean-philippe@linaro.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggeme706-chm.china.huawei.com (10.1.199.102) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022/3/31 18:24, Jean-Philippe Brucker wrote:
> Fix a use-after-free when using page_pool with page fragments. We
> encountered this problem during normal RX in the hns3 driver:
> 
> (1) Initially we have three descriptors in the RX queue. The first one
>     allocates PAGE1 through page_pool, and the other two allocate one
>     half of PAGE2 each. Page references look like this:
> 
>                 RX_BD1 _______ PAGE1
>                 RX_BD2 _______ PAGE2
>                 RX_BD3 _________/
> 
> (2) Handle RX on the first descriptor. Allocate SKB1, eventually added
>     to the receive queue by tcp_queue_rcv().
> 
> (3) Handle RX on the second descriptor. Allocate SKB2 and pass it to
>     netif_receive_skb():
> 
>     netif_receive_skb(SKB2)
>       ip_rcv(SKB2)
>         SKB3 = skb_clone(SKB2)
> 
>     SKB2 and SKB3 share a reference to PAGE2 through
>     skb_shinfo()->dataref. The other ref to PAGE2 is still held by
>     RX_BD3:
> 
>                       SKB2 ---+- PAGE2
>                       SKB3 __/   /
>                 RX_BD3 _________/
> 
>  (3b) Now while handling TCP, coalesce SKB3 with SKB1:
> 
>       tcp_v4_rcv(SKB3)
>         tcp_try_coalesce(to=SKB1, from=SKB3)    // succeeds
>         kfree_skb_partial(SKB3)
>           skb_release_data(SKB3)                // drops one dataref
> 
>                       SKB1 _____ PAGE1
>                            \____
>                       SKB2 _____ PAGE2
>                                  /
>                 RX_BD3 _________/
> 
>     In skb_try_coalesce(), __skb_frag_ref() takes a page reference to
>     PAGE2, where it should instead have increased the page_pool frag
>     reference, pp_frag_count. Without coalescing, when releasing both
>     SKB2 and SKB3, a single reference to PAGE2 would be dropped. Now
>     when releasing SKB1 and SKB2, two references to PAGE2 will be
>     dropped, resulting in underflow.
> 
>  (3c) Drop SKB2:
> 
>       af_packet_rcv(SKB2)
>         consume_skb(SKB2)
>           skb_release_data(SKB2)                // drops second dataref
>             page_pool_return_skb_page(PAGE2)    // drops one pp_frag_count
> 
>                       SKB1 _____ PAGE1
>                            \____
>                                  PAGE2
>                                  /
>                 RX_BD3 _________/
> 
> (4) Userspace calls recvmsg()
>     Copies SKB1 and releases it. Since SKB3 was coalesced with SKB1, we
>     release the SKB3 page as well:
> 
>     tcp_eat_recv_skb(SKB1)
>       skb_release_data(SKB1)
>         page_pool_return_skb_page(PAGE1)
>         page_pool_return_skb_page(PAGE2)        // drops second pp_frag_count
> 
> (5) PAGE2 is freed, but the third RX descriptor was still using it!
>     In our case this causes IOMMU faults, but it would silently corrupt
>     memory if the IOMMU was disabled.
> 
> Change the logic that checks whether pp_recycle SKBs can be coalesced.
> We still reject differing pp_recycle between 'from' and 'to' SKBs, but
> in order to avoid the situation described above, we also reject
> coalescing when both 'from' and 'to' are pp_recycled and 'from' is
> cloned.
> 
> The new logic allows coalescing a cloned pp_recycle SKB into a page
> refcounted one, because in this case the release (4) will drop the right
> reference, the one taken by skb_try_coalesce().

LGTM.

Reviewed-by: Yunsheng Lin <linyunsheng@huawei.com>

> 
> Fixes: 53e0961da1c7 ("page_pool: add frag page recycling support in page pool")
> Suggested-by: Alexander Duyck <alexanderduyck@fb.com>
> Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
> ---
> v2: https://lore.kernel.org/netdev/20220328132258.78307-1-jean-philippe@linaro.org/
> v1: https://lore.kernel.org/netdev/20220324172913.26293-1-jean-philippe@linaro.org/
> ---
>  net/core/skbuff.c | 15 +++++++++++----
>  1 file changed, 11 insertions(+), 4 deletions(-)
> 
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index ea51e23e9247..2d6ef6d7ebf5 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -5244,11 +5244,18 @@ bool skb_try_coalesce(struct sk_buff *to, struct sk_buff *from,
>  	if (skb_cloned(to))
>  		return false;
>  
> -	/* The page pool signature of struct page will eventually figure out
> -	 * which pages can be recycled or not but for now let's prohibit slab
> -	 * allocated and page_pool allocated SKBs from being coalesced.
> +	/* In general, avoid mixing slab allocated and page_pool allocated
> +	 * pages within the same SKB. However when @to is not pp_recycle and
> +	 * @from is cloned, we can transition frag pages from page_pool to
> +	 * reference counted.
> +	 *
> +	 * On the other hand, don't allow coalescing two pp_recycle SKBs if
> +	 * @from is cloned, in case the SKB is using page_pool fragment
> +	 * references (PP_FLAG_PAGE_FRAG). Since we only take full page
> +	 * references for cloned SKBs at the moment that would result in
> +	 * inconsistent reference counts.
>  	 */
> -	if (to->pp_recycle != from->pp_recycle)
> +	if (to->pp_recycle != (from->pp_recycle && !skb_cloned(from)))
>  		return false;
>  
>  	if (len <= skb_tailroom(to)) {
> 
