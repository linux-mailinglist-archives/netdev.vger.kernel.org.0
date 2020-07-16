Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB26B22272D
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 17:38:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729193AbgGPPiN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 11:38:13 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:36034 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729081AbgGPPiI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 11:38:08 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06GFV6TU176572;
        Thu, 16 Jul 2020 11:38:03 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 329r210m9t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Jul 2020 11:38:03 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 06GFZ5Co013682;
        Thu, 16 Jul 2020 15:38:02 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03ams.nl.ibm.com with ESMTP id 327527wrnw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Jul 2020 15:38:01 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 06GFbuod39583874
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jul 2020 15:37:56 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9BD2F42041;
        Thu, 16 Jul 2020 15:37:56 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 593184203F;
        Thu, 16 Jul 2020 15:37:56 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 16 Jul 2020 15:37:56 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net 06/10] net/smc: move add link processing for new device into llc layer
Date:   Thu, 16 Jul 2020 17:37:42 +0200
Message-Id: <20200716153746.77303-7-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200716153746.77303-1-kgraul@linux.ibm.com>
References: <20200716153746.77303-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-16_07:2020-07-16,2020-07-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 bulkscore=0 adultscore=0 spamscore=0 mlxscore=0 phishscore=0
 malwarescore=0 clxscore=1015 priorityscore=1501 impostorscore=0
 mlxlogscore=999 suspectscore=3 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2007160114
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a new ib device is up smc will send an add link invitation to the
peer if needed. This is currently done with rudimentary flow control.
Under high workload these add link invitations can disturb other llc
flows because they arrive unexpected. Fix this by integrating the
invitations into the normal llc event flow and handle them as a flow.
While at it, check for already assigned requests in the flow before
the new add link request is assigned.

Reviewed-by: Ursula Braun <ubraun@linux.ibm.com>
Fixes: 1f90a05d9ff9 ("net/smc: add smcr_port_add() and smcr_link_up() processing")
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 net/smc/smc_core.c | 80 ++++------------------------------------------
 net/smc/smc_llc.c  | 56 ++++++++++++++++++++++++++++----
 net/smc/smc_llc.h  |  2 +-
 3 files changed, 58 insertions(+), 80 deletions(-)

diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index e286b3c8c962..2e965de7412d 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -45,18 +45,10 @@ static struct smc_lgr_list smc_lgr_list = {	/* established link groups */
 static atomic_t lgr_cnt = ATOMIC_INIT(0); /* number of existing link groups */
 static DECLARE_WAIT_QUEUE_HEAD(lgrs_deleted);
 
-struct smc_ib_up_work {
-	struct work_struct	work;
-	struct smc_link_group	*lgr;
-	struct smc_ib_device	*smcibdev;
-	u8			ibport;
-};
-
 static void smc_buf_free(struct smc_link_group *lgr, bool is_rmb,
 			 struct smc_buf_desc *buf_desc);
 static void __smc_lgr_terminate(struct smc_link_group *lgr, bool soft);
 
-static void smc_link_up_work(struct work_struct *work);
 static void smc_link_down_work(struct work_struct *work);
 
 /* return head of link group list and its lock for a given link group */
@@ -1106,67 +1098,23 @@ static void smc_conn_abort_work(struct work_struct *work)
 	sock_put(&smc->sk); /* sock_hold done by schedulers of abort_work */
 }
 
