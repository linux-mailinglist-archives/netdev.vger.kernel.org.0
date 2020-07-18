Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A738224B5D
	for <lists+netdev@lfdr.de>; Sat, 18 Jul 2020 15:09:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727814AbgGRNHG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jul 2020 09:07:06 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:50222 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727055AbgGRNGy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jul 2020 09:06:54 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06ID2g8j087302;
        Sat, 18 Jul 2020 09:06:52 -0400
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0b-001b2d01.pphosted.com with ESMTP id 32bw7wm9h2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 18 Jul 2020 09:06:52 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 06ID6pJm005781;
        Sat, 18 Jul 2020 13:06:51 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06fra.de.ibm.com with ESMTP id 32brbgr6d6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 18 Jul 2020 13:06:50 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 06ID6mCd62062718
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 18 Jul 2020 13:06:48 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 29A30AE045;
        Sat, 18 Jul 2020 13:06:48 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E18C7AE051;
        Sat, 18 Jul 2020 13:06:47 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Sat, 18 Jul 2020 13:06:47 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net v2 07/10] net/smc: fix handling of delete link requests
Date:   Sat, 18 Jul 2020 15:06:15 +0200
Message-Id: <20200718130618.16724-8-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200718130618.16724-1-kgraul@linux.ibm.com>
References: <20200718130618.16724-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-18_05:2020-07-17,2020-07-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxscore=0
 bulkscore=0 lowpriorityscore=0 phishscore=0 malwarescore=0 spamscore=0
 suspectscore=1 priorityscore=1501 impostorscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007180099
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

