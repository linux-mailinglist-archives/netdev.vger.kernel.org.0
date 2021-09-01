Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E4B53FD3BA
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 08:20:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242263AbhIAGVf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 02:21:35 -0400
Received: from relay.sw.ru ([185.231.240.75]:41322 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242071AbhIAGVe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Sep 2021 02:21:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Date:Message-ID:From:
        Subject; bh=CMn1n/Dh7ekMa8GdsiwO8//8ZOlUAm/ndqbU97gmQrE=; b=TfISTGvLL9l2i0BUL
        sWUB5ThmJHilTO/IVkK3C72J4BJVljG2C6JpxX3J7dtHiLut1cG06OgdPHSOTMX5aP3UbPepCHlQe
        sMYjjZ4sCuf1fQfzQQRA6l9jmAXyAzW5Bvuv/vSL8c0jwcLC6ts+J62x2scs2zP5czjYIzVWqpsS8
        =;
Received: from [10.93.0.56]
        by relay.sw.ru with esmtp (Exim 4.94.2)
        (envelope-from <vvs@virtuozzo.com>)
        id 1mLJbo-000R9a-Rw; Wed, 01 Sep 2021 09:20:28 +0300
Subject: Re: [PATCH net-next v3 RFC] skb_expand_head() adjust skb->truesize
 incorrectly
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        Christoph Paasch <christoph.paasch@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org,
        kernel@openvz.org, Julian Wiedmann <jwi@linux.ibm.com>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
References: <8fd56805-2ac8-dcbe-1337-b20f91f759d6@gmail.com>
 <b66d9db6-f0ac-48a9-8062-49d6a5249d4b@virtuozzo.com>
 <f4bbce90-f31f-b844-0087-c9d72db06471@gmail.com>
From:   Vasily Averin <vvs@virtuozzo.com>
Message-ID: <b653692b-1550-e17a-6c51-894832c56065@virtuozzo.com>
Date:   Wed, 1 Sep 2021 09:20:27 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <f4bbce90-f31f-b844-0087-c9d72db06471@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/31/21 10:38 PM, Eric Dumazet wrote:
> On 8/31/21 7:34 AM, Vasily Averin wrote:
>> RFC because it have an extra changes:
>> new is_skb_wmem() helper can be called
>>  - either before pskb_expand_head(), to create skb clones 
>>     for skb with destructors that does not change sk->sk_wmem_alloc
>>  - or after pskb_expand_head(), to change owner in skb_set_owner_w()
>>
>> In current patch I've added both these ways,
>> we need to keep one of them.

If nobody object I vote for 2nd way:

>> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
>> index f931176..3ce33f2 100644
>> --- a/net/core/skbuff.c
>> +++ b/net/core/skbuff.c
>> @@ -1804,30 +1804,47 @@ struct sk_buff *skb_realloc_headroom(struct sk_buff *skb, unsigned int headroom)
>>  struct sk_buff *skb_expand_head(struct sk_buff *skb, unsigned int headroom)
>>  {
... skipped ...
>> -	return skb;
>> +	if (oskb) {
>> +		if (sk)
>> +			skb_set_owner_w(skb, sk);
> 
> Broken for non full sockets.
> Calling skb_set_owner_w(skb, sk) for them is a bug.

I think you're wrong here.
It is 100% equivalent of old code, 
skb_set_owner_w() handles sk_fullsock(sk) inside and does not adjust sk->sk_wmem_alloc.
Please explain if I'm wrong.

>> +		consume_skb(oskb);
>> +	} else if (sk) {
>> +		delta = osize - skb_end_offset(skb);
>> +		if (!is_skb_wmem(skb))
>> +			skb_set_owner_w(skb, sk);
> 
> This would be broken for non full sockets.
> Calling skb_set_owner_w(skb, sk) for them is a bug.
See my comment above.

>> +		skb->truesize += delta;
>> +		if (sk_fullsock(sk))
>> +			refcount_add(delta, &sk->sk_wmem_alloc);
> 
> 
>> +	}	return skb;
Strange line, will fix it.

>>  }
>>  EXPORT_SYMBOL(skb_expand_head);
