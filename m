Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02D3E34CBB7
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 10:54:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235733AbhC2Ivp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 04:51:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235418AbhC2IvW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 04:51:22 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C27D3C061574
        for <netdev@vger.kernel.org>; Mon, 29 Mar 2021 01:51:21 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id x16so11976133wrn.4
        for <netdev@vger.kernel.org>; Mon, 29 Mar 2021 01:51:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YRRwTejOZh/YyqCS8LE0/gR0D+xHvrtCNPKrOMXmWgE=;
        b=EHySP6tcpuH9QVe02XOfuwqMeCD9yj2gwKA/PonerRMwkEYCCoEooLc6RxNC98AHeA
         PgTAUbmEFahnelJQ0F5S6ERPXdsBOLxvw7nLiMN8yWAKpnH/87L3lGLt82nXMhnYCXYm
         jahrMXsp9Xg1hgV5o5mrzRjg24Cyx16mfoDFwIteHrGU8OFV9rV2r44TaiID9o6IRDIp
         EXrBIhPJtCFQgjmg8Qtj868BO0q32gtWcQ8AYPBno3WE1R5YdSE8BGf1BU400uvdhkli
         Ib/rztGf6RTCOKYFz6rFjjGpTBy+kpDX0J5E0n/zwsoUb3B49cQJQyTdoPwctyxlYKcB
         JKfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YRRwTejOZh/YyqCS8LE0/gR0D+xHvrtCNPKrOMXmWgE=;
        b=LOQE10wgB7h/itzDZZ2K1uPEfO0O7QX/LSULxjblRmNnmdOaHOYDy1p2qfupSD9zaS
         qilt/vFBOw5o5M4rw+JfSG98M3j4KN+xPW9cPP47I9SxpZCNooML/1M5O0d5ajqnWE8b
         twnWPmLlLU4Zooldk7uD4g/UUnCxCz3iMkEawZa4b7xldqIi/XrFvzG2aDJZbhuv5WLp
         0uLeqWFeJBFQHajEOrBVkmFbh8ZQzVi9/Q5ajG+WtogcO5cmob+xmvJkWosYrYfN/eOi
         LY+RzS8KUhA8ouNNkisiVT5ze0TvQqYKXX/VcK7EQtxPl+qDPCotmGtg4t9hxgcqhHu9
         5nkA==
X-Gm-Message-State: AOAM532FS6sljAr356rPa3Cejx/NOD7hR2ourI5bJ29H2IuY13ba8gro
        FWVHKHmljTeATt2ZBq3MFkdHBjQkgJOWniBICAANcQ==
X-Google-Smtp-Source: ABdhPJwdA2crqPW++cB9wAIu7tRZtJpsgrKw0XDknliS/rCW2NUPzDv4Yrwu0JLAKADO0onqma+Q59+AOtX8OVsRMmQ=
X-Received: by 2002:a05:6000:2c8:: with SMTP id o8mr27537548wry.407.1617007879245;
 Mon, 29 Mar 2021 01:51:19 -0700 (PDT)
MIME-Version: 1.0
References: <20210329071716.12235-1-kurt@linutronix.de>
In-Reply-To: <20210329071716.12235-1-kurt@linutronix.de>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 29 Mar 2021 10:51:06 +0200
Message-ID: <CANn89iJfLQwADLMw6A9J103qM=1y3O6ki1hQMb3cDuJVrwAkrg@mail.gmail.com>
Subject: Re: [PATCH net v2] net: Reset MAC header for direct packet transmission
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Antoine Tenart <atenart@kernel.org>,
        Wei Wang <weiwan@google.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Taehee Yoo <ap420073@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 29, 2021 at 9:17 AM Kurt Kanzenbach <kurt@linutronix.de> wrote:
>
> Reset MAC header in case of using dev_direct_xmit(), e.g. by specifying
> PACKET_QDISC_BYPASS. This is needed, because other code such as the HSR layer
> expects the MAC header to be correctly set.
>
> This has been observed using the following setup:
>
> |$ ip link add name hsr0 type hsr slave1 lan0 slave2 lan1 supervision 45 version 1
> |$ ifconfig hsr0 up
> |$ ./test hsr0
>
> The test binary is using mmap'ed sockets and is specifying the
> PACKET_QDISC_BYPASS socket option.
>
> This patch resolves the following warning on a non-patched kernel:
>
> |[  112.725394] ------------[ cut here ]------------
> |[  112.731418] WARNING: CPU: 1 PID: 257 at net/hsr/hsr_forward.c:560 hsr_forward_skb+0x484/0x568
> |[  112.739962] net/hsr/hsr_forward.c:560: Malformed frame (port_src hsr0)
>
> The MAC header is also reset unconditionally in case of PACKET_QDISC_BYPASS is
> not used at the top of __dev_queue_xmit().
>
> Fixes: d346a3fae3ff ("packet: introduce PACKET_QDISC_BYPASS socket option")
> Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
> ---
>
> Changes since v1:
>
>  * Move skb_reset_mac_header() to __dev_direct_xmit()
>  * Add Fixes tag
>  * Target net tree
>
> Previous versions:
>
>  * https://lkml.kernel.org/netdev/20210326154835.21296-1-kurt@linutronix.de/
>
> net/core/dev.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/net/core/dev.c b/net/core/dev.c
> index b4c67a5be606..b5088223dc57 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -4297,6 +4297,8 @@ int __dev_direct_xmit(struct sk_buff *skb, u16 queue_id)
>                      !netif_carrier_ok(dev)))
>                 goto drop;
>
> +       skb_reset_mac_header(skb);
> +
>         skb = validate_xmit_skb_list(skb, dev, &again);
>         if (skb != orig_skb)
>                 goto drop;
> --
> 2.20.1
>

Note that last year, I addressed the issue differently in commit
96cc4b69581db68efc9749ef32e9cf8e0160c509
("macvlan: do not assume mac_header is set in macvlan_broadcast()")
(amended with commit 1712b2fff8c682d145c7889d2290696647d82dab
"macvlan: use skb_reset_mac_header() in macvlan_queue_xmit()")

My reasoning was that in TX path, when ndo_start_xmit() is called, MAC
header is essentially skb->data,
so I was hoping to _remove_ skb_reset_mac_header(skb) eventually from
the fast path (aka __dev_queue_xmit),
because most drivers do not care about MAC header, they just use skb->data.

I understand it is more difficult to review drivers instead of just
adding more code in  __dev_direct_xmit()

In hsr case, I do not really see why the existing check can not be
simply reworked ?

mac_header really makes sense in input path, when some layer wants to
get it after it has been pulled.

diff --git a/net/hsr/hsr_forward.c b/net/hsr/hsr_forward.c
index ed82a470b6e154be28d7e53be57019bccd4a964d..cda495cb1471e23e6666c1f2e9d27a01694f997f
100644
--- a/net/hsr/hsr_forward.c
+++ b/net/hsr/hsr_forward.c
@@ -555,11 +555,7 @@ void hsr_forward_skb(struct sk_buff *skb, struct
hsr_port *port)
 {
        struct hsr_frame_info frame;

-       if (skb_mac_header(skb) != skb->data) {
-               WARN_ONCE(1, "%s:%d: Malformed frame (port_src %s)\n",
-                         __FILE__, __LINE__, port->dev->name);
-               goto out_drop;
-       }
+       skb_reset_mac_header(skb);

        if (fill_frame_info(&frame, skb, port) < 0)
                goto out_drop;
