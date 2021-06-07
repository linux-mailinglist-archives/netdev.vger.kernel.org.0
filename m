Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CA6139E66F
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 20:20:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230519AbhFGSWe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 14:22:34 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:60344 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230316AbhFGSWb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 14:22:31 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 157I3wWJ039660;
        Mon, 7 Jun 2021 14:20:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=TlUVyhd1I/S1s9oywuVdqCiNJhe6oZ3yzZTdEVcmpsE=;
 b=nPEzznPVgJrI92ZzV/1kI2QPp96qnS7+Dqug+3Ktib1F5XaNp95tE/SbN+FhbCdaqN1L
 CroySoWEeuaeYbV9btgXf5Qg5mB4FHkBcP88F+LUkMc3cR4RS6YwAs8Seab8WmB+wOOv
 epscZG7Beb6Fyest7oBjie9HQTC/iwQvT0X4wA5yZqJFLSTqiHIlet9OZJPe85ui8gNq
 wzL4GqFIy45DKY9CQC8ecM2eh2uNg04zK1OCwcQsDxRIQkR26bB/YcFdyY0WLYOzVnSo
 hoDD90+UdM0gw3ne3cRi7nUx/2rlc1PtpIggEEOWRHlOTXAIQ/Z4lWAIGW76sVtK/0Wk iQ== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 391q892ke9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Jun 2021 14:20:36 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 157IBL3V021620;
        Mon, 7 Jun 2021 18:20:34 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3900hhs30j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Jun 2021 18:20:34 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 157IJikk35717438
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 7 Jun 2021 18:19:45 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8B813A4059;
        Mon,  7 Jun 2021 18:20:31 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4D8CAA405E;
        Mon,  7 Jun 2021 18:20:31 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  7 Jun 2021 18:20:31 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Heiko Carstens <hca@linux.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [PATCH net-next 4/4] net/smc: Make SMC statistics network namespace aware
Date:   Mon,  7 Jun 2021 20:20:14 +0200
Message-Id: <20210607182014.3384922-5-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210607182014.3384922-1-kgraul@linux.ibm.com>
References: <20210607182014.3384922-1-kgraul@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: pcmIkX-EcHQfMDLvEBt2ssbnlU3AAzpT
X-Proofpoint-ORIG-GUID: pcmIkX-EcHQfMDLvEBt2ssbnlU3AAzpT
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-07_14:2021-06-04,2021-06-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 spamscore=0
 clxscore=1015 priorityscore=1501 suspectscore=0 adultscore=0
 malwarescore=0 mlxscore=0 lowpriorityscore=0 bulkscore=0 phishscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106070125
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guvenc Gulce <guvenc@linux.ibm.com>

Make the gathered SMC statistics network namespace aware, for each
namespace collect an own set of statistic information.

Signed-off-by: Guvenc Gulce <guvenc@linux.ibm.com>
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 include/net/net_namespace.h |   4 ++
 include/net/netns/smc.h     |  16 ++++++
 net/smc/af_smc.c            |  65 +++++++++++++--------
 net/smc/smc_core.c          |  10 ++--
 net/smc/smc_rx.c            |   6 +-
 net/smc/smc_stats.c         |  47 ++++++++-------
 net/smc/smc_stats.h         | 111 ++++++++++++++++++++----------------
 net/smc/smc_tx.c            |  12 ++--
 8 files changed, 163 insertions(+), 108 deletions(-)
 create mode 100644 include/net/netns/smc.h

diff --git a/include/net/net_namespace.h b/include/net/net_namespace.h
index fa5887143f0d..befc5b93f311 100644
--- a/include/net/net_namespace.h
+++ b/include/net/net_namespace.h
@@ -32,6 +32,7 @@
 #include <net/netns/mpls.h>
 #include <net/netns/can.h>
 #include <net/netns/xdp.h>
+#include <net/netns/smc.h>
 #include <net/netns/bpf.h>
 #include <linux/ns_common.h>
 #include <linux/idr.h>
@@ -170,6 +171,9 @@ struct net {
 	struct sock		*crypto_nlsk;
 #endif
 	struct sock		*diag_nlsk;
+#if IS_ENABLED(CONFIG_SMC)
+	struct netns_smc	smc;
+#endif
 } __randomize_layout;
 
 #include <linux/seq_file_net.h>
