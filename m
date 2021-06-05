Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C26F39C913
	for <lists+netdev@lfdr.de>; Sat,  5 Jun 2021 16:37:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230034AbhFEOiz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Jun 2021 10:38:55 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:47064 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229930AbhFEOiy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Jun 2021 10:38:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=MWYMdZOu22Ujn+z8BtXbAw8xgWsZPKHzAaJseRrxwbI=; b=t00R7u1tDXvq/C2w/ZLwgJ1KsC
        XwdmAr1+HfQuYfkLaFM+fSM/QvsUZE0D+SCL71AB7OkwVlMjMRYDmONILvv8QiR9Wwz3tCfQGpkzV
        H7Ny5pmtVZdaWygI44eWpQu36OwpnsOfD2zE+5mpsQ9t3KKABUbAPY4XGNEs+5jqkIvQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lpXQ7-007wBV-Eu; Sat, 05 Jun 2021 16:37:03 +0200
Date:   Sat, 5 Jun 2021 16:37:03 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Liang Xu <lxu@maxlinear.com>
Cc:     "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "vee.khee.wong@linux.intel.com" <vee.khee.wong@linux.intel.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        Hauke Mehrtens <hmehrtens@maxlinear.com>,
        Thomas Mohren <tmohren@maxlinear.com>
Subject: Re: [PATCH v2] net: phy: add Maxlinear GPY115/21x/24x driver
Message-ID: <YLuMDyg2IIpalOIo@lunn.ch>
References: <20210603073438.33967-1-lxu@maxlinear.com>
 <YLoZWho/5a60wqPu@lunn.ch>
 <797fe98f-ab65-8633-dadc-beed56d251d0@maxlinear.com>
 <YLqPnpNXbd6o019o@lunn.ch>
 <f965ae22-c5a8-ec52-322f-33ae04b76404@maxlinear.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f965ae22-c5a8-ec52-322f-33ae04b76404@maxlinear.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 05, 2021 at 03:46:18AM +0000, Liang Xu wrote:
> On 5/6/2021 4:39 am, Andrew Lunn wrote:
> > This email was sent from outside of MaxLinear.
> >
> >
> > On Fri, Jun 04, 2021 at 12:52:02PM +0000, Liang Xu wrote:
> >> On 4/6/2021 8:15 pm, Andrew Lunn wrote:
> >>> This email was sent from outside of MaxLinear.
> >>>
> >>>
> >>>> +config MXL_GPHY
> >>>> +     tristate "Maxlinear PHYs"
> >>>> +     help
> >>>> +       Support for the Maxlinear GPY115, GPY211, GPY212, GPY215,
> >>>> +       GPY241, GPY245 PHYs.
> >>> Do these PHYs have unique IDs in register 2 and 3? What is the format
> >>> of these IDs?
> >>>
> >>> The OUI is fixed. But often the rest is split into two. The higher
> >>> part indicates the product, and the lower part is the revision. We
> >>> then have a struct phy_driver for each product, and the mask is used
> >>> to match on all the revisions of the product.
> >>>
> >>>        Andrew
> >>>
> >> Register 2, Register 3 bit 10~15 - OUI
> >>
> >> Register 3 bit 4~9 - product number
> >>
> >> Register 3 bit 0~3 - revision number
> >>

> These PHYs have same ID and no difference OUI, product number, revision 
> number.

Are you saying GPY115, GPY211, GPY212, GPY215, GPY241, GPY245 all have
the same product number?

Normally, each PHY has its own product ID, and so we have:

/* Vitesse 82xx */
static struct phy_driver vsc82xx_driver[] = {
{
        .phy_id         = PHY_ID_VSC8234,
        .name           = "Vitesse VSC8234",
        .phy_id_mask    = 0x000ffff0,
        /* PHY_GBIT_FEATURES */
        .config_init    = &vsc824x_config_init,
        .config_aneg    = &vsc82x4_config_aneg,
        .config_intr    = &vsc82xx_config_intr,
        .handle_interrupt = &vsc82xx_handle_interrupt,
}, {
        .phy_id         = PHY_ID_VSC8244,
        .name           = "Vitesse VSC8244",
        .phy_id_mask    = 0x000fffc0,
        /* PHY_GBIT_FEATURES */
        .config_init    = &vsc824x_config_init,
        .config_aneg    = &vsc82x4_config_aneg,
        .config_intr    = &vsc82xx_config_intr,
        .handle_interrupt = &vsc82xx_handle_interrupt,
}, {
        .phy_id         = PHY_ID_VSC8572,
        .name           = "Vitesse VSC8572",
        .phy_id_mask    = 0x000ffff0,
        /* PHY_GBIT_FEATURES */
        .config_init    = &vsc824x_config_init,
        .config_aneg    = &vsc82x4_config_aneg,
        .config_intr    = &vsc82xx_config_intr,
        .handle_interrupt = &vsc82xx_handle_interrupt,
}, {

one entry to describe one PHY.

    Andrew
