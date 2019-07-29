Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A9B879358
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 20:46:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387748AbfG2SqA convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 29 Jul 2019 14:46:00 -0400
Received: from mx2.suse.de ([195.135.220.15]:54436 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387512AbfG2SqA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jul 2019 14:46:00 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 2C7F0AE62;
        Mon, 29 Jul 2019 18:45:58 +0000 (UTC)
Date:   Mon, 29 Jul 2019 20:45:57 +0200
From:   Thomas Bogendoerfer <tbogendoerfer@suse.de>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     Ralf Baechle <ralf@linux-mips.org>,
        Paul Burton <paul.burton@mips.com>,
        James Hogan <jhogan@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.com>, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        netdev@vger.kernel.org, linux-rtc@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH v3 5/7] mfd: ioc3: Add driver for SGI IOC3 chip
Message-Id: <20190729204557.468db2153efefda96dd41ec0@suse.de>
In-Reply-To: <20190725114716.GB23883@dell>
References: <20190613170636.6647-1-tbogendoerfer@suse.de>
        <20190613170636.6647-6-tbogendoerfer@suse.de>
        <20190725114716.GB23883@dell>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 25 Jul 2019 12:47:16 +0100
Lee Jones <lee.jones@linaro.org> wrote:

> On Thu, 13 Jun 2019, Thomas Bogendoerfer wrote:
> > +/*
> > + * On IP30 the RTC (a DS1687) is behind the IOC3 on the generic
> > + * ByteBus regions. We have to write the RTC address of interest to
> > + * IOC3_BYTEBUS_DEV1, then read the data from IOC3_BYTEBUS_DEV2.
> > + * rtc->regs already points to IOC3_BYTEBUS_DEV1.
> > + */
> > +#define IP30_RTC_ADDR(rtc) (rtc->regs)
> > +#define IP30_RTC_DATA(rtc) ((rtc->regs) + IOC3_BYTEBUS_DEV2 - IOC3_BYTEBUS_DEV1)
> > +
> > +static u8 ip30_rtc_read(struct ds1685_priv *rtc, int reg)
> > +{
> > +	writeb((reg & 0x7f), IP30_RTC_ADDR(rtc));
> > +	return readb(IP30_RTC_DATA(rtc));
> > +}
> > +
> > +static void ip30_rtc_write(struct ds1685_priv *rtc, int reg, u8 value)
> > +{
> > +	writeb((reg & 0x7f), IP30_RTC_ADDR(rtc));
> > +	writeb(value, IP30_RTC_DATA(rtc));
> > +}
> 
> Why is this not in the RTC driver?

because rtc1685 is used in different systems and accessing the chip
differs between those systems. 

> > +static struct ds1685_rtc_platform_data ip30_rtc_platform_data = {
> > +	.bcd_mode = false,
> > +	.no_irq = false,
> > +	.uie_unsupported = true,
> > +	.alloc_io_resources = true,
> 
> > +	.plat_read = ip30_rtc_read,
> > +	.plat_write = ip30_rtc_write,
> 
> Call-backs in a non-subsystem API is pretty ugly IMHO.

I agree

> Where are these called from?

drivers/rtc/rtc-ds1685.c

I could do the same as done for serial8250 and add an additional .c file
in  drivers/rtc which handles this for SGI-IP30. Alexandre would this work
for you as well ?

> > +#define IOC3_SID(_name, _sid, _setup) \
> > +	{								   \
> > +		.name = _name,						   \
> > +		.sid = (PCI_VENDOR_ID_SGI << 16) | IOC3_SUBSYS_ ## _sid,   \
> > +		.setup = _setup,					   \
> > +	}
> > +
> > +static struct {
> > +	const char *name;
> > +	u32 sid;
> > +	int (*setup)(struct ioc3_priv_data *ipd);
> > +} ioc3_infos[] = {
> 
> IMHO it's neater if you separate the definition and static data part.

I don't quite understand what you mean here. Should I move the #define at
the beginning of the file ? Why is it neater ?

Thomas.

-- 
SUSE Linux GmbH
GF: Felix Imendörffer, Mary Higgins, Sri Rasiah
HRB 21284 (AG Nürnberg)
