Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC9206B06A8
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 13:12:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231214AbjCHML7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 07:11:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbjCHML6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 07:11:58 -0500
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41005A42F5;
        Wed,  8 Mar 2023 04:11:57 -0800 (PST)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.96)
        (envelope-from <daniel@makrotopia.org>)
        id 1pZse8-0002CF-0s;
        Wed, 08 Mar 2023 13:11:52 +0100
Date:   Wed, 8 Mar 2023 12:11:48 +0000
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
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jianhui Zhao <zhaojh329@gmail.com>,
        =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        Frank Wunderlich <frank-w@public-files.de>,
        Alexander Couzens <lynxis@fe80.eu>
Subject: Re: [PATCH net-next v12 08/18] net: ethernet: mtk_eth_soc: fix
 1000Base-X and 2500Base-X modes
Message-ID: <ZAh7hA4JuJm1b2M6@makrotopia.org>
References: <cover.1678201958.git.daniel@makrotopia.org>
 <fd5c7ea79a7f84caac7d0b64b39fe5c4043edfa8.1678201958.git.daniel@makrotopia.org>
 <ZAhzDDjZ8+gxyo3V@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZAhzDDjZ8+gxyo3V@shell.armlinux.org.uk>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 08, 2023 at 11:35:40AM +0000, Russell King (Oracle) wrote:
> On Tue, Mar 07, 2023 at 03:53:58PM +0000, Daniel Golle wrote:
> > After conversion to phylink_pcs the 1000Base-X and 2500Base-X modes
> > would work only after `ethtool -s eth1 autoneg off`.
> > As ethtool autoneg and the ETHTOOL_LINK_MODE_Autoneg_BIT is supposed
> > to control auto-negotiation on the external interface it doesn't make
> > much sense to use it to control on-board SGMII auto-negotiation between
> > MAC and PHY.
> > Set correct values to really only enable SGMII auto-negotiation when
> > actually operating in SGMII mode. For 1000Base-X and 2500Base-X mode,
> > enable remote-fault detection only if in-band-status is enabled.
> > This fixes using 1000Base-X and 2500Base-X SFPs on the BananaPi R3
> > board and also makes it possible to use interface-mode-switching PHYs
> > operating in either SGMII mode for 10M/100M/1000M or in 2500Base-X for
> > 2500M mode on other boards.
> > 
> > Fixes: 14a44ab0330d ("net: mtk_eth_soc: partially convert to phylink_pcs")
> > Signed-off-by: Daniel Golle <daniel@makrotopia.org>
> 
> NAK.
> 
> There are PHYs out there which operate in SGMII mode but do not
> exchange the SGMII 16-bit configuration word. The code implemented
> here by me was explicitly to allow such a configuration to work,
> which is defined as:
> 
> 	SGMII *without* mode == inband
> 
> An example of this is the Broadcom 84881 PHY which can be found on
> SFP modules.

I also have multiple such 1000Base-T SFP modules here (finisar, AJYA),
and this change doesn't touch the codepaths relevant for those. They
are operating in SGMII mode, they have always been working fine.

What I'm trying to fix here is 1000Base-X and 2500Base-X mode which
has been broken by introducing ETHTOOL_LINK_MODE_Autoneg_BIT as the
deciding factor for in-band AN here.

Can you explain why ETHTOOL_LINK_MODE_Autoneg_BIT was used there in
first place? Is my understanding of this bit controlling autoneg on the
*external* interface rather than on the *system-side* interface wrong?
