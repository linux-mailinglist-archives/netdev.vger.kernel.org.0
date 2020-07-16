Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA705222725
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 17:38:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729154AbgGPPiH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 11:38:07 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:5034 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728951AbgGPPiF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 11:38:05 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06GFZDQF044137;
        Thu, 16 Jul 2020 11:38:04 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 329uejq4h8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Jul 2020 11:38:04 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 06GFVfRn022561;
        Thu, 16 Jul 2020 15:38:02 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06ams.nl.ibm.com with ESMTP id 3274pgwjnw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Jul 2020 15:38:01 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 06GFbvKL58327294
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jul 2020 15:37:57 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E875942049;
        Thu, 16 Jul 2020 15:37:56 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A944742047;
        Thu, 16 Jul 2020 15:37:56 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 16 Jul 2020 15:37:56 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net 07/10] net/smc: fix handling of delete link requests
Date:   Thu, 16 Jul 2020 17:37:43 +0200
Message-Id: <20200716153746.77303-8-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200716153746.77303-1-kgraul@linux.ibm.com>
References: <20200716153746.77303-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-16_07:2020-07-16,2020-07-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 malwarescore=0 priorityscore=1501 spamscore=0 phishscore=0 adultscore=0
 suspectscore=1 mlxlogscore=999 clxscore=1015 lowpriorityscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007160114
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As smc client the delete link requests are assigned to the flow when
_any_ flow is active. This may break other flows that do not expect
delete link requests during their handling. Fix that by assigning the
request only when an add link flow is active. With that fix the code
for smc client and smc server is the same, so remove the separate
handling.

Reviewed-by: Ursula Braun <ubraun@linux.ibm.com>
Fixes: 9ec6bf19ec8b ("net/smc: llc_del_link_work and use the LLC flow for delete link")
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 net/smc/smc_llc.c | 29 +++++++----------------------
 1 file changed, 7 insertions(+), 22 deletions(-)

diff --git a/net/smc/smc_llc.c b/net/smc/smc_llc.c
index 30da040ab5b6..fa8cd57a9b32 100644
--- a/net/smc/smc_llc.c
+++ b/net/smc/smc_llc.c
@@ -1544,28 +1544,13 @@ static void smc_llc_event_handler(struct smc_llc_qentry *qentry)
 		}
 		break;
 	case SMC_LLC_DELETE_LINK:
-		if (lgr->role == SMC_CLNT) {
-			/* server requests to delete this link, send response */
-			if (lgr->llc_flow_lcl.type != SMC_LLC_FLOW_NONE) {
-				/* DEL LINK REQ during ADD LINK SEQ */
-				smc_llc_flow_qentry_set(&lgr->llc_flow_lcl,
-							qentry);
-				wake_up(&lgr->llc_msg_waiter);
-			} else if (smc_llc_flow_start(&lgr->llc_flow_lcl,
-						      qentry)) {
-				schedule_work(&lgr->llc_del_link_work);
-			}
-		} else {
-			if (lgr->llc_flow_lcl.type == SMC_LLC_FLOW_ADD_LINK &&
-			    !lgr->llc_flow_lcl.qentry) {
-				/* DEL LINK REQ during ADD LINK SEQ */
-				smc_llc_flow_qentry_set(&lgr->llc_flow_lcl,
-							qentry);
-				wake_up(&lgr->llc_msg_waiter);
-			} else if (smc_llc_flow_start(&lgr->llc_flow_lcl,
-						      qentry)) {
-				schedule_work(&lgr->llc_del_link_work);
-			}
+		if (lgr->llc_flow_lcl.type == SMC_LLC_FLOW_ADD_LINK &&
+		    !lgr->llc_flow_lcl.qentry) {
+			/* DEL LINK REQ during ADD LINK SEQ */
+			smc_llc_flow_qentry_set(&lgr->llc_flow_lcl, qentry);
+			wake_up(&lgr->llc_msg_waiter);
+		} else if (smc_llc_flow_start(&lgr->llc_flow_lcl, qentry)) {
+			schedule_work(&lgr->llc_del_link_work);
 		}
 		return;
 	case SMC_LLC_CONFIRM_RKEY:
-- 
2.17.1

