Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2660D642C56
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 16:58:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232132AbiLEP6L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 10:58:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231688AbiLEP6J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 10:58:09 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B02CFCDD;
        Mon,  5 Dec 2022 07:58:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=jfwGyu4ve1j0oVhiOWykH2evozLZYPU0bSyGSUzM28M=; b=bnKhfYlvkdihXqIw0aPE1in3Q4
        mVseSJdI4DmZ+GP+Z1xoKGH6EnJqz58opFiElt2nfI4b0Nwk80PJNMcd8iUE7Yjk6feiCjmx6poKK
        ZxkvLHGLbToWDHmoYFJ5t+ax1nnKf0IwyUwLEU7n5OHOn8Vq2yhPA+lvLOiQYc4iKdrxQFjIsguj7
        ZFaqvMUmfmYE4CfcqHEO0eYg2qmEeU7eDrXZPaZXdtw1f1HfTB9aMt6G0xAyiuOQFW0gFYR809G+Q
        nwNyvw1Fq2BuI+ksEU+w7CHVRkql5jd8C9wmA57SIwDUEYaZfG/uepl1PsrML6g11vx36oHQdAPN/
        LD7gUW0A==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35580)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1p2Dqt-0006vr-QB; Mon, 05 Dec 2022 15:57:55 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1p2Dqr-0007M9-R6; Mon, 05 Dec 2022 15:57:53 +0000
Date:   Mon, 5 Dec 2022 15:57:53 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Claudiu Beznea <claudiu.beznea@microchip.com>
Cc:     nicolas.ferre@microchip.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        andrew@lunn.ch, hkallweit1@gmail.com, sergiu.moga@microchip.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] net: phylink: add helper to initialize phylink's
 phydev
Message-ID: <Y44VATEVPpEOBz/3@shell.armlinux.org.uk>
References: <20221205153328.503576-1-claudiu.beznea@microchip.com>
 <20221205153328.503576-2-claudiu.beznea@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221205153328.503576-2-claudiu.beznea@microchip.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 05, 2022 at 05:33:27PM +0200, Claudiu Beznea wrote:
> Add helper to initialize phydev embedded in a phylink object.
> 
> Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
> ---
>  drivers/net/phy/phylink.c | 10 ++++++++++
>  include/linux/phylink.h   |  1 +
>  2 files changed, 11 insertions(+)
> 
> diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
> index 09cc65c0da93..1e2478b8cd5f 100644
> --- a/drivers/net/phy/phylink.c
> +++ b/drivers/net/phy/phylink.c
> @@ -2541,6 +2541,16 @@ int phylink_ethtool_set_eee(struct phylink *pl, struct ethtool_eee *eee)
>  }
>  EXPORT_SYMBOL_GPL(phylink_ethtool_set_eee);
>  
> +/**
> + * phylink_init_phydev() - initialize phydev associated to phylink
> + * @pl: a pointer to a &struct phylink returned from phylink_create()
> + */
> +int phylink_init_phydev(struct phylink *pl)
> +{
> +	return phy_init_hw(pl->phydev);
> +}
> +EXPORT_SYMBOL_GPL(phylink_init_phydev);

I'd guess this is something that many MAC drivers will need to do when
resuming if the PHY has lost power.

Maybe a better solution would be to integrate it into phylink_resume(),
when we know that the PHY has lost power - maybe the MAC driver can
tell phylink that detail, and be updated to use phylink_suspend() and
phylink_resume() ?

macb_set_wol() sets bp->wol's MACB_WOL_ENABLED flag depending on
whether WAKE_MAGIC is set in wolopts. No other wolopts are supported.
Generic code sets netdev->wol_enabled if set_wol() was successful and
wolopts is nonzero, indicating that WoL is enabled, and thus
phylink_stop() won't be called if WoL is enabled (similar to what
macb_suspend() is doing.)

Given that the macb MAC seems to be implementing WoL, it should call
phylink_suspend() with mac_wol=true.

Please can you look into this, thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
