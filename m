Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B97B1BE22A
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 17:11:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727082AbgD2PLi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 11:11:38 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:28336 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726911AbgD2PLh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 11:11:37 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03TF2A70004143;
        Wed, 29 Apr 2020 11:11:35 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30me46c6rs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Apr 2020 11:11:35 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 03TFB3X9006709;
        Wed, 29 Apr 2020 15:11:33 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03ams.nl.ibm.com with ESMTP id 30mcu5rnqw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Apr 2020 15:11:33 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03TFBUwO65011836
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Apr 2020 15:11:30 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 28767AE056;
        Wed, 29 Apr 2020 15:11:30 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DBA68AE05D;
        Wed, 29 Apr 2020 15:11:29 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 29 Apr 2020 15:11:29 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net-next 03/13] net/smc: introduce link_idx for link group array
Date:   Wed, 29 Apr 2020 17:10:39 +0200
Message-Id: <20200429151049.49979-4-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200429151049.49979-1-kgraul@linux.ibm.com>
References: <20200429151049.49979-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-29_07:2020-04-29,2020-04-29 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 bulkscore=0
 lowpriorityscore=0 priorityscore=1501 mlxscore=0 impostorscore=0
 spamscore=0 malwarescore=0 mlxlogscore=999 clxscore=1015 phishscore=0
 suspectscore=3 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004290122
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The link_id is the index of the link in the array of the link group.
When a link in the array is reused for a new link, a different unique
link_id should be used, otherwise the index in the array could collide
with the previous link at this array position.
Use a new variable link_idx as array index, and make link_id an
increasing unique id value.

Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
Reviewed-by: Ursula Braun <ubraun@linux.ibm.com>
---
 net/smc/smc_core.c | 34 +++++++++++++++++++++++++++++-----
 net/smc/smc_core.h |  2 ++
 2 files changed, 31 insertions(+), 5 deletions(-)

diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index 3bb45c33db22..d233112ced2a 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -245,8 +245,28 @@ static void smc_lgr_terminate_work(struct work_struct *work)
 	__smc_lgr_terminate(lgr, true);
 }
 
-static int smcr_link_init(struct smc_link *lnk, u8 link_id,
-			  struct smc_init_info *ini)
+/* return next unique link id for the lgr */
+static u8 smcr_next_link_id(struct smc_link_group *lgr)
+{
+	u8 link_id;
+	int i;
+
+	while (1) {
+		link_id = ++lgr->next_link_id;
+		if (!link_id)	/* skip zero as link_id */
+			link_id = ++lgr->next_link_id;
+		for (i = 0; i < SMC_LINKS_PER_LGR_MAX; i++) {
+			if (lgr->lnk[i].state != SMC_LNK_INACTIVE &&
+			    lgr->lnk[i].link_id == link_id)
+				continue;
+		}
+		break;
+	}
+	return link_id;
+}
+
+static int smcr_link_init(struct smc_link_group *lgr, struct smc_link *lnk,
+			  u8 link_idx, struct smc_init_info *ini)
 {
 	u8 rndvec[3];
 	int rc;
@@ -254,7 +274,8 @@ static int smcr_link_init(struct smc_link *lnk, u8 link_id,
 	get_device(&ini->ib_dev->ibdev->dev);
 	atomic_inc(&ini->ib_dev->lnk_cnt);
 	lnk->state = SMC_LNK_ACTIVATING;
-	lnk->link_id = link_id;
+	lnk->link_id = smcr_next_link_id(lgr);
+	lnk->link_idx = link_idx;
 	lnk->smcibdev = ini->ib_dev;
 	lnk->ibport = ini->ib_port;
 	lnk->path_mtu = ini->ib_dev->pattr[ini->ib_port - 1].active_mtu;
@@ -310,6 +331,7 @@ static int smc_lgr_create(struct smc_sock *smc, struct smc_init_info *ini)
 	struct list_head *lgr_list;
 	struct smc_link *lnk;
 	spinlock_t *lgr_lock;
+	u8 link_idx;
 	int rc = 0;
 	int i;
 
@@ -338,6 +360,7 @@ static int smc_lgr_create(struct smc_sock *smc, struct smc_init_info *ini)
 		INIT_LIST_HEAD(&lgr->sndbufs[i]);
 		INIT_LIST_HEAD(&lgr->rmbs[i]);
 	}
+	lgr->next_link_id = 0;
 	smc_lgr_list.num += SMC_LGR_NUM_INCR;
 	memcpy(&lgr->id, (u8 *)&smc_lgr_list.num, SMC_LGR_ID_SIZE);
 	INIT_DELAYED_WORK(&lgr->free_work, smc_lgr_free_work);
@@ -358,8 +381,9 @@ static int smc_lgr_create(struct smc_sock *smc, struct smc_init_info *ini)
 		memcpy(lgr->peer_systemid, ini->ib_lcl->id_for_peer,
 		       SMC_SYSTEMID_LEN);
 
-		lnk = &lgr->lnk[SMC_SINGLE_LINK];
-		rc = smcr_link_init(lnk, SMC_SINGLE_LINK, ini);
+		link_idx = SMC_SINGLE_LINK;
+		lnk = &lgr->lnk[link_idx];
+		rc = smcr_link_init(lgr, lnk, link_idx, ini);
 		if (rc)
 			goto free_lgr;
 		lgr_list = &smc_lgr_list.list;
diff --git a/net/smc/smc_core.h b/net/smc/smc_core.h
index 8041db20c753..c459b0639bf3 100644
--- a/net/smc/smc_core.h
+++ b/net/smc/smc_core.h
@@ -115,6 +115,7 @@ struct smc_link {
 	u8			peer_mac[ETH_ALEN];	/* = gid[8:10||13:15] */
 	u8			peer_gid[SMC_GID_SIZE];	/* gid of peer*/
 	u8			link_id;	/* unique # within link group */
+	u8			link_idx;	/* index in lgr link array */
 
 	enum smc_link_state	state;		/* state of link */
 	struct workqueue_struct *llc_wq;	/* single thread work queue */
@@ -222,6 +223,7 @@ struct smc_link_group {
 						/* remote addr/key pairs */
 			DECLARE_BITMAP(rtokens_used_mask, SMC_RMBS_PER_LGR_MAX);
 						/* used rtoken elements */
+			u8			next_link_id;
 		};
 		struct { /* SMC-D */
 			u64			peer_gid;
-- 
2.17.1

