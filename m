Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00F4465EEF4
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 15:41:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232239AbjAEOlD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 09:41:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233384AbjAEOlA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 09:41:00 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E51DCC30;
        Thu,  5 Jan 2023 06:40:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=VcmkmclKmW24sYOpS8HuiKKoxvXwxynwv/26mO7Ol30=; b=OYZqncrdNKyRrul8nw4C/ZHiR+
        C/P1hTz1qeTRCKP52NzSXLU16s+70WpAaKtpW/gTlCpbQ4HgnGuqcJIvs41vLCN+3ycsOAc1RVkRF
        /88uF2MKsPAFkj+65SwJDClk631M2cuGXFAGaov32Q84L3sni34D4JXA6a9EbWyGeTpCJiO49tZby
        78KdDfO7T0VZpGci2UNkBQIrimNMugNs5rwpf6mDnQCNzG29CcA7kdZHb3nNwBPN6p8TXUA/ZMeew
        0niHlhp32OOG4bzoDmZDfHtIVQCGhqtFrZ5gE8X7UxXTdUN5X0YTEO6KMpVYjWFV13Y96YkeI9w1Q
        PcPM1vPg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35978)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pDRQL-0007H2-9N; Thu, 05 Jan 2023 14:40:52 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pDRQI-00044L-75; Thu, 05 Jan 2023 14:40:50 +0000
Date:   Thu, 5 Jan 2023 14:40:50 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Sean Anderson <sean.anderson@seco.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Tim Harvey <tharvey@gateworks.com>
Subject: Re: [PATCH net-next v5 4/4] phy: aquantia: Determine rate adaptation
 support from registers
Message-ID: <Y7bhctPZoyNnw1ay@shell.armlinux.org.uk>
References: <20230103220511.3378316-1-sean.anderson@seco.com>
 <20230103220511.3378316-5-sean.anderson@seco.com>
 <20230105140421.bqd2aed6du5mtxn4@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230105140421.bqd2aed6du5mtxn4@skbuf>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 05, 2023 at 04:04:21PM +0200, Vladimir Oltean wrote:
> On Tue, Jan 03, 2023 at 05:05:11PM -0500, Sean Anderson wrote:
> >  static int aqr107_get_rate_matching(struct phy_device *phydev,
> >  				    phy_interface_t iface)
> >  {
> > -	if (iface == PHY_INTERFACE_MODE_10GBASER ||
> > -	    iface == PHY_INTERFACE_MODE_2500BASEX ||
> > -	    iface == PHY_INTERFACE_MODE_NA)
> > -		return RATE_MATCH_PAUSE;
> > -	return RATE_MATCH_NONE;
> > +	static const struct aqr107_link_speed_cfg speed_table[] = {
> > +		{
> > +			.speed = SPEED_10,
> > +			.reg = VEND1_GLOBAL_CFG_10M,
> > +			.speed_bit = MDIO_PMA_SPEED_10,
> > +		},
> > +		{
> > +			.speed = SPEED_100,
> > +			.reg = VEND1_GLOBAL_CFG_100M,
> > +			.speed_bit = MDIO_PMA_SPEED_100,
> > +		},
> > +		{
> > +			.speed = SPEED_1000,
> > +			.reg = VEND1_GLOBAL_CFG_1G,
> > +			.speed_bit = MDIO_PMA_SPEED_1000,
> > +		},
> > +		{
> > +			.speed = SPEED_2500,
> > +			.reg = VEND1_GLOBAL_CFG_2_5G,
> > +			.speed_bit = MDIO_PMA_SPEED_2_5G,
> > +		},
> > +		{
> > +			.speed = SPEED_5000,
> > +			.reg = VEND1_GLOBAL_CFG_5G,
> > +			.speed_bit = MDIO_PMA_SPEED_5G,
> > +		},
> > +		{
> > +			.speed = SPEED_10000,
> > +			.reg = VEND1_GLOBAL_CFG_10G,
> > +			.speed_bit = MDIO_PMA_SPEED_10G,
> > +		},
> > +	};
> > +	int speed = phy_interface_max_speed(iface);
> > +	bool got_one = false;
> > +	int i;
> > +
> > +	for (i = 0; i < ARRAY_SIZE(speed_table) &&
> > +		    speed_table[i].speed <= speed; i++) {
> > +		if (!aqr107_rate_adapt_ok(phydev, speed, &speed_table[i]))
> > +			return RATE_MATCH_NONE;
> > +		got_one = true;
> > +	}
> 
> Trying to wrap my head around the API for rate matching that was
> originally proposed and how it applies to what we read from Aquantia
> registers now.
> 
> IIUC, phylink (via the PHY library) asks "what kind of rate matching is
> supported for this SERDES protocol?". It doesn't ask "via what kind of
> rate matching can this SERDES protocol support this particular media
> side speed?".
> 
> Your code walks through the speed_table[] of media speeds (from 10M up
> until the max speed of the SERDES) and sees whether the PHY was
> provisioned, for that speed, to use PAUSE rate adaptation.
> 
> If the PHY firmware uses a combination like this: 10GBASE-R/XFI for
> media speeds of 10G, 5G, 2.5G (rate adapted), and SGMII for 1G, 100M
> and 10M, a call to your implementation of
> aqr107_get_rate_matching(PHY_INTERFACE_MODE_10GBASER) would return
> RATE_MATCH_NONE, right? So only ETHTOOL_LINK_MODE_10000baseT_Full_BIT
> would be advertised on the media side?

No, beause of the special condition in phylink that if it's a clause 45
PHY and we use something like 10GBASE-R, we don't limit to just 10G
speed, but try all interface modes - on the assumption that the PHY
will switch its host interface.

RATE_MATCH_NONE doesn't state anything about whether the PHY operates
in a single interface mode or not - with 10G PHYs (and thus clause 45
PHYs) it seems very common from current observations for
implementations to do this kind of host-interface switching.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
