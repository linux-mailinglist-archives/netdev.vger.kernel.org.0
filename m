Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BEAB140EB0
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 17:10:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729047AbgAQQKA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jan 2020 11:10:00 -0500
Received: from mail.dlink.ru ([178.170.168.18]:38884 "EHLO fd.dlink.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727043AbgAQQKA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Jan 2020 11:10:00 -0500
Received: by fd.dlink.ru (Postfix, from userid 5000)
        id 4764D1B209BB; Fri, 17 Jan 2020 19:09:58 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 fd.dlink.ru 4764D1B209BB
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dlink.ru; s=mail;
        t=1579277398; bh=cTyZHTaULGGA9qLxyq/USVE3FrwcgtB2aCGM7dj6u0Q=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References;
        b=DzjDz7SF/BbaNOvKaWtDCCUsRkBJkMeu9oRRWI6eh79F9oy8Aqa0QWE3TtR4prfyn
         aH8smXnPDgLMoAkiGmbv1dUDA9EDlj3TrSTheb5Fh/6FEKkitcOhjLlK+iLMvaLFio
         fT1ut5A3vxYw2QJ1Om13efASoBevMoPpXpF7Nx6c=
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.dlink.ru
X-Spam-Level: 
X-Spam-Status: No, score=-99.2 required=7.5 tests=BAYES_50,URIBL_BLOCKED,
        USER_IN_WHITELIST autolearn=disabled version=3.4.2
Received: from mail.rzn.dlink.ru (mail.rzn.dlink.ru [178.170.168.13])
        by fd.dlink.ru (Postfix) with ESMTP id 6C7ED1B2010A;
        Fri, 17 Jan 2020 19:09:51 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 fd.dlink.ru 6C7ED1B2010A
Received: from mail.rzn.dlink.ru (localhost [127.0.0.1])
        by mail.rzn.dlink.ru (Postfix) with ESMTP id 46FC81B20AE9;
        Fri, 17 Jan 2020 19:09:51 +0300 (MSK)
Received: from mail.rzn.dlink.ru (localhost [127.0.0.1])
        by mail.rzn.dlink.ru (Postfix) with ESMTPA;
        Fri, 17 Jan 2020 19:09:51 +0300 (MSK)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Fri, 17 Jan 2020 19:09:51 +0300
From:   Alexander Lobakin <alobakin@dlink.ru>
To:     Maxim Mikityanskiy <maximmi@mellanox.com>
Cc:     Edward Cree <ecree@solarflare.com>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Tariq Toukan <tariqt@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH net] net: Fix packet reordering caused by GRO and
 listified RX cooperation
In-Reply-To: <20200117150913.29302-1-maximmi@mellanox.com>
References: <20200117150913.29302-1-maximmi@mellanox.com>
User-Agent: Roundcube Webmail/1.4.0
Message-ID: <f10c43b5b74cafce3f1b3c336ce85bdb@dlink.ru>
X-Sender: alobakin@dlink.ru
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Maxim!

Maxim Mikityanskiy wrote 17.01.2020 18:09:
> Commit 6570bc79c0df ("net: core: use listified Rx for GRO_NORMAL in
> napi_gro_receive()") introduces batching of GRO_NORMAL packets in
> napi_skb_finish. However, dev_gro_receive, that is called just before
> napi_skb_finish, can also pass skbs to the networking stack: e.g., when
> the GRO session is flushed, napi_gro_complete is called, which passes 
> pp
> directly to netif_receive_skb_internal, skipping napi->rx_list. It 
> means
> that the packet stored in pp will be handled by the stack earlier than
> the packets that arrived before, but are still waiting in 
> napi->rx_list.
> It leads to TCP reorderings that can be observed in the TCPOFOQueue
> counter in netstat.
> 
> This commit fixes the reordering issue by making napi_gro_complete also
> use napi->rx_list, so that all packets going through GRO will keep 
> their
> order.
> 
> Fixes: 6570bc79c0df ("net: core: use listified Rx for GRO_NORMAL in
> napi_gro_receive()")

I don't think this is correct commit hash to place in "Fixes".
napi->rx_list was firstly introduced back in 323ebb61e32b
("net: use listified RX for handling GRO_NORMAL skbs"), but only
for napi_gro_frags() users. The one that you mentioned just made
use of listified Rx in napi_gro_receive() too. So I'd better tag
the first one, as this fix affects both receiving functions.

> Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
> Cc: Alexander Lobakin <alobakin@dlink.ru>
> Cc: Edward Cree <ecree@solarflare.com>
> ---
> Alexander and Edward, please verify the correctness of this patch. If
> it's necessary to pass that SKB to the networking stack right away, I
> can change this patch to flush napi->rx_list by calling gro_normal_list
> first, instead of putting the SKB in the list.

I've just tested it on my usual 4-core MIPS board and got pretty
impressive results (VLAN NAT, iperf3, gro_normal_batch == 16):
thoughtput increase up to 40 Mbps (~840 -> ~880) and a huge reduce
of TCP retransmissions (about 80% of them I think).
So, from my point of view, the patch is completely correct and
very important. Thank you for this one!

Tested-by: Alexander Lobakin <alobakin@dlink.ru>

and, if applicable,

Reviewed-by: Alexander Lobakin <alobakin@dlink.ru>

>  net/core/dev.c | 55 +++++++++++++++++++++++++-------------------------
>  1 file changed, 28 insertions(+), 27 deletions(-)
> 
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 0ad39c87b7fd..db7a105bbc77 100644
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

Regards,
ᚷ ᛖ ᚢ ᚦ ᚠ ᚱ
