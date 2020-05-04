Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10EC31C3925
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 14:19:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728757AbgEDMTS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 08:19:18 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:3990 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728621AbgEDMTP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 08:19:15 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 044CChmP157094;
        Mon, 4 May 2020 08:19:12 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30s4r2shdc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 May 2020 08:19:12 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 044C9q3T011607;
        Mon, 4 May 2020 12:19:11 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04ams.nl.ibm.com with ESMTP id 30s0g5mr11-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 May 2020 12:19:10 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 044CJ8GM59572316
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 4 May 2020 12:19:08 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 18E4AA4040;
        Mon,  4 May 2020 12:19:08 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DD81BA4053;
        Mon,  4 May 2020 12:19:07 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  4 May 2020 12:19:07 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net-next 03/12] net/smc: send failover validation message
Date:   Mon,  4 May 2020 14:18:39 +0200
Message-Id: <20200504121848.46585-4-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200504121848.46585-1-kgraul@linux.ibm.com>
References: <20200504121848.46585-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-05-04_07:2020-05-04,2020-05-04 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 mlxlogscore=999 clxscore=1015 priorityscore=1501 malwarescore=0
 impostorscore=0 bulkscore=0 suspectscore=3 adultscore=0 phishscore=0
 mlxscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005040104
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a connection is switched to a new link then a link validation
message must be sent to the peer over the new link, containing the
sequence number of the last CDC message that was sent over the old link.
The peer will validate if this sequence number is the same or lower then
the number he received, and abort the connection if messages were lost.
Add smcr_cdc_msg_send_validation() to send the message validation
message and call it when a connection was switched in
smc_switch_cursor().

Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
Reviewed-by: Ursula Braun <ubraun@linux.ibm.com>
---
 net/smc/smc_cdc.c  | 25 +++++++++++++++++++++++++
 net/smc/smc_cdc.h  |  1 +
 net/smc/smc_core.c |  2 +-
 3 files changed, 27 insertions(+), 1 deletion(-)

diff --git a/net/smc/smc_cdc.c b/net/smc/smc_cdc.c
index 3ca986066f32..e6b7eef71831 100644
--- a/net/smc/smc_cdc.c
+++ b/net/smc/smc_cdc.c
@@ -115,6 +115,31 @@ int smc_cdc_msg_send(struct smc_connection *conn,
 	return rc;
 }
 
+/* send a validation msg indicating the move of a conn to an other QP link */
+int smcr_cdc_msg_send_validation(struct smc_connection *conn)
+{
+	struct smc_host_cdc_msg *local = &conn->local_tx_ctrl;
+	struct smc_link *link = conn->lnk;
+	struct smc_cdc_tx_pend *pend;
+	struct smc_wr_buf *wr_buf;
+	struct smc_cdc_msg *peer;
+	int rc;
+
+	rc = smc_cdc_get_free_slot(conn, link, &wr_buf, NULL, &pend);
+	if (rc)
+		return rc;
+
+	peer = (struct smc_cdc_msg *)wr_buf;
+	peer->common.type = local->common.type;
+	peer->len = local->len;
+	peer->seqno = htons(conn->tx_cdc_seq_fin); /* seqno last compl. tx */
+	peer->token = htonl(local->token);
+	peer->prod_flags.failover_validation = 1;
+
+	rc = smc_wr_tx_send(link, (struct smc_wr_tx_pend_priv *)pend);
+	return rc;
+}
+
 static int smcr_cdc_get_slot_and_msg_send(struct smc_connection *conn)
 {
 	struct smc_cdc_tx_pend *pend;
diff --git a/net/smc/smc_cdc.h b/net/smc/smc_cdc.h
index 42246b4bdcc9..9cfabc9af120 100644
--- a/net/smc/smc_cdc.h
+++ b/net/smc/smc_cdc.h
@@ -313,6 +313,7 @@ int smc_cdc_msg_send(struct smc_connection *conn, struct smc_wr_buf *wr_buf,
 		     struct smc_cdc_tx_pend *pend);
 int smc_cdc_get_slot_and_msg_send(struct smc_connection *conn);
 int smcd_cdc_msg_send(struct smc_connection *conn);
+int smcr_cdc_msg_send_validation(struct smc_connection *conn);
 int smc_cdc_init(void) __init;
 void smcd_cdc_rx_init(struct smc_connection *conn);
 
diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index 21bc1ec07e99..a558ce0bde97 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -483,7 +483,7 @@ static int smc_switch_cursor(struct smc_sock *smc)
 
 	if (smc->sk.sk_state != SMC_INIT &&
 	    smc->sk.sk_state != SMC_CLOSED) {
-		/* tbd: call rc = smc_cdc_get_slot_and_msg_send(conn); */
+		rc = smcr_cdc_msg_send_validation(conn);
 		if (!rc) {
 			schedule_delayed_work(&conn->tx_work, 0);
 			smc->sk.sk_data_ready(&smc->sk);
-- 
2.17.1

