Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 538E428132B
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 14:51:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387768AbgJBMvY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 08:51:24 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:40184 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726017AbgJBMvY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Oct 2020 08:51:24 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kOKWk-00HDPc-5z; Fri, 02 Oct 2020 14:51:10 +0200
Date:   Fri, 2 Oct 2020 14:51:10 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Nick Desaulniers <ndesaulniers@google.com>,
        netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        Rohit Maheshwari <rohitm@chelsio.com>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Subject: Re: [PATCH net-next v2 1/2] Makefile.extrawarn: Add symbol for W=1
 warnings for today
Message-ID: <20201002125110.GJ4067422@lunn.ch>
References: <20201001011232.4050282-1-andrew@lunn.ch>
 <20201001011232.4050282-2-andrew@lunn.ch>
 <CAKwvOdnVC8F1=QT03W5Zh9pJdTxxNfRcqXeob5_b4CXycvG1+g@mail.gmail.com>
 <20201002014411.GG4067422@lunn.ch>
 <CAK8P3a0tA9VMMjgkFeCaM3dWLu8H0CFBTkE8zeUpwSR1o31z1w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK8P3a0tA9VMMjgkFeCaM3dWLu8H0CFBTkE8zeUpwSR1o31z1w@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 02, 2020 at 02:20:50PM +0200, Arnd Bergmann wrote:
> On Fri, Oct 2, 2020 at 3:44 AM Andrew Lunn <andrew@lunn.ch> wrote:
> > On Thu, Oct 01, 2020 at 04:09:43PM -0700, Nick Desaulniers wrote:
> > > On Wed, Sep 30, 2020 at 6:12 PM Andrew Lunn <andrew@lunn.ch> wrote:
> > > >
> > > > There is a movement to try to make more and more of /drivers W=1
> > > > clean. But it will only stay clean if new warnings are quickly
> > > > detected and fixed, ideally by the developer adding the new code.
> 
> Nice, I think everyone agrees that this is a good goal.
> 
> > > > To allow subdirectories to sign up to being W=1 clean for a given
> > > > definition of W=1, export the current set of additional compile flags
> > > > using the symbol KBUILD_CFLAGS_W1_20200930. Subdirectory Makefiles can
> > > > then use:
> > > >
> > > > subdir-ccflags-y := $(KBUILD_CFLAGS_W1_20200930)
> > > >
> > > > To indicate they want to W=1 warnings as defined on 20200930.
> > > >
> > > > Additional warnings can be added to the W=1 definition. This will not
> > > > affect KBUILD_CFLAGS_W1_20200930 and hence no additional warnings will
> > > > start appearing unless W=1 is actually added to the command
> > > > line. Developers can then take their time to fix any new W=1 warnings,
> > > > and then update to the latest KBUILD_CFLAGS_W1_<DATESTAMP> symbol.
> > >
> > > I'm not a fan of this approach.  Are DATESTAMP configs just going to
> > > keep being added? Is it going to complicate isolating the issue from a
> > > randconfig build?  If we want more things to build warning-free at
> > > W=1, then why don't we start moving warnings from W=1 into the
> > > default, until this is no W=1 left?  That way we're cutting down on
> > > the kernel's configuration combinatorial explosion, rather than adding
> > > to it?
> 
> I'm also a little sceptical about the datestamp.

Hi Arnd

Any suggestions for an alternative?

> It won't change with the configuration, but it will change with the
> specific compiler version. When you enable a warning in a
> particular driver or directory, this may have different effects
> on one compiler compared to another: clang and gcc sometimes
> differ in their interpretation of which specific forms of an expression
> to warn about or not, and any multiplexing options like -Wextra
> or -Wformat may turn on additional warnings in later releases.

How do we deal with this at the moment? Or will -Wextra and -Wformat
never get moved into the default?

> I think the two approaches are orthogonal, and I would like to
> see both happening as much as possible:
> 
> - any warning flag in the W=1 set (including many things implied
>   by -Wextra that have or should have their own flags) that
>   only causes a few lines of output should just be enabled by
>   default after we address the warnings

Is there currently any simple way to get statistics about how many
actual warnings there are per warnings flag in W=1? W=1 on the tree as
a whole does not look good, but maybe there is some low hanging fruit
and we can quickly promote some from W=1 to default?

> - Code with maintainers that care should have a way to enable
>   the entire W=1 set per directory or per file after addressing all
>   the warnings they do see, with new flags only getting added to
>   W=1 when they don't cause regressions.

Yes, this is what i'm trying to push forward here. I don't
particularly care how it happen, so if somebody comes up with a
generally acceptable idea, i will go away and implement it.

> > People generally don't care about the tree as a whole. They care about
> > their own corner. The idea of fixing one warning thought the whole
> > tree is 'slicing and dicing' the kernel the wrong way. As we have seen
> > with the recent work with W=1, the more natural way to slice/dice the
> > kernel is by subdirectories.
> 
> I do care about the tree as a whole, and I'm particularly interested in
> having -Wmissing-declarations/-Wmissing-prototypes enabled globally
> at some point in the future.

I know you care. But you are vastly out numbered by developers who
care about their own little corner. Which is why i said 'generally'.

We definitely should come at the problem from both directions, but i
guess we can make more progress with tools for the large number of
developers each in their own corner, than tools for the few who work
tree wide.

     Andrew
