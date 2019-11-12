Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEFEFF90C2
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 14:35:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726946AbfKLNfv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 08:35:51 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:35766 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726738AbfKLNfu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Nov 2019 08:35:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Hcl1cbwRWLCpJHoYUM4DQfDLrNavPzlw/yXdhijl4zc=; b=RPu38bHW4S/lWdYWqR+W3gYT2c
        qu+dSvVpgvfWaUcUCj+50BVVKUSBqte+7XeI0spjv4PrnhZXZIlJzHZGfbyrAZc0M8l/5itRbeN2O
        FGSrG51bYb5Sk79+52SKD+ivjnc+jZsI/hudS+SY/gsKlnCW5cqbrrPYt4Bba8va0uVE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iUWKe-0001Zq-DZ; Tue, 12 Nov 2019 14:35:44 +0100
Date:   Tue, 12 Nov 2019 14:35:44 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     jakub.kicinski@netronome.com, davem@davemloft.net,
        alexandre.belloni@bootlin.com, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, joergen.andreasen@microchip.com,
        allan.nielsen@microchip.com, horatiu.vultur@microchip.com,
        claudiu.manoil@nxp.com, netdev@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH net-next 03/12] net: mscc: ocelot: move invariant configs
 out of adjust_link
Message-ID: <20191112133544.GE5090@lunn.ch>
References: <20191112124420.6225-1-olteanv@gmail.com>
 <20191112124420.6225-4-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191112124420.6225-4-olteanv@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 12, 2019 at 02:44:11PM +0200, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> It doesn't make sense to rewrite all these registers every time the PHY
> library notifies us about a link state change.
> 
> In a future patch we will customize the MTU for the CPU port, and since
> the MTU was previously configured from adjust_link, if we don't make
> this change, its value would have got overridden.

This is also a good change in preparation of PHYLINK.  When you do
that conversion, ocelot_adjust_link() is likely to become
ocelot_mac_config(). It should only change hardware state when there
actually is a change in link state. This is something drivers often
get wrong.

> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew



