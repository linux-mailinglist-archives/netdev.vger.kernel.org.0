Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 014EE1C2C41
	for <lists+netdev@lfdr.de>; Sun,  3 May 2020 14:40:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728599AbgECMj6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 May 2020 08:39:58 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:56274 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728359AbgECMjs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 May 2020 08:39:48 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 043CW9RD145601;
        Sun, 3 May 2020 08:39:46 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 30s2g0qqb9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 03 May 2020 08:39:46 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 043CZOna026289;
        Sun, 3 May 2020 12:39:45 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04ams.nl.ibm.com with ESMTP id 30s0g5jmbt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 03 May 2020 12:39:45 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 043CdgiX55967780
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 3 May 2020 12:39:42 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3F6134C044;
        Sun,  3 May 2020 12:39:42 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0A8E94C05A;
        Sun,  3 May 2020 12:39:42 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Sun,  3 May 2020 12:39:41 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net-next v2 09/11] net/smc: delete link processing as SMC client
Date:   Sun,  3 May 2020 14:38:48 +0200
Message-Id: <20200503123850.57261-10-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200503123850.57261-1-kgraul@linux.ibm.com>
References: <20200503123850.57261-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-05-03_09:2020-05-01,2020-05-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 malwarescore=0
 suspectscore=1 bulkscore=0 priorityscore=1501 spamscore=0
 lowpriorityscore=0 adultscore=0 phishscore=0 mlxlogscore=999 clxscore=1015
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005030110
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add smc_llc_process_cli_delete_link() to process a DELETE_LINK request
as SMC client. When the request is to delete ALL links then terminate
the whole link group. If not, find the link to delete by its link_id,
send the DELETE_LINK response LLC message and then clear the deleted
link. Finally determine and update the link group state.

Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
Reviewed-by: Ursula Braun <ubraun@linux.ibm.com>
---
 net/smc/smc_llc.c | 72 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 72 insertions(+)

diff --git a/net/smc/smc_llc.c b/net/smc/smc_llc.c
index e4e3910a9624..cd57b4fb1842 100644
--- a/net/smc/smc_llc.c
+++ b/net/smc/smc_llc.c
@@ -863,6 +863,18 @@ static void smc_llc_process_cli_add_link(struct smc_link_group *lgr)
 	mutex_unlock(&lgr->llc_conf_mutex);
 }
 
+static int smc_llc_active_link_count(struct smc_link_group *lgr)
+{
+	int i, link_count = 0;
+
+	for (i = 0; i < SMC_LINKS_PER_LGR_MAX; i++) {
+		if (!smc_link_usable(&lgr->lnk[i]))
+			continue;
+		link_count++;
+	}
+	return link_count;
+}
+
 /* find the asymmetric link when 3 links are established  */
 static struct smc_link *smc_llc_find_asym_link(struct smc_link_group *lgr)
 {
@@ -1118,6 +1130,63 @@ static void smc_llc_add_link_work(struct work_struct *work)
 	smc_llc_flow_stop(lgr, &lgr->llc_flow_lcl);
 }
 
+static void smc_llc_process_cli_delete_link(struct smc_link_group *lgr)
+{
+	struct smc_link *lnk_del = NULL, *lnk_asym, *lnk;
+	struct smc_llc_msg_del_link *del_llc;
+	struct smc_llc_qentry *qentry;
+	int active_links;
+	int lnk_idx;
+
+	qentry = smc_llc_flow_qentry_clr(&lgr->llc_flow_lcl);
+	lnk = qentry->link;
+	del_llc = &qentry->msg.delete_link;
+
+	if (del_llc->hd.flags & SMC_LLC_FLAG_DEL_LINK_ALL) {
+		smc_lgr_terminate_sched(lgr);
+		goto out;
+	}
+	mutex_lock(&lgr->llc_conf_mutex);
+	/* delete single link */
+	for (lnk_idx = 0; lnk_idx < SMC_LINKS_PER_LGR_MAX; lnk_idx++) {
+		if (lgr->lnk[lnk_idx].link_id != del_llc->link_num)
+			continue;
+		lnk_del = &lgr->lnk[lnk_idx];
+		break;
+	}
+	del_llc->hd.flags |= SMC_LLC_FLAG_RESP;
+	if (!lnk_del) {
+		/* link was not found */
+		del_llc->reason = htonl(SMC_LLC_DEL_NOLNK);
+		smc_llc_send_message(lnk, &qentry->msg);
+		goto out_unlock;
+	}
+	lnk_asym = smc_llc_find_asym_link(lgr);
+
+	del_llc->reason = 0;
+	smc_llc_send_message(lnk, &qentry->msg); /* response */
+
+	if (smc_link_downing(&lnk_del->state)) {
+		/* tbd: call smc_switch_conns(lgr, lnk_del, false); */
+		smc_wr_tx_wait_no_pending_sends(lnk_del);
+	}
+	smcr_link_clear(lnk_del);
+
+	active_links = smc_llc_active_link_count(lgr);
+	if (lnk_del == lnk_asym) {
+		/* expected deletion of asym link, don't change lgr state */
+	} else if (active_links == 1) {
+		lgr->type = SMC_LGR_SINGLE;
+	} else if (!active_links) {
+		lgr->type = SMC_LGR_NONE;
+		smc_lgr_terminate_sched(lgr);
+	}
+out_unlock:
+	mutex_unlock(&lgr->llc_conf_mutex);
+out:
+	kfree(qentry);
+}
+
 static void smc_llc_delete_link_work(struct work_struct *work)
 {
 	struct smc_link_group *lgr = container_of(work, struct smc_link_group,
@@ -1128,6 +1197,9 @@ static void smc_llc_delete_link_work(struct work_struct *work)
 		smc_llc_flow_qentry_del(&lgr->llc_flow_lcl);
 		goto out;
 	}
+
+	if (lgr->role == SMC_CLNT)
+		smc_llc_process_cli_delete_link(lgr);
 out:
 	smc_llc_flow_stop(lgr, &lgr->llc_flow_lcl);
 }
-- 
2.17.1