diff --git a/include/net/netns/smc.h b/include/net/netns/smc.h
new file mode 100644
index 000000000000..ea8a9cf2619b
--- /dev/null
+++ b/include/net/netns/smc.h
@@ -0,0 +1,16 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __NETNS_SMC_H__
+#define __NETNS_SMC_H__
+#include <linux/mutex.h>
+#include <linux/percpu.h>
+
+struct smc_stats_rsn;
+struct smc_stats;
+struct netns_smc {
+	/* per cpu counters for SMC */
+	struct smc_stats __percpu	*smc_stats;
+	/* protect fback_rsn */
+	struct mutex			mutex_fback_rsn;
+	struct smc_stats_rsn		*fback_rsn;
+};
+#endif
diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index efeaed384769..e41fdac606d4 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -529,15 +529,17 @@ static void smc_stat_inc_fback_rsn_cnt(struct smc_sock *smc,
 
 static void smc_stat_fallback(struct smc_sock *smc)
 {
-	mutex_lock(&smc_stat_fback_rsn);
+	struct net *net = sock_net(&smc->sk);
+
+	mutex_lock(&net->smc.mutex_fback_rsn);
 	if (smc->listen_smc) {
-		smc_stat_inc_fback_rsn_cnt(smc, fback_rsn.srv);
-		fback_rsn.srv_fback_cnt++;
+		smc_stat_inc_fback_rsn_cnt(smc, net->smc.fback_rsn->srv);
+		net->smc.fback_rsn->srv_fback_cnt++;
 	} else {
-		smc_stat_inc_fback_rsn_cnt(smc, fback_rsn.clnt);
-		fback_rsn.clnt_fback_cnt++;
+		smc_stat_inc_fback_rsn_cnt(smc, net->smc.fback_rsn->clnt);
+		net->smc.fback_rsn->clnt_fback_cnt++;
 	}
-	mutex_unlock(&smc_stat_fback_rsn);
+	mutex_unlock(&net->smc.mutex_fback_rsn);
 }
 
 static void smc_switch_to_fallback(struct smc_sock *smc, int reason_code)
@@ -568,10 +570,11 @@ static int smc_connect_fallback(struct smc_sock *smc, int reason_code)
 static int smc_connect_decline_fallback(struct smc_sock *smc, int reason_code,
 					u8 version)
 {
+	struct net *net = sock_net(&smc->sk);
 	int rc;
 
 	if (reason_code < 0) { /* error, fallback is not possible */
-		this_cpu_inc(smc_stats->clnt_hshake_err_cnt);
+		this_cpu_inc(net->smc.smc_stats->clnt_hshake_err_cnt);
 		if (smc->sk.sk_state == SMC_INIT)
 			sock_put(&smc->sk); /* passive closing */
 		return reason_code;
@@ -579,7 +582,7 @@ static int smc_connect_decline_fallback(struct smc_sock *smc, int reason_code,
 	if (reason_code != SMC_CLC_DECL_PEERDECL) {
 		rc = smc_clc_send_decline(smc, reason_code, version);
 		if (rc < 0) {
-			this_cpu_inc(smc_stats->clnt_hshake_err_cnt);
+			this_cpu_inc(net->smc.smc_stats->clnt_hshake_err_cnt);
 			if (smc->sk.sk_state == SMC_INIT)
 				sock_put(&smc->sk); /* passive closing */
 			return rc;
@@ -1027,7 +1030,7 @@ static int __smc_connect(struct smc_sock *smc)
 	if (rc)
 		goto vlan_cleanup;
 
-	SMC_STAT_CLNT_SUCC_INC(aclc);
+	SMC_STAT_CLNT_SUCC_INC(sock_net(smc->clcsock->sk), aclc);
 	smc_connect_ism_vlan_cleanup(smc, ini);
 	kfree(buf);
 	kfree(ini);
@@ -1343,8 +1346,9 @@ static void smc_listen_out_connected(struct smc_sock *new_smc)
 static void smc_listen_out_err(struct smc_sock *new_smc)
 {
 	struct sock *newsmcsk = &new_smc->sk;
+	struct net *net = sock_net(newsmcsk);
 
-	this_cpu_inc(smc_stats->srv_hshake_err_cnt);
+	this_cpu_inc(net->smc.smc_stats->srv_hshake_err_cnt);
 	if (newsmcsk->sk_state == SMC_INIT)
 		sock_put(&new_smc->sk); /* passive closing */
 	newsmcsk->sk_state = SMC_CLOSED;
@@ -1813,7 +1817,7 @@ static void smc_listen_work(struct work_struct *work)
 	}
 	smc_conn_save_peer_info(new_smc, cclc);
 	smc_listen_out_connected(new_smc);
-	SMC_STAT_SERV_SUCC_INC(ini);
+	SMC_STAT_SERV_SUCC_INC(sock_net(newclcsock->sk), ini);
 	goto out_free;
 
 out_unlock:
@@ -2242,7 +2246,7 @@ static int smc_setsockopt(struct socket *sock, int level, int optname,
 		    sk->sk_state != SMC_LISTEN &&
 		    sk->sk_state != SMC_CLOSED) {
 			if (val) {
-				SMC_STAT_INC(!smc->conn.lnk, ndly_cnt);
+				SMC_STAT_INC(smc, ndly_cnt);
 				mod_delayed_work(smc->conn.lgr->tx_wq,
 						 &smc->conn.tx_work, 0);
 			}
@@ -2253,7 +2257,7 @@ static int smc_setsockopt(struct socket *sock, int level, int optname,
 		    sk->sk_state != SMC_LISTEN &&
 		    sk->sk_state != SMC_CLOSED) {
 			if (!val) {
-				SMC_STAT_INC(!smc->conn.lnk, cork_cnt);
+				SMC_STAT_INC(smc, cork_cnt);
 				mod_delayed_work(smc->conn.lgr->tx_wq,
 						 &smc->conn.tx_work, 0);
 			}
@@ -2383,7 +2387,7 @@ static ssize_t smc_sendpage(struct socket *sock, struct page *page,
 		rc = kernel_sendpage(smc->clcsock, page, offset,
 				     size, flags);
 	} else {
-		SMC_STAT_INC(!smc->conn.lnk, sendpage_cnt);
+		SMC_STAT_INC(smc, sendpage_cnt);
 		rc = sock_no_sendpage(sock, page, offset, size, flags);
 	}
 
@@ -2434,7 +2438,7 @@ static ssize_t smc_splice_read(struct socket *sock, loff_t *ppos,
 			flags = MSG_DONTWAIT;
 		else
 			flags = 0;
-		SMC_STAT_INC(!smc->conn.lnk, splice_cnt);
+		SMC_STAT_INC(smc, splice_cnt);
 		rc = smc_rx_recvmsg(smc, NULL, pipe, len, flags);
 	}
 out:
@@ -2523,6 +2527,16 @@ static void __net_exit smc_net_exit(struct net *net)
 	smc_pnet_net_exit(net);
 }
 
+static __net_init int smc_net_stat_init(struct net *net)
+{
+	return smc_stats_init(net);
+}
+
+static void __net_exit smc_net_stat_exit(struct net *net)
+{
+	smc_stats_exit(net);
+}
+
 static struct pernet_operations smc_net_ops = {
 	.init = smc_net_init,
 	.exit = smc_net_exit,
@@ -2530,6 +2544,11 @@ static struct pernet_operations smc_net_ops = {
 	.size = sizeof(struct smc_net),
 };
 
+static struct pernet_operations smc_net_stat_ops = {
+	.init = smc_net_stat_init,
+	.exit = smc_net_stat_exit,
+};
+
 static int __init smc_init(void)
 {
 	int rc;
@@ -2538,6 +2557,10 @@ static int __init smc_init(void)
 	if (rc)
 		return rc;
 
+	rc = register_pernet_subsys(&smc_net_stat_ops);
+	if (rc)
+		return rc;
+
 	smc_ism_init();
 	smc_clc_init();
 
@@ -2558,16 +2581,10 @@ static int __init smc_init(void)
 	if (!smc_close_wq)
 		goto out_alloc_hs_wq;
 
-	rc = smc_stats_init();
-	if (rc) {
-		pr_err("%s: smc_stats_init fails with %d\n", __func__, rc);
-		goto out_alloc_wqs;
-	}
-
 	rc = smc_core_init();
 	if (rc) {
 		pr_err("%s: smc_core_init fails with %d\n", __func__, rc);
-		goto out_smc_stat;
+		goto out_alloc_wqs;
 	}
 
 	rc = smc_llc_init();
@@ -2619,8 +2636,6 @@ static int __init smc_init(void)
 	proto_unregister(&smc_proto);
 out_core:
 	smc_core_exit();
-out_smc_stat:
-	smc_stats_exit();
 out_alloc_wqs:
 	destroy_workqueue(smc_close_wq);
 out_alloc_hs_wq:
@@ -2643,11 +2658,11 @@ static void __exit smc_exit(void)
 	smc_ib_unregister_client();
 	destroy_workqueue(smc_close_wq);
 	destroy_workqueue(smc_hs_wq);
-	smc_stats_exit();
 	proto_unregister(&smc_proto6);
 	proto_unregister(&smc_proto);
 	smc_pnet_exit();
 	smc_nl_exit();
+	unregister_pernet_subsys(&smc_net_stat_ops);
 	unregister_pernet_subsys(&smc_net_ops);
 	rcu_barrier();
 }
diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index d69f58f670a1..cd0d7c908b2a 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -2058,8 +2058,8 @@ static int __smc_buf_create(struct smc_sock *smc, bool is_smcd, bool is_rmb)
 		/* check for reusable slot in the link group */
 		buf_desc = smc_buf_get_slot(bufsize_short, lock, buf_list);
 		if (buf_desc) {
-			SMC_STAT_RMB_SIZE(is_smcd, is_rmb, bufsize);
-			SMC_STAT_BUF_REUSE(is_smcd, is_rmb);
+			SMC_STAT_RMB_SIZE(smc, is_smcd, is_rmb, bufsize);
+			SMC_STAT_BUF_REUSE(smc, is_smcd, is_rmb);
 			memset(buf_desc->cpu_addr, 0, bufsize);
 			break; /* found reusable slot */
 		}
@@ -2074,13 +2074,13 @@ static int __smc_buf_create(struct smc_sock *smc, bool is_smcd, bool is_rmb)
 		if (IS_ERR(buf_desc)) {
 			if (!is_dgraded) {
 				is_dgraded = true;
-				SMC_STAT_RMB_DOWNGRADED(is_smcd, is_rmb);
+				SMC_STAT_RMB_DOWNGRADED(smc, is_smcd, is_rmb);
 			}
 			continue;
 		}
 
-		SMC_STAT_RMB_ALLOC(is_smcd, is_rmb);
-		SMC_STAT_RMB_SIZE(is_smcd, is_rmb, bufsize);
+		SMC_STAT_RMB_ALLOC(smc, is_smcd, is_rmb);
+		SMC_STAT_RMB_SIZE(smc, is_smcd, is_rmb, bufsize);
 		buf_desc->used = 1;
 		mutex_lock(lock);
 		list_add(&buf_desc->list, buf_list);
diff --git a/net/smc/smc_rx.c b/net/smc/smc_rx.c
index ce1ae39923b1..170b733bc736 100644
--- a/net/smc/smc_rx.c
+++ b/net/smc/smc_rx.c
@@ -228,7 +228,7 @@ static int smc_rx_recv_urg(struct smc_sock *smc, struct msghdr *msg, int len,
 	    conn->urg_state == SMC_URG_READ)
 		return -EINVAL;
 
-	SMC_STAT_INC(!conn->lnk, urg_data_cnt);
+	SMC_STAT_INC(smc, urg_data_cnt);
 	if (conn->urg_state == SMC_URG_VALID) {
 		if (!(flags & MSG_PEEK))
 			smc->conn.urg_state = SMC_URG_READ;
@@ -307,10 +307,10 @@ int smc_rx_recvmsg(struct smc_sock *smc, struct msghdr *msg,
 
 	readable = atomic_read(&conn->bytes_to_rcv);
 	if (readable >= conn->rmb_desc->len)
-		SMC_STAT_RMB_RX_FULL(!conn->lnk);
+		SMC_STAT_RMB_RX_FULL(smc, !conn->lnk);
 
 	if (len < readable)
-		SMC_STAT_RMB_RX_SIZE_SMALL(!conn->lnk);
+		SMC_STAT_RMB_RX_SIZE_SMALL(smc, !conn->lnk);
 	/* we currently use 1 RMBE per RMB, so RMBE == RMB base addr */
 	rcvbuf_base = conn->rx_off + conn->rmb_desc->cpu_addr;
 
diff --git a/net/smc/smc_stats.c b/net/smc/smc_stats.c
index b3d279d29c52..614013e3b574 100644
--- a/net/smc/smc_stats.c
+++ b/net/smc/smc_stats.c
@@ -18,24 +18,28 @@
 #include "smc_netlink.h"
 #include "smc_stats.h"
 
-/* serialize fallback reason statistic gathering */
-DEFINE_MUTEX(smc_stat_fback_rsn);
-struct smc_stats __percpu *smc_stats;	/* per cpu counters for SMC */
-struct smc_stats_reason fback_rsn;
-
-int __init smc_stats_init(void)
+int smc_stats_init(struct net *net)
 {
-	memset(&fback_rsn, 0, sizeof(fback_rsn));
-	smc_stats = alloc_percpu(struct smc_stats);
-	if (!smc_stats)
-		return -ENOMEM;
-
+	net->smc.fback_rsn = kzalloc(sizeof(*net->smc.fback_rsn), GFP_KERNEL);
+	if (!net->smc.fback_rsn)
+		goto err_fback;
+	net->smc.smc_stats = alloc_percpu(struct smc_stats);
+	if (!net->smc.smc_stats)
+		goto err_stats;
+	mutex_init(&net->smc.mutex_fback_rsn);
 	return 0;
+
+err_stats:
+	kfree(net->smc.fback_rsn);
+err_fback:
+	return -ENOMEM;
 }
 
-void smc_stats_exit(void)
+void smc_stats_exit(struct net *net)
 {
-	free_percpu(smc_stats);
+	kfree(net->smc.fback_rsn);
+	if (net->smc.smc_stats)
+		free_percpu(net->smc.smc_stats);
 }
 
 static int smc_nl_fill_stats_rmb_data(struct sk_buff *skb,
@@ -256,6 +260,7 @@ int smc_nl_get_stats(struct sk_buff *skb,
 		     struct netlink_callback *cb)
 {
 	struct smc_nl_dmp_ctx *cb_ctx = smc_nl_dmp_ctx(cb);
+	struct net *net = sock_net(skb->sk);
 	struct smc_stats *stats;
 	struct nlattr *attrs;
 	int cpu, i, size;
@@ -279,7 +284,7 @@ int smc_nl_get_stats(struct sk_buff *skb,
 		goto erralloc;
 	size = sizeof(*stats) / sizeof(u64);
 	for_each_possible_cpu(cpu) {
-		src = (u64 *)per_cpu_ptr(smc_stats, cpu);
+		src = (u64 *)per_cpu_ptr(net->smc.smc_stats, cpu);
 		sum = (u64 *)stats;
 		for (i = 0; i < size; i++)
 			*(sum++) += *(src++);
@@ -318,6 +323,7 @@ static int smc_nl_get_fback_details(struct sk_buff *skb,
 				    bool is_srv)
 {
 	struct smc_nl_dmp_ctx *cb_ctx = smc_nl_dmp_ctx(cb);
+	struct net *net = sock_net(skb->sk);
 	int cnt_reported = cb_ctx->pos[2];
 	struct smc_stats_fback *trgt_arr;
 	struct nlattr *attrs;
@@ -325,9 +331,9 @@ static int smc_nl_get_fback_details(struct sk_buff *skb,
 	void *nlh;
 
 	if (is_srv)
-		trgt_arr = &fback_rsn.srv[0];
+		trgt_arr = &net->smc.fback_rsn->srv[0];
 	else
-		trgt_arr = &fback_rsn.clnt[0];
+		trgt_arr = &net->smc.fback_rsn->clnt[0];
 	if (!trgt_arr[pos].fback_code)
 		return -ENODATA;
 	nlh = genlmsg_put(skb, NETLINK_CB(cb->skb).portid, cb->nlh->nlmsg_seq,
@@ -342,11 +348,11 @@ static int smc_nl_get_fback_details(struct sk_buff *skb,
 		goto errattr;
 	if (!cnt_reported) {
 		if (nla_put_u64_64bit(skb, SMC_NLA_FBACK_STATS_SRV_CNT,
-				      fback_rsn.srv_fback_cnt,
+				      net->smc.fback_rsn->srv_fback_cnt,
 				      SMC_NLA_FBACK_STATS_PAD))
 			goto errattr;
 		if (nla_put_u64_64bit(skb, SMC_NLA_FBACK_STATS_CLNT_CNT,
-				      fback_rsn.clnt_fback_cnt,
+				      net->smc.fback_rsn->clnt_fback_cnt,
 				      SMC_NLA_FBACK_STATS_PAD))
 			goto errattr;
 		cnt_reported = 1;
@@ -375,12 +381,13 @@ static int smc_nl_get_fback_details(struct sk_buff *skb,
 int smc_nl_get_fback_stats(struct sk_buff *skb, struct netlink_callback *cb)
 {
 	struct smc_nl_dmp_ctx *cb_ctx = smc_nl_dmp_ctx(cb);
+	struct net *net = sock_net(skb->sk);
 	int rc_srv = 0, rc_clnt = 0, k;
 	int skip_serv = cb_ctx->pos[1];
 	int snum = cb_ctx->pos[0];
 	bool is_srv = true;
 
-	mutex_lock(&smc_stat_fback_rsn);
+	mutex_lock(&net->smc.mutex_fback_rsn);
 	for (k = 0; k < SMC_MAX_FBACK_RSN_CNT; k++) {
 		if (k < snum)
 			continue;
@@ -399,7 +406,7 @@ int smc_nl_get_fback_stats(struct sk_buff *skb, struct netlink_callback *cb)
 		if (rc_clnt == ENODATA && rc_srv == ENODATA)
 			break;
 	}
-	mutex_unlock(&smc_stat_fback_rsn);
+	mutex_unlock(&net->smc.mutex_fback_rsn);
 	cb_ctx->pos[1] = skip_serv;
 	cb_ctx->pos[0] = k;
 	return skb->len;
diff --git a/net/smc/smc_stats.h b/net/smc/smc_stats.h
index 7c35b22d9e29..84b7ecd8c05c 100644
--- a/net/smc/smc_stats.h
+++ b/net/smc/smc_stats.h
@@ -21,10 +21,6 @@
 
 #define SMC_MAX_FBACK_RSN_CNT 30
 
-extern struct smc_stats __percpu *smc_stats;	/* per cpu counters for SMC */
-extern struct smc_stats_reason fback_rsn;
-extern struct mutex smc_stat_fback_rsn;
-
 enum {
 	SMC_BUF_8K,
 	SMC_BUF_16K,
@@ -43,7 +39,7 @@ struct smc_stats_fback {
 	u16	count;
 };
 
-struct smc_stats_reason {
+struct smc_stats_rsn {
 	struct	smc_stats_fback srv[SMC_MAX_FBACK_RSN_CNT];
 	struct	smc_stats_fback clnt[SMC_MAX_FBACK_RSN_CNT];
 	u64			srv_fback_cnt;
@@ -92,122 +88,135 @@ struct smc_stats {
 	u64			srv_hshake_err_cnt;
 };
 
-#define SMC_STAT_PAYLOAD_SUB(_tech, key, _len, _rc) \
+#define SMC_STAT_PAYLOAD_SUB(_smc_stats, _tech, key, _len, _rc) \
 do { \
+	typeof(_smc_stats) stats = (_smc_stats); \
 	typeof(_tech) t = (_tech); \
 	typeof(_len) l = (_len); \
 	int _pos = fls64((l) >> 13); \
 	typeof(_rc) r = (_rc); \
 	int m = SMC_BUF_MAX - 1; \
-	this_cpu_inc((*smc_stats).smc[t].key ## _cnt); \
+	this_cpu_inc((*stats).smc[t].key ## _cnt); \
 	if (r <= 0) \
 		break; \
 	_pos = (_pos < m) ? ((l == 1 << (_pos + 12)) ? _pos - 1 : _pos) : m; \
-	this_cpu_inc((*smc_stats).smc[t].key ## _pd.buf[_pos]); \
-	this_cpu_add((*smc_stats).smc[t].key ## _bytes, r); \
+	this_cpu_inc((*stats).smc[t].key ## _pd.buf[_pos]); \
+	this_cpu_add((*stats).smc[t].key ## _bytes, r); \
 } \
 while (0)
 
 #define SMC_STAT_TX_PAYLOAD(_smc, length, rcode) \
 do { \
 	typeof(_smc) __smc = _smc; \
+	struct net *_net = sock_net(&__smc->sk); \
+	struct smc_stats __percpu *_smc_stats = _net->smc.smc_stats; \
 	typeof(length) _len = (length); \
 	typeof(rcode) _rc = (rcode); \
 	bool is_smcd = !__smc->conn.lnk; \
 	if (is_smcd) \
-		SMC_STAT_PAYLOAD_SUB(SMC_TYPE_D, tx, _len, _rc); \
+		SMC_STAT_PAYLOAD_SUB(_smc_stats, SMC_TYPE_D, tx, _len, _rc); \
 	else \
-		SMC_STAT_PAYLOAD_SUB(SMC_TYPE_R, tx, _len, _rc); \
+		SMC_STAT_PAYLOAD_SUB(_smc_stats, SMC_TYPE_R, tx, _len, _rc); \
 } \
 while (0)
 
 #define SMC_STAT_RX_PAYLOAD(_smc, length, rcode) \
 do { \
 	typeof(_smc) __smc = _smc; \
+	struct net *_net = sock_net(&__smc->sk); \
+	struct smc_stats __percpu *_smc_stats = _net->smc.smc_stats; \
 	typeof(length) _len = (length); \
 	typeof(rcode) _rc = (rcode); \
 	bool is_smcd = !__smc->conn.lnk; \
 	if (is_smcd) \
-		SMC_STAT_PAYLOAD_SUB(SMC_TYPE_D, rx, _len, _rc); \
+		SMC_STAT_PAYLOAD_SUB(_smc_stats, SMC_TYPE_D, rx, _len, _rc); \
 	else \
-		SMC_STAT_PAYLOAD_SUB(SMC_TYPE_R, rx, _len, _rc); \
+		SMC_STAT_PAYLOAD_SUB(_smc_stats, SMC_TYPE_R, rx, _len, _rc); \
 } \
 while (0)
 
-#define SMC_STAT_RMB_SIZE_SUB(_tech, k, _len) \
+#define SMC_STAT_RMB_SIZE_SUB(_smc_stats, _tech, k, _len) \
 do { \
 	typeof(_len) _l = (_len); \
 	typeof(_tech) t = (_tech); \
 	int _pos = fls((_l) >> 13); \
 	int m = SMC_BUF_MAX - 1; \
 	_pos = (_pos < m) ? ((_l == 1 << (_pos + 12)) ? _pos - 1 : _pos) : m; \
-	this_cpu_inc((*smc_stats).smc[t].k ## _rmbsize.buf[_pos]); \
+	this_cpu_inc((*(_smc_stats)).smc[t].k ## _rmbsize.buf[_pos]); \
 } \
 while (0)
 
-#define SMC_STAT_RMB_SUB(type, t, key) \
-	this_cpu_inc((*smc_stats).smc[t].rmb ## _ ## key.type ## _cnt)
+#define SMC_STAT_RMB_SUB(_smc_stats, type, t, key) \
+	this_cpu_inc((*(_smc_stats)).smc[t].rmb ## _ ## key.type ## _cnt)
 
-#define SMC_STAT_RMB_SIZE(_is_smcd, _is_rx, _len) \
+#define SMC_STAT_RMB_SIZE(_smc, _is_smcd, _is_rx, _len) \
 do { \
+	struct net *_net = sock_net(&(_smc)->sk); \
+	struct smc_stats __percpu *_smc_stats = _net->smc.smc_stats; \
 	typeof(_is_smcd) is_d = (_is_smcd); \
 	typeof(_is_rx) is_r = (_is_rx); \
 	typeof(_len) l = (_len); \
 	if ((is_d) && (is_r)) \
-		SMC_STAT_RMB_SIZE_SUB(SMC_TYPE_D, rx, l); \
+		SMC_STAT_RMB_SIZE_SUB(_smc_stats, SMC_TYPE_D, rx, l); \
 	if ((is_d) && !(is_r)) \
-		SMC_STAT_RMB_SIZE_SUB(SMC_TYPE_D, tx, l); \
+		SMC_STAT_RMB_SIZE_SUB(_smc_stats, SMC_TYPE_D, tx, l); \
 	if (!(is_d) && (is_r)) \
-		SMC_STAT_RMB_SIZE_SUB(SMC_TYPE_R, rx, l); \
+		SMC_STAT_RMB_SIZE_SUB(_smc_stats, SMC_TYPE_R, rx, l); \
 	if (!(is_d) && !(is_r)) \
-		SMC_STAT_RMB_SIZE_SUB(SMC_TYPE_R, tx, l); \
+		SMC_STAT_RMB_SIZE_SUB(_smc_stats, SMC_TYPE_R, tx, l); \
 } \
 while (0)
 
-#define SMC_STAT_RMB(type, _is_smcd, _is_rx) \
+#define SMC_STAT_RMB(_smc, type, _is_smcd, _is_rx) \
 do { \
+	struct net *net = sock_net(&(_smc)->sk); \
+	struct smc_stats __percpu *_smc_stats = net->smc.smc_stats; \
 	typeof(_is_smcd) is_d = (_is_smcd); \
 	typeof(_is_rx) is_r = (_is_rx); \
 	if ((is_d) && (is_r)) \
-		SMC_STAT_RMB_SUB(type, SMC_TYPE_D, rx); \
+		SMC_STAT_RMB_SUB(_smc_stats, type, SMC_TYPE_D, rx); \
 	if ((is_d) && !(is_r)) \
-		SMC_STAT_RMB_SUB(type, SMC_TYPE_D, tx); \
+		SMC_STAT_RMB_SUB(_smc_stats, type, SMC_TYPE_D, tx); \
 	if (!(is_d) && (is_r)) \
-		SMC_STAT_RMB_SUB(type, SMC_TYPE_R, rx); \
+		SMC_STAT_RMB_SUB(_smc_stats, type, SMC_TYPE_R, rx); \
 	if (!(is_d) && !(is_r)) \
-		SMC_STAT_RMB_SUB(type, SMC_TYPE_R, tx); \
+		SMC_STAT_RMB_SUB(_smc_stats, type, SMC_TYPE_R, tx); \
 } \
 while (0)
 
-#define SMC_STAT_BUF_REUSE(is_smcd, is_rx) \
-	SMC_STAT_RMB(reuse, is_smcd, is_rx)
+#define SMC_STAT_BUF_REUSE(smc, is_smcd, is_rx) \
+	SMC_STAT_RMB(smc, reuse, is_smcd, is_rx)
 
-#define SMC_STAT_RMB_ALLOC(is_smcd, is_rx) \
-	SMC_STAT_RMB(alloc, is_smcd, is_rx)
+#define SMC_STAT_RMB_ALLOC(smc, is_smcd, is_rx) \
+	SMC_STAT_RMB(smc, alloc, is_smcd, is_rx)
 
-#define SMC_STAT_RMB_DOWNGRADED(is_smcd, is_rx) \
-	SMC_STAT_RMB(dgrade, is_smcd, is_rx)
+#define SMC_STAT_RMB_DOWNGRADED(smc, is_smcd, is_rx) \
+	SMC_STAT_RMB(smc, dgrade, is_smcd, is_rx)
 
-#define SMC_STAT_RMB_TX_PEER_FULL(is_smcd) \
-	SMC_STAT_RMB(buf_full_peer, is_smcd, false)
+#define SMC_STAT_RMB_TX_PEER_FULL(smc, is_smcd) \
+	SMC_STAT_RMB(smc, buf_full_peer, is_smcd, false)
 
-#define SMC_STAT_RMB_TX_FULL(is_smcd) \
-	SMC_STAT_RMB(buf_full, is_smcd, false)
+#define SMC_STAT_RMB_TX_FULL(smc, is_smcd) \
+	SMC_STAT_RMB(smc, buf_full, is_smcd, false)
 
-#define SMC_STAT_RMB_TX_PEER_SIZE_SMALL(is_smcd) \
-	SMC_STAT_RMB(buf_size_small_peer, is_smcd, false)
+#define SMC_STAT_RMB_TX_PEER_SIZE_SMALL(smc, is_smcd) \
+	SMC_STAT_RMB(smc, buf_size_small_peer, is_smcd, false)
 
-#define SMC_STAT_RMB_TX_SIZE_SMALL(is_smcd) \
-	SMC_STAT_RMB(buf_size_small, is_smcd, false)
+#define SMC_STAT_RMB_TX_SIZE_SMALL(smc, is_smcd) \
+	SMC_STAT_RMB(smc, buf_size_small, is_smcd, false)
 
-#define SMC_STAT_RMB_RX_SIZE_SMALL(is_smcd) \
-	SMC_STAT_RMB(buf_size_small, is_smcd, true)
+#define SMC_STAT_RMB_RX_SIZE_SMALL(smc, is_smcd) \
+	SMC_STAT_RMB(smc, buf_size_small, is_smcd, true)
 
-#define SMC_STAT_RMB_RX_FULL(is_smcd) \
-	SMC_STAT_RMB(buf_full, is_smcd, true)
+#define SMC_STAT_RMB_RX_FULL(smc, is_smcd) \
+	SMC_STAT_RMB(smc, buf_full, is_smcd, true)
 
-#define SMC_STAT_INC(is_smcd, type) \
+#define SMC_STAT_INC(_smc, type) \
 do { \
+	typeof(_smc) __smc = _smc; \
+	bool is_smcd = !(__smc)->conn.lnk; \
+	struct net *net = sock_net(&(__smc)->sk); \
+	struct smc_stats __percpu *smc_stats = net->smc.smc_stats; \
 	if ((is_smcd)) \
 		this_cpu_inc(smc_stats->smc[SMC_TYPE_D].type); \
 	else \
@@ -215,11 +224,12 @@ do { \
 } \
 while (0)
 
-#define SMC_STAT_CLNT_SUCC_INC(_aclc) \
+#define SMC_STAT_CLNT_SUCC_INC(net, _aclc) \
 do { \
 	typeof(_aclc) acl = (_aclc); \
 	bool is_v2 = (acl->hdr.version == SMC_V2); \
 	bool is_smcd = (acl->hdr.typev1 == SMC_TYPE_D); \
+	struct smc_stats __percpu *smc_stats = (net)->smc.smc_stats; \
 	if (is_v2 && is_smcd) \
 		this_cpu_inc(smc_stats->smc[SMC_TYPE_D].clnt_v2_succ_cnt); \
 	else if (is_v2 && !is_smcd) \
@@ -231,11 +241,12 @@ do { \
 } \
 while (0)
 
-#define SMC_STAT_SERV_SUCC_INC(_ini) \
+#define SMC_STAT_SERV_SUCC_INC(net, _ini) \
 do { \
 	typeof(_ini) i = (_ini); \
 	bool is_v2 = (i->smcd_version & SMC_V2); \
 	bool is_smcd = (i->is_smcd); \
+	typeof(net->smc.smc_stats) smc_stats = (net)->smc.smc_stats; \
 	if (is_v2 && is_smcd) \
 		this_cpu_inc(smc_stats->smc[SMC_TYPE_D].srv_v2_succ_cnt); \
 	else if (is_v2 && !is_smcd) \
@@ -249,7 +260,7 @@ while (0)
 
 int smc_nl_get_stats(struct sk_buff *skb, struct netlink_callback *cb);
 int smc_nl_get_fback_stats(struct sk_buff *skb, struct netlink_callback *cb);
-int smc_stats_init(void) __init;
-void smc_stats_exit(void);
+int smc_stats_init(struct net *net);
+void smc_stats_exit(struct net *net);
 
 #endif /* NET_SMC_SMC_STATS_H_ */
diff --git a/net/smc/smc_tx.c b/net/smc/smc_tx.c
index a043544d715f..075c4f4b41cf 100644
--- a/net/smc/smc_tx.c
+++ b/net/smc/smc_tx.c
@@ -47,7 +47,7 @@ static void smc_tx_write_space(struct sock *sk)
 	/* similar to sk_stream_write_space */
 	if (atomic_read(&smc->conn.sndbuf_space) && sock) {
 		if (test_bit(SOCK_NOSPACE, &sock->flags))
-			SMC_STAT_RMB_TX_FULL(!smc->conn.lnk);
+			SMC_STAT_RMB_TX_FULL(smc, !smc->conn.lnk);
 		clear_bit(SOCK_NOSPACE, &sock->flags);
 		rcu_read_lock();
 		wq = rcu_dereference(sk->sk_wq);
@@ -155,13 +155,13 @@ int smc_tx_sendmsg(struct smc_sock *smc, struct msghdr *msg, size_t len)
 	}
 
 	if (len > conn->sndbuf_desc->len)
-		SMC_STAT_RMB_TX_SIZE_SMALL(!conn->lnk);
+		SMC_STAT_RMB_TX_SIZE_SMALL(smc, !conn->lnk);
 
 	if (len > conn->peer_rmbe_size)
-		SMC_STAT_RMB_TX_PEER_SIZE_SMALL(!conn->lnk);
+		SMC_STAT_RMB_TX_PEER_SIZE_SMALL(smc, !conn->lnk);
 
 	if (msg->msg_flags & MSG_OOB)
-		SMC_STAT_INC(!conn->lnk, urg_data_cnt);
+		SMC_STAT_INC(smc, urg_data_cnt);
 
 	while (msg_data_left(msg)) {
 		if (sk->sk_state == SMC_INIT)
@@ -432,7 +432,9 @@ static int smc_tx_rdma_writes(struct smc_connection *conn,
 	/* cf. snd_wnd */
 	rmbespace = atomic_read(&conn->peer_rmbe_space);
 	if (rmbespace <= 0) {
-		SMC_STAT_RMB_TX_PEER_FULL(!conn->lnk);
+		struct smc_sock *smc = container_of(conn, struct smc_sock,
+						    conn);
+		SMC_STAT_RMB_TX_PEER_FULL(smc, !conn->lnk);
 		return 0;
 	}
 	smc_curs_copy(&prod, &conn->local_tx_ctrl.prod, conn);
-- 
2.25.1

