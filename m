Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF1753ACCFE
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 16:01:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232152AbhFRODe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 10:03:34 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:44614 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230387AbhFRODd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Jun 2021 10:03:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=OtMNx+STOoasIPfFddFNRvJQfssIcbHuOaMq8kAdsmY=; b=xH
        GbmlxwwZx9Xpd50r5NU6O+Ue9FpIpc/lHYUidhWj0EZ9pX1rPiaFfQ5e4Z9z7XS6cVbhD5U9jSpwe
        vvHxUQ9TCXIf6xAThqVo5tO87fSmv5LL/jwF3EvtjWFAd3A3RD725wf419da5hELeN/sfo/ejQCxU
        UpR4fayJnvADVYs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1luF3f-00A4t5-O0; Fri, 18 Jun 2021 16:01:19 +0200
Date:   Fri, 18 Jun 2021 16:01:19 +0200
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
Message-ID: <YMynL9c9MpfdC7Se@lunn.ch>
References: <20210604161250.49749-1-lxu@maxlinear.com>
 <f56aa414-3002-ef85-51a9-bb36017270e6@gmail.com>
 <7834258b-5826-1c00-2754-b0b7e76b5910@maxlinear.com>
 <YLqIvGIzBIULI2Gm@lunn.ch>
 <2b9945f9-16a4-bda5-40df-d79089be3c12@maxlinear.com>
 <YLuPZTXFrJ9KjNpl@lunn.ch>
 <9a838afe-83e7-b575-db49-f210022966d5@maxlinear.com>
 <334b52a6-30e8-0869-6ffb-52e9955235ff@maxlinear.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <334b52a6-30e8-0869-6ffb-52e9955235ff@maxlinear.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Net-next:
> 
> int genphy_loopback(struct phy_device *phydev, bool enable)
> {
>      if (enable) {
>          u16 val, ctl = BMCR_LOOPBACK;
>          int ret;
> 
>          if (phydev->speed == SPEED_1000)
>              ctl |= BMCR_SPEED1000;
>          else if (phydev->speed == SPEED_100)
>              ctl |= BMCR_SPEED100;
> 
>          if (phydev->duplex == DUPLEX_FULL)
>              ctl |= BMCR_FULLDPLX;
> 
>          phy_modify(phydev, MII_BMCR, ~0, ctl);
> 
>          ret = phy_read_poll_timeout(phydev, MII_BMSR, val,
>                          val & BMSR_LSTATUS,
>                      5000, 500000, true);
>          if (ret)
>              return ret;
>      } else {
>          phy_modify(phydev, MII_BMCR, BMCR_LOOPBACK, 0);
> 
>          phy_config_aneg(phydev);
>      }
> 
>      return 0;
> }
> 
> v5.12.11:
> 
> int genphy_loopback(struct phy_device *phydev, bool enable)
> {
>      return phy_modify(phydev, MII_BMCR, BMCR_LOOPBACK,
>                enable ? BMCR_LOOPBACK : 0);
> }
> 
> 
> Not sure whether anyone else reported similar issue.

The commit message says:

    net: phy: genphy_loopback: add link speed configuration
    
    In case of loopback, in most cases we need to disable autoneg support
    and force some speed configuration. Otherwise, depending on currently
    active auto negotiated link speed, the loopback may or may not work.

> Should I use phy_modify to set the LOOPBACK bit only in my driver 
> implementation as force speed with loopback enable does not work in our 
> device?

So you appear to have the exact opposite problem, you need to use
auto-neg, with yourself, in order to have link. So there are two
solutions:

1) As you say, implement it in your driver

2) Add a second generic implementation, which enables autoneg, if it
is not enabled, sets the loopback bit, and waits for the link to come
up.

Does your PHY driver error out when asked to do a forced mode? It
probably should, if your silicon does not support that part of C22.

	 Andrew
