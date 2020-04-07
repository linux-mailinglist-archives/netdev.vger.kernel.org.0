Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79B7A1A10FB
	for <lists+netdev@lfdr.de>; Tue,  7 Apr 2020 18:08:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727794AbgDGQIS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Apr 2020 12:08:18 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:38438 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726716AbgDGQIR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Apr 2020 12:08:17 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 037Fx3aQ161162;
        Tue, 7 Apr 2020 16:08:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : in-reply-to :
 references; s=corp-2020-01-29;
 bh=esNWUWJqYp316LA0XAkeYSC5vOmSUx+fAKc3UdWlUa4=;
 b=uQDLB5/AI2Hkx2HVVc8lCheP2iRWPGB6pYJDRegIdeQ6fAII6vuPF2InsRk3iT4XaFN/
 FgTOMmUfMad4GlqV9crCoGsu5k5B3d5rgC3KTPiIsKUSkhKdHVyOuO9obubYmhq5cZv0
 EpMtLm6tBVSOP8e2SFiUnJA1OguHXOQS/tbd8dCsAuZ2PygTdOzKbFNZvfD/6sPoQD65
 /HeHBupncrl7aV9f3WPWHe+WT7egBc0EdMCbQn89spxLjDTFKqeRJhAwznT8RCDDabtQ
 abeChpuMIK2XvtppYoywHYg2F8rwEgZSHkTvNp02vln91LB6QUYdDPJ4r7JprIkd2K86 Yg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 306jvn5xm4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Apr 2020 16:08:08 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 037G7PZB050817;
        Tue, 7 Apr 2020 16:08:08 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3030.oracle.com with ESMTP id 3073qgh2vu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 07 Apr 2020 16:08:08 +0000
Received: from userp3030.oracle.com (userp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 037G7YDP051569;
        Tue, 7 Apr 2020 16:08:07 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 3073qgh2us-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Apr 2020 16:08:07 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 037G86fk028391;
        Tue, 7 Apr 2020 16:08:06 GMT
Received: from ca-dev40.us.oracle.com (/10.129.135.27)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 07 Apr 2020 09:08:06 -0700
From:   Ka-Cheong Poon <ka-cheong.poon@oracle.com>
To:     netdev@vger.kernel.org
Cc:     santosh.shilimkar@oracle.com, davem@davemloft.net,
        rds-devel@oss.oracle.com, sironhide0null@gmail.com
Subject: [PATCH net 2/2] net/rds: Fix MR reference counting problem
Date:   Tue,  7 Apr 2020 09:08:02 -0700
Message-Id: <a99e79aa8515e4b52ced83447122fbd260104f0f.1586275373.git.ka-cheong.poon@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <4b96ea99c3f0ccd5cc0683a5c944a1c4da41cc38.1586275373.git.ka-cheong.poon@oracle.com>
References: <4b96ea99c3f0ccd5cc0683a5c944a1c4da41cc38.1586275373.git.ka-cheong.poon@oracle.com>
In-Reply-To: <4b96ea99c3f0ccd5cc0683a5c944a1c4da41cc38.1586275373.git.ka-cheong.poon@oracle.com>
References: <4b96ea99c3f0ccd5cc0683a5c944a1c4da41cc38.1586275373.git.ka-cheong.poon@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9583 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=3
 mlxlogscore=999 mlxscore=0 bulkscore=0 adultscore=0 priorityscore=1501
 lowpriorityscore=0 clxscore=1015 malwarescore=0 impostorscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004070131
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In rds_free_mr(), it calls rds_destroy_mr(mr) directly.  But this
defeats the purpose of reference counting and makes MR free handling
impossible.  It means that holding a reference does not guarantee that
it is safe to access some fields.  For example, In
rds_cmsg_rdma_dest(), it increases the ref count, unlocks and then
calls mr->r_trans->sync_mr().  But if rds_free_mr() (and
rds_destroy_mr()) is called in between (there is no lock preventing
this to happen), r_trans_private is set to NULL, causing a panic.
Similar issue is in rds_rdma_unuse().

Reported-by: zerons <sironhide0null@gmail.com>
Signed-off-by: Ka-Cheong Poon <ka-cheong.poon@oracle.com>
---
 net/rds/rdma.c | 25 ++++++++++++-------------
 net/rds/rds.h  |  8 --------
 2 files changed, 12 insertions(+), 21 deletions(-)

diff --git a/net/rds/rdma.c b/net/rds/rdma.c
index d5abe0e..4cb5485 100644
--- a/net/rds/rdma.c
+++ b/net/rds/rdma.c
@@ -101,9 +101,6 @@ static void rds_destroy_mr(struct rds_mr *mr)
 	rdsdebug("RDS: destroy mr key is %x refcnt %u\n",
 			mr->r_key, refcount_read(&mr->r_refcount));
 
-	if (test_and_set_bit(RDS_MR_DEAD, &mr->r_state))
-		return;
-
 	spin_lock_irqsave(&rs->rs_rdma_lock, flags);
 	if (!RB_EMPTY_NODE(&mr->r_rb_node))
 		rb_erase(&mr->r_rb_node, &rs->rs_rdma_keys);
@@ -140,7 +137,6 @@ void rds_rdma_drop_keys(struct rds_sock *rs)
 		rb_erase(&mr->r_rb_node, &rs->rs_rdma_keys);
 		RB_CLEAR_NODE(&mr->r_rb_node);
 		spin_unlock_irqrestore(&rs->rs_rdma_lock, flags);
-		rds_destroy_mr(mr);
 		rds_mr_put(mr);
 		spin_lock_irqsave(&rs->rs_rdma_lock, flags);
 	}
