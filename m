Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF73E1A10FA
	for <lists+netdev@lfdr.de>; Tue,  7 Apr 2020 18:08:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727865AbgDGQIS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Apr 2020 12:08:18 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:38442 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726873AbgDGQIS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Apr 2020 12:08:18 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 037Fx0oi161043;
        Tue, 7 Apr 2020 16:08:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2020-01-29;
 bh=3qfxonWgtJKEfRw3FTyMs9nDWr+Pzqq3qSpXKmLAm6g=;
 b=XUo1BXFaBVliC1+f1Wt18dAer9hZNdO0hdULpk2XNpeeJVdRvywmAP6BrBkMUAP/VQQJ
 u5c6lfWb20YRI2+GjIXjocaVSAQ3jJz/udgSyaRa3jCj5z6jTx3d+ua/LZpAJM91yB/d
 oHuQ3gRLTwy0H0rAF5YBMkN28h4Odq91bJxWuPVFDLPDwyFQ2t+o59zHspP3NHoHFcPr
 c327sha92W94Ejq95QLh4nXsZ0uGYMj0qM5iyxmR0wrS6gGth62XMsoxd2CIZkEvBfCS
 OB9w0OT+JVeDGN1c1u4JOag/fG1wdVEw4peBBRMsVwDcx73lErDmAixTDQdJHwICBtqp Ow== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 306jvn5xm3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Apr 2020 16:08:08 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 037G7aP8036339;
        Tue, 7 Apr 2020 16:08:07 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3020.oracle.com with ESMTP id 30741eq51d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 07 Apr 2020 16:08:07 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 037G873h038492;
        Tue, 7 Apr 2020 16:08:07 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 30741eq500-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Apr 2020 16:08:07 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 037G865l026271;
        Tue, 7 Apr 2020 16:08:06 GMT
Received: from ca-dev40.us.oracle.com (/10.129.135.27)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 07 Apr 2020 09:08:05 -0700
From:   Ka-Cheong Poon <ka-cheong.poon@oracle.com>
To:     netdev@vger.kernel.org
Cc:     santosh.shilimkar@oracle.com, davem@davemloft.net,
        rds-devel@oss.oracle.com, sironhide0null@gmail.com
Subject: [PATCH net 1/2] net/rds: Replace direct refcount_inc() by inline function
Date:   Tue,  7 Apr 2020 09:08:01 -0700
Message-Id: <4b96ea99c3f0ccd5cc0683a5c944a1c4da41cc38.1586275373.git.ka-cheong.poon@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9583 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=1
 mlxlogscore=972 mlxscore=0 bulkscore=0 adultscore=0 priorityscore=1501
 lowpriorityscore=0 clxscore=1011 malwarescore=0 impostorscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004070131
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Added rds_ib_dev_get() and rds_mr_get() to improve code readability.

Signed-off-by: Ka-Cheong Poon <ka-cheong.poon@oracle.com>
---
 net/rds/ib.c      | 8 ++++----
 net/rds/ib.h      | 5 +++++
 net/rds/ib_rdma.c | 6 +++---
 net/rds/rdma.c    | 8 ++++----
 net/rds/rds.h     | 5 +++++
 5 files changed, 21 insertions(+), 11 deletions(-)

diff --git a/net/rds/ib.c b/net/rds/ib.c
index a792d8a..c16cb1a 100644
--- a/net/rds/ib.c
+++ b/net/rds/ib.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2006, 2019 Oracle and/or its affiliates. All rights reserved.
+ * Copyright (c) 2006, 2020 Oracle and/or its affiliates. All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
@@ -224,10 +224,10 @@ static void rds_ib_add_one(struct ib_device *device)
 	down_write(&rds_ib_devices_lock);
 	list_add_tail_rcu(&rds_ibdev->list, &rds_ib_devices);
 	up_write(&rds_ib_devices_lock);
-	refcount_inc(&rds_ibdev->refcount);
+	rds_ib_dev_get(rds_ibdev);
 
 	ib_set_client_data(device, &rds_ib_client, rds_ibdev);
-	refcount_inc(&rds_ibdev->refcount);
+	rds_ib_dev_get(rds_ibdev);
 
 	rds_ib_nodev_connect();
 
@@ -258,7 +258,7 @@ struct rds_ib_device *rds_ib_get_client_data(struct ib_device *device)
 	rcu_read_lock();
 	rds_ibdev = ib_get_client_data(device, &rds_ib_client);
 	if (rds_ibdev)
