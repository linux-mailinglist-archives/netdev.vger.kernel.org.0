Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A20A758DA9
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 00:08:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726774AbfF0WIr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 18:08:47 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:53032 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726587AbfF0WIm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 18:08:42 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.27/8.16.0.27) with SMTP id x5RM7tVa014945
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 15:08:41 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 2tcc49wgnh-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 15:08:40 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 27 Jun 2019 15:08:38 -0700
Received: by devvm34215.prn1.facebook.com (Postfix, from userid 172786)
        id 92FCE240E9956; Thu, 27 Jun 2019 15:08:36 -0700 (PDT)
Smtp-Origin-Hostprefix: devvm
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
Smtp-Origin-Hostname: devvm34215.prn1.facebook.com
To:     <netdev@vger.kernel.org>, <bjorn.topel@intel.com>,
        <magnus.karlsson@intel.com>, <saeedm@mellanox.com>,
        <maximmi@mellanox.com>, <brouer@redhat.com>
CC:     <kernel-team@fb.com>
Smtp-Origin-Cluster: prn1c35
Subject: [PATCH 2/6 bpf-next] Clean up xsk reuseq API
Date:   Thu, 27 Jun 2019 15:08:32 -0700
Message-ID: <20190627220836.2572684-3-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190627220836.2572684-1-jonathan.lemon@gmail.com>
References: <20190627220836.2572684-1-jonathan.lemon@gmail.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-27_14:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1034 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906270254
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The reuseq is actually a recycle stack, only accessed from the kernel side.
Also, the implementation details of the stack should belong to the umem
object, and not exposed to the caller.

Clean up and rename for consistency in preparation for the next patch.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 drivers/net/ethernet/intel/i40e/i40e_xsk.c    |  8 +--
 drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c  |  8 +--
 .../ethernet/mellanox/mlx5/core/en/xsk/rx.c   |  2 +-
 .../ethernet/mellanox/mlx5/core/en/xsk/umem.c |  7 +--
 include/net/xdp_sock.h                        | 23 ++------
 net/xdp/xdp_umem.c                            |  2 +-
 net/xdp/xsk_queue.c                           | 56 +++++++------------
 net/xdp/xsk_queue.h                           |  2 +-
 8 files changed, 33 insertions(+), 75 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
