Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B59638901D
	for <lists+netdev@lfdr.de>; Sun, 11 Aug 2019 09:29:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726323AbfHKH3N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Aug 2019 03:29:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:50670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725776AbfHKH3M (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 11 Aug 2019 03:29:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ECADB208C2;
        Sun, 11 Aug 2019 07:29:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565508551;
        bh=a18vG4RFaJ1WnQTrQP/A7Fv6lll+Bd1t6q3Pb5dEzII=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xU+1adYVSI0rMNnzRsoaowKdWgU0WokCNDwfBQFfhdWcc0YLPAbaxq7M1xbn75oiY
         5odMmCfDZPXgCz+VwOJ5EV3UWRBqLembaQb7hDHGqkUEY77vH66CWdV0Pi84Rnz0AR
         0br1/8rebHmNysYMMg97eMbkughzY/rR4olgmZ3k=
Date:   Sun, 11 Aug 2019 09:29:07 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     Thomas Bogendoerfer <tbogendoerfer@suse.de>,
        Ralf Baechle <ralf@linux-mips.org>,
        Paul Burton <paul.burton@mips.com>,
        James Hogan <jhogan@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Lee Jones <lee.jones@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Jiri Slaby <jslaby@suse.com>,
        Evgeniy Polyakov <zbr@ioremap.net>, linux-mips@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-input <linux-input@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "open list:REAL TIME CLOCK (RTC) SUBSYSTEM" 
        <linux-rtc@vger.kernel.org>,
        "open list:SERIAL DRIVERS" <linux-serial@vger.kernel.org>
Subject: Re: [PATCH v4 8/9] MIPS: SGI-IP27: fix readb/writeb addressing
Message-ID: <20190811072907.GA1416@kroah.com>
References: <20190809103235.16338-1-tbogendoerfer@suse.de>
 <20190809103235.16338-9-tbogendoerfer@suse.de>
 <CAHp75Vd_083R9sRsspVuJ3ZMTxpVR79PF5Lg-bpnMxRfN+b7wA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHp75Vd_083R9sRsspVuJ3ZMTxpVR79PF5Lg-bpnMxRfN+b7wA@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 10, 2019 at 04:22:23PM +0300, Andy Shevchenko wrote:
> On Fri, Aug 9, 2019 at 1:34 PM Thomas Bogendoerfer
> <tbogendoerfer@suse.de> wrote:
> >
> > Our chosen byte swapping, which is what firmware already uses, is to
> > do readl/writel by normal lw/sw intructions (data invariance). This
> > also means we need to mangle addresses for u8 and u16 accesses. The
> > mangling for 16bit has been done aready, but 8bit one was missing.
> > Correcting this causes different addresses for accesses to the
> > SuperIO and local bus of the IOC3 chip. This is fixed by changing
> > byte order in ioc3 and m48rtc_rtc structs.
> 
> >  /* serial port register map */
> >  struct ioc3_serialregs {
> > -       uint32_t        sscr;
> > -       uint32_t        stpir;
> > -       uint32_t        stcir;
> > -       uint32_t        srpir;
> > -       uint32_t        srcir;
> > -       uint32_t        srtr;
> > -       uint32_t        shadow;
> > +       u32     sscr;
> > +       u32     stpir;
> > +       u32     stcir;
> > +       u32     srpir;
> > +       u32     srcir;
> > +       u32     srtr;
> > +       u32     shadow;
> >  };
> 
> Isn't it a churn? AFAIU kernel documentation the uint32_t is okay to
> use, just be consistent inside one module / driver.
> Am I mistaken?

No, but really it uint* shouldn't be used anywhere in the kernel source
as it does not make sense.

thanks,

greg k-h
