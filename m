Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC6773A9E2C
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 16:53:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234244AbhFPOz2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 10:55:28 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:18622 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233747AbhFPOzZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 10:55:25 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15GEYQCt157797;
        Wed, 16 Jun 2021 10:53:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=HblBm5Y/tc5GrClRmdzXCdSmM+tg4PgJ6DQhNCbfYQs=;
 b=eSBYhdfMmGw1DPSIxIcIZQwIq3COSV9wtm/Umse0dwRidNGlydZpz04thrUpPZXVZMxn
 /9JDa6yURCMAzXgjCWDd9HvxIzLg9fi7Vw0OAVuGYhR0nCGamBFBSToauicPkAiYE+4E
 fY9K//JWqjLcZ9MLxCwhkQWVz6lcD3b2BHbupnvfjsyVYTBGCDSc/W5CMI8AzkMOQ3Mg
 ym5M4R7Ht+rtiFcBegqZ46xLz76Tu25c4IXoIFM9P6medxDd73dbi02ZlHPLVaozu/Js
 g1k/jFKw2kXfjbe64/j+cWdI1BG648RLzBw7dtNBdxfSAAyqpfnhA0lN/7L416NN3NlB cQ== 
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 397j8vu602-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Jun 2021 10:53:13 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15GEmNCY009750;
        Wed, 16 Jun 2021 14:53:12 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma05fra.de.ibm.com with ESMTP id 394mj8h70m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Jun 2021 14:53:12 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15GEr9ig30802392
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Jun 2021 14:53:09 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4D7E442041;
        Wed, 16 Jun 2021 14:53:09 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0211D42047;
        Wed, 16 Jun 2021 14:53:09 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 16 Jun 2021 14:53:08 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Heiko Carstens <hca@linux.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, guvenc@linux.ibm.com
Subject: [PATCH net-next v2 1/4] net/smc: Add SMC statistics support
Date:   Wed, 16 Jun 2021 16:52:55 +0200
Message-Id: <20210616145258.2381446-2-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210616145258.2381446-1-kgraul@linux.ibm.com>
References: <20210616145258.2381446-1-kgraul@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: xadxuhZCzjAJrydimXX59mrLreKcizpk
X-Proofpoint-GUID: xadxuhZCzjAJrydimXX59mrLreKcizpk
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-16_07:2021-06-15,2021-06-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 mlxscore=0
 phishscore=0 lowpriorityscore=0 malwarescore=0 priorityscore=1501
 impostorscore=0 suspectscore=0 adultscore=0 bulkscore=0 clxscore=1015
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106160084
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guvenc Gulce <guvenc@linux.ibm.com>

Add the ability to collect SMC statistics information. Per-cpu
variables are used to collect the statistic information for better
performance and for reducing concurrency pitfalls. The code that is
collecting statistic data is implemented in macros to increase code
reuse and readability.

Signed-off-by: Guvenc Gulce <guvenc@linux.ibm.com>
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 net/smc/Makefile    |   2 +-
 net/smc/af_smc.c    |  89 ++++++++++++----
 net/smc/smc_core.c  |  13 ++-
 net/smc/smc_rx.c    |   8 ++
 net/smc/smc_stats.c |  35 ++++++
 net/smc/smc_stats.h | 253 ++++++++++++++++++++++++++++++++++++++++++++
 net/smc/smc_tx.c    |  16 ++-
 7 files changed, 395 insertions(+), 21 deletions(-)
 create mode 100644 net/smc/smc_stats.c
 create mode 100644 net/smc/smc_stats.h

diff --git a/net/smc/Makefile b/net/smc/Makefile
index 77e54fe42b1c..99a0186cba5b 100644
--- a/net/smc/Makefile
+++ b/net/smc/Makefile
@@ -2,4 +2,4 @@
 obj-$(CONFIG_SMC)	+= smc.o
 obj-$(CONFIG_SMC_DIAG)	+= smc_diag.o
 smc-y := af_smc.o smc_pnet.o smc_ib.o smc_clc.o smc_core.o smc_wr.o smc_llc.o
-smc-y += smc_cdc.o smc_tx.o smc_rx.o smc_close.o smc_ism.o smc_netlink.o
+smc-y += smc_cdc.o smc_tx.o smc_rx.o smc_close.o smc_ism.o smc_netlink.o smc_stats.o
diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 5eff7cccceff..efeaed384769 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -49,6 +49,7 @@
 #include "smc_tx.h"
 #include "smc_rx.h"
 #include "smc_close.h"
