Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC9561BE233
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 17:12:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727816AbgD2PLo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 11:11:44 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:18052 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727062AbgD2PLj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 11:11:39 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03TF2xQa103284;
        Wed, 29 Apr 2020 11:11:36 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com with ESMTP id 30pjmkkbky-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Apr 2020 11:11:36 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 03TFB084012228;
        Wed, 29 Apr 2020 15:11:34 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma05fra.de.ibm.com with ESMTP id 30mcu51vx5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Apr 2020 15:11:34 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03TFBVqX52428834
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Apr 2020 15:11:31 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 88C3AAE05A;
        Wed, 29 Apr 2020 15:11:31 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 46B86AE061;
        Wed, 29 Apr 2020 15:11:31 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 29 Apr 2020 15:11:31 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net-next 07/13] net/smc: add new link state and related helpers
Date:   Wed, 29 Apr 2020 17:10:43 +0200
Message-Id: <20200429151049.49979-8-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200429151049.49979-1-kgraul@linux.ibm.com>
References: <20200429151049.49979-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-29_07:2020-04-29,2020-04-29 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 phishscore=0
 adultscore=0 spamscore=0 impostorscore=0 lowpriorityscore=0 malwarescore=0
 mlxscore=0 mlxlogscore=999 suspectscore=3 clxscore=1015 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004290122
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Before a link can be reused it must have been cleared. Lowest current
link state is INACTIVE, which does not mean that the link is already
cleared.
Add a new state UNUSED that is set when the link is cleared and can be
reused.
Add helper smc_llc_usable_link() to find an active link in a link group,
and smc_link_usable() to determine if a link is usable.

Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
Reviewed-by: Ursula Braun <ubraun@linux.ibm.com>
---
 net/smc/smc_core.c | 36 +++++++++++++++++++-----------------
 net/smc/smc_core.h |  9 +++++++++
 net/smc/smc_llc.c  |  4 ++--
 net/smc/smc_llc.h  | 11 +++++++++++
 net/smc/smc_wr.c   |  2 +-
 5 files changed, 42 insertions(+), 20 deletions(-)

diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index e8897d60b27f..57890cbd4e8a 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -260,7 +260,7 @@ static void smc_lgr_free_work(struct work_struct *work)
 		for (i = 0; i < SMC_LINKS_PER_LGR_MAX; i++) {
 			struct smc_link *lnk = &lgr->lnk[i];
 
-			if (lnk->state != SMC_LNK_INACTIVE)
+			if (smc_link_usable(lnk))
 				smc_llc_link_inactive(lnk);
 		}
 	}
