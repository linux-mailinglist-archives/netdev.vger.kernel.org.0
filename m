Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 150705B7FD4
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 05:54:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229446AbiINDyR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Sep 2022 23:54:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiINDyP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Sep 2022 23:54:15 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4750A6F56A;
        Tue, 13 Sep 2022 20:54:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1663127655; x=1694663655;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=CMQzYDRDA8hvu9Na0dMDyZtAGCnoBzQdZ7cCirM8EWQ=;
  b=0jb4u0SCr4pMgKuQ+m1/dHNIbe9zuZ+dy8A/B68yiZ9jOMxJxHXmrDR+
   DqJrKk4yDAZcnzNhGj4el6WG+a8DHRcGRrZI3a7Jno563g3X6suA98grI
   U6GVGx3Br0jyRettld+H9eit731j/KWl3r5ymKDxWT13sN/tt6i1A6cOa
   kIb8MYbmufN/eobU+87xszV1jIXOXVOdnLvqjntICwFVdzwykkNL1Crh6
   YGeBgUvZR/irKCHEkfVD1IL9c35O3AbX18itNqijwAlRllA5mWXUYKgda
   rzJmbLI96N1153Ehj6Ts+lYt4pn/Q6AVUylDvNYWWLaWHOdi0CbbsNFqP
   w==;
X-IronPort-AV: E=Sophos;i="5.93,313,1654585200"; 
   d="scan'208";a="173755919"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 13 Sep 2022 20:54:14 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Tue, 13 Sep 2022 20:54:13 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Tue, 13 Sep 2022 20:54:07 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <woojung.huh@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <olteanv@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux@armlinux.org.uk>, <Tristram.Ha@microchip.com>,
        <arun.ramadoss@microchip.com>,
        <prasanna.vengateshan@microchip.com>, <hkallweit1@gmail.com>
Subject: [Patch net-next v2 0/5] net: dsa: microchip: ksz9477: enable interrupt for internal phy link detection
Date:   Wed, 14 Sep 2022 09:22:18 +0530
Message-ID: <20220914035223.31702-1-arun.ramadoss@microchip.com>
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

This patch series implements the common interrupt handling for ksz9477 based
switches and lan937x. The ksz9477 and lan937x has similar interrupt registers
except ksz9477 has 4 port based interrupts whereas lan937x has 6 interrupts.
The patch moves the phy interrupt hanler implemented in lan937x_main.c to
ksz_common.c, along with the mdio_register functionality.

v1 -> v2
- Added the .port_nirqs = 2 for ksz9896

Changes in RFC -> v1
- modified the return -ENODEV to 0 if mdio node not present

Arun Ramadoss (5):
  net: dsa: microchip: determine number of port irq based on switch type
  net: dsa: microchip: enable phy interrupts only if interrupt enabled
    in dts
  net: dsa: microchip: lan937x: return zero if mdio node not present
  net: dsa: microchip: move interrupt handling logic from lan937x to
    ksz_common
  net: phy: micrel: enable interrupt for ksz9477 phy

 drivers/net/dsa/microchip/ksz_common.c   | 436 +++++++++++++++++++++++
 drivers/net/dsa/microchip/ksz_common.h   |  10 +
 drivers/net/dsa/microchip/lan937x_main.c | 425 ----------------------
 drivers/net/phy/micrel.c                 |   2 +
 4 files changed, 448 insertions(+), 425 deletions(-)


base-commit: c9ae520ac3faf2f272b5705b085b3778c7997ec8
-- 
2.36.1

