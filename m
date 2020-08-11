Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16393241D04
	for <lists+netdev@lfdr.de>; Tue, 11 Aug 2020 17:15:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728873AbgHKPP4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Aug 2020 11:15:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728833AbgHKPP4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Aug 2020 11:15:56 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0DBAC06174A
        for <netdev@vger.kernel.org>; Tue, 11 Aug 2020 08:15:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=M6Q6LOO2ym31+7V4vV2Yhh5vHmWcZpg3m8MwrvtUBo8=; b=Xg9C5Tr7N5ASs5q+Ji8P4gTfK
        r6gb2eaJgDnD9w/J/rad1zuE/RDU8DQXts5jeVhATpMfDyKWKlHgyFyfbui3/njVhQvNCGBGIJA+1
        kWZQ4yd2DIA+vFy3Mus2RzCOVG+G5VVP11jvgiIdjDgTXI8px+q2EVfXG1tNAmCYshWhHQIYQ9Gp4
        Zjbclpd7tp7DhlMnXq+G9d5O22X/nixXcn3UgL3V5q4ARL5aFdFChL4Kn0ZH0wyuJGL+YNwpaTwaD
        oOrXSD94YHy38pTuCTmRhQX8io6yKX9TmOPYj8BUCe99sjBa85CQHU1okq5VwU+eBaqtfvijolV7a
        +4aSVrkRg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:51188)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1k5W0H-0001Za-Bn; Tue, 11 Aug 2020 16:15:53 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1k5W0H-0002uW-4T; Tue, 11 Aug 2020 16:15:53 +0100
Date:   Tue, 11 Aug 2020 16:15:53 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <marek.behun@nic.cz>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Baruch Siach <baruch@tkos.co.il>,
        Chris Healy <cphealy@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH RFC russell-king 2/4] net: phy: sfp: add support for
 multigig RollBall modules
Message-ID: <20200811151552.GM1551@shell.armlinux.org.uk>
References: <20200810220645.19326-1-marek.behun@nic.cz>
 <20200810220645.19326-3-marek.behun@nic.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200810220645.19326-3-marek.behun@nic.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 11, 2020 at 12:06:43AM +0200, Marek Behún wrote:
> This adds support for multigig copper SFP modules from RollBall/Hilink.
> These modules have a specific way to access clause 45 registers of the
> internal PHY.
> 
> We also need to wait at least 25 seconds after deasserting TX disable
> before accessing the PHY. The code waits for 30 seconds just to be sure.

I wonder why it takes so long - the 88x3310 boots very quickly.

> +static int sfp_i2c_mii_probe(struct sfp *sfp)
> +{
> +	struct mii_bus *i2c_mii;
> +	int ret;
> +
> +	if (sfp->rollball_mii)
> +		i2c_mii = mdio_i2c_rollball_alloc(sfp->dev, sfp->i2c);
> +	else
> +		i2c_mii = mdio_i2c_alloc(sfp->dev, sfp->i2c);
> +

I think I'd prefer to find a way to teach the existing mdio_i2c code
about different protocols rather than having a load of different buses
that we have to select between.  Maybe we can do that via the PHY
address, or maybe we should have a call into mdio_i2c that tells it
which protocol should be used?

The reason I don't like this approach is it seems to me to be very
heavy handed... using a sledge hammer to crack a nut.

> +	rollball = (!memcmp(id.base.vendor_name, "OEM             ", 16) &&
> +		    (!memcmp(id.base.vendor_pn, "SFP-10G-T       ", 16) ||
> +		     !memcmp(id.base.vendor_pn, "RTSFP-10        ", 16) ||
> +		     !memcmp(id.base.vendor_pn, "RTSFP-2.5G      ", 16)));
> +	if (rollball) {
> +		/* TODO: try to write this to EEPROM */
> +		id.base.extended_cc = SFF8024_ECC_10GBASE_T_SFI;

Should we really be "fixing" vendors EEPROMs for them?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
