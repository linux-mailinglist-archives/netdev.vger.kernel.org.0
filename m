Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C93A69AAB8
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 12:48:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229771AbjBQLsL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 06:48:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229607AbjBQLsK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 06:48:10 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C2192B091
        for <netdev@vger.kernel.org>; Fri, 17 Feb 2023 03:48:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=rRfbwa4XGp1tB6EPgcjhncfswhgNIHFHYRTBx0Qtpc0=; b=FOp9H52adHrlhPfhqSxpKvo/J1
        HU0cdqHynhYvgmiuZOTDCYtLuwg4+ep7Bedxctnag+vR8omE7xGDJeCXZjP0Z9FnyL6R63yeKwDIa
        i2Kz8oVMfLR+CjnUAFJLbAb2780eJ6CR8/h0Q6qbXp6BsWmB7knLD578fB34CSMpdZrFmQfoAVAWa
        NB7PHM6bf4UUV+Z+ncgk1i5g1dwtEeKw+OonCVtQh5PSw1hMBeqE+57KdrRZpVJX5PiAI1FQMSsLd
        ha/bTSR+YQFHF28Solc0C4BbAyDnUgWd/1ZRfHFqvpYieX5T3bf80u7ZamgR5m4UCfFIm7F2+pbFN
        ZprlPP5g==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:33382)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pSzDh-0000sh-9H; Fri, 17 Feb 2023 11:48:05 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pSzDd-0006lq-OO; Fri, 17 Feb 2023 11:48:01 +0000
Date:   Fri, 17 Feb 2023 11:48:01 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
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
Message-ID: <Y+9pcRoCK+hUpJvc@shell.armlinux.org.uk>
References: <20230217034230.1249661-1-andrew@lunn.ch>
 <20230217034230.1249661-13-andrew@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230217034230.1249661-13-andrew@lunn.ch>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 17, 2023 at 04:42:24AM +0100, Andrew Lunn wrote:
> phylib should be called in order to manage the EEE settings in the
> PHY, and to return EEE status such are supported link modes, and what
> the link peer supports.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> ---
>  drivers/net/dsa/mt7530.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
> index 214450378978..a472353f14f8 100644
> --- a/drivers/net/dsa/mt7530.c
> +++ b/drivers/net/dsa/mt7530.c
> @@ -3124,10 +3124,13 @@ static int mt753x_get_mac_eee(struct dsa_switch *ds, int port,
>  {
>  	struct mt7530_priv *priv = ds->priv;
>  	u32 eeecr = mt7530_read(priv, MT7530_PMEEECR_P(port));
> +	struct dsa_port *dp = dsa_to_port(ds, port);
>  
>  	e->tx_lpi_enabled = !(eeecr & LPI_MODE_EN);
>  	e->tx_lpi_timer = GET_LPI_THRESH(eeecr);
>  
> +	if (dp->slave->phydev)
> +		return phy_ethtool_get_eee(dp->slave->phydev, e);

Given that DSA makes use of phylink, is there a reason why we can't use
the phylink wrappers here (which may allow for future EEE improvements,
e.g. moving the gating of EEE with the TX LPI enable) ?

> @@ -3146,6 +3150,8 @@ static int mt753x_set_mac_eee(struct dsa_switch *ds, int port,
>  		set |= LPI_MODE_EN;
>  	mt7530_rmw(priv, MT7530_PMEEECR_P(port), mask, set);
>  
> +	if (dp->slave->phydev)
> +		return phy_ethtool_set_eee(dp->slave->phydev, e);
>  	return 0;


Is this the correct place to do the set_eee operation - I mean, the
register state has been altered (and it looks like it may enable LPI
irrespective of the negotiated state) but what concerns me is that
phy_ethtool_set_eee() can fail, and we return failure to userspace
yet we've modified register state.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
