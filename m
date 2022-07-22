Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2472557DF24
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 12:10:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236263AbiGVJhA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 05:37:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236426AbiGVJgt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 05:36:49 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D9009DC8A;
        Fri, 22 Jul 2022 02:25:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1658481926; x=1690017926;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=+QND/riB95eOwELi/wTu+6LY1w/6ea6HUDOUh0x5LJc=;
  b=FB5KAOw+wRMLoLBVNlDdEEjTWEisN4ub06wcvirkUcn5aDx0ZijvWGMo
   MQw2kN5UAyEss5Z3Y/1XIciVOv6MdT3CBh6rwwZoejtH1AUxuGmT8SOhn
   iS24iDEMT260jOGXOIFk2sIlPM/L+dsxt8C4b1lZU1PepDIfhHOpnK5/8
   E99/Fk/zsMugAP1oksPSuQ/IxzUQ+p+dMFtzX2NZIEa2SMHp6SJLKEB9X
   VRQ8cR6dJUVQGxOrWgoE4yXLxItZowb19elbVD552a+LcsjzJjpF5xpeZ
   qwQgIZ8qIizCYuAdweKYgcUmXkZ4LGCdTWvJjnYRWfXSRlZicKIYpgBCM
   A==;
X-IronPort-AV: E=Sophos;i="5.93,185,1654585200"; 
   d="scan'208";a="169043264"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 22 Jul 2022 02:25:23 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 22 Jul 2022 02:25:21 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Fri, 22 Jul 2022 02:25:16 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Woojung Huh <woojung.huh@microchip.com>,
        <UNGLinuxDriver@microchip.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Arun Ramadoss" <arun.ramadoss@microchip.com>,
        Russell King <linux@armlinux.org.uk>
Subject: [Patch net-next v1 0/9] net: dsa: microchip: add support for phylink mac config and link up
Date:   Fri, 22 Jul 2022 14:54:50 +0530
Message-ID: <20220722092459.18653-1-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series add support common phylink mac config and link up for the ksz
series switches. At present, ksz8795 and ksz9477 doesn't implement the phylink
mac config and link up. It configures the mac interface in the port setup hook.
ksz8830 series switch does not mac link configuration. For lan937x switches, in
the part support patch series has support only for MII and RMII configuration.
Some group of switches have some register address and bit fields common and
others are different. So, this patch aims to have common phylink implementation
which configures the register based on the chip id.

Changes in v1
- Squash the reading rgmii value from dt to patch which apply the rgmii value
- Created the new function ksz_port_set_xmii_speed
- Seperated the namespace values for xmii_ctrl_0 and xmii_ctrl_1 register
- Applied the rgmii delay value based on the rx/tx-internal-delay-ps

Arun Ramadoss (9):
  net: dsa: microchip: add common gigabit set and get function
  net: dsa: microchip: add common ksz port xmii speed selection function
  net: dsa: microchip: add common duplex and flow control function
  net: dsa: microchip: add support for common phylink mac link up
  net: dsa: microchip: lan937x: add support for configuing xMII register
  net: dsa: microchip: apply rgmii tx and rx delay in phylink mac config
  net: dsa: microchip: ksz9477: use common xmii function
  net: dsa: microchip: ksz8795: use common xmii function
  net: dsa: microchip: add support for phylink mac config

 drivers/net/dsa/microchip/ksz8795.c      |  40 ---
 drivers/net/dsa/microchip/ksz8795_reg.h  |   8 -
 drivers/net/dsa/microchip/ksz9477.c      | 183 +-----------
 drivers/net/dsa/microchip/ksz9477_reg.h  |  24 --
 drivers/net/dsa/microchip/ksz_common.c   | 342 ++++++++++++++++++++++-
 drivers/net/dsa/microchip/ksz_common.h   |  46 +++
 drivers/net/dsa/microchip/lan937x.h      |   8 +-
 drivers/net/dsa/microchip/lan937x_main.c | 125 +++------
 drivers/net/dsa/microchip/lan937x_reg.h  |  32 ++-
 9 files changed, 453 insertions(+), 355 deletions(-)


base-commit: b66eb3a6e427b059101c6c92ac2ddd899014634c
-- 
2.36.1

