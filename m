Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C664A224B61
	for <lists+netdev@lfdr.de>; Sat, 18 Jul 2020 15:09:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727839AbgGRNHM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jul 2020 09:07:12 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:58184 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726837AbgGRNGy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jul 2020 09:06:54 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06ID1tDY089761;
        Sat, 18 Jul 2020 09:06:53 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32bsyefrgj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 18 Jul 2020 09:06:53 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 06ID5kT0011704;
        Sat, 18 Jul 2020 13:06:50 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma02fra.de.ibm.com with ESMTP id 32brq7rck3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 18 Jul 2020 13:06:50 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 06ID6lo932244040
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 18 Jul 2020 13:06:47 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 86252AE053;
        Sat, 18 Jul 2020 13:06:47 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 493D9AE055;
        Sat, 18 Jul 2020 13:06:47 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Sat, 18 Jul 2020 13:06:47 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net v2 05/10] net/smc: drop out-of-flow llc response messages
Date:   Sat, 18 Jul 2020 15:06:13 +0200
Message-Id: <20200718130618.16724-6-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200718130618.16724-1-kgraul@linux.ibm.com>
References: <20200718130618.16724-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-18_05:2020-07-17,2020-07-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 priorityscore=1501 suspectscore=1 spamscore=0 clxscore=1015
 impostorscore=0 lowpriorityscore=0 mlxlogscore=999 mlxscore=0 phishscore=0
 adultscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2007180095
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To be save from unexpected or late llc response messages check if the
arrived message fits to the current flow type and drop out-of-flow
messages. And drop it when there is already a response assigned to
the flow.

Reviewed-by: Ursula Braun <ubraun@linux.ibm.com>
Fixes: ef79d439cd12 ("net/smc: process llc responses in tasklet context")
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 net/smc/smc_llc.c | 24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/net/smc/smc_llc.c b/net/smc/smc_llc.c
index 58f4da2e0cc7..78704f03e72a 100644
--- a/net/smc/smc_llc.c
+++ b/net/smc/smc_llc.c
@@ -1587,6 +1587,8 @@ static void smc_llc_event_work(struct work_struct *work)
 static void smc_llc_rx_response(struct smc_link *link,
 				struct smc_llc_qentry *qentry)
 {
+	enum smc_llc_flowtype flowtype = link->lgr->llc_flow_lcl.type;
+	struct smc_llc_flow *flow = &link->lgr->llc_flow_lcl;
 	u8 llc_type = qentry->msg.raw.hdr.common.type;
 
 	switch (llc_type) {
@@ -1595,15 +1597,20 @@ static void smc_llc_rx_response(struct smc_link *link,
 			complete(&link->llc_testlink_resp);
 		break;
 	case SMC_LLC_ADD_LINK:
-	case SMC_LLC_DELETE_LINK:
-	case SMC_LLC_CONFIRM_LINK:
 	case SMC_LLC_ADD_LINK_CONT:
+	case SMC_LLC_CONFIRM_LINK:
+		if (flowtype != SMC_LLC_FLOW_ADD_LINK || flow->qentry)
+			break;	/* drop out-of-flow response */
+		goto assign;
+	case SMC_LLC_DELETE_LINK:
+		if (flowtype != SMC_LLC_FLOW_DEL_LINK || flow->qentry)
+			break;	/* drop out-of-flow response */
+		goto assign;
 	case SMC_LLC_CONFIRM_RKEY:
 	case SMC_LLC_DELETE_RKEY:
-		/* assign responses to the local flow, we requested them */
-		smc_llc_flow_qentry_set(&link->lgr->llc_flow_lcl, qentry);
-		wake_up(&link->lgr->llc_msg_waiter);
-		return;
+		if (flowtype != SMC_LLC_FLOW_RKEY || flow->qentry)
+			break;	/* drop out-of-flow response */
+		goto assign;
 	case SMC_LLC_CONFIRM_RKEY_CONT:
 		/* not used because max links is 3 */
 		break;
@@ -1612,6 +1619,11 @@ static void smc_llc_rx_response(struct smc_link *link,
 		break;
 	}
 	kfree(qentry);
+	return;
+assign:
+	/* assign responses to the local flow, we requested them */
+	smc_llc_flow_qentry_set(&link->lgr->llc_flow_lcl, qentry);
+	wake_up(&link->lgr->llc_msg_waiter);
 }
 
 static void smc_llc_enqueue(struct smc_link *link, union smc_llc_msg *llc)
-- 
2.17.1

