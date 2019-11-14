Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70096FC5DD
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 13:03:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726979AbfKNMDC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 07:03:02 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:65516 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726491AbfKNMDB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 07:03:01 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id xAEBwNGY057121
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 07:03:00 -0500
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2w962es87e-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 07:03:00 -0500
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <kgraul@linux.ibm.com>;
        Thu, 14 Nov 2019 12:02:58 -0000
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 14 Nov 2019 12:02:56 -0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xAEC2sgI28442626
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Nov 2019 12:02:54 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 720CF4C044;
        Thu, 14 Nov 2019 12:02:54 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 385E14C040;
        Thu, 14 Nov 2019 12:02:54 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 14 Nov 2019 12:02:54 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net-next 3/8] net/smc: abnormal termination of SMCD link groups
Date:   Thu, 14 Nov 2019 13:02:42 +0100
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191114120247.68889-1-kgraul@linux.ibm.com>
References: <20191114120247.68889-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19111412-0028-0000-0000-000003B6D3DD
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19111412-0029-0000-0000-00002479E10C
Message-Id: <20191114120247.68889-4-kgraul@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-11-14_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1910280000 definitions=main-1911140113
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ursula Braun <ubraun@linux.ibm.com>

A final cleanup due to SMCD device removal means immediate freeing
of all link groups belonging to this device in interrupt context.

This patch introduces a separate SMCD link group termination routine,
which terminates all link groups of an SMCD device.

This new routine smcd_terminate_all ()is reused if the smc module is
unloaded.

Signed-off-by: Ursula Braun <ubraun@linux.ibm.com>
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 net/smc/smc_clc.c  |  2 +-
 net/smc/smc_core.c | 67 +++++++++++++++++++++++++++++++++++-----------
 net/smc/smc_core.h |  3 ++-
 net/smc/smc_ism.c  |  2 +-
 net/smc/smc_llc.c  |  2 +-
 net/smc/smc_tx.c   |  2 +-
 6 files changed, 57 insertions(+), 21 deletions(-)

diff --git a/net/smc/smc_clc.c b/net/smc/smc_clc.c
index 49bcebff6378..0879f7bed967 100644
--- a/net/smc/smc_clc.c
+++ b/net/smc/smc_clc.c
@@ -349,7 +349,7 @@ int smc_clc_wait_msg(struct smc_sock *smc, void *buf, int buflen,
 		smc->peer_diagnosis = ntohl(dclc->peer_diagnosis);
 		if (((struct smc_clc_msg_decline *)buf)->hdr.flag) {
 			smc->conn.lgr->sync_err = 1;
-			smc_lgr_terminate(smc->conn.lgr);
+			smc_lgr_terminate(smc->conn.lgr, true);
 		}
 	}
 
diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index 9d6da2c7413d..d79dd78c1cd8 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -224,7 +224,7 @@ static void smc_lgr_terminate_work(struct work_struct *work)
 	struct smc_link_group *lgr = container_of(work, struct smc_link_group,
 						  terminate_work);
 
-	smc_lgr_terminate(lgr);
+	smc_lgr_terminate(lgr, true);
 }
 
 /* create a new SMC link group */
@@ -528,7 +528,7 @@ static void smc_sk_wake_ups(struct smc_sock *smc)
 }
 
 /* kill a connection */
-static void smc_conn_kill(struct smc_connection *conn)
+static void smc_conn_kill(struct smc_connection *conn, bool soft)
 {
 	struct smc_sock *smc = container_of(conn, struct smc_sock, conn);
 
@@ -541,7 +541,10 @@ static void smc_conn_kill(struct smc_connection *conn)
 	smc_sk_wake_ups(smc);
 	if (conn->lgr->is_smcd) {
 		smc_ism_unset_conn(conn);
-		tasklet_kill(&conn->rx_tsklet);
+		if (soft)
+			tasklet_kill(&conn->rx_tsklet);
+		else
+			tasklet_unlock_wait(&conn->rx_tsklet);
 	}
 	smc_lgr_unregister_conn(conn);
 	smc_close_active_abort(smc);
@@ -562,7 +565,7 @@ static void smc_lgr_cleanup(struct smc_link_group *lgr)
 }
 
 /* terminate link group */
