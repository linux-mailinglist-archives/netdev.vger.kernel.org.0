Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E880B2AC433
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 19:54:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729697AbgKISyH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 13:54:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729243AbgKISyG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 13:54:06 -0500
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91CF9C0613CF;
        Mon,  9 Nov 2020 10:54:06 -0800 (PST)
Received: by mail-wm1-x342.google.com with SMTP id a65so477841wme.1;
        Mon, 09 Nov 2020 10:54:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=OvzMD659ywrxq8cwYUTmLS551BX9LjK8A0JTdHbis88=;
        b=pD05OrEPFS2g2Xpn8cZxWSKC3h18glZBQlXzdHkY0I4OesAfy3Y1pq9u8PATIqbqf+
         ogID5o+JuvO//f3/poA7FzcQ0IbcNPkEnjkVhsJw5bOvE0wM6f0NXTOpeGtPIaFeDWCD
         jtejADySeQbEjJRjjgUhSVZDqLrODPO41VQWh0d4GYJCTC/GIfMWUr4CY1yJRqOrmIdd
         lOnVNt1fw9+s3EqC2pMGBPWoI0Cyjk7hS3T2n2ulL5PIhMMNmi6dtWAgKuCj5U11mrwk
         IJwvFSmJPW5b6/eKneBJ+jWLP+gzAIfdyDlMmTiz6RJWKCoN8eoXKtdVTpzhFd6ft0MP
         WxBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OvzMD659ywrxq8cwYUTmLS551BX9LjK8A0JTdHbis88=;
        b=TDn3sujJ6sz7qQ8AyjW9HO/tDTLxH0e4Gcr3zd39tpArqBGg0tPgt30w+FpsffDh0e
         7m3vcBrEtkpXHvxjmQBMjw2iv9bQ9ZbPZiPCOkQd3vVX4FPdzDHARjiux5wP35wMKVUp
         VKJy4u1r3GJps/3FQS1GtDDmUamd9aG5WEXfJeI9RwLjBpi1yNuG4Ko9gvPi0lnPWBkc
         o0kzId0zBjZHUs1KkEbNqCVsbjcRzlygu1MP762qWWmd8B8POjjeSi3vBfCKs0yPsfXS
         176GEsuxcG54aPPqgfD2Kd9Eq55oP5jdnlvXU8XwDMTm1krfnZu0PJgPBEPSk8NRg1mc
         1UxA==
X-Gm-Message-State: AOAM5301VteiywC1miQl16F0+ghsfxUeFEmoFxvjOxXWrOP2zZxj4tXh
        SxAs1psknMK5ILcb6vEkllL6xj7Hp9A=
X-Google-Smtp-Source: ABdhPJz8Ivh1nkGhAmS7AtezO5VKur/i0+6GuwGQfnBJh6PrnLvje+F0asXnJ+QTVzzWwvzN4+QBbw==
X-Received: by 2002:a1c:7e11:: with SMTP id z17mr608535wmc.83.1604948044891;
        Mon, 09 Nov 2020 10:54:04 -0800 (PST)
Received: from [192.168.8.114] ([37.170.31.34])
        by smtp.gmail.com with ESMTPSA id p10sm14068008wre.2.2020.11.09.10.54.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Nov 2020 10:54:04 -0800 (PST)
Subject: Re: [PATCH v2 net] net: udp: fix Fast/frag0 UDP GRO
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Alexander Lobakin <alobakin@pm.me>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
References: <0eaG8xtbtKY1dEKCTKUBubGiC9QawGgB3tVZtNqVdY@cp4-web-030.plabs.ch>
 <d9d09931-8cd3-1eb6-673c-3ae5ebc3ee57@gmail.com>
 <CA+FuTSc0QLM4QpinZ1XiLreRECBDVbanwoFtMhnF6caEWjXTBw@mail.gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <3729478a-77b5-aeb5-0192-49f0e0d170ac@gmail.com>
