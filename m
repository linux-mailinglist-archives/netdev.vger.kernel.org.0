Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D43C614278E
	for <lists+netdev@lfdr.de>; Mon, 20 Jan 2020 10:45:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727022AbgATJo7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jan 2020 04:44:59 -0500
Received: from mail.dlink.ru ([178.170.168.18]:48358 "EHLO fd.dlink.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726417AbgATJo7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Jan 2020 04:44:59 -0500
Received: by fd.dlink.ru (Postfix, from userid 5000)
        id 29E1A1B20A89; Mon, 20 Jan 2020 12:44:54 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 fd.dlink.ru 29E1A1B20A89
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dlink.ru; s=mail;
        t=1579513494; bh=KJ5U72kR6Fbfe+u+gmJGRAp4sYjRf6cdW1X8g/i/IX0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References;
        b=q0VjYJlNULur0k0+QEj/8v8poeuybYOPOw2tJH1OZsX46S2nggd07x0rEKEkWx1mr
         L6fgULg6rDHYYzyeok4yM5S7fvE8YoNLQtFCDiD0/oeTCV7rhCquwZdggxLT+uN3jD
         Woeawq7EiIVES6h6r4JxWXUAEgMWfe9nm8+QCHAA=
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.dlink.ru
X-Spam-Level: 
X-Spam-Status: No, score=-99.2 required=7.5 tests=BAYES_50,URIBL_BLOCKED,
        USER_IN_WHITELIST autolearn=disabled version=3.4.2
Received: from mail.rzn.dlink.ru (mail.rzn.dlink.ru [178.170.168.13])
        by fd.dlink.ru (Postfix) with ESMTP id AD4161B20265;
        Mon, 20 Jan 2020 12:44:46 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 fd.dlink.ru AD4161B20265
Received: from mail.rzn.dlink.ru (localhost [127.0.0.1])
        by mail.rzn.dlink.ru (Postfix) with ESMTP id 7435F1B2265F;
        Mon, 20 Jan 2020 12:44:46 +0300 (MSK)
Received: from mail.rzn.dlink.ru (localhost [127.0.0.1])
        by mail.rzn.dlink.ru (Postfix) with ESMTPA;
        Mon, 20 Jan 2020 12:44:46 +0300 (MSK)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Mon, 20 Jan 2020 12:44:46 +0300
From:   Alexander Lobakin <alobakin@dlink.ru>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     ecree@solarflare.com, Maxim Mikityanskiy <maximmi@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>, edumazet@google.com,
        netdev@vger.kernel.org, davem@davemloft.net,
        Tariq Toukan <tariqt@mellanox.com>
Subject: Re: [PATCH net] net: Fix packet reordering caused by GRO and
 listified RX cooperation
In-Reply-To: <da13831f11d0141728a96954685fdf40@dlink.ru>
References: <20200117150913.29302-1-maximmi@mellanox.com>
 <7939223efeb4ed9523a802702874be9b8f37f231.camel@mellanox.com>
 <da13831f11d0141728a96954685fdf40@dlink.ru>
User-Agent: Roundcube Webmail/1.4.0
Message-ID: <5b0519b8640f9f270a9570720986eee7@dlink.ru>
X-Sender: alobakin@dlink.ru
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hey al,

Alexander Lobakin wrote 18.01.2020 13:05:
> Hi Saeed,
> 
> Saeed Mahameed wrote 18.01.2020 01:47:
>> On Fri, 2020-01-17 at 15:09 +0000, Maxim Mikityanskiy wrote:
>>> Commit 6570bc79c0df ("net: core: use listified Rx for GRO_NORMAL in
>>> napi_gro_receive()") introduces batching of GRO_NORMAL packets in
>>> napi_skb_finish. However, dev_gro_receive, that is called just before
>>> napi_skb_finish, can also pass skbs to the networking stack: e.g.,
>>> when
>>> the GRO session is flushed, napi_gro_complete is called, which passes
>>> pp
>>> directly to netif_receive_skb_internal, skipping napi->rx_list. It
>>> means
>>> that the packet stored in pp will be handled by the stack earlier
>>> than
>>> the packets that arrived before, but are still waiting in napi-
>>> >rx_list.
>>> It leads to TCP reorderings that can be observed in the TCPOFOQueue
>>> counter in netstat.
>>> 
>>> This commit fixes the reordering issue by making napi_gro_complete
>>> also
>>> use napi->rx_list, so that all packets going through GRO will keep
>>> their
>>> order.
>>> 
>>> Fixes: 6570bc79c0df ("net: core: use listified Rx for GRO_NORMAL in
>>> napi_gro_receive()")
>>> Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
>>> Cc: Alexander Lobakin <alobakin@dlink.ru>
>>> Cc: Edward Cree <ecree@solarflare.com>
>>> ---
>>> Alexander and Edward, please verify the correctness of this patch. If
>>> it's necessary to pass that SKB to the networking stack right away, I
>>> can change this patch to flush napi->rx_list by calling
>>> gro_normal_list
>>> first, instead of putting the SKB in the list.
>>> 
>> 
>> actually this will break performance of traffic that needs to skip
>> gro.. and we will loose bulking, so don't do it :)
>> 
>> But your point is valid when napi_gro_complete() is called outside of
>> napi_gro_receive() path.
>> 
>> see below..
>> 
>>>  net/core/dev.c | 55 +++++++++++++++++++++++++-----------------------
>>> --
>>>  1 file changed, 28 insertions(+), 27 deletions(-)
>>> 
>>> diff --git a/net/core/dev.c b/net/core/dev.c
>>> index 0ad39c87b7fd..db7a105bbc77 100644
>>> --- a/net/core/dev.c
>>> +++ b/net/core/dev.c
>>> @@ -5491,9 +5491,29 @@ static void flush_all_backlogs(void)
>>>  	put_online_cpus();
>>>  }
>>> 
>>> +/* Pass the currently batched GRO_NORMAL SKBs up to the stack. */
>>> +static void gro_normal_list(struct napi_struct *napi)
>>> +{
>>> +	if (!napi->rx_count)
>>> +		return;
>>> +	netif_receive_skb_list_internal(&napi->rx_list);
>>> +	INIT_LIST_HEAD(&napi->rx_list);
>>> +	napi->rx_count = 0;
>>> +}
>>> +
>>> +/* Queue one GRO_NORMAL SKB up for list processing. If batch size
>>> exceeded,
>>> + * pass the whole batch up to the stack.
>>> + */
>>> +static void gro_normal_one(struct napi_struct *napi, struct sk_buff
>>> *skb)
>>> +{
>>> +	list_add_tail(&skb->list, &napi->rx_list);
>>> +	if (++napi->rx_count >= gro_normal_batch)
>>> +		gro_normal_list(napi);
>>> +}
>>> +
>>>  INDIRECT_CALLABLE_DECLARE(int inet_gro_complete(struct sk_buff *,
>>> int));
>>>  INDIRECT_CALLABLE_DECLARE(int ipv6_gro_complete(struct sk_buff *,
>>> int));
>>> -static int napi_gro_complete(struct sk_buff *skb)
>>> +static int napi_gro_complete(struct napi_struct *napi, struct
>>> sk_buff *skb)
>>>  {
>>>  	struct packet_offload *ptype;
>>>  	__be16 type = skb->protocol;
>>> @@ -5526,7 +5546,8 @@ static int napi_gro_complete(struct sk_buff
>>> *skb)
>>>  	}
>>> 
>>>  out:
>>> -	return netif_receive_skb_internal(skb);
>>> +	gro_normal_one(napi, skb);
>>> +	return NET_RX_SUCCESS;
>>>  }
>>> 
>> 
>> The patch looks fine when napi_gro_complete() is called form
>> napi_gro_receive() path.
>> 
>> But napi_gro_complete() is also used by napi_gro_flush() which is
>> called in other contexts, which might break, if they really meant to
>> flush to the stack..
>> 
>> examples:
>> 1. drives that use napi_gro_flush() which is not "eventually" followed
>> by napi_complete_done(), might break.. possible bug in those drivers
>> though. drivers must always return with napi_complete_done();
> 
> Drivers *should not* use napi_gro_flush() by themselves. This was
> discussed several times here and at the moment me and Edward are
> waiting for proper NAPI usage in iwlwifi driver to unexport this
> one and make it static.
> 
>> 2. the following code in napi_complete_done()
>> 
>> /* When the NAPI instance uses a timeout and keeps postponing
>>  * it, we need to bound somehow the time packets are kept in
>>  * the GRO layer
>>  */
>>   napi_gro_flush(n, !!timeout);
>> 
>> with the new implementation we won't really flush to the stack unless
> 
> Oh, I got this one. This is really an issue. gro_normal_list() is
> called earlier than napi_gro_flush() in napi_complete_done(), so
> several skbs might stuck in napi->rx_list until next NAPI session.
> Thanks for pointing this out, I missed it.
> 
>> one possible solution: is to call gro_normal_list(napi); inside:
>> napi_gro_flush() ?
>> 
>> another possible solution:
>> allays make sure to follow napi_gro_flush(); with gro_normal_list(n);
>> 
>> since i see two places in dev.c where we do:
>> 
>> gro_normal_list(n);
>> if (cond) {
>>    napi_gro_flush();
>> }
>> 
>> instead, we can change them to:
>> 
>> if (cond) {
>>    /* flush gro to napi->rx_list, with your implementation  */
>>    napi_gro_flush();
>> }
>> gro_normal_list(n); /* Now flush to the stack */
>> 
>> And your implementation will be correct for such use cases.
> 
> I think this one would be more straightforward and correct.
> But this needs tests for sure. I could do them only Monday, 20
> unfortunately.

I've done all necessary tests as promised, and here are the results.

BTW, my driver uses napi_gro_frags(), but this doesn't make any sense.
Lots of TCP retransmissions come from the fact that my Ethernet
controller is behind DSA switch, so I unavoidably hit several
unlikely() conditions -> 100% branch misses (which are pretty critical
on MIPS)on Rx path.
These results do not represent the full picture and are actual only
for particular setup, of course.

I. Without patch (_net/core/dev.c_ at 5.5-rc6 state)

One flow:

[ ID] Interval           Transfer     Bitrate         Retr
[  5]   0.00-120.00 sec  11.6 GBytes   831 Mbits/sec  335     sender
[  5]   0.00-120.07 sec  11.6 GBytes   831 Mbits/sec          receiver

10 flows:

[ ID] Interval           Transfer     Bitrate         Retr
[SUM]   0.00-503.29 sec  50.0 GBytes   855 Mbits/sec  34314   sender
[SUM]   0.00-503.56 sec  50.0 GBytes   854 Mbits/sec          receiver

II. With Maxim's patch (no changes)

One flow:

[ ID] Interval           Transfer     Bitrate         Retr
[  5]   0.00-120.00 sec  12.1 GBytes   867 Mbits/sec  177     sender
[  5]   0.00-120.07 sec  12.1 GBytes   867 Mbits/sec          receiver

10 flows:

[ ID] Interval           Transfer     Bitrate         Retr
[SUM]   0.00-500.71 sec  50.0 GBytes   864 Mbits/sec  13571   sender
[SUM]   0.00-501.01 sec  50.0 GBytes   863 Mbits/sec          receiver

III. Patch + gro_normal_list() at the end of napi_gro_complete()

One flow:

[ ID] Interval           Transfer     Bitrate         Retr
[  5]   0.00-120.00 sec  11.7 GBytes   840 Mbits/sec  282     sender
[  5]   0.00-120.06 sec  11.7 GBytes   839 Mbits/sec          receiver

10 flows:

[SUM]   0.00-517.55 sec  50.0 GBytes   831 Mbits/sec  35261   sender
[SUM]   0.00-517.61 sec  50.0 GBytes   830 Mbits/sec          receiver

Yes, we lose batching a lot, this variant does not seem to be the
optimal one.

IV. Patch + gro_normal_list() is placed after napi_gro_flush()

One flow:

[ ID] Interval           Transfer     Bitrate         Retr
[  5]   0.00-120.00 sec  12.3 GBytes   881 Mbits/sec  104     sender
[  5]   0.00-120.01 sec  12.3 GBytes   881 Mbits/sec          receiver

10 flows:

[ ID] Interval           Transfer     Bitrate         Retr
[SUM]   0.00-500.21 sec  50.0 GBytes   865 Mbits/sec  11340   sender
[SUM]   0.00-500.22 sec  50.0 GBytes   865 Mbits/sec          receiver

The best results so far.

So, my personal recommendations match Saeed's solution

> another possible solution:
> allays make sure to follow napi_gro_flush(); with gro_normal_list(n);

i.e. to swap

gro_normal_list(n);

and

if (n->gro_bitmask) {
	[...]
	napi_gro_flush(n, ...);
	[...]
}

in both napi_complete_done() and napi_poll() as the napi->rx_list
flushing should be performed after all GRO processing. This way
we'll avoid both packets reordering and their stalling in rx_list.

Note that this change also requires a minimal change in iwlwifi
driver as for now it comes with its own open-coded
napi_complete_done().

The rest of patch is fully OK to me.
Still need Edward's review.

> Or we can call gro_normal_list() directly in napi_gro_complete()
> as Maxim proposed as alternative solution.
> I'd like to see what Edward thinks about it. But this one really
> needs to be handled either way.
> 
>>>  static void __napi_gro_flush_chain(struct napi_struct *napi, u32
>>> index,
>>> @@ -5539,7 +5560,7 @@ static void __napi_gro_flush_chain(struct
>>> napi_struct *napi, u32 index,
>>>  		if (flush_old && NAPI_GRO_CB(skb)->age == jiffies)
>>>  			return;
>>>  		skb_list_del_init(skb);
>>> -		napi_gro_complete(skb);
>>> +		napi_gro_complete(napi, skb);
>>>  		napi->gro_hash[index].count--;
>>>  	}
>>> 
>>> @@ -5641,7 +5662,7 @@ static void gro_pull_from_frag0(struct sk_buff
>>> *skb, int grow)
>>>  	}
>>>  }
>>> 
>>> -static void gro_flush_oldest(struct list_head *head)
>>> +static void gro_flush_oldest(struct napi_struct *napi, struct
>>> list_head *head)
>>>  {
>>>  	struct sk_buff *oldest;
>>> 
>>> @@ -5657,7 +5678,7 @@ static void gro_flush_oldest(struct list_head
>>> *head)
>>>  	 * SKB to the chain.
>>>  	 */
>>>  	skb_list_del_init(oldest);
>>> -	napi_gro_complete(oldest);
>>> +	napi_gro_complete(napi, oldest);
>>>  }
>>> 
>>>  INDIRECT_CALLABLE_DECLARE(struct sk_buff *inet_gro_receive(struct
>>> list_head *,
>>> @@ -5733,7 +5754,7 @@ static enum gro_result dev_gro_receive(struct
>>> napi_struct *napi, struct sk_buff
>>> 
>>>  	if (pp) {
>>>  		skb_list_del_init(pp);
>>> -		napi_gro_complete(pp);
>>> +		napi_gro_complete(napi, pp);
>>>  		napi->gro_hash[hash].count--;
>>>  	}
>>> 
>>> @@ -5744,7 +5765,7 @@ static enum gro_result dev_gro_receive(struct
>>> napi_struct *napi, struct sk_buff
>>>  		goto normal;
>>> 
>>>  	if (unlikely(napi->gro_hash[hash].count >= MAX_GRO_SKBS)) {
>>> -		gro_flush_oldest(gro_head);
>>> +		gro_flush_oldest(napi, gro_head);
>>>  	} else {
>>>  		napi->gro_hash[hash].count++;
>>>  	}
>>> @@ -5802,26 +5823,6 @@ struct packet_offload
>>> *gro_find_complete_by_type(__be16 type)
>>>  }
>>>  EXPORT_SYMBOL(gro_find_complete_by_type);
>>> 
>>> -/* Pass the currently batched GRO_NORMAL SKBs up to the stack. */
>>> -static void gro_normal_list(struct napi_struct *napi)
>>> -{
>>> -	if (!napi->rx_count)
>>> -		return;
>>> -	netif_receive_skb_list_internal(&napi->rx_list);
>>> -	INIT_LIST_HEAD(&napi->rx_list);
>>> -	napi->rx_count = 0;
>>> -}
>>> -
>>> -/* Queue one GRO_NORMAL SKB up for list processing. If batch size
>>> exceeded,
>>> - * pass the whole batch up to the stack.
>>> - */
>>> -static void gro_normal_one(struct napi_struct *napi, struct sk_buff
>>> *skb)
>>> -{
>>> -	list_add_tail(&skb->list, &napi->rx_list);
>>> -	if (++napi->rx_count >= gro_normal_batch)
>>> -		gro_normal_list(napi);
>>> -}
>>> -
>>>  static void napi_skb_free_stolen_head(struct sk_buff *skb)
>>>  {
>>>  	skb_dst_drop(skb);
> 
> Regards,
> ᚷ ᛖ ᚢ ᚦ ᚠ ᚱ

Regards,
ᚷ ᛖ ᚢ ᚦ ᚠ ᚱ
