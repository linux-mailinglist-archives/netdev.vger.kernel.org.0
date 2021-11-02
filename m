Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FE29443804
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 22:46:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231254AbhKBVtX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 17:49:23 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:44002 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230382AbhKBVtX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Nov 2021 17:49:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=g5PjRPGooZX9QLmvsUQz9bR1LIK1fGNbet4Pw/YnfcA=; b=gH3tlkPPy29T0EWrbCXzqKHcQJ
        PeCvulc+CZDyNFCkRWsTfvEeohEBC6jXgwQH5ExkEtKUVtGRquiiYYoCsUlnKbRJ5cADLduFrP8Ic
        MxioaURJFaVUIw8xky+TXasu0/lKP3oF+Nea8nQtyOY92NoRhxUyer2llaFm/U4iw0mU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mi1c6-00CRRZ-K9; Tue, 02 Nov 2021 22:46:38 +0100
Date:   Tue, 2 Nov 2021 22:46:38 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Grygorii Strashko <grygorii.strashko@ti.com>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-kernel@vger.kernel.org, Vignesh Raghavendra <vigneshr@ti.com>
Subject: Re: [RFC PATCH] net: phy/mdio: enable mmd indirect access through
 phy_mii_ioctl()
Message-ID: <YYGxvomL/0tiPzvV@lunn.ch>
References: <20211101182859.24073-1-grygorii.strashko@ti.com>
 <YYBBHsFEwGdPJw3b@lunn.ch>
 <YYBF3IZoSN6/O6AL@shell.armlinux.org.uk>
 <YYCLJnY52MoYfxD8@lunn.ch>
 <YYExmHYW49jOjfOt@shell.armlinux.org.uk>
 <bc9df441-49bf-5c8a-891c-cc3f0db00aba@ti.com>
 <YYF4ZQHqc1jJsE/+@shell.armlinux.org.uk>
 <e18f17bd-9e77-d3ef-cc1e-30adccb7cdd5@ti.com>
 <828e2d69-be15-fe69-48d8-9cfc29c4e76e@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <828e2d69-be15-fe69-48d8-9cfc29c4e76e@ti.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> @@ -300,8 +301,18 @@ int phy_mii_ioctl(struct phy_device *phydev, struct ifreq *ifr, int cmd)
>                         prtad = mii_data->phy_id;
>                         devad = mii_data->reg_num;
>                 }
> -               mii_data->val_out = mdiobus_read(phydev->mdio.bus, prtad,
> -                                                devad);
> +
> +               if (prtad != phydev->mdio.addr)
> +                       phydev_rq = mdiobus_get_phy(phydev->mdio.bus, prtad);
> +
> +               if (!phydev_rq) {
> +                       mii_data->val_out = mdiobus_read(phydev->mdio.bus, prtad, devad);
> +               } else if (mdio_phy_id_is_c45(mii_data->phy_id) && !phydev->is_c45) {
> +                       mii_data->val_out = phy_read_mmd(phydev_rq, mdio_phy_id_devad(mii_data->phy_id), mii_data->reg_num);
> +               } else {
> +                       mii_data->val_out = phy_read(phydev_rq, mii_data->reg_num);
> +               }
> +

One thing i don't like about this is you have little idea what it has
actually done.

If you pass a C45 address, i expect a C45 access. If i pass a C22 i
expect a C22 access.

What i find interesting is that you and the other resent requester are
using the same user space tool. If you implement C45 over C22 in that
tool, you get your solution, and it will work for older kernels as
well. Also, given the diverse implementations of this IOTCL, it
probably works for more drivers than just those using phy_mii_ioctl().

	 Andrew

	
