Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF6C94A8526
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 14:29:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350809AbiBCN3u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 08:29:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349788AbiBCN3t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 08:29:49 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09244C061714
        for <netdev@vger.kernel.org>; Thu,  3 Feb 2022 05:29:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Transfer-Encoding:
        Content-Type:MIME-Version:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Wwu9wh6cswDTi5+RWQfmQBzhzGox2bzk0X69mB58n30=; b=r97olwMF5xaSmMFA4ukwAHKjzk
        J8nwsG5NGYFJgkuHKs2zLvNRvSqBI4knUeaoRYrp7y3KGRZ/vJdyJ2Wx1GnEJgtzn7hTwpw7NPhot
        rpGB59TOp6YeeD1YOUIWwRiDrKadQThn2CdnL4lzGNNLTaxssexkRs0s1Edhv+pygruiiprRcjKIu
        woLmSmpsK9lz8bhbsUkJWoYHn+0K3hN8bcwSaqeIcRlQ8ZjA7TjGzRAMR/BTiXhy//YW0D2l6BeIc
        DTmLfOQcn+RoyTO6QQGXO7NSoqv10phfUnaehD+p1wuklK3TMx5/ZlPTk5Uwnjdl+Sf2Szrl/bu76
        RJ4OFUVQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:57010)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1nFcBC-0002fe-DX; Thu, 03 Feb 2022 13:29:42 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1nFcBA-00042N-In; Thu, 03 Feb 2022 13:29:40 +0000
Date:   Thu, 3 Feb 2022 13:29:40 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next 0/4] net: dsa: mv88e6xxx: convert to
 phylink_generic_validate()
Message-ID: <YfvYxNAkOZ6aNxql@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The overall objective of this series is to convert the mv88e6xxx DSA
driver to use phylink_generic_validate().

Patch 1 adds a new helper mv88e6352_g2_scratch_port_has_serdes() which
indicates whether an 88e6352 port has a serdes associated with it. This
is necessary as ports 4 and 5 will normally be in automedia mode, where
the CMODE field in the port status register will change e.g. between 15
(internal PHY) and 9 (1000base-X) depending on whether the serdes has
link.

The existing code caches the cmode field, and depending whether the
serdes has link at probe time, determines whether we allow things such
as the serdes statistics to be accessed. This means if the link isn't
up at probe time, the serdes is essentially unavailable.

Patch 1 addresses this by reading the pin configuration to find out
whether the serdes is attached to port 4 or port 5.

Patch 2 is a joint effort between myself and Marek Behún, adding the
supported interfaces and MAC capabilities to all mv88e6xxx supported
switch devices. This is slightly more restrictive than the original
code as we didn't used to care too much about the interface mode, but
with this we do - which is why we must know if there's a serdes
associated now.

Patch 3 switches mv88e6xxx to use the generic validation by removing
the initialisation of the phylink_validate pointer in the dsa_ops
struct.

Patch 4 updates the statistics code to use the new helper in patch 1,
so the serdes statistics are available even if the link was down at
driver probe time.

 drivers/net/dsa/mv88e6xxx/chip.c            | 350 ++++++++++++++++++----------
 drivers/net/dsa/mv88e6xxx/chip.h            |   5 +-
 drivers/net/dsa/mv88e6xxx/global2.h         |   3 +
 drivers/net/dsa/mv88e6xxx/global2_scratch.c |  28 +++
 drivers/net/dsa/mv88e6xxx/port.h            |   5 +
 drivers/net/dsa/mv88e6xxx/serdes.c          |  43 ++--
 6 files changed, 294 insertions(+), 140 deletions(-)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
