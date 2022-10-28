Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D58E610E20
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 12:11:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230043AbiJ1KL4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 06:11:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbiJ1KLz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 06:11:55 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72E1F15A8C8;
        Fri, 28 Oct 2022 03:11:54 -0700 (PDT)
Received: from canpemm500006.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MzJHG0c5KzHvV6;
        Fri, 28 Oct 2022 18:11:38 +0800 (CST)
Received: from [10.174.179.200] (10.174.179.200) by
 canpemm500006.china.huawei.com (7.192.105.130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 28 Oct 2022 18:11:52 +0800
Subject: Re: [PATCH net] ipv6/gro: fix an out of bounds memory bug in
 ipv6_gro_receive()
To:     Eric Dumazet <edumazet@google.com>
CC:     <davem@davemloft.net>, <yoshfuji@linux-ipv6.org>,
        <dsahern@kernel.org>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <herbert@gondor.apana.org.au>
References: <20221027102449.926410-1-william.xuanziyang@huawei.com>
 <CANn89iJkKJ3-b8vncrxgawWTtaLphYERhVma7+1qgdSEXn8tiQ@mail.gmail.com>
 <8523b754-992d-0d72-ecd1-4f076e57ebde@huawei.com>
 <CANn89i+FYGkR5_-C3wp7GdpW=JT8V5LELwMNcHg9Gt6=e877JA@mail.gmail.com>
From:   "Ziyang Xuan (William)" <william.xuanziyang@huawei.com>
Message-ID: <4ce1a942-db88-3d20-b377-ade9b4fc997d@huawei.com>
Date:   Fri, 28 Oct 2022 18:11:51 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CANn89i+FYGkR5_-C3wp7GdpW=JT8V5LELwMNcHg9Gt6=e877JA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.200]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 canpemm500006.china.huawei.com (7.192.105.130)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On Thu, Oct 27, 2022 at 6:01 AM Ziyang Xuan (William)
> <william.xuanziyang@huawei.com> wrote:
>>
>>> On Thu, Oct 27, 2022 at 3:25 AM Ziyang Xuan
>>> <william.xuanziyang@huawei.com> wrote:
>>>>
>>>> IPv6 packets without NEXTHDR_NONE extension header can make continuous
>>>> __skb_pull() until pskb_may_pull() failed in ipv6_gso_pull_exthdrs().
>>>> That results in a big value of skb_gro_offset(), and after __skb_push()
>>>> in ipv6_gro_receive(), skb->data will less than skb->head, an out of
>>>> bounds memory bug occurs. That will trigger the problem as following:
>>>>
>>>> ==================================================================
>>>> BUG: KASAN: use-after-free in eth_type_trans+0x100/0x260
>>>> ...
>>>> Call trace:
>>>>  dump_backtrace+0xd8/0x130
>>>>  show_stack+0x1c/0x50
>>>>  dump_stack_lvl+0x64/0x7c
>>>>  print_address_description.constprop.0+0xbc/0x2e8
>>>>  print_report+0x100/0x1e4
>>>>  kasan_report+0x80/0x120
>>>>  __asan_load8+0x78/0xa0
>>>>  eth_type_trans+0x100/0x260
>>>
>>> Crash happens from eth_type_trans() , this should happen before
>>> ipv6_gro_receive() ?
>>>
>>> It seems your patch is unrelated.
>>>
>>> Please provide a repro.
>>
>> C repro put in attachment.
> 
> This seems to be a bug in tun device.
> 
> Please take more time to root cause this issue, instead of adding work
> arounds all over the place.

Hi Eric,

Thank you for your suggestion.

I have analyzed the problem more deeply. The odd IPv6 packet and
big packet length value(IPv6 payload length more than 65535)
together cause the problem.

skb->network_header and skb->transport_header are all u16 type.
They would occuer overflow errors during ipv6_gro_receive() processing.
That cause the value error for __skb_push(skb, value).

So the problem is a bug in tun device.

I will combine my previous problem "net: tun: limit first seg size to avoid oversized linearization"
together to give the fix patch later.

Thanks.

> 
> Thanks.
> 
>>
>>>
>>>
>>>>  napi_gro_frags+0x164/0x550
>>>>  tun_get_user+0xda4/0x1270
>>>>  tun_chr_write_iter+0x74/0x130
>>>>  do_iter_readv_writev+0x130/0x1ec
>>>>  do_iter_write+0xbc/0x1e0
>>>>  vfs_writev+0x13c/0x26c
>>>>
>>>> Add comparison between skb->data - skb_gro_offset() and skb->head
>>>> and exception handler before __skb_push() to fix the bug.
>>>>
>>>> Fixes: 86911732d399 ("gro: Avoid copying headers of unmerged packets")
>>>> Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
>>>> ---
>>>>  net/ipv6/ip6_offload.c | 4 ++++
>>>>  1 file changed, 4 insertions(+)
>>>>
>>>> diff --git a/net/ipv6/ip6_offload.c b/net/ipv6/ip6_offload.c
>>>> index 3ee345672849..6659ccf25387 100644
>>>> --- a/net/ipv6/ip6_offload.c
>>>> +++ b/net/ipv6/ip6_offload.c
>>>> @@ -237,6 +237,10 @@ INDIRECT_CALLABLE_SCOPE struct sk_buff *ipv6_gro_receive(struct list_head *head,
>>>>                 proto = ipv6_gso_pull_exthdrs(skb, proto);
>>>>                 skb_gro_pull(skb, -skb_transport_offset(skb));
>>>>                 skb_reset_transport_header(skb);
>>>> +               if (unlikely(skb_headroom(skb) < skb_gro_offset(skb))) {
>>>
>>> This makes no sense to me.
>>>
>>> If there is a bug, it should be fixed earlier.
>>
>> Maybe it is good to validate IPv6 packet earlier in ipv6_gro_receive() or more earlier?
>>
>>>
>>>> +                       kfree_skb(skb);
>>>> +                       return ERR_PTR(-EINPROGRESS);
>>>> +               }
>>>>                 __skb_push(skb, skb_gro_offset(skb));
>>>>
>>>>                 ops = rcu_dereference(inet6_offloads[proto]);
>>>> --
>>>> 2.25.1
>>>>
>>> .
>>>
> .
> 
