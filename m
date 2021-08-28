Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59AB93FA476
	for <lists+netdev@lfdr.de>; Sat, 28 Aug 2021 10:02:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233466AbhH1ICD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Aug 2021 04:02:03 -0400
Received: from relay.sw.ru ([185.231.240.75]:52554 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230208AbhH1ICC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 28 Aug 2021 04:02:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Date:Message-ID:From:
        Subject; bh=jluMMVsqCTkZy4J4waEELl6tvgeNZqOCbsfsX0toBMw=; b=vzSkXMdC1iLvHgk9H
        Nd0foTlpvg7bF82sh+YtypJLi1ikzKNaZqvU2Pmk0eVbvyp594pohddr2idhphAIWct1ma3cz6Fhy
        rgohntfhIQ+Fab1mhS/bbJ+cKpaDJ9NZ+xB/iNyUv3sbKEDh8DH4r3eArZq6eBo06dP/ZdVpfr2Lk
        =;
Received: from [10.93.0.56]
        by relay.sw.ru with esmtp (Exim 4.94.2)
        (envelope-from <vvs@virtuozzo.com>)
        id 1mJtGv-0002o2-Rk; Sat, 28 Aug 2021 11:01:01 +0300
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
 <7a6588ad-00fe-cfb9-afcd-d8b31be229cd@virtuozzo.com>
 <478ae732-161d-c692-b60a-6df11c37ac2c@gmail.com>
From:   Vasily Averin <vvs@virtuozzo.com>
Message-ID: <1060942f-d479-7399-df13-d312f963a823@virtuozzo.com>
Date:   Sat, 28 Aug 2021 11:01:00 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <478ae732-161d-c692-b60a-6df11c37ac2c@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/27/21 7:47 PM, Eric Dumazet wrote:
> 
> 
> On 8/27/21 8:23 AM, Vasily Averin wrote:
> 
>> I asked Alexey Kuznetsov to look at this problem. Below is his answer:
>> "I think the current scheme is obsolete. It was created
>> when we had only two kinds of skb accounting (rmem & wmem)
>> and with more kinds of accounting it just does not work.
>> Even there we had ignored problems with adjusting accounting.
>>
>> Logically the best solution would be replacing ->destructor,
>> set_owner* etc with skb_ops. Something like:
>>
>> struct skb_ops
>> {
>>         void init(struct sk_buff * skb, struct skb_ops * ops, struct
>> sock * owner);
>>         void fini(struct sk_buff * skb);
>>         void update(struct sk_buff * skb, int adjust);
>>         void inherit(struct sk_buff * skb2, struct sk_buff * skb);
>> };
>>
>> init - is replacement for skb_set_owner_r|w
>> fini - is replacement for skb_orphan
>> update - is new operation to be used in places where skb->truesize changes,
>>        instead of awful constructions like:
>>
>>        if (!skb->sk || skb->destructor == sock_edemux)
>>             skb->truesize += size - osize;
>>
>>        Now it will look like:
>>
>>        if (skb->ops)
>>             skb->ops->update(skb, size - osize);
>>
>> inherit - is replacement for also awful constructs like:
>>
>>       if (skb->sk)
>>             skb_set_owner_w(skb2, skb->sk);
>>
>>       Now it will be:
>>
>>       if (skb->ops)
>>             skb->ops->inherit(skb2, skb);
>>
>> The implementation looks mostly obvious.
>> Some troubles can be only with new functionality:
>> update of accounting was never done before.
>>
>>
>> More efficient, functionally equivalent, but uglier and less flexible
>> alternative would be removal of ->destructor, replaced with
>> a small numeric indicator of ownership:
>>
>> enum
>> {
>>         SKB_OWNER_NONE,  /* aka destructor == NULL */
>>         SKB_OWNER_WMEM,  /* aka destructor == sk_wfree */
>>         SKB_OWNER_RMEM,  /* aka destructor == sk_rfree */
>>         SKB_OWNER_SK,    /* aka destructor == sk_edemux */
>>         SKB_OWNER_TCP,   /* aka destructor == tcp_wfree */
>> }
>>
>> And the same init,fini,inherit,update become functions
>> w/o any inidirect calls. Not sure it is really more efficient though."
>>
> 
> Well, this does not look as stable material, and would add a bunch
> of indirect calls which are quite expensive these days (CONFIG_RETPOLINE=y)
> 
> I suggest we work on a fix, using existing infra, then eventually later
> try to refactor if this is really bringing improvements.
> 
> A fix could simply be a revert of 0c9f227bee119 ("ipv6: use skb_expand_head in ip6_xmit")
> since only IPv6 has the problem (because of arbitrary headers size)

I think it is not enough.

Root of the problem is that skb_expand_head() works incorrectly with non-shared skb.
In this case it do not call skb_clone before pskb_expand_head() execution,
and as result pskb_expand_head() and does not adjust skb->truesize.

I think non-shared skb is more frequent case,
so all skb_expand_head() are affected.

Therefore we need to revert all my patch set in net-next:
f1260ff skbuff: introduce skb_expand_head()
e415ed3 ipv6: use skb_expand_head in ip6_finish_output2
0c9f227 ipv6: use skb_expand_head in ip6_xmit
5678a59 ipv4: use skb_expand_head in ip_finish_output2
14ee70c vrf: use skb_expand_head in vrf_finish_output
53744a4 ax25: use skb_expand_head
a1e975e bpf: use skb_expand_head in bpf_out_neigh_v4/6
07e1d6b Merge branch 'skb_expand_head'
with fixup
06669e6 vrf: fix NULL dereference in vrf_finish_output()

And then rework ip6_finish_output2() in upstream, 
to call skb_realloc_headroom() like it was done in first patch version:
https://lkml.org/lkml/2021/7/7/469.

Thank you,
	Vasily Averin

