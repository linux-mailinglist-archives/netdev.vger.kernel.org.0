Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8361F6DF071
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 11:31:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230458AbjDLJbK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 05:31:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230520AbjDLJbB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 05:31:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63F1B83E2
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 02:30:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681291752;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sHblUz2050AOrZobAfpGmZMZCppVeUNsFDQpop6hdwM=;
        b=ikmt63Xr+ZyDNQMdkGxg7NKcmYBS1XdYuQoe0NRdyZnWE6PLxSdW9w3W9oq/R2zq4kJxFE
        dvZzrzUi+uSXMiVH5AcQsJYkBHe9O3qs/zuDAG4X3DHiNpj+yMxfyJGsSSaZRvn7U48IZ+
        icM0dvti1xxB/3QPJqyQ0ZDjGG3fTfI=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-224-vIcgpxDFPQ-1UpNzwzLIug-1; Wed, 12 Apr 2023 05:29:11 -0400
X-MC-Unique: vIcgpxDFPQ-1UpNzwzLIug-1
Received: by mail-ej1-f70.google.com with SMTP id fj20-20020a1709069c9400b00933ae6694e9so3812238ejc.7
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 02:29:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681291750; x=1683883750;
        h=content-transfer-encoding:in-reply-to:references:to
         :content-language:subject:cc:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sHblUz2050AOrZobAfpGmZMZCppVeUNsFDQpop6hdwM=;
        b=Wmw84GNMJFui23ZQOBI1q4A4pyjypIoXj/qBpeqvJm9oqdqiBrQM4q3ECzVfej6dpu
         huoYMC0J5FtDEuN+fzc+bpaTCYMw1xD41khArkBwbc5BNkzVY3CUX9p7U5CIA5QxXz1s
         b3U49hQVTeOfr6QrGJsdirwj9DWEWLShEDvjJp17LDfYO1qo0aP4rcEwgHxBPQxrxRou
         hHA8XCm3R6XgppZus5udjpTkbu/CgmkSXnmgTLXgLTAdO1Ch2ZG01FjS8WBmsMmcr1Rh
         iRI3kQyXcYEYCsstQadZwje5YjJgRAkKve78mF+DjrgCTxrsNFvESE3+MGY35i0LGIOj
         4tug==
X-Gm-Message-State: AAQBX9e5uXcEIXcebPRwi1/212uIojbhsLlzT+wnmFWgulSSbNi7+udm
        LuE/vV+kpwjuYmBSC2pC2Y8B7EXftLhHu+6m1stUnNErJTbQlNz/BFASW3mKUxiW6GEwN66rshF
        bnABs9MBLzgN/1hrA
X-Received: by 2002:a17:906:388c:b0:947:4828:4399 with SMTP id q12-20020a170906388c00b0094748284399mr12869335ejd.12.1681291750454;
        Wed, 12 Apr 2023 02:29:10 -0700 (PDT)
X-Google-Smtp-Source: AKy350at316mHbsEFBZS9TZcLUuByxbrI0ttwr2zpkGcdTAtEmydWKnUxUnfBQadjvYcqLc6Ixn6FA==
X-Received: by 2002:a17:906:388c:b0:947:4828:4399 with SMTP id q12-20020a170906388c00b0094748284399mr12869319ejd.12.1681291750130;
        Wed, 12 Apr 2023 02:29:10 -0700 (PDT)
Received: from [192.168.42.222] (194-45-78-10.static.kviknet.net. [194.45.78.10])
        by smtp.gmail.com with ESMTPSA id k6-20020a508ac6000000b004fbf6b35a56sm6747475edk.76.2023.04.12.02.29.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Apr 2023 02:29:09 -0700 (PDT)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <9ecc38df-a185-fc1f-e94e-cf0c1fef865f@redhat.com>
Date:   Wed, 12 Apr 2023 11:29:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Cc:     brouer@redhat.com, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, hawk@kernel.org, ilias.apalodimas@linaro.org,
        linyunsheng@huawei.com, Alexander Duyck <alexander.duyck@gmail.com>
Subject: Re: [PATCH net-next 1/3] net: skb: plumb napi state thru skb freeing
 paths
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
References: <20230411201800.596103-1-kuba@kernel.org>
 <20230411201800.596103-2-kuba@kernel.org>
