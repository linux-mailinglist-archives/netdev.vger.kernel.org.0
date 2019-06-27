Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FBD358DA8
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 00:08:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726748AbfF0WIn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 18:08:43 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:36760 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726702AbfF0WIm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 18:08:42 -0400
Received: from pps.filterd (m0044008.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5RM4GbW001472
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 15:08:41 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2td4pdgcc0-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 15:08:41 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 27 Jun 2019 15:08:40 -0700
Received: by devvm34215.prn1.facebook.com (Postfix, from userid 172786)
        id 9BC76240E995A; Thu, 27 Jun 2019 15:08:36 -0700 (PDT)
Smtp-Origin-Hostprefix: devvm
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
Smtp-Origin-Hostname: devvm34215.prn1.facebook.com
To:     <netdev@vger.kernel.org>, <bjorn.topel@intel.com>,
        <magnus.karlsson@intel.com>, <saeedm@mellanox.com>,
        <maximmi@mellanox.com>, <brouer@redhat.com>
CC:     <kernel-team@fb.com>
Smtp-Origin-Cluster: prn1c35
Subject: [PATCH 4/6 bfp-next] Simplify AF_XDP umem allocation path for Intel drivers.
Date:   Thu, 27 Jun 2019 15:08:34 -0700
Message-ID: <20190627220836.2572684-5-jonathan.lemon@gmail.com>
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

Now that the recycle stack is always used for the driver umem path, the
driver code path can be simplified.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 drivers/net/ethernet/intel/i40e/i40e_xsk.c    | 76 ++-----------------
 .../ethernet/intel/ixgbe/ixgbe_txrx_common.h  |  2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c  | 49 +-----------
 3 files changed, 13 insertions(+), 114 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
index 7efe5905b0af..ce8650d06962 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
@@ -265,44 +265,16 @@ static bool i40e_alloc_buffer_zc(struct i40e_ring *rx_ring,
 }
 
 /**
- * i40e_alloc_buffer_slow_zc - Allocates an i40e_rx_buffer
+ * i40e_alloc_rx_buffers_zc - Allocates a number of Rx buffers
  * @rx_ring: Rx ring
- * @bi: Rx buffer to populate
+ * @count: The number of buffers to allocate
  *
- * This function allocates an Rx buffer. The buffer can come from fill
- * queue, or via the reuse queue.
+ * This function allocates a number of Rx buffers from the fill ring
+ * or the internal recycle mechanism and places them on the Rx ring.
  *
  * Returns true for a successful allocation, false otherwise
  **/
-static bool i40e_alloc_buffer_slow_zc(struct i40e_ring *rx_ring,
-				      struct i40e_rx_buffer *bi)
-{
-	struct xdp_umem *umem = rx_ring->xsk_umem;
-	u64 handle, hr;
-
-	if (!xsk_umem_peek_addr_rq(umem, &handle)) {
-		rx_ring->rx_stats.alloc_page_failed++;
-		return false;
-	}
-
-	hr = umem->headroom + XDP_PACKET_HEADROOM;
-
-	bi->dma = xdp_umem_get_dma(umem, handle);
-	bi->dma += hr;
-
-	bi->addr = xdp_umem_get_data(umem, handle);
-	bi->addr += hr;
-
-	bi->handle = handle + umem->headroom;
-
-	xsk_umem_discard_addr_rq(umem);
-	return true;
-}
-
-static __always_inline bool
-__i40e_alloc_rx_buffers_zc(struct i40e_ring *rx_ring, u16 count,
-			   bool alloc(struct i40e_ring *rx_ring,
-				      struct i40e_rx_buffer *bi))
+bool i40e_alloc_rx_buffers_zc(struct i40e_ring *rx_ring, u16 count)
 {
 	u16 ntu = rx_ring->next_to_use;
 	union i40e_rx_desc *rx_desc;
@@ -312,7 +284,7 @@ __i40e_alloc_rx_buffers_zc(struct i40e_ring *rx_ring, u16 count,
 	rx_desc = I40E_RX_DESC(rx_ring, ntu);
 	bi = &rx_ring->rx_bi[ntu];
 	do {
-		if (!alloc(rx_ring, bi)) {
+		if (!i40e_alloc_buffer_zc(rx_ring, bi)) {
 			ok = false;
 			goto no_buffers;
 		}
@@ -344,38 +316,6 @@ __i40e_alloc_rx_buffers_zc(struct i40e_ring *rx_ring, u16 count,
 	return ok;
 }
 
-/**
- * i40e_alloc_rx_buffers_zc - Allocates a number of Rx buffers
- * @rx_ring: Rx ring
- * @count: The number of buffers to allocate
- *
- * This function allocates a number of Rx buffers from the reuse queue
- * or fill ring and places them on the Rx ring.
- *
- * Returns true for a successful allocation, false otherwise
- **/
-bool i40e_alloc_rx_buffers_zc(struct i40e_ring *rx_ring, u16 count)
-{
-	return __i40e_alloc_rx_buffers_zc(rx_ring, count,
-					  i40e_alloc_buffer_slow_zc);
-}
-
-/**
- * i40e_alloc_rx_buffers_fast_zc - Allocates a number of Rx buffers
- * @rx_ring: Rx ring
- * @count: The number of buffers to allocate
- *
- * This function allocates a number of Rx buffers from the fill ring
- * or the internal recycle mechanism and places them on the Rx ring.
- *
- * Returns true for a successful allocation, false otherwise
- **/
-static bool i40e_alloc_rx_buffers_fast_zc(struct i40e_ring *rx_ring, u16 count)
-{
-	return __i40e_alloc_rx_buffers_zc(rx_ring, count,
-					  i40e_alloc_buffer_zc);
-}
-
 /**
  * i40e_get_rx_buffer_zc - Return the current Rx buffer
  * @rx_ring: Rx ring
@@ -541,8 +481,8 @@ int i40e_clean_rx_irq_zc(struct i40e_ring *rx_ring, int budget)
 
 		if (cleaned_count >= I40E_RX_BUFFER_WRITE) {
 			failure = failure ||
-				  !i40e_alloc_rx_buffers_fast_zc(rx_ring,
-								 cleaned_count);
+				  !i40e_alloc_rx_buffers_zc(rx_ring,
+							    cleaned_count);
 			cleaned_count = 0;
 		}
 
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_txrx_common.h b/drivers/net/ethernet/intel/ixgbe/ixgbe_txrx_common.h
index d93a690aff74..7408fbc2e1e1 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_txrx_common.h
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_txrx_common.h
@@ -35,7 +35,7 @@ int ixgbe_xsk_umem_setup(struct ixgbe_adapter *adapter, struct xdp_umem *umem,
 
 void ixgbe_zca_free(struct zero_copy_allocator *alloc, unsigned long handle);
 
-void ixgbe_alloc_rx_buffers_zc(struct ixgbe_ring *rx_ring, u16 cleaned_count);
+bool ixgbe_alloc_rx_buffers_zc(struct ixgbe_ring *rx_ring, u16 cleaned_count);
 int ixgbe_clean_rx_irq_zc(struct ixgbe_q_vector *q_vector,
 			  struct ixgbe_ring *rx_ring,
 			  const int budget);
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
index 1e09fa7ffb90..65feb16200ea 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
@@ -278,35 +278,7 @@ static bool ixgbe_alloc_buffer_zc(struct ixgbe_ring *rx_ring,
 	return true;
 }
 
-static bool ixgbe_alloc_buffer_slow_zc(struct ixgbe_ring *rx_ring,
-				       struct ixgbe_rx_buffer *bi)
-{
-	struct xdp_umem *umem = rx_ring->xsk_umem;
-	u64 handle, hr;
-
-	if (!xsk_umem_peek_addr_rq(umem, &handle)) {
-		rx_ring->rx_stats.alloc_rx_page_failed++;
-		return false;
-	}
-
-	hr = umem->headroom + XDP_PACKET_HEADROOM;
-
-	bi->dma = xdp_umem_get_dma(umem, handle);
-	bi->dma += hr;
-
-	bi->addr = xdp_umem_get_data(umem, handle);
-	bi->addr += hr;
-
-	bi->handle = handle + umem->headroom;
-
-	xsk_umem_discard_addr_rq(umem);
-	return true;
-}
-
-static __always_inline bool
-__ixgbe_alloc_rx_buffers_zc(struct ixgbe_ring *rx_ring, u16 cleaned_count,
-			    bool alloc(struct ixgbe_ring *rx_ring,
-				       struct ixgbe_rx_buffer *bi))
+bool ixgbe_alloc_rx_buffers_zc(struct ixgbe_ring *rx_ring, u16 cleaned_count)
 {
 	union ixgbe_adv_rx_desc *rx_desc;
 	struct ixgbe_rx_buffer *bi;
@@ -322,7 +294,7 @@ __ixgbe_alloc_rx_buffers_zc(struct ixgbe_ring *rx_ring, u16 cleaned_count,
 	i -= rx_ring->count;
 
 	do {
-		if (!alloc(rx_ring, bi)) {
+		if (!ixgbe_alloc_buffer_zc(rx_ring, bi)) {
 			ok = false;
 			break;
 		}
@@ -373,19 +345,6 @@ __ixgbe_alloc_rx_buffers_zc(struct ixgbe_ring *rx_ring, u16 cleaned_count,
 	return ok;
 }
 
-void ixgbe_alloc_rx_buffers_zc(struct ixgbe_ring *rx_ring, u16 count)
-{
-	__ixgbe_alloc_rx_buffers_zc(rx_ring, count,
-				    ixgbe_alloc_buffer_slow_zc);
-}
-
-static bool ixgbe_alloc_rx_buffers_fast_zc(struct ixgbe_ring *rx_ring,
-					   u16 count)
-{
-	return __ixgbe_alloc_rx_buffers_zc(rx_ring, count,
-					   ixgbe_alloc_buffer_zc);
-}
-
 static struct sk_buff *ixgbe_construct_skb_zc(struct ixgbe_ring *rx_ring,
 					      struct ixgbe_rx_buffer *bi,
 					      struct xdp_buff *xdp)
@@ -441,8 +400,8 @@ int ixgbe_clean_rx_irq_zc(struct ixgbe_q_vector *q_vector,
 		/* return some buffers to hardware, one at a time is too slow */
 		if (cleaned_count >= IXGBE_RX_BUFFER_WRITE) {
 			failure = failure ||
-				  !ixgbe_alloc_rx_buffers_fast_zc(rx_ring,
-								 cleaned_count);
+				  !ixgbe_alloc_rx_buffers_zc(rx_ring,
+							     cleaned_count);
 			cleaned_count = 0;
 		}
 
-- 
2.17.1

