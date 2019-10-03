Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC9A8C972E
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 06:11:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726357AbfJCELY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 00:11:24 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:44386 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725613AbfJCELY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 00:11:24 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9343n7C153656;
        Thu, 3 Oct 2019 04:11:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=kD75dE8/FlLx62i7aaYeH67yyAPLqIT00fGpCZG9r70=;
 b=LUe3htbVsUEPb1/HyIQmRkg/p86nGyHnZtVxl40Kya91fRvRRgtNtPBu71O6apuLhHR+
 zoaEifV1Pec25uvDymX6ftR14cbEbnWpJICbEONt6m+NIHWSPYMibs80lGQ6u4fZn54q
 jUbw82c6CpR09Wl5PDGraoc86Tst6QDIwEacCJCDD5tZebCMspqr41MVyRrLf2WiIevw
 rUQXr6/vmH48XQaaUVU3mL+hF8FNfpt7i6CT0baM1vl97FXo1iq9w7A0xr0v/5ioUEo4
 sCWvkurMIWgVxT5uq6hwv83ai1vlPFkAC7C1/5g61tPItY0YFBzdXtRonsEcWEH6o1vb qQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2va05s0ynt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Oct 2019 04:11:14 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9343YL6041311;
        Thu, 3 Oct 2019 04:11:14 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3020.oracle.com with ESMTP id 2vc9dmxgcd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 03 Oct 2019 04:11:13 +0000
