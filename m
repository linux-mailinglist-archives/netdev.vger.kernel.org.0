Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 695EC296965
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 07:32:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S370833AbgJWFcO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 01:32:14 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:62095 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S370829AbgJWFcO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Oct 2020 01:32:14 -0400
Received: from localhost.localdomain (redhouse.blr.asicdesigners.com [10.193.185.57])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 09N5VaZ6017691;
        Thu, 22 Oct 2020 22:32:10 -0700
From:   Rohit Maheshwari <rohitm@chelsio.com>
To:     kuba@kernel.org, netdev@vger.kernel.org, davem@davemloft.net
Cc:     secdev@chelsio.com, Rohit Maheshwari <rohitm@chelsio.com>
Subject: [net v2 6/7] ch_ktls/cxgb4: handle partial tag alone SKBs
Date:   Fri, 23 Oct 2020 11:01:33 +0530
Message-Id: <20201023053134.26021-7-rohitm@chelsio.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20201023053134.26021-1-rohitm@chelsio.com>
References: <20201023053134.26021-1-rohitm@chelsio.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If TCP congestion caused a very small packets which only has some
part fo the TAG, and that too is not till the end. HW can't handle
such case, so falling back to sw crypto in such cases.

v1->v2:
- Marked chcr_ktls_sw_fallback() static.

Signed-off-by: Rohit Maheshwari <rohitm@chelsio.com>
---
 .../ethernet/chelsio/cxgb4/cxgb4_debugfs.c    |   2 +
 .../net/ethernet/chelsio/cxgb4/cxgb4_uld.h    |   1 +
 .../chelsio/inline_crypto/ch_ktls/chcr_ktls.c | 115 +++++++++++++++++-
 .../chelsio/inline_crypto/ch_ktls/chcr_ktls.h |   1 +
 4 files changed, 118 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c
index 0273f40b85f7..17410fe86626 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c
@@ -3573,6 +3573,8 @@ static int chcr_stats_show(struct seq_file *seq, void *v)
 		   atomic64_read(&adap->ch_ktls_stats.ktls_tx_complete_pkts));
 	seq_printf(seq, "TX trim pkts :                    %20llu\n",
 		   atomic64_read(&adap->ch_ktls_stats.ktls_tx_trimmed_pkts));
