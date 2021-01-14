Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2C992F6EC7
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 00:06:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730932AbhANXFA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 18:05:00 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:41666 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726512AbhANXFA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Jan 2021 18:05:00 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1l0Bf5-000eOz-KK; Fri, 15 Jan 2021 00:04:15 +0100
Date:   Fri, 15 Jan 2021 00:04:15 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     "ashiduka@fujitsu.com" <ashiduka@fujitsu.com>
Cc:     "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "torii.ken1@fujitsu.com" <torii.ken1@fujitsu.com>
Subject: Re: [PATCH v2] net: phy: realtek: Add support for RTL9000AA/AN
Message-ID: <YADN77NvrpnZYUVo@lunn.ch>
References: <20210110085221.5881-1-ashiduka@fujitsu.com>
 <X/sptqSqUS7T5XWR@lunn.ch>
 <OSAPR01MB38441EE1695CCAD1FE3476DEDFA80@OSAPR01MB3844.jpnprd01.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OSAPR01MB38441EE1695CCAD1FE3476DEDFA80@OSAPR01MB3844.jpnprd01.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 14, 2021 at 08:38:12AM +0000, ashiduka@fujitsu.com wrote:
> Hi Andrew
> 
> > For T1, it seems like Master is pretty important. Do you have
> > information to be able to return the current Master/slave
> > configuration, or allow it to be configured? See the nxp-tja11xx.c for
> > an example.
> 
> Do you know how to switch between master/slave?

There was a patch to ethtool merged for this:

commit 558f7cc33daf82f945af432c79db40edcbe0dad0
Author: Oleksij Rempel <o.rempel@pengutronix.de>
Date:   Wed Jun 10 10:37:43 2020 +0200

    netlink: add master/slave configuration support
    
    This UAPI is needed for BroadR-Reach 100BASE-T1 devices. Due to lack of
    auto-negotiation support, we needed to be able to configure the
    MASTER-SLAVE role of the port manually or from an application in user
    space.
    
    The same UAPI can be used for 1000BASE-T or MultiGBASE-T devices to
    force MASTER or SLAVE role. See IEEE 802.3-2018:
    22.2.4.3.7 MASTER-SLAVE control register (Register 9)
    22.2.4.3.8 MASTER-SLAVE status register (Register 10)
    40.5.2 MASTER-SLAVE configuration resolution
    45.2.1.185.1 MASTER-SLAVE config value (1.2100.14)
    45.2.7.10 MultiGBASE-T AN control 1 register (Register 7.32)
    
    The MASTER-SLAVE role affects the clock configuration:
    
    -------------------------------------------------------------------------------
    When the  PHY is configured as MASTER, the PMA Transmit function shall
    source TX_TCLK from a local clock source. When configured as SLAVE, the
    PMA Transmit function shall source TX_TCLK from the clock recovered from
    data stream provided by MASTER.
    
    iMX6Q                     KSZ9031                XXX
    ------\                /-----------\        /------------\
          |                |           |        |            |
     MAC  |<----RGMII----->| PHY Slave |<------>| PHY Master |
          |<--- 125 MHz ---+-<------/  |        | \          |
    ------/                \-----------/        \------------/
                                                   ^
                                                    \-TX_TCLK
    
    -------------------------------------------------------------------------------

    Andrew
