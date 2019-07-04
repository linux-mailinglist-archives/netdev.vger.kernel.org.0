Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A1A35FB39
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 17:52:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727849AbfGDPwZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 11:52:25 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:54300 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727816AbfGDPwZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Jul 2019 11:52:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=svphATbkFOoAAltJuUblfqvoklVJ2Q5WVSnZRTgzpDw=; b=cViTZ/CF344FGf1dtxH/n9m/Ke
        59YKl369FU2WptLb8GxVK+48MONjUA7ok4zrdOu2D8uxSz/hy8dVytG0l990Hslraf33EI44o331e
        JB0i7shiAC7PEC9SmVI4eCccso1cymQV/IuV0WOfu/VyxZOKhQWetiQAXhlypz0rI1XU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hj41x-0004lI-Eh; Thu, 04 Jul 2019 17:52:17 +0200
Date:   Thu, 4 Jul 2019 17:52:17 +0200
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
Message-ID: <20190704155217.GI18473@lunn.ch>
References: <1562147404-4371-1-git-send-email-weifeng.voon@intel.com>
 <20190703140520.GA18473@lunn.ch>
 <D6759987A7968C4889FDA6FA91D5CBC8147384B6@PGSMSX103.gar.corp.intel.com>
 <20190704033038.GA6276@lunn.ch>
 <D6759987A7968C4889FDA6FA91D5CBC81473862D@PGSMSX103.gar.corp.intel.com>
 <20190704135420.GD13859@lunn.ch>
 <D6759987A7968C4889FDA6FA91D5CBC8147388E0@PGSMSX103.gar.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <D6759987A7968C4889FDA6FA91D5CBC8147388E0@PGSMSX103.gar.corp.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Yes, the top 16 bit of the data register only valid when C45 is enable.
> It contains the Register address which MDIO c45 frame intended for.

I think there is too much passing variables around by reference than
by value, to make this code easy to understand.

Maybe a better structure would be

static int stmmac_mdion_c45_read(struct stmmac_priv *priv, int phyaddr, int phyreg)
{

	unsigned int reg_shift = priv->hw->mii.reg_shift;
	unsigned int reg_mask = priv->hw->mii.reg_mask;
	u32 mii_addr_val, mii_data_val;

	mii_addr_val = MII_GMAC4_C45E |
                       ((phyreg >> MII_DEVADDR_C45_SHIFT) << reg_shift) & reg_mask;
        mii_data_val = (phyreg & MII_REGADDR_C45_MASK) << MII_GMAC4_REG_ADDR_SHIFT;

	writel(mii_data_val, priv->ioaddr + priv->hw->mii_data);
	writel(mii_addr_val, priv->ioaddr + priv->hw->mii_addrress);

	return (int)readl(priv->ioaddr + mii_data) & MII_DATA_MASK;
}		   

static int stmmac_mdio_read(struct mii_bus *bus, int phyaddr, int phyreg)
{

...
	if (readl_poll_timeout(priv->ioaddr + mii_address, v, !(v & MII_BUSY),
 	   		      100, 10000))
 		return -EBUSY;

      if (priv->plat->has_gmac4 && phyreg & MII_ADDR_C45)
      	return stmmac_mdio_c45_read(priv, phyaddr, phyreg);

	Andrew
