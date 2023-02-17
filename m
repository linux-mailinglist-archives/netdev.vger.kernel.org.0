Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C015569AD3C
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 14:58:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229956AbjBQN6d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 08:58:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229758AbjBQN6c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 08:58:32 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80D8D5E592
        for <netdev@vger.kernel.org>; Fri, 17 Feb 2023 05:58:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Ou5lkUF84+yOvPcv/TkEql/meqor8YmT0zAewjT9NQA=; b=oH2gbAwryMNtaqmPqVTa70l524
        SwAORctGTcWkOos6kM4T5dQ18yOU8yWtNK4X9IiwwCUSXknjzIlZ3Hr9zCs+qwaEgznt3D1FO1Rix
        zTAMI1OJFlx+dPMywOnavp9+M6hjhEllT4pzwAybR4ISaA23PHYkXYQCrJvI5dSOMxn8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pT1Fo-005Hxg-9q; Fri, 17 Feb 2023 14:58:24 +0100
Date:   Fri, 17 Feb 2023 14:58:24 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Doug Berger <opendmb@gmail.com>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>,
        Wei Fang <wei.fang@nxp.com>,
        Shenwei Wang <shenwei.wang@nxp.com>,
        Clark Wang <xiaoning.wang@nxp.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        UNGLinuxDriver@microchip.com, Byungho An <bh74.an@samsung.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Woojung Huh <woojung.huh@microchip.com>,
        Oleksij Rempel <linux@rempel-privat.de>
Subject: Re: [PATCH RFC 08/18] net: FEC: Fixup EEE
Message-ID: <Y++IAH16RqbZrSpg@lunn.ch>
References: <20230217034230.1249661-1-andrew@lunn.ch>
 <20230217034230.1249661-9-andrew@lunn.ch>
 <20230217081943.GA9065@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230217081943.GA9065@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > @@ -1997,6 +1988,7 @@ static void fec_enet_adjust_link(struct net_device *ndev)
> >  			netif_tx_unlock_bh(ndev);
> >  			napi_enable(&fep->napi);
> >  		}
> > +		fec_enet_eee_mode_set(ndev, phy_dev->eee_active);
> 
> Most of iMX variants do not support EEE. It should be something like this:
> 	if (fep->quirks & FEC_QUIRK_HAS_EEE)
> 		fec_enet_eee_mode_set(ndev, phy_dev->eee_active);

Yes, i missed that. Thanks. 

> > @@ -3131,15 +3120,7 @@ fec_enet_set_eee(struct net_device *ndev, struct ethtool_eee *edata)
> >  		return -ENETDOWN;
> >  
> >  	p->tx_lpi_timer = edata->tx_lpi_timer;
> > -
> > -	if (!edata->eee_enabled || !edata->tx_lpi_enabled ||
> > -	    !edata->tx_lpi_timer)
> > -		ret = fec_enet_eee_mode_set(ndev, false);
> > -	else
> > -		ret = fec_enet_eee_mode_set(ndev, true);
> > -
> > -	if (ret)
> > -		return ret;
> > +	p->tx_lpi_enabled = edata->tx_lpi_enabled;
> 
> Hm.. this change have effect only after link restart. Should we do
> something like this?
> 
> 	if (phydev->link)
> 		fec_enet_eee_mode_set(ndev, phydev->eee_active);
> 
> or, execute phy_ethtool_set_eee() first and some how detect if link
> changed? Or restart link by phylib on every change?

The whole startup sequence needs looking at, and ties in with the
phy_supports_eee() call we need to add. Given that EEE is broken with
most MAC drivers, i thought we could do that in a follow up patch
series.

As Russell says, we want to avoid multiple auto-neg cycles. Ideally we
want phy_supports_eee() to be called before phy_start() so that EEE
advertisement is set correctly for the first auto-neg. What is missing
from many MAC drivers is a default value from the LPI timer. It seems
like the need eee_set() has to be called with a value, or they are
relying on hardware reset values. Maybe we need to define a default?

We also need to discuss policy of if EEE should be enabled by default
for those systems which support it. As you have pointed out, it can
effect PTP quality.

   Andrew
