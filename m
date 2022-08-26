Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC2EF5A251E
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 11:53:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344156AbiHZJwh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 05:52:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245436AbiHZJwG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 05:52:06 -0400
Received: from out30-43.freemail.mail.aliyun.com (out30-43.freemail.mail.aliyun.com [115.124.30.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82C07D87E5;
        Fri, 26 Aug 2022 02:52:02 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046050;MF=alibuda@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0VNIjhU._1661507518;
Received: from localhost(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0VNIjhU._1661507518)
          by smtp.aliyun-inc.com;
          Fri, 26 Aug 2022 17:51:59 +0800
From:   "D. Wythe" <alibuda@linux.alibaba.com>
To:     kgraul@linux.ibm.com, wenjia@linux.ibm.com
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org,
        "D. Wythe" <alibuda@linux.alibaba.com>
Subject: [PATCH net-next v2 08/10] net/smc: replace mutex rmbs_lock and sndbufs_lock with rw_semaphore
Date:   Fri, 26 Aug 2022 17:51:35 +0800
Message-Id: <319276929a1307ff69d34ed6c34162c2fbd4ecaa.1661407821.git.alibuda@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <cover.1661407821.git.alibuda@linux.alibaba.com>
References: <cover.1661407821.git.alibuda@linux.alibaba.com>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "D. Wythe" <alibuda@linux.alibaba.com>

It's clear that rmbs_lock and sndbufs_lock are aims to protect the
rmbs list or the sndbufs list.

During connection establieshment, smc_buf_get_slot() will always
be invoked, and it only performs read semantics in rmbs list and
sndbufs list.

Based on the above considerations, we replace mutex with rw_semaphore.
Only smc_buf_get_slot() use down_read() to allow smc_buf_get_slot()
run concurrently, other part use down_write() to keep exclusive
semantics.

Signed-off-by: D. Wythe <alibuda@linux.alibaba.com>
---
 net/smc/smc_core.c | 55 +++++++++++++++++++++++++++---------------------------
 net/smc/smc_core.h |  4 ++--
 net/smc/smc_llc.c  | 16 ++++++++--------
 3 files changed, 38 insertions(+), 37 deletions(-)

diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index 1f66f14..84bf84c 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -1112,8 +1112,8 @@ static int smc_lgr_create(struct smc_sock *smc, struct smc_init_info *ini)
 	lgr->freeing = 0;
 	lgr->vlan_id = ini->vlan_id;
 	refcount_set(&lgr->refcnt, 1); /* set lgr refcnt to 1 */
-	mutex_init(&lgr->sndbufs_lock);
-	mutex_init(&lgr->rmbs_lock);
+	init_rwsem(&lgr->sndbufs_lock);
+	init_rwsem(&lgr->rmbs_lock);
 	rwlock_init(&lgr->conns_lock);
 	for (i = 0; i < SMC_RMBE_SIZES; i++) {
 		INIT_LIST_HEAD(&lgr->sndbufs[i]);
@@ -1354,7 +1354,7 @@ struct smc_link *smc_switch_conns(struct smc_link_group *lgr,
 static void smcr_buf_unuse(struct smc_buf_desc *buf_desc, bool is_rmb,
 			   struct smc_link_group *lgr)
 {
-	struct mutex *lock;	/* lock buffer list */
+	struct rw_semaphore *lock;	/* lock buffer list */
 	int rc;
 
 	if (is_rmb && buf_desc->is_conf_rkey && !list_empty(&lgr->list)) {
@@ -1374,9 +1374,9 @@ static void smcr_buf_unuse(struct smc_buf_desc *buf_desc, bool is_rmb,
 		/* buf registration failed, reuse not possible */
 		lock = is_rmb ? &lgr->rmbs_lock :
 				&lgr->sndbufs_lock;
-		mutex_lock(lock);
+		down_write(lock);
 		list_del(&buf_desc->list);
-		mutex_unlock(lock);
+		up_write(lock);
 
 		smc_buf_free(lgr, is_rmb, buf_desc);
 	} else {
@@ -1480,15 +1480,16 @@ static void smcr_buf_unmap_lgr(struct smc_link *lnk)
 	int i;
 
 	for (i = 0; i < SMC_RMBE_SIZES; i++) {
-		mutex_lock(&lgr->rmbs_lock);
+		down_write(&lgr->rmbs_lock);
 		list_for_each_entry_safe(buf_desc, bf, &lgr->rmbs[i], list)
 			smcr_buf_unmap_link(buf_desc, true, lnk);
-		mutex_unlock(&lgr->rmbs_lock);
-		mutex_lock(&lgr->sndbufs_lock);
+		up_write(&lgr->rmbs_lock);
+
+		down_write(&lgr->sndbufs_lock);
 		list_for_each_entry_safe(buf_desc, bf, &lgr->sndbufs[i],
 					 list)
 			smcr_buf_unmap_link(buf_desc, false, lnk);
-		mutex_unlock(&lgr->sndbufs_lock);
+		up_write(&lgr->sndbufs_lock);
 	}
 }
 
@@ -2310,19 +2311,19 @@ int smc_uncompress_bufsize(u8 compressed)
  * buffer size; if not available, return NULL
  */
 static struct smc_buf_desc *smc_buf_get_slot(int compressed_bufsize,
-					     struct mutex *lock,
+					     struct rw_semaphore *lock,
 					     struct list_head *buf_list)
 {
 	struct smc_buf_desc *buf_slot;
 
-	mutex_lock(lock);
+	down_read(lock);
 	list_for_each_entry(buf_slot, buf_list, list) {
 		if (cmpxchg(&buf_slot->used, 0, 1) == 0) {
-			mutex_unlock(lock);
+			up_read(lock);
 			return buf_slot;
 		}
 	}
-	mutex_unlock(lock);
+	up_read(lock);
 	return NULL;
 }
 
@@ -2431,13 +2432,13 @@ int smcr_link_reg_buf(struct smc_link *link, struct smc_buf_desc *buf_desc)
 	return 0;
 }
 
-static int _smcr_buf_map_lgr(struct smc_link *lnk, struct mutex *lock,
+static int _smcr_buf_map_lgr(struct smc_link *lnk, struct rw_semaphore *lock,
 			     struct list_head *lst, bool is_rmb)
 {
 	struct smc_buf_desc *buf_desc, *bf;
 	int rc = 0;
 
-	mutex_lock(lock);
+	down_write(lock);
 	list_for_each_entry_safe(buf_desc, bf, lst, list) {
 		if (!buf_desc->used)
 			continue;
@@ -2446,7 +2447,7 @@ static int _smcr_buf_map_lgr(struct smc_link *lnk, struct mutex *lock,
 			goto out;
 	}
 out:
-	mutex_unlock(lock);
+	up_write(lock);
 	return rc;
 }
 
@@ -2479,37 +2480,37 @@ int smcr_buf_reg_lgr(struct smc_link *lnk)
 	int i, rc = 0;
 
 	/* reg all RMBs for a new link */
-	mutex_lock(&lgr->rmbs_lock);
+	down_write(&lgr->rmbs_lock);
 	for (i = 0; i < SMC_RMBE_SIZES; i++) {
 		list_for_each_entry_safe(buf_desc, bf, &lgr->rmbs[i], list) {
 			if (!buf_desc->used)
 				continue;
 			rc = smcr_link_reg_buf(lnk, buf_desc);
 			if (rc) {
-				mutex_unlock(&lgr->rmbs_lock);
+				up_write(&lgr->rmbs_lock);
 				return rc;
 			}
 		}
 	}
-	mutex_unlock(&lgr->rmbs_lock);
+	up_write(&lgr->rmbs_lock);
 
 	if (lgr->buf_type == SMCR_PHYS_CONT_BUFS)
 		return rc;
 
 	/* reg all vzalloced sndbufs for a new link */
-	mutex_lock(&lgr->sndbufs_lock);
+	down_write(&lgr->sndbufs_lock);
 	for (i = 0; i < SMC_RMBE_SIZES; i++) {
 		list_for_each_entry_safe(buf_desc, bf, &lgr->sndbufs[i], list) {
 			if (!buf_desc->used || !buf_desc->is_vm)
 				continue;
 			rc = smcr_link_reg_buf(lnk, buf_desc);
 			if (rc) {
-				mutex_unlock(&lgr->sndbufs_lock);
+				up_write(&lgr->sndbufs_lock);
 				return rc;
 			}
 		}
 	}
-	mutex_unlock(&lgr->sndbufs_lock);
+	up_write(&lgr->sndbufs_lock);
 	return rc;
 }
 
@@ -2627,7 +2628,7 @@ static int __smc_buf_create(struct smc_sock *smc, bool is_smcd, bool is_rmb)
 	struct list_head *buf_list;
 	int bufsize, bufsize_short;
 	bool is_dgraded = false;
-	struct mutex *lock;	/* lock buffer list */
+	struct rw_semaphore *lock;	/* lock buffer list */
 	int sk_buf_size;
 
 	if (is_rmb)
@@ -2675,9 +2676,9 @@ static int __smc_buf_create(struct smc_sock *smc, bool is_smcd, bool is_rmb)
 		SMC_STAT_RMB_ALLOC(smc, is_smcd, is_rmb);
 		SMC_STAT_RMB_SIZE(smc, is_smcd, is_rmb, bufsize);
 		buf_desc->used = 1;
-		mutex_lock(lock);
+		down_write(lock);
 		list_add(&buf_desc->list, buf_list);
-		mutex_unlock(lock);
+		up_write(lock);
 		break; /* found */
 	}
 
@@ -2751,9 +2752,9 @@ int smc_buf_create(struct smc_sock *smc, bool is_smcd)
 	/* create rmb */
 	rc = __smc_buf_create(smc, is_smcd, true);
 	if (rc) {
-		mutex_lock(&smc->conn.lgr->sndbufs_lock);
+		down_write(&smc->conn.lgr->sndbufs_lock);
 		list_del(&smc->conn.sndbuf_desc->list);
-		mutex_unlock(&smc->conn.lgr->sndbufs_lock);
+		up_write(&smc->conn.lgr->sndbufs_lock);
 		smc_buf_free(smc->conn.lgr, false, smc->conn.sndbuf_desc);
 		smc->conn.sndbuf_desc = NULL;
 	}
diff --git a/net/smc/smc_core.h b/net/smc/smc_core.h
index 3035ddb..a501ed5 100644
--- a/net/smc/smc_core.h
+++ b/net/smc/smc_core.h
@@ -305,9 +305,9 @@ struct smc_link_group {
 	unsigned short		vlan_id;	/* vlan id of link group */
 
 	struct list_head	sndbufs[SMC_RMBE_SIZES];/* tx buffers */
-	struct mutex		sndbufs_lock;	/* protects tx buffers */
+	struct rw_semaphore	sndbufs_lock;	/* protects tx buffers */
 	struct list_head	rmbs[SMC_RMBE_SIZES];	/* rx buffers */
-	struct mutex		rmbs_lock;	/* protects rx buffers */
+	struct rw_semaphore	rmbs_lock;	/* protects rx buffers */
 
 	u8			id[SMC_LGR_ID_SIZE];	/* unique lgr id */
 	struct delayed_work	free_work;	/* delayed freeing of an lgr */
diff --git a/net/smc/smc_llc.c b/net/smc/smc_llc.c
index f563f95..61a24e1 100644
--- a/net/smc/smc_llc.c
+++ b/net/smc/smc_llc.c
@@ -642,7 +642,7 @@ static int smc_llc_fill_ext_v2(struct smc_llc_msg_add_link_v2_ext *ext,
 
 	prim_lnk_idx = link->link_idx;
 	lnk_idx = link_new->link_idx;
-	mutex_lock(&lgr->rmbs_lock);
+	down_write(&lgr->rmbs_lock);
 	ext->num_rkeys = lgr->conns_num;
 	if (!ext->num_rkeys)
 		goto out;
@@ -662,7 +662,7 @@ static int smc_llc_fill_ext_v2(struct smc_llc_msg_add_link_v2_ext *ext,
 	}
 	len += i * sizeof(ext->rt[0]);
 out:
-	mutex_unlock(&lgr->rmbs_lock);
+	up_write(&lgr->rmbs_lock);
 	return len;
 }
 
@@ -923,7 +923,7 @@ static int smc_llc_cli_rkey_exchange(struct smc_link *link,
 	int rc = 0;
 	int i;
 
-	mutex_lock(&lgr->rmbs_lock);
+	down_write(&lgr->rmbs_lock);
 	num_rkeys_send = lgr->conns_num;
 	buf_pos = smc_llc_get_first_rmb(lgr, &buf_lst);
 	do {
@@ -950,7 +950,7 @@ static int smc_llc_cli_rkey_exchange(struct smc_link *link,
 			break;
 	} while (num_rkeys_send || num_rkeys_recv);
 
-	mutex_unlock(&lgr->rmbs_lock);
+	up_write(&lgr->rmbs_lock);
 	return rc;
 }
 
@@ -1033,14 +1033,14 @@ static void smc_llc_save_add_link_rkeys(struct smc_link *link,
 	ext = (struct smc_llc_msg_add_link_v2_ext *)((u8 *)lgr->wr_rx_buf_v2 +
 						     SMC_WR_TX_SIZE);
 	max = min_t(u8, ext->num_rkeys, SMC_LLC_RKEYS_PER_MSG_V2);
-	mutex_lock(&lgr->rmbs_lock);
+	down_write(&lgr->rmbs_lock);
 	for (i = 0; i < max; i++) {
 		smc_rtoken_set(lgr, link->link_idx, link_new->link_idx,
 			       ext->rt[i].rmb_key,
 			       ext->rt[i].rmb_vaddr_new,
 			       ext->rt[i].rmb_key_new);
 	}
-	mutex_unlock(&lgr->rmbs_lock);
+	up_write(&lgr->rmbs_lock);
 }
 
 static void smc_llc_save_add_link_info(struct smc_link *link,
@@ -1349,7 +1349,7 @@ static int smc_llc_srv_rkey_exchange(struct smc_link *link,
 	int rc = 0;
 	int i;
 
-	mutex_lock(&lgr->rmbs_lock);
+	down_write(&lgr->rmbs_lock);
 	num_rkeys_send = lgr->conns_num;
 	buf_pos = smc_llc_get_first_rmb(lgr, &buf_lst);
 	do {
@@ -1374,7 +1374,7 @@ static int smc_llc_srv_rkey_exchange(struct smc_link *link,
 		smc_llc_flow_qentry_del(&lgr->llc_flow_lcl);
 	} while (num_rkeys_send || num_rkeys_recv);
 out:
-	mutex_unlock(&lgr->rmbs_lock);
+	up_write(&lgr->rmbs_lock);
 	return rc;
 }
 
-- 
1.8.3.1

