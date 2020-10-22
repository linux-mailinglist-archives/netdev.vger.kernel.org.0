Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84526295C71
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 12:10:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2896357AbgJVKKd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Oct 2020 06:10:33 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:13343 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2896302AbgJVKKc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Oct 2020 06:10:32 -0400
Received: from localhost.localdomain (redhouse.blr.asicdesigners.com [10.193.185.57])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 09MAAK5d013211;
        Thu, 22 Oct 2020 03:10:27 -0700
From:   Rohit Maheshwari <rohitm@chelsio.com>
To:     kuba@kernel.org, netdev@vger.kernel.org, davem@davemloft.net
Cc:     secdev@chelsio.com, Rohit Maheshwari <rohitm@chelsio.com>
Subject: [net 2/7] ch_ktls: Correction in finding correct length
Date:   Thu, 22 Oct 2020 15:40:14 +0530
Message-Id: <20201022101019.7363-3-rohitm@chelsio.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20201022101019.7363-1-rohitm@chelsio.com>
References: <20201022101019.7363-1-rohitm@chelsio.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a possibility of linear skbs coming in. Correcting
the length extraction logic.

Fixes: 5a4b9fe7fece ("cxgb4/chcr: complete record tx handling")
Signed-off-by: Rohit Maheshwari <rohitm@chelsio.com>
---
 .../chelsio/inline_crypto/ch_ktls/chcr_ktls.c | 62 +++++++++++--------
 1 file changed, 37 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c b/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
index 43c723c72c61..c69c3901a707 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
+++ b/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
@@ -943,22 +943,21 @@ chcr_ktls_check_tcp_options(struct tcphdr *tcp)
  * @tx_chan - channel number.
  * return: NETDEV_TX_OK/NETDEV_TX_BUSY.
  */
