Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDC54161618
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 16:25:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728924AbgBQPZR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 10:25:17 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:57558 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728335AbgBQPZI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 10:25:08 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01HFK8po044306
        for <netdev@vger.kernel.org>; Mon, 17 Feb 2020 10:25:07 -0500
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2y6cu1us4e-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 17 Feb 2020 10:25:07 -0500
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <ubraun@linux.ibm.com>;
        Mon, 17 Feb 2020 15:25:05 -0000
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 17 Feb 2020 15:25:03 -0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01HFOxm745678700
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Feb 2020 15:24:59 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 83D54A4051;
        Mon, 17 Feb 2020 15:24:59 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 419DFA4053;
        Mon, 17 Feb 2020 15:24:59 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 17 Feb 2020 15:24:59 +0000 (GMT)
From:   Ursula Braun <ubraun@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        kgraul@linux.ibm.com, ubraun@linux.ibm.com
Subject: [PATCH net-next 5/6] net/smc: simplify normal link termination
Date:   Mon, 17 Feb 2020 16:24:54 +0100
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200217152455.15341-1-ubraun@linux.ibm.com>
References: <20200217152455.15341-1-ubraun@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 20021715-0016-0000-0000-000002E7A508
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20021715-0017-0000-0000-0000334AB51A
Message-Id: <20200217152455.15341-6-ubraun@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-17_10:2020-02-17,2020-02-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 mlxscore=0 suspectscore=3 bulkscore=0 spamscore=0
 lowpriorityscore=0 impostorscore=0 adultscore=0 clxscore=1015
 mlxlogscore=999 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2001150001 definitions=main-2002170126
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Karsten Graul <kgraul@linux.ibm.com>

smc_lgr_terminate() and smc_lgr_terminate_sched() both result in soft
link termination, smc_lgr_terminate_sched() is scheduling a worker for
this task. Take out complexity by always using the termination worker
and getting rid of smc_lgr_terminate() completely.

Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
Signed-off-by: Ursula Braun <ubraun@linux.ibm.com>
---
 net/smc/smc_clc.c  | 2 +-
 net/smc/smc_core.c | 9 +++++----
 net/smc/smc_core.h | 8 +-------
 net/smc/smc_llc.c  | 2 +-
 4 files changed, 8 insertions(+), 13 deletions(-)

diff --git a/net/smc/smc_clc.c b/net/smc/smc_clc.c
index aee9ccfa99c2..3e16b887cfcf 100644
--- a/net/smc/smc_clc.c
+++ b/net/smc/smc_clc.c
@@ -349,7 +349,7 @@ int smc_clc_wait_msg(struct smc_sock *smc, void *buf, int buflen,
 		smc->peer_diagnosis = ntohl(dclc->peer_diagnosis);
 		if (((struct smc_clc_msg_decline *)buf)->hdr.flag) {
 			smc->conn.lgr->sync_err = 1;
-			smc_lgr_terminate(smc->conn.lgr);
+			smc_lgr_terminate_sched(smc->conn.lgr);
 		}
 	}
 
diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index 53b6afbb1d93..1bbce5531014 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -46,6 +46,7 @@ static DECLARE_WAIT_QUEUE_HEAD(lgrs_deleted);
 
 static void smc_buf_free(struct smc_link_group *lgr, bool is_rmb,
 			 struct smc_buf_desc *buf_desc);
+static void __smc_lgr_terminate(struct smc_link_group *lgr, bool soft);
 
 /* return head of link group list and its lock for a given link group */
 static inline struct list_head *smc_lgr_list_head(struct smc_link_group *lgr,
@@ -229,7 +230,7 @@ static void smc_lgr_terminate_work(struct work_struct *work)
 	struct smc_link_group *lgr = container_of(work, struct smc_link_group,
 						  terminate_work);
 
-	smc_lgr_terminate(lgr);
+	__smc_lgr_terminate(lgr, true);
 }
 
 /* create a new SMC link group */
@@ -622,8 +623,8 @@ static void __smc_lgr_terminate(struct smc_link_group *lgr, bool soft)
 		smc_lgr_free(lgr);
 }
 
-/* unlink and terminate link group */
-void smc_lgr_terminate(struct smc_link_group *lgr)
+/* unlink link group and schedule termination */
+void smc_lgr_terminate_sched(struct smc_link_group *lgr)
 {
 	spinlock_t *lgr_lock;
 
@@ -635,7 +636,7 @@ void smc_lgr_terminate(struct smc_link_group *lgr)
 	}
 	list_del_init(&lgr->list);
 	spin_unlock_bh(lgr_lock);
-	__smc_lgr_terminate(lgr, true);
+	schedule_work(&lgr->terminate_work);
 }
 
 /* Called when IB port is terminated */
diff --git a/net/smc/smc_core.h b/net/smc/smc_core.h
index 094d43c24345..5695c7bc639e 100644
--- a/net/smc/smc_core.h
+++ b/net/smc/smc_core.h
@@ -285,18 +285,12 @@ static inline struct smc_connection *smc_lgr_find_conn(
 	return res;
 }
 
-static inline void smc_lgr_terminate_sched(struct smc_link_group *lgr)
-{
-	if (!lgr->terminating && !lgr->freeing)
-		schedule_work(&lgr->terminate_work);
-}
-
 struct smc_sock;
 struct smc_clc_msg_accept_confirm;
 struct smc_clc_msg_local;
 
 void smc_lgr_forget(struct smc_link_group *lgr);
-void smc_lgr_terminate(struct smc_link_group *lgr);
+void smc_lgr_terminate_sched(struct smc_link_group *lgr);
 void smc_port_terminate(struct smc_ib_device *smcibdev, u8 ibport);
 void smc_smcd_terminate(struct smcd_dev *dev, u64 peer_gid,
 			unsigned short vlan);
diff --git a/net/smc/smc_llc.c b/net/smc/smc_llc.c
index b134a08c929e..0e52aab53d97 100644
--- a/net/smc/smc_llc.c
+++ b/net/smc/smc_llc.c
@@ -614,7 +614,7 @@ static void smc_llc_testlink_work(struct work_struct *work)
 	rc = wait_for_completion_interruptible_timeout(&link->llc_testlink_resp,
 						       SMC_LLC_WAIT_TIME);
 	if (rc <= 0) {
-		smc_lgr_terminate(smc_get_lgr(link));
+		smc_lgr_terminate_sched(smc_get_lgr(link));
 		return;
 	}
 	next_interval = link->llc_testlink_time;
-- 
2.17.1

