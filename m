Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EDC1278B12
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 16:40:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729040AbgIYOky (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 10:40:54 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:55298 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728612AbgIYOky (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Sep 2020 10:40:54 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kLotu-00GAV3-CH; Fri, 25 Sep 2020 16:40:42 +0200
Date:   Fri, 25 Sep 2020 16:40:42 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Willy Liu <willy.liu@realtek.com>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, fancer.lancer@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ryankao@realtek.com,
        kevans@FreeBSD.org
Subject: Re: [PATCH net] net: phy: realtek: fix rtl8211e rx/tx delay config
Message-ID: <20200925144042.GI3821492@lunn.ch>
References: <1601018715-952-1-git-send-email-willy.liu@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1601018715-952-1-git-send-email-willy.liu@realtek.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 25, 2020 at 03:25:15PM +0800, Willy Liu wrote:
> There are two chip pins named TXDLY and RXDLY which actually adds the 2ns
> delays to TXC and RXC for TXD/RXD latching. These two pins can config via
> 4.7k-ohm resistor to 3.3V hw setting, but also config via software setting
> (extension page 0xa4 register 0x1c bit13 12 and 11).
> 
> The configuration register definitions from table 13 official PHY datasheet:
> PHYAD[2:0] = PHY Address
> AN[1:0] = Auto-Negotiation
> Mode = Interface Mode Select
> RX Delay = RX Delay
> TX Delay = TX Delay
> SELRGV = RGMII/GMII Selection
> 
> This table describes how to config these hw pins via external pull-high or pull-
> low resistor.
> 
> It is a misunderstanding that mapping it as register bits below:
> 8:6 = PHY Address
> 5:4 = Auto-Negotiation
> 3 = Interface Mode Select
> 2 = RX Delay
> 1 = TX Delay
> 0 = SELRGV
> So I removed these descriptions above and add related settings as below:
> 14 = reserved
> 13 = force Tx RX Delay controlled by bit12 bit11
> 12 = Tx Delay
> 11 = Rx Delay
> 10:0 = Test && debug settings reserved by realtek

Hi Willy

Thanks for adding a full description of what the bits do.

Please in future add a version number to the subject line.

[PATCH net v3] .....

So we know which is the latest version.

I think the fix is actually wrong.

        /* enable TX/RX delay for rgmii-* modes, and disable them for rgmii. */
        switch (phydev->interface) {
        case PHY_INTERFACE_MODE_RGMII:
                val = 0;
                break;
        case PHY_INTERFACE_MODE_RGMII_ID:
                val = RTL8211E_TX_DELAY | RTL8211E_RX_DELAY;
                break;
        case PHY_INTERFACE_MODE_RGMII_RXID:
                val = RTL8211E_RX_DELAY;
                break;
        case PHY_INTERFACE_MODE_RGMII_TXID:
                val = RTL8211E_TX_DELAY;
                break;
        default: /* the rest of the modes imply leaving delays as is. */
                return 0;
        }

If the user requests RGMII, we really should set it to RGMII, not
leave the strapping configuration enabled. That means we need to turn
on the force bit, and the two delays off. Please also change the
case PHY_INTERFACE_MODE_RGMII.

Thanks
	Andrew
