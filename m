Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2C2A2568F2
	for <lists+netdev@lfdr.de>; Sat, 29 Aug 2020 18:01:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728467AbgH2QBO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Aug 2020 12:01:14 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:59924 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728428AbgH2QAt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 29 Aug 2020 12:00:49 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kC3Hb-00CQf0-IW; Sat, 29 Aug 2020 18:00:47 +0200
Date:   Sat, 29 Aug 2020 18:00:47 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Adam =?utf-8?Q?Rudzi=C5=84ski?= <adam.rudzinski@arf.net.pl>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        netdev <netdev@vger.kernel.org>, robh+dt@kernel.org,
        frowand.list@gmail.com
Subject: Re: drivers/of/of_mdio.c needs a small modification
Message-ID: <20200829160047.GD2912863@lunn.ch>
References: <c8b74845-b9e1-6d85-3947-56333b73d756@arf.net.pl>
 <20200828222846.GA2403519@lunn.ch>
 <dcfea76d-5340-76cf-7ad0-313af334a2fd@arf.net.pl>
 <20200828225353.GB2403519@lunn.ch>
 <6eb8c287-2d9f-2497-3581-e05a5553b88f@arf.net.pl>
 <891d7e82-f22a-d24b-df5b-44b34dc419b5@gmail.com>
 <113503c8-a871-1dc0-daea-48631e1a436d@arf.net.pl>
 <20200829151553.GB2912863@lunn.ch>
 <76f88763-54b0-eb03-3bc8-3e5022173163@arf.net.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <76f88763-54b0-eb03-3bc8-3e5022173163@arf.net.pl>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> This is true assuming that the PHYs are always and forever connected to one
> specific MDIO bus. This is probably reasonable. Although, in i.MX the MDIO
> bus of FEC1 and FEC2 shares the pins.

In general, they do not. In fact, i don't see how that can work. The
FEC drive provides no mutual exclusion between MDIO operations on
different MDIO controllers. So one controller could be performing a
read while the other a write. If they are sharing the same pins, how
do you drive the clock pin both high and low at the same time? How do
you have the data pin both high impedance so the PHY can drive it, and
also drive out a 0 or a 1 to perform a right?

What is suspect you can do is use pinmux to connect the pins to either
ethernet1 MDIO controller, or ethernet2 mdio controller. But never
both. You have to decide which gets to control the bus, and the other
controller is isolated.

> I'm sure of that - LAN8720A needs to have the clock from FEC or external
> generator to be able to talk over MDIO.

O.K. Then you need to core to enable the clock before scanning the
bus.

	Andrew
