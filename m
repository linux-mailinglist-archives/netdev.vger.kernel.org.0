Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B0DD222B54
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 20:57:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729452AbgGPS5D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 14:57:03 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:39326 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728163AbgGPS5D (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jul 2020 14:57:03 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jw93n-005UW2-Ba; Thu, 16 Jul 2020 20:56:47 +0200
Date:   Thu, 16 Jul 2020 20:56:47 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <marek.behun@nic.cz>
Cc:     linux-leds@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
        jacek.anaszewski@gmail.com, Dan Murphy <dmurphy@ti.com>,
        =?utf-8?Q?Ond=C5=99ej?= Jirman <megous@megous.com>,
        netdev@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Gregory Clement <gregory.clement@bootlin.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC leds + net-next 0/3] Add support for LEDs on Marvell
 PHYs
Message-ID: <20200716185647.GA1308244@lunn.ch>
References: <20200716171730.13227-1-marek.behun@nic.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200716171730.13227-1-marek.behun@nic.cz>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 16, 2020 at 07:17:27PM +0200, Marek Behún wrote:
> Hello,
> 
> this RFC series should apply on both net-next/master and Pavel's
> linux-leds/for-master tree.
> 
> This adds support for LED's connected to some Marvell PHYs.
> 
> LEDs are specified via device-tree. Example:

Hi Marek

I've been playing with something similar, off and on, mostly off.

Take a look at

https://github.com/lunn/linux v5.4-rc6-hw-led-triggers

The binding i have is pretty much the same, since we are both
following the common LED binding. I see no problems with this.

> This is achieved by extending the LED trigger API with LED-private triggers.
> The proposal for this is based on work by Ondrej and Pavel.

So what i did here was allow triggers to be registered against a
specific LED. The /sys/class/leds/<LED>/trigger lists both the generic
triggers and the triggers for this specific LED. Phylib can then
register a trigger for each blink reason that specific LED can
perform. Which does result in a lot of triggers. Especially when you
start talking about a 10 port switch each with 2 LEDs.

I still have some open issues...

1) Polarity. It would be nice to be able to configure the polarity of
the LED in the bindings.

2) PHY LEDs which are not actually part of the PHY. Most of the
Marvell Ethernet switches have inbuilt PHYs, which are driven by the
Marvell PHY driver. The Marvell PHY driver has no idea the PHY is
inside a switch, it is just a PHY.  However, the LEDs are not
controlled via PHY registers, but Switch registers. So the switch
driver is going to end up controlling these LEDs. It would be good to
be able to share as much code as possible, keep the naming consistent,
and keep the user API the same.

3) Some PHYs cannot control the LEDs independently. Or they have modes
which configure two or more LEDs. The Marvell PHYs are like
this. There are something like ~10 blink modes which are
independent. And then there are 4 modes which control multiple LEDs.
There is no simple way to support this with Linux LEDs which assume
the LEDs are fully independent. I suspect we simply cannot support
these combined modes.

As a PHY maintainer, i would like to see a solution which makes use of
Linux LEDs. I don't really care who's code it is, and feel free to
borrow my code, or ideas, or ignore it.

      Andrew
