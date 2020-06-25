Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D0FF20A021
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 15:39:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405187AbgFYNi6 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 25 Jun 2020 09:38:58 -0400
Received: from relay8-d.mail.gandi.net ([217.70.183.201]:36989 "EHLO
        relay8-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405038AbgFYNi5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 09:38:57 -0400
X-Originating-IP: 90.76.143.236
Received: from localhost (lfbn-tou-1-1075-236.w90-76.abo.wanadoo.fr [90.76.143.236])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay8-d.mail.gandi.net (Postfix) with ESMTPSA id 1B2C11BF214;
        Thu, 25 Jun 2020 13:38:54 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20200625132226.GC2548@localhost>
References: <20200623143014.47864-1-antoine.tenart@bootlin.com> <20200623143014.47864-7-antoine.tenart@bootlin.com> <20200625132226.GC2548@localhost>
Subject: Re: [PATCH net-next v4 6/8] net: phy: mscc: timestamping and PHC support
Cc:     davem@davemloft.net, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, thomas.petazzoni@bootlin.com,
        allan.nielsen@microchip.com, foss@0leil.net
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     Richard Cochran <richardcochran@gmail.com>
Message-ID: <159309233393.397581.16273630291558095966@kwain>
Date:   Thu, 25 Jun 2020 15:38:54 +0200
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Richard,

Quoting Richard Cochran (2020-06-25 15:22:26)
> On Tue, Jun 23, 2020 at 04:30:12PM +0200, Antoine Tenart wrote:
> > @@ -978,9 +1483,32 @@ static int __vsc8584_init_ptp(struct phy_device *phydev)
> >  
> >       vsc85xx_ts_eth_cmp1_sig(phydev);
> >  
> > +     vsc8531->mii_ts.rxtstamp = vsc85xx_rxtstamp;
> > +     vsc8531->mii_ts.txtstamp = vsc85xx_txtstamp;
> > +     vsc8531->mii_ts.hwtstamp = vsc85xx_hwtstamp;
> > +     vsc8531->mii_ts.ts_info  = vsc85xx_ts_info;
> > +     phydev->mii_ts = &vsc8531->mii_ts;
> > +
> > +     memcpy(&vsc8531->ptp->caps, &vsc85xx_clk_caps, sizeof(vsc85xx_clk_caps));
> > +
> > +     vsc8531->ptp->ptp_clock = ptp_clock_register(&vsc8531->ptp->caps,
> > +                                                  &phydev->mdio.dev);
> > +     if (IS_ERR(vsc8531->ptp->ptp_clock))
> > +             return PTR_ERR(vsc8531->ptp->ptp_clock);
> 
> The ptp_clock_register() method can also return NULL:
> 
>  * Returns a valid pointer on success or PTR_ERR on failure.  If PHC
>  * support is missing at the configuration level, this function
>  * returns NULL, and drivers are expected to gracefully handle that
>  * case separately.

If ptp_clock_register returns NULL because PHC support is missing, the
clock won't be exported. Beside that, I don't think we can do much in
the error path, so this should be safe.

Thanks,
Antoine

-- 
Antoine Ténart, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
