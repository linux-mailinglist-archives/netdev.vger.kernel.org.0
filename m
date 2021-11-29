Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0465460EDC
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 07:42:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347084AbhK2GqH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 01:46:07 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:34754 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348855AbhK2GoH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 01:44:07 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2661C611F1
        for <netdev@vger.kernel.org>; Mon, 29 Nov 2021 06:40:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD5B2C004E1;
        Mon, 29 Nov 2021 06:40:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638168049;
        bh=go2TNNFTKNGVv/mOEn+JTCbJDsQScA/Hq/0NwDPQ7Y0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tzJ+Pp05KwVARvzYT+/hCNb129cEDbO7dyYtgDprgMXmzjg5TuXMZ1c5dVFmsqfLT
         yBh/ecDNYCKYz0FoePfabHXMXgaHZBNAnDYxdVNTNh71GSdYTJNVPeXx7G/1wutRW2
         F2Oz3ToBq5PMDnkX9p1hXknaE5C7CEMqg1ufHPJ3HTFzOn/ZcZ2jluKVnKK8geBIys
         idHGqFJ6MJ28qFMDkXF/TLv1TAwKgrTzfJThmHCiOiWmF5bu0kiGu2KO8a4h3u7h/M
         qrj8WuG3DK5E7Fy6LWNONH16M0qHJuHCc21w6KItl37k6NQu59i0PlR9JISqxF3300
         IRDjES+fL9xnw==
Date:   Mon, 29 Nov 2021 08:40:44 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Sergey Ryazanov <ryazanov.s.a@gmail.com>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        M Chetan Kumar <m.chetan.kumar@intel.com>,
        Intel Corporation <linuxwwan@intel.com>,
        Loic Poulain <loic.poulain@linaro.org>
Subject: Re: [PATCH RESEND net-next 5/5] net: wwan: core: make debugfs
 optional
Message-ID: <YaR17NOQqvFxXEVs@unreal>
References: <20211128125522.23357-1-ryazanov.s.a@gmail.com>
 <20211128125522.23357-6-ryazanov.s.a@gmail.com>
 <ac532d400cd61a0f86ad5b1931df87a83582323c.camel@sipsolutions.net>
 <CAHNKnsSgc0bEwJbS01f26JRLpnzky9mcSJ6sWy2vFDuNOHz-Xw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHNKnsSgc0bEwJbS01f26JRLpnzky9mcSJ6sWy2vFDuNOHz-Xw@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 29, 2021 at 02:45:16AM +0300, Sergey Ryazanov wrote:
> Add Leon to CC to merge both conversations.
> 
> On Sun, Nov 28, 2021 at 8:01 PM Johannes Berg <johannes@sipsolutions.net> wrote:
> > On Sun, 2021-11-28 at 15:55 +0300, Sergey Ryazanov wrote:
> >>
> >> +config WWAN_DEBUGFS
> >> +     bool "WWAN subsystem common debugfs interface"
> >> +     depends on DEBUG_FS
> >> +     help
> >> +       Enables common debugfs infrastructure for WWAN devices.
> >> +
> >> +       If unsure, say N.
> >>
> >
> > I wonder if that really should even say "If unsure, say N." because
> > really, once you have DEBUG_FS enabled, you can expect things to show up
> > there?
> >
> > And I'd probably even argue that it should be
> >
> >         bool "..." if EXPERT
> >         default y
> >         depends on DEBUG_FS
> >
> > so most people aren't even bothered by the question?
> >
> >
> >>  config WWAN_HWSIM
> >>       tristate "Simulated WWAN device"
> >>       help
> >> @@ -83,6 +91,7 @@ config IOSM
> >>  config IOSM_DEBUGFS
> >>       bool "IOSM Debugfs support"
> >>       depends on IOSM && DEBUG_FS
> >> +     select WWAN_DEBUGFS
> >>
> > I guess it's kind of a philosophical question, but perhaps it would make
> > more sense for that to be "depends on" (and then you can remove &&
> > DEBUG_FS"), since that way it becomes trivial to disable all of WWAN
> > debugfs and not have to worry about individual driver settings?
> >
> >
> > And after that change, I'd probably just make this one "def_bool y"
> > instead of asking the user.
> 
> When I was preparing this series, my primary considered use case was
> embedded firmwares. For example, in OpenWrt, you can not completely
> disable debugfs, as a lot of wireless stuff can only be configured and
> monitored with the debugfs knobs. At the same time, reducing the size
> of a kernel and modules is an essential task in the world of embedded
> software. Disabling the WWAN and IOSM debugfs interfaces allows us to
> save 50K (x86-64 build) of space for module storage. Not much, but
> already considerable when you only have 16MB of storage.
> 
> I personally like Johannes' suggestion to enable these symbols by
> default to avoid bothering PC users with such negligible things for
> them. One thing that makes me doubtful is whether we should hide the
> debugfs disabling option under the EXPERT. Or it would be an EXPERT
> option misuse, since the debugfs knobs existence themself does not
> affect regular WWAN device use.
> 
> Leon, would it be Ok with you to add these options to the kernel
> configuration and enable them by default?

I didn't block your previous proposal either. Just pointed that your
description doesn't correlate with the actual rationale for the patches.

Instead of security claims, just use your OpenWrt case as a base for
the commit message, which is very reasonable and valuable case.

However you should ask yourself if both IOSM_DEBUGFS and WWAN_DEBUGFS
are needed. You wrote that wwan debugfs is empty without ioasm. Isn't
better to allow user to select WWAN_DEBUGFS and change iosm code to
rely on it instead of IOSM_DEBUGFS?

Thanks

> 
> -- 
> Sergey
