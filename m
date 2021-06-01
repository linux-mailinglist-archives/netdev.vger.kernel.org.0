Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2E56397A89
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 21:14:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234741AbhFATPm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 15:15:42 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:39332 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234628AbhFATPl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Jun 2021 15:15:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=/2m2vE+ftN28tEQqzl4iBDZLbfMKxT2qINDoF6ixKBM=; b=I+Zp2SeFeffnTgV9/RQCJIK7Qp
        Om0tGplIF3YckOpIrFCm887bBQHjblAVq6TWvUbMg3QiMdNOLye7qcksiNjHgT7Sasm4xJJkKl3hX
        c4tae6hp0u7T9b+JsKeHSz24Mwny8Vww+ZxHA7d9vgDpiCAI6kZJHNtKIPKhZ6UgNlKI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lo9pt-007Khz-CP; Tue, 01 Jun 2021 21:13:57 +0200
Date:   Tue, 1 Jun 2021 21:13:57 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Liang Xu <lxu@maxlinear.com>
Cc:     "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        Hauke Mehrtens <hmehrtens@maxlinear.com>,
        Thomas Mohren <tmohren@maxlinear.com>
Subject: Re: [PATCH] phy: maxlinear: add Maxlinear GPY115/21x/24x driver
Message-ID: <YLaG9cdn6ewdffjV@lunn.ch>
References: <20210601074427.40990-1-lxu@maxlinear.com>
 <YLYrFDvGr7flA9rt@lunn.ch>
 <050c9cd2-ba6e-332d-d235-4fa9364b461b@maxlinear.com>
 <YLZmZ0pa4vULonsZ@lunn.ch>
 <089adb48-c3f7-4c4e-808f-b303a0cd16d6@maxlinear.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <089adb48-c3f7-4c4e-808f-b303a0cd16d6@maxlinear.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 01, 2021 at 05:14:01PM +0000, Liang Xu wrote:
> On 2/6/2021 12:55 am, Andrew Lunn wrote:
> > This email was sent from outside of MaxLinear.
> >
> >
> >>>> +     linkmode_mod_bit(ETHTOOL_LINK_MODE_5000baseT_Full_BIT,
> >>>> +                      phydev->supported,
> >>>> +                      ret & MDIO_PMA_NG_EXTABLE_5GBT);
> >>>> +
> >>> Does genphy_c45_pma_read_abilities() do the wrong thing here? What
> >>> does it get wrong?
> >> The problem comes from condition "phydev->c45_ids.mmds_present &
> >> MDIO_DEVS_AN".
> >>
> >> Our product supports both C22 and C45.
> >>
> >> In the real system, we found C22 was used by customers (with indirect
> >> access to C45 registers when necessary).
> >>
> >> Then during probe, in API "get_phy_device", it skips reading C45 IDs.
> >>
> >> So that genphy_c45_pma_read_abilities skip the supported flag
> >> ETHTOOL_LINK_MODE_Autoneg_BIT.
> > This sounds like a generic problem, which will affect any PHY which
> > has both C22 and C45. I wounder if it makes sense to add a helper
> > function which a PHY driver can call to get the
> > phydev->c45_ids.mmds_present populated?
> 
> I thought to use get_phy_c45_ids in gpy_config_init to populate the 
> c45_ids, but this is a static function inside phy_device.c.

Yes, which i said maybe add a helper. Something like this in phy_device.c

int phy_get_c45_ids(struct phy_device *phydev) {

	return get_phy_c45_ids(phydev->mdio.bus, phydev->mdio.addr,
			       phydev->c45_ids);
}

Completely untested. Hopefully you get the idea.


> 
> Or maybe in genphy_c45_pma_read_abilities, it reads MII_BMSR register if 
> is_c45 not set.
> 
> >>>> +static int gpy_read_status(struct phy_device *phydev)
> >>>> +{
> >>>> +     int ret;
> >>>> +
> >>>> +     ret = genphy_update_link(phydev);
> >>>> +     if (ret)
> >>>> +             return ret;
> >>>> +
> >>>> +     phydev->speed = SPEED_UNKNOWN;
> >>>> +     phydev->duplex = DUPLEX_UNKNOWN;
> >>>> +     phydev->pause = 0;
> >>>> +     phydev->asym_pause = 0;
> >>>> +
> >>>> +     if (phydev->autoneg == AUTONEG_ENABLE && phydev->autoneg_complete) {
> >>>> +             ret = genphy_c45_read_lpa(phydev);
> >>>> +             if (ret < 0)
> >>>> +                     return ret;
> >>>> +
> >>>> +             /* Read the link partner's 1G advertisement */
> >>>> +             ret = phy_read(phydev, MII_STAT1000);
> >>>> +             if (ret < 0)
> >>>> +                     return ret;
> >>>> +             mii_stat1000_mod_linkmode_lpa_t(phydev->lp_advertising, ret);
> >>> can genphy_read_lpa() be used here?
> >> 2.5G is not covered in genphy_read_lpa.
> >>
> >> If I use genphy_c45_read_lpa first then genphy_read_lpa after, it seems
> >> a bit redundant.
> > I'm just trying to avoid repeating code which is in helpers. I think
> > this is the first PHY driver which uses a mixture of C22 and C45 like
> > this. So it could be the helpers need small modifications to make them
> > work. We should make those modifications, since your PHY is not likely
> > to be the only mixed C22 and C45 device.
> 
> I agree, this is issue for mixed C22/45 device.
> 
> I saw something similar in BRCM driver (bcm84881_read_status) and 
> Marvell driver (mv3310_read_status_copper).
> 
> They are C45 device and use vendor specific register in MMD to access 
> C22 equivalent registers.

As you said, those drivers use vendor specific registers.  In your
case, you use standard registers. So that is why i'm thinking it
should be possible to use the helpers.

	 Andrew
