Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECA10DEF06
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 16:13:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729134AbfJUONb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 10:13:31 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:51802 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729112AbfJUONa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 10:13:30 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x9LEDIPk003867
        for <netdev@vger.kernel.org>; Mon, 21 Oct 2019 10:13:30 -0400
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2vsd0ekv0v-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 21 Oct 2019 10:13:29 -0400
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <kgraul@linux.ibm.com>;
        Mon, 21 Oct 2019 15:13:27 +0100
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 21 Oct 2019 15:13:24 +0100
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x9LEDNob11468818
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Oct 2019 14:13:23 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3461E4C066;
        Mon, 21 Oct 2019 14:13:22 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DFAE14C05C;
        Mon, 21 Oct 2019 14:13:21 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 21 Oct 2019 14:13:21 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        gor@linux.ibm.com, heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net-next 6/8] net/smc: improve abnormal termination of link groups
Date:   Mon, 21 Oct 2019 16:13:13 +0200
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191021141315.58969-1-kgraul@linux.ibm.com>
References: <20191021141315.58969-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19102114-0020-0000-0000-0000037BFAED
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19102114-0021-0000-0000-000021D23249
Message-Id: <20191021141315.58969-7-kgraul@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-21_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1910210135
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ursula Braun <ubraun@linux.ibm.com>

If a link group and its connections must be terminated,
* wake up socket waiters
* do not enable buffer reuse

A linkgroup might be terminated while normal connection closing
is running. Avoid buffer reuse and its related LLC DELETE RKEY
call, if linkgroup termination has started. And use the earliest
indication of linkgroup termination possible, namely the removal
from the linkgroup list.

Signed-off-by: Ursula Braun <ubraun@linux.ibm.com>
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 net/smc/smc_core.c | 40 +++++++++++++++++++++++++++++-----------
 1 file changed, 29 insertions(+), 11 deletions(-)

diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index 494288f32df6..6faaa38412b1 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -154,6 +154,7 @@ static void smc_lgr_unregister_conn(struct smc_connection *conn)
 		__smc_lgr_unregister_conn(conn);
 	}
 	write_unlock_bh(&lgr->conns_lock);
+	conn->lgr = NULL;
 }
 
 /* Send delete link, either as client to request the initiation
@@ -344,7 +345,7 @@ static void smc_buf_unuse(struct smc_connection *conn,
 		conn->sndbuf_desc->used = 0;
 	if (conn->rmb_desc) {
 		if (!conn->rmb_desc->regerr) {
-			if (!lgr->is_smcd) {
+			if (!lgr->is_smcd && !list_empty(&lgr->list)) {
 				/* unregister rmb with peer */
 				smc_llc_do_delete_rkey(
 						&lgr->lnk[SMC_SINGLE_LINK],
@@ -375,9 +376,10 @@ void smc_conn_free(struct smc_connection *conn)
 	} else {
 		smc_cdc_tx_dismiss_slots(conn);
 	}
-	smc_lgr_unregister_conn(conn);
-	smc_buf_unuse(conn, lgr);		/* allow buffer reuse */
-	conn->lgr = NULL;
+	if (!list_empty(&lgr->list)) {
+		smc_lgr_unregister_conn(conn);
+		smc_buf_unuse(conn, lgr); /* allow buffer reuse */
+	}
 
 	if (!lgr->conns_num)
 		smc_lgr_schedule_free_work(lgr);
@@ -491,6 +493,28 @@ void smc_lgr_forget(struct smc_link_group *lgr)
 	spin_unlock_bh(lgr_lock);
 }
 
+static void smc_sk_wake_ups(struct smc_sock *smc)
+{
+	smc->sk.sk_write_space(&smc->sk);
+	smc->sk.sk_data_ready(&smc->sk);
+	smc->sk.sk_state_change(&smc->sk);
+}
+
+/* kill a connection */
+static void smc_conn_kill(struct smc_connection *conn)
+{
+	struct smc_sock *smc = container_of(conn, struct smc_sock, conn);
+
+	smc_close_abort(conn);
+	conn->killed = 1;
+	smc_sk_wake_ups(smc);
+	smc_lgr_unregister_conn(conn);
+	smc->sk.sk_err = ECONNABORTED;
+	sock_hold(&smc->sk); /* sock_put in close work */
+	if (!schedule_work(&conn->close_work))
+		sock_put(&smc->sk);
+}
+
 /* terminate link group */
 static void __smc_lgr_terminate(struct smc_link_group *lgr)
 {
@@ -512,13 +536,7 @@ static void __smc_lgr_terminate(struct smc_link_group *lgr)
 		conn = rb_entry(node, struct smc_connection, alert_node);
 		smc = container_of(conn, struct smc_sock, conn);
 		lock_sock(&smc->sk);
-		sock_hold(&smc->sk); /* sock_put in close work */
-		smc_close_abort(conn);
-		conn->killed = 1;
-		smc_lgr_unregister_conn(conn);
-		conn->lgr = NULL;
-		if (!schedule_work(&conn->close_work))
-			sock_put(&smc->sk);
+		smc_conn_kill(conn);
 		release_sock(&smc->sk);
 		read_lock_bh(&lgr->conns_lock);
 		node = rb_first(&lgr->conns_all);
-- 
2.17.1

