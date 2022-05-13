Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5B7B5269CE
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 21:03:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383488AbiEMTDo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 15:03:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241084AbiEMTDo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 15:03:44 -0400
Received: from mailgw.felk.cvut.cz (mailgw.felk.cvut.cz [147.32.82.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6445591365;
        Fri, 13 May 2022 12:03:41 -0700 (PDT)
Received: from mailgw.felk.cvut.cz (localhost.localdomain [127.0.0.1])
        by mailgw.felk.cvut.cz (Proxmox) with ESMTP id AD69530322D9;
        Fri, 13 May 2022 21:03:08 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        cmp.felk.cvut.cz; h=cc:cc:content-transfer-encoding:content-type
        :content-type:date:from:from:in-reply-to:message-id:mime-version
        :references:reply-to:subject:subject:to:to; s=felkmail; bh=Qk9Ud
        NR/JbQ6ZZ7ow3QrjSj7tcRhytNN46abF/0M+ps=; b=TMpKdgd7v36g4y04OgECJ
        gfmZ/zoREyfNiC4pR1ZeCyLAueFrZtYSSFobRpkoIBIHhW5M114bR6cAINsHUidd
        Xqko7sr0ikQNHxPJiCvreJTLLuVxlOdvHj5f7EwlBZoKIUyiSKMBIcqkl7EfqTPf
        s7ka+h7DpjKPoUX99aPmSWZuKv91QvdpAKrff4FxfiQ+HOqifF1p0MsJBUV9E09J
        yItYXcgnPsWmWWy8hzIyJiDVcd7+dykgBD8mxm3j66j2SM6YDXmwA1YCGpxB16I5
        nwBM9SSi8U+uSvavSJ0LuhQ7dvn6PsMCCMbRVmlZH0QgDqjdBBMH4LRk1aYuj84B
        w==
Received: from cmp.felk.cvut.cz (haar.felk.cvut.cz [147.32.84.19])
        by mailgw.felk.cvut.cz (Proxmox) with ESMTPS id 8E16230322D3;
        Fri, 13 May 2022 21:03:06 +0200 (CEST)
Received: from haar.felk.cvut.cz (localhost [127.0.0.1])
        by cmp.felk.cvut.cz (8.14.0/8.12.3/SuSE Linux 0.6) with ESMTP id 24DJ36fb031780;
        Fri, 13 May 2022 21:03:06 +0200
Received: (from pisa@localhost)
        by haar.felk.cvut.cz (8.14.0/8.13.7/Submit) id 24DJ36Qr031779;
        Fri, 13 May 2022 21:03:06 +0200
X-Authentication-Warning: haar.felk.cvut.cz: pisa set sender to pisa@cmp.felk.cvut.cz using -f
From:   Pavel Pisa <pisa@cmp.felk.cvut.cz>
To:     "Marc Kleine-Budde" <mkl@pengutronix.de>,
        Matej Vasilevski <matej.vasilevski@seznam.cz>,
        ondrej.ille@gmail.com, Jiri Novak <jnovak@fel.cvut.cz>
Subject: Re: [RFC PATCH 1/3] can: ctucanfd: add HW timestamps to RX and error CAN frames
Date:   Fri, 13 May 2022 21:02:58 +0200
User-Agent: KMail/1.9.10
Cc:     linux-can@vger.kernel.org, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, martin.jerabek01@gmail.com
References: <20220512232706.24575-1-matej.vasilevski@seznam.cz> <20220512232706.24575-2-matej.vasilevski@seznam.cz> <20220513114135.lgbda6armyiccj3o@pengutronix.de>
In-Reply-To: <20220513114135.lgbda6armyiccj3o@pengutronix.de>
X-KMail-QuotePrefix: > 
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <202205132102.58109.pisa@cmp.felk.cvut.cz>
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,NICE_REPLY_A,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Marc,

thanks for the fast feedback.

On Friday 13 of May 2022 13:41:35 Marc Kleine-Budde wrote:
> On 13.05.2022 01:27:05, Matej Vasilevski wrote:
> > This patch adds support for retrieving hardware timestamps to RX and
> > error CAN frames for platform devices. It uses timecounter and
> > cyclecounter structures, because the timestamping counter width depends
> > on the IP core implementation (it might not always be 64-bit).
> > To enable HW timestamps, you have to enable it in the kernel config
> > and provide the following properties in device tree:
>
> Please no Kconfig option. There is a proper interface to enable/disable
> time stamps form the user space. IIRC it's an ioctl. But I think the
> overhead is neglectable here.

thanks for suggestion

> > - ts-used-bits
>
> A property with "width"

agree

> in the name seems to be more common. You 
> probably have to add the "ctu" vendor prefix. BTW: the bindings document
> update should come before changing the driver.

this is RFC and not a final.

In general and long term, I vote and prefer to have number of the
most significant active timestamp bit to be encoded in some
CTU CAN FD IP core info register same as for the number of the Tx
buffers. We will discuss that internally. The the solution is the
same for platform as well as for PCI. But the possible second clock
frequency same as the bitrate clock source should stay to be provided
from platform and some table based on vendor and device ID in the PCI
case. Or at least it is my feeling about the situation.

> > - add second clock phandle to 'clocks' property
> > - create 'clock-names' property and name the second clock 'ts_clk'
> >
> > Alternatively, you can set property 'ts-frequency' directly with
> > the timestamping frequency, instead of setting second clock.
>
> For now, please use a clock property only. If you need ACPI bindings add
> them later.

I would be happy if I would never need to think about ACPI...
or if somebody else does it for us...

> > Signed-off-by: Matej Vasilevski <matej.vasilevski@seznam.cz>
> > ---
> >  drivers/net/can/ctucanfd/Kconfig              |  10 ++
> >  drivers/net/can/ctucanfd/Makefile             |   2 +-
> >  drivers/net/can/ctucanfd/ctucanfd.h           |  25 ++++
> >  drivers/net/can/ctucanfd/ctucanfd_base.c      | 123 +++++++++++++++++-
> >  drivers/net/can/ctucanfd/ctucanfd_timestamp.c | 113 ++++++++++++++++
> >  5 files changed, 267 insertions(+), 6 deletions(-)
> >  create mode 100644 drivers/net/can/ctucanfd/ctucanfd_timestamp.c
> >
> > diff --git a/drivers/net/can/ctucanfd/Kconfig
> > b/drivers/net/can/ctucanfd/Kconfig index 48963efc7f19..d75931525ce7
> > 100644
> > --- a/drivers/net/can/ctucanfd/Kconfig
> > +++ b/drivers/net/can/ctucanfd/Kconfig
> > @@ -32,3 +32,13 @@ config CAN_CTUCANFD_PLATFORM
> >  	  company. FPGA design
> > https://gitlab.fel.cvut.cz/canbus/zynq/zynq-can-sja1000-top. The kit
> > description at the Computer Architectures course pages
> > https://cw.fel.cvut.cz/wiki/courses/b35apo/documentation/mz_apo/start . +
> > +config CAN_CTUCANFD_PLATFORM_ENABLE_HW_TIMESTAMPS
> > +	bool "CTU CAN-FD IP core platform device hardware timestamps"
> > +	depends on CAN_CTUCANFD_PLATFORM
> > +	default n
> > +	help
> > +	  Enables reading hardware timestamps from the IP core for platform
> > +	  devices by default. You will have to provide ts-bit-size and
> > +	  ts-frequency/timestaping clock in device tree for CTU CAN-FD IP
> > cores, +	  see device tree bindings for more details.
>
> Please no Kconfig option, see above.

It is only my feeling, but I would keep driver for one or two releases
with timestamps code really disabled by default and make option visible
only when CONFIG_EXPERIMENTAL is set. This would could allow possible
incompatible changes and settle of the situation on IP core side...
Other options is to keep feature for while out of the tree. But review
by community is really important and I am open to suggestions...

> > diff --git a/drivers/net/can/ctucanfd/Makefile
> > b/drivers/net/can/ctucanfd/Makefile index 8078f1f2c30f..78b7d9830098
> > 100644
> > --- a/drivers/net/can/ctucanfd/Makefile
> > +++ b/drivers/net/can/ctucanfd/Makefile
> > --- /dev/null
> > +++ b/drivers/net/can/ctucanfd/ctucanfd_timestamp.c
> > @@ -0,0 +1,113 @@
> > +// SPDX-License-Identifier: GPL-2.0-or-later
> > +/***********************************************************************
> >******** + *
> > + * CTU CAN FD IP Core
> > + *
> > + * Copyright (C) 2022 Matej Vasilevski <matej.vasilevski@seznam.cz> FEE
> > CTU + *
> > + * Project advisors:
> > + *     Jiri Novak <jnovak@fel.cvut.cz>
> > + *     Pavel Pisa <pisa@cmp.felk.cvut.cz>
> > + *
> > + * Department of Measurement         (http://meas.fel.cvut.cz/)
> > + * Faculty of Electrical Engineering (http://www.fel.cvut.cz)
> > + * Czech Technical University        (http://www.cvut.cz/)
> > + *
> > + * This program is free software; you can redistribute it and/or
> > + * modify it under the terms of the GNU General Public License
> > + * as published by the Free Software Foundation; either version 2
> > + * of the License, or (at your option) any later version.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
>
> With the SPDX-License-Identifier you can skip this.

OK, Matej Vasilevski started his work on out of the tree code.

Please, model header according to actual net-next CTU CAN FD
files header.


> > +int ctucan_timestamp_init(struct ctucan_priv *priv)
> > +{
> > +	struct cyclecounter *cc = &priv->cc;
> > +
> > +	cc->read = ctucan_timestamp_read;
> > +	cc->mask = CYCLECOUNTER_MASK(priv->timestamp_bit_size);
> > +	cc->shift = 10;
> > +	cc->mult = clocksource_hz2mult(priv->timestamp_freq, cc->shift);
>
> If you frequency and width is not known, it's probably better not to
>
> hard code the shift and use clocks_calc_mult_shift() instead:
> | https://elixir.bootlin.com/linux/v5.17.7/source/kernel/time/clocksource.c
> |#L47

Thanks for the pointer. I have suggested dynamic shift approach used actually
in calculate_and_set_work_delay. May it be it can be replaced by some 
cloksource function as well.

> There's no need to do the above init on open(), especially in your case.
> I know the mcp251xfd does it this way....In your case, as you parse data
> from DT, it's better to do the parsing in probe and directly do all
> needed calculations and fill the struct cyclecounter there.

OK

Best wishes and thanks Matej Vasilevski for the great work and Marc
for the help to get it into the shape,

                Pavel
-- 
                Pavel Pisa
    e-mail:     pisa@cmp.felk.cvut.cz
    Department of Control Engineering FEE CVUT
    Karlovo namesti 13, 121 35, Prague 2
    university: http://control.fel.cvut.cz/
    personal:   http://cmp.felk.cvut.cz/~pisa
    projects:   https://www.openhub.net/accounts/ppisa
    CAN related:http://canbus.pages.fel.cvut.cz/
    Open Technologies Research Education and Exchange Services
    https://gitlab.fel.cvut.cz/otrees/org/-/wikis/home

