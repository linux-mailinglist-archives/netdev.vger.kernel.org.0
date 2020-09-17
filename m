Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5ACD826E707
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 23:03:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726494AbgIQVC6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 17:02:58 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:49002 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726180AbgIQVC6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 17:02:58 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08HKWnn3027734;
        Thu, 17 Sep 2020 16:46:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=6wKuA5zs4Fqt1g+n3S7zrJDqBW5Pw53cE8A/0gHwkEs=;
 b=LsJam/1zJkLKNi1+drkNrO7oNclewOjRde7qr1CmZ5yyWCu/O9zsJ6Cikq6F/LiDSZGQ
 wCTM8Dd6CtYGRC0M0gYBeLyZgArKjZdpUmA6YtHi+6RGhzOqdhXwiIQdelTt1QefAEUF
 AhQxdJJoxcG9kCyuSthlEtXh5eLv+I8o/KH5xKbEYIlU7jbuvXM3IyKfI9b1swmvRPOb
 9JXOBedHwYTnxuc+iOWTWSO6dIZQ2WKAUFECYUpz98FgT+q/Be12stG9KQENC4Hfz/MU
 ZLDKiXvkIXU8KQFTDtFgYsiNnQTWzWwR3poZ/In9a6LIgCYWs8nOVkWfkynV4mI1uAN1 Sw== 
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33mduw1w4h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Sep 2020 16:46:17 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08HKhbrq007624;
        Thu, 17 Sep 2020 20:46:15 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma01fra.de.ibm.com with ESMTP id 33k5v999j6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Sep 2020 20:46:15 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08HKkCYr16318844
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Sep 2020 20:46:12 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7BE3211C04A;
        Thu, 17 Sep 2020 20:46:12 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 39FA611C052;
        Thu, 17 Sep 2020 20:46:12 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 17 Sep 2020 20:46:12 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net-next 1/1] net/smc: fix double kfree in smc_listen_work()
Date:   Thu, 17 Sep 2020 22:46:02 +0200
Message-Id: <20200917204602.14586-2-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200917204602.14586-1-kgraul@linux.ibm.com>
References: <20200917204602.14586-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-17_17:2020-09-16,2020-09-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 bulkscore=0
 lowpriorityscore=0 phishscore=0 impostorscore=0 mlxlogscore=999 mlxscore=0
 adultscore=0 spamscore=0 clxscore=1015 priorityscore=1501 suspectscore=3
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009170151
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ursula Braun <ubraun@linux.ibm.com>

If smc_listen_rmda_finish() returns with an error, the storage
addressed by 'buf' is freed a second time.
Consolidate freeing under a common label and jump to that label.

Fixes: 6bb14e48ee8d ("net/smc: dynamic allocation of CLC proposal buffer")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Ursula Braun <ubraun@linux.ibm.com>
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 net/smc/af_smc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index f5bececfedaa..ed8f97166be9 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -1371,7 +1371,6 @@ static void smc_listen_work(struct work_struct *work)
 	}
 
 	/* finish worker */
-	kfree(buf);
 	if (!ism_supported) {
 		rc = smc_listen_rdma_finish(new_smc, &cclc,
 					    ini.first_contact_local);
@@ -1381,12 +1380,13 @@ static void smc_listen_work(struct work_struct *work)
 	}
 	smc_conn_save_peer_info(new_smc, &cclc);
 	smc_listen_out_connected(new_smc);
-	return;
+	goto out_free;
 
 out_unlock:
 	mutex_unlock(&smc_server_lgr_pending);
 out_decl:
 	smc_listen_decline(new_smc, rc, ini.first_contact_local);
+out_free:
 	kfree(buf);
 }
 
-- 
2.17.1

