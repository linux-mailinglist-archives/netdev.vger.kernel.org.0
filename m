Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64A8B2CABC2
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 20:22:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404333AbgLATV6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 14:21:58 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:32552 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731215AbgLATVp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 14:21:45 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B1J5QqN008507;
        Tue, 1 Dec 2020 14:21:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=nl7SSpSJruWZf6Ef5+RN1R5+Xtg7KxrnjB8npY5+lnE=;
 b=FsNt5zv5odvKcQ+JmtPOzLJJsguJYEuXqxulWXBoyfLPEzPDgMrI5GklBrVjxmXV3WZQ
 2Y7m9Z6Gu6rqsePrUoA1hFkd0j6KgxXKEjnq5OOLiBlGQLXQz3uWI57bkZcMUraEHJWs
 yvgUzE+EsHCRPkrSQIAE7CfZGR9XLKn+3a4k92Byj7FdzgnfwLSle08dMb8bhmwlz9Rs
 NAtXcLYHj1r/gPNsHr8z5VaKFYuxeMpz7UCGdgm6Qf+32l7iTQ0lycL+ThCewq6mC8lg
 TX6bvH4N8XRXKSNpcxB2oVlp518dhKbDmHD821MV+5P6z2V28G3i4cdR7Q+yuhDH5bEG tA== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 355jt77hjn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 01 Dec 2020 14:21:00 -0500
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0B1JGc9W021292;
        Tue, 1 Dec 2020 19:20:59 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 353e68bf6n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 01 Dec 2020 19:20:59 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0B1JKuUR42533204
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 1 Dec 2020 19:20:56 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 68B10AE045;
        Tue,  1 Dec 2020 19:20:56 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2EB5BAE057;
        Tue,  1 Dec 2020 19:20:56 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  1 Dec 2020 19:20:56 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Heiko Carstens <hca@linux.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [PATCH net-next v7 03/14] net/smc: Add connection counters for links
Date:   Tue,  1 Dec 2020 20:20:38 +0100
Message-Id: <20201201192049.53517-4-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201201192049.53517-1-kgraul@linux.ibm.com>
References: <20201201192049.53517-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-01_07:2020-11-30,2020-12-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxscore=0
 adultscore=0 spamscore=0 impostorscore=0 priorityscore=1501 malwarescore=0
 lowpriorityscore=0 mlxlogscore=999 suspectscore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012010112
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guvenc Gulce <guvenc@linux.ibm.com>

Add connection counters to the structure of the link.
Increase/decrease the counters as needed in the corresponding
routines.

Signed-off-by: Guvenc Gulce <guvenc@linux.ibm.com>
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 net/smc/smc_core.c | 16 ++++++++++++++--
 net/smc/smc_core.h |  1 +
 2 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index af96f813c075..5bc8ebcd03f3 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -139,6 +139,7 @@ static int smcr_lgr_conn_assign_link(struct smc_connection *conn, bool first)
 	}
 	if (!conn->lnk)
 		return SMC_CLC_DECL_NOACTLINK;
+	atomic_inc(&conn->lnk->conn_cnt);
 	return 0;
 }
 
@@ -180,6 +181,8 @@ static void __smc_lgr_unregister_conn(struct smc_connection *conn)
 	struct smc_link_group *lgr = conn->lgr;
 
 	rb_erase(&conn->alert_node, &lgr->conns_all);
+	if (conn->lnk)
+		atomic_dec(&conn->lnk->conn_cnt);
 	lgr->conns_num--;
 	conn->alert_token_local = 0;
 	sock_put(&smc->sk); /* sock_hold in smc_lgr_register_conn() */
@@ -314,6 +317,7 @@ int smcr_link_init(struct smc_link_group *lgr, struct smc_link *lnk,
 	lnk->smcibdev = ini->ib_dev;
 	lnk->ibport = ini->ib_port;
 	lnk->path_mtu = ini->ib_dev->pattr[ini->ib_port - 1].active_mtu;
+	atomic_set(&lnk->conn_cnt, 0);
 	smc_llc_link_set_uid(lnk);
 	INIT_WORK(&lnk->link_down_wrk, smc_link_down_work);
 	if (!ini->ib_dev->initialized) {
@@ -526,6 +530,14 @@ static int smc_switch_cursor(struct smc_sock *smc, struct smc_cdc_tx_pend *pend,
 	return rc;
 }
 
+static void smc_switch_link_and_count(struct smc_connection *conn,
+				      struct smc_link *to_lnk)
+{
+	atomic_dec(&conn->lnk->conn_cnt);
+	conn->lnk = to_lnk;
+	atomic_inc(&conn->lnk->conn_cnt);
+}
+
 struct smc_link *smc_switch_conns(struct smc_link_group *lgr,
 				  struct smc_link *from_lnk, bool is_dev_err)
 {
@@ -574,7 +586,7 @@ struct smc_link *smc_switch_conns(struct smc_link_group *lgr,
 		    smc->sk.sk_state == SMC_PEERABORTWAIT ||
 		    smc->sk.sk_state == SMC_PROCESSABORT) {
 			spin_lock_bh(&conn->send_lock);
-			conn->lnk = to_lnk;
+			smc_switch_link_and_count(conn, to_lnk);
 			spin_unlock_bh(&conn->send_lock);
 			continue;
 		}
@@ -588,7 +600,7 @@ struct smc_link *smc_switch_conns(struct smc_link_group *lgr,
 		}
 		/* avoid race with smcr_tx_sndbuf_nonempty() */
 		spin_lock_bh(&conn->send_lock);
-		conn->lnk = to_lnk;
+		smc_switch_link_and_count(conn, to_lnk);
 		rc = smc_switch_cursor(smc, pend, wr_buf);
 		spin_unlock_bh(&conn->send_lock);
 		sock_put(&smc->sk);
diff --git a/net/smc/smc_core.h b/net/smc/smc_core.h
index 9aee54a6bcba..eefb6770b268 100644
--- a/net/smc/smc_core.h
+++ b/net/smc/smc_core.h
@@ -129,6 +129,7 @@ struct smc_link {
 	struct delayed_work	llc_testlink_wrk; /* testlink worker */
 	struct completion	llc_testlink_resp; /* wait for rx of testlink */
 	int			llc_testlink_time; /* testlink interval */
+	atomic_t		conn_cnt; /* connections on this link */
 };
 
 /* For now we just allow one parallel link per link group. The SMC protocol
-- 
2.17.1

