Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C819FC5E1
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 13:03:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726952AbfKNMDB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 07:03:01 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:41154 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726409AbfKNMDB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 07:03:01 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id xAEBv8Ub000712
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 07:03:00 -0500
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2w96barq1e-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 07:02:59 -0500
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <kgraul@linux.ibm.com>;
        Thu, 14 Nov 2019 12:02:57 -0000
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 14 Nov 2019 12:02:55 -0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xAEC2sN456492042
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Nov 2019 12:02:54 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 20F414C05C;
        Thu, 14 Nov 2019 12:02:54 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D49B44C052;
        Thu, 14 Nov 2019 12:02:53 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 14 Nov 2019 12:02:53 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net-next 2/8] net/smc: immediate termination for SMCD link groups
Date:   Thu, 14 Nov 2019 13:02:41 +0100
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191114120247.68889-1-kgraul@linux.ibm.com>
References: <20191114120247.68889-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19111412-0020-0000-0000-00000386206E
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19111412-0021-0000-0000-000021DC36E7
Message-Id: <20191114120247.68889-3-kgraul@linux.ibm.com>
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

SMCD link group termination is called when peer signals its shutdown
of its corresponding link group. For regular shutdowns no connections
exist anymore. For abnormal shutdowns connections must be killed and
their DMBs must be unregistered immediately. That means the SMCR method
to delay the link group freeing several seconds does not fit.

This patch adds immediate termination of a link group and its SMCD
connections and makes sure all SMCD link group related cleanup steps
are finished.

Signed-off-by: Ursula Braun <ubraun@linux.ibm.com>
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 drivers/s390/net/ism.h |  2 --
 include/net/smc.h      |  2 ++
 net/smc/smc_close.c    | 25 +++++++++++++++++------
 net/smc/smc_core.c     | 46 +++++++++++++++++++++++++++++++++++-------
 net/smc/smc_ism.c      | 14 +++++++++++--
 5 files changed, 72 insertions(+), 17 deletions(-)

diff --git a/drivers/s390/net/ism.h b/drivers/s390/net/ism.h
index 66eac2b9704d..1901e9c80ed8 100644
--- a/drivers/s390/net/ism.h
+++ b/drivers/s390/net/ism.h
@@ -32,8 +32,6 @@
 #define ISM_UNREG_SBA	0x11
 #define ISM_UNREG_IEQ	0x12
 
