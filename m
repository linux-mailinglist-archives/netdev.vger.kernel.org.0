Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0C4347DD17
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 02:18:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346158AbhLWBPx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 20:15:53 -0500
Received: from o1.ptr2625.egauge.net ([167.89.112.53]:27472 "EHLO
        o1.ptr2625.egauge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346267AbhLWBOx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 20:14:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=egauge.net;
        h=from:subject:in-reply-to:references:mime-version:to:cc:
        content-transfer-encoding:content-type;
        s=sgd; bh=HXaP0alwXTa+EUaGACQmixi4C0QDifAyWeipd/C364U=;
        b=SNp27uMOGIAxB3Rg0Io+eW/LkRik1tfEtBcYaHE08DmgMTAgDHrb2m3XbN4Uf41YTFES
        gNf4zp/MmowjRXFPPRn7GJdq3HTjDfMR0TLmA1/I2W4YSbUEsK/IHI0xsG/x6DVU1wK5ID
        rF0EG9fuBKCazZFpsllfaWr2DmQSPDlF8m/Ajo7sK3w0WTolQlyl9JtCpKkKIQlBFX3zKg
        g+jX2rkSvSsRT8fYu0CufKKMw08NU4M0It+ZnLi7BRiZtv7CO8ZduDwHB4qHAlHdj5JBq9
        fYcGBA0JwnUPFefMOqb/zWBGsl1lo/cGJenxnd3T6c95xgBi3+FLfkCGmedIeFuQ==
Received: by filterdrecv-7bf5c69d5-v7fwm with SMTP id filterdrecv-7bf5c69d5-v7fwm-1-61C3CD5E-46
        2021-12-23 01:14:07.013080821 +0000 UTC m=+9687233.251367922
Received: from pearl.egauge.net (unknown)
        by geopod-ismtpd-1-1 (SG)
        with ESMTP
        id Fs4muI52RmC81AQUs-BOJQ
        Thu, 23 Dec 2021 01:14:06.863 +0000 (UTC)
Received: by pearl.egauge.net (Postfix, from userid 1000)
        id C26E2701501; Wed, 22 Dec 2021 18:14:05 -0700 (MST)
From:   David Mosberger-Tang <davidm@egauge.net>
Subject: [PATCH v2 40/50] wilc1000: introduce schedule_packets() function
Date:   Thu, 23 Dec 2021 01:14:07 +0000 (UTC)
Message-Id: <20211223011358.4031459-41-davidm@egauge.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211223011358.4031459-1-davidm@egauge.net>
References: <20211223011358.4031459-1-davidm@egauge.net>
MIME-Version: 1.0
X-SG-EID: =?us-ascii?Q?+kMxBqj35EdRUKoy8diX1j4AXmPtd302oan+iXZuF8m2Nw4HRW2irNspffT=2Fkh?=
 =?us-ascii?Q?ET6RJF6+Prbl0h=2FEtF1rRLvMOna4O64C+EU0IbF?=
 =?us-ascii?Q?+d1EnOG7clc59szXsBOdaG1ztylnbJHADMhMEtQ?=
 =?us-ascii?Q?p2I=2FxpqLi9YzOWNpcnRckNLLmFj7jbCXEUwXYDs?=
 =?us-ascii?Q?sn65=2F9FfUkdU6A3QwYQLB8zlvQq5n8r9DUe8O9m?=
 =?us-ascii?Q?PnxXdr=2F769HmCNIXZCRL=2F9tvpkZoFEEmF+ry7w?=
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

Move the packet scheduling code in its own function for improved
readability.

Signed-off-by: David Mosberger-Tang <davidm@egauge.net>
---
 .../net/wireless/microchip/wilc1000/wlan.c    | 78 ++++++++++++-------
 1 file changed, 50 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/microchip/wilc1000/wlan.c b/drivers/net/wireless/microchip/wilc1000/wlan.c
index 67f5293370d35..f01f7bade6189 100644
--- a/drivers/net/wireless/microchip/wilc1000/wlan.c
+++ b/drivers/net/wireless/microchip/wilc1000/wlan.c
@@ -669,22 +669,20 @@ static void set_header(struct wilc *wilc, struct sk_buff *tqe,
 }
 
 /**
- * fill_vmm_table() - fill VMM table with packets to be sent
+ * schedule_packets() - schedule packets for transmission
  * @wilc: Pointer to the wilc structure.
+ * @vmm_table_len: Current length of the VMM table.
  * @vmm_table: Pointer to the VMM table to fill.
  *
- * Fill VMM table with packets waiting to be sent.  The packets are
- * added based on access category (priority) but also balanced to
- * provide fairness.
- *
- * Return:
- *	The number of VMM entries filled in.  The table is 0-terminated
- *	so the returned number is at most WILC_VMM_TBL_SIZE-1.
+ * Schedule packets from the access-category queues for transmission.
+ * The scheduling is primarily in order of priority, but also takes
+ * fairness into account.  As many packets as possible are moved to
+ * the chip queue.  The chip queue has space for up to
+ * WILC_VMM_TBL_SIZE packets or up to WILC_TX_BUFF_SIZE bytes.
  */
-static int fill_vmm_table(struct wilc *wilc,
-			  u32 vmm_table[WILC_VMM_TBL_SIZE])
+static int schedule_packets(struct wilc *wilc,
+			    int i, u32 vmm_table[WILC_VMM_TBL_SIZE])
 {
-	int i;
 	u8 k, ac;
 	static const u8 ac_preserve_ratio[NQUEUES] = {1, 1, 1, 1};
 	u8 ac_desired_ratio[NQUEUES];
@@ -694,19 +692,6 @@ static int fill_vmm_table(struct wilc *wilc,
 	struct sk_buff *tqe;
 	struct wilc_skb_tx_cb *tx_cb;
 
-	i = 0;
-
-	if (unlikely(wilc->chipq_bytes > 0)) {
-		/* fill in packets that are already on the chipq: */
-		skb_queue_walk(&wilc->chipq, tqe) {
-			tx_cb = WILC_SKB_TX_CB(tqe);
-			vmm_sz = tx_hdr_len(tx_cb->type);
-			vmm_sz += tqe->len;
-			vmm_sz = ALIGN(vmm_sz, 4);
-			vmm_table[i++] = vmm_table_entry(tqe, vmm_sz);
-		}
-	}
-
 	ac_balance(wilc, ac_desired_ratio);
 	num_pkts_to_add = ac_desired_ratio;
 	do {
@@ -718,7 +703,7 @@ static int fill_vmm_table(struct wilc *wilc,
 			ac_exist = 1;
 			for (k = 0; k < num_pkts_to_add[ac]; k++) {
 				if (i >= WILC_VMM_TBL_SIZE - 1)
-					goto out;
+					return i;
 
 				tqe = skb_dequeue(&wilc->txq[ac]);
 				if (!tqe)
@@ -732,7 +717,7 @@ static int fill_vmm_table(struct wilc *wilc,
 				if (wilc->chipq_bytes + vmm_sz > WILC_TX_BUFF_SIZE) {
 					/* return packet to its queue */
 					skb_queue_head(&wilc->txq[ac], tqe);
-					goto out;
+					return i;
 				}
 				atomic_dec(&wilc->txq_entries);
 
@@ -746,8 +731,45 @@ static int fill_vmm_table(struct wilc *wilc,
 		}
 		num_pkts_to_add = ac_preserve_ratio;
 	} while (ac_exist);
-out:
-	vmm_table[i] = 0x0;
+	return i;
+}
+
+/**
+ * fill_vmm_table() - fill VMM table with packets to be sent
+ * @wilc: Pointer to the wilc structure.
+ * @vmm_table: Pointer to the VMM table to fill.
+ *
+ * Fill VMM table with packets waiting to be sent.
+ *
+ * Return: The number of VMM entries filled in.  The table is
+ *	0-terminated so the returned number is at most
+ *	WILC_VMM_TBL_SIZE-1.
+ */
+static int fill_vmm_table(struct wilc *wilc, u32 vmm_table[WILC_VMM_TBL_SIZE])
+{
+	int i;
+	int vmm_sz = 0;
+	struct sk_buff *tqe;
+	struct wilc_skb_tx_cb *tx_cb;
+
+	i = 0;
+
+	if (unlikely(wilc->chipq_bytes > 0)) {
+		/* fill in packets that are already on the chipq: */
+		skb_queue_walk(&wilc->chipq, tqe) {
+			tx_cb = WILC_SKB_TX_CB(tqe);
+			vmm_sz = tx_hdr_len(tx_cb->type);
+			vmm_sz += tqe->len;
+			vmm_sz = ALIGN(vmm_sz, 4);
+			vmm_table[i++] = vmm_table_entry(tqe, vmm_sz);
+		}
+	}
+
+	i = schedule_packets(wilc, i, vmm_table);
+	if (i > 0) {
+		WARN_ON(i >= WILC_VMM_TBL_SIZE);
+		vmm_table[i] = 0x0;
+	}
 	return i;
 }
 
-- 
2.25.1