+	seq_printf(seq, "TX sw fallback :                  %20llu\n",
+		   atomic64_read(&adap->ch_ktls_stats.ktls_tx_fallback));
 	while (i < MAX_NPORTS) {
 		ktls_port = &adap->ch_ktls_stats.ktls_port[i];
 		seq_printf(seq, "Port %d\n", i);
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h
index 65a8d4d4c6e5..c3e51da08877 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h
@@ -388,6 +388,7 @@ struct ch_ktls_stats_debug {
 	atomic64_t ktls_tx_retransmit_pkts;
 	atomic64_t ktls_tx_complete_pkts;
 	atomic64_t ktls_tx_trimmed_pkts;
+	atomic64_t ktls_tx_fallback;
 };
 #endif
 
diff --git a/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c b/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
index 9cb987607f3d..95092118d91e 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
+++ b/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
@@ -1530,6 +1530,88 @@ static int chcr_ktls_tx_plaintxt(struct chcr_ktls_info *tx_info,
 	return 0;
 }
 
+static int chcr_ktls_tunnel_pkt(struct chcr_ktls_info *tx_info,
+				struct sk_buff *skb,
+				struct sge_eth_txq *q)
+{
+	u32 ctrl, iplen, maclen, wr_mid = 0, len16;
+	struct tx_sw_desc *sgl_sdesc;
+	struct fw_eth_tx_pkt_wr *wr;
+	struct cpl_tx_pkt_core *cpl;
+	unsigned int flits, ndesc;
+	int credits, last_desc;
+	u64 cntrl1, *end;
+	void *pos;
+
+	ctrl = sizeof(*cpl);
+	flits = DIV_ROUND_UP(sizeof(*wr) + ctrl, 8);
+
+	flits += chcr_sgl_len(skb_shinfo(skb)->nr_frags + 1);
+	len16 = DIV_ROUND_UP(flits, 2);
+	/* check how many descriptors needed */
+	ndesc = DIV_ROUND_UP(flits, 8);
+
+	credits = chcr_txq_avail(&q->q) - ndesc;
+	if (unlikely(credits < 0)) {
+		chcr_eth_txq_stop(q);
+		return -ENOMEM;
+	}
+
+	if (unlikely(credits < ETHTXQ_STOP_THRES)) {
+		chcr_eth_txq_stop(q);
+		wr_mid |= FW_WR_EQUEQ_F | FW_WR_EQUIQ_F;
+	}
+
+	last_desc = q->q.pidx + ndesc - 1;
+	if (last_desc >= q->q.size)
+		last_desc -= q->q.size;
+	sgl_sdesc = &q->q.sdesc[last_desc];
+
+	if (unlikely(cxgb4_map_skb(tx_info->adap->pdev_dev, skb,
+				   sgl_sdesc->addr) < 0)) {
+		memset(sgl_sdesc->addr, 0, sizeof(sgl_sdesc->addr));
+		q->mapping_err++;
+		return -ENOMEM;
+	}
+
+	iplen = skb_network_header_len(skb);
+	maclen = skb_mac_header_len(skb);
+
+	pos = &q->q.desc[q->q.pidx];
+	end = (u64 *)pos + flits;
+	wr = pos;
+
+	/* Firmware work request header */
+	wr->op_immdlen = htonl(FW_WR_OP_V(FW_ETH_TX_PKT_WR) |
+			       FW_WR_IMMDLEN_V(ctrl));
+
+	wr->equiq_to_len16 = htonl(wr_mid | FW_WR_LEN16_V(len16));
+	wr->r3 = 0;
+
+	cpl = (void *)(wr + 1);
+
+	/* CPL header */
+	cpl->ctrl0 = htonl(TXPKT_OPCODE_V(CPL_TX_PKT) |
+			   TXPKT_INTF_V(tx_info->tx_chan) |
+			   TXPKT_PF_V(tx_info->adap->pf));
+	cpl->pack = 0;
+	cntrl1 = TXPKT_CSUM_TYPE_V(tx_info->ip_family == AF_INET ?
+				   TX_CSUM_TCPIP : TX_CSUM_TCPIP6);
+	cntrl1 |= T6_TXPKT_ETHHDR_LEN_V(maclen - ETH_HLEN) |
+		  TXPKT_IPHDR_LEN_V(iplen);
+	/* checksum offload */
+	cpl->ctrl1 = cpu_to_be64(cntrl1);
+	cpl->len = htons(skb->len);
+
+	pos = cpl + 1;
+
+	cxgb4_write_sgl(skb, &q->q, pos, end, 0, sgl_sdesc->addr);
+	sgl_sdesc->skb = skb;
+	chcr_txq_advance(&q->q, ndesc);
+	cxgb4_ring_tx_db(tx_info->adap, &q->q, ndesc);
+	return 0;
+}
+
 /*
  * chcr_ktls_copy_record_in_skb
  * @nskb - new skb where the frags to be added.
@@ -1681,7 +1763,7 @@ static int chcr_short_record_handler(struct chcr_ktls_info *tx_info,
 				      (TLS_CIPHER_AES_GCM_128_TAG_SIZE -
 				       remaining_record);
 		if (!trimmed_len)
-			goto out;
+			return FALLBACK;
 
 		WARN_ON(trimmed_len > data_len);
 
@@ -1779,6 +1861,34 @@ static int chcr_short_record_handler(struct chcr_ktls_info *tx_info,
 	return NETDEV_TX_BUSY;
 }
 
+static int chcr_ktls_sw_fallback(struct sk_buff *skb,
+				 struct chcr_ktls_info *tx_info,
+				 struct sge_eth_txq *q)
+{
+	u32 data_len, skb_offset;
+	struct sk_buff *nskb;
+	struct tcphdr *th;
+
+	nskb = tls_encrypt_skb(skb);
+
+	if (!nskb)
+		return 0;
+
+	th = tcp_hdr(nskb);
+	skb_offset =  skb_transport_offset(nskb) + tcp_hdrlen(nskb);
+	data_len = nskb->len - skb_offset;
+	skb_tx_timestamp(nskb);
+
+	if (chcr_ktls_tunnel_pkt(tx_info, nskb, q))
+		goto out;
+
+	tx_info->prev_seq = ntohl(th->seq) + data_len;
+	atomic64_inc(&tx_info->adap->ch_ktls_stats.ktls_tx_fallback);
+	return 0;
+out:
+	dev_kfree_skb_any(nskb);
+	return 0;
+}
 /* nic tls TX handler */
 static int chcr_ktls_xmit(struct sk_buff *skb, struct net_device *dev)
 {
@@ -1943,6 +2053,9 @@ static int chcr_ktls_xmit(struct sk_buff *skb, struct net_device *dev)
 			if (th->fin)
 				dev_kfree_skb_any(skb);
 
+			if (ret == FALLBACK)
+				return chcr_ktls_sw_fallback(skb, tx_info, q);
+
 			return NETDEV_TX_OK;
 		}
 
diff --git a/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.h b/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.h
index c1651b1431a0..18b3b1f02415 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.h
+++ b/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.h
@@ -26,6 +26,7 @@
 
 #define CHCR_KTLS_WR_SIZE	(CHCR_PLAIN_TX_DATA_LEN +\
 				 sizeof(struct cpl_tx_sec_pdu))
+#define FALLBACK		35
 
 enum ch_ktls_open_state {
 	CH_KTLS_OPEN_SUCCESS = 0,
-- 
2.18.1