-#define ISM_ERROR	0xFFFF
-
 struct ism_req_hdr {
 	u32 cmd;
 	u16 : 16;
diff --git a/include/net/smc.h b/include/net/smc.h
index 05174ae4f325..7c2082341bb3 100644
--- a/include/net/smc.h
+++ b/include/net/smc.h
@@ -37,6 +37,8 @@ struct smcd_dmb {
 #define ISM_EVENT_GID	1
 #define ISM_EVENT_SWR	2
 
+#define ISM_ERROR	0xFFFF
+
 struct smcd_event {
 	u32 type;
 	u32 code;
diff --git a/net/smc/smc_close.c b/net/smc/smc_close.c
index d34e5adce2eb..d205b2114006 100644
--- a/net/smc/smc_close.c
+++ b/net/smc/smc_close.c
@@ -110,6 +110,17 @@ int smc_close_abort(struct smc_connection *conn)
 	return smc_cdc_get_slot_and_msg_send(conn);
 }
 
+static void smc_close_cancel_work(struct smc_sock *smc)
+{
+	struct sock *sk = &smc->sk;
+
+	release_sock(sk);
+	cancel_work_sync(&smc->conn.close_work);
+	cancel_delayed_work_sync(&smc->conn.tx_work);
+	lock_sock(sk);
+	sk->sk_state = SMC_CLOSED;
+}
+
 /* terminate smc socket abnormally - active abort
  * link group is terminated, i.e. RDMA communication no longer possible
  */
@@ -126,23 +137,21 @@ void smc_close_active_abort(struct smc_sock *smc)
 	switch (sk->sk_state) {
 	case SMC_ACTIVE:
 		sk->sk_state = SMC_PEERABORTWAIT;
-		release_sock(sk);
-		cancel_delayed_work_sync(&smc->conn.tx_work);
-		lock_sock(sk);
+		smc_close_cancel_work(smc);
 		sk->sk_state = SMC_CLOSED;
 		sock_put(sk); /* passive closing */
 		break;
 	case SMC_APPCLOSEWAIT1:
 	case SMC_APPCLOSEWAIT2:
-		release_sock(sk);
-		cancel_delayed_work_sync(&smc->conn.tx_work);
-		lock_sock(sk);
+		smc_close_cancel_work(smc);
 		sk->sk_state = SMC_CLOSED;
 		sock_put(sk); /* postponed passive closing */
 		break;
 	case SMC_PEERCLOSEWAIT1:
 	case SMC_PEERCLOSEWAIT2:
 	case SMC_PEERFINCLOSEWAIT:
+		sk->sk_state = SMC_PEERABORTWAIT;
+		smc_close_cancel_work(smc);
 		sk->sk_state = SMC_CLOSED;
 		smc_conn_free(&smc->conn);
 		release_clcsock = true;
@@ -150,7 +159,11 @@ void smc_close_active_abort(struct smc_sock *smc)
 		break;
 	case SMC_PROCESSABORT:
 	case SMC_APPFINCLOSEWAIT:
+		sk->sk_state = SMC_PEERABORTWAIT;
+		smc_close_cancel_work(smc);
 		sk->sk_state = SMC_CLOSED;
+		smc_conn_free(&smc->conn);
+		release_clcsock = true;
 		break;
 	case SMC_INIT:
 	case SMC_PEERABORTWAIT:
diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index 561f069b30de..9d6da2c7413d 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -214,7 +214,7 @@ static void smc_lgr_free_work(struct work_struct *work)
 
 	if (!lgr->is_smcd && lnk->state != SMC_LNK_INACTIVE)
 		smc_llc_link_inactive(lnk);
-	if (lgr->is_smcd)
+	if (lgr->is_smcd && !lgr->terminating)
 		smc_ism_signal_shutdown(lgr);
 	smc_lgr_free(lgr);
 }
@@ -381,7 +381,8 @@ void smc_conn_free(struct smc_connection *conn)
 	if (!lgr)
 		return;
 	if (lgr->is_smcd) {
-		smc_ism_unset_conn(conn);
+		if (!list_empty(&lgr->list))
+			smc_ism_unset_conn(conn);
 		tasklet_kill(&conn->rx_tsklet);
 	} else {
 		smc_cdc_tx_dismiss_slots(conn);
@@ -481,8 +482,10 @@ static void smc_lgr_free(struct smc_link_group *lgr)
 {
 	smc_lgr_free_bufs(lgr);
 	if (lgr->is_smcd) {
-		smc_ism_put_vlan(lgr->smcd, lgr->vlan_id);
-		put_device(&lgr->smcd->dev);
+		if (!lgr->terminating) {
+			smc_ism_put_vlan(lgr->smcd, lgr->vlan_id);
+			put_device(&lgr->smcd->dev);
+		}
 	} else {
 		smc_link_clear(&lgr->lnk[SMC_SINGLE_LINK]);
 		put_device(&lgr->lnk[SMC_SINGLE_LINK].smcibdev->ibdev->dev);
@@ -503,6 +506,20 @@ void smc_lgr_forget(struct smc_link_group *lgr)
 	spin_unlock_bh(lgr_lock);
 }
 
+static void smcd_unregister_all_dmbs(struct smc_link_group *lgr)
+{
+	int i;
+
+	for (i = 0; i < SMC_RMBE_SIZES; i++) {
+		struct smc_buf_desc *buf_desc;
+
+		list_for_each_entry(buf_desc, &lgr->rmbs[i], list) {
+			buf_desc->len += sizeof(struct smcd_cdc_msg);
+			smc_ism_unregister_dmb(lgr->smcd, buf_desc);
+		}
+	}
+}
+
 static void smc_sk_wake_ups(struct smc_sock *smc)
 {
 	smc->sk.sk_write_space(&smc->sk);
@@ -522,12 +539,28 @@ static void smc_conn_kill(struct smc_connection *conn)
 	conn->killed = 1;
 	smc->sk.sk_err = ECONNABORTED;
 	smc_sk_wake_ups(smc);
-	if (conn->lgr->is_smcd)
+	if (conn->lgr->is_smcd) {
+		smc_ism_unset_conn(conn);
 		tasklet_kill(&conn->rx_tsklet);
+	}
 	smc_lgr_unregister_conn(conn);
 	smc_close_active_abort(smc);
 }
 
+static void smc_lgr_cleanup(struct smc_link_group *lgr)
+{
+	if (lgr->is_smcd) {
+		smc_ism_signal_shutdown(lgr);
+		smcd_unregister_all_dmbs(lgr);
+		smc_ism_put_vlan(lgr->smcd, lgr->vlan_id);
+		put_device(&lgr->smcd->dev);
+	} else {
+		struct smc_link *lnk = &lgr->lnk[SMC_SINGLE_LINK];
+
+		wake_up(&lnk->wr_reg_wait);
+	}
+}
+
 /* terminate link group */
 static void __smc_lgr_terminate(struct smc_link_group *lgr)
 {
@@ -557,8 +590,7 @@ static void __smc_lgr_terminate(struct smc_link_group *lgr)
 		node = rb_first(&lgr->conns_all);
 	}
 	read_unlock_bh(&lgr->conns_lock);
-	if (!lgr->is_smcd)
-		wake_up(&lgr->lnk[SMC_SINGLE_LINK].wr_reg_wait);
+	smc_lgr_cleanup(lgr);
 	smc_lgr_schedule_free_work_fast(lgr);
 }
 
diff --git a/net/smc/smc_ism.c b/net/smc/smc_ism.c
index 18946e95a3be..903da947b20d 100644
--- a/net/smc/smc_ism.c
+++ b/net/smc/smc_ism.c
@@ -146,6 +146,10 @@ int smc_ism_put_vlan(struct smcd_dev *smcd, unsigned short vlanid)
 int smc_ism_unregister_dmb(struct smcd_dev *smcd, struct smc_buf_desc *dmb_desc)
 {
 	struct smcd_dmb dmb;
+	int rc = 0;
+
+	if (!dmb_desc->dma_addr)
+		return rc;
 
 	memset(&dmb, 0, sizeof(dmb));
 	dmb.dmb_tok = dmb_desc->token;
@@ -153,7 +157,13 @@ int smc_ism_unregister_dmb(struct smcd_dev *smcd, struct smc_buf_desc *dmb_desc)
 	dmb.cpu_addr = dmb_desc->cpu_addr;
 	dmb.dma_addr = dmb_desc->dma_addr;
 	dmb.dmb_len = dmb_desc->len;
-	return smcd->ops->unregister_dmb(smcd, &dmb);
+	rc = smcd->ops->unregister_dmb(smcd, &dmb);
+	if (!rc || rc == ISM_ERROR) {
+		dmb_desc->cpu_addr = NULL;
+		dmb_desc->dma_addr = 0;
+	}
+
+	return rc;
 }
 
 int smc_ism_register_dmb(struct smc_link_group *lgr, int dmb_len,
@@ -375,7 +385,7 @@ void smcd_handle_irq(struct smcd_dev *smcd, unsigned int dmbno)
 
 	spin_lock_irqsave(&smcd->lock, flags);
 	conn = smcd->conn[dmbno];
-	if (conn)
+	if (conn && !conn->killed)
 		tasklet_schedule(&conn->rx_tsklet);
 	spin_unlock_irqrestore(&smcd->lock, flags);
 }
-- 
2.17.1

