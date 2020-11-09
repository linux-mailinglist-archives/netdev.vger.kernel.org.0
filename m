Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 401E72AB278
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 09:34:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729780AbgKIIe2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 03:34:28 -0500
Received: from stargate.chelsio.com ([12.32.117.8]:30461 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729769AbgKIIe1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 03:34:27 -0500
Received: from localhost.localdomain (redhouse.blr.asicdesigners.com [10.193.185.57])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 0A98XwJZ010868;
        Mon, 9 Nov 2020 00:34:12 -0800
From:   Rohit Maheshwari <rohitm@chelsio.com>
To:     kuba@kernel.org, netdev@vger.kernel.org, davem@davemloft.net
Cc:     secdev@chelsio.com, Rohit Maheshwari <rohitm@chelsio.com>
Subject: [net v5 04/12] cxgb4/ch_ktls: creating skbs causes panic
Date:   Mon,  9 Nov 2020 14:03:48 +0530
Message-Id: <20201109083356.11117-5-rohitm@chelsio.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20201109083356.11117-1-rohitm@chelsio.com>
References: <20201109083356.11117-1-rohitm@chelsio.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Creating SKB per tls record and freeing the original one causes
panic. There will be race if connection reset is requested. By
freeing original skb, refcnt will be decremented and that means,
there is no pending record to send, and so tls_dev_del will be
requested in control path while SKB of related connection is in
queue.
 Better approach is to use same SKB to send one record (partial
data) at a time. We still have to create a new SKB when partial
last part of a record is requested.
 This fix introduces new API cxgb4_write_partial_sgl() to send
partial part of skb. Present cxgb4_write_sgl can only provide
feasibility to start from an offset which limits to header only
and it can write sgls for the whole skb len. But this new API
will help in both. It can start from any offset and can end
writing in middle of the skb.

Fixes: 429765a149f1 ("chcr: handle partial end part of a record")

v4->v5:
- Removed extra changes.

Signed-off-by: Rohit Maheshwari <rohitm@chelsio.com>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4.h    |   3 +
 drivers/net/ethernet/chelsio/cxgb4/sge.c      | 108 +++++++
 .../chelsio/inline_crypto/ch_ktls/chcr_ktls.c | 284 +++++++-----------
 3 files changed, 226 insertions(+), 169 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h b/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
index 3352dad6ca99..27308600da15 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
@@ -2124,6 +2124,9 @@ void cxgb4_inline_tx_skb(const struct sk_buff *skb, const struct sge_txq *q,
 void cxgb4_write_sgl(const struct sk_buff *skb, struct sge_txq *q,
 		     struct ulptx_sgl *sgl, u64 *end, unsigned int start,
 		     const dma_addr_t *addr);
+void cxgb4_write_partial_sgl(const struct sk_buff *skb, struct sge_txq *q,
+			     struct ulptx_sgl *sgl, u64 *end,
+			     const dma_addr_t *addr, u32 start, u32 send_len);
 void cxgb4_ring_tx_db(struct adapter *adap, struct sge_txq *q, int n);
 int t4_set_vlan_acl(struct adapter *adap, unsigned int mbox, unsigned int vf,
 		    u16 vlan);
diff --git a/drivers/net/ethernet/chelsio/cxgb4/sge.c b/drivers/net/ethernet/chelsio/cxgb4/sge.c
index 01bd9c0dfe4e..196652a114c5 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/sge.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/sge.c
@@ -890,6 +890,114 @@ void cxgb4_write_sgl(const struct sk_buff *skb, struct sge_txq *q,
 }
 EXPORT_SYMBOL(cxgb4_write_sgl);
 
+/*	cxgb4_write_partial_sgl - populate SGL for partial packet
+ *	@skb: the packet
+ *	@q: the Tx queue we are writing into
+ *	@sgl: starting location for writing the SGL
+ *	@end: points right after the end of the SGL
+ *	@addr: the list of bus addresses for the SGL elements
+ *	@start: start offset in the SKB where partial data starts
+ *	@len: length of data from @start to send out
+ *
+ *	This API will handle sending out partial data of a skb if required.
+ *	Unlike cxgb4_write_sgl, @start can be any offset into the skb data,
+ *	and @len will decide how much data after @start offset to send out.
+ */
+void cxgb4_write_partial_sgl(const struct sk_buff *skb, struct sge_txq *q,
+			     struct ulptx_sgl *sgl, u64 *end,
+			     const dma_addr_t *addr, u32 start, u32 len)
+{
+	struct ulptx_sge_pair buf[MAX_SKB_FRAGS / 2 + 1] = {0}, *to;
+	u32 frag_size, skb_linear_data_len = skb_headlen(skb);
+	struct skb_shared_info *si = skb_shinfo(skb);
+	u8 i = 0, frag_idx = 0, nfrags = 0;
+	skb_frag_t *frag;
+
+	/* Fill the first SGL either from linear data or from partial
+	 * frag based on @start.
+	 */
+	if (unlikely(start < skb_linear_data_len)) {
+		frag_size = min(len, skb_linear_data_len - start);
+		sgl->len0 = htonl(frag_size);
+		sgl->addr0 = cpu_to_be64(addr[0] + start);
+		len -= frag_size;
+		nfrags++;
+	} else {
+		start -= skb_linear_data_len;
+		frag = &si->frags[frag_idx];
+		frag_size = skb_frag_size(frag);
+		/* find the first frag */
+		while (start >= frag_size) {
+			start -= frag_size;
+			frag_idx++;
+			frag = &si->frags[frag_idx];
+			frag_size = skb_frag_size(frag);
+		}
+
+		frag_size = min(len, skb_frag_size(frag) - start);
+		sgl->len0 = cpu_to_be32(frag_size);
+		sgl->addr0 = cpu_to_be64(addr[frag_idx + 1] + start);
+		len -= frag_size;
+		nfrags++;
+		frag_idx++;
+	}
+
+	/* If the entire partial data fit in one SGL, then send it out
+	 * now.
+	 */
+	if (!len)
+		goto done;
+
+	/* Most of the complexity below deals with the possibility we hit the
+	 * end of the queue in the middle of writing the SGL.  For this case
+	 * only we create the SGL in a temporary buffer and then copy it.
+	 */
+	to = (u8 *)end > (u8 *)q->stat ? buf : sgl->sge;
+
+	/* If the skb couldn't fit in first SGL completely, fill the
+	 * rest of the frags in subsequent SGLs. Note that each SGL
+	 * pair can store 2 frags.
+	 */
+	while (len) {
+		frag_size = min(len, skb_frag_size(&si->frags[frag_idx]));
+		to->len[i & 1] = cpu_to_be32(frag_size);
+		to->addr[i & 1] = cpu_to_be64(addr[frag_idx + 1]);
+		if (i && (i & 1))
+			to++;
+		nfrags++;
+		frag_idx++;
+		i++;
+		len -= frag_size;
+	}
+
+	/* If we ended in an odd boundary, then set the second SGL's
+	 * length in the pair to 0.
+	 */
+	if (i & 1)
+		to->len[1] = cpu_to_be32(0);
+
+	/* Copy from temporary buffer to Tx ring, in case we hit the
+	 * end of the queue in the middle of writing the SGL.
+	 */
+	if (unlikely((u8 *)end > (u8 *)q->stat)) {
+		u32 part0 = (u8 *)q->stat - (u8 *)sgl->sge, part1;
+
+		if (likely(part0))
+			memcpy(sgl->sge, buf, part0);
+		part1 = (u8 *)end - (u8 *)q->stat;
+		memcpy(q->desc, (u8 *)buf + part0, part1);
+		end = (void *)q->desc + part1;
+	}
+
+	/* 0-pad to multiple of 16 */
+	if ((uintptr_t)end & 8)
+		*end = 0;
+done:
+	sgl->cmd_nsge = htonl(ULPTX_CMD_V(ULP_TX_SC_DSGL) |
+			ULPTX_NSGE_V(nfrags));
+}
+EXPORT_SYMBOL(cxgb4_write_partial_sgl);
+
 /* This function copies 64 byte coalesced work request to
  * memory mapped BAR2 space. For coalesced WR SGE fetches
  * data from the FIFO instead of from Host.
diff --git a/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c b/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
index b7a3e757ee72..950841988ffe 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
+++ b/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
@@ -14,6 +14,50 @@
 static LIST_HEAD(uld_ctx_list);
 static DEFINE_MUTEX(dev_mutex);
 
+/* chcr_get_nfrags_to_send: get the remaining nfrags after start offset
+ * @skb: skb
+ * @start: start offset.
+ * @len: how much data to send after @start
+ */
+static int chcr_get_nfrags_to_send(struct sk_buff *skb, u32 start, u32 len)
+{
+	struct skb_shared_info *si = skb_shinfo(skb);
+	u32 frag_size, skb_linear_data_len = skb_headlen(skb);
+	u8 nfrags = 0, frag_idx = 0;
+	skb_frag_t *frag;
+
+	/* if its a linear skb then return 1 */
+	if (!skb_is_nonlinear(skb))
+		return 1;
+
+	if (unlikely(start < skb_linear_data_len)) {
+		frag_size = min(len, skb_linear_data_len - start);
+		start = 0;
+	} else {
+		start -= skb_linear_data_len;
+
+		frag = &si->frags[frag_idx];
+		frag_size = skb_frag_size(frag);
+		while (start >= frag_size) {
+			start -= frag_size;
+			frag_idx++;
+			frag = &si->frags[frag_idx];
+			frag_size = skb_frag_size(frag);
+		}
+		frag_size = min(len, skb_frag_size(frag) - start);
+	}
+	len -= frag_size;
+	nfrags++;
+
+	while (len) {
+		frag_size = min(len, skb_frag_size(&si->frags[frag_idx]));
+		len -= frag_size;
+		nfrags++;
+		frag_idx++;
+	}
+	return nfrags;
+}
+
 static int chcr_init_tcb_fields(struct chcr_ktls_info *tx_info);
 /*
  * chcr_ktls_save_keys: calculate and save crypto keys.
@@ -865,35 +909,15 @@ static int chcr_ktls_xmit_tcb_cpls(struct chcr_ktls_info *tx_info,
 	return 0;
 }
 
-/*
- * chcr_ktls_skb_copy
- * @nskb - new skb where the frags to be added.
- * @skb - old skb from which frags will be copied.
- */
-static void chcr_ktls_skb_copy(struct sk_buff *skb, struct sk_buff *nskb)
-{
-	int i;
-
-	for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
-		skb_shinfo(nskb)->frags[i] = skb_shinfo(skb)->frags[i];
-		__skb_frag_ref(&skb_shinfo(nskb)->frags[i]);
-	}
-
-	skb_shinfo(nskb)->nr_frags = skb_shinfo(skb)->nr_frags;
-	nskb->len += skb->data_len;
-	nskb->data_len = skb->data_len;
-	nskb->truesize += skb->data_len;
-}
-
 /*
  * chcr_ktls_get_tx_flits
  * returns number of flits to be sent out, it includes key context length, WR
  * size and skb fragments.
  */
 static unsigned int
-chcr_ktls_get_tx_flits(const struct sk_buff *skb, unsigned int key_ctx_len)
+chcr_ktls_get_tx_flits(u32 nr_frags, unsigned int key_ctx_len)
 {
-	return chcr_sgl_len(skb_shinfo(skb)->nr_frags) +
+	return chcr_sgl_len(nr_frags) +
 	       DIV_ROUND_UP(key_ctx_len + CHCR_KTLS_WR_SIZE, 8);
 }
 
@@ -1038,71 +1062,6 @@ chcr_ktls_write_tcp_options(struct chcr_ktls_info *tx_info, struct sk_buff *skb,
 	return 0;
 }
 
-/* chcr_ktls_skb_shift - Shifts request length paged data from skb to another.
- * @tgt- buffer into which tail data gets added
- * @skb- buffer from which the paged data comes from
- * @shiftlen- shift up to this many bytes
- */
-static int chcr_ktls_skb_shift(struct sk_buff *tgt, struct sk_buff *skb,
-			       int shiftlen)
-{
-	skb_frag_t *fragfrom, *fragto;
-	int from, to, todo;
-
-	WARN_ON(shiftlen > skb->data_len);
-
-	todo = shiftlen;
-	from = 0;
-	to = 0;
-	fragfrom = &skb_shinfo(skb)->frags[from];
-
-	while ((todo > 0) && (from < skb_shinfo(skb)->nr_frags)) {
-		fragfrom = &skb_shinfo(skb)->frags[from];
-		fragto = &skb_shinfo(tgt)->frags[to];
-
-		if (todo >= skb_frag_size(fragfrom)) {
-			*fragto = *fragfrom;
-			todo -= skb_frag_size(fragfrom);
-			from++;
-			to++;
-
-		} else {
-			__skb_frag_ref(fragfrom);
-			skb_frag_page_copy(fragto, fragfrom);
-			skb_frag_off_copy(fragto, fragfrom);
-			skb_frag_size_set(fragto, todo);
-
-			skb_frag_off_add(fragfrom, todo);
-			skb_frag_size_sub(fragfrom, todo);
-			todo = 0;
-
-			to++;
-			break;
-		}
-	}
-
-	/* Ready to "commit" this state change to tgt */
-	skb_shinfo(tgt)->nr_frags = to;
-
-	/* Reposition in the original skb */
-	to = 0;
-	while (from < skb_shinfo(skb)->nr_frags)
-		skb_shinfo(skb)->frags[to++] = skb_shinfo(skb)->frags[from++];
-
-	skb_shinfo(skb)->nr_frags = to;
-
-	WARN_ON(todo > 0 && !skb_shinfo(skb)->nr_frags);
-
-	skb->len -= shiftlen;
-	skb->data_len -= shiftlen;
-	skb->truesize -= shiftlen;
-	tgt->len += shiftlen;
-	tgt->data_len += shiftlen;
-	tgt->truesize += shiftlen;
-
-	return shiftlen;
-}
-
 /*
  * chcr_ktls_xmit_wr_complete: This sends out the complete record. If an skb
  * received has partial end part of the record, send out the complete record, so
@@ -1118,6 +1077,8 @@ static int chcr_ktls_skb_shift(struct sk_buff *tgt, struct sk_buff *skb,
 static int chcr_ktls_xmit_wr_complete(struct sk_buff *skb,
 				      struct chcr_ktls_info *tx_info,
 				      struct sge_eth_txq *q, u32 tcp_seq,
+				      bool is_last_wr, u32 data_len,
+				      u32 skb_offset, u32 nfrags,
 				      bool tcp_push, u32 mss)
 {
 	u32 len16, wr_mid = 0, flits = 0, ndesc, cipher_start;
@@ -1133,7 +1094,7 @@ static int chcr_ktls_xmit_wr_complete(struct sk_buff *skb,
 	u64 *end;
 
 	/* get the number of flits required */
-	flits = chcr_ktls_get_tx_flits(skb, tx_info->key_ctx_len);
+	flits = chcr_ktls_get_tx_flits(nfrags, tx_info->key_ctx_len);
 	/* number of descriptors */
 	ndesc = chcr_flits_to_desc(flits);
 	/* check if enough credits available */
@@ -1162,6 +1123,9 @@ static int chcr_ktls_xmit_wr_complete(struct sk_buff *skb,
 		return NETDEV_TX_BUSY;
 	}
 
+	if (!is_last_wr)
+		skb_get(skb);
+
 	pos = &q->q.desc[q->q.pidx];
 	end = (u64 *)pos + flits;
 	/* FW_ULPTX_WR */
@@ -1194,7 +1158,7 @@ static int chcr_ktls_xmit_wr_complete(struct sk_buff *skb,
 		      CPL_TX_SEC_PDU_CPLLEN_V(CHCR_CPL_TX_SEC_PDU_LEN_64BIT) |
 		      CPL_TX_SEC_PDU_PLACEHOLDER_V(1) |
 		      CPL_TX_SEC_PDU_IVINSRTOFST_V(TLS_HEADER_SIZE + 1));
-	cpl->pldlen = htonl(skb->data_len);
+	cpl->pldlen = htonl(data_len);
 
 	/* encryption should start after tls header size + iv size */
 	cipher_start = TLS_HEADER_SIZE + tx_info->iv_size + 1;
@@ -1236,7 +1200,7 @@ static int chcr_ktls_xmit_wr_complete(struct sk_buff *skb,
 	/* CPL_TX_DATA */
 	tx_data = (void *)pos;
 	OPCODE_TID(tx_data) = htonl(MK_OPCODE_TID(CPL_TX_DATA, tx_info->tid));
-	tx_data->len = htonl(TX_DATA_MSS_V(mss) | TX_LENGTH_V(skb->data_len));
+	tx_data->len = htonl(TX_DATA_MSS_V(mss) | TX_LENGTH_V(data_len));
 
 	tx_data->rsvd = htonl(tcp_seq);
 
@@ -1256,8 +1220,8 @@ static int chcr_ktls_xmit_wr_complete(struct sk_buff *skb,
 	}
 
 	/* send the complete packet except the header */
-	cxgb4_write_sgl(skb, &q->q, pos, end, skb->len - skb->data_len,
-			sgl_sdesc->addr);
+	cxgb4_write_partial_sgl(skb, &q->q, pos, end, sgl_sdesc->addr,
+				skb_offset, data_len);
 	sgl_sdesc->skb = skb;
 
 	chcr_txq_advance(&q->q, ndesc);
@@ -1289,10 +1253,11 @@ static int chcr_ktls_xmit_wr_short(struct sk_buff *skb,
 				   struct sge_eth_txq *q,
 				   u32 tcp_seq, bool tcp_push, u32 mss,
 				   u32 tls_rec_offset, u8 *prior_data,
-				   u32 prior_data_len)
+				   u32 prior_data_len, u32 data_len,
+				   u32 skb_offset)
 {
+	u32 len16, wr_mid = 0, cipher_start, nfrags;
 	struct adapter *adap = tx_info->adap;
-	u32 len16, wr_mid = 0, cipher_start;
 	unsigned int flits = 0, ndesc;
 	int credits, left, last_desc;
 	struct tx_sw_desc *sgl_sdesc;
@@ -1305,10 +1270,11 @@ static int chcr_ktls_xmit_wr_short(struct sk_buff *skb,
 	void *pos;
 	u64 *end;
 
+	nfrags = chcr_get_nfrags_to_send(skb, skb_offset, data_len);
 	/* get the number of flits required, it's a partial record so 2 flits
 	 * (AES_BLOCK_SIZE) will be added.
 	 */
-	flits = chcr_ktls_get_tx_flits(skb, tx_info->key_ctx_len) + 2;
+	flits = chcr_ktls_get_tx_flits(nfrags, tx_info->key_ctx_len) + 2;
 	/* get the correct 8 byte IV of this record */
 	iv_record = cpu_to_be64(tx_info->iv + tx_info->record_no);
 	/* If it's a middle record and not 16 byte aligned to run AES CTR, need
@@ -1380,7 +1346,7 @@ static int chcr_ktls_xmit_wr_short(struct sk_buff *skb,
 		htonl(CPL_TX_SEC_PDU_OPCODE_V(CPL_TX_SEC_PDU) |
 		      CPL_TX_SEC_PDU_CPLLEN_V(CHCR_CPL_TX_SEC_PDU_LEN_64BIT) |
 		      CPL_TX_SEC_PDU_IVINSRTOFST_V(1));
-	cpl->pldlen = htonl(skb->data_len + AES_BLOCK_LEN + prior_data_len);
+	cpl->pldlen = htonl(data_len + AES_BLOCK_LEN + prior_data_len);
 	cpl->aadstart_cipherstop_hi =
 		htonl(CPL_TX_SEC_PDU_CIPHERSTART_V(cipher_start));
 	cpl->cipherstop_lo_authinsert = 0;
@@ -1411,7 +1377,7 @@ static int chcr_ktls_xmit_wr_short(struct sk_buff *skb,
 	tx_data = (void *)pos;
 	OPCODE_TID(tx_data) = htonl(MK_OPCODE_TID(CPL_TX_DATA, tx_info->tid));
 	tx_data->len = htonl(TX_DATA_MSS_V(mss) |
-			TX_LENGTH_V(skb->data_len + prior_data_len));
+			     TX_LENGTH_V(data_len + prior_data_len));
 	tx_data->rsvd = htonl(tcp_seq);
 	tx_data->flags = htonl(TX_BYPASS_F);
 	if (tcp_push)
@@ -1444,8 +1410,8 @@ static int chcr_ktls_xmit_wr_short(struct sk_buff *skb,
 	if (prior_data_len)
 		pos = chcr_copy_to_txd(prior_data, &q->q, pos, 16);
 	/* send the complete packet except the header */
-	cxgb4_write_sgl(skb, &q->q, pos, end, skb->len - skb->data_len,
-			sgl_sdesc->addr);
+	cxgb4_write_partial_sgl(skb, &q->q, pos, end, sgl_sdesc->addr,
+				skb_offset, data_len);
 	sgl_sdesc->skb = skb;
 
 	chcr_txq_advance(&q->q, ndesc);
@@ -1473,6 +1439,7 @@ static int chcr_ktls_tx_plaintxt(struct chcr_ktls_info *tx_info,
 				 struct sk_buff *skb, u32 tcp_seq, u32 mss,
 				 bool tcp_push, struct sge_eth_txq *q,
 				 u32 port_id, u8 *prior_data,
+				 u32 data_len, u32 skb_offset,
 				 u32 prior_data_len)
 {
 	int credits, left, len16, last_desc;
@@ -1482,14 +1449,16 @@ static int chcr_ktls_tx_plaintxt(struct chcr_ktls_info *tx_info,
 	struct ulptx_idata *idata;
 	struct ulp_txpkt *ulptx;
 	struct fw_ulptx_wr *wr;
-	u32 wr_mid = 0;
+	u32 wr_mid = 0, nfrags;
 	void *pos;
 	u64 *end;
 
 	flits = DIV_ROUND_UP(CHCR_PLAIN_TX_DATA_LEN, 8);
-	flits += chcr_sgl_len(skb_shinfo(skb)->nr_frags);
+	nfrags = chcr_get_nfrags_to_send(skb, skb_offset, data_len);
+	flits += chcr_sgl_len(nfrags);
 	if (prior_data_len)
 		flits += 2;
+
 	/* WR will need len16 */
 	len16 = DIV_ROUND_UP(flits, 2);
 	/* check how many descriptors needed */
@@ -1542,7 +1511,7 @@ static int chcr_ktls_tx_plaintxt(struct chcr_ktls_info *tx_info,
 	tx_data = (struct cpl_tx_data *)(idata + 1);
 	OPCODE_TID(tx_data) = htonl(MK_OPCODE_TID(CPL_TX_DATA, tx_info->tid));
 	tx_data->len = htonl(TX_DATA_MSS_V(mss) |
-			TX_LENGTH_V(skb->data_len + prior_data_len));
+			     TX_LENGTH_V(data_len + prior_data_len));
 	/* set tcp seq number */
 	tx_data->rsvd = htonl(tcp_seq);
 	tx_data->flags = htonl(TX_BYPASS_F);
@@ -1566,8 +1535,8 @@ static int chcr_ktls_tx_plaintxt(struct chcr_ktls_info *tx_info,
 		end = pos + left;
 	}
 	/* send the complete packet including the header */
-	cxgb4_write_sgl(skb, &q->q, pos, end, skb->len - skb->data_len,
-			sgl_sdesc->addr);
+	cxgb4_write_partial_sgl(skb, &q->q, pos, end, sgl_sdesc->addr,
+				skb_offset, data_len);
 	sgl_sdesc->skb = skb;
 
 	chcr_txq_advance(&q->q, ndesc);
@@ -1578,9 +1547,11 @@ static int chcr_ktls_tx_plaintxt(struct chcr_ktls_info *tx_info,
 /*
  * chcr_ktls_copy_record_in_skb
  * @nskb - new skb where the frags to be added.
+ * @skb - old skb, to copy socket and destructor details.
  * @record - specific record which has complete 16k record in frags.
  */
 static void chcr_ktls_copy_record_in_skb(struct sk_buff *nskb,
+					 struct sk_buff *skb,
 					 struct tls_record_info *record)
 {
 	int i = 0;
@@ -1595,6 +1566,9 @@ static void chcr_ktls_copy_record_in_skb(struct sk_buff *nskb,
 	nskb->data_len = record->len;
 	nskb->len += record->len;
 	nskb->truesize += record->len;
+	nskb->sk = skb->sk;
+	nskb->destructor = skb->destructor;
+	refcount_add(nskb->truesize, &nskb->sk->sk_wmem_alloc);
 }
 
 /*
@@ -1666,7 +1640,7 @@ static int chcr_end_part_handler(struct chcr_ktls_info *tx_info,
 				 struct sk_buff *skb,
 				 struct tls_record_info *record,
 				 u32 tcp_seq, int mss, bool tcp_push_no_fin,
-				 struct sge_eth_txq *q,
+				 struct sge_eth_txq *q, u32 skb_offset,
 				 u32 tls_end_offset, bool last_wr)
 {
 	struct sk_buff *nskb = NULL;
@@ -1675,13 +1649,14 @@ static int chcr_end_part_handler(struct chcr_ktls_info *tx_info,
 		nskb = skb;
 		atomic64_inc(&tx_info->adap->ch_ktls_stats.ktls_tx_complete_pkts);
 	} else {
-		dev_kfree_skb_any(skb);
-
-		nskb = alloc_skb(0, GFP_KERNEL);
-		if (!nskb)
+		nskb = alloc_skb(0, GFP_ATOMIC);
+		if (!nskb) {
+			dev_kfree_skb_any(skb);
 			return NETDEV_TX_BUSY;
+		}
+
 		/* copy complete record in skb */
-		chcr_ktls_copy_record_in_skb(nskb, record);
+		chcr_ktls_copy_record_in_skb(nskb, skb, record);
 		/* packet is being sent from the beginning, update the tcp_seq
 		 * accordingly.
 		 */
@@ -1691,10 +1666,20 @@ static int chcr_end_part_handler(struct chcr_ktls_info *tx_info,
 		 */
 		if (chcr_ktls_update_snd_una(tx_info, q))
 			goto out;
+		/* reset skb offset */
+		skb_offset = 0;
+
+		if (last_wr)
+			dev_kfree_skb_any(skb);
+
+		last_wr = true;
+
 		atomic64_inc(&tx_info->adap->ch_ktls_stats.ktls_tx_end_pkts);
 	}
 
 	if (chcr_ktls_xmit_wr_complete(nskb, tx_info, q, tcp_seq,
+				       last_wr, record->len, skb_offset,
+				       record->num_frags,
 				       (last_wr && tcp_push_no_fin),
 				       mss)) {
 		goto out;
@@ -1730,41 +1715,32 @@ static int chcr_short_record_handler(struct chcr_ktls_info *tx_info,
 				     struct sk_buff *skb,
 				     struct tls_record_info *record,
 				     u32 tcp_seq, int mss, bool tcp_push_no_fin,
+				     u32 data_len, u32 skb_offset,
 				     struct sge_eth_txq *q, u32 tls_end_offset)
 {
 	u32 tls_rec_offset = tcp_seq - tls_record_start_seq(record);
 	u8 prior_data[16] = {0};
 	u32 prior_data_len = 0;
-	u32 data_len;
 
 	/* check if the skb is ending in middle of tag/HASH, its a big
 	 * trouble, send the packet before the HASH.
 	 */
-	int remaining_record = tls_end_offset - skb->data_len;
+	int remaining_record = tls_end_offset - data_len;
 
 	if (remaining_record > 0 &&
 	    remaining_record < TLS_CIPHER_AES_GCM_128_TAG_SIZE) {
-		int trimmed_len = skb->data_len -
+		int trimmed_len = data_len -
 			(TLS_CIPHER_AES_GCM_128_TAG_SIZE - remaining_record);
-		struct sk_buff *tmp_skb = NULL;
 		/* don't process the pkt if it is only a partial tag */
-		if (skb->data_len < TLS_CIPHER_AES_GCM_128_TAG_SIZE)
+		if (data_len < TLS_CIPHER_AES_GCM_128_TAG_SIZE)
 			goto out;
 
-		WARN_ON(trimmed_len > skb->data_len);
-
-		/* shift to those many bytes */
-		tmp_skb = alloc_skb(0, GFP_KERNEL);
-		if (unlikely(!tmp_skb))
-			goto out;
+		WARN_ON(trimmed_len > data_len);
 
-		chcr_ktls_skb_shift(tmp_skb, skb, trimmed_len);
-		/* free the last trimmed portion */
-		dev_kfree_skb_any(skb);
-		skb = tmp_skb;
+		data_len = trimmed_len;
 		atomic64_inc(&tx_info->adap->ch_ktls_stats.ktls_tx_trimmed_pkts);
 	}
-	data_len = skb->data_len;
+
 	/* check if the middle record's start point is 16 byte aligned. CTR
 	 * needs 16 byte aligned start point to start encryption.
 	 */
@@ -1825,9 +1801,6 @@ static int chcr_short_record_handler(struct chcr_ktls_info *tx_info,
 			}
 			/* reset tcp_seq as per the prior_data_required len */
 			tcp_seq -= prior_data_len;
-			/* include prio_data_len for  further calculation.
-			 */
-			data_len += prior_data_len;
 		}
 		/* reset snd una, so the middle record won't send the already
 		 * sent part.
@@ -1844,6 +1817,7 @@ static int chcr_short_record_handler(struct chcr_ktls_info *tx_info,
 						  tcp_push_no_fin, q,
 						  tx_info->port_id,
 						  prior_data,
+						  data_len, skb_offset,
 						  prior_data_len)) {
 				goto out;
 			}
@@ -1854,7 +1828,7 @@ static int chcr_short_record_handler(struct chcr_ktls_info *tx_info,
 
 	if (chcr_ktls_xmit_wr_short(skb, tx_info, q, tcp_seq, tcp_push_no_fin,
 				    mss, tls_rec_offset, prior_data,
-				    prior_data_len)) {
+				    prior_data_len, data_len, skb_offset)) {
 		goto out;
 	}
 
@@ -1876,7 +1850,6 @@ static int chcr_ktls_xmit(struct sk_buff *skb, struct net_device *dev)
 	struct tls_record_info *record;
 	struct chcr_ktls_info *tx_info;
 	struct tls_context *tls_ctx;
-	struct sk_buff *local_skb;
 	struct sge_eth_txq *q;
 	struct adapter *adap;
 	unsigned long flags;
@@ -1898,14 +1871,6 @@ static int chcr_ktls_xmit(struct sk_buff *skb, struct net_device *dev)
 	if (unlikely(!tx_info))
 		goto out;
 
-	/* don't touch the original skb, make a new skb to extract each records
-	 * and send them separately.
-	 */
-	local_skb = alloc_skb(0, GFP_KERNEL);
-
-	if (unlikely(!local_skb))
-		return NETDEV_TX_BUSY;
-
 	adap = tx_info->adap;
 	stats = &adap->ch_ktls_stats;
 	port_stats = &stats->ktls_port[tx_info->port_id];
@@ -1925,13 +1890,9 @@ static int chcr_ktls_xmit(struct sk_buff *skb, struct net_device *dev)
 				      ntohl(th->ack_seq),
 				      ntohs(th->window));
 	if (ret) {
-		dev_kfree_skb_any(local_skb);
 		return NETDEV_TX_BUSY;
 	}
 
-	/* copy skb contents into local skb */
-	chcr_ktls_skb_copy(skb, local_skb);
-
 	/* TCP segments can be in received either complete or partial.
 	 * chcr_end_part_handler will handle cases if complete record or end
 	 * part of the record is received. Incase of partial end part of record,
@@ -1961,7 +1922,6 @@ static int chcr_ktls_xmit(struct sk_buff *skb, struct net_device *dev)
 			atomic64_inc(&port_stats->ktls_tx_skip_no_sync_data);
 			goto out;
 		}
-
 		/* increase page reference count of the record, so that there
 		 * won't be any chance of page free in middle if in case stack
 		 * receives ACK and try to delete the record.
@@ -1977,44 +1937,28 @@ static int chcr_ktls_xmit(struct sk_buff *skb, struct net_device *dev)
 			 tcp_seq, record->end_seq, tx_info->prev_seq, data_len);
 		/* if a tls record is finishing in this SKB */
 		if (tls_end_offset <= data_len) {
-			struct sk_buff *nskb = NULL;
-
-			if (tls_end_offset < data_len) {
-				nskb = alloc_skb(0, GFP_KERNEL);
-				if (unlikely(!nskb)) {
-					ret = -ENOMEM;
-					goto clear_ref;
-				}
-
-				chcr_ktls_skb_shift(nskb, local_skb,
-						    tls_end_offset);
-			} else {
-				/* its the only record in this skb, directly
-				 * point it.
-				 */
-				nskb = local_skb;
-			}
-			ret = chcr_end_part_handler(tx_info, nskb, record,
+			ret = chcr_end_part_handler(tx_info, skb, record,
 						    tcp_seq, mss,
 						    (!th->fin && th->psh), q,
+						    skb_offset,
 						    tls_end_offset,
-						    (nskb == local_skb));
-
-			if (ret && nskb != local_skb)
-				dev_kfree_skb_any(local_skb);
+						    skb_offset +
+						    tls_end_offset == skb->len);
 
 			data_len -= tls_end_offset;
 			/* tcp_seq increment is required to handle next record.
 			 */
 			tcp_seq += tls_end_offset;
+			skb_offset += tls_end_offset;
 		} else {
-			ret = chcr_short_record_handler(tx_info, local_skb,
+			ret = chcr_short_record_handler(tx_info, skb,
 							record, tcp_seq, mss,
 							(!th->fin && th->psh),
+							data_len, skb_offset,
 							q, tls_end_offset);
 			data_len = 0;
 		}
-clear_ref:
+
 		/* clear the frag ref count which increased locally before */
 		for (i = 0; i < record->num_frags; i++) {
 			/* clear the frag ref count */
@@ -2022,7 +1966,8 @@ static int chcr_ktls_xmit(struct sk_buff *skb, struct net_device *dev)
 		}
 		/* if any failure, come out from the loop. */
 		if (ret)
-			goto out;
+			return NETDEV_TX_OK;
+
 		/* length should never be less than 0 */
 		WARN_ON(data_len < 0);
 
@@ -2038,6 +1983,7 @@ static int chcr_ktls_xmit(struct sk_buff *skb, struct net_device *dev)
 	if (th->fin)
 		chcr_ktls_write_tcp_options(tx_info, skb, q, tx_info->tx_chan);
 
+	return NETDEV_TX_OK;
 out:
 	dev_kfree_skb_any(skb);
 	return NETDEV_TX_OK;
-- 
2.18.1

