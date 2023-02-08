Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F08D68EFD7
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 14:33:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231243AbjBHNdS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 08:33:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230430AbjBHNdR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 08:33:17 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 909F83A87
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 05:32:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=MvQdLI3Bfs8SWdCC/a8nzWKrc1dNg1a+wGdZBOHt6sg=; b=OItGhxR3lLxTOyRv+U0uXdgJUF
        Z7W1PlBU+mC4ndecMyjVziWedj1A5rwSplaIeOTLz0LiAgpx6CQI9PzkWM+ubjHSunHwOMN3rx9+d
        qCHgmAPXycuGOxPkSUYsu8pogyO3g15U/3OSDDYrlM9AMZ5zct8wjzdFS2BmO4AD/17TOQoYjcyWm
        Df/MkZYje+UStD8rT/6aZdeyyY4CUNDQqbibs7e2tx3jYx89nIwX/1vcJmbXuXDMdNK54jAMjybII
        +Y63I7mkvaMITjAUlIrU+tFONmijjQTE6kV44e1hgp/D71D5YA7AAB0KzavbtQrtFUzH0Y4woGTsV
        CVsuAWYA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:36466)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pPkYg-0005hW-Km; Wed, 08 Feb 2023 13:32:22 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pPkYU-0003i8-Fw; Wed, 08 Feb 2023 13:32:10 +0000
Date:   Wed, 8 Feb 2023 13:32:10 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Guan Wentao <guanwentao@uniontech.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, mcoquelin.stm32@gmail.com,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] net: stmmac: get phydev->interface from mac for mdio phy
 init
Message-ID: <Y+OkWiGAr1ysMxSt@shell.armlinux.org.uk>
References: <20230208124025.5828-1-guanwentao@uniontech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230208124025.5828-1-guanwentao@uniontech.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[Not fully over covid but I spotted this and don't agree with this change]

On Wed, Feb 08, 2023 at 08:40:25PM +0800, Guan Wentao wrote:
> The phy->interface from mdiobus_get_phy is default from phy_device_create.
> In some phy devices like at803x, use phy->interface to init rgmii delay.
> Use plat->phy_interface to init if know from stmmac_probe_config_dt.
> 
> Fixes: 74371272f97f ("net: stmmac: Convert to phylink and remove phylib logic")
> Signed-off-by: Guan Wentao <guanwentao@uniontech.com>
> ---
>  drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> index 1a5b8dab5e9b..debfcb045c22 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> @@ -1162,6 +1162,12 @@ static int stmmac_init_phy(struct net_device *dev)
>  			return -ENODEV;
>  		}
>  
> +		/* If we know the interface, it defines which PHY interface */
> +		if (priv->plat->phy_interface > 0) {
> +			phydev->interface = priv->plat->phy_interface;
> +			netdev_dbg(priv->dev, "Override default phy interface\n");
> +		}
> +

Why do you need to do this?

You call phylink_create() with ->phy_interface, which tells phylink
which interface you want to use. Then, phylink_connect_phy().

phylink will then call phylink_attach_phy() and then phy_attach_direct()
with the interface you asked for (which was ->phy_interface).

phy_attach_direct() will then set phydev->interface to that interface
mode.

So, I think what you have above is a hack rather than a proper fix,
and the real problem is elsewhere.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
