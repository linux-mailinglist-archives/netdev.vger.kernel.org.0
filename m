Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 270163F9BAA
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 17:24:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245489AbhH0PYg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Aug 2021 11:24:36 -0400
Received: from relay.sw.ru ([185.231.240.75]:54228 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234186AbhH0PYf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Aug 2021 11:24:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Date:Message-ID:From:
        Subject; bh=NUKgTdLlD/xJl95girMo67C/b/8wQUOpTWYlkwSy0Yc=; b=b+c1ORXfRj09WzUM5
        /JtFp2IsYiQ4/mdN2XlWvqQS14Dhq+h8L1tRNLFlQL2oiFRK9LiQjF+Hihy9hXuB0shNGyLSqCBBG
        aEmzEDP0KZbhsd1JTP5Lx1xkvaspz8c2y6wxfpJ2A+RcAta8uVnXhKsG+977j4TNlwAQa8tKsAMUM
        =;
Received: from [10.93.0.56]
        by relay.sw.ru with esmtp (Exim 4.94.2)
        (envelope-from <vvs@virtuozzo.com>)
        id 1mJdhg-0092Kq-Ng; Fri, 27 Aug 2021 18:23:36 +0300
Subject: Re: [PATCH NET-NEXT] ipv6: skb_expand_head() adjust skb->truesize
 incorrectly
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        Christoph Paasch <christoph.paasch@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, kernel@openvz.org,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
References: <6858f130-e6b4-1ba7-ed6f-58c00152be69@virtuozzo.com>
 <ef4458d9-c4d7-f419-00f2-0f1cea5140ce@virtuozzo.com>
 <CALMXkpZkW+ULMMFgeY=cag1F0=891F-v9NEVcdn7Tyd-VUWGYA@mail.gmail.com>
 <1c12b056-79d2-126a-3f78-64629f072345@gmail.com>
 <2d8a102a-d641-c6c1-b417-7a35efa4e5da@gmail.com>
 <bd90616e-8e86-016b-0979-c4f4167b8bc2@gmail.com>
From:   Vasily Averin <vvs@virtuozzo.com>
Message-ID: <7a6588ad-00fe-cfb9-afcd-d8b31be229cd@virtuozzo.com>
Date:   Fri, 27 Aug 2021 18:23:35 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <bd90616e-8e86-016b-0979-c4f4167b8bc2@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/24/21 1:23 AM, Eric Dumazet wrote:
> On 8/23/21 2:51 PM, Eric Dumazet wrote:
>> On 8/23/21 2:45 PM, Eric Dumazet wrote:
>>> On 8/23/21 10:25 AM, Christoph Paasch wrote:
>>>> Hello,
>>>>
>>>> On Mon, Aug 23, 2021 at 12:56 AM Vasily Averin <vvs@virtuozzo.com> wrote:
>>>>>
>>>>> Christoph Paasch reports [1] about incorrect skb->truesize
>>>>> after skb_expand_head() call in ip6_xmit.
>>>>> This happen because skb_set_owner_w() for newly clone skb is called
>>>>> too early, before pskb_expand_head() where truesize is adjusted for
>>>>> (!skb-sk) case.
>>>>>
>>>>> [1] https://lkml.org/lkml/2021/8/20/1082
>>>>>
>>>>> Reported-by: Christoph Paasch <christoph.paasch@gmail.com>
>>>>> Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
>>>>> ---
>>>>>  net/core/skbuff.c | 24 +++++++++++++-----------
>>>>>  1 file changed, 13 insertions(+), 11 deletions(-)
>>>>>
>>>>> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
>>>>> index f931176..508d5c4 100644
>>>>> --- a/net/core/skbuff.c
>>>>> +++ b/net/core/skbuff.c
>>>>> @@ -1803,6 +1803,8 @@ struct sk_buff *skb_realloc_headroom(struct sk_buff *skb, unsigned int headroom)
>>>>>
>>>>>  struct sk_buff *skb_expand_head(struct sk_buff *skb, unsigned int headroom)
>>>>>  {
>>>>> +       struct sk_buff *oskb = skb;
>>>>> +       struct sk_buff *nskb = NULL;
>>>>>         int delta = headroom - skb_headroom(skb);
>>>>>
>>>>>         if (WARN_ONCE(delta <= 0,
>>>>> @@ -1811,21 +1813,21 @@ struct sk_buff *skb_expand_head(struct sk_buff *skb, unsigned int headroom)
>>>>>
>>>>>         /* pskb_expand_head() might crash, if skb is shared */
>>>>>         if (skb_shared(skb)) {
>>>>> -               struct sk_buff *nskb = skb_clone(skb, GFP_ATOMIC);
>>>>> -
>>>>> -               if (likely(nskb)) {
>>>>> -                       if (skb->sk)
>>>>> -                               skb_set_owner_w(nskb, skb->sk);
>>>>> -                       consume_skb(skb);
>>>>> -               } else {
>>>>> -                       kfree_skb(skb);
>>>>> -               }
>>>>> +               nskb = skb_clone(skb, GFP_ATOMIC);
>>>>>                 skb = nskb;
>>>>>         }
>>>>>         if (skb &&
>>>>> -           pskb_expand_head(skb, SKB_DATA_ALIGN(delta), 0, GFP_ATOMIC)) {
>>>>> -               kfree_skb(skb);
>>>>> +           pskb_expand_head(skb, SKB_DATA_ALIGN(delta), 0, GFP_ATOMIC))
>>>>>                 skb = NULL;
>>>>> +
>>>>> +       if (!skb) {
>>>>> +               kfree_skb(oskb);
>>>>> +               if (nskb)
>>>>> +                       kfree_skb(nskb);
>>>>> +       } else if (nskb) {
>>>>> +               if (oskb->sk)
>>>>> +                       skb_set_owner_w(nskb, oskb->sk);
>>>>> +               consume_skb(oskb);
>>>>
>>>> sorry, this does not fix the problem. The syzkaller repro still
>>>> triggers the WARN.
>>>>
>>>> When it happens, the skb in ip6_xmit() is not shared as it comes from
>>>> __tcp_transmit_skb, where it is skb_clone()'d.
>>>>
>>>>
>>>
>>> Old code (in skb_realloc_headroom())
>>> was first calling skb2 = skb_clone(skb, GFP_ATOMIC); 
>>>
>>> At this point, skb2->sk was NULL
>>> So pskb_expand_head(skb2, SKB_DATA_ALIGN(delta), 0, ...) was able to tweak skb2->truesize
>>>
>>> I would try :
>>>
>>> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
>>> index f9311762cc475bd38d87c33e988d7c983b902e56..326749a8938637b044a616cc33b6a19ed191ac41 100644
>>> --- a/net/core/skbuff.c
>>> +++ b/net/core/skbuff.c
>>> @@ -1804,6 +1804,7 @@ EXPORT_SYMBOL(skb_realloc_headroom);
>>>  struct sk_buff *skb_expand_head(struct sk_buff *skb, unsigned int headroom)
>>>  {
>>>         int delta = headroom - skb_headroom(skb);
>>> +       struct sk_buff *oskb = NULL;
>>>  
>>>         if (WARN_ONCE(delta <= 0,
>>>                       "%s is expecting an increase in the headroom", __func__))
>>> @@ -1813,19 +1814,21 @@ struct sk_buff *skb_expand_head(struct sk_buff *skb, unsigned int headroom)
>>>         if (skb_shared(skb)) {
>>>                 struct sk_buff *nskb = skb_clone(skb, GFP_ATOMIC);
>>>  
>>> -               if (likely(nskb)) {
>>> -                       if (skb->sk)
>>> -                               skb_set_owner_w(nskb, skb->sk);
>>> -                       consume_skb(skb);
>>> -               } else {
>>> +               if (unlikely(!nskb)) {
>>>                         kfree_skb(skb);
>>> +                       return NULL;
>>>                 }
>>> +               oskb = skb;
>>>                 skb = nskb;
>>>         }
>>> -       if (skb &&
>>> -           pskb_expand_head(skb, SKB_DATA_ALIGN(delta), 0, GFP_ATOMIC)) {
>>> +       if (pskb_expand_head(skb, SKB_DATA_ALIGN(delta), 0, GFP_ATOMIC)) {
>>>                 kfree_skb(skb);
>>> -               skb = NULL;
>>> +               kfree_skb(oskb);
>>> +               return NULL;
>>> +       }
>>> +       if (oskb) {
>>> +               skb_set_owner_w(skb, oskb->sk);
>>> +               consume_skb(oskb);
>>>         }
>>>         return skb;
>>>  }
>> Oh well, probably not going to work.
>>
>> We have to find a way to properly increase skb->truesize, even if skb_clone() is _not_ called.
> 
> I also note that current use of skb_set_owner_w(), forcing skb->destructor to sock_wfree()
> is probably breaking TCP Small queues, since original skb->destructor would be tcp_wfree() or __sock_wfree()

I asked Alexey Kuznetsov to look at this problem. Below is his answer:
"I think the current scheme is obsolete. It was created
when we had only two kinds of skb accounting (rmem & wmem)
and with more kinds of accounting it just does not work.
Even there we had ignored problems with adjusting accounting.

Logically the best solution would be replacing ->destructor,
set_owner* etc with skb_ops. Something like:

struct skb_ops
{
        void init(struct sk_buff * skb, struct skb_ops * ops, struct
sock * owner);
        void fini(struct sk_buff * skb);
        void update(struct sk_buff * skb, int adjust);
        void inherit(struct sk_buff * skb2, struct sk_buff * skb);
};

init - is replacement for skb_set_owner_r|w
fini - is replacement for skb_orphan
update - is new operation to be used in places where skb->truesize changes,
       instead of awful constructions like:

       if (!skb->sk || skb->destructor == sock_edemux)
            skb->truesize += size - osize;

       Now it will look like:

       if (skb->ops)
            skb->ops->update(skb, size - osize);

inherit - is replacement for also awful constructs like:

      if (skb->sk)
            skb_set_owner_w(skb2, skb->sk);

      Now it will be:

      if (skb->ops)
            skb->ops->inherit(skb2, skb);

The implementation looks mostly obvious.
Some troubles can be only with new functionality:
update of accounting was never done before.


More efficient, functionally equivalent, but uglier and less flexible
alternative would be removal of ->destructor, replaced with
a small numeric indicator of ownership:

enum
{
        SKB_OWNER_NONE,  /* aka destructor == NULL */
        SKB_OWNER_WMEM,  /* aka destructor == sk_wfree */
        SKB_OWNER_RMEM,  /* aka destructor == sk_rfree */
        SKB_OWNER_SK,    /* aka destructor == sk_edemux */
        SKB_OWNER_TCP,   /* aka destructor == tcp_wfree */
}

And the same init,fini,inherit,update become functions
w/o any inidirect calls. Not sure it is really more efficient though."

Thank you,
	Vasily Averin