+#include "smc_stats.h"
 
 static DEFINE_MUTEX(smc_server_lgr_pending);	/* serialize link group
 						 * creation on server
@@ -508,9 +509,42 @@ static void smc_link_save_peer_info(struct smc_link *link,
 	link->peer_mtu = clc->r0.qp_mtu;
 }
 
-static void smc_switch_to_fallback(struct smc_sock *smc)
+static void smc_stat_inc_fback_rsn_cnt(struct smc_sock *smc,
+				       struct smc_stats_fback *fback_arr)
+{
+	int cnt;
+
+	for (cnt = 0; cnt < SMC_MAX_FBACK_RSN_CNT; cnt++) {
+		if (fback_arr[cnt].fback_code == smc->fallback_rsn) {
+			fback_arr[cnt].count++;
+			break;
+		}
+		if (!fback_arr[cnt].fback_code) {
+			fback_arr[cnt].fback_code = smc->fallback_rsn;
+			fback_arr[cnt].count++;
+			break;
+		}
+	}
+}
+
+static void smc_stat_fallback(struct smc_sock *smc)
+{
+	mutex_lock(&smc_stat_fback_rsn);
+	if (smc->listen_smc) {
+		smc_stat_inc_fback_rsn_cnt(smc, fback_rsn.srv);
+		fback_rsn.srv_fback_cnt++;
+	} else {
+		smc_stat_inc_fback_rsn_cnt(smc, fback_rsn.clnt);
+		fback_rsn.clnt_fback_cnt++;
+	}
+	mutex_unlock(&smc_stat_fback_rsn);
+}
+
+static void smc_switch_to_fallback(struct smc_sock *smc, int reason_code)
 {
 	smc->use_fallback = true;
+	smc->fallback_rsn = reason_code;
+	smc_stat_fallback(smc);
 	if (smc->sk.sk_socket && smc->sk.sk_socket->file) {
 		smc->clcsock->file = smc->sk.sk_socket->file;
 		smc->clcsock->file->private_data = smc->clcsock;
@@ -522,8 +556,7 @@ static void smc_switch_to_fallback(struct smc_sock *smc)
 /* fall back during connect */
 static int smc_connect_fallback(struct smc_sock *smc, int reason_code)
 {
-	smc_switch_to_fallback(smc);
-	smc->fallback_rsn = reason_code;
+	smc_switch_to_fallback(smc, reason_code);
 	smc_copy_sock_settings_to_clc(smc);
 	smc->connect_nonblock = 0;
 	if (smc->sk.sk_state == SMC_INIT)
@@ -538,6 +571,7 @@ static int smc_connect_decline_fallback(struct smc_sock *smc, int reason_code,
 	int rc;
 
 	if (reason_code < 0) { /* error, fallback is not possible */
+		this_cpu_inc(smc_stats->clnt_hshake_err_cnt);
 		if (smc->sk.sk_state == SMC_INIT)
 			sock_put(&smc->sk); /* passive closing */
 		return reason_code;
@@ -545,6 +579,7 @@ static int smc_connect_decline_fallback(struct smc_sock *smc, int reason_code,
 	if (reason_code != SMC_CLC_DECL_PEERDECL) {
 		rc = smc_clc_send_decline(smc, reason_code, version);
 		if (rc < 0) {
+			this_cpu_inc(smc_stats->clnt_hshake_err_cnt);
 			if (smc->sk.sk_state == SMC_INIT)
 				sock_put(&smc->sk); /* passive closing */
 			return rc;
@@ -992,6 +1027,7 @@ static int __smc_connect(struct smc_sock *smc)
 	if (rc)
 		goto vlan_cleanup;
 
+	SMC_STAT_CLNT_SUCC_INC(aclc);
 	smc_connect_ism_vlan_cleanup(smc, ini);
 	kfree(buf);
 	kfree(ini);
@@ -1308,6 +1344,7 @@ static void smc_listen_out_err(struct smc_sock *new_smc)
 {
 	struct sock *newsmcsk = &new_smc->sk;
 
+	this_cpu_inc(smc_stats->srv_hshake_err_cnt);
 	if (newsmcsk->sk_state == SMC_INIT)
 		sock_put(&new_smc->sk); /* passive closing */
 	newsmcsk->sk_state = SMC_CLOSED;
@@ -1325,8 +1362,7 @@ static void smc_listen_decline(struct smc_sock *new_smc, int reason_code,
 		smc_listen_out_err(new_smc);
 		return;
 	}
-	smc_switch_to_fallback(new_smc);
-	new_smc->fallback_rsn = reason_code;
+	smc_switch_to_fallback(new_smc, reason_code);
 	if (reason_code && reason_code != SMC_CLC_DECL_PEERDECL) {
 		if (smc_clc_send_decline(new_smc, reason_code, version) < 0) {
 			smc_listen_out_err(new_smc);
@@ -1699,8 +1735,7 @@ static void smc_listen_work(struct work_struct *work)
 
 	/* check if peer is smc capable */
 	if (!tcp_sk(newclcsock->sk)->syn_smc) {
-		smc_switch_to_fallback(new_smc);
-		new_smc->fallback_rsn = SMC_CLC_DECL_PEERNOSMC;
+		smc_switch_to_fallback(new_smc, SMC_CLC_DECL_PEERNOSMC);
 		smc_listen_out_connected(new_smc);
 		return;
 	}
@@ -1778,6 +1813,7 @@ static void smc_listen_work(struct work_struct *work)
 	}
 	smc_conn_save_peer_info(new_smc, cclc);
 	smc_listen_out_connected(new_smc);
+	SMC_STAT_SERV_SUCC_INC(ini);
 	goto out_free;
 
 out_unlock:
@@ -1984,18 +2020,19 @@ static int smc_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
 
 	if (msg->msg_flags & MSG_FASTOPEN) {
 		if (sk->sk_state == SMC_INIT && !smc->connect_nonblock) {
-			smc_switch_to_fallback(smc);
-			smc->fallback_rsn = SMC_CLC_DECL_OPTUNSUPP;
+			smc_switch_to_fallback(smc, SMC_CLC_DECL_OPTUNSUPP);
 		} else {
 			rc = -EINVAL;
 			goto out;
 		}
 	}
 
-	if (smc->use_fallback)
+	if (smc->use_fallback) {
 		rc = smc->clcsock->ops->sendmsg(smc->clcsock, msg, len);
-	else
+	} else {
 		rc = smc_tx_sendmsg(smc, msg, len);
+		SMC_STAT_TX_PAYLOAD(smc, len, rc);
+	}
 out:
 	release_sock(sk);
 	return rc;
@@ -2030,6 +2067,7 @@ static int smc_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 	} else {
 		msg->msg_namelen = 0;
 		rc = smc_rx_recvmsg(smc, msg, NULL, len, flags);
+		SMC_STAT_RX_PAYLOAD(smc, rc, rc);
 	}
 
 out:
@@ -2194,8 +2232,7 @@ static int smc_setsockopt(struct socket *sock, int level, int optname,
 	case TCP_FASTOPEN_NO_COOKIE:
 		/* option not supported by SMC */
 		if (sk->sk_state == SMC_INIT && !smc->connect_nonblock) {
-			smc_switch_to_fallback(smc);
-			smc->fallback_rsn = SMC_CLC_DECL_OPTUNSUPP;
+			smc_switch_to_fallback(smc, SMC_CLC_DECL_OPTUNSUPP);
 		} else {
 			rc = -EINVAL;
 		}
@@ -2204,18 +2241,22 @@ static int smc_setsockopt(struct socket *sock, int level, int optname,
 		if (sk->sk_state != SMC_INIT &&
 		    sk->sk_state != SMC_LISTEN &&
 		    sk->sk_state != SMC_CLOSED) {
-			if (val)
+			if (val) {
+				SMC_STAT_INC(!smc->conn.lnk, ndly_cnt);
 				mod_delayed_work(smc->conn.lgr->tx_wq,
 						 &smc->conn.tx_work, 0);
+			}
 		}
 		break;
 	case TCP_CORK:
 		if (sk->sk_state != SMC_INIT &&
 		    sk->sk_state != SMC_LISTEN &&
 		    sk->sk_state != SMC_CLOSED) {
-			if (!val)
+			if (!val) {
+				SMC_STAT_INC(!smc->conn.lnk, cork_cnt);
 				mod_delayed_work(smc->conn.lgr->tx_wq,
 						 &smc->conn.tx_work, 0);
+			}
 		}
 		break;
 	case TCP_DEFER_ACCEPT:
@@ -2338,11 +2379,13 @@ static ssize_t smc_sendpage(struct socket *sock, struct page *page,
 		goto out;
 	}
 	release_sock(sk);
-	if (smc->use_fallback)
+	if (smc->use_fallback) {
 		rc = kernel_sendpage(smc->clcsock, page, offset,
 				     size, flags);
-	else
+	} else {
+		SMC_STAT_INC(!smc->conn.lnk, sendpage_cnt);
 		rc = sock_no_sendpage(sock, page, offset, size, flags);
+	}
 
 out:
 	return rc;
@@ -2391,6 +2434,7 @@ static ssize_t smc_splice_read(struct socket *sock, loff_t *ppos,
 			flags = MSG_DONTWAIT;
 		else
 			flags = 0;
+		SMC_STAT_INC(!smc->conn.lnk, splice_cnt);
 		rc = smc_rx_recvmsg(smc, NULL, pipe, len, flags);
 	}
 out:
@@ -2514,10 +2558,16 @@ static int __init smc_init(void)
 	if (!smc_close_wq)
 		goto out_alloc_hs_wq;
 
+	rc = smc_stats_init();
+	if (rc) {
+		pr_err("%s: smc_stats_init fails with %d\n", __func__, rc);
+		goto out_alloc_wqs;
+	}
+
 	rc = smc_core_init();
 	if (rc) {
 		pr_err("%s: smc_core_init fails with %d\n", __func__, rc);
-		goto out_alloc_wqs;
+		goto out_smc_stat;
 	}
 
 	rc = smc_llc_init();
@@ -2569,6 +2619,8 @@ static int __init smc_init(void)
 	proto_unregister(&smc_proto);
 out_core:
 	smc_core_exit();
+out_smc_stat:
+	smc_stats_exit();
 out_alloc_wqs:
 	destroy_workqueue(smc_close_wq);
 out_alloc_hs_wq:
@@ -2591,6 +2643,7 @@ static void __exit smc_exit(void)
 	smc_ib_unregister_client();
 	destroy_workqueue(smc_close_wq);
 	destroy_workqueue(smc_hs_wq);
+	smc_stats_exit();
 	proto_unregister(&smc_proto6);
 	proto_unregister(&smc_proto);
 	smc_pnet_exit();
diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index 317bc2c90fab..d69f58f670a1 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -33,6 +33,7 @@
 #include "smc_close.h"
 #include "smc_ism.h"
 #include "smc_netlink.h"
+#include "smc_stats.h"
 
 #define SMC_LGR_NUM_INCR		256
 #define SMC_LGR_FREE_DELAY_SERV		(600 * HZ)
@@ -2029,6 +2030,7 @@ static int __smc_buf_create(struct smc_sock *smc, bool is_smcd, bool is_rmb)
 	struct smc_link_group *lgr = conn->lgr;
 	struct list_head *buf_list;
 	int bufsize, bufsize_short;
+	bool is_dgraded = false;
 	struct mutex *lock;	/* lock buffer list */
 	int sk_buf_size;
 
@@ -2056,6 +2058,8 @@ static int __smc_buf_create(struct smc_sock *smc, bool is_smcd, bool is_rmb)
 		/* check for reusable slot in the link group */
 		buf_desc = smc_buf_get_slot(bufsize_short, lock, buf_list);
 		if (buf_desc) {
+			SMC_STAT_RMB_SIZE(is_smcd, is_rmb, bufsize);
+			SMC_STAT_BUF_REUSE(is_smcd, is_rmb);
 			memset(buf_desc->cpu_addr, 0, bufsize);
 			break; /* found reusable slot */
 		}
@@ -2067,9 +2071,16 @@ static int __smc_buf_create(struct smc_sock *smc, bool is_smcd, bool is_rmb)
 
 		if (PTR_ERR(buf_desc) == -ENOMEM)
 			break;
-		if (IS_ERR(buf_desc))
+		if (IS_ERR(buf_desc)) {
+			if (!is_dgraded) {
+				is_dgraded = true;
+				SMC_STAT_RMB_DOWNGRADED(is_smcd, is_rmb);
+			}
 			continue;
+		}
 
+		SMC_STAT_RMB_ALLOC(is_smcd, is_rmb);
+		SMC_STAT_RMB_SIZE(is_smcd, is_rmb, bufsize);
 		buf_desc->used = 1;
 		mutex_lock(lock);
 		list_add(&buf_desc->list, buf_list);
diff --git a/net/smc/smc_rx.c b/net/smc/smc_rx.c
index fcfac59f8b72..ce1ae39923b1 100644
--- a/net/smc/smc_rx.c
+++ b/net/smc/smc_rx.c
@@ -21,6 +21,7 @@
 #include "smc_cdc.h"
 #include "smc_tx.h" /* smc_tx_consumer_update() */
 #include "smc_rx.h"
+#include "smc_stats.h"
 
 /* callback implementation to wakeup consumers blocked with smc_rx_wait().
  * indirectly called by smc_cdc_msg_recv_action().
@@ -227,6 +228,7 @@ static int smc_rx_recv_urg(struct smc_sock *smc, struct msghdr *msg, int len,
 	    conn->urg_state == SMC_URG_READ)
 		return -EINVAL;
 
+	SMC_STAT_INC(!conn->lnk, urg_data_cnt);
 	if (conn->urg_state == SMC_URG_VALID) {
 		if (!(flags & MSG_PEEK))
 			smc->conn.urg_state = SMC_URG_READ;
@@ -303,6 +305,12 @@ int smc_rx_recvmsg(struct smc_sock *smc, struct msghdr *msg,
 	timeo = sock_rcvtimeo(sk, flags & MSG_DONTWAIT);
 	target = sock_rcvlowat(sk, flags & MSG_WAITALL, len);
 
+	readable = atomic_read(&conn->bytes_to_rcv);
+	if (readable >= conn->rmb_desc->len)
+		SMC_STAT_RMB_RX_FULL(!conn->lnk);
+
+	if (len < readable)
+		SMC_STAT_RMB_RX_SIZE_SMALL(!conn->lnk);
 	/* we currently use 1 RMBE per RMB, so RMBE == RMB base addr */
 	rcvbuf_base = conn->rx_off + conn->rmb_desc->cpu_addr;
 
diff --git a/net/smc/smc_stats.c b/net/smc/smc_stats.c
new file mode 100644
index 000000000000..76e938388520
--- /dev/null
+++ b/net/smc/smc_stats.c
@@ -0,0 +1,35 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Shared Memory Communications over RDMA (SMC-R) and RoCE
+ *
+ * SMC statistics netlink routines
+ *
+ * Copyright IBM Corp. 2021
+ *
+ * Author(s):  Guvenc Gulce
+ */
+#include <linux/init.h>
+#include <linux/mutex.h>
+#include <linux/percpu.h>
+#include <linux/ctype.h>
+#include "smc_stats.h"
+
+/* serialize fallback reason statistic gathering */
+DEFINE_MUTEX(smc_stat_fback_rsn);
+struct smc_stats __percpu *smc_stats;	/* per cpu counters for SMC */
+struct smc_stats_reason fback_rsn;
+
+int __init smc_stats_init(void)
+{
+	memset(&fback_rsn, 0, sizeof(fback_rsn));
+	smc_stats = alloc_percpu(struct smc_stats);
+	if (!smc_stats)
+		return -ENOMEM;
+
+	return 0;
+}
+
+void smc_stats_exit(void)
+{
+	free_percpu(smc_stats);
+}
diff --git a/net/smc/smc_stats.h b/net/smc/smc_stats.h
new file mode 100644
index 000000000000..928372114cf1
--- /dev/null
+++ b/net/smc/smc_stats.h
@@ -0,0 +1,253 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Shared Memory Communications over RDMA (SMC-R) and RoCE
+ *
+ * Macros for SMC statistics
+ *
+ * Copyright IBM Corp. 2021
+ *
+ * Author(s):  Guvenc Gulce
+ */
+
+#ifndef NET_SMC_SMC_STATS_H_
+#define NET_SMC_SMC_STATS_H_
+#include <linux/init.h>
+#include <linux/mutex.h>
+#include <linux/percpu.h>
+#include <linux/ctype.h>
+#include <linux/smc.h>
+
+#include "smc_clc.h"
+
+#define SMC_MAX_FBACK_RSN_CNT 30
+
+extern struct smc_stats __percpu *smc_stats;	/* per cpu counters for SMC */
+extern struct smc_stats_reason fback_rsn;
+extern struct mutex smc_stat_fback_rsn;
+
+enum {
+	SMC_BUF_8K,
+	SMC_BUF_16K,
+	SMC_BUF_32K,
+	SMC_BUF_64K,
+	SMC_BUF_128K,
+	SMC_BUF_256K,
+	SMC_BUF_512K,
+	SMC_BUF_1024K,
+	SMC_BUF_G_1024K,
+	SMC_BUF_MAX,
+};
+
+struct smc_stats_fback {
+	int	fback_code;
+	u16	count;
+};
+
+struct smc_stats_reason {
+	struct	smc_stats_fback srv[SMC_MAX_FBACK_RSN_CNT];
+	struct	smc_stats_fback clnt[SMC_MAX_FBACK_RSN_CNT];
+	u64			srv_fback_cnt;
+	u64			clnt_fback_cnt;
+};
+
+struct smc_stats_rmbcnt {
+	u64	buf_size_small_peer_cnt;
+	u64	buf_size_small_cnt;
+	u64	buf_full_peer_cnt;
+	u64	buf_full_cnt;
+	u64	reuse_cnt;
+	u64	alloc_cnt;
+	u64	dgrade_cnt;
+};
+
+struct smc_stats_memsize {
+	u64	buf[SMC_BUF_MAX];
+};
+
+struct smc_stats_tech {
+	struct smc_stats_memsize tx_rmbsize;
+	struct smc_stats_memsize rx_rmbsize;
+	struct smc_stats_memsize tx_pd;
+	struct smc_stats_memsize rx_pd;
+	struct smc_stats_rmbcnt rmb_tx;
+	struct smc_stats_rmbcnt rmb_rx;
+	u64			clnt_v1_succ_cnt;
+	u64			clnt_v2_succ_cnt;
+	u64			srv_v1_succ_cnt;
+	u64			srv_v2_succ_cnt;
+	u64			sendpage_cnt;
+	u64			urg_data_cnt;
+	u64			splice_cnt;
+	u64			cork_cnt;
+	u64			ndly_cnt;
+	u64			rx_bytes;
+	u64			tx_bytes;
+	u64			rx_cnt;
+	u64			tx_cnt;
+};
+
+struct smc_stats {
+	struct smc_stats_tech	smc[2];
+	u64			clnt_hshake_err_cnt;
+	u64			srv_hshake_err_cnt;
+};
+
+#define SMC_STAT_PAYLOAD_SUB(_tech, key, _len, _rc) \
+do { \
+	typeof(_tech) t = (_tech); \
+	typeof(_len) l = (_len); \
+	int _pos = fls64((l) >> 13); \
+	typeof(_rc) r = (_rc); \
+	int m = SMC_BUF_MAX - 1; \
+	this_cpu_inc((*smc_stats).smc[t].key ## _cnt); \
+	if (r <= 0) \
+		break; \
+	_pos = (_pos < m) ? ((l == 1 << (_pos + 12)) ? _pos - 1 : _pos) : m; \
+	this_cpu_inc((*smc_stats).smc[t].key ## _pd.buf[_pos]); \
+	this_cpu_add((*smc_stats).smc[t].key ## _bytes, r); \
+} \
+while (0)
+
+#define SMC_STAT_TX_PAYLOAD(_smc, length, rcode) \
+do { \
+	typeof(_smc) __smc = _smc; \
+	typeof(length) _len = (length); \
+	typeof(rcode) _rc = (rcode); \
+	bool is_smcd = !__smc->conn.lnk; \
+	if (is_smcd) \
+		SMC_STAT_PAYLOAD_SUB(SMC_TYPE_D, tx, _len, _rc); \
+	else \
+		SMC_STAT_PAYLOAD_SUB(SMC_TYPE_R, tx, _len, _rc); \
+} \
+while (0)
+
+#define SMC_STAT_RX_PAYLOAD(_smc, length, rcode) \
+do { \
+	typeof(_smc) __smc = _smc; \
+	typeof(length) _len = (length); \
+	typeof(rcode) _rc = (rcode); \
+	bool is_smcd = !__smc->conn.lnk; \
+	if (is_smcd) \
+		SMC_STAT_PAYLOAD_SUB(SMC_TYPE_D, rx, _len, _rc); \
+	else \
+		SMC_STAT_PAYLOAD_SUB(SMC_TYPE_R, rx, _len, _rc); \
+} \
+while (0)
+
+#define SMC_STAT_RMB_SIZE_SUB(_tech, k, _len) \
+do { \
+	typeof(_len) _l = (_len); \
+	typeof(_tech) t = (_tech); \
+	int _pos = fls((_l) >> 13); \
+	int m = SMC_BUF_MAX - 1; \
+	_pos = (_pos < m) ? ((_l == 1 << (_pos + 12)) ? _pos - 1 : _pos) : m; \
+	this_cpu_inc((*smc_stats).smc[t].k ## _rmbsize.buf[_pos]); \
+} \
+while (0)
+
+#define SMC_STAT_RMB_SUB(type, t, key) \
+	this_cpu_inc((*smc_stats).smc[t].rmb ## _ ## key.type ## _cnt)
+
+#define SMC_STAT_RMB_SIZE(_is_smcd, _is_rx, _len) \
+do { \
+	typeof(_is_smcd) is_d = (_is_smcd); \
+	typeof(_is_rx) is_r = (_is_rx); \
+	typeof(_len) l = (_len); \
+	if ((is_d) && (is_r)) \
+		SMC_STAT_RMB_SIZE_SUB(SMC_TYPE_D, rx, l); \
+	if ((is_d) && !(is_r)) \
+		SMC_STAT_RMB_SIZE_SUB(SMC_TYPE_D, tx, l); \
+	if (!(is_d) && (is_r)) \
+		SMC_STAT_RMB_SIZE_SUB(SMC_TYPE_R, rx, l); \
+	if (!(is_d) && !(is_r)) \
+		SMC_STAT_RMB_SIZE_SUB(SMC_TYPE_R, tx, l); \
+} \
+while (0)
+
+#define SMC_STAT_RMB(type, _is_smcd, _is_rx) \
+do { \
+	typeof(_is_smcd) is_d = (_is_smcd); \
+	typeof(_is_rx) is_r = (_is_rx); \
+	if ((is_d) && (is_r)) \
+		SMC_STAT_RMB_SUB(type, SMC_TYPE_D, rx); \
+	if ((is_d) && !(is_r)) \
+		SMC_STAT_RMB_SUB(type, SMC_TYPE_D, tx); \
+	if (!(is_d) && (is_r)) \
+		SMC_STAT_RMB_SUB(type, SMC_TYPE_R, rx); \
+	if (!(is_d) && !(is_r)) \
+		SMC_STAT_RMB_SUB(type, SMC_TYPE_R, tx); \
+} \
+while (0)
+
+#define SMC_STAT_BUF_REUSE(is_smcd, is_rx) \
+	SMC_STAT_RMB(reuse, is_smcd, is_rx)
+
+#define SMC_STAT_RMB_ALLOC(is_smcd, is_rx) \
+	SMC_STAT_RMB(alloc, is_smcd, is_rx)
+
+#define SMC_STAT_RMB_DOWNGRADED(is_smcd, is_rx) \
+	SMC_STAT_RMB(dgrade, is_smcd, is_rx)
+
+#define SMC_STAT_RMB_TX_PEER_FULL(is_smcd) \
+	SMC_STAT_RMB(buf_full_peer, is_smcd, false)
+
+#define SMC_STAT_RMB_TX_FULL(is_smcd) \
+	SMC_STAT_RMB(buf_full, is_smcd, false)
+
+#define SMC_STAT_RMB_TX_PEER_SIZE_SMALL(is_smcd) \
+	SMC_STAT_RMB(buf_size_small_peer, is_smcd, false)
+
+#define SMC_STAT_RMB_TX_SIZE_SMALL(is_smcd) \
+	SMC_STAT_RMB(buf_size_small, is_smcd, false)
+
+#define SMC_STAT_RMB_RX_SIZE_SMALL(is_smcd) \
+	SMC_STAT_RMB(buf_size_small, is_smcd, true)
+
+#define SMC_STAT_RMB_RX_FULL(is_smcd) \
+	SMC_STAT_RMB(buf_full, is_smcd, true)
+
+#define SMC_STAT_INC(is_smcd, type) \
+do { \
+	if ((is_smcd)) \
+		this_cpu_inc(smc_stats->smc[SMC_TYPE_D].type); \
+	else \
+		this_cpu_inc(smc_stats->smc[SMC_TYPE_R].type); \
+} \
+while (0)
+
+#define SMC_STAT_CLNT_SUCC_INC(_aclc) \
+do { \
+	typeof(_aclc) acl = (_aclc); \
+	bool is_v2 = (acl->hdr.version == SMC_V2); \
+	bool is_smcd = (acl->hdr.typev1 == SMC_TYPE_D); \
+	if (is_v2 && is_smcd) \
+		this_cpu_inc(smc_stats->smc[SMC_TYPE_D].clnt_v2_succ_cnt); \
+	else if (is_v2 && !is_smcd) \
+		this_cpu_inc(smc_stats->smc[SMC_TYPE_R].clnt_v2_succ_cnt); \
+	else if (!is_v2 && is_smcd) \
+		this_cpu_inc(smc_stats->smc[SMC_TYPE_D].clnt_v1_succ_cnt); \
+	else if (!is_v2 && !is_smcd) \
+		this_cpu_inc(smc_stats->smc[SMC_TYPE_R].clnt_v1_succ_cnt); \
+} \
+while (0)
+
+#define SMC_STAT_SERV_SUCC_INC(_ini) \
+do { \
+	typeof(_ini) i = (_ini); \
+	bool is_v2 = (i->smcd_version & SMC_V2); \
+	bool is_smcd = (i->is_smcd); \
+	if (is_v2 && is_smcd) \
+		this_cpu_inc(smc_stats->smc[SMC_TYPE_D].srv_v2_succ_cnt); \
+	else if (is_v2 && !is_smcd) \
+		this_cpu_inc(smc_stats->smc[SMC_TYPE_R].srv_v2_succ_cnt); \
+	else if (!is_v2 && is_smcd) \
+		this_cpu_inc(smc_stats->smc[SMC_TYPE_D].srv_v1_succ_cnt); \
+	else if (!is_v2 && !is_smcd) \
+		this_cpu_inc(smc_stats->smc[SMC_TYPE_R].srv_v1_succ_cnt); \
+} \
+while (0)
+
+int smc_stats_init(void) __init;
+void smc_stats_exit(void);
+
+#endif /* NET_SMC_SMC_STATS_H_ */
diff --git a/net/smc/smc_tx.c b/net/smc/smc_tx.c
index 4532c16bf85e..a043544d715f 100644
--- a/net/smc/smc_tx.c
+++ b/net/smc/smc_tx.c
@@ -27,6 +27,7 @@
 #include "smc_close.h"
 #include "smc_ism.h"
 #include "smc_tx.h"
+#include "smc_stats.h"
 
 #define SMC_TX_WORK_DELAY	0
 #define SMC_TX_CORK_DELAY	(HZ >> 2)	/* 250 ms */
@@ -45,6 +46,8 @@ static void smc_tx_write_space(struct sock *sk)
 
 	/* similar to sk_stream_write_space */
 	if (atomic_read(&smc->conn.sndbuf_space) && sock) {
+		if (test_bit(SOCK_NOSPACE, &sock->flags))
+			SMC_STAT_RMB_TX_FULL(!smc->conn.lnk);
 		clear_bit(SOCK_NOSPACE, &sock->flags);
 		rcu_read_lock();
 		wq = rcu_dereference(sk->sk_wq);
@@ -151,6 +154,15 @@ int smc_tx_sendmsg(struct smc_sock *smc, struct msghdr *msg, size_t len)
 		goto out_err;
 	}
 
+	if (len > conn->sndbuf_desc->len)
+		SMC_STAT_RMB_TX_SIZE_SMALL(!conn->lnk);
+
+	if (len > conn->peer_rmbe_size)
+		SMC_STAT_RMB_TX_PEER_SIZE_SMALL(!conn->lnk);
+
+	if (msg->msg_flags & MSG_OOB)
+		SMC_STAT_INC(!conn->lnk, urg_data_cnt);
+
 	while (msg_data_left(msg)) {
 		if (sk->sk_state == SMC_INIT)
 			return -ENOTCONN;
@@ -419,8 +431,10 @@ static int smc_tx_rdma_writes(struct smc_connection *conn,
 	/* destination: RMBE */
 	/* cf. snd_wnd */
 	rmbespace = atomic_read(&conn->peer_rmbe_space);
-	if (rmbespace <= 0)
+	if (rmbespace <= 0) {
+		SMC_STAT_RMB_TX_PEER_FULL(!conn->lnk);
 		return 0;
+	}
 	smc_curs_copy(&prod, &conn->local_tx_ctrl.prod, conn);
 	smc_curs_copy(&cons, &conn->local_rx_ctrl.cons, conn);
 
-- 
2.25.1

