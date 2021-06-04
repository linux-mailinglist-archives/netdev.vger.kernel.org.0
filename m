Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07E8039C10C
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 22:13:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230352AbhFDUM1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 16:12:27 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:46050 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229791AbhFDUM1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Jun 2021 16:12:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=BbAFLGrGgY2oihriyQ//wQ5WcXkq7Kyp0Q/UXBGCxb0=; b=YuiSZcWNbcdMmIPkjb14TJ9uKw
        M1ksNIkWXBOHbISbw/ZGaFB3qDOzUjJI86hi6/NFTydyb2hS8CBywwFSOuiQV8wv3Mr5RRprCVnWu
        tXywOIm7tAFCHpu8u2W+yPHDTGjBlFQPgQQzGaW9w2qOnFfNbCRrIpkeE0IdJiwvNczA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lpG9M-007qju-N2; Fri, 04 Jun 2021 22:10:36 +0200
Date:   Fri, 4 Jun 2021 22:10:36 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Liang Xu <lxu@maxlinear.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "vee.khee.wong@linux.intel.com" <vee.khee.wong@linux.intel.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        Hauke Mehrtens <hmehrtens@maxlinear.com>,
        Thomas Mohren <tmohren@maxlinear.com>
Subject: Re: [PATCH v3] net: phy: add Maxlinear GPY115/21x/24x driver
Message-ID: <YLqIvGIzBIULI2Gm@lunn.ch>
References: <20210604161250.49749-1-lxu@maxlinear.com>
 <f56aa414-3002-ef85-51a9-bb36017270e6@gmail.com>
 <7834258b-5826-1c00-2754-b0b7e76b5910@maxlinear.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7834258b-5826-1c00-2754-b0b7e76b5910@maxlinear.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > +static int gpy_read_abilities(struct phy_device *phydev)
> > > +{
> > > + int ret;
> > > +
> > > + ret = genphy_read_abilities(phydev);
> > > + if (ret < 0)
> > > + return ret;
> > > +
> > > + /* Detect 2.5G/5G support. */
> > > + ret = phy_read_mmd(phydev, MDIO_MMD_PMAPMD, MDIO_STAT2);
> > > + if (ret < 0)
> > > + return ret;
> > > + if (!(ret & MDIO_PMA_STAT2_EXTABLE))
> > > + return 0;
> > > +
> > > + ret = phy_read_mmd(phydev, MDIO_MMD_PMAPMD, MDIO_PMA_EXTABLE);
> > > + if (ret < 0)
> > > + return ret;
> > > + if (!(ret & MDIO_PMA_EXTABLE_NBT))
> > > + return 0;
> > > +
> > > + ret = phy_read_mmd(phydev, MDIO_MMD_PMAPMD, MDIO_PMA_NG_EXTABLE);
> > > + if (ret < 0)
> > > + return ret;
> > > +
> > > + linkmode_mod_bit(ETHTOOL_LINK_MODE_2500baseT_Full_BIT,
> > > + phydev->supported,
> > > + ret & MDIO_PMA_NG_EXTABLE_2_5GBT);
> > > +
> > > + linkmode_mod_bit(ETHTOOL_LINK_MODE_5000baseT_Full_BIT,
> > > + phydev->supported,
> > > + ret & MDIO_PMA_NG_EXTABLE_5GBT);
> >
> > This does not access vendor specific registers, should not this be part
> > of the standard genphy_read_abilities() or moved to a helper?
> >
> genphy_read_abilities does not cover 2.5G.
> 
> genphy_c45_pma_read_abilities checks C45 ids and this check fail if 
> is_c45 is not set.

You appear to of ignored my comment about this. Please add the helper
to the core as i suggested, and then use
genphy_c45_pma_read_abilities().

	Andrew
