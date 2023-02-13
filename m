Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37955694E60
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 18:49:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229567AbjBMRtA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 12:49:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230184AbjBMRsz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 12:48:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 623C81F934;
        Mon, 13 Feb 2023 09:48:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EAABAB81624;
        Mon, 13 Feb 2023 17:48:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D99AC433D2;
        Mon, 13 Feb 2023 17:48:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676310530;
        bh=KolfguvNkJgNxPeBch9TKh/NIl+yTt6QO4x4ItWFvek=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=14fDbUwYvFwmxrqzJ4T82nI1FyZKOM/oW1Kf+JhMGLjhj9RHEO5wUvlGbyaOy8v+A
         wfS3JzrrqzGiZiBeAeRRP/u4LfnYEyA5Hj7IheOSckWSh/3o1VQ9r0gPZtPIZALmDy
         RehMCKwN7+g1OEt4IOMXEZw6316VKrTzObl414jw=
Date:   Mon, 13 Feb 2023 18:48:48 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     w@1wt.eu, netdev@vger.kernel.org, regressions@lists.linux.dev,
        stable@vger.kernel.org, winter@winter.cafe
Subject: Re: [REGRESSION] 5.15.88 and onwards no longer return EADDRINUSE
 from bind
Message-ID: <Y+p4AJHkP8JUf4KB@kroah.com>
References: <Y+nsQlVzmTP0meTX@1wt.eu>
 <20230213164455.36911-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230213164455.36911-1-kuniyu@amazon.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 13, 2023 at 08:44:55AM -0800, Kuniyuki Iwashima wrote:
> From:   Willy Tarreau <w@1wt.eu>
> Date:   Mon, 13 Feb 2023 08:52:34 +0100
> > Hi Greg,
> > 
> > On Mon, Feb 13, 2023 at 08:25:34AM +0100, Greg KH wrote:
> > > On Mon, Feb 13, 2023 at 05:27:03AM +0100, Willy Tarreau wrote:
> > > > Hi,
> > > > 
> > > > [CCed netdev]
> > > > 
> > > > On Sun, Feb 12, 2023 at 10:38:40PM -0500, Winter wrote:
> > > > > Hi all,
> > > > > 
> > > > > I'm facing the same issue as
> > > > > https://lore.kernel.org/stable/CAFsF8vL4CGFzWMb38_XviiEgxoKX0GYup=JiUFXUOmagdk9CRg@mail.gmail.com/,
> > > > > but on 5.15. I've bisected it across releases to 5.15.88, and can reproduce
> > > > > on 5.15.93.
> > > > > 
> > > > > However, I cannot seem to find the identified problematic commit in the 5.15
> > > > > branch, so I'm unsure if this is a different issue or not.
> > > > > 
> > > > > There's a few ways to reproduce this issue, but the one I've been using is
> > > > > running libuv's (https://github.com/libuv/libuv) tests, specifically tests
> > > > > 271 and 277.
> > > > 
> > > > >From the linked patch:
> > > > 
> > > >   https://lore.kernel.org/stable/20221228144337.512799851@linuxfoundation.org/
> > > 
> > > But that commit only ended up in 6.0.y, not 5.15, so how is this an
> > > issue in 5.15.y?
> > 
> > Hmmm I plead -ENOCOFFEE on my side, I hadn't notice the "can't find the
> > problematic commit", you're right indeed.
> > 
> > However if the issue happened in 5.15.88, the only part touching the
> > network listening area is this one which may introduce an EINVAL on
> > one listening path, but that seems unrelated to me given that it's
> > only for ULP that libuv doesn't seem to be using:
> > 
> >   dadd0dcaa67d ("net/ulp: prevent ULP without clone op from entering the LISTEN status")
> 
> This commit accidentally backports a part of 7a7160edf1bf ("net: Return
> errno in sk->sk_prot->get_port().") and removed err = -EADDRINUSE in
> inet_csk_listen_start().  Then, listen() will return 0 even if ->get_port()
> actually fails and returns 1.
> 
> I can send a small revert or a whole backport, but which is preferable ?
> The original patch is not for stable, but it will make future backports
> easy.

A whole revert is probably best, if it's not needed.  But if it is, a
fix up would be fine to get as well.

thanks,

greg k-h
