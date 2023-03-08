Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86AD26B0772
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 13:53:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229929AbjCHMxh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 07:53:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229793AbjCHMxf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 07:53:35 -0500
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCEB79BE03;
        Wed,  8 Mar 2023 04:53:29 -0800 (PST)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.96)
        (envelope-from <daniel@makrotopia.org>)
        id 1pZtIJ-0002Wu-1C;
        Wed, 08 Mar 2023 13:53:23 +0100
Date:   Wed, 8 Mar 2023 12:53:13 +0000
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
Message-ID: <ZAiFOTRQI36nGo+w@makrotopia.org>
References: <cover.1678201958.git.daniel@makrotopia.org>
 <fd5c7ea79a7f84caac7d0b64b39fe5c4043edfa8.1678201958.git.daniel@makrotopia.org>
 <ZAhzDDjZ8+gxyo3V@shell.armlinux.org.uk>
 <ZAh7hA4JuJm1b2M6@makrotopia.org>
 <ZAiCh8wkdTBT+6Id@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZAiCh8wkdTBT+6Id@shell.armlinux.org.uk>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 08, 2023 at 12:41:43PM +0000, Russell King (Oracle) wrote:
> On Wed, Mar 08, 2023 at 12:11:48PM +0000, Daniel Golle wrote:
> > On Wed, Mar 08, 2023 at 11:35:40AM +0000, Russell King (Oracle) wrote:
> > > On Tue, Mar 07, 2023 at 03:53:58PM +0000, Daniel Golle wrote:
> > > > After conversion to phylink_pcs the 1000Base-X and 2500Base-X modes
> > > > would work only after `ethtool -s eth1 autoneg off`.
> > > > As ethtool autoneg and the ETHTOOL_LINK_MODE_Autoneg_BIT is supposed
> > > > to control auto-negotiation on the external interface it doesn't make
> > > > much sense to use it to control on-board SGMII auto-negotiation between
> > > > MAC and PHY.
> > > > Set correct values to really only enable SGMII auto-negotiation when
> > > > actually operating in SGMII mode. For 1000Base-X and 2500Base-X mode,
> > > > enable remote-fault detection only if in-band-status is enabled.
> > > > This fixes using 1000Base-X and 2500Base-X SFPs on the BananaPi R3
> > > > board and also makes it possible to use interface-mode-switching PHYs
> > > > operating in either SGMII mode for 10M/100M/1000M or in 2500Base-X for
> > > > 2500M mode on other boards.
> > > > 
> > > > Fixes: 14a44ab0330d ("net: mtk_eth_soc: partially convert to phylink_pcs")
> > > > Signed-off-by: Daniel Golle <daniel@makrotopia.org>
> > > 
> > > NAK.
> > > 
> > > There are PHYs out there which operate in SGMII mode but do not
> > > exchange the SGMII 16-bit configuration word. The code implemented
> > > here by me was explicitly to allow such a configuration to work,
> > > which is defined as:
> > > 
> > > 	SGMII *without* mode == inband
> > > 
> > > An example of this is the Broadcom 84881 PHY which can be found on
> > > SFP modules.
> > 
> > I also have multiple such 1000Base-T SFP modules here (finisar, AJYA),
> > and this change doesn't touch the codepaths relevant for those. They
> > are operating in SGMII mode, they have always been working fine.
> > 
> > What I'm trying to fix here is 1000Base-X and 2500Base-X mode which
> > has been broken by introducing ETHTOOL_LINK_MODE_Autoneg_BIT as the
> > deciding factor for in-band AN here.
> 
> ... which is correct.
> 
> > Can you explain why ETHTOOL_LINK_MODE_Autoneg_BIT was used there in
> > first place? Is my understanding of this bit controlling autoneg on the
> > *external* interface rather than on the *system-side* interface wrong?
> 
> Think about what 1000BASE-X is for. It's not really for internal links,
> it's intended by IEEE 802.3 to be the 1G *media* side protocol for
> 1000BASE-SX, 1000BASE-LX, 1000BASE-CX etc links.
> 
> Therefore, when being used in that case, one may wish to disable
> autoneg over the fibre link. Hence, turning off autoneg via ethtool
> *should* turn off autoneg over the fibre link. So, using
> ETHTOOL_LINK_MODE_Autoneg_BIT to gate 802.3z autonegotiation the
> correct thing to do.
> 
> If we have a PHY using 1000BASE-X, then it is at odds with the
> primary purpose of this protocol, especially with it comes to AN.
> This is why phylink used to refuse to accept PHYs when using 802.3z
> mode, but Marek wanted this to work, so relaxed the checks
> preventing such a setup working.

Sadly 2500Base-X is very commonly used to connect 2500Base-T-capable
PHYs or SFP modules. I also got an ATS branded 1000M/100M/10M copper
SFP module which uses 1000Base-X as system-side interface, independently
of the speed of the link partner on the TP interface.
All of them do not work with inband-AN enabled and a link only comes
up after `ethtool -s eth1 autoneg off` in the current implementation,
while previously they were working just fine.

I understand that there isn't really a good solution for 1000Base-X as
thanks to you I now understand that SerDes autoneg just transparently
ends up being autoneg on a fiber link.

2500Base-X, however, is hardly used for fiber links, but rather mostly
for 2500Base-T PHYs and SFP module as well as xPON SFPs. Maybe we could
at least have in-band AN disabled by default for those to get them
working without requiring the user to carry out ethtool settings?