-static int
-chcr_ktls_write_tcp_options(struct chcr_ktls_info *tx_info, struct sk_buff *skb,
-			    struct sge_eth_txq *q, uint32_t tx_chan)
+static int chcr_ktls_write_tcp_options(struct chcr_ktls_info *tx_info,
+				       struct sk_buff *skb,
+				       struct sge_eth_txq *q, bool fin)
 {
+	u32 ctrl, iplen, maclen, wr_mid = 0, pktlen, ndesc, len16;
 	struct fw_eth_tx_pkt_wr *wr;
 	struct cpl_tx_pkt_core *cpl;
-	u32 ctrl, iplen, maclen;
 #if IS_ENABLED(CONFIG_IPV6)
 	struct ipv6hdr *ip6;
 #endif
-	unsigned int ndesc;
 	struct tcphdr *tcp;
-	int len16, pktlen;
+	u8 buf[150] = {0};
 	struct iphdr *ip;
 	int credits;
-	u8 buf[150];
+	u64 cntrl1;
 	void *pos;
 
 	iplen = skb_network_header_len(skb);
@@ -967,7 +966,7 @@ chcr_ktls_write_tcp_options(struct chcr_ktls_info *tx_info, struct sk_buff *skb,
 	/* packet length = eth hdr len + ip hdr len + tcp hdr len
 	 * (including options).
 	 */
-	pktlen = skb->len - skb->data_len;
+	pktlen = skb_transport_offset(skb) + tcp_hdrlen(skb);
 
 	ctrl = sizeof(*cpl) + pktlen;
 	len16 = DIV_ROUND_UP(sizeof(*wr) + ctrl, 16);
@@ -980,6 +979,10 @@ chcr_ktls_write_tcp_options(struct chcr_ktls_info *tx_info, struct sk_buff *skb,
 		return NETDEV_TX_BUSY;
 	}
 
+	if (unlikely(credits < ETHTXQ_STOP_THRES)) {
+		chcr_eth_txq_stop(q);
+		wr_mid |= FW_WR_EQUEQ_F | FW_WR_EQUIQ_F;
+	}
 	pos = &q->q.desc[q->q.pidx];
 	wr = pos;
 
@@ -987,42 +990,51 @@ chcr_ktls_write_tcp_options(struct chcr_ktls_info *tx_info, struct sk_buff *skb,
 	wr->op_immdlen = htonl(FW_WR_OP_V(FW_ETH_TX_PKT_WR) |
 			       FW_WR_IMMDLEN_V(ctrl));
 
-	wr->equiq_to_len16 = htonl(FW_WR_LEN16_V(len16));
+	wr->equiq_to_len16 = htonl(wr_mid | FW_WR_LEN16_V(len16));
 	wr->r3 = 0;
 
 	cpl = (void *)(wr + 1);
 
 	/* CPL header */
-	cpl->ctrl0 = htonl(TXPKT_OPCODE_V(CPL_TX_PKT) | TXPKT_INTF_V(tx_chan) |
+	cpl->ctrl0 = htonl(TXPKT_OPCODE_V(CPL_TX_PKT) |
+			   TXPKT_INTF_V(tx_info->tx_chan) |
 			   TXPKT_PF_V(tx_info->adap->pf));
 	cpl->pack = 0;
 	cpl->len = htons(pktlen);
-	/* checksum offload */
-	cpl->ctrl1 = 0;
-
-	pos = cpl + 1;
 
 	memcpy(buf, skb->data, pktlen);
 	if (tx_info->ip_family == AF_INET) {
 		/* we need to correct ip header len */
 		ip = (struct iphdr *)(buf + maclen);
 		ip->tot_len = htons(pktlen - maclen);
+		cntrl1 = TXPKT_CSUM_TYPE_V(TX_CSUM_TCPIP);
 #if IS_ENABLED(CONFIG_IPV6)
 	} else {
 		ip6 = (struct ipv6hdr *)(buf + maclen);
 		ip6->payload_len = htons(pktlen - maclen - iplen);
+		cntrl1 = TXPKT_CSUM_TYPE_V(TX_CSUM_TCPIP6);
 #endif
 	}
+
+	cntrl1 |= T6_TXPKT_ETHHDR_LEN_V(maclen - ETH_HLEN) |
+		  TXPKT_IPHDR_LEN_V(iplen);
+	/* checksum offload */
+	cpl->ctrl1 = cpu_to_be64(cntrl1);
+
+	pos = cpl + 1;
+
 	/* now take care of the tcp header, if fin is not set then clear push
 	 * bit as well, and if fin is set, it will be sent at the last so we
 	 * need to update the tcp sequence number as per the last packet.
 	 */
 	tcp = (struct tcphdr *)(buf + maclen + iplen);
 
-	if (!tcp->fin)
+	if (!fin) {
 		tcp->psh = 0;
-	else
+		tcp->fin = 0;
+	} else {
 		tcp->seq = htonl(tx_info->prev_seq);
+	}
 
 	chcr_copy_to_txd(buf, &q->q, pos, pktlen);
 
@@ -1860,6 +1872,7 @@ static int chcr_short_record_handler(struct chcr_ktls_info *tx_info,
 /* nic tls TX handler */
 static int chcr_ktls_xmit(struct sk_buff *skb, struct net_device *dev)
 {
+	u32 tls_end_offset, tcp_seq, skb_data_len, skb_offset;
 	struct ch_ktls_port_stats_debug *port_stats;
 	struct chcr_ktls_ofld_ctx_tx *tx_ctx;
 	struct ch_ktls_stats_debug *stats;
@@ -1867,7 +1880,6 @@ static int chcr_ktls_xmit(struct sk_buff *skb, struct net_device *dev)
 	int data_len, qidx, ret = 0, mss;
 	struct tls_record_info *record;
 	struct chcr_ktls_info *tx_info;
-	u32 tls_end_offset, tcp_seq;
 	struct tls_context *tls_ctx;
 	struct sk_buff *local_skb;
 	struct sge_eth_txq *q;
@@ -1875,8 +1887,11 @@ static int chcr_ktls_xmit(struct sk_buff *skb, struct net_device *dev)
 	unsigned long flags;
 
 	tcp_seq = ntohl(th->seq);
+	skb_offset = skb_transport_offset(skb) + tcp_hdrlen(skb);
+	skb_data_len = skb->len - skb_offset;
+	data_len = skb_data_len;
 
-	mss = skb_is_gso(skb) ? skb_shinfo(skb)->gso_size : skb->data_len;
+	mss = skb_is_gso(skb) ? skb_shinfo(skb)->gso_size : data_len;
 
 	tls_ctx = tls_get_ctx(skb->sk);
 	if (unlikely(tls_ctx->netdev != dev))
@@ -1905,8 +1920,7 @@ static int chcr_ktls_xmit(struct sk_buff *skb, struct net_device *dev)
 	cxgb4_reclaim_completed_tx(adap, &q->q, true);
 	/* if tcp options are set but finish is not send the options first */
 	if (!th->fin && chcr_ktls_check_tcp_options(th)) {
-		ret = chcr_ktls_write_tcp_options(tx_info, skb, q,
-						  tx_info->tx_chan);
+		ret = chcr_ktls_write_tcp_options(tx_info, skb, q, false);
 		if (ret)
 			return NETDEV_TX_BUSY;
 	}
@@ -1922,8 +1936,6 @@ static int chcr_ktls_xmit(struct sk_buff *skb, struct net_device *dev)
 	/* copy skb contents into local skb */
 	chcr_ktls_skb_copy(skb, local_skb);
 
-	/* go through the skb and send only one record at a time. */
-	data_len = skb->data_len;
 	/* TCP segments can be in received either complete or partial.
 	 * chcr_end_part_handler will handle cases if complete record or end
 	 * part of the record is received. Incase of partial end part of record,
@@ -2020,15 +2032,15 @@ static int chcr_ktls_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	} while (data_len > 0);
 
-	tx_info->prev_seq = ntohl(th->seq) + skb->data_len;
+	tx_info->prev_seq = ntohl(th->seq) + skb_data_len;
 	atomic64_inc(&port_stats->ktls_tx_encrypted_packets);
-	atomic64_add(skb->data_len, &port_stats->ktls_tx_encrypted_bytes);
+	atomic64_add(skb_data_len, &port_stats->ktls_tx_encrypted_bytes);
 
 	/* tcp finish is set, send a separate tcp msg including all the options
 	 * as well.
 	 */
 	if (th->fin)
-		chcr_ktls_write_tcp_options(tx_info, skb, q, tx_info->tx_chan);
+		chcr_ktls_write_tcp_options(tx_info, skb, q, true);
 
 out:
 	dev_kfree_skb_any(skb);
-- 
2.18.1

