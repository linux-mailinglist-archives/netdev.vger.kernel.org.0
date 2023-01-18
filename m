Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D79C672AA7
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 22:39:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230258AbjARVit (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 16:38:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230467AbjARViq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 16:38:46 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8149C64695
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 13:37:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674077872;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ClB+1LW1ORcsFTlQjOYTtrXRWCeA0CJptW8kZS4NFfY=;
        b=BVsySjNtJpIXcaOwvp7MKbdwmmrMlDwgFxoorhWg7uTwGFjJskLYaMV0/KQfZTcRZ0riqZ
        zF89dt2GATQpxRX/EL47E+flchD1D7urN6GrJa6jxX1j/BSnHkJNN0oi2Y0ZVfSROEu0ES
        QMGddCmmGdealHmQTi6bqiXAKvNYBN4=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-649-5Gub4v0ANh6Lb9Oj_oMSgw-1; Wed, 18 Jan 2023 16:37:50 -0500
X-MC-Unique: 5Gub4v0ANh6Lb9Oj_oMSgw-1
Received: by mail-ej1-f71.google.com with SMTP id jg2-20020a170907970200b0086ee94381fbso161814ejc.2
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 13:37:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:to
         :content-language:subject:cc:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ClB+1LW1ORcsFTlQjOYTtrXRWCeA0CJptW8kZS4NFfY=;
        b=bNSO0PX+LgnJ3IWNxfwlCt1gzzA1DFwBAE896zUsXDbVY5nd/K748cTBYQNn0BCq/o
         cqn1jqHD/MD1cGCBa7L+KhUJdVr3MmLsh8NTx+tJDnPKu2dutFg+u46S/pp6RiUKTtoR
         WNglGp+EKzm2uPNfi1h09t7seVNUSxtAZTmA+hTjkj/wVOg2uE5da+Yx1t56WrU30pfG
         1olZHzP5CteWXFapreeqvFwwhnRHHx/xqkTHHUdosIlMhU+SNiaCMnFVxsNWk/eJcVxY
         D+M/FStmwqqsNCrAqSUY0r2z2QPAK4aYzi1VLyzsR1cBlCe1dVoHl6ujndxlejc9QLlE
         5OGw==
X-Gm-Message-State: AFqh2krvnNAPgdNEoFXDb5UZicBdgEq+tJG3eZ0jJfwixfQXN0K5R++k
        itPbF0tpOI7wQmnm/KxhRpHzqbEzlW60WWhfWmqL04Po1OvN9LGf+1CTLJE4jJ4ho0RhKZNPndR
        8T4WwW6IKB/Kx3abfHeoKQ9YNNGYD/g1GIP58uNoA5cFbkXskeDFJz0/o2Y8yUFNab04=
X-Received: by 2002:a17:906:4694:b0:86d:c1b2:257b with SMTP id a20-20020a170906469400b0086dc1b2257bmr18896043ejr.19.1674077869363;
        Wed, 18 Jan 2023 13:37:49 -0800 (PST)
X-Google-Smtp-Source: AMrXdXsPIXryoy2jMo4lLv7KaHkLM+H/21nuATpZHTupv4llJ02Q4PW0fwxm2tmoKMaAx2xuVXl1mg==
X-Received: by 2002:a17:906:4694:b0:86d:c1b2:257b with SMTP id a20-20020a170906469400b0086dc1b2257bmr18896028ejr.19.1674077869143;
        Wed, 18 Jan 2023 13:37:49 -0800 (PST)
Received: from [192.168.41.200] (83-90-141-187-cable.dk.customer.tdc.net. [83.90.141.187])
        by smtp.gmail.com with ESMTPSA id l17-20020a1709063d3100b008727576e4ecsm3083446ejf.117.2023.01.18.13.37.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Jan 2023 13:37:48 -0800 (PST)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <6f634864-2937-6e32-ba9d-7fa7f2b576cb@redhat.com>
Date:   Wed, 18 Jan 2023 22:37:47 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Cc:     brouer@redhat.com, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, edumazet@google.com,
        pabeni@redhat.com
Subject: Re: [PATCH net-next V2 2/2] net: kfree_skb_list use
 kmem_cache_free_bulk
Content-Language: en-US
To:     netdev@vger.kernel.org
References: <167361788585.531803.686364041841425360.stgit@firesoul>
 <167361792462.531803.224198635706602340.stgit@firesoul>
In-Reply-To: <167361792462.531803.224198635706602340.stgit@firesoul>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

(related to syzbot issue[1])

On 13/01/2023 14.52, Jesper Dangaard Brouer wrote:
> The kfree_skb_list function walks SKB (via skb->next) and frees them
> individually to the SLUB/SLAB allocator (kmem_cache). It is more
> efficient to bulk free them via the kmem_cache_free_bulk API.
> 
> This patches create a stack local array with SKBs to bulk free while
> walking the list. Bulk array size is limited to 16 SKBs to trade off
> stack usage and efficiency. The SLUB kmem_cache "skbuff_head_cache"
> uses objsize 256 bytes usually in an order-1 page 8192 bytes that is
> 32 objects per slab (can vary on archs and due to SLUB sharing). Thus,
> for SLUB the optimal bulk free case is 32 objects belonging to same
> slab, but runtime this isn't likely to occur.
> 
> The expected gain from using kmem_cache bulk alloc and free API
> have been assessed via a microbencmark kernel module[1].
> 
> The module 'slab_bulk_test01' results at bulk 16 element:
>   kmem-in-loop Per elem: 109 cycles(tsc) 30.532 ns (step:16)
>   kmem-bulk    Per elem: 64 cycles(tsc) 17.905 ns (step:16)
> 
> More detailed description of benchmarks avail in [2].
> 
> [1] https://github.com/netoptimizer/prototype-kernel/tree/master/kernel/mm
> [2] https://github.com/xdp-project/xdp-project/blob/master/areas/mem/kfree_skb_list01.org
> 
> V2: rename function to kfree_skb_add_bulk.
> 
> Reviewed-by: Saeed Mahameed <saeed@kernel.org>
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> ---
>   net/core/skbuff.c |   40 +++++++++++++++++++++++++++++++++++++++-
>   1 file changed, 39 insertions(+), 1 deletion(-)
> 
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index 007a5fbe284b..79c9e795a964 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -964,16 +964,54 @@ kfree_skb_reason(struct sk_buff *skb, enum skb_drop_reason reason)
>   }
>   EXPORT_SYMBOL(kfree_skb_reason);
>   
> +#define KFREE_SKB_BULK_SIZE	16
> +
> +struct skb_free_array {
> +	unsigned int skb_count;
> +	void *skb_array[KFREE_SKB_BULK_SIZE];
> +};
> +
> +static void kfree_skb_add_bulk(struct sk_buff *skb,
> +			       struct skb_free_array *sa,
> +			       enum skb_drop_reason reason)
> +{
> +	/* if SKB is a clone, don't handle this case */
> +	if (unlikely(skb->fclone != SKB_FCLONE_UNAVAILABLE)) {
> +		__kfree_skb(skb);
> +		return;
> +	}
> +
> +	skb_release_all(skb, reason);
> +	sa->skb_array[sa->skb_count++] = skb;
> +
> +	if (unlikely(sa->skb_count == KFREE_SKB_BULK_SIZE)) {
> +		kmem_cache_free_bulk(skbuff_head_cache, KFREE_SKB_BULK_SIZE,
> +				     sa->skb_array);
> +		sa->skb_count = 0;
> +	}
> +}
> +
>   void __fix_address
>   kfree_skb_list_reason(struct sk_buff *segs, enum skb_drop_reason reason)
>   {
> +	struct skb_free_array sa;
> +
> +	sa.skb_count = 0;
> +
>   	while (segs) {
>   		struct sk_buff *next = segs->next;
>   
> +		skb_mark_not_on_list(segs);

The syzbot[1] bug goes way if I remove this skb_mark_not_on_list().

I don't understand why I cannot clear skb->next here?

[1] https://lore.kernel.org/all/000000000000d58eae05f28ca51f@google.com/

>   		if (__kfree_skb_reason(segs, reason))
> -			__kfree_skb(segs);
> +			kfree_skb_add_bulk(segs, &sa, reason);
> +
>   		segs = next;
>   	}
> +
> +	if (sa.skb_count)
> +		kmem_cache_free_bulk(skbuff_head_cache, sa.skb_count,
> +				     sa.skb_array);
>   }
>   EXPORT_SYMBOL(kfree_skb_list_reason);
>   
> 
> 

