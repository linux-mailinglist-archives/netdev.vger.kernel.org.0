Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB201326A57
	for <lists+netdev@lfdr.de>; Sat, 27 Feb 2021 00:11:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229885AbhBZXLZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Feb 2021 18:11:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:40502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229618AbhBZXLY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Feb 2021 18:11:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 95C3E64D99;
        Fri, 26 Feb 2021 23:10:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614381041;
        bh=Dck/P6NE+FFnDIbDWZIyjoYHCiJyJy2BkaOA5BwT41A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=abT4cklFz1qtvGqskF/qMyVPRr+sxRiq0JLpiD+5QSJJEhs94M5ZlKs5iAXNjGb68
         Gwpddy555hmFXkjHi9exZB9rWUOoKmQzsAKTX5Mrw5wkFJwrTorfSwybDAl2CbZXbE
         FG2dgKeZI7kCFS3ZvRQ0NFWK0AfpOsGdzP1cizOLd7aCMgYWNLJJIgwjFZayHt1cb4
         ksMVwRjpelW/mkN62KgTKBP7/S+9TKsQlu101RCsb97rcrCLa6XVRHScOuo4yubf4d
         aOdrds+4FosR4Ni5Ze2dZG+8DlW0jQVQpPT4FMXiZ7dOrn+BSWeBqoZbqRUEBFmayv
         /5EuCPYPVX1Uw==
Date:   Fri, 26 Feb 2021 15:10:40 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Wei Wang <weiwan@google.com>
Cc:     Martin Zaharinov <micron10@gmail.com>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Alexander Duyck <alexander.duyck@gmail.com>
Subject: Re: [PATCH net] net: fix race between napi kthread mode and busy
 poll
Message-ID: <20210226151040.6b9df8ac@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAEA6p_A2upx2Mza5US8tc0JJSkK3jLZ5z=a3quJtFWytdN5XvA@mail.gmail.com>
References: <20210223234130.437831-1-weiwan@google.com>
        <20210224162059.7949b4e1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <BN8PR15MB27873FF52B109480173366B8BD9E9@BN8PR15MB2787.namprd15.prod.outlook.com>
        <20210224180329.306b2207@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAEA6p_CEz-CaK_rCyGzRA8=WNspu2Uia5UasJ266f=p5uiqYkw@mail.gmail.com>
        <20210225002115.5f6215d8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAEA6p_DdccvmymRWEtggHgqb9dQ6NjK8rsrA03HH+r7mzt=5uw@mail.gmail.com>
        <20210225150048.23ed87c9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAEA6p_DnoQ8OLm731burXB58d9PfSPNU7_MvbeX_Ly1Grk2XbA@mail.gmail.com>
        <20210225171857.798e6c81@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAKgT0Ucip_cDs0juYN06xoDxFOrzo83JdhSOUEtRLugresQ2fw@mail.gmail.com>
        <CAEA6p_AJYBPMQY2DEy_vhRwrq5fnZR3z0A_-_HN0+S4yc45enQ@mail.gmail.com>
        <20210226133528.66882be1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAEA6p_A2upx2Mza5US8tc0JJSkK3jLZ5z=a3quJtFWytdN5XvA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 26 Feb 2021 14:24:29 -0800 Wei Wang wrote:
> > I'm not sure this takes care of rapid:
> >
> > dev_set_threaded(0)
> >  # NAPI gets sent to sirq
> > dev_set_threaded(1)
> >
> > since subsequent set_threaded(1) doesn't spawn the thread "afresh".
> 
> I think the race between softirq and kthread could be purely dependent
> on the SCHED bit. In napi_schedule_prep(), we check if SCHED bit is
> set. And we only call ____napi_schedule() when SCHED bit is not set.
> In ____napi_schedule(), we either wake up kthread, or raise softirq,
> never both.
> So as long as we don't wake up the kthread when creating it, there
> should not be a chance of race between softirq and kthread.

But we don't destroy the thread when dev_set_threaded(0) is called, or
make sure that it gets parked, we just clear NAPI_STATE_THREADED and
that's it. 

The thread could be running long after NAPI_STATE_THREADED was cleared,
and long after it gave up NAPI_STATE_SCHED. E.g. if some heavy sirq
processing kicks in at the very moment we reenable BH.

> > >         while (!kthread_should_stop() && !napi_disable_pending(napi)) {
> > > -               if (test_bit(NAPI_STATE_SCHED, &napi->state)) {
> > > +               unsigned long val = READ_ONCE(napi->state);
> > > +
> > > +               if (val & NAPIF_STATE_SCHED &&
> > > +                   !(val & NAPIF_STATE_SCHED_BUSY_POLL)) {  
> >
> > Again, not protected from the napi_disable() case AFAICT.  
> 
> Hmmm..... Yes. I think you are right. I missed that napi_disable()
> also grabs the SCHED bit. In this case, I think we have to use the
> SCHED_THREADED bit. The SCHED_BUSY_POLL bit is not enough to protect
> the race between napi_disable() and napi_threaded_poll(). :(
> Sorry, I missed this point when evaluating both solutions. I will have
> to switch to use the SCHED_THREADED bit.

Alright, AFAICT SCHED_THREADED doesn't suffer either of the problems 
I brought up here.
