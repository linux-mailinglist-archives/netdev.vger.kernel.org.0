Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1793769AD63
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 15:10:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229708AbjBQOKY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 09:10:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbjBQOKX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 09:10:23 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD3576747B
        for <netdev@vger.kernel.org>; Fri, 17 Feb 2023 06:10:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=hXmXl3z5B9ETxz17wZ06EClI5WBnn5XBhY0f6UhTXqk=; b=sTrJUzgspoAtA1LxHajKbvH6oj
        akGV6RH+2rtqTaVNiLUtxjphAvjCD7mY6lZyDesDrHUIZr5ddfAmM3eFW8nyiGBkU0Y48gp13qqIA
        JdeBlPMDUvsh47+mWVsgUB1eE31FxYPw7B0TffRA3ZH8Ng1W+7oy/Mms5EESHISKroJk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pT1RD-005I3r-VE; Fri, 17 Feb 2023 15:10:11 +0100
Date:   Fri, 17 Feb 2023 15:10:11 +0100
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
Message-ID: <Y++Kw6ayQLnsAQRr@lunn.ch>
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
> the phylink wrappers here

Ah, yes, phylink_foo would make a lot of sense. I will fix in the next
version.

> > @@ -3146,6 +3150,8 @@ static int mt753x_set_mac_eee(struct dsa_switch *ds, int port,
> >  		set |= LPI_MODE_EN;
> >  	mt7530_rmw(priv, MT7530_PMEEECR_P(port), mask, set);
> >  
> > +	if (dp->slave->phydev)
> > +		return phy_ethtool_set_eee(dp->slave->phydev, e);
> >  	return 0;
> 
> 
> Is this the correct place to do the set_eee operation - I mean, the
> register state has been altered (and it looks like it may enable LPI
> irrespective of the negotiated state) but what concerns me is that
> phy_ethtool_set_eee() can fail, and we return failure to userspace
> yet we've modified register state.

There is currently no consistency here between drivers. Some make this
call last, some do it earlier.

Thinking aloud...

Why would it fail? Most error reports are that phy_read() or
phy_write() failed. If that happens, the hardware is in an
inconsistent state anyway. It could be the PHY does not support
EEE. So an -EOPNOTSUPP or similar could be returned here. So long as
phydev->eee_active is never true, it should not matter if the value of
the LPI timer is changed here, it should never be put into use.  Are
there other cases where it could fail?

Maybe we should make the order in MAC set_eee() function
consistent. It is just a bigger change...

	    Andrew
