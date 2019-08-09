Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEC92879D2
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 14:23:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406797AbfHIMXC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 08:23:02 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:51125 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406048AbfHIMXB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 08:23:01 -0400
X-Originating-IP: 176.129.6.65
Received: from localhost (car62-h01-176-129-6-65.dsl.sta.abo.bbox.fr [176.129.6.65])
        (Authenticated sender: alexandre.belloni@bootlin.com)
        by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id 0B65C6000F;
        Fri,  9 Aug 2019 12:22:56 +0000 (UTC)
Date:   Fri, 9 Aug 2019 14:22:54 +0200
From:   Alexandre Belloni <alexandre.belloni@bootlin.com>
To:     Thomas Bogendoerfer <tbogendoerfer@suse.de>
Cc:     Lee Jones <lee.jones@linaro.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        Paul Burton <paul.burton@mips.com>,
        James Hogan <jhogan@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.com>, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        netdev@vger.kernel.org, linux-rtc@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH v3 5/7] mfd: ioc3: Add driver for SGI IOC3 chip
Message-ID: <20190809122254.GN3600@piout.net>
References: <20190613170636.6647-1-tbogendoerfer@suse.de>
 <20190613170636.6647-6-tbogendoerfer@suse.de>
 <20190725114716.GB23883@dell>
 <20190729204557.468db2153efefda96dd41ec0@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190729204557.468db2153efefda96dd41ec0@suse.de>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 29/07/2019 20:45:57+0200, Thomas Bogendoerfer wrote:
> On Thu, 25 Jul 2019 12:47:16 +0100
> Lee Jones <lee.jones@linaro.org> wrote:
> 
> > On Thu, 13 Jun 2019, Thomas Bogendoerfer wrote:
> > > +/*
> > > + * On IP30 the RTC (a DS1687) is behind the IOC3 on the generic
> > > + * ByteBus regions. We have to write the RTC address of interest to
> > > + * IOC3_BYTEBUS_DEV1, then read the data from IOC3_BYTEBUS_DEV2.
> > > + * rtc->regs already points to IOC3_BYTEBUS_DEV1.
> > > + */
> > > +#define IP30_RTC_ADDR(rtc) (rtc->regs)
> > > +#define IP30_RTC_DATA(rtc) ((rtc->regs) + IOC3_BYTEBUS_DEV2 - IOC3_BYTEBUS_DEV1)
> > > +
> > > +static u8 ip30_rtc_read(struct ds1685_priv *rtc, int reg)
> > > +{
> > > +	writeb((reg & 0x7f), IP30_RTC_ADDR(rtc));
> > > +	return readb(IP30_RTC_DATA(rtc));
> > > +}
> > > +
> > > +static void ip30_rtc_write(struct ds1685_priv *rtc, int reg, u8 value)
> > > +{
> > > +	writeb((reg & 0x7f), IP30_RTC_ADDR(rtc));
> > > +	writeb(value, IP30_RTC_DATA(rtc));
> > > +}
> > 
> > Why is this not in the RTC driver?
> 
> because rtc1685 is used in different systems and accessing the chip
> differs between those systems. 
> 
> > > +static struct ds1685_rtc_platform_data ip30_rtc_platform_data = {
> > > +	.bcd_mode = false,
> > > +	.no_irq = false,
> > > +	.uie_unsupported = true,
> > > +	.alloc_io_resources = true,
> > 
> > > +	.plat_read = ip30_rtc_read,
> > > +	.plat_write = ip30_rtc_write,
> > 
> > Call-backs in a non-subsystem API is pretty ugly IMHO.
> 
> I agree
> 
> > Where are these called from?
> 
> drivers/rtc/rtc-ds1685.c
> 
> I could do the same as done for serial8250 and add an additional .c file
> in  drivers/rtc which handles this for SGI-IP30. Alexandre would this work
> for you as well ?
> 

As it is not particularly big, you could put that directly in
rtc-ds1685.c.


-- 
Alexandre Belloni, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
