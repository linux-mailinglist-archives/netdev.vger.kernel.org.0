Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBD182869B6
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 22:57:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728607AbgJGU56 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 16:57:58 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:60110 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726152AbgJGU56 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Oct 2020 16:57:58 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 097KVKVw159547;
        Wed, 7 Oct 2020 16:57:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=/2TBB7FjwbfNzDLsRgLUyJSDwJuYReELu/vhMAtR4Ks=;
 b=buLF7FNr3EDGRhSPNtkOBCxKrQuASUu2wkouB+I6MgdelPL4iSX5MRYrGxRX3XqyO53L
 xsqWcPpEax+qJJBZWAuIz1ADTQcncOyvDaHCEPs1avFNJZwK22l1Be8maiYZUZWI0HhM
 l3++/kr3MLZKqUBC4Db849EiwAyRXdD9j047kIaghWulOjkUA5wqxPvbvqXpg7O3pUnG
 aCYDMt+hpOAgdhriPqfW8ExfWRs8hL10R6ElcBdI3pZ/Xuzcr5RJHkU3fOjx5JuP3Bll
 6XwoyPXDQWiT2Yxm8zhHMlwicv8hsKZJc28QYJg10dtcOrUopGtmFRLRMMowCqye0GZU +w== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 341k93b67t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Oct 2020 16:57:56 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 097Kvbap010688;
        Wed, 7 Oct 2020 20:57:54 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04ams.nl.ibm.com with ESMTP id 33xgx84n9y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Oct 2020 20:57:54 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 097KvqDo25624960
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 7 Oct 2020 20:57:52 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 067B8AE045;
        Wed,  7 Oct 2020 20:57:52 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BF111AE053;
        Wed,  7 Oct 2020 20:57:51 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  7 Oct 2020 20:57:51 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net-next 2/3] net/smc: cleanup buffer usage in smc_listen_work()
Date:   Wed,  7 Oct 2020 22:57:42 +0200
Message-Id: <20201007205743.83535-3-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201007205743.83535-1-kgraul@linux.ibm.com>
References: <20201007205743.83535-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-07_10:2020-10-07,2020-10-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 mlxlogscore=999
 lowpriorityscore=0 bulkscore=0 clxscore=1015 malwarescore=0 suspectscore=1
 impostorscore=0 adultscore=0 priorityscore=1501 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010070127
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

coccinelle informs about
net/smc/af_smc.c:1770:10-11: WARNING: opportunity for kzfree/kvfree_sensitive

Its not that kzfree() would help here, the memset() is done to prepare
the buffer for another socket receive.
Fix that warning message by reordering the calls, while at it eliminate
the unneeded variable cclc2 and use sizeof(*buf) as above in the same
function. No functional changes.

Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 net/smc/af_smc.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index fbe98bb20299..f481f0ed2b78 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -1664,7 +1664,6 @@ static void smc_listen_work(struct work_struct *work)
 						smc_listen_work);
 	u8 version = smc_ism_v2_capable ? SMC_V2 : SMC_V1;
 	struct socket *newclcsock = new_smc->clcsock;
-	struct smc_clc_msg_accept_confirm_v2 *cclc2;
 	struct smc_clc_msg_accept_confirm *cclc;
 	struct smc_clc_msg_proposal_area *buf;
 	struct smc_clc_msg_proposal *pclc;
@@ -1740,11 +1739,9 @@ static void smc_listen_work(struct work_struct *work)
 		mutex_unlock(&smc_server_lgr_pending);
 
 	/* receive SMC Confirm CLC message */
-	cclc2 = (struct smc_clc_msg_accept_confirm_v2 *)buf;
-	cclc = (struct smc_clc_msg_accept_confirm *)cclc2;
-	memset(buf, 0, sizeof(struct smc_clc_msg_proposal_area));
-	rc = smc_clc_wait_msg(new_smc, cclc2,
-			      sizeof(struct smc_clc_msg_proposal_area),
+	memset(buf, 0, sizeof(*buf));
+	cclc = (struct smc_clc_msg_accept_confirm *)buf;
+	rc = smc_clc_wait_msg(new_smc, cclc, sizeof(*buf),
 			      SMC_CLC_CONFIRM, CLC_WAIT_TIME);
 	if (rc) {
 		if (!ini->is_smcd)
-- 
2.17.1

