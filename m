Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCB1C22D84C
	for <lists+netdev@lfdr.de>; Sat, 25 Jul 2020 17:04:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727768AbgGYPEG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jul 2020 11:04:06 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:55192 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726567AbgGYPEF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 Jul 2020 11:04:05 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jzLiA-006oxX-TN; Sat, 25 Jul 2020 17:03:42 +0200
Date:   Sat, 25 Jul 2020 17:03:42 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek Behun <marek.behun@nic.cz>
Cc:     Pavel Machek <pavel@ucw.cz>, netdev@vger.kernel.org,
        linux-leds@vger.kernel.org, jacek.anaszewski@gmail.com,
        Dan Murphy <dmurphy@ti.com>,
        =?utf-8?Q?Ond=C5=99ej?= Jirman <megous@megous.com>,
        Russell King <linux@armlinux.org.uk>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Gregory Clement <gregory.clement@bootlin.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC leds + net-next v3 2/2] net: phy: marvell: add
 support for PHY LEDs via LED class
Message-ID: <20200725150342.GG1472201@lunn.ch>
References: <20200724164603.29148-1-marek.behun@nic.cz>
 <20200724164603.29148-3-marek.behun@nic.cz>
 <20200725092339.GB29492@amd>
 <20200725113450.0d4c936b@nic.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200725113450.0d4c936b@nic.cz>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 25, 2020 at 11:34:50AM +0200, Marek Behun wrote:
> On Sat, 25 Jul 2020 11:23:39 +0200
> Pavel Machek <pavel@ucw.cz> wrote:
> 
> > Hi!
> > 
> > > +static const struct marvell_led_mode_info marvell_led_mode_info[] = {
> > > +	{ "link",			{ 0x0,  -1, 0x0,  -1,  -1,  -1, }, 0 },
> > > +	{ "link/act",			{ 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, }, 0 },
> > > +	{ "1Gbps/100Mbps/10Mbps",	{ 0x2,  -1,  -1,  -1,  -1,  -1, }, 0 },  
> > 
> > is this "1Gbps-10Mbps"?
> 
> Most of these modes mean "ON on event", eg
>   "link" means ON when link up, else OFF. "
>   "tx" means ON on when transmitting, else OFF
>   "act" means ON when activity, else OFF
>   "copper" means ON when copper link up, else OFF
> but some are blinking modes
>   "blink-act" means BLINK when activity, else OFF
> 
> Some modes can do ON and BLINK, these have one '/' in their name
>   "link/act" means ON when link up, BLINK on activity, else OFF
>   "link/rx" means ON when link up, BLINK on receive, else OFF
> 
> there is one mode, "1Gbps/100Mbps/10Mbps", which behaves differently:
>   blinks 3 times when linked on 1Gbps
>   blinks 2 times when linked on 100Mbps
>   blinks 1 time when linked on 10Mbps
> (and this blinking is repeating, ie blinks 3 times, pause, blinks 3 times,
> pause)
> 
> Some modes are disjunctive:
>   "100Mbps-fiber" means ON when linked on 100Mbps or via fiber, else OFF

Hi Marek

I would be good to added this to the sysfs documentation.

> > > +	{ "act",			{ 0x3, 0x3, 0x3, 0x3, 0x3, 0x3, }, 0 },
> > > +	{ "blink-act",			{ 0x4, 0x4, 0x4, 0x4, 0x4, 0x4, }, 0 },
> > > +	{ "tx",				{ 0x5,  -1, 0x5,  -1, 0x5, 0x5, }, 0 },
> > > +	{ "tx",				{  -1,  -1,  -1, 0x5,  -1,  -1, }, L3V5_TRANS },
> > > +	{ "rx",				{  -1,  -1,  -1,  -1, 0x0, 0x0, }, 0 },
> > > +	{ "rx",				{  -1, 0x0,  -1,  -1,  -1,  -1, }, L1V0_RECV },

To be consistent these four probably should have the blink- prefix. Or
it could be /tx, /rx ?

> > > +	{ "copper",			{ 0x6,  -1,  -1,  -1,  -1,  -1, }, 0 },
> > > +	{ "copper",			{  -1, 0x0,  -1,  -1,  -1,  -1, }, L1V0_COPPER },
> > > +	{ "1Gbps",			{ 0x7,  -1,  -1,  -1,  -1,  -1, }, 0 },
> > > +	{ "link/rx",			{  -1, 0x2,  -1, 0x2, 0x2, 0x2, }, 0 },
> > > +	{ "100Mbps-fiber",		{  -1, 0x5,  -1,  -1,  -1,  -1, }, L1V5_100_FIBER },
> > > +	{ "100Mbps-10Mbps",		{  -1, 0x5,  -1,  -1,  -1,  -1, }, L1V5_100_10 },
> > > +	{ "1Gbps-100Mbps",		{  -1, 0x6,  -1,  -1,  -1,  -1, }, 0 },
> > > +	{ "1Gbps-10Mbps",		{  -1,  -1, 0x6, 0x6,  -1,  -1, }, 0 },
> > > +	{ "100Mbps",			{  -1, 0x7,  -1,  -1,  -1,  -1, }, 0 },
> > > +	{ "10Mbps",			{  -1,  -1, 0x7,  -1,  -1,  -1, }, 0 },
> > > +	{ "fiber",			{  -1,  -1,  -1, 0x0,  -1,  -1, }, L3V0_FIBER },
> > > +	{ "fiber",			{  -1,  -1,  -1, 0x7,  -1,  -1, }, L3V7_FIBER },
> > > +	{ "FullDuplex",			{  -1,  -1,  -1, 0x7,  -1,  -1, }, L3V7_DUPLEX },
> > > +	{ "FullDuplex",			{  -1,  -1,  -1,  -1, 0x6, 0x6, }, 0 },
> > > +	{ "FullDuplex/collision",	{  -1,  -1,  -1,  -1, 0x7, 0x7, }, 0 },
> > > +	{ "FullDuplex/collision",	{  -1,  -1, 0x2,  -1,  -1,  -1, }, L2V2_DUPLEX },
> > > +	{ "ptp",			{  -1,  -1, 0x2,  -1,  -1,  -1, }, L2V2_PTP },
> > > +	{ "init",			{  -1,  -1, 0x2,  -1,  -1,  -1, }, L2V2_INIT },
> > > +	{ "los",			{  -1,  -1,  -1, 0x0,  -1,  -1, }, L3V0_LOS },
> > > +	{ "hi-z",			{ 0xa, 0xa, 0xa, 0xa, 0xa, 0xa, }, 0 },
> > > +	{ "blink",			{ 0xb, 0xb, 0xb, 0xb, 0xb, 0xb, }, 0 },
> > > +};  
> > 
> > Certainly more documentation will be required here, what "ptp" setting
> > does, for example, is not very obvious to me.
> 
> "ptp" means it will light up when the PTP functionality is enabled on
> the PHY and a PTP packet is received.

Does hi-z mean off? In the implementation i did, i did not list off
and on as triggers. I instead used them for untriggered
brightness. That allowed the software triggers to work, so i had the
PHY blinking the heartbeat etc. But i had to make it optional, since a
quick survey of datasheets suggested not all PHYs support simple
on/off control.

Something beyond the scope of this patchset is implementing etHool -p

       -p --identify
              Initiates adapter-specific action intended to enable an operator to
	      easily identify the adapter by sight. Typically this involves  blink‐
              ing one or more LEDs on the specific network port.

If we have software controlled on/off, then a software trigger seems
like i good way to do this.

     Andrew
