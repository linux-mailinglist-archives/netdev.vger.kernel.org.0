Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14541577160
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 22:17:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230059AbiGPURr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jul 2022 16:17:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbiGPURq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Jul 2022 16:17:46 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CF161D33D;
        Sat, 16 Jul 2022 13:17:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=6/LpxNTgfIFVpFyT+1SyAzsuJadiHFoxBMUFer3AfIY=; b=J7bVVD7ZP6L2tVzSkC88sqaGAO
        JZuVTg10klYERKYYqGzwcDMLxwF4SvR/AtT9uUtd54UBe4teBnYGgvBhxxtWEmT0Lp0Uu4FgEBvzu
        oVltpqfw38PYtPm6z3iR+8BVQJPHGQ5phg1voIt0URz+E2Akn+6vR1de7MshiZTXkbgA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oCoEE-00AZYJ-P2; Sat, 16 Jul 2022 22:17:30 +0200
Date:   Sat, 16 Jul 2022 22:17:30 +0200
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
Subject: Re: [PATCH net-next v3 10/47] net: phylink: Adjust link settings
 based on rate adaptation
Message-ID: <YtMc2qYWKRn2PxRY@lunn.ch>
References: <20220715215954.1449214-1-sean.anderson@seco.com>
 <20220715215954.1449214-11-sean.anderson@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220715215954.1449214-11-sean.anderson@seco.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 15, 2022 at 05:59:17PM -0400, Sean Anderson wrote:
> If the phy is configured to use pause-based rate adaptation, ensure that
> the link is full duplex with pause frame reception enabled. Note that these
> settings may be overridden by ethtool.
> 
> Signed-off-by: Sean Anderson <sean.anderson@seco.com>
> ---
> 
> Changes in v3:
> - New
> 
>  drivers/net/phy/phylink.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
> index 7fa21941878e..7f65413aa778 100644
> --- a/drivers/net/phy/phylink.c
> +++ b/drivers/net/phy/phylink.c
> @@ -1445,6 +1445,10 @@ static void phylink_phy_change(struct phy_device *phydev, bool up)
>  	pl->phy_state.speed = phy_interface_speed(phydev->interface,
>  						  phydev->speed);
>  	pl->phy_state.duplex = phydev->duplex;
> +	if (phydev->rate_adaptation == RATE_ADAPT_PAUSE) {
> +		pl->phy_state.duplex = DUPLEX_FULL;
> +		rx_pause = true;
> +	}

I would not do this. If the requirements for rate adaptation are not
fulfilled, you should turn off rate adaptation.

A MAC which knows rate adaptation is going on can help out, by not
advertising 10Half, 100Half etc. Autoneg will then fail for modes
where rate adaptation does not work.

The MAC should also be declaring what sort of pause it supports, so
disable rate adaptation if it does not have async pause.

      Andrew
