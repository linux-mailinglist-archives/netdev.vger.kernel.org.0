Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62C6F532366
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 08:41:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230269AbiEXGlX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 02:41:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229945AbiEXGlV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 02:41:21 -0400
Received: from mail.meizu.com (edge07.meizu.com [112.91.151.210])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DDC21836E;
        Mon, 23 May 2022 23:41:18 -0700 (PDT)
Received: from IT-EXMB-1-125.meizu.com (172.16.1.125) by mz-mail11.meizu.com
 (172.16.1.15) with Microsoft SMTP Server (TLS) id 14.3.487.0; Tue, 24 May
 2022 14:41:13 +0800
Received: from meizu.meizu.com (172.16.137.70) by IT-EXMB-1-125.meizu.com
 (172.16.1.125) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.14; Tue, 24 May
 2022 14:41:10 +0800
From:   Haowen Bai <baihaowen@meizu.com>
To:     Veerasenareddy Burru <vburru@marvell.com>,
        Abhijit Ayarekar <aayarekar@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Haowen Bai <baihaowen@meizu.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH V3] octeon_ep: Remove unnecessary cast
Date:   Tue, 24 May 2022 14:41:08 +0800
Message-ID: <1653374469-30555-1-git-send-email-baihaowen@meizu.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.16.137.70]
X-ClientProxiedBy: IT-EXMB-1-126.meizu.com (172.16.1.126) To
 IT-EXMB-1-125.meizu.com (172.16.1.125)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

./drivers/net/ethernet/marvell/octeon_ep/octep_rx.c:161:18-40: WARNING:
casting value returned by memory allocation function to (struct
octep_rx_buffer *) is useless.

and we do more optimization:
1. remove casting value
2. use obvious size
3. use kvcalloc instead of vzalloc

Signed-off-by: Haowen Bai <baihaowen@meizu.com>
---
V1->V2: change vzalloc to vcalloc as suggestion.
V2->V3: use obvious size; use kvcalloc instead of vzalloc.

 drivers/net/ethernet/marvell/octeon_ep/octep_rx.c | 8 ++++----
 drivers/net/ethernet/marvell/octeon_ep/octep_rx.h | 2 --
 2 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_rx.c b/drivers/net/ethernet/marvell/octeon_ep/octep_rx.c
index d9ae0937d17a..d6a0da61db44 100644
--- a/drivers/net/ethernet/marvell/octeon_ep/octep_rx.c
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_rx.c
@@ -158,8 +158,8 @@ static int octep_setup_oq(struct octep_device *oct, int q_no)
 		goto desc_dma_alloc_err;
 	}
 
-	oq->buff_info = (struct octep_rx_buffer *)
-			vzalloc(oq->max_count * OCTEP_OQ_RECVBUF_SIZE);
+	oq->buff_info = kvcalloc(oq->max_count, sizeof(struct octep_rx_buffer),
+				 GFP_KERNEL);
 	if (unlikely(!oq->buff_info)) {
 		dev_err(&oct->pdev->dev,
 			"Failed to allocate buffer info for OQ-%d\n", q_no);
@@ -176,7 +176,7 @@ static int octep_setup_oq(struct octep_device *oct, int q_no)
 	return 0;
 
 oq_fill_buff_err:
-	vfree(oq->buff_info);
+	kvfree(oq->buff_info);
 	oq->buff_info = NULL;
 buf_list_err:
 	dma_free_coherent(oq->dev, desc_ring_size,
@@ -230,7 +230,7 @@ static int octep_free_oq(struct octep_oq *oq)
 
 	octep_oq_free_ring_buffers(oq);
 
-	vfree(oq->buff_info);
+	kvfree(oq->buff_info);
 
 	if (oq->desc_ring)
 		dma_free_coherent(oq->dev,
diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_rx.h b/drivers/net/ethernet/marvell/octeon_ep/octep_rx.h
index 782a24f27f3e..34a32d95cd4b 100644
--- a/drivers/net/ethernet/marvell/octeon_ep/octep_rx.h
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_rx.h
@@ -67,8 +67,6 @@ struct octep_rx_buffer {
 	u64 len;
 };
 
-#define OCTEP_OQ_RECVBUF_SIZE    (sizeof(struct octep_rx_buffer))
-
 /* Output Queue statistics. Each output queue has four stats fields. */
 struct octep_oq_stats {
 	/* Number of packets received from the Device. */
-- 
2.7.4

