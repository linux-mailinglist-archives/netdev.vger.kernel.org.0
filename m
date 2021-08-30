Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 922A73FBC8F
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 20:37:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230411AbhH3SiE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 14:38:04 -0400
Received: from relay.sw.ru ([185.231.240.75]:50372 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230181AbhH3SiD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Aug 2021 14:38:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Date:Message-ID:From:
        Subject; bh=rNuHlF2j1NdIZb3G7lOsUUlHYfgunpEcyXX5fsl0zKY=; b=b6zPa7Hm4m2J9zvFy
        kTsItz53p81tC193jsgr7lWHuMqISSpM7sdViYR1ieW68RjycKVTJq63e6Vbad0ftBzRY0SOfr2qE
        kDEm2BSjZ65v624eUGMnUN8ynqPgER+u7Wr+ikUykh35SY/H8u+1YCHLLgz6M6/cy13B6znB6tf8g
        =;
Received: from [10.93.0.56]
        by relay.sw.ru with esmtp (Exim 4.94.2)
        (envelope-from <vvs@virtuozzo.com>)
        id 1mKm9Z-000FoC-L8; Mon, 30 Aug 2021 21:37:05 +0300
Subject: Re: [PATCH v2] skb_expand_head() adjust skb->truesize incorrectly
From:   Vasily Averin <vvs@virtuozzo.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        Christoph Paasch <christoph.paasch@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org,
        kernel@openvz.org, Julian Wiedmann <jwi@linux.ibm.com>
References: <CALMXkpZYGC5HNkJAi4wCuawC-9CVNjN1LqO073YJvUF5ONwupA@mail.gmail.com>
 <860513d5-fd02-832b-1c4c-ea2b17477d76@virtuozzo.com>
 <9f0c5e45-ad79-a9ea-dab1-aeb3bc3730ae@gmail.com>
 <c4373bb7-bb4f-2895-c692-e61a1a89e21f@virtuozzo.com>
Message-ID: <7d13bd9a-9597-74b2-1c9e-5fb7f8c0678a@virtuozzo.com>
Date:   Mon, 30 Aug 2021 21:37:04 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <c4373bb7-bb4f-2895-c692-e61a1a89e21f@virtuozzo.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/30/21 9:09 PM, Vasily Averin wrote:
> On 8/30/21 7:01 PM, Eric Dumazet wrote:
>> On 8/29/21 5:59 AM, Vasily Averin wrote:
>>> Christoph Paasch reports [1] about incorrect skb->truesize
>>> after skb_expand_head() call in ip6_xmit.
>>> This may happen because of two reasons:
>>> - skb_set_owner_w() for newly cloned skb is called too early,
>>> before pskb_expand_head() where truesize is adjusted for (!skb-sk) case.
>>> - pskb_expand_head() does not adjust truesize in (skb->sk) case.
>>> In this case sk->sk_wmem_alloc should be adjusted too.
>>>
>>> [1] https://lkml.org/lkml/2021/8/20/1082
>>> @@ -1756,9 +1756,13 @@ int pskb_expand_head(struct sk_buff *skb, int nhead, int ntail,
>>>  	 * For the moment, we really care of rx path, or
>>>  	 * when skb is orphaned (not attached to a socket).
>>>  	 */
>>> -	if (!skb->sk || skb->destructor == sock_edemux)
>>> -		skb->truesize += size - osize;
>>> -
>>> +	delta = size - osize;
>>> +	if (!skb->sk || skb->destructor == sock_edemux) {
>>> +		skb->truesize += delta;
>>> +	} else if (update_truesize) {
>>
>> Unfortunately we can not always do this sk_wmem_alloc change here.
>>
>> Some skb have skb->sk set, but the 'reference on socket' is not through sk_wmem_alloc
> 
> Could you please provide some example?
> In past in all handeled cases we have cloned original skb and then unconditionally assigned skb sock_wfree destructor.
> Do you want to say that it worked correctly somehow?
> 
> I expected if we set sock_wfree, we have guarantee that old skb adjusted sk_wmem_alloc.
> Am I wrong?
> Could you please point on such case?

However if it is true -- it is not enough to adjust sk_wmem_alloc for proper destructors,
because another destructors may require to do something else.
In this case I can check destructor first and clone skb before pskb_expand_head() call,
like it was happen before.

>> It seems you need a helper to make sure skb->destructor is one of
>> the destructors that use skb->truesize and sk->sk_wmem_alloc
>>
>> For instance, skb_orphan_partial() could have been used.
> 
> Thank you, will investigate.
> 	Vasily Averin
> 

