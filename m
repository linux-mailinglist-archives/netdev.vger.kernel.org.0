Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29B061416F0
	for <lists+netdev@lfdr.de>; Sat, 18 Jan 2020 11:10:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726935AbgARKFa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jan 2020 05:05:30 -0500
Received: from fd.dlink.ru ([178.170.168.18]:52930 "EHLO fd.dlink.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726563AbgARKF3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 18 Jan 2020 05:05:29 -0500
Received: by fd.dlink.ru (Postfix, from userid 5000)
        id 7878C1B206E4; Sat, 18 Jan 2020 13:05:26 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 fd.dlink.ru 7878C1B206E4
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dlink.ru; s=mail;
        t=1579341926; bh=bxEGf7Qy0I/OPDFumCl1l8XrSRQoq9rcQf7L+MY/L/U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References;
        b=eVBxzFCU9YxcgDPNpyUhhBLLdjF+WxQNtKiX1ZNyCKe1lfilx6az9UmP0Fuf3wtMm
         D+OO8RxynNQ+bs+CvoCK5hc0dBX3GsI4oWXwckWcayo1zjDwQ7bC7uyeDKbcGHxEeU
         4o9R85p6BkO3YzXWIvHB3BC2q0wINjcXwRtsJYzw=
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.dlink.ru
X-Spam-Level: 
X-Spam-Status: No, score=-99.2 required=7.5 tests=BAYES_50,URIBL_BLOCKED,
        USER_IN_WHITELIST autolearn=disabled version=3.4.2
Received: from mail.rzn.dlink.ru (mail.rzn.dlink.ru [178.170.168.13])
        by fd.dlink.ru (Postfix) with ESMTP id C73EA1B206E4;
        Sat, 18 Jan 2020 13:05:19 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 fd.dlink.ru C73EA1B206E4
Received: from mail.rzn.dlink.ru (localhost [127.0.0.1])
        by mail.rzn.dlink.ru (Postfix) with ESMTP id 6C3901B20234;
        Sat, 18 Jan 2020 13:05:19 +0300 (MSK)
Received: from mail.rzn.dlink.ru (localhost [127.0.0.1])
        by mail.rzn.dlink.ru (Postfix) with ESMTPA;
        Sat, 18 Jan 2020 13:05:19 +0300 (MSK)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Sat, 18 Jan 2020 13:05:19 +0300
From:   Alexander Lobakin <alobakin@dlink.ru>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     ecree@solarflare.com, Maxim Mikityanskiy <maximmi@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>, edumazet@google.com,
        netdev@vger.kernel.org, davem@davemloft.net,
        Tariq Toukan <tariqt@mellanox.com>
Subject: Re: [PATCH net] net: Fix packet reordering caused by GRO and
 listified RX cooperation
In-Reply-To: <7939223efeb4ed9523a802702874be9b8f37f231.camel@mellanox.com>
References: <20200117150913.29302-1-maximmi@mellanox.com>
 <7939223efeb4ed9523a802702874be9b8f37f231.camel@mellanox.com>
User-Agent: Roundcube Webmail/1.4.0
Message-ID: <da13831f11d0141728a96954685fdf40@dlink.ru>
X-Sender: alobakin@dlink.ru
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Saeed,

Saeed Mahameed wrote 18.01.2020 01:47:
> On Fri, 2020-01-17 at 15:09 +0000, Maxim Mikityanskiy wrote:
>> Commit 6570bc79c0df ("net: core: use listified Rx for GRO_NORMAL in
>> napi_gro_receive()") introduces batching of GRO_NORMAL packets in
>> napi_skb_finish. However, dev_gro_receive, that is called just before
>> napi_skb_finish, can also pass skbs to the networking stack: e.g.,
>> when
>> the GRO session is flushed, napi_gro_complete is called, which passes
>> pp
>> directly to netif_receive_skb_internal, skipping napi->rx_list. It
>> means
>> that the packet stored in pp will be handled by the stack earlier
>> than
>> the packets that arrived before, but are still waiting in napi-
>> >rx_list.
>> It leads to TCP reorderings that can be observed in the TCPOFOQueue
>> counter in netstat.
>> 
>> This commit fixes the reordering issue by making napi_gro_complete
>> also
>> use napi->rx_list, so that all packets going through GRO will keep
>> their
>> order.
>> 
>> Fixes: 6570bc79c0df ("net: core: use listified Rx for GRO_NORMAL in
>> napi_gro_receive()")
>> Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
>> Cc: Alexander Lobakin <alobakin@dlink.ru>
>> Cc: Edward Cree <ecree@solarflare.com>
>> ---
>> Alexander and Edward, please verify the correctness of this patch. If
>> it's necessary to pass that SKB to the networking stack right away, I
>> can change this patch to flush napi->rx_list by calling
>> gro_normal_list
>> first, instead of putting the SKB in the list.
>> 
> 
> actually this will break performance of traffic that needs to skip
> gro.. and we will loose bulking, so don't do it :)
> 
> But your point is valid when napi_gro_complete() is called outside of
> napi_gro_receive() path.
> 
> see below..
> 
>>  net/core/dev.c | 55 +++++++++++++++++++++++++-----------------------
>> --
>>  1 file changed, 28 insertions(+), 27 deletions(-)
>> 
>> diff --git a/net/core/dev.c b/net/core/dev.c
>> index 0ad39c87b7fd..db7a105bbc77 100644
>> --- a/net/core/dev.c
>> +++ b/net/core/dev.c
>> @@ -5491,9 +5491,29 @@ static void flush_all_backlogs(void)
>>  	put_online_cpus();
>>  }
>> 
>> +/* Pass the currently batched GRO_NORMAL SKBs up to the stack. */
>> +static void gro_normal_list(struct napi_struct *napi)
>> +{
>> +	if (!napi->rx_count)
>> +		return;
>> +	netif_receive_skb_list_internal(&napi->rx_list);
>> +	INIT_LIST_HEAD(&napi->rx_list);
>> +	napi->rx_count = 0;
>> +}
>> +
>> +/* Queue one GRO_NORMAL SKB up for list processing. If batch size
>> exceeded,
>> + * pass the whole batch up to the stack.
>> + */
>> +static void gro_normal_one(struct napi_struct *napi, struct sk_buff
>> *skb)
>> +{
>> +	list_add_tail(&skb->list, &napi->rx_list);
>> +	if (++napi->rx_count >= gro_normal_batch)
>> +		gro_normal_list(napi);
>> +}
>> +
>>  INDIRECT_CALLABLE_DECLARE(int inet_gro_complete(struct sk_buff *,
>> int));
>>  INDIRECT_CALLABLE_DECLARE(int ipv6_gro_complete(struct sk_buff *,
>> int));
>> -static int napi_gro_complete(struct sk_buff *skb)
>> +static int napi_gro_complete(struct napi_struct *napi, struct
>> sk_buff *skb)
>>  {
>>  	struct packet_offload *ptype;
>>  	__be16 type = skb->protocol;
>> @@ -5526,7 +5546,8 @@ static int napi_gro_complete(struct sk_buff
>> *skb)
>>  	}
>> 
>>  out:
>> -	return netif_receive_skb_internal(skb);
>> +	gro_normal_one(napi, skb);
>> +	return NET_RX_SUCCESS;
>>  }
>> 
> 
> The patch looks fine when napi_gro_complete() is called form
> napi_gro_receive() path.
> 
> But napi_gro_complete() is also used by napi_gro_flush() which is
> called in other contexts, which might break, if they really meant to
> flush to the stack..
> 
> examples:
> 1. drives that use napi_gro_flush() which is not "eventually" followed
> by napi_complete_done(), might break.. possible bug in those drivers
> though. drivers must always return with napi_complete_done();

Drivers *should not* use napi_gro_flush() by themselves. This was
discussed several times here and at the moment me and Edward are
waiting for proper NAPI usage in iwlwifi driver to unexport this
one and make it static.

> 2. the following code in napi_complete_done()
> 
> /* When the NAPI instance uses a timeout and keeps postponing
>  * it, we need to bound somehow the time packets are kept in
>  * the GRO layer
>  */
>   napi_gro_flush(n, !!timeout);
> 
> with the new implementation we won't really flush to the stack unless

Oh, I got this one. This is really an issue. gro_normal_list() is
called earlier than napi_gro_flush() in napi_complete_done(), so
several skbs might stuck in napi->rx_list until next NAPI session.
Thanks for pointing this out, I missed it.

> one possible solution: is to call gro_normal_list(napi); inside:
> napi_gro_flush() ?
> 
> another possible solution:
> allays make sure to follow napi_gro_flush(); with gro_normal_list(n);
> 
> since i see two places in dev.c where we do:
> 
> gro_normal_list(n);
> if (cond) {
>    napi_gro_flush();
> }
> 
> instead, we can change them to:
> 
> if (cond) {
>    /* flush gro to napi->rx_list, with your implementation  */
>    napi_gro_flush();
> }
> gro_normal_list(n); /* Now flush to the stack */
> 
> And your implementation will be correct for such use cases.

I think this one would be more straightforward and correct.
But this needs tests for sure. I could do them only Monday, 20
unfortunately.

Or we can call gro_normal_list() directly in napi_gro_complete()
as Maxim proposed as alternative solution.
I'd like to see what Edward thinks about it. But this one really
needs to be handled either way.

>>  static void __napi_gro_flush_chain(struct napi_struct *napi, u32
>> index,
>> @@ -5539,7 +5560,7 @@ static void __napi_gro_flush_chain(struct
>> napi_struct *napi, u32 index,
>>  		if (flush_old && NAPI_GRO_CB(skb)->age == jiffies)
>>  			return;
>>  		skb_list_del_init(skb);
>> -		napi_gro_complete(skb);
>> +		napi_gro_complete(napi, skb);
>>  		napi->gro_hash[index].count--;
>>  	}
>> 
>> @@ -5641,7 +5662,7 @@ static void gro_pull_from_frag0(struct sk_buff
>> *skb, int grow)
>>  	}
>>  }
>> 
>> -static void gro_flush_oldest(struct list_head *head)
>> +static void gro_flush_oldest(struct napi_struct *napi, struct
>> list_head *head)
>>  {
>>  	struct sk_buff *oldest;
>> 
>> @@ -5657,7 +5678,7 @@ static void gro_flush_oldest(struct list_head
>> *head)
>>  	 * SKB to the chain.
>>  	 */
>>  	skb_list_del_init(oldest);
>> -	napi_gro_complete(oldest);
>> +	napi_gro_complete(napi, oldest);
>>  }
>> 
>>  INDIRECT_CALLABLE_DECLARE(struct sk_buff *inet_gro_receive(struct
>> list_head *,
>> @@ -5733,7 +5754,7 @@ static enum gro_result dev_gro_receive(struct
>> napi_struct *napi, struct sk_buff
>> 
>>  	if (pp) {
>>  		skb_list_del_init(pp);
>> -		napi_gro_complete(pp);
>> +		napi_gro_complete(napi, pp);
>>  		napi->gro_hash[hash].count--;
>>  	}
>> 
>> @@ -5744,7 +5765,7 @@ static enum gro_result dev_gro_receive(struct
>> napi_struct *napi, struct sk_buff
>>  		goto normal;
>> 
>>  	if (unlikely(napi->gro_hash[hash].count >= MAX_GRO_SKBS)) {
>> -		gro_flush_oldest(gro_head);
>> +		gro_flush_oldest(napi, gro_head);
>>  	} else {
>>  		napi->gro_hash[hash].count++;
>>  	}
>> @@ -5802,26 +5823,6 @@ struct packet_offload
>> *gro_find_complete_by_type(__be16 type)
>>  }
>>  EXPORT_SYMBOL(gro_find_complete_by_type);
>> 
>> -/* Pass the currently batched GRO_NORMAL SKBs up to the stack. */
>> -static void gro_normal_list(struct napi_struct *napi)
>> -{
>> -	if (!napi->rx_count)
>> -		return;
>> -	netif_receive_skb_list_internal(&napi->rx_list);
>> -	INIT_LIST_HEAD(&napi->rx_list);
>> -	napi->rx_count = 0;
>> -}
>> -
>> -/* Queue one GRO_NORMAL SKB up for list processing. If batch size
>> exceeded,
>> - * pass the whole batch up to the stack.
>> - */
>> -static void gro_normal_one(struct napi_struct *napi, struct sk_buff
>> *skb)
>> -{
>> -	list_add_tail(&skb->list, &napi->rx_list);
>> -	if (++napi->rx_count >= gro_normal_batch)
>> -		gro_normal_list(napi);
>> -}
>> -
>>  static void napi_skb_free_stolen_head(struct sk_buff *skb)
>>  {
>>  	skb_dst_drop(skb);

Regards,
ᚷ ᛖ ᚢ ᚦ ᚠ ᚱ
