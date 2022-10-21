Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0912C60732F
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 11:03:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230406AbiJUJDG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 05:03:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230230AbiJUJDD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 05:03:03 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE7C02527C6;
        Fri, 21 Oct 2022 02:03:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1666342983; x=1697878983;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=xgDHZDyzvlvCXScq/7p55/MCpFwOFhGPVzkOBo9ENoM=;
  b=zGkDplqS6/k9ahwkk2WeTliotPyYliCuLqNt898fYms6xuJax7YYhK3S
   iFNosXf3XvmgTE76n39EO105pZCQ9Y4T8lqaL+M/BPHuDIq8yP3PdKxYg
   wVLAwBQEg4Gj8yooPHk7F0duCQmnFxqi35xLaX92bUtQRFu5Kv98bwQv0
   pZ/1ab9L/aFaKaX7shtsybNXsyLeQZNp+aW4wA9Mli9sOC59XbNf6M1I4
   JRe8kK73xcSKpJYaJOWcd6PIqYMsydyYub039B0UfKeh6K5Pzjrw1NrR4
   4OkAnx4Y0KYmkkDwhPeFfxQbqWR0dFhGN4U7yJzOCm02oK3gw2KUIh4HB
   A==;
X-IronPort-AV: E=Sophos;i="5.95,200,1661842800"; 
   d="scan'208";a="179906665"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 21 Oct 2022 02:03:01 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Fri, 21 Oct 2022 02:03:00 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Fri, 21 Oct 2022 02:02:58 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <UNGLinuxDriver@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net] net: lan966x: Stop replacing tx dcbs and dcbs_buf when changing MTU
Date:   Fri, 21 Oct 2022 11:07:11 +0200
Message-ID: <20221021090711.3749009-1-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.38.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a frame is sent using FDMA, the skb is mapped and then the mapped
address is given to an tx dcb that is different than the last used tx
dcb. Once the HW finish with this frame, it would generate an interrupt
and then the dcb can be reused and memory can be freed. For each dcb
there is an dcb buf that contains some meta-data(is used by PTP, is
it free). There is 1 to 1 relationship between dcb and dcb_buf.
The following issue was observed. That sometimes after changing the MTU
to allocate new tx dcbs and dcbs_buf, two frames were not
transmitted. The frames were not transmitted because when reloading the
tx dcbs, it was always presuming to use the first dcb but that was not
always happening. Because it could be that the last tx dcb used before
changing MTU was first dcb and then when it tried to get the next dcb it
would take dcb 1 instead of 0. Because it is supposed to take a
different dcb than the last used one. This can be fixed simply by
changing tx->last_in_use to -1 when the fdma is disabled to reload the
new dcb and dcbs_buff.
But there could be a different issue. For example, right after the frame
is sent, the MTU is changed. Now all the dcbs and dcbs_buf will be
cleared. And now get the interrupt from HW that it finished with the
frame. So when we try to clear the skb, it is not possible because we
lost all the dcbs_buf.
The solution here is to stop replacing the tx dcbs and dcbs_buf when
changing MTU because the TX doesn't care what is the MTU size, it is
only the RX that needs this information.

Fixes: 2ea1cbac267e ("net: lan966x: Update FDMA to change MTU.")
Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 .../ethernet/microchip/lan966x/lan966x_fdma.c | 24 +++----------------
 1 file changed, 3 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c b/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
index 7e4061c854f0e..a42035cec611c 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
@@ -309,6 +309,7 @@ static void lan966x_fdma_tx_disable(struct lan966x_tx *tx)
 		lan966x, FDMA_CH_DB_DISCARD);
 
 	tx->activated = false;
+	tx->last_in_use = -1;
 }
 
 static void lan966x_fdma_tx_reload(struct lan966x_tx *tx)
@@ -687,17 +688,14 @@ static int lan966x_qsys_sw_status(struct lan966x *lan966x)
 
 static int lan966x_fdma_reload(struct lan966x *lan966x, int new_mtu)
 {
-	void *rx_dcbs, *tx_dcbs, *tx_dcbs_buf;
-	dma_addr_t rx_dma, tx_dma;
+	dma_addr_t rx_dma;
+	void *rx_dcbs;
 	u32 size;
 	int err;
 
 	/* Store these for later to free them */
 	rx_dma = lan966x->rx.dma;
-	tx_dma = lan966x->tx.dma;
 	rx_dcbs = lan966x->rx.dcbs;
-	tx_dcbs = lan966x->tx.dcbs;
-	tx_dcbs_buf = lan966x->tx.dcbs_buf;
 
 	napi_synchronize(&lan966x->napi);
 	napi_disable(&lan966x->napi);
@@ -715,17 +713,6 @@ static int lan966x_fdma_reload(struct lan966x *lan966x, int new_mtu)
 	size = ALIGN(size, PAGE_SIZE);
 	dma_free_coherent(lan966x->dev, size, rx_dcbs, rx_dma);
 
-	lan966x_fdma_tx_disable(&lan966x->tx);
-	err = lan966x_fdma_tx_alloc(&lan966x->tx);
-	if (err)
-		goto restore_tx;
-
-	size = sizeof(struct lan966x_tx_dcb) * FDMA_DCB_MAX;
-	size = ALIGN(size, PAGE_SIZE);
-	dma_free_coherent(lan966x->dev, size, tx_dcbs, tx_dma);
-
-	kfree(tx_dcbs_buf);
-
 	lan966x_fdma_wakeup_netdev(lan966x);
 	napi_enable(&lan966x->napi);
 
@@ -735,11 +722,6 @@ static int lan966x_fdma_reload(struct lan966x *lan966x, int new_mtu)
 	lan966x->rx.dcbs = rx_dcbs;
 	lan966x_fdma_rx_start(&lan966x->rx);
 
-restore_tx:
-	lan966x->tx.dma = tx_dma;
-	lan966x->tx.dcbs = tx_dcbs;
-	lan966x->tx.dcbs_buf = tx_dcbs_buf;
-
 	return err;
 }
 
-- 
2.38.0

