Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F3B047DD19
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 02:18:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346684AbhLWBP4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 20:15:56 -0500
Received: from o1.ptr2625.egauge.net ([167.89.112.53]:27402 "EHLO
        o1.ptr2625.egauge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346257AbhLWBOw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 20:14:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=egauge.net;
        h=from:subject:in-reply-to:references:mime-version:to:cc:
        content-transfer-encoding:content-type;
        s=sgd; bh=GoRCB1qp+NT2deD6O9F/OqL86QNfyIxkoZDwvyfsbMo=;
        b=lFqhO/+PNUc/uADkjVfHwOdQFkGTAjnHitQFjZGkikHzAXCIZE87fwv0ZgPt4pTmm+/H
        GN6K/yYa6m+WN168nBItYqvn+jF3U67cf/1453LvM9bY5PCIH0m4IiNUWz2TvYGSRhZdup
        JSFFiBrIKkTSLwQ2AikuTMms+3tUCTF7LlKJSSG2iE0vDVUzx8+kUAlZqFza0n3VsFmspT
        XMiKp3JHjVLR0ii+k3OB2Si42NReWF3wr7PDChcr5CV1ptFvhpug5H+6EOsVaPY65ZG3CZ
        9ZBjf7viyaOJBawFKsTbFBO1NLr6upwsB4GMAGpETcZssOhqPE+R7xRm8c36q6Vw==
Received: by filterdrecv-75ff7b5ffb-bdt5z with SMTP id filterdrecv-75ff7b5ffb-bdt5z-1-61C3CD5E-4A
        2021-12-23 01:14:06.973210454 +0000 UTC m=+9687191.495886346
Received: from pearl.egauge.net (unknown)
        by geopod-ismtpd-2-0 (SG)
        with ESMTP
        id j9HPaFX1RKqwFyYUORk8dQ
        Thu, 23 Dec 2021 01:14:06.858 +0000 (UTC)
Received: by pearl.egauge.net (Postfix, from userid 1000)
        id B9D61700BB0; Wed, 22 Dec 2021 18:14:05 -0700 (MST)
From:   David Mosberger-Tang <davidm@egauge.net>
Subject: [PATCH v2 37/50] wilc1000: introduce set_header() function
Date:   Thu, 23 Dec 2021 01:14:07 +0000 (UTC)
Message-Id: <20211223011358.4031459-38-davidm@egauge.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211223011358.4031459-1-davidm@egauge.net>
References: <20211223011358.4031459-1-davidm@egauge.net>
MIME-Version: 1.0
X-SG-EID: =?us-ascii?Q?+kMxBqj35EdRUKoy8diX1j4AXmPtd302oan+iXZuF8m2Nw4HRW2irNspffT=2Fkh?=
 =?us-ascii?Q?ET6RJF6+Prbl0h=2FEtF1rRLvN1V65Kxvy8FSt8Tq?=
 =?us-ascii?Q?vXxPJ4NYhhzW59EiQOJdXjEbKiDG1I=2FgLb8fMJL?=
 =?us-ascii?Q?j1arpTJuPbRzYLx7qBu=2FkxTrwwnlEms8fygl9yE?=
 =?us-ascii?Q?0xJmovOv6xegtmlKXKPAShxsLSqs+pYGHpEJjNn?=
 =?us-ascii?Q?ioMTsWtKbFfR78wyFdVKobGn19RFjA0V7Q79t9?=
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

Refactor the transmit packet header initialization into its own
set_header() function.

Signed-off-by: David Mosberger-Tang <davidm@egauge.net>
---
 .../net/wireless/microchip/wilc1000/wlan.c    | 56 +++++++++++--------
 1 file changed, 33 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/microchip/wilc1000/wlan.c b/drivers/net/wireless/microchip/wilc1000/wlan.c
index c3802a34defed..86b945e5ee076 100644
--- a/drivers/net/wireless/microchip/wilc1000/wlan.c
+++ b/drivers/net/wireless/microchip/wilc1000/wlan.c
@@ -640,6 +640,37 @@ static u32 vmm_table_entry(struct sk_buff *tqe, u32 vmm_sz)
 	return cpu_to_le32(entry);
 }
 
