Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36D85356C36
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 14:35:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352227AbhDGMfk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 08:35:40 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:38018 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245543AbhDGMfg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Apr 2021 08:35:36 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lU7Ow-00FJ20-2B; Wed, 07 Apr 2021 14:35:18 +0200
Date:   Wed, 7 Apr 2021 14:35:18 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        f.fainelli@gmail.com, netdev@vger.kernel.org, linux-imx@nxp.com,
        Jisheng.Zhang@synaptics.com
Subject: Re: [PATCH net] net: stmmac: fix MAC WoL unwork if PHY doesn't
 support WoL
Message-ID: <YG2nBgdbc4fVQ0tF@lunn.ch>
References: <20210407104404.5781-1-qiangqing.zhang@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210407104404.5781-1-qiangqing.zhang@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 07, 2021 at 06:44:04PM +0800, Joakim Zhang wrote:
> Both get and set WoL will check device_can_wakeup(), if MAC supports
> PMT, it will set device wakeup capability. After commit 1d8e5b0f3f2c ("net:
> stmmac: Support WOL with phy"), device wakeup capability will be
> overwrite in stmmac_init_phy() according to phy's Wol feature. If phy
> doesn't support WoL, then MAC will lose wakeup capability. To fix this
> issue, only overwrite device wakeup capability when MAC doesn't support
> PMT.
> 
> Fixes: commit 1d8e5b0f3f2c ("net: stmmac: Support WOL with phy")
> Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
> ---
>  drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> index 208cae344ffa..f46d9c69168f 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> @@ -1103,7 +1103,9 @@ static int stmmac_init_phy(struct net_device *dev)
>  	}
>  
>  	phylink_ethtool_get_wol(priv->phylink, &wol);
> -	device_set_wakeup_capable(priv->device, !!wol.supported);
> +
> +	if (!priv->plat->pmt)
> +		device_set_wakeup_capable(priv->device, !!wol.supported);
  
It seems like a better fix would be to call stmmac_get_wol(), That
should set wol taking into account both pmt and phy.  But i would also
say stmmac_get_wol() and stmmac_set_wol() are broken. They should
combine capabilities, not be either pmt or phy.

       Andrew
