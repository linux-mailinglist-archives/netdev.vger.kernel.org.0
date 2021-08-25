Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3ECD03F7B34
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 19:08:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242163AbhHYRJF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 13:09:05 -0400
Received: from smtp8.emailarray.com ([65.39.216.67]:29566 "EHLO
        smtp8.emailarray.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229711AbhHYRJE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 13:09:04 -0400
Received: (qmail 97070 invoked by uid 89); 25 Aug 2021 17:08:15 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTYzLjExNC4xMzIuMQ==) (POLARISLOCAL)  
  by smtp8.emailarray.com with SMTP; 25 Aug 2021 17:08:15 -0000
Date:   Wed, 25 Aug 2021 10:08:13 -0700
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Networking <netdev@vger.kernel.org>
Subject: Re: [PATCH] ptp: ocp: don't allow on S390
Message-ID: <20210825170813.7muvouqsijy3ysrr@bsd-mbp.dhcp.thefacebook.com>
References: <20210813203026.27687-1-rdunlap@infradead.org>
 <CAK8P3a3QGF2=WZz6N8wQo2ZQxmVqKToHGmhT4wEtB7tAL+-ruQ@mail.gmail.com>
 <20210820153100.GA9604@hoboy.vegasvil.org>
 <80be0a74-9b0d-7386-323c-c261ca378eef@infradead.org>
 <CAK8P3a11wvEhoEutCNBs5NqiZ2VUA1r-oE1CKBBaYbu_abr4Aw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK8P3a11wvEhoEutCNBs5NqiZ2VUA1r-oE1CKBBaYbu_abr4Aw@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 25, 2021 at 12:55:25PM +0200, Arnd Bergmann wrote:
> On Tue, Aug 24, 2021 at 11:48 PM Randy Dunlap <rdunlap@infradead.org> wrote:
> >
> > On 8/20/21 8:31 AM, Richard Cochran wrote:
> > > On Fri, Aug 20, 2021 at 12:45:42PM +0200, Arnd Bergmann wrote:
> > >
> > >> I would also suggest removing all the 'imply' statements, they
> > >> usually don't do what the original author intended anyway.
> > >> If there is a compile-time dependency with those drivers,
> > >> it should be 'depends on', otherwise they can normally be
> > >> left out.
> > >
> > > +1
> >
> > Hi,
> >
> > Removing the "imply" statements is simple enough and the driver
> > still builds cleanly without them, so Yes, they aren't needed here.
> >
> > Removing the SPI dependency is also clean.
> >
> > The driver does use I2C, MTD, and SERIAL_8250 interfaces, so they
> > can't be removed without some other driver changes, like using
> > #ifdef/#endif (or #if IS_ENABLED()) blocks and some function stubs.
> 
> If the SERIAL_8250 dependency is actually required, then using
> 'depends on' for this is probably better than an IS_ENABLED() check.
> The 'select' is definitely misplaced here, that doesn't even work when
> the dependencies fo 8250 itself are not met, and it does force-enable
> the entire TTY subsystem.

So, something like the following (untested) patch?
I admit to not fully understanding all the nuances around Kconfig.
-- 
Jonathan

diff --git a/drivers/ptp/Kconfig b/drivers/ptp/Kconfig
index 32660dc11354..c3372efd1bb7 100644
--- a/drivers/ptp/Kconfig
+++ b/drivers/ptp/Kconfig
@@ -171,15 +171,10 @@ config PTP_1588_CLOCK_OCP
        tristate "OpenCompute TimeCard as PTP clock"
        depends on PTP_1588_CLOCK
        depends on HAS_IOMEM && PCI
-       depends on SPI && I2C && MTD
+       depends on I2C && MTD
+       depends on SERIAL_8250
        depends on !S390
-       imply SPI_MEM
-       imply SPI_XILINX
-       imply MTD_SPI_NOR
-       imply I2C_XILINX
-       select SERIAL_8250
        select NET_DEVLINK
-
        default n
        help
          This driver adds support for an OpenCompute time card.
