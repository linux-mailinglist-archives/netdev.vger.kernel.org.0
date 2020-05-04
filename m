Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 807B61C392B
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 14:19:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728778AbgEDMTW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 08:19:22 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:35632 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726744AbgEDMTP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 08:19:15 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 044CCYMc069415;
        Mon, 4 May 2020 08:19:13 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 30s50fgq9j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 May 2020 08:19:13 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 044C9rSW011619;
        Mon, 4 May 2020 12:19:11 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04ams.nl.ibm.com with ESMTP id 30s0g5mr15-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 May 2020 12:19:11 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 044CJ9XR13041924
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 4 May 2020 12:19:09 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EC1CDA4040;
        Mon,  4 May 2020 12:19:08 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BA5A9A4053;
        Mon,  4 May 2020 12:19:08 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  4 May 2020 12:19:08 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net-next 06/12] net/smc: send DELETE_LINK,ALL message and wait for send to complete
Date:   Mon,  4 May 2020 14:18:42 +0200
Message-Id: <20200504121848.46585-7-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200504121848.46585-1-kgraul@linux.ibm.com>
References: <20200504121848.46585-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-05-04_05:2020-05-04,2020-05-04 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 clxscore=1015 impostorscore=0 adultscore=0 priorityscore=1501
 malwarescore=0 phishscore=0 mlxscore=0 spamscore=0 mlxlogscore=999
 bulkscore=0 suspectscore=3 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005040100
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add smc_llc_send_message_wait() which uses smc_wr_tx_send_wait() to send
an LLC message and waits for the message send to complete.
smc_llc_send_link_delete_all() calls the new function to send an
DELETE_LINK,ALL LLC message. The RFC states that the sender of this type
of message needs to wait for the completion event of the message
transmission and can terminate the link afterwards.

Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
Reviewed-by: Ursula Braun <ubraun@linux.ibm.com>
---
 net/smc/smc_core.c |  5 +++++
 net/smc/smc_llc.c  | 44 ++++++++++++++++++++++++++++++++++++++++++++
 net/smc/smc_llc.h  |  2 ++
 3 files changed, 51 insertions(+)

diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index b5633fa19b6d..8f630b76c5a4 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -238,6 +238,9 @@ static void smc_lgr_free_work(struct work_struct *work)
 	spin_unlock_bh(lgr_lock);
 	cancel_delayed_work(&lgr->free_work);
 
+	if (!lgr->is_smcd && !lgr->terminating)
+		smc_llc_send_link_delete_all(lgr, true,
+					     SMC_LLC_DEL_PROG_INIT_TERM);
 	if (lgr->is_smcd && !lgr->terminating)
 		smc_ism_signal_shutdown(lgr);
 	if (!lgr->is_smcd) {
@@ -847,6 +850,8 @@ static void smc_lgr_cleanup(struct smc_link_group *lgr)
 		smc_ism_put_vlan(lgr->smcd, lgr->vlan_id);
 		put_device(&lgr->smcd->dev);
 	} else {
+		smc_llc_send_link_delete_all(lgr, false,
+					     SMC_LLC_DEL_OP_INIT_TERM);
 		for (i = 0; i < SMC_LINKS_PER_LGR_MAX; i++) {
 			struct smc_link *lnk = &lgr->lnk[i];
 
diff --git a/net/smc/smc_llc.c b/net/smc/smc_llc.c
index 8d2368accbad..0ea7ad6188ae 100644
--- a/net/smc/smc_llc.c
+++ b/net/smc/smc_llc.c
@@ -560,6 +560,25 @@ static int smc_llc_send_message(struct smc_link *link, void *llcbuf)
 	return smc_wr_tx_send(link, pend);
 }
 
+/* schedule an llc send on link, may wait for buffers,
+ * and wait for send completion notification.
+ * @return 0 on success
+ */
+static int smc_llc_send_message_wait(struct smc_link *link, void *llcbuf)
+{
+	struct smc_wr_tx_pend_priv *pend;
+	struct smc_wr_buf *wr_buf;
+	int rc;
+
+	if (!smc_link_usable(link))
+		return -ENOLINK;
+	rc = smc_llc_add_pending_send(link, &wr_buf, &pend);
+	if (rc)
+		return rc;
+	memcpy(wr_buf, llcbuf, sizeof(union smc_llc_msg));
+	return smc_wr_tx_send_wait(link, pend, SMC_LLC_WAIT_TIME);
+}
+
 /********************************* receive ***********************************/
 
 static int smc_llc_alloc_alt_link(struct smc_link_group *lgr,
@@ -1215,6 +1234,29 @@ static void smc_llc_process_cli_delete_link(struct smc_link_group *lgr)
 	kfree(qentry);
 }
 
+/* try to send a DELETE LINK ALL request on any active link,
+ * waiting for send completion
+ */
+void smc_llc_send_link_delete_all(struct smc_link_group *lgr, bool ord, u32 rsn)
+{
+	struct smc_llc_msg_del_link delllc = {0};
+	int i;
+
+	delllc.hd.common.type = SMC_LLC_DELETE_LINK;
+	delllc.hd.length = sizeof(delllc);
+	if (ord)
+		delllc.hd.flags |= SMC_LLC_FLAG_DEL_LINK_ORDERLY;
+	delllc.hd.flags |= SMC_LLC_FLAG_DEL_LINK_ALL;
+	delllc.reason = htonl(rsn);
+
+	for (i = 0; i < SMC_LINKS_PER_LGR_MAX; i++) {
+		if (!smc_link_usable(&lgr->lnk[i]))
+			continue;
+		if (!smc_llc_send_message_wait(&lgr->lnk[i], &delllc))
+			break;
+	}
+}
+
 static void smc_llc_process_srv_delete_link(struct smc_link_group *lgr)
 {
 	struct smc_llc_msg_del_link *del_llc;
@@ -1230,6 +1272,8 @@ static void smc_llc_process_srv_delete_link(struct smc_link_group *lgr)
 
 	if (qentry->msg.delete_link.hd.flags & SMC_LLC_FLAG_DEL_LINK_ALL) {
 		/* delete entire lgr */
+		smc_llc_send_link_delete_all(lgr, true, ntohl(
+					      qentry->msg.delete_link.reason));
 		smc_lgr_terminate_sched(lgr);
 		goto out;
 	}
diff --git a/net/smc/smc_llc.h b/net/smc/smc_llc.h
index c335fc5f363c..6d2a5d943b83 100644
--- a/net/smc/smc_llc.h
+++ b/net/smc/smc_llc.h
@@ -89,6 +89,8 @@ struct smc_llc_qentry *smc_llc_wait(struct smc_link_group *lgr,
 				    int time_out, u8 exp_msg);
 struct smc_llc_qentry *smc_llc_flow_qentry_clr(struct smc_llc_flow *flow);
 void smc_llc_flow_qentry_del(struct smc_llc_flow *flow);
+void smc_llc_send_link_delete_all(struct smc_link_group *lgr, bool ord,
+				  u32 rsn);
 int smc_llc_cli_add_link(struct smc_link *link, struct smc_llc_qentry *qentry);
 int smc_llc_srv_add_link(struct smc_link *link);
 void smc_llc_srv_add_link_local(struct smc_link *link);
-- 
2.17.1

