Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E8A26030DE
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 18:39:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229732AbiJRQji (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 12:39:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiJRQjf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 12:39:35 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A2B018348;
        Tue, 18 Oct 2022 09:39:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=65bEymJ6ebXyukg1mYJd0nAb5NJZzFAYYGuH+aczhNo=; b=ltF5gg985jvEOsX9L5HsHuiNyj
        D4uQN4/DjloYOv61pSRgwUw1yX1BLI6JFTTK5UAj8sDMvgKtWsMmgVmmbQP2aoSqNIXA6QCAw/fA/
        Mp88Z1BxtyzUK0YyAbFWKvLSkHEgBrluaSe+0hskBmQTtfnb7WTDvMMyzb2CLR2MGjuOX7fFFBrjx
        ZNyfNDnlsVoQaZi8ur0uwR/lilvC1Lr7lObOz4jvlGe8aJDCU51XV1yoXmou9S6epiKiVz65gVmgO
        Fv3uEQmzgcYzuFRc/TJQ6GBSZ595tH/pbmD5Hn9/nnxXmnY+ZsKG7VcaO818LigTO20kkydB0hsPN
        9PfgsUjA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:34774)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1okpcR-0004ga-9F; Tue, 18 Oct 2022 17:39:07 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1okpcL-0001DJ-1a; Tue, 18 Oct 2022 17:39:01 +0100
Date:   Tue, 18 Oct 2022 17:39:01 +0100
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
Subject: Re: [PATCH] net: mtk_sgmii: implement mtk_pcs_ops
Message-ID: <Y07Wpd1A1xxLhIVc@shell.armlinux.org.uk>
References: <20221018153506.60944-1-linux@fw-web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221018153506.60944-1-linux@fw-web.de>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

A couple of points:

On Tue, Oct 18, 2022 at 05:35:06PM +0200, Frank Wunderlich wrote:
> diff --git a/drivers/net/ethernet/mediatek/mtk_sgmii.c b/drivers/net/ethernet/mediatek/mtk_sgmii.c
> index 736839c84130..9614973fd9c4 100644
> --- a/drivers/net/ethernet/mediatek/mtk_sgmii.c
> +++ b/drivers/net/ethernet/mediatek/mtk_sgmii.c
> @@ -122,10 +122,25 @@ static void mtk_pcs_link_up(struct phylink_pcs *pcs, unsigned int mode,
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
> +	regmap_read(mpcs->regmap, SGMSYS_PCS_CONTROL_1, &val);
> +	state->an_complete = !!(val & SGMII_AN_COMPLETE);
> +	state->link = !!(val & SGMII_LINK_STATYS);
> +	state->pause = 0;

Finally, something approaching a reasonable implementation for this!
Two points however:
1) There's no need to set state->pause if there is no way to get that
   state.
2) There should also be a setting for state->pause.

> +}
> +
>  static const struct phylink_pcs_ops mtk_pcs_ops = {
>  	.pcs_config = mtk_pcs_config,
>  	.pcs_an_restart = mtk_pcs_restart_an,
>  	.pcs_link_up = mtk_pcs_link_up,
> +	.pcs_get_state = mtk_pcs_get_state,

Please keep this in order - pcs_get_state should be just before
pcs_config.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
