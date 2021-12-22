Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E2D547D5FA
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 18:47:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234485AbhLVRqz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 12:46:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234397AbhLVRqy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 12:46:54 -0500
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B5F9C061574
        for <netdev@vger.kernel.org>; Wed, 22 Dec 2021 09:46:54 -0800 (PST)
Received: by mail-yb1-xb34.google.com with SMTP id d10so8943751ybe.3
        for <netdev@vger.kernel.org>; Wed, 22 Dec 2021 09:46:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=iCyIH9qoy4Cuhwyn0qbDTkTmYuaLRWzCBF7+0i4eqwM=;
        b=RGQE6wrXzYuoCSSzG+rxJHV2rWxpYlO7m/RZ2qhnRo7k/CxL0kMDjuJIOLCpO4X2C4
         1n22UcdgnTiwOTM8+oLfINvhfLspxOxa+RsQ1gNqnHNmroZmzc/qP1RqqQUMKfDaOACU
         Y1jWCqrN7brmPXhcGcMOWRrIct2eWrUA0RvMY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=iCyIH9qoy4Cuhwyn0qbDTkTmYuaLRWzCBF7+0i4eqwM=;
        b=zkOpVwRXUU2xLr6lMWQ3CctKrlV59Nv0wv+VZ6ifkhsrG0VcJVYlgy1QN6SVbfA1Qt
         cJNSqCvc197Z2haqOx6Q2q4b4LKNRRRxq7Hj/5hkkgd8MDn6nGF67UGi0eB2AwZyIZcA
         hG99CylxzX692uuZGX2HSVbrMeNmYELMcRtg7QcZfzpL2j7oofzyVJfCfBmvn4oKm/jw
         AlviRTyZ7/6JsKRRfU/JQhda2cEFIborqZ+FRyH9b1j6b1Nuf+WaJMnbH594l4jvXsrz
         D9Z1kVX9vzEjPIQgVMv5bELAwngsnCuPwvVxTxO/K5ZUo1y0IdUUMRRpUrx3q7j2dZor
         DXeQ==
X-Gm-Message-State: AOAM531ii2F+XuHdpXJsktNgdgdZ/z+efhXA6SqBbqnavpOxfU+PgoMi
        CPD2VsFGCXaE40RcUKd0qq/KEGD6myRXHV6Qhy4P9H49JiB8Ow==
X-Google-Smtp-Source: ABdhPJxpg1aUtwGj8dEDp1MzllQE9q90hddGLnRax4kvn0M9cTeOjSb05+rXbfc3XdGXWOrZi8MLOs/9GRIDTsmPwGk=
X-Received: by 2002:a25:ae12:: with SMTP id a18mr5674627ybj.286.1640195213649;
 Wed, 22 Dec 2021 09:46:53 -0800 (PST)
MIME-Version: 1.0
From:   Ivan Babrou <ivan@cloudflare.com>
Date:   Wed, 22 Dec 2021 09:46:43 -0800
Message-ID: <CABWYdi3bzd4P0nsyZe6P6coBCQ2jN=kVOJte62zKj=Q8iJCSOQ@mail.gmail.com>
Subject: Initial TCP receive window is clamped to 64k by rcv_ssthresh
To:     Linux Kernel Network Developers <netdev@vger.kernel.org>
Cc:     kernel-team <kernel-team@cloudflare.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

I noticed that the advertised TCP receive window in the first ACK from
the client is clamped at 64k. I'm wondering if this is intentional.

We have an environment with many pairs of distant servers connected by
high BDP links. For the reasons that aren't relevant, we need to
re-establish connections between those often and expect to have as few
round trips as possible to get a response after a handshake.

We have made BBR cooperate on the initcwnd front with TCP_BPF_IW and
some code that remembers cwnd and lets new connections start with a
high value. It's safe to assume that we set initcwnd to 250 from the
server side. I have no issues with the congestion control side of
things.

We also have high rmem and wmem values and plenty of memory.

The problem lies in the fact that no matter how high we crank up the
initcwnd, the connection will hit the 64k wall of the receive window
and will have to stall waiting on ACKs from the other side, which take
a long while to arrive on high latency links. A realistic scenario:

1. TCP connection established, receive window = 64k.
2. Client sends a request.
3. Server userspace program generates a 120k response and writes it to
the socket. That's T0.
4. Server sends 64k worth of data in TCP packets to the client.
5. Client sees the first 64k worth of data T0 + RTT/2 later.
6. Client sends ACKs to cover for the data it just received.
7. Server sees the ACKs T0 + 1 RTT later.
8. Server sends the remaining data.
9. Client sees the remaining data T0 + RTT + RTT/2 later.

In my mind, on a good network (guarded by the initcwnd) I expect to
have the whole response to be sent immediately at T0 and received
RTT/2 later.

The current TCP connection establishment code picks two window sizes
in tcp_select_initial_window() during the SYN packet generation:

* rcv_wnd to advertise (cannot be higher than 64k during SYN, as we
don't know whether wscale is supported yet)
* window_clamp (current max memory allowed for the socket, can be large)

You can find these in code here:

* https://elixir.bootlin.com/linux/v5.15.10/source/include/linux/tcp.h#L209

The call into tcp_select_initial_window() is here:

* https://elixir.bootlin.com/linux/v5.15.10/source/net/ipv4/tcp_output.c#L3682

Then immediately after rcv_ssthresh is set to rcv_wnd. This is the
part that gives me pause.

During the generation of the first ACK after the SYN ACK is received
on the client, assuming the window scaling is supported, I expect the
client to advertise the whole buffer as available and let congestion
control handle whether it can be filled from the sender side. What
happens in reality is that rcv_ssthresh is sent as the window value.
Unfortunately, rcv_ssthresh is limited to 64k from rcv_wnd as
described above.

My question is whether it should be limited to window_clamp in
tcp_connect_init() instead.

I tried looking through git history and the following line was there
since Git import in 2005:

  tp->rcv_ssthresh = tp->rcv_wnd;

I made a small patch that toggles rcv_ssthresh between rcv_wnd and
window_clamp and I'm doing some testing to see if it solves my issue.
I can see it advertise 512k receive buffer in the first ACK from the
client, which seems to address my problem. I'm not sure if there's
some drawback here.
