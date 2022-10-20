Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B84EB60658D
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 18:18:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230308AbiJTQSF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 12:18:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229876AbiJTQSE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 12:18:04 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01F3410573;
        Thu, 20 Oct 2022 09:17:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=lESwXvm7/TM1xJl1haYY/cX2oj4VfSDfgY65rchWdvg=; b=QvK+ioe3eZ2LCAB86gz7Gd5G95
        x0fPcG2Db25FHsXiK/+Sw24enuFw55evax9BQKac4ROlOtV4+Q/AGvtRu2zCpjUdS+eUlFdJaCj4x
        RToIx5OUJMTOe74dz3GKKjvingM8LPXxAT3crT+3oOy9acGTgfzr0bZqAFuFTf1ZXJmJu3P+7majd
        mBCgwI1R5d3DCeoJ/+omEjyTxcL+oKtRS+wbca543Mz5cVhxgdoJ/qmkLsxPVLmhx0WkNLZYKXA6K
        CzK5goRxtiHEORaGz2DoZVCYCxgsXfv5ZXuMC/McJEeEsdN/ewB7uxoUqmCqsbzIqFVUQtNJbuVN8
        XHZH51KQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:34828)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1olYEr-0007UG-6T; Thu, 20 Oct 2022 17:17:45 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1olYEn-0003IX-Hp; Thu, 20 Oct 2022 17:17:41 +0100
Date:   Thu, 20 Oct 2022 17:17:41 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Frank Wunderlich <linux@fw-web.de>
Cc:     linux-mediatek@lists.infradead.org,
        Alexander Couzens <lynxis@fe80.eu>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Frank Wunderlich <frank-w@public-files.de>
Subject: Re: [PATCH v2] net: mtk_sgmii: implement mtk_pcs_ops
Message-ID: <Y1F0pSrJnNlYzehq@shell.armlinux.org.uk>
References: <20221020144431.126124-1-linux@fw-web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221020144431.126124-1-linux@fw-web.de>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 20, 2022 at 04:44:31PM +0200, Frank Wunderlich wrote:
> diff --git a/drivers/net/ethernet/mediatek/mtk_sgmii.c b/drivers/net/ethernet/mediatek/mtk_sgmii.c
> index 736839c84130..8b7465057e57 100644
> --- a/drivers/net/ethernet/mediatek/mtk_sgmii.c
> +++ b/drivers/net/ethernet/mediatek/mtk_sgmii.c
> @@ -122,7 +122,21 @@ static void mtk_pcs_link_up(struct phylink_pcs *pcs, unsigned int mode,
>  	regmap_write(mpcs->regmap, SGMSYS_SGMII_MODE, val);
>  }
>  
> +static void mtk_pcs_get_state(struct phylink_pcs *pcs, struct phylink_link_state *state)
> +{
> +	struct mtk_pcs *mpcs = pcs_to_mtk_pcs(pcs);
> +	unsigned int val;
> +
> +	regmap_read(mpcs->regmap, mpcs->ana_rgc3, &val);
> +	state->speed = val & RG_PHY_SPEED_3_125G ? SPEED_2500 : SPEED_1000;
> +

Sorry, looking back at my initial comment on the first revision of this
patch, I see my second point was confused. It should have read:

"2) There should also be a setting for state->duplex."

IOW, "duplex" instead of "pause".

Also, is there no way to read the link partner advertisement?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
