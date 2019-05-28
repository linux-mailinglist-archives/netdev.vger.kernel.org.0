Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6AADF2C7C3
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 15:27:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727133AbfE1N1y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 09:27:54 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:38624 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726867AbfE1N1x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 09:27:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=S446MZoSPa7QQDBRXKuMaHAfEibW0fm2rgJ3aNBD6o8=; b=EccWAaQBwzwldLjtPqXB11fao
        vCo2ER2d7uRpMI07L9xgpzro3yAYVoy21+MCMAQ4dh4B26lWN+x2CF4+tW5bmhwKk8r2fq86N/CwZ
        TgLSq+yYeOL1RoNBC8IY1GJQnw5YAG4poOJ6pI4SFB2bGXv8jh7X9ya5daNdPqZkNUohWjM2kSPz2
        CG2LQLDXpj2L5uC6sZh7VnqeDJ+4pwAzp0d3xhmbh8TOngrfZqqyUPa7w9QoRuFaL55T5O0GamCoi
        +3siG7i5gb5nUmqjCNkY35po6vzyoLEPF5OMpn5zOzAqyNv7AmpwIqDVNfJCnwMEYKPjJuDGZnW//
        U0i7ZhQZw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:52684)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1hVc8p-000626-Sz; Tue, 28 May 2019 14:27:48 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.89)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1hVc8n-0003ed-NB; Tue, 28 May 2019 14:27:45 +0100
Date:   Tue, 28 May 2019 14:27:45 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 3/5] net: phy: allow Clause 45 access via mii
 ioctl
Message-ID: <20190528132745.m4iuh6ggib3a5kiq@shell.armlinux.org.uk>
References: <20190528095639.kqalmvffsmc5ebs7@shell.armlinux.org.uk>
 <E1hVYrJ-0005ZA-0S@rmk-PC.armlinux.org.uk>
 <CA+h21hpXv7678MuKVfAGiwuQwzZHX_1hjXHpwZUFz8wP5aRabg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+h21hpXv7678MuKVfAGiwuQwzZHX_1hjXHpwZUFz8wP5aRabg@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 28, 2019 at 03:54:31PM +0300, Vladimir Oltean wrote:
