Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74D371C3928
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 14:19:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728764AbgEDMTS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 08:19:18 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:49652 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728686AbgEDMTP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 08:19:15 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 044C2qYd155375;
        Mon, 4 May 2020 08:19:15 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30s45sjf53-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 May 2020 08:19:14 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 044C9xAV004594;
        Mon, 4 May 2020 12:19:12 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04fra.de.ibm.com with ESMTP id 30s0g61wjp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 May 2020 12:19:12 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 044CJ9Qo8847710
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 4 May 2020 12:19:09 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3D686A4040;
        Mon,  4 May 2020 12:19:09 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0D7FCA4059;
        Mon,  4 May 2020 12:19:09 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  4 May 2020 12:19:08 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net-next 07/12] net/smc: assign link to a new connection
Date:   Mon,  4 May 2020 14:18:43 +0200
Message-Id: <20200504121848.46585-8-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200504121848.46585-1-kgraul@linux.ibm.com>
References: <20200504121848.46585-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-05-04_06:2020-05-04,2020-05-04 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 adultscore=0
 phishscore=0 clxscore=1015 suspectscore=3 impostorscore=0 mlxscore=0
 lowpriorityscore=0 bulkscore=0 spamscore=0 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005040104
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For new connections, assign a link from the link group, using some
simple load balancing.

Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
Reviewed-by: Ursula Braun <ubraun@linux.ibm.com>
---
 net/smc/smc_core.c | 65 ++++++++++++++++++++++++++++++++--------------
 1 file changed, 46 insertions(+), 19 deletions(-)

diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index 8f630b76c5a4..9c19b9aa3719 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -121,16 +121,59 @@ static void smc_lgr_add_alert_token(struct smc_connection *conn)
 	rb_insert_color(&conn->alert_node, &conn->lgr->conns_all);
 }
 
+/* assign an SMC-R link to the connection */
+static int smcr_lgr_conn_assign_link(struct smc_connection *conn, bool first)
+{
+	enum smc_link_state expected = first ? SMC_LNK_ACTIVATING :
+				       SMC_LNK_ACTIVE;
+	int i, j;
+
+	/* do link balancing */
+	for (i = 0; i < SMC_LINKS_PER_LGR_MAX; i++) {
+		struct smc_link *lnk = &conn->lgr->lnk[i];
+
+		if (lnk->state != expected)
+			continue;
+		if (conn->lgr->role == SMC_CLNT) {
+			conn->lnk = lnk; /* temporary, SMC server assigns link*/
+			break;
+		}
+		if (conn->lgr->conns_num % 2) {
+			for (j = i + 1; j < SMC_LINKS_PER_LGR_MAX; j++) {
+				struct smc_link *lnk2;
+
+				lnk2 = &conn->lgr->lnk[j];
+				if (lnk2->state == expected) {
+					conn->lnk = lnk2;
+					break;
+				}
+			}
+		}
+		if (!conn->lnk)
+			conn->lnk = lnk;
+		break;
+	}
+	if (!conn->lnk)
+		return SMC_CLC_DECL_NOACTLINK;
+	return 0;
+}
+
 /* Register connection in link group by assigning an alert token
  * registered in a search tree.
  * Requires @conns_lock
  * Note that '0' is a reserved value and not assigned.
  */
-static int smc_lgr_register_conn(struct smc_connection *conn)
+static int smc_lgr_register_conn(struct smc_connection *conn, bool first)
 {
 	struct smc_sock *smc = container_of(conn, struct smc_sock, conn);
 	static atomic_t nexttoken = ATOMIC_INIT(0);
+	int rc;
 
+	if (!conn->lgr->is_smcd) {
+		rc = smcr_lgr_conn_assign_link(conn, first);
+		if (rc)
+			return rc;
+	}
 	/* find a new alert_token_local value not yet used by some connection
 	 * in this link group
 	 */
@@ -141,22 +184,6 @@ static int smc_lgr_register_conn(struct smc_connection *conn)
 			conn->alert_token_local = 0;
 	}
 	smc_lgr_add_alert_token(conn);
-
-	/* assign the new connection to a link */
-	if (!conn->lgr->is_smcd) {
-		struct smc_link *lnk;
-		int i;
-
-		/* tbd - link balancing */
-		for (i = 0; i < SMC_LINKS_PER_LGR_MAX; i++) {
-			lnk = &conn->lgr->lnk[i];
-			if (lnk->state == SMC_LNK_ACTIVATING ||
-			    lnk->state == SMC_LNK_ACTIVE)
-				conn->lnk = lnk;
-		}
-		if (!conn->lnk)
-			return SMC_CLC_DECL_NOACTLINK;
-	}
 	conn->lgr->conns_num++;
 	return 0;
 }
@@ -1285,7 +1312,7 @@ int smc_conn_create(struct smc_sock *smc, struct smc_init_info *ini)
 			/* link group found */
 			ini->cln_first_contact = SMC_REUSE_CONTACT;
 			conn->lgr = lgr;
-			rc = smc_lgr_register_conn(conn); /* add conn to lgr */
+			rc = smc_lgr_register_conn(conn, false);
 			write_unlock_bh(&lgr->conns_lock);
 			if (!rc && delayed_work_pending(&lgr->free_work))
 				cancel_delayed_work(&lgr->free_work);
@@ -1313,7 +1340,7 @@ int smc_conn_create(struct smc_sock *smc, struct smc_init_info *ini)
 			goto out;
 		lgr = conn->lgr;
 		write_lock_bh(&lgr->conns_lock);
-		rc = smc_lgr_register_conn(conn); /* add smc conn to lgr */
+		rc = smc_lgr_register_conn(conn, true);
 		write_unlock_bh(&lgr->conns_lock);
 		if (rc)
 			goto out;
-- 
2.17.1

