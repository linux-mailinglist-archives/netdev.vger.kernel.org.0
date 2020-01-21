Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19BD414416E
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 17:05:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729253AbgAUQDE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 11:03:04 -0500
Received: from mail.dlink.ru ([178.170.168.18]:53276 "EHLO fd.dlink.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726968AbgAUQBU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jan 2020 11:01:20 -0500
Received: by fd.dlink.ru (Postfix, from userid 5000)
        id E59E71B20B06; Tue, 21 Jan 2020 19:01:14 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 fd.dlink.ru E59E71B20B06
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dlink.ru; s=mail;
        t=1579622474; bh=Y0rhrc2hy1WySoTPM62A65bPBAMqU5jeTXgNrGdiVBs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References;
        b=Gak8YW5MGGONFnCP2eMyYBal3Eir85B6yKqeFSMq5OCB3fj1cBbbH+9fkjhRfBeT7
         0u48X9NnItgZL+4qRhUFhq7ziH72NFJLybDtvks+if36mIN/s5OOTE6DWbGjQv9Dw/
         DRYQrLyD0Bzyau3BO6xuKC1K4VtSCG84+DzKhmEU=
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.dlink.ru
X-Spam-Level: 
X-Spam-Status: No, score=-99.2 required=7.5 tests=BAYES_50,URIBL_BLOCKED,
        USER_IN_WHITELIST autolearn=disabled version=3.4.2
Received: from mail.rzn.dlink.ru (mail.rzn.dlink.ru [178.170.168.13])
        by fd.dlink.ru (Postfix) with ESMTP id 5A7F51B2025C;
        Tue, 21 Jan 2020 19:01:03 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 fd.dlink.ru 5A7F51B2025C
Received: from mail.rzn.dlink.ru (localhost [127.0.0.1])
        by mail.rzn.dlink.ru (Postfix) with ESMTP id C07E11B2183C;
        Tue, 21 Jan 2020 19:01:02 +0300 (MSK)
Received: from mail.rzn.dlink.ru (localhost [127.0.0.1])
        by mail.rzn.dlink.ru (Postfix) with ESMTPA;
        Tue, 21 Jan 2020 19:01:02 +0300 (MSK)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Tue, 21 Jan 2020 19:01:02 +0300
From:   Alexander Lobakin <alobakin@dlink.ru>
To:     Maxim Mikityanskiy <maximmi@mellanox.com>
Cc:     Edward Cree <ecree@solarflare.com>,
        Saeed Mahameed <saeedm@mellanox.com>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH net v2] net: Fix packet reordering caused by GRO and
 listified RX cooperation
