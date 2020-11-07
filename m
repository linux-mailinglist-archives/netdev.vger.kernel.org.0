Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E8932AA52E
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 14:00:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728149AbgKGNAm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Nov 2020 08:00:42 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:64600 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727866AbgKGNAS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Nov 2020 08:00:18 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A7CV2aH193573;
        Sat, 7 Nov 2020 08:00:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=nAtl1/5O5Eb11bfeE1ZbWJ4BWiXIDYZngCXDabu8CkA=;
 b=qwzn4OySr0OKKq+w+EdxbR5xpwfFMRMFiDuK5qZkYhUYSFKkOfupqXLCHdgLfl5RTkwW
 TeAKRQR0Q+tmv61PqHTR/8R9+mSzP1Vi9ZsZZMui2pk2gprR01tNjGnOK7ZkH2b+CxAa
 PWv3IQbrFu3jo6+Xz0wonUnLXKSvns6R0hjuGCc2EsCkfeC0xwZ+uGpIKhppq1bYi82c
 WGj4yp1ry5MkYwf6f041McuccuuijT23ZjtAN0FmbGJEUC69mjKy7dw9S+ZZC937vuAd
 1xWA+EzNBIFGBK28urL1xfle9iTsh/KyfvB0OwW+Mxq0mSi9O4CkRstwHKVkwRtKNsQ1 xg== 
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34np2vr2aj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 07 Nov 2020 08:00:15 -0500
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0A7CwKqN019400;
        Sat, 7 Nov 2020 13:00:13 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06fra.de.ibm.com with ESMTP id 34njuh05q9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 07 Nov 2020 13:00:13 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0A7D0A5v4391580
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 7 Nov 2020 13:00:10 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8FC80A407B;
        Sat,  7 Nov 2020 13:00:08 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 68FF9A4070;
        Sat,  7 Nov 2020 13:00:08 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Sat,  7 Nov 2020 13:00:08 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        hca@linux.ibm.com, raspl@linux.ibm.com
Subject: [PATCH net-next v3 03/15] net/smc: Add connection counters for links
Date:   Sat,  7 Nov 2020 13:59:46 +0100
Message-Id: <20201107125958.16384-4-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201107125958.16384-1-kgraul@linux.ibm.com>
References: <20201107125958.16384-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-07_07:2020-11-05,2020-11-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_spam_definite policy=outbound score=100 impostorscore=0
 suspectscore=0 mlxlogscore=-1000 spamscore=100 bulkscore=0
 priorityscore=1501 lowpriorityscore=0 malwarescore=0 clxscore=1015
 phishscore=0 mlxscore=100 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2011070081
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
index 2b19863f7171..6e2077161267 100644
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
 
+static inline void smc_switch_link_and_count(struct smc_connection *conn,
+					     struct smc_link *to_lnk)
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
index 9aee54a6bcba..83a88a4635db 100644
--- a/net/smc/smc_core.h
+++ b/net/smc/smc_core.h
@@ -129,6 +129,7 @@ struct smc_link {
 	struct delayed_work	llc_testlink_wrk; /* testlink worker */
 	struct completion	llc_testlink_resp; /* wait for rx of testlink */
 	int			llc_testlink_time; /* testlink interval */
+	atomic_t		conn_cnt;
 };
 
 /* For now we just allow one parallel link per link group. The SMC protocol
-- 
2.17.1

