Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4082BD1335
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 17:48:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731083AbfJIPs3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 11:48:29 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:46937 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729644AbfJIPs3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 11:48:29 -0400
Received: by mail-wr1-f68.google.com with SMTP id o18so3588960wrv.13
        for <netdev@vger.kernel.org>; Wed, 09 Oct 2019 08:48:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=K92kBHDwfgi01B/qol924kxca+Ki3dY6qt1VYA/2S8w=;
        b=p6Qcxv/U+r6eMsnroCRtlKmlZzuThmhuFC9ZP3D2LVR0HTDVzqnjgwsTLw2QZ7LA5y
         yQjVdp1ypqyO/CqKFuK3o+8HvNc2KDwiEzC9NilXqgUa58m1fHg73BmolxuxDyKKGEQo
         /WE0HjyHxRaPkRkfrypoiaJiq81c0PlBWdUx+QStHpef8Yrq0dmX4UT1FmrEGkP0bOZr
         oPhzTRu1mZZa8Xc4Ra+WU1sRqp+9eg0NbZGDp85FoGdkx49gqbdV8ohlrT43gKlFcMvs
         kXumkGWs5awSGFJexjJSY5pxhN8oMazSHsj2w5aSFzMx58DRIsXeWewanrxHcLGQAO5N
         JXwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=K92kBHDwfgi01B/qol924kxca+Ki3dY6qt1VYA/2S8w=;
        b=aySOLIaD0s2eyWf1A+vwTOgJH6poe8G1i2RncD98DeXMy1rX9rKmkfNWSlTVW/lpmZ
         4niRZ1gvqoFnAwDOkWXYBOQsVR5CxIC5i++cxqerdl7b1UOh9MM9ekARV+AbJmRlcnTb
         V53+FmDEFq+YcP5JsT3cRjYlpVqvg9beUPFzPl2XPc87/dj7BX1ICSdB6322xiZKEox6
         ghSjXdxlFqtr95HekCFIi8VqY5P27LMw7aR3UTIfrt3r1PlAB3Xl+wlD8QWQbw/xKrHk
         HwGPRLKS0g3bLghzrZ3iWFJH4Uj5DGEVusCjljIwkqDV/DhwNOYuysaDxo779NxmGW0z
         pGkA==
X-Gm-Message-State: APjAAAX9rMuC272DARTrBb8tNLDQGtFs1TLfdDyqmFH7ejEf2Wmo+MDz
        44xLdixkh6KOZXkTbY2UuORS2jiLiMJismiv96c=
X-Google-Smtp-Source: APXvYqxWoalxUxHD3j36Sp3jIoZimpoGA00NUahOO4hGc6wZT4npiC7GmaH9UtK/uoIJC8G3sUEXGjWR3pemibycKNw=
X-Received: by 2002:a5d:55ca:: with SMTP id i10mr3365055wrw.12.1570636104329;
 Wed, 09 Oct 2019 08:48:24 -0700 (PDT)
MIME-Version: 1.0
References: <1540332271-15564-1-git-send-email-stranche@codeaurora.org>
In-Reply-To: <1540332271-15564-1-git-send-email-stranche@codeaurora.org>
From:   Maxim Mikityanskiy <maxtram95@gmail.com>
Date:   Wed, 9 Oct 2019 18:47:57 +0300
Message-ID: <CAKErNvp58zokwB2u6cSqOHAuse_ROAbKy3sdyPY_EswnoGVLGw@mail.gmail.com>
Subject: Re: [PATCH net v2] net: udp: fix handling of CHECKSUM_COMPLETE packets
To:     Sean Tranchetti <stranche@codeaurora.org>
Cc:     Maxim Mikityanskiy <maximmi@mellanox.com>, eric.dumazet@gmail.com,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Sam Kumar <samanthakumar@google.com>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sean,

I was analyzing this code and have some concerns. Please see the comments below.

