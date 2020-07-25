Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3109F22D67B
	for <lists+netdev@lfdr.de>; Sat, 25 Jul 2020 11:37:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726651AbgGYJhD convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 25 Jul 2020 05:37:03 -0400
Received: from lists.nic.cz ([217.31.204.67]:52132 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726434AbgGYJhD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 Jul 2020 05:37:03 -0400
Received: from localhost (unknown [IPv6:2a0e:b107:ae1:0:3e97:eff:fe61:c680])
        by mail.nic.cz (Postfix) with ESMTPSA id 0DC9314095F;
        Sat, 25 Jul 2020 11:37:01 +0200 (CEST)
Date:   Sat, 25 Jul 2020 11:37:00 +0200
From:   Marek Behun <marek.behun@nic.cz>
To:     Pavel Machek <pavel@ucw.cz>
Cc:     netdev@vger.kernel.org, linux-leds@vger.kernel.org,
        jacek.anaszewski@gmail.com, Dan Murphy <dmurphy@ti.com>,
        =?UTF-8?B?T25k?= =?UTF-8?B?xZllag==?= Jirman 
        <megous@megous.com>, Russell King <linux@armlinux.org.uk>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC leds + net-next v3 1/2] net: phy: add API for LEDs
 controlled by PHY HW
Message-ID: <20200725113700.7472dcd3@nic.cz>
In-Reply-To: <20200725092124.GA29492@amd>
References: <20200724164603.29148-1-marek.behun@nic.cz>
        <20200724164603.29148-2-marek.behun@nic.cz>
        <20200725092124.GA29492@amd>
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-100.0 required=5.9 tests=SHORTCIRCUIT,URIBL_BLOCKED,
        USER_IN_WHITELIST shortcircuit=ham autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
X-Virus-Scanned: clamav-milter 0.102.2 at mail
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 25 Jul 2020 11:21:24 +0200
Pavel Machek <pavel@ucw.cz> wrote:

> Hi!
> 
> > Many PHYs support various HW control modes for LEDs connected directly
> > to them.
> > 
> > This code adds a new private LED trigger called phydev-hw-mode. When
> > this trigger is enabled for a LED, the various HW control modes which
> > the PHY supports for given LED can be get/set via hw_mode sysfs file.
> > 
> > A PHY driver wishing to utilize this API needs to register the LEDs on
> > its own and set the .trigger_type member of LED classdev to
> > &phy_hw_led_trig_type. It also needs to implement the methods
> > .led_iter_hw_mode, .led_set_hw_mode and .led_get_hw_mode in struct
> > phydev.
> > 
> > Signed-off-by: Marek Behún <marek.behun@nic.cz>  
> 
> Nothing too wrong.
> 
> New sysfs file will require documentation.
> 
> Plus I wonder: should we have single hw_mode file? It seems many
> different "bits" fit inside. Would it be possible to split it further,
> and have bits saying:
> 
> "I want the LED to be on if link is 10Mbps".
> "I want the LED to be on if link is 100Mbps".
> "I want the LED to be on if link is 1000Mbps".
> "I want the LED to blink on tx".
> "I want the LED to blink on rx".
> 
> ?

I don't think this is possible. Only specific combinations are possible
on Marvell PHYs. There is no HW control mode which would do, for
example:
  - ON when linked to 100Mbps
  - BLINK when receive

PHYs from other vendors can different mode sets.

Marek

> +       { "1Gbps/100Mbps/10Mbps",       { 0x2,  -1,  -1,  -1,  -1,
> +       { "1Gbps",                      { 0x7,  -1,  -1,  -1,  -1,
> +       { "100Mbps-fiber",              {  -1, 0x5,  -1,  -1,  -1,
> +       { "100Mbps-10Mbps",             {  -1, 0x5,  -1,  -1,  -1,
> +       { "1Gbps-100Mbps",              {  -1, 0x6,  -1,  -1,  -1,
> +       { "1Gbps-10Mbps",               {  -1,  -1, 0x6, 0x6,  -1,
> +       { "100Mbps",                    {  -1, 0x7,  -1,  -1,  -1,
> +       { "10Mbps",                     {  -1,  -1, 0x7,  -1,  -1,
> 
> Best regards,
> 									Pavel
> 

