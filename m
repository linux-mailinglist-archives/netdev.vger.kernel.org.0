Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77B17520FEC
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 10:45:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238172AbiEJItS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 04:49:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238181AbiEJItI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 04:49:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4A64F2A2F7B
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 01:45:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652172309;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5nF7F3ee/5LY1wxs6YA0/kK8PunSr1381xwJrQb044o=;
        b=fVdAW/b+PeS6+H9/OFIhmfhQOoE6OJhy96FM82uKzWtY64hxR5owITyOq3zQVrvCvxrTw8
        5uDUKi/nPpr6jRROnPaBJd/n/srOGDo3Wq8RT1Ot0LPxGFA7Q8td5k553IhhYTJ5IPWsU/
        Qv0Ia1S7nnB01SWPb04TCpb2TLzRldo=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-73-Lh9ibqnGPzeyA_J3MYlXJw-1; Tue, 10 May 2022 04:45:05 -0400
X-MC-Unique: Lh9ibqnGPzeyA_J3MYlXJw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8BC331C08962;
        Tue, 10 May 2022 08:45:04 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.180])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D47FB413721;
        Tue, 10 May 2022 08:45:02 +0000 (UTC)
From:   =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>
To:     ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com,
        ap420073@gmail.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>
Subject: [PATCH net-next 4/5] sfc: refactor efx_set_xdp_tx_queues
Date:   Tue, 10 May 2022 10:44:42 +0200
Message-Id: <20220510084443.14473-5-ihuguet@redhat.com>
In-Reply-To: <20220510084443.14473-1-ihuguet@redhat.com>
References: <20220510084443.14473-1-ihuguet@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Refactor this code to make easier to follow what's going on there and to
show the intent of the code more clearly.

No functional changes.

Signed-off-by: Íñigo Huguet <ihuguet@redhat.com>
---
 drivers/net/ethernet/sfc/efx_channels.c | 65 ++++++++++---------------
 1 file changed, 27 insertions(+), 38 deletions(-)

diff --git a/drivers/net/ethernet/sfc/efx_channels.c b/drivers/net/ethernet/sfc/efx_channels.c
index 1c05063a7215..f6634faa1ec4 100644
--- a/drivers/net/ethernet/sfc/efx_channels.c
+++ b/drivers/net/ethernet/sfc/efx_channels.c
@@ -781,17 +781,18 @@ static inline int efx_alloc_xdp_tx_queues(struct efx_nic *efx)
 }
 
 /* Assign a tx queue to one CPU for XDP_TX action */
-static int efx_set_xdp_tx_queue(struct efx_nic *efx, int xdp_queue_number,
-				struct efx_tx_queue *tx_queue)
+static inline int efx_set_xdp_tx_queue(struct efx_nic *efx, int cpu,
+				       struct efx_tx_queue *tx_queue)
 {
-	if (xdp_queue_number >= efx->xdp_tx_queue_count)
+	if (cpu >= efx->xdp_tx_queue_count)
 		return -EINVAL;
 
 	netif_dbg(efx, drv, efx->net_dev,
 		  "Channel %u TXQ %u is XDP %u, HW %u\n",
 		  tx_queue->channel->channel, tx_queue->label,
-		  xdp_queue_number, tx_queue->queue);
-	efx->xdp_tx_queues[xdp_queue_number] = tx_queue;
+		  cpu, tx_queue->queue);
+
+	efx->xdp_tx_queues[cpu] = tx_queue;
 	return 0;
 }
 
@@ -803,49 +804,37 @@ static void efx_set_xdp_tx_queues(struct efx_nic *efx)
 {
 	struct efx_tx_queue *tx_queue;
 	struct efx_channel *channel;
-	unsigned int next_queue = 0;
-	int xdp_queue_number = 0;
-	int rc;
-
-	efx_for_each_channel(channel, efx) {
-		if (channel->channel < efx->tx_channel_offset)
-			continue;
-
-		if (efx_channel_is_xdp_tx(channel)) {
+	unsigned int queue_num, cpu;
+
+	cpu = 0;
+	if (efx->xdp_txq_queues_mode == EFX_XDP_TX_QUEUES_BORROWED) {
+		efx_for_each_tx_channel(channel, efx) {
+			/* borrow first channel's queue, with no csum offload */
+			if (efx_set_xdp_tx_queue(efx, cpu, &channel->tx_queue[0]) == 0)
+				cpu++;
+		}
+	} else {
+		efx_for_each_xdp_channel(channel, efx) {
 			efx_for_each_channel_tx_queue(tx_queue, channel) {
-				rc = efx_set_xdp_tx_queue(efx, xdp_queue_number,
-							  tx_queue);
-				if (rc == 0)
-					xdp_queue_number++;
+				if (efx_set_xdp_tx_queue(efx, cpu, tx_queue) == 0)
+					cpu++;
 			}
-		} else if (efx->xdp_txq_queues_mode == EFX_XDP_TX_QUEUES_BORROWED) {
-
-			/* If XDP is borrowing queues from net stack, it must
-			 * use the queue with no csum offload, which is the
-			 * first one of the channel
-			 * (note: tx_queue_by_type is not initialized yet)
-			 */
-			tx_queue = &channel->tx_queue[0];
-			rc = efx_set_xdp_tx_queue(efx, xdp_queue_number,
-						  tx_queue);
-			if (rc == 0)
-				xdp_queue_number++;
 		}
 	}
+
 	WARN_ON(efx->xdp_txq_queues_mode == EFX_XDP_TX_QUEUES_DEDICATED &&
-		xdp_queue_number != efx->xdp_tx_queue_count);
+		cpu != efx->xdp_tx_queue_count);
 	WARN_ON(efx->xdp_txq_queues_mode != EFX_XDP_TX_QUEUES_DEDICATED &&
-		xdp_queue_number > efx->xdp_tx_queue_count);
+		cpu > efx->xdp_tx_queue_count);
 
 	/* If we have more CPUs than assigned XDP TX queues, assign the already
 	 * existing queues to the exceeding CPUs
 	 */
-	next_queue = 0;
-	while (xdp_queue_number < efx->xdp_tx_queue_count) {
-		tx_queue = efx->xdp_tx_queues[next_queue++];
-		rc = efx_set_xdp_tx_queue(efx, xdp_queue_number, tx_queue);
-		if (rc == 0)
-			xdp_queue_number++;
+	queue_num = 0;
+	while (cpu < efx->xdp_tx_queue_count) {
+		tx_queue = efx->xdp_tx_queues[queue_num++];
+		if (efx_set_xdp_tx_queue(efx, cpu, tx_queue) == 0)
+			cpu++;
 	}
 }
 
-- 
2.34.1

