Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 030EC4F23CB
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 08:56:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231246AbiDEG6a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 02:58:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231234AbiDEG62 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 02:58:28 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32273636C;
        Mon,  4 Apr 2022 23:56:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1649141791; x=1680677791;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=XCuwsMkc/RYY+FxUw+6XukXX24ukq5d/45lTk16U5nY=;
  b=ri921db6EtU+4zyQxJM8nsbRJFiRblUm6SzZJsb4gsvuWN5hGxPnCmgs
   knTKzozLNJZ+xFsTZivjJhuY2adrD44JSIETL893rSOmz4CXYjFWFZQKU
   ZxKUPpoeGrZyMWV9Se5cFb1MhyhgwyuOJ1nYxwY2vKbJDtaadZZjvUwXO
   +n6Jgp3V410M8jvJPUKOagjepHauW6f+fBbBT64Oo0Vk9y0MLsfmeJb1C
   yPGdQG1KShQ1pZo23HEUtb59MyBD+roce9EbTtU+0eR8qaG5JVAI0bAfM
   4CLCJiTjic4Grb8Fi8c9aYFTXZ1er/N8XhF5cqL05Z9veU07Yhb3oSsIi
   g==;
X-IronPort-AV: E=Sophos;i="5.90,236,1643698800"; 
   d="scan'208";a="159319232"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 04 Apr 2022 23:56:30 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Mon, 4 Apr 2022 23:56:29 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Mon, 4 Apr 2022 23:56:28 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <Divya.Koppera@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH net] net: micrel: Fix KS8851 Kconfig
Date:   Tue, 5 Apr 2022 08:59:36 +0200
Message-ID: <20220405065936.4105272-1-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

KS8851 selects MICREL_PHY, which depends on PTP_1588_CLOCK_OPTIONAL, so
make KS8851 also depend on PTP_1588_CLOCK_OPTIONAL.

Fixes kconfig warning and build errors:

WARNING: unmet direct dependencies detected for MICREL_PHY
  Depends on [m]: NETDEVICES [=y] && PHYLIB [=y] && PTP_1588_CLOCK_OPTIONAL [=m]
    Selected by [y]:
      - KS8851 [=y] && NETDEVICES [=y] && ETHERNET [=y] && NET_VENDOR_MICREL [=y] && SPI [=y]

ld.lld: error: undefined symbol: ptp_clock_register referenced by micrel.c
net/phy/micrel.o:(lan8814_probe) in archive drivers/built-in.a
ld.lld: error: undefined symbol: ptp_clock_index referenced by micrel.c
net/phy/micrel.o:(lan8814_ts_info) in archive drivers/built-in.a

Reported-by: kernel test robot <lkp@intel.com>
Fixes: ece19502834d ("net: phy: micrel: 1588 support for LAN8814 phy")
Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 drivers/net/ethernet/micrel/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/micrel/Kconfig b/drivers/net/ethernet/micrel/Kconfig
index 1b632cdd7630..830363bafcce 100644
--- a/drivers/net/ethernet/micrel/Kconfig
+++ b/drivers/net/ethernet/micrel/Kconfig
@@ -28,6 +28,7 @@ config KS8842
 config KS8851
 	tristate "Micrel KS8851 SPI"
 	depends on SPI
+	depends on PTP_1588_CLOCK_OPTIONAL
 	select MII
 	select CRC32
 	select EEPROM_93CX6
-- 
2.33.0

