Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 939D56D1C74
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 11:33:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232280AbjCaJdR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 05:33:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232055AbjCaJc7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 05:32:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB7DD1DF91
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 02:31:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680255096;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=G2fT1JQ7dOy3WwoS7CI1rOQ+NB5OZEJ0JVt/YX2LKWA=;
        b=Pz8ZjIuHtADCtRHlF5JHkKi8DC7VOlhWLejIJ3rbCettRiB3Pci1ZOPDipamo4oxkJZBMS
        DRgFSFf2nFmQkQcO+JmymbaO6kk7mo2kD/8ZHCRQRSTh2h9oKa6HXL3xrJuEgwUeI6QLgZ
        xNrTlvKqWl9K5gnh99m/54Gzwx1ETTs=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-278-4G2NzV60OcOsKzOLN4w6PQ-1; Fri, 31 Mar 2023 05:31:34 -0400
X-MC-Unique: 4G2NzV60OcOsKzOLN4w6PQ-1
Received: by mail-lj1-f199.google.com with SMTP id h16-20020a05651c125000b002a3b2b80165so4722158ljh.2
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 02:31:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680255093;
        h=content-transfer-encoding:in-reply-to:references:to
         :content-language:subject:cc:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=G2fT1JQ7dOy3WwoS7CI1rOQ+NB5OZEJ0JVt/YX2LKWA=;
        b=EfCkSU80VvEEu9RyIbTaDYMHUxdsfmASZwGjdPN+S5ygIa85BrbmP/nMcZb/YnwVXR
         LGrFDojClw+LyVULtbGnT0B1djE6c7GtEeZebpOBI4muPH7Pn02Vok7VBNmKEMrfA9xf
         yATH7F7/PHRE95FSNNdmVeiqL304B1YuaXsDiMS3fRsOJRENKEy5tJY0clomCAoLEbXx
         XeU+On+aN44/DoTcIw+Dm3QC6d4DPmDZKFfjh1/0qRgDC9sxYtiuLhQHNmGSHfhaQhVw
         K351Eg83c5W0pi9CS8tFzR6RMVj9G4UfEe1peAMFkEGlwnW4443CrtT62YMS6ZWNgUWa
         7L+g==
X-Gm-Message-State: AAQBX9fbz43CC+VrbxrNWfxBta+KHeDYywJEFYKx8rMbkWshZjXRObZ/
        Uu2TQq4tp94DsrcLVRJeAuovVIpSZpZ0iYrcpzByPIhZ3VXOK1GWQ0jy/XInG7FSNKweQxL8f6t
        V+rlEv05v2z6ABj0P
X-Received: by 2002:a05:6512:950:b0:4db:28ce:e600 with SMTP id u16-20020a056512095000b004db28cee600mr5982948lft.1.1680255093238;
        Fri, 31 Mar 2023 02:31:33 -0700 (PDT)
X-Google-Smtp-Source: AKy350ZQx2qcxGhEQZffaISLhMDkzPz91GvkztF97QhJ+p9xGyG8WCklwmQTaqcfzwIm9+MGiXv9Mw==
X-Received: by 2002:a05:6512:950:b0:4db:28ce:e600 with SMTP id u16-20020a056512095000b004db28cee600mr5982942lft.1.1680255092906;
        Fri, 31 Mar 2023 02:31:32 -0700 (PDT)
Received: from [192.168.42.100] (83-90-141-187-cable.dk.customer.tdc.net. [83.90.141.187])
        by smtp.gmail.com with ESMTPSA id q14-20020ac24a6e000000b004e92c0ed7a0sm306467lfp.100.2023.03.31.02.31.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Mar 2023 02:31:32 -0700 (PDT)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <c646d51c-4e91-bd86-9a5b-97b5a1ce33d0@redhat.com>
