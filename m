Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C79FE2A345E
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 20:39:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727035AbgKBTjl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 14:39:41 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:14576 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726509AbgKBTjk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 14:39:40 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A2JaxpP065522
        for <netdev@vger.kernel.org>; Mon, 2 Nov 2020 14:39:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=s/HRzeD+3KGfEzpf5dG4UYvemk8/JHV23L+u+8kEYfw=;
 b=YQMZl/Bns89jlvSg77lcPX+UB2XqwzkUV0GUGTAMif+DFY+fnMCWJzBz9RcIFZap+uEu
 upa6U0xOfoc0wkC+F37Deyx4KM+1E1yhE6XMQRk8TPU1wouHQG3sElbFvQZrufyWO8+G
 AjZXWZBnVugavf4Xs/RIn+jqLeF7p4DurTo/5MeKtNw6ToznYbDWvfuw7Avbcdwm+2wP
 7dWBcMLJobbf0PXwebJ6zQOHBmm0me9R2syAJW8mDzX8PjoJQ9yaJ36iKpK1pl4OQ36J
 SNg2SJfPVciZECN8RAWEbSM7BFOY8Ftuxjl5GNf1baJdD1lUh+5pjikG3132XU9Tr7wY Bg== 
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34hn6ge7x9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 02 Nov 2020 14:39:38 -0500
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0A2JXdkj031970
        for <netdev@vger.kernel.org>; Mon, 2 Nov 2020 19:34:28 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma01fra.de.ibm.com with ESMTP id 34jbytrbb8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 02 Nov 2020 19:34:28 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0A2JYQxi9503328
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <netdev@vger.kernel.org>; Mon, 2 Nov 2020 19:34:26 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E684A4C040;
        Mon,  2 Nov 2020 19:34:25 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B2E6F4C04A;
        Mon,  2 Nov 2020 19:34:25 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  2 Nov 2020 19:34:25 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        hca@linux.ibm.com, raspl@linux.ibm.com
Subject: [PATCH net-next 01/15] net/smc: use helper smc_conn_abort() in listen processing
Date:   Mon,  2 Nov 2020 20:33:55 +0100
Message-Id: <20201102193409.70901-2-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201102193409.70901-1-kgraul@linux.ibm.com>
References: <20201102193409.70901-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-02_13:2020-11-02,2020-11-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=3 clxscore=1015
 phishscore=0 mlxscore=0 bulkscore=0 mlxlogscore=717 lowpriorityscore=0
 malwarescore=0 priorityscore=1501 spamscore=0 adultscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011020145
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

