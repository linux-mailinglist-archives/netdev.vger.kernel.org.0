Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60BAE6B061F
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 12:39:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229733AbjCHLjS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 06:39:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230365AbjCHLim (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 06:38:42 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B3D17C3F0;
        Wed,  8 Mar 2023 03:38:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=5eLTHF6ZVD7q+XoBX/Z8f3udaRyHm9hE2Qes4Y+33Z8=; b=Jsw+Qi019/aK0xSskknbfctX55
        H/Kbz46G65qhIwm5ZlU0MQXS05aISh+FQJY3BeUtDyopl3ls7AlBppr28dKtrCNM3wPEsZBv7/gqs
        U70fpfCFe1dpkhcsnEanamebkLNCgwOb4qOa3r6s0HSRXY8h7YPlb+/xq9M1ByKCtZbRkMnucZ63b
        S6xm8ndirwkXSZpDeNW1m+8MTZYSl5WAGt2giq2HthVCOTbQYyym0/5eQf057TJmBh4pFp++NNUAh
        j4X9KjZ9JphQf4/PTu34ey9N8mPkpz4mz0Q0cnFDHztWynNihFXJKDvQmKtNkA2XJRV/rn+dBXUnb
        j1MvGi/g==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:36214)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pZs7t-0002N5-62; Wed, 08 Mar 2023 11:38:33 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pZs7r-0002XQ-RT; Wed, 08 Mar 2023 11:38:31 +0000
Date:   Wed, 8 Mar 2023 11:38:31 +0000
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
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jianhui Zhao <zhaojh329@gmail.com>,
        =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        Frank Wunderlich <frank-w@public-files.de>,
        Alexander Couzens <lynxis@fe80.eu>
Subject: Re: [PATCH net-next v12 09/18] net: ethernet: mtk_eth_soc: Fix link
 status for none-SGMII modes
Message-ID: <ZAhzt5eIZiJUyVm7@shell.armlinux.org.uk>
References: <cover.1678201958.git.daniel@makrotopia.org>
 <1590fb0e69f6243ac6a961b16bf7ae7534f46949.1678201958.git.daniel@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1590fb0e69f6243ac6a961b16bf7ae7534f46949.1678201958.git.daniel@makrotopia.org>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 07, 2023 at 03:54:11PM +0000, Daniel Golle wrote:
> Link partner advertised link modes are not reported by the SerDes
> hardware if not operating in SGMII mode. Hence we cannot use
> phylink_mii_c22_pcs_decode_state() in this case.
> Implement reporting link and an_complete only and use speed according to
> the interface mode.
> 
> Fixes: 14a44ab0330d ("net: mtk_eth_soc: partially convert to phylink_pcs")
> Signed-off-by: Daniel Golle <daniel@makrotopia.org>

This has been proven to work by Frank Wunderlich last October, so by
making this change, you will be regressing his setup.

What are you testing against? Have you proven independently that the
link partner is indeed sending a valid advertisement for the LPA
register to be filled in?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
