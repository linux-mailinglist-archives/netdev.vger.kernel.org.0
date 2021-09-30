Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48CAD41DCCC
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 16:59:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351585AbhI3PAn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 11:00:43 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:41258 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351826AbhI3PAn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Sep 2021 11:00:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=zpw3hOJAqQXBVksW1AbLHhp4JiOPJb04MZ6yrfoTbmo=; b=voly3Ky5WC4V/zRxV7Cdk8lx7p
        Y1scZU3rE6fONaWfSlX3fhkPp+SkseIPOc4nAQtjvBEtSngg1/xX28U2SMFWLtab+Yn/ZsMVL40j+
        hUSgJfqN5tD7PVzV2VAJvLpD6Uq8PGMlutQPjEVqZjZlWPX0DypNlpQ0768SwPbqLonw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mVxWP-008xpL-U6; Thu, 30 Sep 2021 16:58:53 +0200
Date:   Thu, 30 Sep 2021 16:58:53 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH RFT net-next] net: mdio: ensure the type of mdio devices
 match mdio drivers
Message-ID: <YVXQrTe392mMNAa+@lunn.ch>
References: <E1mVxSO-000aHB-P0@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1mVxSO-000aHB-P0@rmk-PC.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 30, 2021 at 03:54:44PM +0100, Russell King (Oracle) wrote:
> On the MDIO bus, we have PHYLIB devices and drivers, and we have non-
> PHYLIB devices and drivers. PHYLIB devices are MDIO devices that are
> wrapped with a struct phy_device.
> 
> Trying to bind a MDIO device with a PHYLIB driver results in out-of-
> bounds accesses as we attempt to access struct phy_device members. So,
> let's prevent this by ensuring that the type of the MDIO device
> (indicated by the MDIO_DEVICE_FLAG_PHY flag) matches the type of the
> MDIO driver (indicated by the MDIO_DEVICE_IS_PHY flag.)
> 
> Link: https://lore.kernel.org/r/2b1dc053-8c9a-e3e4-b450-eecdfca3fe16@gmail.com
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> ---
> Tested locally in SolidRun Clearfog, DSA switch and PHY get probed
> correctly. Further testing welcomed.
> 
>  drivers/net/phy/mdio_bus.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
> index 53f034fc2ef7..779e49715e91 100644
> --- a/drivers/net/phy/mdio_bus.c
> +++ b/drivers/net/phy/mdio_bus.c
> @@ -939,6 +939,12 @@ EXPORT_SYMBOL_GPL(mdiobus_modify);
>  static int mdio_bus_match(struct device *dev, struct device_driver *drv)
>  {
>  	struct mdio_device *mdio = to_mdio_device(dev);
> +	struct mdio_driver *mdiodrv = to_mdio_driver(drv);

DaveM would request these two lines are swapped for reverse Christmas tree.

      Andrew
