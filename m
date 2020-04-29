Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F6461BE244
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 17:12:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727878AbgD2PMD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 11:12:03 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:33564 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726948AbgD2PLi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 11:11:38 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03TF3PN9132713;
        Wed, 29 Apr 2020 11:11:36 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30mhc2h2g4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Apr 2020 11:11:35 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 03TFB3X8006709;
        Wed, 29 Apr 2020 15:11:32 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03ams.nl.ibm.com with ESMTP id 30mcu5rnqu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Apr 2020 15:11:32 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03TFBTYD55705652
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Apr 2020 15:11:29 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C4850AE053;
        Wed, 29 Apr 2020 15:11:29 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8E1B3AE051;
        Wed, 29 Apr 2020 15:11:29 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 29 Apr 2020 15:11:29 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net-next 02/13] net/smc: separate function for link initialization
Date:   Wed, 29 Apr 2020 17:10:38 +0200
Message-Id: <20200429151049.49979-3-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200429151049.49979-1-kgraul@linux.ibm.com>
References: <20200429151049.49979-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-29_07:2020-04-29,2020-04-29 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=3
 impostorscore=0 priorityscore=1501 adultscore=0 lowpriorityscore=0
 spamscore=0 bulkscore=0 mlxlogscore=999 phishscore=0 mlxscore=0
 malwarescore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2004290122
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move the initialization of a new link into its own function, separate
from smc_lgr_create, to allow more than one link per link group.
Do an extra check if the IB device initialization was successful, and
reset the link state if any error occurs during smcr_link_init().
And rename two existing functions to use the prefix smcr_ to indicate
that they belong to the SMC-R code path.

Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
Reviewed-by: Ursula Braun <ubraun@linux.ibm.com>
---
 net/smc/smc_core.c | 114 ++++++++++++++++++++++++++-------------------
 1 file changed, 66 insertions(+), 48 deletions(-)

diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index 824c5211b027..3bb45c33db22 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -179,7 +179,7 @@ void smc_lgr_cleanup_early(struct smc_connection *conn)
  * of the DELETE LINK sequence from server; or as server to
  * initiate the delete processing. See smc_llc_rx_delete_link().
  */
