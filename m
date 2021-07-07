Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0F0A3BEBC9
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 18:08:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231886AbhGGQJQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 12:09:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231533AbhGGQJP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Jul 2021 12:09:15 -0400
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20D27C061574
        for <netdev@vger.kernel.org>; Wed,  7 Jul 2021 09:06:34 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id i18so3890128yba.13
        for <netdev@vger.kernel.org>; Wed, 07 Jul 2021 09:06:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Cz9VxnBhX2vHBj0dDPm3b6VvFf8wOp2fN6Lq0yn/8n4=;
        b=V5ltRtjt6VLufh0lnaw/f0qsN7VZvIL+PrMMaTjzgdkAT5QUDgt8tVNWbpYuFsIcaW
         Vf+OF+BDfDjKD1o4AjhaEdTHBfCeZ7kRxY831vxJi/Jiv/vWwAupwEyi2DNj7Sg/sT3s
         BpBYTdLukjU45jZgVdZyLbMJqoVXBLLYvDSNON/UberwKlwkimGuYgFBifIQlAoUT+m+
         lkMXO7xEyKIlOebAfpa3re2QoQIfoLiyvTWNf8EctfF61QjghbSZOqgQk0OWfvkII18C
         ujektxNCetaLBUy2QcQX0FkE+1LLcfoOx0j674bi/f2wQd25+wxSNrW98TjTQ5WX4W7E
         BWYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Cz9VxnBhX2vHBj0dDPm3b6VvFf8wOp2fN6Lq0yn/8n4=;
        b=eG5hSMM85W25ULN+DMjTxC98h1x+LepcMNcGBSQz3776voJMwzLFcyddwUD8O1edcX
         ub+isIf+aRkJh9ptVUO1aZECINXJbERAlqEA+4ITsyeOr3Sd1mR2p45q+KQW4Ol/fudx
         D/ZzJ1p7W27dB5oUul94+iZbm/Q4705G9ZB9uJF9sbNzSqbi/uPB9TYjk8bmWHG0bVsy
         yk9OW01b6Kdtfyu30sluA5PSjPwsLNmZbqAkNciSih2P/1y/ZfOmozjESwvSHMv/ZR97
         cgE2NdtZAkotbKZ/JkoKUfHsv3U93jHhN0m/BGjjof+s0rtdmXbjAgF+z3THJJ8U64rr
         7sDQ==
X-Gm-Message-State: AOAM531o9wNnaZUo7WBZ0rb1vRvRH5x07RrfZi3MsCM1bLW8MtmCsrbi
        4ARw7weewAnHc9kI9zDpttMC7oGgwJGDz+ZUlvNhyQ==
X-Google-Smtp-Source: ABdhPJyesHJJ1n8UZnNh3ZL6pZrfZvC2PqBRH48/lgaO8P5YeWe3//G8Sqof3GECSBiBVddcKr+MKxEZdMNYSymdh5I=
X-Received: by 2002:a25:8081:: with SMTP id n1mr34497810ybk.253.1625673993010;
 Wed, 07 Jul 2021 09:06:33 -0700 (PDT)
MIME-Version: 1.0
References: <20210707154630.583448-1-eric.dumazet@gmail.com> <20210707155930.GE1978@1wt.eu>
In-Reply-To: <20210707155930.GE1978@1wt.eu>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 7 Jul 2021 18:06:21 +0200
Message-ID: <CANn89iKroJhPxiFJFNhopS6cS-Y6u1z_RLDTDCnmH8PMkJwEsA@mail.gmail.com>
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

On Wed, Jul 7, 2021 at 5:59 PM Willy Tarreau <w@1wt.eu> wrote:
>
> Hi Eric,
>
> On Wed, Jul 07, 2021 at 08:46:30AM -0700, Eric Dumazet wrote:
> > From: Eric Dumazet <edumazet@google.com>
> >
> > While TCP stack scales reasonably well, there is still one part that
> > can be used to DDOS it.
> >
> > IPv6 Packet too big messages have to lookup/insert a new route,
> > and if abused by attackers, can easily put hosts under high stress,
> > with many cpus contending on a spinlock while one is stuck in fib6_run_gc()
>
> Just thinking loud, wouldn't it make sense to support randomly dropping
> such packets on input (or even better rate-limit them) ? After all, if
> a host on the net feels like it will need to send one, it will surely
> need to send a few more until one is taken into account so it's not
> dramatic. And this could help significantly reduce their processing cost.

Not sure what you mean by random.

We probably want to process valid packets, if they ever reach us.

In our case, we could simply drop all ICMPv6 " packet too big"
 messages, since we clamp TCP/IPv6 MSS to the bare minimum anyway.

Adding a generic check in TCP/ipv6 stack is cheaper than an iptables
rule (especially if this is the only rule that must be used)
