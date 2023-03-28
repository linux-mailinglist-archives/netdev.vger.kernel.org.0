Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67C486CBE8A
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 14:05:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232798AbjC1MFu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 08:05:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232371AbjC1MFs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 08:05:48 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 330E493C7
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 05:05:27 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1ph84j-0006Ir-CN; Tue, 28 Mar 2023 14:05:17 +0200
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1ph84g-0006UO-Rj; Tue, 28 Mar 2023 14:05:14 +0200
Date:   Tue, 28 Mar 2023 14:05:14 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Wei Fang <wei.fang@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     kernel@pengutronix.de, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Shenwei Wang <shenwei.wang@nxp.com>,
        Clark Wang <xiaoning.wang@nxp.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Amit Cohen <amcohen@nvidia.com>, Gal Pressman <gal@nvidia.com>,
        Alexandru Tachici <alexandru.tachici@analog.com>,
        Piergiorgio Beruto <piergiorgio.beruto@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH net-next v2 6/8] net: phy: at803x: Make SmartEEE support
 optional and configurable via ethtool
Message-ID: <20230328120514.GF15196@pengutronix.de>
References: <20230327142202.3754446-1-o.rempel@pengutronix.de>
 <20230327142202.3754446-7-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230327142202.3754446-7-o.rempel@pengutronix.de>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-2.3 required=5.0 tests=RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 27, 2023 at 04:22:00PM +0200, Oleksij Rempel wrote:
> This commit makes SmartEEE support in the AR8035 PHY optional and
> configurable through the ethtool eee_set/get interface. Before this
> patch, SmartEEE was always enabled except when a device tree option was
> preventing it. Since EEE support not only provides advantages in power
> management, but can also uncover compatibility issues and other bugs, it
> is beneficial to allow users to control this functionality.
> 
> By making SmartEEE support optional and configurable via ethtool, the
> at803x driver can adapt to different MAC configurations and properly
> handle EEE and LPI features. This flexibility empowers users to manage
> the trade-offs between power management, compatibility, and overall
> performance as needed.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---
>  drivers/net/phy/at803x.c | 126 ++++++++++++++++++++++++++++++++++++---
>  1 file changed, 118 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
> index 653d27a2e62b..4f65b3ebf806 100644
> --- a/drivers/net/phy/at803x.c
> +++ b/drivers/net/phy/at803x.c
> @@ -165,8 +165,18 @@
>  
>  #define AT803X_MMD3_SMARTEEE_CTL1		0x805b
>  #define AT803X_MMD3_SMARTEEE_CTL2		0x805c
> +#define AT803X_MMD3_SMARTEEE_LPI_TIME_LOW	GENMASK(15, 0)
> +#define AT803X_MMD3_SMARTEEE_LPI_TIME_15_0	GENMASK(15, 0)
>  #define AT803X_MMD3_SMARTEEE_CTL3		0x805d
>  #define AT803X_MMD3_SMARTEEE_CTL3_LPI_EN	BIT(8)
> +#define AT803X_MMD3_SMARTEEE_LPI_TIME_HIGH	GENMASK(7, 0)
> +#define AT803X_MMD3_SMARTEEE_LPI_TIME_23_16	GENMASK(23, 16)
> +/* Tx LPI timer resolution */
> +#define AT803X_MMD3_SMARTEEE_LPI_TIME_RESOL_NS	163840
> +#define AT803X_MMD3_SMARTEEE_LPI_TIME_MAX_US	\
> +	((GENMASK(23, 0) * AT803X_MMD3_SMARTEEE_LPI_TIME_RESOL_NS) / \
> +	       NSEC_PER_USEC)
> +#define AT803X_MMD3_SMARTEEE_LPI_TIME_DEF_US	335544
>  
>  #define ATH9331_PHY_ID				0x004dd041
>  #define ATH8030_PHY_ID				0x004dd076
> @@ -302,6 +312,8 @@ struct at803x_priv {
>  	u8 smarteee_lpi_tw_100m;
>  	bool is_fiber;
>  	bool is_1000basex;
> +	bool tx_lpi_on;

@Andrew, this variable can be replace by your phydev->tx_lpi_enabled
variable. Should I wait for your patches went mainline?

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
