Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4742B479E4B
	for <lists+netdev@lfdr.de>; Sun, 19 Dec 2021 00:54:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234923AbhLRXyf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Dec 2021 18:54:35 -0500
Received: from o1.ptr2625.egauge.net ([167.89.112.53]:25714 "EHLO
        o1.ptr2625.egauge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234965AbhLRXy1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Dec 2021 18:54:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=egauge.net;
        h=from:subject:in-reply-to:references:mime-version:to:cc:
        content-transfer-encoding:content-type;
        s=sgd; bh=5Pqwl63bHpqoLecNYX9M7YSYzft3PMq3Tp+Ku265mTY=;
        b=R31qg4d/FC+Tyg4exwJVMuwogdfu/qX/5lV5bx4JCMnHIwRmt48WcjUmUj2VrH7YXatz
        GQfZ0wOO6FQ+IS6W+ogSYfcpQHWbpm0Ef7wI9x4U6PLH0apkclP0Sn51G2vPzPl37IsRAx
        Jt6cjEIB0F6GVITNC2vHYVEEke8x3e0ye7Hb/N1WM2228zUwnxAzqK1Q/+3+y9r7ucxTvB
        hg8Bk0EAiSeVX4/8rUik1DqudIFFPHb8VAIeOoNiUTDnY4CxD3OhiRXlv9sVzZvsDnUdL3
        n4EYIIY3o+8YUqBZ391bPCSRoF5lunwUUvdpnHAVz+MN5J3IcWtzOCD+mXyhkb/A==
Received: by filterdrecv-75ff7b5ffb-wdd5z with SMTP id filterdrecv-75ff7b5ffb-wdd5z-1-61BE74A9-9
        2021-12-18 23:54:17.132754881 +0000 UTC m=+9336865.234030658
Received: from pearl.egauge.net (unknown)
        by geopod-ismtpd-1-1 (SG)
        with ESMTP
        id 3JAEvuuJSgy3JFED5vCSbw
        Sat, 18 Dec 2021 23:54:17.020 +0000 (UTC)
Received: by pearl.egauge.net (Postfix, from userid 1000)
        id C770770141C; Sat, 18 Dec 2021 16:54:15 -0700 (MST)
From:   David Mosberger-Tang <davidm@egauge.net>
Subject: [PATCH 18/23] wilc1000: split huge tx handler into subfunctions
Date:   Sat, 18 Dec 2021 23:54:17 +0000 (UTC)
Message-Id: <20211218235404.3963475-19-davidm@egauge.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211218235404.3963475-1-davidm@egauge.net>
References: <20211218235404.3963475-1-davidm@egauge.net>
MIME-Version: 1.0
X-SG-EID: =?us-ascii?Q?+kMxBqj35EdRUKoy8diX1j4AXmPtd302oan+iXZuF8m2Nw4HRW2irNspffT=2Fkh?=
 =?us-ascii?Q?ET6RJF6+Prbl0h=2FEtF1rRLvHfkfcXBPrp40SERT?=
 =?us-ascii?Q?TQC6jUvlYfvdwJLiaQX72T07R=2FeSc78h7Dn=2F52c?=
 =?us-ascii?Q?nt8CvTM7fOpBtB6jG4FkVTHXMaNV7JBixYvCE=2F3?=
 =?us-ascii?Q?nptVdHgSvQpc4GpI0URhYrKAqUXP5md9z1Tov7f?=
 =?us-ascii?Q?NG4WfmmWSAk7vBCtMI5a+o07RKld8JmBKcWPU0?=
To:     Ajay Singh <ajay.kathat@microchip.com>
Cc:     Claudiu Beznea <claudiu.beznea@microchip.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        David Mosberger-Tang <davidm@egauge.net>
X-Entity-ID: Xg4JGAcGrJFIz2kDG9eoaQ==
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=us-ascii
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This makes the code easier to read and less error prone.  There are no
functional changes in this patch.

Signed-off-by: David Mosberger-Tang <davidm@egauge.net>
---
 .../net/wireless/microchip/wilc1000/wlan.c    | 202 +++++++++++++-----
 1 file changed, 153 insertions(+), 49 deletions(-)

diff --git a/drivers/net/wireless/microchip/wilc1000/wlan.c b/drivers/net/wireless/microchip/wilc1000/wlan.c
index 286bbf9392165..b7c8ff95b646a 100644
--- a/drivers/net/wireless/microchip/wilc1000/wlan.c
+++ b/drivers/net/wireless/microchip/wilc1000/wlan.c
@@ -605,43 +605,40 @@ void host_sleep_notify(struct wilc *wilc)
 }
 EXPORT_SYMBOL_GPL(host_sleep_notify);
 
