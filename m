Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63C895AAC72
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 12:32:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235461AbiIBKcm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 06:32:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235792AbiIBKce (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 06:32:34 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22373B2CE4;
        Fri,  2 Sep 2022 03:32:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1662114754; x=1693650754;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=yKhV1QeaMdj5PolCerUiy3X7/Y2GvbFjvuGsxtDBMo8=;
  b=TulDct2L8pJvNJsmpGu2rSs4zB9vEkWlUWV/vIhSRpv50lCIR9JmrJZ+
   8dnM6INqeWKxjCL1okNOtmlvKpmSKUoXALw44n+bCD45VBSe5clHeTSS3
   c0WmLzBQhBeXg2G4B5+DZq4XI0Z5DZ9EtfD0LjuoPh7IDuJjywcyBi4Qi
   ulTQxrkA3hisX2ymhD66VwEJ/HGrWjzlAdgcgYdZ39H0moZ0t0o5JWxNg
   5nq+A+qICghKE2vmWRZo/zIOHX2JRQoAOamsWQhCmhuaMBFzmDu2Y4gGE
   ZiZHfxhMiTXr5MtqtWpa/iY0FEjlvqMCjB6ox3FXPk39Wa3R1MHsh14zT
   w==;
X-IronPort-AV: E=Sophos;i="5.93,283,1654585200"; 
   d="scan'208";a="178772912"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 02 Sep 2022 03:32:31 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Fri, 2 Sep 2022 03:32:21 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Fri, 2 Sep 2022 03:32:16 -0700
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
        "Russell King" <linux@armlinux.org.uk>,
        Tristram Ha <Tristram.Ha@microchip.com>
Subject: [Patch net-next 0/3] net: dsa: microchip: lan937x: enable interrupt for internal phy link detection
Date:   Fri, 2 Sep 2022 16:02:07 +0530
Message-ID: <20220902103210.10743-1-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series enables the internal phy link detection for lan937x using the
interrupt method. lan937x acts as the interrupt controller for the internal
ports and phy, the irq_domain is registered for the individual ports and in
turn for the individual port interrupts.

RFC v3 -> Patch v1
- Removed the RFC v3 1/3 from the series - changing exit from reset
- Changed the variable name in ksz_port from irq to pirq
- Added the check for return value of irq_find_mapping during phy irq
  registeration.
- Moved the clearing of POR_READY_INT from girq_thread_fn to
  lan937x_reset_switch

RFC v2 -> v3
- Used the interrupt controller implementation of phy link

Changes in RFC v2
- fixed the compilation issue

Arun Ramadoss (3):
  net: dsa: microchip: add reference to ksz_device inside the ksz_port
  net: dsa: microchip: lan937x: clear the POR_READY_INT status bit
  net: dsa: microchip: lan937x: add interrupt support for port phy link

 drivers/net/dsa/microchip/ksz_common.c   |  13 +
 drivers/net/dsa/microchip/ksz_common.h   |  18 ++
 drivers/net/dsa/microchip/ksz_spi.c      |   2 +
 drivers/net/dsa/microchip/lan937x.h      |   1 +
 drivers/net/dsa/microchip/lan937x_main.c | 368 ++++++++++++++++++++++-
 drivers/net/dsa/microchip/lan937x_reg.h  |  12 +
 6 files changed, 410 insertions(+), 4 deletions(-)


base-commit: aa51b80e1af47b3781abb1fb1666445a7616f0cd
-- 
2.36.1