-static void __smc_lgr_terminate(struct smc_link_group *lgr)
+static void __smc_lgr_terminate(struct smc_link_group *lgr, bool soft)
 {
 	struct smc_connection *conn;
 	struct smc_sock *smc;
@@ -570,6 +573,8 @@ static void __smc_lgr_terminate(struct smc_link_group *lgr)
 
 	if (lgr->terminating)
 		return;	/* lgr already terminating */
+	if (!soft)
+		cancel_delayed_work_sync(&lgr->free_work);
 	lgr->terminating = 1;
 	if (!lgr->is_smcd)
 		smc_llc_link_inactive(&lgr->lnk[SMC_SINGLE_LINK]);
@@ -583,7 +588,7 @@ static void __smc_lgr_terminate(struct smc_link_group *lgr)
 		smc = container_of(conn, struct smc_sock, conn);
 		sock_hold(&smc->sk); /* sock_put below */
 		lock_sock(&smc->sk);
-		smc_conn_kill(conn);
+		smc_conn_kill(conn, soft);
 		release_sock(&smc->sk);
 		sock_put(&smc->sk); /* sock_hold above */
 		read_lock_bh(&lgr->conns_lock);
@@ -591,11 +596,17 @@ static void __smc_lgr_terminate(struct smc_link_group *lgr)
 	}
 	read_unlock_bh(&lgr->conns_lock);
 	smc_lgr_cleanup(lgr);
-	smc_lgr_schedule_free_work_fast(lgr);
+	if (soft)
+		smc_lgr_schedule_free_work_fast(lgr);
+	else
+		smc_lgr_free(lgr);
 }
 
-/* unlink and terminate link group */
-void smc_lgr_terminate(struct smc_link_group *lgr)
+/* unlink and terminate link group
+ * @soft: true if link group shutdown can take its time
+ *	  false if immediate link group shutdown is required
+ */
+void smc_lgr_terminate(struct smc_link_group *lgr, bool soft)
 {
 	spinlock_t *lgr_lock;
 
@@ -605,9 +616,11 @@ void smc_lgr_terminate(struct smc_link_group *lgr)
 		spin_unlock_bh(lgr_lock);
 		return;	/* lgr already terminating */
 	}
+	if (!soft)
+		lgr->freeing = 1;
 	list_del_init(&lgr->list);
 	spin_unlock_bh(lgr_lock);
-	__smc_lgr_terminate(lgr);
+	__smc_lgr_terminate(lgr, soft);
 }
 
 /* Called when IB port is terminated */
@@ -627,11 +640,11 @@ void smc_port_terminate(struct smc_ib_device *smcibdev, u8 ibport)
 
 	list_for_each_entry_safe(lgr, l, &lgr_free_list, list) {
 		list_del_init(&lgr->list);
-		__smc_lgr_terminate(lgr);
+		__smc_lgr_terminate(lgr, true);
 	}
 }
 
-/* Called when SMC-D device is terminated or peer is lost */
+/* Called when peer lgr shutdown (regularly or abnormally) is received */
 void smc_smcd_terminate(struct smcd_dev *dev, u64 peer_gid, unsigned short vlan)
 {
 	struct smc_link_group *lgr, *l;
@@ -656,6 +669,24 @@ void smc_smcd_terminate(struct smcd_dev *dev, u64 peer_gid, unsigned short vlan)
 	}
 }
 
+/* Called when an SMCD device is removed or the smc module is unloaded */
+void smc_smcd_terminate_all(struct smcd_dev *smcd)
+{
+	struct smc_link_group *lgr, *lg;
+	LIST_HEAD(lgr_free_list);
+
+	spin_lock_bh(&smcd->lgr_lock);
+	list_splice_init(&smcd->lgr_list, &lgr_free_list);
+	list_for_each_entry(lgr, &lgr_free_list, list)
+		lgr->freeing = 1;
+	spin_unlock_bh(&smcd->lgr_lock);
+
+	list_for_each_entry_safe(lgr, lg, &lgr_free_list, list) {
+		list_del_init(&lgr->list);
+		__smc_lgr_terminate(lgr, false);
+	}
+}
+
 /* Determine vlan of internal TCP socket.
  * @vlan_id: address to store the determined vlan id into
  */
@@ -1173,8 +1204,8 @@ static void smc_core_going_away(void)
 	spin_unlock(&smcd_dev_list.lock);
 }
 
