Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AB0F3F7D89
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 23:14:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230301AbhHYVPI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 17:15:08 -0400
Received: from smtp.emailarray.com ([69.28.212.198]:39543 "EHLO
        smtp2.emailarray.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230501AbhHYVPH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 17:15:07 -0400
Received: (qmail 47002 invoked by uid 89); 25 Aug 2021 21:14:18 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTYzLjExNC4xMzIuMQ==) (POLARISLOCAL)  
  by smtp2.emailarray.com with SMTP; 25 Aug 2021 21:14:18 -0000
Date:   Wed, 25 Aug 2021 14:14:15 -0700
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     Arnd Bergmann <arnd@kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Networking <netdev@vger.kernel.org>
Subject: Re: [PATCH] ptp: ocp: don't allow on S390
Message-ID: <20210825211415.mbr2bikxmqts7ie4@bsd-mbp.dhcp.thefacebook.com>
References: <20210813203026.27687-1-rdunlap@infradead.org>
 <CAK8P3a3QGF2=WZz6N8wQo2ZQxmVqKToHGmhT4wEtB7tAL+-ruQ@mail.gmail.com>
 <20210820153100.GA9604@hoboy.vegasvil.org>
 <80be0a74-9b0d-7386-323c-c261ca378eef@infradead.org>
 <CAK8P3a11wvEhoEutCNBs5NqiZ2VUA1r-oE1CKBBaYbu_abr4Aw@mail.gmail.com>
 <20210825170813.7muvouqsijy3ysrr@bsd-mbp.dhcp.thefacebook.com>
 <8f0848a6-354d-ff58-7d41-8610dc095773@infradead.org>
 <20210825204042.5v7ad3ntor6s3pq3@bsd-mbp.dhcp.thefacebook.com>
 <35952ae9-07a5-11aa-76ae-d698bcaa9804@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <35952ae9-07a5-11aa-76ae-d698bcaa9804@infradead.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 25, 2021 at 01:45:57PM -0700, Randy Dunlap wrote:
> On 8/25/21 1:40 PM, Jonathan Lemon wrote:
> > On Wed, Aug 25, 2021 at 10:29:51AM -0700, Randy Dunlap wrote:
> > > On 8/25/21 10:08 AM, Jonathan Lemon wrote:
> > > > On Wed, Aug 25, 2021 at 12:55:25PM +0200, Arnd Bergmann wrote:
> > > > > On Tue, Aug 24, 2021 at 11:48 PM Randy Dunlap <rdunlap@infradead.org> wrote:
> > > > > > 
> > > > > > On 8/20/21 8:31 AM, Richard Cochran wrote:
> > > > > > > On Fri, Aug 20, 2021 at 12:45:42PM +0200, Arnd Bergmann wrote:
> > > > > > > 
> > > > > > > > I would also suggest removing all the 'imply' statements, they
> > > > > > > > usually don't do what the original author intended anyway.
> > > > > > > > If there is a compile-time dependency with those drivers,
> > > > > > > > it should be 'depends on', otherwise they can normally be
> > > > > > > > left out.
> > > > > > > 
> > > > > > > +1
> > > > > > 
> > > > > > Hi,
> > > > > > 
> > > > > > Removing the "imply" statements is simple enough and the driver
> > > > > > still builds cleanly without them, so Yes, they aren't needed here.
> > > > > > 
> > > > > > Removing the SPI dependency is also clean.
> > > > > > 
> > > > > > The driver does use I2C, MTD, and SERIAL_8250 interfaces, so they
> > > > > > can't be removed without some other driver changes, like using
> > > > > > #ifdef/#endif (or #if IS_ENABLED()) blocks and some function stubs.
> > > > > 
> > > > > If the SERIAL_8250 dependency is actually required, then using
> > > > > 'depends on' for this is probably better than an IS_ENABLED() check.
> > > > > The 'select' is definitely misplaced here, that doesn't even work when
> > > > > the dependencies fo 8250 itself are not met, and it does force-enable
> > > > > the entire TTY subsystem.
> > > > 
> > > > So, something like the following (untested) patch?
> > > > I admit to not fully understanding all the nuances around Kconfig.
> > > 
> > > Hi,
> > > 
> > > You can also remove the "select NET_DEVLINK". The driver builds fine
> > > without it. And please drop the "default n" while at it.
> > 
> > I had to add this one because devlink is a dependency and the kbuild
> > robot generated a config without it.
> 
> What kind of dependency is devlink?
> The driver builds without NET_DEVLINK.

It really doesn't.  Odds are one of the network drivers is also
selecting this as well, so it is hidden.
-- 
Jonathan
