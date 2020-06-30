Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BEAB20F2EE
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 12:46:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732602AbgF3KqU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 06:46:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732510AbgF3KqU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 06:46:20 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7C4EC061755
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 03:46:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=0qjw1REKDZVNx9wNKUKiw4AETjSrlEI8JC9HU0Yze0A=; b=oog/wZqOcdaZXocWWlkudM8uk
        DoLSbh3Em1NfhhOWX9JAXASGirK1qBcsK4GpjPYjpczo0RnsO5FZoRuKeG52OD5wqAuXjU2SFIrJi
        fZjfjpTwDqroVV2b0ctcuxGZB57/FZMG5pOjSkN/G/2ransy3DqF7pGiaL0zFwOM/izWLtoELz/EG
        2nx2rvKSD8O4K09SsfFoNgvLu7WWgexDbB9NaqfTX/7J945t53nUJQCEWGxnQgglAtlPTl9Xbg/mc
        JoI2V1D4qgmszn78syagJ06Eq80x7I/Ko11iV+EqjZnVpTgB17YO3QxmSTyXhvY88vesfGz/RPIsH
        BK3AxgvCQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:33504)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jqDmK-0000QS-As; Tue, 30 Jun 2020 11:46:16 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jqDmH-00087X-J2; Tue, 30 Jun 2020 11:46:13 +0100
Date:   Tue, 30 Jun 2020 11:46:13 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        =?iso-8859-1?Q?Ren=E9?= van Dorst <opensource@vdorst.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH RFC net-next] net: mtk_eth_soc: use resolved link config
 for PCS PHY