-/* Called (from smc_exit) when module is removed */
-void smc_core_exit(void)
+/* Clean up all SMC link groups */
+static void smc_lgrs_shutdown(void)
 {
 	struct smc_link_group *lgr, *lg;
 	LIST_HEAD(lgr_freeing_list);
@@ -1188,7 +1219,7 @@ void smc_core_exit(void)
 
 	spin_lock(&smcd_dev_list.lock);
 	list_for_each_entry(smcd, &smcd_dev_list.list, list)
-		list_splice_init(&smcd->lgr_list, &lgr_freeing_list);
+		smc_smcd_terminate_all(smcd);
 	spin_unlock(&smcd_dev_list.lock);
 
 	list_for_each_entry_safe(lgr, lg, &lgr_freeing_list, list) {
@@ -1202,8 +1233,12 @@ void smc_core_exit(void)
 			smc_llc_link_inactive(lnk);
 		}
 		cancel_delayed_work_sync(&lgr->free_work);
-		if (lgr->is_smcd)
-			smc_ism_signal_shutdown(lgr);
 		smc_lgr_free(lgr); /* free link group */
 	}
 }
+
+/* Called (from smc_exit) when module is removed */
+void smc_core_exit(void)
+{
+	smc_lgrs_shutdown();
+}
diff --git a/net/smc/smc_core.h b/net/smc/smc_core.h
index 097ceba86caf..7f34f4d5a514 100644
--- a/net/smc/smc_core.h
+++ b/net/smc/smc_core.h
@@ -296,10 +296,11 @@ struct smc_clc_msg_accept_confirm;
 struct smc_clc_msg_local;
 
 void smc_lgr_forget(struct smc_link_group *lgr);
-void smc_lgr_terminate(struct smc_link_group *lgr);
+void smc_lgr_terminate(struct smc_link_group *lgr, bool soft);
 void smc_port_terminate(struct smc_ib_device *smcibdev, u8 ibport);
 void smc_smcd_terminate(struct smcd_dev *dev, u64 peer_gid,
 			unsigned short vlan);
+void smc_smcd_terminate_all(struct smcd_dev *dev);
 int smc_buf_create(struct smc_sock *smc, bool is_smcd);
 int smc_uncompress_bufsize(u8 compressed);
 int smc_rmb_rtoken_handling(struct smc_connection *conn,
diff --git a/net/smc/smc_ism.c b/net/smc/smc_ism.c
index 903da947b20d..56cdab8be1fa 100644
--- a/net/smc/smc_ism.c
+++ b/net/smc/smc_ism.c
@@ -329,7 +329,7 @@ void smcd_unregister_dev(struct smcd_dev *smcd)
 	list_del_init(&smcd->list);
 	spin_unlock(&smcd_dev_list.lock);
 	smcd->going_away = 1;
-	smc_smcd_terminate(smcd, 0, VLAN_VID_MASK);
+	smc_smcd_terminate_all(smcd);
 	flush_workqueue(smcd->event_wq);
 	destroy_workqueue(smcd->event_wq);
 
diff --git a/net/smc/smc_llc.c b/net/smc/smc_llc.c
index e1918ffaf125..26a18c872455 100644
--- a/net/smc/smc_llc.c
+++ b/net/smc/smc_llc.c
@@ -614,7 +614,7 @@ static void smc_llc_testlink_work(struct work_struct *work)
 	rc = wait_for_completion_interruptible_timeout(&link->llc_testlink_resp,
 						       SMC_LLC_WAIT_TIME);
 	if (rc <= 0) {
-		smc_lgr_terminate(smc_get_lgr(link));
+		smc_lgr_terminate(smc_get_lgr(link), true);
 		return;
 	}
 	next_interval = link->llc_testlink_time;
diff --git a/net/smc/smc_tx.c b/net/smc/smc_tx.c
index 824f096ee7de..0d42e7716b91 100644
--- a/net/smc/smc_tx.c
+++ b/net/smc/smc_tx.c
@@ -284,7 +284,7 @@ static int smc_tx_rdma_write(struct smc_connection *conn, int peer_rmbe_offset,
 	rdma_wr->rkey = lgr->rtokens[conn->rtoken_idx][SMC_SINGLE_LINK].rkey;
 	rc = ib_post_send(link->roce_qp, &rdma_wr->wr, NULL);
 	if (rc)
-		smc_lgr_terminate(lgr);
+		smc_lgr_terminate(lgr, true);
 	return rc;
 }
 
-- 
2.17.1