Date:   Fri, 31 Mar 2023 11:31:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Cc:     brouer@redhat.com, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, hawk@kernel.org, ilias.apalodimas@linaro.org
Subject: Re: [RFC net-next 1/2] page_pool: allow caching from safely localized
 NAPI
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
References: <20230331043906.3015706-1-kuba@kernel.org>
In-Reply-To: <20230331043906.3015706-1-kuba@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 31/03/2023 06.39, Jakub Kicinski wrote:
> Recent patches to mlx5 mentioned a regression when moving from
> driver local page pool to only using the generic page pool code.
> Page pool has two recycling paths (1) direct one, which runs in
> safe NAPI context (basically consumer context, so producing
> can be lockless); and (2) via a ptr_ring, which takes a spin
> lock because the freeing can happen from any CPU; producer
> and consumer may run concurrently.
> 
> Since the page pool code was added, Eric introduced a revised version
> of deferred skb freeing. TCP skbs are now usually returned to the CPU
> which allocated them, and freed in softirq context. This places the
> freeing (producing of pages back to the pool) enticingly close to
> the allocation (consumer).
> 
> If we can prove that we're freeing in the same softirq context in which
> the consumer NAPI will run - lockless use of the cache is perfectly fine,
> no need for the lock.

Super interesting! :-)

> 
> Let drivers link the page pool to a NAPI instance. If the NAPI instance
> is scheduled on the same CPU on which we're freeing - place the pages
> in the direct cache.
> 

Cool, using the direct cache this way.

In the cases where we cannot use the direct cache.
There is also the option of bulk freeing into page_pool which mitigate
the ptr_ring locking. See code page_pool_put_page_bulk().

For XDP the page_pool_put_page_bulk() API is used by
xdp_return_frame_bulk() and xdp_flush_frame_bulk(), which together
builds-up a bulk.
(p.s. I see we could optimize xdp_return_frame_bulk some more, and avoid
some of the rhashtable_lookup(), but that is unrelated to your patch).

