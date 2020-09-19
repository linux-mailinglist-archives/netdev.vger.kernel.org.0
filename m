Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B48362710D2
	for <lists+netdev@lfdr.de>; Sun, 20 Sep 2020 00:03:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726749AbgISWDH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Sep 2020 18:03:07 -0400
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:43992 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726582AbgISWDG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Sep 2020 18:03:06 -0400
X-Greylist: delayed 621 seconds by postgrey-1.27 at vger.kernel.org; Sat, 19 Sep 2020 18:03:05 EDT
Received: from localhost (localhost.localdomain [127.0.0.1])
        by kvm5.telegraphics.com.au (Postfix) with ESMTP id C29A129C36;
        Sat, 19 Sep 2020 17:52:40 -0400 (EDT)
Date:   Sun, 20 Sep 2020 07:52:38 +1000 (AEST)
From:   Finn Thain <fthain@telegraphics.com.au>
To:     Arnd Bergmann <arnd@arndb.de>
cc:     Peter Maydell <peter.maydell@linaro.org>,
        Andy Lutomirski <luto@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        David Howells <dhowells@redhat.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        "open list:MIPS" <linux-mips@vger.kernel.org>,
        Parisc List <linux-parisc@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        sparclinux <sparclinux@vger.kernel.org>,
        linux-block <linux-block@vger.kernel.org>,
        Linux SCSI List <linux-scsi@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        linux-aio <linux-aio@kvack.org>, io-uring@vger.kernel.org,
        linux-arch <linux-arch@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Network Development <netdev@vger.kernel.org>,
        keyrings@vger.kernel.org,
        LSM List <linux-security-module@vger.kernel.org>
Subject: Re: [PATCH 1/9] kernel: add a PF_FORCE_COMPAT flag
In-Reply-To: <CAK8P3a2Mi+1yttyGk4k7HxRVrMtmFqJewouVhynqUL0PJycmog@mail.gmail.com>
Message-ID: <alpine.LNX.2.23.453.2009200745310.6@nippy.intranet>
References: <20200918124533.3487701-1-hch@lst.de> <20200918124533.3487701-2-hch@lst.de> <20200918134012.GY3421308@ZenIV.linux.org.uk> <20200918134406.GA17064@lst.de> <20200918135822.GZ3421308@ZenIV.linux.org.uk> <20200918151615.GA23432@lst.de>
 <CALCETrW=BzodXeTAjSvpCoUQoL+MKaKPEeSTRWnB=-C9jMotbQ@mail.gmail.com> <CAK8P3a2Mi+1yttyGk4k7HxRVrMtmFqJewouVhynqUL0PJycmog@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 19 Sep 2020, Arnd Bergmann wrote:

> On Sat, Sep 19, 2020 at 6:21 PM Andy Lutomirski <luto@kernel.org> wrote:
> > On Fri, Sep 18, 2020 at 8:16 AM Christoph Hellwig <hch@lst.de> wrote:
> > > On Fri, Sep 18, 2020 at 02:58:22PM +0100, Al Viro wrote:
> > > > Said that, why not provide a variant that would take an explicit 
> > > > "is it compat" argument and use it there?  And have the normal one 
> > > > pass in_compat_syscall() to that...
> > >
> > > That would help to not introduce a regression with this series yes. 
> > > But it wouldn't fix existing bugs when io_uring is used to access 
> > > read or write methods that use in_compat_syscall().  One example 
> > > that I recently ran into is drivers/scsi/sg.c.
> 
> Ah, so reading /dev/input/event* would suffer from the same issue, and 
> that one would in fact be broken by your patch in the hypothetical case 
> that someone tried to use io_uring to read /dev/input/event on x32...
> 
> For reference, I checked the socket timestamp handling that has a number 
> of corner cases with time32/time64 formats in compat mode, but none of 
> those appear to be affected by the problem.
> 
> > Aside from the potentially nasty use of per-task variables, one thing 
> > I don't like about PF_FORCE_COMPAT is that it's one-way.  If we're 
> > going to have a generic mechanism for this, shouldn't we allow a full 
> > override of the syscall arch instead of just allowing forcing compat 
> > so that a compat syscall can do a non-compat operation?
> 
> The only reason it's needed here is that the caller is in a kernel 
> thread rather than a system call. Are there any possible scenarios where 
> one would actually need the opposite?
> 

Quite possibly. The ext4 vs. compat getdents bug is still unresolved. 
Please see,
https://lore.kernel.org/lkml/CAFEAcA9W+JK7_TrtTnL1P2ES1knNPJX9wcUvhfLwxLq9augq1w@mail.gmail.com/

>        Arnd
> 
