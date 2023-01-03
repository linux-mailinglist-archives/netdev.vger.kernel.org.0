Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4220565BD69
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 10:48:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236923AbjACJr3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 04:47:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236868AbjACJq6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 04:46:58 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0357E0D4;
        Tue,  3 Jan 2023 01:46:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=9vieuoe0VgancC+Vnw4hbAtvMmDWGV3XLVPMbJmvafw=; b=DjP3AFWSIgtAoq9nrYBevpsOux
        8+IfN83nBYtYLtUipjJF0PAXFkh4+KLpe4+C9WMwHPwnIhUNLwS8j8uzlyk2eZD/Q4R8OoaqgmKrL
        fgjU/hxE+F90CfGSvJSNY9v7hXKqLJZTQLxfYAko6A3O7NjZ64iC5kXu+NRjoF/jG9YsQajZpRkzB
        QqNObvOdiEpWXtfQXAsA03wndml1yT1FO3ELg7nXGGfEygUW+hG0OGKzwG3+81hyxxeNBrdR+Hvz7
        Lo5WgayyUY7/D3N9okFGQWjhg/SsUhj9HTBvhi9d658sx/+sYwE1kxttlAKMa2WNM2ju8FwG1hb/Y
        nlDQQ89A==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35898)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pCdsa-0005AO-H6; Tue, 03 Jan 2023 09:46:44 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pCdsU-0001x7-ML; Tue, 03 Jan 2023 09:46:38 +0000
Date:   Tue, 3 Jan 2023 09:46:38 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Clark Wang <xiaoning.wang@nxp.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, mcoquelin.stm32@gmail.com,
        andrew@lunn.ch, hkallweit1@gmail.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] net: phylink: add a function to resume phy alone to
 fix resume issue with WoL enabled
Message-ID: <Y7P5frCvcYOlzrbz@shell.armlinux.org.uk>
References: <20221221080144.2549125-1-xiaoning.wang@nxp.com>
 <20221221080144.2549125-2-xiaoning.wang@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221221080144.2549125-2-xiaoning.wang@nxp.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 21, 2022 at 04:01:43PM +0800, Clark Wang wrote:
> Issue we met:
> On some platforms, mac cannot work after resumed from the suspend with WoL
> enabled.
> 
> The cause of the issue:
> 1. phylink_resolve() is in a workqueue which will not be executed immediately.
>    This is the call sequence:
>        phylink_resolve()->phylink_link_up()->pl->mac_ops->mac_link_up()
>    For stmmac driver, mac_link_up() will set the correct speed/duplex...
>    values which are from link_state.
> 2. In stmmac_resume(), it will call stmmac_hw_setup() after called the
>    phylink_resume(), because mac need phy rx_clk to do the reset.
>    stmmac_core_init() is called in function stmmac_hw_setup(), which will
>    reset the mac and set the speed/duplex... to default value.
> Conclusion: Because phylink_resolve() cannot determine when it is called, it
>             cannot be guaranteed to be called after stmmac_core_init().
> 	    Once stmmac_core_init() is called after phylink_resolve(),
> 	    the mac will be misconfigured and cannot be used.
> 
> In order to avoid this problem, add a function called phylink_phy_resume()
> to resume phy separately. This eliminates the need to call phylink_resume()
> before stmmac_hw_setup().
> 
> Add another judgement before called phy_start() in phylink_start(). This way
> phy_start() will not be called multiple times when resumes. At the same time,
> it may not affect other drivers that do not use phylink_phy_resume().
> 
> Signed-off-by: Clark Wang <xiaoning.wang@nxp.com>
> ---
>  drivers/net/phy/phylink.c | 21 ++++++++++++++++++++-
>  include/linux/phylink.h   |  1 +
>  2 files changed, 21 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
> index 09cc65c0da93..5bab59142579 100644
> --- a/drivers/net/phy/phylink.c
> +++ b/drivers/net/phy/phylink.c
> @@ -1939,7 +1939,7 @@ void phylink_start(struct phylink *pl)
>  	}
>  	if (poll)
>  		mod_timer(&pl->link_poll, jiffies + HZ);
> -	if (pl->phydev)
> +	if (pl->phydev && pl->phydev->state < PHY_UP)

I'm really not happy with this - not only does this subvert the checks in
phy_start(), it's a layering violation, and it delves into internals of
phylib in an unprotected way.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
