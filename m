Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 506105E604
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 16:05:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727100AbfGCOF2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 10:05:28 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:51204 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727079AbfGCOF1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Jul 2019 10:05:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ocBZZm2C0AqTeZY6iNexdtzLdOjyd9FHHH3bSX7zaec=; b=SnKFE7+Zlhm90oZGy2bd5UIeuU
        ZsmnkDOgJtBzYEu9NLHTb2eZj794oqlnrJAvCTWhFxVIy7cGt80hhKjSVF03oDW7AEid1qGF0PJZg
        555lSSrP7JQlP+6gQekUzsztjjpaX3SHcO56tpSzNNpluDZ2AqndwA1qaLIOUHl8BVtM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hifsu-0004uU-MQ; Wed, 03 Jul 2019 16:05:20 +0200
Date:   Wed, 3 Jul 2019 16:05:20 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Voon Weifeng <weifeng.voon@intel.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jose Abreu <joabreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        biao huang <biao.huang@mediatek.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Kweh Hock Leong <hock.leong.kweh@intel.com>
Subject: Re: [PATCH v1 net-next] net: stmmac: enable clause 45 mdio support
Message-ID: <20190703140520.GA18473@lunn.ch>
References: <1562147404-4371-1-git-send-email-weifeng.voon@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1562147404-4371-1-git-send-email-weifeng.voon@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 03, 2019 at 05:50:04PM +0800, Voon Weifeng wrote:
> @@ -155,22 +171,26 @@ static int stmmac_mdio_read(struct mii_bus *bus, int phyaddr, int phyreg)
>  	struct stmmac_priv *priv = netdev_priv(ndev);
>  	unsigned int mii_address = priv->hw->mii.addr;
>  	unsigned int mii_data = priv->hw->mii.data;
> -	u32 v;
> -	int data;
>  	u32 value = MII_BUSY;
> +	int data = 0;
> +	u32 v;
>  
>  	value |= (phyaddr << priv->hw->mii.addr_shift)
>  		& priv->hw->mii.addr_mask;
>  	value |= (phyreg << priv->hw->mii.reg_shift) & priv->hw->mii.reg_mask;
>  	value |= (priv->clk_csr << priv->hw->mii.clk_csr_shift)
>  		& priv->hw->mii.clk_csr_mask;
> -	if (priv->plat->has_gmac4)
> +	if (priv->plat->has_gmac4) {
>  		value |= MII_GMAC4_READ;
> +		if (phyreg & MII_ADDR_C45)
> +			stmmac_mdio_c45_setup(priv, phyreg, &value, &data);
> +	}
>  
>  	if (readl_poll_timeout(priv->ioaddr + mii_address, v, !(v & MII_BUSY),
>  			       100, 10000))
>  		return -EBUSY;
>  
> +	writel(data, priv->ioaddr + mii_data);

That looks odd. Could you explain why it is needed.

Thanks
	Andrew
