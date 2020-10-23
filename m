Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D11B29773E
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 20:48:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1755078AbgJWSso (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 14:48:44 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:8794 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755050AbgJWSsn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Oct 2020 14:48:43 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09NIWobQ010962;
        Fri, 23 Oct 2020 14:48:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=1DsAkIPistgxzpSaj5B/LUtSCFbX6vrmD62UuDFA6SI=;
 b=tGB5AxAgZIKNhsD6KNgZH1ly/D/rul9SCnmTIvXyWHGmNgacywfJC737UuaM6aGSziZV
 eOz1mW2dktRotaZYRUM2OHLnjK7SGkxSh2J6bRJMBMsuwKfkFq5QeFRlRqHdVi5x4tMZ
 J65FbnHfMik9QpRQNHyubP+OwA9r5EsnHyb7aSL8kseItnlQzejWhR2Z5BRqLpVF6RFP
 XaujrJSoT3GSBRKt5SiEyEhrydpTt8LW+LStgn70mh4LXU75YWWkjiCx+hZ03dphcN8x
 +GTGwC4fLynlovFjdNuKF/I93ELr7VtoFUbsU8qYrgp590DAxAdVGUXlTx+Caoiynhbr Fg== 
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34byfqabmk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 23 Oct 2020 14:48:42 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 09NIZTGY007638;
        Fri, 23 Oct 2020 18:48:40 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma02fra.de.ibm.com with ESMTP id 347r883k3f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 23 Oct 2020 18:48:40 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 09NImbbV32702812
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 23 Oct 2020 18:48:37 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7160B4203F;
        Fri, 23 Oct 2020 18:48:37 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 32BF342042;
        Fri, 23 Oct 2020 18:48:37 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 23 Oct 2020 18:48:37 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net 1/3] net/smc: fix null pointer dereference in smc_listen_decline()
Date:   Fri, 23 Oct 2020 20:48:28 +0200
Message-Id: <20201023184830.59548-2-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201023184830.59548-1-kgraul@linux.ibm.com>
References: <20201023184830.59548-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.737
 definitions=2020-10-23_12:2020-10-23,2020-10-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 phishscore=0
 malwarescore=0 spamscore=0 bulkscore=0 mlxscore=0 priorityscore=1501
 lowpriorityscore=0 adultscore=0 clxscore=1015 mlxlogscore=973
 suspectscore=3 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010230113
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

smc_listen_work() calls smc_listen_decline() on label out_decl,
providing the ini pointer variable. But this pointer can still be null
when the label out_decl is reached.
Fix this by checking the ini variable in smc_listen_work() and call
smc_listen_decline() with the result directly.

Fixes: a7c9c5f4af7f ("net/smc: CLC accept / confirm V2")
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 net/smc/af_smc.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 82be0bd0f6e8..e9f487c8c6d5 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -1317,10 +1317,10 @@ static void smc_listen_out_err(struct smc_sock *new_smc)
 
 /* listen worker: decline and fall back if possible */
 static void smc_listen_decline(struct smc_sock *new_smc, int reason_code,
-			       struct smc_init_info *ini, u8 version)
+			       int local_first, u8 version)
 {
 	/* RDMA setup failed, switch back to TCP */
-	if (ini->first_contact_local)
+	if (local_first)
 		smc_lgr_cleanup_early(&new_smc->conn);
 	else
 		smc_conn_free(&new_smc->conn);
@@ -1768,7 +1768,8 @@ static void smc_listen_work(struct work_struct *work)
 out_unlock:
 	mutex_unlock(&smc_server_lgr_pending);
 out_decl:
-	smc_listen_decline(new_smc, rc, ini, version);
+	smc_listen_decline(new_smc, rc, ini ? ini->first_contact_local : 0,
+			   version);
 out_free:
 	kfree(ini);
 	kfree(buf);
-- 
2.17.1

