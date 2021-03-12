Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAE623397DA
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 21:00:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234547AbhCLT75 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 14:59:57 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:54722 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234524AbhCLT7x (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Mar 2021 14:59:53 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lKnwj-00Aa3i-DN; Fri, 12 Mar 2021 20:59:41 +0100
Date:   Fri, 12 Mar 2021 20:59:41 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Don Bollinger <don@thebollingers.org>
Cc:     'Jakub Kicinski' <kuba@kernel.org>, arndb@arndb.de,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        brandon_chuang@edge-core.com, wally_wang@accton.com,
        aken_liu@edge-core.com, gulv@microsoft.com, jolevequ@microsoft.com,
        xinxliu@microsoft.com, 'netdev' <netdev@vger.kernel.org>,
        'Moshe Shemesh' <moshe@nvidia.com>
Subject: Re: [PATCH v2] eeprom/optoe: driver to read/write SFP/QSFP/CMIS
 EEPROMS
Message-ID: <YEvILa9FK8qQs5QK@lunn.ch>
References: <20210215193821.3345-1-don@thebollingers.org>
 <YDl3f8MNWdZWeOBh@lunn.ch>
 <000901d70cb2$b2848420$178d8c60$@thebollingers.org>
 <004f01d70ed5$8bb64480$a322cd80$@thebollingers.org>
 <YD1ScQ+w8+1H//Y+@lunn.ch>
 <003901d711f2$be2f55d0$3a8e0170$@thebollingers.org>
 <20210305145518.57a765bc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <005e01d71230$ad203be0$0760b3a0$@thebollingers.org>
 <YEL3ksdKIW7cVRh5@lunn.ch>
 <018701d71772$7b0ba3f0$7122ebd0$@thebollingers.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <018701d71772$7b0ba3f0$7122ebd0$@thebollingers.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> This interface is implemented in python scripts provided by the switch
> platform
> vendor.  Those scripts encode the mapping of CPLD i2c muxes to i2c buses to
> port numbers, specific to each switch.
> 
> At the bottom of that python stack, all EEPROM access goes through
> open/seek/read/close access to the optoe managed file in 
> /sys/bus/i2c/devices/{num}-0050/eeprom.

And this python stack is all open source? So you should be able to
throw away parts of the bottom end and replace it with a different
KAPI, and nobody will notice? In fact, this is probably how it was
designed. Anybody working with out of tree code knows what gets merged
later is going to be different because of review comments. And KAPI
code is even more likely to be different. So nobody really expected
optoe to get merged as is.

> You're not going to like this, but ethtool -e and ethtool -m both
> return ' Ethernet0 Cannot get EEPROM data: Operation not supported',
> for every port managed by the big switch silicon.

You are still missing what i said. The existing IOCTL interface needs
a network interface name. But there is no reason why you cannot extend
the new netlink KAPI to take an alternative identifier, sfp42. That
maps directly to the SFP device, without using an interface name. Your
pile of python can directly use the netlink API, the ethtool command
does not need to make use of this form of identifier, and you don't
need to "screen scrape" ethtool.

It seems very unlikely optoe is going to get merged. The network
maintainers are against it, due to KAPI issues. I'm trying to point
out a path you can take to get code merged. But it is up to you if you
decided to follow it.

	Andrew
