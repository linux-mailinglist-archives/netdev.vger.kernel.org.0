Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4591A172328
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 17:23:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730140AbgB0QWB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 11:22:01 -0500
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:37215 "EHLO
        relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729854AbgB0QWB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Feb 2020 11:22:01 -0500
Received: from webmail.gandi.net (webmail18.sd4.0x35.net [10.200.201.18])
        (Authenticated sender: foss@0leil.net)
        by relay5-d.mail.gandi.net (Postfix) with ESMTPA id D2E121C000C;
        Thu, 27 Feb 2020 16:21:58 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 27 Feb 2020 17:21:58 +0100
From:   Quentin Schulz <foss@0leil.net>
To:     Antoine Tenart <antoine.tenart@bootlin.com>
Cc:     davem@davemloft.net, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 3/3] net: phy: mscc: implement RGMII skew delay
 configuration
In-Reply-To: <20200227152859.1687119-4-antoine.tenart@bootlin.com>
References: <20200227152859.1687119-1-antoine.tenart@bootlin.com>
 <20200227152859.1687119-4-antoine.tenart@bootlin.com>
Message-ID: <1f267571ddd9d1caf3e95afe31e47e30@0leil.net>
X-Sender: foss@0leil.net
User-Agent: Roundcube Webmail/1.3.8
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Antoine,

It's still me, nitpicker.

On 2020-02-27 16:28, Antoine Tenart wrote:
> This patch adds support for configuring the RGMII skews in Rx and Tx
> thanks to properties defined in the device tree.
> 
> Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
> ---
>  drivers/net/phy/mscc.c | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
> 
> diff --git a/drivers/net/phy/mscc.c b/drivers/net/phy/mscc.c
> index ecb45c43e5ed..56d6a45a90c2 100644
> --- a/drivers/net/phy/mscc.c
> +++ b/drivers/net/phy/mscc.c
> @@ -192,6 +192,10 @@ enum macsec_bank {
>  /* Extended Page 2 Registers */
>  #define MSCC_PHY_CU_PMD_TX_CNTL		  16
> 
> +#define MSCC_PHY_RGMII_SETTINGS		  18
> +#define RGMII_SKEW_RX_POS		  1
> +#define RGMII_SKEW_TX_POS		  4
> +
>  #define MSCC_PHY_RGMII_CNTL		  20
>  #define RGMII_RX_CLK_DELAY_MASK		  0x0070
>  #define RGMII_RX_CLK_DELAY_POS		  4
> @@ -2682,6 +2686,7 @@ static bool vsc8584_is_pkg_init(struct
> phy_device *phydev, bool reversed)
> 
>  static int vsc8584_config_init(struct phy_device *phydev)
>  {
> +	u32 skew_rx = VSC8584_RGMII_SKEW_0_2, skew_tx = 
> VSC8584_RGMII_SKEW_0_2;
>  	struct vsc8531_private *vsc8531 = phydev->priv;
>  	u16 addr, val;
>  	int ret, i;
> @@ -2830,6 +2835,19 @@ static int vsc8584_config_init(struct phy_device 
> *phydev)
>  	if (ret)
>  		return ret;
> 
> +	if (of_find_property(dev->of_node, "vsc8584,rgmii-skew-rx", NULL) ||
> +	    of_find_property(dev->of_node, "vsc8584,rgmii-skew-tx", NULL)) {
> +		of_property_read_u32(dev->of_node, "vsc8584,rgmii-skew-rx", 
> &skew_rx);
> +		of_property_read_u32(dev->of_node, "vsc8584,rgmii-skew-tx", 
> &skew_tx);
> +

Reading the code, I think **!**of_property_read_u32 could directly 
replace of_find_property in your condition and spare you two calls to 
that function.

Also, do we actually need to write that register only when skews are 
defined in the DT? Can't we just write to it anyway (I guess the fact 
that 0_2 skew is actually 0 in value should put me on the right path but 
I prefer to ask).

Final nitpick: I would see a check of the skew_rx/tx from DT before you 
put them in the following line, they could be drastically different from 
0-8 value set that you expect considering you're reading a u32 (pass 
them through a GENMASK at least?)

> +		phy_modify_paged(phydev, MSCC_PHY_PAGE_EXTENDED_2,
> +				 MSCC_PHY_RGMII_SETTINGS,
> +				 (0x7 << RGMII_SKEW_RX_POS) |
> +				 (0x7 << RGMII_SKEW_TX_POS),
> +				 (skew_rx << RGMII_SKEW_RX_POS) |
> +				 (skew_tx << RGMII_SKEW_TX_POS));
> +	}
> +

Thanks,
Quentin
