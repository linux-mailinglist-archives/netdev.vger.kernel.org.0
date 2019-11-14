Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CCD1FC5DB
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 13:03:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727022AbfKNMDH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 07:03:07 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:27688 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726960AbfKNMDD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 07:03:03 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id xAEBv7Rj147277
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 07:03:03 -0500
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2w96barq3q-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 07:03:03 -0500
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <kgraul@linux.ibm.com>;
        Thu, 14 Nov 2019 12:02:59 -0000
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 14 Nov 2019 12:02:57 -0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xAEC2tWl57278476
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Nov 2019 12:02:55 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B0FCB4C044;
        Thu, 14 Nov 2019 12:02:55 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7C1254C050;
        Thu, 14 Nov 2019 12:02:55 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 14 Nov 2019 12:02:55 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net-next 7/8] net/smc: wait for tx completions before link freeing
Date:   Thu, 14 Nov 2019 13:02:46 +0100
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191114120247.68889-1-kgraul@linux.ibm.com>
References: <20191114120247.68889-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19111412-0028-0000-0000-000003B6D3DE
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19111412-0029-0000-0000-00002479E10D
Message-Id: <20191114120247.68889-8-kgraul@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-11-14_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=738 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1910280000 definitions=main-1911140113
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ursula Braun <ubraun@linux.ibm.com>

Make sure all pending work requests are completed before freeing
a link.
Dismiss tx pending slots already when terminating a link group to
exploit termination shortcut in tx completion queue handler.

And kill the completion queue tasklets after destroy of the
completion queues, otherwise there is a time window for another
tasklet schedule of an already killed tasklet.

Signed-off-by: Ursula Braun <ubraun@linux.ibm.com>
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 net/smc/smc_core.c |  2 ++
 net/smc/smc_ib.c   |  2 +-
 net/smc/smc_wr.c   | 27 +++++++++++++++++++++++++--
 3 files changed, 28 insertions(+), 3 deletions(-)

diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index ee44e8244d0c..0755bd4b587c 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -548,6 +548,8 @@ static void smc_conn_kill(struct smc_connection *conn, bool soft)
 			tasklet_kill(&conn->rx_tsklet);
 		else
 			tasklet_unlock_wait(&conn->rx_tsklet);
+	} else {
+		smc_cdc_tx_dismiss_slots(conn);
 	}
 	smc_lgr_unregister_conn(conn);
 	smc_close_active_abort(smc);
diff --git a/net/smc/smc_ib.c b/net/smc/smc_ib.c
index af05daeb0538..c15dcd08dc74 100644
--- a/net/smc/smc_ib.c
+++ b/net/smc/smc_ib.c
@@ -520,9 +520,9 @@ static void smc_ib_cleanup_per_ibdev(struct smc_ib_device *smcibdev)
 	if (!smcibdev->initialized)
 		return;
 	smcibdev->initialized = 0;
-	smc_wr_remove_dev(smcibdev);
 	ib_destroy_cq(smcibdev->roce_cq_recv);
 	ib_destroy_cq(smcibdev->roce_cq_send);
+	smc_wr_remove_dev(smcibdev);
 }
 
 static struct ib_client smc_ib_client;
diff --git a/net/smc/smc_wr.c b/net/smc/smc_wr.c
index 619dd89fbac0..337ee52ad3d3 100644
--- a/net/smc/smc_wr.c
+++ b/net/smc/smc_wr.c
@@ -50,6 +50,26 @@ struct smc_wr_tx_pend {	/* control data for a pending send request */
 
 /*------------------------------- completion --------------------------------*/
 
+/* returns true if at least one tx work request is pending on the given link */
+static inline bool smc_wr_is_tx_pend(struct smc_link *link)
+{
+	if (find_first_bit(link->wr_tx_mask, link->wr_tx_cnt) !=
+							link->wr_tx_cnt) {
+		return true;
+	}
+	return false;
+}
+
+/* wait till all pending tx work requests on the given link are completed */
+static inline int smc_wr_tx_wait_no_pending_sends(struct smc_link *link)
+{
+	if (wait_event_timeout(link->wr_tx_wait, !smc_wr_is_tx_pend(link),
+			       SMC_WR_TX_WAIT_PENDING_TIME))
+		return 0;
+	else /* timeout */
+		return -EPIPE;
+}
+
 static inline int smc_wr_tx_find_pending_index(struct smc_link *link, u64 wr_id)
 {
 	u32 i;
@@ -229,6 +249,7 @@ int smc_wr_tx_put_slot(struct smc_link *link,
 		memset(&link->wr_tx_bufs[idx], 0,
 		       sizeof(link->wr_tx_bufs[idx]));
 		test_and_clear_bit(idx, link->wr_tx_mask);
+		wake_up(&link->wr_tx_wait);
 		return 1;
 	}
 
@@ -512,8 +533,10 @@ void smc_wr_free_link(struct smc_link *lnk)
 {
 	struct ib_device *ibdev;
 
-	memset(lnk->wr_tx_mask, 0,
-	       BITS_TO_LONGS(SMC_WR_BUF_CNT) * sizeof(*lnk->wr_tx_mask));
+	if (smc_wr_tx_wait_no_pending_sends(lnk))
+		memset(lnk->wr_tx_mask, 0,
+		       BITS_TO_LONGS(SMC_WR_BUF_CNT) *
+						sizeof(*lnk->wr_tx_mask));
 
 	if (!lnk->smcibdev)
 		return;
-- 
2.17.1

