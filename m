Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB249EA1C2
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 17:28:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727621AbfJ3Q2d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 12:28:33 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:42098 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726261AbfJ3Q2d (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Oct 2019 12:28:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=SZUx4NVeGGOnxDClBHA9DgqzCOffD4hhcgm5wwv6WUs=; b=gtK4LzENJNZ3IfWDlksuD6F6Mk
        +X7v8aAddo+Y3EA2Wk14qoXStLAhyN7omwt1LGMfId8PsMuvDF6vgFXxhVaFq4/anphnNaJlQJB01
        /A8XrrdjOyaF3fZg3cGRF73XE25jsx06xJbg9e2o5hhopEgdBvPla7jPVCTBv0nkxouI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iPqph-0003cy-GH; Wed, 30 Oct 2019 17:28:29 +0100
Date:   Wed, 30 Oct 2019 17:28:29 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jose Abreu <Jose.Abreu@synopsys.com>
Cc:     netdev@vger.kernel.org, Joao Pinto <Joao.Pinto@synopsys.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH net-next 2/3] net: stmmac: xgmac: Add C45 PHY support in
 the MDIO callbacks
Message-ID: <20191030162829.GC10555@lunn.ch>
References: <cover.1572449009.git.Jose.Abreu@synopsys.com>
 <444208cef341686bcf35f8361f409467f539c73b.1572449009.git.Jose.Abreu@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <444208cef341686bcf35f8361f409467f539c73b.1572449009.git.Jose.Abreu@synopsys.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 30, 2019 at 04:28:49PM +0100, Jose Abreu wrote:
> Add the support for C45 PHYs in the MDIO callbacks for XGMAC. This was
> tested using Synopsys DesignWare XPCS.
> 
> Signed-off-by: Jose Abreu <Jose.Abreu@synopsys.com>
> 
> ---
> Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
> Cc: Alexandre Torgue <alexandre.torgue@st.com>
> Cc: Jose Abreu <joabreu@synopsys.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>
> Cc: netdev@vger.kernel.org
> Cc: linux-stm32@st-md-mailman.stormreply.com
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c | 47 +++++++++++++++++++++--
>  1 file changed, 43 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
> index 40c42637ad75..143bffd28acf 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
> @@ -41,6 +41,29 @@
>  #define MII_XGMAC_BUSY			BIT(22)
>  #define MII_XGMAC_MAX_C22ADDR		3
>  #define MII_XGMAC_C22P_MASK		GENMASK(MII_XGMAC_MAX_C22ADDR, 0)
> +#define MII_XGMAC_PA_SHIFT		16
> +#define MII_XGMAC_DA_SHIFT		21
> +
> +static int stmmac_xgmac2_c45_format(struct stmmac_priv *priv, int phyaddr,
> +				    int phyreg, u32 *hw_addr)
> +{
> +	unsigned int mii_data = priv->hw->mii.data;
> +	u32 tmp;
> +
> +	/* Wait until any existing MII operation is complete */
> +	if (readl_poll_timeout(priv->ioaddr + mii_data, tmp,
> +			       !(tmp & MII_XGMAC_BUSY), 100, 10000))
> +		return -EBUSY;

Hi Jose

The stmmac_xgmac2_c22_format function does the same. Maybe the call
can be pulled out into stmmac_xgmac2_mdio_write() and
stmmac_xgmac2_mdio_read()?

	Andrew