-int wilc_wlan_handle_txq(struct wilc *wilc, u32 *txq_count)
+/**
+ * Fill VMM table with packets waiting to be sent.  The packets are
+ * added based on access category (priority) but also balanced to
+ * provide fairness.  Since this function peeks at the packet queues,
+ * the txq_add_to_head_cs mutex must be acquired before calling this
+ * function.
+ *
+ * @wilc - Pointer to the wilc structure.
+ * @ac_desired_ratio: First-round limit on number of packets to add from the
+ *	respective queue.
+ * @vmm_table: Pointer to the VMM table to fill.
+ * @vmm_entries_ac: Pointer to the queue-number table to fill.
+ *	For each packet added to the VMM table, this will be filled in
+ *	with the queue-number (access-category) that the packet is coming
+ *	from.
+ *
+ * @return
+ *	The number of VMM entries filled in.  The table is 0-terminated
+ *	so the returned number is at most WILC_VMM_TBL_SIZE-1.
+ */
+static int fill_vmm_table(const struct wilc *wilc,
+			  u8 ac_desired_ratio[NQUEUES],
+			  u32 vmm_table[WILC_VMM_TBL_SIZE],
+			  u8 vmm_entries_ac[WILC_VMM_TBL_SIZE])
 {
-	int i, entries = 0;
+	int i;
 	u8 k, ac;
 	u32 sum;
-	u32 reg;
-	u8 ac_desired_ratio[NQUEUES] = {0, 0, 0, 0};
 	u8 ac_preserve_ratio[NQUEUES] = {1, 1, 1, 1};
 	u8 *num_pkts_to_add;
-	u8 vmm_entries_ac[WILC_VMM_TBL_SIZE];
-	u32 offset = 0;
 	bool max_size_over = 0, ac_exist = 0;
 	int vmm_sz = 0;
 	struct sk_buff *tqe_q[NQUEUES];
 	struct wilc_skb_tx_cb *tx_cb;
-	int ret = 0;
-	int counter;
-	int timeout;
-	u32 vmm_table[WILC_VMM_TBL_SIZE];
-	u8 ac_pkt_num_to_chip[NQUEUES] = {0, 0, 0, 0};
-	const struct wilc_hif_func *func;
-	int srcu_idx;
-	u8 *txb = wilc->tx_buffer;
-	struct wilc_vif *vif;
-
-	if (wilc->quit)
-		goto out_update_cnt;
-
-	if (ac_balance(wilc, ac_desired_ratio))
-		return -EINVAL;
-
-	mutex_lock(&wilc->txq_add_to_head_cs);
-
-	srcu_idx = srcu_read_lock(&wilc->srcu);
-	list_for_each_entry_rcu(vif, &wilc->vif_list, list)
-		wilc_wlan_txq_filter_dup_tcp_ack(vif->ndev);
-	srcu_read_unlock(&wilc->srcu, srcu_idx);
 
 	for (ac = 0; ac < NQUEUES; ac++)
 		tqe_q[ac] = skb_peek(&wilc->txq[ac]);
@@ -695,11 +692,28 @@ int wilc_wlan_handle_txq(struct wilc *wilc, u32 *txq_count)
 		num_pkts_to_add = ac_preserve_ratio;
 	} while (!max_size_over && ac_exist);
 
-	if (i == 0)
-		goto out_unlock;
 	vmm_table[i] = 0x0;
+	return i;
+}
+
+/**
+ * Send the VMM table to the chip and get back the number of entries
+ * that the chip can accept.  The bus must have been acquired before
+ * calling this function.
+ *
+ * @wilc: Pointer to the wilc structure.
+ * @i: The number of entries in the VMM table.
+ * @vmm_table: The VMM table to send.
+ *
+ * @return
+ *	The number of VMM table entries the chip can accept.
+ */
+static int send_vmm_table(struct wilc *wilc, int i, const u32 *vmm_table)
+{
+	const struct wilc_hif_func *func;
+	int ret, counter, entries, timeout;
+	u32 reg;
 
-	acquire_bus(wilc, WILC_BUS_ACQUIRE_AND_WAKEUP);
 	counter = 0;
 	func = wilc->hif_func;
 	do {
@@ -721,7 +735,7 @@ int wilc_wlan_handle_txq(struct wilc *wilc, u32 *txq_count)
 	} while (!wilc->quit);
 
 	if (ret)
-		goto out_release_bus;
+		return ret;
 
 	timeout = 200;
 	do {
@@ -759,22 +773,36 @@ int wilc_wlan_handle_txq(struct wilc *wilc, u32 *txq_count)
 				break;
 			reg &= ~BIT(0);
 			ret = func->hif_write_reg(wilc, WILC_HOST_TX_CTRL, reg);
+		} else {
+			ret = entries;
 		}
 	} while (0);
+	return ret;
+}
 
