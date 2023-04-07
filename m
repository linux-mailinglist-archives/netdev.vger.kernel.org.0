Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDDA96DAAB7
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 11:15:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231700AbjDGJPV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 05:15:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230265AbjDGJPU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 05:15:20 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 816897683
        for <netdev@vger.kernel.org>; Fri,  7 Apr 2023 02:15:18 -0700 (PDT)
Received: from dggpemm500005.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4PtCM14twvzKx3h;
        Fri,  7 Apr 2023 17:12:45 +0800 (CST)
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Fri, 7 Apr
 2023 17:15:16 +0800
Subject: Re: [RFC net-next v2 1/3] net: skb: plumb napi state thru skb freeing
 paths
To:     Jakub Kicinski <kuba@kernel.org>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <edumazet@google.com>,
        <pabeni@redhat.com>, <hawk@kernel.org>,
        <ilias.apalodimas@linaro.org>
References: <20230405232100.103392-1-kuba@kernel.org>
 <20230405232100.103392-2-kuba@kernel.org>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <2628d71f-ef66-6ea9-61da-6d01c04fbda9@huawei.com>
Date:   Fri, 7 Apr 2023 17:15:15 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <20230405232100.103392-2-kuba@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.3 required=5.0 tests=NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2023/4/6 7:20, Jakub Kicinski wrote:
> We maintain a NAPI-local cache of skbs which is fed by napi_consume_skb().
> Going forward we will also try to cache head and data pages.
> Plumb the "are we in a normal NAPI context" information thru
> deeper into the freeing path, up to skb_release_data() and
> skb_free_head()/skb_pp_recycle().
> 
> Use "bool in_normal_napi" rather than bare "int budget",
> the further we get from NAPI the more confusing the budget
> argument may seem (particularly whether 0 or MAX is the
> correct value to pass in when not in NAPI).
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  net/core/skbuff.c | 38 ++++++++++++++++++++------------------
>  1 file changed, 20 insertions(+), 18 deletions(-)
> 
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index 050a875d09c5..8d5377b4112f 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -839,7 +839,7 @@ static void skb_clone_fraglist(struct sk_buff *skb)
>  		skb_get(list);
>  }
>  
> -static bool skb_pp_recycle(struct sk_buff *skb, void *data)
> +static bool skb_pp_recycle(struct sk_buff *skb, void *data, bool in_normal_napi)

What does *normal* means in 'in_normal_napi'?
can we just use in_napi?

