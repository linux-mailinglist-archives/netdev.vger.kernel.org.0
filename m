Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9A6016EA39
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 16:34:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731146AbgBYPes (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 10:34:48 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:18138 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728065AbgBYPes (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 10:34:48 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01PFYDT3130300
        for <netdev@vger.kernel.org>; Tue, 25 Feb 2020 10:34:46 -0500
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2yb12c8dxk-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 25 Feb 2020 10:34:46 -0500
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <kgraul@linux.ibm.com>;
        Tue, 25 Feb 2020 15:34:45 -0000
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 25 Feb 2020 15:34:42 -0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01PFYf8e51511542
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Feb 2020 15:34:41 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 32E4111C04A;
        Tue, 25 Feb 2020 15:34:41 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ED2E911C04C;
        Tue, 25 Feb 2020 15:34:40 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 25 Feb 2020 15:34:40 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net] net/smc: fix cleanup for linkgroup setup failures
Date:   Tue, 25 Feb 2020 16:34:36 +0100
X-Mailer: git-send-email 2.17.1
X-TM-AS-GCONF: 00
x-cbid: 20022515-0016-0000-0000-000002EA2AAA
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20022515-0017-0000-0000-0000334D56B6
Message-Id: <20200225153436.26498-1-kgraul@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-25_05:2020-02-21,2020-02-25 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 clxscore=1015 priorityscore=1501 lowpriorityscore=0 suspectscore=3
 adultscore=0 malwarescore=0 impostorscore=0 phishscore=0 mlxlogscore=999
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002250120
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ursula Braun <ubraun@linux.ibm.com>

If an SMC connection to a certain peer is setup the first time,
a new linkgroup is created. In case of setup failures, such a
linkgroup is unusable and should disappear. As a first step the
linkgroup is removed from the linkgroup list in smc_lgr_forget().

There are 2 problems:
smc_listen_decline() might be called before linkgroup creation
resulting in a crash due to calling smc_lgr_forget() with
parameter NULL.
If a setup failure occurs after linkgroup creation, the connection
is never unregistered from the linkgroup, preventing linkgroup
freeing.

This patch introduces an enhanced smc_lgr_cleanup_early() function
which
* contains a linkgroup check for early smc_listen_decline()
  invocations
* invokes smc_conn_free() to guarantee unregistering of the
  connection.
* schedules fast linkgroup removal of the unusable linkgroup

And the unused function smcd_conn_free() is removed from smc_core.h.

Fixes: 3b2dec2603d5b ("net/smc: restructure client and server code in af_smc")
Fixes: 2a0674fffb6bc ("net/smc: improve abnormal termination of link groups")
Signed-off-by: Ursula Braun <ubraun@linux.ibm.com>
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 net/smc/af_smc.c   | 25 +++++++++++++++----------
 net/smc/smc_core.c | 12 ++++++++++++
 net/smc/smc_core.h |  2 +-
 3 files changed, 28 insertions(+), 11 deletions(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 90988a511cd5..6fd44bdb0fc3 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -512,15 +512,18 @@ static int smc_connect_decline_fallback(struct smc_sock *smc, int reason_code)
 static int smc_connect_abort(struct smc_sock *smc, int reason_code,
 			     int local_contact)
 {
+	bool is_smcd = smc->conn.lgr->is_smcd;
+
 	if (local_contact == SMC_FIRST_CONTACT)
-		smc_lgr_forget(smc->conn.lgr);
-	if (smc->conn.lgr->is_smcd)
+		smc_lgr_cleanup_early(&smc->conn);
+	else
+		smc_conn_free(&smc->conn);
+	if (is_smcd)
 		/* there is only one lgr role for SMC-D; use server lock */
 		mutex_unlock(&smc_server_lgr_pending);
 	else
 		mutex_unlock(&smc_client_lgr_pending);
 
-	smc_conn_free(&smc->conn);
 	smc->connect_nonblock = 0;
 	return reason_code;
 }
@@ -1091,7 +1094,6 @@ static void smc_listen_out_err(struct smc_sock *new_smc)
 	if (newsmcsk->sk_state == SMC_INIT)
 		sock_put(&new_smc->sk); /* passive closing */
 	newsmcsk->sk_state = SMC_CLOSED;
-	smc_conn_free(&new_smc->conn);
 
 	smc_listen_out(new_smc);
 }
@@ -1102,12 +1104,13 @@ static void smc_listen_decline(struct smc_sock *new_smc, int reason_code,
 {
 	/* RDMA setup failed, switch back to TCP */
 	if (local_contact == SMC_FIRST_CONTACT)
-		smc_lgr_forget(new_smc->conn.lgr);
+		smc_lgr_cleanup_early(&new_smc->conn);
+	else
+		smc_conn_free(&new_smc->conn);
 	if (reason_code < 0) { /* error, no fallback possible */
 		smc_listen_out_err(new_smc);
 		return;
 	}
-	smc_conn_free(&new_smc->conn);
 	smc_switch_to_fallback(new_smc);
 	new_smc->fallback_rsn = reason_code;
 	if (reason_code && reason_code != SMC_CLC_DECL_PEERDECL) {
@@ -1170,16 +1173,18 @@ static int smc_listen_ism_init(struct smc_sock *new_smc,
 			    new_smc->conn.lgr->vlan_id,
 			    new_smc->conn.lgr->smcd)) {
 		if (ini->cln_first_contact == SMC_FIRST_CONTACT)
-			smc_lgr_forget(new_smc->conn.lgr);
-		smc_conn_free(&new_smc->conn);
+			smc_lgr_cleanup_early(&new_smc->conn);
+		else
+			smc_conn_free(&new_smc->conn);
 		return SMC_CLC_DECL_SMCDNOTALK;
 	}
 
 	/* Create send and receive buffers */
 	if (smc_buf_create(new_smc, true)) {
 		if (ini->cln_first_contact == SMC_FIRST_CONTACT)
-			smc_lgr_forget(new_smc->conn.lgr);
-		smc_conn_free(&new_smc->conn);
+			smc_lgr_cleanup_early(&new_smc->conn);
+		else
+			smc_conn_free(&new_smc->conn);
 		return SMC_CLC_DECL_MEM;
 	}
 
diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index 2249de5379ee..5b085efa3bce 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -162,6 +162,18 @@ static void smc_lgr_unregister_conn(struct smc_connection *conn)
 	conn->lgr = NULL;
 }
 
+void smc_lgr_cleanup_early(struct smc_connection *conn)
+{
+	struct smc_link_group *lgr = conn->lgr;
+
+	if (!lgr)
+		return;
+
+	smc_conn_free(conn);
+	smc_lgr_forget(lgr);
+	smc_lgr_schedule_free_work_fast(lgr);
+}
+
 /* Send delete link, either as client to request the initiation
  * of the DELETE LINK sequence from server; or as server to
  * initiate the delete processing. See smc_llc_rx_delete_link().
diff --git a/net/smc/smc_core.h b/net/smc/smc_core.h
index c472e12951d1..234ae25f0025 100644
--- a/net/smc/smc_core.h
+++ b/net/smc/smc_core.h
@@ -296,6 +296,7 @@ struct smc_clc_msg_accept_confirm;
 struct smc_clc_msg_local;
 
 void smc_lgr_forget(struct smc_link_group *lgr);
+void smc_lgr_cleanup_early(struct smc_connection *conn);
 void smc_lgr_terminate(struct smc_link_group *lgr, bool soft);
 void smc_port_terminate(struct smc_ib_device *smcibdev, u8 ibport);
 void smc_smcd_terminate(struct smcd_dev *dev, u64 peer_gid,
@@ -316,7 +317,6 @@ int smc_vlan_by_tcpsk(struct socket *clcsock, struct smc_init_info *ini);
 
 void smc_conn_free(struct smc_connection *conn);
 int smc_conn_create(struct smc_sock *smc, struct smc_init_info *ini);
-void smcd_conn_free(struct smc_connection *conn);
 void smc_lgr_schedule_free_work_fast(struct smc_link_group *lgr);
 int smc_core_init(void);
 void smc_core_exit(void);
-- 
2.17.1

