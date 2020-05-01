Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98A6C1C1123
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 12:48:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728676AbgEAKsn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 06:48:43 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:9594 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728611AbgEAKsc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 May 2020 06:48:32 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 041AXWLm177282;
        Fri, 1 May 2020 06:48:29 -0400
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0b-001b2d01.pphosted.com with ESMTP id 30r825p2ra-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 01 May 2020 06:48:29 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 041AkIY6028478;
        Fri, 1 May 2020 10:48:27 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma01fra.de.ibm.com with ESMTP id 30mcu8ffb2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 01 May 2020 10:48:27 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 041AlGK858065360
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 1 May 2020 10:47:16 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DF647A4054;
        Fri,  1 May 2020 10:48:24 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9A629A4060;
        Fri,  1 May 2020 10:48:24 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  1 May 2020 10:48:24 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net-next 08/13] net/smc: add smcr_port_err() and smcr_link_down() processing
Date:   Fri,  1 May 2020 12:48:08 +0200
Message-Id: <20200501104813.76601-9-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200501104813.76601-1-kgraul@linux.ibm.com>
References: <20200501104813.76601-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-05-01_03:2020-04-30,2020-05-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 spamscore=0
 impostorscore=0 clxscore=1015 phishscore=0 lowpriorityscore=0
 priorityscore=1501 malwarescore=0 suspectscore=3 bulkscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005010078
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Call smcr_port_err() when an IB event reports an inactive IB device.
smcr_port_err() calls smcr_link_down() for all affected links.
smcr_link_down() either triggers the local DELETE_LINK processing, or
sends an DELETE_LINK LLC message to the SMC server to initiate the
processing.
The old handler function smc_port_terminate() is removed.
Add helper smcr_link_down_cond() to take a link down conditionally, and
smcr_link_down_cond_sched() to schedule the link_down processing to a
work.

Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
Reviewed-by: Ursula Braun <ubraun@linux.ibm.com>
---
 net/smc/smc_core.c | 119 +++++++++++++++++++++++++++++++++------------
 net/smc/smc_core.h |   6 ++-
 net/smc/smc_ib.c   |   2 +-
 net/smc/smc_llc.h  |   3 ++
 4 files changed, 98 insertions(+), 32 deletions(-)

diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index 20bc9e46bf52..62108e0cd529 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -56,6 +56,7 @@ static void smc_buf_free(struct smc_link_group *lgr, bool is_rmb,
 static void __smc_lgr_terminate(struct smc_link_group *lgr, bool soft);
 
 static void smc_link_up_work(struct work_struct *work);
+static void smc_link_down_work(struct work_struct *work);
 
 /* return head of link group list and its lock for a given link group */
 static inline struct list_head *smc_lgr_list_head(struct smc_link_group *lgr,
@@ -320,6 +321,7 @@ static int smcr_link_init(struct smc_link_group *lgr, struct smc_link *lnk,
 	lnk->smcibdev = ini->ib_dev;
 	lnk->ibport = ini->ib_port;
 	lnk->path_mtu = ini->ib_dev->pattr[ini->ib_port - 1].active_mtu;
+	INIT_WORK(&lnk->link_down_wrk, smc_link_down_work);
 	if (!ini->ib_dev->initialized) {
 		rc = (int)smc_ib_setup_per_ibdev(ini->ib_dev);
 		if (rc)
@@ -818,36 +820,6 @@ void smc_lgr_terminate_sched(struct smc_link_group *lgr)
 	schedule_work(&lgr->terminate_work);
 }
 
-/* Called when IB port is terminated */
-void smc_port_terminate(struct smc_ib_device *smcibdev, u8 ibport)
-{
-	struct smc_link_group *lgr, *l;
-	LIST_HEAD(lgr_free_list);
-	int i;
-
-	spin_lock_bh(&smc_lgr_list.lock);
-	list_for_each_entry_safe(lgr, l, &smc_lgr_list.list, list) {
-		if (lgr->is_smcd)
-			continue;
-		/* tbd - terminate only when no more links are active */
-		for (i = 0; i < SMC_LINKS_PER_LGR_MAX; i++) {
-			if (!smc_link_usable(&lgr->lnk[i]))
-				continue;
-			if (lgr->lnk[i].smcibdev == smcibdev &&
-			    lgr->lnk[i].ibport == ibport) {
-				list_move(&lgr->list, &lgr_free_list);
-				lgr->freeing = 1;
-			}
-		}
-	}
-	spin_unlock_bh(&smc_lgr_list.lock);
-
-	list_for_each_entry_safe(lgr, l, &lgr_free_list, list) {
-		list_del_init(&lgr->list);
-		__smc_lgr_terminate(lgr, false);
-	}
-}
-
 /* Called when peer lgr shutdown (regularly or abnormally) is received */
 void smc_smcd_terminate(struct smcd_dev *dev, u64 peer_gid, unsigned short vlan)
 {
@@ -1000,6 +972,79 @@ void smcr_port_add(struct smc_ib_device *smcibdev, u8 ibport)
 	}
 }
 
+/* link is down - switch connections to alternate link,
+ * must be called under lgr->llc_conf_mutex lock
+ */
+static void smcr_link_down(struct smc_link *lnk)
+{
+	struct smc_link_group *lgr = lnk->lgr;
+	struct smc_link *to_lnk;
+	int del_link_id;
+
+	if (!lgr || lnk->state == SMC_LNK_UNUSED || list_empty(&lgr->list))
+		return;
+
+	smc_ib_modify_qp_reset(lnk);
+	to_lnk = NULL;
+	/* tbd: call to_lnk = smc_switch_conns(lgr, lnk, true); */
+	if (!to_lnk) { /* no backup link available */
+		smcr_link_clear(lnk);
+		return;
+	}
+	lgr->type = SMC_LGR_SINGLE;
+	del_link_id = lnk->link_id;
+
+	if (lgr->role == SMC_SERV) {
+		/* trigger local delete link processing */
+	} else {
+		if (lgr->llc_flow_lcl.type != SMC_LLC_FLOW_NONE) {
+			/* another llc task is ongoing */
+			mutex_unlock(&lgr->llc_conf_mutex);
+			wait_event_interruptible_timeout(lgr->llc_waiter,
+				(lgr->llc_flow_lcl.type == SMC_LLC_FLOW_NONE),
+				SMC_LLC_WAIT_TIME);
+			mutex_lock(&lgr->llc_conf_mutex);
+		}
+		smc_llc_send_delete_link(to_lnk, del_link_id, SMC_LLC_REQ, true,
+					 SMC_LLC_DEL_LOST_PATH);
+	}
+}
+
+/* must be called under lgr->llc_conf_mutex lock */
+void smcr_link_down_cond(struct smc_link *lnk)
+{
+	if (smc_link_downing(&lnk->state))
+		smcr_link_down(lnk);
+}
+
+/* will get the lgr->llc_conf_mutex lock */
+void smcr_link_down_cond_sched(struct smc_link *lnk)
+{
+	if (smc_link_downing(&lnk->state))
+		schedule_work(&lnk->link_down_wrk);
+}
+
+void smcr_port_err(struct smc_ib_device *smcibdev, u8 ibport)
+{
+	struct smc_link_group *lgr, *n;
+	int i;
+
+	list_for_each_entry_safe(lgr, n, &smc_lgr_list.list, list) {
+		if (strncmp(smcibdev->pnetid[ibport - 1], lgr->pnet_id,
+			    SMC_MAX_PNETID_LEN))
+			continue; /* lgr is not affected */
+		if (list_empty(&lgr->list))
+			continue;
+		for (i = 0; i < SMC_LINKS_PER_LGR_MAX; i++) {
+			struct smc_link *lnk = &lgr->lnk[i];
+
+			if (smc_link_usable(lnk) &&
+			    lnk->smcibdev == smcibdev && lnk->ibport == ibport)
+				smcr_link_down_cond_sched(lnk);
+		}
+	}
+}
+
 static void smc_link_up_work(struct work_struct *work)
 {
 	struct smc_ib_up_work *ib_work = container_of(work,
@@ -1014,6 +1059,20 @@ static void smc_link_up_work(struct work_struct *work)
 	kfree(ib_work);
 }
 
+static void smc_link_down_work(struct work_struct *work)
+{
+	struct smc_link *link = container_of(work, struct smc_link,
+					     link_down_wrk);
+	struct smc_link_group *lgr = link->lgr;
+
+	if (list_empty(&lgr->list))
+		return;
+	wake_up_interruptible_all(&lgr->llc_waiter);
+	mutex_lock(&lgr->llc_conf_mutex);
+	smcr_link_down(link);
+	mutex_unlock(&lgr->llc_conf_mutex);
+}
+
 /* Determine vlan of internal TCP socket.
  * @vlan_id: address to store the determined vlan id into
  */
diff --git a/net/smc/smc_core.h b/net/smc/smc_core.h
index 86453ad83491..da3cddbd1651 100644
--- a/net/smc/smc_core.h
+++ b/net/smc/smc_core.h
@@ -117,6 +117,7 @@ struct smc_link {
 	u8			link_id;	/* unique # within link group */
 	u8			link_idx;	/* index in lgr link array */
 	struct smc_link_group	*lgr;		/* parent link group */
+	struct work_struct	link_down_wrk;	/* wrk to bring link down */
 
 	enum smc_link_state	state;		/* state of link */
 	struct delayed_work	llc_testlink_wrk; /* testlink worker */
@@ -344,8 +345,8 @@ struct smc_clc_msg_local;
 void smc_lgr_forget(struct smc_link_group *lgr);
 void smc_lgr_cleanup_early(struct smc_connection *conn);
 void smc_lgr_terminate_sched(struct smc_link_group *lgr);
-void smc_port_terminate(struct smc_ib_device *smcibdev, u8 ibport);
 void smcr_port_add(struct smc_ib_device *smcibdev, u8 ibport);
+void smcr_port_err(struct smc_ib_device *smcibdev, u8 ibport);
 void smc_smcd_terminate(struct smcd_dev *dev, u64 peer_gid,
 			unsigned short vlan);
 void smc_smcd_terminate_all(struct smcd_dev *dev);
@@ -376,6 +377,9 @@ void smcr_link_clear(struct smc_link *lnk);
 int smcr_buf_map_lgr(struct smc_link *lnk);
 int smcr_buf_reg_lgr(struct smc_link *lnk);
 int smcr_link_reg_rmb(struct smc_link *link, struct smc_buf_desc *rmb_desc);
+void smcr_link_down_cond(struct smc_link *lnk);
+void smcr_link_down_cond_sched(struct smc_link *lnk);
+
 static inline struct smc_link_group *smc_get_lgr(struct smc_link *link)
 {
 	return link->lgr;
diff --git a/net/smc/smc_ib.c b/net/smc/smc_ib.c
index 545fb0bc3714..2c743caad69a 100644
--- a/net/smc/smc_ib.c
+++ b/net/smc/smc_ib.c
@@ -249,7 +249,7 @@ static void smc_ib_port_event_work(struct work_struct *work)
 		clear_bit(port_idx, &smcibdev->port_event_mask);
 		if (!smc_ib_port_active(smcibdev, port_idx + 1)) {
 			set_bit(port_idx, smcibdev->ports_going_away);
-			smc_port_terminate(smcibdev, port_idx + 1);
+			smcr_port_err(smcibdev, port_idx + 1);
 		} else {
 			clear_bit(port_idx, smcibdev->ports_going_away);
 			smcr_port_add(smcibdev, port_idx + 1);
diff --git a/net/smc/smc_llc.h b/net/smc/smc_llc.h
index d2c50d3e43a6..4ed4486e5082 100644
--- a/net/smc/smc_llc.h
+++ b/net/smc/smc_llc.h
@@ -35,6 +35,9 @@ enum smc_llc_msg_type {
 	SMC_LLC_DELETE_RKEY		= 0x09,
 };
 
+#define smc_link_downing(state) \
+	(cmpxchg(state, SMC_LNK_ACTIVE, SMC_LNK_INACTIVE) == SMC_LNK_ACTIVE)
+
 /* LLC DELETE LINK Request Reason Codes */
 #define SMC_LLC_DEL_LOST_PATH		0x00010000
 #define SMC_LLC_DEL_OP_INIT_TERM	0x00020000
-- 
2.17.1

