Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D658DD3AE3
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 10:22:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727517AbfJKIV1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 04:21:27 -0400
Received: from Mailgw01.mediatek.com ([1.203.163.78]:41245 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726983AbfJKIVZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Oct 2019 04:21:25 -0400
X-UUID: 683957e80d3f4b828ae9e3cf2535bbf0-20191011
X-UUID: 683957e80d3f4b828ae9e3cf2535bbf0-20191011
Received: from mtkcas32.mediatek.inc [(172.27.4.253)] by mailgw01.mediatek.com
        (envelope-from <biao.huang@mediatek.com>)
        (mailgw01.mediatek.com ESMTP with TLS)
        with ESMTP id 1514359459; Fri, 11 Oct 2019 16:21:11 +0800
Received: from MTKCAS32.mediatek.inc (172.27.4.184) by MTKMBS31DR.mediatek.inc
 (172.27.6.102) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Fri, 11 Oct
 2019 16:21:07 +0800
Received: from [10.17.3.153] (172.27.4.253) by MTKCAS32.mediatek.inc
 (172.27.4.170) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Fri, 11 Oct 2019 16:21:07 +0800
Message-ID: <1570782069.5044.12.camel@mhfsdcap03>
Subject: Re: [PATCH] net: stmmac: disable/enable ptp_ref_clk in
 suspend/resume flow
From:   biao huang <biao.huang@mediatek.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
CC:     <davem@davemloft.net>, Jose Abreu <joabreu@synopsys.com>,
        <andrew@lunn.ch>, Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        <netdev@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>, <yt.shen@mediatek.com>,
        <jianguo.zhang@mediatek.com>, <boon.leong.ong@intel.com>,
        <yong.wu@mediatek.com>
Date:   Fri, 11 Oct 2019 16:21:09 +0800
In-Reply-To: <20191010160103.63c3c0ed@cakuba.netronome.com>
References: <20191009085649.6736-1-biao.huang@mediatek.com>
         <20191010160103.63c3c0ed@cakuba.netronome.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-SNTS-SMTP: 830FACAF2A292503757689C34417C3AFCD74A88CD9AC4330D44496E1DBE6BC492000:8
X-MTK:  N
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Appreciate your comments!

On Thu, 2019-10-10 at 16:01 -0700, Jakub Kicinski wrote:
> On Wed, 9 Oct 2019 16:56:49 +0800, Biao Huang wrote:
> > disable ptp_ref_clk in suspend flow, and enable it in resume flow.
> > 
> > Signed-off-by: Biao Huang <biao.huang@mediatek.com>
> > ---
> >  drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 4 ++++
> >  1 file changed, 4 insertions(+)
> > 
> > diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> > index c7c9e5f162e6..b592aeecc3dd 100644
> > --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> > +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> > @@ -4469,6 +4469,8 @@ int stmmac_suspend(struct device *dev)
> >  		stmmac_mac_set(priv, priv->ioaddr, false);
> >  		pinctrl_pm_select_sleep_state(priv->device);
> >  		/* Disable clock in case of PWM is off */
> > +		if (priv->plat->clk_ptp_ref)
> > +			clk_disable_unprepare(priv->plat->clk_ptp_ref);
> 
> I don't know much embedded, but it seems like this should perhaps just
> be clk_disable() without the unprepare? stmmac_hw_teardown() is called
> when driver is removed so it needs to unprepare as well.
> 
> Please feel free to explain to me why this needs to be
> clk_disable_unprepare(), as I said - not an expert.
> 
As our clock owner's advice, there are prepare/unprepare clk_ops for
pll, but no enable/disable clk_ops for it, and pll will be off only when
the prepare reference count decrease to 0.

so for the sake of power saving, we'd better call clk_disable_unprepare
to turn the parent pll off.

> Also - if this is a bug fix and you'd like to have it backported to
> older releases you need to add a Fixes tag.
> 
Thanks for the reminder, I'll add the fixes tag in the next version.
> Thanks!
> 
> >  		clk_disable(priv->plat->pclk);
> >  		clk_disable(priv->plat->stmmac_clk);
maybe it should be clk_disable_unprepare(priv->plat->pclk);
		   clk_disable_unprepare(priv->plat->stmmac_clk);
> >  	}
> > @@ -4535,6 +4537,8 @@ int stmmac_resume(struct device *dev)
> >  		/* enable the clk previously disabled */
> >  		clk_enable(priv->plat->stmmac_clk);
> >  		clk_enable(priv->plat->pclk);
> > +		if (priv->plat->clk_ptp_ref)
> > +			clk_prepare_enable(priv->plat->clk_ptp_ref);
> >  		/* reset the phy so that it's ready */
> >  		if (priv->mii)
> >  			stmmac_mdio_reset(priv->mii);
> 


