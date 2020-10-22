Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5558295A41
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 10:26:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2895251AbgJVI0W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Oct 2020 04:26:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:56800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2444122AbgJVI0S (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Oct 2020 04:26:18 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2ABFB2065D;
        Thu, 22 Oct 2020 08:26:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603355177;
        bh=dmCNgDGTpNmF+8O2fjJO2XplnMkrwwsAXNmOMHG4kDE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=zDx/QVbNU8SimNSxRnLGamZjzaL0aYk8447/KE6GRihUCtWhJ6Z86tE/3/Weg2vwC
         GiWZsECpqwLisbFLZe5yubGxrkvnswusVy8o3gK7vn/eUfbf4ADoW/+TTZixBrP7Y/
         ZuwgVCa1BoOMrly/6gJ13uZ1QxD/B6i974xOGQS0=
Date:   Thu, 22 Oct 2020 10:26:54 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Al Viro <viro@zeniv.linux.org.uk>,
        Nick Desaulniers <ndesaulniers@google.com>
Cc:     Christoph Hellwig <hch@lst.de>, kernel-team@android.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, Arnd Bergmann <arnd@arndb.de>,
        David Howells <dhowells@redhat.com>,
        David Laight <David.Laight@aculab.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org,
        sparclinux@vger.kernel.org, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-aio@kvack.org, io-uring@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-mm@kvack.org,
        netdev@vger.kernel.org, keyrings@vger.kernel.org,
        linux-security-module@vger.kernel.org
Subject: Re: Buggy commit tracked to: "Re: [PATCH 2/9] iov_iter: move
 rw_copy_check_uvector() into lib/iov_iter.c"
Message-ID: <20201022082654.GA1477657@kroah.com>
References: <20200925045146.1283714-1-hch@lst.de>
 <20200925045146.1283714-3-hch@lst.de>
 <20201021161301.GA1196312@kroah.com>
 <20201021233914.GR3576660@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201021233914.GR3576660@ZenIV.linux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 22, 2020 at 12:39:14AM +0100, Al Viro wrote:
> On Wed, Oct 21, 2020 at 06:13:01PM +0200, Greg KH wrote:
> > On Fri, Sep 25, 2020 at 06:51:39AM +0200, Christoph Hellwig wrote:
> > > From: David Laight <David.Laight@ACULAB.COM>
> > > 
> > > This lets the compiler inline it into import_iovec() generating
> > > much better code.
> > > 
> > > Signed-off-by: David Laight <david.laight@aculab.com>
> > > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > > ---
> > >  fs/read_write.c | 179 ------------------------------------------------
> > >  lib/iov_iter.c  | 176 +++++++++++++++++++++++++++++++++++++++++++++++
> > >  2 files changed, 176 insertions(+), 179 deletions(-)
> > 
> > Strangely, this commit causes a regression in Linus's tree right now.
> > 
> > I can't really figure out what the regression is, only that this commit
> > triggers a "large Android system binary" from working properly.  There's
> > no kernel log messages anywhere, and I don't have any way to strace the
> > thing in the testing framework, so any hints that people can provide
> > would be most appreciated.
> 
> It's a pure move - modulo changed line breaks in the argument lists
> the functions involved are identical before and after that (just checked
> that directly, by checking out the trees before and after, extracting two
> functions in question from fs/read_write.c and lib/iov_iter.c (before and
> after, resp.) and checking the diff between those.
> 
> How certain is your bisection?

The bisection is very reproducable.

But, this looks now to be a compiler bug.  I'm using the latest version
of clang and if I put "noinline" at the front of the function,
everything works.

Nick, any ideas here as to who I should report this to?

I'll work on a fixup patch for the Android kernel tree to see if I can
work around it there, but others will hit this in Linus's tree sooner or
later...

thanks,

greg k-h
