Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F87B69A6C3
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 09:19:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbjBQIT5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 03:19:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjBQIT4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 03:19:56 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C46635CF24
        for <netdev@vger.kernel.org>; Fri, 17 Feb 2023 00:19:52 -0800 (PST)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pSvyA-0003Wt-Kz; Fri, 17 Feb 2023 09:19:50 +0100
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pSvy3-0005bS-3M; Fri, 17 Feb 2023 09:19:43 +0100
Date:   Fri, 17 Feb 2023 09:19:43 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>
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
Message-ID: <20230217081943.GA9065@pengutronix.de>
References: <20230217034230.1249661-1-andrew@lunn.ch>
 <20230217034230.1249661-9-andrew@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230217034230.1249661-9-andrew@lunn.ch>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 17, 2023 at 04:42:20AM +0100, Andrew Lunn wrote:
> The enabling/disabling of EEE in the MAC should happen as a result of
> auto negotiation. So move the enable/disable into
> fec_enet_adjust_link() which gets called by phylib when there is a
> change in link status.
> 
> fec_enet_set_eee() now just stores away the LTI timer value and if TX
> LPI should be enabled. Everything else is passed to phylib, so it can
> correctly setup the PHY.
> 
> fec_enet_get_eee() relies on phylib doing most of the work,
> the MAC driver just adds the LTI timer value and the stored tx_lpi_enabled.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> ---
>  drivers/net/ethernet/freescale/fec_main.c | 27 ++++-------------------
>  1 file changed, 4 insertions(+), 23 deletions(-)
> 
> diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
> index 195df75ee614..5aca705876fe 100644
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
> +	if (eee_active && p->tx_lpi_enabled) {
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
> @@ -1997,6 +1988,7 @@ static void fec_enet_adjust_link(struct net_device *ndev)
>  			netif_tx_unlock_bh(ndev);
>  			napi_enable(&fep->napi);
>  		}
> +		fec_enet_eee_mode_set(ndev, phy_dev->eee_active);

Most of iMX variants do not support EEE. It should be something like this:
	if (fep->quirks & FEC_QUIRK_HAS_EEE)
		fec_enet_eee_mode_set(ndev, phy_dev->eee_active);

>  	} else {
>  		if (fep->link) {
>  			napi_disable(&fep->napi);
> @@ -3109,8 +3101,6 @@ fec_enet_get_eee(struct net_device *ndev, struct ethtool_eee *edata)
>  	if (!netif_running(ndev))
>  		return -ENETDOWN;
>  
> -	edata->eee_enabled = p->eee_enabled;
> -	edata->eee_active = p->eee_active;
>  	edata->tx_lpi_timer = p->tx_lpi_timer;
>  	edata->tx_lpi_enabled = p->tx_lpi_enabled;
>  
> @@ -3122,7 +3112,6 @@ fec_enet_set_eee(struct net_device *ndev, struct ethtool_eee *edata)
>  {
>  	struct fec_enet_private *fep = netdev_priv(ndev);
>  	struct ethtool_eee *p = &fep->eee;
> -	int ret = 0;
>  
>  	if (!(fep->quirks & FEC_QUIRK_HAS_EEE))
>  		return -EOPNOTSUPP;
> @@ -3131,15 +3120,7 @@ fec_enet_set_eee(struct net_device *ndev, struct ethtool_eee *edata)
>  		return -ENETDOWN;
>  
>  	p->tx_lpi_timer = edata->tx_lpi_timer;
> -
> -	if (!edata->eee_enabled || !edata->tx_lpi_enabled ||
> -	    !edata->tx_lpi_timer)
> -		ret = fec_enet_eee_mode_set(ndev, false);
> -	else
> -		ret = fec_enet_eee_mode_set(ndev, true);
> -
> -	if (ret)
> -		return ret;
> +	p->tx_lpi_enabled = edata->tx_lpi_enabled;

Hm.. this change have effect only after link restart. Should we do
something like this?

	if (phydev->link)
		fec_enet_eee_mode_set(ndev, phydev->eee_active);

or, execute phy_ethtool_set_eee() first and some how detect if link
changed? Or restart link by phylib on every change?

>  
>  	return phy_ethtool_set_eee(ndev->phydev, edata);
>  }
> -- 
> 2.39.1
> 
> 

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
