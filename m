Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C45334EC95D
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 18:11:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348646AbiC3QMq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 12:12:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230350AbiC3QMn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 12:12:43 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D5B436143
        for <netdev@vger.kernel.org>; Wed, 30 Mar 2022 09:10:54 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id e5so20840457pls.4
        for <netdev@vger.kernel.org>; Wed, 30 Mar 2022 09:10:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=W2YxiqL0KKgc5ISYdixAcoWCCpMEmvOhwM0Jsq612lA=;
        b=b0ydvxgacHGiLvyob/h/nSD9eTK/FyJBGd3TFQMaz0aYU2iI3YsIeTR5Y6kHvQl5tJ
         dpEauZnMahp0pFlq0Tz6Wu+RvQJwtkJcvAl4JJgC9Z39EpqRulc0TADcKPftXa1LkXrO
         kXxcEdJxsgQ02fvBS67gO3HPLy88gXSZYS33OH0iFZgYt9zaMd9RM9gd+R1tWnf1pZBS
         OEz+xF1AqynOeFBFJka6v2E5arFFQjWLeE11E/pYAay81wDOgcTvomcwri6Qsjzx3wYH
         K2hXfsAq5xGKJilabw1IsOdj/LBaA4OJHtsN35J5B9N7bVykwg0HkSkwQnFoai8x1Ttg
         JIkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=W2YxiqL0KKgc5ISYdixAcoWCCpMEmvOhwM0Jsq612lA=;
        b=qy5MgVM8DENpfi/QQbGSQg3aiCjuuiITmqdReeZ+aH1sEqQKnyZ+UT2JicVuj2Zwd3
         nZXs431bBL84+kiPctpSrpXlK53njEvIW2YFMrMninsI/EI1xGtQXfgDkeNxxKif0RdX
         LrmRMoMQxRWvpJC8e2rrnyCCYUBEM5Ni8mB2cvAeCLdcdicNR8o/Q0Q4fepQfWd4hn2a
         EaL44hLbqG4MCMy3CXcSGov/Q5+ksYrcDWhimi7vAXj1WfBCIbdJwBw6Jb3KEwufpKAn
         BQx4ALHrBGraZlc3FNSqe4Dl5W5cHUINX+rCcJzxizDKqC+Pu7jFIyEl5woKDw/rpCyw
         o80Q==
X-Gm-Message-State: AOAM531ZThF8K7UpEL/0NEMjooUsIXsxXyDboCBRq3nU0NOXCbNXss8a
        Fjswy1AdoIHyANTMMoRiy9g=
X-Google-Smtp-Source: ABdhPJzBeSeVl9SfQ5Uh7hsUUMsOOeHab5AwqokWOT9z2tm+zgip/FgGIvslbLU+/E+FQtG7JGjFXA==
X-Received: by 2002:a17:90a:3e4e:b0:1c6:586a:4d6a with SMTP id t14-20020a17090a3e4e00b001c6586a4d6amr256928pjm.214.1648656653498;
        Wed, 30 Mar 2022 09:10:53 -0700 (PDT)
Received: from localhost.localdomain ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id o27-20020a63731b000000b0038232af858esm19515047pgc.65.2022.03.30.09.10.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Mar 2022 09:10:52 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, ecree.xilinx@gmail.com,
        habetsm.xilinx@gmail.com, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com,
        cmclachlan@solarflare.com
Cc:     ap420073@gmail.com
Subject: [PATCH net] net: sfc: add missing xdp queue reinitialization
Date:   Wed, 30 Mar 2022 16:10:19 +0000
Message-Id: <20220330161019.5367-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After rx/tx ring buffer size is changed, kernel panic occurs when
it acts XDP_TX or XDP_REDIRECT.

When tx/rx ring buffer size is changed(ethtool -G), sfc driver
reallocates and reinitializes rx and tx queues and their buffers
(tx_queue->buffer).
But it misses reinitializing xdp queues and buffers.
So, while it is acting XDP_TX or XDP_REDIRECT, it uses the uninitialized
tx_queue->buffer.

