Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F6B21C112E
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 12:49:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728703AbgEAKsz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 06:48:55 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:35264 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728622AbgEAKsb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 May 2020 06:48:31 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 041AWMF5002464;
        Fri, 1 May 2020 06:48:29 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30r82mp2y7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 01 May 2020 06:48:28 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 041Ak815026765;
        Fri, 1 May 2020 10:48:26 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03ams.nl.ibm.com with ESMTP id 30mcu5vh5p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 01 May 2020 10:48:26 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 041AlFba57737622
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 1 May 2020 10:47:15 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E6C49A405B;
        Fri,  1 May 2020 10:48:23 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AA76DA4062;
        Fri,  1 May 2020 10:48:23 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  1 May 2020 10:48:23 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net-next 05/13] net/smc: mutex to protect the lgr against parallel reconfigurations
Date:   Fri,  1 May 2020 12:48:05 +0200
Message-Id: <20200501104813.76601-6-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200501104813.76601-1-kgraul@linux.ibm.com>
References: <20200501104813.76601-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-05-01_02:2020-04-30,2020-05-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 lowpriorityscore=0 priorityscore=1501 phishscore=0 impostorscore=0
 clxscore=1015 spamscore=0 malwarescore=0 mlxscore=0 bulkscore=0
 adultscore=0 suspectscore=1 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2005010078
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce llc_conf_mutex in the link group which is used to protect the
buffers and lgr states against parallel link reconfiguration.
This ensures that new connections do not start to register buffers with
the links of a link group when link creation or termination is running.

Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
Reviewed-by: Ursula Braun <ubraun@linux.ibm.com>
---
 net/smc/af_smc.c   |  9 +++++++++
 net/smc/smc_core.c | 26 ++++++++++++++++++++++----
 net/smc/smc_core.h |  2 ++
 net/smc/smc_llc.c  |  9 +--------
 4 files changed, 34 insertions(+), 12 deletions(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 20d6d3fbb86c..6663a63be9e4 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -344,6 +344,13 @@ static int smcr_lgr_reg_rmbs(struct smc_link *link,
 	struct smc_link_group *lgr = link->lgr;
 	int i, rc = 0;
 
+	rc = smc_llc_flow_initiate(lgr, SMC_LLC_FLOW_RKEY);
+	if (rc)
+		return rc;
+	/* protect against parallel smc_llc_cli_rkey_exchange() and
+	 * parallel smcr_link_reg_rmb()
+	 */
+	mutex_lock(&lgr->llc_conf_mutex);
 	for (i = 0; i < SMC_LINKS_PER_LGR_MAX; i++) {
 		if (lgr->lnk[i].state != SMC_LNK_ACTIVE)
 			continue;
@@ -360,6 +367,8 @@ static int smcr_lgr_reg_rmbs(struct smc_link *link,
 	}
 	rmb_desc->is_conf_rkey = true;
 out:
+	mutex_unlock(&lgr->llc_conf_mutex);
+	smc_llc_flow_stop(lgr, &lgr->llc_flow_lcl);
 	return rc;
 }
 
diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index c905675017c7..4c3af05d76a5 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -448,11 +448,21 @@ static int smc_lgr_create(struct smc_sock *smc, struct smc_init_info *ini)
 static void smcr_buf_unuse(struct smc_buf_desc *rmb_desc,
 			   struct smc_link_group *lgr)
 {
+	int rc;
+
 	if (rmb_desc->is_conf_rkey && !list_empty(&lgr->list)) {
 		/* unregister rmb with peer */
-		smc_llc_do_delete_rkey(lgr, rmb_desc);
-		rmb_desc->is_conf_rkey = false;
+		rc = smc_llc_flow_initiate(lgr, SMC_LLC_FLOW_RKEY);
+		if (!rc) {
+			/* protect against smc_llc_cli_rkey_exchange() */
+			mutex_lock(&lgr->llc_conf_mutex);
+			smc_llc_do_delete_rkey(lgr, rmb_desc);
+			rmb_desc->is_conf_rkey = false;
+			mutex_unlock(&lgr->llc_conf_mutex);
+			smc_llc_flow_stop(lgr, &lgr->llc_flow_lcl);
+		}
 	}
+
 	if (rmb_desc->is_reg_err) {
 		/* buf registration failed, reuse not possible */
 		mutex_lock(&lgr->rmbs_lock);
@@ -552,6 +562,7 @@ static void smcr_rtoken_clear_link(struct smc_link *lnk)
 	}
 }
 
+/* must be called under lgr->llc_conf_mutex lock */
 void smcr_link_clear(struct smc_link *lnk)
 {
 	struct smc_ib_device *smcibdev;
@@ -1170,7 +1181,9 @@ static int smcr_buf_map_link(struct smc_buf_desc *buf_desc, bool is_rmb,
 	return rc;
 }
 
-/* register a new rmb on IB device */
+/* register a new rmb on IB device,
+ * must be called under lgr->llc_conf_mutex lock
+ */
 int smcr_link_reg_rmb(struct smc_link *link, struct smc_buf_desc *rmb_desc)
 {
 	if (list_empty(&link->lgr->list))
@@ -1224,7 +1237,9 @@ int smcr_buf_map_lgr(struct smc_link *lnk)
 	return 0;
 }
 
-/* register all used buffers of lgr for a new link */
+/* register all used buffers of lgr for a new link,
+ * must be called under lgr->llc_conf_mutex lock
+ */
 int smcr_buf_reg_lgr(struct smc_link *lnk)
 {
 	struct smc_link_group *lgr = lnk->lgr;
@@ -1278,6 +1293,8 @@ static int smcr_buf_map_usable_links(struct smc_link_group *lgr,
 {
 	int i, rc = 0;
 
+	/* protect against parallel link reconfiguration */
+	mutex_lock(&lgr->llc_conf_mutex);
 	for (i = 0; i < SMC_LINKS_PER_LGR_MAX; i++) {
 		struct smc_link *lnk = &lgr->lnk[i];
 
@@ -1289,6 +1306,7 @@ static int smcr_buf_map_usable_links(struct smc_link_group *lgr,
 		}
 	}
 out:
+	mutex_unlock(&lgr->llc_conf_mutex);
 	return rc;
 }
 
diff --git a/net/smc/smc_core.h b/net/smc/smc_core.h
index 61ddb5264936..aa198dd0f0e4 100644
--- a/net/smc/smc_core.h
+++ b/net/smc/smc_core.h
@@ -248,6 +248,8 @@ struct smc_link_group {
 						/* queue for llc events */
 			spinlock_t		llc_event_q_lock;
 						/* protects llc_event_q */
+			struct mutex		llc_conf_mutex;
+						/* protects lgr reconfig. */
 			struct work_struct	llc_event_work;
 						/* llc event worker */
 			wait_queue_head_t	llc_waiter;
diff --git a/net/smc/smc_llc.c b/net/smc/smc_llc.c
index 171835926db6..ceed3c89926f 100644
--- a/net/smc/smc_llc.c
+++ b/net/smc/smc_llc.c
@@ -848,6 +848,7 @@ void smc_llc_lgr_init(struct smc_link_group *lgr, struct smc_sock *smc)
 	spin_lock_init(&lgr->llc_event_q_lock);
 	spin_lock_init(&lgr->llc_flow_lock);
 	init_waitqueue_head(&lgr->llc_waiter);
+	mutex_init(&lgr->llc_conf_mutex);
 	lgr->llc_testlink_time = net->ipv4.sysctl_tcp_keepalive_time;
 }
 
@@ -897,9 +898,6 @@ int smc_llc_do_confirm_rkey(struct smc_link *send_link,
 	struct smc_llc_qentry *qentry = NULL;
 	int rc = 0;
 
-	rc = smc_llc_flow_initiate(lgr, SMC_LLC_FLOW_RKEY);
-	if (rc)
-		return rc;
 	rc = smc_llc_send_confirm_rkey(send_link, rmb_desc);
 	if (rc)
 		goto out;
@@ -911,7 +909,6 @@ int smc_llc_do_confirm_rkey(struct smc_link *send_link,
 out:
 	if (qentry)
 		smc_llc_flow_qentry_del(&lgr->llc_flow_lcl);
-	smc_llc_flow_stop(lgr, &lgr->llc_flow_lcl);
 	return rc;
 }
 
@@ -927,9 +924,6 @@ int smc_llc_do_delete_rkey(struct smc_link_group *lgr,
 	if (!send_link)
 		return -ENOLINK;
 
-	rc = smc_llc_flow_initiate(lgr, SMC_LLC_FLOW_RKEY);
-	if (rc)
-		return rc;
 	/* protected by llc_flow control */
 	rc = smc_llc_send_delete_rkey(send_link, rmb_desc);
 	if (rc)
@@ -942,7 +936,6 @@ int smc_llc_do_delete_rkey(struct smc_link_group *lgr,
 out:
 	if (qentry)
 		smc_llc_flow_qentry_del(&lgr->llc_flow_lcl);
-	smc_llc_flow_stop(lgr, &lgr->llc_flow_lcl);
 	return rc;
 }
 
-- 
2.17.1

