Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBD7B691D02
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 11:39:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232116AbjBJKiz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 05:38:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232111AbjBJKix (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 05:38:53 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B29A18AB9;
        Fri, 10 Feb 2023 02:38:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=2OUA7HlYXogwM8qpdJDrZwtYflzFDq9HBMiwA08oRKM=; b=HMRpaiphWDk/DkQhDFVSnenS7r
        QWasYa8MlAUK5cojxWkk1gmQXQsgQgXYLd/08Ag1P5+Ca0G00vbY0uLRaLn8aErbrph/gK8FGDmo7
        kL0N1dhqdIN/FwfM07L3HqzX//P0Ujig9IYQVDtBa21jkukIP01mpkfznDTvUA1Y6RHEEuaVrNRfO
        NUSf2QGWkBkeHEuJtddur+5ih+hRPRJwPePwuKtDyGOxp8oV5Vy/nGuc7+9pgwA22zm1MYYjXdeaP
        DR6Ixx3mDorResI5ys8WhtK+qg7IYGpHulnErtVo9CzKh8sYU4tEmT5/AUCt2IBCjUAWE70J52PWN
        aksFGXhQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:36506)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pQQnq-0001II-Ev; Fri, 10 Feb 2023 10:38:50 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pQQno-0005Us-Su; Fri, 10 Feb 2023 10:38:48 +0000
Date:   Fri, 10 Feb 2023 10:38:48 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Daniel Golle <daniel@makrotopia.org>
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
Subject: Re: [PATCH v2 06/11] net: ethernet: mtk_eth_soc: only write values
 if needed
Message-ID: <Y+YeuCgwdgiuS+te@shell.armlinux.org.uk>
References: <cover.1675779094.git.daniel@makrotopia.org>
 <ce55597e584e2d85dea14083bda56aa5bf18ea8b.1675779094.git.daniel@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ce55597e584e2d85dea14083bda56aa5bf18ea8b.1675779094.git.daniel@makrotopia.org>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 07, 2023 at 02:21:25PM +0000, Daniel Golle wrote:
> @@ -106,16 +101,21 @@ static int mtk_pcs_config(struct phylink_pcs *pcs, unsigned int mode,
>  		regmap_update_bits(mpcs->regmap, mpcs->ana_rgc3,
>  				   RG_PHY_SPEED_3_125G, rgc3);
>  
> +		/* Setup the link timer and QPHY power up inside SGMIISYS */
> +		link_timer = phylink_get_link_timer_ns(interface);
> +		if (link_timer < 0)
> +			return link_timer;

I know I asked for this to be placed inside this if(), but I'd prefer it
if it were before any register state was touched, so if it returns an
error then no register state is affected by the pcs_config() call.

IIRC, we don't touch any state before the if(), so it should be a
matter of placing it as one of the first things in the if() block.

Thanks!

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
