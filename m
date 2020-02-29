Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82A3A1747B0
	for <lists+netdev@lfdr.de>; Sat, 29 Feb 2020 16:30:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727120AbgB2Pac (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Feb 2020 10:30:32 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:39766 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727070AbgB2Pab (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 29 Feb 2020 10:30:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=sBHWhVSh3klJN5kcIPaPKiA9b5bvnaJ4b7vpHAEeB84=; b=DRuRlxoe4uR69CzfbpF+lthW4G
        Xp2/YO/kT2EVT0tfpEhaOJ9ms4+a10KOGpDgPYwgYA3e/pmlSGzZbR8tLrM5KvqPsCs15Pui60LCv
        cw1+3XubTYqESQ1t4KlLtgm+l+6lB4YMLOq2G2fWkMumPjFip4qIMmyEQq7Ykicppdrk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1j844N-0001kg-Ss; Sat, 29 Feb 2020 16:30:23 +0100
Date:   Sat, 29 Feb 2020 16:30:23 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Pengcheng Xu <i@jsteward.moe>
Cc:     Nicolas Ferre <nicolas.ferre@microchip.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: macb: add support for fixed-link
Message-ID: <20200229153023.GC6305@lunn.ch>
References: <20200229070902.1294280-1-i@jsteward.moe>
 <CADuippAvUXHH2Mjuxyz+9JFf-SR5j8itmRi5YvUJowmbVXR9Og@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CADuippAvUXHH2Mjuxyz+9JFf-SR5j8itmRi5YvUJowmbVXR9Og@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 29, 2020 at 03:19:15PM +0800, Pengcheng Xu wrote:
> Sorry for forgetting to CC the mailing lists.  Adding them now.
> 
> 2020年2月29日(土) 15:09 Pengcheng Xu <i@jsteward.moe>:
> >
> > The Cadence macb driver did not support fixed-link PHYs.  This patch
> > adds support for fixed-link PHYs to the driver.
> >
> > The driver only checks if there's a valid PHY over MDIO, which is either
> > present as a device tree node, or (if absent) searched on the MDIO bus.
> > This patch detects if there is a `fixed-link` PHY instead of a regular
> > MDIO-attached PHY.  The device tree node of the MAC is checked for a
> > fixed-link PHY via `of_phy_is_fixed_link`, and, if so, the normal MDIO
> > register routine is skipped, and `of_phy_register_fixed_link` is
> > performed instead.
> >
> > The changes were borrowed from
> > drivers/net/ethernet/altera/altera_tse_main.c and tested to work on a
> > Xilinx Zynq UltraScale+ device.
> >
> > Signed-off-by: Pengcheng Xu <i@jsteward.moe>
> > ---
> >  drivers/net/ethernet/cadence/macb_main.c | 15 ++++++++++++---
> >  1 file changed, 12 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
> > index 2c28da1737fe..fb359ce90ae4 100644
> > --- a/drivers/net/ethernet/cadence/macb_main.c
> > +++ b/drivers/net/ethernet/cadence/macb_main.c
> > @@ -744,6 +744,7 @@ static int macb_mdiobus_register(struct macb *bp)
> >
> >  static int macb_mii_init(struct macb *bp)
> >  {
> > +       struct device_node *np = bp->pdev->dev.of_node;
> >         int err = -ENXIO;
> >
> >         /* Enable management port */
> > @@ -765,9 +766,17 @@ static int macb_mii_init(struct macb *bp)
> >
> >         dev_set_drvdata(&bp->dev->dev, bp->mii_bus);
> >
> > -       err = macb_mdiobus_register(bp);
> > -       if (err)
> > -               goto err_out_free_mdiobus;
> > +       if (of_phy_is_fixed_link(np)) {
> > +               err = of_phy_register_fixed_link(np);
> > +               if (err) {
> > +                       netdev_err(bp->dev, "cannot register fixed-link PHY\n");
> > +                       goto err_out_free_mdiobus;
> > +               }
> > +       } else {
> > +               err = macb_mdiobus_register(bp);
> > +               if (err)
> > +                       goto err_out_free_mdiobus;
> > +       }
> >
> >         err = macb_mii_probe(bp->dev);
> >         if (err)

Hi Pengcheng

Fixed link and an mdio bus are not mutually exclusive. When the MAC is
connected to an Ethernet switch, you often see a fixed link, and the
ethernet switch on the MDIO bus. As an example,

arch/arm/boot/dts/vf610-zii-cfu1.dts

&fec1 {
        phy-mode = "rmii";
        pinctrl-names = "default";
        pinctrl-0 = <&pinctrl_fec1>;
        status = "okay";

        fixed-link {
                speed = <100>;
                full-duplex;
        };

        mdio1: mdio {
                #address-cells = <1>;
                #size-cells = <0>;
                status = "okay";

                switch0: switch0@0 {
                        compatible = "marvell,mv88e6085";
                        pinctrl-names = "default";
                        pinctrl-0 = <&pinctrl_switch>;
                        reg = <0>;
                        eeprom-length = <512>;
                        interrupt-parent = <&gpio3>;
                        interrupts = <2 IRQ_TYPE_LEVEL_LOW>;
                        interrupt-controller;
                        #interrupt-cells = <2>;
                        reset-gpios = <&gpio3 11 GPIO_ACTIVE_LOW>;

...

So if you find a fixed-phy, you should register it. And if you find an
mdio bus, you should also register it.

     Andrew
