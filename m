Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 567A53A1B2F
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 18:47:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229678AbhFIQtn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 12:49:43 -0400
Received: from mail-yb1-f173.google.com ([209.85.219.173]:38599 "EHLO
        mail-yb1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbhFIQtl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 12:49:41 -0400
Received: by mail-yb1-f173.google.com with SMTP id m9so29929718ybo.5
        for <netdev@vger.kernel.org>; Wed, 09 Jun 2021 09:47:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=c0fJTBkKWdz/o6PI1DmIR+MW5KfI9q7fYwWY7fdtqvk=;
        b=nAWK0pFjLStGkGfQToHQ7k3s+lvl0qjeTWfpjdq4oc5XIvAR7QrnCNE5FbAa0+0iDM
         aXhOm8Xog2Y+tiFB4mDR230x7/eCd3S0+vYN1XeYlJZfFHFb/xmhP69WarXZJlqBVBVR
         2EVYtKm7OsAtNc1kZ0n4e71Qg1/2ThtRgxADbw1UjR5LmWMClcQTR0fgw3ONvP1g9yUa
         KKHThqcyQXhaRME/kNH1Op+x/XwsgRcWhZMA2vZIjBowL2fSfSgVbh2anWMrKiEZQC4K
         Wy/XisrWmMgcAITAkcqAbr/S11/nuzTzsj31x4mUYXvFzEnvYg1WLa7Pa05zpqpPgSNP
         OSPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=c0fJTBkKWdz/o6PI1DmIR+MW5KfI9q7fYwWY7fdtqvk=;
        b=jDCZUu5VFmfilbG+1949NVJXJqfRSqHBE8AHoEdndjyIaYQ+gwOuuz2VIJ9hujMiGU
         wnwN6Wm1KrRyrdZ0VgXSyTlRt9oCdPGMiDFe9b02NyXgCSJCtgfle6B/ikS5irzY4LuU
         RH1Nj2LRPvGKWlQfQn76soArT2dzVE9WekLvOqIcckWe9VWraW9q1Sb6YkVEK/kAizgQ
         TWNW4jcIw3myMyVDF57lTzS+JIJO8Ys4EPWnFVrAwHzAm/tolvT6IJwMp2uZJwX/yrrZ
         v4I7Z6NZA/dJYEC8y16k4jZ9FVYKFCYHHU9gYagPiiNxQJHwN3FDWH/eOkWAz9onRDlY
         Y6xw==
X-Gm-Message-State: AOAM5308fkryunwUaGNZASYU3txIov86lr8C/qdqAXC+YsnKrnrfazAy
        5aCqA65ZWh63PjCVOY+TVIg2/zvimbT0DJMdHfbVBAnBlYQ=
X-Google-Smtp-Source: ABdhPJyHVRC6ndYXS6E57Wo7JtBcb/9mz0xmN/Bf99uWQN7kuVT8/eq03CGvS89s/NeKmf5o5iPK8w+M8dwS8mzHsAs=
X-Received: by 2002:a05:6902:4b2:: with SMTP id r18mr1284226ybs.446.1623257193778;
 Wed, 09 Jun 2021 09:46:33 -0700 (PDT)
MIME-Version: 1.0
References: <20210607154534.57034-1-dust.li@linux.alibaba.com>
 <CANn89i+dDy6ev50mBMwoK7f0NN+0xHf8V-Jas8zAmew02hJV4w@mail.gmail.com>
 <20210608030903.GN53857@linux.alibaba.com> <CANn89i+VEA4rc3T_oC7tJXYvA7OAmDc=Vk_wyxYwzYz23nENPg@mail.gmail.com>
 <20210609002542.GO53857@linux.alibaba.com> <CANn89i+vBRxKFy_Bb2_tKTh1ttLanZj99UNZcmjSQ=oq4-j6og@mail.gmail.com>
 <20210609084504.GP53857@linux.alibaba.com>
In-Reply-To: <20210609084504.GP53857@linux.alibaba.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 9 Jun 2021 18:46:22 +0200
Message-ID: <CANn89i+BO+oPw1-SJNutGEHRzUfHBH7QvFaMqDepZwYQ1W5RXg@mail.gmail.com>
Subject: Re: [PATCH net-next] tcp: avoid spurious loopback retransmit
To:     "dust.li" <dust.li@linux.alibaba.com>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Tony Lu <tonylu@linux.alibaba.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 9, 2021 at 10:45 AM dust.li <dust.li@linux.alibaba.com> wrote:
>
> On Wed, Jun 09, 2021 at 09:03:14AM +0200, Eric Dumazet wrote:
> >On Wed, Jun 9, 2021 at 2:25 AM dust.li <dust.li@linux.alibaba.com> wrote:
> >>
> >
> >> Normal RTO and fast retransmits are rarely triggerred.
> >> But for TLP timers, it is easy since its timeout is usally only 2ms.
> >>
> >
> >OK, by definition rtx timers can fire too early, so I think we will
> >leave the code as it is.
> >(ie not try to do special things for 'special' interfaces like loopback)
> >
> >We want to be generic as much as possible.
> Totally understand!
>
> After talking to you, I also rethinked this a bit more.
> The original patch is bad and not generic, my original intention is
> also to discuss with the community.
>
> Through the patch is bad, I still think the problem is generic.
> Devices like loopback/veth/ifb and maybe some others as well,
> who depend on netif_rx() or tasklet to receive packets from CPU
> backlog should all have this problem.

No, you can also have spurious retransmits when using regular/standard NIC

The receiver can have delays/jitter in processing incoming packets,
either because of a sudden spike in networking activity, or because
BH handling had to be deferred for various reasons.

>
> But I really didn't find a general way to gracefully solve this.

We simply live with this, really.
