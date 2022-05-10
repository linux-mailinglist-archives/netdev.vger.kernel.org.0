Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2B0A520FE9
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 10:45:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238178AbiEJItG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 04:49:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238172AbiEJItD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 04:49:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 56EF02A2F7B
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 01:45:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652172306;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Imw52/oNdQSoSXzpgws3ep9t+R90M7Leua7GRrni830=;
        b=Tjcn1DBxlLRXQnzRopKuRko44YXuX81PevShhI00hsOBvsBW4cB0f6c+DFIzHC1nVnnOBx
        oZkf8mTZ/tS1abg2/58rFdBV/ipK3mA4mtMkgum5HAlAbvxRccgz+uE+2JacurP7uGkH9Z
        mtRvISuBKZe677kot8I3R2AlNGrRzYM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-630-PtKLByhAN3y2BKEJvP3mZg-1; Tue, 10 May 2022 04:45:01 -0400
X-MC-Unique: PtKLByhAN3y2BKEJvP3mZg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8B2DD86B8AC;
        Tue, 10 May 2022 08:45:00 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.180])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D90FF413721;
        Tue, 10 May 2022 08:44:58 +0000 (UTC)
From:   =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>
To:     ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com,
        ap420073@gmail.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>
Subject: [PATCH net-next 2/5] sfc: separate channel->tx_queue and efx->xdp_tx_queue mappings
Date:   Tue, 10 May 2022 10:44:40 +0200
Message-Id: <20220510084443.14473-3-ihuguet@redhat.com>
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

Channels that contains tx queues need to determine the mapping of this
queue structures to hw queue numbers. This applies both to all tx
queues, no matter if they are normal tx queues, xdp_tx queues or both at
the same time.

Also, a lookup table to map each cpu to a xdp_tx queue is created,
containing pointers to the xdp_tx queues, that should already be
allocated in one or more channels. This lookup table is global to all
efx_nic structure.

Mappings to hw queues and xdp lookup table creation were done at the
same time in efx_set_channels, but it had a bit messy and not very clear
code. Then, commit 059a47f1da93 ("net: sfc: add missing xdp queue
reinitialization") moved part of that initialization to a separate
function to fix a bug produced because the xdp_tx queues lookup table
was not reinitialized after channels reallocation, leaving it pointing
to deallocated queues. Not all of that initialization needs to be
redone, but only the xdp_tx queues lookup table, and not the mappings to
hw queues. So this resulted in even less clear code.

This patch moves back the part of that code that doesn't need to be
reinitialized. That is, the mapping of tx queues with hw queues numbers.
As a result, xdp queues lookup table creation and this are done in
different places, conforming to single responsibility principle and
resulting in more clear code.

Signed-off-by: Íñigo Huguet <ihuguet@redhat.com>
---
 drivers/net/ethernet/sfc/efx_channels.c | 69 +++++++++++++------------
 1 file changed, 37 insertions(+), 32 deletions(-)

diff --git a/drivers/net/ethernet/sfc/efx_channels.c b/drivers/net/ethernet/sfc/efx_channels.c
index 3f28f9861dfa..8feba80f0a34 100644
--- a/drivers/net/ethernet/sfc/efx_channels.c
+++ b/drivers/net/ethernet/sfc/efx_channels.c
@@ -767,6 +767,19 @@ void efx_remove_channels(struct efx_nic *efx)
 	kfree(efx->xdp_tx_queues);
 }
 
