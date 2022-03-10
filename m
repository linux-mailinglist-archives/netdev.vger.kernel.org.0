Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7772A4D5252
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 20:44:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343527AbiCJTUu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 14:20:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237363AbiCJTUt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 14:20:49 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B92AB7C54;
        Thu, 10 Mar 2022 11:19:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=+ux52yQrmOIHTp92xmuhCZ/Mwz615e3tMXTxWgDbPLw=; b=spU9UH5LCCexXx5va1ti5hdUtj
        tkfrXi1vszkVVeGy8acnWqg668BRfY04aOGNY4bTcc5LQ9uek/mQRsee6I3fan8SSjalRy1G33klJ
        Q8IW963Cv8l5/Na2q7lMtjnBSXPnLY1nOvcQimFoWaU9fU03ICeUxt1icQ3NGdYpzdg0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nSOJy-00AAri-PO; Thu, 10 Mar 2022 20:19:34 +0100
Date:   Thu, 10 Mar 2022 20:19:34 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, paskripkin@gmail.com
Subject: Re: [PATCH net-next v1 4/4] net: usb: asix: suspend internal PHY if
 external is used
Message-ID: <YipPRtJSlSh6YLHY@lunn.ch>
References: <20220310114434.3465481-1-o.rempel@pengutronix.de>
 <20220310114434.3465481-4-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220310114434.3465481-4-o.rempel@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 10, 2022 at 12:44:34PM +0100, Oleksij Rempel wrote:
> In case external PHY is used, we need to take care of internal PHY.
> Since there are no methods to disable this PHY from the MAC side, we
> need to suspend it.
> This we reduce electrical noise (PHY is continuing to send FLPs) and power
> consumption by 0,22W.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---
>  drivers/net/usb/asix.h         |  3 +++
>  drivers/net/usb/asix_devices.c | 16 +++++++++++++++-
>  2 files changed, 18 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/usb/asix.h b/drivers/net/usb/asix.h
> index 072760d76a72..8a087205355d 100644
> --- a/drivers/net/usb/asix.h
> +++ b/drivers/net/usb/asix.h
> @@ -158,6 +158,8 @@
>  #define AX_EEPROM_MAGIC		0xdeadbeef
>  #define AX_EEPROM_LEN		0x200
>  
> +#define AX_INTERNAL_PHY_ADDR	0x10
> +
>  /* This structure cannot exceed sizeof(unsigned long [5]) AKA 20 bytes */
>  struct asix_data {
>  	u8 multi_filter[AX_MCAST_FILTER_SIZE];
> @@ -183,6 +185,7 @@ struct asix_common_private {
>  	struct asix_rx_fixup_info rx_fixup_info;
>  	struct mii_bus *mdio;
>  	struct phy_device *phydev;
> +	struct phy_device *phydev_int;
>  	u16 phy_addr;
>  	bool embd_phy;
>  	u8 chipcode;
> diff --git a/drivers/net/usb/asix_devices.c b/drivers/net/usb/asix_devices.c
> index fb617eb551bb..2c63fbe32ca2 100644
> --- a/drivers/net/usb/asix_devices.c
> +++ b/drivers/net/usb/asix_devices.c
> @@ -679,6 +679,20 @@ static int ax88772_init_phy(struct usbnet *dev)
>  
>  	phy_attached_info(priv->phydev);
>  
> +	if (priv->embd_phy)
> +		return 0;

Minor nit pick: There appears to be some inconsistency with internal
and embedded. I think they are meant to mean the same thing? Maybe
replace internal with embedded in this patch?

The rest looks O.K.

    Andrew
