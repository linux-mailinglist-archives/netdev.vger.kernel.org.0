Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 795EB49533F
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 18:30:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230395AbiATRad (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 12:30:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230431AbiATRaF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 12:30:05 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B10BC061574
        for <netdev@vger.kernel.org>; Thu, 20 Jan 2022 09:30:04 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id d7so5698956plr.12
        for <netdev@vger.kernel.org>; Thu, 20 Jan 2022 09:30:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nWuQlNh1+FFK77BDf2dM2joOBNRuxhXU9eZ1lL6RJ9U=;
        b=Vt1BML/8C1w1Q+B4uH6TEBe5Bp0XbsvPs4rQ6vDbh4AQAMJsx6vpR/THGjnP986NTs
         4d1TEV4riAkWtTWI+l1jErkyQaKUeVe8WtypsjRoeZgbZXQIZ+pX7nRZnQ7iTfTU9B2y
         BtUyTG8OcdTCpFbU/VnEt3Wh9cjUEYvkCPXzI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nWuQlNh1+FFK77BDf2dM2joOBNRuxhXU9eZ1lL6RJ9U=;
        b=wiys00Q5mF1EL4F90PFR3PycEvQRjpIh7iHy3opV/cvfLhSM+unQJfXlAH+ZZUptyK
         mIUIyfCffINscA+naCHps0HLXZ9o76yMWDwUP1OyBYMYSuKSjqxsAaFqfSOOf44lte10
         tafFPytTRI5rKF5g945sCN/mKKJiFupQt+NDSZTtlLm+NtHWISsKP358Q+z/Qz6B93pt
         I+lyFSxmFUzwQ8Tb6atnXvllTSpplt3fc/RrxgChqiTU2+xynHYalRS5zYwfEOY/goCk
         13Y+6CoA3+Hqz+iLe7gbCIZHWnXyBTx7bnfY5kEngQssdLk1jG9CRr3Osv3FS24k2mwP
         B88A==
X-Gm-Message-State: AOAM530/B82FlV32WSxO4noOfSzmhmu+s0uIVvVS8KK5l/mNoVppLGyl
        Ska8ASF312H3gGunsHLLzOyQ5jm2948Dwwkyfb1bLg==
X-Google-Smtp-Source: ABdhPJycFKl02Oq1wNGDCLiXjMub65SO5ZLEVDaIoyisqTvtciMEWjY7xyrtl1oNS1NiH4FU0GVEpBm3W0Z0Wb9yuws=
X-Received: by 2002:a17:902:8208:b0:14a:c442:8ca2 with SMTP id
 x8-20020a170902820800b0014ac4428ca2mr27948pln.12.1642699803642; Thu, 20 Jan
 2022 09:30:03 -0800 (PST)
MIME-Version: 1.0
References: <CA+wXwBRbLq6SW39qCD8GNG98YD5BJR2MFXmJV2zU1xwFjC-V0A@mail.gmail.com>
 <CANn89iLbKNkB9bzkA2nk+d2c6rq40-6-h9LXAVFCkub=T4BGsQ@mail.gmail.com>
 <CA+wXwBTQtzgsErFZZEUbEq=JMhdq-fF2OXJ7ztnnq6hPXs_L3Q@mail.gmail.com>
 <CANn89iKTw5aZ0GvybkO=3B17HkGRmFKcqz9FqJFuo5r--=afOA@mail.gmail.com> <CANn89iKBqPRHFy5U+SMxT5RUPkioDFrZ5rN5WKNwfzA-TkMhwA@mail.gmail.com>
In-Reply-To: <CANn89iKBqPRHFy5U+SMxT5RUPkioDFrZ5rN5WKNwfzA-TkMhwA@mail.gmail.com>
From:   Daniel Dao <dqminh@cloudflare.com>
Date:   Thu, 20 Jan 2022 17:29:52 +0000
Message-ID: <CA+wXwBSGsBjovTqvoPQEe012yEF2eYbnC5_0W==EAvWH1zbOAg@mail.gmail.com>
Subject: Re: Expensive tcp_collapse with high tcp_rmem limit
To:     Eric Dumazet <edumazet@google.com>
Cc:     netdev <netdev@vger.kernel.org>,
        kernel-team <kernel-team@cloudflare.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Marek Majkowski <marek@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 6, 2022 at 6:55 PM Eric Dumazet <edumazet@google.com> wrote:
>
> On Thu, Jan 6, 2022 at 10:52 AM Eric Dumazet <edumazet@google.com> wrote:
>
> > I think that you should first look if you are under some kind of attack [1]
> >
> > Eventually you would still have to make room, involving expensive copies.
> >
> > 12% of 16MB is still a lot of memory to copy.
> >
> > [1] Detecting an attack signature could allow you to zap the socket
> > and save ~16MB of memory per flow.

Sorry for the late reply, we spent more time over the past weeks to
gather more data.

>   tid 0: rmem_alloc=16780416 sk_rcvbuf=16777216 rcv_ssthresh=2920
>   tid 0: advmss=1460 wclamp=4194304 rcv_wnd=450560
>   tid 0: len=3316 truesize=15808
>   tid 0: len=4106 truesize=16640
>   tid 0: len=3967 truesize=16512
>   tid 0: len=2988 truesize=15488
> > I think that you should first look if you are under some kind of attack [1]

This and indeed the majority of similar occurrences come from a
websocket origin that can
emit a large flow of tiny packets. As the tcp_collapse hiccups occur
in a proxy node, we think that
a combination of slow / unresponsive clients and the websocket traffic
can trigger this.

We made a workaround to clamp the websocket's rcvbuf to a smaller
value and it reduces
the peak latency of tcp_collapse as we no longer need to collapse up to 16MB.

> What kind of NIC driver is used on your host ?

We are running mlx5

> Except that you would still have to parse the linear list.

Most of the time when we see a high value of tcp_collapse, the bloated
skb is almost always at the top
of the list. I guess the client is already unresponsive so the flow is
full of bloated skbs. I would rather not
having to spend too much time collapsing these skbs.