+static inline int efx_alloc_xdp_tx_queues(struct efx_nic *efx)
+{
+	if (efx->xdp_tx_queue_count) {
+		EFX_WARN_ON_PARANOID(efx->xdp_tx_queues);
+		efx->xdp_tx_queues = kcalloc(efx->xdp_tx_queue_count,
+					     sizeof(*efx->xdp_tx_queues),
+					     GFP_KERNEL);
+		if (!efx->xdp_tx_queues)
+			return -ENOMEM;
+	}
+	return 0;
+}
+
 static int efx_set_xdp_tx_queue(struct efx_nic *efx, int xdp_queue_number,
 				struct efx_tx_queue *tx_queue)
 {
@@ -789,44 +802,29 @@ static void efx_set_xdp_channels(struct efx_nic *efx)
 	int xdp_queue_number = 0;
 	int rc;
 
-	/* We need to mark which channels really have RX and TX
-	 * queues, and adjust the TX queue numbers if we have separate
-	 * RX-only and TX-only channels.
-	 */
 	efx_for_each_channel(channel, efx) {
 		if (channel->channel < efx->tx_channel_offset)
 			continue;
 
 		if (efx_channel_is_xdp_tx(channel)) {
 			efx_for_each_channel_tx_queue(tx_queue, channel) {
-				tx_queue->queue = next_queue++;
 				rc = efx_set_xdp_tx_queue(efx, xdp_queue_number,
 							  tx_queue);
 				if (rc == 0)
 					xdp_queue_number++;
 			}
-		} else {
-			efx_for_each_channel_tx_queue(tx_queue, channel) {
-				tx_queue->queue = next_queue++;
-				netif_dbg(efx, drv, efx->net_dev,
-					  "Channel %u TXQ %u is HW %u\n",
-					  channel->channel, tx_queue->label,
-					  tx_queue->queue);
-			}
+		} else if (efx->xdp_txq_queues_mode == EFX_XDP_TX_QUEUES_BORROWED) {
 
 			/* If XDP is borrowing queues from net stack, it must
 			 * use the queue with no csum offload, which is the
 			 * first one of the channel
 			 * (note: tx_queue_by_type is not initialized yet)
 			 */
-			if (efx->xdp_txq_queues_mode ==
-			    EFX_XDP_TX_QUEUES_BORROWED) {
-				tx_queue = &channel->tx_queue[0];
-				rc = efx_set_xdp_tx_queue(efx, xdp_queue_number,
-							  tx_queue);
-				if (rc == 0)
-					xdp_queue_number++;
-			}
+			tx_queue = &channel->tx_queue[0];
+			rc = efx_set_xdp_tx_queue(efx, xdp_queue_number,
+						  tx_queue);
+			if (rc == 0)
+				xdp_queue_number++;
 		}
 	}
 	WARN_ON(efx->xdp_txq_queues_mode == EFX_XDP_TX_QUEUES_DEDICATED &&
@@ -952,31 +950,38 @@ int efx_realloc_channels(struct efx_nic *efx, u32 rxq_entries, u32 txq_entries)
 
 int efx_set_channels(struct efx_nic *efx)
 {
+	struct efx_tx_queue *tx_queue;
 	struct efx_channel *channel;
+	unsigned int queue_num = 0;
 	int rc;
 
 	efx->tx_channel_offset =
 		efx_separate_tx_channels ?
 		efx->n_channels - efx->n_tx_channels : 0;
 
-	if (efx->xdp_tx_queue_count) {
-		EFX_WARN_ON_PARANOID(efx->xdp_tx_queues);
-
-		/* Allocate array for XDP TX queue lookup. */
-		efx->xdp_tx_queues = kcalloc(efx->xdp_tx_queue_count,
-					     sizeof(*efx->xdp_tx_queues),
-					     GFP_KERNEL);
-		if (!efx->xdp_tx_queues)
-			return -ENOMEM;
-	}
-
+	/* We need to mark which channels really have RX and TX queues, and
+	 * adjust the TX queue numbers if we have separate RX/TX only channels.
+	 */
 	efx_for_each_channel(channel, efx) {
 		if (channel->channel < efx->n_rx_channels)
 			channel->rx_queue.core_index = channel->channel;
 		else
 			channel->rx_queue.core_index = -1;
+
+		if (channel->channel >= efx->tx_channel_offset) {
+			efx_for_each_channel_tx_queue(tx_queue, channel) {
+				tx_queue->queue = queue_num++;
+				netif_dbg(efx, drv, efx->net_dev,
+					  "Channel %u TXQ %u is HW %u\n",
+					  channel->channel, tx_queue->label,
+					  tx_queue->queue);
+			}
+		}
 	}
 
+	rc = efx_alloc_xdp_tx_queues(efx);
+	if (rc)
+		return rc;
 	efx_set_xdp_channels(efx);
 
 	rc = netif_set_real_num_tx_queues(efx->net_dev, efx->n_tx_channels);
-- 
2.34.1

