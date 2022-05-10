Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A23AC522478
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 21:02:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238223AbiEJTCM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 15:02:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230456AbiEJTCH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 15:02:07 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01F6EDEEF
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 12:02:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=mljwU2WTOHaOWkrHMiH9zzZtJ3jxd8R7cn3s60TmhMI=; b=ZKs+MWkBbM5A5G+g36JH4d7uac
        BaqnPW1+MxIiSZM38yZs1Wqw6v7jhU9NMApDTjn1xCi0W1RD7QXsCiN5F+OmCNNq5yGl/ru5hVrSN
        RTA/+ymjmv3hvtD+4N4E0MMVfGeKkQkP3CTlcyqVv89F8D+vpniKFn35mJzgDOd65qCA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1noV7O-002CEP-Fh; Tue, 10 May 2022 21:01:58 +0200
Date:   Tue, 10 May 2022 21:01:58 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        Markus Koch <markus@notsyncing.net>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Hao Chen <chenhao288@hisilicon.com>
Subject: Re: [PATCH net-next 07/10] net: ethernet: freescale: xgmac: Separate
 C22 and C45 transactions for xgmac
Message-ID: <Ynq2phuiw8mLN8bZ@lunn.ch>
References: <20220508153049.427227-1-andrew@lunn.ch>
 <20220508153049.427227-8-andrew@lunn.ch>
 <20220510182818.w7kl3vmlgvqjjj4u@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220510182818.w7kl3vmlgvqjjj4u@skbuf>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 10, 2022 at 09:28:18PM +0300, Vladimir Oltean wrote:
> On Sun, May 08, 2022 at 05:30:46PM +0200, Andrew Lunn wrote:
> > The xgmac MDIO bus driver can perform both C22 and C45 transfers.
> > Create separate functions for each and register the C45 versions using
> > the new API calls where appropriate.
> > 
> > Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> > ---
> >  drivers/net/ethernet/freescale/xgmac_mdio.c | 154 +++++++++++++++-----
> >  1 file changed, 117 insertions(+), 37 deletions(-)
> > 
> > diff --git a/drivers/net/ethernet/freescale/xgmac_mdio.c b/drivers/net/ethernet/freescale/xgmac_mdio.c
> > index ec90da1de030..ddfe6bf1f231 100644
> > --- a/drivers/net/ethernet/freescale/xgmac_mdio.c
> > +++ b/drivers/net/ethernet/freescale/xgmac_mdio.c
> > @@ -128,30 +128,59 @@ static int xgmac_wait_until_done(struct device *dev,
> >  	return 0;
> >  }
> >  
> > -/*
> > - * Write value to the PHY for this device to the register at regnum,waiting
> > +/* Write value to the PHY for this device to the register at regnum,waiting
> >   * until the write is done before it returns.  All PHY configuration has to be
> >   * done through the TSEC1 MIIM regs.
> >   */
> > -static int xgmac_mdio_write(struct mii_bus *bus, int phy_id, int regnum, u16 value)
> > +static int xgmac_mdio_write_c22(struct mii_bus *bus, int phy_id, int regnum,
> > +				u16 value)
> >  {
> >  	struct mdio_fsl_priv *priv = (struct mdio_fsl_priv *)bus->priv;
> >  	struct tgec_mdio_controller __iomem *regs = priv->mdio_base;
> > -	uint16_t dev_addr;
> > +	bool endian = priv->is_little_endian;
> >  	u32 mdio_ctl, mdio_stat;
> > +	u16 dev_addr;
> >  	int ret;
> > +
> > +	mdio_stat = xgmac_read32(&regs->mdio_stat, endian);
> > +	dev_addr = regnum & 0x1f;
> 
> Please move this either to the variable declaration, or near the mdio_ctl write,
> or just integrate it into the macro argument.

There are masks like this in some drivers, others don't. Since for the
majority of the MDIO bus drivers i don't have the hardware i was
trying to keep my changes to a minimum, so i'm less likely to break
it.

Once we have all the bus drivers converted, we can validate all the
requests in the core to guarantee no users are passing invalid values
to the drivers. And then all these masks can be removed.

> 
> > +	mdio_stat &= ~MDIO_STAT_ENC;
> > +
> 
> You can remove this empty line during read-modify-write patterns.

Sure, but just an FYI: the old code probably did it that way. My aim
is to split C22 from C45, not re-write/clean up every driver. I have
over 40 patches in total, without doing cleanups.

   Andrew
