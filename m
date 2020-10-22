Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5550D295B20
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 11:01:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2509920AbgJVJBU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Oct 2020 05:01:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:41206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2509093AbgJVJBT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Oct 2020 05:01:19 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 28A9221775;
        Thu, 22 Oct 2020 09:01:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603357277;
        bh=rAUCu3y7+03C75oqJ/20IK+Enh1/ET9ZKI7jdElMjo4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ad/zpVq/zKZLTkR1qraoAyhbAOsAvF+KdoSyEBs42/YLrGpiLyddqpRptp/SZLyPi
         jIHhSoabF1qMfT1ObkraxF/Ul+8o1N2gos3O4YOsvBymdBfz2InJa17WOryGKFU6TA
         RNvXrxZvulro6hjQh6nEdXR7Oy+/eCOK/s20i5z4=
Date:   Thu, 22 Oct 2020 11:01:55 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     David Hildenbrand <david@redhat.com>
Cc:     David Laight <David.Laight@aculab.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Christoph Hellwig <hch@lst.de>,
        "kernel-team@android.com" <kernel-team@android.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, Arnd Bergmann <arnd@arndb.de>,
        David Howells <dhowells@redhat.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
        "linux-parisc@vger.kernel.org" <linux-parisc@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "sparclinux@vger.kernel.org" <sparclinux@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-aio@kvack.org" <linux-aio@kvack.org>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "keyrings@vger.kernel.org" <keyrings@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>
Subject: Re: Buggy commit tracked to: "Re: [PATCH 2/9] iov_iter: move
 rw_copy_check_uvector() into lib/iov_iter.c"
Message-ID: <20201022090155.GA1483166@kroah.com>
References: <20200925045146.1283714-1-hch@lst.de>
 <20200925045146.1283714-3-hch@lst.de>
 <20201021161301.GA1196312@kroah.com>
 <20201021233914.GR3576660@ZenIV.linux.org.uk>
 <20201022082654.GA1477657@kroah.com>
 <80a2e5fa-718a-8433-1ab0-dd5b3e3b5416@redhat.com>
 <5d2ecb24db1e415b8ff88261435386ec@AcuMS.aculab.com>
 <df2e0758-b8ed-5aec-6adc-a18f499c0179@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <df2e0758-b8ed-5aec-6adc-a18f499c0179@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 22, 2020 at 10:48:59AM +0200, David Hildenbrand wrote:
> On 22.10.20 10:40, David Laight wrote:
> > From: David Hildenbrand
> >> Sent: 22 October 2020 09:35
> >>
> >> On 22.10.20 10:26, Greg KH wrote:
> >>> On Thu, Oct 22, 2020 at 12:39:14AM +0100, Al Viro wrote:
> >>>> On Wed, Oct 21, 2020 at 06:13:01PM +0200, Greg KH wrote:
> >>>>> On Fri, Sep 25, 2020 at 06:51:39AM +0200, Christoph Hellwig wrote:
> >>>>>> From: David Laight <David.Laight@ACULAB.COM>
> >>>>>>
> >>>>>> This lets the compiler inline it into import_iovec() generating
> >>>>>> much better code.
> >>>>>>
> >>>>>> Signed-off-by: David Laight <david.laight@aculab.com>
> >>>>>> Signed-off-by: Christoph Hellwig <hch@lst.de>
> >>>>>> ---
> >>>>>>  fs/read_write.c | 179 ------------------------------------------------
> >>>>>>  lib/iov_iter.c  | 176 +++++++++++++++++++++++++++++++++++++++++++++++
> >>>>>>  2 files changed, 176 insertions(+), 179 deletions(-)
> >>>>>
> >>>>> Strangely, this commit causes a regression in Linus's tree right now.
> >>>>>
> >>>>> I can't really figure out what the regression is, only that this commit
> >>>>> triggers a "large Android system binary" from working properly.  There's
> >>>>> no kernel log messages anywhere, and I don't have any way to strace the
> >>>>> thing in the testing framework, so any hints that people can provide
> >>>>> would be most appreciated.
> >>>>
> >>>> It's a pure move - modulo changed line breaks in the argument lists
> >>>> the functions involved are identical before and after that (just checked
> >>>> that directly, by checking out the trees before and after, extracting two
> >>>> functions in question from fs/read_write.c and lib/iov_iter.c (before and
> >>>> after, resp.) and checking the diff between those.
> >>>>
> >>>> How certain is your bisection?
> >>>
> >>> The bisection is very reproducable.
> >>>
> >>> But, this looks now to be a compiler bug.  I'm using the latest version
> >>> of clang and if I put "noinline" at the front of the function,
> >>> everything works.
> >>
> >> Well, the compiler can do more invasive optimizations when inlining. If
> >> you have buggy code that relies on some unspecified behavior, inlining
> >> can change the behavior ... but going over that code, there isn't too
> >> much action going on. At least nothing screamed at me.
> > 
> > Apart from all the optimisations that get rid off the 'pass be reference'
> > parameters and strange conditional tests.
> > Plenty of scope for the compiler getting it wrong.
> > But nothing even vaguely illegal.
> 
> Not the first time that people blame the compiler to then figure out
> that something else is wrong ... but maybe this time is different :)

I agree, I hate to blame the compiler, that's almost never the real
problem, but this one sure "feels" like it.

I'm running some more tests, trying to narrow things down as just adding
a "noinline" to the function that got moved here doesn't work on Linus's
tree at the moment because the function was split into multiple
functions.

Give me a few hours...

thanks,

greg k-h
