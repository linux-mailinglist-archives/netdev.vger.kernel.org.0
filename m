Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 429D113144
	for <lists+netdev@lfdr.de>; Fri,  3 May 2019 17:33:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728334AbfECPdn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 11:33:43 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:46614 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726724AbfECPdm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 May 2019 11:33:42 -0400
Received: by mail-lf1-f68.google.com with SMTP id k18so4686694lfj.13
        for <netdev@vger.kernel.org>; Fri, 03 May 2019 08:33:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=W4zuDR8DVvXOgmmF+EdOoRpw3esdWbJUxbXb0zljiY0=;
        b=qgsQFZDjbI/Dgz5sp6sOuELePyQpk7ds2FDmKt93szOONdEfRaliY/MieYjY16P/jx
         90dofXCanXtNijBV1u6cliDq+skdAd5VWkGGyXj0r2FyfBh9rDmhInTe17wPD2v3QU9L
         HcS5p1I823o+ckdnszaKbLa/aPvNLUWGza1PRnop07hfGaeDT9LRFihnmHiyfvxm34Jr
         sQWv3wL6tpu2WubBpCUxYLAeIyRZ2zjrFvyTU6ZmBgoeiOpEuSwuNKaU4En8Q6tnWH/D
         UZ3vg6QLL0LzonxQo61lNBE0RgNa4ZQDfYyZhx1KF5OEv8po8zDCLLCd2qlCgzCmDelK
         Dk5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=W4zuDR8DVvXOgmmF+EdOoRpw3esdWbJUxbXb0zljiY0=;
        b=UYNkVmlvmJD6rTAVvLC+3WLTn86VCb1TgotLHraRtyKouOfO87T0LDBcQaABQ+RiVi
         5DeFO2YbUCVxJUNYqTtNpWREBicmQrKwQhqJFPM2Wefhgu06mwZupUJibIkT5xV6qCF0
         K4TfotfEPrVb3U+3LQqTEFWex4704Mx2EiFdC54zQunvM9gML7j67Lk+k8phL2y0TXCt
         MiZjU8zw+Y7T0/CF1Dy55UuoPywvIXUzlFQe5QkyFUBLDGePtgEtX5pns5PYOBNAgG/9
         zRa3ki8g/MQ2AUQVlfvRr01GugL/+/w+CTDmkvb0jwUtILPC0VTFvyU6NvV4HTnfbXxT
         v9+Q==
X-Gm-Message-State: APjAAAWrInagtsbiEmd+4Vy7DJdi0BOgSArirMKTqKBbQMHpCKXjGxE7
        rE+If5jVdGmt3/kKc5eIpo6hC0Kzp4/9IzjTvgbF3w==
X-Google-Smtp-Source: APXvYqwaITJ9KUm0VocPnXH0HBI3viG4JgwRmRzO4BtWBCS5elUEMuGz0+kShiqQsYGg01cLJpCYkGERMxFthmpybOk=
X-Received: by 2002:a19:a417:: with SMTP id q23mr5341273lfc.110.1556897620559;
 Fri, 03 May 2019 08:33:40 -0700 (PDT)
MIME-Version: 1.0
References: <20190503114721.10502-1-edumazet@google.com>
In-Reply-To: <20190503114721.10502-1-edumazet@google.com>
From:   Peter Oskolkov <posk@google.com>
Date:   Fri, 3 May 2019 08:33:28 -0700
Message-ID: <CAPNVh5c-xeSaRkQgFtFUL1h3u0DpEozBXDP+xf-XEvXKbDgCYg@mail.gmail.com>
Subject: Re: [PATCH net] ip6: fix skb leak in ip6frag_expire_frag_queue()
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Stfan Bader <stefan.bader@canonical.com>,
        Florian Westphal <fw@strlen.de>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 3, 2019 at 4:47 AM Eric Dumazet <edumazet@google.com> wrote:
>
> Since ip6frag_expire_frag_queue() now pulls the head skb
> from frag queue, we should no longer use skb_get(), since
> this leads to an skb leak.
>
> Stefan Bader initially reported a problem in 4.4.stable [1] caused
> by the skb_get(), so this patch should also fix this issue.
>
> 296583.091021] kernel BUG at /build/linux-6VmqmP/linux-4.4.0/net/core/skbuff.c:1207!
> [296583.091734] Call Trace:
> [296583.091749]  [<ffffffff81740e50>] __pskb_pull_tail+0x50/0x350
> [296583.091764]  [<ffffffff8183939a>] _decode_session6+0x26a/0x400
> [296583.091779]  [<ffffffff817ec719>] __xfrm_decode_session+0x39/0x50
> [296583.091795]  [<ffffffff818239d0>] icmpv6_route_lookup+0xf0/0x1c0
> [296583.091809]  [<ffffffff81824421>] icmp6_send+0x5e1/0x940
> [296583.091823]  [<ffffffff81753238>] ? __netif_receive_skb+0x18/0x60
> [296583.091838]  [<ffffffff817532b2>] ? netif_receive_skb_internal+0x32/0xa0
> [296583.091858]  [<ffffffffc0199f74>] ? ixgbe_clean_rx_irq+0x594/0xac0 [ixgbe]
> [296583.091876]  [<ffffffffc04eb260>] ? nf_ct_net_exit+0x50/0x50 [nf_defrag_ipv6]
> [296583.091893]  [<ffffffff8183d431>] icmpv6_send+0x21/0x30
> [296583.091906]  [<ffffffff8182b500>] ip6_expire_frag_queue+0xe0/0x120
> [296583.091921]  [<ffffffffc04eb27f>] nf_ct_frag6_expire+0x1f/0x30 [nf_defrag_ipv6]
> [296583.091938]  [<ffffffff810f3b57>] call_timer_fn+0x37/0x140
> [296583.091951]  [<ffffffffc04eb260>] ? nf_ct_net_exit+0x50/0x50 [nf_defrag_ipv6]
> [296583.091968]  [<ffffffff810f5464>] run_timer_softirq+0x234/0x330
> [296583.091982]  [<ffffffff8108a339>] __do_softirq+0x109/0x2b0
>
> Fixes: d4289fcc9b16 ("net: IP6 defrag: use rbtrees for IPv6 defrag")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: Stfan Bader <stefan.bader@canonical.com>
> Cc: Peter Oskolkov <posk@google.com>
> Cc: Florian Westphal <fw@strlen.de>
> ---
>  include/net/ipv6_frag.h | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/include/net/ipv6_frag.h b/include/net/ipv6_frag.h
> index 28aa9b30aeceac9a86ee6754e4b5809be115e947..1f77fb4dc79df6bc4e41d6d2f4d49ace32082ca4 100644
> --- a/include/net/ipv6_frag.h
> +++ b/include/net/ipv6_frag.h
> @@ -94,7 +94,6 @@ ip6frag_expire_frag_queue(struct net *net, struct frag_queue *fq)
>                 goto out;
>
>         head->dev = dev;
> -       skb_get(head);

This skb_get was introduced by commit 05c0b86b9696802fd0ce5676a92a63f1b455bdf3
"ipv6: frags: rewrite ip6_expire_frag_queue()", and the rbtree patch
is not in 4.4, where the bug is reported at.
Shouldn't the "Fixes" tag also reference the original patch?


>         spin_unlock(&fq->q.lock);
>
>         icmpv6_send(head, ICMPV6_TIME_EXCEED, ICMPV6_EXC_FRAGTIME, 0);
> --
> 2.21.0.1020.gf2820cf01a-goog
>
