Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 662A64224CE
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 13:16:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234258AbhJELRz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 07:17:55 -0400
Received: from mga12.intel.com ([192.55.52.136]:14206 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232658AbhJELRx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Oct 2021 07:17:53 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10127"; a="205835950"
X-IronPort-AV: E=Sophos;i="5.85,348,1624345200"; 
   d="scan'208";a="205835950"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Oct 2021 04:16:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,348,1624345200"; 
   d="scan'208";a="483736181"
Received: from linux.intel.com ([10.54.29.200])
  by fmsmga007.fm.intel.com with ESMTP; 05 Oct 2021 04:16:02 -0700
Received: from linux.intel.com (vwong3-ilbpg3.png.intel.com [10.88.229.80])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id 53B435805EE;
        Tue,  5 Oct 2021 04:15:59 -0700 (PDT)
Date:   Tue, 5 Oct 2021 19:15:56 +0800
From:   Wong Vee Khee <vee.khee.wong@linux.intel.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        Wong Vee Khee <veekhee@gmail.com>
Subject: Re: [PATCH net v1 1/1] net: stmmac: fix EEE init issue when paired
 with EEE capable PHYs
Message-ID: <20211005111556.GA28642@linux.intel.com>
References: <20210930064436.1502516-1-vee.khee.wong@linux.intel.com>
 <YVZI2GWxUNZdL2SX@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YVZI2GWxUNZdL2SX@lunn.ch>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 01, 2021 at 01:31:36AM +0200, Andrew Lunn wrote:
> On Thu, Sep 30, 2021 at 02:44:36PM +0800, Wong Vee Khee wrote:
> > When STMMAC is paired with Energy-Efficient Ethernet(EEE) capable PHY,
> > and the PHY is advertising EEE by default, we need to enable EEE on the
> > xPCS side too, instead of having user to manually trigger the enabling
> > config via ethtool.
> > 
> > Fixed this by adding xpcs_config_eee() call in stmmac_eee_init().
> > 
> > Fixes: 7617af3d1a5e ("net: pcs: Introducing support for DWC xpcs Energy Efficient Ethernet")
> > Cc: Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>
> > Signed-off-by: Wong Vee Khee <vee.khee.wong@linux.intel.com>
> > ---
> >  drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 4 ++++
> >  1 file changed, 4 insertions(+)
> > 
> > diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> > index 553c4403258a..981ccf47dcea 100644
> > --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> > +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> > @@ -486,6 +486,10 @@ bool stmmac_eee_init(struct stmmac_priv *priv)
> >  		timer_setup(&priv->eee_ctrl_timer, stmmac_eee_ctrl_timer, 0);
> >  		stmmac_set_eee_timer(priv, priv->hw, STMMAC_DEFAULT_LIT_LS,
> >  				     eee_tw_timer);
> > +		if (priv->hw->xpcs)
> > +			xpcs_config_eee(priv->hw->xpcs,
> > +					priv->plat->mult_fact_100ns,
> > +					true);
> >  	}
> 
> 
>        /* Check if it needs to be deactivated */
>         if (!priv->eee_active) {
>                 if (priv->eee_enabled) {
>                         netdev_dbg(priv->dev, "disable EEE\n");
>                         stmmac_lpi_entry_timer_config(priv, 0);
>                         del_timer_sync(&priv->eee_ctrl_timer);
>                         stmmac_set_eee_timer(priv, priv->hw, 0, eee_tw_timer);
>                 }
>                 mutex_unlock(&priv->lock);
>                 return false;
>         }
> 
> Don't you want to turn it of in here?
> 
>       Andrew

You're right.

Will introduce a new patch for that.

Regards,
Vee Khee
