Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A97B495C5D
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 09:55:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379610AbiAUIzZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 03:55:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349644AbiAUIzW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 03:55:22 -0500
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 521E1C061574
        for <netdev@vger.kernel.org>; Fri, 21 Jan 2022 00:55:21 -0800 (PST)
Received: by mail-yb1-xb35.google.com with SMTP id v186so25669904ybg.1
        for <netdev@vger.kernel.org>; Fri, 21 Jan 2022 00:55:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kBeFLk8nIik4tR4MfjXtlPhKnhHrvx/36FoJ2Zpa+cs=;
        b=gOLp4NWAe+hUipU/d5ZgmtgiPoRHxy+C9P/4+6XE7zW68jndyvO3/uYwQVu3TXZiQc
         rC/sc/HlYvIWUCX42u5zcX7D/nUYaZqtu+d9tGhnLW3Rt7ENvfmYyEeuuRmCZ4hVn3Ja
         jX+Cb51eLxngrx1m3ETFfNRzD5WUJA6RPfxvkHgW632pvpPe9+5ChLMLtqm+d/4WSdl+
         3UiXOtUn4JbGT658himUxvMjLbE5D/779aoxrYFhpD+IiklRyarThtSGPyIg24ZzOR6c
         WZLhQ/3VNkEJ4Dy/aEo5eEpRnnVtUeYB5aNnpbWCSolqrnYycJwWOdcuu2hTGysH4Cu1
         XV6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kBeFLk8nIik4tR4MfjXtlPhKnhHrvx/36FoJ2Zpa+cs=;
        b=mUFq3lF+8visWfCC1bad/NIktfJ0pgK9X71ZDL8kXUnoRwclnrSdBp4bBED6swKgCK
         YGSwzRF02+/NQZWYcSpM1xSuuAW8V7XEU5eNhw8MNlO0DnBA7YIZJWhubuAUdoZDeQTF
         vmS0oiWaAzvUUvX5/kgIlogGJg2XMdV9RolVNKPKItDQZM5vSLd5tc07r97U2860Qp6j
         dXXxGdXghCOb5hnM4p6lbahSSjx4ENErbmCgMnq6dAACS/tDo8mn5yhlFt/HvXmvfkgp
         Qp3r+Oh8EBNTg4fAHDUBtcW6Elu3B0x+0bYWodL5Mir/pU4PIrDGtYNLufGwnpYDMGwC
         +2tg==
X-Gm-Message-State: AOAM530ESBff91r8WiODre3EjmcG+OdczNNgS+qgGSlWThBXbJl0cKN8
        KxXIPixIoqPPgI3YJ7mMlM0ytNbyf2flWZ71a1CANw==
X-Google-Smtp-Source: ABdhPJxrgYbkIml0IXCHVRmsN9gEzPT/DmyVrEx4DP69Z3qPDRLURTEPTFY/mszxjZR/Sau3wAwNv4+1rDE8bWvvQ3A=
X-Received: by 2002:a25:a06:: with SMTP id 6mr4602119ybk.5.1642755320048; Fri,
 21 Jan 2022 00:55:20 -0800 (PST)
MIME-Version: 1.0
References: <20220121011941.1123392-1-kuba@kernel.org>
In-Reply-To: <20220121011941.1123392-1-kuba@kernel.org>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 21 Jan 2022 00:55:08 -0800
Message-ID: <CANn89iKBchKPeumrdWVOf9onjM2qBm1D5_2CUToi57C+CEwoJw@mail.gmail.com>
Subject: Re: [PATCH net] ipv6: gro: flush instead of assuming different flows
 on hop_limit mismatch
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        David Ahern <dsahern@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 20, 2022 at 5:19 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> IPv6 GRO considers packets to belong to different flows when their
> hop_limit is different. This seems counter-intuitive, the flow is
> the same. hop_limit may vary because of various bugs or hacks but
> that doesn't mean it's okay for GRO to reorder packets.
>
> Practical impact of this problem on overall TCP performance
> is unclear, but TCP itself detects this reordering and bumps
> TCPSACKReorder resulting in user complaints.
>
> Note that the code plays an easy to miss trick by upcasting next_hdr
> to a u16 pointer and compares next_hdr and hop_limit in one go.
> Coalesce the flush setting to reduce the instruction count a touch.
>

