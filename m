Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6CF62A4DE5
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 19:10:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728889AbgKCSKI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 13:10:08 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:40866 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727706AbgKCSKI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 13:10:08 -0500
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 4CQd9K5TJfz1qs0Y;
        Tue,  3 Nov 2020 19:09:57 +0100 (CET)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 4CQd9K1f27z1qtZ6;
        Tue,  3 Nov 2020 19:09:57 +0100 (CET)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id p6lJGzKwqxFx; Tue,  3 Nov 2020 19:09:55 +0100 (CET)
X-Auth-Info: gGi0xWFnHCJvaoRCQCKJKp3s7WaTZQFo8IXbB2aMlKo=
Received: from localhost.localdomain (ip-89-176-112-137.net.upcbroadband.cz [89.176.112.137])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Tue,  3 Nov 2020 19:09:55 +0100 (CET)
From:   Marek Vasut <marex@denx.de>
To:     linux-wireless@vger.kernel.org
Cc:     Marek Vasut <marex@denx.de>, Angus Ainslie <angus@akkea.ca>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Lee Jones <lee.jones@linaro.org>,
        Martin Kepplinger <martink@posteo.de>,
        Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>,
        Siva Rebbagondla <siva8118@gmail.com>, netdev@vger.kernel.org
Subject: [PATCH 1/2] rsi: Move card interrupt handling to RX thread
Date:   Tue,  3 Nov 2020 19:09:40 +0100
Message-Id: <20201103180941.443528-1-marex@denx.de>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The interrupt handling of the RS911x is particularly heavy. For each RX
packet, the card does three SDIO transactions, one to read interrupt
status register, one to RX buffer length, one to read the RX packet(s).
This translates to ~330 uS per one cycle of interrupt handler. In case
there is more incoming traffic, this will be more.

The drivers/mmc/core/sdio_irq.c has the following comment, quote "Just
like traditional hard IRQ handlers, we expect SDIO IRQ handlers to be
quick and to the point, so that the holding of the host lock does not
cover too much work that doesn't require that lock to be held."

The RS911x interrupt handler does not fit that. This patch therefore
changes it such that the entire IRQ handler is moved to the RX thread
instead, and the interrupt handler only wakes the RX thread.

This is OK, because the interrupt handler only does things which can
also be done in the RX thread, that is, it checks for firmware loading
error(s), it checks buffer status, it checks whether a packet arrived
and if so, reads out the packet and passes it to network stack.

Moreover, this change permits removal of a code which allocated an
skbuff only to get 4-byte-aligned buffer, read up to 8kiB of data
into the skbuff, queue this skbuff into local private queue, then in
RX thread, this buffer is dequeued, the data in the skbuff as passed
to the RSI driver core, and the skbuff is deallocated. All this is
replaced by directly calling the RSI driver core with local buffer.

Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Angus Ainslie <angus@akkea.ca>
Cc: David S. Miller <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: Lee Jones <lee.jones@linaro.org>
Cc: Martin Kepplinger <martink@posteo.de>
Cc: Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>
Cc: Siva Rebbagondla <siva8118@gmail.com>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
---
 drivers/net/wireless/rsi/rsi_91x_sdio.c     |  6 +--
 drivers/net/wireless/rsi/rsi_91x_sdio_ops.c | 52 ++++++---------------
 drivers/net/wireless/rsi/rsi_sdio.h         |  8 +---
 3 files changed, 15 insertions(+), 51 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_sdio.c b/drivers/net/wireless/rsi/rsi_91x_sdio.c
index 78ad605081ae..d81874eee4b3 100644
--- a/drivers/net/wireless/rsi/rsi_91x_sdio.c
+++ b/drivers/net/wireless/rsi/rsi_91x_sdio.c
@@ -153,9 +153,7 @@ static void rsi_handle_interrupt(struct sdio_func *function)
 	if (adapter->priv->fsm_state == FSM_FW_NOT_LOADED)
 		return;
 
