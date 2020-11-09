Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD1262AC121
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 17:43:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730502AbgKIQmy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 11:42:54 -0500
Received: from mail-40134.protonmail.ch ([185.70.40.134]:36031 "EHLO
        mail-40134.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726410AbgKIQmx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 11:42:53 -0500
Date:   Mon, 09 Nov 2020 16:42:44 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1604940170; bh=B3gjp1cx0ay+GW92ZkmYrI76+YY6rmkXid9EU3kmo4M=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=cHg3+r/VBaOAQAqKH7+E2qA9Hc9DX0O2NnWAHfX+/aedZZOas+n2vI0jWC/816fSq
         zjs9J4sOo/Cr8uOuHaxIBf8bFtVMP+QsG/qmybPsLDTiVG1o7sTJqYhE/NWQrxJT/T
         IdQjGmpSidm5ASb6acIiDSOXEy4/Seq1bHl3kEh8S+tMrto/GkeTFEIZXkk2c8neeA
         WyIKivXtWw5sGzcccnPZi5HDx+aiCb899aGkUX1jLgepX3w7C8a5J5wY6MeVx7ipGI
         geMD+EtF/ZbiDcFUTLULkT0LiITrtt7uHM5VNJtrnXYasLphmsr8bHHQQGAPW5+rP1
         lhk0Zyc/Ydd7g==
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Alexander Lobakin <alobakin@pm.me>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: Re: [PATCH net] net: udp: fix Fast/frag0 UDP GRO
Message-ID: <XSgG3DIkTqqsRK6pTSfiht6Uyy0DaJYdPbHjPv1ac@cp4-web-027.plabs.ch>
In-Reply-To: <CA+FuTSfokZNJv2g2mCK284UTj7nN_-qXei42J4QWt7YniSrKog@mail.gmail.com>
References: <YazU6GEzBdpyZMDMwJirxDX7B4sualpDG68ADZYvJI@cp4-web-034.plabs.ch> <CA+FuTSfokZNJv2g2mCK284UTj7nN_-qXei42J4QWt7YniSrKog@mail.gmail.com>
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
Date: Mon, 9 Nov 2020 09:36:12 -0500

> On Sat, Nov 7, 2020 at 8:11 PM Alexander Lobakin <alobakin@pm.me> wrote:
>>
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
>> Fixes: e20cf8d3f1f7 ("udp: implement GRO for plain UDP sockets.")
>> Signed-off-by: Alexander Lobakin <alobakin@pm.me>
>> ---
>>  net/ipv4/udp_offload.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/net/ipv4/udp_offload.c b/net/ipv4/udp_offload.c
>> index e67a66fbf27b..13740e9fe6ec 100644
>> --- a/net/ipv4/udp_offload.c
>> +++ b/net/ipv4/udp_offload.c
>> @@ -366,7 +366,7 @@ static struct sk_buff *udp4_ufo_fragment(struct sk_b=
uff *skb,
>>  static struct sk_buff *udp_gro_receive_segment(struct list_head *head,
>>                                                struct sk_buff *skb)
>>  {
>> -       struct udphdr *uh =3D udp_hdr(skb);
>> +       struct udphdr *uh =3D udp_gro_udphdr(skb);
>>         struct sk_buff *pp =3D NULL;
>>         struct udphdr *uh2;
>>         struct sk_buff *p;
>
> Good catch. skb_gro_header_slow may fail and return NULL. Need to
> check that before dereferencing uh below in

Ah, sure. It's very unlikely condition, but "better safe than sorry"
(c). Thanks, will do v2 soon.

>>         /* requires non zero csum, for symmetry with GSO */
>>         if (!uh->check) {
>>                 NAPI_GRO_CB(skb)->flush =3D 1;
>>                 return NULL;
>>         }

Al

