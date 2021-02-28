Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A5FE32740A
	for <lists+netdev@lfdr.de>; Sun, 28 Feb 2021 20:18:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231357AbhB1TRx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Feb 2021 14:17:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:45470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231296AbhB1TRw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 28 Feb 2021 14:17:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9688364E74;
        Sun, 28 Feb 2021 19:17:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614539831;
        bh=8Jzbct29pJR4sj72HwmM+hAAoIoMs8p31633ixWx98M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dMgDQ5CBTB0+4CmJZdGUPfVbeNq3kosHzpFGz9z7VGy+9dPEtQ7Cf7py0h9qCDejB
         769861SVNkns4FYeySFIl26WXiuJzPQ/XEymQzP50/WR+8RHhxGtvy1E0iXxUgM3nE
         SUlJzcmcdTWLoZmGY9ZQsL9Lxm2NFBku+TmWc8RjeTZ1zmsAWTI5IS24IPk7Mnokmf
         U4drEINpt3eR8d983a3lwB/RrSMlS4QMaXtuwlYjbG/9OmTwqQ/GD2gzpGi9JFqg/I
         mXoNgGhfk87MkccOQyiWg72W0qJBQQWrJPG+T4dI9/HTnF1BbJeHTPDcS2Q2RCRn/a
         leeF/oLOJHHEg==
Date:   Sun, 28 Feb 2021 11:17:10 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Wei Wang <weiwan@google.com>
Cc:     Alexander Duyck <alexanderduyck@fb.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Martin Zaharinov <micron10@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>
Subject: Re: [PATCH net v2] net: fix race between napi kthread mode and busy
 poll
Message-ID: <20210228111710.4e82a88e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAEA6p_DtTG6ryiG3GkxaySJeNcYF=RfkgCYTc-T-mHqMwL2-Gw@mail.gmail.com>
References: <20210227003047.1051347-1-weiwan@google.com>
        <20210226164803.4413571f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAEA6p_CJx7K1Fab1C0Qkw=1VNnDaV9qwB_UUtikPMoqNUUWJuA@mail.gmail.com>
        <20210226172240.24d626e5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAEA6p_B6baYFZnEOMS=Nmvg0kA_qB=7ip4S96ys9ZoJWfOiOCA@mail.gmail.com>
        <20210226180833.09c98110@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAEA6p_ABZfs3zyQ+90cC1P8T8w94Lz4RvvBdQHQsHXEPP5aexQ@mail.gmail.com>
        <CAEA6p_DtTG6ryiG3GkxaySJeNcYF=RfkgCYTc-T-mHqMwL2-Gw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 27 Feb 2021 15:23:56 -0800 Wei Wang wrote:
> > > Indeed, looks like the task will be in WAKING state until it runs?
> > > We can switch the check in ____napi_schedule() from
> > >
> > >         if (thread->state == TASK_RUNNING)
> > >
> > > to
> > >
> > >         if (!(thread->state & TASK_INTERRUPTIBLE))
> > >
> > > ?  
> >
> > Hmm... I am not very sure what state the thread will be put in after
> > kthread_create(). Could it be in TASK_INTERRUPTIBLE?  
> 
> I did a printk and confirmed that the thread->state is
> TASK_UNINTERRUPTIBLE after kthread_create() is called.
> So I think if we change the above state to:
>           if (thread->state != TASK_INTERRUPTIBLE)
>                   set_bit(NAPI_STATE_SCHED_THREADED, &napi->state);
> It should work.

> diff --git a/net/core/dev.c b/net/core/dev.c
> index 6c5967e80132..43607523ee99 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -1501,17 +1501,18 @@ static int napi_kthread_create(struct napi_struct *n)
>  {
>         int err = 0;
> 
> -       /* Create and wake up the kthread once to put it in
> -        * TASK_INTERRUPTIBLE mode to avoid the blocked task
> -        * warning and work with loadavg.
> +       /* Avoid waking up the kthread during creation to prevent
> +        * potential race.
>          */
> -       n->thread = kthread_run(napi_threaded_poll, n, "napi/%s-%d",
> -                               n->dev->name, n->napi_id);
> +       n->thread = kthread_create(napi_threaded_poll, n, "napi/%s-%d",
> +                                  n->dev->name, n->napi_id);

Does kthread_run() make the thread go into TASK_INTERRUPTIBLE ?
It just calls wake_up_process(), which according to a comment in the
kdoc..

 * Conceptually does:
 *
 *   If (@state & @p->state) @p->state = TASK_RUNNING.

So I think we could safely stick to kthread_run() if the condition in
at the NAPI wake point checks for INTERRUPTIBLE?
