Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 867721C2C40
	for <lists+netdev@lfdr.de>; Sun,  3 May 2020 14:40:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728577AbgECMjz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 May 2020 08:39:55 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:2422 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728309AbgECMjs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 May 2020 08:39:48 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 043CWhQA085719;
        Sun, 3 May 2020 08:39:47 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30s45rntkf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 03 May 2020 08:39:46 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 043CZgHl021496;
        Sun, 3 May 2020 12:39:44 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03fra.de.ibm.com with ESMTP id 30s0g5h24q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 03 May 2020 12:39:44 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 043CdfD742336376
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 3 May 2020 12:39:41 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 70AC94C050;
        Sun,  3 May 2020 12:39:41 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3C0FE4C040;
        Sun,  3 May 2020 12:39:41 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Sun,  3 May 2020 12:39:41 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net-next v2 06/11] net/smc: final part of add link processing as SMC server
Date:   Sun,  3 May 2020 14:38:45 +0200
Message-Id: <20200503123850.57261-7-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200503123850.57261-1-kgraul@linux.ibm.com>
References: <20200503123850.57261-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-05-03_09:2020-05-01,2020-05-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 adultscore=0
 phishscore=0 clxscore=1015 suspectscore=1 impostorscore=0 mlxscore=0
 lowpriorityscore=0 bulkscore=0 spamscore=0 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005030112
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch finalizes the ADD_LINK processing of new links. Send the
CONFIRM_LINK request to the peer, receive the response and set link
state to ACTIVE.

Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
Reviewed-by: Ursula Braun <ubraun@linux.ibm.com>
---
 net/smc/smc_llc.c | 29 ++++++++++++++++++++++++++++-
 1 file changed, 28 insertions(+), 1 deletion(-)

diff --git a/net/smc/smc_llc.c b/net/smc/smc_llc.c
index de73432bd72f..1fefee55e293 100644
--- a/net/smc/smc_llc.c
+++ b/net/smc/smc_llc.c
@@ -904,6 +904,33 @@ static int smc_llc_srv_rkey_exchange(struct smc_link *link,
 	return rc;
 }
 
+static int smc_llc_srv_conf_link(struct smc_link *link,
+				 struct smc_link *link_new,
+				 enum smc_lgr_type lgr_new_t)
+{
+	struct smc_link_group *lgr = link->lgr;
+	struct smc_llc_qentry *qentry = NULL;
+	int rc;
+
+	/* send CONFIRM LINK request over the RoCE fabric */
+	rc = smc_llc_send_confirm_link(link_new, SMC_LLC_REQ);
+	if (rc)
+		return -ENOLINK;
+	/* receive CONFIRM LINK response over the RoCE fabric */
+	qentry = smc_llc_wait(lgr, link, SMC_LLC_WAIT_FIRST_TIME,
+			      SMC_LLC_CONFIRM_LINK);
+	if (!qentry) {
+		/* send DELETE LINK */
+		smc_llc_send_delete_link(link, link_new->link_id, SMC_LLC_REQ,
+					 false, SMC_LLC_DEL_LOST_PATH);
+		return -ENOLINK;
+	}
+	smc_llc_link_active(link_new);
+	lgr->type = lgr_new_t;
+	smc_llc_flow_qentry_del(&lgr->llc_flow_lcl);
+	return 0;
+}
+
 int smc_llc_srv_add_link(struct smc_link *link)
 {
 	enum smc_lgr_type lgr_new_t = SMC_LGR_SYMMETRIC;
@@ -967,7 +994,7 @@ int smc_llc_srv_add_link(struct smc_link *link)
 	rc = smc_llc_srv_rkey_exchange(link, link_new);
 	if (rc)
 		goto out_err;
-	/* tbd: rc = smc_llc_srv_conf_link(link, link_new, lgr_new_t); */
+	rc = smc_llc_srv_conf_link(link, link_new, lgr_new_t);
 	if (rc)
 		goto out_err;
 	return 0;
-- 
2.17.1