-/* link is up - establish alternate link if applicable */
-static void smcr_link_up(struct smc_link_group *lgr,
-			 struct smc_ib_device *smcibdev, u8 ibport)
-{
-	struct smc_link *link = NULL;
-
-	if (list_empty(&lgr->list) ||
-	    lgr->type == SMC_LGR_SYMMETRIC ||
-	    lgr->type == SMC_LGR_ASYMMETRIC_PEER)
-		return;
-
-	if (lgr->role == SMC_SERV) {
-		/* trigger local add link processing */
-		link = smc_llc_usable_link(lgr);
-		if (!link)
-			return;
-		smc_llc_srv_add_link_local(link);
-	} else {
-		/* invite server to start add link processing */
-		u8 gid[SMC_GID_SIZE];
-
-		if (smc_ib_determine_gid(smcibdev, ibport, lgr->vlan_id, gid,
-					 NULL))
-			return;
-		if (lgr->llc_flow_lcl.type != SMC_LLC_FLOW_NONE) {
-			/* some other llc task is ongoing */
-			wait_event_timeout(lgr->llc_flow_waiter,
-				(list_empty(&lgr->list) ||
-				 lgr->llc_flow_lcl.type == SMC_LLC_FLOW_NONE),
-				SMC_LLC_WAIT_TIME);
-		}
-		/* lgr or device no longer active? */
-		if (!list_empty(&lgr->list) &&
-		    smc_ib_port_active(smcibdev, ibport))
-			link = smc_llc_usable_link(lgr);
-		if (link)
-			smc_llc_send_add_link(link, smcibdev->mac[ibport - 1],
-					      gid, NULL, SMC_LLC_REQ);
-		wake_up(&lgr->llc_flow_waiter);	/* wake up next waiter */
-	}
-}
-
 void smcr_port_add(struct smc_ib_device *smcibdev, u8 ibport)
 {
-	struct smc_ib_up_work *ib_work;
 	struct smc_link_group *lgr, *n;
 
 	list_for_each_entry_safe(lgr, n, &smc_lgr_list.list, list) {
+		struct smc_link *link;
+
 		if (strncmp(smcibdev->pnetid[ibport - 1], lgr->pnet_id,
 			    SMC_MAX_PNETID_LEN) ||
 		    lgr->type == SMC_LGR_SYMMETRIC ||
 		    lgr->type == SMC_LGR_ASYMMETRIC_PEER)
 			continue;
-		ib_work = kmalloc(sizeof(*ib_work), GFP_KERNEL);
-		if (!ib_work)
-			continue;
-		INIT_WORK(&ib_work->work, smc_link_up_work);
-		ib_work->lgr = lgr;
-		ib_work->smcibdev = smcibdev;
-		ib_work->ibport = ibport;
-		schedule_work(&ib_work->work);
+
+		/* trigger local add link processing */
+		link = smc_llc_usable_link(lgr);
+		if (link)
+			smc_llc_add_link_local(link);
 	}
 }
 
@@ -1249,20 +1197,6 @@ void smcr_port_err(struct smc_ib_device *smcibdev, u8 ibport)
 	}
 }
 
-static void smc_link_up_work(struct work_struct *work)
-{
-	struct smc_ib_up_work *ib_work = container_of(work,
-						      struct smc_ib_up_work,
-						      work);
-	struct smc_link_group *lgr = ib_work->lgr;
-
-	if (list_empty(&lgr->list))
-		goto out;
-	smcr_link_up(lgr, ib_work->smcibdev, ib_work->ibport);
-out:
-	kfree(ib_work);
-}
-
 static void smc_link_down_work(struct work_struct *work)
 {
 	struct smc_link *link = container_of(work, struct smc_link,
diff --git a/net/smc/smc_llc.c b/net/smc/smc_llc.c
index 78704f03e72a..30da040ab5b6 100644
--- a/net/smc/smc_llc.c
+++ b/net/smc/smc_llc.c
@@ -895,6 +895,36 @@ int smc_llc_cli_add_link(struct smc_link *link, struct smc_llc_qentry *qentry)
 	return rc;
 }
 
+/* as an SMC client, invite server to start the add_link processing */
+static void smc_llc_cli_add_link_invite(struct smc_link *link,
+					struct smc_llc_qentry *qentry)
+{
+	struct smc_link_group *lgr = smc_get_lgr(link);
+	struct smc_init_info ini;
+
+	if (lgr->type == SMC_LGR_SYMMETRIC ||
+	    lgr->type == SMC_LGR_ASYMMETRIC_PEER)
+		goto out;
+
+	ini.vlan_id = lgr->vlan_id;
+	smc_pnet_find_alt_roce(lgr, &ini, link->smcibdev);
+	if (!ini.ib_dev)
+		goto out;
+
+	smc_llc_send_add_link(link, ini.ib_dev->mac[ini.ib_port - 1],
+			      ini.ib_gid, NULL, SMC_LLC_REQ);
+out:
+	kfree(qentry);
+}
+
+static bool smc_llc_is_local_add_link(union smc_llc_msg *llc)
+{
+	if (llc->raw.hdr.common.type == SMC_LLC_ADD_LINK &&
+	    !llc->add_link.qp_mtu && !llc->add_link.link_num)
+		return true;
+	return false;
+}
+
 static void smc_llc_process_cli_add_link(struct smc_link_group *lgr)
 {
 	struct smc_llc_qentry *qentry;
@@ -902,7 +932,10 @@ static void smc_llc_process_cli_add_link(struct smc_link_group *lgr)
 	qentry = smc_llc_flow_qentry_clr(&lgr->llc_flow_lcl);
 
 	mutex_lock(&lgr->llc_conf_mutex);
-	smc_llc_cli_add_link(qentry->link, qentry);
+	if (smc_llc_is_local_add_link(&qentry->msg))
+		smc_llc_cli_add_link_invite(qentry->link, qentry);
+	else
+		smc_llc_cli_add_link(qentry->link, qentry);
 	mutex_unlock(&lgr->llc_conf_mutex);
 }
 
@@ -1160,14 +1193,14 @@ static void smc_llc_process_srv_add_link(struct smc_link_group *lgr)
 	mutex_unlock(&lgr->llc_conf_mutex);
 }
 
