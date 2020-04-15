Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FC9F1AA19C
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 14:46:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S370129AbgDOMnt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 08:43:49 -0400
Received: from mx2.suse.de ([195.135.220.15]:58698 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S370090AbgDOMnr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Apr 2020 08:43:47 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id ED032AC11;
        Wed, 15 Apr 2020 12:43:43 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id B1379E16A6; Wed, 15 Apr 2020 14:43:43 +0200 (CEST)
Date:   Wed, 15 Apr 2020 14:43:43 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        David Jander <david@protonic.nl>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
        mkl@pengutronix.de, Marek Vasut <marex@denx.de>
Subject: Re: [PATCH v1] ethtool: provide UAPI for PHY master/slave
 configuration.
Message-ID: <20200415124343.GZ3141@unicorn.suse.cz>
References: <20200415121209.12197-1-o.rempel@pengutronix.de>
 <20200415121940.2du33zckvayfqjrb@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200415121940.2du33zckvayfqjrb@pengutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 15, 2020 at 02:19:40PM +0200, Oleksij Rempel wrote:
> Cc: Marek Vasut <marex@denx.de>
> 
> On Wed, Apr 15, 2020 at 02:12:09PM +0200, Oleksij Rempel wrote:
> > This UAPI is needed for BroadR-Reach 100BASE-T1 devices. Due to lack of
> > auto-negotiation support, we needed to be able to configure the
> > MASTER-SLAVE role of the port manually or from an application in user
> > space.
> > 
> > The same UAPI can be used for 1000BASE-T or MultiGBASE-T devices to
> > force MASTER or SLAVE role. See IEEE 802.3-2018:
> > 22.2.4.3.7 MASTER-SLAVE control register (Register 9)
> > 22.2.4.3.8 MASTER-SLAVE status register (Register 10)
> > 40.5.2 MASTER-SLAVE configuration resolution
> > 45.2.1.185.1 MASTER-SLAVE config value (1.2100.14)
> > 45.2.7.10 MultiGBASE-T AN control 1 register (Register 7.32)
> > 
> > The MASTER-SLAVE role affects the clock configuration:
> > 
> > -------------------------------------------------------------------------------
> > When the  PHY is configured as MASTER, the PMA Transmit function shall
> > source TX_TCLK from a local clock source. When configured as SLAVE, the
> > PMA Transmit function shall source TX_TCLK from the clock recovered from
> > data stream provided by MASTER.
> > 
> > iMX6Q                     KSZ9031                XXX
> > ------\                /-----------\        /------------\
> >       |                |           |        |            |
> >  MAC  |<----RGMII----->| PHY Slave |<------>| PHY Master |
> >       |<--- 125 MHz ---+-<------/  |        | \          |
> > ------/                \-----------/        \------------/
> >                                                ^
> >                                                 \-TX_TCLK
> > 
> > -------------------------------------------------------------------------------
> > 
> > Since some clock or link related issues are only reproducible in a
> > specific MASTER-SLAVE-role, MAC and PHY configuration, it is beneficial
> > to provide generic (not 100BASE-T1 specific) interface to the user space
> > for configuration flexibility and trouble shooting.
> > 
> > Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> > ---
[...]
> > +/* Port mode */
> > +#define PORT_MODE_MASTER	0x00
> > +#define PORT_MODE_SLAVE		0x01
> > +#define PORT_MODE_MASTER_FORCE	0x02
> > +#define PORT_MODE_SLAVE_FORCE	0x03
> > +#define PORT_MODE_UNKNOWN	0xff

Shouldn't 0 rather be something like PORT_MODE_UNSUPPORTED or
PORT_MODE_NONE? If I see correctly, all drivers not setting the new
field (which would be all drivers right now and almost all later) will
leave the value at 0 which would be interpreted as PORT_MODE_MASTER.

Michal
