Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9757E6D7822
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 11:27:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237170AbjDEJ1p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 05:27:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237301AbjDEJ1o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 05:27:44 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C5AF4EEF
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 02:27:33 -0700 (PDT)
Received: from dude02.red.stw.pengutronix.de ([2a0a:edc0:0:1101:1d::28])
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <m.felsch@pengutronix.de>)
        id 1pjzPx-0004pA-P4; Wed, 05 Apr 2023 11:27:01 +0200
From:   Marco Felsch <m.felsch@pengutronix.de>
Subject: [PATCH 00/12] Rework PHY reset handling
Date:   Wed, 05 Apr 2023 11:26:51 +0200
Message-Id: <20230405-net-next-topic-net-phy-reset-v1-0-7e5329f08002@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIANs+LWQC/x2NQQrDMAwEvxJ0rsFNXUL7ldKD40i1ICjGckpKy
 N8rcljY2cPsDoqVUeHZ7VDxy8qLGFwvHaQc5YOOJ2PofX/zwd+dYLNszbWlcDqx5J+rqNYCDQ+
 iYaIQPZhijIpurFFSNoms82xjqUi8nZ+v93H8AdfhtMyDAAAA
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Radu Pirea <radu-nicolae.pirea@oss.nxp.com>,
        Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Iyappan Subramanian <iyappan@os.amperecomputing.com>,
        Keyur Chudgar <keyur@os.amperecomputing.com>,
        Quan Nguyen <quan@os.amperecomputing.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Len Brown <lenb@kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, devicetree@vger.kernel.org,
        kernel@pengutronix.de
X-Mailer: b4 0.12.1
X-SA-Exim-Connect-IP: 2a0a:edc0:0:1101:1d::28
X-SA-Exim-Mail-From: m.felsch@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-2.3 required=5.0 tests=RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current phy reset handling is broken in a way that it needs
pre-running firmware to setup the phy initially. Since the very first
step is to readout the PHYID1/2 registers before doing anything else.

The whole dection logic will fall apart if the pre-running firmware
don't setup the phy accordingly or the kernel boot resets GPIOs states
or disables clocks. In such cases the PHYID1/2 read access will fail and
so the whole detection will fail.

I fixed this via this series, the fix will include a new kernel API
called phy_device_atomic_register() which will do all necessary things
and return a 'struct phy_device' on success. So setting up a phy and the
phy state machine is more convenient.

I tested the series on a i.MX8MP-EVK and a custom board which have a
TJA1102 dual-port ethernet phy. Other testers are welcome :)

Regards,
  Marco

Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
---
Marco Felsch (12):
      net: phy: refactor phy_device_create function
      net: phy: refactor get_phy_device function
      net: phy: add phy_device_set_miits helper
      net: phy: unify get_phy_device and phy_device_create parameter list
      net: phy: add phy_id_broken support
      net: phy: add phy_device_atomic_register helper
      net: mdio: make use of phy_device_atomic_register helper
      net: phy: add possibility to specify mdio device parent
      net: phy: nxp-tja11xx: make use of phy_device_atomic_register()
      of: mdio: remove now unused of_mdiobus_phy_device_register()
      net: mdiobus: remove now unused fwnode helpers
      net: phy: add default gpio assert/deassert delay

 Documentation/firmware-guide/acpi/dsd/phy.rst     |   2 +-
 MAINTAINERS                                       |   1 -
 drivers/net/ethernet/adi/adin1110.c               |   6 +-
 drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c       |   8 +-
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_mac.c |  11 +-
 drivers/net/ethernet/socionext/netsec.c           |   7 +-
 drivers/net/mdio/Kconfig                          |   7 -
 drivers/net/mdio/Makefile                         |   1 -
 drivers/net/mdio/acpi_mdio.c                      |  20 +-
 drivers/net/mdio/fwnode_mdio.c                    | 183 ------------
 drivers/net/mdio/mdio-xgene.c                     |   6 +-
 drivers/net/mdio/of_mdio.c                        |  23 +-
 drivers/net/phy/bcm-phy-ptp.c                     |   2 +-
 drivers/net/phy/dp83640.c                         |   2 +-
 drivers/net/phy/fixed_phy.c                       |   6 +-
 drivers/net/phy/mdio_bus.c                        |   7 +-
 drivers/net/phy/micrel.c                          |   2 +-
 drivers/net/phy/mscc/mscc_ptp.c                   |   2 +-
 drivers/net/phy/nxp-c45-tja11xx.c                 |   2 +-
 drivers/net/phy/nxp-tja11xx.c                     |  47 ++-
 drivers/net/phy/phy_device.c                      | 348 +++++++++++++++++++---
 drivers/net/phy/sfp.c                             |   7 +-
 include/linux/fwnode_mdio.h                       |  35 ---
 include/linux/of_mdio.h                           |   8 -
 include/linux/phy.h                               |  46 ++-
 25 files changed, 442 insertions(+), 347 deletions(-)
---
base-commit: 054fbf7ff8143d35ca7d3bb5414bb44ee1574194
change-id: 20230405-net-next-topic-net-phy-reset-4f79ff7df4a0

Best regards,
-- 
Marco Felsch <m.felsch@pengutronix.de>

