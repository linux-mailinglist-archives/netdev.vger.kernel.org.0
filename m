Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B93E8585234
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 17:18:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237122AbiG2PSF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 11:18:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237092AbiG2PSE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 11:18:04 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD06A63914;
        Fri, 29 Jul 2022 08:18:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1659107881; x=1690643881;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=eK/W5ETq5QSYGd3HgstGbsh5CACgeNdBiLnNdZM3OOk=;
  b=FoJqZWCVulv3Fha2UbJ6MlIdP9BpraHKADkXZEAdJCOHzXW8KBrWP8kX
   qpBFteCRhcYd7i/cnrCsOCbBkXT84Wi8YmOl9JKeR9irmAqfIwrq/hxv9
   naYBfLf/4NjV5Gh92ZC8m1e1zOogXfx1SMjEtRQ5r8U+wjr4wmnWqfJGX
   U6aDcCiUtoxi6/MUMg5+sHhJ+XW71vbFYlLJANkmXNuItsoCLDNjvj90u
   IoyygF+aW2Y5QE4MPjPz0U/2QHQMM7wIEKzMCWO//GXTetXpNHg5ji3tL
   n/4ILzbGbhRiSbV2AyThnRXjd/DmswJKZ1GWnmYh0ZzKRL7wH0QtpJtka
   w==;
X-IronPort-AV: E=Sophos;i="5.93,201,1654585200"; 
   d="scan'208";a="174162666"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 29 Jul 2022 08:18:00 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 29 Jul 2022 08:17:59 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Fri, 29 Jul 2022 08:17:48 -0700
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
        "Russell King" <linux@armlinux.org.uk>
Subject: [Patch RFC net-next 0/4] net: dsa: microchip: vlan configuration for bridge_vlan_unaware ports
Date:   Fri, 29 Jul 2022 20:47:29 +0530
Message-ID: <20220729151733.6032-1-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

During refactoring of ksz spi probe, ds->configure_vlan_while_filtering flag is
set in the ksz_setup function. It makes the extack warning when vlan_add
command is used when vlan_filtering is turned off for the port.
To allow the vlan_add for the bridge vlan unaware ports, private pvid is used
for it. This pvid is used for the vlan_unaware ports. The private pvid is added
to the vlan_table during the port_setup function.
For the vlan aware ports, pvid issued by the user application will be used.
Bridge vlan pvid is stored in the ksz port structure which can be used during
transition between the vlan aware to unaware and vice versa.

Tested using the following sequence for ksz9477 and lan937x
----------------
Setup -> Host1 --- LAN1 -- LAN2 --- Host2

ip link set dev br0 type bridge vlan_filtering 0
bridge vlan add vid 5 dev lan1 pvid untagged
bridge vlan add vid 5 dev lan2 pvid untagged
bridge vlan del vid 5 dev lan1
bridge vlan del vid 5 dev lan2

After each step of execution, transmitted the packets from Host1 and
successfully received by the Host2.

Arun Ramadoss (4):
  net: dsa: microchip: modify vlan_add function prototype
  net: dsa: microchip: lan937x: remove vlan_filtering_is_global flag
  net: dsa: microchip: common ksz pvid get and set function
  net: dsa: microchip: use private pvid for bridge_vlan_unwaware

 drivers/net/dsa/microchip/ksz8.h         |  6 +-
 drivers/net/dsa/microchip/ksz8795.c      | 42 +++-------
 drivers/net/dsa/microchip/ksz9477.c      | 40 ++++------
 drivers/net/dsa/microchip/ksz9477.h      |  5 +-
 drivers/net/dsa/microchip/ksz_common.c   | 98 +++++++++++++++++++++++-
 drivers/net/dsa/microchip/ksz_common.h   | 21 ++++-
 drivers/net/dsa/microchip/lan937x_main.c |  5 --
 7 files changed, 142 insertions(+), 75 deletions(-)


base-commit: ba323f6bee1d1e70aed280f8c89ac06959559855
-- 
2.36.1

