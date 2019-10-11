Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98FE6D39FE
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 09:26:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727471AbfJKH0i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 03:26:38 -0400
Received: from fd.dlink.ru ([178.170.168.18]:45558 "EHLO fd.dlink.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726679AbfJKH0i (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Oct 2019 03:26:38 -0400
Received: by fd.dlink.ru (Postfix, from userid 5000)
        id 078D31B219E5; Fri, 11 Oct 2019 10:26:36 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 fd.dlink.ru 078D31B219E5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dlink.ru; s=mail;
        t=1570778796; bh=dOAAmZ8hjSoImka9riHogX7F0mjdr4LsS8gu4vN8Q+E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References;
        b=eC1VKdI0CIfK20AIvg3zUMydFtaRLCQ9SiSDSYK30/YYpdbbrFxzHEpdqjrpAQXEX
         ewvEBaClc23mzWj+q3pXjvadx5ne/6XlHPAon0OBErf2lidTmzJKVBNBxAPIcKd5IA
         NmsXvXEAK0jdF1C333CI79lJ8oryNuHz3fuBv6SY=
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on mail.dlink.ru
X-Spam-Level: 
X-Spam-Status: No, score=-99.2 required=7.5 tests=BAYES_50,URIBL_BLOCKED,
        USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from mail.rzn.dlink.ru (mail.rzn.dlink.ru [178.170.168.13])
        by fd.dlink.ru (Postfix) with ESMTP id D5F141B219E0;
        Fri, 11 Oct 2019 10:26:32 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 fd.dlink.ru D5F141B219E0
Received: by mail.rzn.dlink.ru (Postfix, from userid 5000)
        id C2B1B1B2192D; Fri, 11 Oct 2019 10:26:32 +0300 (MSK)
Received: from mail.rzn.dlink.ru (localhost [127.0.0.1])
        by mail.rzn.dlink.ru (Postfix) with ESMTPA id 156C41B2023E;
        Fri, 11 Oct 2019 10:26:25 +0300 (MSK)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Fri, 11 Oct 2019 10:26:25 +0300
From:   Alexander Lobakin <alobakin@dlink.ru>
To:     Edward Cree <ecree@solarflare.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>,
        Eric Dumazet <edumazet@google.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Petr Machata <petrm@mellanox.com>,
        Sabrina Dubroca <sd@queasysnail.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next1/2] net: core: use listified Rx for GRO_NORMAL in
 napi_gro_receive()
In-Reply-To: <bb454c3c-1d86-f81e-a03e-86f8de3e9822@solarflare.com>
References: <20191010144226.4115-1-alobakin@dlink.ru>
 <20191010144226.4115-2-alobakin@dlink.ru>
 <bb454c3c-1d86-f81e-a03e-86f8de3e9822@solarflare.com>
Message-ID: <e7eaf0a1d236dda43f5cd73887ecfb9d@dlink.ru>
X-Sender: alobakin@dlink.ru
User-Agent: Roundcube Webmail/1.3.6
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Edward Cree wrote 10.10.2019 21:23:
> On 10/10/2019 15:42, Alexander Lobakin wrote:
>> Commit 323ebb61e32b4 ("net: use listified RX for handling GRO_NORMAL
>> skbs") made use of listified skb processing for the users of
>> napi_gro_frags().
>> The same technique can be used in a way more common napi_gro_receive()
>> to speed up non-merged (GRO_NORMAL) skbs for a wide range of drivers,
>> including gro_cells and mac80211 users.
>> 
>> Signed-off-by: Alexander Lobakin <alobakin@dlink.ru>
>> ---
>>  net/core/dev.c | 49 +++++++++++++++++++++++++------------------------
>>  1 file changed, 25 insertions(+), 24 deletions(-)
>> 
>> diff --git a/net/core/dev.c b/net/core/dev.c
>> index 8bc3dce71fc0..a33f56b439ce 100644
>> --- a/net/core/dev.c
>> +++ b/net/core/dev.c
>> @@ -5884,6 +5884,26 @@ struct packet_offload 
>> *gro_find_complete_by_type(__be16 type)
>>  }
>>  EXPORT_SYMBOL(gro_find_complete_by_type);
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
>> +/* Queue one GRO_NORMAL SKB up for list processing.  If batch size 
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
>>  static void napi_skb_free_stolen_head(struct sk_buff *skb)
>>  {
>>  	skb_dst_drop(skb);
>> @@ -5891,12 +5911,13 @@ static void napi_skb_free_stolen_head(struct 
>> sk_buff *skb)
>>  	kmem_cache_free(skbuff_head_cache, skb);
>>  }
>> 
>> -static gro_result_t napi_skb_finish(gro_result_t ret, struct sk_buff 
>> *skb)
>> +static gro_result_t napi_skb_finish(struct napi_struct *napi,
>> +				    struct sk_buff *skb,
>> +				    gro_result_t ret)
> Any reason why the argument order here is changed around?

Actually yes: to match napi_skb_finish() and napi_frags_finish()
prototypes, as gro_normal one() required an addition of napi
argument anyway.

> 
> -Ed
>>  {
>>  	switch (ret) {
>>  	case GRO_NORMAL:
>> -		if (netif_receive_skb_internal(skb))
>> -			ret = GRO_DROP;
>> +		gro_normal_one(napi, skb);
>>  		break;
>> 
>>  	case GRO_DROP:
>> @@ -5928,7 +5949,7 @@ gro_result_t napi_gro_receive(struct napi_struct 
>> *napi, struct sk_buff *skb)
>> 
>>  	skb_gro_reset_offset(skb);
>> 
>> -	ret = napi_skb_finish(dev_gro_receive(napi, skb), skb);
>> +	ret = napi_skb_finish(napi, skb, dev_gro_receive(napi, skb));
>>  	trace_napi_gro_receive_exit(ret);
>> 
>>  	return ret;
>> @@ -5974,26 +5995,6 @@ struct sk_buff *napi_get_frags(struct 
>> napi_struct *napi)
>>  }
>>  EXPORT_SYMBOL(napi_get_frags);
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
>> -/* Queue one GRO_NORMAL SKB up for list processing.  If batch size 
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
>>  static gro_result_t napi_frags_finish(struct napi_struct *napi,
>>  				      struct sk_buff *skb,
>>  				      gro_result_t ret)

Regards,
ᚷ ᛖ ᚢ ᚦ ᚠ ᚱ
