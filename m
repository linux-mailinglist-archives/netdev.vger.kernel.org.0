Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C723B3949BA
	for <lists+netdev@lfdr.de>; Sat, 29 May 2021 02:53:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbhE2AzI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 20:55:08 -0400
Received: from relay.smtp-ext.broadcom.com ([192.19.11.229]:39908 "EHLO
        relay.smtp-ext.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229729AbhE2AzC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 May 2021 20:55:02 -0400
Received: from localhost.swdvt.lab.broadcom.net (dhcp-10-13-253-90.swdvt.lab.broadcom.net [10.13.253.90])
        by relay.smtp-ext.broadcom.com (Postfix) with ESMTP id 57DDD7DAE;
        Fri, 28 May 2021 17:53:26 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 relay.smtp-ext.broadcom.com 57DDD7DAE
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1622249607;
        bh=/tsE8QBvbAEgheyrxPAm9/HL6zvM/8aN8z1H9bZCxCw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Uwm8g5WiTo9ZcdEWJ1y9m+sDiCquHtjVzWxKubAfhoIutdtyM7zPI1Cwiu40XhXsN
         9vM83WfqZVMxeinRZ8TXXcUTNKRV8d2wOJQ888KX/xH6ptm2pi/sc3cUzwqFcGhmtG
         ojUlBQk7002TX/t7bRQ4BEnwPz9e6HJsRFdoI+yo=
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, gospo@broadcom.com,
        richardcochran@gmail.com, pavan.chebbi@broadcom.com,
        edwin.peer@broadcom.com
Subject: [PATCH net-next 5/7] bnxt_en: Get the RX packet timestamp.
Date:   Fri, 28 May 2021 20:53:19 -0400
Message-Id: <1622249601-7106-6-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1622249601-7106-1-git-send-email-michael.chan@broadcom.com>
References: <1622249601-7106-1-git-send-email-michael.chan@broadcom.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pavan Chebbi <pavan.chebbi@broadcom.com>

If the RX packet is timestamped by the hardware, the RX completion
record will contain the lower 32-bit of the timestamp.  This needs
to be combined with the upper 16-bit of the periodic timestamp that
we get from the timer.  The previous snapshot in ptp->old_timer is
used to make sure that the snapshot is not ahead of the RX timestamp
and we adjust for wrap-around if needed.

Reviewed-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     | 19 +++++++++++++++++--
 drivers/net/ethernet/broadcom/bnxt/bnxt.h     |  3 ++-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c | 16 ++++++++++++++++
 drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h |  1 +
 4 files changed, 36 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 2b24d927fd07..1fbfc0326dda 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -1709,9 +1709,9 @@ static int bnxt_rx_pkt(struct bnxt *bp, struct bnxt_cp_ring_info *cpr,
 	u8 *data_ptr, agg_bufs, cmp_type;
 	dma_addr_t dma_addr;
 	struct sk_buff *skb;
+	u32 flags, misc;
 	void *data;
 	int rc = 0;
-	u32 misc;
 
 	rxcmp = (struct rx_cmp *)
 			&cpr->cp_desc_ring[CP_RING(cp_cons)][CP_IDX(cp_cons)];
@@ -1809,7 +1809,8 @@ static int bnxt_rx_pkt(struct bnxt *bp, struct bnxt_cp_ring_info *cpr,
 		goto next_rx_no_len;
 	}
 
-	len = le32_to_cpu(rxcmp->rx_cmp_len_flags_type) >> RX_CMP_LEN_SHIFT;
+	flags = le32_to_cpu(rxcmp->rx_cmp_len_flags_type);
+	len = flags >> RX_CMP_LEN_SHIFT;
 	dma_addr = rx_buf->mapping;
 
 	if (bnxt_rx_xdp(bp, rxr, cons, data, &data_ptr, &len, event)) {
@@ -1886,6 +1887,20 @@ static int bnxt_rx_pkt(struct bnxt *bp, struct bnxt_cp_ring_info *cpr,
 		}
 	}
 
+	if (unlikely((flags & RX_CMP_FLAGS_ITYPES_MASK) ==
+		     RX_CMP_FLAGS_ITYPE_PTP_W_TS)) {
+		if (bp->flags & BNXT_FLAG_CHIP_P5) {
+			u32 cmpl_ts = le32_to_cpu(rxcmp1->rx_cmp_timestamp);
+			u64 ns, ts;
+
+			if (!bnxt_get_rx_ts_p5(bp, &ts, cmpl_ts)) {
+				ns = timecounter_cyc2time(&bp->ptp_cfg->tc, ts);
+				memset(skb_hwtstamps(skb), 0,
+				       sizeof(*skb_hwtstamps(skb)));
+				skb_hwtstamps(skb)->hwtstamp = ns_to_ktime(ns);
+			}
+		}
+	}
 	bnxt_deliver_skb(bp, bnapi, skb);
 	rc = 1;
 
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index cf10cfff5c1b..dbefa77279ef 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -159,6 +159,7 @@ struct rx_cmp {
 	#define RX_CMP_FLAGS_RSS_VALID				(1 << 10)
 	#define RX_CMP_FLAGS_UNUSED				(1 << 11)
 	 #define RX_CMP_FLAGS_ITYPES_SHIFT			 12
+	 #define RX_CMP_FLAGS_ITYPES_MASK			 0xf000
 	 #define RX_CMP_FLAGS_ITYPE_UNKNOWN			 (0 << 12)
 	 #define RX_CMP_FLAGS_ITYPE_IP				 (1 << 12)
 	 #define RX_CMP_FLAGS_ITYPE_TCP				 (2 << 12)
@@ -240,7 +241,7 @@ struct rx_cmp_ext {
 	#define RX_CMPL_CFA_CODE_MASK				(0xffff << 16)
 	 #define RX_CMPL_CFA_CODE_SFT				 16
 
-	__le32 rx_cmp_unused3;
+	__le32 rx_cmp_timestamp;
 };
 
 #define RX_CMP_L2_ERRORS						\
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
index bdf79850fc2d..538b3c8f97f1 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
@@ -247,6 +247,22 @@ static u64 bnxt_cc_read(const struct cyclecounter *cc)
 	return ns;
 }
 
+int bnxt_get_rx_ts_p5(struct bnxt *bp, u64 *ts, u32 pkt_ts)
+{
+	struct bnxt_ptp_cfg *ptp = bp->ptp_cfg;
+	u64 time;
+
+	if (!ptp)
+		return -ENODEV;
+
+	time = READ_ONCE(ptp->old_time);
+	*ts = (time & BNXT_HI_TIMER_MASK) | pkt_ts;
+	if (pkt_ts < (time & BNXT_LO_TIMER_MASK))
+		*ts += BNXT_LO_TIMER_MASK + 1;
+
+	return 0;
+}
+
 int bnxt_ptp_start(struct bnxt *bp)
 {
 	struct bnxt_ptp_cfg *ptp = bp->ptp_cfg;
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h
index 7ea58a26720d..3bea71111231 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h
@@ -53,6 +53,7 @@ struct bnxt_ptp_cfg {
 int bnxt_ptp_get_current_time(struct bnxt *bp);
 int bnxt_hwtstamp_set(struct net_device *dev, struct ifreq *ifr);
 int bnxt_hwtstamp_get(struct net_device *dev, struct ifreq *ifr);
+int bnxt_get_rx_ts_p5(struct bnxt *bp, u64 *ts, u32 pkt_ts);
 int bnxt_ptp_start(struct bnxt *bp);
 int bnxt_ptp_init(struct bnxt *bp);
 void bnxt_ptp_clear(struct bnxt *bp);
-- 
2.18.1

