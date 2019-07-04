Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 115DC5F0FB
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 03:33:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727099AbfGDBdV convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 3 Jul 2019 21:33:21 -0400
Received: from mga07.intel.com ([134.134.136.100]:30478 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726574AbfGDBdV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Jul 2019 21:33:21 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Jul 2019 18:33:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,449,1557212400"; 
   d="scan'208";a="315735804"
Received: from kmsmsx157.gar.corp.intel.com ([172.21.138.134])
  by orsmga004.jf.intel.com with ESMTP; 03 Jul 2019 18:33:18 -0700
Received: from pgsmsx103.gar.corp.intel.com ([169.254.2.4]) by
 kmsmsx157.gar.corp.intel.com ([169.254.5.204]) with mapi id 14.03.0439.000;
 Thu, 4 Jul 2019 09:33:17 +0800
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
Thread-Index: AQHVMUGmUw8CyhUBakCg51utnm9b/6a4aBMAgAFBlaA=
Date:   Thu, 4 Jul 2019 01:33:16 +0000
Message-ID: <D6759987A7968C4889FDA6FA91D5CBC8147384B6@PGSMSX103.gar.corp.intel.com>
References: <1562147404-4371-1-git-send-email-weifeng.voon@intel.com>
 <20190703140520.GA18473@lunn.ch>
In-Reply-To: <20190703140520.GA18473@lunn.ch>
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

> > @@ -155,22 +171,26 @@ static int stmmac_mdio_read(struct mii_bus *bus,
> int phyaddr, int phyreg)
> >  	struct stmmac_priv *priv = netdev_priv(ndev);
> >  	unsigned int mii_address = priv->hw->mii.addr;
> >  	unsigned int mii_data = priv->hw->mii.data;
> > -	u32 v;
> > -	int data;
> >  	u32 value = MII_BUSY;
> > +	int data = 0;
> > +	u32 v;
> >
> >  	value |= (phyaddr << priv->hw->mii.addr_shift)
> >  		& priv->hw->mii.addr_mask;
> >  	value |= (phyreg << priv->hw->mii.reg_shift) & priv->hw-
> >mii.reg_mask;
> >  	value |= (priv->clk_csr << priv->hw->mii.clk_csr_shift)
> >  		& priv->hw->mii.clk_csr_mask;
> > -	if (priv->plat->has_gmac4)
> > +	if (priv->plat->has_gmac4) {
> >  		value |= MII_GMAC4_READ;
> > +		if (phyreg & MII_ADDR_C45)
> > +			stmmac_mdio_c45_setup(priv, phyreg, &value, &data);
> > +	}
> >
> >  	if (readl_poll_timeout(priv->ioaddr + mii_address, v, !(v &
> MII_BUSY),
> >  			       100, 10000))
> >  		return -EBUSY;
> >
> > +	writel(data, priv->ioaddr + mii_data);
> 
> That looks odd. Could you explain why it is needed.
> 
> Thanks
> 	Andrew

Hi Andrew,
This mdio c45 support needed to access DWC xPCS which is a Clause-45
MDIO Manageable Device (MMD). This is discuss in:
https://patchwork.ozlabs.org/patch/1109776/
https://patchwork.ozlabs.org/patch/1109777/
Since the patch is still WIP to make the xPCS as PHY driver for SGMII
to RGMII converter. So i decided to upstream this patch first.

Biao Huang also needed this patch and tested pass with this patch on 
their platform.
https://patchwork.ozlabs.org/patch/1103861/

Biao Huang's patch on MDIO-c45 access 
https://patchwork.ozlabs.org/patch/1092436/ 

Regards,
Weifeng


