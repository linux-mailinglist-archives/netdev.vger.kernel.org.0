Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5033E3949BB
	for <lists+netdev@lfdr.de>; Sat, 29 May 2021 02:53:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229738AbhE2AzI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 20:55:08 -0400
Received: from saphodev.broadcom.com ([192.19.11.229]:39874 "EHLO
        relay.smtp-ext.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229762AbhE2AzG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 May 2021 20:55:06 -0400
Received: from localhost.swdvt.lab.broadcom.net (dhcp-10-13-253-90.swdvt.lab.broadcom.net [10.13.253.90])
        by relay.smtp-ext.broadcom.com (Postfix) with ESMTP id 33ABD7DAF;
        Fri, 28 May 2021 17:53:27 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 relay.smtp-ext.broadcom.com 33ABD7DAF
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1622249607;
        bh=tv9dqqMwAj6mYXFi93zA6+4peaai6ctP5uu4Uuy1HPM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k1sQnYFbcF8QPDUv2Li7VNJ13yRXQkuitW96xvRVCXS6TlWUc6Yr/FzM9PVJPpX7b
         IkNENth60Kqv5sN6zQTQ+Xzb3ZJWYYe1Ax1y47eM5GbIew1ZWew9piOyXEkdVseTju
         GzSFHPcyzCItUrXN22OvQ3wpPTEY7nRL0bW2gyfA=
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, gospo@broadcom.com,
        richardcochran@gmail.com, pavan.chebbi@broadcom.com,
        edwin.peer@broadcom.com
Subject: [PATCH net-next 6/7] bnxt_en: Transmit and retrieve packet timestamps.
Date:   Fri, 28 May 2021 20:53:20 -0400
Message-Id: <1622249601-7106-7-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1622249601-7106-1-git-send-email-michael.chan@broadcom.com>
References: <1622249601-7106-1-git-send-email-michael.chan@broadcom.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pavan Chebbi <pavan.chebbi@broadcom.com>

Setup the TXBD to enable TX timestamp if requested.  At TX packet DMA
completion, if we requested TX timestamp on that packet, we defer to a
worqueue to obtain the TX timestamp from the firmware before we free
the TX SKB.

Reviewed-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     | 38 ++++++++--
 drivers/net/ethernet/broadcom/bnxt/bnxt.h     |  2 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c | 70 +++++++++++++++++++
 drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h |  2 +
 4 files changed, 107 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 1fbfc0326dda..00dbc2d6c33b 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -421,12 +421,25 @@ static netdev_tx_t bnxt_start_xmit(struct sk_buff *skb, struct net_device *dev)
 			vlan_tag_flags |= 1 << TX_BD_CFA_META_TPID_SHIFT;
 	}
 
