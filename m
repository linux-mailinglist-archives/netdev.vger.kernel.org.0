Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51F3E1AEEAF
	for <lists+netdev@lfdr.de>; Sat, 18 Apr 2020 16:23:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726089AbgDROXj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Apr 2020 10:23:39 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:46424 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725879AbgDROXj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 18 Apr 2020 10:23:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=HuhdcQVqPs2We6PMS/Dfi5J0jRsJtrsrDRMDZUCkZKI=; b=znvCAeoGkh2IKmj20b7LKrFF8Z
        D4X/G3SrodeLxtsHUeJ3z8elg2aYq5eFKyZ9KpgB49qJxBpsanDHZbnV9i85Tn5zrV9faIHPZEioB
        1t+gP3uVwSq4uq/jJkBaQBmskfeXC5BEZULmLpl9iJ6k8Jnv3sN/xyRky8++rpBnqk38=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jPoNc-003T4H-Jc; Sat, 18 Apr 2020 16:23:36 +0200
Date:   Sat, 18 Apr 2020 16:23:36 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>, fugang.duan@nxp.com,
        Chris Healy <Chris.Healy@zii.aero>
Subject: Re: [PATCH net-next v2 2/3] net: ethernet: fec: Allow configuration
 of MDIO bus speed
Message-ID: <20200418142336.GB804711@lunn.ch>
References: <20200418000355.804617-1-andrew@lunn.ch>
 <20200418000355.804617-3-andrew@lunn.ch>
 <3cb32a99-c684-03fd-c471-1d061ca97d4b@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3cb32a99-c684-03fd-c471-1d061ca97d4b@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 17, 2020 at 05:34:56PM -0700, Florian Fainelli wrote:
> Hi Andrew,
> 
> On 4/17/2020 5:03 PM, Andrew Lunn wrote:
> > MDIO busses typically operate at 2.5MHz. However many devices can
> > operate at faster speeds. This then allows more MDIO transactions per
> > second, useful for Ethernet switch statistics, or Ethernet PHY TDR
> > data. Allow the bus speed to be configured, using the standard
> > "clock-frequency" property, which i2c busses use to indicate the bus
> > speed.
> > 
> > Suggested-by: Chris Healy <Chris.Healy@zii.aero>
> > Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> 
> This does look good to me, however if we go down that road, it looks like we
> should also support a 'mdio-max-frequency' per MDIO child node in order to
> scale up and down the frequency accordingly.

Hi Florian

I don't see how that would work. Each device on the bus needs to be
able to receiver the transaction in order to decode the device
address, and then either discard it, or act on it. So the same as I2C
where the device address is part of the transaction. You need the bus
to run as fast as the slowest device on the bus. So a bus property is
the simplest. You could have per device properties, and during the bus
scan, figure out what the slowest device is, but that seems to add
complexity for no real gain. I2C does not have this either.

If MDIO was more like SPI, with per device chip select lines, then a
per device frequency would make sense.

	   Andrew