> On Tue, 28 May 2019 at 12:58, Russell King <rmk+kernel@armlinux.org.uk> wrote:
> >
> > Allow userspace to generate Clause 45 MII access cycles via phylib.
> > This is useful for tools such as mii-diag to be able to inspect Clause
> > 45 PHYs.
> >
> > Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> > Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> > ---
> >  drivers/net/phy/phy.c | 33 ++++++++++++++++++++++++---------
> >  1 file changed, 24 insertions(+), 9 deletions(-)
> >
> > diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
> > index 3745220c5c98..6d279c2ac1f8 100644
> > --- a/drivers/net/phy/phy.c
> > +++ b/drivers/net/phy/phy.c
> > @@ -386,6 +386,7 @@ int phy_mii_ioctl(struct phy_device *phydev, struct ifreq *ifr, int cmd)
> >         struct mii_ioctl_data *mii_data = if_mii(ifr);
> >         u16 val = mii_data->val_in;
> >         bool change_autoneg = false;
> > +       int prtad, devad;
> >
> >         switch (cmd) {
> >         case SIOCGMIIPHY:
> > @@ -393,14 +394,29 @@ int phy_mii_ioctl(struct phy_device *phydev, struct ifreq *ifr, int cmd)
> >                 /* fall through */
> >
> >         case SIOCGMIIREG:
> > -               mii_data->val_out = mdiobus_read(phydev->mdio.bus,
> > -                                                mii_data->phy_id,
> > -                                                mii_data->reg_num);
> > +               if (mdio_phy_id_is_c45(mii_data->phy_id)) {
> > +                       prtad = mdio_phy_id_prtad(mii_data->phy_id);
> > +                       devad = mdio_phy_id_devad(mii_data->phy_id);
> > +                       devad = MII_ADDR_C45 | devad << 16 | mii_data->reg_num;
> > +               } else {
> > +                       prtad = mii_data->phy_id;
> > +                       devad = mii_data->reg_num;
> > +               }
> > +               mii_data->val_out = mdiobus_read(phydev->mdio.bus, prtad,
> > +                                                devad);
> >                 return 0;
> >
> >         case SIOCSMIIREG:
> > -               if (mii_data->phy_id == phydev->mdio.addr) {
> > -                       switch (mii_data->reg_num) {
> > +               if (mdio_phy_id_is_c45(mii_data->phy_id)) {
> > +                       prtad = mdio_phy_id_prtad(mii_data->phy_id);
> > +                       devad = mdio_phy_id_devad(mii_data->phy_id);
> > +                       devad = MII_ADDR_C45 | devad << 16 | mii_data->reg_num;
> > +               } else {
> > +                       prtad = mii_data->phy_id;
> > +                       devad = mii_data->reg_num;
> > +               }
> > +               if (prtad == phydev->mdio.addr) {
> > +                       switch (devad) {
> >                         case MII_BMCR:
> >                                 if ((val & (BMCR_RESET | BMCR_ANENABLE)) == 0) {
> >                                         if (phydev->autoneg == AUTONEG_ENABLE)
> > @@ -433,11 +449,10 @@ int phy_mii_ioctl(struct phy_device *phydev, struct ifreq *ifr, int cmd)
> >                         }
> >                 }
> >
> > -               mdiobus_write(phydev->mdio.bus, mii_data->phy_id,
> > -                             mii_data->reg_num, val);
> > +               mdiobus_write(phydev->mdio.bus, prtad, devad, val);
> >
> > -               if (mii_data->phy_id == phydev->mdio.addr &&
> > -                   mii_data->reg_num == MII_BMCR &&
> > +               if (prtad == phydev->mdio.addr &&
> > +                   devad == MII_BMCR &&
> >                     val & BMCR_RESET)
> >                         return phy_init_hw(phydev);
> >
> > --
> > 2.7.4
> >
> 
> Hi Russell,
> 
> I find the SIOCGMIIREG/SIOCGMIIPHY ioctls useful for C45 just as much
> as they are for C22, but I think the way they work is a big hack and
> for that reason they're less than useful when you need them most.
> These ioctls work by hijacking the MDIO bus driver of a PHY that is
> attached to a net_device. Hence they can be used to access at most a
> PHY that lies on the same MDIO bus as one you already have a
> phy-handle to.
> If you have a PHY issue that makes of_phy_connect fail and the
> net_device to fail to probe, basically you're SOL because you lose
> that one handle that userspace had to the MDIO bus.
> Similarly if you're doing a bring-up and all PHY interfaces are fixed-link.
> Maybe it would be better to rethink this and expose some sysfs nodes
> for raw MDIO access in the bus drivers.

I don't see how putting some attributes in sysfs helps - sysfs is
fine for exporting structured information, but with PHYs, it's not
that structured.  ioctls on sysfs attributes are certainly very
undesirable, and not supported.  So, I don't think sysfs would work.

debugfs is another option, that is more flexible, but that is also
based around the idea of exporting stuff in a relatively structured
way, and I don't think a MII bus with arbitary PHYs with an arbitary
number of layers would be exportable in a particularly nice way.
Consider that a Clause 45 PHY can have up to 32 layers, each with
64Ki of register space - that's a total of 2Mi of 16-bit registers.

What would be better would be for the MDIO layer to have /dev nodes
that userspace could use to access the bus independent of the PHY,
much the same as we have /dev/i2c-* - but I'm not sure if we really
want to invent a whole new interface to MDIO buses.

The MII interface already exists, works for the most part, and is
already used for Clause 45 PHYs for a number of NICs.  I do agree
that it is less than perfect though.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
