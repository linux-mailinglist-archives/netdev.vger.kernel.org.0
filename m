Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CD8F4BBDC8
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 17:48:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238067AbiBRQtC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 11:49:02 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:56996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234380AbiBRQtB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 11:49:01 -0500
Received: from gate.crashing.org (gate.crashing.org [63.228.1.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id ADE09B5A;
        Fri, 18 Feb 2022 08:48:44 -0800 (PST)
Received: from gate.crashing.org (localhost.localdomain [127.0.0.1])
        by gate.crashing.org (8.14.1/8.14.1) with ESMTP id 21IGiLDR024462;
        Fri, 18 Feb 2022 10:44:21 -0600
Received: (from segher@localhost)
        by gate.crashing.org (8.14.1/8.14.1/Submit) id 21IGiLRA024461;
        Fri, 18 Feb 2022 10:44:21 -0600
X-Authentication-Warning: gate.crashing.org: segher set sender to segher@kernel.crashing.org using -f
Date:   Fri, 18 Feb 2022 10:44:20 -0600
From:   Segher Boessenkool <segher@kernel.crashing.org>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     Masahiro Yamada <masahiroy@kernel.org>,
        David Laight <David.Laight@aculab.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net v3] net: Force inlining of checksum functions in net/checksum.h
Message-ID: <20220218164420.GR614@gate.crashing.org>
References: <d38e5e1c-29b6-8cc6-7409-d0bdd5772f23@csgroup.eu> <9b8ef186-c7fe-822c-35df-342c9e86cc88@csgroup.eu> <3c2b682a7d804b5e8749428b50342c82@AcuMS.aculab.com> <CAK7LNASWTJ-ax9u5yOwHV9vHCBAcQTazV-oXtqVFVFedOA0Eqw@mail.gmail.com> <2e38265880db45afa96cfb51223f7418@AcuMS.aculab.com> <CAK7LNASvBLLWMa+kb5eGJ6vpSqob_dBUxwCnpHZfL-spzRG7qA@mail.gmail.com> <20220217180735.GM614@gate.crashing.org> <CAK7LNAQ3tdOEYP7LjSX5+vhy=eUf0q-YiktQriH-rcr1n2Q3aA@mail.gmail.com> <20220218121237.GQ614@gate.crashing.org> <20220218082920.06d6b80f@hermes.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220218082920.06d6b80f@hermes.local>
User-Agent: Mutt/1.4.2.3i
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 18, 2022 at 08:29:20AM -0800, Stephen Hemminger wrote:
> On Fri, 18 Feb 2022 06:12:37 -0600
> Segher Boessenkool <segher@kernel.crashing.org> wrote:
> > On Fri, Feb 18, 2022 at 10:35:48AM +0900, Masahiro Yamada wrote:
> > > On Fri, Feb 18, 2022 at 3:10 AM Segher Boessenkool
> > > <segher@kernel.crashing.org> wrote:  
> > > > On Fri, Feb 18, 2022 at 02:27:16AM +0900, Masahiro Yamada wrote:  
> > > > > On Fri, Feb 18, 2022 at 1:49 AM David Laight <David.Laight@aculab.com> wrote:  
> > > > > > That description is largely fine.
> > > > > >
> > > > > > Inappropriate 'inline' ought to be removed.
> > > > > > Then 'inline' means - 'really do inline this'.  
> > > > >
> > > > > You cannot change "static inline" to "static"
> > > > > in header files.  
> > > >
> > > > Why not?  Those two have identical semantics!  
> > > 
> > > e.g.)
> > > 
> > > 
> > > [1] Open  include/linux/device.h with your favorite editor,
> > >      then edit
> > > 
> > > static inline void *devm_kcalloc(struct device *dev,
> > > 
> > >     to
> > > 
> > > static void *devm_kcalloc(struct device *dev,
> > > 
> > > 
> > > [2] Build the kernel  
> > 
> > You get some "defined but not used" warnings that are shushed for
> > inlines.  Do you see something else?
> > 
> > The semantics are the same.  Warnings are just warnings.  It builds
> > fine.
> 
> Kernel code should build with zero warnings, the compiler is telling you
> something.

The second part is of course true.  The first part less so, and is in
fact not true at all from some points of view:
$ ./build --kernel x86_64
Building x86_64... (target x86_64-linux)
    kernel: configure [00:06] build [02:12]  1949 warnings  OK
(This is with a development version of GCC.)

There are simple ways to shut up specific warnings for specific code.
That is useful, certainly.  And so is having a warning-free build.  It
is obvious that we do survive without either of that though!

And none of this detracts from the point that the semantics of "static"
and "static inline" are identical.


Segher
