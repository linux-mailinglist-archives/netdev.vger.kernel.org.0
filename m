Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A549C60579A
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 08:44:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230207AbiJTGoN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 02:44:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230281AbiJTGoE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 02:44:04 -0400
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EEFC190E55;
        Wed, 19 Oct 2022 23:44:01 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045192;MF=alibuda@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0VSdzyIX_1666248239;
Received: from j66a10360.sqa.eu95.tbsite.net(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0VSdzyIX_1666248239)
          by smtp.aliyun-inc.com;
          Thu, 20 Oct 2022 14:43:59 +0800
From:   "D.Wythe" <alibuda@linux.alibaba.com>
To:     kgraul@linux.ibm.com, wenjia@linux.ibm.com, jaka@linux.ibm.com
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: [PATCH net-next v3 04/10] net/smc: make SMC_LLC_FLOW_RKEY run concurrently
Date:   Thu, 20 Oct 2022 14:43:46 +0800
Message-Id: <1666248232-63751-5-git-send-email-alibuda@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1666248232-63751-1-git-send-email-alibuda@linux.alibaba.com>
References: <1666248232-63751-1-git-send-email-alibuda@linux.alibaba.com>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "D. Wythe" <alibuda@linux.alibaba.com>

Once confirm/delete rkey response can be multiplex delivered,
We can allow parallel execution of start (remote) or
initialization (local) a SMC_LLC_FLOW_RKEY flow.

This patch will count the flows executed in parallel, and only when
the count reaches zero will the current flow type be removed.

Signed-off-by: D. Wythe <alibuda@linux.alibaba.com>
---
 net/smc/smc_core.h |  1 +
 net/smc/smc_llc.c  | 69 +++++++++++++++++++++++++++++++++++++++++-------------
 net/smc/smc_llc.h  |  6 +++++
 3 files changed, 60 insertions(+), 16 deletions(-)

