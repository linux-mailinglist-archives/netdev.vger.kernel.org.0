Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1F5A4126C8
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 21:20:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346056AbhITTWQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 15:22:16 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:42142 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1347595AbhITTUH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 15:20:07 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18KJGBiX000922;
        Mon, 20 Sep 2021 15:18:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=veuPbfNTbz1JI+88wVt/wDZSMUBOyLnuUNjo6E9fK18=;
 b=pt4TEFNnEarjahZXE2rQubWIKNb4QJh9OIDNZUxJOZIECrXKUUGCwxIW06sth6plvwzz
 loZJhD7L3A+LU1R9FC8+trWWdEpa+y3aYEXIAiasJgQ+EssYB3PP4LYYsS1dZSYm6vlb
 ieKs0/y5J71Zk1RpolL9MryJTRndqZOHbNUpc3qbOjr2Gqf1EUw1YA3ICfwqgDkNpQO7
 46WxESQKmLSTSUx+jgn1OwS1Y4lkmB2Cc3aeKN3bXPmXC3CzvUZ+VMZ4ooe56EGjAXbV
 4ALXXgx/Bo9FzF9NHo/KAJxJYoer2jxGy8QRIUrKd8VVvuDz+HUL1G0R8MgRyCL5xNhs fA== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3b5w0pkfc0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Sep 2021 15:18:37 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18KJ37QG016306;
        Mon, 20 Sep 2021 19:18:35 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03ams.nl.ibm.com with ESMTP id 3b57r8mesv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Sep 2021 19:18:35 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18KJDniA42598886
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Sep 2021 19:13:49 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1BBF411C04A;
        Mon, 20 Sep 2021 19:18:32 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C0BA411C04C;
        Mon, 20 Sep 2021 19:18:31 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 20 Sep 2021 19:18:31 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>,
        Guvenc Gulce <guvenc@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net 2/2] net/smc: fix 'workqueue leaked lock' in smc_conn_abort_work
Date:   Mon, 20 Sep 2021 21:18:15 +0200
Message-Id: <20210920191815.2919121-3-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210920191815.2919121-1-kgraul@linux.ibm.com>
References: <20210920191815.2919121-1-kgraul@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: _0HkWZfF2MbEl9suIejtDl2U9-DJjJnu
X-Proofpoint-GUID: _0HkWZfF2MbEl9suIejtDl2U9-DJjJnu
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-20_07,2021-09-20_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 adultscore=0
 mlxscore=0 lowpriorityscore=0 suspectscore=0 mlxlogscore=909 spamscore=0
 clxscore=1015 priorityscore=1501 malwarescore=0 impostorscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109200111
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The abort_work is scheduled when a connection was detected to be
out-of-sync after a link failure. The work calls smc_conn_kill(),
which calls smc_close_active_abort() and that might end up calling
smc_close_cancel_work().
smc_close_cancel_work() cancels any pending close_work and tx_work but
needs to release the sock_lock before and acquires the sock_lock again
afterwards. So when the sock_lock was NOT acquired before then it may
be held after the abort_work completes. Thats why the sock_lock is
acquired before the call to smc_conn_kill() in __smc_lgr_terminate(),
but this is missing in smc_conn_abort_work().

Fix that by acquiring the sock_lock first and release it after the
call to smc_conn_kill().

Fixes: b286a0651e44 ("net/smc: handle incoming CDC validation message")
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 net/smc/smc_core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index af227b65669e..8280c938be80 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -1474,7 +1474,9 @@ static void smc_conn_abort_work(struct work_struct *work)
 						   abort_work);
 	struct smc_sock *smc = container_of(conn, struct smc_sock, conn);
 
+	lock_sock(&smc->sk);
 	smc_conn_kill(conn, true);
+	release_sock(&smc->sk);
 	sock_put(&smc->sk); /* sock_hold done by schedulers of abort_work */
 }
 
-- 
2.25.1

