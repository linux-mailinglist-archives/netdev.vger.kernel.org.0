Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C44B32E8F2
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 13:30:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230399AbhCEM3h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Mar 2021 07:29:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:38424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232159AbhCEM3S (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Mar 2021 07:29:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 17B0365029;
        Fri,  5 Mar 2021 12:29:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614947357;
        bh=pWtrbZuS6RQCQhjX+DA08GgCMOjVa1dMHUpKWcnJGY0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wKLYqZWVnI9woK1gOpkIzVi/lUWSMhtM9TwSuNtUs29UZT05R0jiBNswEICphL6JI
         ljWXkpCNh9vqECxEWau7pCrrt+IXSl8tmig/SN1hrXg9pUUo6JpDDymSE2BRvMSiFd
         kd0r3tTgyB7Z0PqsvKdBdTYTY5iiEd34BESwu7QQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marek Vasut <marex@denx.de>,
        Angus Ainslie <angus@akkea.ca>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Lee Jones <lee.jones@linaro.org>,
        Martin Kepplinger <martink@posteo.de>,
        Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>,
        Siva Rebbagondla <siva8118@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Martin Kepplinger <martin.kepplinger@puri.sm>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 036/102] rsi: Move card interrupt handling to RX thread
Date:   Fri,  5 Mar 2021 13:20:55 +0100
Message-Id: <20210305120905.062667739@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210305120903.276489876@linuxfoundation.org>
References: <20210305120903.276489876@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marek Vasut <marex@denx.de>

[ Upstream commit 287431463e786766e05e4dc26d0a11d5f8ac8815 ]

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
Tested-by: Martin Kepplinger <martin.kepplinger@puri.sm>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20201103180941.443528-1-marex@denx.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/rsi/rsi_91x_sdio.c     |  6 +--
 drivers/net/wireless/rsi/rsi_91x_sdio_ops.c | 52 ++++++---------------
 drivers/net/wireless/rsi/rsi_sdio.h         |  8 +---
 3 files changed, 15 insertions(+), 51 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_sdio.c b/drivers/net/wireless/rsi/rsi_91x_sdio.c
index a7b8684143f4..592e9dadcb55 100644
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
2.30.1



