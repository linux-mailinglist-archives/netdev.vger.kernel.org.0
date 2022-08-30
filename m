Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BF5C5A6137
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 12:54:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229959AbiH3Kxf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 06:53:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229875AbiH3Kxd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 06:53:33 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AF4A61B3C;
        Tue, 30 Aug 2022 03:53:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1661856811; x=1693392811;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=3JtcZwD8ykfZwltMBZg2Y5mHojyWHZBx52LH+LqU5qU=;
  b=i9Iq2HTPW9om5KJ41RLiywtBmNGflLfPq2Pmq2kHVgel4j/pJnuAtSKH
   36P/BIaaReJwiP/BrbfqtBpCFChSjdeU0mpj+Nbo1oRG/lAYqU5LMtG7M
   kRMmxh3slbemT8IXaEgiZnfm68UF+YJRyOO6HISLHFOhx1jNWeW1mJ50B
   xC2SdJnn+Iw/ngalDuEqomqnd2uHDc8/XGEsEr2sa6uxlcNrhaosJbwQy
   ncyaK0OUZOm8sS81ZLN9W9FipbH//7KBGVFnH1s817jGXgSmpFzVTui4c
   L3bT/xOLp1ieYXWfbADrpOns7+zOTm9bSJ7p18tUcfPXNnS0uiCgQKIiW
   g==;
X-IronPort-AV: E=Sophos;i="5.93,274,1654585200"; 
   d="scan'208";a="188626311"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 30 Aug 2022 03:53:30 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Tue, 30 Aug 2022 03:53:29 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Tue, 30 Aug 2022 03:53:24 -0700
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
Subject: [RFC Patch net-next v3 1/3] net: dsa: microchip: use dev_ops->reset instead of exit in ksz_switch_register
Date:   Tue, 30 Aug 2022 16:23:01 +0530
Message-ID: <20220830105303.22067-2-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220830105303.22067-1-arun.ramadoss@microchip.com>
References: <20220830105303.22067-1-arun.ramadoss@microchip.com>
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

ksz8_switch_exit, ksz9477_switch_exit and lan937x_switch_exit functions
all call the reset function which is assigned to dev_ops->reset hooks.
So instead of calling the dev_ops->exit in ksz_switch_register during
the error condition of dsa_register_switch, dev_ops->reset is used now.
The dev_ops->exit can be extended in lan937x for freeing up the irq
during the ksz_spi_remove. If we add the irq remove in the exit function
and it is called during the dsa_switch_register error condition, kernel
panic happens since irq is setup only in setup operation. To avoid the
kernel panic, dev_ops->reset is used instead of exit.

Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
---
 drivers/net/dsa/microchip/ksz_common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 6bd69a7e6809..da9bdf753f7a 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -1963,7 +1963,7 @@ int ksz_switch_register(struct ksz_device *dev)
 
 	ret = dsa_register_switch(dev->ds);
 	if (ret) {
-		dev->dev_ops->exit(dev);
+		dev->dev_ops->reset(dev);
 		return ret;
 	}
 
-- 
2.36.1

