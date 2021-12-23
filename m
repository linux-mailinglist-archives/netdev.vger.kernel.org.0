Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5612E47DD2E
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 02:18:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346784AbhLWBQT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 20:16:19 -0500
Received: from o1.ptr2625.egauge.net ([167.89.112.53]:27356 "EHLO
        o1.ptr2625.egauge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346242AbhLWBOp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 20:14:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=egauge.net;
        h=from:subject:in-reply-to:references:mime-version:to:cc:
        content-transfer-encoding:content-type;
        s=sgd; bh=dfBeb34NhlQx9kSnwdfVLwJrGwUjal6SLB3oVtZbo4E=;
        b=TWgM3B+/1zIiBki4SbXmfYuLUWEujlY5xWduxlkRk2mazS4YvgyERmULCarpZ/CbweMb
        EViiHe2U3LSwRagfjO1Ump67NEbfkNwbDekK9wuO1FN189EB45sF1UUSJSd7JusKGsZyE+
        RFgm2gYF8U8OLo5V9sPcfAR1SqZNVfT9f56BqGV2s0AcYYncjS2pw6qqUZizGr+B+asNci
        P/4Xnogo9K6IinHEnNQwT1oeTKjyo01jxo32kpk/mnV4WWijqTDVnAg6Y2VvyyY2LwGnGP
        ZTRCYWn9YNr10qS7Cr5Gz3zgU9Ad2BXbQS6AZeJtYaWpeGyyY344yGXfJdu5mzjw==
Received: by filterdrecv-64fcb979b9-ds7qn with SMTP id filterdrecv-64fcb979b9-ds7qn-1-61C3CD5E-32
        2021-12-23 01:14:07.03458828 +0000 UTC m=+8644641.963188758
Received: from pearl.egauge.net (unknown)
        by geopod-ismtpd-6-0 (SG)
        with ESMTP
        id -51l937fQTCZaa8cFnq3Fw
        Thu, 23 Dec 2021 01:14:06.874 +0000 (UTC)
Received: by pearl.egauge.net (Postfix, from userid 1000)
        id C7CF770150C; Wed, 22 Dec 2021 18:14:05 -0700 (MST)
From:   David Mosberger-Tang <davidm@egauge.net>
Subject: [PATCH v2 42/50] wilc1000: simplify code by adding header/padding to
 skb
Date:   Thu, 23 Dec 2021 01:14:07 +0000 (UTC)
Message-Id: <20211223011358.4031459-43-davidm@egauge.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211223011358.4031459-1-davidm@egauge.net>
References: <20211223011358.4031459-1-davidm@egauge.net>
MIME-Version: 1.0
X-SG-EID: =?us-ascii?Q?+kMxBqj35EdRUKoy8diX1j4AXmPtd302oan+iXZuF8m2Nw4HRW2irNspffT=2Fkh?=
 =?us-ascii?Q?ET6RJF6+Prbl0h=2FEtF1rRLvJwCYg8sr53xntpFM?=
 =?us-ascii?Q?RamCYBsHW6iylotlCCb9egN=2FBBDuQ1z=2FxYKvh6c?=
 =?us-ascii?Q?ntcV6X5h9Sln5AMVFLh=2FTmorjPALjoSxE80Z+Py?=
 =?us-ascii?Q?VAL=2FVf6Ee3j117tzOqgUl1KOZeOXHRJET5Rw2q4?=
 =?us-ascii?Q?er3wUnhSGPw28bYEoKtxthUTNrxzL5g6ewA8aQ?=
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

When a packet is moved to the chip queue, push the header and add
necessary padding to the socket-buffer directly.

Signed-off-by: David Mosberger-Tang <davidm@egauge.net>
---
 .../net/wireless/microchip/wilc1000/netdev.c  |  4 ++
 .../net/wireless/microchip/wilc1000/wlan.c    | 65 +++++++++----------
 2 files changed, 33 insertions(+), 36 deletions(-)

diff --git a/drivers/net/wireless/microchip/wilc1000/netdev.c b/drivers/net/wireless/microchip/wilc1000/netdev.c
index 71cb15f042cdd..d9fbff4bfcd30 100644
--- a/drivers/net/wireless/microchip/wilc1000/netdev.c
+++ b/drivers/net/wireless/microchip/wilc1000/netdev.c
@@ -924,6 +924,10 @@ struct wilc_vif *wilc_netdev_ifc_init(struct wilc *wl, const char *name,
 	if (!ndev)
 		return ERR_PTR(-ENOMEM);
 
+	ndev->needed_headroom = ETH_CONFIG_PKT_HDR_OFFSET;
+	/* we may need up to 3 bytes of padding: */
+	ndev->needed_tailroom = 3;
+
 	vif = netdev_priv(ndev);
 	ndev->ieee80211_ptr = &vif->priv.wdev;
 	strcpy(ndev->name, name);
diff --git a/drivers/net/wireless/microchip/wilc1000/wlan.c b/drivers/net/wireless/microchip/wilc1000/wlan.c
index f89ea4839aa61..08f3e96bf72cf 100644
--- a/drivers/net/wireless/microchip/wilc1000/wlan.c
+++ b/drivers/net/wireless/microchip/wilc1000/wlan.c
@@ -626,30 +626,39 @@ static u32 tx_hdr_len(u8 type)
 	}
 }
 
