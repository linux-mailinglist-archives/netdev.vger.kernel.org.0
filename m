Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB7B43B05AB
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 15:16:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230332AbhFVNSk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 09:18:40 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:49768 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229913AbhFVNSj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Jun 2021 09:18:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=ASPA2Alud/ObRkYHzXvNjD5ePOL4W0UexmCN5MberbY=; b=pOUwXcvoNtNuIXN2pOgQyZU/xD
        I91eWspKCBJU6kaqFVByzQJ7jstAiWk3hgZ4WenUt4SqtHiyf2sByQWg1FTwuXdV2kVlweerL4ucb
        /Wy3YRBk6RzBgpQXwDVpQ4VefBqZe0Z4GV1qGfqKZKYFBkaG867TyIXNowo/w3TuoNnU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lvgG8-00AhuO-Im; Tue, 22 Jun 2021 15:16:08 +0200
Date:   Tue, 22 Jun 2021 15:16:08 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Ismail, Mohammad Athari" <mohammad.athari.ismail@intel.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "hmehrtens@maxlinear.com" <hmehrtens@maxlinear.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "tmohren@maxlinear.com" <tmohren@maxlinear.com>,
        "vee.khee.wong@linux.intel.com" <vee.khee.wong@linux.intel.com>,
        "lxu@maxlinear.com" <lxu@maxlinear.com>
Subject: Re: [PATCH v3] net: phy: add Maxlinear GPY115/21x/24x driver
Message-ID: <YNHimAJNg0rO/Tt4@lunn.ch>
References: <CO1PR11MB477189838CFCDB952D4B064BD5099@CO1PR11MB4771.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CO1PR11MB477189838CFCDB952D4B064BD5099@CO1PR11MB4771.namprd11.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 22, 2021 at 04:21:47AM +0000, Ismail, Mohammad Athari wrote:
> > -----Original Message-----
> > From: Ismail, Mohammad Athari <mohammad.athari.ismail@intel.com>
> > Sent: Tuesday, June 22, 2021 12:15 PM
> > To: Ismail, Mohammad Athari <mohammad.athari.ismail@intel.com>
> > Subject:
> > 
> > > Net-next:
> > >
> > > int genphy_loopback(struct phy_device *phydev, bool enable) {
> > >      if (enable) {
> > >          u16 val, ctl = BMCR_LOOPBACK;
> > >          int ret;
> > >
> > >          if (phydev->speed == SPEED_1000)
> > >              ctl |= BMCR_SPEED1000;
> > >          else if (phydev->speed == SPEED_100)
> > >              ctl |= BMCR_SPEED100;
> > >
> > >          if (phydev->duplex == DUPLEX_FULL)
> > >              ctl |= BMCR_FULLDPLX;
> > >
> > >          phy_modify(phydev, MII_BMCR, ~0, ctl);
> > >
> > >          ret = phy_read_poll_timeout(phydev, MII_BMSR, val,
> > >                          val & BMSR_LSTATUS,
> > >                      5000, 500000, true);
> > >          if (ret)
> > >              return ret;
> > >      } else {
> > >          phy_modify(phydev, MII_BMCR, BMCR_LOOPBACK, 0);
> > >
> > >          phy_config_aneg(phydev);
> > >      }
> > >
> > >      return 0;
> > > }
> 
> Hi Andrew,
> 

> We also observe same issue on Marvell88E1510 PHY (C22 supported PHY)
> as well. It works with v5.12.11's genphy_loopback() but not
> net-next's.

Ah, yes. The Marvell probably needs a software reset after the write
to the MII_BMSR register. But just setting the loopback bit also
probably needed a software reset as well, so i suspect it was broken
before this change.

Oleksij, rather that writing registers directly, we probably need to
use the phylib API calls to configure the PHY. That will handle
oddities like the Marvell needing a reset, or PHYs with other speeds
etc.

	Andrew