+/**
+ * set_header() - set WILC-specific header
+ * @wilc: Pointer to the wilc structure.
+ * @tqe: The packet to add to the chip queue.
+ * @vmm_sz: The final size of the packet, including VMM header and padding.
+ * @hdr: Pointer to the header to set
+ */
+static void set_header(struct wilc *wilc, struct sk_buff *tqe,
+		       u32 vmm_sz, void *hdr)
+{
+	struct wilc_skb_tx_cb *tx_cb = WILC_SKB_TX_CB(tqe);
+	u32 mgmt_pkt = 0, vmm_hdr, prio, data_len = tqe->len;
+	struct wilc_vif *vif;
+
+	/* add the VMM header word: */
+	if (tx_cb->type == WILC_MGMT_PKT)
+		mgmt_pkt = FIELD_PREP(WILC_VMM_HDR_MGMT_FIELD, 1);
+	vmm_hdr = cpu_to_le32(mgmt_pkt |
+			      FIELD_PREP(WILC_VMM_HDR_TYPE, tx_cb->type) |
+			      FIELD_PREP(WILC_VMM_HDR_PKT_SIZE, data_len) |
+			      FIELD_PREP(WILC_VMM_HDR_BUFF_SIZE, vmm_sz));
+	memcpy(hdr, &vmm_hdr, 4);
+
+	if (tx_cb->type == WILC_NET_PKT) {
+		vif = netdev_priv(tqe->dev);
+		prio = cpu_to_le32(tx_cb->q_num);
+		memcpy(hdr + 4, &prio, sizeof(prio));
+		memcpy(hdr + 8, vif->bssid, ETH_ALEN);
+	}
+}
+
 /**
  * fill_vmm_table() - Fill VMM table with packets to be sent
  * @wilc: Pointer to the wilc structure.
@@ -827,7 +858,6 @@ static int copy_packets(struct wilc *wilc, int entries, u32 *vmm_table,
 	u8 ac_pkt_num_to_chip[NQUEUES] = {0, 0, 0, 0};
 	struct wilc_skb_tx_cb *tx_cb;
 	u8 *txb = wilc->tx_buffer;
-	struct wilc_vif *vif;
 	int i, vmm_sz;
 	u32 offset;
 
@@ -835,9 +865,7 @@ static int copy_packets(struct wilc *wilc, int entries, u32 *vmm_table,
 	i = 0;
 	do {
 		struct sk_buff *tqe;
-		u32 header, buffer_offset;
-		char *bssid;
-		u8 mgmt_ptk = 0;
+		u32 buffer_offset;
 
 		tqe = skb_dequeue(&wilc->txq[vmm_entries_ac[i]]);
 		if (!tqe)
@@ -845,7 +873,6 @@ static int copy_packets(struct wilc *wilc, int entries, u32 *vmm_table,
 
 		atomic_dec(&wilc->txq_entries);
 		ac_pkt_num_to_chip[vmm_entries_ac[i]]++;
-		vif = netdev_priv(tqe->dev);
 		tx_cb = WILC_SKB_TX_CB(tqe);
 		if (vmm_table[i] == 0)
 			break;
@@ -854,25 +881,8 @@ static int copy_packets(struct wilc *wilc, int entries, u32 *vmm_table,
 		vmm_sz = FIELD_GET(WILC_VMM_BUFFER_SIZE, vmm_table[i]);
 		vmm_sz *= 4;
 
-		if (tx_cb->type == WILC_MGMT_PKT)
-			mgmt_ptk = 1;
-
-		header = (FIELD_PREP(WILC_VMM_HDR_TYPE, tx_cb->type) |
-			  FIELD_PREP(WILC_VMM_HDR_MGMT_FIELD, mgmt_ptk) |
-			  FIELD_PREP(WILC_VMM_HDR_PKT_SIZE, tqe->len) |
-			  FIELD_PREP(WILC_VMM_HDR_BUFF_SIZE, vmm_sz));
-
-		cpu_to_le32s(&header);
-		memcpy(&txb[offset], &header, 4);
 		buffer_offset = tx_hdr_len(tx_cb->type);
-		if (tx_cb->type == WILC_NET_PKT) {
-			int prio = tx_cb->q_num;
-
-			bssid = vif->bssid;
-			memcpy(&txb[offset + 4], &prio, sizeof(prio));
-			memcpy(&txb[offset + 8], bssid, 6);
-		}
-
+		set_header(wilc, tqe, vmm_sz, txb + offset);
 		memcpy(&txb[offset + buffer_offset], tqe->data, tqe->len);
 		offset += vmm_sz;
 		i++;
-- 
2.25.1

