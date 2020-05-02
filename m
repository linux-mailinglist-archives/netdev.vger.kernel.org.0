Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A0E91C255D
	for <lists+netdev@lfdr.de>; Sat,  2 May 2020 14:36:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727948AbgEBMgU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 May 2020 08:36:20 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:7468 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727882AbgEBMgS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 May 2020 08:36:18 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 042CXVgL103742;
        Sat, 2 May 2020 08:36:17 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30s3696yfg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 02 May 2020 08:36:16 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 042CaEa5027837;
        Sat, 2 May 2020 12:36:14 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04fra.de.ibm.com with ESMTP id 30s0g60a8q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 02 May 2020 12:36:14 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 042CaBah64881140
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 2 May 2020 12:36:11 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D84DDA405C;
        Sat,  2 May 2020 12:36:11 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9B212A4060;
        Sat,  2 May 2020 12:36:11 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Sat,  2 May 2020 12:36:11 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net-next 11/13] net/smc: delete link processing as SMC server
Date:   Sat,  2 May 2020 14:35:50 +0200
Message-Id: <20200502123552.17204-12-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200502123552.17204-1-kgraul@linux.ibm.com>
References: <20200502123552.17204-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-05-02_06:2020-05-01,2020-05-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 adultscore=0
 bulkscore=0 priorityscore=1501 mlxscore=0 phishscore=0 clxscore=1015
 malwarescore=0 suspectscore=1 spamscore=0 lowpriorityscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005020114
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

