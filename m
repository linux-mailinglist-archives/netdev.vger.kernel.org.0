Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 192325FFA2
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 05:05:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727459AbfGEDFv convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 4 Jul 2019 23:05:51 -0400
Received: from mga12.intel.com ([192.55.52.136]:39441 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726404AbfGEDFv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Jul 2019 23:05:51 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Jul 2019 20:05:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,453,1557212400"; 
   d="scan'208";a="155180636"
Received: from pgsmsx105.gar.corp.intel.com ([10.221.44.96])
  by orsmga007.jf.intel.com with ESMTP; 04 Jul 2019 20:05:48 -0700
Received: from pgsmsx103.gar.corp.intel.com ([169.254.2.4]) by
 PGSMSX105.gar.corp.intel.com ([169.254.4.2]) with mapi id 14.03.0439.000;
 Fri, 5 Jul 2019 11:02:50 +0800
From:   "Voon, Weifeng" <weifeng.voon@intel.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jose Abreu <joabreu@synopsys.com>,
        "Giuseppe Cavallaro" <peppe.cavallaro@st.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        biao huang <biao.huang@mediatek.com>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>,
        "Kweh, Hock Leong" <hock.leong.kweh@intel.com>
Subject: RE: [PATCH v1 net-next] net: stmmac: enable clause 45 mdio support
Thread-Topic: [PATCH v1 net-next] net: stmmac: enable clause 45 mdio support
Thread-Index: AQHVMUGmUw8CyhUBakCg51utnm9b/6a4aBMAgAFBlaD//59qAIAArWRQgAAA3wCAAJ+BsP//gXOAgAE5twA=
Date:   Fri, 5 Jul 2019 03:02:49 +0000
Message-ID: <D6759987A7968C4889FDA6FA91D5CBC814738B36@PGSMSX103.gar.corp.intel.com>
References: <1562147404-4371-1-git-send-email-weifeng.voon@intel.com>
 <20190703140520.GA18473@lunn.ch>
 <D6759987A7968C4889FDA6FA91D5CBC8147384B6@PGSMSX103.gar.corp.intel.com>
 <20190704033038.GA6276@lunn.ch>
 <D6759987A7968C4889FDA6FA91D5CBC81473862D@PGSMSX103.gar.corp.intel.com>
 <20190704135420.GD13859@lunn.ch>
 <D6759987A7968C4889FDA6FA91D5CBC8147388E0@PGSMSX103.gar.corp.intel.com>
 <20190704155217.GI18473@lunn.ch>
In-Reply-To: <20190704155217.GI18473@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.0.600.7
dlp-reaction: no-action
x-originating-ip: [172.30.20.206]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I think there is too much passing variables around by reference than by
> value, to make this code easy to understand.
> 
> Maybe a better structure would be
> 
> static int stmmac_mdion_c45_read(struct stmmac_priv *priv, int phyaddr,
> int phyreg) {
> 
> 	unsigned int reg_shift = priv->hw->mii.reg_shift;
> 	unsigned int reg_mask = priv->hw->mii.reg_mask;
> 	u32 mii_addr_val, mii_data_val;
> 
> 	mii_addr_val = MII_GMAC4_C45E |
>                        ((phyreg >> MII_DEVADDR_C45_SHIFT) << reg_shift)
> & reg_mask;
>         mii_data_val = (phyreg & MII_REGADDR_C45_MASK) <<
> MII_GMAC4_REG_ADDR_SHIFT;
> 
> 	writel(mii_data_val, priv->ioaddr + priv->hw->mii_data);
> 	writel(mii_addr_val, priv->ioaddr + priv->hw->mii_addrress);
> 
> 	return (int)readl(priv->ioaddr + mii_data) & MII_DATA_MASK;
> }
> 
> static int stmmac_mdio_read(struct mii_bus *bus, int phyaddr, int phyreg)
> {
> 
> ...
> 	if (readl_poll_timeout(priv->ioaddr + mii_address, v, !(v &
> MII_BUSY),
>  	   		      100, 10000))
>  		return -EBUSY;
> 
>       if (priv->plat->has_gmac4 && phyreg & MII_ADDR_C45)
>       	return stmmac_mdio_c45_read(priv, phyaddr, phyreg);
> 
> 	Andrew

Both c45 read/write needs to set c45 enable bit(MII_ADDR_C45) in mii_adrress
and set the register address in mii_data. Besides this, the whole programming
flow will be the same as c22. With the current design, user can easily know
that the different between c22 and c45 is just in stmmac_mdio_c45_setup(). 

If the community prefers readability, I will suggest to do the c45 setup in
both stmmac_mdio_read() and stmmac_mdio_write() 's if(C45) condition rather
than splitting into 2 new c45_read() and c45_write() functions.     

static int stmmac_mdio_read(struct mii_bus *bus, int phyaddr, int phyreg)
{

...
	if (phyreg & MII_ADDR_C45)
       *val |= MII_GMAC4_C45E;
       *val &= ~reg_mask;
       *val |= ((phyreg >> MII_DEVADDR_C45_SHIFT) << reg_shift) & reg_mask;

       *data |= (phyreg & MII_REGADDR_C45_MASK) << MII_GMAC4_REG_ADDR_SHIFT;

Weifeng