On Wed, Oct 24, 2018 at 1:04 AM Sean Tranchetti <stranche@codeaurora.org> wrote:
>
> Current handling of CHECKSUM_COMPLETE packets by the UDP stack is
> incorrect for any packet that has an incorrect checksum value.
>
> udp4/6_csum_init() will both make a call to
> __skb_checksum_validate_complete() to initialize/validate the csum
> field when receiving a CHECKSUM_COMPLETE packet. When this packet
> fails validation, skb->csum will be overwritten with the pseudoheader
> checksum so the packet can be fully validated by software, but the
> skb->ip_summed value will be left as CHECKSUM_COMPLETE so that way
> the stack can later warn the user about their hardware spewing bad
> checksums. Unfortunately, leaving the SKB in this state can cause
> problems later on in the checksum calculation.
>
> Since the the packet is still marked as CHECKSUM_COMPLETE,
> udp_csum_pull_header() will SUBTRACT the checksum of the UDP header
> from skb->csum instead of adding it, leaving us with a garbage value
> in that field. Once we try to copy the packet to userspace in the
> udp4/6_recvmsg(), we'll make a call to skb_copy_and_csum_datagram_msg()
> to checksum the packet data and add it in the garbage skb->csum value
> to perform our final validation check.
>
> Since the value we're validating is not the proper checksum, it's possible
> that the folded value could come out to 0, causing us not to drop the
> packet. Instead, we believe that the packet was checksummed incorrectly
> by hardware since skb->ip_summed is still CHECKSUM_COMPLETE, and we attempt
> to warn the user with netdev_rx_csum_fault(skb->dev);
>
> Unfortunately, since this is the UDP path, skb->dev has been overwritten
> by skb->dev_scratch and is no longer a valid pointer, so we end up
> reading invalid memory.
>
> This patch addresses this problem in two ways:
>         1) Do not use the dev pointer when calling netdev_rx_csum_fault()
>            from skb_copy_and_csum_datagram_msg(). Since this gets called
>            from the UDP path where skb->dev has been overwritten, we have
>            no way of knowing if the pointer is still valid. Also for the
>            sake of consistency with the other uses of
>            netdev_rx_csum_fault(), don't attempt to call it if the
>            packet was checksummed by software.
>
>         2) Add better CHECKSUM_COMPLETE handling to udp4/6_csum_init().
>            If we receive a packet that's CHECKSUM_COMPLETE that fails
>            verification (i.e. skb->csum_valid == 0), check who performed
>            the calculation. It's possible that the checksum was done in
>            software by the network stack earlier (such as Netfilter's
>            CONNTRACK module), and if that says the checksum is bad,
>            we can drop the packet immediately instead of waiting until
>            we try and copy it to userspace. Otherwise, we need to
>            mark the SKB as CHECKSUM_NONE, since the skb->csum field
>            no longer contains the full packet checksum after the
>            call to __skb_checksum_validate_complete().
>
> Fixes: e6afc8ace6dd ("udp: remove headers from UDP packets before queueing")
> Fixes: c84d949057ca ("udp: copy skb->truesize in the first cache line")
> Cc: Sam Kumar <samanthakumar@google.com>
> Cc: Eric Dumazet <edumazet@google.com>
> Signed-off-by: Sean Tranchetti <stranche@codeaurora.org>
> ---
>  net/core/datagram.c     |  5 +++--
>  net/ipv4/udp.c          | 20 ++++++++++++++++++--
>  net/ipv6/ip6_checksum.c | 20 ++++++++++++++++++--
>  3 files changed, 39 insertions(+), 6 deletions(-)
>
> diff --git a/net/core/datagram.c b/net/core/datagram.c
> index 9aac0d6..df16493 100644
> --- a/net/core/datagram.c
> +++ b/net/core/datagram.c
> @@ -808,8 +808,9 @@ int skb_copy_and_csum_datagram_msg(struct sk_buff *skb,
>                         return -EINVAL;
>                 }
>
> -               if (unlikely(skb->ip_summed == CHECKSUM_COMPLETE))
> -                       netdev_rx_csum_fault(skb->dev);
> +               if (unlikely(skb->ip_summed == CHECKSUM_COMPLETE) &&
> +                   !skb->csum_complete_sw)
> +                       netdev_rx_csum_fault(NULL);

