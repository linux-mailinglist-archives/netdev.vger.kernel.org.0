Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 747381BE238
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 17:12:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727841AbgD2PLu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 11:11:50 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:61614 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727813AbgD2PLo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 11:11:44 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03TF3wxK096621;
        Wed, 29 Apr 2020 11:11:42 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30q802r1gh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Apr 2020 11:11:41 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 03TFAutn015228;
        Wed, 29 Apr 2020 15:11:35 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04ams.nl.ibm.com with ESMTP id 30mcu70q0g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Apr 2020 15:11:35 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03TFBWTd60490042
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Apr 2020 15:11:32 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3298EAE063;
        Wed, 29 Apr 2020 15:11:32 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EC681AE055;
        Wed, 29 Apr 2020 15:11:31 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 29 Apr 2020 15:11:31 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net-next 09/13] net/smc: simplify link deactivation
Date:   Wed, 29 Apr 2020 17:10:45 +0200
Message-Id: <20200429151049.49979-10-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200429151049.49979-1-kgraul@linux.ibm.com>
References: <20200429151049.49979-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-29_07:2020-04-29,2020-04-29 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 malwarescore=0
 suspectscore=3 phishscore=0 adultscore=0 lowpriorityscore=0
 priorityscore=1501 bulkscore=0 spamscore=0 clxscore=1015 mlxlogscore=999
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004290122
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cancel the testlink worker during link clear processing and remove the
extra function smc_llc_link_inactive().

Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
Reviewed-by: Ursula Braun <ubraun@linux.ibm.com>
---
 net/smc/smc_core.c |  8 ++------
 net/smc/smc_llc.c  | 15 ++++-----------
 net/smc/smc_llc.h  |  1 -
 3 files changed, 6 insertions(+), 18 deletions(-)

diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index 57890cbd4e8a..78ccfbf6e4af 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -261,7 +261,7 @@ static void smc_lgr_free_work(struct work_struct *work)
 			struct smc_link *lnk = &lgr->lnk[i];
 
 			if (smc_link_usable(lnk))
-				smc_llc_link_inactive(lnk);
+				lnk->state = SMC_LNK_INACTIVE;
 		}
 	}
 	smc_lgr_free(lgr);
@@ -692,7 +692,7 @@ static void smc_lgr_cleanup(struct smc_link_group *lgr)
 			struct smc_link *lnk = &lgr->lnk[i];
 
 			if (smc_link_usable(lnk))
-				smc_llc_link_inactive(lnk);
+				lnk->state = SMC_LNK_INACTIVE;
 		}
 	}
 }
@@ -706,16 +706,12 @@ static void __smc_lgr_terminate(struct smc_link_group *lgr, bool soft)
 	struct smc_connection *conn;
 	struct smc_sock *smc;
 	struct rb_node *node;
-	int i;
 
 	if (lgr->terminating)
 		return;	/* lgr already terminating */
 	if (!soft)
 		cancel_delayed_work_sync(&lgr->free_work);
 	lgr->terminating = 1;
-	if (!lgr->is_smcd)
-		for (i = 0; i < SMC_LINKS_PER_LGR_MAX; i++)
-			smc_llc_link_inactive(&lgr->lnk[i]);
 
 	/* kill remaining link group connections */
 	read_lock_bh(&lgr->conns_lock);
diff --git a/net/smc/smc_llc.c b/net/smc/smc_llc.c
index 69cc0d65b437..2f03131c85fd 100644
--- a/net/smc/smc_llc.c
+++ b/net/smc/smc_llc.c
@@ -660,22 +660,15 @@ void smc_llc_link_deleting(struct smc_link *link)
 	smc_wr_wakeup_tx_wait(link);
 }
 
-/* called in tasklet context */
-void smc_llc_link_inactive(struct smc_link *link)
-{
-	if (link->state == SMC_LNK_INACTIVE)
-		return;
-	link->state = SMC_LNK_INACTIVE;
-	cancel_delayed_work_sync(&link->llc_testlink_wrk);
-	smc_wr_wakeup_reg_wait(link);
-	smc_wr_wakeup_tx_wait(link);
-}
-
 /* called in worker context */
 void smc_llc_link_clear(struct smc_link *link)
 {
 	flush_workqueue(link->llc_wq);
 	destroy_workqueue(link->llc_wq);
+	complete(&link->llc_testlink_resp);
+	cancel_delayed_work_sync(&link->llc_testlink_wrk);
+	smc_wr_wakeup_reg_wait(link);
+	smc_wr_wakeup_tx_wait(link);
 }
 
 /* register a new rtoken at the remote peer */
diff --git a/net/smc/smc_llc.h b/net/smc/smc_llc.h
index 08171131110c..c2c9d48d079f 100644
--- a/net/smc/smc_llc.h
+++ b/net/smc/smc_llc.h
@@ -56,7 +56,6 @@ int smc_llc_send_delete_link(struct smc_link *link,
 int smc_llc_link_init(struct smc_link *link);
 void smc_llc_link_active(struct smc_link *link, int testlink_time);
 void smc_llc_link_deleting(struct smc_link *link);
-void smc_llc_link_inactive(struct smc_link *link);
 void smc_llc_link_clear(struct smc_link *link);
 int smc_llc_do_confirm_rkey(struct smc_link *link,
 			    struct smc_buf_desc *rmb_desc);
-- 
2.17.1

