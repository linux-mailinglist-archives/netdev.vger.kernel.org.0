Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21CA0AFA01
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 12:10:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727551AbfIKKKZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 06:10:25 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:56982 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726341AbfIKKKZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Sep 2019 06:10:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=hn2x8HbV7ojQpyUDVHHPLV53AHNfyJ+GzzuAB0pB4kw=; b=TMKfNNgZA4dRN9kS51bLL7CcG
        NrJYUfh++qO+I3D9nO9IXN1brtM1SxmJqNkcEeGaeMeP6cQst1L+/Km10QPq+cM5dlkSwFAiCvrOr
        JQoBJ2ELWWX1NAB3DZQ3bE97hBy71SqHsFOGzNBuMNNDz247c+ES2IDbhPJzKrSPYXqABBBj8izNQ
        QDTtJDvGXOxCwVUzcLtZ0pEo8pAFgNZI5Wqb+CApQ7fhP5x++rqI16zyg1PMTHottvEK2Z7luxbca
        M9v49J9f7wtievzsDKI2Gwqv1QxcgyG3V4DxrmCnTVOps/xuTQatUoKM+89PqQ07kcbs4ttNtAZRB
        RagWu2CIg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:42318)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1i7zZr-0005hn-Lb; Wed, 11 Sep 2019 11:10:19 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1i7zZo-0003rs-W7; Wed, 11 Sep 2019 11:10:17 +0100
Date:   Wed, 11 Sep 2019 11:10:16 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-gpio@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH 04/11] net: phylink: switch to using
 fwnode_gpiod_get_index()
Message-ID: <20190911101016.GW13294@shell.armlinux.org.uk>
References: <20190911075215.78047-1-dmitry.torokhov@gmail.com>
 <20190911075215.78047-5-dmitry.torokhov@gmail.com>
 <20190911092514.GM2680@smile.fi.intel.com>
 <20190911093914.GT13294@shell.armlinux.org.uk>
 <20190911094619.GN2680@smile.fi.intel.com>
 <20190911094929.GV13294@shell.armlinux.org.uk>
 <20190911095511.GB108334@dtor-ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190911095511.GB108334@dtor-ws>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 11, 2019 at 02:55:11AM -0700, Dmitry Torokhov wrote:
> On Wed, Sep 11, 2019 at 10:49:29AM +0100, Russell King - ARM Linux admin wrote:
> > On Wed, Sep 11, 2019 at 12:46:19PM +0300, Andy Shevchenko wrote:
> > > On Wed, Sep 11, 2019 at 10:39:14AM +0100, Russell King - ARM Linux admin wrote:
> > > > On Wed, Sep 11, 2019 at 12:25:14PM +0300, Andy Shevchenko wrote:
> > > > > On Wed, Sep 11, 2019 at 12:52:08AM -0700, Dmitry Torokhov wrote:
> > > > > > Instead of fwnode_get_named_gpiod() that I plan to hide away, let's use
> > > > > > the new fwnode_gpiod_get_index() that mimics gpiod_get_index(), bit
> > > > > > works with arbitrary firmware node.
> > e > > 
> > > > > I'm wondering if it's possible to step forward and replace
> > > > > fwnode_get_gpiod_index by gpiod_get() / gpiod_get_index() here and
> > > > > in other cases in this series.
> > > > 
> > > > No, those require a struct device, but we have none.  There are network
> > > > drivers where there is a struct device for the network complex, but only
> > > > DT nodes for the individual network interfaces.  So no, gpiod_* really
> > > > doesn't work.
> > > 
> > > In the following patch the node is derived from struct device. So, I believe
> > > some cases can be handled differently.
> > 
> > phylink is not passed a struct device - it has no knowledge what the
> > parent device is.
> > 
> > In any case, I do not have "the following patch".
> 
> Andy is talking about this one:
> 
> diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
> index ce940871331e..9ca51d678123 100644
> --- a/drivers/net/phy/mdio_bus.c
> +++ b/drivers/net/phy/mdio_bus.c
> @@ -46,8 +46,8 @@ static int mdiobus_register_gpiod(struct mdio_device *mdiodev)
> 
>         /* Deassert the optional reset signal */
>         if (mdiodev->dev.of_node)
> -               gpiod = fwnode_get_named_gpiod(&mdiodev->dev.of_node->fwnode,
> -                                              "reset-gpios", 0,
>                                                GPIOD_OUT_LOW,
> +               gpiod = fwnode_gpiod_get_index(&mdiodev->dev.of_node->fwnode,
> +                                              "reset", 0, GPIOD_OUT_LOW,
>                                                "PHY reset");
> Here if we do not care about "PHY reset" label, we could use
> gpiod_get(&mdiodev->dev, "reset", GPIOD_OUT_LOW).

Here, you have a struct device, so yes, it's possible.

Referring back to my comment, notice that I said we have none for the
phylink case, so it's not possible there.

I'm not sure why Andy replied the way he did, unless he mis-read my
comment.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
