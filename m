Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26A09DEEFF
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 16:13:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729093AbfJUON3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 10:13:29 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:33530 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727344AbfJUON3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 10:13:29 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x9LEDLUQ059933
        for <netdev@vger.kernel.org>; Mon, 21 Oct 2019 10:13:28 -0400
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2vsbkn7epp-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 21 Oct 2019 10:13:27 -0400
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <kgraul@linux.ibm.com>;
        Mon, 21 Oct 2019 15:13:24 +0100
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 21 Oct 2019 15:13:23 +0100
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x9LECnjC11076068
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Oct 2019 14:12:49 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C817D4C04E;
        Mon, 21 Oct 2019 14:13:21 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8999C4C05A;
        Mon, 21 Oct 2019 14:13:21 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 21 Oct 2019 14:13:21 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        gor@linux.ibm.com, heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net-next 5/8] net/smc: tell peers about abnormal link group termination
Date:   Mon, 21 Oct 2019 16:13:12 +0200
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191021141315.58969-1-kgraul@linux.ibm.com>
References: <20191021141315.58969-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19102114-0028-0000-0000-000003ACF267
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19102114-0029-0000-0000-0000246F19C6
Message-Id: <20191021141315.58969-6-kgraul@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-21_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1910210135
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ursula Braun <ubraun@linux.ibm.com>

There are lots of link group termination scenarios. Most of them
still allow to inform the peer of the terminating sockets about aborting.
This patch tries to call smc_close_abort() for terminating sockets.

And the internal TCP socket is reset with tcp_abort().

Signed-off-by: Ursula Braun <ubraun@linux.ibm.com>
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 net/smc/smc_close.c | 9 ++++-----
 net/smc/smc_close.h | 1 +
 net/smc/smc_core.c  | 2 +-
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/smc/smc_close.c b/net/smc/smc_close.c
index 1d706c581592..2bbcd45a421e 100644
--- a/net/smc/smc_close.c
+++ b/net/smc/smc_close.c
@@ -13,6 +13,7 @@
 #include <linux/sched/signal.h>
 
 #include <net/sock.h>
+#include <net/tcp.h>
 
 #include "smc.h"
 #include "smc_tx.h"
@@ -102,7 +103,7 @@ static int smc_close_final(struct smc_connection *conn)
 	return smc_cdc_get_slot_and_msg_send(conn);
 }
 
-static int smc_close_abort(struct smc_connection *conn)
+int smc_close_abort(struct smc_connection *conn)
 {
 	conn->local_tx_ctrl.conn_state_flags.peer_conn_abort = 1;
 
@@ -118,10 +119,8 @@ static void smc_close_active_abort(struct smc_sock *smc)
 
 	if (sk->sk_state != SMC_INIT && smc->clcsock && smc->clcsock->sk) {
 		sk->sk_err = ECONNABORTED;
-		if (smc->clcsock && smc->clcsock->sk) {
-			smc->clcsock->sk->sk_err = ECONNABORTED;
-			smc->clcsock->sk->sk_state_change(smc->clcsock->sk);
-		}
+		if (smc->clcsock && smc->clcsock->sk)
+			tcp_abort(smc->clcsock->sk, ECONNABORTED);
 	}
 	switch (sk->sk_state) {
 	case SMC_ACTIVE:
diff --git a/net/smc/smc_close.h b/net/smc/smc_close.h
index e0e3b5df25d2..084c4f37aa96 100644
--- a/net/smc/smc_close.h
+++ b/net/smc/smc_close.h
@@ -24,5 +24,6 @@ int smc_close_active(struct smc_sock *smc);
 int smc_close_shutdown_write(struct smc_sock *smc);
 void smc_close_init(struct smc_sock *smc);
 void smc_clcsock_release(struct smc_sock *smc);
+int smc_close_abort(struct smc_connection *conn);
 
 #endif /* SMC_CLOSE_H */
diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index e7e9dbcd7d8b..494288f32df6 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -513,8 +513,8 @@ static void __smc_lgr_terminate(struct smc_link_group *lgr)
 		smc = container_of(conn, struct smc_sock, conn);
 		lock_sock(&smc->sk);
 		sock_hold(&smc->sk); /* sock_put in close work */
+		smc_close_abort(conn);
 		conn->killed = 1;
-		conn->local_tx_ctrl.conn_state_flags.peer_conn_abort = 1;
 		smc_lgr_unregister_conn(conn);
 		conn->lgr = NULL;
 		if (!schedule_work(&conn->close_work))
-- 
2.17.1