index 3b84fca1c11d..7efe5905b0af 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
@@ -78,7 +78,6 @@ static int i40e_xsk_umem_enable(struct i40e_vsi *vsi, struct xdp_umem *umem,
 				u16 qid)
 {
 	struct net_device *netdev = vsi->netdev;
-	struct xdp_umem_fq_reuse *reuseq;
 	bool if_running;
 	int err;
 
@@ -92,12 +91,9 @@ static int i40e_xsk_umem_enable(struct i40e_vsi *vsi, struct xdp_umem *umem,
 	    qid >= netdev->real_num_tx_queues)
 		return -EINVAL;
 
-	reuseq = xsk_reuseq_prepare(vsi->rx_rings[0]->count);
-	if (!reuseq)
+	if (!xsk_umem_recycle_alloc(umem, vsi->rx_rings[0]->count))
 		return -ENOMEM;
 
-	xsk_reuseq_free(xsk_reuseq_swap(umem, reuseq));
-
 	err = i40e_xsk_umem_dma_map(vsi, umem);
 	if (err)
 		return err;
@@ -811,7 +807,7 @@ void i40e_xsk_clean_rx_ring(struct i40e_ring *rx_ring)
 		if (!rx_bi->addr)
 			continue;
 
-		xsk_umem_fq_reuse(rx_ring->xsk_umem, rx_bi->handle);
+		xsk_umem_recycle_addr(rx_ring->xsk_umem, rx_bi->handle);
 		rx_bi->addr = NULL;
 	}
 }
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
index a9cab3271ac9..1e09fa7ffb90 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
@@ -67,7 +67,6 @@ static int ixgbe_xsk_umem_enable(struct ixgbe_adapter *adapter,
 				 u16 qid)
 {
 	struct net_device *netdev = adapter->netdev;
-	struct xdp_umem_fq_reuse *reuseq;
 	bool if_running;
 	int err;
 
@@ -78,12 +77,9 @@ static int ixgbe_xsk_umem_enable(struct ixgbe_adapter *adapter,
 	    qid >= netdev->real_num_tx_queues)
 		return -EINVAL;
 
-	reuseq = xsk_reuseq_prepare(adapter->rx_ring[0]->count);
-	if (!reuseq)
+	if (!xsk_umem_recycle_alloc(umem, adapter->rx_ring[0]->count))
 		return -ENOMEM;
 
-	xsk_reuseq_free(xsk_reuseq_swap(umem, reuseq));
-
 	err = ixgbe_xsk_umem_dma_map(adapter, umem);
 	if (err)
 		return err;
@@ -554,7 +550,7 @@ void ixgbe_xsk_clean_rx_ring(struct ixgbe_ring *rx_ring)
 	struct ixgbe_rx_buffer *bi = &rx_ring->rx_buffer_info[i];
 
 	while (i != rx_ring->next_to_alloc) {
-		xsk_umem_fq_reuse(rx_ring->xsk_umem, bi->handle);
+		xsk_umem_recycle_addr(rx_ring->xsk_umem, bi->handle);
 		i++;
 		bi++;
 		if (i == rx_ring->count) {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
index 85440b1c1c3f..8d24eaa660a8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
@@ -44,7 +44,7 @@ int mlx5e_xsk_page_alloc_umem(struct mlx5e_rq *rq,
 
 static inline void mlx5e_xsk_recycle_frame(struct mlx5e_rq *rq, u64 handle)
 {
-	xsk_umem_fq_reuse(rq->umem, handle);
+	xsk_umem_recycle_addr(rq->umem, handle);
 }
 
 /* XSKRQ uses pages from UMEM, they must not be released. They are returned to
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/umem.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/umem.c
index 4baaa5788320..6f75ac653697 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/umem.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/umem.c
@@ -243,13 +243,8 @@ int mlx5e_xsk_setup_umem(struct net_device *dev, struct xdp_umem *umem, u16 qid)
 
 int mlx5e_xsk_resize_reuseq(struct xdp_umem *umem, u32 nentries)
 {
-	struct xdp_umem_fq_reuse *reuseq;
-
-	reuseq = xsk_reuseq_prepare(nentries);
-	if (unlikely(!reuseq))
+	if (!xsk_umem_recycle_alloc(umem, nentries))
 		return -ENOMEM;
-	xsk_reuseq_free(xsk_reuseq_swap(umem, reuseq));
-
 	return 0;
 }
 
diff --git a/include/net/xdp_sock.h b/include/net/xdp_sock.h
index 39516d960636..7df7b417ac53 100644
--- a/include/net/xdp_sock.h
+++ b/include/net/xdp_sock.h
@@ -83,10 +83,7 @@ void xsk_umem_discard_addr(struct xdp_umem *umem);
 void xsk_umem_complete_tx(struct xdp_umem *umem, u32 nb_entries);
 bool xsk_umem_consume_tx(struct xdp_umem *umem, struct xdp_desc *desc);
 void xsk_umem_consume_tx_done(struct xdp_umem *umem);
-struct xdp_umem_fq_reuse *xsk_reuseq_prepare(u32 nentries);
-struct xdp_umem_fq_reuse *xsk_reuseq_swap(struct xdp_umem *umem,
-					  struct xdp_umem_fq_reuse *newq);
-void xsk_reuseq_free(struct xdp_umem_fq_reuse *rq);
+bool xsk_umem_recycle_alloc(struct xdp_umem *umem, u32 nentries);
 struct xdp_umem *xdp_get_umem_from_qid(struct net_device *dev, u16 queue_id);
 
 static inline char *xdp_umem_get_data(struct xdp_umem *umem, u64 addr)
@@ -131,7 +128,7 @@ static inline void xsk_umem_discard_addr_rq(struct xdp_umem *umem)
 		rq->length--;
 }
 
-static inline void xsk_umem_fq_reuse(struct xdp_umem *umem, u64 addr)
+static inline void xsk_umem_recycle_addr(struct xdp_umem *umem, u64 addr)
 {
 	struct xdp_umem_fq_reuse *rq = umem->fq_reuse;
 
@@ -185,19 +182,9 @@ static inline void xsk_umem_consume_tx_done(struct xdp_umem *umem)
 {
 }
 
-static inline struct xdp_umem_fq_reuse *xsk_reuseq_prepare(u32 nentries)
-{
-	return NULL;
-}
-
-static inline struct xdp_umem_fq_reuse *xsk_reuseq_swap(
-	struct xdp_umem *umem,
-	struct xdp_umem_fq_reuse *newq)
-{
-	return NULL;
-}
-static inline void xsk_reuseq_free(struct xdp_umem_fq_reuse *rq)
+static inline bool xsk_umem_recycle_alloc(struct xdp_umem *umem, u32 nentries)
 {
+	return false;
 }
 
 static inline struct xdp_umem *xdp_get_umem_from_qid(struct net_device *dev,
@@ -230,7 +217,7 @@ static inline void xsk_umem_discard_addr_rq(struct xdp_umem *umem)
 {
 }
 
-static inline void xsk_umem_fq_reuse(struct xdp_umem *umem, u64 addr)
+static inline void xsk_umem_recycle_addr(struct xdp_umem *umem, u64 addr)
 {
 }
 
diff --git a/net/xdp/xdp_umem.c b/net/xdp/xdp_umem.c
index 9c6de4f114f8..2150ba3fc744 100644
--- a/net/xdp/xdp_umem.c
+++ b/net/xdp/xdp_umem.c
@@ -208,7 +208,7 @@ static void xdp_umem_release(struct xdp_umem *umem)
 		umem->cq = NULL;
 	}
 
-	xsk_reuseq_destroy(umem);
+	xsk_umem_recycle_destroy(umem);
 
 	xdp_umem_unpin_pages(umem);
 
diff --git a/net/xdp/xsk_queue.c b/net/xdp/xsk_queue.c
index b66504592d9b..116b28622297 100644
--- a/net/xdp/xsk_queue.c
+++ b/net/xdp/xsk_queue.c
@@ -65,55 +65,39 @@ void xskq_destroy(struct xsk_queue *q)
 	kfree(q);
 }
 
-struct xdp_umem_fq_reuse *xsk_reuseq_prepare(u32 nentries)
+bool xsk_umem_recycle_alloc(struct xdp_umem *umem, u32 nentries)
 {
-	struct xdp_umem_fq_reuse *newq;
+	struct xdp_umem_fq_reuse *newq, *oldq;
 
 	/* Check for overflow */
 	if (nentries > (u32)roundup_pow_of_two(nentries))
-		return NULL;
+		return false;
 	nentries = roundup_pow_of_two(nentries);
+	oldq = umem->fq_reuse;
+	if (oldq && (oldq->length >= nentries ||
+		     oldq->nentries == nentries))
+		return true;
 
 	newq = kvmalloc(struct_size(newq, handles, nentries), GFP_KERNEL);
 	if (!newq)
-		return NULL;
-	memset(newq, 0, offsetof(typeof(*newq), handles));
-
-	newq->nentries = nentries;
-	return newq;
-}
-EXPORT_SYMBOL_GPL(xsk_reuseq_prepare);
-
-struct xdp_umem_fq_reuse *xsk_reuseq_swap(struct xdp_umem *umem,
-					  struct xdp_umem_fq_reuse *newq)
-{
-	struct xdp_umem_fq_reuse *oldq = umem->fq_reuse;
-
-	if (!oldq) {
-		umem->fq_reuse = newq;
-		return NULL;
+		return false;
+	if (oldq) {
+		memcpy(newq->handles, oldq->handles,
+		       array_size(oldq->length, sizeof(u64)));
+		newq->length = oldq->length;
+		kvfree(oldq);
+	} else {
+		newq->length = 0;
 	}
-
-	if (newq->nentries < oldq->length)
-		return newq;
-
-	memcpy(newq->handles, oldq->handles,
-	       array_size(oldq->length, sizeof(u64)));
-	newq->length = oldq->length;
-
+	newq->nentries = nentries;
 	umem->fq_reuse = newq;
-	return oldq;
-}
-EXPORT_SYMBOL_GPL(xsk_reuseq_swap);
 
-void xsk_reuseq_free(struct xdp_umem_fq_reuse *rq)
-{
-	kvfree(rq);
+	return true;
 }
-EXPORT_SYMBOL_GPL(xsk_reuseq_free);
+EXPORT_SYMBOL_GPL(xsk_umem_recycle_alloc);
 
-void xsk_reuseq_destroy(struct xdp_umem *umem)
+void xsk_umem_recycle_destroy(struct xdp_umem *umem)
 {
-	xsk_reuseq_free(umem->fq_reuse);
+	kvfree(umem->fq_reuse);
 	umem->fq_reuse = NULL;
 }
diff --git a/net/xdp/xsk_queue.h b/net/xdp/xsk_queue.h
index 12b49784a6d5..c9db4e8ae80e 100644
--- a/net/xdp/xsk_queue.h
+++ b/net/xdp/xsk_queue.h
@@ -321,6 +321,6 @@ struct xsk_queue *xskq_create(u32 nentries, bool umem_queue);
 void xskq_destroy(struct xsk_queue *q_ops);
 
 /* Executed by the core when the entire UMEM gets freed */
-void xsk_reuseq_destroy(struct xdp_umem *umem);
+void xsk_umem_recycle_destroy(struct xdp_umem *umem);
 
 #endif /* _LINUX_XSK_QUEUE_H */
-- 
2.17.1

