Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FDB364452E
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 14:59:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234462AbiLFN7w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 08:59:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231255AbiLFN7u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 08:59:50 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 289816163;
        Tue,  6 Dec 2022 05:59:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=XzTi/+CPlea6BjgH4HGU1K3zrFmzxH8ADOjRkaoqvyA=; b=uiQoxcvtSwPnG69c5tBO8nP9vu
        MHeKXPRZyfstw3pLHawm908KSlhUCLPMKSGiHBiyNppN7tSNI4GYnOcTH/a/WwN7PrnSJXDCvQ/jY
        EUf5fvaJHUBsELZccHfH/xhtcwrr28LbZTV/31LXxkh8Q3ySpIF/UD9LulMcFE2QuILs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1p2YTz-004X8E-4t; Tue, 06 Dec 2022 14:59:39 +0100
Date:   Tue, 6 Dec 2022 14:59:39 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Oleksij Rempel <o.rempel@pengutronix.de>
Subject: Re: [PATCH v4 net-next 4/5] drivers/net/phy: add helpers to get/set
 PLCA configuration
Message-ID: <Y49Ky7aCUZxE5Fwg@lunn.ch>
References: <cover.1670329232.git.piergiorgio.beruto@gmail.com>
 <4c6bb420c2169edb31abd5c4d5fe04090ed329e4.1670329232.git.piergiorgio.beruto@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4c6bb420c2169edb31abd5c4d5fe04090ed329e4.1670329232.git.piergiorgio.beruto@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +/* MDIO Manageable Devices (MMDs). */
> +#define MDIO_MMD_OATC14		MDIO_MMD_VEND2

As i said in a comment somewhere, i would prefer you use
MDIO_MMD_VEND2, not MDIO_MMD_OATC14. We want the gentle reminder that
these registers can contain anything the vendor wants, including, but
not limited to, PLCA.

> +/* Open Alliance TC14 PLCA CTRL0 register */
> +#define MDIO_OATC14_PLCA_EN	0x8000  /* PLCA enable */
> +#define MDIO_OATC14_PLCA_RST	0x4000  /* PLCA reset */

These are bits, so use the BIT macro. When this was part of mii.h,
that file used this hex format so it made sense to follow that
format. Now you are in a few file, you should use the macro.

> +/* Open Alliance TC14 PLCA CTRL1 register */
> +#define MDIO_OATC14_PLCA_NCNT	0xff00	/* PLCA node count */
> +#define MDIO_OATC14_PLCA_ID	0x00ff	/* PLCA local node ID */
> +
> +/* Open Alliance TC14 PLCA STATUS register */
> +#define MDIO_OATC14_PLCA_PST	0x8000	/* PLCA status indication */
> +
> +/* Open Alliance TC14 PLCA TOTMR register */
> +#define MDIO_OATC14_PLCA_TOT	0x00ff
> +
> +/* Open Alliance TC14 PLCA BURST register */
> +#define MDIO_OATC14_PLCA_MAXBC	0xff00
> +#define MDIO_OATC14_PLCA_BTMR	0x00ff
> +
> +#endif /* __MDIO_OPEN_ALLIANCE__ */
> diff --git a/drivers/net/phy/phy-c45.c b/drivers/net/phy/phy-c45.c
> index a87a4b3ffce4..dace5d3b29ad 100644
> --- a/drivers/net/phy/phy-c45.c
> +++ b/drivers/net/phy/phy-c45.c
> @@ -8,6 +8,8 @@
>  #include <linux/mii.h>
>  #include <linux/phy.h>
>  
> +#include "mdio-open-alliance.h"
> +
>  /**
>   * genphy_c45_baset1_able - checks if the PMA has BASE-T1 extended abilities
>   * @phydev: target phy_device struct
> @@ -931,6 +933,184 @@ int genphy_c45_fast_retrain(struct phy_device *phydev, bool enable)
>  }
>  EXPORT_SYMBOL_GPL(genphy_c45_fast_retrain);
>  
> +/**
> + * genphy_c45_plca_get_cfg - get PLCA configuration from standard registers
> + * @phydev: target phy_device struct
> + * @plca_cfg: output structure to store the PLCA configuration
> + *
> + * Description: if the PHY complies to the Open Alliance TC14 10BASE-T1S PLCA
> + *   Management Registers specifications, this function can be used to retrieve
> + *   the current PLCA configuration from the standard registers in MMD 31.
> + */
> +int genphy_c45_plca_get_cfg(struct phy_device *phydev,
> +			    struct phy_plca_cfg *plca_cfg)
> +{
> +	int ret;
> +
> +	ret = phy_read_mmd(phydev, MDIO_MMD_OATC14, MDIO_OATC14_PLCA_IDVER);
> +	if (ret < 0)
> +		return ret;
> +
> +	plca_cfg->version = ret;

It would be good to verify this value, and return -ENODEV if it is not
valid.

	Andrew
