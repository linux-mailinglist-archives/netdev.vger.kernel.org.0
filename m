Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FF6B35FFF6
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 04:25:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbhDOCYG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 22:24:06 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:3084 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229646AbhDOCYA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 22:24:00 -0400
Received: from dggeml406-hub.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4FLNMx1xT8zWRqF;
        Thu, 15 Apr 2021 10:19:57 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggeml406-hub.china.huawei.com (10.3.17.50) with Microsoft SMTP Server (TLS)
 id 14.3.498.0; Thu, 15 Apr 2021 10:23:17 +0800
Received: from [127.0.0.1] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2106.2; Thu, 15 Apr
 2021 10:23:18 +0800
Subject: Re: [PATCH net-next] skbuff: revert "skbuff: remove some unnecessary
 operation in skb_segment_list()"
To:     Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>
CC:     Dongseok Yi <dseok.yi@samsung.com>,
        Willem de Bruijn <willemb@google.com>
References: <f092ecf89336221af04310c9feac800e49d4647f.1618397249.git.pabeni@redhat.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <cfb7af92-5a0b-059f-f598-be2c95f5419a@huawei.com>
Date:   Thu, 15 Apr 2021 10:23:17 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <f092ecf89336221af04310c9feac800e49d4647f.1618397249.git.pabeni@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggeme702-chm.china.huawei.com (10.1.199.98) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/4/14 18:48, Paolo Abeni wrote:
> the commit 1ddc3229ad3c ("skbuff: remove some unnecessary operation
> in skb_segment_list()") introduces an issue very similar to the
> one already fixed by commit 53475c5dd856 ("net: fix use-after-free when
> UDP GRO with shared fraglist").
> 
> If the GSO skb goes though skb_clone() and pskb_expand_head() before
> entering skb_segment_list(), the latter  will unshare the frag_list
> skbs and will release the old list. With the reverted commit in place,
> when skb_segment_list() completes, skb->next points to the just
> released list, and later on the kernel will hit UaF.

In that case, is "nskb->next = list_skb" needed before jumpping to
error when __skb_linearize() fails? As there is "nskb->next = list_skb"
before jumpping to error handling when skb_clone() fails.

The inconsistency above is the reason I sent the reverted patch:)

> 
> Note that since commit e0e3070a9bc9 ("udp: properly complete L4 GRO
> over UDP tunnel packet") the critical scenario can be reproduced also
> receiving UDP over vxlan traffic with:
> 
> NIC (NETIF_F_GRO_FRAGLIST enabled) -> vxlan -> UDP sink
> 
> Attaching a packet socket to the NIC will cause skb_clone() and the
> tunnel decapsulation will call pskb_expand_head().
> 
> Fixes: 1ddc3229ad3c ("skbuff: remove some unnecessary operation in skb_segment_list()")
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> ---
>  net/core/skbuff.c | 15 ++++++++++++---
>  1 file changed, 12 insertions(+), 3 deletions(-)
> 
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index 3ad9e8425ab2..14010c0eec48 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -3773,13 +3773,13 @@ struct sk_buff *skb_segment_list(struct sk_buff *skb,
>  	unsigned int tnl_hlen = skb_tnl_header_len(skb);
>  	unsigned int delta_truesize = 0;
>  	unsigned int delta_len = 0;
> +	struct sk_buff *tail = NULL;
>  	struct sk_buff *nskb, *tmp;
>  	int err;
>  
>  	skb_push(skb, -skb_network_offset(skb) + offset);
>  
>  	skb_shinfo(skb)->frag_list = NULL;
> -	skb->next = list_skb;
>  
>  	do {
>  		nskb = list_skb;
> @@ -3797,8 +3797,17 @@ struct sk_buff *skb_segment_list(struct sk_buff *skb,
>  			}
>  		}
>  
> -		if (unlikely(err))
> +		if (!tail)
> +			skb->next = nskb;
> +		else
> +			tail->next = nskb;
> +
> +		if (unlikely(err)) {
> +			nskb->next = list_skb;
>  			goto err_linearize;
> +		}
> +
> +		tail = nskb;
>  
>  		delta_len += nskb->len;
>  		delta_truesize += nskb->truesize;
> @@ -3825,7 +3834,7 @@ struct sk_buff *skb_segment_list(struct sk_buff *skb,
>  
>  	skb_gso_reset(skb);
>  
> -	skb->prev = nskb;
> +	skb->prev = tail;
>  
>  	if (skb_needs_linearize(skb, features) &&
>  	    __skb_linearize(skb))
> 

