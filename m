Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 319C93F44B3
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 07:44:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234757AbhHWFpT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 01:45:19 -0400
Received: from relay.sw.ru ([185.231.240.75]:57712 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231267AbhHWFpS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Aug 2021 01:45:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Date:Message-ID:From:
        Subject; bh=Fl3YLeNPw73kTCd+tayVreDVmY39xWbUXsGFSI8fAJs=; b=BKgjhm6JRLLJVwNPQ
        M5iIcdxkT+Z2i8RPmYlvvcyCWT4GPLbgZuMaBdHv7yjTkN2pwyEQH50VcdDxSW3lbAVry6Z36zMSY
        eGjCk8cNWp0T0iiJROU6Kl2ZRWgTdCthMWZu220lZks6UZ9FcVFSf+cRakuoTZUHCRYvCdhqt5hpo
        =;
Received: from [10.93.0.56]
        by relay.sw.ru with esmtp (Exim 4.94.2)
        (envelope-from <vvs@virtuozzo.com>)
        id 1mI2l4-008Y2I-Hh; Mon, 23 Aug 2021 08:44:30 +0300
Subject: Re: [PATCH NET v4 3/7] ipv6: use skb_expand_head in ip6_xmit
To:     Christoph Paasch <christoph.paasch@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, kernel@openvz.org,
        Julian Wiedmann <jwi@linux.ibm.com>
References: <ccce7edb-54dd-e6bf-1e84-0ec320d8886c@linux.ibm.com>
 <cover.1628235065.git.vvs@virtuozzo.com>
 <77f3e358-c75e-b0bf-ca87-6f8297f5593c@virtuozzo.com>
 <CALMXkpaay1y=0tkbnskr4gf-HTMjJJsVryh4Prnej_ws-hJvBg@mail.gmail.com>
 <CALMXkpa4RqwssO2QNKMjk=f8pGWDMtj4gpQbAYWbGDRfN4J6DQ@mail.gmail.com>
 <ff75b068-8165-a45c-0026-8b8f1c745213@virtuozzo.com>
 <CALMXkpZVkqFDKiCa4yHV0yJ7qEESqzcanu4mrWTNvc9jm=gxcw@mail.gmail.com>
 <CALMXkpYeR+DegQJ7Eec2cx=z8i+Z8Y-Aygftjg08Y2+bQXJZ7Q@mail.gmail.com>
From:   Vasily Averin <vvs@virtuozzo.com>
Message-ID: <7d71f2cc-3fff-beff-b82b-d0a81fb60429@virtuozzo.com>
Date:   Mon, 23 Aug 2021 08:44:29 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CALMXkpYeR+DegQJ7Eec2cx=z8i+Z8Y-Aygftjg08Y2+bQXJZ7Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/22/21 8:13 PM, Christoph Paasch wrote:
> On Sun, Aug 22, 2021 at 10:04 AM Christoph Paasch
> <christoph.paasch@gmail.com> wrote:
>>
>> Hello Vasily,
>>
>> On Fri, Aug 20, 2021 at 11:21 PM Vasily Averin <vvs@virtuozzo.com> wrote:
>>>
>>> On 8/21/21 1:44 AM, Christoph Paasch wrote:
>>>> (resend without html - thanks gmail web-interface...)
>>>> On Fri, Aug 20, 2021 at 3:41 PM Christoph Paasch
>>>>> AFAICS, this is because pskb_expand_head (called from
>>>>> skb_expand_head) is not adjusting skb->truesize when skb->sk is set
>>>>> (which I guess is the case in this particular scenario). I'm not
>>>>> sure what the proper fix would be though...
>>>
>>> Could you please elaborate?
>>> it seems to me skb_realloc_headroom used before my patch called pskb_expand_head() too
>>> and did not adjusted skb->truesize too. Am I missed something perhaps?
>>>
>>> The only difference in my patch is that skb_clone can be not called,
>>> though I do not understand how this can affect skb->truesize.
>>
>> I *believe* that the difference is that after skb_clone() skb->sk is
>> NULL and thus truesize will be adjusted.
>>
>> I will try to confirm that with some more debugging.
> 
> Yes indeed.
> 
> Before your patch:
> [   19.154039] ip6_xmit before realloc truesize 4864 sk? 000000002ccd6868
> [   19.155230] ip6_xmit after realloc truesize 5376 sk? 0000000000000000
> 
> skb->sk is not set and thus truesize will be adjusted.

This looks strange for me. skb should not lost sk reference.

Could you please clarify where exactly you cheked it?
sk on newly allocated skb is set on line 291

net/ipv6/ip6_output.c::ip6_xmit()
 282         if (unlikely(skb_headroom(skb) < head_room)) {
 283                 struct sk_buff *skb2 = skb_realloc_headroom(skb, head_room);
 284                 if (!skb2) {
 285                         IP6_INC_STATS(net, ip6_dst_idev(skb_dst(skb)),
 286                                       IPSTATS_MIB_OUTDISCARDS);
 287                         kfree_skb(skb);
 288                         return -ENOBUFS;
 289                 }
 290                 if (skb->sk)
 291                         skb_set_owner_w(skb2, skb->sk); <<<<< here
 292                 consume_skb(skb);
 293                 skb = skb2;
 294         }

> With your change:
> [   15.092933] ip6_xmit before realloc truesize 4864 sk? 00000000072930fd
> [   15.094131] ip6_xmit after realloc truesize 4864 sk? 00000000072930fd
> 
> skb->sk is set and thus truesize is not adjusted.

In this case skb_set_owner_w() is called inside skb_expand_head()

net/ipv6/ip6_output.c::ip6_xmit()
 265         if (unlikely(head_room > skb_headroom(skb))) {
 266                 skb = skb_expand_head(skb, head_room);
 267                 if (!skb) {
 268                         IP6_INC_STATS(net, idev, IPSTATS_MIB_OUTDISCARDS);
 269                         return -ENOBUFS;
 270                 }
 271         }

net/core/skbuff.c::skb_expand_head()
1813         if (skb_shared(skb)) {
1814                 struct sk_buff *nskb = skb_clone(skb, GFP_ATOMIC);
1815 
1816                 if (likely(nskb)) {
1817                         if (skb->sk)
1818                                 skb_set_owner_w(nskb, skb->sk);  <<<< here
1819                         consume_skb(skb);
1820                 } else {
1821                         kfree_skb(skb);
1822                 }
1823                 skb = nskb;
1824         }

So I do not understand how this can happen.
With my patch: 
a) if skb is not shared -- it should keep original skb->sk
b) if skb is shared -- new skb should set sk if it was set on original skb.

Your results can be explained if you looked and skb->sk and truesize right after skb_realloc_headroom() call
but  before following skb_set_owner_w(). Could you please check it?

Thank you,
	Vasily Averin