-	if (ret)
-		goto out_release_bus;
-
-	if (entries == 0) {
-		/*
-		 * No VMM space available in firmware so retry to transmit
-		 * the packet from tx queue.
-		 */
-		ret = WILC_VMM_ENTRY_FULL_RETRY;
-		goto out_release_bus;
-	}
-
-	release_bus(wilc, WILC_BUS_RELEASE_ALLOW_SLEEP);
+/**
+ * Copy a set of packets to the transmit buffer.  The
+ * txq_add_to_head_cs mutex must still be held when calling this
+ * function.
+ *
+ * @wilc - Pointer to the wilc structure.
+ * @entries: The number of packets to send from the VMM table.
+ * @vmm_table: The VMM table to send.
+ * @vmm_entries_ac: Table index i contains the number of the queue to
+ *	take the i-th packet from.
+ *
+ * @return
+ *	Negative number on error, 0 on success.
+ */
+static int copy_packets(struct wilc *wilc, int entries, u32 *vmm_table,
+			u8 *vmm_entries_ac)
+{
+	u8 ac_pkt_num_to_chip[NQUEUES] = {0, 0, 0, 0};
+	struct wilc_skb_tx_cb *tx_cb;
+	u8 *txb = wilc->tx_buffer;
+	struct wilc_vif *vif;
+	int i, vmm_sz;
+	u32 offset;
 
 	offset = 0;
 	i = 0;
@@ -829,16 +857,92 @@ int wilc_wlan_handle_txq(struct wilc *wilc, u32 *txq_count)
 	} while (--entries);
 	for (i = 0; i < NQUEUES; i++)
 		wilc->fw[i].count += ac_pkt_num_to_chip[i];
+	return offset;
+}
 
-	acquire_bus(wilc, WILC_BUS_ACQUIRE_AND_WAKEUP);
+/**
+ * Send the packets in the VMM table to the chip.  The bus must have
+ * been acquired.
+ *
+ * @wilc - Pointer to the wilc structure.
+ * @length: The length of the buffer containing the packets to be
+ *	sent to the chip.
+ *
+ * @return
+ *	Negative number on error, 0 on success.
+ */
+static int send_packets(struct wilc *wilc, int len)
+{
+	const struct wilc_hif_func *func = wilc->hif_func;
+	int ret;
+	u8 *txb = wilc->tx_buffer;
 
 	ret = func->hif_clear_int_ext(wilc, ENABLE_TX_VMM);
 	if (ret)
-		goto out_release_bus;
+		return ret;
+
+	ret = func->hif_block_tx_ext(wilc, 0, txb, len);
+	return ret;
+}
+
+int wilc_wlan_handle_txq(struct wilc *wilc, u32 *txq_count)
+{
+	int i, entries, len;
+	u8 ac;
+	u8 ac_desired_ratio[NQUEUES] = {0, 0, 0, 0};
+	u8 vmm_entries_ac[WILC_VMM_TBL_SIZE];
+	struct sk_buff *tqe_q[NQUEUES];
+	int ret = 0;
+	u32 vmm_table[WILC_VMM_TBL_SIZE];
+	int srcu_idx;
+	struct wilc_vif *vif;
+
+	if (wilc->quit)
+		goto out_update_cnt;
+
+	if (ac_balance(wilc, ac_desired_ratio))
+		return -EINVAL;
+
+	mutex_lock(&wilc->txq_add_to_head_cs);
+
+	srcu_idx = srcu_read_lock(&wilc->srcu);
+	list_for_each_entry_rcu(vif, &wilc->vif_list, list)
+		wilc_wlan_txq_filter_dup_tcp_ack(vif->ndev);
+	srcu_read_unlock(&wilc->srcu, srcu_idx);
+
+	for (ac = 0; ac < NQUEUES; ac++)
+		tqe_q[ac] = skb_peek(&wilc->txq[ac]);
+
+	i = fill_vmm_table(wilc, ac_desired_ratio, vmm_table, vmm_entries_ac);
+	if (i == 0)
+		goto out_unlock;
+
+	acquire_bus(wilc, WILC_BUS_ACQUIRE_AND_WAKEUP);
+
+	ret = send_vmm_table(wilc, i, vmm_table);
+
+	release_bus(wilc, WILC_BUS_RELEASE_ALLOW_SLEEP);
+
+	if (ret < 0)
+		goto out_unlock;
+
+	entries = ret;
+	if (entries == 0) {
+		/* No VMM space available in firmware.  Inform caller
+		 * to retry later.
+		 */
+		ret = WILC_VMM_ENTRY_FULL_RETRY;
+		goto out_unlock;
+	}
+
+	len = copy_packets(wilc, entries, vmm_table, vmm_entries_ac);
+	if (len <= 0)
+		goto out_unlock;
+
+	acquire_bus(wilc, WILC_BUS_ACQUIRE_AND_WAKEUP);
 
-	ret = func->hif_block_tx_ext(wilc, 0, txb, offset);
+	ret = send_packets(wilc, len);
 
-out_release_bus:
 	release_bus(wilc, WILC_BUS_RELEASE_ALLOW_SLEEP);
 
 out_unlock:
-- 
2.25.1