-	dev->sdio_irq_task = current;
-	rsi_interrupt_handler(adapter);
-	dev->sdio_irq_task = NULL;
+	rsi_set_event(&dev->rx_thread.event);
 }
 
 /**
@@ -1058,8 +1056,6 @@ static int rsi_probe(struct sdio_func *pfunction,
 		rsi_dbg(ERR_ZONE, "%s: Unable to init rx thrd\n", __func__);
 		goto fail_kill_thread;
 	}
-	skb_queue_head_init(&sdev->rx_q.head);
-	sdev->rx_q.num_rx_pkts = 0;
 
 	sdio_claim_host(pfunction);
 	if (sdio_claim_irq(pfunction, rsi_handle_interrupt)) {
diff --git a/drivers/net/wireless/rsi/rsi_91x_sdio_ops.c b/drivers/net/wireless/rsi/rsi_91x_sdio_ops.c
index 7825c9a889d3..23e709aabd1f 100644
--- a/drivers/net/wireless/rsi/rsi_91x_sdio_ops.c
+++ b/drivers/net/wireless/rsi/rsi_91x_sdio_ops.c
@@ -60,39 +60,20 @@ int rsi_sdio_master_access_msword(struct rsi_hw *adapter, u16 ms_word)
 	return status;
 }
 
+static void rsi_rx_handler(struct rsi_hw *adapter);
+
 void rsi_sdio_rx_thread(struct rsi_common *common)
 {
 	struct rsi_hw *adapter = common->priv;
 	struct rsi_91x_sdiodev *sdev = adapter->rsi_dev;
-	struct sk_buff *skb;
-	int status;
 
 	do {
 		rsi_wait_event(&sdev->rx_thread.event, EVENT_WAIT_FOREVER);
 		rsi_reset_event(&sdev->rx_thread.event);
+		rsi_rx_handler(adapter);
+	} while (!atomic_read(&sdev->rx_thread.thread_done));
 
-		while (true) {
-			if (atomic_read(&sdev->rx_thread.thread_done))
-				goto out;
-
-			skb = skb_dequeue(&sdev->rx_q.head);
-			if (!skb)
-				break;
-			if (sdev->rx_q.num_rx_pkts > 0)
-				sdev->rx_q.num_rx_pkts--;
-			status = rsi_read_pkt(common, skb->data, skb->len);
-			if (status) {
-				rsi_dbg(ERR_ZONE, "Failed to read the packet\n");
-				dev_kfree_skb(skb);
-				break;
-			}
-			dev_kfree_skb(skb);
-		}
-	} while (1);
-
-out:
 	rsi_dbg(INFO_ZONE, "%s: Terminated SDIO RX thread\n", __func__);
-	skb_queue_purge(&sdev->rx_q.head);
 	atomic_inc(&sdev->rx_thread.thread_done);
 	complete_and_exit(&sdev->rx_thread.completion, 0);
 }
@@ -113,10 +94,6 @@ static int rsi_process_pkt(struct rsi_common *common)
 	u32 rcv_pkt_len = 0;
 	int status = 0;
 	u8 value = 0;
-	struct sk_buff *skb;
-
-	if (dev->rx_q.num_rx_pkts >= RSI_MAX_RX_PKTS)
-		return 0;
 
 	num_blks = ((adapter->interrupt_status & 1) |
 			((adapter->interrupt_status >> RECV_NUM_BLOCKS) << 1));
@@ -144,22 +121,19 @@ static int rsi_process_pkt(struct rsi_common *common)
 
 	rcv_pkt_len = (num_blks * 256);
 
-	skb = dev_alloc_skb(rcv_pkt_len);
-	if (!skb)
-		return -ENOMEM;
-
-	status = rsi_sdio_host_intf_read_pkt(adapter, skb->data, rcv_pkt_len);
+	status = rsi_sdio_host_intf_read_pkt(adapter, dev->pktbuffer,
+					     rcv_pkt_len);
 	if (status) {
 		rsi_dbg(ERR_ZONE, "%s: Failed to read packet from card\n",
 			__func__);
-		dev_kfree_skb(skb);
 		return status;
 	}
-	skb_put(skb, rcv_pkt_len);
-	skb_queue_tail(&dev->rx_q.head, skb);
-	dev->rx_q.num_rx_pkts++;
 
-	rsi_set_event(&dev->rx_thread.event);
+	status = rsi_read_pkt(common, dev->pktbuffer, rcv_pkt_len);
+	if (status) {
+		rsi_dbg(ERR_ZONE, "Failed to read the packet\n");
+		return status;
+	}
 
 	return 0;
 }
@@ -251,12 +225,12 @@ int rsi_init_sdio_slave_regs(struct rsi_hw *adapter)
 }
 
 /**
- * rsi_interrupt_handler() - This function read and process SDIO interrupts.
+ * rsi_rx_handler() - Read and process SDIO interrupts.
  * @adapter: Pointer to the adapter structure.
  *
  * Return: None.
  */
-void rsi_interrupt_handler(struct rsi_hw *adapter)
+static void rsi_rx_handler(struct rsi_hw *adapter)
 {
 	struct rsi_common *common = adapter->priv;
 	struct rsi_91x_sdiodev *dev =
diff --git a/drivers/net/wireless/rsi/rsi_sdio.h b/drivers/net/wireless/rsi/rsi_sdio.h
index 9afc1d0d2684..1c756263cf15 100644
--- a/drivers/net/wireless/rsi/rsi_sdio.h
+++ b/drivers/net/wireless/rsi/rsi_sdio.h
@@ -107,11 +107,6 @@ struct receive_info {
 	u32 buf_available_counter;
 };
 
-struct rsi_sdio_rx_q {
-	u8 num_rx_pkts;
-	struct sk_buff_head head;
-};
-
 struct rsi_91x_sdiodev {
 	struct sdio_func *pfunction;
 	struct task_struct *sdio_irq_task;
@@ -124,11 +119,10 @@ struct rsi_91x_sdiodev {
 	u16 tx_blk_size;
 	u8 write_fail;
 	bool buff_status_updated;
-	struct rsi_sdio_rx_q rx_q;
 	struct rsi_thread rx_thread;
+	u8 pktbuffer[8192] __aligned(4);
 };
 
-void rsi_interrupt_handler(struct rsi_hw *adapter);
 int rsi_init_sdio_slave_regs(struct rsi_hw *adapter);
 int rsi_sdio_read_register(struct rsi_hw *adapter, u32 addr, u8 *data);
 int rsi_sdio_host_intf_read_pkt(struct rsi_hw *adapter, u8 *pkt, u32 length);
-- 
2.28.0