diff --git a/net/smc/smc_core.h b/net/smc/smc_core.h
index dae2983..234d213 100644
--- a/net/smc/smc_core.h
+++ b/net/smc/smc_core.h
@@ -244,6 +244,7 @@ enum smc_llc_flowtype {
 struct smc_llc_flow {
 	enum smc_llc_flowtype type;
 	struct smc_llc_qentry *qentry;
+	refcount_t	parallel_refcnt;
 };
 
 struct smc_lgr_decision_maker;
diff --git a/net/smc/smc_llc.c b/net/smc/smc_llc.c
index 24f9488..700129c 100644
--- a/net/smc/smc_llc.c
+++ b/net/smc/smc_llc.c
@@ -231,10 +231,18 @@ static inline void smc_llc_flow_qentry_set(struct smc_llc_flow *flow,
 	flow->qentry = qentry;
 }
 
-static void smc_llc_flow_parallel(struct smc_link_group *lgr, u8 flow_type,
+static void smc_llc_flow_parallel(struct smc_link_group *lgr, struct smc_llc_flow *flow,
 				  struct smc_llc_qentry *qentry)
 {
 	u8 msg_type = qentry->msg.raw.hdr.common.llc_type;
+	u8 flow_type = flow->type;
+
+	/* SMC_LLC_FLOW_RKEY can be parallel */
+	if (flow_type == SMC_LLC_FLOW_RKEY &&
+	    (msg_type == SMC_LLC_CONFIRM_RKEY || msg_type == SMC_LLC_DELETE_RKEY)) {
+		refcount_inc(&flow->parallel_refcnt);
+		return;
+	}
 
 	if ((msg_type == SMC_LLC_ADD_LINK || msg_type == SMC_LLC_DELETE_LINK) &&
 	    flow_type != msg_type && !lgr->delayed_event) {
@@ -261,7 +269,7 @@ static bool smc_llc_flow_start(struct smc_llc_flow *flow,
 	spin_lock_bh(&lgr->llc_flow_lock);
 	if (flow->type) {
 		/* a flow is already active */
-		smc_llc_flow_parallel(lgr, flow->type, qentry);
+		smc_llc_flow_parallel(lgr, flow, qentry);
 		spin_unlock_bh(&lgr->llc_flow_lock);
 		return false;
 	}
@@ -280,6 +288,7 @@ static bool smc_llc_flow_start(struct smc_llc_flow *flow,
 		flow->type = SMC_LLC_FLOW_NONE;
 	}
 	smc_llc_flow_qentry_set(flow, qentry);
+	refcount_set(&flow->parallel_refcnt, 1);
 	spin_unlock_bh(&lgr->llc_flow_lock);
 	return true;
 }
@@ -289,6 +298,7 @@ int smc_llc_flow_initiate(struct smc_link_group *lgr,
 			  enum smc_llc_flowtype type)
 {
 	enum smc_llc_flowtype allowed_remote = SMC_LLC_FLOW_NONE;
+	bool accept = false;
 	int rc;
 
 	/* all flows except confirm_rkey and delete_rkey are exclusive,
@@ -300,10 +310,39 @@ int smc_llc_flow_initiate(struct smc_link_group *lgr,
 	if (list_empty(&lgr->list))
 		return -ENODEV;
 	spin_lock_bh(&lgr->llc_flow_lock);
-	if (lgr->llc_flow_lcl.type == SMC_LLC_FLOW_NONE &&
-	    (lgr->llc_flow_rmt.type == SMC_LLC_FLOW_NONE ||
-	     lgr->llc_flow_rmt.type == allowed_remote)) {
-		lgr->llc_flow_lcl.type = type;
+
+	/* Flow is initialized only if the following conditions are met:
+	 * incoming flow	local flow		remote flow
+	 * exclusive		NONE			NONE
+	 * SMC_LLC_FLOW_RKEY	SMC_LLC_FLOW_RKEY	SMC_LLC_FLOW_RKEY
+	 * SMC_LLC_FLOW_RKEY	NONE			SMC_LLC_FLOW_RKEY
+	 * SMC_LLC_FLOW_RKEY	SMC_LLC_FLOW_RKEY	NONE
+	 */
+	switch (type) {
+	case SMC_LLC_FLOW_RKEY:
+		if (!SMC_IS_PARALLEL_FLOW(lgr->llc_flow_lcl.type))
+			break;
+		if (!SMC_IS_PARALLEL_FLOW(lgr->llc_flow_rmt.type))
+			break;
+		/* accepted */
+		accept = true;
+		break;
+	default:
+		if (!SMC_IS_NONE_FLOW(lgr->llc_flow_lcl.type))
+			break;
+		if (!SMC_IS_NONE_FLOW(lgr->llc_flow_rmt.type))
+			break;
+		/* accepted */
+		accept = true;
+		break;
+	}
+	if (accept) {
+		if (SMC_IS_NONE_FLOW(lgr->llc_flow_lcl.type)) {
+			lgr->llc_flow_lcl.type = type;
+			refcount_set(&lgr->llc_flow_lcl.parallel_refcnt, 1);
+		} else {
+			refcount_inc(&lgr->llc_flow_lcl.parallel_refcnt);
+		}
 		spin_unlock_bh(&lgr->llc_flow_lock);
 		return 0;
 	}
@@ -322,6 +361,10 @@ int smc_llc_flow_initiate(struct smc_link_group *lgr,
 void smc_llc_flow_stop(struct smc_link_group *lgr, struct smc_llc_flow *flow)
 {
 	spin_lock_bh(&lgr->llc_flow_lock);
+	if (!refcount_dec_and_test(&flow->parallel_refcnt)) {
+		spin_unlock_bh(&lgr->llc_flow_lock);
+		return;
+	}
 	memset(flow, 0, sizeof(*flow));
 	flow->type = SMC_LLC_FLOW_NONE;
 	spin_unlock_bh(&lgr->llc_flow_lock);
@@ -1723,16 +1766,14 @@ static void smc_llc_delete_link_work(struct work_struct *work)
 }
 
 /* process a confirm_rkey request from peer, remote flow */
-static void smc_llc_rmt_conf_rkey(struct smc_link_group *lgr)
+static void smc_llc_rmt_conf_rkey(struct smc_link_group *lgr, struct smc_llc_qentry *qentry)
 {
 	struct smc_llc_msg_confirm_rkey *llc;
-	struct smc_llc_qentry *qentry;
 	struct smc_link *link;
 	int num_entries;
 	int rk_idx;
 	int i;
 
-	qentry = lgr->llc_flow_rmt.qentry;
 	llc = &qentry->msg.confirm_rkey;
 	link = qentry->link;
 
@@ -1759,19 +1800,16 @@ static void smc_llc_rmt_conf_rkey(struct smc_link_group *lgr)
 	llc->hd.flags |= SMC_LLC_FLAG_RESP;
 	smc_llc_init_msg_hdr(&llc->hd, link->lgr, sizeof(*llc));
 	smc_llc_send_message(link, &qentry->msg);
-	smc_llc_flow_qentry_del(&lgr->llc_flow_rmt);
 }
 
 /* process a delete_rkey request from peer, remote flow */
-static void smc_llc_rmt_delete_rkey(struct smc_link_group *lgr)
+static void smc_llc_rmt_delete_rkey(struct smc_link_group *lgr, struct smc_llc_qentry *qentry)
 {
 	struct smc_llc_msg_delete_rkey *llc;
-	struct smc_llc_qentry *qentry;
 	struct smc_link *link;
 	u8 err_mask = 0;
 	int i, max;
 
-	qentry = lgr->llc_flow_rmt.qentry;
 	llc = &qentry->msg.delete_rkey;
 	link = qentry->link;
 
@@ -1809,7 +1847,6 @@ static void smc_llc_rmt_delete_rkey(struct smc_link_group *lgr)
 finish:
 	llc->hd.flags |= SMC_LLC_FLAG_RESP;
 	smc_llc_send_message(link, &qentry->msg);
-	smc_llc_flow_qentry_del(&lgr->llc_flow_rmt);
 }
 
 static void smc_llc_protocol_violation(struct smc_link_group *lgr, u8 type)
@@ -1910,7 +1947,7 @@ static void smc_llc_event_handler(struct smc_llc_qentry *qentry)
 		/* new request from remote, assign to remote flow */
 		if (smc_llc_flow_start(&lgr->llc_flow_rmt, qentry)) {
 			/* process here, does not wait for more llc msgs */
-			smc_llc_rmt_conf_rkey(lgr);
+			smc_llc_rmt_conf_rkey(lgr, qentry);
 			smc_llc_flow_stop(lgr, &lgr->llc_flow_rmt);
 		}
 		return;
@@ -1923,7 +1960,7 @@ static void smc_llc_event_handler(struct smc_llc_qentry *qentry)
 		/* new request from remote, assign to remote flow */
 		if (smc_llc_flow_start(&lgr->llc_flow_rmt, qentry)) {
 			/* process here, does not wait for more llc msgs */
-			smc_llc_rmt_delete_rkey(lgr);
+			smc_llc_rmt_delete_rkey(lgr, qentry);
 			smc_llc_flow_stop(lgr, &lgr->llc_flow_rmt);
 		}
 		return;
diff --git a/net/smc/smc_llc.h b/net/smc/smc_llc.h
index 7e7a316..cb217793 100644
--- a/net/smc/smc_llc.h
+++ b/net/smc/smc_llc.h
@@ -49,6 +49,12 @@ enum smc_llc_msg_type {
 #define smc_link_downing(state) \
 	(cmpxchg(state, SMC_LNK_ACTIVE, SMC_LNK_INACTIVE) == SMC_LNK_ACTIVE)
 
+#define SMC_IS_NONE_FLOW(type)		\
+	((type) == SMC_LLC_FLOW_NONE)
+
+#define SMC_IS_PARALLEL_FLOW(type)	\
+	(((type) == SMC_LLC_FLOW_RKEY) || SMC_IS_NONE_FLOW(type))
+
 /* LLC DELETE LINK Request Reason Codes */
 #define SMC_LLC_DEL_LOST_PATH		0x00010000
 #define SMC_LLC_DEL_OP_INIT_TERM	0x00020000
-- 
1.8.3.1

