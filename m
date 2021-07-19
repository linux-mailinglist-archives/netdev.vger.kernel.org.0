Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A0593CD359
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 13:13:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236350AbhGSKWp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 06:22:45 -0400
Received: from novek.ru ([213.148.174.62]:40950 "EHLO novek.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235440AbhGSKWl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Jul 2021 06:22:41 -0400
Received: from [192.168.0.18] (unknown [37.228.234.253])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id 89F10503A47;
        Mon, 19 Jul 2021 14:00:56 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru 89F10503A47
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1626692458; bh=A8HPabJBxeEVI1VkLeuuVx4yMCcSw27JdfqYuVveneI=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=iKnZC/dNwKqkLbhfcJl5s/r4Ya2gNsqPywQJA0PrfAXz2i6B2NuYGhXHnDrWD+sGa
         TQFOfGirxxMK2JCgz91GsWZ5nKpSWoGRhdO3td+0UXVet0YbwaZwFDLqdSiOLYGG2j
         XDz6zdTQoaQcUfdJ7Im9AALZgIr3HEb+wFv51S7c=
Subject: Re: [PATCH net v2 1/2] udp: check encap socket in __udp_lib_err_encap
To:     Xin Long <lucien.xin@gmail.com>
Cc:     David Ahern <dsahern@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        network dev <netdev@vger.kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
References: <20210716105417.7938-1-vfedorenko@novek.ru>
 <20210716105417.7938-2-vfedorenko@novek.ru>
 <CADvbK_eJEY_-4sJM-up_L2G47HqdV2q3XSkexYSm9vDmpmD9pA@mail.gmail.com>
 <bdb405e2-59e8-b75c-2b8a-864019477989@novek.ru>
 <CADvbK_fnOyTVOQ0wopnVZSmbB5ZBkCft1mXWLy=SqKkLYv_q3Q@mail.gmail.com>
From:   Vadim Fedorenko <vfedorenko@novek.ru>
Message-ID: <1dd7175e-4906-6168-42e4-08715a292778@novek.ru>
Date:   Mon, 19 Jul 2021 12:03:16 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CADvbK_fnOyTVOQ0wopnVZSmbB5ZBkCft1mXWLy=SqKkLYv_q3Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED,NICE_REPLY_A
        autolearn=ham autolearn_force=no version=3.4.1
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on gate.novek.ru
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 17.07.2021 19:41, Xin Long wrote:
> On Fri, Jul 16, 2021 at 6:32 PM Vadim Fedorenko <vfedorenko@novek.ru> wrote:
>>
>> On 16.07.2021 19:46, Xin Long wrote:
>>> On Fri, Jul 16, 2021 at 6:54 AM Vadim Fedorenko <vfedorenko@novek.ru> wrote:
>>>>
>>>> Commit d26796ae5894 ("udp: check udp sock encap_type in __udp_lib_err")
>>>> added checks for encapsulated sockets but it broke cases when there is
>>>> no implementation of encap_err_lookup for encapsulation, i.e. ESP in
>>>> UDP encapsulation. Fix it by calling encap_err_lookup only if socket
>>>> implements this method otherwise treat it as legal socket.
>>>>
>>>> Fixes: d26796ae5894 ("udp: check udp sock encap_type in __udp_lib_err")
>>>> Signed-off-by: Vadim Fedorenko <vfedorenko@novek.ru>
>>>> ---
>>>>    net/ipv4/udp.c | 23 +++++++++++++++++------
>>>>    net/ipv6/udp.c | 23 +++++++++++++++++------
>>>>    2 files changed, 34 insertions(+), 12 deletions(-)
>>>>
>>>> diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
>>>> index 62cd4cd52e84..963275b94f00 100644
>>>> --- a/net/ipv4/udp.c
>>>> +++ b/net/ipv4/udp.c
>>>> @@ -645,10 +645,12 @@ static struct sock *__udp4_lib_err_encap(struct net *net,
>>>>                                            const struct iphdr *iph,
>>>>                                            struct udphdr *uh,
>>>>                                            struct udp_table *udptable,
>>>> +                                        struct sock *sk,
>>>>                                            struct sk_buff *skb, u32 info)
>>>>    {
>>>> +       int (*lookup)(struct sock *sk, struct sk_buff *skb);
>>>>           int network_offset, transport_offset;
>>>> -       struct sock *sk;
>>>> +       struct udp_sock *up;
>>>>
>>>>           network_offset = skb_network_offset(skb);
>>>>           transport_offset = skb_transport_offset(skb);
>>>> @@ -659,12 +661,19 @@ static struct sock *__udp4_lib_err_encap(struct net *net,
>>>>           /* Transport header needs to point to the UDP header */
>>>>           skb_set_transport_header(skb, iph->ihl << 2);
>>>>
>>>> +       if (sk) {
>>>> +               up = udp_sk(sk);
>>>> +
>>>> +               lookup = READ_ONCE(up->encap_err_lookup);
>>>> +               if (!lookup || !lookup(sk, skb))
>>>> +                       goto out;
>>>> +       }
>>>> +
>>> Currently SCTP reuses lookup() to handle some of ICMP error packets by itself
>>> in lookup(), for these packets it will return 1, in which case we should
>>> set sk = NULL, and not let udp4_lib_err() handle these packets again.
>>>
>>> Can you change this part to this below?
>>>
>>> +       if (sk) {
>>> +               up = udp_sk(sk);
>>> +
>>> +               lookup = READ_ONCE(up->encap_err_lookup);
>>> +               if (lookup && lookup(sk, skb))
>>> +                       sk = NULL;
>>> +
>>> +               goto out;
>>> +       }
>>> +
>>>
>>> thanks.
>>>
>>
>> But we have vxlan and geneve with encap_err_lookup handler enabled and which do
>> not handle ICMP itself, just checks whether socket is correctly selected. Such
>> code could break their implementation
> Sorry, I don't see how this will break vxlan and geneve implementation.
> 
> It checking 'sk' and calling lookup() here means we believe this sk
> should be the correct one (for the case of src == dst port only). So
> even if lookup() returns !0, we should NOT go to another
> __udp4_lib_lookup() in __udp4_lib_err_encap().
> 
> If we don't believe this sk should be the correct one, as the sk was
> found with reverse ports, then we should NOT call lookup() with this sk
> but call __udp4_lib_lookup() directly in __udp4_lib_err_encap(), as it
> currently does, and fix this by checking READ_ONCE(up->encap_err_lookup)
> in __udp4_lib_lookup(), as Paolo suggested.
> 
> Either way is fine to me, but not this one. what do you think?
> 
> Thanks.
> 

Ok, I got your point, will send v3 soon with what you suggested first.
Thanks for review!

>>
>>>>           sk = __udp4_lib_lookup(net, iph->daddr, uh->source,
>>>>                                  iph->saddr, uh->dest, skb->dev->ifindex, 0,
>>>>                                  udptable, NULL);
>>>>           if (sk) {
>>>> -               int (*lookup)(struct sock *sk, struct sk_buff *skb);
>>>> -               struct udp_sock *up = udp_sk(sk);
>>>> +               up = udp_sk(sk);
>>>>
>>>>                   lookup = READ_ONCE(up->encap_err_lookup);
>>>>                   if (!lookup || lookup(sk, skb))
>>>> @@ -674,6 +683,7 @@ static struct sock *__udp4_lib_err_encap(struct net *net,
>>>>           if (!sk)
>>>>                   sk = ERR_PTR(__udp4_lib_err_encap_no_sk(skb, info));
>>>>
>>>> +out:
>>>>           skb_set_transport_header(skb, transport_offset);
>>>>           skb_set_network_header(skb, network_offset);
>>>>
>>>> @@ -707,15 +717,16 @@ int __udp4_lib_err(struct sk_buff *skb, u32 info, struct udp_table *udptable)
>>>>           sk = __udp4_lib_lookup(net, iph->daddr, uh->dest,
>>>>                                  iph->saddr, uh->source, skb->dev->ifindex,
>>>>                                  inet_sdif(skb), udptable, NULL);
>>>> +
>>>>           if (!sk || udp_sk(sk)->encap_type) {
>>>>                   /* No socket for error: try tunnels before discarding */
>>>> -               sk = ERR_PTR(-ENOENT);
>>>>                   if (static_branch_unlikely(&udp_encap_needed_key)) {
>>>> -                       sk = __udp4_lib_err_encap(net, iph, uh, udptable, skb,
>>>> +                       sk = __udp4_lib_err_encap(net, iph, uh, udptable, sk, skb,
>>>>                                                     info);
>>>>                           if (!sk)
>>>>                                   return 0;
>>>> -               }
>>>> +               } else
>>>> +                       sk = ERR_PTR(-ENOENT);
>>>>
>>>>                   if (IS_ERR(sk)) {
>>>>                           __ICMP_INC_STATS(net, ICMP_MIB_INERRORS);
>>>> diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
>>>> index 0cc7ba531b34..0210ec93d21d 100644
>>>> --- a/net/ipv6/udp.c
>>>> +++ b/net/ipv6/udp.c
>>>> @@ -502,12 +502,14 @@ static struct sock *__udp6_lib_err_encap(struct net *net,
>>>>                                            const struct ipv6hdr *hdr, int offset,
>>>>                                            struct udphdr *uh,
>>>>                                            struct udp_table *udptable,
>>>> +                                        struct sock *sk,
>>>>                                            struct sk_buff *skb,
>>>>                                            struct inet6_skb_parm *opt,
>>>>                                            u8 type, u8 code, __be32 info)
>>>>    {
>>>> +       int (*lookup)(struct sock *sk, struct sk_buff *skb);
>>>>           int network_offset, transport_offset;
>>>> -       struct sock *sk;
>>>> +       struct udp_sock *up;
>>>>
>>>>           network_offset = skb_network_offset(skb);
>>>>           transport_offset = skb_transport_offset(skb);
>>>> @@ -518,12 +520,19 @@ static struct sock *__udp6_lib_err_encap(struct net *net,
>>>>           /* Transport header needs to point to the UDP header */
>>>>           skb_set_transport_header(skb, offset);
>>>>
>>>> +       if (sk) {
>>>> +               up = udp_sk(sk);
>>>> +
>>>> +               lookup = READ_ONCE(up->encap_err_lookup);
>>>> +               if (!lookup || !lookup(sk, skb))
>>>> +                       goto out;
>>>> +       }
>>>> +
>>>>           sk = __udp6_lib_lookup(net, &hdr->daddr, uh->source,
>>>>                                  &hdr->saddr, uh->dest,
>>>>                                  inet6_iif(skb), 0, udptable, skb);
>>>>           if (sk) {
>>>> -               int (*lookup)(struct sock *sk, struct sk_buff *skb);
>>>> -               struct udp_sock *up = udp_sk(sk);
>>>> +               up = udp_sk(sk);
>>>>
>>>>                   lookup = READ_ONCE(up->encap_err_lookup);
>>>>                   if (!lookup || lookup(sk, skb))
>>>> @@ -535,6 +544,7 @@ static struct sock *__udp6_lib_err_encap(struct net *net,
>>>>                                                           offset, info));
>>>>           }
>>>>
>>>> +out:
>>>>           skb_set_transport_header(skb, transport_offset);
>>>>           skb_set_network_header(skb, network_offset);
>>>>
>>>> @@ -558,16 +568,17 @@ int __udp6_lib_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
>>>>
>>>>           sk = __udp6_lib_lookup(net, daddr, uh->dest, saddr, uh->source,
>>>>                                  inet6_iif(skb), inet6_sdif(skb), udptable, NULL);
>>>> +
>>>>           if (!sk || udp_sk(sk)->encap_type) {
>>>>                   /* No socket for error: try tunnels before discarding */
>>>> -               sk = ERR_PTR(-ENOENT);
>>>>                   if (static_branch_unlikely(&udpv6_encap_needed_key)) {
>>>>                           sk = __udp6_lib_err_encap(net, hdr, offset, uh,
>>>> -                                                 udptable, skb,
>>>> +                                                 udptable, sk, skb,
>>>>                                                     opt, type, code, info);
>>>>                           if (!sk)
>>>>                                   return 0;
>>>> -               }
>>>> +               } else
>>>> +                       sk = ERR_PTR(-ENOENT);
>>>>
>>>>                   if (IS_ERR(sk)) {
>>>>                           __ICMP6_INC_STATS(net, __in6_dev_get(skb->dev),
>>>> --
>>>> 2.18.4
>>>>
>>

