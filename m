Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B66C397EDA
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 04:20:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229932AbhFBCVc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 22:21:32 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:40038 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229702AbhFBCVb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Jun 2021 22:21:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=K3KCqXEauU6aKWxkMMXwDfluv9Lna1lNjOr9IA8yR50=; b=T/jkor7n0Ct6kXy2F4qShDNK2Z
        87SmFZM6g/f0GwloGvvWi0Ja41Orn0I4sCRWYW3sZL8E+YtzrndGl/ZKLI6kDiM05Zucl9YZBc9OR
        Uk8z0lejdQmmPC7utewdJFvnbZ+Hj8PT5+Ea3pJVFEoBJ558+Cclz+XUmockU+hMOyFE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1loGTv-007Ngi-Ln; Wed, 02 Jun 2021 04:19:43 +0200
Date:   Wed, 2 Jun 2021 04:19:43 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Wong Vee Khee <vee.khee.wong@linux.intel.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC net-next 0/2] Introduce MDIO probe order C45 over C22
Message-ID: <YLbqv0Sy/3E2XaVU@lunn.ch>
References: <20210525055803.22116-1-vee.khee.wong@linux.intel.com>
 <YKz86iMwoP3VT4uh@lunn.ch>
 <20210601104734.GA18984@linux.intel.com>
 <YLYwcx3aHXFu4n5C@lunn.ch>
 <20210601154423.GA27463@linux.intel.com>
 <YLazBrpXbpsb6aXI@lunn.ch>
 <20210601230352.GA28209@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210601230352.GA28209@linux.intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Yeah, you're right. Thanks for pointing that out. It should be:
> 
> diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
> index 1539ea021ac0..73bfde770f2d 100644
> --- a/drivers/net/phy/phy_device.c
> +++ b/drivers/net/phy/phy_device.c
> @@ -862,11 +862,22 @@ struct phy_device *get_phy_device(struct mii_bus *bus, int addr, bool is_c45)
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
> +                               return phy_device_create(bus, addr, phy_id,
> +                                                        false, &c45_ids);
> +                       else
> +                               return phy_device_create(bus, addr, phy_id,
> +                                                        true, &c45_ids);

Still not correct. Think about when get_phy_c22_id() returns an
error. Walk through all the different code paths and check they do the
right thing. It is actually a lot more complex than what is shown
here. Think about all the different types of PHYs and all the
different types of MDIO bus drivers.

      Andrew
