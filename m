Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DE686A05EF
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 11:22:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233256AbjBWKWB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 05:22:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233993AbjBWKVv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 05:21:51 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BC8B51902;
        Thu, 23 Feb 2023 02:21:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=2qAVv/2mOlvFxStqbQsgpUYCmjvX2Lnr+60Cn2DTsOU=; b=TgElQnDUMw4O3xsGHQ0dJdiheG
        URc397+tCp3J+KSSx6tAGEb40b5LerjygN7eqjHeDDLjIbUAwMETKH1QXycPPHcohlNmZ8zzIRUXd
        lcte98hg035mDkUfApbK+yWYolqKTcS2kpGizXeQIy2VW0+n5JwVo2K1te5F9PePE2GWmMNFc5RLi
        5rLcGiuZPxdW/mVv7KRFIoceqh84SpXo2KufB2nel69UKrokaSiQbbSI160tCl3lsHw70i8sXSDR/
        /jiZjwtQCyyYIPCGYC/w1IFGhgRZkviu9ZbFFeqOawrElgIUsFJc8wr4X3m308XILDYsCRfeQDN1T
        1FDZX5rQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:41264)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pV8jM-0007tA-RL; Thu, 23 Feb 2023 10:21:40 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pV8jJ-00045z-AR; Thu, 23 Feb 2023 10:21:37 +0000
Date:   Thu, 23 Feb 2023 10:21:37 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Clark Wang <xiaoning.wang@nxp.com>, peppe.cavallaro@st.com,
        alexandre.torgue@foss.st.com, joabreu@synopsys.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        mcoquelin.stm32@gmail.com, andrew@lunn.ch, hkallweit1@gmail.com,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-imx@nxp.com
Subject: Re: [PATCH V3 1/2] net: phylink: add a function to resume phy alone
 to fix resume issue with WoL enabled
Message-ID: <Y/c+MQtgtKFDjEZF@shell.armlinux.org.uk>
References: <20230202081559.3553637-1-xiaoning.wang@nxp.com>
 <83a8fb89ac7a69d08c9ea1422dade301dcc87297.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <83a8fb89ac7a69d08c9ea1422dade301dcc87297.camel@redhat.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 23, 2023 at 11:09:04AM +0100, Paolo Abeni wrote:
> On Thu, 2023-02-02 at 16:15 +0800, Clark Wang wrote:
> > Issue we met:
> > On some platforms, mac cannot work after resumed from the suspend with WoL
> > enabled.
> > 
> > The cause of the issue:
> > 1. phylink_resolve() is in a workqueue which will not be executed immediately.
> >    This is the call sequence:
> >        phylink_resolve()->phylink_link_up()->pl->mac_ops->mac_link_up()
> >    For stmmac driver, mac_link_up() will set the correct speed/duplex...
> >    values which are from link_state.
> > 2. In stmmac_resume(), it will call stmmac_hw_setup() after called the
> >    phylink_resume(), because mac need phy rx_clk to do the reset.
> >    stmmac_core_init() is called in function stmmac_hw_setup(), which will
> >    reset the mac and set the speed/duplex... to default value.
> > Conclusion: Because phylink_resolve() cannot determine when it is called, it
> >             cannot be guaranteed to be called after stmmac_core_init().
> > 	    Once stmmac_core_init() is called after phylink_resolve(),
> > 	    the mac will be misconfigured and cannot be used.
> > 
> > In order to avoid this problem, add a function called phylink_phy_resume()
> > to resume phy separately. This eliminates the need to call phylink_resume()
> > before stmmac_hw_setup().
> > 
> > Add another judgement before called phy_start() in phylink_start(). This way
> > phy_start() will not be called multiple times when resumes. At the same time,
> > it may not affect other drivers that do not use phylink_phy_resume().
> > 
> > Signed-off-by: Clark Wang <xiaoning.wang@nxp.com>
> > ---
> > V2 change:
> >  - add mac_resume_phy_separately flag to struct phylink to mark if the mac
> >    driver uses the phylink_phy_resume() first.
> > V3 change:
> >  - add brace to avoid ambiguous 'else'
> >    Reported-by: kernel test robot <lkp@intel.com>
> > ---
> >  drivers/net/phy/phylink.c | 32 ++++++++++++++++++++++++++++++--
> >  include/linux/phylink.h   |  1 +
> >  2 files changed, 31 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
> > index 319790221d7f..c2fe66f0b78f 100644
> > --- a/drivers/net/phy/phylink.c
> > +++ b/drivers/net/phy/phylink.c
> > @@ -80,6 +80,8 @@ struct phylink {
> >  	DECLARE_PHY_INTERFACE_MASK(sfp_interfaces);
> >  	__ETHTOOL_DECLARE_LINK_MODE_MASK(sfp_support);
> >  	u8 sfp_port;
> > +
> > +	bool mac_resume_phy_separately;
> >  };
> >  
> >  #define phylink_printk(level, pl, fmt, ...) \
> > @@ -1509,6 +1511,7 @@ struct phylink *phylink_create(struct phylink_config *config,
> >  		return ERR_PTR(-EINVAL);
> >  	}
> >  
> > +	pl->mac_resume_phy_separately = false;
> >  	pl->using_mac_select_pcs = using_mac_select_pcs;
> >  	pl->phy_state.interface = iface;
> >  	pl->link_interface = iface;
> > @@ -1943,8 +1946,12 @@ void phylink_start(struct phylink *pl)
> >  	}
> >  	if (poll)
> >  		mod_timer(&pl->link_poll, jiffies + HZ);
> > -	if (pl->phydev)
> > -		phy_start(pl->phydev);
> > +	if (pl->phydev) {
> > +		if (!pl->mac_resume_phy_separately)
> > +			phy_start(pl->phydev);
> > +		else
> > +			pl->mac_resume_phy_separately = false;
> > +	}
> >  	if (pl->sfp_bus)
> >  		sfp_upstream_start(pl->sfp_bus);
> >  }
> > @@ -2024,6 +2031,27 @@ void phylink_suspend(struct phylink *pl, bool mac_wol)
> >  }
> >  EXPORT_SYMBOL_GPL(phylink_suspend);
> >  
> > +/**
> > + * phylink_phy_resume() - resume phy alone
> > + * @pl: a pointer to a &struct phylink returned from phylink_create()
> > + *
> > + * In the MAC driver using phylink, if the MAC needs the clock of the phy
> > + * when it resumes, can call this function to resume the phy separately.
> > + * Then proceed to MAC resume operations.
> > + */
> > +void phylink_phy_resume(struct phylink *pl)
> > +{
> > +	ASSERT_RTNL();
> > +
> > +	if (!test_bit(PHYLINK_DISABLE_MAC_WOL, &pl->phylink_disable_state)
> > +	    && pl->phydev) {
> > +		phy_start(pl->phydev);
> > +		pl->mac_resume_phy_separately = true;
> > +	}
> > +
> 
> Minor nit: the empty line here is not needed.

The author appears to have become non-responsive after sending half of
the two patch series, and hasn't addressed previous feedback.

In any case, someone else was also having similar issues with stmmac,
and proposing different patches, so I've requested that they work
together to solve what looks like one common problem, instead of us
ending up with two patch series potentially addressing that same
issue.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
