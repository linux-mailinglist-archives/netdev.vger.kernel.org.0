Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A28F41E504
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 01:32:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349561AbhI3Xdk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 19:33:40 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:42092 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347868AbhI3Xdj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Sep 2021 19:33:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=9gmdjG51P4sUtdlckZMNf2bN5+zN0n8cVhZkk4LzqwE=; b=pC5GRS0XWArGvEi55mbqERtVOh
        N39cL3bi9yU69ML2hwVJ6lOe3tLcxU7O827WLtiuL720YgiSe9kDsdVok9lzuD2BvtKu/R58bCI/Q
        MYdjTqAQIQ2WB73gZnYaDK+3pG5Qm/xwNDy25zsvvgUUv3CtLNCW0CYzJDdNpoYvb3HU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mW5Wa-0091JE-Nn; Fri, 01 Oct 2021 01:31:36 +0200
Date:   Fri, 1 Oct 2021 01:31:36 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Wong Vee Khee <vee.khee.wong@linux.intel.com>
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
Message-ID: <YVZI2GWxUNZdL2SX@lunn.ch>
References: <20210930064436.1502516-1-vee.khee.wong@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210930064436.1502516-1-vee.khee.wong@linux.intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 30, 2021 at 02:44:36PM +0800, Wong Vee Khee wrote:
> When STMMAC is paired with Energy-Efficient Ethernet(EEE) capable PHY,
> and the PHY is advertising EEE by default, we need to enable EEE on the
> xPCS side too, instead of having user to manually trigger the enabling
> config via ethtool.
> 
> Fixed this by adding xpcs_config_eee() call in stmmac_eee_init().
> 
> Fixes: 7617af3d1a5e ("net: pcs: Introducing support for DWC xpcs Energy Efficient Ethernet")
> Cc: Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>
> Signed-off-by: Wong Vee Khee <vee.khee.wong@linux.intel.com>
> ---
>  drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> index 553c4403258a..981ccf47dcea 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> @@ -486,6 +486,10 @@ bool stmmac_eee_init(struct stmmac_priv *priv)
>  		timer_setup(&priv->eee_ctrl_timer, stmmac_eee_ctrl_timer, 0);
>  		stmmac_set_eee_timer(priv, priv->hw, STMMAC_DEFAULT_LIT_LS,
>  				     eee_tw_timer);
> +		if (priv->hw->xpcs)
> +			xpcs_config_eee(priv->hw->xpcs,
> +					priv->plat->mult_fact_100ns,
> +					true);
>  	}


       /* Check if it needs to be deactivated */
        if (!priv->eee_active) {
                if (priv->eee_enabled) {
                        netdev_dbg(priv->dev, "disable EEE\n");
                        stmmac_lpi_entry_timer_config(priv, 0);
                        del_timer_sync(&priv->eee_ctrl_timer);
                        stmmac_set_eee_timer(priv, priv->hw, 0, eee_tw_timer);
                }
                mutex_unlock(&priv->lock);
                return false;
        }

Don't you want to turn it of in here?

      Andrew