There are downsides to this change.

We had an internal discussion at Google years ago about this
difference in behavior of IPv6/IPv4

We came to the conclusion the IPv6 behavior was better for our needs
(and we do not care
much about IPv4 GRO, since Google DC traffic is 99.99% IPv6)

In our case, we wanted to keep this 'ipv6 feature' because we were
experimenting with the idea of sending
TSO packets with different flowlabels, to use different paths in the
network, to increase nominal
throughput for WAN flows (one flow would use multiple fiber links)

The issue with 'ipv4 gro style about ttl mismatch' was that because of
small differences in RTT for each path,
 a receiver could very well receive mixed packets.

Even without playing with ECMP hashes, this scenario can happen if the sender
uses a bonding device in balance-rr mode.

After your change, GRO would be defeated and deliver one MSS at a time
to TCP stack.

We implemented SACK compress in TCP stack to avoid extra SACK being
sent by the receiver

We have an extension of this SACK compression for TCP flows terminated
by Google servers,
since modern TCP stacks do not need the old rule of TCP_FASTRETRANS_THRESH
DUPACK to start retransmits.

Something like this pseudo code:

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index dc49a3d551eb919baf5ad812ef21698c5c7b9679..d72554ab70fd2e16ed60dc78a905f4aa1414f8c9
100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -5494,7 +5494,8 @@ static void __tcp_ack_snd_check(struct sock *sk,
int ofo_possible)
        }
        if (tp->dup_ack_counter < TCP_FASTRETRANS_THRESH) {
                tp->dup_ack_counter++;
-               goto send_now;
+               if (peer_is_using_old_rule_about_fastretrans(tp))
+                       goto send_now;
        }
        tp->compressed_ack++;
        if (hrtimer_is_queued(&tp->compressed_ack_timer))



> Fixes: 787e92083601 ("ipv6: Add GRO support")
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  net/ipv6/ip6_offload.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/net/ipv6/ip6_offload.c b/net/ipv6/ip6_offload.c
> index b29e9ba5e113..570071a87e71 100644
> --- a/net/ipv6/ip6_offload.c
> +++ b/net/ipv6/ip6_offload.c
> @@ -249,7 +249,7 @@ INDIRECT_CALLABLE_SCOPE struct sk_buff *ipv6_gro_receive(struct list_head *head,
>                  if ((first_word & htonl(0xF00FFFFF)) ||
>                      !ipv6_addr_equal(&iph->saddr, &iph2->saddr) ||
>                      !ipv6_addr_equal(&iph->daddr, &iph2->daddr) ||
> -                    *(u16 *)&iph->nexthdr != *(u16 *)&iph2->nexthdr) {
> +                    iph->nexthdr != iph2->nexthdr) {
>  not_same_flow:
>                         NAPI_GRO_CB(p)->same_flow = 0;
>                         continue;
> @@ -260,8 +260,9 @@ INDIRECT_CALLABLE_SCOPE struct sk_buff *ipv6_gro_receive(struct list_head *head,
>                                 goto not_same_flow;
>                 }
>                 /* flush if Traffic Class fields are different */
> -               NAPI_GRO_CB(p)->flush |= !!(first_word & htonl(0x0FF00000));
> -               NAPI_GRO_CB(p)->flush |= flush;
> +               NAPI_GRO_CB(p)->flush |= flush |
> +                                        !!((first_word & htonl(0x0FF00000)) |
> +                                           (iph->hop_limit ^ iph2->hop_limit));
>
>                 /* If the previous IP ID value was based on an atomic
>                  * datagram we can overwrite the value and ignore it.
> --
> 2.31.1
>
