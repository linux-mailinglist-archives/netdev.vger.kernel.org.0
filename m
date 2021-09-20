Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 871F0412854
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 23:43:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240269AbhITVo5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 17:44:57 -0400
Received: from relay.sw.ru ([185.231.240.75]:36772 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233543AbhITVmo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Sep 2021 17:42:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Date:Message-ID:From:
        Subject; bh=8rK8W2Vd3scYVv5BGnvaNbmY0E+bS3ovyAG03FyVVFk=; b=VDI8fnQ5XIs1uERh1
        QxMeLIz7QqR9aU30cY27PhxxTb0B+W+3AORPbmQv1bXiaNvwb1kXzNfHh5aK1Pdr0SsrYKHYh1oaq
        VshclcZ0VW0KocPbX76JilZFpEWWFrVrCPVADkRUQyk+5taJ6/hR9zxVhkgVT0RpS3S7aQdY6wono
        =;
Received: from [10.93.0.56]
        by relay.sw.ru with esmtp (Exim 4.94.2)
        (envelope-from <vvs@virtuozzo.com>)
        id 1mSR2J-002eA0-GC; Tue, 21 Sep 2021 00:41:15 +0300
Subject: Re: [RFC net v7] net: skb_expand_head() adjust skb->truesize
 incorrectly
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     eric.dumazet@gmail.com, netdev@vger.kernel.org,
        Christoph Paasch <christoph.paasch@gmail.com>,
        Hao Sun <sunhao.th@gmail.com>
References: <20210917162418.1437772-1-kuba@kernel.org>
 <b38881fc-7dbf-8c5f-92b8-5fa1afaade0c@virtuozzo.com>
 <20210920111259.18f9cc01@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Vasily Averin <vvs@virtuozzo.com>
Message-ID: <c4d204a5-f3f1-e505-4206-26dfd1c097f1@virtuozzo.com>
Date:   Tue, 21 Sep 2021 00:41:15 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210920111259.18f9cc01@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/20/21 9:12 PM, Jakub Kicinski wrote:
> On Sat, 18 Sep 2021 13:05:28 +0300 Vasily Averin wrote:
>> On 9/17/21 7:24 PM, Jakub Kicinski wrote:
>>> From: Vasily Averin <vvs@virtuozzo.com>
>>>
>>> Christoph Paasch reports [1] about incorrect skb->truesize
>>> after skb_expand_head() call in ip6_xmit.
>>> This may happen because of two reasons:
>>>  - skb_set_owner_w() for newly cloned skb is called too early,
>>>    before pskb_expand_head() where truesize is adjusted for (!skb-sk) case.
>>>  - pskb_expand_head() does not adjust truesize in (skb->sk) case.
>>>    In this case sk->sk_wmem_alloc should be adjusted too.
>>>
>>> Eric cautions us against increasing sk_wmem_alloc if the old
>>> skb did not hold any wmem references.
> 
>>> @@ -1810,21 +1829,28 @@ struct sk_buff *skb_expand_head(struct sk_buff *skb, unsigned int headroom)
>>>  	if (skb_shared(skb)) {
>>>  		struct sk_buff *nskb = skb_clone(skb, GFP_ATOMIC);
>>>  
>>> -		if (likely(nskb)) {
>>> -			if (skb->sk)
>>> -				skb_set_owner_w(nskb, skb->sk);
>>> -			consume_skb(skb);
>>> -		} else {
>>> -			kfree_skb(skb);
>>> -		}
>>> +		if (unlikely(!nskb))
>>> +			goto err_free;
>>> +
>>> +		skb_owner_inherit(nskb, skb);
>>> +		consume_skb(skb);
>>>  		skb = nskb;
>>>  	}
>>> -	if (skb &&
>>> -	    pskb_expand_head(skb, SKB_DATA_ALIGN(delta), 0, GFP_ATOMIC)) {
>>> -		kfree_skb(skb);
>>> -		skb = NULL;
>>> -	}
>>> +
>>> +	if (pskb_expand_head(skb, SKB_DATA_ALIGN(delta), 0, GFP_ATOMIC))
>>> +		goto err_free;
>>> +	delta = skb_end_offset(skb) - osize;
>>> +
>>> +	/* pskb_expand_head() will adjust truesize itself for non-sk cases
>>> +	 * todo: move the adjustment there at some point?
>>> +	 */
>>> +	if (skb->sk && skb->destructor != sock_edemux)
>>> +		skb_increase_truesize(skb, delta);  
>>
>> I think it is wrong.
>> 1) there are a few skb destructors called sock_wfree inside. I've found: 
>>    tpacket_destruct_skb, sctp_wfree, unix_destruct_scm and xsk_destruct_skb.
>>    If any such skb can be use here it will not adjust sk_wmem_alloc.   I afraid there might be other similar destructors, out of tree,
>>    so we cannot have full white list for wfree-compatible destructors.
>>
>> 2) in fact you increase truesize here for all skb types.
>>    If it is acceptable it could be done directly inside pskb_expand_head().
>>    However it isn't.  As you pointed sock_rfree case is handled incorrectly. 
>>    I've found other similar destructors: sock_rmem_free, netlink_skb_destructor,
>>    kcm_rfree, sock_ofree. They will be handled incorrectly too, but even without WARN_ON.
>>    Few other descriptors seems should not fail but do not require truesize update.
>>
>> From my POV v6 patch version works correctly in any cases. If necessary it calls
>> original destructor, correctly set up new one and correctly adjust truesize
>> and sk_wmem_alloc.
>> If you still have doubts, we can just go back and clone non-wmem skb, 
>> like we did before.
> 
> Thanks for taking a look. I would prefer not to bake any ideas about
> the skb's function into generic functions. Enumerating every destructor
> callback in generic code is impossible (technically so, since the code
> may reside in modules).
> 
> Let me think about it. Perhaps we can extend sock callbacks with
> skb_sock_inherit, and skb_adjust_trusize? That'd transfer the onus of
> handling the adjustments done on splitting to the protocols. I'll see
> if that's feasible unless someone can immediately call this path
> ghastly.

This is similar to Alexey Kuznetsov's suggestion for me, 
see https://lkml.org/lkml/2021/8/27/460

However I think we can do it later,
right now we need to fix somehow broken skb_expand_head(),
please take look at v8.

Thank you,
	Vasily Averin
