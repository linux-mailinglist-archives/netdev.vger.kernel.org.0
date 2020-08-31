Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAF00257B05
	for <lists+netdev@lfdr.de>; Mon, 31 Aug 2020 16:02:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727037AbgHaOCw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 10:02:52 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:34174 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726326AbgHaOCv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 31 Aug 2020 10:02:51 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kCkOO-00CeQ1-DB; Mon, 31 Aug 2020 16:02:40 +0200
Date:   Mon, 31 Aug 2020 16:02:40 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marco Felsch <m.felsch@pengutronix.de>
Cc:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        f.fainelli@gmail.com, hkallweit1@gmail.com, linux@armlinux.org.uk,
        zhengdejin5@gmail.com, richard.leitner@skidata.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        kernel@pengutronix.de
Subject: Re: [PATCH 1/5] net: phy: smsc: skip ENERGYON interrupt if disabled
Message-ID: <20200831140240.GD2403519@lunn.ch>
References: <20200831134836.20189-1-m.felsch@pengutronix.de>
 <20200831134836.20189-2-m.felsch@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200831134836.20189-2-m.felsch@pengutronix.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 31, 2020 at 03:48:32PM +0200, Marco Felsch wrote:
> Don't enable the interrupt if the platform disable the energy detection
> by "smsc,disable-energy-detect".
> 
> Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
> ---
>  drivers/net/phy/smsc.c | 15 +++++++++++----
>  1 file changed, 11 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/phy/smsc.c b/drivers/net/phy/smsc.c
> index 74568ae16125..fa539a867de6 100644
> --- a/drivers/net/phy/smsc.c
> +++ b/drivers/net/phy/smsc.c
> @@ -37,10 +37,17 @@ struct smsc_phy_priv {
>  
>  static int smsc_phy_config_intr(struct phy_device *phydev)
>  {
> -	int rc = phy_write (phydev, MII_LAN83C185_IM,
> -			((PHY_INTERRUPT_ENABLED == phydev->interrupts)
> -			? MII_LAN83C185_ISF_INT_PHYLIB_EVENTS
> -			: 0));
> +	struct smsc_phy_priv *priv = phydev->priv;
> +	u16 intmask = 0;
> +	int rc;
> +
> +	if (phydev->interrupts) {
> +		intmask = MII_LAN83C185_ISF_INT4 | MII_LAN83C185_ISF_INT6;
> +		if (priv->energy_enable)
> +			intmask |= MII_LAN83C185_ISF_INT7;

Hi Marco

These names are not particularly helpful. The include file does
actually document the bits.

#define MII_LAN83C185_ISF_INT1 (1<<1) /* Auto-Negotiation Page Received */
#define MII_LAN83C185_ISF_INT2 (1<<2) /* Parallel Detection Fault */
#define MII_LAN83C185_ISF_INT3 (1<<3) /* Auto-Negotiation LP Ack */
#define MII_LAN83C185_ISF_INT4 (1<<4) /* Link Down */
#define MII_LAN83C185_ISF_INT5 (1<<5) /* Remote Fault Detected */
#define MII_LAN83C185_ISF_INT6 (1<<6) /* Auto-Negotiation complete */
#define MII_LAN83C185_ISF_INT7 (1<<7) /* ENERGYON */

If you feel like it, maybe add another patch which renames these to
something better. MII_LAN83C185_ISF_DOWN, MII_LAN83C185_ISF_ENERGY_ON,
etc?

For this patch:

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
