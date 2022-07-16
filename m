Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B314577137
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 21:40:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232170AbiGPTju (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jul 2022 15:39:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbiGPTjt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Jul 2022 15:39:49 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC0D3140A8;
        Sat, 16 Jul 2022 12:39:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=LtAtzCZ8cJhp8hFf9hMUPei/xAdhBC+XgYV77Uq9zYg=; b=YznQjFgd0fk/tF9iA6Yg9Xs1a+
        sGg2QRsnbTm4gU896SJ/a2Oq1PN1C9xSt3N7My9hmdSxS2cv0hG/SabHxT5Izk7frk4E5c6pVnN8j
        13WII0yIuYfyc0HLtOa4N7htN9NFjT1Nqf3V+nQBDK8Z05iWM0jgtvTiEboUsf04X/5E=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oCndR-00AZPu-Sb; Sat, 16 Jul 2022 21:39:29 +0200
Date:   Sat, 16 Jul 2022 21:39:29 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        linux-arm-kernel@lists.infradead.org,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH net-next v3 07/47] net: phy: Add support for rate
 adaptation
Message-ID: <YtMT8V4PNkxJ9lMm@lunn.ch>
References: <20220715215954.1449214-1-sean.anderson@seco.com>
 <20220715215954.1449214-8-sean.anderson@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220715215954.1449214-8-sean.anderson@seco.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>  drivers/net/phy/phy.c | 21 +++++++++++++++++++++
>  include/linux/phy.h   | 38 ++++++++++++++++++++++++++++++++++++++
>  2 files changed, 59 insertions(+)
> 
> diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
> index 8d3ee3a6495b..cf4a8b055a42 100644
> --- a/drivers/net/phy/phy.c
> +++ b/drivers/net/phy/phy.c
> @@ -114,6 +114,27 @@ void phy_print_status(struct phy_device *phydev)
>  }
>  EXPORT_SYMBOL(phy_print_status);
>  
> +/**
> + * phy_get_rate_adaptation - determine if rate adaptation is supported
> + * @phydev: The phy device to return rate adaptation for
> + * @iface: The interface mode to use
> + *
> + * This determines the type of rate adaptation (if any) that @phy supports
> + * using @iface. @iface may be %PHY_INTERFACE_MODE_NA to determine if any
> + * interface supports rate adaptation.
> + *
> + * Return: The type of rate adaptation @phy supports for @iface, or
> + *         %RATE_ADAPT_NONE.
> + */
> +enum rate_adaptation phy_get_rate_adaptation(struct phy_device *phydev,
> +					     phy_interface_t iface)
> +{
> +	if (phydev->drv->get_rate_adaptation)
> +		return phydev->drv->get_rate_adaptation(phydev, iface);

It is normal that any call into the driver is performed with the
phydev->lock held.

>  #define PHY_INIT_TIMEOUT	100000
>  #define PHY_FORCE_TIMEOUT	10
> @@ -570,6 +588,7 @@ struct macsec_ops;
>   * @lp_advertising: Current link partner advertised linkmodes
>   * @eee_broken_modes: Energy efficient ethernet modes which should be prohibited
>   * @autoneg: Flag autoneg being used
> + * @rate_adaptation: Current rate adaptation mode
>   * @link: Current link state
>   * @autoneg_complete: Flag auto negotiation of the link has completed
>   * @mdix: Current crossover
> @@ -637,6 +656,8 @@ struct phy_device {
>  	unsigned irq_suspended:1;
>  	unsigned irq_rerun:1;
>  
> +	enum rate_adaptation rate_adaptation;

It is not clear what the locking is on this member. Is it only safe to
access it during the adjust_link callback, when it is guaranteed that
the phydev->lock is held, so the value is consistent? Or is the MAC
allowed to access this at other times?

	Andrew
