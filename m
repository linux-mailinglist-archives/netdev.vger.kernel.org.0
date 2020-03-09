Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D25E17DB21
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 09:37:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726739AbgCIIhQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 04:37:16 -0400
Received: from smtprelay-out1.synopsys.com ([149.117.87.133]:42420 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726215AbgCIIgp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 04:36:45 -0400
Received: from mailhost.synopsys.com (mdc-mailhost2.synopsys.com [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id F11C2C04C0;
        Mon,  9 Mar 2020 08:36:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1583743004; bh=nNW7ATs8+GuGeb3XY+MZ9vqqRxlVeew7FQjk122/a3E=;
        h=From:To:Cc:Subject:Date:From;
        b=ZcicXufR4XTCBX1R49tN9rvomFqt9gJOHipcnE6Ebh37+J79vyF5cZX7VHlzDm7Hl
         tuuHmZbca9mllw360dlR2UgwNMtNVuSDfKJI8TUgzUNveltSy3Az250ONW4p1SWVCo
         V3qWxpYjhlG8PL5YVdsa+AWYQcQ7rf4Cj9jGsElUJPvdh2IlVs4IoGUyrbaUslnxPe
         Fy+Ee6fPi+hvm/35w5hKcq2lYY8mmwAS5FUxk3SgTPtgPPj7wXDcq9ffkDlsFUVTc6
         X3c4jVSzPL1TdQjjYUrjPapoIxH+A/9ZR6a6dRCA9+5stxGSuOTYDZmeQ5wG5WNIp/
         eax4z/zWeagug==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id C741CA005C;
        Mon,  9 Mar 2020 08:36:38 +0000 (UTC)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     netdev@vger.kernel.org
Cc:     Joao Pinto <Joao.Pinto@synopsys.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 0/8] net: Add support for Synopsys DesignWare XPCS
Date:   Mon,  9 Mar 2020 09:36:19 +0100
Message-Id: <cover.1583742615.git.Jose.Abreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds support for Synopsys DesignWare XPCS in net subsystem and
integrates it into stmmac.

At 1/8, we start by removing the limitation of stmmac selftests that needed
a PHY to pass all the tests.

Then at 2/8 we use some helpers in stmmac so that some code can be
simplified.

At 3/8, we fallback to dev_fwnode() so that PCI based setups wich may
not have CONFIG_OF can still use FW node.

At 4/8, we adapt stmmac to the new PHYLINK changes as suggested by Russell
King.

We proceed by doing changes in PHYLINK in order to support XPCS: At 5/8 we
add some missing speeds that USXGMII supports and at 6/8 we check if
Autoneg is supported after initial parameters are validated.

Support for XPCS is finally introduced at 7/8, along with the usage of it
in stmmac driver at 8/8.

---
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc: Alexandre Torgue <alexandre.torgue@st.com>
Cc: Jose Abreu <joabreu@synopsys.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: Heiner Kallweit <hkallweit1@gmail.com>
Cc: netdev@vger.kernel.org
Cc: linux-stm32@st-md-mailman.stormreply.com
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---

Jose Abreu (8):
  net: stmmac: selftests: Do not fail if PHY is not attached
  net: stmmac: Switch to linkmode_and()/linkmode_andnot()
  net: stmmac: Fallback to dev_fwnode() if needed
  net: stmmac: Use resolved link config in mac_link_up()
  net: phylink: Add missing Backplane speeds
  net: phylink: Test if MAC/PCS support Autoneg
  net: phy: Add Synopsys DesignWare XPCS MDIO module
  net: stmmac: Integrate it with DesignWare XPCS

 MAINTAINERS                                        |   7 +
 drivers/net/ethernet/stmicro/stmmac/Kconfig        |   1 +
 drivers/net/ethernet/stmicro/stmmac/common.h       |   3 +
 drivers/net/ethernet/stmicro/stmmac/hwif.h         |  12 +
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |  96 ++--
 drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c  |  27 +
 .../net/ethernet/stmicro/stmmac/stmmac_selftests.c |   2 +-
 drivers/net/phy/Kconfig                            |   6 +
 drivers/net/phy/Makefile                           |   1 +
 drivers/net/phy/mdio-xpcs.c                        | 612 +++++++++++++++++++++
 drivers/net/phy/phylink.c                          |   5 +
 include/linux/mdio-xpcs.h                          |  41 ++
 include/linux/stmmac.h                             |   1 +
 13 files changed, 771 insertions(+), 43 deletions(-)
 create mode 100644 drivers/net/phy/mdio-xpcs.c
 create mode 100644 include/linux/mdio-xpcs.h

-- 
2.7.4

