Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 334FD47DCE0
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 02:15:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242099AbhLWBO6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 20:14:58 -0500
Received: from o1.ptr2625.egauge.net ([167.89.112.53]:18368 "EHLO
        o1.ptr2625.egauge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345771AbhLWBOR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 20:14:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=egauge.net;
        h=from:subject:in-reply-to:references:mime-version:to:cc:
        content-transfer-encoding:content-type;
        s=sgd; bh=vZhKpwkeABx3tV5464sBNHKmLdYJetnkUWgiwVq0e+M=;
        b=gSMXBJmGkyQjVJdOl21pxvi7KtiMRQGaum/3+DtPG8VdaTSmBRxB4u3bBD7ONHGsUDdK
        D0MqI+fKkvqCGZ0KHlGCdQQonTTGWBE7YsoGen4n0GYppz/JWQHCeREwd1RIbu0qlErWjN
        ypjuBG9V/G9aryFUlOHjy2WMfEHzg/J9O8ujPsHg0BmjUdte6fOsFRnatK6Zw3FB6TGiHx
        2RQ3xIje6YFOxwdPVeOIwXttEYRjhOp/k8oBfADCM8/blRARaa21IXPZD1Do5cYZr1yDQu
        a619dWd5snsWW7nh4HRrmytA0L5Z7xKw0Pa/5zrPUeSF7C73Iqlmr2+QWm4NiCFg==
Received: by filterdrecv-64fcb979b9-stcmh with SMTP id filterdrecv-64fcb979b9-stcmh-1-61C3CD5E-19
        2021-12-23 01:14:06.641297648 +0000 UTC m=+8644585.985703208
Received: from pearl.egauge.net (unknown)
        by geopod-ismtpd-5-0 (SG)
        with ESMTP
        id kYQx10e9SJ-POfpDVVT99Q
        Thu, 23 Dec 2021 01:14:06.439 +0000 (UTC)
Received: by pearl.egauge.net (Postfix, from userid 1000)
        id 36E4A701321; Wed, 22 Dec 2021 18:14:05 -0700 (MST)
From:   David Mosberger-Tang <davidm@egauge.net>
Subject: [PATCH v2 18/50] wilc1000: split huge tx handler into subfunctions
Date:   Thu, 23 Dec 2021 01:14:06 +0000 (UTC)
Message-Id: <20211223011358.4031459-19-davidm@egauge.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211223011358.4031459-1-davidm@egauge.net>
References: <20211223011358.4031459-1-davidm@egauge.net>
MIME-Version: 1.0
X-SG-EID: =?us-ascii?Q?+kMxBqj35EdRUKoy8diX1j4AXmPtd302oan+iXZuF8m2Nw4HRW2irNspffT=2Fkh?=
 =?us-ascii?Q?ET6RJF6+Prbl0h=2FEtF1rRLvN=2FgGHiwjRLSHlTP9?=
 =?us-ascii?Q?0xv=2FCkD5McJdotNU1IWUaiA5rlUOQzfOXej2buH?=
 =?us-ascii?Q?57ZdJ8RFuS2M85fKVNxTd4qP8KXY0N9I5X64lnD?=
 =?us-ascii?Q?bxyYyhvp2vRlgfDV8hkbb7KqHVt+kqz24dfxlJv?=
 =?us-ascii?Q?+NqFJgNEVVbNbzexsISz3ez+EJdogo2o8C8PCc?=
To:     Ajay Singh <ajay.kathat@microchip.com>
Cc:     Claudiu Beznea <claudiu.beznea@microchip.com>,
        Kalle Valo <kvalo@kernel.org>,
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
 .../net/wireless/microchip/wilc1000/wlan.c    | 206 +++++++++++++-----
 1 file changed, 157 insertions(+), 49 deletions(-)

diff --git a/drivers/net/wireless/microchip/wilc1000/wlan.c b/drivers/net/wireless/microchip/wilc1000/wlan.c
index 8bff1d8050b11..54dfb2b9f3524 100644
--- a/drivers/net/wireless/microchip/wilc1000/wlan.c
+++ b/drivers/net/wireless/microchip/wilc1000/wlan.c
@@ -605,43 +605,43 @@ void host_sleep_notify(struct wilc *wilc)
 }
 EXPORT_SYMBOL_GPL(host_sleep_notify);
 
