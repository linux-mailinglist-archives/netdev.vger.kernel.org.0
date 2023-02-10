Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E958691F55
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 13:53:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231923AbjBJMx3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 07:53:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231609AbjBJMx2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 07:53:28 -0500
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64B1F6BD1A;
        Fri, 10 Feb 2023 04:53:25 -0800 (PST)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.96)
        (envelope-from <daniel@makrotopia.org>)
        id 1pQStm-0007XU-0V;
        Fri, 10 Feb 2023 13:53:06 +0100
Date:   Fri, 10 Feb 2023 12:52:56 +0000
From:   Daniel Golle <daniel@makrotopia.org>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        John Crispin <john@phrozen.org>, Felix Fietkau <nbd@nbd.name>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Jianhui Zhao <zhaojh329@gmail.com>,
        =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>
Subject: Re: [PATCH v2 11/11] net: dsa: mt7530: use external PCS driver
Message-ID: <Y+Y+KHXnGUgroYQ/@makrotopia.org>
References: <cover.1675779094.git.daniel@makrotopia.org>
 <dcda0a3a1bf89e27e600822df63009b2b10e136a.1675779094.git.daniel@makrotopia.org>
 <Y+Yi+ajKHaLo4Vvq@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y+Yi+ajKHaLo4Vvq@shell.armlinux.org.uk>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 10, 2023 at 10:56:57AM +0000, Russell King (Oracle) wrote:
> On Tue, Feb 07, 2023 at 02:24:17PM +0000, Daniel Golle wrote:
> > @@ -2728,11 +2612,11 @@ mt753x_phylink_mac_select_pcs(struct dsa_switch *ds, int port,
> >  
> >  	switch (interface) {
> >  	case PHY_INTERFACE_MODE_TRGMII:
> > +		return &priv->pcs[port].pcs;
               ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

> >  	case PHY_INTERFACE_MODE_SGMII:
> >  	case PHY_INTERFACE_MODE_1000BASEX:
> >  	case PHY_INTERFACE_MODE_2500BASEX:
> > -		return &priv->pcs[port].pcs;
> > -
> > +		return priv->ports[port].sgmii_pcs;
               ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> 
> My only concern here is that we also use the PCS when in TRGMII mode in
> this driver, but the mtk pcs code from mtk_eth_soc doesn't handle
> TRGMII (and getting the link timer will fail for this mode, causing
> the pcs_config() method to fail.)
> 
> Thus, this driver will stop working in TRGMII mode.

But in TRGMII mode we return &priv->pcs[port].pcs which is not the PCS
code from mtk_eth_soc now moved to the new pcs-mtk-lynxi driver, but
rather the old existing codepath from mt7530.c.

The new PCS driver only replaces mt7531_sgmii_pcs_* functions, which
were all nearly identical with what is now in pcs-mtk-lynxi.c.

Or do I miss something here?
