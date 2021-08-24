Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1070C3F668D
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 19:25:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240064AbhHXRZS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 13:25:18 -0400
Received: from relay.sw.ru ([185.231.240.75]:35480 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240567AbhHXRWi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Aug 2021 13:22:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Date:Message-ID:From:
        Subject; bh=8i1v+A0+fnakBZkFrRSDHnZZu3IYLEQL/+VJgmo3gnI=; b=tXNIpfw8Fj4uxBFmS
        UeFukxBW8iBp1qB7pFd2QtksSf3Tr2/lVNBFa7SO8N55CxNb2rnuVGTJNfcGHWHOogtql8pg+gm6L
        0AGylF7hl1N2+JsUgjc4DM/sXAlia3TqrKApSfAJmJfvLsr3SvOPSm54MRtqYvYMHhgPoSc/95iIY
        =;
Received: from [10.93.0.56]
        by relay.sw.ru with esmtp (Exim 4.94.2)
        (envelope-from <vvs@virtuozzo.com>)
        id 1mIa7M-008j7d-EG; Tue, 24 Aug 2021 20:21:44 +0300
Subject: Re: [PATCH NET-NEXT] ipv6: skb_expand_head() adjust skb->truesize
 incorrectly
From:   Vasily Averin <vvs@virtuozzo.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        Christoph Paasch <christoph.paasch@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, kernel@openvz.org,
        Julian Wiedmann <jwi@linux.ibm.com>
References: <6858f130-e6b4-1ba7-ed6f-58c00152be69@virtuozzo.com>
 <ef4458d9-c4d7-f419-00f2-0f1cea5140ce@virtuozzo.com>
 <CALMXkpZkW+ULMMFgeY=cag1F0=891F-v9NEVcdn7Tyd-VUWGYA@mail.gmail.com>
 <1c12b056-79d2-126a-3f78-64629f072345@gmail.com>
 <2d8a102a-d641-c6c1-b417-7a35efa4e5da@gmail.com>
 <bd90616e-8e86-016b-0979-c4f4167b8bc2@gmail.com>
 <4fe6edb4-a364-0e59-f902-9a362dd998d4@virtuozzo.com>
Message-ID: <61da35a1-e609-02d5-609d-5228e184e43f@virtuozzo.com>
Date:   Tue, 24 Aug 2021 20:21:43 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <4fe6edb4-a364-0e59-f902-9a362dd998d4@virtuozzo.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/24/21 11:50 AM, Vasily Averin wrote:
> On 8/24/21 1:23 AM, Eric Dumazet wrote:
>> On 8/23/21 2:51 PM, Eric Dumazet wrote:
>>> On 8/23/21 2:45 PM, Eric Dumazet wrote:
>>>> On 8/23/21 10:25 AM, Christoph Paasch wrote:
>>>>> Hello,
>>>>>
>>>>> On Mon, Aug 23, 2021 at 12:56 AM Vasily Averin <vvs@virtuozzo.com> wrote:
>>>>>>
>>>>>> Christoph Paasch reports [1] about incorrect skb->truesize
>>>>>> after skb_expand_head() call in ip6_xmit.
>>>>>> This happen because skb_set_owner_w() for newly clone skb is called
>>>>>> too early, before pskb_expand_head() where truesize is adjusted for
>>>>>> (!skb-sk) case.
>>>>>>
>>>>>> [1] https://lkml.org/lkml/2021/8/20/1082
>>>>>>
>>>>>> Reported-by: Christoph Paasch <christoph.paasch@gmail.com>
>>>>>> Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
>>>>>> ---
>>>>>>  net/core/skbuff.c | 24 +++++++++++++-----------
>>>>>>  1 file changed, 13 insertions(+), 11 deletions(-)
>>>>>>
>>>>>> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
>>>>>> index f931176..508d5c4 100644
>>>>>> --- a/net/core/skbuff.c
>>>>>> +++ b/net/core/skbuff.c
>>>>>> @@ -1803,6 +1803,8 @@ struct sk_buff *skb_realloc_headroom(struct sk_buff *skb, unsigned int headroom)
>>>>>>
>>>>>>  struct sk_buff *skb_expand_head(struct sk_buff *skb, unsigned int headroom)
>>>>>>  {
>>>>>> +       struct sk_buff *oskb = skb;
>>>>>> +       struct sk_buff *nskb = NULL;
>>>>>>         int delta = headroom - skb_headroom(skb);
>>>>>>
>>>>>>         if (WARN_ONCE(delta <= 0,
>>>>>> @@ -1811,21 +1813,21 @@ struct sk_buff *skb_expand_head(struct sk_buff *skb, unsigned int headroom)
>>>>>>
>>>>>>         /* pskb_expand_head() might crash, if skb is shared */
>>>>>>         if (skb_shared(skb)) {
>>>>>> -               struct sk_buff *nskb = skb_clone(skb, GFP_ATOMIC);
>>>>>> -
>>>>>> -               if (likely(nskb)) {
>>>>>> -                       if (skb->sk)
>>>>>> -                               skb_set_owner_w(nskb, skb->sk);
>>>>>> -                       consume_skb(skb);
>>>>>> -               } else {
>>>>>> -                       kfree_skb(skb);
>>>>>> -               }
>>>>>> +               nskb = skb_clone(skb, GFP_ATOMIC);
>>>>>>                 skb = nskb;
>>>>>>         }
>>>>>>         if (skb &&
>>>>>> -           pskb_expand_head(skb, SKB_DATA_ALIGN(delta), 0, GFP_ATOMIC)) {
>>>>>> -               kfree_skb(skb);
>>>>>> +           pskb_expand_head(skb, SKB_DATA_ALIGN(delta), 0, GFP_ATOMIC))
>>>>>>                 skb = NULL;
>>>>>> +
>>>>>> +       if (!skb) {
>>>>>> +               kfree_skb(oskb);
>>>>>> +               if (nskb)
>>>>>> +                       kfree_skb(nskb);
>>>>>> +       } else if (nskb) {
>>>>>> +               if (oskb->sk)
>>>>>> +                       skb_set_owner_w(nskb, oskb->sk);
>>>>>> +               consume_skb(oskb);
>>>>>
>>>>> sorry, this does not fix the problem. The syzkaller repro still
>>>>> triggers the WARN.
>>>>>
>>>>> When it happens, the skb in ip6_xmit() is not shared as it comes from
>>>>> __tcp_transmit_skb, where it is skb_clone()'d.
>>>>>
>>>>>
>>>>
>>>> Old code (in skb_realloc_headroom())
>>>> was first calling skb2 = skb_clone(skb, GFP_ATOMIC); 
>>>>
>>>> At this point, skb2->sk was NULL
>>>> So pskb_expand_head(skb2, SKB_DATA_ALIGN(delta), 0, ...) was able to tweak skb2->truesize
>>>>
>>>> I would try :
>>>>
>>>> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
>>>> index f9311762cc475bd38d87c33e988d7c983b902e56..326749a8938637b044a616cc33b6a19ed191ac41 100644
>>>> --- a/net/core/skbuff.c
>>>> +++ b/net/core/skbuff.c
>>>> @@ -1804,6 +1804,7 @@ EXPORT_SYMBOL(skb_realloc_headroom);
>>>>  struct sk_buff *skb_expand_head(struct sk_buff *skb, unsigned int headroom)
>>>>  {
>>>>         int delta = headroom - skb_headroom(skb);
>>>> +       struct sk_buff *oskb = NULL;
>>>>  
>>>>         if (WARN_ONCE(delta <= 0,
>>>>                       "%s is expecting an increase in the headroom", __func__))
>>>> @@ -1813,19 +1814,21 @@ struct sk_buff *skb_expand_head(struct sk_buff *skb, unsigned int headroom)
>>>>         if (skb_shared(skb)) {
>>>>                 struct sk_buff *nskb = skb_clone(skb, GFP_ATOMIC);
>>>>  
>>>> -               if (likely(nskb)) {
>>>> -                       if (skb->sk)
>>>> -                               skb_set_owner_w(nskb, skb->sk);
>>>> -                       consume_skb(skb);
>>>> -               } else {
>>>> +               if (unlikely(!nskb)) {
>>>>                         kfree_skb(skb);
>>>> +                       return NULL;
>>>>                 }
>>>> +               oskb = skb;
>>>>                 skb = nskb;
>>>>         }
>>>> -       if (skb &&
>>>> -           pskb_expand_head(skb, SKB_DATA_ALIGN(delta), 0, GFP_ATOMIC)) {
>>>> +       if (pskb_expand_head(skb, SKB_DATA_ALIGN(delta), 0, GFP_ATOMIC)) {
>>>>                 kfree_skb(skb);
>>>> -               skb = NULL;
>>>> +               kfree_skb(oskb);
>>>> +               return NULL;
>>>> +       }
>>>> +       if (oskb) {
>>>> +               skb_set_owner_w(skb, oskb->sk);
>>>> +               consume_skb(oskb);
>>>>         }
>>>>         return skb;
>>>>  }
>>>
>>>
>>> Oh well, probably not going to work.
>>>
>>> We have to find a way to properly increase skb->truesize, even if skb_clone() is _not_ called.
> 
> Can we adjust truesize outside pskb_expand_head()?
> Could you please explain why it can be not safe?

Do you mean truesize change should not break balance of sk->sk_wmem_alloc?

>> I also note that current use of skb_set_owner_w(), forcing skb->destructor to sock_wfree()
>> is probably breaking TCP Small queues, since original skb->destructor would be tcp_wfree() or __sock_wfree()
> 
> I agree, however as far as I understand it is separate and more global problem.
> 
> Thank you,
> 	Vasily Averin
> 

