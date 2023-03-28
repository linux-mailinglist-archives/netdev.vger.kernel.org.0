Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E6A26CBEA2
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 14:09:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232696AbjC1MJx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 08:09:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232964AbjC1MJv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 08:09:51 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63AB87EFD
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 05:09:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=ck6rFUFpw8nxBkW5K/L6cGTlnT+AqIgiTN0/BuVaz9s=; b=LulFpZl8m6l0xYTEEdqfD/J1In
        s8/nLaYp9i7zMbDh+it9eBgTn5ro3Zf8fOhCmUzCJo1/VOhTgXJGtgN/dKH9MFyFTGX45QCtbmbus
        N+Fu62o5gXcOKXovrLBI6rS9BQe0Gjrf9h8LbBvRQJ7X2JvPYVPQRuqa/rNP9WO25hvw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ph896-008dpY-De; Tue, 28 Mar 2023 14:09:48 +0200
Date:   Tue, 28 Mar 2023 14:09:48 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>
Subject: Re: [RFC/RFT 03/23] net: phy: Add helper to set EEE Clock stop
 enable bit
Message-ID: <185fa856-0832-409c-84e6-357f4d14da3c@lunn.ch>
References: <20230327170201.2036708-1-andrew@lunn.ch>
 <20230327170201.2036708-4-andrew@lunn.ch>
 <20230328050327.GB15196@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230328050327.GB15196@pengutronix.de>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > + */
> > +int phy_eee_clk_stop_enable(struct phy_device *phydev)
> 
> this function should go to drivers/net/phy/phy-c45.c
> and renamed to genphy_c45_eee_clk_stop_enable()
> > +{
> > +	int ret;
> > +
> > +	mutex_lock(&phydev->lock);
> 
> 	/* IEEE 802.3-2018 45.2.3.1.4 Clock stop enable (3.0.10) */
> 
> > +	ret = phy_set_bits_mmd(phydev, MDIO_MMD_PCS, MDIO_CTRL1,
> > +			       MDIO_PCS_CTRL1_CLKSTOP_EN);
> 
> It would be better to write it conditionally. Only if EEE is supported
> and only if this bit is supported as well. Support is indicated by the
> IEEE 802.3:2018 - 45.2.3.2.6 Clock stop capable (3.1.6)

O.K, i was too lazy. I just took the existing code in phy_eee_init()
and moved it here. I can rework it as requested.

> It looks like there are other registers for same functionality too but
> other types of PHYs:
> 45.2.4.1.4 Clock stop enable (4.0.10)
> 45.2.4.2.6 Clock stop capable (4.1.6)
> 45.2.5.1.4 Clock stop enable (5.0.10)
> 45.2.5.2.6 Clock stop capable (5.1.6)
> 
> If I see it correctly, Clock-stop is possible only for GMII/RGMII.
> Integrated PHYs or EEE capable PHYs with RMII do not support it.

For the existing code, it is up to the MAC to decide if the clock
should be stopped. It is not clear why, but we do see some MACs where
the DMA engine stops working when the clock is stopped. So i don't
want to be overly eager to stop clocks and introduce regressions.  So
i will keep with just one clock above. But make it conditional on the
capability.

	Andrew

