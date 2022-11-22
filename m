Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2172634987
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 22:42:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234983AbiKVVkT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 16:40:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235087AbiKVVkN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 16:40:13 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D43B5C6072;
        Tue, 22 Nov 2022 13:40:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1669153206; x=1700689206;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=q0Sn23Y5RcrLJJSzqjsvSLaJWPYpAiItTX0oz16kJUE=;
  b=pqc2GIYTKpBB5B1xae98Y2zPPjw+wYC/u8qtI+oYhnN+pXysSGpkC2aa
   KiNw5w6ypLKTQ5E7ZDYjU+aN9ceLR/cbS6zekZGdnnhbYuGd3UvRNoC5A
   UB6lyYdOnCKaEkajtCO5DR++H635ME5a4F/h9Iao75PUxcmjAI7YrfKe8
   5xe3gewEvYNguhgRLXzkLYN/1PwdTuzrdPHK0MffQjBc2LEozXh6R5Nww
   Z+1A62SfIV8FBEuu0Kb94rr/HYS6uo2+8AU6KUFn+FOlaFEbWNVyCgIdi
   QGvkSLJVgf3XpHh9RUzzJLHbHODabpAXom929jPDWhEIM9NhBqb3/RlgS
   g==;
X-IronPort-AV: E=Sophos;i="5.96,185,1665471600"; 
   d="scan'208";a="184748246"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 22 Nov 2022 14:40:06 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Tue, 22 Nov 2022 14:40:02 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Tue, 22 Nov 2022 14:40:00 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <bpf@vger.kernel.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <hawk@kernel.org>, <john.fastabend@gmail.com>,
        <alexandr.lobakin@intel.com>, <UNGLinuxDriver@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v4 3/7] net: lan966x: Add len field to lan966x_tx_dcb_buf
Date:   Tue, 22 Nov 2022 22:44:09 +0100
Message-ID: <20221122214413.3446006-4-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221122214413.3446006-1-horatiu.vultur@microchip.com>
References: <20221122214413.3446006-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,T_SPF_TEMPERROR autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently when a frame was transmitted, it is required to unamp the
frame that was transmitted. The length of the frame was taken from the
transmitted skb. In the future we might not have an skb, therefore store
the length skb directly in the lan966x_tx_dcb_buf and use this one to
unamp the frame.
While at this, also arrange the members in lan966x_tx_dcb_buf not to
have any holes.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c | 5 +++--
 drivers/net/ethernet/microchip/lan966x/lan966x_main.h | 7 ++++---
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c b/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
index 94c720e59caee..384ed34197d58 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
@@ -391,12 +391,12 @@ static void lan966x_fdma_tx_clear_buf(struct lan966x *lan966x, int weight)
 			continue;
 
 		dcb_buf->dev->stats.tx_packets++;
-		dcb_buf->dev->stats.tx_bytes += dcb_buf->skb->len;
+		dcb_buf->dev->stats.tx_bytes += dcb_buf->len;
 
 		dcb_buf->used = false;
 		dma_unmap_single(lan966x->dev,
 				 dcb_buf->dma_addr,
-				 dcb_buf->skb->len,
+				 dcb_buf->len,
 				 DMA_TO_DEVICE);
 		if (!dcb_buf->ptp)
 			dev_kfree_skb_any(dcb_buf->skb);
@@ -709,6 +709,7 @@ int lan966x_fdma_xmit(struct sk_buff *skb, __be32 *ifh, struct net_device *dev)
 	/* Fill up the buffer */
 	next_dcb_buf = &tx->dcbs_buf[next_to_use];
 	next_dcb_buf->skb = skb;
+	next_dcb_buf->len = skb->len;
 	next_dcb_buf->dma_addr = dma_addr;
 	next_dcb_buf->used = true;
 	next_dcb_buf->ptp = false;
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
index bc93051aa0798..c762e3732f88f 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
@@ -173,11 +173,12 @@ struct lan966x_rx {
 };
 
 struct lan966x_tx_dcb_buf {
+	dma_addr_t dma_addr;
 	struct net_device *dev;
 	struct sk_buff *skb;
-	dma_addr_t dma_addr;
-	bool used;
-	bool ptp;
+	u32 len;
+	u32 used : 1;
+	u32 ptp : 1;
 };
 
 struct lan966x_tx {
-- 
2.38.0

