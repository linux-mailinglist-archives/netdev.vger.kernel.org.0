Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9548817CEC5
	for <lists+netdev@lfdr.de>; Sat,  7 Mar 2020 15:36:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726462AbgCGOgo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Mar 2020 09:36:44 -0500
Received: from stargate.chelsio.com ([12.32.117.8]:65202 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726444AbgCGOgo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Mar 2020 09:36:44 -0500
Received: from redhouse-blr-asicdesigners-com.blr.asicdesigners.com (redhouse.blr.asicdesigners.com [10.193.185.57])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 027Ea9n1031095;
        Sat, 7 Mar 2020 06:36:31 -0800
From:   Rohit Maheshwari <rohitm@chelsio.com>
To:     borisp@mellanox.com, netdev@vger.kernel.org, davem@davemloft.net
Cc:     herbert@gondor.apana.org.au, kuba@kernel.org, secdev@chelsio.com,
        varun@chelsio.com, Rohit Maheshwari <rohitm@chelsio.com>
Subject: [PATCH net-next v4 5/6] chcr: Handle first or middle part of record
Date:   Sat,  7 Mar 2020 20:06:07 +0530
Message-Id: <20200307143608.13109-6-rohitm@chelsio.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20200307143608.13109-1-rohitm@chelsio.com>
References: <20200307143608.13109-1-rohitm@chelsio.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch contains handling of first part or middle part of the record.
When we get a middle record, we will fetch few already sent bytes to
make packet start 16 byte aligned.
And if the packet has only the header part, we don't need to send it for
packet encryption, send that packet as a plaintext.

v1->v2:
- un-necessary updating left variable.

v3->v4:
- replaced kfree_skb with dev_kfree_skb_any.

Signed-off-by: Rohit Maheshwari <rohitm@chelsio.com>
---
 drivers/crypto/chelsio/chcr_common.h |   3 +
 drivers/crypto/chelsio/chcr_ktls.c   | 486 ++++++++++++++++++++++++++-
 drivers/crypto/chelsio/chcr_ktls.h   |   2 +
 3 files changed, 489 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/chelsio/chcr_common.h b/drivers/crypto/chelsio/chcr_common.h
index f4ccea68df6f..33f589cbfba1 100644
--- a/drivers/crypto/chelsio/chcr_common.h
+++ b/drivers/crypto/chelsio/chcr_common.h
@@ -10,10 +10,13 @@
 #define CHCR_KEYCTX_MAC_KEY_SIZE_128       0
 #define CHCR_KEYCTX_CIPHER_KEY_SIZE_128    0
 #define CHCR_SCMD_CIPHER_MODE_AES_GCM      2
+#define CHCR_SCMD_CIPHER_MODE_AES_CTR      3
 #define CHCR_CPL_TX_SEC_PDU_LEN_64BIT      2
 #define CHCR_SCMD_SEQ_NO_CTRL_64BIT        3
 #define CHCR_SCMD_PROTO_VERSION_TLS        0
+#define CHCR_SCMD_PROTO_VERSION_GENERIC    4
 #define CHCR_SCMD_AUTH_MODE_GHASH          4
+#define AES_BLOCK_LEN                      16
 
 enum chcr_state {
 	CHCR_INIT = 0,
diff --git a/drivers/crypto/chelsio/chcr_ktls.c b/drivers/crypto/chelsio/chcr_ktls.c
index 57b798b535af..5dff444b4104 100644
--- a/drivers/crypto/chelsio/chcr_ktls.c
+++ b/drivers/crypto/chelsio/chcr_ktls.c
@@ -55,6 +55,18 @@ static int chcr_ktls_save_keys(struct chcr_ktls_info *tx_info,
 		/* keys will be sent inline. */
 		tx_info->scmd0_ivgen_hdrlen = SCMD_KEY_CTX_INLINE_F;
 
+		/* The SCMD fields used when encrypting a partial TLS
+		 * record (no trailer and possibly a truncated payload).
+		 */
+		tx_info->scmd0_short_seqno_numivs =
+			SCMD_CIPH_AUTH_SEQ_CTRL_F |
+			SCMD_PROTO_VERSION_V(CHCR_SCMD_PROTO_VERSION_GENERIC) |
+			SCMD_CIPH_MODE_V(CHCR_SCMD_CIPHER_MODE_AES_CTR) |
+			SCMD_IV_SIZE_V(AES_BLOCK_LEN >> 1);
+
+		tx_info->scmd0_short_ivgen_hdrlen =
+			tx_info->scmd0_ivgen_hdrlen | SCMD_AADIVDROP_F;
+
 		break;
 
 	default:
@@ -1144,6 +1156,314 @@ static int chcr_ktls_xmit_wr_complete(struct sk_buff *skb,
 	return 0;
 }
 
+/*
+ * chcr_ktls_xmit_wr_short: This is to send out partial records. If its
+ * a middle part of a record, fetch the prior data to make it 16 byte aligned
+ * and then only send it out.
+ *
+ * @skb - skb contains partial record..
+ * @tx_info - driver specific tls info.
+ * @q - TX queue.
+ * @tcp_seq
+ * @tcp_push - tcp push bit.
+ * @mss - segment size.
+ * @tls_rec_offset - offset from start of the tls record.
+ * @perior_data - data before the current segment, required to make this record
+ *		  16 byte aligned.
+ * @prior_data_len - prior_data length (less than 16)
+ * return: NETDEV_TX_BUSY/NET_TX_OK.
+ */
+static int chcr_ktls_xmit_wr_short(struct sk_buff *skb,
+				   struct chcr_ktls_info *tx_info,
+				   struct sge_eth_txq *q,
+				   u32 tcp_seq, bool tcp_push, u32 mss,
+				   u32 tls_rec_offset, u8 *prior_data,
+				   u32 prior_data_len)
+{
+	struct adapter *adap = tx_info->adap;
+	u32 len16, wr_mid = 0, cipher_start;
+	unsigned int flits = 0, ndesc;
+	int credits, left, last_desc;
+	struct tx_sw_desc *sgl_sdesc;
+	struct cpl_tx_data *tx_data;
+	struct cpl_tx_sec_pdu *cpl;
+	struct ulptx_idata *idata;
+	struct ulp_txpkt *ulptx;
+	struct fw_ulptx_wr *wr;
+	__be64 iv_record;
+	void *pos;
+	u64 *end;
+
+	/* get the number of flits required, it's a partial record so 2 flits
+	 * (AES_BLOCK_SIZE) will be added.
+	 */
+	flits = chcr_ktls_get_tx_flits(skb, tx_info->key_ctx_len) + 2;
+	/* get the correct 8 byte IV of this record */
+	iv_record = cpu_to_be64(tx_info->iv + tx_info->record_no);
+	/* If it's a middle record and not 16 byte aligned to run AES CTR, need
+	 * to make it 16 byte aligned. So atleadt 2 extra flits of immediate
+	 * data will be added.
+	 */
+	if (prior_data_len)
+		flits += 2;
+	/* number of descriptors */
+	ndesc = chcr_flits_to_desc(flits);
+	/* check if enough credits available */
+	credits = chcr_txq_avail(&q->q) - ndesc;
+	if (unlikely(credits < 0)) {
+		chcr_eth_txq_stop(q);
+		return NETDEV_TX_BUSY;
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
+	if (unlikely(cxgb4_map_skb(adap->pdev_dev, skb, sgl_sdesc->addr) < 0)) {
+		memset(sgl_sdesc->addr, 0, sizeof(sgl_sdesc->addr));
+		q->mapping_err++;
+		return NETDEV_TX_BUSY;
+	}
+
+	pos = &q->q.desc[q->q.pidx];
+	end = (u64 *)pos + flits;
+	/* FW_ULPTX_WR */
+	wr = pos;
+	/* WR will need len16 */
+	len16 = DIV_ROUND_UP(flits, 2);
+	wr->op_to_compl = htonl(FW_WR_OP_V(FW_ULPTX_WR));
+	wr->flowid_len16 = htonl(wr_mid | FW_WR_LEN16_V(len16));
+	wr->cookie = 0;
+	pos += sizeof(*wr);
+	/* ULP_TXPKT */
+	ulptx = pos;
+	ulptx->cmd_dest = htonl(ULPTX_CMD_V(ULP_TX_PKT) |
+				ULP_TXPKT_CHANNELID_V(tx_info->port_id) |
+				ULP_TXPKT_FID_V(q->q.cntxt_id) |
+				ULP_TXPKT_RO_F);
+	ulptx->len = htonl(len16 - 1);
+	/* ULPTX_IDATA sub-command */
+	idata = (struct ulptx_idata *)(ulptx + 1);
+	idata->cmd_more = htonl(ULPTX_CMD_V(ULP_TX_SC_IMM) | ULP_TX_SC_MORE_F);
+	/* idata length will include cpl_tx_sec_pdu + key context size +
+	 * cpl_tx_data header.
+	 */
+	idata->len = htonl(sizeof(*cpl) + tx_info->key_ctx_len +
+			   sizeof(*tx_data) + AES_BLOCK_LEN + prior_data_len);
+	/* SEC CPL */
+	cpl = (struct cpl_tx_sec_pdu *)(idata + 1);
+	/* cipher start will have tls header + iv size extra if its a header
+	 * part of tls record. else only 16 byte IV will be added.
+	 */
+	cipher_start =
+		AES_BLOCK_LEN + 1 +
+		(!tls_rec_offset ? TLS_HEADER_SIZE + tx_info->iv_size : 0);
+
+	cpl->op_ivinsrtofst =
+		htonl(CPL_TX_SEC_PDU_OPCODE_V(CPL_TX_SEC_PDU) |
+		      CPL_TX_SEC_PDU_CPLLEN_V(CHCR_CPL_TX_SEC_PDU_LEN_64BIT) |
+		      CPL_TX_SEC_PDU_IVINSRTOFST_V(1));
+	cpl->pldlen = htonl(skb->data_len + AES_BLOCK_LEN + prior_data_len);
+	cpl->aadstart_cipherstop_hi =
+		htonl(CPL_TX_SEC_PDU_CIPHERSTART_V(cipher_start));
+	cpl->cipherstop_lo_authinsert = 0;
+	/* These two flits are actually a CPL_TLS_TX_SCMD_FMT. */
+	cpl->seqno_numivs = htonl(tx_info->scmd0_short_seqno_numivs);
+	cpl->ivgen_hdrlen = htonl(tx_info->scmd0_short_ivgen_hdrlen);
+	cpl->scmd1 = 0;
+
+	pos = cpl + 1;
+	/* check if space left to fill the keys */
+	left = (void *)q->q.stat - pos;
+	if (!left) {
+		left = (void *)end - (void *)q->q.stat;
+		pos = q->q.desc;
+		end = pos + left;
+	}
+
+	pos = chcr_copy_to_txd(&tx_info->key_ctx, &q->q, pos,
+			       tx_info->key_ctx_len);
+	left = (void *)q->q.stat - pos;
+
+	if (!left) {
+		left = (void *)end - (void *)q->q.stat;
+		pos = q->q.desc;
+		end = pos + left;
+	}
+	/* CPL_TX_DATA */
+	tx_data = (void *)pos;
+	OPCODE_TID(tx_data) = htonl(MK_OPCODE_TID(CPL_TX_DATA, tx_info->tid));
+	tx_data->len = htonl(TX_DATA_MSS_V(mss) |
+			TX_LENGTH_V(skb->data_len + prior_data_len));
+	tx_data->rsvd = htonl(tcp_seq);
+	tx_data->flags = htonl(TX_BYPASS_F);
+	if (tcp_push)
+		tx_data->flags |= htonl(TX_PUSH_F | TX_SHOVE_F);
+
+	/* check left again, it might go beyond queue limit */
+	pos = tx_data + 1;
+	left = (void *)q->q.stat - pos;
+
+	/* check the position again */
+	if (!left) {
+		left = (void *)end - (void *)q->q.stat;
+		pos = q->q.desc;
+		end = pos + left;
+	}
+	/* copy the 16 byte IV for AES-CTR, which includes 4 bytes of salt, 8
+	 * bytes of actual IV and 4 bytes of 16 byte-sequence.
+	 */
+	memcpy(pos, tx_info->key_ctx.salt, tx_info->salt_size);
+	memcpy(pos + tx_info->salt_size, &iv_record, tx_info->iv_size);
+	*(__be32 *)(pos + tx_info->salt_size + tx_info->iv_size) =
+		htonl(2 + (tls_rec_offset ? ((tls_rec_offset -
+		(TLS_HEADER_SIZE + tx_info->iv_size)) / AES_BLOCK_LEN) : 0));
+
+	pos += 16;
+	/* Prior_data_len will always be less than 16 bytes, fill the
+	 * prio_data_len after AES_CTRL_BLOCK and clear the remaining length
+	 * to 0.
+	 */
+	if (prior_data_len)
+		pos = chcr_copy_to_txd(prior_data, &q->q, pos, 16);
+	/* send the complete packet except the header */
+	cxgb4_write_sgl(skb, &q->q, pos, end, skb->len - skb->data_len,
+			sgl_sdesc->addr);
+	sgl_sdesc->skb = skb;
+
+	chcr_txq_advance(&q->q, ndesc);
+	cxgb4_ring_tx_db(adap, &q->q, ndesc);
+
+	return 0;
+}
+
+/*
+ * chcr_ktls_tx_plaintxt: This handler will take care of the records which has
+ * only plain text (only tls header and iv)
+ * @tx_info - driver specific tls info.
+ * @skb - skb contains partial record..
+ * @tcp_seq
+ * @mss - segment size.
+ * @tcp_push - tcp push bit.
+ * @q - TX queue.
+ * @port_id : port number
+ * @perior_data - data before the current segment, required to make this record
+ *		 16 byte aligned.
+ * @prior_data_len - prior_data length (less than 16)
+ * return: NETDEV_TX_BUSY/NET_TX_OK.
+ */
+static int chcr_ktls_tx_plaintxt(struct chcr_ktls_info *tx_info,
+				 struct sk_buff *skb, u32 tcp_seq, u32 mss,
+				 bool tcp_push, struct sge_eth_txq *q,
+				 u32 port_id, u8 *prior_data,
+				 u32 prior_data_len)
+{
+	int credits, left, len16, last_desc;
+	unsigned int flits = 0, ndesc;
+	struct tx_sw_desc *sgl_sdesc;
+	struct cpl_tx_data *tx_data;
+	struct ulptx_idata *idata;
+	struct ulp_txpkt *ulptx;
+	struct fw_ulptx_wr *wr;
+	u32 wr_mid = 0;
+	void *pos;
+	u64 *end;
+
+	flits = DIV_ROUND_UP(CHCR_PLAIN_TX_DATA_LEN, 8);
+	flits += chcr_sgl_len(skb_shinfo(skb)->nr_frags);
+	if (prior_data_len)
+		flits += 2;
+	/* WR will need len16 */
+	len16 = DIV_ROUND_UP(flits, 2);
+	/* check how many descriptors needed */
+	ndesc = DIV_ROUND_UP(flits, 8);
+
+	credits = chcr_txq_avail(&q->q) - ndesc;
+	if (unlikely(credits < 0)) {
+		chcr_eth_txq_stop(q);
+		return NETDEV_TX_BUSY;
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
+		return NETDEV_TX_BUSY;
+	}
+
+	pos = &q->q.desc[q->q.pidx];
+	end = (u64 *)pos + flits;
+	/* FW_ULPTX_WR */
+	wr = pos;
+	wr->op_to_compl = htonl(FW_WR_OP_V(FW_ULPTX_WR));
+	wr->flowid_len16 = htonl(wr_mid | FW_WR_LEN16_V(len16));
+	wr->cookie = 0;
+	pos += sizeof(*wr);
+	/* ULP_TXPKT */
+	ulptx = (struct ulp_txpkt *)(wr + 1);
+	ulptx->cmd_dest = htonl(ULPTX_CMD_V(ULP_TX_PKT) |
+			ULP_TXPKT_DATAMODIFY_V(0) |
+			ULP_TXPKT_CHANNELID_V(tx_info->port_id) |
+			ULP_TXPKT_DEST_V(0) |
+			ULP_TXPKT_FID_V(q->q.cntxt_id) | ULP_TXPKT_RO_V(1));
+	ulptx->len = htonl(len16 - 1);
+	/* ULPTX_IDATA sub-command */
+	idata = (struct ulptx_idata *)(ulptx + 1);
+	idata->cmd_more = htonl(ULPTX_CMD_V(ULP_TX_SC_IMM) | ULP_TX_SC_MORE_F);
+	idata->len = htonl(sizeof(*tx_data) + prior_data_len);
+	/* CPL_TX_DATA */
+	tx_data = (struct cpl_tx_data *)(idata + 1);
+	OPCODE_TID(tx_data) = htonl(MK_OPCODE_TID(CPL_TX_DATA, tx_info->tid));
+	tx_data->len = htonl(TX_DATA_MSS_V(mss) |
+			TX_LENGTH_V(skb->data_len + prior_data_len));
+	/* set tcp seq number */
+	tx_data->rsvd = htonl(tcp_seq);
+	tx_data->flags = htonl(TX_BYPASS_F);
+	if (tcp_push)
+		tx_data->flags |= htonl(TX_PUSH_F | TX_SHOVE_F);
+
+	pos = tx_data + 1;
+	/* apart from prior_data_len, we should set remaining part of 16 bytes
+	 * to be zero.
+	 */
+	if (prior_data_len)
+		pos = chcr_copy_to_txd(prior_data, &q->q, pos, 16);
+
+	/* check left again, it might go beyond queue limit */
+	left = (void *)q->q.stat - pos;
+
+	/* check the position again */
+	if (!left) {
+		left = (void *)end - (void *)q->q.stat;
+		pos = q->q.desc;
+		end = pos + left;
+	}
+	/* send the complete packet including the header */
+	cxgb4_write_sgl(skb, &q->q, pos, end, skb->len - skb->data_len,
+			sgl_sdesc->addr);
+	sgl_sdesc->skb = skb;
+
+	chcr_txq_advance(&q->q, ndesc);
+	cxgb4_ring_tx_db(tx_info->adap, &q->q, ndesc);
+	return 0;
+}
+
 /*
  * chcr_ktls_copy_record_in_skb
  * @nskb - new skb where the frags to be added.
@@ -1272,6 +1592,162 @@ static int chcr_end_part_handler(struct chcr_ktls_info *tx_info,
 	return NETDEV_TX_BUSY;
 }
 
+/*
+ * chcr_short_record_handler: This handler will take care of the records which
+ * doesn't have end part (1st part or the middle part(/s) of a record). In such
+ * cases, AES CTR will be used in place of AES GCM to send out partial packet.
+ * This partial record might be the first part of the record, or the middle
+ * part. In case of middle record we should fetch the prior data to make it 16
+ * byte aligned. If it has a partial tls header or iv then get to the start of
+ * tls header. And if it has partial TAG, then remove the complete TAG and send
+ * only the payload.
+ * There is one more possibility that it gets a partial header, send that
+ * portion as a plaintext.
+ * @tx_info - driver specific tls info.
+ * @skb - skb contains partial record..
+ * @record - complete record of 16K size.
+ * @tcp_seq
+ * @mss - segment size in which TP needs to chop a packet.
+ * @tcp_push_no_fin - tcp push if fin is not set.
+ * @q - TX queue.
+ * @tls_end_offset - offset from end of the record.
+ * return: NETDEV_TX_OK/NETDEV_TX_BUSY.
+ */
+static int chcr_short_record_handler(struct chcr_ktls_info *tx_info,
+				     struct sk_buff *skb,
+				     struct tls_record_info *record,
+				     u32 tcp_seq, int mss, bool tcp_push_no_fin,
+				     struct sge_eth_txq *q, u32 tls_end_offset)
+{
+	u32 tls_rec_offset = tcp_seq - tls_record_start_seq(record);
+	u8 prior_data[16] = {0};
+	u32 prior_data_len = 0;
+	u32 data_len;
+
+	/* check if the skb is ending in middle of tag/HASH, its a big
+	 * trouble, send the packet before the HASH.
+	 */
+	int remaining_record = tls_end_offset - skb->data_len;
+
+	if (remaining_record > 0 &&
+	    remaining_record < TLS_CIPHER_AES_GCM_128_TAG_SIZE) {
+		int trimmed_len = skb->data_len -
+			(TLS_CIPHER_AES_GCM_128_TAG_SIZE - remaining_record);
+		struct sk_buff *tmp_skb = NULL;
+		/* don't process the pkt if it is only a partial tag */
+		if (skb->data_len < TLS_CIPHER_AES_GCM_128_TAG_SIZE)
+			goto out;
+
+		WARN_ON(trimmed_len > skb->data_len);
+
+		/* shift to those many bytes */
+		tmp_skb = alloc_skb(0, GFP_KERNEL);
+		if (unlikely(!tmp_skb))
+			goto out;
+
+		chcr_ktls_skb_shift(tmp_skb, skb, trimmed_len);
+		/* free the last trimmed portion */
+		dev_kfree_skb_any(skb);
+		skb = tmp_skb;
+	}
+	data_len = skb->data_len;
+	/* check if the middle record's start point is 16 byte aligned. CTR
+	 * needs 16 byte aligned start point to start encryption.
+	 */
+	if (tls_rec_offset) {
+		/* there is an offset from start, means its a middle record */
+		int remaining = 0;
+
+		if (tls_rec_offset < (TLS_HEADER_SIZE + tx_info->iv_size)) {
+			prior_data_len = tls_rec_offset;
+			tls_rec_offset = 0;
+			remaining = 0;
+		} else {
+			prior_data_len =
+				(tls_rec_offset -
+				(TLS_HEADER_SIZE + tx_info->iv_size))
+				% AES_BLOCK_LEN;
+			remaining = tls_rec_offset - prior_data_len;
+		}
+
+		/* if prior_data_len is not zero, means we need to fetch prior
+		 * data to make this record 16 byte aligned, or we need to reach
+		 * to start offset.
+		 */
+		if (prior_data_len) {
+			int i = 0;
+			u8 *data = NULL;
+			skb_frag_t *f;
+			u8 *vaddr;
+			int frag_size = 0, frag_delta = 0;
+
+			while (remaining > 0) {
+				frag_size = skb_frag_size(&record->frags[i]);
+				if (remaining < frag_size)
+					break;
+
+				remaining -= frag_size;
+				i++;
+			}
+			f = &record->frags[i];
+			vaddr = kmap_atomic(skb_frag_page(f));
+
+			data = vaddr + skb_frag_off(f)  + remaining;
+			frag_delta = skb_frag_size(f) - remaining;
+
+			if (frag_delta >= prior_data_len) {
+				memcpy(prior_data, data, prior_data_len);
+				kunmap_atomic(vaddr);
+			} else {
+				memcpy(prior_data, data, frag_delta);
+				kunmap_atomic(vaddr);
+				/* get the next page */
+				f = &record->frags[i + 1];
+				vaddr = kmap_atomic(skb_frag_page(f));
+				data = vaddr + skb_frag_off(f);
+				memcpy(prior_data + frag_delta,
+				       data, (prior_data_len - frag_delta));
+				kunmap_atomic(vaddr);
+			}
+			/* reset tcp_seq as per the prior_data_required len */
+			tcp_seq -= prior_data_len;
+			/* include prio_data_len for  further calculation.
+			 */
+			data_len += prior_data_len;
+		}
+		/* reset snd una, so the middle record won't send the already
+		 * sent part.
+		 */
+		if (chcr_ktls_update_snd_una(tx_info, q))
+			goto out;
+	} else {
+		/* Else means, its a partial first part of the record. Check if
+		 * its only the header, don't need to send for encryption then.
+		 */
+		if (data_len <= TLS_HEADER_SIZE + tx_info->iv_size) {
+			if (chcr_ktls_tx_plaintxt(tx_info, skb, tcp_seq, mss,
+						  tcp_push_no_fin, q,
+						  tx_info->port_id,
+						  prior_data,
+						  prior_data_len)) {
+				goto out;
+			}
+			return 0;
+		}
+	}
+
+	if (chcr_ktls_xmit_wr_short(skb, tx_info, q, tcp_seq, tcp_push_no_fin,
+				    mss, tls_rec_offset, prior_data,
+				    prior_data_len)) {
+		goto out;
+	}
+
+	return 0;
+out:
+	dev_kfree_skb_any(skb);
+	return NETDEV_TX_BUSY;
+}
+
 /* nic tls TX handler */
 int chcr_ktls_xmit(struct sk_buff *skb, struct net_device *dev)
 {
@@ -1420,6 +1896,12 @@ int chcr_ktls_xmit(struct sk_buff *skb, struct net_device *dev)
 			/* tcp_seq increment is required to handle next record.
 			 */
 			tcp_seq += tls_end_offset;
+		} else {
+			ret = chcr_short_record_handler(tx_info, local_skb,
+							record, tcp_seq, mss,
+							(!th->fin && th->psh),
+							q, tls_end_offset);
+			data_len = 0;
 		}
 clear_ref:
 		/* clear the frag ref count which increased locally before */
@@ -1427,10 +1909,10 @@ int chcr_ktls_xmit(struct sk_buff *skb, struct net_device *dev)
 			/* clear the frag ref count */
 			__skb_frag_unref(&record->frags[i]);
 		}
-
+		/* if any failure, come out from the loop. */
 		if (ret)
 			goto out;
-
+		/* length should never be less than 0 */
 		WARN_ON(data_len < 0);
 
 	} while (data_len > 0);
diff --git a/drivers/crypto/chelsio/chcr_ktls.h b/drivers/crypto/chelsio/chcr_ktls.h
index df54b210324d..9ffb8cc85db1 100644
--- a/drivers/crypto/chelsio/chcr_ktls.h
+++ b/drivers/crypto/chelsio/chcr_ktls.h
@@ -52,6 +52,8 @@ struct chcr_ktls_info {
 	u32 scmd0_seqno_numivs;
 	u32 scmd0_ivgen_hdrlen;
 	u32 tcp_start_seq_number;
+	u32 scmd0_short_seqno_numivs;
+	u32 scmd0_short_ivgen_hdrlen;
 	enum chcr_ktls_conn_state connection_state;
 	u16 prev_win;
 	u8 tx_chan;
-- 
2.18.1

