Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD19422D678
	for <lists+netdev@lfdr.de>; Sat, 25 Jul 2020 11:34:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726870AbgGYJey (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jul 2020 05:34:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726583AbgGYJex (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jul 2020 05:34:53 -0400
Received: from mail.nic.cz (lists.nic.cz [IPv6:2001:1488:800:400::400])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F5F9C0619D3;
        Sat, 25 Jul 2020 02:34:53 -0700 (PDT)
Received: from localhost (unknown [IPv6:2a0e:b107:ae1:0:3e97:eff:fe61:c680])
        by mail.nic.cz (Postfix) with ESMTPSA id A0C45140990;
        Sat, 25 Jul 2020 11:34:50 +0200 (CEST)
Date:   Sat, 25 Jul 2020 11:34:50 +0200
From:   Marek Behun <marek.behun@nic.cz>
To:     Pavel Machek <pavel@ucw.cz>
Cc:     netdev@vger.kernel.org, linux-leds@vger.kernel.org,
        jacek.anaszewski@gmail.com, Dan Murphy <dmurphy@ti.com>,
        =?UTF-8?B?T25k?= =?UTF-8?B?xZllag==?= Jirman 
        <megous@megous.com>, Russell King <linux@armlinux.org.uk>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC leds + net-next v3 2/2] net: phy: marvell: add
 support for PHY LEDs via LED class
Message-ID: <20200725113450.0d4c936b@nic.cz>
In-Reply-To: <20200725092339.GB29492@amd>
References: <20200724164603.29148-1-marek.behun@nic.cz>
        <20200724164603.29148-3-marek.behun@nic.cz>
        <20200725092339.GB29492@amd>
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-100.0 required=5.9 tests=SHORTCIRCUIT,
        USER_IN_WHITELIST shortcircuit=ham autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
X-Virus-Scanned: clamav-milter 0.102.2 at mail
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 25 Jul 2020 11:23:39 +0200
Pavel Machek <pavel@ucw.cz> wrote:

> Hi!
> 
> > +static const struct marvell_led_mode_info marvell_led_mode_info[] = {
> > +	{ "link",			{ 0x0,  -1, 0x0,  -1,  -1,  -1, }, 0 },
> > +	{ "link/act",			{ 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, }, 0 },
> > +	{ "1Gbps/100Mbps/10Mbps",	{ 0x2,  -1,  -1,  -1,  -1,  -1, }, 0 },  
> 
> is this "1Gbps-10Mbps"?

Most of these modes mean "ON on event", eg
  "link" means ON when link up, else OFF. "
  "tx" means ON on when transmitting, else OFF
  "act" means ON when activity, else OFF
  "copper" means ON when copper link up, else OFF
but some are blinking modes
  "blink-act" means BLINK when activity, else OFF

Some modes can do ON and BLINK, these have one '/' in their name
  "link/act" means ON when link up, BLINK on activity, else OFF
  "link/rx" means ON when link up, BLINK on receive, else OFF

there is one mode, "1Gbps/100Mbps/10Mbps", which behaves differently:
  blinks 3 times when linked on 1Gbps
  blinks 2 times when linked on 100Mbps
  blinks 1 time when linked on 10Mbps
(and this blinking is repeating, ie blinks 3 times, pause, blinks 3 times,
pause)

Some modes are disjunctive:
  "100Mbps-fiber" means ON when linked on 100Mbps or via fiber, else OFF


> 
> > +	{ "act",			{ 0x3, 0x3, 0x3, 0x3, 0x3, 0x3, }, 0 },
> > +	{ "blink-act",			{ 0x4, 0x4, 0x4, 0x4, 0x4, 0x4, }, 0 },
> > +	{ "tx",				{ 0x5,  -1, 0x5,  -1, 0x5, 0x5, }, 0 },
> > +	{ "tx",				{  -1,  -1,  -1, 0x5,  -1,  -1, }, L3V5_TRANS },
> > +	{ "rx",				{  -1,  -1,  -1,  -1, 0x0, 0x0, }, 0 },
> > +	{ "rx",				{  -1, 0x0,  -1,  -1,  -1,  -1, }, L1V0_RECV },
> > +	{ "copper",			{ 0x6,  -1,  -1,  -1,  -1,  -1, }, 0 },
> > +	{ "copper",			{  -1, 0x0,  -1,  -1,  -1,  -1, }, L1V0_COPPER },
> > +	{ "1Gbps",			{ 0x7,  -1,  -1,  -1,  -1,  -1, }, 0 },
> > +	{ "link/rx",			{  -1, 0x2,  -1, 0x2, 0x2, 0x2, }, 0 },
> > +	{ "100Mbps-fiber",		{  -1, 0x5,  -1,  -1,  -1,  -1, }, L1V5_100_FIBER },
> > +	{ "100Mbps-10Mbps",		{  -1, 0x5,  -1,  -1,  -1,  -1, }, L1V5_100_10 },
> > +	{ "1Gbps-100Mbps",		{  -1, 0x6,  -1,  -1,  -1,  -1, }, 0 },
> > +	{ "1Gbps-10Mbps",		{  -1,  -1, 0x6, 0x6,  -1,  -1, }, 0 },
> > +	{ "100Mbps",			{  -1, 0x7,  -1,  -1,  -1,  -1, }, 0 },
> > +	{ "10Mbps",			{  -1,  -1, 0x7,  -1,  -1,  -1, }, 0 },
> > +	{ "fiber",			{  -1,  -1,  -1, 0x0,  -1,  -1, }, L3V0_FIBER },
> > +	{ "fiber",			{  -1,  -1,  -1, 0x7,  -1,  -1, }, L3V7_FIBER },
> > +	{ "FullDuplex",			{  -1,  -1,  -1, 0x7,  -1,  -1, }, L3V7_DUPLEX },
> > +	{ "FullDuplex",			{  -1,  -1,  -1,  -1, 0x6, 0x6, }, 0 },
> > +	{ "FullDuplex/collision",	{  -1,  -1,  -1,  -1, 0x7, 0x7, }, 0 },
> > +	{ "FullDuplex/collision",	{  -1,  -1, 0x2,  -1,  -1,  -1, }, L2V2_DUPLEX },
> > +	{ "ptp",			{  -1,  -1, 0x2,  -1,  -1,  -1, }, L2V2_PTP },
> > +	{ "init",			{  -1,  -1, 0x2,  -1,  -1,  -1, }, L2V2_INIT },
> > +	{ "los",			{  -1,  -1,  -1, 0x0,  -1,  -1, }, L3V0_LOS },
> > +	{ "hi-z",			{ 0xa, 0xa, 0xa, 0xa, 0xa, 0xa, }, 0 },
> > +	{ "blink",			{ 0xb, 0xb, 0xb, 0xb, 0xb, 0xb, }, 0 },
> > +};  
> 
> Certainly more documentation will be required here, what "ptp" setting
> does, for example, is not very obvious to me.

"ptp" means it will light up when the PTP functionality is enabled on
the PHY and a PTP packet is received.

> Best regards,
> 									Pavel