-	if (unlikely(skb->no_fcs)) {
-		lflags |= cpu_to_le32(TX_BD_FLAGS_NO_CRC);
-		goto normal_tx;
+	if (unlikely(skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP)) {
+		struct bnxt_ptp_cfg *ptp = bp->ptp_cfg;
+
+		if (ptp && ptp->tx_tstamp_en && !skb_is_gso(skb) &&
+		    atomic_dec_if_positive(&ptp->tx_avail) >= 0) {
+			if (!bnxt_ptp_parse(skb, &ptp->tx_seqid)) {
+				lflags |= cpu_to_le32(TX_BD_FLAGS_STAMP);
+				skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
+			} else {
+				atomic_inc(&bp->ptp_cfg->tx_avail);
+			}
+		}
 	}
 
-	if (free_size == bp->tx_ring_size && length <= bp->tx_push_thresh) {
+	if (unlikely(skb->no_fcs))
+		lflags |= cpu_to_le32(TX_BD_FLAGS_NO_CRC);
+
+	if (free_size == bp->tx_ring_size && length <= bp->tx_push_thresh &&
+	    !lflags) {
 		struct tx_push_buffer *tx_push_buf = txr->tx_push;
 		struct tx_push_bd *tx_push = &tx_push_buf->push_bd;
 		struct tx_bd_ext *tx_push1 = &tx_push->txbd2;
@@ -593,6 +606,8 @@ static netdev_tx_t bnxt_start_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	netdev_tx_sent_queue(txq, skb->len);
 
+	skb_tx_timestamp(skb);
+
 	/* Sync BD data before updating doorbell */
 	wmb();
 
@@ -622,6 +637,9 @@ static netdev_tx_t bnxt_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	return NETDEV_TX_OK;
 
 tx_dma_error:
+	if (BNXT_TX_PTP_IS_SET(lflags))
+		atomic_inc(&bp->ptp_cfg->tx_avail);
+
 	last_frag = i;
 
 	/* start back at beginning and unmap skb */
@@ -656,6 +674,7 @@ static void bnxt_tx_int(struct bnxt *bp, struct bnxt_napi *bnapi, int nr_pkts)
 
 	for (i = 0; i < nr_pkts; i++) {
 		struct bnxt_sw_tx_bd *tx_buf;
+		bool compl_deferred = false;
 		struct sk_buff *skb;
 		int j, last;
 
@@ -682,12 +701,21 @@ static void bnxt_tx_int(struct bnxt *bp, struct bnxt_napi *bnapi, int nr_pkts)
 				skb_frag_size(&skb_shinfo(skb)->frags[j]),
 				PCI_DMA_TODEVICE);
 		}
+		if (unlikely(skb_shinfo(skb)->tx_flags & SKBTX_IN_PROGRESS)) {
+			if (bp->flags & BNXT_FLAG_CHIP_P5) {
+				if (!bnxt_get_tx_ts_p5(bp, skb))
+					compl_deferred = true;
+				else
+					atomic_inc(&bp->ptp_cfg->tx_avail);
+			}
+		}
 
 next_tx_int:
 		cons = NEXT_TX(cons);
 
 		tx_bytes += skb->len;
-		dev_kfree_skb_any(skb);
+		if (!compl_deferred)
+			dev_kfree_skb_any(skb);
 	}
 
 	netdev_tx_completed_queue(txq, nr_pkts, tx_bytes);
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index dbefa77279ef..b6f95799a214 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -89,6 +89,8 @@ struct tx_bd_ext {
 	#define TX_BD_CFA_META_KEY_VLAN                         (1 << 28)
 };
 
+#define BNXT_TX_PTP_IS_SET(lflags) ((lflags) & cpu_to_le32(TX_BD_FLAGS_STAMP))
+
 struct rx_bd {
 	__le32 rx_bd_len_flags_type;
 	#define RX_BD_TYPE					(0x3f << 0)
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
index 538b3c8f97f1..ccd7ed6d2296 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
@@ -15,10 +15,32 @@
 #include <linux/net_tstamp.h>
 #include <linux/timecounter.h>
 #include <linux/timekeeping.h>
+#include <linux/ptp_classify.h>
 #include "bnxt_hsi.h"
 #include "bnxt.h"
 #include "bnxt_ptp.h"
 
+int bnxt_ptp_parse(struct sk_buff *skb, u16 *seq_id)
+{
+	unsigned int ptp_class;
+	struct ptp_header *hdr;
+
+	ptp_class = ptp_classify_raw(skb);
+
+	switch (ptp_class & PTP_CLASS_VMASK) {
+	case PTP_CLASS_V1:
+	case PTP_CLASS_V2:
+		hdr = ptp_parse_header(skb, ptp_class);
+		if (!hdr)
+			return -EINVAL;
+
+		*seq_id	 = ntohs(hdr->sequence_id);
+		return 0;
+	default:
+		return -ERANGE;
+	}
+}
+
 static int bnxt_ptp_settime(struct ptp_clock_info *ptp_info,
 			    const struct timespec64 *ts)
 {
@@ -247,6 +269,48 @@ static u64 bnxt_cc_read(const struct cyclecounter *cc)
 	return ns;
 }
 
+static void bnxt_ptp_ts_task(struct work_struct *work)
+{
+	struct bnxt_ptp_cfg *ptp = container_of(work, struct bnxt_ptp_cfg,
+						ptp_ts_task);
+	u32 flags = PORT_TS_QUERY_REQ_FLAGS_PATH_TX;
+	struct skb_shared_hwtstamps timestamp;
+	struct bnxt *bp = ptp->bp;
+	u64 ts = 0, ns = 0;
+	int rc;
+
+	if (!ptp->tx_skb)
+		return;
+
+	rc = bnxt_hwrm_port_ts_query(bp, flags, &ts, NULL);
+	if (!rc) {
+		memset(&timestamp, 0, sizeof(timestamp));
+		ns = timecounter_cyc2time(&ptp->tc, ts);
+		timestamp.hwtstamp = ns_to_ktime(ns);
+		skb_tstamp_tx(ptp->tx_skb, &timestamp);
+	} else {
+		netdev_err(bp->dev, "TS query for TX timer failed rc = %x\n",
+			   rc);
+	}
+
+	dev_kfree_skb_any(ptp->tx_skb);
+	ptp->tx_skb = NULL;
+	atomic_inc(&bp->ptp_cfg->tx_avail);
+}
+
+int bnxt_get_tx_ts_p5(struct bnxt *bp, struct sk_buff *skb)
+{
+	struct bnxt_ptp_cfg *ptp = bp->ptp_cfg;
+
+	if (ptp->tx_skb) {
+		netdev_err(bp->dev, "deferring skb:one SKB is still outstanding\n");
+		return -EBUSY;
+	}
+	ptp->tx_skb = skb;
+	schedule_work(&ptp->ptp_ts_task);
+	return 0;
+}
+
 int bnxt_get_rx_ts_p5(struct bnxt *bp, u64 *ts, u32 pkt_ts)
 {
 	struct bnxt_ptp_cfg *ptp = bp->ptp_cfg;
@@ -319,6 +383,7 @@ int bnxt_ptp_init(struct bnxt *bp)
 	if (IS_ERR(ptp->ptp_clock))
 		ptp->ptp_clock = NULL;
 
+	INIT_WORK(&ptp->ptp_ts_task, bnxt_ptp_ts_task);
 	return 0;
 }
 
@@ -333,4 +398,9 @@ void bnxt_ptp_clear(struct bnxt *bp)
 		ptp_clock_unregister(ptp->ptp_clock);
 
 	ptp->ptp_clock = NULL;
+	cancel_work_sync(&ptp->ptp_ts_task);
+	if (ptp->tx_skb) {
+		dev_kfree_skb_any(ptp->tx_skb);
+		ptp->tx_skb = NULL;
+	}
 }
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h
index 3bea71111231..ca5bd53bcf8c 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h
@@ -50,9 +50,11 @@ struct bnxt_ptp_cfg {
 	int			rx_filter;
 };
 
+int bnxt_ptp_parse(struct sk_buff *skb, u16 *seq_id);
 int bnxt_ptp_get_current_time(struct bnxt *bp);
 int bnxt_hwtstamp_set(struct net_device *dev, struct ifreq *ifr);
 int bnxt_hwtstamp_get(struct net_device *dev, struct ifreq *ifr);
+int bnxt_get_tx_ts_p5(struct bnxt *bp, struct sk_buff *skb);
 int bnxt_get_rx_ts_p5(struct bnxt *bp, u64 *ts, u32 pkt_ts);
 int bnxt_ptp_start(struct bnxt *bp);
 int bnxt_ptp_init(struct bnxt *bp);
-- 
2.18.1

