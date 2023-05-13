Return-Path: <netdev+bounces-2396-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9DE9A701ABC
	for <lists+netdev@lfdr.de>; Sun, 14 May 2023 01:01:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 50038280DB7
	for <lists+netdev@lfdr.de>; Sat, 13 May 2023 23:01:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0866AD2F7;
	Sat, 13 May 2023 22:57:41 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3B7FC8FD
	for <netdev@vger.kernel.org>; Sat, 13 May 2023 22:57:40 +0000 (UTC)
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBC5826B3
	for <netdev@vger.kernel.org>; Sat, 13 May 2023 15:57:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684018655; x=1715554655;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=EGOkpcoXBTzdQ2cRpu4xdXKU14s0/xAr+2reir8NNjU=;
  b=ES/OEXIF3i8PhnmLnfa+YlOHUVaTtWu2vMPGWCqg9Ji7SrRDUBWtsynU
   CCSzQ6MvQieetWl5TU6AOEBh6d6vst8ckqOanwC6h3lJdbFFM7pkMmrWH
   AHu38R7mIvfa4A2h49eNbRPheQwAZfi5MPTKS9c2jzNmaUQt+ARE3LjG1
   fiESRPdWXSFjZXE7Tb9Hh8GErYV4gJjM/1j9obe7W7X39548DtZpAkSC0
   64YPiq0Gh2N3TwjZL54Fnj6uMUsUl+p960x0fuqJSrcJNfUAbWuEashN7
   9ads31XXJnMLytwTkAZ0pMVO0zkGRwZhXFmsc0b3iBC/Uu0ddI2QHlOVM
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10709"; a="348487602"
X-IronPort-AV: E=Sophos;i="5.99,273,1677571200"; 
   d="scan'208";a="348487602"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2023 15:57:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10709"; a="770171502"
X-IronPort-AV: E=Sophos;i="5.99,273,1677571200"; 
   d="scan'208";a="770171502"
Received: from estantil-desk.jf.intel.com ([10.166.241.20])
  by fmsmga004.fm.intel.com with ESMTP; 13 May 2023 15:57:26 -0700
From: Emil Tantilov <emil.s.tantilov@intel.com>
To: intel-wired-lan@lists.osuosl.org
Cc: shannon.nelson@amd.com,
	simon.horman@corigine.com,
	leon@kernel.org,
	decot@google.com,
	willemb@google.com,
	Joshua Hay <joshua.a.hay@intel.com>,
	jesse.brandeburg@intel.com,
	anthony.l.nguyen@intel.com,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	netdev@vger.kernel.org,
	Alan Brady <alan.brady@intel.com>,
	Madhu Chittim <madhu.chittim@intel.com>,
	Phani Burra <phani.r.burra@intel.com>,
	Pavan Kumar Linga <pavan.kumar.linga@intel.com>
Subject: [PATCH iwl-next v5 11/15] idpf: add TX splitq napi poll support
Date: Sat, 13 May 2023 15:57:06 -0700
Message-Id: <20230513225710.3898-12-emil.s.tantilov@intel.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20230513225710.3898-1-emil.s.tantilov@intel.com>
References: <20230513225710.3898-1-emil.s.tantilov@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>

From: Joshua Hay <joshua.a.hay@intel.com>

Add support to handle the interrupts for the TX completion queue and
process the various completion types.

In the flow scheduling mode, the driver processes primarily buffer
completions as well as descriptor completions occasionally. This mode
supports out of order TX completions. To do so, HW generates one buffer
completion per packet. Each of those completions contains the unique tag
provided during the TX encoding which is used to locate the packet either
on the TX buffer ring or in a hash table. The hash table is used to track
TX buffer information so the descriptor(s) for a given packet can be
reused while the driver is still waiting on the buffer completion(s).

Packets end up in the hash table in one of 2 ways: 1) a packet was
stashed during descriptor completion cleaning, or 2) because an out of
order buffer completion was processed. A descriptor completion arrives
only every so often and is primarily used to guarantee the TX descriptor
ring can be reused without having to wait on the individual buffer
completions. E.g. a descriptor completion for N+16 guarantees HW read all
of the descriptors for packets N through N+15, therefore all of the
buffers for packets N through N+15 are stashed into the hash table and the
descriptors can be reused for more TX packets. Similarly, a packet can be
stashed in the hash table because an out an order buffer completion was
processed. E.g. processing a buffer completion for packet N+3 implies that
HW read all of the descriptors for packets N through N+3 and they can be
reused. However, the HW did not do the DMA yet. The buffers for packets N
through N+2 cannot be freed, so they are stashed in the hash table.
In either case, the buffer completions will eventually be processed for
all of the stashed packets, and all of the buffers will be cleaned from
the hash table.

In queue based scheduling mode, the driver processes primarily descriptor
completions and cleans the TX ring the conventional way.

In addition, the driver processes miss and reinject completions when the
packet triggers the rule miss flow. The HW generates a miss completion
when a packet triggers this flow. While processing the miss completion,
the driver frees DMA buffers for the given packet, but it cannot free
the SKB or update BQLs (as the packet did not go out on the wire yet).
A reinject completion is expected to follow but not guaranteed, so the
driver starts a timer. Once the reinject completion is processed or the
timer expires, the driver frees the SKB and updates BQL. No other
completions are expected for this packet.

Finally, the driver triggers a TX queue drain after sending the disable
queues virtchnl message. When the HW completes the queue draining, it
sends the driver a queue marker packet completion. The driver determines
when all TX queues have been drained and proceeds with the disable flow.

With this, the driver can send TX packets and clean up the resources
properly.

Signed-off-by: Joshua Hay <joshua.a.hay@intel.com>
Co-developed-by: Alan Brady <alan.brady@intel.com>
Signed-off-by: Alan Brady <alan.brady@intel.com>
Co-developed-by: Madhu Chittim <madhu.chittim@intel.com>
Signed-off-by: Madhu Chittim <madhu.chittim@intel.com>
Co-developed-by: Phani Burra <phani.r.burra@intel.com>
Signed-off-by: Phani Burra <phani.r.burra@intel.com>
Co-developed-by: Pavan Kumar Linga <pavan.kumar.linga@intel.com>
Signed-off-by: Pavan Kumar Linga <pavan.kumar.linga@intel.com>
Reviewed-by: Sridhar Samudrala <sridhar.samudrala@intel.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
---
 drivers/net/ethernet/intel/idpf/idpf.h        |   11 +
 .../net/ethernet/intel/idpf/idpf_lan_txrx.h   |   16 +
 drivers/net/ethernet/intel/idpf/idpf_lib.c    |    2 +
 drivers/net/ethernet/intel/idpf/idpf_txrx.c   | 1029 ++++++++++++++++-
 drivers/net/ethernet/intel/idpf/idpf_txrx.h   |   49 +-
 .../net/ethernet/intel/idpf/idpf_virtchnl.c   |   52 +-
 6 files changed, 1154 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/idpf/idpf.h b/drivers/net/ethernet/intel/idpf/idpf.h
index 5e96e0efa5ec..75d537d9f10f 100644
--- a/drivers/net/ethernet/intel/idpf/idpf.h
+++ b/drivers/net/ethernet/intel/idpf/idpf.h
@@ -14,6 +14,7 @@ struct idpf_vport_max_q;
 #include <linux/etherdevice.h>
 #include <linux/pci.h>
 #include <linux/bitfield.h>
+#include <linux/dim.h>
 
 #include "virtchnl2.h"
 #include "idpf_lan_txrx.h"
@@ -203,12 +204,16 @@ extern const char * const idpf_vport_vc_state_str[];
  * enum idpf_vport_flags - vport flags
  * @IDPF_VPORT_VC_MSG_PENDING: Virtchnl message buffer received needs to be
  *			       processed
