Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44A613248E5
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 03:34:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234044AbhBYCeW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 21:34:22 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:56948 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229722AbhBYCeV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Feb 2021 21:34:21 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lF6TC-008L2f-F5; Thu, 25 Feb 2021 03:33:38 +0100
Date:   Thu, 25 Feb 2021 03:33:38 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>
Cc:     netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH V1 net-next 0/3] net: stmmac: implement clocks
Message-ID: <YDcMgr2rvcFvs746@lunn.ch>
References: <20210223104818.1933-1-qiangqing.zhang@nxp.com>
 <20210223084503.34ae93f7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <DB8PR04MB6795925488C63791C2BD588EE69F9@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <20210223175441.2a1b86f1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YDZOMpUYZrijdFli@lunn.ch>
 <DB8PR04MB6795FAE4C1736AABDCA75FA7E69E9@DB8PR04MB6795.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DB8PR04MB6795FAE4C1736AABDCA75FA7E69E9@DB8PR04MB6795.eurprd04.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Hi Andrew,
> 

> I don't have experience with Ethernet switch, according to your
> points, you mean we can connect STMMAC to an Ethernet switch, and
> then Ethernet switch managed STMMAC by the MDIO bus but without
> checking whether STMMAC interface is opened or not, so STMMAC needs
> clocks for MDIO even interface is closed, right?

Correct. The MDIO bus has a different life cycle to the MAC. If any of
stmmac_xgmac2_mdio_read(), stmmac_xgmac2_mdio_write(),
stmmac_mdio_read(), and stmmac_mdio_write() need clocks ticking, you
need to ensure the clock is ticking, because these functions can be
called while the interface is not opened.

> > You said you copied the FEC driver. Take a look at that, it was initially broken in
> > this way, and i needed to extend it when i got a board with an Ethernet switch
> > attached to the FEC.
> 

> Could you point me how to implement clocks management to cover above
> Ethernet switch case? Or can we upstream this first and then fix it
> later for such case?

I actually got is wrong on the first attempt. So you need to look at:

42ea4457ae net: fec: normalize return value of pm_runtime_get_sync() in MDIO write
14d2b7c1a9 net: fec: fix initial runtime PM refcount
8fff755e9f net: fec: Ensure clocks are enabled while using mdio bus

And no, you cannot fix it later, because your patches potentially
break existing systems using an Ethernet switch. See:

ommit da29f2d84bd10234df570b7f07cbd0166e738230
Author: Jose Abreu <Jose.Abreu@synopsys.com>
Date:   Tue Jan 7 13:35:42 2020 +0100

    net: stmmac: Fixed link does not need MDIO Bus
    
    When using fixed link we don't need the MDIO bus support.

...
    Tested-by: Florian Fainelli <f.fainelli@gmail> # Lamobo R1 (fixed-link + MDIO sub node for roboswitch).

So there are boards which make use of a switch and MDIO. Florian might
however be able to run tests for you, if you ask him.

   Andrew
