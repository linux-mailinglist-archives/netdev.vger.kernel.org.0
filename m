Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66666203B00
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 17:36:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729167AbgFVPgD convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 22 Jun 2020 11:36:03 -0400
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:26739 "EHLO
        relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729150AbgFVPgC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 11:36:02 -0400
X-Originating-IP: 90.76.143.236
Received: from localhost (lfbn-tou-1-1075-236.w90-76.abo.wanadoo.fr [90.76.143.236])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay1-d.mail.gandi.net (Postfix) with ESMTPSA id 04959240002;
        Mon, 22 Jun 2020 15:35:59 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
In-Reply-To: <7520915d32e185d2ca29f085b988d55e@0leil.net>
References: <20200619122300.2510533-1-antoine.tenart@bootlin.com> <20200619122300.2510533-7-antoine.tenart@bootlin.com> <7520915d32e185d2ca29f085b988d55e@0leil.net>
Subject: Re: [PATCH net-next v3 6/8] net: phy: mscc: timestamping and PHC support
To:     Quentin Schulz <foss@0leil.net>
From:   Antoine Tenart <antoine.tenart@bootlin.com>
Cc:     davem@davemloft.net, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com, richardcochran@gmail.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.petazzoni@bootlin.com, allan.nielsen@microchip.com
Message-ID: <159284015920.1456598.1495380569655598691@kwain>
Date:   Mon, 22 Jun 2020 17:35:59 +0200
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Quentin,

Quoting Quentin Schulz (2020-06-21 19:35:20)
> On 2020-06-19 14:22, Antoine Tenart wrote:
> [...]
> > @@ -999,9 +1553,35 @@ int vsc8584_ptp_probe(struct phy_device *phydev)
> >       if (!vsc8531->ptp)
> >               return -ENOMEM;
> > 
> > +     mutex_init(&vsc8531->phc_lock);
> >       mutex_init(&vsc8531->ts_lock);
> > 
> > +     /* Retrieve the shared load/save GPIO. Request it as non exclusive as
> > +      * the same GPIO can be requested by all the PHYs of the same 
> > package.
> > +      * Ths GPIO must be used with the phc_lock taken (the lock is shared
> 
> Typo + wrong lock named in the comment, instead:
> 
>          * This GPIO must be used with the gpio_lock taken (the lock is shared
> 
> Though technically both are taken when access to the GPIO is requested 
> AFAICT.

That's right, thanks for pointing this out! I'll fix it for v4.

> Also on another note, maybe we could actually make vsc8531->base_addr
> be a part of vsc85xx_shared_private structure.
> 
> We would still need to compute it to pass it to devm_phy_package_join
> but it can easily be returned by vsc8584_get_base_addr instead of the
> current void and it'd put all the things used for all PHYs in the
> package at the same place.

We actually do not use directly the base_addr anymore from within the
driver, thanks to the shared package conversion. We're now using
__phy_package_write/__phy_package_read which are using the base address.

So the move could be to remove it from the vsc8531_private. If we were
to do it, we would need to find a clean solution: it's still part of a
structure as multiple values are computed in vsc8584_get_base_addr, and
it's a lot easier and cleaner to have them all in the same struct. Also,
that have nothing to do with the current series :)

Thanks,
Antoine

-- 
Antoine Ténart, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