-static u32 vmm_table_entry(struct sk_buff *tqe, u32 vmm_sz)
+static u32 vmm_table_entry(struct sk_buff *tqe)
 {
 	struct wilc_skb_tx_cb *tx_cb = WILC_SKB_TX_CB(tqe);
 	u32 entry;
 
-	entry = vmm_sz / 4;
+	entry = tqe->len / 4;
 	if (tx_cb->type == WILC_CFG_PKT)
 		entry |= WILC_VMM_CFG_PKT;
 	return cpu_to_le32(entry);
 }
 
 /**
- * set_header() - set WILC-specific header
+ * add_hdr_and_pad() - prepare a packet for the chip queue
  * @wilc: Pointer to the wilc structure.
  * @tqe: The packet to add to the chip queue.
+ * @hdr_len: The size of the header to add.
  * @vmm_sz: The final size of the packet, including VMM header and padding.
- * @hdr: Pointer to the header to set
+ *
+ * Bring a packet into the form required by the chip by adding a
+ * header and padding as needed.
  */
-static void set_header(struct wilc *wilc, struct sk_buff *tqe,
-		       u32 vmm_sz, void *hdr)
+static void add_hdr_and_pad(struct wilc *wilc, struct sk_buff *tqe,
+			    u32 hdr_len, u32 vmm_sz)
 {
 	struct wilc_skb_tx_cb *tx_cb = WILC_SKB_TX_CB(tqe);
 	u32 mgmt_pkt = 0, vmm_hdr, prio, data_len = tqe->len;
 	struct wilc_vif *vif;
+	void *hdr;
+
+	/* grow skb with header and pad bytes, all initialized to 0: */
+	hdr = skb_push(tqe, hdr_len);
+	if (vmm_sz > tqe->len)
+		skb_put(tqe, vmm_sz - tqe->len);
 
 	/* add the VMM header word: */
 	if (tx_cb->type == WILC_MGMT_PKT)
@@ -687,8 +696,8 @@ static int schedule_packets(struct wilc *wilc,
 	static const u8 ac_preserve_ratio[NQUEUES] = {1, 1, 1, 1};
 	u8 ac_desired_ratio[NQUEUES];
 	const u8 *num_pkts_to_add;
+	u32 vmm_sz, hdr_len;
 	bool ac_exist = 0;
-	int vmm_sz = 0;
 	struct sk_buff *tqe;
 	struct wilc_skb_tx_cb *tx_cb;
 
@@ -710,8 +719,8 @@ static int schedule_packets(struct wilc *wilc,
 					continue;
 
 				tx_cb = WILC_SKB_TX_CB(tqe);
-				vmm_sz = tx_hdr_len(tx_cb->type);
-				vmm_sz += tqe->len;
+				hdr_len = tx_hdr_len(tx_cb->type);
+				vmm_sz = hdr_len + tqe->len;
 				vmm_sz = ALIGN(vmm_sz, 4);
 
 				if (wilc->chipq_bytes + vmm_sz > WILC_TX_BUFF_SIZE) {
@@ -721,12 +730,13 @@ static int schedule_packets(struct wilc *wilc,
 				}
 				atomic_dec(&wilc->txq_entries);
 
+				add_hdr_and_pad(wilc, tqe, hdr_len, vmm_sz);
+
 				__skb_queue_tail(&wilc->chipq, tqe);
 				wilc->chipq_bytes += tqe->len;
 
-				vmm_table[vmm_table_len] = vmm_table_entry(tqe, vmm_sz);
+				vmm_table[vmm_table_len] = vmm_table_entry(tqe);
 				vmm_table_len++;
-
 			}
 		}
 		num_pkts_to_add = ac_preserve_ratio;
@@ -747,20 +757,13 @@ static int schedule_packets(struct wilc *wilc,
  */
 static int fill_vmm_table(struct wilc *wilc, u32 vmm_table[WILC_VMM_TBL_SIZE])
 {
-	int vmm_table_len = 0, vmm_sz = 0;
+	int vmm_table_len = 0;
 	struct sk_buff *tqe;
-	struct wilc_skb_tx_cb *tx_cb;
 
-	if (unlikely(wilc->chipq_bytes > 0)) {
+	if (unlikely(wilc->chipq_bytes > 0))
 		/* fill in packets that are already on the chipq: */
-		skb_queue_walk(&wilc->chipq, tqe) {
-			tx_cb = WILC_SKB_TX_CB(tqe);
-			vmm_sz = tx_hdr_len(tx_cb->type);
-			vmm_sz += tqe->len;
-			vmm_sz = ALIGN(vmm_sz, 4);
-			vmm_table[vmm_table_len++] = vmm_table_entry(tqe, vmm_sz);
-		}
-	}
+		skb_queue_walk(&wilc->chipq, tqe)
+			vmm_table[vmm_table_len++] = vmm_table_entry(tqe);
 
 	vmm_table_len = schedule_packets(wilc, vmm_table_len, vmm_table);
 	if (vmm_table_len > 0) {
@@ -872,15 +875,12 @@ static int copy_packets(struct wilc *wilc, int entries)
 	u8 ac_pkt_num_to_chip[NQUEUES] = {0, 0, 0, 0};
 	struct wilc_skb_tx_cb *tx_cb;
 	u8 *txb = wilc->tx_buffer;
-	int i, vmm_sz;
+	int i;
+	struct sk_buff *tqe;
 	u32 offset;
 
 	offset = 0;
-	i = 0;
 	do {
-		struct sk_buff *tqe;
-		u32 buffer_offset;
-
 		tqe = __skb_dequeue(&wilc->chipq);
 		if (WARN_ON(!tqe))
 			break;
@@ -889,15 +889,8 @@ static int copy_packets(struct wilc *wilc, int entries)
 		tx_cb = WILC_SKB_TX_CB(tqe);
 		ac_pkt_num_to_chip[tx_cb->q_num]++;
 
-		buffer_offset = tx_hdr_len(tx_cb->type);
-		vmm_sz = buffer_offset;
-		vmm_sz += tqe->len;
-		vmm_sz = ALIGN(vmm_sz, 4);
-
-		set_header(wilc, tqe, vmm_sz, txb + offset);
-		memcpy(&txb[offset + buffer_offset], tqe->data, tqe->len);
-		offset += vmm_sz;
-		i++;
+		memcpy(&txb[offset], tqe->data, tqe->len);
+		offset += tqe->len;
 		wilc_wlan_tx_packet_done(tqe, 1);
 	} while (--entries);
 	for (i = 0; i < NQUEUES; i++)
-- 
2.25.1

