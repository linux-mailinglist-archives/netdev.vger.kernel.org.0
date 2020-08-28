Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 164B125633A
	for <lists+netdev@lfdr.de>; Sat, 29 Aug 2020 00:54:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726797AbgH1Wx6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Aug 2020 18:53:58 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:59154 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726536AbgH1Wx6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Aug 2020 18:53:58 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kBnFp-00CLKQ-4F; Sat, 29 Aug 2020 00:53:53 +0200
Date:   Sat, 29 Aug 2020 00:53:53 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Adam =?utf-8?Q?Rudzi=C5=84ski?= <adam.rudzinski@arf.net.pl>
Cc:     robh+dt@kernel.org, frowand.list@gmail.com, f.fainelli@gmail.com,
        netdev <netdev@vger.kernel.org>
Subject: Re: drivers/of/of_mdio.c needs a small modification
Message-ID: <20200828225353.GB2403519@lunn.ch>
References: <c8b74845-b9e1-6d85-3947-56333b73d756@arf.net.pl>
 <20200828222846.GA2403519@lunn.ch>
 <dcfea76d-5340-76cf-7ad0-313af334a2fd@arf.net.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <dcfea76d-5340-76cf-7ad0-313af334a2fd@arf.net.pl>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 29, 2020 at 12:34:05AM +0200, Adam Rudziński wrote:
> Hi Andrew.
> 
> W dniu 2020-08-29 o 00:28, Andrew Lunn pisze:
> > Hi Adam
> > 
> > > If kernel has to bring up two Ethernet interfaces, the processor has two
> > > peripherals with functionality of MACs (in i.MX6ULL these are Fast Ethernet
> > > Controllers, FECs), but uses a shared MDIO bus, then the kernel first probes
> > > one MAC, enables clock for its PHY, probes MDIO bus tryng to discover _all_
> > > PHYs, and then probes the second MAC, and enables clock for its PHY. The
> > > result is that the second PHY is still inactive during PHY discovery. Thus,
> > > one Ethernet interface is not functional.
> > What clock are you talking about? Do you have the FEC feeding a 50MHz
> > clock to the PHY? Each FEC providing its own clock to its own PHY? And
> > are you saying a PHY without its reference clock does not respond to
> > MDIO reads and hence the second PHY does not probe because it has no
> > reference clock?
> > 
> > 	  Andrew
> 
> Yes, exactly. In my case the PHYs are LAN8720A, and it works this way.

O.K. Boards i've seen like this have both PHYs driver from the first
MAC. Or the clock goes the other way, the PHY has a crystal and it
feeds the FEC.

I would say the correct way to solve this is to make the FEC a clock
provider. It should register its clocks with the common clock
framework. The MDIO bus can then request the clock from the second FEC
before it scans the bus. Or we add the clock to the PHY node so it
enables the clock before probing it. There are people who want this
sort of framework code, to be able to support a GPIO reset, which
needs releasing before probing the bus for the PHY.

Anyway, post your patch, so we get a better idea what you are
proposing.

	Andrew