Date:   Mon, 9 Nov 2020 19:54:02 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <CA+FuTSc0QLM4QpinZ1XiLreRECBDVbanwoFtMhnF6caEWjXTBw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/9/20 7:28 PM, Willem de Bruijn wrote:
> On Mon, Nov 9, 2020 at 12:37 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>>
>>
>>
>> On 11/9/20 5:56 PM, Alexander Lobakin wrote:
>>> While testing UDP GSO fraglists forwarding through driver that uses
>>> Fast GRO (via napi_gro_frags()), I was observing lots of out-of-order
>>> iperf packets:
>>>
>>> [ ID] Interval           Transfer     Bitrate         Jitter
>>> [SUM]  0.0-40.0 sec  12106 datagrams received out-of-order
>>>
>>> Simple switch to napi_gro_receive() any other method without frag0
>>> shortcut completely resolved them.
>>>
>>> I've found that UDP GRO uses udp_hdr(skb) in its .gro_receive()
>>> callback. While it's probably OK for non-frag0 paths (when all
>>> headers or even the entire frame are already in skb->data), this
>>> inline points to junk when using Fast GRO (napi_gro_frags() or
>>> napi_gro_receive() with only Ethernet header in skb->data and all
>>> the rest in shinfo->frags) and breaks GRO packet compilation and
>>> the packet flow itself.
>>> To support both modes, skb_gro_header_fast() + skb_gro_header_slow()
>>> are typically used. UDP even has an inline helper that makes use of
>>> them, udp_gro_udphdr(). Use that instead of troublemaking udp_hdr()
>>> to get rid of the out-of-order delivers.
>>>
>>> Present since the introduction of plain UDP GRO in 5.0-rc1.
>>>
>>> Since v1 [1]:
>>>  - added a NULL pointer check for "uh" as suggested by Willem.
>>>
>>> [1] https://lore.kernel.org/netdev/YazU6GEzBdpyZMDMwJirxDX7B4sualpDG68ADZYvJI@cp4-web-034.plabs.ch
>>>
>>> Fixes: e20cf8d3f1f7 ("udp: implement GRO for plain UDP sockets.")
>>> Signed-off-by: Alexander Lobakin <alobakin@pm.me>
>>> ---
>>>  net/ipv4/udp_offload.c | 7 ++++++-
>>>  1 file changed, 6 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/net/ipv4/udp_offload.c b/net/ipv4/udp_offload.c
>>> index e67a66fbf27b..7f6bd221880a 100644
>>> --- a/net/ipv4/udp_offload.c
>>> +++ b/net/ipv4/udp_offload.c
>>> @@ -366,13 +366,18 @@ static struct sk_buff *udp4_ufo_fragment(struct sk_buff *skb,
>>>  static struct sk_buff *udp_gro_receive_segment(struct list_head *head,
>>>                                              struct sk_buff *skb)
>>>  {
>>> -     struct udphdr *uh = udp_hdr(skb);
>>> +     struct udphdr *uh = udp_gro_udphdr(skb);
>>>       struct sk_buff *pp = NULL;
>>>       struct udphdr *uh2;
>>>       struct sk_buff *p;
>>>       unsigned int ulen;
>>>       int ret = 0;
>>>
>>> +     if (unlikely(!uh)) {
>>
>> How uh could be NULL here ?
>>
>> My understanding is that udp_gro_receive() is called
>> only after udp4_gro_receive() or udp6_gro_receive()
>> validated that udp_gro_udphdr(skb) was not NULL.
> 
> Oh indeed. This has already been checked before.
> 
>>> +             NAPI_GRO_CB(skb)->flush = 1;
>>> +             return NULL;
>>> +     }
>>> +
>>>       /* requires non zero csum, for symmetry with GSO */
>>>       if (!uh->check) {
>>>               NAPI_GRO_CB(skb)->flush = 1;
>>>
>>
>> Why uh2 is left unchanged ?
>>
>>     uh2 = udp_hdr(p);
> 
> Isn't that the same as th2 = tcp_hdr(p) in tcp_gro_receive? no frag0
> optimization to worry about for packets on the list.

My feeling was that tcp_gro_receive() is terminal in the GRO stack.

While UDP could be encapsulated in UDP :)

I guess we do not support this yet.

Years ago we made sure to propagate the current header offset into GRO stack
(when we added SIT/IPIP/GRE support to GRO)
299603e8370a93dd5d8e8d800f0dff1ce2c53d36 ("net-gro: Prepare GRO stack for the upcoming tunneling support")


udp_hdr() is using transport header, which is unique for skb "on the list"

