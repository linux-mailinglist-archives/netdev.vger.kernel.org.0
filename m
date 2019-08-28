Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7773A0891
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 19:34:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726805AbfH1RdZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 13:33:25 -0400
Received: from mga02.intel.com ([134.134.136.20]:19308 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726315AbfH1RdZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Aug 2019 13:33:25 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 28 Aug 2019 10:33:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,441,1559545200"; 
   d="scan'208";a="182093663"
Received: from glass.png.intel.com ([172.30.181.95])
  by fmsmga007.fm.intel.com with ESMTP; 28 Aug 2019 10:33:20 -0700
From:   Ong Boon Leong <boon.leong.ong@intel.com>
To:     davem@davemloft.net, linux@armlinux.org.uk,
        mcoquelin.stm32@gmail.com, joabreu@synopsys.com,
        f.fainelli@gmail.com, andrew@lunn.ch
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        peppe.cavallaro@st.comi, alexandre.torgue@st.com,
        weifeng.voon@intel.com
Subject: [RFC net-next v1 0/5] PHY converter driver for DW xPCS IP
Date:   Thu, 29 Aug 2019 01:33:16 +0800
Message-Id: <20190828173321.25334-1-boon.leong.ong@intel.com>
X-Mailer: git-send-email 2.17.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Following review comment from Florian and discussion in below thread:-

https://patchwork.ozlabs.org/patch/1109777/

This RFC is to solicit feedback on the implementation of PHY converter
driver for DW xPCS and some changes in the mdiobus API to prepare for
mdio device registration during driver open() instead of probe() phase
for non-DT platform. The implementation in this Phy Converter has DT
registration for future expansion, however, it is not tested in our
current platform.

The 1st three patches involve changes in existing mdiobus API:-
1) Make mdiobus_create_device() function callable from Ethernet driver
2) Introduce new API mdiobus_get_mdio_device()
3) Add private data for struct mdio_device so that DW xPCS specific
   private data can be established between the pairing Ethernet
   controller for non-DT way.

The reason for changes for mdiobus_create_device() &
mdiobus_get_mdio_device() is to allow Eth driver to be able to create
mdio device for PHY converter driver when Ethernet driver open() is
called. Existing way for registering mdio device for non-DT appraoch
is through mdiobus_register_board_info() and the mdio device creation
happens inside Ethernet probe() whereby IRQ is not setup. The mdio
device registration happens in mdiobus_register() -->
mdiobus_setup_mdiodevfrom_board_info(), and it becomes an issue for
Phy Converter such as dwxpcs that requires IRQ setup before, i.e.
inside Ethernet controller open().

The 4th patch is for PHY Converter driver for DW xPCS.
Large portion of main logics of this code has been reviewed in the
past in above review thread and all review inputs have been factored.

First, the loading of PHY converter driver is through ACPI Device ID.
The current implementation also has logics for DT style, but since
we don't have such platform, we the DT implementation as place-holder
for anyone that needs in future. The DT implementation follows the
design of drivers/net/phy/xilinx_gmii2rgmii.c closely.

What is extra is setup for DW xPCS IRQ request. In current EHL & TGL
implementation, the IRQ is routed from MAC controller. For non-DT way,
the IRQ line is tied to Ethernet driver (PCI enum), and we need a
way to pass IRQ info from Ethernet driver to PHY converter driver
during the creation of mdio device. Therefore, this is the reason
for the 1st 3 patches. All the ISR does is to kick the workqueue to
process the IRQ as we cannot call mdio_read() and mdio_write() inside
ISR.

The 5th (last) patch shows how the associated PHY converter mdio device
is setup in Ethernet controller open() function and removed during
stop(). The implementation is done in stmmac pci driver.

With this implementation, now, we have dwxpcs implemented as PHY driver
and the hook from stmmac driver for non-DT style is done through
platform-specific data related to EHL & TGL when SGMII interface is
selected. The PHY converter driver will still be beneficial for other
platform that would need it and may use DT to enable the PHY converter
driver and mdio device through DT definition.

Please kindly review this RFC and provide any feedback/concern that
the community may have. Appreciate your time here.

Thanks
Boon Leong

Ong Boon Leong (5):
  net: phy: make mdiobus_create_device() function callable from Eth
    driver
  net: phy: introduce mdiobus_get_mdio_device
  net: phy: add private data to mdio_device
  net: phy: introducing support for DWC xPCS logics for EHL & TGL
  net: stmmac: add dwxpcs boardinfo for mdio_device registration

 drivers/net/ethernet/stmicro/stmmac/Kconfig   |   1 +
 drivers/net/ethernet/stmicro/stmmac/stmmac.h  |   2 +
 .../net/ethernet/stmicro/stmmac/stmmac_main.c |  25 ++
 .../net/ethernet/stmicro/stmmac/stmmac_pci.c  |  45 +-
 drivers/net/phy/Kconfig                       |   9 +
 drivers/net/phy/Makefile                      |   1 +
 drivers/net/phy/dwxpcs.c                      | 417 ++++++++++++++++++
 drivers/net/phy/mdio_bus.c                    |  11 +-
 include/linux/dwxpcs.h                        |  16 +
 include/linux/mdio.h                          |   3 +
 include/linux/phy.h                           |   7 +
 include/linux/stmmac.h                        |   3 +
 12 files changed, 537 insertions(+), 3 deletions(-)
 create mode 100644 drivers/net/phy/dwxpcs.c
 create mode 100644 include/linux/dwxpcs.h

-- 
2.17.0