A new function efx_set_xdp_channels() is separated from efx_set_channels()
to handle only xdp queues.

Splat looks like:
   BUG: kernel NULL pointer dereference, address: 000000000000002a
   #PF: supervisor write access in kernel mode
   #PF: error_code(0x0002) - not-present page
   PGD 0 P4D 0
   Oops: 0002 [#4] PREEMPT SMP NOPTI
   RIP: 0010:efx_tx_map_chunk+0x54/0x90 [sfc]
   CPU: 2 PID: 0 Comm: swapper/2 Tainted: G      D           5.17.0+ #55 e8beeee8289528f11357029357cf
   Code: 48 8b 8d a8 01 00 00 48 8d 14 52 4c 8d 2c d0 44 89 e0 48 85 c9 74 0e 44 89 e2 4c 89 f6 48 80
   RSP: 0018:ffff92f121e45c60 EFLAGS: 00010297
   RIP: 0010:efx_tx_map_chunk+0x54/0x90 [sfc]
   RAX: 0000000000000040 RBX: ffff92ea506895c0 RCX: ffffffffc0330870
   RDX: 0000000000000001 RSI: 00000001139b10ce RDI: ffff92ea506895c0
   RBP: ffffffffc0358a80 R08: 00000001139b110d R09: 0000000000000000
   R10: 0000000000000001 R11: ffff92ea414c0088 R12: 0000000000000040
   R13: 0000000000000018 R14: 00000001139b10ce R15: ffff92ea506895c0
   FS:  0000000000000000(0000) GS:ffff92f121ec0000(0000) knlGS:0000000000000000
   CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
   Code: 48 8b 8d a8 01 00 00 48 8d 14 52 4c 8d 2c d0 44 89 e0 48 85 c9 74 0e 44 89 e2 4c 89 f6 48 80
   CR2: 000000000000002a CR3: 00000003e6810004 CR4: 00000000007706e0
   RSP: 0018:ffff92f121e85c60 EFLAGS: 00010297
   PKRU: 55555554
   RAX: 0000000000000040 RBX: ffff92ea50689700 RCX: ffffffffc0330870
   RDX: 0000000000000001 RSI: 00000001145a90ce RDI: ffff92ea50689700
   RBP: ffffffffc0358a80 R08: 00000001145a910d R09: 0000000000000000
   R10: 0000000000000001 R11: ffff92ea414c0088 R12: 0000000000000040
   R13: 0000000000000018 R14: 00000001145a90ce R15: ffff92ea50689700
   FS:  0000000000000000(0000) GS:ffff92f121e80000(0000) knlGS:0000000000000000
   CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
   CR2: 000000000000002a CR3: 00000003e6810005 CR4: 00000000007706e0
   PKRU: 55555554
   Call Trace:
    <IRQ>
    efx_xdp_tx_buffers+0x12b/0x3d0 [sfc 84c94b8e32d44d296c17e10a634d3ad454de4ba5]
    __efx_rx_packet+0x5c3/0x930 [sfc 84c94b8e32d44d296c17e10a634d3ad454de4ba5]
    efx_rx_packet+0x28c/0x2e0 [sfc 84c94b8e32d44d296c17e10a634d3ad454de4ba5]
    efx_ef10_ev_process+0x5f8/0xf40 [sfc 84c94b8e32d44d296c17e10a634d3ad454de4ba5]
    ? enqueue_task_fair+0x95/0x550
    efx_poll+0xc4/0x360 [sfc 84c94b8e32d44d296c17e10a634d3ad454de4ba5]

Fixes: 3990a8fffbda ("sfc: allocate channels for XDP tx queues")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/ethernet/sfc/efx_channels.c | 147 +++++++++++++-----------
 1 file changed, 82 insertions(+), 65 deletions(-)

diff --git a/drivers/net/ethernet/sfc/efx_channels.c b/drivers/net/ethernet/sfc/efx_channels.c
index d6fdcdc530ca..271f3bdfc141 100644
--- a/drivers/net/ethernet/sfc/efx_channels.c
+++ b/drivers/net/ethernet/sfc/efx_channels.c
@@ -789,6 +789,86 @@ void efx_remove_channels(struct efx_nic *efx)
 	kfree(efx->xdp_tx_queues);
 }
 
