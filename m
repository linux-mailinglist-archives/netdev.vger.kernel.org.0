Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81E1C3CF964
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 14:11:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236874AbhGTLap (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 07:30:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:57394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235205AbhGTLaa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Jul 2021 07:30:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 07FA361186;
        Tue, 20 Jul 2021 12:11:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626783069;
        bh=av9dlPOiIuOYX4rH9uCvNWi6RQdlqGoBD1H0vMS1szM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=PZuEca6SVRX7UrxD+bSUquzzGIz55YjMPR2xfFprnkZpbHqjEL4074TAfUpueg7XO
         ZqEcEu8qMiK5mRH9/cj2a56SFJivuu3l33vNz2cQmCZPIuxjkptpFPq+D1aCRsf07u
         npBvgHBaaga0X2uAE+B1lN2RApltgiaWg4TdX3/43ZnbAyIRS5gNhPmJub901EhgS1
         oxChRRPEl3jvkr/blB2c8FT0pa0yQonD1QY7MpNDtPrWWzSUVhc7IwYVqJhA2EdY6P
         tBYlQY6TGQvRbfN30gCz1+khN7bqfqByuOihQjcjIQ7bY/WqItLQdFWifuguYwfXMk
         Iq+GUMIREtHqw==
Date:   Tue, 20 Jul 2021 14:11:01 +0200
From:   Jakub Kicinski <kuba@kernel.org>
To:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Steen Hegelund <steen.hegelund@microchip.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Subject: Re: linux-next: build failure in Linus' tree
Message-ID: <20210720141101.78c1b8ba@cakuba>
In-Reply-To: <20210720164531.3f122a89@canb.auug.org.au>
References: <20210715095032.6897f1f6@canb.auug.org.au>
        <20210720164531.3f122a89@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 20 Jul 2021 16:45:31 +1000, Stephen Rothwell wrote:
> Hi all,
> 
> On Thu, 15 Jul 2021 09:50:32 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> >
> > While compiling Linus' tree, a powerpc-allmodconfig build (and others)
> > with gcc 4.9 failed like this:
> > 
> > drivers/net/ethernet/microchip/sparx5/sparx5_netdev.c: In function 'ifh_encode_bitfield':
> > include/linux/compiler_types.h:328:38: error: call to '__compiletime_assert_431' declared with attribute error: Unsupported width, must be <= 40
> >   _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
> >                                       ^
> > include/linux/compiler_types.h:309:4: note: in definition of macro '__compiletime_assert'
> >     prefix ## suffix();    \
> >     ^
> > include/linux/compiler_types.h:328:2: note: in expansion of macro '_compiletime_assert'
> >   _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
> >   ^
> > drivers/net/ethernet/microchip/sparx5/sparx5_netdev.c:28:2: note: in expansion of macro 'compiletime_assert'
> >   compiletime_assert(width <= 40, "Unsupported width, must be <= 40");
> >   ^
> > 
> > Caused by commit
> > 
> >   f3cad2611a77 ("net: sparx5: add hostmode with phylink support")
> > 
> > I guess this is caused by the call to ifh_encode_bitfield() not being
> > inlined.  
> 
> I am still getting these failures.

Bjarni, Steen, could you address this build failure ASAP?

We can't have a compile time asserts in static functions, if the code
is optimized for size chances are the function won't get inlined. clang
is pretty bad at propagating constants to compile time asserts, too.
Please remove this check, or refactor it to be done in a macro, or ..
