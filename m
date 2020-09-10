Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36579264A5F
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 18:55:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727035AbgIJQyr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 12:54:47 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:30302 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727030AbgIJQtV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 12:49:21 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08AGQUg8088981;
        Thu, 10 Sep 2020 12:49:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=7kFcK0qU1PMMzuKu/tjRytCWi0DcK1Ppot8MNhbFh2k=;
 b=UtzwmNZWoK8EQNKKn0pNvcEsfG7Nuno6g+R7OHspZm3mGO+5AbSujMueB6ktn0vLFNFD
 3QEvE5NPFeUcc4luh11nK7ZT9A7inXUS9137RuW7n+6wz7JbmWHuoP+d+l6BPqVsKLId
 /h6ho53ABien7ooBC3eNKlI7CGRk1BhzA6cCJ1LUIBsFn5JtOOWuz1j+AcrLtmh0XcsG
 /WUosJAWRTaAhCYsia7PD/RvTBqm96eYqNiXiyYLeWZ6QENFJpsVrogl+Q9GaP1oGXl9
 +2m2lH23M9MV4PJ/CL25IQPAkk/M0IJJduECN8ecUu1xZij0o5cOqJhlV0+owRCiTAUU wQ== 
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33fq9s169m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Sep 2020 12:49:09 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08AGmCI0026575;
        Thu, 10 Sep 2020 16:49:04 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma01fra.de.ibm.com with ESMTP id 33c2a81hn7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Sep 2020 16:49:04 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08AGn1iu56164694
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Sep 2020 16:49:02 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DF4664C050;
        Thu, 10 Sep 2020 16:49:01 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A47F64C04A;
        Thu, 10 Sep 2020 16:49:01 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 10 Sep 2020 16:49:01 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net-next 10/10] net/smc: use separate work queues for different worker types
Date:   Thu, 10 Sep 2020 18:48:29 +0200
Message-Id: <20200910164829.65426-11-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200910164829.65426-1-kgraul@linux.ibm.com>
References: <20200910164829.65426-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-10_04:2020-09-10,2020-09-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 adultscore=0
 suspectscore=3 bulkscore=0 impostorscore=0 clxscore=1015 phishscore=0
 priorityscore=1501 malwarescore=0 lowpriorityscore=0 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009100148
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are 6 types of workers which exist per smc connection. 3 of them
are used for listen and handshake processing, another 2 are used for
close and abort processing and 1 is the tx worker that moves calls to
sleeping functions into a worker.
To prevent flooding of the system work queue when many connections are
opened or closed at the same time (some pattern uperf implements), move
those workers to one of 3 smc-specific work queues. Two work queues are
module-global and used for handshake and close workers. The third work
queue is defined per link group and used by the tx workers that may
sleep waiting for resources of this link group.
And in smc_llc_enqueue() queue the llc_event_work work to the system
prio work queue because its critical that this work is started fast.