+static inline int efx_set_xdp_tx_queue(struct efx_nic *efx,
+				       int xdp_queue_number,
+				       struct efx_tx_queue *tx_queue)
+{
+	if (xdp_queue_number >= efx->xdp_tx_queue_count)
+		return -EINVAL;
+
+	netif_dbg(efx, drv, efx->net_dev,
+		  "Channel %u TXQ %u is XDP %u, HW %u\n",
+		  tx_queue->channel->channel, tx_queue->label,
+		  xdp_queue_number, tx_queue->queue);
+	efx->xdp_tx_queues[xdp_queue_number] = tx_queue;
+	return 0;
+}
+
+static void efx_set_xdp_channels(struct efx_nic *efx)
+{
+	struct efx_tx_queue *tx_queue;
+	struct efx_channel *channel;
+	unsigned int next_queue = 0;
+	int xdp_queue_number = 0;
+	int rc;
+
+	/* We need to mark which channels really have RX and TX
+	 * queues, and adjust the TX queue numbers if we have separate
+	 * RX-only and TX-only channels.
+	 */
+	efx_for_each_channel(channel, efx) {
+		if (channel->channel < efx->tx_channel_offset)
+			continue;
+
+		if (efx_channel_is_xdp_tx(channel)) {
+			efx_for_each_channel_tx_queue(tx_queue, channel) {
+				tx_queue->queue = next_queue++;
+				rc = efx_set_xdp_tx_queue(efx, xdp_queue_number,
+							  tx_queue);
+				if (rc == 0)
+					xdp_queue_number++;
+			}
+		} else {
+			efx_for_each_channel_tx_queue(tx_queue, channel) {
+				tx_queue->queue = next_queue++;
+				netif_dbg(efx, drv, efx->net_dev,
+					  "Channel %u TXQ %u is HW %u\n",
+					  channel->channel, tx_queue->label,
+					  tx_queue->queue);
+			}
+
+			/* If XDP is borrowing queues from net stack, it must
+			 * use the queue with no csum offload, which is the
+			 * first one of the channel
+			 * (note: tx_queue_by_type is not initialized yet)
+			 */
+			if (efx->xdp_txq_queues_mode ==
+			    EFX_XDP_TX_QUEUES_BORROWED) {
+				tx_queue = &channel->tx_queue[0];
+				rc = efx_set_xdp_tx_queue(efx, xdp_queue_number,
+							  tx_queue);
+				if (rc == 0)
+					xdp_queue_number++;
+			}
+		}
+	}
+	WARN_ON(efx->xdp_txq_queues_mode == EFX_XDP_TX_QUEUES_DEDICATED &&
+		xdp_queue_number != efx->xdp_tx_queue_count);
+	WARN_ON(efx->xdp_txq_queues_mode != EFX_XDP_TX_QUEUES_DEDICATED &&
+		xdp_queue_number > efx->xdp_tx_queue_count);
+
+	/* If we have more CPUs than assigned XDP TX queues, assign the already
+	 * existing queues to the exceeding CPUs
+	 */
+	next_queue = 0;
+	while (xdp_queue_number < efx->xdp_tx_queue_count) {
+		tx_queue = efx->xdp_tx_queues[next_queue++];
+		rc = efx_set_xdp_tx_queue(efx, xdp_queue_number, tx_queue);
+		if (rc == 0)
+			xdp_queue_number++;
+	}
+}
+
 int efx_realloc_channels(struct efx_nic *efx, u32 rxq_entries, u32 txq_entries)
 {
 	struct efx_channel *other_channel[EFX_MAX_CHANNELS], *channel;
@@ -860,6 +940,7 @@ int efx_realloc_channels(struct efx_nic *efx, u32 rxq_entries, u32 txq_entries)
 		efx_init_napi_channel(efx->channel[i]);
 	}
 
