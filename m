Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1D5544E34C
	for <lists+netdev@lfdr.de>; Fri, 12 Nov 2021 09:34:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234415AbhKLIhZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Nov 2021 03:37:25 -0500
Received: from szxga01-in.huawei.com ([45.249.212.187]:30934 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232841AbhKLIhX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Nov 2021 03:37:23 -0500
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4HrBb75jZFzcbKm;
        Fri, 12 Nov 2021 16:29:39 +0800 (CST)
Received: from dggpeml500017.china.huawei.com (7.185.36.243) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Fri, 12 Nov 2021 16:34:28 +0800
Received: from huawei.com (10.175.103.91) by dggpeml500017.china.huawei.com
 (7.185.36.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.15; Fri, 12 Nov
 2021 16:34:27 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <stable@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <rds-devel@oss.oracle.com>,
        <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <sashal@kernel.org>,
        <kuba@kernel.org>, <davem@davemloft.net>,
        <santosh.shilimkar@oracle.com>
Subject: [PATCH 5.10 1/1] rds: stop using dmapool
Date:   Fri, 12 Nov 2021 16:41:23 +0800
Message-ID: <20211112084123.1091671-2-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211112084123.1091671-1-yangyingliang@huawei.com>
References: <20211112084123.1091671-1-yangyingliang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500017.china.huawei.com (7.185.36.243)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

commit 42f2611cc1738b201701e717246e11e86bef4e1e upstream.

RDMA ULPs should only perform DMA through the ib_dma_* API instead of
using the hidden dma_device directly.  In addition using the dma coherent
API family that dmapool is a part of can be very ineffcient on plaforms
that are not DMA coherent.  Switch to use slab allocations and the
ib_dma_* APIs instead.

Link: https://lore.kernel.org/r/20201106181941.1878556-6-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 net/rds/ib.c      |  10 ----
 net/rds/ib.h      |   6 ---
 net/rds/ib_cm.c   | 128 ++++++++++++++++++++++++++++------------------
 net/rds/ib_recv.c |  18 +++++--
 net/rds/ib_send.c |   8 +++
 5 files changed, 101 insertions(+), 69 deletions(-)

diff --git a/net/rds/ib.c b/net/rds/ib.c
index deecbdcdae84e..24c9a9005a6fb 100644
--- a/net/rds/ib.c
+++ b/net/rds/ib.c
@@ -30,7 +30,6 @@
  * SOFTWARE.
  *
  */
-#include <linux/dmapool.h>
 #include <linux/kernel.h>
 #include <linux/in.h>
 #include <linux/if.h>
@@ -108,7 +107,6 @@ static void rds_ib_dev_free(struct work_struct *work)
 		rds_ib_destroy_mr_pool(rds_ibdev->mr_1m_pool);
 	if (rds_ibdev->pd)
 		ib_dealloc_pd(rds_ibdev->pd);
-	dma_pool_destroy(rds_ibdev->rid_hdrs_pool);
 
 	list_for_each_entry_safe(i_ipaddr, i_next, &rds_ibdev->ipaddr_list, list) {
 		list_del(&i_ipaddr->list);
@@ -191,14 +189,6 @@ static int rds_ib_add_one(struct ib_device *device)
 		rds_ibdev->pd = NULL;
 		goto put_dev;
 	}
-	rds_ibdev->rid_hdrs_pool = dma_pool_create(device->name,
-						   device->dma_device,
-						   sizeof(struct rds_header),
-						   L1_CACHE_BYTES, 0);
-	if (!rds_ibdev->rid_hdrs_pool) {
-		ret = -ENOMEM;
-		goto put_dev;
-	}
 
 	rds_ibdev->mr_1m_pool =
 		rds_ib_create_mr_pool(rds_ibdev, RDS_IB_MR_1M_POOL);
diff --git a/net/rds/ib.h b/net/rds/ib.h
index c23a11d9ad362..2ba71102b1f1f 100644
--- a/net/rds/ib.h
+++ b/net/rds/ib.h
@@ -246,7 +246,6 @@ struct rds_ib_device {
 	struct list_head	conn_list;
 	struct ib_device	*dev;
 	struct ib_pd		*pd;
-	struct dma_pool		*rid_hdrs_pool; /* RDS headers DMA pool */
 	u8			odp_capable:1;
 
 	unsigned int		max_mrs;
@@ -380,11 +379,6 @@ int rds_ib_cm_handle_connect(struct rdma_cm_id *cm_id,
 int rds_ib_cm_initiate_connect(struct rdma_cm_id *cm_id, bool isv6);
 void rds_ib_cm_connect_complete(struct rds_connection *conn,
 				struct rdma_cm_event *event);
-struct rds_header **rds_dma_hdrs_alloc(struct ib_device *ibdev,
-				       struct dma_pool *pool,
-				       dma_addr_t **dma_addrs, u32 num_hdrs);
-void rds_dma_hdrs_free(struct dma_pool *pool, struct rds_header **hdrs,
-		       dma_addr_t *dma_addrs, u32 num_hdrs);
 
 #define rds_ib_conn_error(conn, fmt...) \
 	__rds_ib_conn_error(conn, KERN_WARNING "RDS/IB: " fmt)
diff --git a/net/rds/ib_cm.c b/net/rds/ib_cm.c
index b36b60668b1da..f5cbe963cd8f7 100644
--- a/net/rds/ib_cm.c
+++ b/net/rds/ib_cm.c
@@ -30,7 +30,6 @@
  * SOFTWARE.
  *
  */
-#include <linux/dmapool.h>
 #include <linux/kernel.h>
 #include <linux/in.h>
 #include <linux/slab.h>
@@ -441,42 +440,87 @@ static inline void ibdev_put_vector(struct rds_ib_device *rds_ibdev, int index)
 	rds_ibdev->vector_load[index]--;
 }
 
+static void rds_dma_hdr_free(struct ib_device *dev, struct rds_header *hdr,
+		dma_addr_t dma_addr, enum dma_data_direction dir)
+{
+	ib_dma_unmap_single(dev, dma_addr, sizeof(*hdr), dir);
+	kfree(hdr);
+}
+
+static struct rds_header *rds_dma_hdr_alloc(struct ib_device *dev,
+		dma_addr_t *dma_addr, enum dma_data_direction dir)
+{
+	struct rds_header *hdr;
+
+	hdr = kzalloc_node(sizeof(*hdr), GFP_KERNEL, ibdev_to_node(dev));
+	if (!hdr)
+		return NULL;
+
+	*dma_addr = ib_dma_map_single(dev, hdr, sizeof(*hdr),
+				      DMA_BIDIRECTIONAL);
+	if (ib_dma_mapping_error(dev, *dma_addr)) {
+		kfree(hdr);
+		return NULL;
+	}
+
+	return hdr;
+}
+
+/* Free the DMA memory used to store struct rds_header.
+ *
+ * @dev: the RDS IB device
+ * @hdrs: pointer to the array storing DMA memory pointers
+ * @dma_addrs: pointer to the array storing DMA addresses
+ * @num_hdars: number of headers to free.
+ */
+static void rds_dma_hdrs_free(struct rds_ib_device *dev,
+		struct rds_header **hdrs, dma_addr_t *dma_addrs, u32 num_hdrs,
+		enum dma_data_direction dir)
+{
+	u32 i;
+
+	for (i = 0; i < num_hdrs; i++)
+		rds_dma_hdr_free(dev->dev, hdrs[i], dma_addrs[i], dir);
+	kvfree(hdrs);
+	kvfree(dma_addrs);
+}
+
+
 /* Allocate DMA coherent memory to be used to store struct rds_header for
  * sending/receiving packets.  The pointers to the DMA memory and the
  * associated DMA addresses are stored in two arrays.
  *
- * @ibdev: the IB device
- * @pool: the DMA memory pool
+ * @dev: the RDS IB device
  * @dma_addrs: pointer to the array for storing DMA addresses
  * @num_hdrs: number of headers to allocate
  *
  * It returns the pointer to the array storing the DMA memory pointers.  On
  * error, NULL pointer is returned.
  */
-struct rds_header **rds_dma_hdrs_alloc(struct ib_device *ibdev,
-				       struct dma_pool *pool,
-				       dma_addr_t **dma_addrs, u32 num_hdrs)
+static struct rds_header **rds_dma_hdrs_alloc(struct rds_ib_device *dev,
+		dma_addr_t **dma_addrs, u32 num_hdrs,
+		enum dma_data_direction dir)
 {
 	struct rds_header **hdrs;
 	dma_addr_t *hdr_daddrs;
 	u32 i;
 
 	hdrs = kvmalloc_node(sizeof(*hdrs) * num_hdrs, GFP_KERNEL,
-			     ibdev_to_node(ibdev));
+			     ibdev_to_node(dev->dev));
 	if (!hdrs)
 		return NULL;
 
 	hdr_daddrs = kvmalloc_node(sizeof(*hdr_daddrs) * num_hdrs, GFP_KERNEL,
-				   ibdev_to_node(ibdev));
+				   ibdev_to_node(dev->dev));
 	if (!hdr_daddrs) {
 		kvfree(hdrs);
 		return NULL;
 	}
 
 	for (i = 0; i < num_hdrs; i++) {
-		hdrs[i] = dma_pool_zalloc(pool, GFP_KERNEL, &hdr_daddrs[i]);
+		hdrs[i] = rds_dma_hdr_alloc(dev->dev, &hdr_daddrs[i], dir);
 		if (!hdrs[i]) {
-			rds_dma_hdrs_free(pool, hdrs, hdr_daddrs, i);
+			rds_dma_hdrs_free(dev, hdrs, hdr_daddrs, i, dir);
 			return NULL;
 		}
 	}
@@ -485,24 +529,6 @@ struct rds_header **rds_dma_hdrs_alloc(struct ib_device *ibdev,
 	return hdrs;
 }
 
-/* Free the DMA memory used to store struct rds_header.
- *
- * @pool: the DMA memory pool
- * @hdrs: pointer to the array storing DMA memory pointers
- * @dma_addrs: pointer to the array storing DMA addresses
- * @num_hdars: number of headers to free.
- */
-void rds_dma_hdrs_free(struct dma_pool *pool, struct rds_header **hdrs,
-		       dma_addr_t *dma_addrs, u32 num_hdrs)
-{
-	u32 i;
-
-	for (i = 0; i < num_hdrs; i++)
-		dma_pool_free(pool, hdrs[i], dma_addrs[i]);
-	kvfree(hdrs);
-	kvfree(dma_addrs);
-}
-
 /*
  * This needs to be very careful to not leave IS_ERR pointers around for
  * cleanup to trip over.
@@ -516,7 +542,6 @@ static int rds_ib_setup_qp(struct rds_connection *conn)
 	struct rds_ib_device *rds_ibdev;
 	unsigned long max_wrs;
 	int ret, fr_queue_space;
-	struct dma_pool *pool;
 
 	/*
 	 * It's normal to see a null device if an incoming connection races
@@ -612,25 +637,26 @@ static int rds_ib_setup_qp(struct rds_connection *conn)
 		goto recv_cq_out;
 	}
 
-	pool = rds_ibdev->rid_hdrs_pool;
-	ic->i_send_hdrs = rds_dma_hdrs_alloc(dev, pool, &ic->i_send_hdrs_dma,
-					     ic->i_send_ring.w_nr);
+	ic->i_send_hdrs = rds_dma_hdrs_alloc(rds_ibdev, &ic->i_send_hdrs_dma,
+					     ic->i_send_ring.w_nr,
+					     DMA_TO_DEVICE);
 	if (!ic->i_send_hdrs) {
 		ret = -ENOMEM;
 		rdsdebug("DMA send hdrs alloc failed\n");
 		goto qp_out;
 	}
 
-	ic->i_recv_hdrs = rds_dma_hdrs_alloc(dev, pool, &ic->i_recv_hdrs_dma,
-					     ic->i_recv_ring.w_nr);
+	ic->i_recv_hdrs = rds_dma_hdrs_alloc(rds_ibdev, &ic->i_recv_hdrs_dma,
+					     ic->i_recv_ring.w_nr,
+					     DMA_FROM_DEVICE);
 	if (!ic->i_recv_hdrs) {
 		ret = -ENOMEM;
 		rdsdebug("DMA recv hdrs alloc failed\n");
 		goto send_hdrs_dma_out;
 	}
 
-	ic->i_ack = dma_pool_zalloc(pool, GFP_KERNEL,
-				    &ic->i_ack_dma);
+	ic->i_ack = rds_dma_hdr_alloc(rds_ibdev->dev, &ic->i_ack_dma,
+				      DMA_TO_DEVICE);
 	if (!ic->i_ack) {
 		ret = -ENOMEM;
 		rdsdebug("DMA ack header alloc failed\n");
@@ -666,18 +692,19 @@ static int rds_ib_setup_qp(struct rds_connection *conn)
 	vfree(ic->i_sends);
 
 ack_dma_out:
-	dma_pool_free(pool, ic->i_ack, ic->i_ack_dma);
+	rds_dma_hdr_free(rds_ibdev->dev, ic->i_ack, ic->i_ack_dma,
+			 DMA_TO_DEVICE);
 	ic->i_ack = NULL;
 
 recv_hdrs_dma_out:
-	rds_dma_hdrs_free(pool, ic->i_recv_hdrs, ic->i_recv_hdrs_dma,
-			  ic->i_recv_ring.w_nr);
+	rds_dma_hdrs_free(rds_ibdev, ic->i_recv_hdrs, ic->i_recv_hdrs_dma,
+			  ic->i_recv_ring.w_nr, DMA_FROM_DEVICE);
 	ic->i_recv_hdrs = NULL;
 	ic->i_recv_hdrs_dma = NULL;
 
 send_hdrs_dma_out:
-	rds_dma_hdrs_free(pool, ic->i_send_hdrs, ic->i_send_hdrs_dma,
-			  ic->i_send_ring.w_nr);
+	rds_dma_hdrs_free(rds_ibdev, ic->i_send_hdrs, ic->i_send_hdrs_dma,
+			  ic->i_send_ring.w_nr, DMA_TO_DEVICE);
 	ic->i_send_hdrs = NULL;
 	ic->i_send_hdrs_dma = NULL;
 
@@ -1110,29 +1137,30 @@ void rds_ib_conn_path_shutdown(struct rds_conn_path *cp)
 		}
 
 		if (ic->rds_ibdev) {
-			struct dma_pool *pool;
-
-			pool = ic->rds_ibdev->rid_hdrs_pool;
-
 			/* then free the resources that ib callbacks use */
 			if (ic->i_send_hdrs) {
-				rds_dma_hdrs_free(pool, ic->i_send_hdrs,
+				rds_dma_hdrs_free(ic->rds_ibdev,
+						  ic->i_send_hdrs,
 						  ic->i_send_hdrs_dma,
-						  ic->i_send_ring.w_nr);
+						  ic->i_send_ring.w_nr,
+						  DMA_TO_DEVICE);
 				ic->i_send_hdrs = NULL;
 				ic->i_send_hdrs_dma = NULL;
 			}
 
 			if (ic->i_recv_hdrs) {
-				rds_dma_hdrs_free(pool, ic->i_recv_hdrs,
+				rds_dma_hdrs_free(ic->rds_ibdev,
+						  ic->i_recv_hdrs,
 						  ic->i_recv_hdrs_dma,
-						  ic->i_recv_ring.w_nr);
+						  ic->i_recv_ring.w_nr,
+						  DMA_FROM_DEVICE);
 				ic->i_recv_hdrs = NULL;
 				ic->i_recv_hdrs_dma = NULL;
 			}
 
 			if (ic->i_ack) {
-				dma_pool_free(pool, ic->i_ack, ic->i_ack_dma);
+				rds_dma_hdr_free(ic->rds_ibdev->dev, ic->i_ack,
+						 ic->i_ack_dma, DMA_TO_DEVICE);
 				ic->i_ack = NULL;
 			}
 		} else {
diff --git a/net/rds/ib_recv.c b/net/rds/ib_recv.c
index 3cffcec5fb371..6fdedd9dbbc28 100644
--- a/net/rds/ib_recv.c
+++ b/net/rds/ib_recv.c
@@ -662,10 +662,16 @@ static void rds_ib_send_ack(struct rds_ib_connection *ic, unsigned int adv_credi
 	seq = rds_ib_get_ack(ic);
 
 	rdsdebug("send_ack: ic %p ack %llu\n", ic, (unsigned long long) seq);
+
+	ib_dma_sync_single_for_cpu(ic->rds_ibdev->dev, ic->i_ack_dma,
+				   sizeof(*hdr), DMA_TO_DEVICE);
 	rds_message_populate_header(hdr, 0, 0, 0);
 	hdr->h_ack = cpu_to_be64(seq);
 	hdr->h_credit = adv_credits;
 	rds_message_make_checksum(hdr);
+	ib_dma_sync_single_for_device(ic->rds_ibdev->dev, ic->i_ack_dma,
+				      sizeof(*hdr), DMA_TO_DEVICE);
+
 	ic->i_ack_queued = jiffies;
 
 	ret = ib_post_send(ic->i_cm_id->qp, &ic->i_ack_wr, NULL);
@@ -845,6 +851,7 @@ static void rds_ib_process_recv(struct rds_connection *conn,
 	struct rds_ib_connection *ic = conn->c_transport_data;
 	struct rds_ib_incoming *ibinc = ic->i_ibinc;
 	struct rds_header *ihdr, *hdr;
+	dma_addr_t dma_addr = ic->i_recv_hdrs_dma[recv - ic->i_recvs];
 
 	/* XXX shut down the connection if port 0,0 are seen? */
 
@@ -863,6 +870,8 @@ static void rds_ib_process_recv(struct rds_connection *conn,
 
 	ihdr = ic->i_recv_hdrs[recv - ic->i_recvs];
 
+	ib_dma_sync_single_for_cpu(ic->rds_ibdev->dev, dma_addr,
+				   sizeof(*ihdr), DMA_FROM_DEVICE);
 	/* Validate the checksum. */
 	if (!rds_message_verify_checksum(ihdr)) {
 		rds_ib_conn_error(conn, "incoming message "
@@ -870,7 +879,7 @@ static void rds_ib_process_recv(struct rds_connection *conn,
 		       "forcing a reconnect\n",
 		       &conn->c_faddr);
 		rds_stats_inc(s_recv_drop_bad_checksum);
-		return;
+		goto done;
 	}
 
 	/* Process the ACK sequence which comes with every packet */
@@ -899,7 +908,7 @@ static void rds_ib_process_recv(struct rds_connection *conn,
 		 */
 		rds_ib_frag_free(ic, recv->r_frag);
 		recv->r_frag = NULL;
-		return;
+		goto done;
 	}
 
 	/*
@@ -933,7 +942,7 @@ static void rds_ib_process_recv(struct rds_connection *conn,
 		    hdr->h_dport != ihdr->h_dport) {
 			rds_ib_conn_error(conn,
 				"fragment header mismatch; forcing reconnect\n");
-			return;
+			goto done;
 		}
 	}
 
@@ -965,6 +974,9 @@ static void rds_ib_process_recv(struct rds_connection *conn,
 
 		rds_inc_put(&ibinc->ii_inc);
 	}
+done:
+	ib_dma_sync_single_for_device(ic->rds_ibdev->dev, dma_addr,
+				      sizeof(*ihdr), DMA_FROM_DEVICE);
 }
 
 void rds_ib_recv_cqe_handler(struct rds_ib_connection *ic,
diff --git a/net/rds/ib_send.c b/net/rds/ib_send.c
index dfe778220657a..92b4a8689aae7 100644
--- a/net/rds/ib_send.c
+++ b/net/rds/ib_send.c
@@ -638,6 +638,10 @@ int rds_ib_xmit(struct rds_connection *conn, struct rds_message *rm,
 		send->s_sge[0].length = sizeof(struct rds_header);
 		send->s_sge[0].lkey = ic->i_pd->local_dma_lkey;
 
+		ib_dma_sync_single_for_cpu(ic->rds_ibdev->dev,
+					   ic->i_send_hdrs_dma[pos],
+					   sizeof(struct rds_header),
+					   DMA_TO_DEVICE);
 		memcpy(ic->i_send_hdrs[pos], &rm->m_inc.i_hdr,
 		       sizeof(struct rds_header));
 
@@ -688,6 +692,10 @@ int rds_ib_xmit(struct rds_connection *conn, struct rds_message *rm,
 			adv_credits = 0;
 			rds_ib_stats_inc(s_ib_tx_credit_updates);
 		}
+		ib_dma_sync_single_for_device(ic->rds_ibdev->dev,
+					      ic->i_send_hdrs_dma[pos],
+					      sizeof(struct rds_header),
+					      DMA_TO_DEVICE);
 
 		if (prev)
 			prev->s_wr.next = &send->s_wr;
-- 
2.25.1

