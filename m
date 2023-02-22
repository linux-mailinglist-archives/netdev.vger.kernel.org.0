Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7491D69F1D1
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 10:35:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231397AbjBVJf5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Feb 2023 04:35:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232085AbjBVJer (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Feb 2023 04:34:47 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B55F99EF0;
        Wed, 22 Feb 2023 01:32:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=RZxqWOtOiY463rPgMWomV6862Rwqvyak5+4JgTBIxcE=; b=zolW4tU4QDEFF7t28e1uyOMJ87
        QfEpv0FnARRQ59zu5uQF0lrxl1jhqrBewUylyy8cmfCxAA3mD7EqQkZng30DJeg+2XSPEXzx2MYg4
        lmiyLax98k7zjNjou+e3o3DobITCUxO0aEXvve+slkaGtEuXDkPVamVb2LHL+tVpHB44RQ7TH1f35
        0zUg00FbngPdCHr334Ioi8oFbrT5V/CZRaQ1afRa1YlZ0Z/WWJshJu+JpkSQ45jwc5N8epezwJu8/
        kzY+UnrxvopsXckpkZat7J4NtyHtUoSgJR4x7Mh6hU+vatM7f3h4FJh9Ak5bL4HgQZycQu1j9J0QB
        fULZdLxw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:48670)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pUlT3-0006ka-Cy; Wed, 22 Feb 2023 09:31:17 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pUlSz-00035v-JI; Wed, 22 Feb 2023 09:31:13 +0000
Date:   Wed, 22 Feb 2023 09:31:13 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Clark Wang <xiaoning.wang@nxp.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, mcoquelin.stm32@gmail.com,
        andrew@lunn.ch, hkallweit1@gmail.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-imx@nxp.com
Subject: Re: [PATCH net-next V4 1/2] net: phylink: add a function to resume
 PHY alone to fix resume issue with WoL enabled
Message-ID: <Y/Xg4T+Zw3jW0/Lb@shell.armlinux.org.uk>
References: <20230222092636.1984847-1-xiaoning.wang@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230222092636.1984847-1-xiaoning.wang@nxp.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

net-next is closed due to the merge window. Please resubmit after
6.3-rc1. Thanks.

