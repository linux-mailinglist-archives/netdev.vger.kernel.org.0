Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8A9747DD2F
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 02:18:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346798AbhLWBQT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 20:16:19 -0500
Received: from o1.ptr2625.egauge.net ([167.89.112.53]:27336 "EHLO
        o1.ptr2625.egauge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346239AbhLWBOp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 20:14:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=egauge.net;
        h=from:subject:in-reply-to:references:mime-version:to:cc:
        content-transfer-encoding:content-type;
        s=sgd; bh=DlCBRu7J1bxJ3/LQJt36l7jN/7IIPnFkxtrjOj9W9fc=;
        b=RktnbaWJYD0OqoDLrEerbGVsR3Dr+51Mjfx2woNob8Pdz3cneHipQRZwJrRZc9OyHBzE
        MgABOY16CKah7tXtvTk16MJ9LRGXQozIf5v/FmnVO2Ti5BuQd+O4BRde1v5RNHplHDALrK
        WB4T6PAIuG9B/Xepe/qA2bXxlj9MIC4KJRxKMOICp8cjmrv50TKxmL3yDurQNlb5MVNBfK
        /DLnSsSTEJo+OvFrKXvZZmVydSU+9qeSR2AS5yDabnb/i7/wfJksS9Ko7pO3w8I2+Ln8Xj
        R+bQT+YvCL/u7yJ8I7F7k49zY6AN6aUiXVAjyCvsvnX671Y8fZ4afb4Vx6O0Bljg==
Received: by filterdrecv-656998cfdd-5st9z with SMTP id filterdrecv-656998cfdd-5st9z-1-61C3CD5F-2
        2021-12-23 01:14:07.066588987 +0000 UTC m=+7955191.029031746
Received: from pearl.egauge.net (unknown)
        by geopod-ismtpd-5-1 (SG)
        with ESMTP
        id LkEsxIgnSluBVp_O0u0jcw
        Thu, 23 Dec 2021 01:14:06.903 +0000 (UTC)
Received: by pearl.egauge.net (Postfix, from userid 1000)
        id D1C3570150D; Wed, 22 Dec 2021 18:14:05 -0700 (MST)
From:   David Mosberger-Tang <davidm@egauge.net>
Subject: [PATCH v2 43/50] wilc1000: add support for zero-copy transmit of tx
 packets
Date:   Thu, 23 Dec 2021 01:14:07 +0000 (UTC)
Message-Id: <20211223011358.4031459-44-davidm@egauge.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211223011358.4031459-1-davidm@egauge.net>
References: <20211223011358.4031459-1-davidm@egauge.net>
MIME-Version: 1.0
X-SG-EID: =?us-ascii?Q?+kMxBqj35EdRUKoy8diX1j4AXmPtd302oan+iXZuF8m2Nw4HRW2irNspffT=2Fkh?=
 =?us-ascii?Q?ET6RJF6+Prbl0h=2FEtF1rRLvCpc2ftgM2qu67NNB?=
 =?us-ascii?Q?uHZcfjZzUnbiHUNZbafQh3Mqs3rJrxKIhGH79qo?=
 =?us-ascii?Q?89Du1mpWVV3Bd5CTB5MIKKbipe9JjI+qT4r9DVa?=
 =?us-ascii?Q?OnNwH=2FPjaQOyzCkoNYydH+RJuxohcMG84BX6wFU?=
 =?us-ascii?Q?T=2F4IqRm0hK3EdvEHCj=2FIdUSCZ4sB9Tjt7CaID9?=
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

Add the infrastructure to enable zero-copy transmits.  This is
currently a no-op as the SPI or SDIO drivers will need to implement
hif_sk_buffs_tx to take advantage of this.

Signed-off-by: David Mosberger-Tang <davidm@egauge.net>
---
 .../net/wireless/microchip/wilc1000/wlan.c    | 43 ++++++++++++++++++-
 .../net/wireless/microchip/wilc1000/wlan.h    |  2 +
 2 files changed, 44 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/microchip/wilc1000/wlan.c b/drivers/net/wireless/microchip/wilc1000/wlan.c
index 08f3e96bf72cf..d96a7e2a0bd59 100644
--- a/drivers/net/wireless/microchip/wilc1000/wlan.c
+++ b/drivers/net/wireless/microchip/wilc1000/wlan.c
@@ -935,6 +935,44 @@ static int copy_and_send_packets(struct wilc *wilc, int entries)
 	return ret;
 }
 
