Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A59A47D649
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 19:10:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344512AbhLVSKF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 13:10:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234629AbhLVSKF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 13:10:05 -0500
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBC60C061574
        for <netdev@vger.kernel.org>; Wed, 22 Dec 2021 10:10:04 -0800 (PST)
Received: by mail-yb1-xb32.google.com with SMTP id y68so9151220ybe.1
        for <netdev@vger.kernel.org>; Wed, 22 Dec 2021 10:10:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KxfjhktGinihZ582cVTF96r0qqlmYfu/Or2h1yFUKkU=;
        b=Se+/IHvRuH7qDC0U2YeiQYqvzqDCv8q9zNRCglELcOXP2degPa/9ITgrrmFVpIaiCI
         X/Ps65u1shTwSLa8SaZ/W42lgtRZcoFMB2y+B9XUz9YXyUJoAvdqaJdJL+aAjxGgId3o
         D90k1Pi5Ez4B3equimt4aZFPCMb3s7N5nLL6Vyda8CA9dQSxw7lEHFagtyMYRgpBsgHp
         e2mg26opLYAy9nsYrGek0gqcaT38eIoF30hd39aFVUIDbobYVcsT36MkkOSkTErbK95j
         aMcBYT1/kX8EZkFW0zQ9P8WpihDGuhKpf9Ro4ecBKvRLO/IjrB4J9A4O98aObAc6qA3/
         TItQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KxfjhktGinihZ582cVTF96r0qqlmYfu/Or2h1yFUKkU=;
        b=AT+7BDefv+Qn50upDrMJS4Y/7M/486Y9DGKGbCg/bsYh9eelSOqRjCCqTqXiNrn94K
         3rVGwwOKMQCqUI/14HuABWJtjE0cNccuxgiL0zi0b7szZdt6U+uTbQ8ZC9yK0WcG4AKu
         1/j0jwUU6iUBVlqtY2eIKJoWTgjKeU/wtcAixl0c2luMzxGIpetRIO7YjEF+C9UhK9bT
         +/e484GL4QJe30va3Ftmoh+GJEntGqP8ZQ8sKNuKkL9FaguVFisSH/MBQjNCpdhO23y6
         b/8NRiw8kzKo3tQnFYng5kEPe+jSxHqIFKP6MjOfcES7VH/ChLtfiAtuQIwGdVHMs1CG
         jjng==
X-Gm-Message-State: AOAM533kwqnRiXk68Lhton5mMttKXAp2TIzoH46TNI+cEGVQS9xs9IX4
        L+z052M09jSDpf6hpPmv+eQpJ0IO7uZ+j/jWXOehCA==
X-Google-Smtp-Source: ABdhPJxQnW1FDX2AzqzPGaua6s5N61Z4J6ZNsLcO2qxg6admc0mWo3nSqmm/fRTGw/gf7xPo+VyjSP37GfJyoA8VABE=
X-Received: by 2002:a25:df4f:: with SMTP id w76mr6468607ybg.711.1640196603657;
 Wed, 22 Dec 2021 10:10:03 -0800 (PST)
MIME-Version: 1.0
References: <CABWYdi3bzd4P0nsyZe6P6coBCQ2jN=kVOJte62zKj=Q8iJCSOQ@mail.gmail.com>
In-Reply-To: <CABWYdi3bzd4P0nsyZe6P6coBCQ2jN=kVOJte62zKj=Q8iJCSOQ@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 22 Dec 2021 10:09:52 -0800
Message-ID: <CANn89i+mhqGaM2tuhgEmEPbbNu_59GGMhBMha4jnnzFE=UBNYg@mail.gmail.com>
Subject: Re: Initial TCP receive window is clamped to 64k by rcv_ssthresh
To:     Ivan Babrou <ivan@cloudflare.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        kernel-team <kernel-team@cloudflare.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 22, 2021 at 9:46 AM Ivan Babrou <ivan@cloudflare.com> wrote:
>
> Hello,
>
> I noticed that the advertised TCP receive window in the first ACK from
> the client is clamped at 64k. I'm wondering if this is intentional.
>
> We have an environment with many pairs of distant servers connected by
> high BDP links. For the reasons that aren't relevant, we need to
> re-establish connections between those often and expect to have as few
> round trips as possible to get a response after a handshake.
>
> We have made BBR cooperate on the initcwnd front with TCP_BPF_IW and
> some code that remembers cwnd and lets new connections start with a
> high value. It's safe to assume that we set initcwnd to 250 from the
> server side. I have no issues with the congestion control side of
> things.
>
> We also have high rmem and wmem values and plenty of memory.
>
> The problem lies in the fact that no matter how high we crank up the
> initcwnd, the connection will hit the 64k wall of the receive window
> and will have to stall waiting on ACKs from the other side, which take
> a long while to arrive on high latency links. A realistic scenario:
>
> 1. TCP connection established, receive window = 64k.
> 2. Client sends a request.
> 3. Server userspace program generates a 120k response and writes it to
> the socket. That's T0.
> 4. Server sends 64k worth of data in TCP packets to the client.
> 5. Client sees the first 64k worth of data T0 + RTT/2 later.
> 6. Client sends ACKs to cover for the data it just received.
> 7. Server sees the ACKs T0 + 1 RTT later.
> 8. Server sends the remaining data.
> 9. Client sees the remaining data T0 + RTT + RTT/2 later.
>
> In my mind, on a good network (guarded by the initcwnd) I expect to
> have the whole response to be sent immediately at T0 and received
> RTT/2 later.
>
> The current TCP connection establishment code picks two window sizes
> in tcp_select_initial_window() during the SYN packet generation:
>
> * rcv_wnd to advertise (cannot be higher than 64k during SYN, as we
> don't know whether wscale is supported yet)
> * window_clamp (current max memory allowed for the socket, can be large)
>
> You can find these in code here:
>
> * https://elixir.bootlin.com/linux/v5.15.10/source/include/linux/tcp.h#L209
>
> The call into tcp_select_initial_window() is here:
>
> * https://elixir.bootlin.com/linux/v5.15.10/source/net/ipv4/tcp_output.c#L3682
>
> Then immediately after rcv_ssthresh is set to rcv_wnd. This is the
> part that gives me pause.
>
> During the generation of the first ACK after the SYN ACK is received
> on the client, assuming the window scaling is supported, I expect the
> client to advertise the whole buffer as available and let congestion
> control handle whether it can be filled from the sender side. What
> happens in reality is that rcv_ssthresh is sent as the window value.
> Unfortunately, rcv_ssthresh is limited to 64k from rcv_wnd as
> described above.
>
> My question is whether it should be limited to window_clamp in
> tcp_connect_init() instead.
>
> I tried looking through git history and the following line was there
> since Git import in 2005:
>
>   tp->rcv_ssthresh = tp->rcv_wnd;
>
> I made a small patch that toggles rcv_ssthresh between rcv_wnd and
> window_clamp and I'm doing some testing to see if it solves my issue.
> I can see it advertise 512k receive buffer in the first ACK from the
> client, which seems to address my problem. I'm not sure if there's
> some drawback here.

Stack is conservative about RWIN increase, it wants to receive packets
to have an idea
of the skb->len/skb->truesize ratio to convert a memory budget to  RWIN.

Some drivers have to allocate 16K buffers (or even 32K buffers) just
to hold one segment
(of less than 1500 bytes of payload), while others are able to pack
memory more efficiently.

I guess that you could use eBPF code to precisely tweak stack behavior
to your needs.
