Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00C613FE9D3
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 09:13:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242885AbhIBHOj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 03:14:39 -0400
Received: from relay.sw.ru ([185.231.240.75]:41040 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233363AbhIBHOi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Sep 2021 03:14:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Date:Message-ID:From:
        Subject; bh=jcxB9UZFDlTKnN6RO3VLRHt6sc+pufmSIvofaIuTdIM=; b=Z+Cg/Kwu6zgpcbGu5
        Nr3tsqTQTBrG8tZ1J+aj8ISSz8iOZw7jq2U55gSnFZy2DK39jSLX3EC1quge/gHNEi2flMx7TwFin
        Yraf7fdUctizqCDDsplHe0517wzVI9pvR+x5oMgGmmdm842KNgCGb6wtPxOeS9KnvyBuxf/QIqpPY
        =;
Received: from [10.93.0.56]
        by relay.sw.ru with esmtp (Exim 4.94.2)
        (envelope-from <vvs@virtuozzo.com>)
        id 1mLgug-000YI2-TL; Thu, 02 Sep 2021 10:13:30 +0300
Subject: Re: [PATCH net-next v4] skb_expand_head() adjust skb->truesize
 incorrectly
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        Christoph Paasch <christoph.paasch@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org,
        kernel@openvz.org, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Julian Wiedmann <jwi@linux.ibm.com>
References: <b653692b-1550-e17a-6c51-894832c56065@virtuozzo.com>
 <ee5b763a-c39d-80fd-3dd4-bca159b5f5ac@virtuozzo.com>
 <ce783b33-c81f-4760-1f9e-90b7d8c51fd7@gmail.com>
 <b7c2cb05-7307-f04e-530e-89fc466aa83f@virtuozzo.com>
 <ef7ccff8-700b-79c2-9a82-199b9ed3d95b@gmail.com>
 <67740366-7f1b-c953-dfe1-d2085297bdf3@gmail.com>
From:   Vasily Averin <vvs@virtuozzo.com>
Message-ID: <8a183782-f4b9-e12a-55d1-c4a3c4078369@virtuozzo.com>
Date:   Thu, 2 Sep 2021 10:13:29 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <67740366-7f1b-c953-dfe1-d2085297bdf3@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/2/21 7:48 AM, Eric Dumazet wrote:
> On 9/1/21 9:32 PM, Eric Dumazet wrote:
>> I think you missed netem case, in particular
>> skb_orphan_partial() which I already pointed out.
>>
>> You can setup a stack of virtual devices (tunnels),
>> with a qdisc on them, before ip6_xmit() is finally called...
>>
>> Socket might have been closed already.
>>
>> To test your patch, you could force a skb_orphan_partial() at the beginning
>> of skb_expand_head() (extending code coverage)
> 
> To clarify :
> 
> It is ok to 'downgrade' an skb->destructor having a ref on sk->sk_wmem_alloc to
> something owning a ref on sk->refcnt.
> 
> But the opposite operation (ref on sk->sk_refcnt -->  ref on sk->sk_wmem_alloc) is not safe.

Could you please explain in more details, since I stil have a completely opposite point of view?

Every sk referenced in skb have sk_wmem_alloc > 9 
It is assigned to 1 in sk_alloc and decremented right before last __sk_free(),
inside  both sk_free() sock_wfree() and __sock_wfree()

So it is safe to adjust skb->sk->sk_wmem_alloc, 
because alive skb keeps reference to alive sk and last one keeps sk_wmem_alloc > 0

So any destructor used sk->sk_refcnt will already have sk_wmem_alloc > 0, 
because last sock_put() calls sk_free().

However now I'm not sure in reversed direction.
skb_set_owner_w() check !sk_fullsock(sk) and call sock_hold(sk);
If sk->sk_refcnt can be 0 here (i.e. after execution of old destructor inside skb_orphan) 
-- it can be trigger pointed problem:
"refcount_add() will trigger a warning (panic under KASAN)".

Could you please explain where I'm wrong?

Thank you,
	Vasily Averin
