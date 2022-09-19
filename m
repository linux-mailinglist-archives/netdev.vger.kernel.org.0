Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 962F55BCDC5
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 15:58:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231207AbiISN6z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 09:58:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231175AbiISN6o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 09:58:44 -0400
Received: from mail.base45.de (mail.base45.de [80.241.60.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 075352A70A;
        Mon, 19 Sep 2022 06:58:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=fe80.eu;
        s=20190804; h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:
        In-Reply-To:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=y2eZFXkRGCADI8G4ZiLU6FZ1217+LNWKnbyMSfFCMqI=; b=PUEX4Jv/i8vf9eVrlZywyq7r2w
        v8LyfhzVohWEZO/2zG+eaIOicaQP+CCg//8Fb94L+jEIEhJ12jwKfMUppiOycjx8yTp6I4xpwpMnH
        d1KxHVjLEk6UXxOXbQnYFTZEX50gkc0xs2YiPEhEWazgQ76NnQZys81tqUnwW8enHzr2eTRML7Fnd
        3c+Ypffp8Dl/RduZn5Iqc9rJ4KL8YcxnACcfVfUWS+5VaR8KVMAmDhB/MBoGDciXMa6JYYzgu3fp7
        dgnoXFE7PIhE4EdtipcheQM/wy9SLTMalG41KwAAwBzcF6pgze96CsVjCsIKyb3PyrGMbHIs9HG7+
        HELNZOeA==;
Received: from [92.206.252.27] (helo=javelin)
        by mail.base45.de with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <lynxis@fe80.eu>)
        id 1oaHFn-0018kh-Hc; Mon, 19 Sep 2022 13:56:07 +0000
Date:   Mon, 19 Sep 2022 15:56:06 +0200
From:   Alexander 'lynxis' Couzens <lynxis@fe80.eu>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Daniel Golle <daniel@makrotopia.org>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 5/5] net: mediatek: sgmii: refactor power
 cycling into mtk_pcs_config()
Message-ID: <20220919155606.3270478d@javelin>
In-Reply-To: <YyhRTV7mh9emXl4v@shell.armlinux.org.uk>
References: <20220919083713.730512-1-lynxis@fe80.eu>
        <20220919083713.730512-6-lynxis@fe80.eu>
        <YyhRTV7mh9emXl4v@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > -	/* PHYA power down */
> > -	regmap_write(mpcs->regmap, SGMSYS_QPHY_PWR_STATE_CTRL,
> > SGMII_PHYA_PWD); -
> >  	/* Set SGMII phy speed */
> >  	regmap_read(mpcs->regmap, mpcs->ana_rgc3, &val);
> >  	val &= ~RG_PHY_SPEED_MASK;
> > @@ -72,9 +57,6 @@ static int mtk_pcs_setup_mode_force(struct
> > mtk_pcs *mpcs, {
> >  	unsigned int val;
> >  
> > -	/* PHYA power down */
> > -	regmap_write(mpcs->regmap, SGMSYS_QPHY_PWR_STATE_CTRL,
> > SGMII_PHYA_PWD); -
> >  	regmap_read(mpcs->regmap, mpcs->ana_rgc3, &val);
> >  	val &= ~RG_PHY_SPEED_MASK;
> >  	if (interface == PHY_INTERFACE_MODE_2500BASEX)  
> 
> After powering the PHY down, the next thing that is done is to
> configure the speed. Even with my comments on patch 4, this can still
> be consolidated.

I'll move more code out of the functions.

> 
> > @@ -115,12 +85,27 @@ static int mtk_pcs_config(struct phylink_pcs
> > *pcs, unsigned int mode, struct mtk_pcs *mpcs =
> > pcs_to_mtk_pcs(pcs);  
> 
> 	unsigned int val;
> 
> >  	int err = 0;
> >  
> > +	/* PHYA power down */
> > +	regmap_write(mpcs->regmap, SGMSYS_QPHY_PWR_STATE_CTRL,
> > SGMII_PHYA_PWD);
> > +  
> 
> 	regmap_read(mpcs->regmap, mpcs->ana_rgc3, &val);
> 	val &= ~RG_PHY_SPEED_MASK;
> 	if (interface == PHY_INTERFACE_MODE_2500BASEX)
> 		val |= RG_PHY_SPEED_3_125G;
> 	regmap_write(mpcs->regmap, mpcs->ana_rgc3, val);
> 
> which would make logical sense to do here, so we always configure the
> speed for the PCS correctly.
> 
> That then leaves the configuration of SGMSYS_PCS_CONTROL_1 and
> SGMSYS_SGMII_MODE, which I think could also be consolidated, but I'll
> leave that to those with the hardware to make that decision.
> 
> Reading between the lines of the code in this driver, it looks to me
> like this hardware supports only SGMII, but doesn't actually support
> 1000base-X and 2500base-X with negotiation. Is that correct? If so,
> it would be good to add a mtk_pcs_validate() function that clears
> ETHTOOL_LINK_MODE_Autoneg_BIT for these modes.

I don't know. I don't have hardware to debug
the serdes interface further. I only have a test board with mt7622 soc
connect via SGMII/2500basex to a realtek phy (rtl8221).

Maybe the maintainers from mediatek could share some knowledge if the
SGMII block supports 1000/2500basex autoneg?

At least with the public available datasheets (mt7531, mt7622) doesn't
explain it further.
I could also imagine we need to modify the page register
(PCS_SPEED_ABILITY) and link timer to get autoneg for
1000basex/2500basex working.

Best,
lynxis
