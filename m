Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 994D16B0B4A
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 15:33:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232029AbjCHOdM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 09:33:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231861AbjCHOdG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 09:33:06 -0500
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ADC914200;
        Wed,  8 Mar 2023 06:32:58 -0800 (PST)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.96)
        (envelope-from <daniel@makrotopia.org>)
        id 1pZuqX-0003Nq-2f;
        Wed, 08 Mar 2023 15:32:50 +0100
Date:   Wed, 8 Mar 2023 14:32:40 +0000
From:   Daniel Golle <daniel@makrotopia.org>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
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
        =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        Frank Wunderlich <frank-w@public-files.de>,
        Alexander Couzens <lynxis@fe80.eu>
Subject: Re: [PATCH net-next v12 08/18] net: ethernet: mtk_eth_soc: fix
 1000Base-X and 2500Base-X modes
Message-ID: <ZAiciK5fElvLXYQ9@makrotopia.org>
References: <cover.1678201958.git.daniel@makrotopia.org>
 <fd5c7ea79a7f84caac7d0b64b39fe5c4043edfa8.1678201958.git.daniel@makrotopia.org>
 <ZAhzDDjZ8+gxyo3V@shell.armlinux.org.uk>
 <ZAh7hA4JuJm1b2M6@makrotopia.org>
 <ZAiCh8wkdTBT+6Id@shell.armlinux.org.uk>
 <ZAiFOTRQI36nGo+w@makrotopia.org>
 <ZAiJqvzcUob2Aafq@shell.armlinux.org.uk>
 <20230308134642.cdxqw4lxtlgfsl4g@skbuf>
 <ZAiXvNT8EzHTmFPh@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZAiXvNT8EzHTmFPh@shell.armlinux.org.uk>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 08, 2023 at 01:12:10PM +0000, Russell King (Oracle) wrote:
> On Wed, Mar 08, 2023 at 12:53:13PM +0000, Daniel Golle wrote:
> > On Wed, Mar 08, 2023 at 12:41:43PM +0000, Russell King (Oracle) wrote:
> > > On Wed, Mar 08, 2023 at 12:11:48PM +0000, Daniel Golle wrote:
> > > > On Wed, Mar 08, 2023 at 11:35:40AM +0000, Russell King (Oracle) wrote:
> > > > > On Tue, Mar 07, 2023 at 03:53:58PM +0000, Daniel Golle wrote:
> > > > > > After conversion to phylink_pcs the 1000Base-X and 2500Base-X modes
> > > > > > would work only after `ethtool -s eth1 autoneg off`.
> > > > > > As ethtool autoneg and the ETHTOOL_LINK_MODE_Autoneg_BIT is supposed
> > > > > > to control auto-negotiation on the external interface it doesn't make
> > > > > > much sense to use it to control on-board SGMII auto-negotiation between
> > > > > > MAC and PHY.
> > > > > > Set correct values to really only enable SGMII auto-negotiation when
> > > > > > actually operating in SGMII mode. For 1000Base-X and 2500Base-X mode,
> > > > > > enable remote-fault detection only if in-band-status is enabled.
> > > > > > This fixes using 1000Base-X and 2500Base-X SFPs on the BananaPi R3
> > > > > > board and also makes it possible to use interface-mode-switching PHYs
> > > > > > operating in either SGMII mode for 10M/100M/1000M or in 2500Base-X for
> > > > > > 2500M mode on other boards.
> > > > > > 
> > > > > > Fixes: 14a44ab0330d ("net: mtk_eth_soc: partially convert to phylink_pcs")
> > > > > > Signed-off-by: Daniel Golle <daniel@makrotopia.org>
> > > > > 
> > > > > NAK.
> > > > > 
> > > > > There are PHYs out there which operate in SGMII mode but do not
> > > > > exchange the SGMII 16-bit configuration word. The code implemented
> > > > > here by me was explicitly to allow such a configuration to work,
> > > > > which is defined as:
> > > > > 
> > > > > 	SGMII *without* mode == inband
> > > > > 
> > > > > An example of this is the Broadcom 84881 PHY which can be found on
> > > > > SFP modules.
> > > > 
> > > > I also have multiple such 1000Base-T SFP modules here (finisar, AJYA),
> > > > and this change doesn't touch the codepaths relevant for those. They
> > > > are operating in SGMII mode, they have always been working fine.
> > > > 
> > > > What I'm trying to fix here is 1000Base-X and 2500Base-X mode which
> > > > has been broken by introducing ETHTOOL_LINK_MODE_Autoneg_BIT as the
> > > > deciding factor for in-band AN here.
> > > 
> > > ... which is correct.
> > > 
> > > > Can you explain why ETHTOOL_LINK_MODE_Autoneg_BIT was used there in
> > > > first place? Is my understanding of this bit controlling autoneg on the
> > > > *external* interface rather than on the *system-side* interface wrong?
> > > 
> > > Think about what 1000BASE-X is for. It's not really for internal links,
> > > it's intended by IEEE 802.3 to be the 1G *media* side protocol for
> > > 1000BASE-SX, 1000BASE-LX, 1000BASE-CX etc links.
> > > 
> > > Therefore, when being used in that case, one may wish to disable
> > > autoneg over the fibre link. Hence, turning off autoneg via ethtool
> > > *should* turn off autoneg over the fibre link. So, using
> > > ETHTOOL_LINK_MODE_Autoneg_BIT to gate 802.3z autonegotiation the
> > > correct thing to do.
> > > 
> > > If we have a PHY using 1000BASE-X, then it is at odds with the
> > > primary purpose of this protocol, especially with it comes to AN.
> > > This is why phylink used to refuse to accept PHYs when using 802.3z
> > > mode, but Marek wanted this to work, so relaxed the checks
> > > preventing such a setup working.
> > 
> > Sadly 2500Base-X is very commonly used to connect 2500Base-T-capable
> > PHYs or SFP modules. I also got an ATS branded 1000M/100M/10M copper
> > SFP module which uses 1000Base-X as system-side interface, independently
> > of the speed of the link partner on the TP interface.
> > All of them do not work with inband-AN enabled and a link only comes
> > up after `ethtool -s eth1 autoneg off` in the current implementation,
> > while previously they were working just fine.
> > 
> > I understand that there isn't really a good solution for 1000Base-X as
> > thanks to you I now understand that SerDes autoneg just transparently
> > ends up being autoneg on a fiber link.
> > 
> > 2500Base-X, however, is hardly used for fiber links, but rather mostly
> > for 2500Base-T PHYs and SFP module as well as xPON SFPs. Maybe we could
> > at least have in-band AN disabled by default for those to get them
> > working without requiring the user to carry out ethtool settings?
> 
> We could _possibly_ make 2500base-X ignore the autoneg bit, but in
> order to do that I would want to make other changes, because this
> is getting absolutely stupid to have these decisions being made in
> each and every PCS - and have each PCS author implementing different
> decision making in their PCS driver.
> 
> The problem that gives is it makes phylink maintenance in hard,
> because it becomes impossible to predict what the effect of any
> change is.
> 
> It also means that plugging the same SFP module into different
> hardware will give different results (maybe it works, maybe it
> doesn't.)
> 
> So, what I would want to do is to move the decision about whether
> the PCS should enable in-band into the phylink core code instead
> of these random decisions being made in each PCS.
> 
> At that point, we can then make the decision about whether the
> ethtool autoneg bit should affect whether the PCS uses inband
> depending on whether the PCS is effectively the media facing
> entity, or whether there is a PHY attached - and if there is a PHY
> attached, ask the PHY whether it will be using in-band or not.
> 
> This also would give a way to ensure that all PCS adopt the same
> behaviour.
> 
> Does that sound a reasonable approach?

In general it sound reasonable. We may need more SFP qurik bits to
indicate presence of a PHY on SFP modules which do not expose that
PHY via i2c-mdio or otherwise let the host know about it's presence.
For my TP-LINK TL-SM410U 2500Base-T SFP this unfortunately seems to
be the case, and I assume it's actually like that for most
2500Base-T as well as xPON SFPs... (xPON SFPs are usually managed
via high-level protocols, even Web-UI is common there. They don't
tell you much about them via I2C, I suppose to get them to work in
as many SFP host devices as possible without any software changes).

FYI:
TP-LINK TL-SM410U 2500Base-T module:

sfp EE: 00000000: 03 04 07 00 00 00 00 00 00 40 00 01 1f 00 00 00  .........@......
sfp EE: 00000010: 00 00 00 00 54 50 2d 4c 49 4e 4b 20 20 20 20 20  ....TP-LINK     
sfp EE: 00000020: 20 20 20 20 00 30 b5 c2 54 4c 2d 53 4d 34 31 30      .0..TL-SM410
sfp EE: 00000030: 55 20 20 20 20 20 20 20 32 2e 30 20 00 00 00 1b  U       2.0 ....
sfp EE: 00000040: 00 08 01 00 80 ff ff ff 40 3d f0 0d c0 ff ff ff  ........@=......
sfp EE: 00000050: c8 39 7a 08 c0 ff ff ff 50 3d f0 0d c0 ff ff ff  .9z.....P=......
sfp sfp2: module TP-LINK          TL-SM410U        rev 2.0  sn 12260M4001782    dc 220622  


And this is the ATS SFP-GE-T 10/100/1000M copper module doing
rate-adaptation to 1000Base-X:

sfp sfp1: EEPROM extended structure checksum failure: 0xb0 != 0xaf
sfp EE: 00000000: 03 04 07 00 00 00 02 12 00 01 01 01 0c 00 03 00  ................
sfp EE: 00000010: 00 00 00 00 4f 45 4d 20 20 20 20 20 20 20 20 20  ....OEM         
sfp EE: 00000020: 20 20 20 20 00 00 90 65 53 46 50 2d 47 45 2d 54      ...eSFP-GE-T
sfp EE: 00000030: 20 20 20 20 00 00 00 00 43 20 20 20 00 00 00 f0      ....C   ....
sfp EE: 00000040: 00 12 00 00 32 31 30 37 31 30 41 30 30 31 32 37  ....210710A00127
sfp EE: 00000050: 33 39 00 00 32 31 30 37 31 30 20 20 60 00 01 af  39..210710  `...
sfp sfp1: module OEM              SFP-GE-T     rev C    sn  dc 

That one already needs quirks to even work at all as TX-FAULT is not
reported properly by the module, see

https://github.com/dangowrt/linux/commit/2c694bd494583f08858fabca97cfdc79de8ba089

> 
> Strangely, I already have some patches along those lines in my
> net-queue branch. See:
> 
> net: phylink: add helpers for decoding mode
> net: use phylink_mode_*() helpers
> net: phylink: split PCS in-band from inband mode
> 
> It's nowhere near finished though, it was just an idea back in
> 2021 when the problem of getting rid of differing PCS behaviours
> was on my mind.

I'll take a look and let you know.

For this series, I will post v13 without the two patches fixing
????Base-X modes tomorrow, waiting for other comments on the current
post of the series up to then.