In-Reply-To: <20200121150917.6279-1-maximmi@mellanox.com>
References: <20200121150917.6279-1-maximmi@mellanox.com>
User-Agent: Roundcube Webmail/1.4.0
Message-ID: <99961e583c3a880454caf7f0eb31b812@dlink.ru>
X-Sender: alobakin@dlink.ru
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Maxim Mikityanskiy wrote 21.01.2020 18:09:
> Commit 323ebb61e32b ("net: use listified RX for handling GRO_NORMAL
> skbs") introduces batching of GRO_NORMAL packets in napi_frags_finish,
> and commit 6570bc79c0df ("net: core: use listified Rx for GRO_NORMAL in
> napi_gro_receive()") adds the same to napi_skb_finish. However,
> dev_gro_receive (that is called just before napi_{frags,skb}_finish) 
> can
> also pass skbs to the networking stack: e.g., when the GRO session is
> flushed, napi_gro_complete is called, which passes pp directly to
> netif_receive_skb_internal, skipping napi->rx_list. It means that the
> packet stored in pp will be handled by the stack earlier than the
> packets that arrived before, but are still waiting in napi->rx_list. It
> leads to TCP reorderings that can be observed in the TCPOFOQueue 
> counter
> in netstat.
> 
> This commit fixes the reordering issue by making napi_gro_complete also
> use napi->rx_list, so that all packets going through GRO will keep 
> their
> order. In order to keep napi_gro_flush working properly, 
> gro_normal_list
> calls are moved after the flush to clear napi->rx_list.
> 
> iwlwifi calls napi_gro_flush directly and does the same thing that is
> done by gro_normal_list, so the same change is applied there:
> napi_gro_flush is moved to be before the flush of napi->rx_list.
> 
> A few other drivers also use napi_gro_flush (brocade/bna/bnad.c,
> cortina/gemini.c, hisilicon/hns3/hns3_enet.c). The first two also use
> napi_complete_done afterwards, which performs the gro_normal_list 
> flush,
> so they are fine. The latter calls napi_gro_receive right after
> napi_gro_flush, so it can end up with non-empty napi->rx_list anyway.

There's a call of napi_complete() at hisilicon/hns3/hns3_enet.c:3331,
so its polling cannot end with non-empty napi->rx_list.

> Fixes: 323ebb61e32b ("net: use listified RX for handling GRO_NORMAL 
> skbs")
> Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
> Cc: Alexander Lobakin <alobakin@dlink.ru>
> Cc: Edward Cree <ecree@solarflare.com>
> ---
> v2 changes:
> 
> Flush napi->rx_list after napi_gro_flush, not before. Do it in iwlwifi
> as well.
> 
> Please also pay attention that there is gro_flush_oldest that also 
> calls
> napi_gro_complete and DOESN'T do gro_normal_list to flush 
> napi->rx_list.
> I guess, it's not required in this flow, but if I'm wrong, please tell
> me.

gro_flush_oldest() is only called inside dev_gro_receive(), so the
subsequent mandatory napi_complete_done() will sweep all leftovers.

>  drivers/net/wireless/intel/iwlwifi/pcie/rx.c |  4 +-
>  net/core/dev.c                               | 64 ++++++++++----------
>  2 files changed, 35 insertions(+), 33 deletions(-)

Acked-by: Alexander Lobakin <alobakin@dlink.ru>

> diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
> b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
> index 452da44a21e0..f0b8ff67a1bc 100644
> --- a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
> +++ b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
> @@ -1529,13 +1529,13 @@ static void iwl_pcie_rx_handle(struct
> iwl_trans *trans, int queue)
> 
>  	napi = &rxq->napi;
>  	if (napi->poll) {
> +		napi_gro_flush(napi, false);
> +
>  		if (napi->rx_count) {
>  			netif_receive_skb_list(&napi->rx_list);
>  			INIT_LIST_HEAD(&napi->rx_list);
>  			napi->rx_count = 0;
>  		}
> -
> -		napi_gro_flush(napi, false);
>  	}
> 
>  	iwl_pcie_rxq_restock(trans, rxq);
> diff --git a/net/core/dev.c b/net/core/dev.c
> index e82e9b82dfd9..cca03914108a 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -5491,9 +5491,29 @@ static void flush_all_backlogs(void)
>  	put_online_cpus();
>  }
> 
> +/* Pass the currently batched GRO_NORMAL SKBs up to the stack. */
> +static void gro_normal_list(struct napi_struct *napi)
> +{
> +	if (!napi->rx_count)
> +		return;
> +	netif_receive_skb_list_internal(&napi->rx_list);
> +	INIT_LIST_HEAD(&napi->rx_list);
> +	napi->rx_count = 0;
> +}
> +
> +/* Queue one GRO_NORMAL SKB up for list processing. If batch size 
> exceeded,
> + * pass the whole batch up to the stack.
> + */
> +static void gro_normal_one(struct napi_struct *napi, struct sk_buff 
> *skb)
> +{
> +	list_add_tail(&skb->list, &napi->rx_list);
> +	if (++napi->rx_count >= gro_normal_batch)
> +		gro_normal_list(napi);
> +}
> +
>  INDIRECT_CALLABLE_DECLARE(int inet_gro_complete(struct sk_buff *, 
> int));
>  INDIRECT_CALLABLE_DECLARE(int ipv6_gro_complete(struct sk_buff *, 
> int));
> -static int napi_gro_complete(struct sk_buff *skb)
> +static int napi_gro_complete(struct napi_struct *napi, struct sk_buff 
> *skb)
>  {
>  	struct packet_offload *ptype;
>  	__be16 type = skb->protocol;
> @@ -5526,7 +5546,8 @@ static int napi_gro_complete(struct sk_buff *skb)
>  	}
> 
>  out:
> -	return netif_receive_skb_internal(skb);
> +	gro_normal_one(napi, skb);
> +	return NET_RX_SUCCESS;
>  }
> 
>  static void __napi_gro_flush_chain(struct napi_struct *napi, u32 
> index,
> @@ -5539,7 +5560,7 @@ static void __napi_gro_flush_chain(struct
> napi_struct *napi, u32 index,
>  		if (flush_old && NAPI_GRO_CB(skb)->age == jiffies)
>  			return;
>  		skb_list_del_init(skb);
> -		napi_gro_complete(skb);
> +		napi_gro_complete(napi, skb);
>  		napi->gro_hash[index].count--;
>  	}
> 
> @@ -5641,7 +5662,7 @@ static void gro_pull_from_frag0(struct sk_buff
> *skb, int grow)
>  	}
>  }
> 
> -static void gro_flush_oldest(struct list_head *head)
> +static void gro_flush_oldest(struct napi_struct *napi, struct 
> list_head *head)
>  {
>  	struct sk_buff *oldest;
> 
> @@ -5657,7 +5678,7 @@ static void gro_flush_oldest(struct list_head 
> *head)
>  	 * SKB to the chain.
>  	 */
>  	skb_list_del_init(oldest);
> -	napi_gro_complete(oldest);
> +	napi_gro_complete(napi, oldest);
>  }
> 
>  INDIRECT_CALLABLE_DECLARE(struct sk_buff *inet_gro_receive(struct 
> list_head *,
> @@ -5733,7 +5754,7 @@ static enum gro_result dev_gro_receive(struct
> napi_struct *napi, struct sk_buff
> 
>  	if (pp) {
>  		skb_list_del_init(pp);
> -		napi_gro_complete(pp);
> +		napi_gro_complete(napi, pp);
>  		napi->gro_hash[hash].count--;
>  	}
> 
> @@ -5744,7 +5765,7 @@ static enum gro_result dev_gro_receive(struct
> napi_struct *napi, struct sk_buff
>  		goto normal;
> 
>  	if (unlikely(napi->gro_hash[hash].count >= MAX_GRO_SKBS)) {
> -		gro_flush_oldest(gro_head);
> +		gro_flush_oldest(napi, gro_head);
>  	} else {
>  		napi->gro_hash[hash].count++;
>  	}
> @@ -5802,26 +5823,6 @@ struct packet_offload
> *gro_find_complete_by_type(__be16 type)
>  }
>  EXPORT_SYMBOL(gro_find_complete_by_type);
> 
> -/* Pass the currently batched GRO_NORMAL SKBs up to the stack. */
> -static void gro_normal_list(struct napi_struct *napi)
> -{
> -	if (!napi->rx_count)
> -		return;
> -	netif_receive_skb_list_internal(&napi->rx_list);
> -	INIT_LIST_HEAD(&napi->rx_list);
> -	napi->rx_count = 0;
> -}
> -
> -/* Queue one GRO_NORMAL SKB up for list processing. If batch size 
> exceeded,
> - * pass the whole batch up to the stack.
> - */
> -static void gro_normal_one(struct napi_struct *napi, struct sk_buff 
> *skb)
> -{
> -	list_add_tail(&skb->list, &napi->rx_list);
> -	if (++napi->rx_count >= gro_normal_batch)
> -		gro_normal_list(napi);
> -}
> -
>  static void napi_skb_free_stolen_head(struct sk_buff *skb)
>  {
>  	skb_dst_drop(skb);
> @@ -6200,8 +6201,6 @@ bool napi_complete_done(struct napi_struct *n,
> int work_done)
>  				 NAPIF_STATE_IN_BUSY_POLL)))
>  		return false;
> 
> -	gro_normal_list(n);
> -
>  	if (n->gro_bitmask) {
>  		unsigned long timeout = 0;
> 
> @@ -6217,6 +6216,9 @@ bool napi_complete_done(struct napi_struct *n,
> int work_done)
>  			hrtimer_start(&n->timer, ns_to_ktime(timeout),
>  				      HRTIMER_MODE_REL_PINNED);
>  	}
> +
> +	gro_normal_list(n);
> +
>  	if (unlikely(!list_empty(&n->poll_list))) {
>  		/* If n->poll_list is not empty, we need to mask irqs */
>  		local_irq_save(flags);
> @@ -6548,8 +6550,6 @@ static int napi_poll(struct napi_struct *n,
> struct list_head *repoll)
>  		goto out_unlock;
>  	}
> 
> -	gro_normal_list(n);
> -
>  	if (n->gro_bitmask) {
>  		/* flush too old packets
>  		 * If HZ < 1000, flush all packets.
> @@ -6557,6 +6557,8 @@ static int napi_poll(struct napi_struct *n,
> struct list_head *repoll)
>  		napi_gro_flush(n, HZ >= 1000);
>  	}
> 
> +	gro_normal_list(n);
> +
>  	/* Some drivers may have called napi_schedule
>  	 * prior to exhausting their budget.
>  	 */

Regards,
ᚷ ᛖ ᚢ ᚦ ᚠ ᚱ
