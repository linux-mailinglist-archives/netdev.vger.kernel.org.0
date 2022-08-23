Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A704259EA2B
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 19:51:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231873AbiHWRkC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 13:40:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230342AbiHWRjR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 13:39:17 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1482DA5C4E;
        Tue, 23 Aug 2022 08:27:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=WGBOT8OTohW7/COq9mdVEqzeGYKhKe6FxtEGmt1DLuU=; b=shphAs2/laF9F0tecgG6Rk9wqs
        SnvnTahX4U2LqcGRCYRmuRwKRLQWBeS9BACJYuMR6dILrr18fG4fqw3djD8LPEJrpi6wag2sn6dmF
        o4IGVdwvp+YmoaQxnY6fwdK/nR+LZOc99tHEs6503VS/gjLUtWzJoeG8l7nIDq9bQ23CW67BZaYbj
        zysb/6AJT/6D8lxDPTKyTk2G5lDJZ1VIhjuhZTOYZFcd1GdV+gM7swDnEySv9EJq38YEjqolW0cYR
        9ighveL2OMqtguxRtjGOKKDUPjKN9bTWH3u8tUwTAjwqqMfER5fHp+tQWXM7KVR/WWn4eF6Zf6ttT
        eGcGxojA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:33894)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1oQVoF-0003Kq-4z; Tue, 23 Aug 2022 16:27:19 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1oQVo7-0003FO-FE; Tue, 23 Aug 2022 16:27:11 +0100
Date:   Tue, 23 Aug 2022 16:27:11 +0100
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
        netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-kernel@vger.kernel.org, Daniel Golle <daniel@makrotopia.org>
Subject: Re: [PATCH 4/4] net: mediatek: sgmii: set the speed according to the
 phy interface in AN
Message-ID: <YwTxzyQd4eUlf3j+@shell.armlinux.org.uk>
References: <20220820224538.59489-1-lynxis@fe80.eu>
 <20220820224538.59489-5-lynxis@fe80.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220820224538.59489-5-lynxis@fe80.eu>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 21, 2022 at 12:45:38AM +0200, Alexander Couzens wrote:
> The non auto-negotiating code path is setting the correct speed for the
> interface. Ensure auto-negotiation code path is doing it as well.
> 
> Signed-off-by: Alexander Couzens <lynxis@fe80.eu>
> ---
>  drivers/net/ethernet/mediatek/mtk_sgmii.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mediatek/mtk_sgmii.c b/drivers/net/ethernet/mediatek/mtk_sgmii.c
> index aa69baf1a42f..75de2c73a048 100644
> --- a/drivers/net/ethernet/mediatek/mtk_sgmii.c
> +++ b/drivers/net/ethernet/mediatek/mtk_sgmii.c
> @@ -21,13 +21,20 @@ static struct mtk_pcs *pcs_to_mtk_pcs(struct phylink_pcs *pcs)
>  }
>  
>  /* For SGMII interface mode */
> -static int mtk_pcs_setup_mode_an(struct mtk_pcs *mpcs)
> +static int mtk_pcs_setup_mode_an(struct mtk_pcs *mpcs, phy_interface_t interface)
>  {
>  	unsigned int val;
>  
>  	/* PHYA power down */
>  	regmap_write(mpcs->regmap, SGMSYS_QPHY_PWR_STATE_CTRL, SGMII_PHYA_PWD);
>  
> +	/* Set SGMII phy speed */
> +	regmap_read(mpcs->regmap, mpcs->ana_rgc3, &val);
> +	val &= ~RG_PHY_SPEED_MASK;
> +	if (interface == PHY_INTERFACE_MODE_2500BASEX)
> +		val |= RG_PHY_SPEED_3_125G;
> +	regmap_write(mpcs->regmap, mpcs->ana_rgc3, val);
> +

It looks to me like, after this commit, the initial part of
mtk_pcs_setup_mode_an() and mtk_pcs_setup_mode_force() are identical.
Also, I think that the tail of each of these functions is also
identical.

So, would it make sense for a final patch to tidy this code up?

>  	/* Setup the link timer and QPHY power up inside SGMIISYS */
>  	regmap_write(mpcs->regmap, SGMSYS_PCS_LINK_TIMER,
>  		     SGMII_LINK_TIMER_DEFAULT);
> @@ -100,7 +107,7 @@ static int mtk_pcs_config(struct phylink_pcs *pcs, unsigned int mode,
>  	if (interface != PHY_INTERFACE_MODE_SGMII)
>  		err = mtk_pcs_setup_mode_force(mpcs, interface);
>  	else if (phylink_autoneg_inband(mode))
> -		err = mtk_pcs_setup_mode_an(mpcs);
> +		err = mtk_pcs_setup_mode_an(mpcs, interface);

What is the situation when PHY_INTERFACE_MODE_SGMII is being used, but
we're not using inband mode? Right now, we don't do any configuration
of this block, and that seems rather wrong.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