> With that and patched bnxt (XDP enabled to engage the page pool, sigh,
> bnxt really needs page pool work :() I see a 2.6% perf boost with
> a TCP stream test (app on a different physical core than softirq).
> 
> The CPU use of relevant functions decreases as expected:
> 
>    page_pool_refill_alloc_cache   1.17% -> 0%
>    _raw_spin_lock                 2.41% -> 0.98%
> 
> Only consider lockless path to be safe when NAPI is scheduled
> - in practice this should cover majority if not all of steady state
> workloads. It's usually the NAPI kicking in that causes the skb flush.
>

Make sense, but do read the comment above struct pp_alloc_cache.
The sizing of pp_alloc_cache is important for this trick/heuristic to
work, meaning the pp_alloc_cache have enough room.
It is definitely on purpose that pp_alloc_cache have 128 elements and is
only refill'ed with 64 elements, which leaves room for this kind of
trick.  But if Eric's deferred skb freeing have more than 64 pages to
free, then we will likely fallback to ptr_ring recycling.

Code wise, I suggest that you/we change page_pool_put_page_bulk() to
have a variant that 'allow_direct' (looking at code below, you might
already do this as this patch over-steer 'allow_direct').  Using the
bulk API, would then bulk into ptr_ring in the cases we cannot use
direct cache.

> The main case we'll miss out on is when application runs on the same
> CPU as NAPI. In that case we don't use the deferred skb free path.
> We could disable softirq one that path, too... maybe?
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> CC: hawk@kernel.org
> CC: ilias.apalodimas@linaro.org
> ---
>   include/linux/netdevice.h |  3 +++
>   include/net/page_pool.h   |  1 +
>   net/core/dev.c            |  3 +++
>   net/core/page_pool.c      | 16 ++++++++++++++++
>   4 files changed, 23 insertions(+)
> 
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index 62e093a6d6d1..b3c11353078b 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -360,8 +360,11 @@ struct napi_struct {
>   	unsigned long		gro_bitmask;
>   	int			(*poll)(struct napi_struct *, int);
>   #ifdef CONFIG_NETPOLL
> +	/* CPU actively polling if netpoll is configured */
>   	int			poll_owner;
>   #endif
> +	/* CPU on which NAPI has been scheduled for processing */
> +	int			list_owner;
>   	struct net_device	*dev;
>   	struct gro_list		gro_hash[GRO_HASH_BUCKETS];
>   	struct sk_buff		*skb;
> diff --git a/include/net/page_pool.h b/include/net/page_pool.h
> index ddfa0b328677..f86cdfb51585 100644
> --- a/include/net/page_pool.h
> +++ b/include/net/page_pool.h
> @@ -77,6 +77,7 @@ struct page_pool_params {
>   	unsigned int	pool_size;
>   	int		nid;  /* Numa node id to allocate from pages from */
>   	struct device	*dev; /* device, for DMA pre-mapping purposes */
> +	struct napi_struct *napi; /* Sole consumer of pages, otherwise NULL */
>   	enum dma_data_direction dma_dir; /* DMA mapping direction */
>   	unsigned int	max_len; /* max DMA sync memory size */
>   	unsigned int	offset;  /* DMA addr offset */
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 0c4b21291348..a6d6e5c89ce7 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -4360,6 +4360,7 @@ static inline void ____napi_schedule(struct softnet_data *sd,
>   	}
>   
>   	list_add_tail(&napi->poll_list, &sd->poll_list);
> +	WRITE_ONCE(napi->list_owner, smp_processor_id());
>   	/* If not called from net_rx_action()
>   	 * we have to raise NET_RX_SOFTIRQ.
>   	 */
> @@ -6070,6 +6071,7 @@ bool napi_complete_done(struct napi_struct *n, int work_done)
>   		list_del_init(&n->poll_list);
>   		local_irq_restore(flags);
>   	}
> +	WRITE_ONCE(n->list_owner, -1);
>   
>   	val = READ_ONCE(n->state);
>   	do {
> @@ -6385,6 +6387,7 @@ void netif_napi_add_weight(struct net_device *dev, struct napi_struct *napi,
>   #ifdef CONFIG_NETPOLL
>   	napi->poll_owner = -1;
>   #endif
> +	napi->list_owner = -1;
>   	set_bit(NAPI_STATE_SCHED, &napi->state);
>   	set_bit(NAPI_STATE_NPSVC, &napi->state);
>   	list_add_rcu(&napi->dev_list, &dev->napi_list);
> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> index 193c18799865..c3e2ab0c2684 100644
> --- a/net/core/page_pool.c
> +++ b/net/core/page_pool.c
> @@ -19,6 +19,7 @@
>   #include <linux/mm.h> /* for put_page() */
>   #include <linux/poison.h>
>   #include <linux/ethtool.h>
> +#include <linux/netdevice.h>
>   
>   #include <trace/events/page_pool.h>
>   
> @@ -544,6 +545,18 @@ static bool page_pool_recycle_in_cache(struct page *page,
>   	return true;
>   }
>   
> +/* If caller didn't allow direct recycling check if we have other reasons
> + * to believe that the producer and consumer can't race.
> + *
> + * Result is only meaningful in softirq context.
> + */
> +static bool page_pool_safe_producer(struct page_pool *pool)
> +{
> +	struct napi_struct *napi = pool->p.napi;
> +
> +	return napi && READ_ONCE(napi->list_owner) == smp_processor_id();
> +}
> +
>   /* If the page refcnt == 1, this will try to recycle the page.
>    * if PP_FLAG_DMA_SYNC_DEV is set, we'll try to sync the DMA area for
>    * the configured size min(dma_sync_size, pool->max_len).
> @@ -570,6 +583,9 @@ __page_pool_put_page(struct page_pool *pool, struct page *page,
>   			page_pool_dma_sync_for_device(pool, page,
>   						      dma_sync_size);
>   
> +		if (!allow_direct)
> +			allow_direct = page_pool_safe_producer(pool);
> +

I remember some use-case for veth, that explicitly disables
"allow_direct".  I cannot remember why exactly, but we need to make sure
that doesn't break something (as this code can undo the allow_direct).

>   		if (allow_direct && in_softirq() &&
>   		    page_pool_recycle_in_cache(page, pool))
>   			return NULL;