Reviewed-by: Ursula Braun <ubraun@linux.ibm.com>
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 net/smc/af_smc.c   | 34 ++++++++++++++++++++++++++--------
 net/smc/smc.h      |  3 +++
 net/smc/smc_cdc.c  |  4 ++--
 net/smc/smc_core.c | 13 +++++++++++--
 net/smc/smc_core.h |  1 +
 net/smc/smc_llc.c  |  2 +-
 net/smc/smc_tx.c   | 10 +++++-----
 7 files changed, 49 insertions(+), 18 deletions(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 9f3e148c60c5..f5bececfedaa 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -55,6 +55,9 @@ static DEFINE_MUTEX(smc_client_lgr_pending);	/* serialize link group
 						 * creation on client
 						 */
 
+struct workqueue_struct	*smc_hs_wq;	/* wq for handshake work */
+struct workqueue_struct	*smc_close_wq;	/* wq for close work */
+
 static void smc_tcp_listen_work(struct work_struct *);
 static void smc_connect_work(struct work_struct *);
 
@@ -905,7 +908,7 @@ static int smc_connect(struct socket *sock, struct sockaddr *addr,
 	if (smc->use_fallback)
 		goto out;
 	if (flags & O_NONBLOCK) {
-		if (schedule_work(&smc->connect_work))
+		if (queue_work(smc_hs_wq, &smc->connect_work))
 			smc->connect_nonblock = 1;
 		rc = -EINPROGRESS;
 	} else {
@@ -1412,7 +1415,7 @@ static void smc_tcp_listen_work(struct work_struct *work)
 		new_smc->sk.sk_sndbuf = lsmc->sk.sk_sndbuf;
 		new_smc->sk.sk_rcvbuf = lsmc->sk.sk_rcvbuf;
 		sock_hold(&new_smc->sk); /* sock_put in passive closing */
-		if (!schedule_work(&new_smc->smc_listen_work))
+		if (!queue_work(smc_hs_wq, &new_smc->smc_listen_work))
 			sock_put(&new_smc->sk);
 	}
 
@@ -1432,7 +1435,7 @@ static void smc_clcsock_data_ready(struct sock *listen_clcsock)
 	lsmc->clcsk_data_ready(listen_clcsock);
 	if (lsmc->sk.sk_state == SMC_LISTEN) {
 		sock_hold(&lsmc->sk); /* sock_put in smc_tcp_listen_work() */
-		if (!schedule_work(&lsmc->tcp_listen_work))
+		if (!queue_work(smc_hs_wq, &lsmc->tcp_listen_work))
 			sock_put(&lsmc->sk);
 	}
 }
@@ -1800,8 +1803,8 @@ static int smc_setsockopt(struct socket *sock, int level, int optname,
 		    sk->sk_state != SMC_LISTEN &&
 		    sk->sk_state != SMC_CLOSED) {
 			if (val)
-				mod_delayed_work(system_wq, &smc->conn.tx_work,
-						 0);
+				mod_delayed_work(smc->conn.lgr->tx_wq,
+						 &smc->conn.tx_work, 0);
 		}
 		break;
 	case TCP_CORK:
@@ -1809,8 +1812,8 @@ static int smc_setsockopt(struct socket *sock, int level, int optname,
 		    sk->sk_state != SMC_LISTEN &&
 		    sk->sk_state != SMC_CLOSED) {
 			if (!val)
-				mod_delayed_work(system_wq, &smc->conn.tx_work,
-						 0);
+				mod_delayed_work(smc->conn.lgr->tx_wq,
+						 &smc->conn.tx_work, 0);
 		}
 		break;
 	case TCP_DEFER_ACCEPT:
@@ -2093,10 +2096,19 @@ static int __init smc_init(void)
 	if (rc)
 		goto out_pernet_subsys;
 
+	rc = -ENOMEM;
+	smc_hs_wq = alloc_workqueue("smc_hs_wq", 0, 0);
+	if (!smc_hs_wq)
+		goto out_pnet;
+
+	smc_close_wq = alloc_workqueue("smc_close_wq", 0, 0);
+	if (!smc_close_wq)
+		goto out_alloc_hs_wq;
+
 	rc = smc_core_init();
 	if (rc) {
 		pr_err("%s: smc_core_init fails with %d\n", __func__, rc);
-		goto out_pnet;
+		goto out_alloc_wqs;
 	}
 
 	rc = smc_llc_init();
@@ -2148,6 +2160,10 @@ static int __init smc_init(void)
 	proto_unregister(&smc_proto);
 out_core:
 	smc_core_exit();
+out_alloc_wqs:
+	destroy_workqueue(smc_close_wq);
+out_alloc_hs_wq:
+	destroy_workqueue(smc_hs_wq);
 out_pnet:
 	smc_pnet_exit();
 out_pernet_subsys:
@@ -2162,6 +2178,8 @@ static void __exit smc_exit(void)
 	sock_unregister(PF_SMC);
 	smc_core_exit();
 	smc_ib_unregister_client();
+	destroy_workqueue(smc_close_wq);
+	destroy_workqueue(smc_hs_wq);
 	proto_unregister(&smc_proto6);
 	proto_unregister(&smc_proto);
 	smc_pnet_exit();
diff --git a/net/smc/smc.h b/net/smc/smc.h
index 356f39532bf3..2bd57e57b7e7 100644
--- a/net/smc/smc.h
+++ b/net/smc/smc.h
@@ -239,6 +239,9 @@ static inline struct smc_sock *smc_sk(const struct sock *sk)
 	return (struct smc_sock *)sk;
 }
 
