Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55F213D2461
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 15:10:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232064AbhGVM3q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 08:29:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232057AbhGVM3p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Jul 2021 08:29:45 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20268C061757
        for <netdev@vger.kernel.org>; Thu, 22 Jul 2021 06:10:20 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id p22so8244186yba.7
        for <netdev@vger.kernel.org>; Thu, 22 Jul 2021 06:10:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=E9r9uVnuNcXfAI11JfB/29V/jMcTVQxprw/1WIN4XSg=;
        b=KLPi8kjA3PUJYShcGJz9RjnV8s1Zyf7CJLHNfrXdxLvQUWaB+qCVdt05IBbzWKL6Fk
         EXqC3/nwswJNTfer4ctEQtC21dphTHd5mVYNrEYmTmRVv0nlfzdehjIIjgvJhuC/yM0d
         AJytpffV4WLsheDKXFdWgFS7zvq/DfAc2+sqOhZP3cYsnFEcqDGS5FZ4ZejmOcTGs7wA
         GizX24D8L+C4BFS1TtF40A3Pd7nyBbWb0AmVglhjbW3fDeLu+j2d0ATaP3HPXqMXFgSK
         CP2ds+cvHop0us6rPCuWtvrbUFm5BSmB5ypFHNix3Y9Mmt3PL+qmpInv0wTTgS0FbJ19
         z0yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=E9r9uVnuNcXfAI11JfB/29V/jMcTVQxprw/1WIN4XSg=;
        b=CeiDgBqWyg1wMwhZt1zrV5G1HUk1isMmNnxY8pwTxTkwbm19JFKOeVejxasyiQ+Gzg
         Edy9EwJjg2161MysR1j+j1ANFcR+0kiPZFrkttnDwuKLXnbXEaRH/Ds/hblLERKTvyzD
         fGmTEFZ3wT6PdOl8ZCnR5LHNdqKReGtt6Gv+WFYb4HyR6KNXrgOCfroW/xNTHEmGQ25X
         adtli3pisFg4t8r1N6n3WuSMeXyNNKMlxOy37qt7ZgvoJcc9TQQHs3KTv9CXlDgS5IBg
         hVnlh1g/dHNPPUWV/paEbFVfKxrqKYioRVL/Wm5zFHqrE0DFw0RFOujlgAAvYrm6yQ/H
         V5Nw==
X-Gm-Message-State: AOAM5323r03BYo4K5OGk06zkhrMQaBB8scqhxxoPVSSw3t5Af4dtI8Q9
        ZPsbUJKGmj+TgfV7lpEIfwhS3aPmkFiyR8hYYCeG9g==
X-Google-Smtp-Source: ABdhPJxUZnFnJidC9QmDkN2l4ri35ZU3TXQ4d7hxHQ6oMksfsIsHdp6lOwVVQdtfW2vspoyPw1nfrySiC7zakBJA4eM=
X-Received: by 2002:a25:550:: with SMTP id 77mr52731774ybf.452.1626959418958;
 Thu, 22 Jul 2021 06:10:18 -0700 (PDT)
MIME-Version: 1.0
References: <20210722110325.371-1-borisp@nvidia.com> <20210722110325.371-2-borisp@nvidia.com>
 <CANn89iLP4yXDK9nOq6Lxs9NrfAOZ6RuX5B5SV0Japx50KvnEyQ@mail.gmail.com> <7fdb948a-6411-fce5-370f-90567d2fe985@gmail.com>
In-Reply-To: <7fdb948a-6411-fce5-370f-90567d2fe985@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 22 Jul 2021 15:10:07 +0200
Message-ID: <CANn89iLUDcL-F2RvaNz5+b8oQPnL1DnanHe0vvMb8QkM26whCQ@mail.gmail.com>
Subject: Re: [PATCH v5 net-next 01/36] net: Introduce direct data placement
 tcp offload
