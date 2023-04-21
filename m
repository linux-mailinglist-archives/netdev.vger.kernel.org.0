Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C95A76EB203
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 21:04:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232769AbjDUTD6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 15:03:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231362AbjDUTD5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 15:03:57 -0400
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC60C1B7;
        Fri, 21 Apr 2023 12:03:55 -0700 (PDT)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.96)
        (envelope-from <daniel@makrotopia.org>)
        id 1ppw2m-0002mI-06;
        Fri, 21 Apr 2023 21:03:40 +0200
Date:   Fri, 21 Apr 2023 20:03:37 +0100
From:   Daniel Golle <daniel@makrotopia.org>
To:     =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Cc:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Russell King <linux@armlinux.org.uk>,
        Richard van Schagen <richard@routerhints.com>,
        Richard van Schagen <vschagen@cs.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        erkin.bozoglu@xeront.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: Re: [RFC PATCH net-next 08/22] net: dsa: mt7530: change
 p{5,6}_interface to p{5,6}_configured
Message-ID: <ZELeCYZ0_eHTKFF_@makrotopia.org>
References: <20230421143648.87889-1-arinc.unal@arinc9.com>
 <20230421143648.87889-9-arinc.unal@arinc9.com>
 <ZELH2RlYLPjJGx6Y@makrotopia.org>
 <810aa47b-7007-7d53-9a23-c2d17d43d8a8@arinc9.com>
 <f1c38c13-a1f6-93d8-90ae-4ea3f7e06dc2@arinc9.com>
 <235c80fc-3f1b-a9c9-6364-6f50ee45b21b@arinc9.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <235c80fc-3f1b-a9c9-6364-6f50ee45b21b@arinc9.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 21, 2023 at 09:25:39PM +0300, Arınç ÜNAL wrote:
> 
> 
> On 21.04.2023 21:20, Arınç ÜNAL wrote:
> > On 21.04.2023 21:17, Arınç ÜNAL wrote:
> > > On 21.04.2023 20:28, Daniel Golle wrote:
> > > > On Fri, Apr 21, 2023 at 05:36:34PM +0300, arinc9.unal@gmail.com wrote:
> > > > > From: Arınç ÜNAL <arinc.unal@arinc9.com>
> > > > > 
> > > > > The idea of p5_interface and p6_interface pointers is to prevent
> > > > > mt753x_mac_config() from running twice for MT7531, as it's
> > > > > already run with
> > > > > mt753x_cpu_port_enable() from mt7531_setup_common(), if the
> > > > > port is used as
> > > > > a CPU port.
> > > > > 
> > > > > Change p5_interface and p6_interface to p5_configured and
> > > > > p6_configured.
> > > > > Make them boolean.
> > > > > 
> > > > > Do not set them for any other reason.
> > > > > 
> > > > > The priv->p5_intf_sel check is useless as in this code path,
> > > > > it will always
> > > > > be P5_INTF_SEL_GMAC5.
> > > > > 
> > > > > There was also no need to set priv->p5_interface and
> > > > > priv->p6_interface to
> > > > > PHY_INTERFACE_MODE_NA on mt7530_setup() and mt7531_setup()
> > > > > as they would
> > > > > already be set to that when "priv" is allocated. The
> > > > > pointers were of the
> > > > > phy_interface_t enumeration type, and the first element of the enum is
> > > > > PHY_INTERFACE_MODE_NA. There was nothing in between that
> > > > > would change this
> > > > > beforehand.
> > > > > 
> > > > > Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> > > > > Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> > > > 
> > > > NACK. This assumes that a user port is configured exactly once.
> > > > However, interface mode may change because of mode-changing PHYs (e.g.
> > > > often using Cisco SGMII for 10M/100M/1000M but using 2500Base-X for
> > > > 2500M, ie. depending on actual link speed).
> > > > 
> > > > Also when using SFP modules (which can be hotplugged) the interface
> > > > mode may change after initially setting up the driver, e.g. when SFP
> > > > driver is loaded or a module is plugged or replaced.
> > > 
> > > I'm not sure I understand. pX_configured would be set to true only
> > > when the port is used as a CPU port. mt753x_mac_config() should run
> > > for user or DSA ports more than once, if needed.
> > 
> > Looking at this again, once pX_interface is true, the check will prevent
> > even user or DSA ports to be configured again. What about setting
> > pX_interface to false after mt753x_mac_config() is run?
> 
> On a third thought, pX_interface will never be true for the port if it's a
> user or DSA port so this should not be a problem at all.

I also followed the individual codepaths and conclude that you are
right. I've also tested this by now on several boards with MT753x,
incl. BPi-R3 and SerDes interface mode switching is anyway handled in
the PCS driver (I should have rembered that...)

Hence
Acked-by: Daniel Golle <daniel@makrotopia.org>

> 
> Arınç
