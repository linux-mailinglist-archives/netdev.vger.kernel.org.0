Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A1DA2AA528
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 14:00:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728098AbgKGNAd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Nov 2020 08:00:33 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:52720 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727298AbgKGNAR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Nov 2020 08:00:17 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A7CUivs129037;
        Sat, 7 Nov 2020 08:00:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=s/HRzeD+3KGfEzpf5dG4UYvemk8/JHV23L+u+8kEYfw=;
 b=CzBrNFU/nnISsvo+0eU5ndOoMdwOAyY3M3y1NiIT7pTgFZqPUZkhHDsNvuXQZW2gfKU2
 pdYi7Gm1fRZpPc4aPJGngNzZUuzETscmRxIUUqOMlfWHBBa9fGES//fjXrlbW+UzX2R2
 np5uPY/lgrBevq5775AuhUMRtypIpO1O4aBP3wkDWs+2kMtu2Ild6yygXbLyTLuLaxzV
 w3/P76uAVVYo/BGDJak5yETX04Sbos30BYoxfXodvybrJRB1Pl0W3ie54AaG38g498w0
 SsTv+fSvC10cudXurKPVfl7ei35mCznRRbN5rksXRqBEMMdQeG+lqkh0vkpFAd4L8PtI VQ== 
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34nreumepx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 07 Nov 2020 08:00:13 -0500
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0A7D0CCZ012499;
        Sat, 7 Nov 2020 13:00:12 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma05fra.de.ibm.com with ESMTP id 34nk7885ey-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 07 Nov 2020 13:00:12 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0A7D08Jm64160190
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 7 Nov 2020 13:00:09 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 198D3A4059;
        Sat,  7 Nov 2020 13:00:08 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E715AA406F;
        Sat,  7 Nov 2020 13:00:07 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Sat,  7 Nov 2020 13:00:07 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        hca@linux.ibm.com, raspl@linux.ibm.com
Subject: [PATCH net-next v3 01/15] net/smc: use helper smc_conn_abort() in listen processing
Date:   Sat,  7 Nov 2020 13:59:44 +0100
Message-Id: <20201107125958.16384-2-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201107125958.16384-1-kgraul@linux.ibm.com>
References: <20201107125958.16384-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-07_07:2020-11-05,2020-11-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_spam_definite policy=outbound score=100 mlxscore=100
 lowpriorityscore=0 malwarescore=0 adultscore=0 spamscore=100
 mlxlogscore=-1000 phishscore=0 bulkscore=0 suspectscore=0 clxscore=1015
 priorityscore=1501 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2011070081
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The helper smc_connect_abort() can be used by the listen processing
functions, too. And rename this helper to smc_conn_abort() to make the
purpose clearer.
No functional change.

Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 net/smc/af_smc.c | 17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 527185af7bf3..bc3e45289771 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -552,8 +552,7 @@ static int smc_connect_decline_fallback(struct smc_sock *smc, int reason_code,
 	return smc_connect_fallback(smc, reason_code);
 }
 
-/* abort connecting */
-static void smc_connect_abort(struct smc_sock *smc, int local_first)
+static void smc_conn_abort(struct smc_sock *smc, int local_first)
 {
 	if (local_first)
 		smc_lgr_cleanup_early(&smc->conn);
@@ -814,7 +813,7 @@ static int smc_connect_rdma(struct smc_sock *smc,
 
 	return 0;
 connect_abort:
-	smc_connect_abort(smc, ini->first_contact_local);
+	smc_conn_abort(smc, ini->first_contact_local);
 	mutex_unlock(&smc_client_lgr_pending);
 	smc->connect_nonblock = 0;
 
@@ -893,7 +892,7 @@ static int smc_connect_ism(struct smc_sock *smc,
 
 	return 0;
 connect_abort:
-	smc_connect_abort(smc, ini->first_contact_local);
+	smc_conn_abort(smc, ini->first_contact_local);
 	mutex_unlock(&smc_server_lgr_pending);
 	smc->connect_nonblock = 0;
 
@@ -1320,10 +1319,7 @@ static void smc_listen_decline(struct smc_sock *new_smc, int reason_code,
 			       int local_first, u8 version)
 {
 	/* RDMA setup failed, switch back to TCP */
-	if (local_first)
-		smc_lgr_cleanup_early(&new_smc->conn);
-	else
-		smc_conn_free(&new_smc->conn);
+	smc_conn_abort(new_smc, local_first);
 	if (reason_code < 0) { /* error, no fallback possible */
 		smc_listen_out_err(new_smc);
 		return;
@@ -1429,10 +1425,7 @@ static int smc_listen_ism_init(struct smc_sock *new_smc,
 	/* Create send and receive buffers */
 	rc = smc_buf_create(new_smc, true);
 	if (rc) {
-		if (ini->first_contact_local)
-			smc_lgr_cleanup_early(&new_smc->conn);
-		else
-			smc_conn_free(&new_smc->conn);
+		smc_conn_abort(new_smc, ini->first_contact_local);
 		return (rc == -ENOSPC) ? SMC_CLC_DECL_MAX_DMB :
 					 SMC_CLC_DECL_MEM;
 	}
-- 
2.17.1