To:     Boris Pismenny <borispismenny@gmail.com>
Cc:     Boris Pismenny <borisp@nvidia.com>,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Christoph Hellwig <hch@lst.de>, sagi@grimberg.me, axboe@fb.com,
        kbusch@kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        smalin@marvell.com, boris.pismenny@gmail.com,
        linux-nvme@lists.infradead.org, netdev <netdev@vger.kernel.org>,
        benishay@nvidia.com, ogerlitz@nvidia.com, yorayz@nvidia.com,
        Boris Pismenny <borisp@mellanox.com>,
        Ben Ben-Ishay <benishay@mellanox.com>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Yoray Zack <yorayz@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 22, 2021 at 2:18 PM Boris Pismenny <borispismenny@gmail.com> wrote:
>
> On 22/07/2021 14:26, Eric Dumazet wrote:
> > On Thu, Jul 22, 2021 at 1:04 PM Boris Pismenny <borisp@nvidia.com> wrote:
> >>
> >> From: Boris Pismenny <borisp@mellanox.com>
> >>
> >>
> > ...
> >
> >>  };
> >>
> >>  const char
> >> diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
> >> index e6ca5a1f3b59..4a7160bba09b 100644
> >> --- a/net/ipv4/tcp_input.c
> >> +++ b/net/ipv4/tcp_input.c
> >> @@ -5149,6 +5149,9 @@ tcp_collapse(struct sock *sk, struct sk_buff_head *list, struct rb_root *root,
> >>                 memcpy(nskb->cb, skb->cb, sizeof(skb->cb));
> >>  #ifdef CONFIG_TLS_DEVICE
> >>                 nskb->decrypted = skb->decrypted;
> >> +#endif
> >> +#ifdef CONFIG_ULP_DDP
> >> +               nskb->ddp_crc = skb->ddp_crc;
> >
> > Probably you do not want to attempt any collapse if skb->ddp_crc is
> > set right there.
> >
>
> Right.
>
> >>  #endif
> >>                 TCP_SKB_CB(nskb)->seq = TCP_SKB_CB(nskb)->end_seq = start;
> >>                 if (list)
> >> @@ -5182,6 +5185,11 @@ tcp_collapse(struct sock *sk, struct sk_buff_head *list, struct rb_root *root,
> >>  #ifdef CONFIG_TLS_DEVICE
> >>                                 if (skb->decrypted != nskb->decrypted)
> >>                                         goto end;
> >> +#endif
> >> +#ifdef CONFIG_ULP_DDP
> >> +
> >> +                               if (skb->ddp_crc != nskb->ddp_crc)
> >
> > This checks only the second, third, and remaining skbs.
> >
>
> Right, as we handle the head skb above. Could you clarify?

I was simply saying you missed the first skb.

>
> >> +                                       goto end;
> >>  #endif
> >>                         }
> >>                 }
> >
> >
> > tcp_collapse() is copying data from small skbs to pack it to bigger
> > skb (one page of payload), in case
> > of memory emergency/pressure (socket queues are full)
> >
> > If your changes are trying to avoid 'needless'  copies, maybe you
> > should reconsider and let the emergency packing be done.
> >
> > If the copy is not _possible_, you should rephrase your changelog to
> > clearly state the kernel _cannot_ access this memory in any way.
> >
>
> The issue is that skb_condense also gets called on many skbs in
> tcp_add_backlog and it will identify skbs that went through DDP as ideal
> for packing, even though they are not small and packing is
> counter-productive as data already resides in its destination.
>
> As mentioned above, it is possible to copy, but it is counter-productive
> in this case. If there was a real need to access this memory, then it is
> allowed.

Standard GRO packets from high perf drivers have no room in their
skb->head (ie skb_tailroom() should be 0)

If you have a driver using GRO and who pulled some payload in
skb->head, it is already too late for DDP.

So I think you are trying to add code in TCP that should not be
needed. Perhaps mlx5 driver is doing something it should not ?
(If this is ' copybreak'  this has been documented as being
suboptimal, transports have better strategies)

Secondly, tcp_collapse() should absolutely not be called under regular
workloads.

Trying to optimize this last-resort thing is a lost cause:
If an application is dumb enough to send small packets back-to-back,
it should be fixed (sender side has this thing called autocork, for
applications that do not know about MSG_MORE or TC_CORK.)

(tcp_collapse is a severe source of latencies)
