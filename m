Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95E0E634212
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 18:00:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234419AbiKVRAr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 12:00:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234416AbiKVRAq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 12:00:46 -0500
Received: from 1wt.eu (wtarreau.pck.nerim.net [62.212.114.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 18B742F67F;
        Tue, 22 Nov 2022 09:00:43 -0800 (PST)
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id 2AMGxCjf016272;
        Tue, 22 Nov 2022 17:59:12 +0100
Date:   Tue, 22 Nov 2022 17:59:12 +0100
From:   Willy Tarreau <w@1wt.eu>
To:     David Laight <David.Laight@aculab.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
Subject: Re: Optimising csum_fold()
Message-ID: <20221122165912.GD15368@1wt.eu>
References: <e77165c267df486f914f8013fede1d32@AcuMS.aculab.com>
 <20221122162451.GB15368@1wt.eu>
 <f2ad1680da754f0eab1083d651c8f71c@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f2ad1680da754f0eab1083d651c8f71c@AcuMS.aculab.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 22, 2022 at 04:55:27PM +0000, David Laight wrote:
> From: Willy Tarreau <w@1wt.eu>
> > Sent: 22 November 2022 16:25
> > 
> > On Tue, Nov 22, 2022 at 01:08:23PM +0000, David Laight wrote:
> > > There are currently 20 copies of csum_fold(), some in C some in assembler.
> > > The default C version (in asm-generic/checksum.h) is pretty horrid.
> > > Some of the asm versions (including x86 and x86-64) aren't much better.
> > >
> > > There are 3 pretty good C versions:
> > >   1:	(~sum - rol32(sum, 16)) >> 16
> > >   2:  ~(sum + rol32(sum, 16)) >> 16
> > >   3:  (u16)~((sum + rol32(sum, 16)) >> 16)
> > > All three are (usually) 4 arithmetic instructions.
> > >
> > > The first two have the advantage that the high bits are zero.
> > > Relevant when the value is being checked rather than set.
> > >
> > > The first one can generate better instruction scheduling (the rotate
> > > and invert can be executed in the same clock).
> > >
> > > The 3rd one saves an instruction on arm, but may need masking.
> > > (I've not compiled an arm kernel to see how often that happens.)
> > >
> > > The only architectures where (I think) the current asm code is better
> > > than the C above are sparc and sparc64.
> > > Sparc doesn't have a rotate instruction, but does have a carry flag.
> > > This makes the current asm version one instruction shorter.
> > >
> > > For architectures like mips and risc-v which have neither rotate
> > > instructions nor carry flags the C is as good as the current asm.
> > > The rotate is 3 instructions - the same as the extra cmp+add.
> > >
> > > Changing everything to use [1] would improve quite a few architectures
> > > while only adding 1 clock to some paths in arm/arm64 and sparc.
> > >
> > > Unfortunately it is all currently a mess.
> > > Most architectures don't include asm-generic/checksum.h at all.
> > >
> > > Thoughts?
> > 
> > Then why not just have one version per arch, the most efficient one,
> > and use it everywhere ? The simple fact that we're discussing the
> > tradeoffs means that if we don't want to compromise performance here
> > (which I assume to be the case), then it needs to be per-arch and
> > that's all. At least that's the way I understand it.
> 
> At the moment there are a lot of arch-specific ones that are
> definitely sub-optimal.

Yes very likely!

> I started doing some patches, my x86-64 kernel in about 4k
> smaller with [1].
> I was going to post the patches to asm-generic an x86.

I mean, maybe we could have your 3 versions with different names
in asm-generic, and have each asm file define csum_fold() to one
of them. That would limit the spreadth of variants and the auditing
difficulty.

Willy
