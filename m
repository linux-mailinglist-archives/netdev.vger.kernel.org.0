Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88BE11C2C48
	for <lists+netdev@lfdr.de>; Sun,  3 May 2020 14:40:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728528AbgECMjw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 May 2020 08:39:52 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:32998 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728427AbgECMjt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 May 2020 08:39:49 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 043CWVHZ167418;
        Sun, 3 May 2020 08:39:47 -0400
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0b-001b2d01.pphosted.com with ESMTP id 30s50emkdr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 03 May 2020 08:39:47 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 043CZZS4018418;
        Sun, 3 May 2020 12:39:45 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma01fra.de.ibm.com with ESMTP id 30s0g592bp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 03 May 2020 12:39:45 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 043CdgRb31064140
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 3 May 2020 12:39:42 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7EF0B4C040;
        Sun,  3 May 2020 12:39:42 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4A23B4C046;
        Sun,  3 May 2020 12:39:42 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Sun,  3 May 2020 12:39:42 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net-next v2 10/11] net/smc: delete link processing as SMC server
Date:   Sun,  3 May 2020 14:38:49 +0200
Message-Id: <20200503123850.57261-11-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200503123850.57261-1-kgraul@linux.ibm.com>
References: <20200503123850.57261-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-05-03_09:2020-05-01,2020-05-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 clxscore=1015 impostorscore=0 adultscore=0 priorityscore=1501
 malwarescore=0 phishscore=0 mlxscore=0 spamscore=0 mlxlogscore=999
 bulkscore=0 suspectscore=1 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005030112
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add smc_llc_process_srv_delete_link() to process a DELETE_LINK request
as SMC server. When the request is to delete ALL links then terminate
the whole link group. If not, find the link to delete by its link_id,
send the DELETE_LINK request LLC message and wait for the response.
No matter if a response was received, clear the deleted link and update
the link group state.

Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
Reviewed-by: Ursula Braun <ubraun@linux.ibm.com>
---
 net/smc/smc_llc.c | 72 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 72 insertions(+)

diff --git a/net/smc/smc_llc.c b/net/smc/smc_llc.c
index cd57b4fb1842..ac065f6d60dc 100644
--- a/net/smc/smc_llc.c
+++ b/net/smc/smc_llc.c
@@ -1187,6 +1187,76 @@ static void smc_llc_process_cli_delete_link(struct smc_link_group *lgr)
 	kfree(qentry);
 }
 
+static void smc_llc_process_srv_delete_link(struct smc_link_group *lgr)
+{
+	struct smc_llc_msg_del_link *del_llc;
+	struct smc_link *lnk, *lnk_del;
+	struct smc_llc_qentry *qentry;
+	int active_links;
+	int i;
+
+	mutex_lock(&lgr->llc_conf_mutex);
+	qentry = smc_llc_flow_qentry_clr(&lgr->llc_flow_lcl);
+	lnk = qentry->link;
+	del_llc = &qentry->msg.delete_link;
+
+	if (qentry->msg.delete_link.hd.flags & SMC_LLC_FLAG_DEL_LINK_ALL) {
+		/* delete entire lgr */
+		smc_lgr_terminate_sched(lgr);
+		goto out;
+	}
+	/* delete single link */
+	lnk_del = NULL;
+	for (i = 0; i < SMC_LINKS_PER_LGR_MAX; i++) {
+		if (lgr->lnk[i].link_id == del_llc->link_num) {
+			lnk_del = &lgr->lnk[i];
+			break;
+		}
+	}
+	if (!lnk_del)
+		goto out; /* asymmetric link already deleted */
+
+	if (smc_link_downing(&lnk_del->state)) {
+		/* tbd: call smc_switch_conns(lgr, lnk_del, false); */
+		smc_wr_tx_wait_no_pending_sends(lnk_del);
+	}
+	if (!list_empty(&lgr->list)) {
+		/* qentry is either a request from peer (send it back to
+		 * initiate the DELETE_LINK processing), or a locally
+		 * enqueued DELETE_LINK request (forward it)
+		 */
+		if (!smc_llc_send_message(lnk, &qentry->msg)) {
+			struct smc_llc_msg_del_link *del_llc_resp;
+			struct smc_llc_qentry *qentry2;
+
+			qentry2 = smc_llc_wait(lgr, lnk, SMC_LLC_WAIT_TIME,
+					       SMC_LLC_DELETE_LINK);
+			if (!qentry2) {
+			} else {
+				del_llc_resp = &qentry2->msg.delete_link;
+				smc_llc_flow_qentry_del(&lgr->llc_flow_lcl);
+			}
+		}
+	}
+	smcr_link_clear(lnk_del);
+
+	active_links = smc_llc_active_link_count(lgr);
+	if (active_links == 1) {
+		lgr->type = SMC_LGR_SINGLE;
+	} else if (!active_links) {
+		lgr->type = SMC_LGR_NONE;
+		smc_lgr_terminate_sched(lgr);
+	}
+
+	if (lgr->type == SMC_LGR_SINGLE && !list_empty(&lgr->list)) {
+		/* trigger setup of asymm alt link */
+		/* tbd: call smc_llc_srv_add_link_local(lnk); */
+	}
+out:
+	mutex_unlock(&lgr->llc_conf_mutex);
+	kfree(qentry);
+}
+
 static void smc_llc_delete_link_work(struct work_struct *work)
 {
 	struct smc_link_group *lgr = container_of(work, struct smc_link_group,
@@ -1200,6 +1270,8 @@ static void smc_llc_delete_link_work(struct work_struct *work)
 
 	if (lgr->role == SMC_CLNT)
 		smc_llc_process_cli_delete_link(lgr);
+	else
+		smc_llc_process_srv_delete_link(lgr);
 out:
 	smc_llc_flow_stop(lgr, &lgr->llc_flow_lcl);
 }
-- 
2.17.1

