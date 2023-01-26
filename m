Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1807567D660
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 21:26:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232252AbjAZU0Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 15:26:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231655AbjAZUZ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 15:25:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FC4C7377C
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 12:25:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AD5E9B81E0B
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 20:25:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C2ADC433EF;
        Thu, 26 Jan 2023 20:25:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674764712;
        bh=DYWL9vRnyYNAFlP/SzWCeksMdIP+NTn2/u5hVh9iuSc=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=QYHk9teg0kf+CJpNs5xw7TalppHCbp4WmeE/6kjkaqWahACQhITbRyAM8rjz3CHqo
         SJAIZwuA69gRKm5EzyYTWpBblJsmXIVo2QnV6lbt3jUtCGW9kRWwfHyRDA9ZqYiT2J
         aYrnY1tGH6Sf134csfY4DBFIkzkY05TYJ6/Fm4m30OXsMy71u9fWv45AKqgg2qpA1E
         F84NZio63LnuwAvfaYV1BxvSaRSMwcywcs8JmfmDQ0RudCmIGccuKXStiReBYyNkGU
         +JtuWCZgbOYofbtMupDPuqsPHPXW/8JBR4Jr+L4O4Ckp1JXwUPjrffy/fIqeqa1RL6
         2J3TZahuW6Byg==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
        id E07D95C1C6D; Thu, 26 Jan 2023 12:25:11 -0800 (PST)
Date:   Thu, 26 Jan 2023 12:25:11 -0800
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Kirill Tkhai <tkhai@ya.ru>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        kuniyu@amazon.com, gorcunov@gmail.com
Subject: Re: [PATCH net-next] unix: Guarantee sk_state relevance in case of
 it was assigned by a task on other cpu
Message-ID: <20230126202511.GL2948950@paulmck-ThinkPad-P17-Gen-1>
Reply-To: paulmck@kernel.org
References: <72ae40ef-2d68-2e89-46d3-fc8f820db42a@ya.ru>
 <20230124173557.2b13e194@kernel.org>
 <6953ec3b-6c48-954e-f3db-63450a5ab886@ya.ru>
 <20230125221053.301c0341@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230125221053.301c0341@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 25, 2023 at 10:10:53PM -0800, Jakub Kicinski wrote:
> On Thu, 26 Jan 2023 00:09:08 +0300 Kirill Tkhai wrote:
> > 1)There are a many combinations with third task involved:
> > 
> > [CPU0:Task0]  [CPU1:Task1]                           [CPU2:Task2]
> > listen(sk)
> >               kernel:
> >                 sk_diag_fill(sk)
> >                   rep->udiag_state = TCP_LISTEN
> >                 return_from_syscall
> >               userspace:
> >                 mutex_lock()
> >                 shared_mem_var = rep->udiag_state 
> >                 mutex_unlock()
> > 
> >                                                      userspace: 
> >                                                        mutex_lock()
> >                                                        if (shared_mem_var == TCP_LISTEN)
> >                                                          accept(sk); /* -> fail, since sk_state is not visible */
> >                                                        mutex_unlock()
> > 
> > In this situation Task2 definitely knows Task0's listen() has succeed, but there is no a possibility
> > to guarantee its accept() won't fail. Despite there are appropriate barriers in mutex_lock() and mutex_unlock(),
> > there is no a possibility to add a barrier on CPU1 to make Task0's store visible on CPU2.
> 
> Me trying to prove that memory ordering is transitive would be 100%
> speculation. Let's ask Paul instead - is the above valid? Or the fact
> that CPU1 observes state from CPU0 and is strongly ordered with CPU2
> implies that CPU2 will also observe CPU0's state?

Hmmm...  What is listen() doing?  There seem to be a lot of them
in the kernel.

But proceeding on first principles...

Sometimes.  Memory ordering is transitive only when the ordering is
sufficiently strong.

In this case, I do not see any ordering between CPU 0 and anything else.
If the listen() function were to acquire the same mutex as CPU1 and CPU2
did, and if it acquired it first, then CPU2 would be guaranteed to see
anything CPU0 did while holding that mutex.

Alternatively, if CPU0 wrote to some memory, and CPU1 read that value
before releasing the mutex (including possibly before acquiring that
mutex), then CPU2 would be guaranteed to see that value (or the value
written by some later write to that same memory) after acquiring that
mutex.

So here are some things you can count on transitively:

1.	After acquiring a given lock (or mutex or whatever), you will
	see any values written or read prior to any earlier conflicting
	release of that same lock.

2.	After an access with acquire semantics (for example,
	smp_load_acquire()) you will see any values written or read
	prior to any earlier access with release semantics (for example,
	smp_store_release()).

Or in all cases, you might see later values, in case someone else also
did a write to the location in question.

Does that help, or am I missing a turn in there somewhere?

							Thanx, Paul
