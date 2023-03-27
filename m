Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6B656C9A2B
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 05:30:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232311AbjC0DaC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Mar 2023 23:30:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232301AbjC0D3e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Mar 2023 23:29:34 -0400
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD8E75279;
        Sun, 26 Mar 2023 20:28:42 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R771e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046056;MF=guwen@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0Vef4At-_1679887717;
Received: from localhost(mailfrom:guwen@linux.alibaba.com fp:SMTPD_---0Vef4At-_1679887717)
          by smtp.aliyun-inc.com;
          Mon, 27 Mar 2023 11:28:39 +0800
From:   Wen Gu <guwen@linux.alibaba.com>
To:     kgraul@linux.ibm.com, wenjia@linux.ibm.com, jaka@linux.ibm.com,
        wintera@linux.ibm.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH net-next v4 9/9] net/smc: Add interface implementation of loopback device
Date:   Mon, 27 Mar 2023 11:28:19 +0800
Message-Id: <1679887699-54797-10-git-send-email-guwen@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1679887699-54797-1-git-send-email-guwen@linux.alibaba.com>
References: <1679887699-54797-1-git-send-email-guwen@linux.alibaba.com>
X-Spam-Status: No, score=-8.0 required=5.0 tests=ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
        USER_IN_DEF_SPF_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch completes the specific implementation of loopback device
for the newly added SMC-D DMB-related interface.

The loopback device always provides mappable DMB because the device
users are in the same OS instance.

Signed-off-by: Wen Gu <guwen@linux.alibaba.com>
---
 net/smc/smc_loopback.c | 101 +++++++++++++++++++++++++++++++++++++++++++++----
 net/smc/smc_loopback.h |   5 +++
 2 files changed, 98 insertions(+), 8 deletions(-)

diff --git a/net/smc/smc_loopback.c b/net/smc/smc_loopback.c
index 6ac5727..2e35cb5 100644
--- a/net/smc/smc_loopback.c
+++ b/net/smc/smc_loopback.c
@@ -74,6 +74,7 @@ static int smc_lo_register_dmb(struct smcd_dev *smcd, struct smcd_dmb *dmb,
 	}
 	dmb_node->len = dmb->dmb_len;
 	dmb_node->dma_addr = (dma_addr_t)dmb_node->cpu_addr;
+	refcount_set(&dmb_node->refcnt, 1);
 
 	/* TODO: token is random but not exclusive !
 	 * suppose to find token in dmb hask table, if has this token
@@ -84,6 +85,7 @@ static int smc_lo_register_dmb(struct smcd_dev *smcd, struct smcd_dmb *dmb,
 	write_lock(&ldev->dmb_ht_lock);
 	hash_add(ldev->dmb_ht, &dmb_node->list, dmb_node->token);
 	write_unlock(&ldev->dmb_ht_lock);
+	atomic_inc(&ldev->dmb_cnt);
 
 	dmb->sba_idx = dmb_node->sba_idx;
 	dmb->dmb_tok = dmb_node->token;
@@ -105,11 +107,12 @@ static int smc_lo_unregister_dmb(struct smcd_dev *smcd, struct smcd_dmb *dmb)
 	struct smc_lo_dmb_node *dmb_node = NULL, *tmp_node;
 	struct smc_lo_dev *ldev = smcd->priv;
 
-	/* remove dmb from hash table */
+	/* find dmb from hash table */
 	write_lock(&ldev->dmb_ht_lock);
 	hash_for_each_possible(ldev->dmb_ht, tmp_node, list, dmb->dmb_tok) {
 		if (tmp_node->token == dmb->dmb_tok) {
 			dmb_node = tmp_node;
+			dmb_node->freeing = 1;
 			break;
 		}
 	}
@@ -117,16 +120,85 @@ static int smc_lo_unregister_dmb(struct smcd_dev *smcd, struct smcd_dmb *dmb)
 		write_unlock(&ldev->dmb_ht_lock);
 		return -EINVAL;
 	}
