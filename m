Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EFC39D746
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 22:13:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387978AbfHZUNw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 16:13:52 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:60700 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732670AbfHZUNv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Aug 2019 16:13:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=VazxrIYVBs1CiKh7GDTAYPEjIJ6tVdemFqrwUPFMkWQ=; b=V9QSCvIDBZaUperU1dfYz8IDFV
        gbNlW2f3BYEVhRHmXfY8ckS4Iw5qISPCM5EETcQ+Xvs+J+5rj3JcweSRnWcrOz3Lu0JzA8atPzoPx
        hTgzFNikZ1sepptj0OO4CHQRZ91UVKzsYUuVO9fmNt4PU0EU283AS0GwW2JicCsdkIeg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1i2LN4-0006l2-5H; Mon, 26 Aug 2019 22:13:46 +0200
Date:   Mon, 26 Aug 2019 22:13:46 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Voon Weifeng <weifeng.voon@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jose Abreu <joabreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>
Subject: Re: [PATCH v1 net-next 4/4] net: stmmac: setup higher frequency clk
 support for EHL & TGL
Message-ID: <20190826201346.GJ2168@lunn.ch>
References: <1566869891-29239-1-git-send-email-weifeng.voon@intel.com>
 <1566869891-29239-5-git-send-email-weifeng.voon@intel.com>
 <7d43e0c6-6f51-0d71-0af8-89f22b0234f9@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7d43e0c6-6f51-0d71-0af8-89f22b0234f9@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 26, 2019 at 12:55:31PM -0700, Florian Fainelli wrote:
> On 8/26/19 6:38 PM, Voon Weifeng wrote:
> > EHL DW EQOS is running on a 200MHz clock. Setting up stmmac-clk,
> > ptp clock and ptp_max_adj to 200MHz.
> > 
> > Signed-off-by: Voon Weifeng <weifeng.voon@intel.com>
> > Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
> > ---
> >  drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c | 21 +++++++++++++++++++++
> >  drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c |  3 +++
> >  include/linux/stmmac.h                           |  1 +
> >  3 files changed, 25 insertions(+)
> > 
> > diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c
> > index e969dc9bb9f0..20906287b6d4 100644
> > --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c
> > +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c
> > @@ -9,6 +9,7 @@
> >    Author: Giuseppe Cavallaro <peppe.cavallaro@st.com>
> >  *******************************************************************************/
> >  
> > +#include <linux/clk-provider.h>
> >  #include <linux/pci.h>
> >  #include <linux/dmi.h>
> >  
> > @@ -174,6 +175,19 @@ static int intel_mgbe_common_data(struct pci_dev *pdev,
> >  	plat->axi->axi_blen[1] = 8;
> >  	plat->axi->axi_blen[2] = 16;
> >  
> > +	plat->ptp_max_adj = plat->clk_ptp_rate;
> > +
> > +	/* Set system clock */
> > +	plat->stmmac_clk = clk_register_fixed_rate(&pdev->dev,
> > +						   "stmmac-clk", NULL, 0,
> > +						   plat->clk_ptp_rate);
> > +
> > +	if (IS_ERR(plat->stmmac_clk)) {
> > +		dev_warn(&pdev->dev, "Fail to register stmmac-clk\n");
> > +		plat->stmmac_clk = NULL;
> 
> Don't you need to propagate at least EPROBE_DEFER here?

Hi Florian

Isn't a fixed rate clock a complete fake. There is no hardware behind
it. So can it return EPROBE_DEFER?

    Andrew
