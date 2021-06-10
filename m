Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 950243A32D4
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 20:15:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230502AbhFJSR1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 14:17:27 -0400
Received: from mail-ed1-f42.google.com ([209.85.208.42]:43779 "EHLO
        mail-ed1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230336AbhFJSR0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 14:17:26 -0400
Received: by mail-ed1-f42.google.com with SMTP id s6so34116321edu.10
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 11:15:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JM2dA2MHoGWhyaFJ55n7dKKxtR6PiJI5pXYsdE6MYYw=;
        b=d5hiP383zAu6nP014LFbpcwp4uGdQJOscnRjBXFqcFMBWCTJge7Zf2XuDmcwCfZ9d1
         OWgmXSq5MmubeaFtd3Aw2jHc6ul2blAy+s5vkY8aia0Avd/pBqEENAisuI15a/ehzc/9
         zQgL2ftXVETluT6j5YPqmHKI0pGejm+KK1rha+PwAdJv+vdlLnIbqiUfhwOzn2g7PAuO
         aVhCqcjF/aXoKI1UuRgI3ELerBoayg1CQVrbjjc0KicO2WaDzKyHHxDpEG8EqvhPJZaz
         oEmSVNQiAvmFuFmomtCVPWLFWtze+sl0NG2IOIc8paDV3wRRV1JkZ2gdFqD6SLckO9L8
         CSDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JM2dA2MHoGWhyaFJ55n7dKKxtR6PiJI5pXYsdE6MYYw=;
        b=XXRnwNjer/azxp30hlCe3BVWto0USAcJ0VMUG5jYgH226zOoyoMp0zCeonujxxyeHs
         Loz4jN/V8BSM4Ip0U5nHKDayxsSMl0gyDrBnA9H36ANSBip8nVyQghoz5bnNu7c9f9/N
         kwh88xTl2R2k1juvx2HpJz2bTgB98Q3/RBr4Yck/AOO5TFI3LZ8uJbaxAzUFP71usSJk
         0m1CpTlj7vE+l+oEQ3VIwbI8PjcFNS2j+k6GMHAVQSXAwAEzoddmBhpDywY+k0/Gg6Vj
         4HiV26hn+kJC/7Ge+E1rNxbWWspnK+fIGRRzX62Rn2zBwY/ceG0NZI/VzQfv+Sv5qUVu
         d25Q==
X-Gm-Message-State: AOAM532bdgJ+xUmoMmrhqCvyvAo8WA+T62epa9GhA2YCPYFk0Y/Gqnls
        WmEZWfFvQM/rcMOjsdGgF8w=
X-Google-Smtp-Source: ABdhPJw5nb8yivMGREJPLik9g70fPumLmdv/bwyZ9cDUFBHh9cRM9CG4WPROoF8gPRoUAW+Pj7uvbg==
X-Received: by 2002:aa7:c4d0:: with SMTP id p16mr830088edr.150.1623348859900;
        Thu, 10 Jun 2021 11:14:19 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id dh18sm1705660edb.92.2021.06.10.11.14.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 11:14:18 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Wong Vee Khee <vee.khee.wong@linux.intel.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v2 net-next 00/13] Port the SJA1105 DSA driver to XPCS
Date:   Thu, 10 Jun 2021 21:13:57 +0300
Message-Id: <20210610181410.1886658-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

As requested when adding support for the NXP SJA1110, the SJA1105 driver
could make use of the common XPCS driver, to eliminate some hardware
specific code duplication.

This series modifies the XPCS driver so that it can accommodate the XPCS
instantiation from NXP switches, and the SJA1105 driver so it can expose
what the XPCS driver expects.

Tested on NXP SJA1105S and SJA1110A.

Changes in v2:
- fix module build (pcs-xpcs-nxp.c is not a different module so this
  means that we need to change the name of pcs-xpcs.ko to pcs_xpcs.ko).
- delete sja1105_sgmii.h
- just check for priv->pcs[port] instead of checking the PHY interface
  mode each time.
- add the 2500base-x check in one place where it was missing (before
  mdio_device_create)
- remove it from a few places where it is no longer necessary now that
  we check more generically for the presence of priv->xpcs[port]

Vladimir Oltean (13):
  net: pcs: xpcs: rename mdio_xpcs_args to dw_xpcs
  net: stmmac: reverse Christmas tree notation in stmmac_xpcs_setup
  net: stmmac: reduce indentation when calling stmmac_xpcs_setup
  net: pcs: xpcs: move register bit descriptions to a header file
  net: pcs: xpcs: add support for sgmii with no inband AN
  net: pcs: xpcs: also ignore phy id if it's all ones
  net: pcs: xpcs: add support for NXP SJA1105
  net: pcs: xpcs: add support for NXP SJA1110
  net: pcs: xpcs: export xpcs_do_config and xpcs_link_up
  net: dsa: sja1105: migrate to xpcs for SGMII
  net: dsa: sja1105: register the PCS MDIO bus for SJA1110
  net: dsa: sja1105: SGMII and 2500base-x on the SJA1110 are 'special'
  net: dsa: sja1105: plug in support for 2500base-x

 MAINTAINERS                                   |   2 +
 drivers/net/dsa/sja1105/Kconfig               |   1 +
 drivers/net/dsa/sja1105/sja1105.h             |   9 +
 drivers/net/dsa/sja1105/sja1105_main.c        | 186 +++----------
 drivers/net/dsa/sja1105/sja1105_mdio.c        | 255 +++++++++++++++++
 drivers/net/dsa/sja1105/sja1105_sgmii.h       |  53 ----
 drivers/net/dsa/sja1105/sja1105_spi.c         |  17 ++
 drivers/net/ethernet/stmicro/stmmac/common.h  |   2 +-
 .../net/ethernet/stmicro/stmmac/stmmac_main.c |  10 +-
 .../net/ethernet/stmicro/stmmac/stmmac_mdio.c |   6 +-
 drivers/net/pcs/Makefile                      |   4 +-
 drivers/net/pcs/pcs-xpcs-nxp.c                | 185 ++++++++++++
 drivers/net/pcs/pcs-xpcs.c                    | 263 +++++++++---------
 drivers/net/pcs/pcs-xpcs.h                    | 115 ++++++++
 include/linux/pcs/pcs-xpcs.h                  |  21 +-
 15 files changed, 772 insertions(+), 357 deletions(-)
 delete mode 100644 drivers/net/dsa/sja1105/sja1105_sgmii.h
 create mode 100644 drivers/net/pcs/pcs-xpcs-nxp.c
 create mode 100644 drivers/net/pcs/pcs-xpcs.h

-- 
2.25.1

