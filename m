Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B741669CF2F
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 15:18:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231513AbjBTOSt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 09:18:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231466AbjBTOSr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 09:18:47 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B192610A8E;
        Mon, 20 Feb 2023 06:18:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=F3HH6Boj0AYyg5UcJPeckqn32F4X2DjoktZw34EHU4o=; b=sUSzxP4ZjvNMlgzwhu3zPNRGcC
        uDYhpqh5b9StXo5d5RYzXD9k8Bivo48/otIgNJ2Lf2ML/BmTHxx/rYwXAdPiw6DgUJZkyTmHuxqs1
        kiXi7SM351vxEGP5WmUNqkoXx4xi6CuvolPFAfuoGNCBskP3LTdNhbBQNtLKnGizUaVPaE2wVlofv
        FQXnT4w4hgv2QS0IHJfFfFRqLHL46m+4PFSoGC37zmHqSiETjRHntkrE8M6Z6KtG4Uat5zo5D6mMQ
        ehkBG/RlKRC9mUVNnt+6q/40rbbdd39wDMEHjR7RGoj6jH7opHP53mmQI5qYKoHranRWnIpNEApXd
        A+mi2y+Q==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:45172)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pU702-0004b5-C4; Mon, 20 Feb 2023 14:18:38 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pU701-0001HQ-6E; Mon, 20 Feb 2023 14:18:37 +0000
Date:   Mon, 20 Feb 2023 14:18:37 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v1 3/4] net: phy: do not force EEE support
Message-ID: <Y/OBPZRGM+viGp+8@shell.armlinux.org.uk>
References: <20230220135605.1136137-1-o.rempel@pengutronix.de>
 <20230220135605.1136137-4-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230220135605.1136137-4-o.rempel@pengutronix.de>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

A couple of minor points, but not sufficient not to prevent merging
this.

On Mon, Feb 20, 2023 at 02:56:04PM +0100, Oleksij Rempel wrote:
> @@ -865,7 +864,12 @@ EXPORT_SYMBOL_GPL(genphy_c45_read_eee_abilities);
>   */
>  int genphy_c45_an_config_eee_aneg(struct phy_device *phydev)
>  {
> -	return genphy_c45_write_eee_adv(phydev, phydev->supported_eee);
> +	__ETHTOOL_DECLARE_LINK_MODE_MASK(adv) = {};

It would be nice to avoid this initialisation in the case where
eee_enabled is true, as this takes CPU cycles. However, not too
bothered about it as this isn't a fast path.

> +
> +	if (!phydev->eee_enabled)
> +		return genphy_c45_write_eee_adv(phydev, adv);
> +
> +	return genphy_c45_write_eee_adv(phydev, phydev->advertising_eee);
>  }
>  
>  /**
> @@ -1431,17 +1435,17 @@ EXPORT_SYMBOL(genphy_c45_ethtool_get_eee);
>  int genphy_c45_ethtool_set_eee(struct phy_device *phydev,
>  			       struct ethtool_eee *data)
>  {
> -	__ETHTOOL_DECLARE_LINK_MODE_MASK(adv) = {};
>  	int ret;
>  
>  	if (data->eee_enabled) {
> +		phydev->eee_enabled = true;
>  		if (data->advertised)
> -			adv[0] = data->advertised;
> -		else
> -			linkmode_copy(adv, phydev->supported_eee);
> +			phydev->advertising_eee[0] = data->advertised;

Is there a reason not to use ethtool_convert_legacy_u32_to_link_mode()?
I'm guessing this will be more efficient.

Other than that, looks good.

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Thanks!

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