-/* enqueue a local add_link req to trigger a new add_link flow, only as SERV */
-void smc_llc_srv_add_link_local(struct smc_link *link)
+/* enqueue a local add_link req to trigger a new add_link flow */
+void smc_llc_add_link_local(struct smc_link *link)
 {
 	struct smc_llc_msg_add_link add_llc = {0};
 
 	add_llc.hd.length = sizeof(add_llc);
 	add_llc.hd.common.type = SMC_LLC_ADD_LINK;
-	/* no dev and port needed, we as server ignore client data anyway */
+	/* no dev and port needed */
 	smc_llc_enqueue(link, (union smc_llc_msg *)&add_llc);
 }
 
@@ -1347,7 +1380,7 @@ static void smc_llc_process_srv_delete_link(struct smc_link_group *lgr)
 
 	if (lgr->type == SMC_LGR_SINGLE && !list_empty(&lgr->list)) {
 		/* trigger setup of asymm alt link */
-		smc_llc_srv_add_link_local(lnk);
+		smc_llc_add_link_local(lnk);
 	}
 out:
 	mutex_unlock(&lgr->llc_conf_mutex);
@@ -1476,7 +1509,18 @@ static void smc_llc_event_handler(struct smc_llc_qentry *qentry)
 		if (list_empty(&lgr->list))
 			goto out;	/* lgr is terminating */
 		if (lgr->role == SMC_CLNT) {
-			if (lgr->llc_flow_lcl.type == SMC_LLC_FLOW_ADD_LINK) {
+			if (smc_llc_is_local_add_link(llc)) {
+				if (lgr->llc_flow_lcl.type ==
+				    SMC_LLC_FLOW_ADD_LINK)
+					break;	/* add_link in progress */
+				if (smc_llc_flow_start(&lgr->llc_flow_lcl,
+						       qentry)) {
+					schedule_work(&lgr->llc_add_link_work);
+				}
+				return;
+			}
+			if (lgr->llc_flow_lcl.type == SMC_LLC_FLOW_ADD_LINK &&
+			    !lgr->llc_flow_lcl.qentry) {
 				/* a flow is waiting for this message */
 				smc_llc_flow_qentry_set(&lgr->llc_flow_lcl,
 							qentry);
diff --git a/net/smc/smc_llc.h b/net/smc/smc_llc.h
index a5d2fe3eea61..cc00a2ec4e92 100644
--- a/net/smc/smc_llc.h
+++ b/net/smc/smc_llc.h
@@ -103,7 +103,7 @@ void smc_llc_send_link_delete_all(struct smc_link_group *lgr, bool ord,
 				  u32 rsn);
 int smc_llc_cli_add_link(struct smc_link *link, struct smc_llc_qentry *qentry);
 int smc_llc_srv_add_link(struct smc_link *link);
-void smc_llc_srv_add_link_local(struct smc_link *link);
+void smc_llc_add_link_local(struct smc_link *link);
 int smc_llc_init(void) __init;
 
 #endif /* SMC_LLC_H */
-- 
2.17.1

