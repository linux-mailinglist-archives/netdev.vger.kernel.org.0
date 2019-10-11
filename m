Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6107D3CB4
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 11:48:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727893AbfJKJsF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 05:48:05 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:45406 "EHLO
        kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727888AbfJKJsD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Oct 2019 05:48:03 -0400
Received: from reginn.horms.nl (watermunt.horms.nl [80.127.179.77])
        by kirsty.vergenet.net (Postfix) with ESMTPA id ECC9B25AD5C;
        Fri, 11 Oct 2019 20:48:01 +1100 (AEDT)
Received: by reginn.horms.nl (Postfix, from userid 7100)
        id EFEEC940958; Fri, 11 Oct 2019 11:47:59 +0200 (CEST)
Date:   Fri, 11 Oct 2019 11:47:59 +0200
From:   Simon Horman <horms@verge.net.au>
To:     Marek Vasut <marex@denx.de>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        George McCollister <george.mccollister@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        Woojung Huh <woojung.huh@microchip.com>
Subject: Re: [PATCH V2 1/2] net: phy: micrel: Discern KSZ8051 and KSZ8795 PHYs
Message-ID: <20191011094759.na2z5gkced2qlyv3@verge.net.au>
References: <20191010194622.28742-1-marex@denx.de>
 <20191011055707.stsk5dwwg7acfmnv@verge.net.au>
 <cb1edacc-d85c-0f79-687f-88e4ce349f00@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cb1edacc-d85c-0f79-687f-88e4ce349f00@denx.de>
Organisation: Horms Solutions BV
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 11, 2019 at 08:52:13AM +0200, Marek Vasut wrote:
> On 10/11/19 7:57 AM, Simon Horman wrote:
> [...]
> >> +static int ksz8795_match_phy_device(struct phy_device *phydev)
> >> +{
> >> +	int ret;
> >> +
> >> +	if ((phydev->phy_id & MICREL_PHY_ID_MASK) != PHY_ID_KSZ8795)
> >> +		return 0;
> >> +
> >> +	ret = phy_read(phydev, MII_BMSR);
> >> +	if (ret < 0)
> >> +		return ret;
> >> +
> >> +	/* See comment in ksz8051_match_phy_device() for details. */
> >> +	return !(ret & BMSR_ERCAP);
> >> +}
> >> +
> > 
> > Hi Marek,
> > 
> > given the similarity between ksz8051_match_phy_device() and
> > ksz8795_match_phy_device() I wonder if a common helper is appropriate.
> 
> Then one (or both) of them look like this:
> 
> static int ksz8795_match_phy_device(struct phy_device *phydev)
> {
>         int ret;
> 
>         /* See comment in ksz8051_match_phy_device() for details. */
>         ret = ksz8051_match_phy_device(phydev);
>         if (ret < 0)
>                 return ret;
> 
>         return !ret;
> }
> 
> It's not that much better.

Hi Marek,

I think I slightly prefer this but I do see your point
and I have no objections to leaving the patch as-is.
