Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C256A1BE243
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 17:12:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727870AbgD2PMC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 11:12:02 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:26927 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727106AbgD2PLk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 11:11:40 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03TF1k5R029328;
        Wed, 29 Apr 2020 11:11:39 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30mhr889gq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Apr 2020 11:11:39 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 03TFB086012228;
        Wed, 29 Apr 2020 15:11:36 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma05fra.de.ibm.com with ESMTP id 30mcu51vxb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Apr 2020 15:11:36 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03TFAPG862390760
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Apr 2020 15:10:25 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 86A20AE07F;
        Wed, 29 Apr 2020 15:11:33 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 45463AE073;
        Wed, 29 Apr 2020 15:11:33 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 29 Apr 2020 15:11:33 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net-next 13/13] net/smc: move llc layer related init and clear into smc_llc.c
Date:   Wed, 29 Apr 2020 17:10:49 +0200
Message-Id: <20200429151049.49979-14-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200429151049.49979-1-kgraul@linux.ibm.com>
References: <20200429151049.49979-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-29_07:2020-04-29,2020-04-29 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 bulkscore=0 spamscore=0 mlxscore=0 suspectscore=3 clxscore=1015
 priorityscore=1501 adultscore=0 phishscore=0 mlxlogscore=999
 impostorscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2004290122
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce smc_llc_lgr_init() and smc_llc_lgr_clear() to implement all
llc layer specific initialization and cleanup in module smc_llc.c.

Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
Reviewed-by: Ursula Braun <ubraun@linux.ibm.com>
---
 net/smc/af_smc.c   |  6 ++----
 net/smc/smc_core.c |  6 +++---
 net/smc/smc_core.h |  2 ++
 net/smc/smc_llc.c  | 26 +++++++++++++++++++++-----
 net/smc/smc_llc.h  |  5 +++--
 5 files changed, 31 insertions(+), 14 deletions(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index e39f6aedd3bd..e859e3f420d9 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -381,7 +381,6 @@ static int smcr_lgr_reg_rmbs(struct smc_link_group *lgr,
 
 static int smcr_clnt_conf_first_link(struct smc_sock *smc)
 {
-	struct net *net = sock_net(smc->clcsock->sk);
 	struct smc_link *link = smc->conn.lnk;
 	int rest;
 	int rc;
@@ -433,7 +432,7 @@ static int smcr_clnt_conf_first_link(struct smc_sock *smc)
 	if (rc < 0)
 		return SMC_CLC_DECL_TIMEOUT_AL;
 
-	smc_llc_link_active(link, net->ipv4.sysctl_tcp_keepalive_time);
+	smc_llc_link_active(link);
 
 	return 0;
 }
@@ -1019,7 +1018,6 @@ void smc_close_non_accepted(struct sock *sk)
 
 static int smcr_serv_conf_first_link(struct smc_sock *smc)
 {
-	struct net *net = sock_net(smc->clcsock->sk);
 	struct smc_link *link = smc->conn.lnk;
 	int rest;
 	int rc;
@@ -1065,7 +1063,7 @@ static int smcr_serv_conf_first_link(struct smc_sock *smc)
 		return rc == -EAGAIN ? SMC_CLC_DECL_TIMEOUT_AL : rc;
 	}
 
-	smc_llc_link_active(link, net->ipv4.sysctl_tcp_keepalive_time);
+	smc_llc_link_active(link);
 
 	return 0;
 }
diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index 8a43d2948493..db49f8cd5c95 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -412,8 +412,8 @@ static int smc_lgr_create(struct smc_sock *smc, struct smc_init_info *ini)
 		lgr->role = smc->listen_smc ? SMC_SERV : SMC_CLNT;
 		memcpy(lgr->peer_systemid, ini->ib_lcl->id_for_peer,
 		       SMC_SYSTEMID_LEN);
-		INIT_LIST_HEAD(&lgr->llc_event_q);
-		spin_lock_init(&lgr->llc_event_q_lock);
+		smc_llc_lgr_init(lgr, smc);
+
 		link_idx = SMC_SINGLE_LINK;
 		lnk = &lgr->lnk[link_idx];
 		rc = smcr_link_init(lgr, lnk, link_idx, ini);
@@ -614,7 +614,7 @@ static void smc_lgr_free(struct smc_link_group *lgr)
 			if (lgr->lnk[i].state != SMC_LNK_UNUSED)
 				smcr_link_clear(&lgr->lnk[i]);
 		}
-		smc_llc_event_flush(lgr);
+		smc_llc_lgr_clear(lgr);
 		if (!atomic_dec_return(&lgr_cnt))
 			wake_up(&lgrs_deleted);
 	}