+ * @IDPF_VPORT_SW_MARKER: Indicate TX pipe drain software marker packets
+ *			  processing is done
  * @IDPF_VPORT_ADD_MAC_REQ: Asynchronous add ether address in flight
  * @IDPF_VPORT_DEL_MAC_REQ: Asynchronous delete ether address in flight
  * @IDPF_VPORT_FLAGS_NBITS: Must be last
  */
 enum idpf_vport_flags {
 	IDPF_VPORT_VC_MSG_PENDING,
+	/* Indicate TX pipe drain software marker packets processing is done */
+	IDPF_VPORT_SW_MARKER,
 	/* Asynchronous add/del ether address in flight */
 	IDPF_VPORT_ADD_MAC_REQ,
 	IDPF_VPORT_DEL_MAC_REQ,
@@ -232,6 +237,7 @@ struct idpf_vport {
 	 */
 	int txq_desc_count;
 	int complq_desc_count;
+	int compln_clean_budget;
 	int num_txq_grp;
 	struct idpf_txq_group *txq_grps;
 	u32 txq_model;
@@ -264,6 +270,9 @@ struct idpf_vport {
 	u16 *q_vector_idxs;			/* q vector index array */
 	u16 max_mtu;
 	u8 default_mac_addr[ETH_ALEN];
+	/* ITR profiles for the DIM algorithm */
+#define IDPF_DIM_PROFILE_SLOTS  5
+	u16 tx_itr_profile[IDPF_DIM_PROFILE_SLOTS];
 
 	bool link_up;
 
@@ -273,6 +282,8 @@ struct idpf_vport {
 	/* Everything below this will NOT be copied during soft reset */
 	enum idpf_vport_state state;
 	wait_queue_head_t vchnl_wq;
+	/* wait_queue for TX drain SW marker packets */
+	wait_queue_head_t sw_marker_wq;
 	/* lock to protect against multiple stop threads, which can happen when
 	 * the driver is in a namespace in a system that is being shutdown
 	 */
diff --git a/drivers/net/ethernet/intel/idpf/idpf_lan_txrx.h b/drivers/net/ethernet/intel/idpf/idpf_lan_txrx.h
index 5dd7f5367aab..a734345c75db 100644
--- a/drivers/net/ethernet/intel/idpf/idpf_lan_txrx.h
+++ b/drivers/net/ethernet/intel/idpf/idpf_lan_txrx.h
@@ -56,6 +56,14 @@ enum idpf_rss_hash {
 	BIT_ULL(IDPF_HASH_NONF_UNICAST_IPV6_UDP) |		\
 	BIT_ULL(IDPF_HASH_NONF_MULTICAST_IPV6_UDP))
 
+/* For idpf_splitq_base_tx_compl_desc */
+#define IDPF_TXD_COMPLQ_GEN_S		15
+#define IDPF_TXD_COMPLQ_GEN_M		BIT_ULL(IDPF_TXD_COMPLQ_GEN_S)
+#define IDPF_TXD_COMPLQ_COMPL_TYPE_S	11
+#define IDPF_TXD_COMPLQ_COMPL_TYPE_M	GENMASK_ULL(13, 11)
+#define IDPF_TXD_COMPLQ_QID_S		0
+#define IDPF_TXD_COMPLQ_QID_M		GENMASK_ULL(9, 0)
+
 #define IDPF_TXD_CTX_QW1_MSS_S		50
 #define IDPF_TXD_CTX_QW1_MSS_M		GENMASK_ULL(63, 50)
 #define IDPF_TXD_CTX_QW1_TSO_LEN_S	30
@@ -75,6 +83,14 @@ enum idpf_rss_hash {
 #define IDPF_TXD_QW1_DTYPE_S		0
 #define IDPF_TXD_QW1_DTYPE_M		GENMASK_ULL(3, 0)
 
+/* TX Completion Descriptor Completion Types */
+#define IDPF_TXD_COMPLT_ITR_FLUSH	0
+#define IDPF_TXD_COMPLT_RULE_MISS	1
+#define IDPF_TXD_COMPLT_RS		2
+#define IDPF_TXD_COMPLT_REINJECTED	3
+#define IDPF_TXD_COMPLT_RE		4
+#define IDPF_TXD_COMPLT_SW_MARKER	5
+
 enum idpf_tx_desc_dtype_value {
 	IDPF_TX_DESC_DTYPE_DATA				= 0,
 	IDPF_TX_DESC_DTYPE_CTX				= 1,
diff --git a/drivers/net/ethernet/intel/idpf/idpf_lib.c b/drivers/net/ethernet/intel/idpf/idpf_lib.c
index 1aadcedd0c42..9accf667eaa6 100644
--- a/drivers/net/ethernet/intel/idpf/idpf_lib.c
+++ b/drivers/net/ethernet/intel/idpf/idpf_lib.c
@@ -916,6 +916,7 @@ static struct idpf_vport *idpf_vport_alloc(struct idpf_adapter *adapter,
 
 	vport->idx = idx;
 	vport->adapter = adapter;
+	vport->compln_clean_budget = IDPF_TX_COMPLQ_CLEAN_BUDGET;
 	vport->default_vport = adapter->num_alloc_vports <
 			       idpf_get_default_vports(adapter);
 
@@ -1253,6 +1254,7 @@ void idpf_init_task(struct work_struct *work)
 	index = vport->idx;
 	vport_config = adapter->vport_config[index];
 
+	init_waitqueue_head(&vport->sw_marker_wq);
 	init_waitqueue_head(&vport->vchnl_wq);
 
 	spin_lock_init(&vport->mac_filter_list_lock);
diff --git a/drivers/net/ethernet/intel/idpf/idpf_txrx.c b/drivers/net/ethernet/intel/idpf/idpf_txrx.c
index a0bd45bd7278..7177b8fd0896 100644
--- a/drivers/net/ethernet/intel/idpf/idpf_txrx.c
+++ b/drivers/net/ethernet/intel/idpf/idpf_txrx.c
@@ -3,6 +3,36 @@
 
 #include "idpf.h"
 
+/**
+ * idpf_buf_lifo_push - push a buffer pointer onto stack
+ * @stack: pointer to stack struct
+ * @buf: pointer to buf to push
+ *
+ * Returns 0 on success, negative on failure
+ **/
+static int idpf_buf_lifo_push(struct idpf_buf_lifo *stack,
+			      struct idpf_tx_stash *buf)
+{
+	if (unlikely(stack->top == stack->size))
+		return -ENOSPC;
+
+	stack->bufs[stack->top++] = buf;
+
+	return 0;
+}
+
+/**
+ * idpf_buf_lifo_pop - pop a buffer pointer from stack
+ * @stack: pointer to stack struct
+ **/
+static struct idpf_tx_stash *idpf_buf_lifo_pop(struct idpf_buf_lifo *stack)
+{
+	if (unlikely(!stack->top))
+		return NULL;
+
+	return stack->bufs[--stack->top];
+}
+
 /**
  * idpf_tx_buf_rel - Release a Tx buffer
  * @tx_q: the queue that owns the buffer
@@ -1480,6 +1510,733 @@ int idpf_vport_queues_alloc(struct idpf_vport *vport)
 	return err;
 }
 
+/**
+ * idpf_tx_handle_sw_marker - Handle queue marker packet
+ * @tx_q: tx queue to handle software marker
+ */
+static void idpf_tx_handle_sw_marker(struct idpf_queue *tx_q)
+{
+	struct idpf_vport *vport = tx_q->vport;
+	int i;
+
+	clear_bit(__IDPF_Q_SW_MARKER, tx_q->flags);
+	/* Hardware must write marker packets to all queues associated with
+	 * completion queues. So check if all queues received marker packets
+	 */
+	for (i = 0; i < vport->num_txq; i++)
+		/* If we're still waiting on any other TXQ marker completions,
+		 * just return now since we cannot wake up the marker_wq yet.
+		 */
+		if (test_bit(__IDPF_Q_SW_MARKER, vport->txqs[i]->flags))
+			return;
+
+	/* Drain complete */
+	set_bit(IDPF_VPORT_SW_MARKER, vport->flags);
+	wake_up(&vport->sw_marker_wq);
+}
+
+/**
+ * idpf_tx_splitq_unmap_hdr - unmap DMA buffer for header
+ * @tx_q: tx queue to clean buffer from
+ * @tx_buf: buffer to be cleaned
+ */
+static void idpf_tx_splitq_unmap_hdr(struct idpf_queue *tx_q,
+				     struct idpf_tx_buf *tx_buf)
+{
+	/* unmap skb header data */
+	dma_unmap_single(tx_q->dev,
+			 dma_unmap_addr(tx_buf, dma),
+			 dma_unmap_len(tx_buf, len),
+			 DMA_TO_DEVICE);
+
+	dma_unmap_len_set(tx_buf, len, 0);
+}
+
+/**
+ * idpf_tx_splitq_clean_hdr - Clean TX buffer resources for header portion of
+ * packet
+ * @tx_q: tx queue to clean buffer from
+ * @tx_buf: buffer to be cleaned
+ * @cleaned: pointer to stats struct to track cleaned packets/bytes
+ * @napi_budget: Used to determine if we are in netpoll
+ */
+static void idpf_tx_splitq_clean_hdr(struct idpf_queue *tx_q,
+				     struct idpf_tx_buf *tx_buf,
+				     struct idpf_cleaned_stats *cleaned,
+				     int napi_budget)
+{
+	napi_consume_skb(tx_buf->skb, napi_budget);
+
+	if (dma_unmap_len(tx_buf, len))
+		idpf_tx_splitq_unmap_hdr(tx_q, tx_buf);
+
+	/* clear tx_buf data */
+	tx_buf->skb = NULL;
+
+	cleaned->bytes += tx_buf->bytecount;
+	cleaned->packets += tx_buf->gso_segs;
+}
+
+/**
+ * idpf_tx_clean_stashed_bufs - clean bufs that were stored for
+ * out of order completions
+ * @txq: queue to clean
+ * @compl_tag: completion tag of packet to clean (from completion descriptor)
+ * @cleaned: pointer to stats struct to track cleaned packets/bytes
+ * @budget: Used to determine if we are in netpoll
+ */
+static void idpf_tx_clean_stashed_bufs(struct idpf_queue *txq, u16 compl_tag,
+				       struct idpf_cleaned_stats *cleaned,
+				       int budget)
+{
+	struct idpf_tx_stash *stash;
+	struct hlist_node *tmp_buf;
+
+	/* Buffer completion */
+	hash_for_each_possible_safe(txq->sched_buf_hash, stash, tmp_buf,
+				    hlist, compl_tag) {
+		if (unlikely(stash->buf.compl_tag != (int)compl_tag))
+			continue;
+
+		if (stash->buf.skb) {
+			idpf_tx_splitq_clean_hdr(txq, &stash->buf, cleaned,
+						 budget);
+		} else if (dma_unmap_len(&stash->buf, len)) {
+			dma_unmap_page(txq->dev,
+				       dma_unmap_addr(&stash->buf, dma),
+				       dma_unmap_len(&stash->buf, len),
+				       DMA_TO_DEVICE);
+			dma_unmap_len_set(&stash->buf, len, 0);
+		}
+		if (stash->miss_pkt)
+			del_timer(&stash->reinject_timer);
+
+		/* Push shadow buf back onto stack */
+		idpf_buf_lifo_push(&txq->buf_stack, stash);
+
+		hash_del(&stash->hlist);
+	}
+}
+
+/**
+ * idpf_tx_find_stashed_bufs - fetch "first" buffer for a packet with the given
+ * completion tag
+ * @txq: queue to clean
+ * @compl_tag: completion tag of packet to clean (from completion descriptor)
+ */
+static struct idpf_tx_stash *idpf_tx_find_stashed_bufs(struct idpf_queue *txq,
+						       u16 compl_tag)
+{
+	struct idpf_tx_stash *stash;
+
+	/* Buffer completion */
+	hash_for_each_possible(txq->sched_buf_hash, stash, hlist, compl_tag) {
+		if (unlikely(stash->buf.compl_tag != (int)compl_tag))
+			continue;
+
+		if (stash->buf.skb)
+			return stash;
+	}
+
+	return NULL;
+}
+
+/**
+ * idpf_tx_handle_reinject_expire - handler for miss completion timer
+ * @timer: pointer to timer that expired
+ */
+static void idpf_tx_handle_reinject_expire(struct timer_list *timer)
+{
+	struct idpf_tx_stash *stash = from_timer(stash, timer, reinject_timer);
+	struct idpf_cleaned_stats cleaned = { };
+	struct idpf_queue *txq = stash->txq;
+	struct netdev_queue *nq;
+
+	idpf_tx_clean_stashed_bufs(txq, stash->buf.compl_tag, &cleaned, 0);
+
+	/* Update BQL */
+	nq = netdev_get_tx_queue(txq->vport->netdev, txq->idx);
+	netdev_tx_completed_queue(nq, cleaned.packets, cleaned.bytes);
+}
+
+/**
+ * idpf_tx_start_reinject_timer - start timer to wait for reinject completion
+ * @txq: pointer to queue struct
+ * @stash: stash of packet to start timer for
+ */
+static void idpf_tx_start_reinject_timer(struct idpf_queue *txq,
+					 struct idpf_tx_stash *stash)
+{
+	/* Back pointer to txq so timer expire handler knows what to
+	 * clean if timer expires.
+	 */
+	stash->txq = txq;
+	timer_setup(&stash->reinject_timer, idpf_tx_handle_reinject_expire, 0);
+	mod_timer(&stash->reinject_timer, jiffies + msecs_to_jiffies(4 * HZ));
+}
+
+/**
+ * idpf_stash_flow_sch_buffers - store buffer parameters info to be freed at a
+ * later time (only relevant for flow scheduling mode)
+ * @txq: Tx queue to clean
+ * @tx_buf: buffer to store
+ * @compl_type: type of completion, determines what extra steps need to be
+ * taken when stashing, such as starting the reinject timer on a miss
+ * completion. Only IDPF_TXD_COMPLT_RULE_MISS and IDPF_TXD_COMPLT_REINJECTED
+ * are relevant
+ */
+static int idpf_stash_flow_sch_buffers(struct idpf_queue *txq,
+				       struct idpf_tx_buf *tx_buf,
+				       u8 compl_type)
+{
+	struct idpf_tx_stash *stash;
+
+	if (unlikely(!dma_unmap_addr(tx_buf, dma) &&
+		     !dma_unmap_len(tx_buf, len)))
+		return 0;
+
+	stash = idpf_buf_lifo_pop(&txq->buf_stack);
+	if (unlikely(!stash)) {
+		net_err_ratelimited("%s: No out-of-order TX buffers left!\n",
+				    txq->vport->netdev->name);
+
+		return -ENOMEM;
+	}
+
+	/* Store buffer params in shadow buffer */
+	stash->buf.skb = tx_buf->skb;
+	stash->buf.bytecount = tx_buf->bytecount;
+	stash->buf.gso_segs = tx_buf->gso_segs;
+	dma_unmap_addr_set(&stash->buf, dma, dma_unmap_addr(tx_buf, dma));
+	dma_unmap_len_set(&stash->buf, len, dma_unmap_len(tx_buf, len));
+	stash->buf.compl_tag = tx_buf->compl_tag;
+
+	if (unlikely(compl_type == IDPF_TXD_COMPLT_RULE_MISS)) {
+		idpf_tx_start_reinject_timer(txq, stash);
+		stash->miss_pkt = true;
+	} else if (unlikely(compl_type == IDPF_TXD_COMPLT_REINJECTED)) {
+		stash->miss_pkt = true;
+	}
+
+	/* Add buffer to buf_hash table to be freed later */
+	hash_add(txq->sched_buf_hash, &stash->hlist, stash->buf.compl_tag);
+
+	memset(tx_buf, 0, sizeof(struct idpf_tx_buf));
+
+	/* Reinitialize buf_id portion of tag */
+	tx_buf->compl_tag = IDPF_SPLITQ_TX_INVAL_COMPL_TAG;
+
+	return 0;
+}
+
+#define idpf_tx_splitq_clean_bump_ntc(txq, ntc, desc, buf)	\
+do {								\
+	(ntc)++;						\
+	if (unlikely(!(ntc))) {					\
+		ntc -= (txq)->desc_count;			\
+		buf = (txq)->tx_buf;				\
+		desc = IDPF_FLEX_TX_DESC(txq, 0);		\
+	} else {						\
+		(buf)++;					\
+		(desc)++;					\
+	}							\
+} while (0)
+
+/**
+ * idpf_tx_splitq_clean - Reclaim resources from buffer queue
+ * @tx_q: Tx queue to clean
+ * @end: queue index until which it should be cleaned
+ * @napi_budget: Used to determine if we are in netpoll
+ * @cleaned: pointer to stats struct to track cleaned packets/bytes
+ * @descs_only: true if queue is using flow-based scheduling and should
+ * not clean buffers at this time
+ *
+ * Cleans the queue descriptor ring. If the queue is using queue-based
+ * scheduling, the buffers will be cleaned as well. If the queue is using
+ * flow-based scheduling, only the descriptors are cleaned at this time.
+ * Separate packet completion events will be reported on the completion queue,
+ * and the buffers will be cleaned separately. The stats are not updated from
+ * this function when using flow-based scheduling.
+ */
+static void idpf_tx_splitq_clean(struct idpf_queue *tx_q, u16 end,
+				 int napi_budget,
+				 struct idpf_cleaned_stats *cleaned,
+				 bool descs_only)
+{
+	union idpf_tx_flex_desc *next_pending_desc = NULL;
+	union idpf_tx_flex_desc *tx_desc;
+	s16 ntc = tx_q->next_to_clean;
+	struct idpf_tx_buf *tx_buf;
+
+	tx_desc = IDPF_FLEX_TX_DESC(tx_q, ntc);
+	next_pending_desc = IDPF_FLEX_TX_DESC(tx_q, end);
+	tx_buf = &tx_q->tx_buf[ntc];
+	ntc -= tx_q->desc_count;
+
+	while (tx_desc != next_pending_desc) {
+		union idpf_tx_flex_desc *eop_desc;
+
+		/* If this entry in the ring was used as a context descriptor,
+		 * it's corresponding entry in the buffer ring will have an
+		 * invalid completion tag since no buffer was used.  We can
+		 * skip this descriptor since there is no buffer to clean.
+		 */
+		if (unlikely(tx_buf->compl_tag == IDPF_SPLITQ_TX_INVAL_COMPL_TAG))
+			goto fetch_next_txq_desc;
+
+		eop_desc = (union idpf_tx_flex_desc *)tx_buf->next_to_watch;
+
+		/* clear next_to_watch to prevent false hangs */
+		tx_buf->next_to_watch = NULL;
+
+		if (descs_only) {
+			if (idpf_stash_flow_sch_buffers(tx_q, tx_buf, IDPF_TXD_COMPLT_RE))
+				goto tx_splitq_clean_out;
+
+			while (tx_desc != eop_desc) {
+				idpf_tx_splitq_clean_bump_ntc(tx_q, ntc,
+							      tx_desc, tx_buf);
+
+				if (dma_unmap_len(tx_buf, len)) {
+					if (idpf_stash_flow_sch_buffers(tx_q,
+									tx_buf,
+									IDPF_TXD_COMPLT_RE))
+						goto tx_splitq_clean_out;
+				}
+			}
+		} else {
+			idpf_tx_splitq_clean_hdr(tx_q, tx_buf, cleaned,
+						 napi_budget);
+
+			/* unmap remaining buffers */
+			while (tx_desc != eop_desc) {
+				idpf_tx_splitq_clean_bump_ntc(tx_q, ntc,
+							      tx_desc, tx_buf);
+
+				/* unmap any remaining paged data */
+				if (dma_unmap_len(tx_buf, len)) {
+					dma_unmap_page(tx_q->dev,
+						       dma_unmap_addr(tx_buf, dma),
+						       dma_unmap_len(tx_buf, len),
+						       DMA_TO_DEVICE);
+					dma_unmap_len_set(tx_buf, len, 0);
+				}
+			}
+		}
+
+fetch_next_txq_desc:
+		idpf_tx_splitq_clean_bump_ntc(tx_q, ntc, tx_desc, tx_buf);
+	}
+
+tx_splitq_clean_out:
+	ntc += tx_q->desc_count;
+	tx_q->next_to_clean = ntc;
+}
+
+#define idpf_tx_clean_buf_ring_bump_ntc(txq, ntc, buf)	\
+do {							\
+	(buf)++;					\
+	(ntc)++;					\
+	if (unlikely((ntc) == (txq)->desc_count)) {	\
+		buf = (txq)->tx_buf;			\
+		ntc = 0;				\
+	}						\
+} while (0)
+
+/**
+ * idpf_tx_clean_buf_ring - clean flow scheduling TX queue buffers
+ * @txq: queue to clean
+ * @compl_tag: completion tag of packet to clean (from completion descriptor)
+ * @compl_type: completion type
+ *	IDPF_TXD_COMPLT_RS - clean all buffers with given completion tag and
+ *	stash any buffers on the ring prior to this packet.
+ *
+ *	IDPF_TXD_COMPLT_RULE_MISS - stash the skb and unmap/free DMA buffers.
+ *
+ *	IDPF_TXD_COMPLT_REINJECTED - stash buffers with this completion tag and
+ *	any buffers on the ring prior to this packet.
+ * @cleaned: pointer to stats struct to track cleaned packets/bytes
+ * @budget: Used to determine if we are in netpoll
+ *
+ * Cleans all buffers associated with the input completion tag either from the
+ * TX buffer ring or from the hash table if the buffers were previously
+ * stashed. Returns the byte/segment count for the cleaned packet associated
+ * this completion tag.
+ */
+static bool idpf_tx_clean_buf_ring(struct idpf_queue *txq,
+				   u16 compl_tag, u8 compl_type,
+				   struct idpf_cleaned_stats *cleaned,
+				   int budget)
+{
+	u16 idx = compl_tag & txq->compl_tag_bufid_m;
+	struct idpf_tx_buf *tx_buf = NULL;
+	u16 ntc = txq->next_to_clean;
+	u16 num_descs_cleaned = 0;
+	u16 orig_idx = idx;
+
+	tx_buf = &txq->tx_buf[idx];
+
+	while (tx_buf->compl_tag == (int)compl_tag) {
+		if (unlikely(compl_type == IDPF_TXD_COMPLT_REINJECTED)) {
+			idpf_stash_flow_sch_buffers(txq, tx_buf, compl_type);
+		} else if (tx_buf->skb) {
+			if (unlikely(compl_type == IDPF_TXD_COMPLT_RULE_MISS)) {
+				/* Since we received a miss completion, we can
+				 * free all of the buffers, but cannot free the
+				 * skb or update the stack BQL yet. We will
+				 * stash the skb and start the timer to wait
+				 * for the reinject completion
+				 */
+				idpf_tx_splitq_unmap_hdr(txq, tx_buf);
+
+				idpf_stash_flow_sch_buffers(txq, tx_buf,
+							    compl_type);
+			} else {
+				idpf_tx_splitq_clean_hdr(txq, tx_buf, cleaned,
+							 budget);
+			}
+		} else if (dma_unmap_len(tx_buf, len)) {
+			dma_unmap_page(txq->dev,
+				       dma_unmap_addr(tx_buf, dma),
+				       dma_unmap_len(tx_buf, len),
+				       DMA_TO_DEVICE);
+			dma_unmap_len_set(tx_buf, len, 0);
+		}
+
+		memset(tx_buf, 0, sizeof(struct idpf_tx_buf));
+		tx_buf->compl_tag = IDPF_SPLITQ_TX_INVAL_COMPL_TAG;
+
+		num_descs_cleaned++;
+		idpf_tx_clean_buf_ring_bump_ntc(txq, idx, tx_buf);
+	}
+
+	/* If we didn't clean anything on the ring for this completion, there's
+	 * nothing more to do.
+	 */
+	if (unlikely(!num_descs_cleaned))
+		return false;
+
+	/* Otherwise, if we did clean a packet on the ring directly, it's safe
+	 * to assume that the descriptors starting from the original
+	 * next_to_clean up until the previously cleaned packet can be reused.
+	 * Therefore, we will go back in the ring and stash any buffers still
+	 * in the ring into the hash table to be cleaned later.
+	 */
+	tx_buf = &txq->tx_buf[ntc];
+	while (tx_buf != &txq->tx_buf[orig_idx]) {
+		idpf_stash_flow_sch_buffers(txq, tx_buf, IDPF_TXD_COMPLT_RS);
+		idpf_tx_clean_buf_ring_bump_ntc(txq, ntc, tx_buf);
+	}
+
+	/* Finally, update next_to_clean to reflect the work that was just done
+	 * on the ring, if any. If the packet was only cleaned from the hash
+	 * table, the ring will not be impacted, therefore we should not touch
+	 * next_to_clean. The updated idx is used here
+	 */
+	txq->next_to_clean = idx;
+
+	return true;
+}
+
+/**
+ * idpf_tx_handle_miss_completion
+ * @txq: Tx ring to clean
+ * @desc: pointer to completion queue descriptor to extract completion
+ * information from
+ * @cleaned: pointer to stats struct to track cleaned packets/bytes
+ * @budget: Used to determine if we are in netpoll
+ *
+ * Determines where the packet is located, the hash table or the ring. If the
+ * packet is on the ring, the ring cleaning function will take care of freeing
+ * the DMA buffers and stash the SKB. The stashing function, called inside the
+ * ring cleaning function, will take care of starting the timer.
+ *
+ * If packet is already in the hashtable, determine if we need to finish up the
+ * reinject completion or start the timer to wait for the reinject completion.
+ *
+ * Returns cleaned bytes/packets only if we're finishing up the reinject
+ * completion and freeing the skb. Otherwise, the stats are 0 / irrelevant
+ */
+static void idpf_tx_handle_miss_completion(struct idpf_queue *txq,
+					   struct idpf_splitq_tx_compl_desc *desc,
+					   struct idpf_cleaned_stats *cleaned,
+					   int budget)
+{
+	u16 compl_tag = le16_to_cpu(desc->q_head_compl_tag.compl_tag);
+	struct idpf_tx_stash *stash;
+
+	/* First determine if this packet was already stashed */
+	stash = idpf_tx_find_stashed_bufs(txq, compl_tag);
+	if (!stash) {
+		/* Packet must still be on the ring, go pull it from there. */
+		idpf_tx_clean_buf_ring(txq, compl_tag,
+				       IDPF_TXD_COMPLT_RULE_MISS,
+				       cleaned, budget);
+	} else {
+		if (stash->miss_pkt)
+			/* If it was previously stashed because
+			 * of a reinject completion, we can go
+			 * ahead and clean everything up
+			 */
+			idpf_tx_clean_stashed_bufs(txq, compl_tag, cleaned,
+						   budget);
+		else
+			/* If it was previously stashed because
+			 * of an RE completion, we just need to
+			 * start the timer while we wait for
+			 * the reinject completion
+			 */
+			idpf_tx_start_reinject_timer(txq, stash);
+	}
+}
+
+/**
+ * idpf_tx_handle_rs_completion - clean a single packet and all of its buffers
+ * whether on the buffer ring or in the hash table
+ * @txq: Tx ring to clean
+ * @desc: pointer to completion queue descriptor to extract completion
+ * information from
+ * @cleaned: pointer to stats struct to track cleaned packets/bytes
+ * @budget: Used to determine if we are in netpoll
+ *
+ * Returns bytes/packets cleaned
+ */
+static void idpf_tx_handle_rs_completion(struct idpf_queue *txq,
+					 struct idpf_splitq_tx_compl_desc *desc,
+					 struct idpf_cleaned_stats *cleaned,
+					 int budget)
+{
+	u16 compl_tag;
+
+	if (!test_bit(__IDPF_Q_FLOW_SCH_EN, txq->flags)) {
+		u16 head = le16_to_cpu(desc->q_head_compl_tag.q_head);
+
+		return idpf_tx_splitq_clean(txq, head, budget, cleaned, false);
+	}
+
+	compl_tag = le16_to_cpu(desc->q_head_compl_tag.compl_tag);
+	/* Check for miss completion in tag if enabled */
+	if (unlikely(test_bit(__IDPF_Q_MISS_TAG_EN, txq->flags) &&
+		     compl_tag & IDPF_TX_SPLITQ_MISS_COMPL_TAG))
+		return idpf_tx_handle_miss_completion(txq, desc, cleaned,
+						      budget);
+
+	/* If we didn't clean anything on the ring, this packet must be
+	 * in the hash table. Go clean it there.
+	 */
+	if (!idpf_tx_clean_buf_ring(txq, compl_tag, IDPF_TXD_COMPLT_RS,
+				    cleaned, budget))
+		idpf_tx_clean_stashed_bufs(txq, compl_tag, cleaned, budget);
+}
+
+/**
+ * idpf_tx_handle_reinject_completion
+ * @txq: Tx ring to clean
+ * @desc: pointer to completion queue descriptor to extract completion
+ * information from
+ * @cleaned: pointer to stats struct to track cleaned packets/bytes
+ * @budget: Used to determine if we are in netpoll
+ */
+static void
+idpf_tx_handle_reinject_completion(struct idpf_queue *txq,
+				   struct idpf_splitq_tx_compl_desc *desc,
+				   struct idpf_cleaned_stats *cleaned,
+				   int budget)
+{
+	u16 compl_tag = le16_to_cpu(desc->q_head_compl_tag.compl_tag);
+	struct idpf_tx_stash *stash;
+
+	/* First check if the packet has already been stashed because of a miss
+	 * completion
+	 */
+	stash = idpf_tx_find_stashed_bufs(txq, compl_tag);
+	if (stash) {
+		if (stash->miss_pkt)
+			/* If it was previously stashed because of a miss
+			 * completion, we can go ahead and clean everything up
+			 */
+			idpf_tx_clean_stashed_bufs(txq, compl_tag, cleaned,
+						   budget);
+		else
+			/* If it was previously stashed because of a RE or out
+			 * of order RS completion, it means we received the
+			 * reinject completion before the miss completion.
+			 * However, since the packet did take the miss path, it
+			 * is guaranteed to get a miss completion Therefore,
+			 * mark it as a miss path packet in the hash table so
+			 * it will be cleaned upon receiving the miss
+			 * completion
+			 */
+			stash->miss_pkt = true;
+	} else {
+		/* If it was not in the hash table, the packet is still on the
+		 * ring.  This is another scenario in which the reinject
+		 * completion arrives before the miss completion.  We can
+		 * simply stash all of the buffers associated with this packet
+		 * and any buffers on the ring prior to it.  We will clean the
+		 * packet and all of its buffers associated with this
+		 * completion tag upon receiving the miss completion, and clean
+		 * the others upon receiving their respective RS completions.
+		 */
+		idpf_tx_clean_buf_ring(txq, compl_tag, IDPF_TXD_COMPLT_REINJECTED,
+				       cleaned, budget);
+	}
+
+	/* If the packet is not in the ring or hash table, it means we either
+	 * received a regular completion already or the timer expired on the
+	 * miss completion.  In either case, everything should already be
+	 * cleaned up and we should ignore this completion.
+	 */
+}
+
+/**
+ * idpf_tx_clean_complq - Reclaim resources on completion queue
+ * @complq: Tx ring to clean
+ * @budget: Used to determine if we are in netpoll
+ * @cleaned: returns number of packets cleaned
+ *
+ * Returns true if there's any budget left (e.g. the clean is finished)
+ */
+static bool idpf_tx_clean_complq(struct idpf_queue *complq, int budget,
+				 int *cleaned)
+{
+	struct idpf_splitq_tx_compl_desc *tx_desc;
+	struct idpf_vport *vport = complq->vport;
+	s16 ntc = complq->next_to_clean;
+	unsigned int complq_budget;
+	bool complq_ok = true;
+	int i;
+
+	complq_budget = vport->compln_clean_budget;
+	tx_desc = IDPF_SPLITQ_TX_COMPLQ_DESC(complq, ntc);
+	ntc -= complq->desc_count;
+
+	do {
+		struct idpf_cleaned_stats cleaned_stats = { };
+		struct idpf_queue *tx_q;
+		int rel_tx_qid;
+		u16 hw_head;
+		u8 ctype;	/* completion type */
+		u16 gen;
+
+		/* if the descriptor isn't done, no work yet to do */
+		gen = (le16_to_cpu(tx_desc->qid_comptype_gen) &
+		      IDPF_TXD_COMPLQ_GEN_M) >> IDPF_TXD_COMPLQ_GEN_S;
+		if (test_bit(__IDPF_Q_GEN_CHK, complq->flags) != gen)
+			break;
+
+		/* Find necessary info of TX queue to clean buffers */
+		rel_tx_qid = (le16_to_cpu(tx_desc->qid_comptype_gen) &
+			 IDPF_TXD_COMPLQ_QID_M) >> IDPF_TXD_COMPLQ_QID_S;
+		if (rel_tx_qid >= complq->txq_grp->num_txq ||
+		    !complq->txq_grp->txqs[rel_tx_qid]) {
+			dev_err(&complq->vport->adapter->pdev->dev,
+				"TxQ not found\n");
+			goto fetch_next_desc;
+		}
+		tx_q = complq->txq_grp->txqs[rel_tx_qid];
+
+		/* Determine completion type */
+		ctype = (le16_to_cpu(tx_desc->qid_comptype_gen) &
+			IDPF_TXD_COMPLQ_COMPL_TYPE_M) >>
+			IDPF_TXD_COMPLQ_COMPL_TYPE_S;
+		switch (ctype) {
+		case IDPF_TXD_COMPLT_RE:
+			hw_head = le16_to_cpu(tx_desc->q_head_compl_tag.q_head);
+
+			idpf_tx_splitq_clean(tx_q, hw_head, budget,
+					     &cleaned_stats, true);
+			break;
+		case IDPF_TXD_COMPLT_RS:
+			idpf_tx_handle_rs_completion(tx_q, tx_desc,
+						     &cleaned_stats, budget);
+			break;
+		case IDPF_TXD_COMPLT_SW_MARKER:
+			idpf_tx_handle_sw_marker(tx_q);
+			break;
+		case IDPF_TXD_COMPLT_RULE_MISS:
+			idpf_tx_handle_miss_completion(tx_q, tx_desc,
+						       &cleaned_stats, budget);
+			break;
+		case IDPF_TXD_COMPLT_REINJECTED:
+			idpf_tx_handle_reinject_completion(tx_q, tx_desc,
+							   &cleaned_stats, budget);
+			break;
+		default:
+			dev_err(&tx_q->vport->adapter->pdev->dev,
+				"Unknown TX completion type: %d\n",
+				ctype);
+			goto fetch_next_desc;
+		}
+
+		u64_stats_update_begin(&tx_q->stats_sync);
+		u64_stats_add(&tx_q->q_stats.tx.packets, cleaned_stats.packets);
+		u64_stats_add(&tx_q->q_stats.tx.bytes, cleaned_stats.bytes);
+		tx_q->cleaned_pkts += cleaned_stats.packets;
+		tx_q->cleaned_bytes += cleaned_stats.bytes;
+		complq->num_completions++;
+		u64_stats_update_end(&tx_q->stats_sync);
+
+fetch_next_desc:
+		tx_desc++;
+		ntc++;
+		if (unlikely(!ntc)) {
+			ntc -= complq->desc_count;
+			tx_desc = IDPF_SPLITQ_TX_COMPLQ_DESC(complq, 0);
+			change_bit(__IDPF_Q_GEN_CHK, complq->flags);
+		}
+
+		prefetch(tx_desc);
+
+		/* update budget accounting */
+		complq_budget--;
+	} while (likely(complq_budget));
+
+	/* Store the state of the complq to be used later in deciding if a
+	 * TXQ can be started again
+	 */
+	if (unlikely(IDPF_TX_COMPLQ_PENDING(complq->txq_grp) >
+		     IDPF_TX_COMPLQ_OVERFLOW_THRESH(complq)))
+		complq_ok = false;
+
+	for (i = 0; i < complq->txq_grp->num_txq; ++i) {
+		struct idpf_queue *tx_q = complq->txq_grp->txqs[i];
+		struct netdev_queue *nq;
+
+		/* We didn't clean anything on this queue, move along */
+		if (!tx_q->cleaned_bytes)
+			continue;
+
+		*cleaned += tx_q->cleaned_pkts;
+
+		/* Update BQL */
+		nq = netdev_get_tx_queue(tx_q->vport->netdev, tx_q->idx);
+		netdev_tx_completed_queue(nq, tx_q->cleaned_pkts, tx_q->cleaned_bytes);
+
+		/* Reset cleaned stats for the next time this queue is cleaned */
+		tx_q->cleaned_bytes = 0;
+		tx_q->cleaned_pkts = 0;
+
+		/* Check if the TXQ needs to and can be restarted */
+		if (unlikely(netif_tx_queue_stopped(nq) && complq_ok &&
+			     netif_carrier_ok(tx_q->vport->netdev) &&
+			     IDPF_TX_BUF_RSV_LOW(tx_q) &&
+			     (IDPF_DESC_UNUSED(tx_q) >= IDPF_TX_WAKE_THRESH))) {
+			/* Make sure any other threads stopping queue after
+			 * this see new next_to_clean.
+			 */
+			smp_mb();
+			if (complq->vport->state == __IDPF_VPORT_UP)
+				netif_tx_wake_queue(nq);
+		}
+	}
+
+	ntc += complq->desc_count;
+	complq->next_to_clean = ntc;
+
+	return !!complq_budget;
+}
+
 /**
  * idpf_tx_splitq_build_ctb - populate command tag and size for queue
  * based scheduling descriptors
@@ -2274,7 +3031,11 @@ netdev_tx_t idpf_tx_splitq_start(struct sk_buff *skb,
 static irqreturn_t idpf_vport_intr_clean_queues(int __always_unused irq,
 						void *data)
 {
-	/* stub */
+	struct idpf_q_vector *q_vector = (struct idpf_q_vector *)data;
+
+	q_vector->total_events++;
+	napi_schedule(&q_vector->napi);
+
 	return IRQ_HANDLED;
 }
 
@@ -2380,6 +3141,121 @@ static void idpf_vport_intr_rel_irq(struct idpf_vport *vport)
 	}
 }
 
+/**
+ * idpf_vport_intr_dis_irq_all - Disable all interrupt
+ * @vport: main vport structure
+ */
+static void idpf_vport_intr_dis_irq_all(struct idpf_vport *vport)
+{
+	struct idpf_q_vector *q_vector = vport->q_vectors;
+	int q_idx;
+
+	for (q_idx = 0; q_idx < vport->num_q_vectors; q_idx++)
+		writel(0, q_vector[q_idx].intr_reg.dyn_ctl);
+}
+
+/**
+ * idpf_vport_intr_buildreg_itr - Enable default interrupt generation settings
+ * @q_vector: pointer to q_vector
+ * @type: itr index
+ * @itr: itr value
+ */
+static u32 idpf_vport_intr_buildreg_itr(struct idpf_q_vector *q_vector,
+					const int type, u16 itr)
+{
+	u32 itr_val;
+
+	itr &= IDPF_ITR_MASK;
+	/* Don't clear PBA because that can cause lost interrupts that
+	 * came in while we were cleaning/polling
+	 */
+	itr_val = q_vector->intr_reg.dyn_ctl_intena_m |
+		  (type << q_vector->intr_reg.dyn_ctl_itridx_s) |
+		  (itr << (q_vector->intr_reg.dyn_ctl_intrvl_s - 1));
+
+	return itr_val;
+}
+
+/**
+ * idpf_update_dim_sample - Update dim sample with packets and bytes
+ * @q_vector: the vector associated with the interrupt
+ * @dim_sample: dim sample to update
+ * @dim: dim instance structure
+ * @packets: total packets
+ * @bytes: total bytes
+ *
+ * Update the dim sample with the packets and bytes which are passed to this
+ * function. Set the dim state appropriately if the dim settings gets stale.
+ */
+static void idpf_update_dim_sample(struct idpf_q_vector *q_vector,
+				   struct dim_sample *dim_sample,
+				   struct dim *dim, u64 packets, u64 bytes)
+{
+	dim_update_sample(q_vector->total_events, packets, bytes, dim_sample);
+	dim_sample->comp_ctr = 0;
+
+	/* if dim settings get stale, like when not updated for 1 second or
+	 * longer, force it to start again. This addresses the frequent case
+	 * of an idle queue being switched to by the scheduler.
+	 */
+	if (ktime_ms_delta(dim_sample->time, dim->start_sample.time) >= HZ)
+		dim->state = DIM_START_MEASURE;
+}
+
+/**
+ * idpf_net_dim - Update net DIM algorithm
+ * @q_vector: the vector associated with the interrupt
+ *
+ * Create a DIM sample and notify net_dim() so that it can possibly decide
+ * a new ITR value based on incoming packets, bytes, and interrupts.
+ *
+ * This function is a no-op if the queue is not configured to dynamic ITR.
+ */
+static void idpf_net_dim(struct idpf_q_vector *q_vector)
+{
+	struct dim_sample dim_sample = { };
+	u64 packets, bytes;
+	u32 i;
+
+	if (!IDPF_ITR_IS_DYNAMIC(q_vector->tx_intr_mode))
+		return;
+
+	for (i = 0, packets = 0, bytes = 0; i < q_vector->num_txq; i++) {
+		struct idpf_queue *txq = q_vector->tx[i];
+		unsigned int start;
+
+		do {
+			start = u64_stats_fetch_begin(&txq->stats_sync);
+			packets += u64_stats_read(&txq->q_stats.tx.packets);
+			bytes += u64_stats_read(&txq->q_stats.tx.bytes);
+		} while (u64_stats_fetch_retry(&txq->stats_sync, start));
+	}
+
+	idpf_update_dim_sample(q_vector, &dim_sample, &q_vector->tx_dim,
+			       packets, bytes);
+	net_dim(&q_vector->tx_dim, dim_sample);
+}
+
+/**
+ * idpf_vport_intr_update_itr_ena_irq - Update itr and re-enable MSIX interrupt
+ * @q_vector: q_vector for which itr is being updated and interrupt enabled
+ *
+ * Update the net_dim() algorithm and re-enable the interrupt associated with
+ * this vector.
+ */
+static void idpf_vport_intr_update_itr_ena_irq(struct idpf_q_vector *q_vector)
+{
+	u32 intval;
+
+	/* net_dim() updates ITR out-of-band using a work item */
+	idpf_net_dim(q_vector);
+
+	intval = idpf_vport_intr_buildreg_itr(q_vector,
+					      IDPF_NO_ITR_UPDATE_IDX, 0);
+
+	writel(intval, q_vector->intr_reg.dyn_ctl);
+}
+
 /**
  * idpf_vport_intr_req_irq - get MSI-X vectors from the OS for the vport
  * @vport: main vport structure
@@ -2432,6 +3308,54 @@ static int idpf_vport_intr_req_irq(struct idpf_vport *vport, char *basename)
 	return err;
 }
 
+/**
+ * idpf_vport_intr_write_itr - Write ITR value to the ITR register
+ * @q_vector: q_vector structure
+ * @itr: Interrupt throttling rate
+ * @tx: Tx or Rx ITR
+ */
+static void idpf_vport_intr_write_itr(struct idpf_q_vector *q_vector,
+				      u16 itr, bool tx)
+{
+	struct idpf_intr_reg *intr_reg;
+
+	if (tx && !q_vector->tx)
+		return;
+	else if (!tx && !q_vector->rx)
+		return;
+
+	intr_reg = &q_vector->intr_reg;
+	writel(ITR_REG_ALIGN(itr) >> IDPF_ITR_GRAN_S,
+	       tx ? intr_reg->tx_itr : intr_reg->rx_itr);
+}
+
+/**
+ * idpf_vport_intr_ena_irq_all - Enable IRQ for the given vport
+ * @vport: main vport structure
+ */
+static void idpf_vport_intr_ena_irq_all(struct idpf_vport *vport)
+{
+	bool dynamic;
+	int q_idx;
+	u16 itr;
+
+	for (q_idx = 0; q_idx < vport->num_q_vectors; q_idx++) {
+		struct idpf_q_vector *qv = &vport->q_vectors[q_idx];
+
+		/* Set the initial ITR values */
+		if (qv->num_txq) {
+			dynamic = IDPF_ITR_IS_DYNAMIC(qv->tx_intr_mode);
+			itr = vport->tx_itr_profile[qv->tx_dim.profile_ix];
+			idpf_vport_intr_write_itr(qv, dynamic ?
+						  itr : qv->tx_itr_value,
+						  true);
+		}
+
+		if (qv->num_txq)
+			idpf_vport_intr_update_itr_ena_irq(qv);
+	}
+}
+
 /**
  * idpf_vport_intr_deinit - Release all vector associations for the vport
  * @vport: main vport structure
@@ -2440,9 +3364,47 @@ void idpf_vport_intr_deinit(struct idpf_vport *vport)
 {
 	idpf_vport_intr_napi_dis_all(vport);
 	idpf_vport_intr_napi_del_all(vport);
+	idpf_vport_intr_dis_irq_all(vport);
 	idpf_vport_intr_rel_irq(vport);
 }
 
+/**
+ * idpf_tx_dim_work - Call back from the stack
+ * @work: work queue structure
+ */
+static void idpf_tx_dim_work(struct work_struct *work)
+{
+	struct idpf_q_vector *q_vector;
+	struct idpf_vport *vport;
+	struct dim *dim;
+	u16 itr;
+
+	dim = container_of(work, struct dim, work);
+	q_vector = container_of(dim, struct idpf_q_vector, tx_dim);
+	vport = q_vector->vport;
+
+	if (dim->profile_ix >= ARRAY_SIZE(vport->tx_itr_profile))
+		dim->profile_ix = ARRAY_SIZE(vport->tx_itr_profile) - 1;
+
+	/* look up the values in our local table */
+	itr = vport->tx_itr_profile[dim->profile_ix];
+
+	idpf_vport_intr_write_itr(q_vector, itr, true);
+
+	dim->state = DIM_START_MEASURE;
+}
+
+/**
+ * idpf_init_dim - Set up dynamic interrupt moderation
+ * @qv: q_vector structure
+ */
+static void idpf_init_dim(struct idpf_q_vector *qv)
+{
+	INIT_WORK(&qv->tx_dim.work, idpf_tx_dim_work);
+	qv->tx_dim.mode = DIM_CQ_PERIOD_MODE_START_FROM_EQE;
+	qv->tx_dim.profile_ix = IDPF_DIM_DEFAULT_PROFILE_IX;
+}
+
 /**
  * idpf_vport_intr_napi_ena_all - Enable NAPI for all q_vectors in the vport
  * @vport: main vport structure
@@ -2457,10 +3419,37 @@ static void idpf_vport_intr_napi_ena_all(struct idpf_vport *vport)
 	for (q_idx = 0; q_idx < vport->num_q_vectors; q_idx++) {
 		struct idpf_q_vector *q_vector = &vport->q_vectors[q_idx];
 
+		idpf_init_dim(q_vector);
 		napi_enable(&q_vector->napi);
 	}
 }
 
+/**
+ * idpf_tx_splitq_clean_all- Clean completion queues
+ * @q_vec: queue vector
+ * @budget: Used to determine if we are in netpoll
+ * @cleaned: returns number of packets cleaned
+ *
+ * Returns false if clean is not complete else returns true
+ */
+static bool idpf_tx_splitq_clean_all(struct idpf_q_vector *q_vec,
+				     int budget, int *cleaned)
+{
+	int num_txq = q_vec->num_txq;
+	bool clean_complete = true;
+	int i, budget_per_q;
+
+	if (unlikely(!num_txq))
+		return true;
+
+	budget_per_q = DIV_ROUND_UP(budget, num_txq);
+	for (i = 0; i < num_txq; i++)
+		clean_complete &= idpf_tx_clean_complq(q_vec->tx[i],
+						       budget_per_q, cleaned);
+
+	return clean_complete;
+}
+
 /**
  * idpf_vport_splitq_napi_poll - NAPI handler
  * @napi: struct from which you get q_vector
@@ -2468,8 +3457,40 @@ static void idpf_vport_intr_napi_ena_all(struct idpf_vport *vport)
  */
 static int idpf_vport_splitq_napi_poll(struct napi_struct *napi, int budget)
 {
-	/* stub */
-	return 0;
+	struct idpf_q_vector *q_vector =
+				container_of(napi, struct idpf_q_vector, napi);
+	bool clean_complete;
+	int work_done = 0;
+
+	/* Handle case where we are called by netpoll with a budget of 0 */
+	if (unlikely(!budget)) {
+		idpf_tx_splitq_clean_all(q_vector, budget, &work_done);
+
+		return 0;
+	}
+
+	clean_complete = idpf_tx_splitq_clean_all(q_vector, budget, &work_done);
+
+	/* If work not completed, return budget and polling will return */
+	if (!clean_complete)
+		return budget;
+
+	work_done = min_t(int, work_done, budget - 1);
+
+	/* Exit the polling mode, but don't re-enable interrupts if stack might
+	 * poll us due to busy-polling
+	 */
+	if (likely(napi_complete_done(napi, work_done)))
+		idpf_vport_intr_update_itr_ena_irq(q_vector);
+
+	/* Switch to poll mode in the tear-down path after sending disable queues
+	 * virtchnl message, as the interrupts will be disabled after that
+	 */
+	if (unlikely(q_vector->num_txq && test_bit(__IDPF_Q_POLL_MODE,
+						   q_vector->tx[0]->flags)))
+		return budget;
+	else
+		return work_done;
 }
 
 /**
@@ -2719,6 +3740,8 @@ int idpf_vport_intr_init(struct idpf_vport *vport)
 	if (err)
 		goto unroll_vectors_alloc;
 
+	idpf_vport_intr_ena_irq_all(vport);
+
 	return 0;
 
 unroll_vectors_alloc:
diff --git a/drivers/net/ethernet/intel/idpf/idpf_txrx.h b/drivers/net/ethernet/intel/idpf/idpf_txrx.h
index 17dcabbf0f6d..ecbaf1c85566 100644
--- a/drivers/net/ethernet/intel/idpf/idpf_txrx.h
+++ b/drivers/net/ethernet/intel/idpf/idpf_txrx.h
@@ -13,6 +13,9 @@
 #define IDPF_MIN_TXQ_COMPLQ_DESC		256
 #define IDPF_MAX_QIDS				256
 
+#define IDPF_MIN_TX_DESC_NEEDED (MAX_SKB_FRAGS + 6)
+#define IDPF_TX_WAKE_THRESH ((u16)IDPF_MIN_TX_DESC_NEEDED * 2)
+
 #define MIN_SUPPORT_TXDID (\
 	VIRTCHNL2_TXDID_FLEX_FLOW_SCHED |\
 	VIRTCHNL2_TXDID_FLEX_TSO_CTX)
@@ -77,6 +80,9 @@
 #define IDPF_SPLITQ_RX_BUF_DESC(rxq, i)	\
 	(&(((struct virtchnl2_splitq_rx_buf_desc *)((rxq)->desc_ring))[i]))
 
+#define IDPF_SPLITQ_TX_COMPLQ_DESC(txcq, i)	\
+	(&(((struct idpf_splitq_tx_compl_desc *)((txcq)->desc_ring))[i]))
+
 #define IDPF_FLEX_TX_DESC(txq, i) \
 	(&(((union idpf_tx_flex_desc *)((txq)->desc_ring))[i]))
 #define IDPF_FLEX_TX_CTX_DESC(txq, i)	\
@@ -100,6 +106,7 @@
 	(txq)->num_completions_pending - (txq)->complq->num_completions)
 
 #define IDPF_TX_SPLITQ_COMPL_TAG_WIDTH	16
+#define IDPF_TX_SPLITQ_MISS_COMPL_TAG	BIT(15)
 /* Adjust the generation for the completion tag and wrap if necessary */
 #define IDPF_TX_ADJ_COMPL_TAG_GEN(txq) \
 	((++(txq)->compl_tag_cur_gen) >= (txq)->compl_tag_gen_max ? \
@@ -144,7 +151,16 @@ struct idpf_tx_buf {
 };
 
 struct idpf_tx_stash {
-	/* stub */
+	struct hlist_node hlist;
+	struct timer_list reinject_timer;
+	struct idpf_tx_buf buf;
+	struct idpf_queue *txq;
+	/* Keep track of whether this packet was sent on the exception path
+	 * either because the driver received a miss completion and is waiting
+	 * on a reinject completion or because the driver received a reinject
+	 * completion and is waiting on a follow up completion.
+	 */
+	bool miss_pkt;
 };
 
 struct idpf_buf_lifo {
@@ -177,6 +193,7 @@ struct idpf_tx_splitq_params {
 	struct idpf_tx_offload_params offload;
 };
 
+#define IDPF_TX_COMPLQ_CLEAN_BUDGET	256
 #define IDPF_TX_MIN_PKT_LEN		17
 #define IDPF_TX_DESCS_FOR_SKB_DATA_PTR	1
 #define IDPF_TX_DESCS_PER_CACHE_LINE	(L1_CACHE_BYTES / \
@@ -338,6 +355,8 @@ enum idpf_queue_flags_t {
 	 */
 	__IDPF_RFLQ_GEN_CHK,
 	__IDPF_Q_FLOW_SCH_EN,
+	__IDPF_Q_SW_MARKER,
+	__IDPF_Q_POLL_MODE,
 	__IDPF_Q_MISS_TAG_EN,
 
 	__IDPF_Q_FLAGS_NBITS,
@@ -371,6 +390,7 @@ struct idpf_q_vector {
 
 	int num_txq;
 	struct idpf_queue **tx;
+	struct dim tx_dim;	/* data for net_dim algorithm */
 	u16 tx_itr_value;
 	bool tx_intr_mode;
 	u32 tx_itr_idx;
@@ -384,6 +404,7 @@ struct idpf_q_vector {
 	int num_bufq;
 	struct idpf_queue **bufq;
 
+	u16 total_events;       /* net_dim(): number of interrupts processed */
 	char name[IDPF_INT_NAME_STR_LEN];
 };
 
@@ -392,6 +413,8 @@ struct idpf_rx_queue_stats {
 };
 
 struct idpf_tx_queue_stats {
+	u64_stats_t packets;
+	u64_stats_t bytes;
 	u64_stats_t lso_pkts;
 	u64_stats_t linearize;
 	u64_stats_t q_busy;
@@ -399,6 +422,11 @@ struct idpf_tx_queue_stats {
 	u64_stats_t dma_map_errs;
 };
 
+struct idpf_cleaned_stats {
+	u32 packets;
+	u32 bytes;
+};
+
 union idpf_queue_stats {
 	struct idpf_rx_queue_stats rx;
 	struct idpf_tx_queue_stats tx;
@@ -406,9 +434,16 @@ union idpf_queue_stats {
 
 #define IDPF_ITR_DYNAMIC	1
 #define IDPF_ITR_20K		0x0032
+#define IDPF_ITR_GRAN_S		1	/* Assume ITR granularity is 2us */
+#define IDPF_ITR_MASK		0x1FFE  /* ITR register value alignment mask */
+#define ITR_REG_ALIGN(setting)	((setting) & IDPF_ITR_MASK)
+#define IDPF_ITR_IS_DYNAMIC(itr_mode) (itr_mode)
 #define IDPF_ITR_TX_DEF		IDPF_ITR_20K
 #define IDPF_ITR_RX_DEF		IDPF_ITR_20K
+/* Index used for 'No ITR' update in DYN_CTL register */
+#define IDPF_NO_ITR_UPDATE_IDX	3
 #define IDPF_ITR_IDX_SPACING(spacing, dflt)	(spacing ? spacing : dflt)
+#define IDPF_DIM_DEFAULT_PROFILE_IX		1
 
 /* queue associated with a vport */
 struct idpf_queue {
@@ -459,6 +494,18 @@ struct idpf_queue {
 	union idpf_queue_stats q_stats;
 	struct u64_stats_sync stats_sync;
 
+	/* Splitq only, TXQ only: When a TX completion is received on the TX
+	 * completion queue, it can be for any TXQ associated with that
+	 * completion queue. This means we can clean up to N TXQs during a
+	 * single call to clean the completion queue. cleaned_bytes|pkts tracks
+	 * the clean stats per TXQ during that single call to clean the
+	 * completion queue. By doing so, we can update BQL with aggregate
+	 * cleaned stats for each TXQ only once at the end of the cleaning
+	 * routine.
+	 */
+	u32 cleaned_bytes;
+	u16 cleaned_pkts;
+
 	bool rx_hsplit_en;
 	u16 rx_hbuf_size;	/* Header buffer size */
 	u16 rx_buf_size;
diff --git a/drivers/net/ethernet/intel/idpf/idpf_virtchnl.c b/drivers/net/ethernet/intel/idpf/idpf_virtchnl.c
index 8b2538fbb336..153bbe660667 100644
--- a/drivers/net/ethernet/intel/idpf/idpf_virtchnl.c
+++ b/drivers/net/ethernet/intel/idpf/idpf_virtchnl.c
@@ -695,6 +695,36 @@ static int idpf_wait_for_event(struct idpf_adapter *adapter,
 				     IDPF_WAIT_FOR_EVENT_TIMEO);
 }
 
+/**
+ * idpf_wait_for_marker_event - wait for software marker response
+ * @vport: virtual port data structure
+ *
+ * Returns 0 success, negative on failure.
+ **/
+static int idpf_wait_for_marker_event(struct idpf_vport *vport)
+{
+	int event = 0;
+	int i;
+
+	for (i = 0; i < vport->num_txq; i++)
+		set_bit(__IDPF_Q_SW_MARKER, vport->txqs[i]->flags);
+
+	event = wait_event_timeout(vport->sw_marker_wq,
+				   test_and_clear_bit(IDPF_VPORT_SW_MARKER,
+						      vport->flags),
+				   msecs_to_jiffies(500));
+
+	for (i = 0; i < vport->num_txq; i++)
+		clear_bit(__IDPF_Q_POLL_MODE, vport->txqs[i]->flags);
+
+	if (event)
+		return 0;
+
+	dev_warn(&vport->adapter->pdev->dev, "Failed to receive marker packets\n");
+
+	return -ETIMEDOUT;
+}
+
 /**
  * idpf_send_ver_msg - send virtchnl version message
  * @adapter: Driver specific private structure
@@ -1978,7 +2008,23 @@ int idpf_send_enable_queues_msg(struct idpf_vport *vport)
  */
 int idpf_send_disable_queues_msg(struct idpf_vport *vport)
 {
-	return idpf_send_ena_dis_queues_msg(vport, VIRTCHNL2_OP_DISABLE_QUEUES);
+	int err, i;
+
+	err = idpf_send_ena_dis_queues_msg(vport, VIRTCHNL2_OP_DISABLE_QUEUES);
+	if (err)
+		return err;
+
+	/* switch to poll mode as interrupts will be disabled after disable
+	 * queues virtchnl message is sent
+	 */
+	for (i = 0; i < vport->num_txq; i++)
+		set_bit(__IDPF_Q_POLL_MODE, vport->txqs[i]->flags);
+
+	/* schedule the napi to receive all the marker packets */
+	for (i = 0; i < vport->num_q_vectors; i++)
+		napi_schedule(&vport->q_vectors[i].napi);
+
+	return idpf_wait_for_marker_event(vport);
 }
 
 /**
@@ -2858,6 +2904,7 @@ void idpf_vport_init(struct idpf_vport *vport, struct idpf_vport_max_q *max_q)
 	struct idpf_adapter *adapter = vport->adapter;
 	struct virtchnl2_create_vport *vport_msg;
 	struct idpf_vport_config *vport_config;
+	u16 tx_itr[] = {2, 8, 64, 128, 256};
 	struct idpf_rss_data *rss_data;
 	u16 idx = vport->idx;
 
@@ -2883,6 +2930,9 @@ void idpf_vport_init(struct idpf_vport *vport, struct idpf_vport_max_q *max_q)
 	ether_addr_copy(vport->default_mac_addr, vport_msg->default_mac_addr);
 	vport->max_mtu = le16_to_cpu(vport_msg->max_mtu) - IDPF_PACKET_HDR_PAD;
 
+	/* Initialize Tx profiles for Dynamic Interrupt Moderation */
+	memcpy(vport->tx_itr_profile, tx_itr, IDPF_DIM_PROFILE_SLOTS);
+
 	idpf_vport_init_num_qs(vport, vport_msg);
 	idpf_vport_calc_num_q_desc(vport);
 	idpf_vport_calc_num_q_groups(vport);
-- 
2.17.2


