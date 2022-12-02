Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14CD2640D07
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 19:23:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234029AbiLBSXh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 13:23:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233783AbiLBSXg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 13:23:36 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3930BD94;
        Fri,  2 Dec 2022 10:23:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=R0fGDqmvQrSQkxfa81/zaMzQhWSTRfKrZBbNxZjHPdY=; b=vpxC4NupKJoV9CYI2lEnN260KV
        cZ9bN7e+5IrBfxlAG8Qx9W+b3mfCLlVOtT1fpMztUKTZ2lJP4o3qb5YCDifKM43sOGcbWbHKdG61l
        UbO6hI6QOAY+84XOUdV2vatxZgXjPWewt92Pnb29D233Oh6sPzZ8pDJVQu22bkxOJ9ug=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1p1Agi-004Clh-Si; Fri, 02 Dec 2022 19:23:04 +0100
Date:   Fri, 2 Dec 2022 19:23:04 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Walle <michael@walle.cc>
Cc:     Xu Liang <lxu@maxlinear.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH net-next v1 1/4] net: phy: mxl-gpy: add MDINT workaround
Message-ID: <Y4pCiOHgNCPLyZzA@lunn.ch>
References: <20221202151204.3318592-1-michael@walle.cc>
 <20221202151204.3318592-2-michael@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221202151204.3318592-2-michael@walle.cc>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 02, 2022 at 04:12:01PM +0100, Michael Walle wrote:
> At least the GPY215B and GPY215C has a bug where it is still driving the
> interrupt line (MDINT) even after the interrupt status register is read
> and its bits are cleared. This will cause an interrupt storm.
> 
> Although the MDINT is multiplexed with a GPIO pin and theoretically we
> could switch the pinmux to GPIO input mode, this isn't possible because
> the access to this register will stall exactly as long as the interrupt
> line is asserted. We exploit this very fact and just read a random
> internal register in our interrupt handler. This way, it will be delayed
> until the external interrupt line is released and an interrupt storm is
> avoided.
> 
> The internal register access via the mailbox was deduced by looking at
> the downstream PHY API because the datasheet doesn't mention any of
> this.
> 
> Signed-off-by: Michael Walle <michael@walle.cc>
> ---
>  drivers/net/phy/mxl-gpy.c | 83 +++++++++++++++++++++++++++++++++++++++
>  1 file changed, 83 insertions(+)
> 
> diff --git a/drivers/net/phy/mxl-gpy.c b/drivers/net/phy/mxl-gpy.c
> index 0ff7ef076072..20e610dda891 100644
> --- a/drivers/net/phy/mxl-gpy.c
> +++ b/drivers/net/phy/mxl-gpy.c
> @@ -9,6 +9,7 @@
>  #include <linux/module.h>
>  #include <linux/bitfield.h>
>  #include <linux/hwmon.h>
> +#include <linux/mutex.h>
>  #include <linux/phy.h>
>  #include <linux/polynomial.h>
>  #include <linux/netdevice.h>
> @@ -81,6 +82,14 @@
>  #define VSPEC1_TEMP_STA	0x0E
>  #define VSPEC1_TEMP_STA_DATA	GENMASK(9, 0)
>  
> +/* Mailbox */
> +#define VSPEC1_MBOX_DATA	0x5
> +#define VSPEC1_MBOX_ADDRLO	0x6
> +#define VSPEC1_MBOX_CMD		0x7
> +#define VSPEC1_MBOX_CMD_ADDRHI	GENMASK(7, 0)
> +#define VSPEC1_MBOX_CMD_RD	(0 << 8)
> +#define VSPEC1_MBOX_CMD_READY	BIT(15)
> +
>  /* WoL */
>  #define VPSPEC2_WOL_CTL		0x0E06
>  #define VPSPEC2_WOL_AD01	0x0E08
> @@ -88,7 +97,15 @@
>  #define VPSPEC2_WOL_AD45	0x0E0A
>  #define WOL_EN			BIT(0)
>  
> +/* Internal registers, access via mbox */
> +#define REG_GPIO0_OUT		0xd3ce00
> +
>  struct gpy_priv {
> +	struct phy_device *phydev;
> +
> +	/* serialize mailbox acesses */
> +	struct mutex mbox_lock;
> +

>  static int gpy_probe(struct phy_device *phydev)
>  {
>  	struct device *dev = &phydev->mdio.dev;
> @@ -228,7 +286,9 @@ static int gpy_probe(struct phy_device *phydev)
>  	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
>  	if (!priv)
>  		return -ENOMEM;
> +	priv->phydev = phydev;

I don't think you use this anywhere. Maybe in one of the following
patches?

	Andrew
