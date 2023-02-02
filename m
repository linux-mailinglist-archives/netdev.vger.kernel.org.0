Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2F42687759
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 09:27:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232102AbjBBI1I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 03:27:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232113AbjBBI1E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 03:27:04 -0500
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C4B621971;
        Thu,  2 Feb 2023 00:27:02 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045170;MF=alibuda@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0Vak2b-p_1675326419;
Received: from j66a10360.sqa.eu95.tbsite.net(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0Vak2b-p_1675326419)
          by smtp.aliyun-inc.com;
          Thu, 02 Feb 2023 16:26:59 +0800
From:   "D. Wythe" <alibuda@linux.alibaba.com>
To:     kgraul@linux.ibm.com, wenjia@linux.ibm.com, jaka@linux.ibm.com
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org,
        "D. Wythe" <alibuda@linux.alibaba.com>
Subject: [net-next v7 1/4] net/smc: llc_conf_mutex refactor, replace it with rw_semaphore
Date:   Thu,  2 Feb 2023 16:26:39 +0800
Message-Id: <1675326402-109943-2-git-send-email-alibuda@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1675326402-109943-1-git-send-email-alibuda@linux.alibaba.com>
References: <1675326402-109943-1-git-send-email-alibuda@linux.alibaba.com>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "D. Wythe" <alibuda@linux.alibaba.com>

llc_conf_mutex was used to protect links and link related configurations
in the same link group, for example, add or delete links. However,
in most cases, the protected critical area has only read semantics and
with no write semantics at all, such as obtaining a usable link or an
available rmb_desc.

This patch do simply code refactoring, replace mutex with rw_semaphore,
replace mutex_lock with down_write and replace mutex_unlock with
up_write.

Theoretically, this replacement is equivalent, but after this patch,
we can distinguish lock granularity according to different semantics
of critical areas.

