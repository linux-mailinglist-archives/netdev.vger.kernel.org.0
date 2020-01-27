Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 597AF14A2BC
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 12:16:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730302AbgA0LPy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 06:15:54 -0500
Received: from sv2-smtprelay2.synopsys.com ([149.117.73.133]:44530 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729463AbgA0LPw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 06:15:52 -0500
Received: from mailhost.synopsys.com (mdc-mailhost1.synopsys.com [10.225.0.209])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 2E0D540693;
        Mon, 27 Jan 2020 11:09:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1580123375; bh=IjWRnmaSPsNrSVZrLeGmi4hFsW9Xwf+qeBSJQHYUGvA=;
        h=From:To:Cc:Subject:Date:From;
        b=fX7CEUyoF7CatZ79YNwGoqdE2qM/bUjWcAeah10Eq4KX5LVkmopVInSGhyD73fC9r
         WYe9MBlnrasoeabTiXz1wZ5isM1aR0mdZ6qS7gkgitdiwi4qdQw1cTO0UCiZian0KI
         eWJaePzX1r7yxtg9YoAkko5hX1+7COlItx9lU5mNR2id/MOotuaFQZdUGYyZrsQUu5
         ySEMPtFJNsX5wlGt4WFeF/kvZjMtBr2k1N1rC3j63j+i2THjBU1qC+7Am4ovQ+7pjm
         rXsnMDPGm+j76Mbi4HKxps7pfYM2kFleH+k80qvdSrgHHVSnh+8trNJUDuK480AJqw
         9ukmxI/h70sow==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id 2D4B0A005C;
        Mon, 27 Jan 2020 11:09:23 +0000 (UTC)
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
Subject: [RFC net-next 0/8] net: Add support for Synopsys DesignWare XPCS
Date:   Mon, 27 Jan 2020 12:09:05 +0100
Message-Id: <cover.1580122909.git.Jose.Abreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds support for Synopsys DesignWare XPCS in net subsystem and
integrates it into stmmac.

At 1/8, we start by removing the limitation of stmmac selftests that needed
a PHY to pass all the tests.

Then at 2/8 and 3/8 we add and use some new helpers in PHYLINK so that we
can simplify some code in stmmac and possible other drivers.

At 4/8, we fallback to dev_fwnode() so that PCI based setups wich may
not have CONFIG_OF can still use FW node.

We proceed by doing changes in PHYLINK in order to support XPCS: At 5/8 we
add some missing speeds that USXGMII supports and at 6/8 we do the most
important change to support XPCS that allows to configure MAC and PCS
withouht having any PHY neither SFP attached.

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
  net: phylink: Add phylink_and and phylink_andnot Helpers
  net: stmmac: Switch to phylink_and()/phylink_andnot()
  net: stmmac: Fallback to dev_fwnode() if needed
  net: phylink: Add missing Backplane speeds
  net: phylink: Configure MAC/PCS when link is up without PHY
  net: phy: Add Synopsys DesignWare XPCS MDIO module
  net: stmmac: Integrate it with DesignWare XPCS

 MAINTAINERS                                        |   7 +
 drivers/net/ethernet/stmicro/stmmac/Kconfig        |   1 +
 drivers/net/ethernet/stmicro/stmmac/common.h       |   3 +
 drivers/net/ethernet/stmicro/stmmac/hwif.h         |  12 +
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |  32 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c  |  27 +
 .../net/ethernet/stmicro/stmmac/stmmac_selftests.c |   2 +-
 drivers/net/phy/Kconfig                            |   6 +
 drivers/net/phy/Makefile                           |   1 +
 drivers/net/phy/mdio-xpcs.c                        | 567 +++++++++++++++++++++
 drivers/net/phy/phylink.c                          |  16 +-
 include/linux/mdio-xpcs.h                          |  41 ++
 include/linux/phylink.h                            |   4 +
 include/linux/stmmac.h                             |   1 +
 14 files changed, 708 insertions(+), 12 deletions(-)
 create mode 100644 drivers/net/phy/mdio-xpcs.c
 create mode 100644 include/linux/mdio-xpcs.h

-- 
2.7.4

