Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0908A412EA9
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 08:36:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229788AbhIUGh7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 02:37:59 -0400
Received: from relay.sw.ru ([185.231.240.75]:44442 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229624AbhIUGh5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Sep 2021 02:37:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Date:Message-ID:From:
        Subject; bh=MSuTQJ+XQxWeuIZJRE3xX1lmPJnwKi6ysthqUZAK1Js=; b=FNowpGRcKINeeavHp
        DfvzWb1dF2TYIeWXPZsZgURzWaCBhHhxg3Fy9yP163pko6Tpx1zWahglJ3TpKr2gE6Fn+dEV5wLQE
        Enn/t8ibLcjIJJ0RTcaU5ljvsp3ZKS7kfLzEA35LwGpUSH1KWHPsy37yEjsbxhSG1NADzwJ+LM0DY
        =;
Received: from [10.93.0.56]
        by relay.sw.ru with esmtp (Exim 4.94.2)
        (envelope-from <vvs@virtuozzo.com>)
        id 1mSZOE-002fjh-Ua; Tue, 21 Sep 2021 09:36:26 +0300
Subject: Re: [RFC net v7] net: skb_expand_head() adjust skb->truesize
 incorrectly
To:     Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc:     netdev@vger.kernel.org,
        Christoph Paasch <christoph.paasch@gmail.com>,
        Hao Sun <sunhao.th@gmail.com>, kernel@openvz.org
References: <20210917162418.1437772-1-kuba@kernel.org>
 <b38881fc-7dbf-8c5f-92b8-5fa1afaade0c@virtuozzo.com>
 <20210920111259.18f9cc01@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <c4d204a5-f3f1-e505-4206-26dfd1c097f1@virtuozzo.com>
 <20210920173949.7e060848@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Vasily Averin <vvs@virtuozzo.com>
Message-ID: <5ed3cdb8-0a72-9dfb-ecdd-d59411f63653@virtuozzo.com>
Date:   Tue, 21 Sep 2021 09:36:26 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210920173949.7e060848@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/21/21 3:39 AM, Jakub Kicinski wrote:
> On Tue, 21 Sep 2021 00:41:15 +0300 Vasily Averin wrote:
>>> Thanks for taking a look. I would prefer not to bake any ideas about
>>> the skb's function into generic functions. Enumerating every destructor
>>> callback in generic code is impossible (technically so, since the code
>>> may reside in modules).
>>>
>>> Let me think about it. Perhaps we can extend sock callbacks with
>>> skb_sock_inherit, and skb_adjust_trusize? That'd transfer the onus of
>>> handling the adjustments done on splitting to the protocols. I'll see
>>> if that's feasible unless someone can immediately call this path
>>> ghastly.  
>>
>> This is similar to Alexey Kuznetsov's suggestion for me, 
>> see https://lkml.org/lkml/2021/8/27/460
> 
> Interesting, I wasn't thinking of keeping the ops pointer in every skb.
> 
>> However I think we can do it later,
>> right now we need to fix somehow broken skb_expand_head(),
>> please take look at v8.
> 
> I think v8 still has the issue that Eric was explaining over and over.

I've missed sock_edemux check, however I do not see any other issues.
Could you please explain what problem you talking about?

Eric said:
"it is not valid to call skb_set_owner_w(skb, sk) on all kind of sockets",
because socket might have been closed already.

Before the call we have old skb with sk reference, so sk is not closed yet
and have nonzero sk->sk_wmem_alloc.

During the call, skb_set_owner_w calls skb_orphan that calls old skb destructor.
Yes, it can decrement last sk reference and release the socket, 
and I think this is exactly the problem that Eric was pointing out: 
now sk access is unsafe.

However it can be prevented in at least 2 ways:
a) clone old skb and call skb_set_owner_w(nskb, sk) before skb_consume(oskb).
   In this case, skb_orphan does not call old destructor, because at this point
   nskb->sk = NULL and nskb->destructor = NULL, and sk reference is kept by oskb.  
   This is widely used in current code (ppp_xmit, ipip6_tunnel_xmit, 
   ip_vs_prepare_tunneled_skb and so on).
   This is used in v8 too.
b) Alternatively, extra refs on sk->sk_wmem_alloc and sk->sk_refcnt can be
   carefully taken before skb_set_owner_w() call. These references will not allow
   to release sk during old destructor's execution. 
   This was used in v6, and I think this should works correctly too. 

Could you please explain where I am wrong?
Do you talking about some other issue perhaps?

Thank you,
	Vasily Averin