@@ -286,7 +286,7 @@ static u8 smcr_next_link_id(struct smc_link_group *lgr)
 		if (!link_id)	/* skip zero as link_id */
 			link_id = ++lgr->next_link_id;
 		for (i = 0; i < SMC_LINKS_PER_LGR_MAX; i++) {
-			if (lgr->lnk[i].state != SMC_LNK_INACTIVE &&
+			if (smc_link_usable(&lgr->lnk[i]) &&
 			    lgr->lnk[i].link_id == link_id)
 				continue;
 		}
@@ -350,6 +350,7 @@ static int smcr_link_init(struct smc_link_group *lgr, struct smc_link *lnk,
 out:
 	put_device(&ini->ib_dev->ibdev->dev);
 	memset(lnk, 0, sizeof(struct smc_link));
+	lnk->state = SMC_LNK_UNUSED;
 	if (!atomic_dec_return(&ini->ib_dev->lnk_cnt))
 		wake_up(&ini->ib_dev->lnks_deleted);
 	return rc;
@@ -500,6 +501,8 @@ void smc_conn_free(struct smc_connection *conn)
 
 static void smcr_link_clear(struct smc_link *lnk)
 {
+	struct smc_ib_device *smcibdev;
+
 	if (lnk->peer_qpn == 0)
 		return;
 	lnk->peer_qpn = 0;
@@ -510,8 +513,11 @@ static void smcr_link_clear(struct smc_link *lnk)
 	smc_ib_dealloc_protection_domain(lnk);
 	smc_wr_free_link_mem(lnk);
 	put_device(&lnk->smcibdev->ibdev->dev);
-	if (!atomic_dec_return(&lnk->smcibdev->lnk_cnt))
-		wake_up(&lnk->smcibdev->lnks_deleted);
+	smcibdev = lnk->smcibdev;
+	memset(lnk, 0, sizeof(struct smc_link));
+	lnk->state = SMC_LNK_UNUSED;
+	if (!atomic_dec_return(&smcibdev->lnk_cnt))
+		wake_up(&smcibdev->lnks_deleted);
 }
 
 static void smcr_buf_free(struct smc_link_group *lgr, bool is_rmb,
@@ -604,9 +610,8 @@ static void smc_lgr_free(struct smc_link_group *lgr)
 			wake_up(&lgr->smcd->lgrs_deleted);
 	} else {
 		for (i = 0; i < SMC_LINKS_PER_LGR_MAX; i++) {
-			if (lgr->lnk[i].state == SMC_LNK_INACTIVE)
-				continue;
-			smcr_link_clear(&lgr->lnk[i]);
+			if (lgr->lnk[i].state != SMC_LNK_UNUSED)
+				smcr_link_clear(&lgr->lnk[i]);
 		}
 		if (!atomic_dec_return(&lgr_cnt))
 			wake_up(&lgrs_deleted);
@@ -686,7 +691,7 @@ static void smc_lgr_cleanup(struct smc_link_group *lgr)
 		for (i = 0; i < SMC_LINKS_PER_LGR_MAX; i++) {
 			struct smc_link *lnk = &lgr->lnk[i];
 
-			if (lnk->state != SMC_LNK_INACTIVE)
+			if (smc_link_usable(lnk))
 				smc_llc_link_inactive(lnk);
 		}
 	}
@@ -764,7 +769,7 @@ void smc_port_terminate(struct smc_ib_device *smcibdev, u8 ibport)
 			continue;
 		/* tbd - terminate only when no more links are active */
 		for (i = 0; i < SMC_LINKS_PER_LGR_MAX; i++) {
-			if (lgr->lnk[i].state == SMC_LNK_INACTIVE ||
+			if (!smc_link_usable(&lgr->lnk[i]) ||
 			    lgr->lnk[i].state == SMC_LNK_DELETING)
 				continue;
 			if (lgr->lnk[i].smcibdev == smcibdev &&
@@ -1161,8 +1166,7 @@ static int smcr_buf_map_usable_links(struct smc_link_group *lgr,
 	for (i = 0; i < SMC_LINKS_PER_LGR_MAX; i++) {
 		struct smc_link *lnk = &lgr->lnk[i];
 
-		if (lnk->state != SMC_LNK_ACTIVE &&
-		    lnk->state != SMC_LNK_ACTIVATING)
+		if (!smc_link_usable(lnk))
 			continue;
 		if (smcr_buf_map_link(buf_desc, is_rmb, lnk)) {
 			smcr_buf_unuse(buf_desc, lnk);
@@ -1294,14 +1298,14 @@ static int __smc_buf_create(struct smc_sock *smc, bool is_smcd, bool is_rmb)
 
 void smc_sndbuf_sync_sg_for_cpu(struct smc_connection *conn)
 {
-	if (!conn->lgr || conn->lgr->is_smcd)
+	if (!conn->lgr || conn->lgr->is_smcd || !smc_link_usable(conn->lnk))
 		return;
 	smc_ib_sync_sg_for_cpu(conn->lnk, conn->sndbuf_desc, DMA_TO_DEVICE);
 }
 
 void smc_sndbuf_sync_sg_for_device(struct smc_connection *conn)
 {
-	if (!conn->lgr || conn->lgr->is_smcd)
+	if (!conn->lgr || conn->lgr->is_smcd || !smc_link_usable(conn->lnk))
 		return;
 	smc_ib_sync_sg_for_device(conn->lnk, conn->sndbuf_desc, DMA_TO_DEVICE);
 }
@@ -1313,8 +1317,7 @@ void smc_rmb_sync_sg_for_cpu(struct smc_connection *conn)
 	if (!conn->lgr || conn->lgr->is_smcd)
 		return;
 	for (i = 0; i < SMC_LINKS_PER_LGR_MAX; i++) {
-		if (conn->lgr->lnk[i].state != SMC_LNK_ACTIVE &&
-		    conn->lgr->lnk[i].state != SMC_LNK_ACTIVATING)
+		if (!smc_link_usable(&conn->lgr->lnk[i]))
 			continue;
 		smc_ib_sync_sg_for_cpu(&conn->lgr->lnk[i], conn->rmb_desc,
 				       DMA_FROM_DEVICE);
@@ -1328,8 +1331,7 @@ void smc_rmb_sync_sg_for_device(struct smc_connection *conn)
 	if (!conn->lgr || conn->lgr->is_smcd)
 		return;
 	for (i = 0; i < SMC_LINKS_PER_LGR_MAX; i++) {
-		if (conn->lgr->lnk[i].state != SMC_LNK_ACTIVE &&
-		    conn->lgr->lnk[i].state != SMC_LNK_ACTIVATING)
+		if (!smc_link_usable(&conn->lgr->lnk[i]))
 			continue;
 		smc_ib_sync_sg_for_device(&conn->lgr->lnk[i], conn->rmb_desc,
 					  DMA_FROM_DEVICE);
diff --git a/net/smc/smc_core.h b/net/smc/smc_core.h
index f68ba187ecf8..2b1960c8c8ce 100644
--- a/net/smc/smc_core.h
+++ b/net/smc/smc_core.h
@@ -32,6 +32,7 @@ enum smc_lgr_role {		/* possible roles of a link group */
 };
 
 enum smc_link_state {			/* possible states of a link */
+	SMC_LNK_UNUSED,		/* link is unused */
 	SMC_LNK_INACTIVE,	/* link is inactive */
 	SMC_LNK_ACTIVATING,	/* link is being activated */
 	SMC_LNK_ACTIVE,		/* link is active */
@@ -295,6 +296,14 @@ static inline struct smc_connection *smc_lgr_find_conn(
 	return res;
 }
 
+/* returns true if the specified link is usable */
+static inline bool smc_link_usable(struct smc_link *lnk)
+{
+	if (lnk->state == SMC_LNK_UNUSED || lnk->state == SMC_LNK_INACTIVE)
+		return false;
+	return true;
+}
+
 struct smc_sock;
 struct smc_clc_msg_accept_confirm;
 struct smc_clc_msg_local;
diff --git a/net/smc/smc_llc.c b/net/smc/smc_llc.c
index 903ae068da3a..c267f5006faa 100644
--- a/net/smc/smc_llc.c
+++ b/net/smc/smc_llc.c
@@ -372,7 +372,7 @@ static void smc_llc_send_message_work(struct work_struct *work)
 	struct smc_wr_buf *wr_buf;
 	int rc;
 
-	if (llcwrk->link->state == SMC_LNK_INACTIVE)
+	if (!smc_link_usable(llcwrk->link))
 		goto out;
 	rc = smc_llc_add_pending_send(llcwrk->link, &wr_buf, &pend);
 	if (rc)
@@ -562,7 +562,7 @@ static void smc_llc_rx_handler(struct ib_wc *wc, void *buf)
 		return; /* short message */
 	if (llc->raw.hdr.length != sizeof(*llc))
 		return; /* invalid message */
-	if (link->state == SMC_LNK_INACTIVE)
+	if (!smc_link_usable(link))
 		return; /* link not active, drop msg */
 
 	switch (llc->raw.hdr.common.type) {
diff --git a/net/smc/smc_llc.h b/net/smc/smc_llc.h
index 461c0c3ef76e..08171131110c 100644
--- a/net/smc/smc_llc.h
+++ b/net/smc/smc_llc.h
@@ -35,6 +35,17 @@ enum smc_llc_msg_type {
 	SMC_LLC_DELETE_RKEY		= 0x09,
 };
 
+/* returns a usable link of the link group, or NULL */
+static inline struct smc_link *smc_llc_usable_link(struct smc_link_group *lgr)
+{
+	int i;
+
+	for (i = 0; i < SMC_LINKS_PER_LGR_MAX; i++)
+		if (smc_link_usable(&lgr->lnk[i]))
+			return &lgr->lnk[i];
+	return NULL;
+}
+
 /* transmit */
 int smc_llc_send_confirm_link(struct smc_link *lnk,
 			      enum smc_llc_reqresp reqresp);
diff --git a/net/smc/smc_wr.c b/net/smc/smc_wr.c
index 337ee52ad3d3..93223628c002 100644
--- a/net/smc/smc_wr.c
+++ b/net/smc/smc_wr.c
@@ -207,7 +207,7 @@ int smc_wr_tx_get_free_slot(struct smc_link *link,
 	} else {
 		rc = wait_event_interruptible_timeout(
 			link->wr_tx_wait,
-			link->state == SMC_LNK_INACTIVE ||
+			!smc_link_usable(link) ||
 			lgr->terminating ||
 			(smc_wr_tx_get_free_slot_index(link, &idx) != -EBUSY),
 			SMC_WR_TX_WAIT_FREE_SLOT_TIME);
-- 
2.17.1

