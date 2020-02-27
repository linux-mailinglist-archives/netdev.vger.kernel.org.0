Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C77D1722DB
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 17:10:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730009AbgB0QJ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 11:09:29 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:39317 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729134AbgB0QJ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Feb 2020 11:09:29 -0500
Received: from webmail.gandi.net (webmail18.sd4.0x35.net [10.200.201.18])
        (Authenticated sender: foss@0leil.net)
        by relay3-d.mail.gandi.net (Postfix) with ESMTPA id 0774160003;
        Thu, 27 Feb 2020 16:09:25 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Thu, 27 Feb 2020 17:09:25 +0100
From:   Quentin Schulz <foss@0leil.net>
To:     Antoine Tenart <antoine.tenart@bootlin.com>
Cc:     davem@davemloft.net, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 1/3] net: phy: mscc: add support for RGMII MAC
 mode
In-Reply-To: <20200227152859.1687119-2-antoine.tenart@bootlin.com>
References: <20200227152859.1687119-1-antoine.tenart@bootlin.com>
 <20200227152859.1687119-2-antoine.tenart@bootlin.com>
Message-ID: <55c4a6d121868a083b1d8ca78c65cd37@0leil.net>
X-Sender: foss@0leil.net
User-Agent: Roundcube Webmail/1.3.8
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Antoine,

I guess I slipped through in your Cc list but now that it's too late to 
undo it, I'll give my 2¢ :)

On 2020-02-27 16:28, Antoine Tenart wrote:
> This patch adds support for connecting VSC8584 PHYs to the MAC using
> RGMII.
> 
> Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
> ---
>  drivers/net/phy/mscc.c | 33 +++++++++++++++++++++------------
>  1 file changed, 21 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/net/phy/mscc.c b/drivers/net/phy/mscc.c
> index d24577de0775..ecb45c43e5ed 100644
> --- a/drivers/net/phy/mscc.c
> +++ b/drivers/net/phy/mscc.c
> @@ -272,6 +272,7 @@ enum macsec_bank {
>  #define MAC_CFG_MASK			  0xc000
>  #define MAC_CFG_SGMII			  0x0000
>  #define MAC_CFG_QSGMII			  0x4000
> +#define MAC_CFG_RGMII			  0x8000
> 
>  /* Test page Registers */
>  #define MSCC_PHY_TEST_PAGE_5		  5
> @@ -2751,27 +2752,35 @@ static int vsc8584_config_init(struct
> phy_device *phydev)
> 
>  	val = phy_base_read(phydev, MSCC_PHY_MAC_CFG_FASTLINK);
>  	val &= ~MAC_CFG_MASK;
> -	if (phydev->interface == PHY_INTERFACE_MODE_QSGMII)
> +	if (phydev->interface == PHY_INTERFACE_MODE_QSGMII) {
>  		val |= MAC_CFG_QSGMII;
> -	else
> +	} else if (phydev->interface == PHY_INTERFACE_MODE_SGMII) {
>  		val |= MAC_CFG_SGMII;
> +	} else if (phy_interface_mode_is_rgmii(phydev->interface)) {

Nitpick:
I don't know much the difference between that one and 
phy_interface_is_rgmii wrt when one should be used and not the other, 
but seeing the implementation 
(https://elixir.bootlin.com/linux/latest/source/include/linux/phy.h#L999)... 
we should be safe :) Since you already have a phydev in hands at that 
time, maybe using phy_interface_is_rgmii would be cleaner? (shorter).

> +		val |= MAC_CFG_RGMII;
> +	} else {
> +		ret = -EINVAL;
> +		goto err;
> +	}
> 
>  	ret = phy_base_write(phydev, MSCC_PHY_MAC_CFG_FASTLINK, val);
>  	if (ret)
>  		goto err;
> 
> -	val = PROC_CMD_MCB_ACCESS_MAC_CONF | PROC_CMD_RST_CONF_PORT |
> -		PROC_CMD_READ_MOD_WRITE_PORT;
> -	if (phydev->interface == PHY_INTERFACE_MODE_QSGMII)
> -		val |= PROC_CMD_QSGMII_MAC;
> -	else
> -		val |= PROC_CMD_SGMII_MAC;
> +	if (!phy_interface_mode_is_rgmii(phydev->interface)) {

Ditto.

Thanks,
Quentin
