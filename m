Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A88D04F5F21
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 15:29:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231425AbiDFNOh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 09:14:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233505AbiDFNMq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 09:12:46 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DCC15F78BC
        for <netdev@vger.kernel.org>; Wed,  6 Apr 2022 02:49:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
        Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=HAZAkxGQ/zOdZiDQf8oSglIAyCEr2REmP3A7bnFL5Lw=; b=sO7m6/msfb1eq0aFrkmsU+sEzt
        eKwlIuQhzyzSjVUe9pFqfastnzDv2E9xwjD6RITJvC7ywINEjTfpQM7VXifEbgwJeDSVFRrQXH4wA
        J5yHvS8ON7R4zuJ3g8ZgJeFBNiJrmVHArv7ns3C3OTUpwIZoHFgyxUBCtBEcEPTIoRmm/+DGqKC4f
        EQw1SgrlGIgnNqwW+glElXiUY/GdNv8kiJ467YrBAWLSTv6LLVQQt/cidU1cFZiBEZdI0B3uVQBhz
        rh+Ix+ICyqU9UBSOF7zOrUaGy97b/hx8kYKLuDQNXrqonGfX3yI3t6n60w58uQVxKY/w+YqOVfDJI
        nrkqCFZw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:58144)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1nc2Hv-0002T9-Hc; Wed, 06 Apr 2022 10:49:19 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1nc2Hs-00052x-6g; Wed, 06 Apr 2022 10:49:16 +0100
Date:   Wed, 6 Apr 2022 10:49:16 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH net-next 0/9] net: dsa: mt7530: updates for phylink changes
Message-ID: <Yk1iHCy4fqvxsvu0@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This revised series is a partial conversion of the mt7530 DSA driver to
the modern phylink infrastructure. This driver has some exceptional
cases which prevent - at the moment - its full conversion (particularly
with the Autoneg bit) to using phylink_generic_validate().

Patch 1 fixes the incorrect test highlighted in the first RFC series.

Patch 2 fixes the incorrect assumption that RGMII is unable to support
1000BASE-X.

Patch 3 populates the supported_interfaces for each port

Patch 4 removes the interface checks that become unnecessary as a result
of patch 3.

Patch 5 removes use of phylink_helper_basex_speed() which is no longer
required by phylink.

Patch 6 becomes possible after patch 5, only indicating the ethtool
modes that can be supported with a particular interface mode - this
involves removing some modes and adding others as per phylink
documentation.

Patch 7 switches the driver to use phylink_get_linkmodes(), which moves
the driver as close as we can to phylink_generic_validate() due to the
Autoneg bit issue mentioned above.

Patch 8 converts the driver to the phylink pcs support, removing a bunch
of driver private indirected methods. We include TRGMII as a PCS even
though strictly TRGMII does not have a PCS. This is convenient to allow
the change in patch 9 to be made.

Patch 9 moves the special autoneg handling to the PCS validate method,
which means we can convert the MAC side to the generic validator.

Patch 10 marks the driver as non-legacy.

The series was posted on 23 February, and a ping sent on 3 March, but
no feedback has been received. The previous posting also received no
feedback on the actual patches either.

 drivers/net/dsa/mt7530.c | 330 +++++++++++++++++++++--------------------------
 drivers/net/dsa/mt7530.h |  26 ++--
 2 files changed, 159 insertions(+), 197 deletions(-)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
