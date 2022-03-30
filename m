Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D53584EC9C5
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 18:37:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348878AbiC3QjD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 12:39:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236846AbiC3QjB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 12:39:01 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B91C197AC3;
        Wed, 30 Mar 2022 09:37:15 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id s8so19197285pfk.12;
        Wed, 30 Mar 2022 09:37:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=ncCMERzhXgEwa8YpsHvGRoleMf6RuPaWT+VsO4MzRgU=;
        b=h5fB5kqw7kgZZ7GiiqhNgopBgU3OVifclVBFYjbjk/fF+JUwmyGztrIpstEhHgDW7G
         DDVDY/eqLsaMAWgYG1HvJ6MSMpwLmmI8R1+GDdNNRk6H1xGOjjNqlZHlmLtu1nBEroki
         7BKd2UF/nOqMNhJ0qSifuYSP5ASJ0e9GbvRbduWaZMoYSRrEWzZmcxd67V7xXNAq+l9q
         6XdLq/VwNZaql8Pw+d6XGtTG8tkbYyrz5LEaobUjeLRMd/M842YWWZgoobhf2vwAGv86
         fl9RkvZwvSLbfOvyoGXmkBkosj7DOd5dEBNGUu7Ll15TG2yK6RqRBscNXLa7RgRAbQ6y
         aL2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=ncCMERzhXgEwa8YpsHvGRoleMf6RuPaWT+VsO4MzRgU=;
        b=tRLivL8GGgp00OJbcGpMd/g07yGuc7ZSfW85a4Ba4bXi3OyYIwdYiiX6BrKqm6sY2B
         neUYAUiC5BSX7vNw+LWlEx0HMxLEBjP/6wHduLPJrLCTYcqTea247K5jJufJh6BJKh6z
         FL5YWVwAVMvhj3pItbYyNYrYkb8mNrdI59BqmbiJ4jhZkZvBp7vwwcaRiwNLJ6M8lBgq
         nnt5Vya7P9QZgodReKzSBVDBEfsYdVt1EI4WwGqdzsgskhtM6mv/3cCM1M9GFmfRYtT1
         Id4EzmFtcOMZnTCax1ZVYA5d3zPKUck90p0jfeQNa1/YVqqFBJyn8dMT2skAysl5lEgX
         XrLw==
X-Gm-Message-State: AOAM531ExNL2XrnNyArSySUxi9ooJZ3ePgBH/I5uDC9N/R3fAc3k7yMP
        Rt/c1OsTuSraeB0VgtQwdUg=
X-Google-Smtp-Source: ABdhPJxVHXRIUEJEE/QCW1WbPe8hN9HKop9wh5Lfe9nswdo6G3RkkQq025wlJnoHNeNzjXFPOuBQqw==
X-Received: by 2002:a65:6e0f:0:b0:382:2f78:4369 with SMTP id bd15-20020a656e0f000000b003822f784369mr6849189pgb.406.1648658234761;
        Wed, 30 Mar 2022 09:37:14 -0700 (PDT)
Received: from localhost.localdomain ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id m18-20020a639412000000b003820bd9f2f2sm20119791pge.53.2022.03.30.09.37.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Mar 2022 09:37:14 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        cmclachlan@solarflare.com
Cc:     ap420073@gmail.com
Subject: [PATCH net v2] net: sfc: add missing xdp queue reinitialization
Date:   Wed, 30 Mar 2022 16:37:03 +0000
Message-Id: <20220330163703.25086-1-ap420073@gmail.com>
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
reallocates and reinitializes rx and tx queues and their buffer
(tx_queue->buffer).
But it misses reinitializing xdp queues(efx->xdp_tx_queues).
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

v2: Do not use inline in .c file

 drivers/net/ethernet/sfc/efx_channels.c | 146 +++++++++++++-----------
 1 file changed, 81 insertions(+), 65 deletions(-)

diff --git a/drivers/net/ethernet/sfc/efx_channels.c b/drivers/net/ethernet/sfc/efx_channels.c
index d6fdcdc530ca..b29ca69aeca5 100644
--- a/drivers/net/ethernet/sfc/efx_channels.c
+++ b/drivers/net/ethernet/sfc/efx_channels.c
@@ -789,6 +789,85 @@ void efx_remove_channels(struct efx_nic *efx)
 	kfree(efx->xdp_tx_queues);
 }
 
+static int efx_set_xdp_tx_queue(struct efx_nic *efx, int xdp_queue_number,
+				struct efx_tx_queue *tx_queue)
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
@@ -860,6 +939,7 @@ int efx_realloc_channels(struct efx_nic *efx, u32 rxq_entries, u32 txq_entries)
 		efx_init_napi_channel(efx->channel[i]);
 	}
 
+	efx_set_xdp_channels(efx);
 out:
 	/* Destroy unused channel structures */
 	for (i = 0; i < efx->n_channels; i++) {
@@ -892,26 +972,9 @@ int efx_realloc_channels(struct efx_nic *efx, u32 rxq_entries, u32 txq_entries)
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
@@ -929,61 +992,14 @@ int efx_set_channels(struct efx_nic *efx)
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