@@ -434,12 +430,6 @@ int rds_free_mr(struct rds_sock *rs, char __user *optval, int optlen)
 	if (!mr)
 		return -EINVAL;
 
-	/*
-	 * call rds_destroy_mr() ourselves so that we're sure it's done by the time
-	 * we return.  If we let rds_mr_put() do it it might not happen until
-	 * someone else drops their ref.
-	 */
-	rds_destroy_mr(mr);
 	rds_mr_put(mr);
 	return 0;
 }
@@ -464,6 +454,14 @@ void rds_rdma_unuse(struct rds_sock *rs, u32 r_key, int force)
 		return;
 	}
 
+	/* Get a reference so that the MR won't go away before calling
+	 * sync_mr() below.
+	 */
+	rds_mr_get(mr);
+
+	/* If it is going to be freed, remove it from the tree now so
+	 * that no other thread can find it and free it.
+	 */
 	if (mr->r_use_once || force) {
 		rb_erase(&mr->r_rb_node, &rs->rs_rdma_keys);
 		RB_CLEAR_NODE(&mr->r_rb_node);
@@ -477,12 +475,13 @@ void rds_rdma_unuse(struct rds_sock *rs, u32 r_key, int force)
 	if (mr->r_trans->sync_mr)
 		mr->r_trans->sync_mr(mr->r_trans_private, DMA_FROM_DEVICE);
 
+	/* Release the reference held above. */
+	rds_mr_put(mr);
+
 	/* If the MR was marked as invalidate, this will
 	 * trigger an async flush. */
-	if (zot_me) {
-		rds_destroy_mr(mr);
+	if (zot_me)
 		rds_mr_put(mr);
-	}
 }
 
 void rds_rdma_free_op(struct rm_rdma_op *ro)
diff --git a/net/rds/rds.h b/net/rds/rds.h
index 6a665fa..e889ef8 100644
--- a/net/rds/rds.h
+++ b/net/rds/rds.h
@@ -299,19 +299,11 @@ struct rds_mr {
 	unsigned int		r_invalidate:1;
 	unsigned int		r_write:1;
 
-	/* This is for RDS_MR_DEAD.
-	 * It would be nice & consistent to make this part of the above
-	 * bit field here, but we need to use test_and_set_bit.
-	 */
-	unsigned long		r_state;
 	struct rds_sock		*r_sock; /* back pointer to the socket that owns us */
 	struct rds_transport	*r_trans;
 	void			*r_trans_private;
 };
 
-/* Flags for mr->r_state */
-#define RDS_MR_DEAD		0
-
 static inline rds_rdma_cookie_t rds_rdma_make_cookie(u32 r_key, u32 offset)
 {
 	return r_key | (((u64) offset) << 32);
-- 
1.8.3.1

