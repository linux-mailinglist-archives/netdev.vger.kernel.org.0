Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A702C59E821
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 18:56:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244500AbiHWQ4V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 12:56:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343800AbiHWQzz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 12:55:55 -0400
Received: from mail.base45.de (mail.base45.de [IPv6:2001:67c:2050:320::77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9968858086;
        Tue, 23 Aug 2022 07:17:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=fe80.eu;
        s=20190804; h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:
        In-Reply-To:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=BC9EHfNdBZO5BhwtclMR6Z7TH9XPXfo6wRg4PO4XuJE=; b=l0pKfb/k+xmXrkPPGH2z7TCxrh
        pFA3KU3IXc3vXh2aDLsz3QfUPpSxvadT083kJytpCjVte4fSdmFoIJ9sl09EuoPeG7UR9XIEqjP2g
        Ox5yM7+g4H6KkGh/WsWacpVhtQa5D4M4RqrioFaSK7jTzVOzd9nQ9H1Dushsk62mwXFogPT3ts8wl
        OEX8PwW5ut4lmpZjS/LxvXcCqCJ3eqJgckHBo9pUWylhtdEDgZdQ8RekROEgzfQoxMqZlgMSth6eN
        6gOLoxP+d4a+G+x8WE/bBz9RSbQhTmqJpo6r4MjYU9xNiJJ46NAss+HNyXvBi+dqs8oks1trpHxIA
        2+EV/Fag==;
Received: from [2a02:2454:9869:1a::98b] (helo=javelin)
        by mail.base45.de with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <lynxis@fe80.eu>)
        id 1oQUiQ-00HV0I-47; Tue, 23 Aug 2022 14:17:14 +0000
Date:   Tue, 23 Aug 2022 16:17:12 +0200
From:   Alexander 'lynxis' Couzens <lynxis@fe80.eu>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        Daniel Golle <daniel@makrotopia.org>
Subject: Re: [PATCH 2/4] net: mediatek: sgmii: ensure the SGMII PHY is
 powered down on configuration
Message-ID: <20220823161712.2cafa970@javelin>
In-Reply-To: <efd1c89e3bbd7364ef381292c9ceff430cbeda8d.camel@redhat.com>
References: <20220820224538.59489-1-lynxis@fe80.eu>
        <20220820224538.59489-3-lynxis@fe80.eu>
        <efd1c89e3bbd7364ef381292c9ceff430cbeda8d.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 23 Aug 2022 15:18:31 +0200
Paolo Abeni <pabeni@redhat.com> wrote:

> On Sun, 2022-08-21 at 00:45 +0200, Alexander Couzens wrote:
> > The code expect the PHY to be in power down which is only true
> > after reset. Allow changes of the SGMII parameters more than once.
> > 
> > Signed-off-by: Alexander Couzens <lynxis@fe80.eu>
> > ---
> >  drivers/net/ethernet/mediatek/mtk_sgmii.c | 16 +++++++++++++++-
> >  1 file changed, 15 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/net/ethernet/mediatek/mtk_sgmii.c
> > b/drivers/net/ethernet/mediatek/mtk_sgmii.c index
> > a01bb20ea957..782812434367 100644 ---
> > a/drivers/net/ethernet/mediatek/mtk_sgmii.c +++
> > b/drivers/net/ethernet/mediatek/mtk_sgmii.c @@ -7,6 +7,7 @@
> >   *
> >   */
> >  
> > +#include <linux/delay.h>
> >  #include <linux/mfd/syscon.h>
> >  #include <linux/of.h>
> >  #include <linux/phylink.h>
> > @@ -24,6 +25,9 @@ static int mtk_pcs_setup_mode_an(struct mtk_pcs
> > *mpcs) {
> >  	unsigned int val;
> >  
> > +	/* PHYA power down */
> > +	regmap_write(mpcs->regmap, SGMSYS_QPHY_PWR_STATE_CTRL,
> > SGMII_PHYA_PWD);  
> 
> in mtk_pcs_setup_mode_an() and in mtk_pcs_setup_mode_force() the code
> carefully flips only the SGMII_PHYA_PWD bit. Is it safe to overwrite
> the full register contents?

I've read out the register without my patch and it's 0x0. The old driver
worked as long the engine came out of reset.
When writing the single bit SGMII_PHYA_PWD (0x10), the register might
end up containing 0x19 and as long 0x9 is in the register the link
doesn't work.

I've tested the driver with a mt7622 and Daniel Golle tested it with a
mt7986.


> 
> > +
> >  	/* Setup the link timer and QPHY power up inside SGMIISYS
> > */ regmap_write(mpcs->regmap, SGMSYS_PCS_LINK_TIMER,
> >  		     SGMII_LINK_TIMER_DEFAULT);
> > @@ -36,6 +40,10 @@ static int mtk_pcs_setup_mode_an(struct mtk_pcs
> > *mpcs) val |= SGMII_AN_RESTART;
> >  	regmap_write(mpcs->regmap, SGMSYS_PCS_CONTROL_1, val);
> >  
> > +	/* Release PHYA power down state
> > +	 * unknown how much the QPHY needs but it is racy without
> > a sleep
> > +	 */
> > +	usleep_range(50, 100);  
> 
> Ouch, this looks fragile, without any related H/W specification. 

The datasheet [1] doesn't say anything about it. I'ven't found a
mediatek SDK which adds a usleep(). It seems they always expect the
SGMII came out of reset and don't change after initial configured.
But without it, it's racy.

[1] MT7622 Reference Manual, v1.0, 2018-12-19, 1972 pages

> 
> >  	regmap_write(mpcs->regmap, SGMSYS_QPHY_PWR_STATE_CTRL, 0);
> >  
> >  	return 0;
> > @@ -50,6 +58,9 @@ static int mtk_pcs_setup_mode_force(struct
> > mtk_pcs *mpcs, {
> >  	unsigned int val;
> >  
> > +	/* PHYA power down */
> > +	regmap_write(mpcs->regmap, SGMSYS_QPHY_PWR_STATE_CTRL,
> > SGMII_PHYA_PWD); +
> >  	regmap_read(mpcs->regmap, mpcs->ana_rgc3, &val);
> >  	val &= ~RG_PHY_SPEED_MASK;
> >  	if (interface == PHY_INTERFACE_MODE_2500BASEX)
> > @@ -67,7 +78,10 @@ static int mtk_pcs_setup_mode_force(struct
> > mtk_pcs *mpcs, val |= SGMII_SPEED_1000;
> >  	regmap_write(mpcs->regmap, SGMSYS_SGMII_MODE, val);
> >  
> > -	/* Release PHYA power down state */
> > +	/* Release PHYA power down state
> > +	 * unknown how much the QPHY needs but it is racy without
> > a sleep
> > +	 */
> > +	usleep_range(50, 100);  
> 
> Same here.

Best,
lynxis
