Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F252D6B0C41
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 16:11:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230488AbjCHPLO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 10:11:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230240AbjCHPLN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 10:11:13 -0500
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C269BAD1E;
        Wed,  8 Mar 2023 07:10:48 -0800 (PST)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.96)
        (envelope-from <daniel@makrotopia.org>)
        id 1pZvR8-0003fl-2r;
        Wed, 08 Mar 2023 16:10:39 +0100
Date:   Wed, 8 Mar 2023 15:08:55 +0000
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
Message-ID: <ZAik+I1Ei+grJdUQ@makrotopia.org>
References: <fd5c7ea79a7f84caac7d0b64b39fe5c4043edfa8.1678201958.git.daniel@makrotopia.org>
 <ZAhzDDjZ8+gxyo3V@shell.armlinux.org.uk>
 <ZAh7hA4JuJm1b2M6@makrotopia.org>
 <ZAiCh8wkdTBT+6Id@shell.armlinux.org.uk>
 <ZAiFOTRQI36nGo+w@makrotopia.org>
 <ZAiJqvzcUob2Aafq@shell.armlinux.org.uk>
 <20230308134642.cdxqw4lxtlgfsl4g@skbuf>
 <ZAiXvNT8EzHTmFPh@shell.armlinux.org.uk>
 <ZAiciK5fElvLXYQ9@makrotopia.org>
 <ZAijM91F18lWC80+@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZAijM91F18lWC80+@shell.armlinux.org.uk>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 08, 2023 at 03:01:07PM +0000, Russell King (Oracle) wrote:
> On Wed, Mar 08, 2023 at 02:32:40PM +0000, Daniel Golle wrote:
> > In general it sound reasonable. We may need more SFP qurik bits to
> > indicate presence of a PHY on SFP modules which do not expose that
> > PHY via i2c-mdio or otherwise let the host know about it's presence.
> 
> That's a whole load of fun - some modules where the PHY is inaccessible
> will be using 1000base-X, others will be using SGMII. So yes, its
> likely that we may need quirks for these. We don't have quirks yet
> because you're the first to suggest there's a problem.
> 
> > For my TP-LINK TL-SM410U 2500Base-T SFP this unfortunately seems to
> > be the case, and I assume it's actually like that for most
> > 2500Base-T as well as xPON SFPs... (xPON SFPs are usually managed
> > via high-level protocols, even Web-UI is common there. They don't
> > tell you much about them via I2C, I suppose to get them to work in
> > as many SFP host devices as possible without any software changes).
> 
> xPON SFPs are a whole different ball game. For some, they auto-detect
> while booting and try 2500base-X or 1000base-X to see which will sync
> and if not they try the other. Other xPON SFPs run their host interface
> at a speed determined by the configuration set by the remote end. Other
> xPON SFPs may do something entirely different.
> 
> In many cases, their EEPROM is a full of errors - such as advertising
> that they're 1.2 or 1.3 Gbd while operating in 2500base-X mode.
> 
> They do weird stuff with their status pins as well, for example, some
> use the RX_LOS pin as a uart - which is a problem if it's e.g. tied
> from the cage to a switch that uses the pin to gate the link-up
> indication without any software control of that!
> 
> With xPON SFPs, it's just a total minefield, which lots of SFF MSA
> violations all over the place. They're essentially a law to themselves
> (this is exactly why we have the quirks infrastructure.)
> 
> > FYI:
> > TP-LINK TL-SM410U 2500Base-T module:
> > 
> > sfp EE: 00000000: 03 04 07 00 00 00 00 00 00 40 00 01 1f 00 00 00  .........@......
> > sfp EE: 00000010: 00 00 00 00 54 50 2d 4c 49 4e 4b 20 20 20 20 20  ....TP-LINK     
> > sfp EE: 00000020: 20 20 20 20 00 30 b5 c2 54 4c 2d 53 4d 34 31 30      .0..TL-SM410
> > sfp EE: 00000030: 55 20 20 20 20 20 20 20 32 2e 30 20 00 00 00 1b  U       2.0 ....
> > sfp EE: 00000040: 00 08 01 00 80 ff ff ff 40 3d f0 0d c0 ff ff ff  ........@=......
> > sfp EE: 00000050: c8 39 7a 08 c0 ff ff ff 50 3d f0 0d c0 ff ff ff  .9z.....P=......
> > sfp sfp2: module TP-LINK          TL-SM410U        rev 2.0  sn 12260M4001782    dc 220622  
> 
> I'm guessing this is a module with a checksum problem...

No, the checksum of the TL-SM410U is correct. I have patched the kernel
to always dump the EEPROM, so I can share it with you.

> 
> > And this is the ATS SFP-GE-T 10/100/1000M copper module doing
> > rate-adaptation to 1000Base-X:
> > 
> > sfp sfp1: EEPROM extended structure checksum failure: 0xb0 != 0xaf
> 
> Given how close that is, it looks like they used the wrong algorithm.
> 
> > sfp EE: 00000000: 03 04 07 00 00 00 02 12 00 01 01 01 0c 00 03 00  ................
> > sfp EE: 00000010: 00 00 00 00 4f 45 4d 20 20 20 20 20 20 20 20 20  ....OEM         
> > sfp EE: 00000020: 20 20 20 20 00 00 90 65 53 46 50 2d 47 45 2d 54      ...eSFP-GE-T
> > sfp EE: 00000030: 20 20 20 20 00 00 00 00 43 20 20 20 00 00 00 f0      ....C   ....
> > sfp EE: 00000040: 00 12 00 00 32 31 30 37 31 30 41 30 30 31 32 37  ....210710A00127
> > sfp EE: 00000050: 33 39 00 00 32 31 30 37 31 30 20 20 60 00 01 af  39..210710  `...
> > sfp sfp1: module OEM              SFP-GE-T     rev C    sn  dc 
> 
> Welcome to the wonderful world of horribly broken SFPs.
> 
> Do we know what form of rate adaption this module needs on the
> transmit path? Does it require the host to pace itself to the media
> speed (which I suspect will be unreadable if the PHY isn't accessible)
> or will it send pause frames?
> 
> It would be nice to add these to my database - please send me the
> output of ethtool -m $iface raw on > foo.bin for each module.
> 
> > That one already needs quirks to even work at all as TX-FAULT is not
> > reported properly by the module, see
> > 
> > https://github.com/dangowrt/linux/commit/2c694bd494583f08858fabca97cfdc79de8ba089
> 
> I'm guessing that's not on a kernel version that has:
> 
> 73472c830eae net: sfp: add support for HALNy GPON SFP
> 5029be761161 net: sfp: move Huawei MA5671A fixup
> 275416754e9a net: sfp: move Alcatel Lucent 3FE46541AA fixup
> 23571c7b9643 net: sfp: move quirk handling into sfp.c
> 8475c4b70b04 net: sfp: re-implement soft state polling setup
> 
> which reworks how we deal with the soft/hard state signals.
> 
> I think the problem space is growing, and I fear that if we try to
> address all these issues in one go, we're going to end up with way
> too much to deal with in one go (which means poor reviews etc.)
> 
> Can we try to concentrate on fixing one problem at a time, rather
> than throwing a whole load of problems into the mix?

Ok. I'll just repost tomorrow without the ????Base-X AN realted patches.

> 
> Thanks.
> 
> -- 
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
