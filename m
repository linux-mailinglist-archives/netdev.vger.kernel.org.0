Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79E6952D5A2
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 16:10:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239406AbiESOKX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 10:10:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239016AbiESOKW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 10:10:22 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D37FC6129E;
        Thu, 19 May 2022 07:10:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=to/gE6L+q0zD4a47p6IDhLpRguUiZpp9mAgkla7qJ7w=; b=fOisF9OLkcQKp7mCPGiV7oQ0KG
        iIsn968OLmZfCCPxAoYGt1QY7qjDErfEHRSX/U8Qoc4u+s95/8HirfQZqAfvgSb3xCAHmmckLEdI6
        zcbXwTbWcv9vTVOJfNqqYHvGy0M+6HQwM8QgCAS/FwgWiyRNob/BYq2ge+eElw6YqlwY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nrgr1-003Ukg-2y; Thu, 19 May 2022 16:10:15 +0200
Date:   Thu, 19 May 2022 16:10:15 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Maxime Chevallier <maxime.chevallier@bootlin.com>
Cc:     davem@davemloft.net, Rob Herring <robh+dt@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, thomas.petazzoni@bootlin.com,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Richard Cochran <richardcochran@gmail.com>,
        Horatiu.Vultur@microchip.com, Allan.Nielsen@microchip.com,
        UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net-next 4/6] net: phy: Add support for inband extensions
Message-ID: <YoZPx3s353hJcGnt@lunn.ch>
References: <20220519135647.465653-1-maxime.chevallier@bootlin.com>
 <20220519135647.465653-5-maxime.chevallier@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220519135647.465653-5-maxime.chevallier@bootlin.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int phy_set_inband_ext(struct phy_device *phydev, u32 mask, u32 ext)
> +{
> +	int ret;
> +
> +	if (!phy_interface_has_inband_ext(phydev->interface))
> +		return -EOPNOTSUPP;
> +
> +	if (!phydev->drv->inband_ext_config)
> +		return -EOPNOTSUPP;
> +
> +	ret = phydev->drv->inband_ext_config(phydev, mask, ext);
> +	if (ret)
> +		return ret;
> +
> +	phydev->inband_ext.enabled &= ~mask;
> +	phydev->inband_ext.enabled |= (mask & ext);

You appear to be missing locking in this patchset.

> +int phy_inband_ext_enable(struct phy_device *phydev, u32 ext)
> +{
> +	return phy_set_inband_ext(phydev, ext, ext);

There should be an -EOPNOTSUPP here is requested to enable an
extension which is not available.

> +}
> +EXPORT_SYMBOL(phy_inband_ext_enable);
> +
> +int phy_inband_ext_disable(struct phy_device *phydev, u32 ext)
> +{
> +	return phy_set_inband_ext(phydev, ext, 0);

And the same here.

> +}
> +EXPORT_SYMBOL(phy_inband_ext_disable);
> +
> +int phy_inband_ext_set_available(struct phy_device *phydev, u32 mask, u32 ext)
> +{
> +	if (!(mask & phydev->drv->inband_ext))
> +		return -EOPNOTSUPP;
> +
> +	phydev->inband_ext.available &= ~mask;
> +	phydev->inband_ext.available |= (mask & ext);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(phy_inband_ext_set_available);
> +
> diff --git a/include/linux/phy.h b/include/linux/phy.h
> index 4a2731c78590..6b08f49bce5b 100644
> --- a/include/linux/phy.h
> +++ b/include/linux/phy.h
> @@ -190,6 +190,21 @@ static inline void phy_interface_set_rgmii(unsigned long *intf)
>  	__set_bit(PHY_INTERFACE_MODE_RGMII_TXID, intf);
>  }
>  
> +/*
> + * TODO : Doc
> + */
> +enum {
> +	__PHY_INBAND_EXT_PCH = 0,
> +};
> +
> +#define PHY_INBAND_EXT_PCH	BIT(__PHY_INBAND_EXT_PCH)

the documentation is important here, since it makes it clear if these
are values directly taken from the specification, or if these are
linux specific, and the driver needs to map from linux to whatever the
spec calls them.

     Andrew
