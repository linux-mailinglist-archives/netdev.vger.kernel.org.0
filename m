Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69C5D6AAC80
	for <lists+netdev@lfdr.de>; Sat,  4 Mar 2023 21:48:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229759AbjCDUsr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Mar 2023 15:48:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229746AbjCDUsn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Mar 2023 15:48:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 005D61B551;
        Sat,  4 Mar 2023 12:48:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6F12860A48;
        Sat,  4 Mar 2023 20:48:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB6A2C433D2;
        Sat,  4 Mar 2023 20:48:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677962918;
        bh=NfBmVBeYzwKjgG01hzGaF8aGIwKsoVzw9AJTurpewMM=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=NplpAjwiVhpTS3DgedLpcxM49Rxt8SNDOfrg6C2pX44h1V3EhVMYCP8yvNT65DIA9
         PditGBBi6emtHyhEpzrzFDbLV12GC6ht7lUpAv6al6rF8kkMNNj4Q8hhOLfGdHp9Y6
         xSzPMl/ZMDaYQANYpQNZvBWxrUAmrkfG0vYUIYRRCwj3ENmbv664cOfIqcz5r616yn
         +svuLAHBQN1Mp/h2VodZF1iaHVIB4ONqvn7hD3FR3Xg8b8yh3NTCie4Zf/gXnFJL87
         J36rB0yb2vETE4osKvlXQj1De9VFC2lpUAtCiLlQIfUgtzK5w8pDXEGkhmK83WBT6b
         EQhbpNMBAsGPA==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
        id 623905C036B; Sat,  4 Mar 2023 12:48:38 -0800 (PST)
Date:   Sat, 4 Mar 2023 12:48:38 -0800
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>, peterz@infradead.org,
        jstultz@google.com, edumazet@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] softirq: avoid spurious stalls due to need_resched()
Message-ID: <20230304204838.GA1265853@paulmck-ThinkPad-P17-Gen-1>
Reply-To: paulmck@kernel.org
References: <20221222221244.1290833-1-kuba@kernel.org>
 <20221222221244.1290833-3-kuba@kernel.org>
 <87r0u6j721.ffs@tglx>
 <20230303133143.7b35433f@kernel.org>
 <20230303223739.GC1301832@paulmck-ThinkPad-P17-Gen-1>
 <20230303233627.GA2136520@paulmck-ThinkPad-P17-Gen-1>
 <20230303154413.1d846ac3@kernel.org>
 <20230304012535.GF1301832@paulmck-ThinkPad-P17-Gen-1>
 <20230303173921.29d9faef@kernel.org>
 <20230304031109.GG1301832@paulmck-ThinkPad-P17-Gen-1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230304031109.GG1301832@paulmck-ThinkPad-P17-Gen-1>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 03, 2023 at 07:11:09PM -0800, Paul E. McKenney wrote:
> On Fri, Mar 03, 2023 at 05:39:21PM -0800, Jakub Kicinski wrote:
> > On Fri, 3 Mar 2023 17:25:35 -0800 Paul E. McKenney wrote:
> > > > Just to be sure - have you seen Peter's patches?
> > > > 
> > > >   git://git.kernel.org/pub/scm/linux/kernel/git/peterz/queue.git core/softirq
> > > > 
> > > > I think it feeds the time limit to the callback from softirq,
> > > > so the local 3ms is no more?  
> > > 
> > > I might or might not have back in September of 2020.  ;-)
> > > 
> > > But either way, the question remains:  Should RCU_SOFTIRQ do time checking
> > > in ksoftirqd context?  Seems like the answer should be "yes", independently
> > > of Peter's patches.
> > 
> > :-o  I didn't notice, I thought that's from Dec 22, LWN was writing
> > about Peter's rework at that point. I'm not sure what the story is :(
> > And when / if any of these changes are coming downstream.
> 
> Not a problem either way, as the compiler would complain bitterly about
> the resulting merge conflict and it is easy to fix.  ;-)

And even more not a problem because in_serving_softirq() covers both the
softirq environment as well as ksoftirqd.  So that "else" clause is for
rcuoc kthreads, which do not block other softirq vectors.  So I am adding
a comment instead...

							Thanx, Paul
