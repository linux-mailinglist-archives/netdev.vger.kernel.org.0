Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE29B5AAC7B
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 12:33:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235764AbiIBKcp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 06:32:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235462AbiIBKci (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 06:32:38 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE33EAEDB7;
        Fri,  2 Sep 2022 03:32:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1662114757; x=1693650757;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fxSuSNbw+Gw3ZVt6tZ2JrFpggo7D69jYFkK70yn9Oo8=;
  b=szNm9sGa9sYsA5dJHjmDDDc0mBYP8Q0J9ioASpvjNLUpdz1+WPD3HC6K
   /gXrTZepnCDwx+iqa+qXK4t50BH1ppXjSYBA61KOfX/8lqjoSa7/gx71v
   IvTafiXe6CgMpdQrfGmVPh3Oo+MnNKWXGDT8x9iwZcP1I7ha4OgW//Qh/
   D9jTGv8LjlygbSOG3fF7iArvssMdbkM+aKWy1tMOqo5vN5TgfoIMu0aRd
   4nAgJ6+mljY2K0M5AC9ZmkKqHVYM0MCg6Bmtp7vzfGrnFOw3b+GtneY7u
   DEoXw5LYLBlkt4yAFvNAspPmabAJLbeOxOKMgi+9EnqqLWySdFyr8yQx2
   Q==;
X-IronPort-AV: E=Sophos;i="5.93,283,1654585200"; 
   d="scan'208";a="175358363"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 02 Sep 2022 03:32:36 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Fri, 2 Sep 2022 03:32:36 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Fri, 2 Sep 2022 03:32:31 -0700
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
Subject: [Patch net-next 2/3] net: dsa: microchip: lan937x: clear the POR_READY_INT status bit
Date:   Fri, 2 Sep 2022 16:02:09 +0530
Message-ID: <20220902103210.10743-3-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220902103210.10743-1-arun.ramadoss@microchip.com>
References: <20220902103210.10743-1-arun.ramadoss@microchip.com>
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

In the lan937x_reset_switch(), it masks all the switch and port
registers. In the Global_Int_status register, POR ready bit is write 1
to clear bit and all other bits are read only. So, this patch clear the
por_ready_int status bit by writing 1.

Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
---
 drivers/net/dsa/microchip/lan937x_main.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/dsa/microchip/lan937x_main.c b/drivers/net/dsa/microchip/lan937x_main.c
index 7b464f1fb5d8..0466c4d0b10c 100644
--- a/drivers/net/dsa/microchip/lan937x_main.c
+++ b/drivers/net/dsa/microchip/lan937x_main.c
@@ -225,6 +225,10 @@ int lan937x_reset_switch(struct ksz_device *dev)
 	if (ret < 0)
 		return ret;
 
+	ret = ksz_write32(dev, REG_SW_INT_STATUS__4, POR_READY_INT);
+	if (ret < 0)
+		return ret;
+
 	ret = ksz_write32(dev, REG_SW_PORT_INT_MASK__4, 0xFF);
 	if (ret < 0)
 		return ret;
-- 
2.36.1