Here you are fixing skb_copy_and_csum_datagram_msg, but this is not
the only flow that leads to netdev_rx_csum_fault. This function is
also called from __skb_checksum_complete (also after using the screwed
up skb->csum), and there are two ways we can get to
__skb_checksum_complete:

1. Directly from skb_copy_and_csum_datagram_msg.

2. udpv6_recvmsg -> __udp_lib_checksum_complete -> __skb_checksum_complete:

if (copied < ulen || peeking ||
    (is_udplite && UDP_SKB_CB(skb)->partial_cov)) {
        checksum_valid = udp_skb_csum_unnecessary(skb) ||
                        !__udp_lib_checksum_complete(skb);
        if (!checksum_valid)
                goto csum_copy_err;
}

It looks to me, as if these flows may also lead to parsing
skb->dev_scratch as skb->dev.

>         }
>         return 0;
>  fault:
> diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
> index c32a4c1..f8183fd 100644
> --- a/net/ipv4/udp.c
> +++ b/net/ipv4/udp.c
> @@ -2120,8 +2120,24 @@ static inline int udp4_csum_init(struct sk_buff *skb, struct udphdr *uh,
>         /* Note, we are only interested in != 0 or == 0, thus the
>          * force to int.
>          */
> -       return (__force int)skb_checksum_init_zero_check(skb, proto, uh->check,
> -                                                        inet_compute_pseudo);
> +       err = (__force int)skb_checksum_init_zero_check(skb, proto, uh->check,
> +                                                       inet_compute_pseudo);
> +       if (err)
> +               return err;
> +
> +       if (skb->ip_summed == CHECKSUM_COMPLETE && !skb->csum_valid) {
> +               /* If SW calculated the value, we know it's bad */
> +               if (skb->csum_complete_sw)
> +                       return 1;
> +
> +               /* HW says the value is bad. Let's validate that.
> +                * skb->csum is no longer the full packet checksum,
> +                * so don't treat it as such.
> +                */
> +               skb_checksum_complete_unset(skb);
> +       }
> +
> +       return 0;
>  }
>
>  /* wrapper for udp_queue_rcv_skb tacking care of csum conversion and
> diff --git a/net/ipv6/ip6_checksum.c b/net/ipv6/ip6_checksum.c
> index 547515e..3777170 100644
> --- a/net/ipv6/ip6_checksum.c
> +++ b/net/ipv6/ip6_checksum.c
> @@ -88,8 +88,24 @@ int udp6_csum_init(struct sk_buff *skb, struct udphdr *uh, int proto)
>          * Note, we are only interested in != 0 or == 0, thus the
>          * force to int.
>          */
> -       return (__force int)skb_checksum_init_zero_check(skb, proto, uh->check,
> -                                                        ip6_compute_pseudo);
> +       err = (__force int)skb_checksum_init_zero_check(skb, proto, uh->check,
> +                                                       ip6_compute_pseudo);
> +       if (err)
> +               return err;
> +
> +       if (skb->ip_summed == CHECKSUM_COMPLETE && !skb->csum_valid) {
> +               /* If SW calculated the value, we know it's bad */
> +               if (skb->csum_complete_sw)
> +                       return 1;
> +
> +               /* HW says the value is bad. Let's validate that.
> +                * skb->csum is no longer the full packet checksum,
> +                * so don't treat is as such.
> +                */
> +               skb_checksum_complete_unset(skb);

If I understand it correctly, we'll have ip_summed == CHECKSUM_NONE
after this point, so __skb_checksum_complete won't call
netdev_rx_csum_fault anymore in case of bad hardware that calculates
checksums incorrectly.

> +       }
> +
> +       return 0;
>  }
>  EXPORT_SYMBOL(udp6_csum_init);
>

Are my concerns real, or am I missing anything? If my points are
valid, do you have ideas how it could be fixed?

Thanks and looking forward to your reply.
