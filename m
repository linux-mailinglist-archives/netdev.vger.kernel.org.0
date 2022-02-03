Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD1F44A8A0D
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 18:30:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352860AbiBCRaq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 12:30:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352897AbiBCRao (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 12:30:44 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA419C061714
        for <netdev@vger.kernel.org>; Thu,  3 Feb 2022 09:30:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
        Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=LtXb/005KFgYr+A6KsWEWAEbArfOPZ1QJXbaqXZvAVk=; b=Ix/zwTEKFlJTaUXsCoM96bsRbw
        5L+6Wu/nrX7sjTqitAr+bLYnDnb8ieFdi3iycZuhEjhCwWTSNzTJPPSBYLMJ6zSRAL/Xq9s2Z36Rz
        ovzolJZwWN9vnfxDDdfP5IYbzGTeK65LmXg+0SepD4B6L5XDml4RLdwRV4Uy+Vtgw9EKlXVabcHe5
        igA+aWqr2EDGkO2JahUHl5DceGtD1TKtGERTajuCRGItR9ERVrolc4nAsgTnVrQqGJH72w6yQF3R1
        HAulxinNG8A3Q1FjNKJnipYRFXh5qsBoH6z0HRNjSAime6Iq/rYQj2+RT8cTY/a3OpVja2TMhRHWj
        1eE4mi3g==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:57018)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1nFfwI-0002y5-Ej; Thu, 03 Feb 2022 17:30:34 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1nFfwF-0004B7-Kj; Thu, 03 Feb 2022 17:30:31 +0000
Date:   Thu, 3 Feb 2022 17:30:31 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     DENG Qingfang <dqfext@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH RFC net-next 0/7] net: dsa: mt7530: updates for phylink
 changes
Message-ID: <YfwRN2ObqFbrw/fF@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This series is a partial conversion of the mt7530 DSA driver to the
modern phylink infrastructure. This driver has some exceptional cases
which prevent - at the moment - its full conversion (particularly with
the Autoneg bit) to using phylink_generic_validate().

What stands in the way is this if() condition in
mt753x_phylink_validate():

	if (state->interface != PHY_INTERFACE_MODE_TRGMII ||
	    !phy_interface_mode_is_8023z(state->interface)) {

reduces to being always true. I highlight this here for the attention
of the driver maintainers.

Patch 1 populates the supported_interfaces for each port

Patch 2 removes the interface checks that become unnecessary as a result
of patch 1.

Patch 3 removes use of phylink_helper_basex_speed() which is no longer
required by phylink.

Patch 4 becomes possible after patch 3, only indicating the ethtool
modes that can be supported with a particular interface mode - this
involves removing some modes and adding others as per phylink
documentation.

Patch 5 continues patch 4, as RGMII can support 1000base-X ethtool link
mode with an appropriate external PHY.

Patch 6 switches the driver to use phylink_get_linkmodes(), which moves
the driver as close as we can to phylink_generic_validate() due to the
Autoneg bit issue mentioned above.

Patch 7 marks the driver as non-legacy.

 drivers/net/dsa/mt7530.c | 166 ++++++++++++++++-------------------------------
 drivers/net/dsa/mt7530.h |   5 +-
 2 files changed, 58 insertions(+), 113 deletions(-)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
