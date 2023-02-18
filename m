Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0144F69B7A0
	for <lists+netdev@lfdr.de>; Sat, 18 Feb 2023 03:00:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229557AbjBRCAf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 21:00:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjBRCAe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 21:00:34 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 964176745E
        for <netdev@vger.kernel.org>; Fri, 17 Feb 2023 18:00:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=xX7a0M5VbP8WILhfcVjNFoPfVthkkFOEGpJoAd8NDdY=; b=SOuNWWvwQmqVaYhy9fUhxNRvRc
        a0OP/fyyoGWe/OA9JfNaQ/mkC3JCOtbil1gSe1c61qAGdahVaYdDJf3tR1ixsppqhmT3mYzLJxrgP
        pFqZWvsota15LaifHA8hUohmmTW7Hw2wq30gVjzGj5iR4tLi88MdyBnkxV6zdo6c0cSg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pTCWU-005MFG-0w; Sat, 18 Feb 2023 03:00:22 +0100
Date:   Sat, 18 Feb 2023 03:00:22 +0100
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
Message-ID: <Y/AxNuRjLsdXBZRl@lunn.ch>
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

I think moving tx_lpi_enabled into phylib will help here. phylib can
track if only this changes, and then call the adjust_link callback
without actually doing an auto neg is only that changes.

	Andrew
