Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 667B92AC55E
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 20:48:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730911AbgKITsO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 14:48:14 -0500
Received: from mail1.protonmail.ch ([185.70.40.18]:36256 "EHLO
        mail1.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730379AbgKITsM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 14:48:12 -0500
Date:   Mon, 09 Nov 2020 19:48:04 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1604951287; bh=iJG8GK7B+1FrIWkorLlgz4sj0U+L98vlXVW5tXD0nVI=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=oWmUJV3YSNOSqkl4PjoZsC/3gKpjCTwpny7Kzi1vZMhk54GXeR2vwYG0McE2p5Am9
         TxPBsJ0lZQxCDs36mGM/zD3XIt34qHRt1w47YpzZEB5TCFdyz0r5+HgOdIUKkFJQ+i
         LEifG80aUOnaq7EydF3SH/qJgcFX8lPEan7Sv/5jy1PH50a9KAej2a83xpYz0IUmz3
         KjusRhbOQ7gGublCtPhb3rY1yAp6l3t1ECTcYH+DYNOSegVcZaOgG27A9XLxzrJmPi
         TIB5ODQLEj/qWiXFq7acLZs0RGaPdyYDqaZgrNMbyta3SURwbEFoTNWQO2u9ZQy8y5
         vf4BG0k3bG2sw==
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Alexander Lobakin <alobakin@pm.me>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: Re: [PATCH v2 net] net: udp: fix Fast/frag0 UDP GRO
Message-ID: <nokss4CZW7lx6fLaxY3rnl4Qx5buif9VLcfCbI@cp3-web-020.plabs.ch>
In-Reply-To: <CA+FuTSd2q=zaBJffxi+ORs7rxZN50c8X3n4NoJcrAq+pAZAMCA@mail.gmail.com>
References: <0eaG8xtbtKY1dEKCTKUBubGiC9QawGgB3tVZtNqVdY@cp4-web-030.plabs.ch> <d9d09931-8cd3-1eb6-673c-3ae5ebc3ee57@gmail.com> <CA+FuTSc0QLM4QpinZ1XiLreRECBDVbanwoFtMhnF6caEWjXTBw@mail.gmail.com> <3729478a-77b5-aeb5-0192-49f0e0d170ac@gmail.com> <CA+FuTSd2q=zaBJffxi+ORs7rxZN50c8X3n4NoJcrAq+pAZAMCA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.2 required=10.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF shortcircuit=no
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on
        mailout.protonmail.ch
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date: Mon, 9 Nov 2020 14:06:07 -0500

> On Mon, Nov 9, 2020 at 1:54 PM Eric Dumazet <eric.dumazet@gmail.com> wrot=
e:
>>
>>
>>
>> On 11/9/20 7:28 PM, Willem de Bruijn wrote:
>>> On Mon, Nov 9, 2020 at 12:37 PM Eric Dumazet <eric.dumazet@gmail.com> w=
rote:
>>>>
>>>>
>>>>
>>>> On 11/9/20 5:56 PM, Alexander Lobakin wrote:
>>>>> While testing UDP GSO fraglists forwarding through driver that uses
>>>>> Fast GRO (via napi_gro_frags()), I was observing lots of out-of-order
>>>>> iperf packets:
>>>>>
>>>>> [ ID] Interval           Transfer     Bitrate         Jitter
>>>>> [SUM]  0.0-40.0 sec  12106 datagrams received out-of-order
>>>>>
>>>>> Simple switch to napi_gro_receive() any other method without frag0
>>>>> shortcut completely resolved them.
>>>>>
>>>>> I've found that UDP GRO uses udp_hdr(skb) in its .gro_receive()
>>>>> callback. While it's probably OK for non-frag0 paths (when all
>>>>> headers or even the entire frame are already in skb->data), this
>>>>> inline points to junk when using Fast GRO (napi_gro_frags() or
>>>>> napi_gro_receive() with only Ethernet header in skb->data and all
>>>>> the rest in shinfo->frags) and breaks GRO packet compilation and
>>>>> the packet flow itself.
>>>>> To support both modes, skb_gro_header_fast() + skb_gro_header_slow()
>>>>> are typically used. UDP even has an inline helper that makes use of
>>>>> them, udp_gro_udphdr(). Use that instead of troublemaking udp_hdr()
>>>>> to get rid of the out-of-order delivers.
>>>>>
>>>>> Present since the introduction of plain UDP GRO in 5.0-rc1.
>>>>>
>>>>> Since v1 [1]:
>>>>>  - added a NULL pointer check for "uh" as suggested by Willem.
>>>>>
>>>>> [1] https://lore.kernel.org/netdev/YazU6GEzBdpyZMDMwJirxDX7B4sualpDG6=
8ADZYvJI@cp4-web-034.plabs.ch
>>>>>
>>>>> Fixes: e20cf8d3f1f7 ("udp: implement GRO for plain UDP sockets.")
>>>>> Signed-off-by: Alexander Lobakin <alobakin@pm.me>
>>>>> ---
>>>>>  net/ipv4/udp_offload.c | 7 ++++++-
>>>>>  1 file changed, 6 insertions(+), 1 deletion(-)
>>>>>
>>>>> diff --git a/net/ipv4/udp_offload.c b/net/ipv4/udp_offload.c
>>>>> index e67a66fbf27b..7f6bd221880a 100644
>>>>> --- a/net/ipv4/udp_offload.c
>>>>> +++ b/net/ipv4/udp_offload.c
>>>>> @@ -366,13 +366,18 @@ static struct sk_buff *udp4_ufo_fragment(struct=
 sk_buff *skb,
>>>>>  static struct sk_buff *udp_gro_receive_segment(struct list_head *hea=
d,
>>>>>                                              struct sk_buff *skb)
>>>>>  {
>>>>> -     struct udphdr *uh =3D udp_hdr(skb);
>>>>> +     struct udphdr *uh =3D udp_gro_udphdr(skb);
>>>>>       struct sk_buff *pp =3D NULL;
>>>>>       struct udphdr *uh2;
>>>>>       struct sk_buff *p;
>>>>>       unsigned int ulen;
>>>>>       int ret =3D 0;
>>>>>
>>>>> +     if (unlikely(!uh)) {
>>>>
>>>> How uh could be NULL here ?
>>>>
>>>> My understanding is that udp_gro_receive() is called
>>>> only after udp4_gro_receive() or udp6_gro_receive()
>>>> validated that udp_gro_udphdr(skb) was not NULL.
>>>
>>> Oh indeed. This has already been checked before.
>>>
>>>>> +             NAPI_GRO_CB(skb)->flush =3D 1;
>>>>> +             return NULL;
>>>>> +     }
>>>>> +
>>>>>       /* requires non zero csum, for symmetry with GSO */
>>>>>       if (!uh->check) {
>>>>>               NAPI_GRO_CB(skb)->flush =3D 1;
>>>>>
>>>>
>>>> Why uh2 is left unchanged ?
>>>>
>>>>     uh2 =3D udp_hdr(p);
>>>
>>> Isn't that the same as th2 =3D tcp_hdr(p) in tcp_gro_receive? no frag0
>>> optimization to worry about for packets on the list.
>>
>> My feeling was that tcp_gro_receive() is terminal in the GRO stack.
>>
>> While UDP could be encapsulated in UDP :)
>>
>> I guess we do not support this yet.
>>
>> Years ago we made sure to propagate the current header offset into GRO s=
tack
>> (when we added SIT/IPIP/GRE support to GRO)
>> 299603e8370a93dd5d8e8d800f0dff1ce2c53d36 ("net-gro: Prepare GRO stack fo=
r the upcoming tunneling support")
>
> On which note, and Alexander's mention of udp4_lib_lookup_skb(), that
> performs a standard ip_hdr on the possibly frag0 optimized incoming
> packet:
>
> struct sock *udp4_lib_lookup_skb(struct sk_buff *skb,
>                                  __be16 sport, __be16 dport)
> {
>         const struct iphdr *iph =3D ip_hdr(skb);
>
>         return __udp4_lib_lookup(dev_net(skb->dev), iph->saddr, sport,
>                                  iph->daddr, dport, inet_iif(skb),
>                                  inet_sdif(skb), &udp_table, NULL);
> }
>
> This should use skb_gro_header_.. too, then?

Well, both of udp{4,6}_lib_lookup_skb() and a couple of neighbour
functions use ip_hdr(skb). I didn't check this path before as my
test case was NAT/forwarding with no sk.
I suspect they should use skb_gro_network_header() to obtain an IP
header. I'll fix them in v3, thanks for pointing this out!

Al