-		refcount_inc(&rds_ibdev->refcount);
+		rds_ib_dev_get(rds_ibdev);
 	rcu_read_unlock();
 	return rds_ibdev;
 }
diff --git a/net/rds/ib.h b/net/rds/ib.h
index 0296f1f..fe7ea4e 100644
--- a/net/rds/ib.h
+++ b/net/rds/ib.h
@@ -361,6 +361,11 @@ static inline void rds_ib_dma_sync_sg_for_device(struct ib_device *dev,
 extern struct rds_transport rds_ib_transport;
 struct rds_ib_device *rds_ib_get_client_data(struct ib_device *device);
 void rds_ib_dev_put(struct rds_ib_device *rds_ibdev);
+static inline void rds_ib_dev_get(struct rds_ib_device *rds_ibdev)
+{
+	refcount_inc(&rds_ibdev->refcount);
+}
+
 extern struct ib_client rds_ib_client;
 
 extern unsigned int rds_ib_retry_count;
diff --git a/net/rds/ib_rdma.c b/net/rds/ib_rdma.c
index b34b24e..1b942d80 100644
--- a/net/rds/ib_rdma.c
+++ b/net/rds/ib_rdma.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2006, 2018 Oracle and/or its affiliates. All rights reserved.
+ * Copyright (c) 2006, 2020 Oracle and/or its affiliates. All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
@@ -56,7 +56,7 @@ static struct rds_ib_device *rds_ib_get_device(__be32 ipaddr)
 	list_for_each_entry_rcu(rds_ibdev, &rds_ib_devices, list) {
 		list_for_each_entry_rcu(i_ipaddr, &rds_ibdev->ipaddr_list, list) {
 			if (i_ipaddr->ipaddr == ipaddr) {
-				refcount_inc(&rds_ibdev->refcount);
+				rds_ib_dev_get(rds_ibdev);
 				rcu_read_unlock();
 				return rds_ibdev;
 			}
@@ -139,7 +139,7 @@ void rds_ib_add_conn(struct rds_ib_device *rds_ibdev, struct rds_connection *con
 	spin_unlock_irq(&ib_nodev_conns_lock);
 
 	ic->rds_ibdev = rds_ibdev;
-	refcount_inc(&rds_ibdev->refcount);
+	rds_ib_dev_get(rds_ibdev);
 }
 
 void rds_ib_remove_conn(struct rds_ib_device *rds_ibdev, struct rds_connection *conn)
diff --git a/net/rds/rdma.c b/net/rds/rdma.c
index 585e6b3..d5abe0e 100644
--- a/net/rds/rdma.c
+++ b/net/rds/rdma.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2007, 2017 Oracle and/or its affiliates. All rights reserved.
+ * Copyright (c) 2007, 2020 Oracle and/or its affiliates. All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
@@ -84,7 +84,7 @@ static struct rds_mr *rds_mr_tree_walk(struct rb_root *root, u64 key,
 	if (insert) {
 		rb_link_node(&insert->r_rb_node, parent, p);
 		rb_insert_color(&insert->r_rb_node, root);
-		refcount_inc(&insert->r_refcount);
+		rds_mr_get(insert);
 	}
 	return NULL;
 }
@@ -343,7 +343,7 @@ static int __rds_rdma_map(struct rds_sock *rs, struct rds_get_mr_args *args,
 
 	rdsdebug("RDS: get_mr key is %x\n", mr->r_key);
 	if (mr_ret) {
-		refcount_inc(&mr->r_refcount);
+		rds_mr_get(mr);
 		*mr_ret = mr;
 	}
 
@@ -827,7 +827,7 @@ int rds_cmsg_rdma_dest(struct rds_sock *rs, struct rds_message *rm,
 	if (!mr)
 		err = -EINVAL;	/* invalid r_key */
 	else
-		refcount_inc(&mr->r_refcount);
+		rds_mr_get(mr);
 	spin_unlock_irqrestore(&rs->rs_rdma_lock, flags);
 
 	if (mr) {
diff --git a/net/rds/rds.h b/net/rds/rds.h
index e4a6035..6a665fa 100644
--- a/net/rds/rds.h
+++ b/net/rds/rds.h
@@ -953,6 +953,11 @@ static inline void rds_mr_put(struct rds_mr *mr)
 		__rds_put_mr_final(mr);
 }
 
+static inline void rds_mr_get(struct rds_mr *mr)
+{
+	refcount_inc(&mr->r_refcount);
+}
+
 static inline bool rds_destroy_pending(struct rds_connection *conn)
 {
 	return !check_net(rds_conn_net(conn)) ||
-- 
1.8.3.1

