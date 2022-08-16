Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34A56595A37
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 13:34:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234541AbiHPLeK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 07:34:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234523AbiHPLdu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 07:33:50 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15C557C1C5;
        Tue, 16 Aug 2022 03:55:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1660647333; x=1692183333;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=ydczOs/B4f5E5PAGhD2udvBxWaaSFQ2xVkQP9xvCjU8=;
  b=oTQzoV7YDMSyipRcfysxVCwIl8eYAFhxbhN38G9QCUwVU3uvdQIleI3Y
   kahM2iMEBPswwj0IV1VBo3vLipO+KGBwKQk/RzOk1LW3ddU+/zhIRYyaG
   6gvqX25GasRvTci3lEtuPT4xwuEgZiL8wucqGTvfUMK+Nqbj8KKgVdCAG
   sRzjlRJo4z3jisqf/Q2TTHc7/5qrjEUlE2MmSTUQZzczyOLnWPTYwpmzK
   DEHibJwbYVuu5/hbktrOGBa6wuafzsPYk1uEvMBQaI2C8Eosd7X5Rjiat
   +OPU6r6RUqtq004icNz/HguJ8K5MsofZEfpfRSrvXiFvauEsYsPI8IMQ6
   A==;
X-IronPort-AV: E=Sophos;i="5.93,240,1654585200"; 
   d="scan'208";a="169486516"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 16 Aug 2022 03:55:32 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Tue, 16 Aug 2022 03:55:30 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Tue, 16 Aug 2022 03:55:24 -0700
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
Subject: [patch net v3] net: dsa: microchip: ksz9477: fix fdb_dump last invalid entry
Date:   Tue, 16 Aug 2022 16:25:16 +0530
Message-ID: <20220816105516.18350-1-arun.ramadoss@microchip.com>
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

In the ksz9477_fdb_dump function it reads the ALU control register and
exit from the timeout loop if there is valid entry or search is
complete. After exiting the loop, it reads the alu entry and report to
the user space irrespective of entry is valid. It works till the valid
entry. If the loop exited when search is complete, it reads the alu
table. The table returns all ones and it is reported to user space. So
bridge fdb show gives ff:ff:ff:ff:ff:ff as last entry for every port.
To fix it, after exiting the loop the entry is reported only if it is
valid one.

Fixes: b987e98e50ab ("dsa: add DSA switch driver for Microchip KSZ9477")
Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
---
changes in v3
- changed the subject from net-next to net

changes in v2
- changed the fixes commit id
- reduced the indentation level by using ! and continue statement

 drivers/net/dsa/microchip/ksz9477.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index 4b14d80d27ed..e4f446db0ca1 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -613,6 +613,9 @@ int ksz9477_fdb_dump(struct ksz_device *dev, int port,
 			goto exit;
 		}
 
+		if (!(ksz_data & ALU_VALID))
+			continue;
+
 		/* read ALU table */
 		ksz9477_read_table(dev, alu_table);
 

base-commit: 7ebfc85e2cd7b08f518b526173e9a33b56b3913b
-- 
2.36.1

