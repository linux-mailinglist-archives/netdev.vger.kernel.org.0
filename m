Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E88CA6DAEA8
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 16:15:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240428AbjDGOO7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 10:14:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240100AbjDGOOw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 10:14:52 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B1536E95;
        Fri,  7 Apr 2023 07:14:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=R4TH8iF3XRJ1DlarsE3NhkPLoUGzWdq0m7N8occ5vGM=; b=qfkEn4cpxPYcnc/95fxARsn6kI
        zpeKmQ0mwVKakCrF1WP0MnojedLNPejElAIifeijWYvYqjdQZTh60gwiU0Xsy2Ap2RGQay0bQcUiy
        dxMAKj5eXZTpqTBy81xujjnLuNvcS+U+6pm7Q33vb32HQDNLy8D9RKY5TOcInHbQItWE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pkmrM-009jDL-2x; Fri, 07 Apr 2023 16:14:36 +0200
Date:   Fri, 7 Apr 2023 16:14:36 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Radu Pirea (OSS)" <radu-nicolae.pirea@oss.nxp.com>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH net] net: phy: nxp-c45-tja11xx: disable port and global
 interrupts
Message-ID: <47d0347d-02a1-48a3-8553-d6ab2be731e8@lunn.ch>
References: <20230406095546.74351-1-radu-nicolae.pirea@oss.nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230406095546.74351-1-radu-nicolae.pirea@oss.nxp.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 06, 2023 at 12:55:46PM +0300, Radu Pirea (OSS) wrote:
> Disabling only the link event irq is not enough to disable the
> interrupts. PTP will still be able to generate interrupts.
> 
> The interrupts are organised in a tree on the C45 TJA11XX PHYs. To
> completely disable the interrupts, they are disable from the top of the
> interrupt tree.
> 
> Fixes: 514def5dd339 ("phy: nxp-c45-tja11xx: add timestamping support")
> CC: stable@vger.kernel.org # 5.15+
> Signed-off-by: Radu Pirea (OSS) <radu-nicolae.pirea@oss.nxp.com>
> ---
>  drivers/net/phy/nxp-c45-tja11xx.c | 22 ++++++++++++++++------
>  1 file changed, 16 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/phy/nxp-c45-tja11xx.c b/drivers/net/phy/nxp-c45-tja11xx.c
> index 029875a59ff8..ce718a5865a4 100644
> --- a/drivers/net/phy/nxp-c45-tja11xx.c
> +++ b/drivers/net/phy/nxp-c45-tja11xx.c
> @@ -31,6 +31,10 @@
>  #define DEVICE_CONTROL_CONFIG_GLOBAL_EN	BIT(14)
>  #define DEVICE_CONTROL_CONFIG_ALL_EN	BIT(13)
>  
> +#define VEND1_PORT_IRQ_ENABLES		0x0072
> +#define PORT1_IRQ			BIT(1)
> +#define GLOBAL_IRQ			BIT(0)

I find the PORT1 confusing there, it suggests there is a port0? What
is port0? There is no other reference to numbered ports in the driver.

> -static bool nxp_c45_poll_txts(struct phy_device *phydev)
> +static bool nxp_c45_poll(struct phy_device *phydev)
>  {
>  	return phydev->irq <= 0;
>  }

Maybe as a new patch, but phy_interrupt_is_valid() can be used here.

Maybe also extend the commit message to include a comment that
functions names are changed to reflect that all interrupts are now
disabled, not just _txts interrupts. Otherwise this rename might be
considered an unrelated change.

> @@ -448,7 +452,7 @@ static void nxp_c45_process_txts(struct nxp_c45_phy *priv,
>  static long nxp_c45_do_aux_work(struct ptp_clock_info *ptp)
>  {
>  	struct nxp_c45_phy *priv = container_of(ptp, struct nxp_c45_phy, caps);
> -	bool poll_txts = nxp_c45_poll_txts(priv->phydev);
> +	bool poll_txts = nxp_c45_poll(priv->phydev);
>  	struct skb_shared_hwtstamps *shhwtstamps_rx;
>  	struct ptp_clock_event event;
>  	struct nxp_c45_hwts hwts;
> @@ -699,7 +703,7 @@ static void nxp_c45_txtstamp(struct mii_timestamper *mii_ts,
>  		NXP_C45_SKB_CB(skb)->header = ptp_parse_header(skb, type);
>  		skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
>  		skb_queue_tail(&priv->tx_queue, skb);
> -		if (nxp_c45_poll_txts(priv->phydev))
> +		if (nxp_c45_poll(priv->phydev))
>  			ptp_schedule_worker(priv->ptp_clock, 0);
>  		break;
>  	case HWTSTAMP_TX_OFF:
> @@ -772,7 +776,7 @@ static int nxp_c45_hwtstamp(struct mii_timestamper *mii_ts,
>  				 PORT_PTP_CONTROL_BYPASS);
>  	}
>  
> -	if (nxp_c45_poll_txts(priv->phydev))
> +	if (nxp_c45_poll(priv->phydev))
>  		goto nxp_c45_no_ptp_irq;
>  
>  	if (priv->hwts_tx)
> @@ -892,10 +896,12 @@ static int nxp_c45_config_intr(struct phy_device *phydev)
>  {
>  	if (phydev->interrupts == PHY_INTERRUPT_ENABLED)
>  		return phy_set_bits_mmd(phydev, MDIO_MMD_VEND1,
> -					VEND1_PHY_IRQ_EN, PHY_IRQ_LINK_EVENT);
> +					VEND1_PORT_IRQ_ENABLES,
> +					PORT1_IRQ | GLOBAL_IRQ);
>  	else
>  		return phy_clear_bits_mmd(phydev, MDIO_MMD_VEND1,
> -					  VEND1_PHY_IRQ_EN, PHY_IRQ_LINK_EVENT);
> +					  VEND1_PORT_IRQ_ENABLES,
> +					  PORT1_IRQ | GLOBAL_IRQ);
>  }
>  
>  static irqreturn_t nxp_c45_handle_interrupt(struct phy_device *phydev)
> @@ -1290,6 +1296,10 @@ static int nxp_c45_config_init(struct phy_device *phydev)
>  	phy_set_bits_mmd(phydev, MDIO_MMD_VEND1, VEND1_PORT_FUNC_ENABLES,
>  			 PTP_ENABLE);
>  
> +	if (!nxp_c45_poll(phydev))
> +		phy_set_bits_mmd(phydev, MDIO_MMD_VEND1,
> +				 VEND1_PHY_IRQ_EN, PHY_IRQ_LINK_EVENT);
> +

It seems odd to be touching interrupt configuration outside of
nxp_c45_config_intr(). Is there a reason this cannot be part of
phydev->interrupts == PHY_INTERRUPT_ENABLED ?

	Andrew
