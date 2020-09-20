Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DC89271527
	for <lists+netdev@lfdr.de>; Sun, 20 Sep 2020 16:54:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726342AbgITOx6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Sep 2020 10:53:58 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:46032 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726267AbgITOx6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 20 Sep 2020 10:53:58 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kK0it-00FU26-QI; Sun, 20 Sep 2020 16:53:51 +0200
Date:   Sun, 20 Sep 2020 16:53:51 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Masahiro Yamada <masahiroy@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Subject: Re: [PATCH RFC/RFT 0/2] W=1 by default for Ethernet PHY subsystem
Message-ID: <20200920145351.GB3689762@lunn.ch>
References: <20200919190258.3673246-1-andrew@lunn.ch>
 <CAK7LNASY6hTDo8cuH5H_ExciEybBPbAuB3OxsmHbUUgoES94EA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK7LNASY6hTDo8cuH5H_ExciEybBPbAuB3OxsmHbUUgoES94EA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 20, 2020 at 12:42:51PM +0900, Masahiro Yamada wrote:
> On Sun, Sep 20, 2020 at 4:03 AM Andrew Lunn <andrew@lunn.ch> wrote:
> >
> > There is a movement to make the code base compile clean with W=1. Some
> > subsystems are already clean. In order to keep them clean, we need
> > developers to build new code with W=1 by default in these subsystems.
> >
> > This patchset refactors the core Makefile warning code to allow the
> > additional warnings W=1 adds available to any Makefile. The Ethernet
> > PHY subsystem Makefiles then make use of this to make W=1 the default
> > for this subsystem.
> >
> > RFT since i've only tested with x86 and arm with a modern gcc. Is the
> > code really clean for older compilers? For clang?
> 
> 
> I appreciate your efforts for keeping your subsystems
> clean for W=1 builds, and I hope this work will be
> extended towards upper directory level,
> drivers/net/phy -> drivers/net -> drivers/.
 
It definitely is.

drivers/net:
https://www.spinics.net/lists/netdev/msg683687.html

drivers/spi
https://www.spinics.net/lists/linux-spi/msg23280.html

drivers/mfd
https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg2211644.html

etc.

> So, another idea might be hard-coding extra warnings
> like drivers/gpu/drm/i915/Makefile.
> 
> For example, your subsystem already achieved
> -Wmissing-declarations free.
> 
> You can add
> 
>    subdir-ccflags-y += -Wmissing-declarations
> 
> to drivers/net/phy/Makefile.
> 
> Once you fix all net drivers, you can move it to
> the parent, drivers/net/Makefile.
> 
> Then, drivers/Makefile next, and if it reaches
> the top directory level, we can move it to W=0.

Do you think this will scale?

Lets just assume we do this at driver/ level. We have 141
subdirectories in driver/ . So we will end up with 141

subdir-ccflags-y += 

lines which we need to maintain.

Given the current cleanup effort, many are going to be identical to
todays W=1.

How do we maintain those 141 lines when it is time to add a new flag
to W=1?

How often are new W=1 flags added? My patch exported
KBUILD_CFLAGS_WARN1. How about instead we export
KBUILD_CFLAGS_WARN1_20200920. A subsystem can then sign up to being
W=1 clean as for the 20200920 definition of W=1.

If you want to add a new warning

KBUILD_CFLAGS_WARN1_20201031 := KBUILD_CFLAGS_WARN1_20200920 + "-Wghosts"

W=1 will always use the latest. You then build with W=1, maybe by
throwing it at 0-day, find which subsystems are still clean, and
update their subdir-ccflags-y += line with the new timestamp?

This should help with scaling, in that a subsystem is not dealing with
a list of warnings, just a symbol that represents the warnings from a
particular date?

Or maybe others have better ideas?

   Andrew
