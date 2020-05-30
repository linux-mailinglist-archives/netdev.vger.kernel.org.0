Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F94B1E9225
	for <lists+netdev@lfdr.de>; Sat, 30 May 2020 16:44:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729029AbgE3Onq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 May 2020 10:43:46 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:20332 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728927AbgE3Onp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 May 2020 10:43:45 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04UEVjaR148906;
        Sat, 30 May 2020 10:43:42 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 31brsprpe6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 30 May 2020 10:43:42 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 04UEdvGa020866;
        Sat, 30 May 2020 14:43:40 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04ams.nl.ibm.com with ESMTP id 31bf47rswk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 30 May 2020 14:43:40 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 04UEhbgD54984944
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 30 May 2020 14:43:37 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BCF24A405C;
        Sat, 30 May 2020 14:43:37 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7E88EA4054;
        Sat, 30 May 2020 14:43:37 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Sat, 30 May 2020 14:43:37 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net-next] net/smc: pre-fetch send buffer outside of send_lock
Date:   Sat, 30 May 2020 16:42:37 +0200
Message-Id: <20200530144237.15883-1-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-05-30_10:2020-05-28,2020-05-30 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 mlxscore=0 suspectscore=3 adultscore=0 mlxlogscore=850
 cotscore=-2147483648 phishscore=0 bulkscore=0 clxscore=1015
 priorityscore=1501 impostorscore=0 spamscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005300110
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pre-fetch send buffer for the CDC validation message before entering the
send_lock. Without that the send call might fail with -EBUSY because
there are no free buffers and waiting for buffers is not possible under
send_lock.

Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
Reviewed-by: Ursula Braun <ubraun@linux.ibm.com>
---
 net/smc/smc_cdc.c  | 10 +++-------
 net/smc/smc_cdc.h  |  4 +++-
 net/smc/smc_core.c | 18 +++++++++++++++---
 3 files changed, 21 insertions(+), 11 deletions(-)

diff --git a/net/smc/smc_cdc.c b/net/smc/smc_cdc.c
index b2b85e1be72c..a47e8855e045 100644
--- a/net/smc/smc_cdc.c
+++ b/net/smc/smc_cdc.c
@@ -116,19 +116,15 @@ int smc_cdc_msg_send(struct smc_connection *conn,
 }
 
 /* send a validation msg indicating the move of a conn to an other QP link */
-int smcr_cdc_msg_send_validation(struct smc_connection *conn)
+int smcr_cdc_msg_send_validation(struct smc_connection *conn,
+				 struct smc_cdc_tx_pend *pend,
+				 struct smc_wr_buf *wr_buf)
 {
 	struct smc_host_cdc_msg *local = &conn->local_tx_ctrl;
 	struct smc_link *link = conn->lnk;
-	struct smc_cdc_tx_pend *pend;
-	struct smc_wr_buf *wr_buf;
 	struct smc_cdc_msg *peer;
 	int rc;
 
-	rc = smc_cdc_get_free_slot(conn, link, &wr_buf, NULL, &pend);
-	if (rc)
-		return rc;
-
 	peer = (struct smc_cdc_msg *)wr_buf;
 	peer->common.type = local->common.type;
 	peer->len = local->len;
diff --git a/net/smc/smc_cdc.h b/net/smc/smc_cdc.h
index 2ddcc5fb5ceb..0a0a89abd38b 100644
--- a/net/smc/smc_cdc.h
+++ b/net/smc/smc_cdc.h
@@ -296,7 +296,9 @@ int smc_cdc_msg_send(struct smc_connection *conn, struct smc_wr_buf *wr_buf,
 		     struct smc_cdc_tx_pend *pend);
 int smc_cdc_get_slot_and_msg_send(struct smc_connection *conn);
 int smcd_cdc_msg_send(struct smc_connection *conn);
-int smcr_cdc_msg_send_validation(struct smc_connection *conn);
+int smcr_cdc_msg_send_validation(struct smc_connection *conn,
+				 struct smc_cdc_tx_pend *pend,
+				 struct smc_wr_buf *wr_buf);
 int smc_cdc_init(void) __init;
 void smcd_cdc_rx_init(struct smc_connection *conn);
 
diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index 65de700e1f17..7964a21e5e6f 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -483,7 +483,8 @@ static int smc_write_space(struct smc_connection *conn)
 	return space;
 }
 
-static int smc_switch_cursor(struct smc_sock *smc)
+static int smc_switch_cursor(struct smc_sock *smc, struct smc_cdc_tx_pend *pend,
+			     struct smc_wr_buf *wr_buf)
 {
 	struct smc_connection *conn = &smc->conn;
 	union smc_host_cursor cons, fin;
@@ -520,11 +521,14 @@ static int smc_switch_cursor(struct smc_sock *smc)
 
 	if (smc->sk.sk_state != SMC_INIT &&
 	    smc->sk.sk_state != SMC_CLOSED) {
-		rc = smcr_cdc_msg_send_validation(conn);
+		rc = smcr_cdc_msg_send_validation(conn, pend, wr_buf);
 		if (!rc) {
 			schedule_delayed_work(&conn->tx_work, 0);
 			smc->sk.sk_data_ready(&smc->sk);
 		}
+	} else {
+		smc_wr_tx_put_slot(conn->lnk,
+				   (struct smc_wr_tx_pend_priv *)pend);
 	}
 	return rc;
 }
@@ -533,7 +537,9 @@ struct smc_link *smc_switch_conns(struct smc_link_group *lgr,
 				  struct smc_link *from_lnk, bool is_dev_err)
 {
 	struct smc_link *to_lnk = NULL;
+	struct smc_cdc_tx_pend *pend;
 	struct smc_connection *conn;
+	struct smc_wr_buf *wr_buf;
 	struct smc_sock *smc;
 	struct rb_node *node;
 	int i, rc = 0;
@@ -582,10 +588,16 @@ struct smc_link *smc_switch_conns(struct smc_link_group *lgr,
 		}
 		sock_hold(&smc->sk);
 		read_unlock_bh(&lgr->conns_lock);
+		/* pre-fetch buffer outside of send_lock, might sleep */
+		rc = smc_cdc_get_free_slot(conn, to_lnk, &wr_buf, NULL, &pend);
+		if (rc) {
+			smcr_link_down_cond_sched(to_lnk);
+			return NULL;
+		}
 		/* avoid race with smcr_tx_sndbuf_nonempty() */
 		spin_lock_bh(&conn->send_lock);
 		conn->lnk = to_lnk;
-		rc = smc_switch_cursor(smc);
+		rc = smc_switch_cursor(smc, pend, wr_buf);
 		spin_unlock_bh(&conn->send_lock);
 		sock_put(&smc->sk);
 		if (rc) {
-- 
2.17.1

