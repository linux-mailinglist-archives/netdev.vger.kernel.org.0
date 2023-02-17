Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBB2069AD3E
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 14:58:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229968AbjBQN6g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 08:58:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229962AbjBQN6e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 08:58:34 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D6846241E
        for <netdev@vger.kernel.org>; Fri, 17 Feb 2023 05:58:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=9leBYnbjsGjYfUc8WA8c1bY9xOuxVd2LhKhWB714CvQ=; b=yThcf/FsRxp7QvGsqqARWSTJy7
        Uec1Bf8dGQbX/ZcUH4J8XiXzMYR+2MJmnXfVoIVJYz3XYHX7EcRZW6glRu1oPhaEdCj6fY4aQi5vu
        3C827POwX8cL4BWG+zccocRFVYL1JN2Fo8pVDrgRBV25VH44GBl+nSShmfGQrwKmOM8w=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pT0v7-005Hq6-Ap; Fri, 17 Feb 2023 14:37:01 +0100
Date:   Fri, 17 Feb 2023 14:37:01 +0100
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
Subject: Re: [PATCH RFC 01/18] net: phy: Add phydev->eee_active to simplify
 adjust link callbacks
Message-ID: <Y++C/dklM39jjOeT@lunn.ch>
References: <20230217034230.1249661-1-andrew@lunn.ch>
 <20230217034230.1249661-2-andrew@lunn.ch>
 <Y+9mv0E9pca1tuPP@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y+9mv0E9pca1tuPP@shell.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 17, 2023 at 11:36:31AM +0000, Russell King (Oracle) wrote:
> On Fri, Feb 17, 2023 at 04:42:13AM +0100, Andrew Lunn wrote:
> > MAC drivers which support EEE need to know the results of the EEE
> > auto-neg in order to program the hardware to perform EEE or not.  The
> > oddly named phy_init_eee() can be used to determine this, it returns 0
> > if EEE should be used, or a negative error code,
> > e.g. -EOPPROTONOTSUPPORT if the PHY does not support EEE or negotiate
> > resulted in it not being used.
> > 
> > However, many MAC drivers get this wrong. Add phydev->eee_active which
> > indicates the result of the autoneg for EEE, including if EEE is
> > administratively disabled with ethtool. The MAC driver can then access
> > this in the same way as link speed and duplex in the adjust link
> > callback.
> > 
> > Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> 
> Yay!
> 
> Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Hi Russell

I did wonder about making this a parameter for phylink mac up
callback, rather than having the driver look inside phydev. It is
something which can be done later.

	  Andrew