Signed-off-by: D. Wythe <alibuda@linux.alibaba.com>
---
 net/smc/af_smc.c   |  8 ++++----
 net/smc/smc_core.c | 20 ++++++++++----------
 net/smc/smc_core.h |  2 +-
 net/smc/smc_llc.c  | 18 +++++++++---------
 4 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 1c0fe9b..6e93ad6 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -502,7 +502,7 @@ static int smcr_lgr_reg_sndbufs(struct smc_link *link,
 		return -EINVAL;
 
 	/* protect against parallel smcr_link_reg_buf() */
-	mutex_lock(&lgr->llc_conf_mutex);
+	down_write(&lgr->llc_conf_mutex);
 	for (i = 0; i < SMC_LINKS_PER_LGR_MAX; i++) {
 		if (!smc_link_active(&lgr->lnk[i]))
 			continue;
@@ -510,7 +510,7 @@ static int smcr_lgr_reg_sndbufs(struct smc_link *link,
 		if (rc)
 			break;
 	}
-	mutex_unlock(&lgr->llc_conf_mutex);
+	up_write(&lgr->llc_conf_mutex);
 	return rc;
 }
 
@@ -527,7 +527,7 @@ static int smcr_lgr_reg_rmbs(struct smc_link *link,
 	/* protect against parallel smc_llc_cli_rkey_exchange() and
 	 * parallel smcr_link_reg_buf()
 	 */
-	mutex_lock(&lgr->llc_conf_mutex);
+	down_write(&lgr->llc_conf_mutex);
 	for (i = 0; i < SMC_LINKS_PER_LGR_MAX; i++) {
 		if (!smc_link_active(&lgr->lnk[i]))
 			continue;
@@ -544,7 +544,7 @@ static int smcr_lgr_reg_rmbs(struct smc_link *link,
 	}
 	rmb_desc->is_conf_rkey = true;
 out:
-	mutex_unlock(&lgr->llc_conf_mutex);
+	up_write(&lgr->llc_conf_mutex);
 	smc_llc_flow_stop(lgr, &lgr->llc_flow_lcl);
 	return rc;
 }
diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index 7642b16..22ddce6 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -1106,10 +1106,10 @@ static void smcr_buf_unuse(struct smc_buf_desc *buf_desc, bool is_rmb,
 		rc = smc_llc_flow_initiate(lgr, SMC_LLC_FLOW_RKEY);
 		if (!rc) {
 			/* protect against smc_llc_cli_rkey_exchange() */
-			mutex_lock(&lgr->llc_conf_mutex);
+			down_write(&lgr->llc_conf_mutex);
 			smc_llc_do_delete_rkey(lgr, buf_desc);
 			buf_desc->is_conf_rkey = false;
-			mutex_unlock(&lgr->llc_conf_mutex);
+			up_write(&lgr->llc_conf_mutex);
 			smc_llc_flow_stop(lgr, &lgr->llc_flow_lcl);
 		}
 	}
@@ -1377,12 +1377,12 @@ static void smc_lgr_free(struct smc_link_group *lgr)
 	int i;
 
 	if (!lgr->is_smcd) {
-		mutex_lock(&lgr->llc_conf_mutex);
+		down_write(&lgr->llc_conf_mutex);
 		for (i = 0; i < SMC_LINKS_PER_LGR_MAX; i++) {
 			if (lgr->lnk[i].state != SMC_LNK_UNUSED)
 				smcr_link_clear(&lgr->lnk[i], false);
 		}
-		mutex_unlock(&lgr->llc_conf_mutex);
+		up_write(&lgr->llc_conf_mutex);
 		smc_llc_lgr_clear(lgr);
 	}
 
@@ -1696,12 +1696,12 @@ static void smcr_link_down(struct smc_link *lnk)
 	} else {
 		if (lgr->llc_flow_lcl.type != SMC_LLC_FLOW_NONE) {
 			/* another llc task is ongoing */
-			mutex_unlock(&lgr->llc_conf_mutex);
+			up_write(&lgr->llc_conf_mutex);
 			wait_event_timeout(lgr->llc_flow_waiter,
 				(list_empty(&lgr->list) ||
 				 lgr->llc_flow_lcl.type == SMC_LLC_FLOW_NONE),
 				SMC_LLC_WAIT_TIME);
-			mutex_lock(&lgr->llc_conf_mutex);
+			down_write(&lgr->llc_conf_mutex);
 		}
 		if (!list_empty(&lgr->list)) {
 			smc_llc_send_delete_link(to_lnk, del_link_id,
@@ -1761,9 +1761,9 @@ static void smc_link_down_work(struct work_struct *work)
 	if (list_empty(&lgr->list))
 		return;
 	wake_up_all(&lgr->llc_msg_waiter);
-	mutex_lock(&lgr->llc_conf_mutex);
+	down_write(&lgr->llc_conf_mutex);
 	smcr_link_down(link);
-	mutex_unlock(&lgr->llc_conf_mutex);
+	up_write(&lgr->llc_conf_mutex);
 }
 
 static int smc_vlan_by_tcpsk_walk(struct net_device *lower_dev,
@@ -2247,7 +2247,7 @@ static int smcr_buf_map_usable_links(struct smc_link_group *lgr,
 	int i, rc = 0, cnt = 0;
 
 	/* protect against parallel link reconfiguration */
-	mutex_lock(&lgr->llc_conf_mutex);
+	down_write(&lgr->llc_conf_mutex);
 	for (i = 0; i < SMC_LINKS_PER_LGR_MAX; i++) {
 		struct smc_link *lnk = &lgr->lnk[i];
 
@@ -2260,7 +2260,7 @@ static int smcr_buf_map_usable_links(struct smc_link_group *lgr,
 		cnt++;
 	}
 out:
-	mutex_unlock(&lgr->llc_conf_mutex);
+	up_write(&lgr->llc_conf_mutex);
 	if (!rc && !cnt)
 		rc = -EINVAL;
 	return rc;
diff --git a/net/smc/smc_core.h b/net/smc/smc_core.h
index 285f9bd..bd7198b 100644
--- a/net/smc/smc_core.h
+++ b/net/smc/smc_core.h
@@ -298,7 +298,7 @@ struct smc_link_group {
 						/* queue for llc events */
 			spinlock_t		llc_event_q_lock;
 						/* protects llc_event_q */
-			struct mutex		llc_conf_mutex;
+			struct rw_semaphore	llc_conf_mutex;
 						/* protects lgr reconfig. */
 			struct work_struct	llc_add_link_work;
 			struct work_struct	llc_del_link_work;
diff --git a/net/smc/smc_llc.c b/net/smc/smc_llc.c
index 524649d..c0e73e4 100644
--- a/net/smc/smc_llc.c
+++ b/net/smc/smc_llc.c
@@ -1202,12 +1202,12 @@ static void smc_llc_process_cli_add_link(struct smc_link_group *lgr)
 
 	qentry = smc_llc_flow_qentry_clr(&lgr->llc_flow_lcl);
 
-	mutex_lock(&lgr->llc_conf_mutex);
+	down_write(&lgr->llc_conf_mutex);
 	if (smc_llc_is_local_add_link(&qentry->msg))
 		smc_llc_cli_add_link_invite(qentry->link, qentry);
 	else
 		smc_llc_cli_add_link(qentry->link, qentry);
-	mutex_unlock(&lgr->llc_conf_mutex);
+	up_write(&lgr->llc_conf_mutex);
 }
 
 static int smc_llc_active_link_count(struct smc_link_group *lgr)
@@ -1509,13 +1509,13 @@ static void smc_llc_process_srv_add_link(struct smc_link_group *lgr)
 
 	qentry = smc_llc_flow_qentry_clr(&lgr->llc_flow_lcl);
 
-	mutex_lock(&lgr->llc_conf_mutex);
+	down_write(&lgr->llc_conf_mutex);
 	rc = smc_llc_srv_add_link(link, qentry);
 	if (!rc && lgr->type == SMC_LGR_SYMMETRIC) {
 		/* delete any asymmetric link */
 		smc_llc_delete_asym_link(lgr);
 	}
-	mutex_unlock(&lgr->llc_conf_mutex);
+	up_write(&lgr->llc_conf_mutex);
 	kfree(qentry);
 }
 
@@ -1582,7 +1582,7 @@ static void smc_llc_process_cli_delete_link(struct smc_link_group *lgr)
 		smc_lgr_terminate_sched(lgr);
 		goto out;
 	}
-	mutex_lock(&lgr->llc_conf_mutex);
+	down_write(&lgr->llc_conf_mutex);
 	/* delete single link */
 	for (lnk_idx = 0; lnk_idx < SMC_LINKS_PER_LGR_MAX; lnk_idx++) {
 		if (lgr->lnk[lnk_idx].link_id != del_llc->link_num)
@@ -1616,7 +1616,7 @@ static void smc_llc_process_cli_delete_link(struct smc_link_group *lgr)
 		smc_lgr_terminate_sched(lgr);
 	}
 out_unlock:
-	mutex_unlock(&lgr->llc_conf_mutex);
+	up_write(&lgr->llc_conf_mutex);
 out:
 	kfree(qentry);
 }
@@ -1652,7 +1652,7 @@ static void smc_llc_process_srv_delete_link(struct smc_link_group *lgr)
 	int active_links;
 	int i;
 
-	mutex_lock(&lgr->llc_conf_mutex);
+	down_write(&lgr->llc_conf_mutex);
 	qentry = smc_llc_flow_qentry_clr(&lgr->llc_flow_lcl);
 	lnk = qentry->link;
 	del_llc = &qentry->msg.delete_link;
@@ -1708,7 +1708,7 @@ static void smc_llc_process_srv_delete_link(struct smc_link_group *lgr)
 		smc_llc_add_link_local(lnk);
 	}
 out:
-	mutex_unlock(&lgr->llc_conf_mutex);
+	up_write(&lgr->llc_conf_mutex);
 	kfree(qentry);
 }
 
@@ -2126,7 +2126,7 @@ void smc_llc_lgr_init(struct smc_link_group *lgr, struct smc_sock *smc)
 	spin_lock_init(&lgr->llc_flow_lock);
 	init_waitqueue_head(&lgr->llc_flow_waiter);
 	init_waitqueue_head(&lgr->llc_msg_waiter);
-	mutex_init(&lgr->llc_conf_mutex);
+	init_rwsem(&lgr->llc_conf_mutex);
 	lgr->llc_testlink_time = READ_ONCE(net->smc.sysctl_smcr_testlink_time);
 }
 
-- 
1.8.3.1