In-Reply-To: <20230411201800.596103-2-kuba@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 11/04/2023 22.17, Jakub Kicinski wrote:
> We maintain a NAPI-local cache of skbs which is fed by napi_consume_skb().
> Going forward we will also try to cache head and data pages.
> Plumb the "are we in a normal NAPI context" information thru
> deeper into the freeing path, up to skb_release_data() and
> skb_free_head()/skb_pp_recycle().
> 
> Use "bool in_normal_napi" rather than bare "int budget",

The code was changed to "napi_safe", the desc should reflect this ;-)

> the further we get from NAPI the more confusing the budget
> argument may seem (particularly whether 0 or MAX is the
> correct value to pass in when not in NAPI).

I do like the code cleanup.
It is worth explaining/mentioning that where budget==0 comes from?

(Cc. Alex, please correct me.)
My understanding is that this is caused by netconsole/netpoll (see
net/core/netpoll.c func poll_one_napi()), which is a kernel (net)console
debugging facility sending UDP packets via using only TX side of
napi_poll.  Thus, we are really trying to protect against doing these
recycle tricks for when netpoll/netconcole is running (which I guess
makes sense as we are likely printing/sending an OOPS msg over UDP).


> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> v1:
>   - feed the cache in __kfree_skb_defer(), it's in NAPI
>   - s/in_normal_napi/napi_safe/
> ---
>   net/core/skbuff.c | 38 ++++++++++++++++++++------------------
>   1 file changed, 20 insertions(+), 18 deletions(-)
> 