-int wilc_wlan_handle_txq(struct wilc *wilc, u32 *txq_count)
+/**
+ * fill_vmm_table() - Fill VMM table with packets to be sent
+ * @wilc: Pointer to the wilc structure.
+ * @ac_desired_ratio: First-round limit on number of packets to add from the
+ *	respective queue.
+ * @vmm_table: Pointer to the VMM table to fill.
+ * @vmm_entries_ac: Pointer to the queue-number table to fill.
+ *	For each packet added to the VMM table, this will be filled in
+ *	with the queue-number (access-category) that the packet is coming
+ *	from.
+ *
+ * Fill VMM table with packets waiting to be sent.  The packets are
+ * added based on access category (priority) but also balanced to
+ * provide fairness.
+ *
+ * Context: Since this function peeks at the packet queues, the
+ * txq_add_to_head_cs mutex must be acquired before calling this
+ * function.
+ *
+ * Return:
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
@@ -695,11 +695,31 @@ int wilc_wlan_handle_txq(struct wilc *wilc, u32 *txq_count)
 		num_pkts_to_add = ac_preserve_ratio;
 	} while (!max_size_over && ac_exist);
 
-	if (i == 0)
-		goto out_unlock;
 	vmm_table[i] = 0x0;
+	return i;
+}
+
+/**
+ * send_vmm_table() - Send the VMM table to the chip
+ * @wilc: Pointer to the wilc structure.
+ * @i: The number of entries in the VMM table.
+ * @vmm_table: The VMM table to send.
+ *
+ * Send the VMM table to the chip and get back the number of entries
+ * that the chip can accept.
+ *
+ * Context: The bus must have been acquired before calling this
+ * function.
+ *
+ * Return:
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
@@ -721,7 +741,7 @@ int wilc_wlan_handle_txq(struct wilc *wilc, u32 *txq_count)
 	} while (!wilc->quit);
 
 	if (ret)
-		goto out_release_bus;
+		return ret;
 
 	timeout = 200;
 	do {
@@ -759,22 +779,38 @@ int wilc_wlan_handle_txq(struct wilc *wilc, u32 *txq_count)
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
+ * copy_packets() - Copy packets to the transmit buffer
+ * @wilc: Pointer to the wilc structure.
+ * @entries: The number of packets to send from the VMM table.
+ * @vmm_table: The VMM table to send.
+ * @vmm_entries_ac: Table index i contains the number of the queue to
+ *	take the i-th packet from.
+ *
+ * Copy a set of packets to the transmit buffer.
+ *
+ * Context: The txq_add_to_head_cs mutex must still be held when
+ * calling this function.
+ *
+ * Return:
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
@@ -829,16 +865,88 @@ int wilc_wlan_handle_txq(struct wilc *wilc, u32 *txq_count)
 	} while (--entries);
 	for (i = 0; i < NQUEUES; i++)
 		wilc->fw[i].count += ac_pkt_num_to_chip[i];
+	return offset;
+}
 
-	acquire_bus(wilc, WILC_BUS_ACQUIRE_AND_WAKEUP);
+/**
+ * send_packets() - Send packets to the chip
+ * @wilc: Pointer to the wilc structure.
+ * @len: The length of the buffer containing the packets to be sent to
+ *	the chip.
+ *
+ * Send the packets in the VMM table to the chip.
+ *
+ * Context: The bus must have been acquired.
+ *
+ * Return:
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
+	return func->hif_block_tx_ext(wilc, 0, txb, len);
+}
+
+int wilc_wlan_handle_txq(struct wilc *wilc, u32 *txq_count)
+{
+	int i, entries, len;
+	u8 ac_desired_ratio[NQUEUES] = {0, 0, 0, 0};
+	u8 vmm_entries_ac[WILC_VMM_TBL_SIZE];
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

