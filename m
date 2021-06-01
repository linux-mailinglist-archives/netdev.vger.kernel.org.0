Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9165E397C62
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 00:22:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234997AbhFAWXo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 18:23:44 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:39728 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234905AbhFAWXn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Jun 2021 18:23:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=CsnPtThWLybNzTBvLNc9eaF3rItMTUPI+K/z2tQukKA=; b=uvn8r/aROG7HiY8DYbNpSzBKQl
        EOiXVdSCniSkUupurOqYnS5e2fAyEFGqhLNcrN73OUsJLZ4qz+VdgTQq48BzCLj7Kjq9xeNdfAWqG
        9qlj3Lrj8LuRA/tQTkxcMhB7sLybk+XTJpLJ8BjHlLtz5wgXSrbG9AxiHy5hponaHLT4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1loClr-007M6J-0I; Wed, 02 Jun 2021 00:21:59 +0200
Date:   Wed, 2 Jun 2021 00:21:58 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Wong Vee Khee <vee.khee.wong@linux.intel.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC net-next 0/2] Introduce MDIO probe order C45 over C22
Message-ID: <YLazBrpXbpsb6aXI@lunn.ch>
References: <20210525055803.22116-1-vee.khee.wong@linux.intel.com>
 <YKz86iMwoP3VT4uh@lunn.ch>
 <20210601104734.GA18984@linux.intel.com>
 <YLYwcx3aHXFu4n5C@lunn.ch>
 <20210601154423.GA27463@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210601154423.GA27463@linux.intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 01, 2021 at 11:44:23PM +0800, Wong Vee Khee wrote:
> On Tue, Jun 01, 2021 at 03:04:51PM +0200, Andrew Lunn wrote:
> > On Tue, Jun 01, 2021 at 06:47:34PM +0800, Wong Vee Khee wrote:
> > > On Tue, May 25, 2021 at 03:34:34PM +0200, Andrew Lunn wrote:
> > > > On Tue, May 25, 2021 at 01:58:03PM +0800, Wong Vee Khee wrote:
> > > > > Synopsys MAC controller is capable of pairing with external PHY devices
> > > > > that accessible via Clause-22 and Clause-45.
> > > > > 
> > > > > There is a problem when it is paired with Marvell 88E2110 which returns
> > > > > PHY ID of 0 using get_phy_c22_id(). We can add this check in that
> > > > > function, but this will break swphy, as swphy_reg_reg() return 0. [1]
> > > > 
> > > > Is it possible to identify it is a Marvell PHY? Do any of the other
> > > > C22 registers return anything unique? I'm wondering if adding
> > > > .match_phy_device to genphy would work to identify it is a Marvell PHY
> > > > and not bind to it. Or we can turn it around, make the
> > > > .match_phy_device specifically look for the fixed-link device by
> > > > putting a magic number in one of the vendor registers.
> > > >
> > > 
> > > I checked the Marvell and did not see any unique register values.
> > > Also, since get_phy_c22_id() returns a *phy_id== 0, it is not bind to
> > > any PHY driver, so I don't think adding the match_phy_device check in
> > > getphy would help.
> > 
> > It has a Marvell ID in C45 space. So maybe we need to special case for
> > ID 0. If we get that, go look in C45 space. If we find a valid ID, use
> > it. If we get EOPNOTSUP because the MDIO bus is not C45 capable, or we
> > don't find a vendor ID in C45 space, keep with id == 0 and load
> > genphy?
> >
> 
> Make sense for me.
> Let me what you think of adding the checks in *get_phy_device():
> 
> diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
> index 1539ea021ac0..ad9a87fadea1 100644
> --- a/drivers/net/phy/phy_device.c
> +++ b/drivers/net/phy/phy_device.c
> @@ -862,11 +862,21 @@ struct phy_device *get_phy_device(struct mii_bus *bus, int addr, bool is_c45)
>         c45_ids.mmds_present = 0;
>         memset(c45_ids.device_ids, 0xff, sizeof(c45_ids.device_ids));
> 
> -       if (is_c45)
> +       if (is_c45) {
>                 r = get_phy_c45_ids(bus, addr, &c45_ids);
> -       else
> +       } else {
>                 r = get_phy_c22_id(bus, addr, &phy_id);
> 
> +               if (phy_id == 0) {
> +                       r = get_phy_c45_ids(bus, addr, &c45_ids);
> +                       if (r == -ENOTSUPP || r == -ENODEV)
> +                               return 0;

This bit is not correct. I said 'or we don't find a vendor ID in C45
space, keep with id == 0'. We need to keep backwards compatibility. If
get_phy_c22_id() did not return an error we should create a device
with phy_id 0, if get_phy_c45_ids() returns an error.

     Andrew
