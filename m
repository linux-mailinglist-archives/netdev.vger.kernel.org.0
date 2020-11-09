Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADB302AC3C8
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 19:26:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729785AbgKIS0f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 13:26:35 -0500
Received: from mail1.protonmail.ch ([185.70.40.18]:50307 "EHLO
        mail1.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729119AbgKIS0f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 13:26:35 -0500
Date:   Mon, 09 Nov 2020 18:26:23 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1604946392; bh=+CQqk8Dxom9CvkBxEHpxQ3fmbypfmfAfmwMPYA0at10=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=ODxl+KaPXeNe5xY9geajV1P7z08xnqBQeveNMlIDfmlgZRCZOhcL5mfGODJcMvix7
         tN6CwTvQL/2HF6SAR1C6Rbpvur84pmQvXDr0P7xZuDpO9UTU4r/9dMr4Msr+sqoF0y
         zJjI0Qqptgl/j/PycMhj9AqBKFBLIMGyeu1tAOVnL5A/1RpTlLmZvVfcWMwdtzr/au
         G9D0S9nW+FNDdncJi6/TmAD4JQNgF2Sd1a5YVLrKEwiMHFAXk80cWIaP6L1loluO6A
         36G77T1TzLWvhonTJ4bpiPAYQ9klhHGOaLFCfWoZBTvRTrmlMi7hjnGC3xWlLi64p1
         5Jdz6D4agwxlA==
To:     Eric Dumazet <eric.dumazet@gmail.com>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Alexander Lobakin <alobakin@pm.me>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Willem de Bruijn <willemb@google.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: Re: [PATCH v2 net] net: udp: fix Fast/frag0 UDP GRO
Message-ID: <Nc6hn1Qaui1C7hTlHl8CdsNV00CdlHtyjQYv36ZYA@cp4-web-040.plabs.ch>
In-Reply-To: <d9d09931-8cd3-1eb6-673c-3ae5ebc3ee57@gmail.com>
References: <0eaG8xtbtKY1dEKCTKUBubGiC9QawGgB3tVZtNqVdY@cp4-web-030.plabs.ch> <d9d09931-8cd3-1eb6-673c-3ae5ebc3ee57@gmail.com>
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

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Mon, 9 Nov 2020 18:37:36 +0100

> On 11/9/20 5:56 PM, Alexander Lobakin wrote:
>> While testing UDP GSO fraglists forwarding through driver that uses
>> Fast GRO (via napi_gro_frags()), I was observing lots of out-of-order
>> iperf packets:
>>
>> [ ID] Interval           Transfer     Bitrate         Jitter
>> [SUM]  0.0-40.0 sec  12106 datagrams received out-of-order
>>
>> Simple switch to napi_gro_receive() any other method without frag0
>> shortcut completely resolved them.
>>
>> I've found that UDP GRO uses udp_hdr(skb) in its .gro_receive()
>> callback. While it's probably OK for non-frag0 paths (when all
>> headers or even the entire frame are already in skb->data), this
>> inline points to junk when using Fast GRO (napi_gro_frags() or
>> napi_gro_receive() with only Ethernet header in skb->data and all
>> the rest in shinfo->frags) and breaks GRO packet compilation and
>> the packet flow itself.
>> To support both modes, skb_gro_header_fast() + skb_gro_header_slow()
>> are typically used. UDP even has an inline helper that makes use of
>> them, udp_gro_udphdr(). Use that instead of troublemaking udp_hdr()
>> to get rid of the out-of-order delivers.
>>
>> Present since the introduction of plain UDP GRO in 5.0-rc1.
>>
>> Since v1 [1]:
>>  - added a NULL pointer check for "uh" as suggested by Willem.
>>
>> [1] https://lore.kernel.org/netdev/YazU6GEzBdpyZMDMwJirxDX7B4sualpDG68AD=
ZYvJI@cp4-web-034.plabs.ch
>>
>> Fixes: e20cf8d3f1f7 ("udp: implement GRO for plain UDP sockets.")
>> Signed-off-by: Alexander Lobakin <alobakin@pm.me>
>> ---
>>  net/ipv4/udp_offload.c | 7 ++++++-
>>  1 file changed, 6 insertions(+), 1 deletion(-)
>>
>> diff --git a/net/ipv4/udp_offload.c b/net/ipv4/udp_offload.c
>> index e67a66fbf27b..7f6bd221880a 100644
>> --- a/net/ipv4/udp_offload.c
>> +++ b/net/ipv4/udp_offload.c
>> @@ -366,13 +366,18 @@ static struct sk_buff *udp4_ufo_fragment(struct sk=
_buff *skb,
>>  static struct sk_buff *udp_gro_receive_segment(struct list_head *head,
>>  =09=09=09=09=09       struct sk_buff *skb)
>>  {
>> -=09struct udphdr *uh =3D udp_hdr(skb);
>> +=09struct udphdr *uh =3D udp_gro_udphdr(skb);
>>  =09struct sk_buff *pp =3D NULL;
>>  =09struct udphdr *uh2;
>>  =09struct sk_buff *p;
>>  =09unsigned int ulen;
>>  =09int ret =3D 0;
>>
>> +=09if (unlikely(!uh)) {
>
> How uh could be NULL here ?
>
> My understanding is that udp_gro_receive() is called
> only after udp4_gro_receive() or udp6_gro_receive()
> validated that udp_gro_udphdr(skb) was not NULL.

Right, but only after udp{4,6}_lib_lookup_skb() in certain cases.
I don't know for sure if their logic can actually edit skb->data,
so it's better to check from my point of view.

>> +=09=09NAPI_GRO_CB(skb)->flush =3D 1;
>> +=09=09return NULL;
>> +=09}
>> +
>>  =09/* requires non zero csum, for symmetry with GSO */
>>  =09if (!uh->check) {
>>  =09=09NAPI_GRO_CB(skb)->flush =3D 1;
>>
>
>Why uh2 is left unchanged ?
>
>    uh2 =3D udp_hdr(p);
>
>...

Packets from list_head *head have their headers already pulled to
skb->data in 100% cases, no need to change anything here.
I double-checked that udp_hdr(p) always returns the same pointer as
"p->data + network offset" and left it as it is.

Thanks,
Al

