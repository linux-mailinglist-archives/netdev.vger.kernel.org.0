Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AEC73BEC10
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 18:25:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230211AbhGGQ2D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 12:28:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbhGGQ2D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Jul 2021 12:28:03 -0400
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B48AEC061574
        for <netdev@vger.kernel.org>; Wed,  7 Jul 2021 09:25:22 -0700 (PDT)
Received: by mail-yb1-xb2a.google.com with SMTP id o139so4018788ybg.9
        for <netdev@vger.kernel.org>; Wed, 07 Jul 2021 09:25:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aZWd70CxxLgkEPKFGEyFH1B1P8RRyCb+ADAS4aIhf9g=;
        b=GsGpAls2qEdBPzzAMJJGILhNUnQx5ocw+YS/gJvBApqwXibw9j1DM8AT22acZVZqmS
         vR7S5awix6jbLiUQ8a5uXe9UpaMzJzt+Ok0n1u0XfqrinrVHWeX+PMIoZB6fZ7yXsZps
         ZYFoUvvQGBoEl7LhVfTu+glsWnSTDcHZfnFCKe0eBDLwpZU28MLk2wdScvyrME8KbB7T
         WxVRhK7VgAMeAIhg6AY8ObNdlLmZcu0dwxCJUHtjz22+WDa2qJorKFZQjDwmoE8NF2Sp
         CPQQp6DPOy/wURX4Am27Ut13sCNB/jYuemgJ0IGCrLRjSHCFmz5ZRzLlZizFclI6pwVE
         ruSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aZWd70CxxLgkEPKFGEyFH1B1P8RRyCb+ADAS4aIhf9g=;
        b=cnouNuP0AWrHf3nfux7m9TGbgdOzEB08El0qKuXujIhLrgIE0zWhF6OoNlvA6n9jT3
         hQ/nf/j+4Ij9+OsfWPV3jmsoQItgRhoQ4h6LC0tac4H39BY/nU1VvuZTvA/b3qtRySZo
         ps1s/M0+19MsJtZNuqVXXV0PBzKEnARmY/l6z4QJo3nZH2V4FbES0sF94Dua8Ugz3vFk
         V+B+ZMAM+8NC6m9w4JX6dyuYL90qaE6SArUiN+0kS+UR7w37AsUpTfTqxkm/YZW8qkd/
         sFjbKPpaGrWmjD/YmC0kL7VB4gBNgVHjCccFv8Gu0IYX9fJznF/FjO7pdlCEJ+rwKAkD
         nxXQ==
X-Gm-Message-State: AOAM530rGOX/pvIY01QcU7ynDuemwLyb16Rc59m5QToHfYOKVrYjcxvZ
        sf8XpwYfndvq8nH4fP4CKQd2rzVfyBVnGE5Yw361vQ==
X-Google-Smtp-Source: ABdhPJxVyDz3l5snu8Zi4BHeXcNFege8fQj7yZBLTZOObIxEwAUe8fKnieqUH0vZzGF2drF0vRioCzMwRmvL6qmvmnA=
X-Received: by 2002:a25:bec2:: with SMTP id k2mr33854117ybm.234.1625675121474;
 Wed, 07 Jul 2021 09:25:21 -0700 (PDT)
MIME-Version: 1.0
References: <20210707154630.583448-1-eric.dumazet@gmail.com>
 <20210707155930.GE1978@1wt.eu> <CANn89iKroJhPxiFJFNhopS6cS-Y6u1z_RLDTDCnmH8PMkJwEsA@mail.gmail.com>
 <20210707161535.GF1978@1wt.eu>
In-Reply-To: <20210707161535.GF1978@1wt.eu>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 7 Jul 2021 18:25:10 +0200
Message-ID: <CANn89iJcEiYJa7dv+nwUw-EF4KpeNCCPHb1NBhn7M0Nhw9gVrg@mail.gmail.com>
Subject: Re: [PATCH net] ipv6: tcp: drop silly ICMPv6 packet too big messages
To:     Willy Tarreau <w@1wt.eu>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Maciej Zenczykowski <maze@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 7, 2021 at 6:15 PM Willy Tarreau <w@1wt.eu> wrote:
>
> On Wed, Jul 07, 2021 at 06:06:21PM +0200, Eric Dumazet wrote:
> > On Wed, Jul 7, 2021 at 5:59 PM Willy Tarreau <w@1wt.eu> wrote:
> > >
> > > Hi Eric,
> > >
> > > On Wed, Jul 07, 2021 at 08:46:30AM -0700, Eric Dumazet wrote:
> > > > From: Eric Dumazet <edumazet@google.com>
> > > >
> > > > While TCP stack scales reasonably well, there is still one part that
> > > > can be used to DDOS it.
> > > >
> > > > IPv6 Packet too big messages have to lookup/insert a new route,
> > > > and if abused by attackers, can easily put hosts under high stress,
> > > > with many cpus contending on a spinlock while one is stuck in fib6_run_gc()
> > >
> > > Just thinking loud, wouldn't it make sense to support randomly dropping
> > > such packets on input (or even better rate-limit them) ? After all, if
> > > a host on the net feels like it will need to send one, it will surely
> > > need to send a few more until one is taken into account so it's not
> > > dramatic. And this could help significantly reduce their processing cost.
> >
> > Not sure what you mean by random.
>
> I just meant statistical randomness. E.g. drop 9/10 when under stress for
> example.

It is hard to define ' stress'. In our case we were maybe receiving 10
ICMPv6 messages per second " only "

I would rather define the issue as a deficiency in current IPv6 stack vs routes.

One can hope that one day the issue will disappear.

>
> > We probably want to process valid packets, if they ever reach us.
>
> That's indeed the other side of my question. I.e. if a server gets hit
> by such a flood, do we consider more important to spend the CPU cycles
> processing all received packets or can we afford dropping a lot of them.
>
> > In our case, we could simply drop all ICMPv6 " packet too big"
> >  messages, since we clamp TCP/IPv6 MSS to the bare minimum anyway.
> >
> > Adding a generic check in TCP/ipv6 stack is cheaper than an iptables
> > rule (especially if this is the only rule that must be used)
>
> Sure, I was not thinking about iptables here, rather a hard-coded
> prandom_u32() call or a percpu cycling counter.
>
> Willy
