Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE487280C0F
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 03:44:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387496AbgJBBob (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 21:44:31 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:39484 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727780AbgJBBob (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Oct 2020 21:44:31 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kOA7H-00H9Pv-O0; Fri, 02 Oct 2020 03:44:11 +0200
Date:   Fri, 2 Oct 2020 03:44:11 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        Rohit Maheshwari <rohitm@chelsio.com>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH net-next v2 1/2] Makefile.extrawarn: Add symbol for W=1
 warnings for today
Message-ID: <20201002014411.GG4067422@lunn.ch>
References: <20201001011232.4050282-1-andrew@lunn.ch>
 <20201001011232.4050282-2-andrew@lunn.ch>
 <CAKwvOdnVC8F1=QT03W5Zh9pJdTxxNfRcqXeob5_b4CXycvG1+g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKwvOdnVC8F1=QT03W5Zh9pJdTxxNfRcqXeob5_b4CXycvG1+g@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 01, 2020 at 04:09:43PM -0700, Nick Desaulniers wrote:
> On Wed, Sep 30, 2020 at 6:12 PM Andrew Lunn <andrew@lunn.ch> wrote:
> >
> > There is a movement to try to make more and more of /drivers W=1
> > clean. But it will only stay clean if new warnings are quickly
> > detected and fixed, ideally by the developer adding the new code.
> >
> > To allow subdirectories to sign up to being W=1 clean for a given
> > definition of W=1, export the current set of additional compile flags
> > using the symbol KBUILD_CFLAGS_W1_20200930. Subdirectory Makefiles can
> > then use:
> >
> > subdir-ccflags-y := $(KBUILD_CFLAGS_W1_20200930)
> >
> > To indicate they want to W=1 warnings as defined on 20200930.
> >
> > Additional warnings can be added to the W=1 definition. This will not
> > affect KBUILD_CFLAGS_W1_20200930 and hence no additional warnings will
> > start appearing unless W=1 is actually added to the command
> > line. Developers can then take their time to fix any new W=1 warnings,
> > and then update to the latest KBUILD_CFLAGS_W1_<DATESTAMP> symbol.
> 
> I'm not a fan of this approach.  Are DATESTAMP configs just going to
> keep being added? Is it going to complicate isolating the issue from a
> randconfig build?  If we want more things to build warning-free at
> W=1, then why don't we start moving warnings from W=1 into the
> default, until this is no W=1 left?  That way we're cutting down on
> the kernel's configuration combinatorial explosion, rather than adding
> to it?

Hi Nick

I don't see randconfig being an issue. driver/net/ethernet would
always be build W=1, by some stable definition of W=1. randconfig
would not enable or disable additional warnings. It to make it clear,
KBUILD_CFLAGS_W1_20200930 is not a Kconfig option you can select. It
is a Makefile constant, a list of warnings which define what W=1 means
on that specific day. See patch 1/2.

I see a few issues with moving individual warnings from W=1 to the
default:

One of the comments for v1 of this patchset is that we cannot
introduce new warnings in the build. The complete tree needs to clean
of a particularly warning, before it can be added to the default list.
But that is not how people are cleaning up code, nor how the
infrastructure is designed. Those doing the cleanup are not take the
first from the list, -Wextra and cleanup up the whole tree for that
one warnings. They are rather enabling W=1 on a subdirectory, and
cleanup up all warnings on that subdirectory. So using this approach,
in order to move a warning from W=1 to the default, we are going to
have to get the entire tree W=1 clean, and move them all the warnings
are once.

People generally don't care about the tree as a whole. They care about
their own corner. The idea of fixing one warning thought the whole
tree is 'slicing and dicing' the kernel the wrong way. As we have seen
with the recent work with W=1, the more natural way to slice/dice the
kernel is by subdirectories.

I do however understand the fear that we end up with lots of
KBUILD_CFLAGS_W1_<DATESTAMP> constants. So i looked at the git history
of script/Makefile.extrawarn. These are historically the symbols we
would have, if we started this idea 1/1/2018:

KBUILD_CFLAGS_W1_20200326    # CLANG only change
KBUILD_CFLAGS_W1_20190907
KBUILD_CFLAGS_W1_20190617    # CLANG only change
KBUILD_CFLAGS_W1_20190614    # CLANG only change
KBUILD_CFLAGS_W1_20190509
KBUILD_CFLAGS_W1_20180919
KBUILD_CFLAGS_W1_20180111

So not too many.

   Andrew
