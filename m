Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5451563E2DF
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 22:43:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229660AbiK3Vnb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 16:43:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbiK3Vna (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 16:43:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2D51769FD;
        Wed, 30 Nov 2022 13:43:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2980761E05;
        Wed, 30 Nov 2022 21:43:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D9A1C433D7;
        Wed, 30 Nov 2022 21:43:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669844608;
        bh=d+XZQFsoyZn0bNyAsgJB+8TgIz28In9nJ8iHQfRcRYg=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=VF3vM0r/sflL3CIjAmqERb8k1Tq4IXO9IEyOq1g3+o4Fzebw+En7brY7ummjpjZC8
         oSB/Y8bHHxsye8Mqst4A4BKk/inirFjstR3Vzpl5XSsnroqcTaeGR0Pstjna21ogyc
         0WC025Ql1GdumPJbt5FZ0dmz8qLL4b+5dLYT89pdaTGpzsygNMHZWdimi7V8XxHiMz
         3ei6s2HMGRfF90sMa7/WrXZ2hgiUTZVFDIFwQEi4ulmdNm2QCXrwocWD8fQpPQyyeF
         S3M1YBLKgToZJzy7v0P9oP1s1Tu8mZC6jIAGhJQ85b1ZwvjmRE5bGOH7Dt2/hDv3PW
         Vt2IYcpmtez/w==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
        id E9D785C051C; Wed, 30 Nov 2022 13:43:27 -0800 (PST)
Date:   Wed, 30 Nov 2022 13:43:27 -0800
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Joel Fernandes <joel@joelfernandes.org>
Cc:     David Howells <dhowells@redhat.com>, rcu@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-team@meta.com,
        rostedt@goodmis.org, Marc Dionne <marc.dionne@auristor.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-afs@lists.infradead.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH rcu 14/16] rxrpc: Use call_rcu_hurry() instead of
 call_rcu()
Message-ID: <20221130214327.GU4001@paulmck-ThinkPad-P17-Gen-1>
Reply-To: paulmck@kernel.org
References: <639433.1669835344@warthog.procyon.org.uk>
 <B4935931-239F-4C48-9646-2C20578F027C@joelfernandes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <B4935931-239F-4C48-9646-2C20578F027C@joelfernandes.org>
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 30, 2022 at 02:20:52PM -0500, Joel Fernandes wrote:
> 
> 
> > On Nov 30, 2022, at 2:09 PM, David Howells <dhowells@redhat.com> wrote:
> > 
> > ﻿Note that this conflicts with my patch:
> 
> Oh.  I don’t see any review or Ack tags on it. Is it still under review?

So what I have done is to drop this patch from the series, but to also
preserve it for posterity at -rcu branch lazy-obsolete.2022.11.30a.

It looks like that wakeup is still delayed, but I could easily be
missing something.

Joel, could you please test the effects of having the current lazy branch,
but also David Howells's patch?  That way, if there is an issue, we can
work it sooner rather than later, and if it all works fine, we can stop
worrying about it.  ;-)

							Thanx, Paul

> Thanks,
> 
> - Joel
> 
> 
> 
> > 
> >    rxrpc: Don't hold a ref for connection workqueue
> >    https://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git/commit/?h=rxrpc-next&id=450b00011290660127c2d76f5c5ed264126eb229
> > 
> > which should render it unnecessary.  It's a little ahead of yours in the
> > net-next queue, if that means anything.
> > 
> > David
> > 
