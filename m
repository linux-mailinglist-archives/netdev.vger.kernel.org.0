Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27B1364B306
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 11:15:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234940AbiLMKPO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Dec 2022 05:15:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234753AbiLMKPM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Dec 2022 05:15:12 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 026061B7AD;
        Tue, 13 Dec 2022 02:14:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1670926496; x=1702462496;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Gfjh3ZJpkPC3xWETT6ztzTsldD6PDg4VZwFB/XqjB4k=;
  b=uVkClGY1+hj2U+jqWNkpVmIVKhNhEEQMzoPZpFK1yfZ+Rmz6EpzFSK61
   TwaspXeREpRLheZnstDI6/5gtMeaaWCLbiWJVGheMhyk0EUrpxDnPG/sQ
   nLpJ2SXnc/K8/2QPLmZH3nIogrKYKq3PiGmPdSuByEK1v33xmcZKWPBvZ
   9g7mVM1a+pn/Vst7rdK031H+FVz6SWEdl9Y0VZHdeMbClzXE+8Ug5GFTx
   DMxPY/WeV2ix3642at8mg2IzwMPaL1BPqlT25vJvCFlVpYzVdfVktV/63
   iOr61ZGXXGqLFbo2CKct1BRtRB1go9LK+YIl8yaY+QSxDSPG0zn0my5jN
   g==;
X-IronPort-AV: E=Sophos;i="5.96,241,1665471600"; 
   d="scan'208";a="127869668"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 13 Dec 2022 03:14:56 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 13 Dec 2022 03:14:56 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Tue, 13 Dec 2022 03:14:50 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <woojung.huh@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <olteanv@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux@armlinux.org.uk>, <Tristram.Ha@microchip.com>,
        <ceggers@arri.de>
Subject: [Patch net] net: dsa: microchip: remove IRQF_TRIGGER_FALLING in request_threaded_irq
Date:   Tue, 13 Dec 2022 15:44:40 +0530
Message-ID: <20221213101440.24667-1-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

KSZ swithes used interrupts for detecting the phy link up and down.
During registering the interrupt handler, it used IRQF_TRIGGER_FALLING
flag. But this flag has to be retrieved from device tree instead of hard
coding in the driver, so removing the flag.

Fixes: ff319a644829 ("net: dsa: microchip: move interrupt handling logic from lan937x to ksz_common")
Reported-by: Christian Eggers <ceggers@arri.de>
Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
---
 drivers/net/dsa/microchip/ksz_common.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index d612181b3226..c68f48cd1ec0 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -1883,8 +1883,7 @@ static int ksz_irq_common_setup(struct ksz_device *dev, struct ksz_irq *kirq)
 		irq_create_mapping(kirq->domain, n);
 
 	ret = request_threaded_irq(kirq->irq_num, NULL, ksz_irq_thread_fn,
-				   IRQF_ONESHOT | IRQF_TRIGGER_FALLING,
-				   kirq->name, kirq);
+				   IRQF_ONESHOT, kirq->name, kirq);
 	if (ret)
 		goto out;
 

base-commit: e095493091e850d5292ad01d8fbf5cde1d89ac53
-- 
2.36.1

