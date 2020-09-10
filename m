Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 745D0264A4D
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 18:50:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727027AbgIJQuv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 12:50:51 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:30508 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726951AbgIJQtV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 12:49:21 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08AGbLAc020672;
        Thu, 10 Sep 2020 12:49:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=kriWNmAfiarYeUEiZQcUlGYIGo3BZGpfTE7sAfV+umo=;
 b=rANJHfJOgWtZxgfNpX1eONQYymvOAabKh85+zrEmOdzaoNk0Bwd36TWDn5voSSsEXo1o
 Gs1JIUaXKxbginO9NoaNcOnBgxnyPYs5/OQN5eEBdMYO926NqYxF/5j2sRMzK7+1RUcK
 /M9rbnf62jo2yuWo8hS/8V0dOkvpXPk7ffarQztWCpWtD0cONWEzlGYODCtPuNUp9/Cr
 s1tKCjGjUkilbpTZipSmJyjANjAqze7qcpil2I5Yo2JPLT1/LV8x+jZfwJ86m4N0M/XB
 9qxGVKs277R0Oj00vvbim1UVpfwv2AcJ9zh3LFAGX/lv4qKSdTH99iqY2GfnfCSB7mG6 SQ== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 33fqts0ayr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Sep 2020 12:49:05 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08AGlqQl023937;
        Thu, 10 Sep 2020 16:49:03 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 33c2a86992-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Sep 2020 16:49:03 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08AGn0Gc28836302
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Sep 2020 16:49:00 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C24E74C040;
        Thu, 10 Sep 2020 16:49:00 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 88DF14C052;
        Thu, 10 Sep 2020 16:49:00 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 10 Sep 2020 16:49:00 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net-next 06/10] net/smc: reduce smc_listen_decline() calls
Date:   Thu, 10 Sep 2020 18:48:25 +0200
Message-Id: <20200910164829.65426-7-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200910164829.65426-1-kgraul@linux.ibm.com>
References: <20200910164829.65426-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-10_04:2020-09-10,2020-09-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 phishscore=0
 mlxlogscore=956 suspectscore=1 clxscore=1015 malwarescore=0 adultscore=0
 lowpriorityscore=0 priorityscore=1501 impostorscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009100148
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ursula Braun <ubraun@linux.ibm.com>

smc_listen_work() contains already an smc_listen_decline() exit.
Use this exit for smc_listen_rdma_finish() problems as well.

Signed-off-by: Ursula Braun <ubraun@linux.ibm.com>
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 net/smc/af_smc.c | 22 ++++++----------------
 1 file changed, 6 insertions(+), 16 deletions(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index f27a596b2624..9f3e148c60c5 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -1233,27 +1233,17 @@ static int smc_listen_rdma_finish(struct smc_sock *new_smc,
 	if (local_first)
 		smc_link_save_peer_info(link, cclc);
 
-	if (smc_rmb_rtoken_handling(&new_smc->conn, link, cclc)) {
-		reason_code = SMC_CLC_DECL_ERR_RTOK;
-		goto decline;
-	}
+	if (smc_rmb_rtoken_handling(&new_smc->conn, link, cclc))
+		return SMC_CLC_DECL_ERR_RTOK;
 
 	if (local_first) {
-		if (smc_ib_ready_link(link)) {
-			reason_code = SMC_CLC_DECL_ERR_RDYLNK;
-			goto decline;
-		}
+		if (smc_ib_ready_link(link))
+			return SMC_CLC_DECL_ERR_RDYLNK;
 		/* QP confirmation over RoCE fabric */
 		smc_llc_flow_initiate(link->lgr, SMC_LLC_FLOW_ADD_LINK);
 		reason_code = smcr_serv_conf_first_link(new_smc);
 		smc_llc_flow_stop(link->lgr, &link->lgr->llc_flow_lcl);
-		if (reason_code)
-			goto decline;
 	}
-	return 0;
-
-decline:
-	smc_listen_decline(new_smc, reason_code, local_first);
 	return reason_code;
 }
 
@@ -1382,9 +1372,9 @@ static void smc_listen_work(struct work_struct *work)
 	if (!ism_supported) {
 		rc = smc_listen_rdma_finish(new_smc, &cclc,
 					    ini.first_contact_local);
-		mutex_unlock(&smc_server_lgr_pending);
 		if (rc)
-			return;
+			goto out_unlock;
+		mutex_unlock(&smc_server_lgr_pending);
 	}
 	smc_conn_save_peer_info(new_smc, &cclc);
 	smc_listen_out_connected(new_smc);
-- 
2.17.1

