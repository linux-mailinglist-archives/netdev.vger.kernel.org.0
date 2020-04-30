Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F326C1BFAD6
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 15:56:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729232AbgD3N4R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 09:56:17 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:19770 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728919AbgD3N4N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 09:56:13 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03UDabgU014329;
        Thu, 30 Apr 2020 09:56:11 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30q7qjyph2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Apr 2020 09:56:11 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 03UDmR2E031741;
        Thu, 30 Apr 2020 13:56:09 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04ams.nl.ibm.com with ESMTP id 30mcu72qe4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Apr 2020 13:56:09 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03UDu77e62914654
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Apr 2020 13:56:07 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1E64A4C044;
        Thu, 30 Apr 2020 13:56:07 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D8B6C4C04A;
        Thu, 30 Apr 2020 13:56:06 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 30 Apr 2020 13:56:06 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net-next 11/14] net/smc: adapt SMC remote CONFIRM_RKEY processing to use the LLC flow
Date:   Thu, 30 Apr 2020 15:55:48 +0200
Message-Id: <20200430135551.26267-12-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200430135551.26267-1-kgraul@linux.ibm.com>
References: <20200430135551.26267-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-30_08:2020-04-30,2020-04-30 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 spamscore=0
 priorityscore=1501 bulkscore=0 malwarescore=0 suspectscore=1
 mlxlogscore=999 lowpriorityscore=0 phishscore=0 adultscore=0
 impostorscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2004300111
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the LLC flow framework for the processing of CONFIRM_RKEY messages
that were received from the peer.

Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
Reviewed-by: Ursula Braun <ubraun@linux.ibm.com>
---
 net/smc/smc_llc.c | 56 ++++++++++++++++++++++++++++++++++-------------
 1 file changed, 41 insertions(+), 15 deletions(-)

diff --git a/net/smc/smc_llc.c b/net/smc/smc_llc.c
index 4945abbad111..b7b5cc01b78e 100644
--- a/net/smc/smc_llc.c
+++ b/net/smc/smc_llc.c
@@ -105,6 +105,7 @@ struct smc_llc_msg_confirm_rkey_cont {	/* type 0x08 */
 };
 
 #define SMC_LLC_DEL_RKEY_MAX	8
+#define SMC_LLC_FLAG_RKEY_RETRY	0x10
 #define SMC_LLC_FLAG_RKEY_NEG	0x20
 
 struct smc_llc_msg_delete_rkey {	/* type 0x09 */
@@ -563,21 +564,41 @@ static void smc_llc_rx_delete_link(struct smc_link *link,
 	smc_lgr_terminate_sched(lgr);
 }
 
-static void smc_llc_rx_confirm_rkey(struct smc_link *link,
-				    struct smc_llc_msg_confirm_rkey *llc)
+/* process a confirm_rkey request from peer, remote flow */
+static void smc_llc_rmt_conf_rkey(struct smc_link_group *lgr)
 {
-	int rc;
-
-	rc = smc_rtoken_add(link,
-			    llc->rtoken[0].rmb_vaddr,
-			    llc->rtoken[0].rmb_key);
-
-	/* ignore rtokens for other links, we have only one link */
-
+	struct smc_llc_msg_confirm_rkey *llc;
+	struct smc_llc_qentry *qentry;
+	struct smc_link *link;
+	int num_entries;
+	int rk_idx;
+	int i;
+
+	qentry = lgr->llc_flow_rmt.qentry;
+	llc = &qentry->msg.confirm_rkey;
+	link = qentry->link;
+
+	num_entries = llc->rtoken[0].num_rkeys;
+	/* first rkey entry is for receiving link */
+	rk_idx = smc_rtoken_add(link,
+				llc->rtoken[0].rmb_vaddr,
+				llc->rtoken[0].rmb_key);
+	if (rk_idx < 0)
+		goto out_err;
+
+	for (i = 1; i <= min_t(u8, num_entries, SMC_LLC_RKEYS_PER_MSG - 1); i++)
+		smc_rtoken_set2(lgr, rk_idx, llc->rtoken[i].link_id,
+				llc->rtoken[i].rmb_vaddr,
+				llc->rtoken[i].rmb_key);
+	/* max links is 3 so there is no need to support conf_rkey_cont msgs */
+	goto out;
+out_err:
+	llc->hd.flags |= SMC_LLC_FLAG_RKEY_NEG;
+	llc->hd.flags |= SMC_LLC_FLAG_RKEY_RETRY;
+out:
 	llc->hd.flags |= SMC_LLC_FLAG_RESP;
-	if (rc < 0)
-		llc->hd.flags |= SMC_LLC_FLAG_RKEY_NEG;
-	smc_llc_send_message(link, llc);
+	smc_llc_send_message(link, &qentry->msg);
+	smc_llc_flow_qentry_del(&lgr->llc_flow_rmt);
 }
 
 static void smc_llc_rx_confirm_rkey_cont(struct smc_link *link,
@@ -666,8 +687,13 @@ static void smc_llc_event_handler(struct smc_llc_qentry *qentry)
 		smc_llc_rx_delete_link(link, &llc->delete_link);
 		break;
 	case SMC_LLC_CONFIRM_RKEY:
-		smc_llc_rx_confirm_rkey(link, &llc->confirm_rkey);
-		break;
+		/* new request from remote, assign to remote flow */
+		if (smc_llc_flow_start(&lgr->llc_flow_rmt, qentry)) {
+			/* process here, does not wait for more llc msgs */
+			smc_llc_rmt_conf_rkey(lgr);
+			smc_llc_flow_stop(lgr, &lgr->llc_flow_rmt);
+		}
+		return;
 	case SMC_LLC_CONFIRM_RKEY_CONT:
 		smc_llc_rx_confirm_rkey_cont(link, &llc->confirm_rkey_cont);
 		break;
-- 
2.17.1