Received: from userp3020.oracle.com (userp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x934BDNg060774;
        Thu, 3 Oct 2019 04:11:13 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2vc9dmxgbk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Oct 2019 04:11:13 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x934BC8g005643;
        Thu, 3 Oct 2019 04:11:12 GMT
Received: from ca-dev40.us.oracle.com (/10.129.135.27)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 02 Oct 2019 21:11:12 -0700
From:   Ka-Cheong Poon <ka-cheong.poon@oracle.com>
To:     netdev@vger.kernel.org
Cc:     santosh.shilimkar@oracle.com, davem@davemloft.net,
        rds-devel@oss.oracle.com
Subject: [PATCH net-next v2] net/rds: Use DMA memory pool allocation for rds_header
Date:   Wed,  2 Oct 2019 21:11:08 -0700
Message-Id: <1570075868-3163-1-git-send-email-ka-cheong.poon@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1569834480-25584-1-git-send-email-ka-cheong.poon@oracle.com>
References: <1569834480-25584-1-git-send-email-ka-cheong.poon@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9398 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=4 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910030037
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, RDS calls ib_dma_alloc_coherent() to allocate a large piece
of contiguous DMA coherent memory to store struct rds_header for
sending/receiving packets.  The memory allocated is then partitioned
into struct rds_header.  This is not necessary and can be costly at
times when memory is fragmented.  Instead, RDS should use the DMA
memory pool interface to handle this.  The DMA addresses of the pre-
allocated headers are stored in an array.  At send/receive ring
initialization and refill time, this arrary is de-referenced to get
the DMA addresses.  This array is not accessed at send/receive packet
processing.

Suggested-by: Håkon Bugge <haakon.bugge@oracle.com>
Signed-off-by: Ka-Cheong Poon <ka-cheong.poon@oracle.com>
Acked-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>
---
 net/rds/ib.c      |  10 +++-
 net/rds/ib.h      |  15 +++--
 net/rds/ib_cm.c   | 166 +++++++++++++++++++++++++++++++++++++++---------------
 net/rds/ib_recv.c |   8 +--
 net/rds/ib_send.c |  15 +++--
 5 files changed, 153 insertions(+), 61 deletions(-)

diff --git a/net/rds/ib.c b/net/rds/ib.c
index 45acab2..01dc189 100644
--- a/net/rds/ib.c
+++ b/net/rds/ib.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2006, 2018 Oracle and/or its affiliates. All rights reserved.
+ * Copyright (c) 2006, 2019 Oracle and/or its affiliates. All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
@@ -107,6 +107,8 @@ static void rds_ib_dev_free(struct work_struct *work)
 		rds_ib_destroy_mr_pool(rds_ibdev->mr_1m_pool);
 	if (rds_ibdev->pd)
 		ib_dealloc_pd(rds_ibdev->pd);
+	if (rds_ibdev->rid_hdrs_pool)
+		dma_pool_destroy(rds_ibdev->rid_hdrs_pool);
 
 	list_for_each_entry_safe(i_ipaddr, i_next, &rds_ibdev->ipaddr_list, list) {
 		list_del(&i_ipaddr->list);
@@ -179,6 +181,12 @@ static void rds_ib_add_one(struct ib_device *device)
 		rds_ibdev->pd = NULL;
 		goto put_dev;
 	}
+	rds_ibdev->rid_hdrs_pool = dma_pool_create(device->name,
+						   device->dma_device,
+						   sizeof(struct rds_header),
+						   L1_CACHE_BYTES, 0);
+	if (!rds_ibdev->rid_hdrs_pool)
+		goto put_dev;
 
 	rds_ibdev->mr_1m_pool =
 		rds_ib_create_mr_pool(rds_ibdev, RDS_IB_MR_1M_POOL);
diff --git a/net/rds/ib.h b/net/rds/ib.h
index f2b558e..6e6f247 100644
--- a/net/rds/ib.h
+++ b/net/rds/ib.h
@@ -165,8 +165,8 @@ struct rds_ib_connection {
 	/* tx */
 	struct rds_ib_work_ring	i_send_ring;
 	struct rm_data_op	*i_data_op;
-	struct rds_header	*i_send_hdrs;
-	dma_addr_t		i_send_hdrs_dma;
+	struct rds_header	**i_send_hdrs;
+	dma_addr_t		*i_send_hdrs_dma;
 	struct rds_ib_send_work *i_sends;
 	atomic_t		i_signaled_sends;
 
@@ -175,8 +175,8 @@ struct rds_ib_connection {
 	struct rds_ib_work_ring	i_recv_ring;
 	struct rds_ib_incoming	*i_ibinc;
 	u32			i_recv_data_rem;
-	struct rds_header	*i_recv_hdrs;
-	dma_addr_t		i_recv_hdrs_dma;
+	struct rds_header	**i_recv_hdrs;
+	dma_addr_t		*i_recv_hdrs_dma;
 	struct rds_ib_recv_work *i_recvs;
 	u64			i_ack_recv;	/* last ACK received */
 	struct rds_ib_refill_cache i_cache_incs;
@@ -246,6 +246,7 @@ struct rds_ib_device {
 	struct list_head	conn_list;
 	struct ib_device	*dev;
 	struct ib_pd		*pd;
+	struct dma_pool		*rid_hdrs_pool; /* RDS headers DMA pool */
 	bool                    use_fastreg;
 
 	unsigned int		max_mrs;
@@ -381,7 +382,11 @@ int rds_ib_cm_handle_connect(struct rdma_cm_id *cm_id,
 int rds_ib_cm_initiate_connect(struct rdma_cm_id *cm_id, bool isv6);
 void rds_ib_cm_connect_complete(struct rds_connection *conn,
 				struct rdma_cm_event *event);
-
+struct rds_header **rds_dma_hdrs_alloc(struct ib_device *ibdev,
+				       struct dma_pool *pool,
+				       dma_addr_t **dma_addrs, u32 num_hdrs);
+void rds_dma_hdrs_free(struct dma_pool *pool, struct rds_header **hdrs,
+		       dma_addr_t *dma_addrs, u32 num_hdrs);
 
 #define rds_ib_conn_error(conn, fmt...) \
 	__rds_ib_conn_error(conn, KERN_WARNING "RDS/IB: " fmt)
diff --git a/net/rds/ib_cm.c b/net/rds/ib_cm.c
index 233f136..d08251f 100644
--- a/net/rds/ib_cm.c
+++ b/net/rds/ib_cm.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2006, 2018 Oracle and/or its affiliates. All rights reserved.
+ * Copyright (c) 2006, 2019 Oracle and/or its affiliates. All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
@@ -439,6 +439,68 @@ static inline void ibdev_put_vector(struct rds_ib_device *rds_ibdev, int index)
 	rds_ibdev->vector_load[index]--;
 }
 
+/* Allocate DMA coherent memory to be used to store struct rds_header for
+ * sending/receiving packets.  The pointers to the DMA memory and the
+ * associated DMA addresses are stored in two arrays.
+ *
+ * @ibdev: the IB device
+ * @pool: the DMA memory pool
+ * @dma_addrs: pointer to the array for storing DMA addresses
+ * @num_hdrs: number of headers to allocate
+ *
+ * It returns the pointer to the array storing the DMA memory pointers.  On
+ * error, NULL pointer is returned.
+ */
+struct rds_header **rds_dma_hdrs_alloc(struct ib_device *ibdev,
+				       struct dma_pool *pool,
+				       dma_addr_t **dma_addrs, u32 num_hdrs)
+{
+	struct rds_header **hdrs;
+	dma_addr_t *hdr_daddrs;
+	u32 i;
+
+	hdrs = kvmalloc_node(sizeof(*hdrs) * num_hdrs, GFP_KERNEL,
+			     ibdev_to_node(ibdev));
+	if (!hdrs)
+		return NULL;
+
+	hdr_daddrs = kvmalloc_node(sizeof(*hdr_daddrs) * num_hdrs, GFP_KERNEL,
+				   ibdev_to_node(ibdev));
+	if (!hdr_daddrs) {
+		kvfree(hdrs);
+		return NULL;
+	}
+
+	for (i = 0; i < num_hdrs; i++) {
+		hdrs[i] = dma_pool_zalloc(pool, GFP_KERNEL, &hdr_daddrs[i]);
+		if (!hdrs[i]) {
+			rds_dma_hdrs_free(pool, hdrs, hdr_daddrs, i);
+			return NULL;
+		}
+	}
+
+	*dma_addrs = hdr_daddrs;
+	return hdrs;
+}
+
+/* Free the DMA memory used to store struct rds_header.
+ *
+ * @pool: the DMA memory pool
+ * @hdrs: pointer to the array storing DMA memory pointers
+ * @dma_addrs: pointer to the array storing DMA addresses
+ * @num_hdars: number of headers to free.
+ */
+void rds_dma_hdrs_free(struct dma_pool *pool, struct rds_header **hdrs,
+		       dma_addr_t *dma_addrs, u32 num_hdrs)
+{
+	u32 i;
+
+	for (i = 0; i < num_hdrs; i++)
+		dma_pool_free(pool, hdrs[i], dma_addrs[i]);
+	kvfree(hdrs);
+	kvfree(dma_addrs);
+}
+
 /*
  * This needs to be very careful to not leave IS_ERR pointers around for
  * cleanup to trip over.
@@ -451,6 +513,7 @@ static int rds_ib_setup_qp(struct rds_connection *conn)
 	struct ib_cq_init_attr cq_attr = {};
 	struct rds_ib_device *rds_ibdev;
 	int ret, fr_queue_space;
+	struct dma_pool *pool;
 
 	/*
 	 * It's normal to see a null device if an incoming connection races
@@ -541,31 +604,28 @@ static int rds_ib_setup_qp(struct rds_connection *conn)
 		goto recv_cq_out;
 	}
 
-	ic->i_send_hdrs = ib_dma_alloc_coherent(dev,
-					   ic->i_send_ring.w_nr *
-						sizeof(struct rds_header),
-					   &ic->i_send_hdrs_dma, GFP_KERNEL);
+	pool = rds_ibdev->rid_hdrs_pool;
+	ic->i_send_hdrs = rds_dma_hdrs_alloc(dev, pool, &ic->i_send_hdrs_dma,
+					     ic->i_send_ring.w_nr);
 	if (!ic->i_send_hdrs) {
 		ret = -ENOMEM;
-		rdsdebug("ib_dma_alloc_coherent send failed\n");
+		rdsdebug("DMA send hdrs alloc failed\n");
 		goto qp_out;
 	}
 
-	ic->i_recv_hdrs = ib_dma_alloc_coherent(dev,
-					   ic->i_recv_ring.w_nr *
-						sizeof(struct rds_header),
-					   &ic->i_recv_hdrs_dma, GFP_KERNEL);
+	ic->i_recv_hdrs = rds_dma_hdrs_alloc(dev, pool, &ic->i_recv_hdrs_dma,
+					     ic->i_recv_ring.w_nr);
 	if (!ic->i_recv_hdrs) {
 		ret = -ENOMEM;
-		rdsdebug("ib_dma_alloc_coherent recv failed\n");
+		rdsdebug("DMA recv hdrs alloc failed\n");
 		goto send_hdrs_dma_out;
 	}
 
-	ic->i_ack = ib_dma_alloc_coherent(dev, sizeof(struct rds_header),
-				       &ic->i_ack_dma, GFP_KERNEL);
+	ic->i_ack = dma_pool_zalloc(pool, GFP_KERNEL,
+				    &ic->i_ack_dma);
 	if (!ic->i_ack) {
 		ret = -ENOMEM;
-		rdsdebug("ib_dma_alloc_coherent ack failed\n");
+		rdsdebug("DMA ack header alloc failed\n");
 		goto recv_hdrs_dma_out;
 	}
 
@@ -596,17 +656,23 @@ static int rds_ib_setup_qp(struct rds_connection *conn)
 
 sends_out:
 	vfree(ic->i_sends);
+
 ack_dma_out:
-	ib_dma_free_coherent(dev, sizeof(struct rds_header),
-			     ic->i_ack, ic->i_ack_dma);
+	dma_pool_free(pool, ic->i_ack, ic->i_ack_dma);
+	ic->i_ack = NULL;
+
 recv_hdrs_dma_out:
-	ib_dma_free_coherent(dev, ic->i_recv_ring.w_nr *
-					sizeof(struct rds_header),
-					ic->i_recv_hdrs, ic->i_recv_hdrs_dma);
+	rds_dma_hdrs_free(pool, ic->i_recv_hdrs, ic->i_recv_hdrs_dma,
+			  ic->i_recv_ring.w_nr);
+	ic->i_recv_hdrs = NULL;
+	ic->i_recv_hdrs_dma = NULL;
+
 send_hdrs_dma_out:
-	ib_dma_free_coherent(dev, ic->i_send_ring.w_nr *
-					sizeof(struct rds_header),
-					ic->i_send_hdrs, ic->i_send_hdrs_dma);
+	rds_dma_hdrs_free(pool, ic->i_send_hdrs, ic->i_send_hdrs_dma,
+			  ic->i_send_ring.w_nr);
+	ic->i_send_hdrs = NULL;
+	ic->i_send_hdrs_dma = NULL;
+
 qp_out:
 	rdma_destroy_qp(ic->i_cm_id);
 recv_cq_out:
@@ -984,8 +1050,6 @@ void rds_ib_conn_path_shutdown(struct rds_conn_path *cp)
 		 ic->i_cm_id ? ic->i_cm_id->qp : NULL);
 
 	if (ic->i_cm_id) {
-		struct ib_device *dev = ic->i_cm_id->device;
-
 		rdsdebug("disconnecting cm %p\n", ic->i_cm_id);
 		err = rdma_disconnect(ic->i_cm_id);
 		if (err) {
@@ -1035,24 +1099,39 @@ void rds_ib_conn_path_shutdown(struct rds_conn_path *cp)
 			ib_destroy_cq(ic->i_recv_cq);
 		}
 
-		/* then free the resources that ib callbacks use */
-		if (ic->i_send_hdrs)
-			ib_dma_free_coherent(dev,
-					   ic->i_send_ring.w_nr *
-						sizeof(struct rds_header),
-					   ic->i_send_hdrs,
-					   ic->i_send_hdrs_dma);
-
-		if (ic->i_recv_hdrs)
-			ib_dma_free_coherent(dev,
-					   ic->i_recv_ring.w_nr *
-						sizeof(struct rds_header),
-					   ic->i_recv_hdrs,
-					   ic->i_recv_hdrs_dma);
-
-		if (ic->i_ack)
-			ib_dma_free_coherent(dev, sizeof(struct rds_header),
-					     ic->i_ack, ic->i_ack_dma);
+		if (ic->rds_ibdev) {
+			struct dma_pool *pool;
+
+			pool = ic->rds_ibdev->rid_hdrs_pool;
+
+			/* then free the resources that ib callbacks use */
+			if (ic->i_send_hdrs) {
+				rds_dma_hdrs_free(pool, ic->i_send_hdrs,
+						  ic->i_send_hdrs_dma,
+						  ic->i_send_ring.w_nr);
+				ic->i_send_hdrs = NULL;
+				ic->i_send_hdrs_dma = NULL;
+			}
+
+			if (ic->i_recv_hdrs) {
+				rds_dma_hdrs_free(pool, ic->i_recv_hdrs,
+						  ic->i_recv_hdrs_dma,
+						  ic->i_recv_ring.w_nr);
+				ic->i_recv_hdrs = NULL;
+				ic->i_recv_hdrs_dma = NULL;
+			}
+
+			if (ic->i_ack) {
+				dma_pool_free(pool, ic->i_ack, ic->i_ack_dma);
+				ic->i_ack = NULL;
+			}
+		} else {
+			WARN_ON(ic->i_send_hdrs);
+			WARN_ON(ic->i_send_hdrs_dma);
+			WARN_ON(ic->i_recv_hdrs);
+			WARN_ON(ic->i_recv_hdrs_dma);
+			WARN_ON(ic->i_ack);
+		}
 
 		if (ic->i_sends)
 			rds_ib_send_clear_ring(ic);
@@ -1071,9 +1150,6 @@ void rds_ib_conn_path_shutdown(struct rds_conn_path *cp)
 		ic->i_pd = NULL;
 		ic->i_send_cq = NULL;
 		ic->i_recv_cq = NULL;
-		ic->i_send_hdrs = NULL;
-		ic->i_recv_hdrs = NULL;
-		ic->i_ack = NULL;
 	}
 	BUG_ON(ic->rds_ibdev);
 
diff --git a/net/rds/ib_recv.c b/net/rds/ib_recv.c
index a0f99bb..bcc2a71 100644
--- a/net/rds/ib_recv.c
+++ b/net/rds/ib_recv.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2006, 2017 Oracle and/or its affiliates. All rights reserved.
+ * Copyright (c) 2006, 2019 Oracle and/or its affiliates. All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
@@ -61,7 +61,7 @@ void rds_ib_recv_init_ring(struct rds_ib_connection *ic)
 		recv->r_wr.num_sge = RDS_IB_RECV_SGE;
 
 		sge = &recv->r_sge[0];
-		sge->addr = ic->i_recv_hdrs_dma + (i * sizeof(struct rds_header));
+		sge->addr = ic->i_recv_hdrs_dma[i];
 		sge->length = sizeof(struct rds_header);
 		sge->lkey = ic->i_pd->local_dma_lkey;
 
@@ -343,7 +343,7 @@ static int rds_ib_recv_refill_one(struct rds_connection *conn,
 	WARN_ON(ret != 1);
 
 	sge = &recv->r_sge[0];
-	sge->addr = ic->i_recv_hdrs_dma + (recv - ic->i_recvs) * sizeof(struct rds_header);
+	sge->addr = ic->i_recv_hdrs_dma[recv - ic->i_recvs];
 	sge->length = sizeof(struct rds_header);
 
 	sge = &recv->r_sge[1];
@@ -861,7 +861,7 @@ static void rds_ib_process_recv(struct rds_connection *conn,
 	}
 	data_len -= sizeof(struct rds_header);
 
-	ihdr = &ic->i_recv_hdrs[recv - ic->i_recvs];
+	ihdr = ic->i_recv_hdrs[recv - ic->i_recvs];
 
 	/* Validate the checksum. */
 	if (!rds_message_verify_checksum(ihdr)) {
diff --git a/net/rds/ib_send.c b/net/rds/ib_send.c
index dfe6237..58b82d8 100644
--- a/net/rds/ib_send.c
+++ b/net/rds/ib_send.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2006, 2017 Oracle and/or its affiliates. All rights reserved.
+ * Copyright (c) 2006, 2019 Oracle and/or its affiliates. All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
@@ -201,7 +201,8 @@ void rds_ib_send_init_ring(struct rds_ib_connection *ic)
 		send->s_wr.ex.imm_data = 0;
 
 		sge = &send->s_sge[0];
-		sge->addr = ic->i_send_hdrs_dma + (i * sizeof(struct rds_header));
+		sge->addr = ic->i_send_hdrs_dma[i];
+
 		sge->length = sizeof(struct rds_header);
 		sge->lkey = ic->i_pd->local_dma_lkey;
 
@@ -631,11 +632,13 @@ int rds_ib_xmit(struct rds_connection *conn, struct rds_message *rm,
 		send->s_queued = jiffies;
 		send->s_op = NULL;
 
-		send->s_sge[0].addr = ic->i_send_hdrs_dma
-			+ (pos * sizeof(struct rds_header));
+		send->s_sge[0].addr = ic->i_send_hdrs_dma[pos];
+
 		send->s_sge[0].length = sizeof(struct rds_header);
 
-		memcpy(&ic->i_send_hdrs[pos], &rm->m_inc.i_hdr, sizeof(struct rds_header));
+		memcpy(ic->i_send_hdrs[pos], &rm->m_inc.i_hdr,
+		       sizeof(struct rds_header));
+
 
 		/* Set up the data, if present */
 		if (i < work_alloc
@@ -674,7 +677,7 @@ int rds_ib_xmit(struct rds_connection *conn, struct rds_message *rm,
 			 &send->s_wr, send->s_wr.num_sge, send->s_wr.next);
 
 		if (ic->i_flowctl && adv_credits) {
-			struct rds_header *hdr = &ic->i_send_hdrs[pos];
+			struct rds_header *hdr = ic->i_send_hdrs[pos];
 
 			/* add credit and redo the header checksum */
 			hdr->h_credit = adv_credits;
-- 
1.8.3.1