diff --git a/net/smc/smc_core.h b/net/smc/smc_core.h
index 379ced490c49..b5781511063d 100644
--- a/net/smc/smc_core.h
+++ b/net/smc/smc_core.h
@@ -238,6 +238,8 @@ struct smc_link_group {
 						/* protects llc_event_q */
 			struct work_struct	llc_event_work;
 						/* llc event worker */
+			int			llc_testlink_time;
+						/* link keep alive time */
 		};
 		struct { /* SMC-D */
 			u64			peer_gid;
diff --git a/net/smc/smc_llc.c b/net/smc/smc_llc.c
index 265889c8b03b..e715dd6735ee 100644
--- a/net/smc/smc_llc.c
+++ b/net/smc/smc_llc.c
@@ -493,7 +493,7 @@ static void smc_llc_rx_delete_rkey(struct smc_link *link,
 }
 
 /* flush the llc event queue */
-void smc_llc_event_flush(struct smc_link_group *lgr)
+static void smc_llc_event_flush(struct smc_link_group *lgr)
 {
 	struct smc_llc_qentry *qentry, *q;
 
@@ -669,6 +669,23 @@ static void smc_llc_testlink_work(struct work_struct *work)
 	schedule_delayed_work(&link->llc_testlink_wrk, next_interval);
 }
 
+void smc_llc_lgr_init(struct smc_link_group *lgr, struct smc_sock *smc)
+{
+	struct net *net = sock_net(smc->clcsock->sk);
+
+	INIT_WORK(&lgr->llc_event_work, smc_llc_event_work);
+	INIT_LIST_HEAD(&lgr->llc_event_q);
+	spin_lock_init(&lgr->llc_event_q_lock);
+	lgr->llc_testlink_time = net->ipv4.sysctl_tcp_keepalive_time;
+}
+
+/* called after lgr was removed from lgr_list */
+void smc_llc_lgr_clear(struct smc_link_group *lgr)
+{
+	smc_llc_event_flush(lgr);
+	cancel_work_sync(&lgr->llc_event_work);
+}
+
 int smc_llc_link_init(struct smc_link *link)
 {
 	init_completion(&link->llc_confirm);
@@ -679,16 +696,15 @@ int smc_llc_link_init(struct smc_link *link)
 	init_completion(&link->llc_delete_rkey_resp);
 	mutex_init(&link->llc_delete_rkey_mutex);
 	init_completion(&link->llc_testlink_resp);
-	INIT_WORK(&link->lgr->llc_event_work, smc_llc_event_work);
 	INIT_DELAYED_WORK(&link->llc_testlink_wrk, smc_llc_testlink_work);
 	return 0;
 }
 
-void smc_llc_link_active(struct smc_link *link, int testlink_time)
+void smc_llc_link_active(struct smc_link *link)
 {
 	link->state = SMC_LNK_ACTIVE;
-	if (testlink_time) {
-		link->llc_testlink_time = testlink_time * HZ;
+	if (link->lgr->llc_testlink_time) {
+		link->llc_testlink_time = link->lgr->llc_testlink_time * HZ;
 		schedule_delayed_work(&link->llc_testlink_wrk,
 				      link->llc_testlink_time);
 	}
diff --git a/net/smc/smc_llc.h b/net/smc/smc_llc.h
index 9de83495ad14..66063f22166b 100644
--- a/net/smc/smc_llc.h
+++ b/net/smc/smc_llc.h
@@ -53,15 +53,16 @@ int smc_llc_send_add_link(struct smc_link *link, u8 mac[], u8 gid[],
 			  enum smc_llc_reqresp reqresp);
 int smc_llc_send_delete_link(struct smc_link *link,
 			     enum smc_llc_reqresp reqresp, bool orderly);
+void smc_llc_lgr_init(struct smc_link_group *lgr, struct smc_sock *smc);
+void smc_llc_lgr_clear(struct smc_link_group *lgr);
 int smc_llc_link_init(struct smc_link *link);
-void smc_llc_link_active(struct smc_link *link, int testlink_time);
+void smc_llc_link_active(struct smc_link *link);
 void smc_llc_link_deleting(struct smc_link *link);
 void smc_llc_link_clear(struct smc_link *link);
 int smc_llc_do_confirm_rkey(struct smc_link *link,
 			    struct smc_buf_desc *rmb_desc);
 int smc_llc_do_delete_rkey(struct smc_link *link,
 			   struct smc_buf_desc *rmb_desc);
-void smc_llc_event_flush(struct smc_link_group *lgr);
 int smc_llc_init(void) __init;
 
 #endif /* SMC_LLC_H */
-- 
2.17.1

