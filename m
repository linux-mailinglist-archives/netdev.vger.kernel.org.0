Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61A1E31E2FA
	for <lists+netdev@lfdr.de>; Thu, 18 Feb 2021 00:19:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231466AbhBQXTF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 18:19:05 -0500
Received: from mail.zx2c4.com ([104.131.123.232]:50168 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229774AbhBQXTD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Feb 2021 18:19:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1613603900;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AdrWV+0RqhKCTxk9ZB3XViePvtjikVcHH9GgVrWTd7k=;
        b=O+2A58Bl3UDsyNIyinZjpQM9ivnsh1sOLIQka876ehzrRILUCXsUkUTQk5rjCHhlN7BNz+
        WGPLnZydELSSq4c7LuY18LrsewQOLFjvF3DrQ88sIyDGST6llAvXKwL8qKB/KwZ33YC8lP
        crbbwE0IffNQBN9o9w37DduavYA24GM=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id a67271fe (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Wed, 17 Feb 2021 23:18:20 +0000 (UTC)
Received: by mail-yb1-f175.google.com with SMTP id u3so341023ybk.6;
        Wed, 17 Feb 2021 15:18:20 -0800 (PST)
X-Gm-Message-State: AOAM530WHkyxJjmO9ulUdkgMBz6eKj9RACrD7D7ZX07iQsZwlS1PtHYz
        TXmPqtIEoMGp7anU06SrN+d5y5jYXJlMh6xpqjw=
X-Google-Smtp-Source: ABdhPJzHFoKDH/ZMtpGk4JJaz0HtVODj3UjZQBaRjwppT6zywQcfNjkMCTDE2i6TWrTwHS8e5Ss25NMgNFsfNnp1p8A=
X-Received: by 2002:a25:4981:: with SMTP id w123mr2560681yba.123.1613603900090;
 Wed, 17 Feb 2021 15:18:20 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:7110:8013:b029:34:f999:a3fe with HTTP; Wed, 17 Feb 2021
 15:18:19 -0800 (PST)
In-Reply-To: <CAF=yD-+Fm7TuggoEeP=Wy7DEmfuC6nxmyBQxX=EzhyTQsiP2DQ@mail.gmail.com>
References: <CAHmME9qfXFZKZfO-uc7GC3xguSq99_CqrTtzmgp_984MSfNbgA@mail.gmail.com>
 <CA+FuTSfHRtV7kP-y6ihW_BnYVmHE9Hv7jHgOdTwJhUXkd6L79w@mail.gmail.com>
 <CAHmME9qRkxeKDA6pOXTE7yXTkN-AsfaDfLfUX8J7EP7fbUiB0Q@mail.gmail.com> <CAF=yD-+Fm7TuggoEeP=Wy7DEmfuC6nxmyBQxX=EzhyTQsiP2DQ@mail.gmail.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Thu, 18 Feb 2021 00:18:19 +0100
X-Gmail-Original-Message-ID: <CAHmME9oe59WAdNS-AjJP9rQ+Fc6TfQVh7aHABc3JNTJaZ3sVLA@mail.gmail.com>
Message-ID: <CAHmME9oe59WAdNS-AjJP9rQ+Fc6TfQVh7aHABc3JNTJaZ3sVLA@mail.gmail.com>
Subject: Re: possible stack corruption in icmp_send (__stack_chk_fail)
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Willem de Bruijn <willemb@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/18/21, Willem de Bruijn <willemdebruijn.kernel@gmail.com> wrote:
> On Wed, Feb 17, 2021 at 5:56 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>>
>> Hi Willem,
>>
>> On Wed, Feb 17, 2021 at 11:27 PM Willem de Bruijn
>> <willemdebruijn.kernel@gmail.com> wrote:
>> > A vmlinux image might help. I couldn't find one for this kernel.
>>
>> https://data.zx2c4.com/icmp_send-crash-e03b4a42-706a-43bf-bc40-1f15966b3216.tar.xz
>> has .debs with vmlinuz in there, which you can extract to vmlinux, as
>> well as my own vmlinux elf construction with the symbols added back in
>> by extracting them from kallsyms. That's the best I've been able to
>> do, as all of this is coming from somebody random emailing me.
>>
>> > But could it be
>> > that the forwarded packet is not sensible IPv4? The skb->protocol is
>> > inferred in wg_packet_consume_data_done->ip_tunnel_parse_protocol.
>>
>> The wg calls to icmp_ndo_send are gated by checking skb->protocol:
>>
>>         if (skb->protocol == htons(ETH_P_IP))
>>                icmp_ndo_send(skb, ICMP_DEST_UNREACH, ICMP_HOST_UNREACH,
>> 0);
>>        else if (skb->protocol == htons(ETH_P_IPV6))
>>                icmpv6_ndo_send(skb, ICMPV6_DEST_UNREACH,
>> ICMPV6_ADDR_UNREACH, 0);
>>
>> On the other hand, that code is hit on an error path when
>> wg_check_packet_protocol returns false:
>>
>> static inline bool wg_check_packet_protocol(struct sk_buff *skb)
>> {
>>        __be16 real_protocol = ip_tunnel_parse_protocol(skb);
>>        return real_protocol && skb->protocol == real_protocol;
>> }
>>
>> So that means, at least in theory, icmp_ndo_send could be called with
>> skb->protocol != ip_tunnel_parse_protocol(skb). I guess I can address
>> that. But... is it actually a problem?
>
> For this forwarded packet that arrived on a wireguard tunnel,
> skb->protocol was originally also set by ip_tunnel_parse_protocol.
> So likely not.
>
> The other issue seems more like a real bug. wg_xmit calling
> icmp_ndo_send without clearing IPCB first.
>

Bingo! Nice eye! I confirmed the crash by just memsetting 0x41 to cb
before the call. Clearly this should be zeroed by icmp_ndo_xmit. Will
send a patch for icmp_ndo_xmit momentarily and will CC you.

Jason
