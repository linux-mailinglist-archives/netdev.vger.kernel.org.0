Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AECA61EC6F5
	for <lists+netdev@lfdr.de>; Wed,  3 Jun 2020 03:53:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726036AbgFCBxt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 21:53:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725890AbgFCBxs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jun 2020 21:53:48 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C51EC08C5C0;
        Tue,  2 Jun 2020 18:53:48 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id 9so661114ljc.8;
        Tue, 02 Jun 2020 18:53:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IXyjPldssMSiKQfQfztOYSdzyap64t/hNOEyR2JogWw=;
        b=WeVBCx2lg1qJ7F+AQmKynH1A1/xigy0hdupKSIWoP0EEn4ZGyZOWgjAAtRGmNj49B6
         SV3pWh6UdxPQ5VGk2B8nx5sIHxWVNx7rwFC3qDn9q/B3CxzCYtw6D3392XQq29QOb+UM
         aZanPp6wPMSn/4yjMI6hUwq71SzOWkxZhANcQhPWhscJoYvCwYokySFMr2+0APVb1y5A
         cDx2tZI4WqyzXcf1yz0+d4m/49lLeTrcrPYpuKjWGZ0a3Hh3T4b0L9f84jUdzn9KBcMg
         86gtO4loxVFOq8gI4dYURUTSTxjrC21djPZgbDTkadBp95cR7N0yObmgwp0tYW03cuVi
         pU9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IXyjPldssMSiKQfQfztOYSdzyap64t/hNOEyR2JogWw=;
        b=AXXlUA2Tcgk7la3bC7VZ+UtX114llcw1VqTPJlSrohUu/3rHoXqlG6YORfdM9P+vvT
         VqYrnbg72yUMAnFGUWbPu/MM5wiLTPNoyrhrKIiRV1Yf2qkbRtZKF/py28qLHZzn3ieL
         X+DejbocAmY3JduSpmMaABExHMnDoh0yFlaCE1ksdSnO1RCBsx4afsGs8Jg5Z3gc3b1t
         0ncZ3yM/g4cHJKeJ1nCthzPcvtZ+ds25Tlq0q/pGsPMabsDincVD1p/fjSZMoPp3njjC
         ImhOjyzSpaG0NCCOojYJdkVdY6defFof2oudH88rvj/PzqowLwQzTYWmzZ8swkH5PBPG
         ViKQ==
X-Gm-Message-State: AOAM531N8coQ7spIORfdQhM+A2dem/tJmEkzls9vvpqPU540J1ce+MTW
        14xwrUOjXqXdpSiAb7VgA+rvD6jJjW+iPXvJs5w=
X-Google-Smtp-Source: ABdhPJw2l88MIgoIzyzG/zupAyXhrcRHDI7kwii+k2JxyBRYPdhoq3fWyN0Bk2oFbUH5kOid2r/P61MIPiyeygTlSNE=
X-Received: by 2002:a2e:b611:: with SMTP id r17mr829195ljn.321.1591149226574;
 Tue, 02 Jun 2020 18:53:46 -0700 (PDT)
MIME-Version: 1.0
References: <20200602080425.93712-1-kerneljasonxing@gmail.com> <CANn89iLNCDuXAhj4By0PDKbuFvneVfwmwkLbRCEKLBF+pmNEPg@mail.gmail.com>
In-Reply-To: <CANn89iLNCDuXAhj4By0PDKbuFvneVfwmwkLbRCEKLBF+pmNEPg@mail.gmail.com>
From:   Jason Xing <kerneljasonxing@gmail.com>
Date:   Wed, 3 Jun 2020 09:53:10 +0800
Message-ID: <CAL+tcoBjjwrkE5QbXDFADRGJfPoniLL1rMFNUkAKBN9L57UGHA@mail.gmail.com>
Subject: Re: [PATCH] tcp: fix TCP socks unreleased in BBR mode
To:     Eric Dumazet <edumazet@google.com>
Cc:     David Miller <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, liweishi@kuaishou.com,
        Shujin Li <lishujin@kuaishou.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Eric,

I'm sorry that I didn't write enough clearly. We're running the
pristine 4.19.125 linux kernel (the latest LTS version) and have been
haunted by such an issue. This patch is high-important, I think. So
I'm going to resend this email with the [patch 4.19] on the headline
and cc Greg.

Thanks,
Jason

On Tue, Jun 2, 2020 at 9:05 PM Eric Dumazet <edumazet@google.com> wrote:
>
> On Tue, Jun 2, 2020 at 1:05 AM <kerneljasonxing@gmail.com> wrote:
> >
> > From: Jason Xing <kerneljasonxing@gmail.com>
> >
> > TCP socks cannot be released because of the sock_hold() increasing the
> > sk_refcnt in the manner of tcp_internal_pacing() when RTO happens.
> > Therefore, this situation could increase the slab memory and then trigger
> > the OOM if the machine has beening running for a long time. This issue,
> > however, can happen on some machine only running a few days.
> >
> > We add one exception case to avoid unneeded use of sock_hold if the
> > pacing_timer is enqueued.
> >
> > Reproduce procedure:
> > 0) cat /proc/slabinfo | grep TCP
> > 1) switch net.ipv4.tcp_congestion_control to bbr
> > 2) using wrk tool something like that to send packages
> > 3) using tc to increase the delay in the dev to simulate the busy case.
> > 4) cat /proc/slabinfo | grep TCP
> > 5) kill the wrk command and observe the number of objects and slabs in TCP.
> > 6) at last, you could notice that the number would not decrease.
> >
> > Signed-off-by: Jason Xing <kerneljasonxing@gmail.com>
> > Signed-off-by: liweishi <liweishi@kuaishou.com>
> > Signed-off-by: Shujin Li <lishujin@kuaishou.com>
> > ---
> >  net/ipv4/tcp_output.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
> > index cc4ba42..5cf63d9 100644
> > --- a/net/ipv4/tcp_output.c
> > +++ b/net/ipv4/tcp_output.c
> > @@ -969,7 +969,8 @@ static void tcp_internal_pacing(struct sock *sk, const struct sk_buff *skb)
> >         u64 len_ns;
> >         u32 rate;
> >
> > -       if (!tcp_needs_internal_pacing(sk))
> > +       if (!tcp_needs_internal_pacing(sk) ||
> > +           hrtimer_is_queued(&tcp_sk(sk)->pacing_timer))
> >                 return;
> >         rate = sk->sk_pacing_rate;
> >         if (!rate || rate == ~0U)
> > --
> > 1.8.3.1
> >
>
> Hi Jason.
>
> Please do not send patches that do not apply to current upstream trees.
>
> Instead, backport to your kernels the needed fixes.
>
> I suspect that you are not using a pristine linux kernel, but some
> heavily modified one and something went wrong in your backports.
> Do not ask us to spend time finding what went wrong.
>
> Thank you.
