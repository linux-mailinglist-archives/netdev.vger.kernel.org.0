Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E4495E5BE7
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 09:11:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229791AbiIVHLJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 03:11:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbiIVHLH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 03:11:07 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1C8A98D01;
        Thu, 22 Sep 2022 00:11:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1663830663; x=1695366663;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=AaF/adrnSmLVJ38c7CTc0hQa7F9kDTXh+ROH6ZvZgfs=;
  b=hta3Xz2G+ja+nnpU77LDiPIZ5R14LWc6i6cIlP9WMxCWW6oMGTUZGOci
   gYXMomMkRpiwq8uzcUXUU4ubq9jPQrS2YW56FAA+ELql/bR78rLLRDEey
   s72Fe5EX8SdKfarJXJpbb1a2gmo0PBcrSy3jnZGBO0m/M4yZ9bEupKqoj
   +of0459BU82X1OnbSEcs+8Vxf9QyaS8io/HMM3LgwOq8fA7JWU0sbR5Ny
   tFxwaLyi0q2JTU4/YdJ7Mwq3TaIbIHCngofI9j4k1c2alKOOEjH7KnJin
   0tneQDbK8sxYvrG5FJwZji4r1AvSvknIDz5njstyTEqyHCza9miY8gYEg
   Q==;
X-IronPort-AV: E=Sophos;i="5.93,335,1654585200"; 
   d="scan'208";a="181581741"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 22 Sep 2022 00:11:02 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Thu, 22 Sep 2022 00:11:00 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Thu, 22 Sep 2022 00:10:54 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <woojung.huh@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <olteanv@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux@armlinux.org.uk>, <Tristram.Ha@microchip.com>,
        <arun.ramadoss@microchip.com>,
        <prasanna.vengateshan@microchip.com>, <hkallweit1@gmail.com>
Subject: [Patch net-next v4 0/6] net: dsa: microchip: ksz9477: enable interrupt for internal phy link detection
Date:   Thu, 22 Sep 2022 12:40:22 +0530
Message-ID: <20220922071028.18012-1-arun.ramadoss@microchip.com>
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

v3 -> v4
- Rebased the code to latest net-next

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
 drivers/net/dsa/microchip/lan937x_main.c | 427 -----------------------
 drivers/net/phy/micrel.c                 |   2 +
 4 files changed, 336 insertions(+), 428 deletions(-)


base-commit: 7a5d48c4463e6ef896ea2190a97d9e90b37c38da
-- 
2.36.1

