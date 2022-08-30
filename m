Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63E375A612E
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 12:53:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229747AbiH3Kx0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 06:53:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbiH3KxZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 06:53:25 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2925061B3C;
        Tue, 30 Aug 2022 03:53:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1661856801; x=1693392801;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=0NJnagFhYLzXOTkxodmjd0RzxVp5Xg3XokjLa4kfVAM=;
  b=b+nr4ziGfbQ59wDdi6BQLTlZBpRLL3vGddR6pmkXkOEJiszR6uvFTDhv
   eraKuSy0izOonCs/edgswxyf710Yoo+qE3RW8fFxeVI25PFVnSTeg+e+I
   fc9/CWZfP1gWEtNMAj1dorKg8HfvFffShtIg4z0oBaXGrqHvb8Sv9uYYl
   i7n55vfwmFx98Dfc1P1kSPgBvTGwxH66iAaANyQ4rLpH3HJhYLWCrGrwK
   HPQm7Ic6OXHI33dDG9dY8iV7dVn9uV8c+To181kB55bjwBVJfUe7mbJpG
   L0ExznqEskHE9zvqqTyeN/vY4Aw81hT2lsEm+oum8+pMcE5YocB2m0FXE
   A==;
X-IronPort-AV: E=Sophos;i="5.93,274,1654585200"; 
   d="scan'208";a="188626258"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 30 Aug 2022 03:53:21 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Tue, 30 Aug 2022 03:53:21 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Tue, 30 Aug 2022 03:53:16 -0700
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
Subject: [RFC Patch net-next v3 0/3] net: dsa: microchip: lan937x: enable interrupt for internal phy link detection
Date:   Tue, 30 Aug 2022 16:23:00 +0530
Message-ID: <20220830105303.22067-1-arun.ramadoss@microchip.com>
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

RFC v2 -> v3
- Used the interrupt controller implementation of phy link

Changes in RFC v2
- fixed the compilation issue

Arun Ramadoss (3):
  net: dsa: microchip: use dev_ops->reset instead of exit in
    ksz_switch_register
  net: dsa: microchip: add reference to ksz_device inside the ksz_port
  net: dsa: microchip: lan937x: add interrupt support for port phy link

 drivers/net/dsa/microchip/ksz_common.c   |   5 +-
 drivers/net/dsa/microchip/ksz_common.h   |  17 ++
 drivers/net/dsa/microchip/ksz_spi.c      |   2 +
 drivers/net/dsa/microchip/lan937x_main.c | 332 ++++++++++++++++++++++-
 drivers/net/dsa/microchip/lan937x_reg.h  |  12 +
 5 files changed, 361 insertions(+), 7 deletions(-)

-- 
2.36.1

