Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C187DEF0B
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 16:13:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729246AbfJUONl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 10:13:41 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:16174 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729112AbfJUONj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 10:13:39 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x9LEDXIK029847
        for <netdev@vger.kernel.org>; Mon, 21 Oct 2019 10:13:38 -0400
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2vsdcvtmt7-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 21 Oct 2019 10:13:36 -0400
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <kgraul@linux.ibm.com>;
        Mon, 21 Oct 2019 15:13:26 +0100
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 21 Oct 2019 15:13:22 +0100
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x9LECmQ826607980
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Oct 2019 14:12:49 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1B6424C074;
        Mon, 21 Oct 2019 14:13:21 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CF6364C06D;
        Mon, 21 Oct 2019 14:13:20 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 21 Oct 2019 14:13:20 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        gor@linux.ibm.com, heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net-next 3/8] net/smc: improve abnormal termination locking
Date:   Mon, 21 Oct 2019 16:13:10 +0200
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191021141315.58969-1-kgraul@linux.ibm.com>
References: <20191021141315.58969-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19102114-4275-0000-0000-00000374FF38
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19102114-4276-0000-0000-000038882012
Message-Id: <20191021141315.58969-4-kgraul@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-21_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=767 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1910210135
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ursula Braun <ubraun@linux.ibm.com>

Locking hierarchy requires that the link group conns_lock can be
taken if the socket lock is held, but not vice versa. Nevertheless
socket termination during abnormal link group termination should
be protected by the socket lock.
This patch reduces the time segments the link group conns_lock is
held to enable usage of lock_sock in smc_lgr_terminate().

Signed-off-by: Ursula Braun <ubraun@linux.ibm.com>
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 net/smc/smc_core.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index b53ba8f0a833..1f58cd82928c 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -491,23 +491,26 @@ static void __smc_lgr_terminate(struct smc_link_group *lgr)
 	if (!lgr->is_smcd)
 		smc_llc_link_inactive(&lgr->lnk[SMC_SINGLE_LINK]);
 
-	write_lock_bh(&lgr->conns_lock);
+	/* kill remaining link group connections */
+	read_lock_bh(&lgr->conns_lock);
 	node = rb_first(&lgr->conns_all);
 	while (node) {
+		read_unlock_bh(&lgr->conns_lock);
 		conn = rb_entry(node, struct smc_connection, alert_node);
 		smc = container_of(conn, struct smc_sock, conn);
+		lock_sock(&smc->sk);
 		sock_hold(&smc->sk); /* sock_put in close work */
 		conn->killed = 1;
 		conn->local_tx_ctrl.conn_state_flags.peer_conn_abort = 1;
-		__smc_lgr_unregister_conn(conn);
+		smc_lgr_unregister_conn(conn);
 		conn->lgr = NULL;
-		write_unlock_bh(&lgr->conns_lock);
 		if (!schedule_work(&conn->close_work))
 			sock_put(&smc->sk);
-		write_lock_bh(&lgr->conns_lock);
+		release_sock(&smc->sk);
+		read_lock_bh(&lgr->conns_lock);
 		node = rb_first(&lgr->conns_all);
 	}
-	write_unlock_bh(&lgr->conns_lock);
+	read_unlock_bh(&lgr->conns_lock);
 	if (!lgr->is_smcd)
 		wake_up(&lgr->lnk[SMC_SINGLE_LINK].wr_reg_wait);
 	smc_lgr_schedule_free_work(lgr);
-- 
2.17.1