+	efx_set_xdp_channels(efx);
 out:
 	/* Destroy unused channel structures */
 	for (i = 0; i < efx->n_channels; i++) {
@@ -892,26 +973,9 @@ int efx_realloc_channels(struct efx_nic *efx, u32 rxq_entries, u32 txq_entries)
 	goto out;
 }
 
-static inline int
-efx_set_xdp_tx_queue(struct efx_nic *efx, int xdp_queue_number,
-		     struct efx_tx_queue *tx_queue)
-{
-	if (xdp_queue_number >= efx->xdp_tx_queue_count)
-		return -EINVAL;
-
-	netif_dbg(efx, drv, efx->net_dev, "Channel %u TXQ %u is XDP %u, HW %u\n",
-		  tx_queue->channel->channel, tx_queue->label,
-		  xdp_queue_number, tx_queue->queue);
-	efx->xdp_tx_queues[xdp_queue_number] = tx_queue;
-	return 0;
-}
-
 int efx_set_channels(struct efx_nic *efx)
 {
-	struct efx_tx_queue *tx_queue;
 	struct efx_channel *channel;
-	unsigned int next_queue = 0;
-	int xdp_queue_number;
 	int rc;
 
 	efx->tx_channel_offset =
@@ -929,61 +993,14 @@ int efx_set_channels(struct efx_nic *efx)
 			return -ENOMEM;
 	}
 
-	/* We need to mark which channels really have RX and TX
-	 * queues, and adjust the TX queue numbers if we have separate
-	 * RX-only and TX-only channels.
-	 */
-	xdp_queue_number = 0;
 	efx_for_each_channel(channel, efx) {
 		if (channel->channel < efx->n_rx_channels)
 			channel->rx_queue.core_index = channel->channel;
 		else
 			channel->rx_queue.core_index = -1;
-
-		if (channel->channel >= efx->tx_channel_offset) {
-			if (efx_channel_is_xdp_tx(channel)) {
-				efx_for_each_channel_tx_queue(tx_queue, channel) {
-					tx_queue->queue = next_queue++;
-					rc = efx_set_xdp_tx_queue(efx, xdp_queue_number, tx_queue);
-					if (rc == 0)
-						xdp_queue_number++;
-				}
-			} else {
-				efx_for_each_channel_tx_queue(tx_queue, channel) {
-					tx_queue->queue = next_queue++;
-					netif_dbg(efx, drv, efx->net_dev, "Channel %u TXQ %u is HW %u\n",
-						  channel->channel, tx_queue->label,
-						  tx_queue->queue);
-				}
-
-				/* If XDP is borrowing queues from net stack, it must use the queue
-				 * with no csum offload, which is the first one of the channel
-				 * (note: channel->tx_queue_by_type is not initialized yet)
-				 */
-				if (efx->xdp_txq_queues_mode == EFX_XDP_TX_QUEUES_BORROWED) {
-					tx_queue = &channel->tx_queue[0];
-					rc = efx_set_xdp_tx_queue(efx, xdp_queue_number, tx_queue);
-					if (rc == 0)
-						xdp_queue_number++;
-				}
-			}
-		}
 	}
-	WARN_ON(efx->xdp_txq_queues_mode == EFX_XDP_TX_QUEUES_DEDICATED &&
-		xdp_queue_number != efx->xdp_tx_queue_count);
-	WARN_ON(efx->xdp_txq_queues_mode != EFX_XDP_TX_QUEUES_DEDICATED &&
-		xdp_queue_number > efx->xdp_tx_queue_count);
 
-	/* If we have more CPUs than assigned XDP TX queues, assign the already
-	 * existing queues to the exceeding CPUs
-	 */
-	next_queue = 0;
-	while (xdp_queue_number < efx->xdp_tx_queue_count) {
-		tx_queue = efx->xdp_tx_queues[next_queue++];
-		rc = efx_set_xdp_tx_queue(efx, xdp_queue_number, tx_queue);
-		if (rc == 0)
-			xdp_queue_number++;
-	}
+	efx_set_xdp_channels(efx);
 
 	rc = netif_set_real_num_tx_queues(efx->net_dev, efx->n_tx_channels);
 	if (rc)
-- 
2.17.1

