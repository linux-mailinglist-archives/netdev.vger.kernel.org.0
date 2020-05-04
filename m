Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FAEB1C3937
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 14:19:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728802AbgEDMTe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 08:19:34 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:32816 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728747AbgEDMTQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 08:19:16 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 044C31Cj124679;
        Mon, 4 May 2020 08:19:15 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30s5d3s1h3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 May 2020 08:19:15 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 044C9plg029255;
        Mon, 4 May 2020 12:19:13 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03ams.nl.ibm.com with ESMTP id 30s0g5mrym-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 May 2020 12:19:12 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 044CJA9W60358676
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 4 May 2020 12:19:10 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 279A9A4040;
        Mon,  4 May 2020 12:19:10 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E2C98A4051;
        Mon,  4 May 2020 12:19:09 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  4 May 2020 12:19:09 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net-next 10/12] net/smc: improve termination processing
Date:   Mon,  4 May 2020 14:18:46 +0200
Message-Id: <20200504121848.46585-11-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200504121848.46585-1-kgraul@linux.ibm.com>
References: <20200504121848.46585-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-05-04_07:2020-05-04,2020-05-04 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=3 adultscore=0
 impostorscore=0 mlxscore=0 phishscore=0 spamscore=0 bulkscore=0
 lowpriorityscore=0 mlxlogscore=999 malwarescore=0 clxscore=1015
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005040104
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add helper smcr_lgr_link_deactivate_all() and eliminate duplicate code.
In smc_lgr_free(), clear the smc-r links before smc_lgr_free_bufs() is
called so buffers are already prepared for free. The usage of the soft
parameter in __smc_lgr_terminate() is no longer needed, smc_lgr_free()
can be called directly. smc_lgr_terminate_sched() and
smc_smcd_terminate() set lgr->freeing to indicate that the link group
will be freed soon to avoid unnecessary schedules of the free worker.

Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
Reviewed-by: Ursula Braun <ubraun@linux.ibm.com>
---
 net/smc/smc_core.c | 61 +++++++++++++++++++++++-----------------------
 1 file changed, 31 insertions(+), 30 deletions(-)

diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index b6f93b44f9c7..fb391bc6781e 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -237,6 +237,19 @@ void smc_lgr_cleanup_early(struct smc_connection *conn)
 	smc_lgr_schedule_free_work_fast(lgr);
 }
 
+static void smcr_lgr_link_deactivate_all(struct smc_link_group *lgr)
+{
+	int i;
+
+	for (i = 0; i < SMC_LINKS_PER_LGR_MAX; i++) {
+		struct smc_link *lnk = &lgr->lnk[i];
+
+		if (smc_link_usable(lnk))
+			lnk->state = SMC_LNK_INACTIVE;
+	}
+	wake_up_interruptible_all(&lgr->llc_waiter);
+}
+
 static void smc_lgr_free(struct smc_link_group *lgr);
 
 static void smc_lgr_free_work(struct work_struct *work)
@@ -246,7 +259,6 @@ static void smc_lgr_free_work(struct work_struct *work)
 						  free_work);
 	spinlock_t *lgr_lock;
 	bool conns;
-	int i;
 
 	smc_lgr_list_head(lgr, &lgr_lock);
 	spin_lock_bh(lgr_lock);
@@ -271,15 +283,8 @@ static void smc_lgr_free_work(struct work_struct *work)
 					     SMC_LLC_DEL_PROG_INIT_TERM);
 	if (lgr->is_smcd && !lgr->terminating)
 		smc_ism_signal_shutdown(lgr);
-	if (!lgr->is_smcd) {
-		for (i = 0; i < SMC_LINKS_PER_LGR_MAX; i++) {
-			struct smc_link *lnk = &lgr->lnk[i];
-
-			if (smc_link_usable(lnk))
-				lnk->state = SMC_LNK_INACTIVE;
-		}
-		wake_up_interruptible_all(&lgr->llc_waiter);
-	}
+	if (!lgr->is_smcd)
+		smcr_lgr_link_deactivate_all(lgr);
 	smc_lgr_free(lgr);
 }
 
