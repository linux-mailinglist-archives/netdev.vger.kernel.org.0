Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AED4067F40F
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 03:37:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231825AbjA1Chy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 21:37:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229716AbjA1Chw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 21:37:52 -0500
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAB8F199C3;
        Fri, 27 Jan 2023 18:37:50 -0800 (PST)
Received: from dggpemm500005.china.huawei.com (unknown [172.30.72.55])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4P3dm33Kk2zJqCq;
        Sat, 28 Jan 2023 10:33:23 +0800 (CST)
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Sat, 28 Jan
 2023 10:37:48 +0800
Subject: Re: [net PATCH] skb: Do mix page pool and page referenced frags in
 GRO
To:     Alexander Duyck <alexander.duyck@gmail.com>, <nbd@nbd.name>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <hawk@kernel.org>,
        <ilias.apalodimas@linaro.org>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <lorenzo@kernel.org>,
        <netdev@vger.kernel.org>, <pabeni@redhat.com>
References: <04e27096-9ace-07eb-aa51-1663714a586d@nbd.name>
 <167475990764.1934330.11960904198087757911.stgit@localhost.localdomain>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <cde24ed8-1852-ce93-69f3-ff378731f52c@huawei.com>
Date:   Sat, 28 Jan 2023 10:37:47 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <167475990764.1934330.11960904198087757911.stgit@localhost.localdomain>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2023/1/27 3:06, Alexander Duyck wrote:
> From: Alexander Duyck <alexanderduyck@fb.com>
> 
> GSO should not merge page pool recycled frames with standard reference
> counted frames. Traditionally this didn't occur, at least not often.
> However as we start looking at adding support for wireless adapters there
> becomes the potential to mix the two due to A-MSDU repartitioning frames in
> the receive path. There are possibly other places where this may have
> occurred however I suspect they must be few and far between as we have not
> seen this issue until now.
> 
> Fixes: 53e0961da1c7 ("page_pool: add frag page recycling support in page pool")
> Reported-by: Felix Fietkau <nbd@nbd.name>
> Signed-off-by: Alexander Duyck <alexanderduyck@fb.com>
> ---
>  net/core/gro.c |    9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/net/core/gro.c b/net/core/gro.c
> index 506f83d715f8..4bac7ea6e025 100644
> --- a/net/core/gro.c
> +++ b/net/core/gro.c
> @@ -162,6 +162,15 @@ int skb_gro_receive(struct sk_buff *p, struct sk_buff *skb)
>  	struct sk_buff *lp;
>  	int segs;
>  
> +	/* Do not splice page pool based packets w/ non-page pool
> +	 * packets. This can result in reference count issues as page
> +	 * pool pages will not decrement the reference count and will
> +	 * instead be immediately returned to the pool or have frag
> +	 * count decremented.
> +	 */
> +	if (p->pp_recycle != skb->pp_recycle)
> +		return -ETOOMANYREFS;

If we are not allowing gro for the above case, setting NAPI_GRO_CB(p)->flush
to 1 in gro_list_prepare() seems to be making more sense so that the above
case has the same handling as skb_has_frag_list() handling?
https://elixir.bootlin.com/linux/v6.2-rc4/source/net/core/gro.c#L503

As it seems to avoid some unnecessary operation according to comment
in tcp4_gro_receive():
https://elixir.bootlin.com/linux/v6.2-rc4/source/net/ipv4/tcp_offload.c#L322


Also if A-MSDU is normal case for wireless adapters and we want the
performance back for the above case, maybe the driver can set
skb->pp_recycle and update the page->pp_frag_count instead of
page refcount if A-MSDU or A-MSDU decap performed by the driver
can track if the page is from page pool. In that case we may turn
the above checking to a WARN_ON() to catch any other corner-case.


> +
>  	/* pairs with WRITE_ONCE() in netif_set_gro_max_size() */
>  	gro_max_size = READ_ONCE(p->dev->gro_max_size);
>  
> 
> 
> .
> 
