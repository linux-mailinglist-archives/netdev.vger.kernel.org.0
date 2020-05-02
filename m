Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87D841C2563
	for <lists+netdev@lfdr.de>; Sat,  2 May 2020 14:36:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727983AbgEBMgZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 May 2020 08:36:25 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:29224 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727887AbgEBMgT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 May 2020 08:36:19 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 042CW6mq179511;
        Sat, 2 May 2020 08:36:16 -0400
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0b-001b2d01.pphosted.com with ESMTP id 30s2fyysx8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 02 May 2020 08:36:16 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 042CZQIX010194;
        Sat, 2 May 2020 12:36:14 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma01fra.de.ibm.com with ESMTP id 30s0g58a88-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 02 May 2020 12:36:14 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 042CaBMP60293378
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 2 May 2020 12:36:11 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8DD88A405B;
        Sat,  2 May 2020 12:36:11 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 50D6CA405C;
        Sat,  2 May 2020 12:36:11 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Sat,  2 May 2020 12:36:11 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net-next 10/13] net/smc: delete link processing as SMC client
Date:   Sat,  2 May 2020 14:35:49 +0200
Message-Id: <20200502123552.17204-11-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200502123552.17204-1-kgraul@linux.ibm.com>
References: <20200502123552.17204-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-05-02_06:2020-05-01,2020-05-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 malwarescore=0
 suspectscore=1 bulkscore=0 priorityscore=1501 spamscore=0
 lowpriorityscore=0 adultscore=0 phishscore=0 mlxlogscore=999 clxscore=1015
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005020109
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