+extern struct workqueue_struct	*smc_hs_wq;	/* wq for handshake work */
+extern struct workqueue_struct	*smc_close_wq;	/* wq for close work */
+
 #define SMC_SYSTEMID_LEN		8
 
 extern u8	local_systemid[SMC_SYSTEMID_LEN]; /* unique system identifier */
diff --git a/net/smc/smc_cdc.c b/net/smc/smc_cdc.c
index ce468ff62a19..b1ce6ccbfaec 100644
--- a/net/smc/smc_cdc.c
+++ b/net/smc/smc_cdc.c
@@ -299,7 +299,7 @@ static void smc_cdc_msg_validate(struct smc_sock *smc, struct smc_cdc_msg *cdc,
 		conn->lnk = link;
 		spin_unlock_bh(&conn->send_lock);
 		sock_hold(&smc->sk); /* sock_put in abort_work */
-		if (!schedule_work(&conn->abort_work))
+		if (!queue_work(smc_close_wq, &conn->abort_work))
 			sock_put(&smc->sk);
 	}
 }
@@ -368,7 +368,7 @@ static void smc_cdc_msg_recv_action(struct smc_sock *smc,
 			smc->clcsock->sk->sk_shutdown |= RCV_SHUTDOWN;
 		sock_set_flag(&smc->sk, SOCK_DONE);
 		sock_hold(&smc->sk); /* sock_put in close_work */
-		if (!schedule_work(&conn->close_work))
+		if (!queue_work(smc_close_wq, &conn->close_work))
 			sock_put(&smc->sk);
 	}
 }
diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index e8711830d69e..c811ae1a8add 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -386,6 +386,12 @@ static int smc_lgr_create(struct smc_sock *smc, struct smc_init_info *ini)
 		rc = SMC_CLC_DECL_MEM;
 		goto ism_put_vlan;
 	}
+	lgr->tx_wq = alloc_workqueue("smc_tx_wq-%*phN", 0, 0,
+				     SMC_LGR_ID_SIZE, &lgr->id);
+	if (!lgr->tx_wq) {
+		rc = -ENOMEM;
+		goto free_lgr;
+	}
 	lgr->is_smcd = ini->is_smcd;
 	lgr->sync_err = 0;
 	lgr->terminating = 0;
@@ -426,7 +432,7 @@ static int smc_lgr_create(struct smc_sock *smc, struct smc_init_info *ini)
 		lnk = &lgr->lnk[link_idx];
 		rc = smcr_link_init(lgr, lnk, link_idx, ini);
 		if (rc)
-			goto free_lgr;
+			goto free_wq;
 		lgr_list = &smc_lgr_list.list;
 		lgr_lock = &smc_lgr_list.lock;
 		atomic_inc(&lgr_cnt);
@@ -437,6 +443,8 @@ static int smc_lgr_create(struct smc_sock *smc, struct smc_init_info *ini)
 	spin_unlock_bh(lgr_lock);
 	return 0;
 
+free_wq:
+	destroy_workqueue(lgr->tx_wq);
 free_lgr:
 	kfree(lgr);
 ism_put_vlan:
@@ -506,7 +514,7 @@ static int smc_switch_cursor(struct smc_sock *smc, struct smc_cdc_tx_pend *pend,
 	    smc->sk.sk_state != SMC_CLOSED) {
 		rc = smcr_cdc_msg_send_validation(conn, pend, wr_buf);
 		if (!rc) {
-			schedule_delayed_work(&conn->tx_work, 0);
+			queue_delayed_work(conn->lgr->tx_wq, &conn->tx_work, 0);
 			smc->sk.sk_data_ready(&smc->sk);
 		}
 	} else {
@@ -813,6 +821,7 @@ static void smc_lgr_free(struct smc_link_group *lgr)
 	}
 
 	smc_lgr_free_bufs(lgr);
