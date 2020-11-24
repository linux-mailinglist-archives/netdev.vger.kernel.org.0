Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF6C22C2F5A
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 18:54:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404189AbgKXRwc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 12:52:32 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:9742 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2404014AbgKXRwb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 12:52:31 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AOHXt8u048509;
        Tue, 24 Nov 2020 12:52:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=pttTdUESkBeR5eE/dIPitvmuWql6VqLxapQp+i/eeO0=;
 b=nh32bleAx1s+HmPWiOIhRrf31oijy4fRObwXlcKmaVYeraejVSp+QFLdIk/ZKnSxF8dj
 ZkLSLN0EsSd05vNBmdfNHqALjg0raJrvyNFqHaruhEdW1lemo6shTt06bGzzgGdj3Ras
 SX0kOFysa1ss9ZHAX7tNUOYovjZke1US5Xa28ecMISV/WaXiEQ2rS5XOeEDWojKNQpkp
 GWXVsw65rK8qJ5ia8id9c6SRm09rFHHT0EY7B7PxMLNFJZoPgnPG/T2Qu7PwT+d1gKZs
 x7QGoe7IfUI6uLRWtn682LELUUWTFo++LpY9Zj5BRddz5y0rCA2RDurDDGeqgpSPC49N Yw== 
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34ygtu5y0r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 Nov 2020 12:52:27 -0500
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AOHgsNH001671;
        Tue, 24 Nov 2020 17:52:21 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma02fra.de.ibm.com with ESMTP id 350cvrsbtt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 Nov 2020 17:52:21 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AOHp3kx63898100
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Nov 2020 17:51:03 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A3667A4053;
        Tue, 24 Nov 2020 17:51:03 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 76B3EA405F;
        Tue, 24 Nov 2020 17:51:03 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 24 Nov 2020 17:51:03 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Heiko Carstens <hca@linux.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [PATCH net-next v5 01/14] net/smc: use helper smc_conn_abort() in listen processing
Date:   Tue, 24 Nov 2020 18:50:34 +0100
Message-Id: <20201124175047.56949-2-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201124175047.56949-1-kgraul@linux.ibm.com>
References: <20201124175047.56949-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-24_05:2020-11-24,2020-11-24 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 clxscore=1015
 mlxscore=0 impostorscore=0 malwarescore=0 mlxlogscore=948 suspectscore=2
 bulkscore=0 spamscore=0 phishscore=0 lowpriorityscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011240104
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
index 811819c849da..13db3f260e94 100644
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
 
@@ -1321,10 +1320,7 @@ static void smc_listen_decline(struct smc_sock *new_smc, int reason_code,
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
@@ -1430,10 +1426,7 @@ static int smc_listen_ism_init(struct smc_sock *new_smc,
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

