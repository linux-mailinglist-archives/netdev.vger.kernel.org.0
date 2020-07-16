Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BEEE222735
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 17:38:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728972AbgGPPiZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 11:38:25 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:31714 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729230AbgGPPiX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 11:38:23 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06GFWM45058844;
        Thu, 16 Jul 2020 11:38:22 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32792xc941-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Jul 2020 11:38:21 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 06GFc1CW007615;
        Thu, 16 Jul 2020 15:38:01 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03fra.de.ibm.com with ESMTP id 327527jx2m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Jul 2020 15:38:01 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 06GFbuq739583868
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jul 2020 15:37:56 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4B7884204B;
        Thu, 16 Jul 2020 15:37:56 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0B87942049;
        Thu, 16 Jul 2020 15:37:56 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 16 Jul 2020 15:37:55 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net 05/10] net/smc: drop out-of-flow llc response messages
Date:   Thu, 16 Jul 2020 17:37:41 +0200
Message-Id: <20200716153746.77303-6-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200716153746.77303-1-kgraul@linux.ibm.com>
References: <20200716153746.77303-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-16_06:2020-07-16,2020-07-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=1
 mlxlogscore=999 priorityscore=1501 lowpriorityscore=0 clxscore=1015
 adultscore=0 impostorscore=0 spamscore=0 malwarescore=0 bulkscore=0
 mlxscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007160114
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

