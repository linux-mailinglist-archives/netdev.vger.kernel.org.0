Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8246ADEF08
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 16:13:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729144AbfJUONh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 10:13:37 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:33912 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728983AbfJUONh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 10:13:37 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x9LEDXRJ118379
        for <netdev@vger.kernel.org>; Mon, 21 Oct 2019 10:13:36 -0400
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2vsddsj7af-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 21 Oct 2019 10:13:35 -0400
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <kgraul@linux.ibm.com>;
        Mon, 21 Oct 2019 15:13:25 +0100
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 21 Oct 2019 15:13:23 +0100
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x9LECncO37421564
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Oct 2019 14:12:49 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7B0C44C04A;
        Mon, 21 Oct 2019 14:13:21 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 32B164C058;
        Mon, 21 Oct 2019 14:13:21 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 21 Oct 2019 14:13:21 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        gor@linux.ibm.com, heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net-next 4/8] net/smc: improve link group freeing
Date:   Mon, 21 Oct 2019 16:13:11 +0200
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191021141315.58969-1-kgraul@linux.ibm.com>
References: <20191021141315.58969-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19102114-0016-0000-0000-000002BAF723
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19102114-0017-0000-0000-0000331C2D1D
Message-Id: <20191021141315.58969-5-kgraul@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-21_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1910210135
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ursula Braun <ubraun@linux.ibm.com>

Usually link groups are freed delayed to enable quick connection
creation for a follow-on SMC socket. Terminated link groups are
freed faster. This patch makes sure, fast schedule of link group
freeing is not rescheduled by a delayed schedule. And it makes sure
link group freeing is not rescheduled, if the real freeing is already
running.

Signed-off-by: Ursula Braun <ubraun@linux.ibm.com>
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 net/smc/smc_core.c | 47 +++++++++++++++++++++++++++++-----------------
 net/smc/smc_core.h |  2 ++
 2 files changed, 32 insertions(+), 17 deletions(-)

diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index 1f58cd82928c..e7e9dbcd7d8b 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -61,14 +61,21 @@ static void smc_lgr_schedule_free_work(struct smc_link_group *lgr)
 	 * creation. For client use a somewhat higher removal delay time,
 	 * otherwise there is a risk of out-of-sync link groups.
 	 */
-	mod_delayed_work(system_wq, &lgr->free_work,
-			 (!lgr->is_smcd && lgr->role == SMC_CLNT) ?
-			 SMC_LGR_FREE_DELAY_CLNT : SMC_LGR_FREE_DELAY_SERV);
+	if (!lgr->freeing && !lgr->freefast) {
+		mod_delayed_work(system_wq, &lgr->free_work,
+				 (!lgr->is_smcd && lgr->role == SMC_CLNT) ?
+						SMC_LGR_FREE_DELAY_CLNT :
+						SMC_LGR_FREE_DELAY_SERV);
+	}
 }
 
 void smc_lgr_schedule_free_work_fast(struct smc_link_group *lgr)
 {
-	mod_delayed_work(system_wq, &lgr->free_work, SMC_LGR_FREE_DELAY_FAST);
+	if (!lgr->freeing && !lgr->freefast) {
+		lgr->freefast = 1;
+		mod_delayed_work(system_wq, &lgr->free_work,
+				 SMC_LGR_FREE_DELAY_FAST);
+	}
 }
 
 /* Register connection's alert token in our lookup structure.
@@ -171,10 +178,15 @@ static void smc_lgr_free_work(struct work_struct *work)
 						  struct smc_link_group,
 						  free_work);
 	spinlock_t *lgr_lock;
+	struct smc_link *lnk;
 	bool conns;
 
 	smc_lgr_list_head(lgr, &lgr_lock);
 	spin_lock_bh(lgr_lock);
+	if (lgr->freeing) {
+		spin_unlock_bh(lgr_lock);
+		return;
+	}
 	read_lock_bh(&lgr->conns_lock);
 	conns = RB_EMPTY_ROOT(&lgr->conns_all);
 	read_unlock_bh(&lgr->conns_lock);
@@ -183,29 +195,27 @@ static void smc_lgr_free_work(struct work_struct *work)
 		return;
 	}
 	list_del_init(&lgr->list); /* remove from smc_lgr_list */
-	spin_unlock_bh(lgr_lock);
 
+	lnk = &lgr->lnk[SMC_SINGLE_LINK];
 	if (!lgr->is_smcd && !lgr->terminating)	{
-		struct smc_link *lnk = &lgr->lnk[SMC_SINGLE_LINK];
-
 		/* try to send del link msg, on error free lgr immediately */
 		if (lnk->state == SMC_LNK_ACTIVE &&
 		    !smc_link_send_delete(lnk)) {
 			/* reschedule in case we never receive a response */
 			smc_lgr_schedule_free_work(lgr);
+			spin_unlock_bh(lgr_lock);
 			return;
 		}
 	}
+	lgr->freeing = 1; /* this instance does the freeing, no new schedule */
+	spin_unlock_bh(lgr_lock);
+	cancel_delayed_work(&lgr->free_work);
 
-	if (!delayed_work_pending(&lgr->free_work)) {
-		struct smc_link *lnk = &lgr->lnk[SMC_SINGLE_LINK];
-
-		if (!lgr->is_smcd && lnk->state != SMC_LNK_INACTIVE)
-			smc_llc_link_inactive(lnk);
-		if (lgr->is_smcd)
-			smc_ism_signal_shutdown(lgr);
-		smc_lgr_free(lgr);
-	}
+	if (!lgr->is_smcd && lnk->state != SMC_LNK_INACTIVE)
+		smc_llc_link_inactive(lnk);
+	if (lgr->is_smcd)
+		smc_ism_signal_shutdown(lgr);
+	smc_lgr_free(lgr);
 }
 
 /* create a new SMC link group */
@@ -233,6 +243,9 @@ static int smc_lgr_create(struct smc_sock *smc, struct smc_init_info *ini)
 	}
 	lgr->is_smcd = ini->is_smcd;
 	lgr->sync_err = 0;
+	lgr->terminating = 0;
+	lgr->freefast = 0;
+	lgr->freeing = 0;
 	lgr->vlan_id = ini->vlan_id;
 	rwlock_init(&lgr->sndbufs_lock);
 	rwlock_init(&lgr->rmbs_lock);
@@ -513,7 +526,7 @@ static void __smc_lgr_terminate(struct smc_link_group *lgr)
 	read_unlock_bh(&lgr->conns_lock);
 	if (!lgr->is_smcd)
 		wake_up(&lgr->lnk[SMC_SINGLE_LINK].wr_reg_wait);
-	smc_lgr_schedule_free_work(lgr);
+	smc_lgr_schedule_free_work_fast(lgr);
 }
 
 /* unlink and terminate link group */
diff --git a/net/smc/smc_core.h b/net/smc/smc_core.h
index c00ac61dc129..12c2818b293f 100644
--- a/net/smc/smc_core.h
+++ b/net/smc/smc_core.h
@@ -204,6 +204,8 @@ struct smc_link_group {
 	struct delayed_work	free_work;	/* delayed freeing of an lgr */
 	u8			sync_err : 1;	/* lgr no longer fits to peer */
 	u8			terminating : 1;/* lgr is terminating */
+	u8			freefast : 1;	/* free worker scheduled fast */
+	u8			freeing : 1;	/* lgr is being freed */
 
 	bool			is_smcd;	/* SMC-R or SMC-D */
 	union {
-- 
2.17.1

