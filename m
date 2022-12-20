Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 735AC651993
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 04:22:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232912AbiLTDW1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Dec 2022 22:22:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233079AbiLTDWF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Dec 2022 22:22:05 -0500
Received: from out30-8.freemail.mail.aliyun.com (out30-8.freemail.mail.aliyun.com [115.124.30.8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1548813CFB;
        Mon, 19 Dec 2022 19:22:02 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045192;MF=guwen@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0VXjTtLD_1671506518;
Received: from localhost(mailfrom:guwen@linux.alibaba.com fp:SMTPD_---0VXjTtLD_1671506518)
          by smtp.aliyun-inc.com;
          Tue, 20 Dec 2022 11:22:00 +0800
From:   Wen Gu <guwen@linux.alibaba.com>
To:     kgraul@linux.ibm.com, wenjia@linux.ibm.com, jaka@linux.ibm.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH net-next v2 3/5] net/smc: add dmb attach and detach interface
Date:   Tue, 20 Dec 2022 11:21:43 +0800
Message-Id: <1671506505-104676-4-git-send-email-guwen@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1671506505-104676-1-git-send-email-guwen@linux.alibaba.com>
References: <1671506505-104676-1-git-send-email-guwen@linux.alibaba.com>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch extends smcd_ops, adding two more semantic for
SMC-D device:

- attach_dmb:

  Attach an already registered dmb to a specific buf_desc,
  so that we can refer to the dmb through this buf_desc.

- detach_dmb:

  Reverse operation of attach_dmb. detach the dmb from the
  buf_desc.

This interface extension is to prepare for the reduction
of data moving from sndbuf to RMB in SMC-D loopback device.

Signed-off-by: Wen Gu <guwen@linux.alibaba.com>
---
 include/net/smc.h      |  2 ++
 net/smc/smc_ism.c      | 36 ++++++++++++++++++++++++++
 net/smc/smc_ism.h      |  2 ++
 net/smc/smc_loopback.c | 69 ++++++++++++++++++++++++++++++++++++++++++++++++++
 net/smc/smc_loopback.h |  4 +++
 5 files changed, 113 insertions(+)

diff --git a/include/net/smc.h b/include/net/smc.h
index 7699f97..60a96f7 100644
--- a/include/net/smc.h
+++ b/include/net/smc.h
@@ -63,6 +63,8 @@ struct smcd_ops {
 				u32 vid);
 	int (*register_dmb)(struct smcd_dev *dev, struct smcd_dmb *dmb);
 	int (*unregister_dmb)(struct smcd_dev *dev, struct smcd_dmb *dmb);
+	int (*attach_dmb)(struct smcd_dev *dev, struct smcd_dmb *dmb);
+	int (*detach_dmb)(struct smcd_dev *dev, u64 token);
 	int (*add_vlan_id)(struct smcd_dev *dev, u64 vlan_id);
 	int (*del_vlan_id)(struct smcd_dev *dev, u64 vlan_id);
 	int (*set_vlan_required)(struct smcd_dev *dev);
diff --git a/net/smc/smc_ism.c b/net/smc/smc_ism.c
index 1d10435..2049388 100644
--- a/net/smc/smc_ism.c
+++ b/net/smc/smc_ism.c
@@ -202,6 +202,42 @@ int smc_ism_register_dmb(struct smc_link_group *lgr, int dmb_len,
 	return rc;
 }
 
+int smc_ism_attach_dmb(struct smcd_dev *dev, u64 token,
+		       struct smc_buf_desc *dmb_desc)
+{
+	struct smcd_dmb dmb;
+	int rc = 0;
+
+	memset(&dmb, 0, sizeof(dmb));
+	dmb.dmb_tok = token;
+
+	/* only support loopback device now */
+	if (!dev->is_loopback)
+		return -EINVAL;
+	if (!dev->ops->attach_dmb)
+		return -EINVAL;
+
+	rc = dev->ops->attach_dmb(dev, &dmb);
+	if (!rc) {
+		dmb_desc->sba_idx = dmb.sba_idx;
+		dmb_desc->token = dmb.dmb_tok;
+		dmb_desc->cpu_addr = dmb.cpu_addr;
+		dmb_desc->dma_addr = dmb.dma_addr;
+		dmb_desc->len = dmb.dmb_len;
+	}
+	return rc;
+}
+
+int smc_ism_detach_dmb(struct smcd_dev *dev, u64 token)
+{
+	if (!dev->is_loopback)
+		return -EINVAL;
+	if (!dev->ops->detach_dmb)
+		return -EINVAL;
+
+	return dev->ops->detach_dmb(dev, token);
+}
+
 static int smc_nl_handle_smcd_dev(struct smcd_dev *smcd,
 				  struct sk_buff *skb,
 				  struct netlink_callback *cb)
diff --git a/net/smc/smc_ism.h b/net/smc/smc_ism.h
index d6b2db6..9022979 100644
--- a/net/smc/smc_ism.h
+++ b/net/smc/smc_ism.h
@@ -38,6 +38,8 @@ struct smc_ism_vlanid {			/* VLAN id set on ISM device */
 int smc_ism_register_dmb(struct smc_link_group *lgr, int buf_size,
 			 struct smc_buf_desc *dmb_desc);
 int smc_ism_unregister_dmb(struct smcd_dev *dev, struct smc_buf_desc *dmb_desc);
+int smc_ism_attach_dmb(struct smcd_dev *dev, u64 token, struct smc_buf_desc *dmb_desc);
+int smc_ism_detach_dmb(struct smcd_dev *dev, u64 token);
 int smc_ism_signal_shutdown(struct smc_link_group *lgr);
 void smc_ism_get_system_eid(u8 **eid);
 u16 smc_ism_get_chid(struct smcd_dev *dev);
diff --git a/net/smc/smc_loopback.c b/net/smc/smc_loopback.c
index 973382a..bc3ff82 100644
--- a/net/smc/smc_loopback.c
+++ b/net/smc/smc_loopback.c
@@ -68,6 +68,7 @@ static int lo_register_dmb(struct smcd_dev *smcd, struct smcd_dmb *dmb)
 		goto err_node;
 	}
 	dmb_node->len = dmb->dmb_len;
+	refcount_set(&dmb_node->refcnt, 1);
 
 	/* TODO: token is random but not exclusive !
 	 * suppose to find token in dmb hask table, if has this token
@@ -78,6 +79,7 @@ static int lo_register_dmb(struct smcd_dev *smcd, struct smcd_dmb *dmb)
 	write_lock(&ldev->dmb_ht_lock);
 	hash_add(ldev->dmb_ht, &dmb_node->list, dmb_node->token);
 	write_unlock(&ldev->dmb_ht_lock);
+	atomic_inc(&ldev->dmb_cnt);
 
 	dmb->sba_idx = dmb_node->sba_idx;
 	dmb->dmb_tok = dmb_node->token;
@@ -115,9 +117,69 @@ static int lo_unregister_dmb(struct smcd_dev *smcd, struct smcd_dmb *dmb)
 	write_unlock(&ldev->dmb_ht_lock);
 
 	clear_bit(dmb_node->sba_idx, ldev->sba_idx_mask);
+
+	/* wait for dmb refcnt equal to 0 */
+	if (!refcount_dec_and_test(&dmb_node->refcnt))
+		wait_event(ldev->dmbs_release, !refcount_read(&dmb_node->refcnt));
 	kfree(dmb_node->cpu_addr);
 	kfree(dmb_node);
 
+	if (atomic_dec_and_test(&ldev->dmb_cnt))
+		wake_up(&ldev->ldev_release);
+
+	return 0;
+}
+
+static int lo_attach_dmb(struct smcd_dev *smcd, struct smcd_dmb *dmb)
+{
+	struct lo_dmb_node *dmb_node = NULL, *tmp_node;
+	struct lo_dev *ldev = smcd->priv;
+
+	/* find dmb_node according to dmb->dmb_tok */
+	read_lock(&ldev->dmb_ht_lock);
+	hash_for_each_possible(ldev->dmb_ht, tmp_node, list, dmb->dmb_tok) {
+		if (tmp_node->token == dmb->dmb_tok) {
+			dmb_node = tmp_node;
+			break;
+		}
+	}
+	if (!dmb_node) {
+		read_unlock(&ldev->dmb_ht_lock);
+		return -EINVAL;
+	}
+	read_unlock(&ldev->dmb_ht_lock);
+	refcount_inc(&dmb_node->refcnt);
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
+static int lo_detach_dmb(struct smcd_dev *smcd, u64 token)
+{
+	struct lo_dmb_node *dmb_node = NULL, *tmp_node;
+	struct lo_dev *ldev = smcd->priv;
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
 	return 0;
 }
 
@@ -193,6 +255,8 @@ static u16 lo_get_chid(struct smcd_dev *smcd)
 	.query_remote_gid = lo_query_rgid,
 	.register_dmb = lo_register_dmb,
 	.unregister_dmb = lo_unregister_dmb,
+	.attach_dmb = lo_attach_dmb,
+	.detach_dmb = lo_detach_dmb,
 	.add_vlan_id = lo_add_vlan_id,
 	.del_vlan_id = lo_del_vlan_id,
 	.set_vlan_required = lo_set_vlan_required,
@@ -218,6 +282,9 @@ static int lo_dev_init(struct lo_dev *ldev)
 	ldev->lgid = smcd->local_gid;
 	rwlock_init(&ldev->dmb_ht_lock);
 	hash_init(ldev->dmb_ht);
+	atomic_set(&ldev->dmb_cnt, 0);
+	init_waitqueue_head(&ldev->dmbs_release);
+	init_waitqueue_head(&ldev->ldev_release);
 
 	return smcd_register_dev(smcd);
 }
