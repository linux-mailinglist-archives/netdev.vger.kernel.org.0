Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C18D344EB
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 12:59:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727324AbfFDK6d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 06:58:33 -0400
Received: from mga07.intel.com ([134.134.136.100]:62569 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726877AbfFDK6d (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Jun 2019 06:58:33 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Jun 2019 03:58:32 -0700
X-ExtLoop1: 1
Received: from wvoon-ilbpg2.png.intel.com ([10.88.227.88])
  by orsmga008.jf.intel.com with ESMTP; 04 Jun 2019 03:58:29 -0700
From:   Voon Weifeng <weifeng.voon@intel.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jose Abreu <joabreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        biao huang <biao.huang@mediatek.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Kweh Hock Leong <hock.leong.kweh@intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>
Subject: [PATCH net-next v6 0/5] net: stmmac: enable EHL SGMII
Date:   Wed,  5 Jun 2019 02:58:51 +0800
Message-Id: <1559674736-2190-1-git-send-email-weifeng.voon@intel.com>
X-Mailer: git-send-email 1.9.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch-set is to enable Ethernet controller
(DW Ethernet QoS and DW Ethernet PCS) with SGMII interface in Elkhart Lake.
The DW Ethernet PCS is the Physical Coding Sublayer that is between Ethernet
MAC and PHY and uses MDIO Clause-45 as Communication.

Selttests results:
root@intel-corei7-64:~# ethtool -t eth0
The test result is PASS
The test extra info:
 1. MAC Loopback                 0
 2. PHY Loopback                 -95
 3. MMC Counters                 0
 4. EEE                          -95
 5. Hash Filter MC               0
 6. Perfect Filter UC            0
 7. MC Filter                    0
 8. UC Filter                    0
 9. Flow Control                 0

Kweh Hock Leong (1):
  net: stmmac: enable clause 45 mdio support

Ong Boon Leong (3):
  net: stmmac: introducing support for DWC xPCS logics
  net: stmmac: add xpcs function hooks into main driver and ethtool
  net: stmmac: add xPCS functions for device with DWMACv5.1

Voon Weifeng (1):
  net: stmmac: add EHL SGMII 1Gbps PCI info and PCI ID

 drivers/net/ethernet/stmicro/stmmac/Makefile       |   2 +-
 drivers/net/ethernet/stmicro/stmmac/common.h       |   1 +
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c  |  34 ++++
 drivers/net/ethernet/stmicro/stmmac/dwxpcs.c       | 208 +++++++++++++++++++++
 drivers/net/ethernet/stmicro/stmmac/dwxpcs.h       |  51 +++++
 drivers/net/ethernet/stmicro/stmmac/hwif.c         |  42 ++++-
 drivers/net/ethernet/stmicro/stmmac/hwif.h         |  21 +++
 drivers/net/ethernet/stmicro/stmmac/stmmac.h       |   2 +
 .../net/ethernet/stmicro/stmmac/stmmac_ethtool.c   |  50 +++--
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  | 139 ++++++++++----
 drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c  |  40 +++-
 drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c   | 111 +++++++++++
 include/linux/phy.h                                |   2 +
 include/linux/stmmac.h                             |   3 +
 14 files changed, 648 insertions(+), 58 deletions(-)
 create mode 100644 drivers/net/ethernet/stmicro/stmmac/dwxpcs.c
 create mode 100644 drivers/net/ethernet/stmicro/stmmac/dwxpcs.h

-- 
Changelog v6:
*Added missing selftests entry in dwmac510_xpcs_ops
*Applied more reversed christmas tree
Changelog v5:
*Cosmetic touch up
*Change axi_wr_osr_lmt and axi_rd_osr_lmt value to 1 since the register
 has a default value of 1
Changelog v4:
*Rebased to latest net-next
Changelog v3:
*Applied reversed christmas tree
Changelog v2:
*Added support for the C37 AN for 1000BASE-X and SGMII (MAC side SGMII only)
*removed and submitted the fix patch to net
 "net: stmmac: dma channel control register need to be init first"
*Squash the following 2 patches and move it to the end of the patch set:
 "net: stmmac: add EHL SGMII 1Gbps platform data and PCI ID"
 "net: stmmac: add xPCS platform data for EHL"
1.9.1