+	destroy_workqueue(lgr->tx_wq);
 	if (lgr->is_smcd) {
 		smc_ism_put_vlan(lgr->smcd, lgr->vlan_id);
 		put_device(&lgr->smcd->dev);
diff --git a/net/smc/smc_core.h b/net/smc/smc_core.h
index 3fe985d6f4cd..37a5903789b0 100644
--- a/net/smc/smc_core.h
+++ b/net/smc/smc_core.h
@@ -225,6 +225,7 @@ struct smc_link_group {
 	u8			id[SMC_LGR_ID_SIZE];	/* unique lgr id */
 	struct delayed_work	free_work;	/* delayed freeing of an lgr */
 	struct work_struct	terminate_work;	/* abnormal lgr termination */
+	struct workqueue_struct	*tx_wq;		/* wq for conn. tx workers */
 	u8			sync_err : 1;	/* lgr no longer fits to peer */
 	u8			terminating : 1;/* lgr is terminating */
 	u8			freeing : 1;	/* lgr is being freed */
diff --git a/net/smc/smc_llc.c b/net/smc/smc_llc.c
index 3ea33466ebe9..2db967f2fb50 100644
--- a/net/smc/smc_llc.c
+++ b/net/smc/smc_llc.c
@@ -1691,7 +1691,7 @@ static void smc_llc_enqueue(struct smc_link *link, union smc_llc_msg *llc)
 	spin_lock_irqsave(&lgr->llc_event_q_lock, flags);
 	list_add_tail(&qentry->list, &lgr->llc_event_q);
 	spin_unlock_irqrestore(&lgr->llc_event_q_lock, flags);
-	schedule_work(&lgr->llc_event_work);
+	queue_work(system_highpri_wq, &lgr->llc_event_work);
 }
 
 /* copy received msg and add it to the event queue */
diff --git a/net/smc/smc_tx.c b/net/smc/smc_tx.c
index 54ba0443847e..4532c16bf85e 100644
--- a/net/smc/smc_tx.c
+++ b/net/smc/smc_tx.c
@@ -228,8 +228,8 @@ int smc_tx_sendmsg(struct smc_sock *smc, struct msghdr *msg, size_t len)
 			/* for a corked socket defer the RDMA writes if there
 			 * is still sufficient sndbuf_space available
 			 */
-			schedule_delayed_work(&conn->tx_work,
-					      SMC_TX_CORK_DELAY);
+			queue_delayed_work(conn->lgr->tx_wq, &conn->tx_work,
+					   SMC_TX_CORK_DELAY);
 		else
 			smc_tx_sndbuf_nonempty(conn);
 	} /* while (msg_data_left(msg)) */
@@ -499,7 +499,7 @@ static int smcr_tx_sndbuf_nonempty(struct smc_connection *conn)
 			if (conn->killed)
 				return -EPIPE;
 			rc = 0;
-			mod_delayed_work(system_wq, &conn->tx_work,
+			mod_delayed_work(conn->lgr->tx_wq, &conn->tx_work,
 					 SMC_TX_WORK_DELAY);
 		}
 		return rc;
@@ -623,8 +623,8 @@ void smc_tx_consumer_update(struct smc_connection *conn, bool force)
 			return;
 		if ((smc_cdc_get_slot_and_msg_send(conn) < 0) &&
 		    !conn->killed) {
-			schedule_delayed_work(&conn->tx_work,
-					      SMC_TX_WORK_DELAY);
+			queue_delayed_work(conn->lgr->tx_wq, &conn->tx_work,
+					   SMC_TX_WORK_DELAY);
 			return;
 		}
 	}
-- 
2.17.1

