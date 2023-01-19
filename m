Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A3C4673FB8
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 18:17:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229798AbjASRRx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 12:17:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229592AbjASRRw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 12:17:52 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4449E2887F
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 09:17:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=3xMlunkRCcJIS751bLdhsys16drmVg5YEN73wGDCqxg=; b=wEsW0+j8MBQKhcVhQgxiw9FYhj
        Xa4aWl4aNJx2MYLVcOzLaF9vx2SwFZht0qonGgGvahLKdzY3OVY1jabWM1XlybXAdGc3t/zMsdbWe
        /irTeZJ77jv8YUsR1pe9dV2Jx+iROOQ8H5k5y0h2Gc8C9Kyc6EnzY1CSngAvXGyupu4BvKrSXKsCa
        GojjJaV0d3RhN879yYBhe8b0QjTfux/iHamEu2ynbZLMtZkPMEW3mTC2immtLII53hyMy54U2ci0n
        H+N8QV8SJjkJtGMFoVK8FRdNi6KyEGZel1qQ7iVWto3wBkpODRbg9PfrxPq/HM9udGxuWuBvq41v6
        tmqXwoyw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:36210)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pIYXs-0004jM-G9; Thu, 19 Jan 2023 17:17:48 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pIYXr-0000eM-1L; Thu, 19 Jan 2023 17:17:47 +0000
Date:   Thu, 19 Jan 2023 17:17:47 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>
Cc:     netdev@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Daniel Golle <daniel@makrotopia.org>,
        Alexander Couzens <lynxis@fe80.eu>
Subject: Re: [PATCH net 1/3] net: mediatek: sgmii: ensure the SGMII PHY is
 powered down on configuration
Message-ID: <Y8l7Oz9gpslb3IwH@shell.armlinux.org.uk>
References: <20230119171248.3882021-1-bjorn@mork.no>
 <20230119171248.3882021-2-bjorn@mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230119171248.3882021-2-bjorn@mork.no>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 19, 2023 at 06:12:46PM +0100, Bjørn Mork wrote:
> From: Alexander Couzens <lynxis@fe80.eu>
> 
> The code expect the PHY to be in power down which is only true after reset.
> Allow changes of the SGMII parameters more than once.
> 
> There are cases when the SGMII_PHYA_PWD register contains 0x9 which
> prevents SGMII from working. The SGMII still shows link but no traffic
> can flow. Writing 0x0 to the PHYA_PWD register fix the issue. 0x0 was
> taken from a good working state of the SGMII interface.
> 
> Signed-off-by: Alexander Couzens <lynxis@fe80.eu>
> [ bmork: rebased and squashed into one patch ]
> Signed-off-by: Bjørn Mork <bjorn@mork.no>
> ---
>  drivers/net/ethernet/mediatek/mtk_sgmii.c | 18 +++++++++++++++---
>  1 file changed, 15 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mediatek/mtk_sgmii.c b/drivers/net/ethernet/mediatek/mtk_sgmii.c
> index 5c286f2c9418..481f2f1e39f5 100644
> --- a/drivers/net/ethernet/mediatek/mtk_sgmii.c
> +++ b/drivers/net/ethernet/mediatek/mtk_sgmii.c
> @@ -88,6 +88,10 @@ static int mtk_pcs_config(struct phylink_pcs *pcs, unsigned int mode,
>  		bmcr = 0;
>  	}
>  
> +	/* PHYA power down */
> +	regmap_update_bits(mpcs->regmap, SGMSYS_QPHY_PWR_STATE_CTRL,
> +			   SGMII_PHYA_PWD, SGMII_PHYA_PWD);
> +

Doing this unconditionally means that the link will drop - even when
we aren't doing any reconfiguration (except changing the advertisement).
That's why I made it conditional in the version of the patch I sent
(which failed due to the unknown bits 3 and 0.)

We should always avoid bouncing the link when there's no reason to.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