-static int smc_link_send_delete(struct smc_link *lnk, bool orderly)
+static int smcr_link_send_delete(struct smc_link *lnk, bool orderly)
 {
 	if (lnk->state == SMC_LNK_ACTIVE &&
 	    !smc_llc_send_delete_link(lnk, SMC_LLC_REQ, orderly)) {
@@ -219,7 +219,7 @@ static void smc_lgr_free_work(struct work_struct *work)
 	if (!lgr->is_smcd && !lgr->terminating)	{
 		/* try to send del link msg, on error free lgr immediately */
 		if (lnk->state == SMC_LNK_ACTIVE &&
-		    !smc_link_send_delete(lnk, true)) {
+		    !smcr_link_send_delete(lnk, true)) {
 			/* reschedule in case we never receive a response */
 			smc_lgr_schedule_free_work(lgr);
 			spin_unlock_bh(lgr_lock);
@@ -245,6 +245,64 @@ static void smc_lgr_terminate_work(struct work_struct *work)
 	__smc_lgr_terminate(lgr, true);
 }
 
+static int smcr_link_init(struct smc_link *lnk, u8 link_id,
+			  struct smc_init_info *ini)
+{
+	u8 rndvec[3];
+	int rc;
+
+	get_device(&ini->ib_dev->ibdev->dev);
+	atomic_inc(&ini->ib_dev->lnk_cnt);
+	lnk->state = SMC_LNK_ACTIVATING;
+	lnk->link_id = link_id;
+	lnk->smcibdev = ini->ib_dev;
+	lnk->ibport = ini->ib_port;
+	lnk->path_mtu = ini->ib_dev->pattr[ini->ib_port - 1].active_mtu;
+	if (!ini->ib_dev->initialized) {
+		rc = (int)smc_ib_setup_per_ibdev(ini->ib_dev);
+		if (rc)
+			goto out;
+	}
+	get_random_bytes(rndvec, sizeof(rndvec));
+	lnk->psn_initial = rndvec[0] + (rndvec[1] << 8) +
+		(rndvec[2] << 16);
+	rc = smc_ib_determine_gid(lnk->smcibdev, lnk->ibport,
+				  ini->vlan_id, lnk->gid, &lnk->sgid_index);
+	if (rc)
+		goto out;
+	rc = smc_llc_link_init(lnk);
+	if (rc)
+		goto out;
+	rc = smc_wr_alloc_link_mem(lnk);
+	if (rc)
+		goto clear_llc_lnk;
+	rc = smc_ib_create_protection_domain(lnk);
+	if (rc)
+		goto free_link_mem;
+	rc = smc_ib_create_queue_pair(lnk);
+	if (rc)
+		goto dealloc_pd;
+	rc = smc_wr_create_link(lnk);
+	if (rc)
+		goto destroy_qp;
+	return 0;
+
+destroy_qp:
+	smc_ib_destroy_queue_pair(lnk);
+dealloc_pd:
+	smc_ib_dealloc_protection_domain(lnk);
+free_link_mem:
+	smc_wr_free_link_mem(lnk);
+clear_llc_lnk:
+	smc_llc_link_clear(lnk);
+out:
+	put_device(&ini->ib_dev->ibdev->dev);
+	memset(lnk, 0, sizeof(struct smc_link));
+	if (!atomic_dec_return(&ini->ib_dev->lnk_cnt))
+		wake_up(&ini->ib_dev->lnks_deleted);
+	return rc;
+}
+
 /* create a new SMC link group */
 static int smc_lgr_create(struct smc_sock *smc, struct smc_init_info *ini)
 {
@@ -252,7 +310,6 @@ static int smc_lgr_create(struct smc_sock *smc, struct smc_init_info *ini)
 	struct list_head *lgr_list;
 	struct smc_link *lnk;
 	spinlock_t *lgr_lock;
-	u8 rndvec[3];
 	int rc = 0;
 	int i;
 
@@ -297,48 +354,17 @@ static int smc_lgr_create(struct smc_sock *smc, struct smc_init_info *ini)
 		atomic_inc(&ini->ism_dev->lgr_cnt);
 	} else {
 		/* SMC-R specific settings */
-		get_device(&ini->ib_dev->ibdev->dev);
 		lgr->role = smc->listen_smc ? SMC_SERV : SMC_CLNT;
 		memcpy(lgr->peer_systemid, ini->ib_lcl->id_for_peer,
 		       SMC_SYSTEMID_LEN);
 
 		lnk = &lgr->lnk[SMC_SINGLE_LINK];
-		/* initialize link */
-		lnk->state = SMC_LNK_ACTIVATING;
-		lnk->link_id = SMC_SINGLE_LINK;
-		lnk->smcibdev = ini->ib_dev;
-		lnk->ibport = ini->ib_port;
-		lgr_list = &smc_lgr_list.list;
-		lgr_lock = &smc_lgr_list.lock;
-		lnk->path_mtu =
-			ini->ib_dev->pattr[ini->ib_port - 1].active_mtu;
-		if (!ini->ib_dev->initialized)
-			smc_ib_setup_per_ibdev(ini->ib_dev);
-		get_random_bytes(rndvec, sizeof(rndvec));
-		lnk->psn_initial = rndvec[0] + (rndvec[1] << 8) +
-			(rndvec[2] << 16);
-		rc = smc_ib_determine_gid(lnk->smcibdev, lnk->ibport,
-					  ini->vlan_id, lnk->gid,
-					  &lnk->sgid_index);
-		if (rc)
-			goto free_lgr;
-		rc = smc_llc_link_init(lnk);
+		rc = smcr_link_init(lnk, SMC_SINGLE_LINK, ini);
 		if (rc)
 			goto free_lgr;
-		rc = smc_wr_alloc_link_mem(lnk);
-		if (rc)
-			goto clear_llc_lnk;
-		rc = smc_ib_create_protection_domain(lnk);
-		if (rc)
-			goto free_link_mem;
-		rc = smc_ib_create_queue_pair(lnk);
-		if (rc)
-			goto dealloc_pd;
-		rc = smc_wr_create_link(lnk);
-		if (rc)
-			goto destroy_qp;
+		lgr_list = &smc_lgr_list.list;
+		lgr_lock = &smc_lgr_list.lock;
 		atomic_inc(&lgr_cnt);
-		atomic_inc(&ini->ib_dev->lnk_cnt);
 	}
 	smc->conn.lgr = lgr;
 	spin_lock_bh(lgr_lock);
@@ -346,14 +372,6 @@ static int smc_lgr_create(struct smc_sock *smc, struct smc_init_info *ini)
 	spin_unlock_bh(lgr_lock);
 	return 0;
 
-destroy_qp:
-	smc_ib_destroy_queue_pair(lnk);
-dealloc_pd:
-	smc_ib_dealloc_protection_domain(lnk);
-free_link_mem:
-	smc_wr_free_link_mem(lnk);
-clear_llc_lnk:
-	smc_llc_link_clear(lnk);
 free_lgr:
 	kfree(lgr);
 ism_put_vlan:
@@ -417,7 +435,7 @@ void smc_conn_free(struct smc_connection *conn)
 		smc_lgr_schedule_free_work(lgr);
 }
 
-static void smc_link_clear(struct smc_link *lnk)
+static void smcr_link_clear(struct smc_link *lnk)
 {
 	lnk->peer_qpn = 0;
 	smc_llc_link_clear(lnk);
@@ -426,6 +444,7 @@ static void smc_link_clear(struct smc_link *lnk)
 	smc_ib_destroy_queue_pair(lnk);
 	smc_ib_dealloc_protection_domain(lnk);
 	smc_wr_free_link_mem(lnk);
+	put_device(&lnk->smcibdev->ibdev->dev);
 	if (!atomic_dec_return(&lnk->smcibdev->lnk_cnt))
 		wake_up(&lnk->smcibdev->lnks_deleted);
 }
@@ -512,8 +531,7 @@ static void smc_lgr_free(struct smc_link_group *lgr)
 		if (!atomic_dec_return(&lgr->smcd->lgr_cnt))
 			wake_up(&lgr->smcd->lgrs_deleted);
 	} else {
-		smc_link_clear(&lgr->lnk[SMC_SINGLE_LINK]);
-		put_device(&lgr->lnk[SMC_SINGLE_LINK].smcibdev->ibdev->dev);
+		smcr_link_clear(&lgr->lnk[SMC_SINGLE_LINK]);
 		if (!atomic_dec_return(&lgr_cnt))
 			wake_up(&lgrs_deleted);
 	}
-- 
2.17.1