On Wed, Feb 22, 2023 at 05:26:35PM +0800, Clark Wang wrote:
> Issue we met:
> On some platforms, MAC cannot work after resumed from the suspend with WoL
> enabled.
> 
> The cause of the issue:
> 1. phylink_resolve() is in a workqueue which will not be executed immediately.
>    This is the call sequence:
>        phylink_resolve()->phylink_link_up()->pl->mac_ops->mac_link_up()
>    For stmmac driver, mac_link_up() will set the correct speed/duplex...
>    values which are from link_state.
> 2. In stmmac_resume(), it will call stmmac_hw_setup() after called the
>    phylink_resume(), because MAC need PHY rx_clk to do the reset.
>    stmmac_core_init() is called in function stmmac_hw_setup(), which will
>    reset the MAC and set the speed/duplex... to default value.
> Conclusion: Because phylink_resolve() cannot determine when it is called, it
>             cannot be guaranteed to be called after stmmac_core_init().
> 	    Once stmmac_core_init() is called after phylink_resolve(),
> 	    the MAC will be misconfigured and cannot be used.
> 
> In order to avoid this problem, add a function called phylink_phy_resume()
> to resume PHY separately. This eliminates the need to call phylink_resume()
> before stmmac_hw_setup().
> 
> Add another judgement before called phy_start() in phylink_start(). This way
> phy_start() will not be called multiple times when resumes. At the same time,
> it may not affect other drivers that do not use phylink_phy_resume().
> 
> Signed-off-by: Clark Wang <xiaoning.wang@nxp.com>
> ---
> V2 change:
>  - add mac_resume_phy_separately flag to struct phylink to mark if the MAC
>    driver uses the phylink_phy_resume() first.
> V3 change:
>  - add brace to avoid ambiguous 'else'
>    Reported-by: kernel test robot <lkp@intel.com>
> V4:
> Many thanks to Jakub and Russel for their suggestions, here are the changes for V4.
>  - Unify MAC and PHY in comments and subject to uppercase.
>  - Add subject of the sentence.
>  - Move && to the end of the line
>  - Add notice in the comment of function phylink_phy_resume()
> ---
>  drivers/net/phy/phylink.c | 35 +++++++++++++++++++++++++++++++++--
>  include/linux/phylink.h   |  1 +
>  2 files changed, 34 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
> index ea8fcce5b2d9..0be57e9463d9 100644
> --- a/drivers/net/phy/phylink.c
> +++ b/drivers/net/phy/phylink.c
> @@ -80,6 +80,8 @@ struct phylink {
>  	DECLARE_PHY_INTERFACE_MASK(sfp_interfaces);
>  	__ETHTOOL_DECLARE_LINK_MODE_MASK(sfp_support);
>  	u8 sfp_port;
> +
> +	bool mac_resume_phy_separately;
>  };
>  
>  #define phylink_printk(level, pl, fmt, ...) \
> @@ -1509,6 +1511,7 @@ struct phylink *phylink_create(struct phylink_config *config,
>  		return ERR_PTR(-EINVAL);
>  	}
>  
> +	pl->mac_resume_phy_separately = false;
>  	pl->using_mac_select_pcs = using_mac_select_pcs;
>  	pl->phy_state.interface = iface;
>  	pl->link_interface = iface;
> @@ -1942,8 +1945,12 @@ void phylink_start(struct phylink *pl)
>  	}
>  	if (poll)
>  		mod_timer(&pl->link_poll, jiffies + HZ);
> -	if (pl->phydev)
> -		phy_start(pl->phydev);
> +	if (pl->phydev) {
> +		if (!pl->mac_resume_phy_separately)
> +			phy_start(pl->phydev);
> +		else
> +			pl->mac_resume_phy_separately = false;
> +	}
>  	if (pl->sfp_bus)
>  		sfp_upstream_start(pl->sfp_bus);
>  }
> @@ -2023,6 +2030,30 @@ void phylink_suspend(struct phylink *pl, bool mac_wol)
>  }
>  EXPORT_SYMBOL_GPL(phylink_suspend);
>  
> +/**
> + * phylink_phy_resume() - resume PHY alone
> + * @pl: a pointer to a &struct phylink returned from phylink_create()
> + *
> + * In the MAC driver using phylink, if the MAC needs the clock of the PHY
> + * when it resumes, it can call this function to resume the PHY separately.
> + * Then proceed to MAC resume operations.
> + * 
> + * Note: This function MUST ONLY be called before calling phylink_start()
> + *       in the MAC resume function.
> + */
> +void phylink_phy_resume(struct phylink *pl)
> +{
> +	ASSERT_RTNL();
> +
> +	if (!test_bit(PHYLINK_DISABLE_MAC_WOL, &pl->phylink_disable_state) &&
> +	    pl->phydev) {
> +		phy_start(pl->phydev);
> +		pl->mac_resume_phy_separately = true;
> +	}
> +
> +}
> +EXPORT_SYMBOL_GPL(phylink_phy_resume);
> +
>  /**
>   * phylink_resume() - handle a network device resume event
>   * @pl: a pointer to a &struct phylink returned from phylink_create()
> diff --git a/include/linux/phylink.h b/include/linux/phylink.h
> index c492c26202b5..6edfab5f754c 100644
> --- a/include/linux/phylink.h
> +++ b/include/linux/phylink.h
> @@ -589,6 +589,7 @@ void phylink_stop(struct phylink *);
>  
>  void phylink_suspend(struct phylink *pl, bool mac_wol);
>  void phylink_resume(struct phylink *pl);
> +void phylink_phy_resume(struct phylink *pl);
>  
>  void phylink_ethtool_get_wol(struct phylink *, struct ethtool_wolinfo *);
>  int phylink_ethtool_set_wol(struct phylink *, struct ethtool_wolinfo *);
> -- 
> 2.34.1
> 
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
