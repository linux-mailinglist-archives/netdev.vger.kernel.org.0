Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85659572037
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 18:03:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233815AbiGLQDh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 12:03:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232900AbiGLQDf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 12:03:35 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A404E95;
        Tue, 12 Jul 2022 09:03:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1657641812; x=1689177812;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=0K0J4t2ZUnG1rG6QAYX6jCH2YeQQ1D9EMcy9ouR70Fw=;
  b=WP0UQsEbS+D20eJBYXBxUb5NrRFmm0iHB/ieCoXN1J91ea9txrV4vXRE
   xw0Q2sh1hs+5lHPsU7q8KFuXucYruoQZqFtgOxCIt3ONxzfwWHdORnvft
   Vu9g6sD56UBcIntZkHbm2Y52n4a50o7UmY845VpdI0cxFFhoQzOhicQsP
   I8/N09EPgZK/rjrE8bdE1HTa1fM/OESLWmrpOzqImSAZoJYSMfA+SKL6g
   IV9Sp2WbfzSRrm2xkLKEly/W8euYZy4PnAJHuKqnw6yd3nBq2g3xi27ee
   UyhBLdMN0Ly6I9GQ7QFQAfPn1JjyPxNdp27us6WGNjJsV7KSv2oUfxTg6
   w==;
X-IronPort-AV: E=Sophos;i="5.92,266,1650956400"; 
   d="scan'208";a="104122489"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 12 Jul 2022 09:03:32 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 12 Jul 2022 09:03:31 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Tue, 12 Jul 2022 09:03:21 -0700
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
Subject: [RFC Patch net-next 00/10] net: dsa: microchip: add support for phylink mac config and link up
Date:   Tue, 12 Jul 2022 21:32:58 +0530
Message-ID: <20220712160308.13253-1-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series add common phylink mac config and link up support for the ksz
series switches. At present, ksz8795 and ksz9477 doesn't implement the phylink
mac config and link up. It configures the mac interface in the port setup hook.
ksz8830 series switch does not mac link configuration. For lan937x switches, in
the part support patch series has support only for MII and RMII configuration.
Some group of switches have some register address and bit fields common and
others are different. So, this patch aims to have common phylink implementation
which configures the register based on the chip id.

Arun Ramadoss (10):
  net: dsa: microchip: lan937x: read rgmii delay from device tree
  net: dsa: microchip: add common gigabit set and get function
  net: dsa: microchip: add common 100/10Mbps selection function
  net: dsa: microchip: add common duplex and flow control function
  net: dsa: microchip: add support for common phylink mac link up
  net: dsa: microchip: lan937x: add support for configuing xMII register
  net: dsa: microchip: apply rgmii tx and rx delay in phylink mac config
  net: dsa: microchip: ksz9477: use common xmii function
  net: dsa: microchip: ksz8795: use common xmii function
  net: dsa: microchip: add support for phylink mac config

 drivers/net/dsa/microchip/ksz8795.c      |  40 ---
 drivers/net/dsa/microchip/ksz8795_reg.h  |   8 -
 drivers/net/dsa/microchip/ksz9477.c      | 183 +-------------
 drivers/net/dsa/microchip/ksz9477_reg.h  |  24 --
 drivers/net/dsa/microchip/ksz_common.c   | 305 ++++++++++++++++++++++-
 drivers/net/dsa/microchip/ksz_common.h   |  41 +++
 drivers/net/dsa/microchip/lan937x.h      |   4 -
 drivers/net/dsa/microchip/lan937x_main.c | 131 ++++------
 drivers/net/dsa/microchip/lan937x_reg.h  |  32 +--
 9 files changed, 419 insertions(+), 349 deletions(-)


base-commit: 5022e221c98a609e0e5b0a73852c7e3d32f1c545
-- 
2.36.1

