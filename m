Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2F27686C7F
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 18:12:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231786AbjBARMn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 12:12:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbjBARMm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 12:12:42 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D0B69EED;
        Wed,  1 Feb 2023 09:12:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=hGzG/sA63e+whllyzMxtyCU4dN4cHFGosz/XbA42Rbo=; b=QpRVxHzm/Z+iz1HHu18q5ar0Vg
        bytU7wJkj+A/7MJ2hijJHqPaSPHS8yMZBVyppjYl22azUXzXNZeJixr0tr8sdt0YhqH4FFtxqN/lG
        gX427TufG1zr5RTVRMP1Gusrm23fPQkN56hivbi1QA044K/AZ2laTtcN0WO9FbwuUFSo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pNGet-003ooW-4K; Wed, 01 Feb 2023 18:12:31 +0100
Date:   Wed, 1 Feb 2023 18:12:31 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Wei Fang <wei.fang@nxp.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Arun.Ramadoss@microchip.com, intel-wired-lan@lists.osuosl.org
Subject: Re: [PATCH net-next v4 02/23] net: phy: add
 genphy_c45_read_eee_abilities() function
Message-ID: <Y9qdfwlgQ48Rj1X3@lunn.ch>
References: <20230201145845.2312060-1-o.rempel@pengutronix.de>
 <20230201145845.2312060-3-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230201145845.2312060-3-o.rempel@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 01, 2023 at 03:58:24PM +0100, Oleksij Rempel wrote:
> Add generic function for EEE abilities defined by IEEE 802.3
> specification. For now following registers are supported:
> - IEEE 802.3-2018 45.2.3.10 EEE control and capability 1 (Register 3.20)
> - IEEE 802.3cg-2019 45.2.1.186b 10BASE-T1L PMA status register
>   (Register 1.2295)
> 
> Since I was not able to find any flag signaling support of this
> registers, we should detect link mode abilities first and then based on
> this abilities doing EEE link modes detection.

Hi Oleksij

There was a discussion along these lines with Chris Healy
recently. The meson-gxl PHYs don't have these registers, and reads
return 0xffff. The 802.3 2018 standard says the top 2 bits are
reserved and should read as 0. Also, it seems unlikely anybody will
build a PHY which supports 100GBASE-R deep sleep all the way down to
100BASE-TX EEE. So i would suggest adding a check when reading
MDIO_PCS_EEE_ABLE and if it is 0xffff assume EEE is not supported.

> +		val = phy_read_mmd(phydev, MDIO_MMD_PCS, MDIO_PCS_EEE_ABLE);
> +		if (val < 0)
> +			return val;
> +
> +		mii_eee_100_10000_adv_mod_linkmode_t(phydev->supported_eee, val);
> +
> +		/* Some buggy devices claim not supported EEE link modes */
> +		linkmode_and(phydev->supported_eee, phydev->supported_eee,
> +			     phydev->supported);

That comment could be improved. What i think you mean is

/* Some buggy devices indicate EEE link modes in MDIO_PCS_EEE_ABLE
   which they don't support as indicated by BMSR, ESTATUS etc. */

   Andrew
