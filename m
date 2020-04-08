Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09C8E1A1EAC
	for <lists+netdev@lfdr.de>; Wed,  8 Apr 2020 12:21:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728118AbgDHKVT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Apr 2020 06:21:19 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:56222 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726846AbgDHKVT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Apr 2020 06:21:19 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 038ADl2p118984;
        Wed, 8 Apr 2020 10:21:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : in-reply-to :
 references; s=corp-2020-01-29;
 bh=Si8Xwn0FubnhVinonnKQuwh07MeUhM45kQOJuneHLLk=;
 b=Jo46YrqEKqTH9WQCAaGjA+nOIjT+/CTCsF8bpYv+shsgewtix2XYWmJ0wyk9AtfZg5nk
 CZAcQ0qZumXNgNfQi3UXNPUMtOeTS2yCmK42c85nFLxXC8jY6TWkIjAXix3Pqr1ZBQly
 Mua8exRlBMWAcIuQqdnu6T+tGjDlgEU2LWpzJ6jh58nH/TiUEGsEbhiHOb7JsZGK29GT
 x3P5VGYXSLR5mtiDZ574wi1Rm0lqRhl4n3MQAiHhjcD7bU7XAsqVvPdyR4cy02FM97E2
 YkHmHQEAUUOpDV9iETA4uNOzP69QuxYEOUonAZfiC0vK5YlU6rRGmx/nUz9itHxUwpBe GQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 3091m0tm5w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Apr 2020 10:21:09 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 038ADNPN130956;
        Wed, 8 Apr 2020 10:21:08 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3030.oracle.com with ESMTP id 3091m0m81q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 08 Apr 2020 10:21:08 +0000
Received: from userp3030.oracle.com (userp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 038AL8HU152741;
        Wed, 8 Apr 2020 10:21:08 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 3091m0m80v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Apr 2020 10:21:07 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 038AL6TZ018097;
        Wed, 8 Apr 2020 10:21:06 GMT
Received: from ca-dev40.us.oracle.com (/10.129.135.27)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 08 Apr 2020 03:21:06 -0700
From:   Ka-Cheong Poon <ka-cheong.poon@oracle.com>
To:     netdev@vger.kernel.org
Cc:     santosh.shilimkar@oracle.com, davem@davemloft.net,
        rds-devel@oss.oracle.com, sironhide0null@gmail.com
Subject: [PATCH v2 net 2/2] net/rds: Fix MR reference counting problem
Date:   Wed,  8 Apr 2020 03:21:02 -0700
Message-Id: <76140548ff6c7ae75af0a7c4e6f585a061bd74a7.1586340235.git.ka-cheong.poon@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <fb149123516920dd5f5bf730a1da3a0cb9f3d25e.1586340235.git.ka-cheong.poon@oracle.com>
References: <fb149123516920dd5f5bf730a1da3a0cb9f3d25e.1586340235.git.ka-cheong.poon@oracle.com>
In-Reply-To: <fb149123516920dd5f5bf730a1da3a0cb9f3d25e.1586340235.git.ka-cheong.poon@oracle.com>
References: <fb149123516920dd5f5bf730a1da3a0cb9f3d25e.1586340235.git.ka-cheong.poon@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9584 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999 mlxscore=0
 priorityscore=1501 phishscore=0 suspectscore=3 bulkscore=0
 lowpriorityscore=0 impostorscore=0 malwarescore=0 clxscore=1015
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004080085
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
Acked-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>
---
 net/rds/rdma.c | 25 ++++++++++++-------------
 net/rds/rds.h  |  8 --------
 2 files changed, 12 insertions(+), 21 deletions(-)

diff --git a/net/rds/rdma.c b/net/rds/rdma.c
index f828b66..113e442 100644
--- a/net/rds/rdma.c
+++ b/net/rds/rdma.c
@@ -101,9 +101,6 @@ static void rds_destroy_mr(struct rds_mr *mr)
 	rdsdebug("RDS: destroy mr key is %x refcnt %u\n",
 		 mr->r_key, kref_read(&mr->r_kref));
 
-	if (test_and_set_bit(RDS_MR_DEAD, &mr->r_state))
-		return;
-
 	spin_lock_irqsave(&rs->rs_rdma_lock, flags);
 	if (!RB_EMPTY_NODE(&mr->r_rb_node))
 		rb_erase(&mr->r_rb_node, &rs->rs_rdma_keys);
@@ -142,7 +139,6 @@ void rds_rdma_drop_keys(struct rds_sock *rs)
 		rb_erase(&mr->r_rb_node, &rs->rs_rdma_keys);
 		RB_CLEAR_NODE(&mr->r_rb_node);
 		spin_unlock_irqrestore(&rs->rs_rdma_lock, flags);
-		rds_destroy_mr(mr);
 		kref_put(&mr->r_kref, __rds_put_mr_final);
 		spin_lock_irqsave(&rs->rs_rdma_lock, flags);
 	}
@@ -436,12 +432,6 @@ int rds_free_mr(struct rds_sock *rs, char __user *optval, int optlen)
 	if (!mr)
 		return -EINVAL;
 
-	/*
-	 * call rds_destroy_mr() ourselves so that we're sure it's done by the time
-	 * we return.  If we let rds_mr_put() do it it might not happen until
-	 * someone else drops their ref.
-	 */
-	rds_destroy_mr(mr);
 	kref_put(&mr->r_kref, __rds_put_mr_final);
 	return 0;
 }
@@ -466,6 +456,14 @@ void rds_rdma_unuse(struct rds_sock *rs, u32 r_key, int force)
 		return;
 	}
 
+	/* Get a reference so that the MR won't go away before calling
+	 * sync_mr() below.
+	 */
+	kref_get(&mr->r_kref);
+
+	/* If it is going to be freed, remove it from the tree now so
+	 * that no other thread can find it and free it.
+	 */
 	if (mr->r_use_once || force) {
 		rb_erase(&mr->r_rb_node, &rs->rs_rdma_keys);
 		RB_CLEAR_NODE(&mr->r_rb_node);
@@ -479,12 +477,13 @@ void rds_rdma_unuse(struct rds_sock *rs, u32 r_key, int force)
 	if (mr->r_trans->sync_mr)
 		mr->r_trans->sync_mr(mr->r_trans_private, DMA_FROM_DEVICE);
 
+	/* Release the reference held above. */
+	kref_put(&mr->r_kref, __rds_put_mr_final);
+
 	/* If the MR was marked as invalidate, this will
 	 * trigger an async flush. */
-	if (zot_me) {
-		rds_destroy_mr(mr);
+	if (zot_me)
 		kref_put(&mr->r_kref, __rds_put_mr_final);
-	}
 }
 
 void rds_rdma_free_op(struct rm_rdma_op *ro)
diff --git a/net/rds/rds.h b/net/rds/rds.h
index 3cda01c..8e18cd2 100644
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