>  {
>  	if (!IS_ENABLED(CONFIG_PAGE_POOL) || !skb->pp_recycle)
>  		return false;
> @@ -856,12 +856,12 @@ static void skb_kfree_head(void *head, unsigned int end_offset)
>  		kfree(head);
>  }
>  
> -static void skb_free_head(struct sk_buff *skb)
> +static void skb_free_head(struct sk_buff *skb, bool in_normal_napi)
>  {
>  	unsigned char *head = skb->head;
>  
>  	if (skb->head_frag) {
> -		if (skb_pp_recycle(skb, head))
> +		if (skb_pp_recycle(skb, head, in_normal_napi))
>  			return;
>  		skb_free_frag(head);
>  	} else {
> @@ -869,7 +869,8 @@ static void skb_free_head(struct sk_buff *skb)
>  	}
>  }
>  
> -static void skb_release_data(struct sk_buff *skb, enum skb_drop_reason reason)
> +static void skb_release_data(struct sk_buff *skb, enum skb_drop_reason reason,
> +			     bool in_normal_napi)
>  {
>  	struct skb_shared_info *shinfo = skb_shinfo(skb);
>  	int i;
> @@ -894,7 +895,7 @@ static void skb_release_data(struct sk_buff *skb, enum skb_drop_reason reason)
>  	if (shinfo->frag_list)
>  		kfree_skb_list_reason(shinfo->frag_list, reason);
>  
> -	skb_free_head(skb);
> +	skb_free_head(skb, in_normal_napi);
>  exit:
>  	/* When we clone an SKB we copy the reycling bit. The pp_recycle
>  	 * bit is only set on the head though, so in order to avoid races
> @@ -955,11 +956,12 @@ void skb_release_head_state(struct sk_buff *skb)
>  }
>  
>  /* Free everything but the sk_buff shell. */
> -static void skb_release_all(struct sk_buff *skb, enum skb_drop_reason reason)
> +static void skb_release_all(struct sk_buff *skb, enum skb_drop_reason reason,
> +			    bool in_normal_napi)
>  {
>  	skb_release_head_state(skb);
>  	if (likely(skb->head))
> -		skb_release_data(skb, reason);
> +		skb_release_data(skb, reason, in_normal_napi);
>  }
>  
>  /**
> @@ -973,7 +975,7 @@ static void skb_release_all(struct sk_buff *skb, enum skb_drop_reason reason)
>  
>  void __kfree_skb(struct sk_buff *skb)
>  {
> -	skb_release_all(skb, SKB_DROP_REASON_NOT_SPECIFIED);
> +	skb_release_all(skb, SKB_DROP_REASON_NOT_SPECIFIED, false);
>  	kfree_skbmem(skb);
>  }
>  EXPORT_SYMBOL(__kfree_skb);
> @@ -1027,7 +1029,7 @@ static void kfree_skb_add_bulk(struct sk_buff *skb,
>  		return;
>  	}
>  
> -	skb_release_all(skb, reason);
> +	skb_release_all(skb, reason, false);
>  	sa->skb_array[sa->skb_count++] = skb;
>  
>  	if (unlikely(sa->skb_count == KFREE_SKB_BULK_SIZE)) {
> @@ -1201,7 +1203,7 @@ EXPORT_SYMBOL(consume_skb);
>  void __consume_stateless_skb(struct sk_buff *skb)
>  {
>  	trace_consume_skb(skb, __builtin_return_address(0));
> -	skb_release_data(skb, SKB_CONSUMED);
> +	skb_release_data(skb, SKB_CONSUMED, false);
>  	kfree_skbmem(skb);
>  }
>  
> @@ -1226,7 +1228,7 @@ static void napi_skb_cache_put(struct sk_buff *skb)
>  
>  void __kfree_skb_defer(struct sk_buff *skb)
>  {
> -	skb_release_all(skb, SKB_DROP_REASON_NOT_SPECIFIED);
> +	skb_release_all(skb, SKB_DROP_REASON_NOT_SPECIFIED, false);
>  	napi_skb_cache_put(skb);

Is there any reson not to call skb_release_all() with in_normal_napi
being true while napi_skb_cache_put() is called here?

>  }
>  
> @@ -1264,7 +1266,7 @@ void napi_consume_skb(struct sk_buff *skb, int budget)
>  		return;
>  	}
>  
> -	skb_release_all(skb, SKB_CONSUMED);
> +	skb_release_all(skb, SKB_CONSUMED, !!budget);
>  	napi_skb_cache_put(skb);
>  }
>  EXPORT_SYMBOL(napi_consume_skb);
> @@ -1395,7 +1397,7 @@ EXPORT_SYMBOL_GPL(alloc_skb_for_msg);
>   */
>  struct sk_buff *skb_morph(struct sk_buff *dst, struct sk_buff *src)
>  {
> -	skb_release_all(dst, SKB_CONSUMED);
> +	skb_release_all(dst, SKB_CONSUMED, false);
>  	return __skb_clone(dst, src);
>  }
>  EXPORT_SYMBOL_GPL(skb_morph);
> @@ -2018,9 +2020,9 @@ int pskb_expand_head(struct sk_buff *skb, int nhead, int ntail,
>  		if (skb_has_frag_list(skb))
>  			skb_clone_fraglist(skb);
>  
> -		skb_release_data(skb, SKB_CONSUMED);
> +		skb_release_data(skb, SKB_CONSUMED, false);
>  	} else {
> -		skb_free_head(skb);
> +		skb_free_head(skb, false);
>  	}
>  	off = (data + nhead) - skb->head;
>  
> @@ -6389,12 +6391,12 @@ static int pskb_carve_inside_header(struct sk_buff *skb, const u32 off,
>  			skb_frag_ref(skb, i);
>  		if (skb_has_frag_list(skb))
>  			skb_clone_fraglist(skb);
> -		skb_release_data(skb, SKB_CONSUMED);
> +		skb_release_data(skb, SKB_CONSUMED, false);
>  	} else {
>  		/* we can reuse existing recount- all we did was
>  		 * relocate values
>  		 */
> -		skb_free_head(skb);
> +		skb_free_head(skb, false);
>  	}
>  
>  	skb->head = data;
> @@ -6529,7 +6531,7 @@ static int pskb_carve_inside_nonlinear(struct sk_buff *skb, const u32 off,
>  		skb_kfree_head(data, size);
>  		return -ENOMEM;
>  	}
> -	skb_release_data(skb, SKB_CONSUMED);
> +	skb_release_data(skb, SKB_CONSUMED, false);
>  
>  	skb->head = data;
>  	skb->head_frag = 0;
> 
