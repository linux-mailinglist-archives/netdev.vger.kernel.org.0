Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E49405F96D
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 15:54:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727357AbfGDNy3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 09:54:29 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:53950 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727044AbfGDNy3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Jul 2019 09:54:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=/tUWj9SXbNEAufZYyZPkHISvXvHqdA3KX4p3SCB6+58=; b=PU3reFtiNuWI7IaG6QoE7LdN69
        tfCwrCFaqPLIHZTbPs9+tvqBpLUEv2+ykv2SULBo4xRbvcjgUB4VKjLvKlHQ8RpfEv4N5LaGyNqVR
        h/K8/fJikTii5KftGAd/tTorJ1efBQWbqLdS687ei8lB7Xq+MzDBXirmiHWY7bi//Zg0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hj2Bo-0003zo-Lm; Thu, 04 Jul 2019 15:54:20 +0200
Date:   Thu, 4 Jul 2019 15:54:20 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Voon, Weifeng" <weifeng.voon@intel.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jose Abreu <joabreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        biao huang <biao.huang@mediatek.com>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>,
        "Kweh, Hock Leong" <hock.leong.kweh@intel.com>
Subject: Re: [PATCH v1 net-next] net: stmmac: enable clause 45 mdio support
Message-ID: <20190704135420.GD13859@lunn.ch>
References: <1562147404-4371-1-git-send-email-weifeng.voon@intel.com>
 <20190703140520.GA18473@lunn.ch>
 <D6759987A7968C4889FDA6FA91D5CBC8147384B6@PGSMSX103.gar.corp.intel.com>
 <20190704033038.GA6276@lunn.ch>
 <D6759987A7968C4889FDA6FA91D5CBC81473862D@PGSMSX103.gar.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <D6759987A7968C4889FDA6FA91D5CBC81473862D@PGSMSX103.gar.corp.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 04, 2019 at 06:05:23AM +0000, Voon, Weifeng wrote:
> > > > > @@ -155,22 +171,26 @@ static int stmmac_mdio_read(struct mii_bus
> > > > > *bus,
> > > > int phyaddr, int phyreg)
> > > > >  	struct stmmac_priv *priv = netdev_priv(ndev);
> > > > >  	unsigned int mii_address = priv->hw->mii.addr;
> > > > >  	unsigned int mii_data = priv->hw->mii.data;
> > > > > -	u32 v;
> > > > > -	int data;
> > > > >  	u32 value = MII_BUSY;
> > > > > +	int data = 0;
> > > > > +	u32 v;
> > > > >
> > > > >  	value |= (phyaddr << priv->hw->mii.addr_shift)
> > > > >  		& priv->hw->mii.addr_mask;
> > > > >  	value |= (phyreg << priv->hw->mii.reg_shift) & priv->hw-
> > > > >mii.reg_mask;
> > > > >  	value |= (priv->clk_csr << priv->hw->mii.clk_csr_shift)
> > > > >  		& priv->hw->mii.clk_csr_mask;
> > > > > -	if (priv->plat->has_gmac4)
> > > > > +	if (priv->plat->has_gmac4) {
> > > > >  		value |= MII_GMAC4_READ;
> > > > > +		if (phyreg & MII_ADDR_C45)
> > > > > +			stmmac_mdio_c45_setup(priv, phyreg, &value, &data);
> > > > > +	}
> > > > >
> > > > >  	if (readl_poll_timeout(priv->ioaddr + mii_address, v, !(v &
> > > > MII_BUSY),
> > > > >  			       100, 10000))
> > > > >  		return -EBUSY;
> > > > >
> > > > > +	writel(data, priv->ioaddr + mii_data);
> > > >
> > > > That looks odd. Could you explain why it is needed.
> > > >
> > > > Thanks
> > > > 	Andrew
> > >
> > > Hi Andrew,
> > > This mdio c45 support needed to access DWC xPCS which is a Clause-45
> > 
> > I mean it looks odd doing a write to the data register in the middle of
> > stmmac_mdio_read().
> 
> MAC is using an indirect access to access mdio devices. In order to read,
> the driver needs to write into both mii_data and mii_address to select 
> c45, read/write command, phy address, address to read, and etc. 

Yes, that is all clear. The stmmac_mdio_c45_setup() does part of this
setup. There is also a write to mii_address which i snipped out when
replying. But why do you need to write to the data registers during a
read? C22 does not need this write. Are there some bits in the top of
the data register which are relevant to C45?

Thanks
    Andrew
