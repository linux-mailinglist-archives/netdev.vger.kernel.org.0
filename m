Return-Path: <netdev+bounces-3867-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 19CCA7094BF
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 12:27:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3CB4E281BC3
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 10:27:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C9E46FD9;
	Fri, 19 May 2023 10:27:36 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D9726AA4
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 10:27:35 +0000 (UTC)
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B08D5E6B
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 03:27:30 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
	by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <ore@pengutronix.de>)
	id 1pzxKa-0007jH-Qj; Fri, 19 May 2023 12:27:28 +0200
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
	(envelope-from <ore@pengutronix.de>)
	id 1pzxKY-0004SC-Tz; Fri, 19 May 2023 12:27:26 +0200
Date: Fri, 19 May 2023 12:27:26 +0200
From: Oleksij Rempel <o.rempel@pengutronix.de>
To: Andrew Lunn <andrew@lunn.ch>
Cc: netdev <netdev@vger.kernel.org>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Russell King <rmk+kernel@armlinux.org.uk>,
	Oleksij Rempel <linux@rempel-privat.de>
Subject: Re: [RFC/RFTv3 12/24] net: FEC: Fixup EEE
Message-ID: <20230519102726.GC8586@pengutronix.de>
References: <20230331005518.2134652-1-andrew@lunn.ch>
 <20230331005518.2134652-13-andrew@lunn.ch>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230331005518.2134652-13-andrew@lunn.ch>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Mar 31, 2023 at 02:55:06AM +0200, Andrew Lunn wrote:
> The enabling/disabling of EEE in the MAC should happen as a result of
> auto negotiation. So move the enable/disable into
> fec_enet_adjust_link() which gets called by phylib when there is a
> change in link status.
> 
> fec_enet_set_eee() now just stores away the LTI timer value.
> Everything else is passed to phylib, so it can correctly setup the
> PHY.
> 
> fec_enet_get_eee() relies on phylib doing most of the work,
> the MAC driver just adds the LTI timer value.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>

Tested on imx8mp based debix mode a board.

Tested-by: Oleksij Rempel <o.rempel@pengutronix.de>

> ---
> v2: Only call fec_enet_eee_mode_set for those that support EEE
> ---
>  drivers/net/ethernet/freescale/fec_main.c | 28 ++++-------------------
>  1 file changed, 4 insertions(+), 24 deletions(-)
> 
> diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
> index 462755f5d33e..fda1f9ff32b9 100644
> --- a/drivers/net/ethernet/freescale/fec_main.c
> +++ b/drivers/net/ethernet/freescale/fec_main.c
> @@ -1930,18 +1930,13 @@ static int fec_enet_us_to_tx_cycle(struct net_device *ndev, int us)
>  	return us * (fep->clk_ref_rate / 1000) / 1000;
>  }
>  
> -static int fec_enet_eee_mode_set(struct net_device *ndev, bool enable)
> +static int fec_enet_eee_mode_set(struct net_device *ndev, bool eee_active)
>  {
>  	struct fec_enet_private *fep = netdev_priv(ndev);
>  	struct ethtool_eee *p = &fep->eee;
>  	unsigned int sleep_cycle, wake_cycle;
> -	int ret = 0;
> -
> -	if (enable) {
> -		ret = phy_init_eee(ndev->phydev, false);
> -		if (ret)
> -			return ret;
>  
> +	if (eee_active) {
>  		sleep_cycle = fec_enet_us_to_tx_cycle(ndev, p->tx_lpi_timer);
>  		wake_cycle = sleep_cycle;
>  	} else {
> @@ -1949,10 +1944,6 @@ static int fec_enet_eee_mode_set(struct net_device *ndev, bool enable)
>  		wake_cycle = 0;
>  	}
>  
> -	p->tx_lpi_enabled = enable;
> -	p->eee_enabled = enable;
> -	p->eee_active = enable;
> -
>  	writel(sleep_cycle, fep->hwp + FEC_LPI_SLEEP);
>  	writel(wake_cycle, fep->hwp + FEC_LPI_WAKE);
>  
> @@ -1997,6 +1988,8 @@ static void fec_enet_adjust_link(struct net_device *ndev)
>  			netif_tx_unlock_bh(ndev);
>  			napi_enable(&fep->napi);
>  		}
> +		if (fep->quirks & FEC_QUIRK_HAS_EEE)
> +			fec_enet_eee_mode_set(ndev, phy_dev->eee_active);
>  	} else {
>  		if (fep->link) {
>  			napi_disable(&fep->napi);
> @@ -3109,10 +3102,7 @@ fec_enet_get_eee(struct net_device *ndev, struct ethtool_eee *edata)
>  	if (!netif_running(ndev))
>  		return -ENETDOWN;
>  
> -	edata->eee_enabled = p->eee_enabled;
> -	edata->eee_active = p->eee_active;
>  	edata->tx_lpi_timer = p->tx_lpi_timer;
> -	edata->tx_lpi_enabled = p->tx_lpi_enabled;
>  
>  	return phy_ethtool_get_eee(ndev->phydev, edata);
>  }
> @@ -3122,7 +3112,6 @@ fec_enet_set_eee(struct net_device *ndev, struct ethtool_eee *edata)
>  {
>  	struct fec_enet_private *fep = netdev_priv(ndev);
>  	struct ethtool_eee *p = &fep->eee;
> -	int ret = 0;
>  
>  	if (!(fep->quirks & FEC_QUIRK_HAS_EEE))
>  		return -EOPNOTSUPP;
> @@ -3132,15 +3121,6 @@ fec_enet_set_eee(struct net_device *ndev, struct ethtool_eee *edata)
>  
>  	p->tx_lpi_timer = edata->tx_lpi_timer;
>  
> -	if (!edata->eee_enabled || !edata->tx_lpi_enabled ||
> -	    !edata->tx_lpi_timer)
> -		ret = fec_enet_eee_mode_set(ndev, false);
> -	else
> -		ret = fec_enet_eee_mode_set(ndev, true);
> -
> -	if (ret)
> -		return ret;
> -
>  	return phy_ethtool_set_eee(ndev->phydev, edata);
>  }
>  
> -- 
> 2.40.0
> 
> 

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

