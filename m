Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 934AA6B0696
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 13:05:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231148AbjCHMFk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 07:05:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229774AbjCHMFj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 07:05:39 -0500
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61CECB862A;
        Wed,  8 Mar 2023 04:05:32 -0800 (PST)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.96)
        (envelope-from <daniel@makrotopia.org>)
        id 1pZsXr-00028P-0Q;
        Wed, 08 Mar 2023 13:05:23 +0100
Date:   Wed, 8 Mar 2023 12:05:19 +0000
From:   Daniel Golle <daniel@makrotopia.org>
To:     Frank Wunderlich <frank-w@public-files.de>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
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
        Alexander Couzens <lynxis@fe80.eu>
Subject: Re: [PATCH net-next v12 09/18] net: ethernet: mtk_eth_soc: Fix link
 status for none-SGMII modes
Message-ID: <ZAh5/+erE6yYYl7B@makrotopia.org>
References: <cover.1678201958.git.daniel@makrotopia.org>
 <1590fb0e69f6243ac6a961b16bf7ae7534f46949.1678201958.git.daniel@makrotopia.org>
 <ZAhzt5eIZiJUyVm7@shell.armlinux.org.uk>
 <B69026D7-E770-4168-B1CA-54E34D52C961@public-files.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <B69026D7-E770-4168-B1CA-54E34D52C961@public-files.de>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 08, 2023 at 12:44:57PM +0100, Frank Wunderlich wrote:
> Am 8. März 2023 12:38:31 MEZ schrieb "Russell King (Oracle)" <linux@armlinux.org.uk>:
> >On Tue, Mar 07, 2023 at 03:54:11PM +0000, Daniel Golle wrote:
> >> Link partner advertised link modes are not reported by the SerDes
> >> hardware if not operating in SGMII mode. Hence we cannot use
> >> phylink_mii_c22_pcs_decode_state() in this case.
> >> Implement reporting link and an_complete only and use speed according to
> >> the interface mode.
> >> 
> >> Fixes: 14a44ab0330d ("net: mtk_eth_soc: partially convert to phylink_pcs")
> >> Signed-off-by: Daniel Golle <daniel@makrotopia.org>
> >
> >This has been proven to work by Frank Wunderlich last October, so by
> >making this change, you will be regressing his setup.
> 
> Hi
> 
> My tests were done with 1 kind of 1g fibre sfp as i only have these atm...have ordered some 2g5 rj54 ones,but don't have them yet. I'm not sure if they are working with/without sgmii (1000base-X) and if they have builtin phy.
> 
> Daniel have a lot more of different SFPs and some (especially 2g5) were not working after our pcs change.

Exactly. 1 GBit/s SFPs with built-in PHY and using SGMII are working
fine before and after conversion to phylink_pcs. 1000Base-X and
2500Base-X PHYs and SFPs were broken after this.

The patch about (and the other one you already NACK'ed) fixes those
codepaths which were simply not used in Frank's setup.

> 
> >What are you testing against? Have you proven independently that the
> >link partner is indeed sending a valid advertisement for the LPA
> >register to be filled in?
> >

I have a ballpark of different SFPs and MediaTek boards with different
PHYs here and tried all of them.

I have no way to tell if the SFPs and PHYs which stopped working after
the phylink_pcs conversion are sending valid advertisement. The only
other boards with SFP slots I got here are RealTek-based switches, and
all I can say is that on an RTL8380 based 1G switch both, the SFP
modules containing a PHY and operating in SGMII mode as well as the
ones without a PHY exposed via i2c-mdio and operating in 1000Base-X
mode are working fine with that switch, with both, stock firmware and
OpenWrt running on it.

However, even should they not send valid advertisement, they are very
common parts and they were working before and not after the change to
phylink_pcs, for the reasons mentioned in the description of this
patch.
