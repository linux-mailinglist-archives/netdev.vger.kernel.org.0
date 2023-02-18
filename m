Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C838269B7AA
	for <lists+netdev@lfdr.de>; Sat, 18 Feb 2023 03:10:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229585AbjBRCKL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 21:10:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjBRCKK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 21:10:10 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B14E6ABE5
        for <netdev@vger.kernel.org>; Fri, 17 Feb 2023 18:10:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=uUzAq4I0XT9AU9m4owdR0rHtzJXhqA+DSxedsIgNbX4=; b=599+r5PhO7TDf3aWSFWTwEXtVm
        AALSms8BLWVJBq9Uqi6K8MzN1/XCz3b5GzlM7KWWSDGci7q8e9TiV6QfT2KbQ9i84T3rRmHVd7ylh
        9O6z7rYWCvOk35M9psYQKgK/qz5zoSoaSsFWpmfaNPRwMyE0Z/pFf/frDheUO334ilgk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pTCfr-005MHN-1T; Sat, 18 Feb 2023 03:10:03 +0100
Date:   Sat, 18 Feb 2023 03:10:03 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
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
        Woojung Huh <woojung.huh@microchip.com>,
        Oleksij Rempel <linux@rempel-privat.de>
Subject: Re: [PATCH RFC 12/18] net: dsa: mt7530: Call phylib for set_eee and
 get_eee
Message-ID: <Y/Aze42t1EfVwsJg@lunn.ch>
References: <20230217034230.1249661-1-andrew@lunn.ch>
 <20230217034230.1249661-13-andrew@lunn.ch>
 <Y+9pcRoCK+hUpJvc@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y+9pcRoCK+hUpJvc@shell.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

 On Fri, Feb 17, 2023 at 11:48:01AM +0000, Russell King (Oracle) wrote:
> On Fri, Feb 17, 2023 at 04:42:24AM +0100, Andrew Lunn wrote:
> > phylib should be called in order to manage the EEE settings in the
> > PHY, and to return EEE status such are supported link modes, and what
> > the link peer supports.
> > 
> > Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> > ---
> >  drivers/net/dsa/mt7530.c | 6 ++++++
> >  1 file changed, 6 insertions(+)
> > 
> > diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
> > index 214450378978..a472353f14f8 100644
> > --- a/drivers/net/dsa/mt7530.c
> > +++ b/drivers/net/dsa/mt7530.c
> > @@ -3124,10 +3124,13 @@ static int mt753x_get_mac_eee(struct dsa_switch *ds, int port,
> >  {
> >  	struct mt7530_priv *priv = ds->priv;
> >  	u32 eeecr = mt7530_read(priv, MT7530_PMEEECR_P(port));
> > +	struct dsa_port *dp = dsa_to_port(ds, port);
> >  
> >  	e->tx_lpi_enabled = !(eeecr & LPI_MODE_EN);
> >  	e->tx_lpi_timer = GET_LPI_THRESH(eeecr);
> >  
> > +	if (dp->slave->phydev)
> > +		return phy_ethtool_get_eee(dp->slave->phydev, e);
> 
> Given that DSA makes use of phylink, is there a reason why we can't use
> the phylink wrappers here (which may allow for future EEE improvements,
> e.g. moving the gating of EEE with the TX LPI enable) ?

Turns out this is pointless. dsa_slave_get_eee() and
dsa_slave_set_eee() already make calls to phylink_ethtool_get_eee()
and phylink_ethtool_set_eee() after calling into the DSA driver.

So i will drop this patch, and the b53 change.

   Andrew