+	write_unlock(&ldev->dmb_ht_lock);
+
+	/* wait for dmb refcnt to be 0 */
+	if (!refcount_dec_and_test(&dmb_node->refcnt))
+		wait_event(ldev->dmbs_release, !refcount_read(&dmb_node->refcnt));
+
+	/* remove dmb from hash table */
+	write_lock(&ldev->dmb_ht_lock);
 	hash_del(&dmb_node->list);
 	write_unlock(&ldev->dmb_ht_lock);
 
 	clear_bit(dmb_node->sba_idx, ldev->sba_idx_mask);
+
 	kfree(dmb_node->cpu_addr);
 	kfree(dmb_node);
 
+	if (atomic_dec_and_test(&ldev->dmb_cnt))
+		wake_up(&ldev->ldev_release);
 	return 0;
 }
 
+static int smc_lo_attach_dmb(struct smcd_dev *smcd, struct smcd_dmb *dmb)
+{
+	struct smc_lo_dmb_node *dmb_node = NULL, *tmp_node;
+	struct smc_lo_dev *ldev = smcd->priv;
+
+	/* find dmb_node according to dmb->dmb_tok */
+	read_lock(&ldev->dmb_ht_lock);
+	hash_for_each_possible(ldev->dmb_ht, tmp_node, list, dmb->dmb_tok) {
+		if (tmp_node->token == dmb->dmb_tok && !tmp_node->freeing) {
+			dmb_node = tmp_node;
+			break;
+		}
+	}
+	if (!dmb_node) {
+		read_unlock(&ldev->dmb_ht_lock);
+		return -EINVAL;
+	}
+	refcount_inc(&dmb_node->refcnt);
+	read_unlock(&ldev->dmb_ht_lock);
+
+	/* provide dmb information */
+	dmb->sba_idx = dmb_node->sba_idx;
+	dmb->dmb_tok = dmb_node->token;
+	dmb->cpu_addr = dmb_node->cpu_addr;
+	dmb->dma_addr = dmb_node->dma_addr;
+	dmb->dmb_len = dmb_node->len;
+	return 0;
+}
+
+static int smc_lo_detach_dmb(struct smcd_dev *smcd, u64 token)
+{
+	struct smc_lo_dmb_node *dmb_node = NULL, *tmp_node;
+	struct smc_lo_dev *ldev = smcd->priv;
+
+	/* find dmb_node according to dmb->dmb_tok */
+	read_lock(&ldev->dmb_ht_lock);
+	hash_for_each_possible(ldev->dmb_ht, tmp_node, list, token) {
+		if (tmp_node->token == token) {
+			dmb_node = tmp_node;
+			break;
+		}
+	}
+	if (!dmb_node) {
+		read_unlock(&ldev->dmb_ht_lock);
+		return -EINVAL;
+	}
+	read_unlock(&ldev->dmb_ht_lock);
+
+	if (refcount_dec_and_test(&dmb_node->refcnt))
+		wake_up_all(&ldev->dmbs_release);
+	return 0;
+}
+
+static int smc_lo_get_dev_dmb_attr(struct smcd_dev *smcd)
+{
+	return (1 << ISM_DMB_MAPPABLE);
+}
+
 static int smc_lo_add_vlan_id(struct smcd_dev *smcd, u64 vlan_id)
 {
 	return -EOPNOTSUPP;
@@ -153,7 +225,15 @@ static int smc_lo_move_data(struct smcd_dev *smcd, u64 dmb_tok, unsigned int idx
 {
 	struct smc_lo_dmb_node *rmb_node = NULL, *tmp_node;
 	struct smc_lo_dev *ldev = smcd->priv;
-
+	struct smc_connection *conn;
+
+	if (!sf) {
+		/* local sndbuf shares the same physical memory with
+		 * peer RMB, so no need to copy data from local sndbuf
+		 * to peer RMB.
+		 */
+		return 0;
+	}
 	read_lock(&ldev->dmb_ht_lock);
 	hash_for_each_possible(ldev->dmb_ht, tmp_node, list, dmb_tok) {
 		if (tmp_node->token == dmb_tok) {
@@ -169,13 +249,10 @@ static int smc_lo_move_data(struct smcd_dev *smcd, u64 dmb_tok, unsigned int idx
 
 	memcpy((char *)rmb_node->cpu_addr + offset, data, size);
 
-	if (sf) {
-		struct smc_connection *conn =
-			smcd->conn[rmb_node->sba_idx];
+	conn = smcd->conn[rmb_node->sba_idx];
+	if (conn && !conn->killed)
+		smcd_cdc_rx_handler(conn);
 
-		if (conn && !conn->killed)
-			smcd_cdc_rx_handler(conn);
-	}
 	return 0;
 }
 
@@ -208,6 +285,8 @@ static struct device *smc_lo_get_dev(struct smcd_dev *smcd)
 	.query_remote_gid = smc_lo_query_rgid,
 	.register_dmb = smc_lo_register_dmb,
 	.unregister_dmb = smc_lo_unregister_dmb,
+	.attach_dmb = smc_lo_attach_dmb,
+	.detach_dmb = smc_lo_detach_dmb,
 	.add_vlan_id = smc_lo_add_vlan_id,
 	.del_vlan_id = smc_lo_del_vlan_id,
 	.set_vlan_required = smc_lo_set_vlan_required,
@@ -219,6 +298,7 @@ static struct device *smc_lo_get_dev(struct smcd_dev *smcd)
 	.get_local_gid = smc_lo_get_local_gid,
 	.get_chid = smc_lo_get_chid,
 	.get_dev = smc_lo_get_dev,
+	.get_dev_dmb_attr = smc_lo_get_dev_dmb_attr,
 };
 
 static struct smcd_dev *smcd_lo_alloc_dev(const struct smcd_ops *ops,
@@ -299,6 +379,9 @@ static int smc_lo_dev_init(struct smc_lo_dev *ldev)
 	smc_lo_gen_id(ldev);
 	rwlock_init(&ldev->dmb_ht_lock);
 	hash_init(ldev->dmb_ht);
+	atomic_set(&ldev->dmb_cnt, 0);
+	init_waitqueue_head(&ldev->dmbs_release);
+	init_waitqueue_head(&ldev->ldev_release);
 
 	return smcd_lo_register_dev(ldev);
 }
@@ -337,6 +420,8 @@ static int smc_lo_dev_probe(void)
 static void smc_lo_dev_exit(struct smc_lo_dev *ldev)
 {
 	smcd_lo_unregister_dev(ldev);
+	if (atomic_read(&ldev->dmb_cnt))
+		wait_event(ldev->ldev_release, !atomic_read(&ldev->dmb_cnt));
 }
 
 static void smc_lo_dev_remove(void)
diff --git a/net/smc/smc_loopback.h b/net/smc/smc_loopback.h
index 9d34aba..e0bf044 100644
--- a/net/smc/smc_loopback.h
+++ b/net/smc/smc_loopback.h
@@ -33,6 +33,8 @@ struct smc_lo_dmb_node {
 	u32 sba_idx;
 	void *cpu_addr;
 	dma_addr_t dma_addr;
+	refcount_t refcnt;
+	u8 freeing : 1;
 };
 
 struct smc_lo_dev {
@@ -43,6 +45,9 @@ struct smc_lo_dev {
 	DECLARE_BITMAP(sba_idx_mask, SMC_LODEV_MAX_DMBS);
 	rwlock_t dmb_ht_lock;
 	DECLARE_HASHTABLE(dmb_ht, SMC_LODEV_MAX_DMBS_BUCKETS);
+	atomic_t dmb_cnt;
+	wait_queue_head_t dmbs_release;
+	wait_queue_head_t ldev_release;
 };
 
 int smc_loopback_init(void);
-- 
1.8.3.1

