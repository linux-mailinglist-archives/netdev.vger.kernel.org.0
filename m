Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6E7A34A838
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 14:37:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229935AbhCZNhK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 09:37:10 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:49284 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229930AbhCZNgi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Mar 2021 09:36:38 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lPmdg-00D8WM-HD; Fri, 26 Mar 2021 14:36:36 +0100
Date:   Fri, 26 Mar 2021 14:36:36 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: FEC unbind/bind feature
Message-ID: <YF3jZNRvqXm2aLVX@lunn.ch>
References: <DB8PR04MB6795E5896375A9A9FED55A84E6629@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <YFyF0dEgjN562aT8@lunn.ch>
 <DB8PR04MB679514359C626505E956981BE6619@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <DB8PR04MB67952CC10ADC4A656963D871E6619@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <YF3UvaMpaXcFxU5y@lunn.ch>
 <DB8PR04MB67951448528CEA7DF6661611E6619@DB8PR04MB6795.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <DB8PR04MB67951448528CEA7DF6661611E6619@DB8PR04MB6795.eurprd04.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 26, 2021 at 01:18:52PM +0000, Joakim Zhang wrote:
> 
> > -----Original Message-----
> > From: Andrew Lunn <andrew@lunn.ch>
> > Sent: 2021年3月26日 20:34
> > To: Joakim Zhang <qiangqing.zhang@nxp.com>
> > Cc: Florian Fainelli <f.fainelli@gmail.com>; hkallweit1@gmail.com;
> > netdev@vger.kernel.org
> > Subject: Re: FEC unbind/bind feature
> > 
> > > One more add, yes, I am looking the drivers/net/mdio, it is better to
> > implement standalone MDIO driver when writing the MAC driver at the
> > beginning.
> > > Now if I abstract MDIO driver from FEC driver, dt bindings would change, it
> > will break all existing implementations in the kernel based on FEC driver, let
> > them can't work.
> > > How to compatible the legacy dt bindings? I have no idea now. At the same
> > time, I also feel that it seems not necessary to rewrite it.
> > 
> > I have a reasonable understanding of the FEC MDIO driver. I have broken it a
> > few times :-)
> > 
> > It is going to be hard to make it an independent driver, because it needs access
> > to the interrupt flags and the clocks for power saving. From a hardware
> > perspective, it is not an independent hardware block, it is integrated into the
> > MAC.
> > 
> > XDP probably is your easier path.
> 
> Thanks Andrew for your share, you mean use XDP instead DPDK, right?

Yes. We have much more control over XDP since it is in kernel, and
uses kernel drivers. No need to unbind the FEC, since the FEC is the
driver used by XDP. The down side is, the FEC has not been optimised
for XDP, so you will be using the generic support. Its performance
won't be optimal. To get that, you need to add native XDP support to
the FEC driver.

    Andrew
