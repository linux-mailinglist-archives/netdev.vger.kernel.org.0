Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E26249D71A
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 02:02:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231734AbiA0BCs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 20:02:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231644AbiA0BCr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 20:02:47 -0500
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08D2CC06161C
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 17:02:47 -0800 (PST)
Received: by mail-yb1-xb34.google.com with SMTP id i62so3893024ybg.5
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 17:02:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PvX4CHaBVcJyh77GU1JeNeaTFcpTU0ljmpbqC+pReCg=;
        b=JTWG742YiKaH9fljbpA/WnIKyPL/cXiKGEYav/685qlccbR4cto79jS+EoynZrq0MD
         rY7kcbbpPvxZZQyOWCRyH/sVmfM5TiGrOW2cFY1g2aGBS38gOP1hTJ35WS6PwvV1JY+h
         RunST2861TuNTp7zsaPFrn5rLnvvlW2xLHR7CiXgH+rW2LQrOnvMZJYE+KmMpYcHVi7u
         HO80DpXsuFqhCin5E3PT5dVMP+pPP/XgVs5U4uh0q5GKQ4eCOeqBZ3+oFkkwFr+DvkQd
         oviNJuLBb1r4sj6J1CUxaZG8P99aaUjYEUNISs8N3e/ze8FXVJ12G9MpJUHVbwlhdOjW
         6t4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PvX4CHaBVcJyh77GU1JeNeaTFcpTU0ljmpbqC+pReCg=;
        b=oJIcwvVzOdj4lH6Tb9ZWDH/8NwDJJcXhKtQeTok9EnFF0wLE0HPJa2i/UqrFa0BnXr
         7zL8oArPv8oIpwbDgXN/lSlJ3nPzPBUy6MogGen0kvzZu2+ZGqlzcZpdom0RUySGbNN3
         ZUozCaMxQ70WKo2xbYlHgOMdrW7/0lXr2cS/PIe0IrQJ+76b4w0ZT8TvFdt3kWPtj2wS
         0pit80cEWq8l6d5GSgIOwoOn5GR07REbZiZCQ2MqJsjpFnzPP7e9K6U5/YCyVlSet0d1
         G7AGFBpe+PZXmjBp3fH4new9MqldTwpwEcZ+vJ7Rhbsxr1/FaFX8bC27NFalrJ1XfYcn
         1JYQ==
X-Gm-Message-State: AOAM5322REDTIOa6JqaMcl8k5bYOH+YMigYWIW9vtQWQQ/TpvlpnPRjL
        fac+Ooboo9JTh3QA3kUeZTlxFbUp0ht9MFcc2lttEamw2MkhJQ==
X-Google-Smtp-Source: ABdhPJyRPgW+/zSEB4Zf1FaUca5c3eYnqAaP1owFPtP/6VHSGead4hTdkLUHOaB6KKuTyZpD0KOK012lX55iUrZmOZM=
X-Received: by 2002:a25:c709:: with SMTP id w9mr2368455ybe.296.1643245365880;
 Wed, 26 Jan 2022 17:02:45 -0800 (PST)
MIME-Version: 1.0
References: <20220126200518.990670-1-eric.dumazet@gmail.com>
 <20220126200518.990670-2-eric.dumazet@gmail.com> <20220126165647.237f16e3@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220126165647.237f16e3@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 26 Jan 2022 17:02:34 -0800
Message-ID: <CANn89iJxMGhXPxAekxZ9tALWVb=0oRGxdR95oM9ijBHGohTSNw@mail.gmail.com>
Subject: Re: [PATCH net 1/2] ipv4: tcp: send zero IPID in SYNACK messages
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        David Ahern <dsahern@kernel.org>,
        netdev <netdev@vger.kernel.org>, Ray Che <xijiache@gmail.com>,
        Geoff Alexander <alexandg@cs.unm.edu>, Willy Tarreau <w@1wt.eu>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 26, 2022 at 4:56 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Wed, 26 Jan 2022 12:05:17 -0800 Eric Dumazet wrote:
> > +             /* TCP packets here are SYNACK with fat IPv4/TCP options.
> > +              * Avoid using the hashed IP ident generator.
> > +              */
> > +             if (sk->sk_protocol == IPPROTO_TCP)
> > +                     iph->id = prandom_u32();
>
> Is it worth marking this as (__force __be32) to avoid the false
> positive sparse warning?

Sure thing, we can add this (I guess this needs to be __be16 ?)