(no more comments below, but didn't cut code for Alex to see)

> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index 050a875d09c5..b2092166f7e2 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -839,7 +839,7 @@ static void skb_clone_fraglist(struct sk_buff *skb)
>   		skb_get(list);
>   }
>   
> -static bool skb_pp_recycle(struct sk_buff *skb, void *data)
> +static bool skb_pp_recycle(struct sk_buff *skb, void *data, bool napi_safe)
>   {
>   	if (!IS_ENABLED(CONFIG_PAGE_POOL) || !skb->pp_recycle)
>   		return false;
> @@ -856,12 +856,12 @@ static void skb_kfree_head(void *head, unsigned int end_offset)
>   		kfree(head);
>   }
>   
> -static void skb_free_head(struct sk_buff *skb)
> +static void skb_free_head(struct sk_buff *skb, bool napi_safe)
>   {
>   	unsigned char *head = skb->head;
>   
>   	if (skb->head_frag) {
> -		if (skb_pp_recycle(skb, head))
> +		if (skb_pp_recycle(skb, head, napi_safe))
>   			return;
>   		skb_free_frag(head);
>   	} else {
> @@ -869,7 +869,8 @@ static void skb_free_head(struct sk_buff *skb)
>   	}
>   }
>   
> -static void skb_release_data(struct sk_buff *skb, enum skb_drop_reason reason)
> +static void skb_release_data(struct sk_buff *skb, enum skb_drop_reason reason,
> +			     bool napi_safe)
>   {
>   	struct skb_shared_info *shinfo = skb_shinfo(skb);
>   	int i;
> @@ -894,7 +895,7 @@ static void skb_release_data(struct sk_buff *skb, enum skb_drop_reason reason)
>   	if (shinfo->frag_list)
>   		kfree_skb_list_reason(shinfo->frag_list, reason);
>   
> -	skb_free_head(skb);
> +	skb_free_head(skb, napi_safe);
>   exit:
>   	/* When we clone an SKB we copy the reycling bit. The pp_recycle
>   	 * bit is only set on the head though, so in order to avoid races
> @@ -955,11 +956,12 @@ void skb_release_head_state(struct sk_buff *skb)
>   }
>   
>   /* Free everything but the sk_buff shell. */
> -static void skb_release_all(struct sk_buff *skb, enum skb_drop_reason reason)
> +static void skb_release_all(struct sk_buff *skb, enum skb_drop_reason reason,
> +			    bool napi_safe)
>   {
>   	skb_release_head_state(skb);
>   	if (likely(skb->head))
> -		skb_release_data(skb, reason);
> +		skb_release_data(skb, reason, napi_safe);
>   }
>   
>   /**
> @@ -973,7 +975,7 @@ static void skb_release_all(struct sk_buff *skb, enum skb_drop_reason reason)
>   
>   void __kfree_skb(struct sk_buff *skb)
>   {
> -	skb_release_all(skb, SKB_DROP_REASON_NOT_SPECIFIED);
> +	skb_release_all(skb, SKB_DROP_REASON_NOT_SPECIFIED, false);
>   	kfree_skbmem(skb);
>   }
>   EXPORT_SYMBOL(__kfree_skb);
> @@ -1027,7 +1029,7 @@ static void kfree_skb_add_bulk(struct sk_buff *skb,
>   		return;
>   	}
>   
> -	skb_release_all(skb, reason);
> +	skb_release_all(skb, reason, false);
>   	sa->skb_array[sa->skb_count++] = skb;
>   
>   	if (unlikely(sa->skb_count == KFREE_SKB_BULK_SIZE)) {
> @@ -1201,7 +1203,7 @@ EXPORT_SYMBOL(consume_skb);
>   void __consume_stateless_skb(struct sk_buff *skb)
>   {
>   	trace_consume_skb(skb, __builtin_return_address(0));
> -	skb_release_data(skb, SKB_CONSUMED);
> +	skb_release_data(skb, SKB_CONSUMED, false);
>   	kfree_skbmem(skb);
>   }
>   
> @@ -1226,7 +1228,7 @@ static void napi_skb_cache_put(struct sk_buff *skb)
>   
>   void __kfree_skb_defer(struct sk_buff *skb)
>   {
> -	skb_release_all(skb, SKB_DROP_REASON_NOT_SPECIFIED);
> +	skb_release_all(skb, SKB_DROP_REASON_NOT_SPECIFIED, true);
>   	napi_skb_cache_put(skb);
>   }
>   
> @@ -1264,7 +1266,7 @@ void napi_consume_skb(struct sk_buff *skb, int budget)
>   		return;
>   	}
>   
> -	skb_release_all(skb, SKB_CONSUMED);
> +	skb_release_all(skb, SKB_CONSUMED, !!budget);
>   	napi_skb_cache_put(skb);
>   }
>   EXPORT_SYMBOL(napi_consume_skb);
> @@ -1395,7 +1397,7 @@ EXPORT_SYMBOL_GPL(alloc_skb_for_msg);
>    */
>   struct sk_buff *skb_morph(struct sk_buff *dst, struct sk_buff *src)
>   {
> -	skb_release_all(dst, SKB_CONSUMED);
> +	skb_release_all(dst, SKB_CONSUMED, false);
>   	return __skb_clone(dst, src);
>   }
>   EXPORT_SYMBOL_GPL(skb_morph);
> @@ -2018,9 +2020,9 @@ int pskb_expand_head(struct sk_buff *skb, int nhead, int ntail,
>   		if (skb_has_frag_list(skb))
>   			skb_clone_fraglist(skb);
>   
> -		skb_release_data(skb, SKB_CONSUMED);
> +		skb_release_data(skb, SKB_CONSUMED, false);
>   	} else {
> -		skb_free_head(skb);
> +		skb_free_head(skb, false);
>   	}
>   	off = (data + nhead) - skb->head;
>   
> @@ -6389,12 +6391,12 @@ static int pskb_carve_inside_header(struct sk_buff *skb, const u32 off,
>   			skb_frag_ref(skb, i);
>   		if (skb_has_frag_list(skb))
>   			skb_clone_fraglist(skb);
> -		skb_release_data(skb, SKB_CONSUMED);
> +		skb_release_data(skb, SKB_CONSUMED, false);
>   	} else {
>   		/* we can reuse existing recount- all we did was
>   		 * relocate values
>   		 */
> -		skb_free_head(skb);
> +		skb_free_head(skb, false);
>   	}
>   
>   	skb->head = data;
> @@ -6529,7 +6531,7 @@ static int pskb_carve_inside_nonlinear(struct sk_buff *skb, const u32 off,
>   		skb_kfree_head(data, size);
>   		return -ENOMEM;
>   	}
> -	skb_release_data(skb, SKB_CONSUMED);
> +	skb_release_data(skb, SKB_CONSUMED, false);
>   
>   	skb->head = data;
>   	skb->head_frag = 0;

