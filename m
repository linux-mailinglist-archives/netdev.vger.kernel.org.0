Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF0F359CAF7
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 23:40:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237823AbiHVVjj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 17:39:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237803AbiHVVji (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 17:39:38 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C074652097;
        Mon, 22 Aug 2022 14:39:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1661204375; x=1692740375;
  h=from:to:subject:date:message-id:mime-version;
  bh=ZrNeU8CEeIl3AZc1VJMb4npC0a4B7n74iwOT/dV4tiA=;
  b=1UIoy1rZmEVyUGihuaoN4hIXY7FbrfX7sHcJfiQLhtl3XZQ0R39tL+S8
   8bvZ16uECMXjJmeekQVB5yWQduUsuhAU5q8kqiDB6RsHHD5rfgS+c7cmb
   J45awJC3G2KhcTs00TJFjXpTDs2txbqUszplMQ8tn7tWz+G5XOZXVjuur
   0ty5Zp8nsdt81ueTfXLGeqcQnNwluVaZJbQr0euN/qHHIFUZmbfqPakec
   rNYpJRUOHF5G0/0ALw3usVA46DKJUP80UNbN/Re4fN7laWx8ThMZMo9Yd
   Nrp+xzVfj4NmhAywzS4YGtSGnSSPEk+GiANFMrQ7wYTRH7pJv9WsltA6K
   Q==;
X-IronPort-AV: E=Sophos;i="5.93,255,1654585200"; 
   d="scan'208";a="187595698"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 22 Aug 2022 14:39:35 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Mon, 22 Aug 2022 14:39:34 -0700
Received: from AUS-LT-C33025.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Mon, 22 Aug 2022 14:39:33 -0700
From:   Jerry Ray <jerry.ray@microchip.com>
To:     "David S . Miller " <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jerry Ray <jerry.ray@microchip.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <UNGLinuxDriver@microchip.com>
Subject: [PATCH] micrel: ksz8851: fixes struct pointer issue
Date:   Mon, 22 Aug 2022 16:39:32 -0500
Message-ID: <20220822213932.12848-1-jerry.ray@microchip.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
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

Issue found during code review. This bug has no impact as long as the
ks8851_net structure is the first element of the ks8851_net_spi structure.
As long as the offset to the ks8851_net struct is zero, the container_of()
macro is subtracting 0 and therefore no damage done. But if the
ks8851_net_spi struct is ever modified such that the ks8851_net struct
within it is no longer the first element of the struct, then the bug would
manifest itself and cause problems.

struct ks8851_net is contained within ks8851_net_spi.
ks is contained within kss.
kss is the priv_data of the netdev structure.

Signed-off-by: Jerry Ray <jerry.ray@microchip.com>
---
 drivers/net/ethernet/micrel/ks8851_spi.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/micrel/ks8851_spi.c b/drivers/net/ethernet/micrel/ks8851_spi.c
index 479406ecbaa3..13c76352ae8d 100644
--- a/drivers/net/ethernet/micrel/ks8851_spi.c
+++ b/drivers/net/ethernet/micrel/ks8851_spi.c
@@ -413,7 +413,8 @@ static int ks8851_probe_spi(struct spi_device *spi)
 
 	spi->bits_per_word = 8;
 
-	ks = netdev_priv(netdev);
+	kss = netdev_priv(netdev);
+	ks = &kss->ks8851;
 
 	ks->lock = ks8851_lock_spi;
 	ks->unlock = ks8851_unlock_spi;
@@ -433,8 +434,6 @@ static int ks8851_probe_spi(struct spi_device *spi)
 		 IRQ_RXPSI)	/* RX process stop */
 	ks->rc_ier = STD_IRQ;
 
-	kss = to_ks8851_spi(ks);
-
 	kss->spidev = spi;
 	mutex_init(&kss->lock);
 	INIT_WORK(&kss->tx_work, ks8851_tx_work);
-- 
2.17.1