+/**
+ * zero_copy_send_packets() - send packets to the chip (copy-free).
+ * @wilc: Pointer to the wilc structure.
+ * @entries: The number of packets to send from the VMM table.
+ *
+ * Zero-copy version of sending the packets in the VMM table to the
+ * chip.
+ *
+ * Context: The wilc1000 bus must have been released but the chip
+ *	must be awake.
+ *
+ * Return: Negative number on error, 0 on success.
+ */
+static int zero_copy_send_packets(struct wilc *wilc, int entries)
+{
+	const struct wilc_hif_func *func = wilc->hif_func;
+	struct wilc_skb_tx_cb *tx_cb;
+	struct sk_buff *tqe;
+	int ret, i = 0;
+
+	acquire_bus(wilc, WILC_BUS_ACQUIRE_ONLY);
+
+	ret = func->hif_clear_int_ext(wilc, ENABLE_TX_VMM);
+	if (ret == 0)
+		ret = func->hif_sk_buffs_tx(wilc, 0, entries, &wilc->chipq);
+
+	release_bus(wilc, WILC_BUS_RELEASE_ALLOW_SLEEP);
+
+	for (i = 0; i < entries; ++i) {
+		tqe = __skb_dequeue(&wilc->chipq);
+		tx_cb = WILC_SKB_TX_CB(tqe);
+		wilc->fw[tx_cb->q_num].count++;
+		wilc->chipq_bytes -= tqe->len;
+		wilc_wlan_tx_packet_done(tqe, ret == 0);
+	}
+	return ret;
+}
+
 int wilc_wlan_handle_txq(struct wilc *wilc, u32 *txq_count)
 {
 	int vmm_table_len, entries;
@@ -966,7 +1004,10 @@ int wilc_wlan_handle_txq(struct wilc *wilc, u32 *txq_count)
 	if (entries <= 0) {
 		ret = entries;
 	} else {
-		ret = copy_and_send_packets(wilc, entries);
+		if (wilc->hif_func->hif_sk_buffs_tx)
+			ret = zero_copy_send_packets(wilc, entries);
+		else
+			ret = copy_and_send_packets(wilc, entries);
 	}
 	if (ret >= 0 && entries < vmm_table_len)
 		ret = WILC_VMM_ENTRY_FULL_RETRY;
diff --git a/drivers/net/wireless/microchip/wilc1000/wlan.h b/drivers/net/wireless/microchip/wilc1000/wlan.h
index 11a54320ffd05..bda31f0970bda 100644
--- a/drivers/net/wireless/microchip/wilc1000/wlan.h
+++ b/drivers/net/wireless/microchip/wilc1000/wlan.h
@@ -367,6 +367,8 @@ struct wilc_hif_func {
 	int (*hif_read_size)(struct wilc *wilc, u32 *size);
 	int (*hif_block_tx_ext)(struct wilc *wilc, u32 addr, u8 *buf, u32 size);
 	int (*hif_block_rx_ext)(struct wilc *wilc, u32 addr, u8 *buf, u32 size);
+	int (*hif_sk_buffs_tx)(struct wilc *wilc, u32 addr,
+			       size_t num_skbs, struct sk_buff_head *skbs);
 	int (*hif_sync_ext)(struct wilc *wilc, int nint);
 	int (*enable_interrupt)(struct wilc *nic);
 	void (*disable_interrupt)(struct wilc *nic);
-- 
2.25.1

