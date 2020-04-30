Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48A831BFAED
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 15:56:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729207AbgD3N4r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 09:56:47 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:32398 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729204AbgD3N4O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 09:56:14 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03UDaeUm122973;
        Thu, 30 Apr 2020 09:56:12 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30mggwypcr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Apr 2020 09:56:12 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 03UDmNP5022987;
        Thu, 30 Apr 2020 13:56:10 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03ams.nl.ibm.com with ESMTP id 30mcu5tnvm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Apr 2020 13:56:10 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03UDu72T59244640
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Apr 2020 13:56:07 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5EF5A4C044;
        Thu, 30 Apr 2020 13:56:07 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 296C94C046;
        Thu, 30 Apr 2020 13:56:07 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 30 Apr 2020 13:56:07 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net-next 12/14] net/smc: adapt SMC remote DELETE_RKEY processing to use the LLC flow
Date:   Thu, 30 Apr 2020 15:55:49 +0200
Message-Id: <20200430135551.26267-13-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200430135551.26267-1-kgraul@linux.ibm.com>
References: <20200430135551.26267-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-30_08:2020-04-30,2020-04-30 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 spamscore=0
 suspectscore=1 mlxscore=0 lowpriorityscore=0 adultscore=0 phishscore=0
 bulkscore=0 priorityscore=1501 malwarescore=0 clxscore=1015
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004300106
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the LLC flow framework for the processing of DELETE_RKEY messages
that were received from the peer.

Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
Reviewed-by: Ursula Braun <ubraun@linux.ibm.com>
---
 net/smc/smc_llc.c | 37 ++++++++++++++++++++++++-------------
 1 file changed, 24 insertions(+), 13 deletions(-)

diff --git a/net/smc/smc_llc.c b/net/smc/smc_llc.c
index b7b5cc01b78e..e458207bde9e 100644
--- a/net/smc/smc_llc.c
+++ b/net/smc/smc_llc.c
@@ -601,31 +601,37 @@ static void smc_llc_rmt_conf_rkey(struct smc_link_group *lgr)
 	smc_llc_flow_qentry_del(&lgr->llc_flow_rmt);
 }
 
-static void smc_llc_rx_confirm_rkey_cont(struct smc_link *link,
-				      struct smc_llc_msg_confirm_rkey_cont *llc)
-{
-	/* ignore rtokens for other links, we have only one link */
-	llc->hd.flags |= SMC_LLC_FLAG_RESP;
-	smc_llc_send_message(link, llc);
-}
-
-static void smc_llc_rx_delete_rkey(struct smc_link *link,
-				   struct smc_llc_msg_delete_rkey *llc)
+/* process a delete_rkey request from peer, remote flow */
+static void smc_llc_rmt_delete_rkey(struct smc_link_group *lgr)
 {
+	struct smc_llc_msg_delete_rkey *llc;
+	struct smc_llc_qentry *qentry;
+	struct smc_link *link;
 	u8 err_mask = 0;
 	int i, max;
 
+	qentry = lgr->llc_flow_rmt.qentry;
+	llc = &qentry->msg.delete_rkey;
+	link = qentry->link;
+
 	max = min_t(u8, llc->num_rkeys, SMC_LLC_DEL_RKEY_MAX);
 	for (i = 0; i < max; i++) {
 		if (smc_rtoken_delete(link, llc->rkey[i]))
 			err_mask |= 1 << (SMC_LLC_DEL_RKEY_MAX - 1 - i);
 	}
-
 	if (err_mask) {
 		llc->hd.flags |= SMC_LLC_FLAG_RKEY_NEG;
 		llc->err_mask = err_mask;
 	}
+	llc->hd.flags |= SMC_LLC_FLAG_RESP;
+	smc_llc_send_message(link, &qentry->msg);
+	smc_llc_flow_qentry_del(&lgr->llc_flow_rmt);
+}
 
+static void smc_llc_rx_confirm_rkey_cont(struct smc_link *link,
+				      struct smc_llc_msg_confirm_rkey_cont *llc)
+{
+	/* ignore rtokens for other links, we have only one link */
 	llc->hd.flags |= SMC_LLC_FLAG_RESP;
 	smc_llc_send_message(link, llc);
 }
@@ -698,8 +704,13 @@ static void smc_llc_event_handler(struct smc_llc_qentry *qentry)
 		smc_llc_rx_confirm_rkey_cont(link, &llc->confirm_rkey_cont);
 		break;
 	case SMC_LLC_DELETE_RKEY:
-		smc_llc_rx_delete_rkey(link, &llc->delete_rkey);
-		break;
+		/* new request from remote, assign to remote flow */
+		if (smc_llc_flow_start(&lgr->llc_flow_rmt, qentry)) {
+			/* process here, does not wait for more llc msgs */
+			smc_llc_rmt_delete_rkey(lgr);
+			smc_llc_flow_stop(lgr, &lgr->llc_flow_rmt);
+		}
+		return;
 	}
 out:
 	kfree(qentry);
-- 
2.17.1

