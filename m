Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E286D34B191
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 22:55:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230196AbhCZVyd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 17:54:33 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50340 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230043AbhCZVyU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Mar 2021 17:54:20 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lPuPB-00DDfV-Eg; Fri, 26 Mar 2021 22:54:09 +0100
Date:   Fri, 26 Mar 2021 22:54:09 +0100
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
Message-ID: <YF5YAQvQXCn4QapJ@lunn.ch>
References: <20210315103950.65fedf2c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <001201d719c6$6ac826c0$40587440$@thebollingers.org>
 <YFJHN+raumcJ5/7M@lunn.ch>
 <009601d72023$b73dbde0$25b939a0$@thebollingers.org>
 <YFpr2RyiwX10SNbD@lunn.ch>
 <011301d7226f$dc2426f0$946c74d0$@thebollingers.org>
 <YF46FI4epRGwlyP8@lunn.ch>
 <011901d7227c$e00015b0$a0004110$@thebollingers.org>
 <YF5GA1RbaM1Ht3nl@lunn.ch>
 <011c01d72284$544c8f50$fce5adf0$@thebollingers.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <011c01d72284$544c8f50$fce5adf0$@thebollingers.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> The only thing wrong I can see is that it doesn't use the kernel network
> stack.  Here's where "you keep missing the point".  The kernel network stack
> is not being used in these systems.  Implementing EEPROM access through
> ethtool is of course possible, but it is a lot of work with no benefit on
> these systems.  The simple approach works.  Let me use it.
> 
> > 
> > The optoe KAPI needs to handle these 'interesting' SFP modules. The KAPI
> > design needs to be flexible enough that the driver underneath it can be
> > extended to support these SFPs. The code does not need to be there, but
> > the KAPI design needs to allow it. And i personally cannot see how the
> optoe
> > KAPI can efficiently support these SFPs.
> 
> Help me understand.  Your KAPI specifies ethtool as the KAPI, and the
> ethtool/netlink stack as the interface through which the data flows.

Nearly. It specifies netlink and the netlink messages definitions.
They happen to be in the ethtool group, but there is no requirement to
use ethtool(1).

But there is a bit more to it.

Either the MAC driver implements the needed code, or it defers to the
generic sfp.c code. In both cases, you have access to the GPIO
lines.

If you are using the generic sfp.c, the Device Tree definitions of the
GPIOs become part of the KAPI. DT is consider ABI.

So the low level code knows when there was been a hotplug. It then can
determine what quirks to apply for all future reads until the module
is unplugged.

Your KAPI is missing how optoe gets access to the GPIOs. Without
knowing if the module has been hotplugged, in a robust manor, you have
problems with quirks. For every userspace read, you need to assume the
module has been changed, read the ID information from the EEPROM a
byte at a time, figure out what quirks to apply, and then do the user
requested read. I doubt that is good for performance. The design which
has been chosen is that userspace is monitoring the GPIO lines. So to
make it efficient, your KAPI need some way to pass down that the
module has/has not been hot-plugged since the last read.

Or do you see some other way to implement these quirks?

       Andrew
