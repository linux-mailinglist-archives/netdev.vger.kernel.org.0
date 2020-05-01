Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DC3F1C1125
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 12:48:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728684AbgEAKso (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 06:48:44 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:51366 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728629AbgEAKsc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 May 2020 06:48:32 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 041AXTia007994;
        Fri, 1 May 2020 06:48:31 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30r7mmxft7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 01 May 2020 06:48:31 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 041Ak816026765;
        Fri, 1 May 2020 10:48:29 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03ams.nl.ibm.com with ESMTP id 30mcu5vh5u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 01 May 2020 10:48:29 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 041AmQMg58851480
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 1 May 2020 10:48:26 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 604AEA4054;
        Fri,  1 May 2020 10:48:26 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 24914A405B;
        Fri,  1 May 2020 10:48:26 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  1 May 2020 10:48:26 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net-next 13/13] net/smc: llc_add_link_work to handle ADD_LINK LLC requests
Date:   Fri,  1 May 2020 12:48:13 +0200
Message-Id: <20200501104813.76601-14-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200501104813.76601-1-kgraul@linux.ibm.com>
References: <20200501104813.76601-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-05-01_04:2020-04-30,2020-05-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 phishscore=0
 clxscore=1015 mlxscore=0 adultscore=0 impostorscore=0 mlxlogscore=999
 priorityscore=1501 lowpriorityscore=0 spamscore=0 suspectscore=1
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005010082
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce a work that is scheduled when a new ADD_LINK LLC request is
received. The work will call either the SMC client or SMC server
ADD_LINK processing.

Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
Reviewed-by: Ursula Braun <ubraun@linux.ibm.com>
---
 net/smc/smc_core.h |  1 +
 net/smc/smc_llc.c  | 24 ++++++++++++++++++++++--
 2 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/net/smc/smc_core.h b/net/smc/smc_core.h
index eb27f2eb7c8c..555ada9d2423 100644
--- a/net/smc/smc_core.h
+++ b/net/smc/smc_core.h
@@ -253,6 +253,7 @@ struct smc_link_group {
 						/* protects llc_event_q */
 			struct mutex		llc_conf_mutex;
 						/* protects lgr reconfig. */
+			struct work_struct	llc_add_link_work;
 			struct work_struct	llc_event_work;
 						/* llc event worker */
 			wait_queue_head_t	llc_waiter;
diff --git a/net/smc/smc_llc.c b/net/smc/smc_llc.c
index 3a25b6ebe3a8..50f59746bdf9 100644
--- a/net/smc/smc_llc.c
+++ b/net/smc/smc_llc.c
@@ -565,6 +565,24 @@ static int smc_llc_alloc_alt_link(struct smc_link_group *lgr,
 	return -EMLINK;
 }
 
+/* worker to process an add link message */
+static void smc_llc_add_link_work(struct work_struct *work)
+{
+	struct smc_link_group *lgr = container_of(work, struct smc_link_group,
+						  llc_add_link_work);
+
+	if (list_empty(&lgr->list)) {
+		/* link group is terminating */
+		smc_llc_flow_qentry_del(&lgr->llc_flow_lcl);
+		goto out;
+	}
+
+	/* tbd: call smc_llc_process_cli_add_link(lgr); */
+	/* tbd: call smc_llc_process_srv_add_link(lgr); */
+out:
+	smc_llc_flow_stop(lgr, &lgr->llc_flow_lcl);
+}
+
 static void smc_llc_rx_delete_link(struct smc_link *link,
 				   struct smc_llc_msg_del_link *llc)
 {
@@ -685,11 +703,11 @@ static void smc_llc_event_handler(struct smc_llc_qentry *qentry)
 				wake_up_interruptible(&lgr->llc_waiter);
 			} else if (smc_llc_flow_start(&lgr->llc_flow_lcl,
 						      qentry)) {
-				/* tbd: schedule_work(&lgr->llc_add_link_work); */
+				schedule_work(&lgr->llc_add_link_work);
 			}
 		} else if (smc_llc_flow_start(&lgr->llc_flow_lcl, qentry)) {
 			/* as smc server, handle client suggestion */
-			/* tbd: schedule_work(&lgr->llc_add_link_work); */
+			schedule_work(&lgr->llc_add_link_work);
 		}
 		return;
 	case SMC_LLC_CONFIRM_LINK:
@@ -868,6 +886,7 @@ void smc_llc_lgr_init(struct smc_link_group *lgr, struct smc_sock *smc)
 	struct net *net = sock_net(smc->clcsock->sk);
 
 	INIT_WORK(&lgr->llc_event_work, smc_llc_event_work);
+	INIT_WORK(&lgr->llc_add_link_work, smc_llc_add_link_work);
 	INIT_LIST_HEAD(&lgr->llc_event_q);
 	spin_lock_init(&lgr->llc_event_q_lock);
 	spin_lock_init(&lgr->llc_flow_lock);
@@ -882,6 +901,7 @@ void smc_llc_lgr_clear(struct smc_link_group *lgr)
 	smc_llc_event_flush(lgr);
 	wake_up_interruptible_all(&lgr->llc_waiter);
 	cancel_work_sync(&lgr->llc_event_work);
+	cancel_work_sync(&lgr->llc_add_link_work);
 	if (lgr->delayed_event) {
 		kfree(lgr->delayed_event);
 		lgr->delayed_event = NULL;
-- 
2.17.1

