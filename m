Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA3B612C23
	for <lists+netdev@lfdr.de>; Fri,  3 May 2019 13:17:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727563AbfECLRx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 07:17:53 -0400
Received: from mail-yw1-f68.google.com ([209.85.161.68]:46717 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726396AbfECLRx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 May 2019 07:17:53 -0400
Received: by mail-yw1-f68.google.com with SMTP id v15so3956943ywe.13
        for <netdev@vger.kernel.org>; Fri, 03 May 2019 04:17:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aIRkYW9H27aJcAES1KtaFVQzoaLuCcfsTtbxjxewh6Y=;
        b=a+pcrmvPgsBF4uQSD1KjEHaEZfPM2mwg5APbU7490TiR5YF83dFaB+U1MSMDVMdYVK
         ZQ0du18o1sUSjINlwtQGLg+HVYKMgm3BHfdiiTRrEl/q7QuyufII5z8125vOnGWbQi47
         lanu0xQQs/KjMooVGkPG7oYaRzEgctB8CZBqswPwS73mZNvm5UmgE124upMWIiebZp4p
         AWPmN7zQ+8noBAtUyviOZzVNtOEtTBXx2vpwiBQBfRwizPSGZyPH6rMOzVSYdgyraGtg
         jSIQxy/bKSjPHb4S31Tyx0jc5jlBcye3U7hDdNZtAe6lbiFTJWdNrhnHvejwEbB+BLjJ
         t98w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aIRkYW9H27aJcAES1KtaFVQzoaLuCcfsTtbxjxewh6Y=;
        b=Ye0QkMVT2Rs1gOZ7ApAq/+7023vqNbRF5pCCMqw8moacso+mjjshFXfsSOSdKwkaYt
         b6cW+F3sS2vFoK5HxYCe2e5DzdERYOR0EA1S71qu8ZmPKW8MG0DESyL0hEV1GHKVFuFv
         p+nJm3MAxuwm2YD9ithoLXk9RGASViYr/uJwngT7DV9Oi8RXAEEvC4VfiELn+hcKhVR5
         s+BFDsHz3b9Bi5zH64IKSSL8shJskWObNFaEzM+uBmiXQCwpQ2JbVzgBnBe4StxHsDFA
         ogzslXALUQUM/4lESgDJfjM79/z66d+c3t+0w+nT+yY5vftfo0rU27ltAKDlwj1/bmGW
         jx+w==
X-Gm-Message-State: APjAAAXlmVIv6fSjgcUA0wd2UpQGPS67fUpWAG2Zb4sLvRHWU8Bx+Z0e
        /tuWOwLq8YVGhCMEUWcXsAKKs1HZyknAKa34I1ZHMA==
X-Google-Smtp-Source: APXvYqxCRxf6H8EyurEvURh3lC2EFbgMdKztN2bDZAdM+3xh4ZxSTcjrHChJiLNURFJUwOBAvnTL6yakF0PnbTuKgMo=
X-Received: by 2002:a25:b16:: with SMTP id 22mr7138930ybl.236.1556882271609;
 Fri, 03 May 2019 04:17:51 -0700 (PDT)
MIME-Version: 1.0
References: <20190503091732.19452-1-stefan.bader@canonical.com> <CANn89iLjw2bvXO-N-JUhQLZtnWhQey8Hy9KiizMq0=4=CEonGA@mail.gmail.com>
In-Reply-To: <CANn89iLjw2bvXO-N-JUhQLZtnWhQey8Hy9KiizMq0=4=CEonGA@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 3 May 2019 07:17:40 -0400
Message-ID: <CANn89iKm2wLKCMZnp+brgD+1W4r-9rd2xvVL8-=nEhqVdMX7+A@mail.gmail.com>
Subject: Re: Possible refcount bug in ip6_expire_frag_queue()?
To:     Stefan Bader <stefan.bader@canonical.com>,
        Peter Oskolkov <posk@google.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 3, 2019 at 7:12 AM Eric Dumazet <edumazet@google.com> wrote:
>
> On Fri, May 3, 2019 at 5:17 AM Stefan Bader <stefan.bader@canonical.com> wrote:
> >
> > In commit 05c0b86b9696802fd0ce5676a92a63f1b455bdf3 "ipv6: frags:
> > rewrite ip6_expire_frag_queue()" this function got changed to
> > be like ip_expire() (after dropping a clone there).
> > This was backported to 4.4.y stable (amongst other stable trees)
> > in v4.4.174.
> >
> > Since then we got reports that in evironments with heave ipv6 load,
> > the kernel crashes about every 2-3hrs with the following trace: [1].
> >
> > The crash is triggered by the skb_shared(skb) check in
> > pskb_expand_head(). Comparing ip6_expire_frag_queue() and
> > ip_expire(), the ipv6 code does a skb_get() which increments that
> > refcount while the ipv4 code does not seem to do that.
> >
> > Would it be possible that ip6_expire-frag_queue() should not
> > call skb_get() when using the first skb of the frag queue for
> > the icmp message?
>
> Hi Stefan
>
> The bug should also trigger in latest/current trees as I can see, right ?
>
> The skb_get() in current linux kernel seems unnecessary since we
> remove the head skb thanks
> to the call to inet_frag_pull_head(). We did remove the skb_get() in
> IPv4, but not in IPv6. [1]
>
> But in 4.4.stable this is not happening.
>
> To fix the issue (remove the skb_get()) , we would need to remove the
> head from fq->q.fragments
>
> [1]
> In IPv4, the skb_get() removal was done in commit
> fa0f527358bd900ef92f925878ed6bfbd51305cc
> ("ip: use rb trees for IP frag queue.")
>
> I will send the following fix
>
> diff --git a/include/net/ipv6_frag.h b/include/net/ipv6_frag.h
> index 28aa9b30aeceac9a86ee6754e4b5809be115e947..d3152811b8962705a508b3fd31d2157dd19ae8e5
> 100644
> --- a/include/net/ipv6_frag.h
> +++ b/include/net/ipv6_frag.h
> @@ -94,11 +94,9 @@ ip6frag_expire_frag_queue(struct net *net, struct
> frag_queue *fq)
>                 goto out;
>
>         head->dev = dev;
> -       skb_get(head);
>         spin_unlock(&fq->q.lock);
>
>         icmpv6_send(head, ICMPV6_TIME_EXCEED, ICMPV6_EXC_FRAGTIME, 0);
> -       kfree_skb(head);

Oh well, we want to keep the kfree_skb() of course.

Only the skb_get(head) needs to be removed (this would fix memory leak
I presume...  :/ )

>         goto out_rcu_unlock;
>
>  out:
>
>
> >
> > Thanks,
> > Stefan
> >
> >
> >
> > [1]
> > [296583.091021] kernel BUG at /build/linux-6VmqmP/linux-4.4.0/net/core/skbuff.c:1207!
> > [296583.091734] Call Trace:
> > [296583.091749]  [<ffffffff81740e50>] __pskb_pull_tail+0x50/0x350
> > [296583.091764]  [<ffffffff8183939a>] _decode_session6+0x26a/0x400
> > [296583.091779]  [<ffffffff817ec719>] __xfrm_decode_session+0x39/0x50
> > [296583.091795]  [<ffffffff818239d0>] icmpv6_route_lookup+0xf0/0x1c0
> > [296583.091809]  [<ffffffff81824421>] icmp6_send+0x5e1/0x940
> > [296583.091823]  [<ffffffff81753238>] ? __netif_receive_skb+0x18/0x60
> > [296583.091838]  [<ffffffff817532b2>] ? netif_receive_skb_internal+0x32/0xa0
> > [296583.091858]  [<ffffffffc0199f74>] ? ixgbe_clean_rx_irq+0x594/0xac0 [ixgbe]
> > [296583.091876]  [<ffffffffc04eb260>] ? nf_ct_net_exit+0x50/0x50 [nf_defrag_ipv6]
> > [296583.091893]  [<ffffffff8183d431>] icmpv6_send+0x21/0x30
> > [296583.091906]  [<ffffffff8182b500>] ip6_expire_frag_queue+0xe0/0x120
> > [296583.091921]  [<ffffffffc04eb27f>] nf_ct_frag6_expire+0x1f/0x30 [nf_defrag_ipv6]
> > [296583.091938]  [<ffffffff810f3b57>] call_timer_fn+0x37/0x140
> > [296583.091951]  [<ffffffffc04eb260>] ? nf_ct_net_exit+0x50/0x50 [nf_defrag_ipv6]
> > [296583.091968]  [<ffffffff810f5464>] run_timer_softirq+0x234/0x330
> > [296583.091982]  [<ffffffff8108a339>] __do_softirq+0x109/0x2b0
> > [296583.091995]  [<ffffffff8108a655>] irq_exit+0xa5/0xb0
> > [296583.092008]  [<ffffffff818660c0>] smp_apic_timer_interrupt+0x50/0x70
> > [296583.092023]  [<ffffffff8186383c>] apic_timer_interrupt+0xcc/0xe0
> > [296583.092037]  <EOI>
> > [296583.092044]  [<ffffffff816f07ae>] ? cpuidle_enter_state+0x11e/0x2d0
> > [296583.092060]  [<ffffffff816f0997>] cpuidle_enter+0x17/0x20
> > [296583.092073]  [<ffffffff810ca5c2>] call_cpuidle+0x32/0x60
> > [296583.092086]  [<ffffffff816f0979>] ? cpuidle_select+0x19/0x20
> > [296583.092099]  [<ffffffff810ca886>] cpu_startup_entry+0x296/0x360
> > [296583.092114]  [<ffffffff81052da7>] start_secondary+0x177/0x1b0
> > [296583.092878] Code: 75 1a 41 8b 87 cc 00 00 00 49 03 87 d0 00 00 00 e9 e2 fe ff ff b8 f4 ff ff ff eb bc 4c 89 ef e8 f4 99 ab ff b8 f4 ff ff ff eb ad <0f> 0b 90 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 55 48 89
> > [296583.094510] RIP  [<ffffffff81740953>] pskb_expand_head+0x243/0x250
> > [296583.095302]  RSP <ffff88021fd03b80>
> > [296583.099491] ---[ end trace 4262f47656f8ba9f ]---
