Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AC23523F00
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 22:37:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347850AbiEKUhm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 16:37:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347555AbiEKUhl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 16:37:41 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9B1E2BB03;
        Wed, 11 May 2022 13:37:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1652301458; x=1683837458;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=ct8k43enuOkoow9AJvOHfRIKrB74EgiEykFuu2k4yEo=;
  b=OYQJXxRh/V5zLB+jxDp3B4M3PD4CC53OpW6LI9/cd4vRtN9fxUtH0PoF
   4J9+X5BQaSC4ZdxYEO0KSihSXdtVN1vLw7i9RWVoHmiTYfhEUZdR643g4
   vM6S3giX5rZgrLwwmqucVFTKHXB4tc3Rk4fp0vM2XrgAlGIzPceLWafuM
   KCjMYgDTqIpyc7ZbNSFX2yj2I4ylbj3bubdB+uGj2OUdMjgEo7Jb00oLB
   5FrPkwDAN4bWCoa+xd8XKr/GX2DX5mNVp/rcm1M3Y0dTD0EzWRwLoQVwd
   LO2edNqEAyRBmbQkDMQJFODlqFtXq3aZfRsqHHRUCSZ0A6hE7R15oBVm/
   Q==;
X-IronPort-AV: E=Sophos;i="5.91,218,1647327600"; 
   d="scan'208";a="95415885"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 11 May 2022 13:37:37 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Wed, 11 May 2022 13:37:37 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Wed, 11 May 2022 13:37:35 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <UNGLinuxDriver@microchip.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH net-next] net: lan966x: Fix use of pointer after being freed
Date:   Wed, 11 May 2022 22:40:59 +0200
Message-ID: <20220511204059.2689199-1-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The smatch found the following warning:

drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c:736 lan966x_fdma_reload()
warn: 'rx_dcbs' was already freed.

This issue can happen when changing the MTU on one of the ports and once
the RX buffers are allocated and then the TX buffer allocation fails.
In that case the RX buffers should not be restore. This fix this issue
such that the RX buffers will not be restored if the TX buffers failed
to be allocated.

Fixes: 2ea1cbac267e2a ("net: lan966x: Update FDMA to change MTU.")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c b/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
index 9e2a7323eaf0..6dea7f8c1481 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
@@ -729,11 +729,11 @@ static int lan966x_fdma_reload(struct lan966x *lan966x, int new_mtu)
 	return err;
 restore:
 	lan966x->rx.dma = rx_dma;
-	lan966x->tx.dma = tx_dma;
+	lan966x->rx.dcbs = rx_dcbs;
 	lan966x_fdma_rx_start(&lan966x->rx);
 
 restore_tx:
-	lan966x->rx.dcbs = rx_dcbs;
+	lan966x->tx.dma = tx_dma;
 	lan966x->tx.dcbs = tx_dcbs;
 	lan966x->tx.dcbs_buf = tx_dcbs_buf;
 
-- 
2.33.0

