Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D35945B3C8C
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 18:02:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231726AbiIIQBr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Sep 2022 12:01:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231674AbiIIQBq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Sep 2022 12:01:46 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 343B6D51E9;
        Fri,  9 Sep 2022 09:01:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1662739305; x=1694275305;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=eZcBiEzR0A8RuY62lRo67e7/QJylgwmlLCnFSuB+ZD4=;
  b=WAi83r6Wsz0lLwgjNfzCjTfbAHQNEiSTXXEI7a4D2AFXnrB27B+uU4He
   eOYAacbvLLEZ0RaqNwe17xriN/lR60uj8ml9a7ba/C9zBJUB2RDv4sLc6
   MwdDx2OZ1JBYTTGLC32/NR8545T9TUekSbusxtQJn2u5+KEnZw8LRUoQb
   DLAHorVJLe8JnC/uiD9R8cf7V5PqtTZBatdK9t8fhvyAIKt/m6s/Prhk1
   Oz6j8Fziace3RZYYvVO8LJ7Zmg7yQq4FE1/i0ln7Jk9VcAnkainzhBzSt
   HKVAdLJ4XFccC349ocl7xvuB7VPRvJpjZxUst9PqyeEWXU1kmcH/vq/+2
   w==;
X-IronPort-AV: E=Sophos;i="5.93,303,1654585200"; 
   d="scan'208";a="190177599"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 09 Sep 2022 09:01:44 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Fri, 9 Sep 2022 09:01:43 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Fri, 9 Sep 2022 09:01:38 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <woojung.huh@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <olteanv@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux@armlinux.org.uk>, <Tristram.Ha@microchip.com>
Subject: [RFC Patch net-next 0/4] net: dsa: microchip: ksz9477: enable interrupt for internal phy link detection
Date:   Fri, 9 Sep 2022 21:31:16 +0530
Message-ID: <20220909160120.9101-1-arun.ramadoss@microchip.com>
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

Arun Ramadoss (4):
  net: dsa: microchip: determine number of port irq based on switch type
  net: dsa: microchip: enable phy interrupts only if interrupt enabled
    in dts
  net: dsa: microchip: move interrupt handling logic from lan937x to
    ksz_common
  net: phy: micrel: enable interrupt for ksz9477 phy

 drivers/net/dsa/microchip/ksz_common.c   | 437 +++++++++++++++++++++++
 drivers/net/dsa/microchip/ksz_common.h   |  10 +
 drivers/net/dsa/microchip/lan937x_main.c | 425 ----------------------
 drivers/net/phy/micrel.c                 |   2 +
 4 files changed, 449 insertions(+), 425 deletions(-)

-- 
2.36.1

