Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 319964E6C4A
	for <lists+netdev@lfdr.de>; Fri, 25 Mar 2022 02:59:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348435AbiCYCBL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 22:01:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244624AbiCYCBK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 22:01:10 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3C1353713
        for <netdev@vger.kernel.org>; Thu, 24 Mar 2022 18:59:36 -0700 (PDT)
Received: from dggpemm500022.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4KPlbr3J3FzfZf1;
        Fri, 25 Mar 2022 09:58:00 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggpemm500022.china.huawei.com (7.185.36.162) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Fri, 25 Mar 2022 09:59:34 +0800
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2308.21; Fri, 25 Mar
 2022 09:59:34 +0800
Subject: Re: [PATCH net] skbuff: disable coalescing for page_pool recycling
To:     Jean-Philippe Brucker <jean-philippe@linaro.org>,
        <ilias.apalodimas@linaro.org>, <hawk@kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, Alexander Duyck <alexanderduyck@fb.com>
References: <20220324172913.26293-1-jean-philippe@linaro.org>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <6dca1c23-e72e-7580-31ba-0ef1dfe745ad@huawei.com>
Date:   Fri, 25 Mar 2022 09:59:33 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <20220324172913.26293-1-jean-philippe@linaro.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggeme707-chm.china.huawei.com (10.1.199.103) To
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

+cc Alexander Duyck

On 2022/3/25 1:29, Jean-Philippe Brucker wrote:
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
>     The problem is here: both SKB1 and SKB2 point to PAGE2 but SKB1 does
>     not actually hold a reference to PAGE2.

it seems the SKB1 *does* hold a reference to PAGE2 by calling __skb_frag_ref(),
which increments the page->_refcount instead of incrementing pp_frag_count,
as skb_cloned(SKB3) is true and __skb_frag_ref() does not handle page pool
case:

https://elixir.bootlin.com/linux/v5.17-rc1/source/net/core/skbuff.c#L5308

 Without coalescing, when
>     releasing both SKB2 and SKB3, a single reference to PAGE2 would be
>     dropped. Now when releasing SKB1 and SKB2, two references to PAGE2
>     will be dropped, resulting in underflow.
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
> A proper implementation would probably take another reference from the
> page_pool at step (3b), but that seems too complicated for a fix. Keep
> it simple for now, prevent coalescing for page_pool users.
> 
> Fixes: 53e0961da1c7 ("page_pool: add frag page recycling support in page pool")
> Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
> ---
> 
> The Fixes tag says frag page recycling but I'm not sure, does it not
> also affect full page recycling?  Coalescing is one case, are there
> other places where we move page fragments between skbuffs?  I'm still
> too unfamiliar with this code to figure it out.
> 
> Previously discussed here:
> https://lore.kernel.org/netdev/YfFbDivUPbpWjh%2Fm@myrica/
> ---
>  net/core/skbuff.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index 10bde7c6db44..431f7ce88049 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -5276,11 +5276,11 @@ bool skb_try_coalesce(struct sk_buff *to, struct sk_buff *from,
>  	if (skb_cloned(to))
>  		return false;
>  
> -	/* The page pool signature of struct page will eventually figure out
> -	 * which pages can be recycled or not but for now let's prohibit slab
> -	 * allocated and page_pool allocated SKBs from being coalesced.
> +	/* Prohibit adding page_pool allocated SKBs, because that would require
> +	 * transferring the page fragment reference. For now let's also prohibit
> +	 * slab allocated and page_pool allocated SKBs from being coalesced.
>  	 */
> -	if (to->pp_recycle != from->pp_recycle)
> +	if (to->pp_recycle || from->pp_recycle)
>  		return false;
>  
>  	if (len <= skb_tailroom(to)) {
> 
