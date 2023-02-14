Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD08E6964A7
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 14:26:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232382AbjBNN0s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 08:26:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231827AbjBNN0r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 08:26:47 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0552B13C;
        Tue, 14 Feb 2023 05:26:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=0rJ9a1FHbwi1I90TwyTMSs5JQSie7vEdBnAR3P/wp4I=; b=Ud82zC1I92DfUGlh6nIhnZv3Cf
        AWyOW6/b/5b42TUQ9xiA5lzfPWYbDZyrv/MNMOk7xxWh6/TMiaUDAy1/AneLzvbXmZ1bbV+kNskL0
        pYY0oj1Vc/VSlRHDL/4gE4mHq7BphSRgjf8Ap+PotaMatyC4tI2X8yK+bfDCued5D76o=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pRvKO-004x2p-8v; Tue, 14 Feb 2023 14:26:36 +0100
Date:   Tue, 14 Feb 2023 14:26:36 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Wei Fang <wei.fang@nxp.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Shenwei Wang <shenwei.wang@nxp.com>,
        Clark Wang <xiaoning.wang@nxp.com>,
        NXP Linux Team <linux-imx@nxp.com>
Subject: Re: [PATCH net-next v1 7/7] net: fec: add support for PHYs with
 SmartEEE support
Message-ID: <Y+uMDEyWW15gerN0@lunn.ch>
References: <20230214090314.2026067-1-o.rempel@pengutronix.de>
 <20230214090314.2026067-8-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230214090314.2026067-8-o.rempel@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 14, 2023 at 10:03:14AM +0100, Oleksij Rempel wrote:
> Ethernet controller in i.MX6*/i.MX7* series do not provide EEE support.
> But this chips are used sometimes in combinations with SmartEEE capable
> PHYs.
> So, instead of aborting get/set_eee access on MACs without EEE support,
> ask PHY if it is able to do the EEE job by using SmartEEE.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---
>  drivers/net/ethernet/freescale/fec_main.c | 22 ++++++++++++++++++----
>  1 file changed, 18 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
> index c73e25f8995e..00f3703db69d 100644
> --- a/drivers/net/ethernet/freescale/fec_main.c
> +++ b/drivers/net/ethernet/freescale/fec_main.c
> @@ -3102,8 +3102,15 @@ fec_enet_get_eee(struct net_device *ndev, struct ethtool_eee *edata)
>  	struct fec_enet_private *fep = netdev_priv(ndev);
>  	struct ethtool_eee *p = &fep->eee;
>  
> -	if (!(fep->quirks & FEC_QUIRK_HAS_EEE))
> -		return -EOPNOTSUPP;
> +	if (!(fep->quirks & FEC_QUIRK_HAS_EEE)) {
> +		if (!netif_running(ndev))
> +			return -ENETDOWN;
> +
> +		if (!phy_has_smarteee(ndev->phydev))
> +			return -EOPNOTSUPP;
> +
> +		return phy_ethtool_get_eee(ndev->phydev, edata);
> +	}

I can see two different ways we do this. As you have here, we modify
every MAC driver which is paired to a SmartEEE PHY and have it call
into phylib. Or we modify the ethtool core, if it gets -EOPNOTSUPP,
and there is an ndev->phydev call directly into phylib. That should
make all boards with SmartEEE supported. We do this for a few calls,
TS Info, and SFP module info.

Either way, i don't think we need phy_has_smarteee() exposed outside
of phylib. SmartEEE is supposed to be transparent to the MAC, so it
should not need to care. Same as WOL, the MAC does not care if the PHY
supports WoL, it should just call the APIs to get and set WoL and
assume they do the right thing.

What is also unclear to me is how we negotiate between EEE and
SmartEEE. I assume if the MAC is EEE capable, we prefer that over
SmartEEE. But i don't think i've seen anything in these patches which
addresses this. Maybe we want phy_init_eee() to disable SmartEEE?

	  Andrew