@@ -802,6 +807,16 @@ static void smc_lgr_free(struct smc_link_group *lgr)
 {
 	int i;
 
+	if (!lgr->is_smcd) {
+		mutex_lock(&lgr->llc_conf_mutex);
+		for (i = 0; i < SMC_LINKS_PER_LGR_MAX; i++) {
+			if (lgr->lnk[i].state != SMC_LNK_UNUSED)
+				smcr_link_clear(&lgr->lnk[i]);
+		}
+		mutex_unlock(&lgr->llc_conf_mutex);
+		smc_llc_lgr_clear(lgr);
+	}
+
 	smc_lgr_free_bufs(lgr);
 	if (lgr->is_smcd) {
 		if (!lgr->terminating) {
@@ -811,11 +826,6 @@ static void smc_lgr_free(struct smc_link_group *lgr)
 		if (!atomic_dec_return(&lgr->smcd->lgr_cnt))
 			wake_up(&lgr->smcd->lgrs_deleted);
 	} else {
-		for (i = 0; i < SMC_LINKS_PER_LGR_MAX; i++) {
-			if (lgr->lnk[i].state != SMC_LNK_UNUSED)
-				smcr_link_clear(&lgr->lnk[i]);
-		}
-		smc_llc_lgr_clear(lgr);
 		if (!atomic_dec_return(&lgr_cnt))
 			wake_up(&lgrs_deleted);
 	}
@@ -870,8 +880,6 @@ static void smc_conn_kill(struct smc_connection *conn, bool soft)
 
 static void smc_lgr_cleanup(struct smc_link_group *lgr)
 {
-	int i;
-
 	if (lgr->is_smcd) {
 		smc_ism_signal_shutdown(lgr);
 		smcd_unregister_all_dmbs(lgr);
@@ -883,13 +891,7 @@ static void smc_lgr_cleanup(struct smc_link_group *lgr)
 		if (!rsn)
 			rsn = SMC_LLC_DEL_PROG_INIT_TERM;
 		smc_llc_send_link_delete_all(lgr, false, rsn);
-		for (i = 0; i < SMC_LINKS_PER_LGR_MAX; i++) {
-			struct smc_link *lnk = &lgr->lnk[i];
-
-			if (smc_link_usable(lnk))
-				lnk->state = SMC_LNK_INACTIVE;
-		}
-		wake_up_interruptible_all(&lgr->llc_waiter);
+		smcr_lgr_link_deactivate_all(lgr);
 	}
 }
 
@@ -905,8 +907,8 @@ static void __smc_lgr_terminate(struct smc_link_group *lgr, bool soft)
 
 	if (lgr->terminating)
 		return;	/* lgr already terminating */
-	if (!soft)
-		cancel_delayed_work_sync(&lgr->free_work);
+	/* cancel free_work sync, will terminate when lgr->freeing is set */
+	cancel_delayed_work_sync(&lgr->free_work);
 	lgr->terminating = 1;
 
 	/* kill remaining link group connections */
@@ -926,10 +928,7 @@ static void __smc_lgr_terminate(struct smc_link_group *lgr, bool soft)
 	}
 	read_unlock_bh(&lgr->conns_lock);
 	smc_lgr_cleanup(lgr);
-	if (soft)
-		smc_lgr_schedule_free_work_fast(lgr);
-	else
-		smc_lgr_free(lgr);
+	smc_lgr_free(lgr);
 }
 
 /* unlink link group and schedule termination */
@@ -944,6 +943,7 @@ void smc_lgr_terminate_sched(struct smc_link_group *lgr)
 		return;	/* lgr already terminating */
 	}
 	list_del_init(&lgr->list);
+	lgr->freeing = 1;
 	spin_unlock_bh(lgr_lock);
 	schedule_work(&lgr->terminate_work);
 }
@@ -962,6 +962,7 @@ void smc_smcd_terminate(struct smcd_dev *dev, u64 peer_gid, unsigned short vlan)
 			if (peer_gid) /* peer triggered termination */
 				lgr->peer_shutdown = 1;
 			list_move(&lgr->list, &lgr_free_list);
+			lgr->freeing = 1;
 		}
 	}
 	spin_unlock_bh(&dev->lgr_lock);
-- 
2.17.1