> ---
>  drivers/net/ethernet/mscc/ocelot.c | 85 +++++++++++++++---------------
>  1 file changed, 43 insertions(+), 42 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
> index 2b6792ab0eda..4558c09e2e8a 100644
> --- a/drivers/net/ethernet/mscc/ocelot.c
> +++ b/drivers/net/ethernet/mscc/ocelot.c
> @@ -408,7 +408,7 @@ static void ocelot_adjust_link(struct ocelot *ocelot, int port,
>  			       struct phy_device *phydev)
>  {
>  	struct ocelot_port *ocelot_port = ocelot->ports[port];
> -	int speed, atop_wm, mode = 0;
> +	int speed, mode = 0;
>  
>  	switch (phydev->speed) {
>  	case SPEED_10:
> @@ -440,32 +440,9 @@ static void ocelot_adjust_link(struct ocelot *ocelot, int port,
>  	ocelot_port_writel(ocelot_port, DEV_MAC_MODE_CFG_FDX_ENA |
>  			   mode, DEV_MAC_MODE_CFG);
>  
> -	/* Set MAC IFG Gaps
> -	 * FDX: TX_IFG = 5, RX_IFG1 = RX_IFG2 = 0
> -	 * !FDX: TX_IFG = 5, RX_IFG1 = RX_IFG2 = 5
> -	 */
> -	ocelot_port_writel(ocelot_port, DEV_MAC_IFG_CFG_TX_IFG(5),
> -			   DEV_MAC_IFG_CFG);
> -
> -	/* Load seed (0) and set MAC HDX late collision  */
> -	ocelot_port_writel(ocelot_port, DEV_MAC_HDX_CFG_LATE_COL_POS(67) |
> -			   DEV_MAC_HDX_CFG_SEED_LOAD,
> -			   DEV_MAC_HDX_CFG);
> -	mdelay(1);
> -	ocelot_port_writel(ocelot_port, DEV_MAC_HDX_CFG_LATE_COL_POS(67),
> -			   DEV_MAC_HDX_CFG);
> -
>  	if (ocelot->ops->pcs_init)
>  		ocelot->ops->pcs_init(ocelot, port);
>  
> -	/* Set Max Length and maximum tags allowed */
> -	ocelot_port_writel(ocelot_port, VLAN_ETH_FRAME_LEN,
> -			   DEV_MAC_MAXLEN_CFG);
> -	ocelot_port_writel(ocelot_port, DEV_MAC_TAGS_CFG_TAG_ID(ETH_P_8021AD) |
> -			   DEV_MAC_TAGS_CFG_VLAN_AWR_ENA |
> -			   DEV_MAC_TAGS_CFG_VLAN_LEN_AWR_ENA,
> -			   DEV_MAC_TAGS_CFG);
> -
>  	/* Enable MAC module */
>  	ocelot_port_writel(ocelot_port, DEV_MAC_ENA_CFG_RX_ENA |
>  			   DEV_MAC_ENA_CFG_TX_ENA, DEV_MAC_ENA_CFG);
> @@ -475,22 +452,10 @@ static void ocelot_adjust_link(struct ocelot *ocelot, int port,
>  	ocelot_port_writel(ocelot_port, DEV_CLOCK_CFG_LINK_SPEED(speed),
>  			   DEV_CLOCK_CFG);
>  
> -	/* Set SMAC of Pause frame (00:00:00:00:00:00) */
> -	ocelot_port_writel(ocelot_port, 0, DEV_MAC_FC_MAC_HIGH_CFG);
> -	ocelot_port_writel(ocelot_port, 0, DEV_MAC_FC_MAC_LOW_CFG);
> -
>  	/* No PFC */
>  	ocelot_write_gix(ocelot, ANA_PFC_PFC_CFG_FC_LINK_SPEED(speed),
>  			 ANA_PFC_PFC_CFG, port);
>  
> -	/* Set Pause WM hysteresis
> -	 * 152 = 6 * VLAN_ETH_FRAME_LEN / OCELOT_BUFFER_CELL_SZ
> -	 * 101 = 4 * VLAN_ETH_FRAME_LEN / OCELOT_BUFFER_CELL_SZ
> -	 */
> -	ocelot_write_rix(ocelot, SYS_PAUSE_CFG_PAUSE_ENA |
> -			 SYS_PAUSE_CFG_PAUSE_STOP(101) |
> -			 SYS_PAUSE_CFG_PAUSE_START(152), SYS_PAUSE_CFG, port);
> -
>  	/* Core: Enable port for frame transfer */
>  	ocelot_write_rix(ocelot, QSYS_SWITCH_PORT_MODE_INGRESS_DROP_MODE |
>  			 QSYS_SWITCH_PORT_MODE_SCH_NEXT_CFG(1) |
> @@ -505,12 +470,6 @@ static void ocelot_adjust_link(struct ocelot *ocelot, int port,
>  			 SYS_MAC_FC_CFG_FC_LINK_SPEED(speed),
>  			 SYS_MAC_FC_CFG, port);
>  	ocelot_write_rix(ocelot, 0, ANA_POL_FLOWC, port);
> -
> -	/* Tail dropping watermark */
> -	atop_wm = (ocelot->shared_queue_sz - 9 * VLAN_ETH_FRAME_LEN) / OCELOT_BUFFER_CELL_SZ;
> -	ocelot_write_rix(ocelot, ocelot_wm_enc(9 * VLAN_ETH_FRAME_LEN),
> -			 SYS_ATOP, port);
> -	ocelot_write(ocelot, ocelot_wm_enc(atop_wm), SYS_ATOP_TOT_CFG);
>  }
>  
>  static void ocelot_port_adjust_link(struct net_device *dev)
> @@ -2141,11 +2100,53 @@ static int ocelot_init_timestamp(struct ocelot *ocelot)
>  static void ocelot_init_port(struct ocelot *ocelot, int port)
>  {
>  	struct ocelot_port *ocelot_port = ocelot->ports[port];
> +	int atop_wm;
>  
>  	INIT_LIST_HEAD(&ocelot_port->skbs);
>  
>  	/* Basic L2 initialization */
>  
> +	/* Set MAC IFG Gaps
> +	 * FDX: TX_IFG = 5, RX_IFG1 = RX_IFG2 = 0
> +	 * !FDX: TX_IFG = 5, RX_IFG1 = RX_IFG2 = 5
> +	 */
> +	ocelot_port_writel(ocelot_port, DEV_MAC_IFG_CFG_TX_IFG(5),
> +			   DEV_MAC_IFG_CFG);
> +
> +	/* Load seed (0) and set MAC HDX late collision  */
> +	ocelot_port_writel(ocelot_port, DEV_MAC_HDX_CFG_LATE_COL_POS(67) |
> +			   DEV_MAC_HDX_CFG_SEED_LOAD,
> +			   DEV_MAC_HDX_CFG);
> +	mdelay(1);
> +	ocelot_port_writel(ocelot_port, DEV_MAC_HDX_CFG_LATE_COL_POS(67),
> +			   DEV_MAC_HDX_CFG);
> +
> +	/* Set Max Length and maximum tags allowed */
> +	ocelot_port_writel(ocelot_port, VLAN_ETH_FRAME_LEN,
> +			   DEV_MAC_MAXLEN_CFG);
> +	ocelot_port_writel(ocelot_port, DEV_MAC_TAGS_CFG_TAG_ID(ETH_P_8021AD) |
> +			   DEV_MAC_TAGS_CFG_VLAN_AWR_ENA |
> +			   DEV_MAC_TAGS_CFG_VLAN_LEN_AWR_ENA,
> +			   DEV_MAC_TAGS_CFG);
> +
> +	/* Set SMAC of Pause frame (00:00:00:00:00:00) */
> +	ocelot_port_writel(ocelot_port, 0, DEV_MAC_FC_MAC_HIGH_CFG);
> +	ocelot_port_writel(ocelot_port, 0, DEV_MAC_FC_MAC_LOW_CFG);
> +
> +	/* Set Pause WM hysteresis
> +	 * 152 = 6 * VLAN_ETH_FRAME_LEN / OCELOT_BUFFER_CELL_SZ
> +	 * 101 = 4 * VLAN_ETH_FRAME_LEN / OCELOT_BUFFER_CELL_SZ
> +	 */
> +	ocelot_write_rix(ocelot, SYS_PAUSE_CFG_PAUSE_ENA |
> +			 SYS_PAUSE_CFG_PAUSE_STOP(101) |
> +			 SYS_PAUSE_CFG_PAUSE_START(152), SYS_PAUSE_CFG, port);
> +
> +	/* Tail dropping watermark */
> +	atop_wm = (ocelot->shared_queue_sz - 9 * VLAN_ETH_FRAME_LEN) / OCELOT_BUFFER_CELL_SZ;
> +	ocelot_write_rix(ocelot, ocelot_wm_enc(9 * VLAN_ETH_FRAME_LEN),
> +			 SYS_ATOP, port);
> +	ocelot_write(ocelot, ocelot_wm_enc(atop_wm), SYS_ATOP_TOT_CFG);
> +
>  	/* Drop frames with multicast source address */
>  	ocelot_rmw_gix(ocelot, ANA_PORT_DROP_CFG_DROP_MC_SMAC_ENA,
>  		       ANA_PORT_DROP_CFG_DROP_MC_SMAC_ENA,
> -- 
> 2.17.1
> 
