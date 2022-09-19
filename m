Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C88225BCA9D
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 13:24:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230083AbiISLYP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 07:24:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229799AbiISLYO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 07:24:14 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6485E1A80A;
        Mon, 19 Sep 2022 04:24:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=mQIM/EJij0VCL0/KLKnA4As/obLNORXFYtrVRXtkL68=; b=Uy73segPjVyktd8MoQvEluJ9Sh
        8UMlXvBQXgcmxdqKPCvnG0AJB5XTJrqI6TkyZbqzLgvj3De5Z8SaAM66xp2jYDyFPEyh5IoLJBoyV
        YnFSkxf+7niuxzR2BJeS+2IUuG63xeDlCLVR6SXgLpKW2GK3p64cjCvnfjEBFSlbhVt5LwUBoty/0
        17xzYlZme8iC9EEtdlDJLQ6nK5GSU+zmxYvhlmyPJiY/l4nLkPJKT6yULBWYHKzZ1YSxRkPJquYcW
        16AZAqjaiImN+9RUOneXZF5KblFKbB4dTrNfXa1amvIj0XOknpHPV8q1ZVxCVKiFwppyWVpbxHQNp
        C+IMmD4g==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:34400)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1oaEsa-0000no-KQ; Mon, 19 Sep 2022 12:24:00 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1oaEsX-0006Lj-R3; Mon, 19 Sep 2022 12:23:57 +0100
Date:   Mon, 19 Sep 2022 12:23:57 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Alexander Couzens <lynxis@fe80.eu>
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
Message-ID: <YyhRTV7mh9emXl4v@shell.armlinux.org.uk>
References: <20220919083713.730512-1-lynxis@fe80.eu>
 <20220919083713.730512-6-lynxis@fe80.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220919083713.730512-6-lynxis@fe80.eu>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 19, 2022 at 10:37:12AM +0200, Alexander Couzens wrote:
> Both code paths (autonegotiated and force mode) are power cycling
> the phy. Move power cycling code to the caller to remove code
> duplicity.

I think we can do more consolidation here - and it probably makes sense
to do in another patch.

> diff --git a/drivers/net/ethernet/mediatek/mtk_sgmii.c b/drivers/net/ethernet/mediatek/mtk_sgmii.c
> index 4c8e8c7b1d32..50f605208295 100644
> --- a/drivers/net/ethernet/mediatek/mtk_sgmii.c
> +++ b/drivers/net/ethernet/mediatek/mtk_sgmii.c
> @@ -25,9 +25,6 @@ static int mtk_pcs_setup_mode_an(struct mtk_pcs *mpcs, phy_interface_t interface
>  {
>  	unsigned int val;
>  
> -	/* PHYA power down */
> -	regmap_write(mpcs->regmap, SGMSYS_QPHY_PWR_STATE_CTRL, SGMII_PHYA_PWD);
> -
>  	/* Set SGMII phy speed */
>  	regmap_read(mpcs->regmap, mpcs->ana_rgc3, &val);
>  	val &= ~RG_PHY_SPEED_MASK;
> @@ -72,9 +57,6 @@ static int mtk_pcs_setup_mode_force(struct mtk_pcs *mpcs,
>  {
>  	unsigned int val;
>  
> -	/* PHYA power down */
> -	regmap_write(mpcs->regmap, SGMSYS_QPHY_PWR_STATE_CTRL, SGMII_PHYA_PWD);
> -
>  	regmap_read(mpcs->regmap, mpcs->ana_rgc3, &val);
>  	val &= ~RG_PHY_SPEED_MASK;
>  	if (interface == PHY_INTERFACE_MODE_2500BASEX)

After powering the PHY down, the next thing that is done is to configure
the speed. Even with my comments on patch 4, this can still be
consolidated.

> @@ -115,12 +85,27 @@ static int mtk_pcs_config(struct phylink_pcs *pcs, unsigned int mode,
>  	struct mtk_pcs *mpcs = pcs_to_mtk_pcs(pcs);

	unsigned int val;

>  	int err = 0;
>  
> +	/* PHYA power down */
> +	regmap_write(mpcs->regmap, SGMSYS_QPHY_PWR_STATE_CTRL, SGMII_PHYA_PWD);
> +

	regmap_read(mpcs->regmap, mpcs->ana_rgc3, &val);
	val &= ~RG_PHY_SPEED_MASK;
	if (interface == PHY_INTERFACE_MODE_2500BASEX)
		val |= RG_PHY_SPEED_3_125G;
	regmap_write(mpcs->regmap, mpcs->ana_rgc3, val);

which would make logical sense to do here, so we always configure the
speed for the PCS correctly.

That then leaves the configuration of SGMSYS_PCS_CONTROL_1 and
SGMSYS_SGMII_MODE, which I think could also be consolidated, but I'll
leave that to those with the hardware to make that decision.

Reading between the lines of the code in this driver, it looks to me
like this hardware supports only SGMII, but doesn't actually support
1000base-X and 2500base-X with negotiation. Is that correct? If so,
it would be good to add a mtk_pcs_validate() function that clears
ETHTOOL_LINK_MODE_Autoneg_BIT for these modes.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
