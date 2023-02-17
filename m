Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8263A69AD3D
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 14:58:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229965AbjBQN6e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 08:58:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229959AbjBQN6d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 08:58:33 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A12E65356
        for <netdev@vger.kernel.org>; Fri, 17 Feb 2023 05:58:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=xkxx+fLJSyq7rthD4G6wtdqqL1Gp4p1ux0tfkxjQ0bA=; b=qXAco7hDCnfyJeoW3V4mf84Cya
        J1ppeb/D+VKYMhTbVxv7D6MEJzHACMsDSN04cuS5I1SzlJAKB0wxJ4DlqkaSD73kSV87Oy7ItG8i+
        O91Nj6ujVe4ntJpLmCd2+TnkP9bApmGhGUH7q/OtfnqdEEg9oGeu5AIEacIKyZgmbtXQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pT13G-005HuG-Ar; Fri, 17 Feb 2023 14:45:26 +0100
Date:   Fri, 17 Feb 2023 14:45:26 +0100
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
Subject: Re: [PATCH RFC 03/18] net: marvell: mvneta: Simplify EEE
 configuration
Message-ID: <Y++E9gq63oWRpVYM@lunn.ch>
References: <20230217034230.1249661-1-andrew@lunn.ch>
 <20230217034230.1249661-4-andrew@lunn.ch>
 <Y+9sK/yN7JmQyTl0@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y+9sK/yN7JmQyTl0@shell.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 17, 2023 at 11:59:39AM +0000, Russell King (Oracle) wrote:
> On Fri, Feb 17, 2023 at 04:42:15AM +0100, Andrew Lunn wrote:
> > @@ -4221,10 +4218,8 @@ static void mvneta_mac_link_up(struct phylink_config *config,
> >  
> >  	mvneta_port_up(pp);
> >  
> > -	if (phy && pp->eee_enabled) {
> > -		pp->eee_active = phy_init_eee(phy, false) >= 0;
> > -		mvneta_set_eee(pp, pp->eee_active && pp->tx_lpi_enabled);
> > -	}
> > +	if (phy)
> > +		mvneta_set_eee(pp, phy->eee_active && pp->tx_lpi_enabled);
> 
> Thinking about this a bit more, I'm not convinced this is properly safe.
> What protects phy->eee_active from changing here? The phydev mutex won't
> be held at this point.

That is one of the differences between phylib and phylink. For phylib,
the adjust_link callback is performed while holding phydev lock. So it
is guaranteed to be consistent.

> It's way more invasive, as it requires the mac_link_up() method
> signature to change, but I think it would be a cleaner approach
> overall.

Yes, i think it has to happen. But i also think it will have a
beneficial side effect. Very few MAC drivers implement EEE. Having
this parameters will make it much more visible, which could lead to
more MAC drivers adding EEE support.

     Andrew
