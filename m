Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B02BD5BA91F
	for <lists+netdev@lfdr.de>; Fri, 16 Sep 2022 11:16:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230366AbiIPJOU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Sep 2022 05:14:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229812AbiIPJOS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Sep 2022 05:14:18 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE8896EF11;
        Fri, 16 Sep 2022 02:14:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1663319657; x=1694855657;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=BG5V+A4uG8HRBRbESp15yu8AT7lZh9mvv40sj/jdHsM=;
  b=L9iwVakqWjNiN06egHZWkhJpyRdAdYdYxdYzFOQ3d88mcKK0CugTunX5
   39oZ5Y+8hgY2XERGGcC+yffuWSO1UI0n+gaKk1IBT6bghD35+HlB8nhKV
   0MdkUcXTSANMWgGEiFwQIgElagwXIj3OMl3A93om1Uko3FWdAuBpW3RdC
   2lF4xsl/nsEftKkiX09nh+b6EflT1F/qjkAiXyFyUNMb7j6pzQjLclTmY
   /STedT34mFvd5F7DSujqz2zFFWoy5gkW7xU9E64hBGy8YrIezHySTwRug
   hXCI+zfauWo3ZD92Jlt3nypyimqb/ZtUXHZKjRvcSarkEwFJuhU/SXAw+
   A==;
X-IronPort-AV: E=Sophos;i="5.93,320,1654585200"; 
   d="scan'208";a="180663662"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 16 Sep 2022 02:14:16 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Fri, 16 Sep 2022 02:14:16 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Fri, 16 Sep 2022 02:14:10 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <woojung.huh@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <olteanv@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux@armlinux.org.uk>, <Tristram.Ha@microchip.com>,
        <arun.ramadoss@microchip.com>,
        <prasanna.vengateshan@microchip.com>, <hkallweit1@gmail.com>
Subject: [Patch net-next v3 0/6] net: dsa: microchip: ksz9477: enable interrupt for internal phy link detection
Date:   Fri, 16 Sep 2022 14:43:42 +0530
Message-ID: <20220916091348.8570-1-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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

v2 -> v3
- Added the common interrupt routines for girq and pirq

v1 -> v2
- Added the .port_nirqs = 2 for ksz9896

Changes in RFC -> v1
- modified the return -ENODEV to 0 if mdio node not present

Arun Ramadoss (6):
  net: dsa: microchip: determine number of port irq based on switch type
  net: dsa: microchip: enable phy interrupts only if interrupt enabled
    in dts
  net: dsa: microchip: lan937x: return zero if mdio node not present
  net: dsa: microchip: move interrupt handling logic from lan937x to
    ksz_common
  net: dsa: microchip: use common irq routines for girq and pirq
  net: phy: micrel: enable interrupt for ksz9477 phy

 drivers/net/dsa/microchip/ksz_common.c   | 320 +++++++++++++++++
 drivers/net/dsa/microchip/ksz_common.h   |  15 +-
 drivers/net/dsa/microchip/lan937x_main.c | 425 -----------------------
 drivers/net/phy/micrel.c                 |   2 +
 4 files changed, 336 insertions(+), 426 deletions(-)


base-commit: da970726ea872269dc311b6dd87af8cf457b8fe9
-- 
2.36.1