Message-ID: <20200630104613.GB1551@shell.armlinux.org.uk>
References: <E1jqDIk-0004m5-0L@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <E1jqDIk-0004m5-0L@rmk-PC.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 30, 2020 at 11:15:42AM +0100, Russell King wrote:
> The SGMII PCS PHY needs to be updated with the link configuration in
> the mac_link_up() call rather than in mac_config().  However,
> mtk_sgmii_setup_mode_force() programs the SGMII block during
> mac_config() when using 802.3z interface modes with the link
> configuration.
> 
> Split that functionality from mtk_sgmii_setup_mode_force(), moving it
> to a new mtk_sgmii_link_up() function, and call it from mac_link_up().
> 
> This does not look correct to me: 802.3z modes operate at a fixed
> speed.  The contents of mtk_sgmii_link_up() look more appropriate for
> SGMII mode, but the original code definitely did not call
> mtk_sgmii_setup_mode_force() for SGMII mode but only 802.3z mode.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> ---
> René, can you assist with this patch please - I really think there are
> problems with the existing code.  You call mtk_sgmii_setup_mode_force()
> in a block which is conditionalised as:
> 
> 	if (state->interface == PHY_INTERFACE_MODE_SGMII ||
> 	    phy_interface_mode_is_8023z(state->interface)) {
> ...
> 		if (state->interface != PHY_INTERFACE_MODE_SGMII)
> 			err = mtk_sgmii_setup_mode_force(eth->sgmii, sid,
> 							 state);
> 
> Hence, mtk_sgmii_setup_mode_force() is only called for 1000BASE-X and
> 2500BASE-X, which do not support anything but their native speeds.
> Yet, mtk_sgmii_setup_mode_force() tries to program the SGMII for 10M
> and 100M.
> 
> Note that this patch is more about moving uses of state->{speed,duplex}
> into mac_link_up(), rather than fixing this problem, but I don't think
> the addition in mtk_mac_link_up(), nor mtk_sgmii_link_up() is of any
> use.

My Coccinelle script just found this use of state->{speed,duplex} still
remaining:

                        if (MTK_HAS_CAPS(mac->hw->soc->caps,
                                         MTK_TRGMII_MT7621_CLK)) {
...
                        } else {
                                if (state->interface !=
                                    PHY_INTERFACE_MODE_TRGMII)
                                        mtk_gmac0_rgmii_adjust(mac->hw,
                                                               state->speed);

which also needs to be eliminated.  Can that also be moved to
mtk_mac_link_up()?

Thanks.

> 
> Thanks.
> 
>  drivers/net/ethernet/mediatek/mtk_eth_soc.c |  9 ++++-
>  drivers/net/ethernet/mediatek/mtk_eth_soc.h |  3 +-
>  drivers/net/ethernet/mediatek/mtk_sgmii.c   | 37 +++++++++++++++------
>  3 files changed, 36 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> index 20db302d31ce..ef9ec3b6a5c8 100644
> --- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> +++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> @@ -326,7 +326,7 @@ static void mtk_mac_config(struct phylink_config *config, unsigned int mode,
>  		/* Setup SGMIISYS with the determined property */
>  		if (state->interface != PHY_INTERFACE_MODE_SGMII)
>  			err = mtk_sgmii_setup_mode_force(eth->sgmii, sid,
> -							 state);
> +							 state->interface);
>  		else if (phylink_autoneg_inband(mode))
>  			err = mtk_sgmii_setup_mode_an(eth->sgmii, sid);
>  
> @@ -423,6 +423,13 @@ static void mtk_mac_link_up(struct phylink_config *config,
>  					   phylink_config);
>  	u32 mcr = mtk_r32(mac->hw, MTK_MAC_MCR(mac->id));
>  
> +	if (phy_interface_mode_is_8023z(interface)) {
> +		/* Decide how GMAC and SGMIISYS be mapped */
> +		int sid = (MTK_HAS_CAPS(eth->soc->caps, MTK_SHARED_SGMII)) ?
> +			   0 : mac->id;
> +		mtk_sgmii_link_up(eth->sgmii, sid, speed, duplex);
> +	}
> +
>  	mcr &= ~(MAC_MCR_SPEED_100 | MAC_MCR_SPEED_1000 |
>  		 MAC_MCR_FORCE_DPX | MAC_MCR_FORCE_TX_FC |
>  		 MAC_MCR_FORCE_RX_FC);
> diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.h b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
> index 454cfcd465fd..6f4b99bb7bfb 100644
> --- a/drivers/net/ethernet/mediatek/mtk_eth_soc.h
> +++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
> @@ -932,7 +932,8 @@ int mtk_sgmii_init(struct mtk_sgmii *ss, struct device_node *np,
>  		   u32 ana_rgc3);
>  int mtk_sgmii_setup_mode_an(struct mtk_sgmii *ss, int id);
>  int mtk_sgmii_setup_mode_force(struct mtk_sgmii *ss, int id,
> -			       const struct phylink_link_state *state);
> +			       phy_interface_t interface);
> +void mtk_sgmii_link_up(struct mtk_sgmii *ss, int id, int speed, int duplex);
>  void mtk_sgmii_restart_an(struct mtk_eth *eth, int mac_id);
>  
>  int mtk_gmac_sgmii_path_setup(struct mtk_eth *eth, int mac_id);
> diff --git a/drivers/net/ethernet/mediatek/mtk_sgmii.c b/drivers/net/ethernet/mediatek/mtk_sgmii.c
> index 32d83421226a..372c85c830b5 100644
> --- a/drivers/net/ethernet/mediatek/mtk_sgmii.c
> +++ b/drivers/net/ethernet/mediatek/mtk_sgmii.c
> @@ -60,7 +60,7 @@ int mtk_sgmii_setup_mode_an(struct mtk_sgmii *ss, int id)
>  }
>  
>  int mtk_sgmii_setup_mode_force(struct mtk_sgmii *ss, int id,
> -			       const struct phylink_link_state *state)
> +			       phy_interface_t interface)
>  {
>  	unsigned int val;
>  
> @@ -69,7 +69,7 @@ int mtk_sgmii_setup_mode_force(struct mtk_sgmii *ss, int id,
>  
>  	regmap_read(ss->regmap[id], ss->ana_rgc3, &val);
>  	val &= ~RG_PHY_SPEED_MASK;
> -	if (state->interface == PHY_INTERFACE_MODE_2500BASEX)
> +	if (interface == PHY_INTERFACE_MODE_2500BASEX)
>  		val |= RG_PHY_SPEED_3_125G;
>  	regmap_write(ss->regmap[id], ss->ana_rgc3, val);
>  
> @@ -78,11 +78,33 @@ int mtk_sgmii_setup_mode_force(struct mtk_sgmii *ss, int id,
>  	val &= ~SGMII_AN_ENABLE;
>  	regmap_write(ss->regmap[id], SGMSYS_PCS_CONTROL_1, val);
>  
> +	if (interface == PHY_INTERFACE_MODE_1000BASEX ||
> +	    interface == PHY_INTERFACE_MODE_2500BASEX) {
> +		/* SGMII force mode setting */
> +		regmap_read(ss->regmap[id], SGMSYS_SGMII_MODE, &val);
> +		val &= ~SGMII_IF_MODE_MASK;
> +		val |= SGMII_SPEED_1000;
> +		val |= SGMII_DUPLEX_FULL;
> +		regmap_write(ss->regmap[id], SGMSYS_SGMII_MODE, val);
> +	}
> +
> +	/* Release PHYA power down state */
> +	regmap_read(ss->regmap[id], SGMSYS_QPHY_PWR_STATE_CTRL, &val);
> +	val &= ~SGMII_PHYA_PWD;
> +	regmap_write(ss->regmap[id], SGMSYS_QPHY_PWR_STATE_CTRL, val);
> +
> +	return 0;
> +}
> +
> +void mtk_sgmii_link_up(struct mtk_sgmii *ss, int id, int speed, int duplex)
> +{
> +	unsigned int val;
> +
>  	/* SGMII force mode setting */
>  	regmap_read(ss->regmap[id], SGMSYS_SGMII_MODE, &val);
>  	val &= ~SGMII_IF_MODE_MASK;
>  
> -	switch (state->speed) {
> +	switch (speed) {
>  	case SPEED_10:
>  		val |= SGMII_SPEED_10;
>  		break;
> @@ -95,17 +117,10 @@ int mtk_sgmii_setup_mode_force(struct mtk_sgmii *ss, int id,
>  		break;
>  	}
>  
> -	if (state->duplex == DUPLEX_FULL)
> +	if (duplex == DUPLEX_FULL)
>  		val |= SGMII_DUPLEX_FULL;
>  
>  	regmap_write(ss->regmap[id], SGMSYS_SGMII_MODE, val);
> -
> -	/* Release PHYA power down state */
> -	regmap_read(ss->regmap[id], SGMSYS_QPHY_PWR_STATE_CTRL, &val);
> -	val &= ~SGMII_PHYA_PWD;
> -	regmap_write(ss->regmap[id], SGMSYS_QPHY_PWR_STATE_CTRL, val);
> -
> -	return 0;
>  }
>  
>  void mtk_sgmii_restart_an(struct mtk_eth *eth, int mac_id)
> -- 
> 2.20.1
> 
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
