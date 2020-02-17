Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2E5B1618D0
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 18:29:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729361AbgBQR3A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 12:29:00 -0500
Received: from stargate.chelsio.com ([12.32.117.8]:3330 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728575AbgBQR3A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 12:29:00 -0500
Received: from redhouse.blr.asicdesginers.com ([10.193.187.72])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 01HHSfK0022959;
        Mon, 17 Feb 2020 09:28:56 -0800
From:   Rohit Maheshwari <rohitm@chelsio.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     manojmalviya@chelsio.com, varun@chelsio.com,
        Rohit Maheshwari <rohitm@chelsio.com>
Subject: [RFC net-next 4/6] chcr: handle partial end part of a record
Date:   Mon, 17 Feb 2020 22:58:37 +0530
Message-Id: <20200217172839.32066-5-rohitm@chelsio.com>
X-Mailer: git-send-email 2.25.0.191.gde93cc1
In-Reply-To: <20200217172839.32066-1-rohitm@chelsio.com>
References: <20200217172839.32066-1-rohitm@chelsio.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

TCP segment can chop a record in any order. Record can either be
complete or it can be partial (first part which contains header,
middle part which doesn't have header or TAG, and the end part
which contains TAG. This patch handles partial end part of a tx
record. In case of partial end part's, driver will send complete
record to HW, so that HW will calculate GHASH (TAG) of complete
packet.
Also added support to handle multiple records in a segment.

Signed-off-by: Rohit Maheshwari <rohitm@chelsio.com>
---
 drivers/crypto/chelsio/chcr_ktls.c | 314 ++++++++++++++++++++++++++++-
 1 file changed, 308 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/chelsio/chcr_ktls.c b/drivers/crypto/chelsio/chcr_ktls.c
index 70c0f2e81100..4a7b6c87f08d 100644
--- a/drivers/crypto/chelsio/chcr_ktls.c
+++ b/drivers/crypto/chelsio/chcr_ktls.c
@@ -771,6 +771,202 @@ chcr_ktls_get_tx_flits(const struct sk_buff *skb, unsigned int key_ctx_len)
 	       DIV_ROUND_UP(key_ctx_len + CHCR_KTLS_WR_SIZE, 8);
 }
 
+/*
+ * chcr_ktls_check_tcp_options: To check if there is any TCP option availbale
+ * other than timestamp.
+ * @skb - skb contains partial record..
+ * return: 1 / 0
+ */
+static int
+chcr_ktls_check_tcp_options(struct tcphdr *tcp)
+{
+	int cnt, opt, optlen;
+	u_char *cp;
+
+	cp = (u_char *)(tcp + 1);
+	cnt = (tcp->doff << 2) - sizeof(struct tcphdr);
+	for (; cnt > 0; cnt -= optlen, cp += optlen) {
+		opt = cp[0];
+		if (opt == TCPOPT_EOL)
+			break;
+		if (opt == TCPOPT_NOP) {
+			optlen = 1;
+		} else {
+			if (cnt < 2)
+				break;
+			optlen = cp[1];
+			if (optlen < 2 || optlen > cnt)
+				break;
+		}
+		switch (opt) {
+		case TCPOPT_NOP:
+		case TCPOPT_TIMESTAMP:
+			break;
+		default:
+			return 1;
+		}
+	}
+	return 0;
+}
+
+/*
+ * chcr_ktls_write_tcp_options : TP can't send out all the options, we need to
+ * send out separately.
+ * @tx_info - driver specific tls info.
+ * @skb - skb contains partial record..
+ * @q - TX queue.
+ * @tx_chan - channel number.
+ * return: NETDEV_TX_OK/NETDEV_TX_BUSY.
+ */
+static int
+chcr_ktls_write_tcp_options(struct chcr_ktls_info *tx_info, struct sk_buff *skb,
+			    struct sge_eth_txq *q, uint32_t tx_chan)
+{
+	struct fw_eth_tx_pkt_wr *wr;
+	struct cpl_tx_pkt_core *cpl;
+	u32 ctrl, iplen, maclen;
+	struct ipv6hdr *ip6;
+	unsigned int ndesc;
+	struct tcphdr *tcp;
+	int len16, pktlen;
+	struct iphdr *ip;
+	int credits;
+	u8 buf[150];
+	void *pos;
+
+	iplen = skb_network_header_len(skb);
+	maclen = skb_mac_header_len(skb);
+
+	/* packet length = eth hdr len + ip hdr len + tcp hdr len
+	 * (including options).
+	 */
+	pktlen = skb->len - skb->data_len;
+
+	ctrl = sizeof(*cpl) + pktlen;
+	len16 = DIV_ROUND_UP(sizeof(*wr) + ctrl, 16);
+	/* check how many descriptors needed */
+	ndesc = DIV_ROUND_UP(len16, 4);
+
+	credits = chcr_txq_avail(&q->q) - ndesc;
+	if (unlikely(credits < 0)) {
+		chcr_eth_txq_stop(q);
+		return NETDEV_TX_BUSY;
+	}
+
+	pos = &q->q.desc[q->q.pidx];
+	wr = pos;
+
+	/* Firmware work request header */
+	wr->op_immdlen = htonl(FW_WR_OP_V(FW_ETH_TX_PKT_WR) |
+			       FW_WR_IMMDLEN_V(ctrl));
+
+	wr->equiq_to_len16 = htonl(FW_WR_LEN16_V(len16));
+	wr->r3 = 0;
+
+	cpl = (void *)(wr + 1);
+
+	/* CPL header */
+	cpl->ctrl0 = htonl(TXPKT_OPCODE_V(CPL_TX_PKT) | TXPKT_INTF_V(tx_chan) |
+			   TXPKT_PF_V(tx_info->adap->pf));
+	cpl->pack = 0;
+	cpl->len = htons(pktlen);
+	/* checksum offload */
+	cpl->ctrl1 = 0;
+
+	pos = cpl + 1;
+
+	memcpy(buf, skb->data, pktlen);
+	if (tx_info->ip_family == AF_INET) {
+		/* we need to correct ip header len */
+		ip = (struct iphdr *)(buf + maclen);
+		ip->tot_len = htons(pktlen - maclen);
+	} else {
+		ip6 = (struct ipv6hdr *)(buf + maclen);
+		ip6->payload_len = htons(pktlen - maclen);
+	}
+	/* now take care of the tcp header, if fin is not set then clear push
+	 * bit as well, and if fin is set, it will be sent at the last so we
+	 * need to update the tcp sequence number as per the last packet.
+	 */
+	tcp = (struct tcphdr *)(buf + maclen + iplen);
+
+	if (!tcp->fin)
+		tcp->psh = 0;
+	else
+		tcp->seq = htonl(tx_info->prev_seq);
+
+	chcr_copy_to_txd(buf, &q->q, pos, pktlen);
+
+	chcr_txq_advance(&q->q, ndesc);
+	cxgb4_ring_tx_db(tx_info->adap, &q->q, ndesc);
+	return 0;
+}
+
+/* chcr_ktls_skb_shift - Shifts request length paged data from skb to another.
+ * @tgt- buffer into which tail data gets added
+ * @skb- buffer from which the paged data comes from
+ * @shiftlen- shift up to this many bytes
+ */
+static int chcr_ktls_skb_shift(struct sk_buff *tgt, struct sk_buff *skb,
+			       int shiftlen)
+{
+	skb_frag_t *fragfrom, *fragto;
+	int from, to, todo;
+
+	WARN_ON(shiftlen > skb->data_len);
+
+	todo = shiftlen;
+	from = 0;
+	to = 0;
+	fragfrom = &skb_shinfo(skb)->frags[from];
+
+	while ((todo > 0) && (from < skb_shinfo(skb)->nr_frags)) {
+		fragfrom = &skb_shinfo(skb)->frags[from];
+		fragto = &skb_shinfo(tgt)->frags[to];
+
+		if (todo >= skb_frag_size(fragfrom)) {
+			*fragto = *fragfrom;
+			todo -= skb_frag_size(fragfrom);
+			from++;
+			to++;
+
+		} else {
+			__skb_frag_ref(fragfrom);
+			skb_frag_page_copy(fragto, fragfrom);
+			skb_frag_off_copy(fragto, fragfrom);
+			skb_frag_size_set(fragto, todo);
+
+			skb_frag_off_add(fragfrom, todo);
+			skb_frag_size_sub(fragfrom, todo);
+			todo = 0;
+
+			to++;
+			break;
+		}
+	}
+
+	/* Ready to "commit" this state change to tgt */
+	skb_shinfo(tgt)->nr_frags = to;
+
+	/* Reposition in the original skb */
+	to = 0;
+	while (from < skb_shinfo(skb)->nr_frags)
+		skb_shinfo(skb)->frags[to++] = skb_shinfo(skb)->frags[from++];
+
+	skb_shinfo(skb)->nr_frags = to;
+
+	WARN_ON(todo > 0 && !skb_shinfo(skb)->nr_frags);
+
+	skb->len -= shiftlen;
+	skb->data_len -= shiftlen;
+	skb->truesize -= shiftlen;
+	tgt->len += shiftlen;
+	tgt->data_len += shiftlen;
+	tgt->truesize += shiftlen;
+
+	return shiftlen;
+}
+
 /*
  * chcr_ktls_xmit_wr_complete: This sends out the complete record. If an skb
  * received has partial end part of the record, send out the complete record, so
@@ -937,6 +1133,76 @@ static int chcr_ktls_xmit_wr_complete(struct sk_buff *skb,
 	return 0;
 }
 
+/*
+ * chcr_ktls_copy_record_in_skb
+ * @nskb - new skb where the frags to be added.
+ * @record - specific record which has complete 16k record in frags.
+ */
+static void chcr_ktls_copy_record_in_skb(struct sk_buff *nskb,
+					 struct tls_record_info *record)
+{
+	int i = 0;
+
+	for (i = 0; i < record->num_frags; i++) {
+		skb_shinfo(nskb)->frags[i] = record->frags[i];
+		/* increase the frag ref count */
+		__skb_frag_ref(&skb_shinfo(nskb)->frags[i]);
+	}
+
+	skb_shinfo(nskb)->nr_frags = record->num_frags;
+	nskb->data_len = record->len;
+	nskb->len += record->len;
+	nskb->truesize += record->len;
+}
+
+/*
+ * chcr_ktls_update_snd_una:  Reset the SEND_UNA. It will be done to avoid
+ * sending the same segment again. It will discard the segment which is before
+ * the current tx max.
+ * @tx_info - driver specific tls info.
+ * @q - TX queue.
+ * return: NET_TX_OK/NET_XMIT_DROP.
+ */
+static int chcr_ktls_update_snd_una(struct chcr_ktls_info *tx_info,
+				    struct sge_eth_txq *q)
+{
+	struct fw_ulptx_wr *wr;
+	unsigned int ndesc;
+	int credits;
+	void *pos;
+	u32 len;
+
+	len = sizeof(*wr) + roundup(CHCR_SET_TCB_FIELD_LEN, 16);
+	ndesc = DIV_ROUND_UP(len, 64);
+
+	credits = chcr_txq_avail(&q->q) - ndesc;
+	if (unlikely(credits < 0)) {
+		chcr_eth_txq_stop(q);
+		return NETDEV_TX_BUSY;
+	}
+
+	pos = &q->q.desc[q->q.pidx];
+
+	wr = pos;
+	/* ULPTX wr */
+	wr->op_to_compl = htonl(FW_WR_OP_V(FW_ULPTX_WR));
+	wr->cookie = 0;
+	/* fill len in wr field */
+	wr->flowid_len16 = htonl(FW_WR_LEN16_V(DIV_ROUND_UP(len, 16)));
+
+	pos += sizeof(*wr);
+
+	pos = chcr_write_cpl_set_tcb_ulp(tx_info, q, tx_info->tid, pos, 0,
+					 TCB_SND_UNA_RAW_W,
+					 TCB_SND_UNA_RAW_V(TCB_SND_UNA_RAW_M),
+					 TCB_SND_UNA_RAW_V(0), 0);
+
+	chcr_txq_advance(&q->q, ndesc);
+	cxgb4_ring_tx_db(tx_info->adap, &q->q, ndesc);
+
+	return 0;
+}
+
 /*
  * chcr_end_part_handler: This handler will handle the record which
  * is complete or if record's end part is received. T6 adapter has a issue that
@@ -966,8 +1232,23 @@ static int chcr_end_part_handler(struct chcr_ktls_info *tx_info,
 	if (tls_end_offset == record->len) {
 		nskb = skb;
 	} else {
-		/* handle it in next patch */
-		goto out;
+		nskb = alloc_skb(0, GFP_KERNEL);
+		if (!nskb) {
+			kfree_skb(skb);
+			return NETDEV_TX_BUSY;
+		}
+		kfree_skb(skb);
+		/* copy complete record in skb */
+		chcr_ktls_copy_record_in_skb(nskb, record);
+		/* packet is being sent from the beginning, update the tcp_seq
+		 * accordingly.
+		 */
+		tcp_seq = tls_record_start_seq(record);
+		/* reset snd una, so the middle record won't send the already
+		 * sent part.
+		 */
+		if (chcr_ktls_update_snd_una(tx_info, q))
+			goto out;
 	}
 
 	if (chcr_ktls_xmit_wr_complete(nskb, tx_info, q, tcp_seq,
@@ -977,8 +1258,7 @@ static int chcr_end_part_handler(struct chcr_ktls_info *tx_info,
 	}
 	return 0;
 out:
-	if (nskb)
-		kfree_skb(nskb);
+	kfree_skb(nskb);
 	return NETDEV_TX_BUSY;
 }
 
@@ -1031,6 +1311,13 @@ int chcr_ktls_xmit(struct sk_buff *skb, struct net_device *dev)
 	qidx = skb->queue_mapping;
 	q = &adap->sge.ethtxq[qidx + tx_info->first_qset];
 	cxgb4_reclaim_completed_tx(adap, &q->q, true);
+	/* if tcp options are set but finish is not send the options first */
+	if (!th->fin && chcr_ktls_check_tcp_options(th)) {
+		ret = chcr_ktls_write_tcp_options(tx_info, skb, q,
+						  tx_info->tx_chan);
+		if (ret)
+			return ret;
+	}
 	/* update tcb */
 	ret = chcr_ktls_xmit_tcb_cpls(tx_info, q, ntohl(th->seq),
 				      ntohl(th->ack_seq),
@@ -1087,8 +1374,14 @@ int chcr_ktls_xmit(struct sk_buff *skb, struct net_device *dev)
 			struct sk_buff *nskb = NULL;
 
 			if (tls_end_offset < data_len) {
-				/* handle it later */
-				goto clear_ref;
+				nskb = alloc_skb(0, GFP_KERNEL);
+				if (unlikely(!nskb)) {
+					ret = -ENOMEM;
+					goto clear_ref;
+				}
+
+				chcr_ktls_skb_shift(nskb, local_skb,
+						    tls_end_offset);
 			} else {
 				/* its the only record in this skb, directly
 				 * point it.
@@ -1124,6 +1417,15 @@ int chcr_ktls_xmit(struct sk_buff *skb, struct net_device *dev)
 	} while (data_len > 0);
 
 	tx_info->prev_seq = ntohl(th->seq) + skb->data_len;
+	/* tcp finish is set, send a separate tcp msg including all the options
+	 * as well.
+	 */
+	if (th->fin) {
+		ret = chcr_ktls_write_tcp_options(tx_info, skb, q,
+						  tx_info->tx_chan);
+		if (ret)
+			return ret;
+	}
 out:
 	kfree_skb(skb);
 	return NETDEV_TX_OK;
-- 
2.25.0.191.gde93cc1