@@ -255,6 +322,8 @@ static int lo_dev_probe(void)
 static void lo_dev_exit(struct lo_dev *ldev)
 {
 	smcd_unregister_dev(ldev->smcd);
+	if (atomic_read(&ldev->dmb_cnt))
+		wait_event(ldev->ldev_release, !atomic_read(&ldev->dmb_cnt));
 }
 
 static void lo_dev_remove(void)
diff --git a/net/smc/smc_loopback.h b/net/smc/smc_loopback.h
index d7f7815..f4122be 100644
--- a/net/smc/smc_loopback.h
+++ b/net/smc/smc_loopback.h
@@ -32,6 +32,7 @@ struct lo_dmb_node {
 	u32 sba_idx;
 	void *cpu_addr;
 	dma_addr_t dma_addr;
+	refcount_t refcnt;
 };
 
 struct lo_dev {
@@ -41,6 +42,9 @@ struct lo_dev {
 	DECLARE_BITMAP(sba_idx_mask, LODEV_MAX_DMBS);
 	rwlock_t dmb_ht_lock;
 	DECLARE_HASHTABLE(dmb_ht, LODEV_MAX_DMBS_BUCKETS);
+	atomic_t dmb_cnt;
+	wait_queue_head_t dmbs_release;
+	wait_queue_head_t ldev_release;
 };
 
 struct lo_systemeid {
-- 
1.8.3.1

