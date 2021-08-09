Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB4473E4208
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 11:06:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234154AbhHIJG1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 05:06:27 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:57152 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S234127AbhHIJG0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 05:06:26 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17993uXO136812;
        Mon, 9 Aug 2021 05:06:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=IEwu7FdvUkdM3tmFDCMn/hiuvkOwr7o1bjIvBVHeH7k=;
 b=Jdp5X8PgfdXWGJ1sCoWbrzAgQmSfUFiDOGRuvQHzL8Ghb3Xlcigui0Fz34+8J6Wy3EdX
 5NOYclpT0WZtoRQ5OM1PwKwT4FCajSSisvLbgTm6tTri2G9977ssYIydo3Z0xosJyV49
 XUB/iSU9GHtT2cCwq563xEmwW9JZySAXDyesrFq1nSeLVtuzrYIVxK3EPJCqBaUpNjXx
 9pfbtzQbQGmX91HK1iTt8CjA2YCmfGzoQDC0ZX0G26z1DHyIO+sXXux7aX/QxApwRF+9
 gQcznomxqSw5PjhyDvelbu1zf1mj7en5st/v13yrZMhft9KDSCJiu/wrNFSbRg19njUI zQ== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3aa78b8cj9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Aug 2021 05:06:03 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 179930wS024568;
        Mon, 9 Aug 2021 09:06:02 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3a9ht8upn4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Aug 2021 09:06:01 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17992new56951272
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 9 Aug 2021 09:02:49 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5FF024C05A;
        Mon,  9 Aug 2021 09:05:58 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 160D14C058;
        Mon,  9 Aug 2021 09:05:58 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  9 Aug 2021 09:05:58 +0000 (GMT)
From:   Guvenc Gulce <guvenc@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>
Subject: [PATCH net 1/2] net/smc: fix wait on already cleared link
Date:   Mon,  9 Aug 2021 11:05:56 +0200
Message-Id: <20210809090557.3121288-2-guvenc@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210809090557.3121288-1-guvenc@linux.ibm.com>
References: <20210809090557.3121288-1-guvenc@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 7s1QMCfY97S3iM11_j-chRapwC7BAo5u
X-Proofpoint-GUID: 7s1QMCfY97S3iM11_j-chRapwC7BAo5u
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-09_01:2021-08-06,2021-08-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 adultscore=0
 priorityscore=1501 suspectscore=0 clxscore=1015 spamscore=0 phishscore=0
 malwarescore=0 lowpriorityscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108090073
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Karsten Graul <kgraul@linux.ibm.com>

There can be a race between the waiters for a tx work request buffer
and the link down processing that finally clears the link. Although
all waiters are woken up before the link is cleared there might be
waiters which did not yet get back control and are still waiting.
This results in an access to a cleared wait queue head.

Fix this by introducing atomic reference counting around the wait calls,
and wait with the link clear processing until all waiters have finished.
Move the work request layer related calls into smc_wr.c and set the
link state to INACTIVE before calling smcr_link_clear() in
smc_llc_srv_add_link().

Fixes: 15e1b99aadfb ("net/smc: no WR buffer wait for terminating link group")
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
Signed-off-by: Guvenc Gulce <guvenc@linux.ibm.com>
---
 net/smc/smc_core.h |  2 ++
 net/smc/smc_llc.c  | 10 ++++------
 net/smc/smc_tx.c   | 18 +++++++++++++++++-
 net/smc/smc_wr.c   | 10 ++++++++++
 4 files changed, 33 insertions(+), 7 deletions(-)

diff --git a/net/smc/smc_core.h b/net/smc/smc_core.h
index 6d6fd1397c87..64d86298e4df 100644
--- a/net/smc/smc_core.h
+++ b/net/smc/smc_core.h
@@ -97,6 +97,7 @@ struct smc_link {
 	unsigned long		*wr_tx_mask;	/* bit mask of used indexes */
 	u32			wr_tx_cnt;	/* number of WR send buffers */
 	wait_queue_head_t	wr_tx_wait;	/* wait for free WR send buf */
+	atomic_t		wr_tx_refcnt;	/* tx refs to link */
 
 	struct smc_wr_buf	*wr_rx_bufs;	/* WR recv payload buffers */
 	struct ib_recv_wr	*wr_rx_ibs;	/* WR recv meta data */
@@ -109,6 +110,7 @@ struct smc_link {
 
 	struct ib_reg_wr	wr_reg;		/* WR register memory region */
 	wait_queue_head_t	wr_reg_wait;	/* wait for wr_reg result */
+	atomic_t		wr_reg_refcnt;	/* reg refs to link */
 	enum smc_wr_reg_state	wr_reg_state;	/* state of wr_reg request */
 
 	u8			gid[SMC_GID_SIZE];/* gid matching used vlan id*/
diff --git a/net/smc/smc_llc.c b/net/smc/smc_llc.c
index 273eaf1bfe49..2e7560eba981 100644
--- a/net/smc/smc_llc.c
+++ b/net/smc/smc_llc.c
@@ -888,6 +888,7 @@ int smc_llc_cli_add_link(struct smc_link *link, struct smc_llc_qentry *qentry)
 	if (!rc)
 		goto out;
 out_clear_lnk:
+	lnk_new->state = SMC_LNK_INACTIVE;
 	smcr_link_clear(lnk_new, false);
 out_reject:
 	smc_llc_cli_add_link_reject(qentry);
@@ -1184,6 +1185,7 @@ int smc_llc_srv_add_link(struct smc_link *link)
 		goto out_err;
 	return 0;
 out_err:
+	link_new->state = SMC_LNK_INACTIVE;
 	smcr_link_clear(link_new, false);
 	return rc;
 }
@@ -1286,10 +1288,8 @@ static void smc_llc_process_cli_delete_link(struct smc_link_group *lgr)
 	del_llc->reason = 0;
 	smc_llc_send_message(lnk, &qentry->msg); /* response */
 
-	if (smc_link_downing(&lnk_del->state)) {
-		if (smc_switch_conns(lgr, lnk_del, false))
-			smc_wr_tx_wait_no_pending_sends(lnk_del);
-	}
+	if (smc_link_downing(&lnk_del->state))
+		smc_switch_conns(lgr, lnk_del, false);
 	smcr_link_clear(lnk_del, true);
 
 	active_links = smc_llc_active_link_count(lgr);
@@ -1805,8 +1805,6 @@ void smc_llc_link_clear(struct smc_link *link, bool log)
 				    link->smcibdev->ibdev->name, link->ibport);
 	complete(&link->llc_testlink_resp);
 	cancel_delayed_work_sync(&link->llc_testlink_wrk);
-	smc_wr_wakeup_reg_wait(link);
-	smc_wr_wakeup_tx_wait(link);
 }
 
 /* register a new rtoken at the remote peer (for all links) */
diff --git a/net/smc/smc_tx.c b/net/smc/smc_tx.c
index 289025cd545a..c79361dfcdfb 100644
--- a/net/smc/smc_tx.c
+++ b/net/smc/smc_tx.c
@@ -496,7 +496,7 @@ static int smc_tx_rdma_writes(struct smc_connection *conn,
 /* Wakeup sndbuf consumers from any context (IRQ or process)
  * since there is more data to transmit; usable snd_wnd as max transmit
  */
-static int smcr_tx_sndbuf_nonempty(struct smc_connection *conn)
+static int _smcr_tx_sndbuf_nonempty(struct smc_connection *conn)
 {
 	struct smc_cdc_producer_flags *pflags = &conn->local_tx_ctrl.prod_flags;
 	struct smc_link *link = conn->lnk;
@@ -550,6 +550,22 @@ static int smcr_tx_sndbuf_nonempty(struct smc_connection *conn)
 	return rc;
 }
 
+static int smcr_tx_sndbuf_nonempty(struct smc_connection *conn)
+{
+	struct smc_link *link = conn->lnk;
+	int rc = -ENOLINK;
+
+	if (!link)
+		return rc;
+
+	atomic_inc(&link->wr_tx_refcnt);
+	if (smc_link_usable(link))
+		rc = _smcr_tx_sndbuf_nonempty(conn);
+	if (atomic_dec_and_test(&link->wr_tx_refcnt))
+		wake_up_all(&link->wr_tx_wait);
+	return rc;
+}
+
 static int smcd_tx_sndbuf_nonempty(struct smc_connection *conn)
 {
 	struct smc_cdc_producer_flags *pflags = &conn->local_tx_ctrl.prod_flags;
diff --git a/net/smc/smc_wr.c b/net/smc/smc_wr.c
index cbc73a7e4d59..a419e9af36b9 100644
--- a/net/smc/smc_wr.c
+++ b/net/smc/smc_wr.c
@@ -322,9 +322,12 @@ int smc_wr_reg_send(struct smc_link *link, struct ib_mr *mr)
 	if (rc)
 		return rc;
 
+	atomic_inc(&link->wr_reg_refcnt);
 	rc = wait_event_interruptible_timeout(link->wr_reg_wait,
 					      (link->wr_reg_state != POSTED),
 					      SMC_WR_REG_MR_WAIT_TIME);
+	if (atomic_dec_and_test(&link->wr_reg_refcnt))
+		wake_up_all(&link->wr_reg_wait);
 	if (!rc) {
 		/* timeout - terminate link */
 		smcr_link_down_cond_sched(link);
@@ -566,10 +569,15 @@ void smc_wr_free_link(struct smc_link *lnk)
 		return;
 	ibdev = lnk->smcibdev->ibdev;
 
+	smc_wr_wakeup_reg_wait(lnk);
+	smc_wr_wakeup_tx_wait(lnk);
+
 	if (smc_wr_tx_wait_no_pending_sends(lnk))
 		memset(lnk->wr_tx_mask, 0,
 		       BITS_TO_LONGS(SMC_WR_BUF_CNT) *
 						sizeof(*lnk->wr_tx_mask));
+	wait_event(lnk->wr_reg_wait, (!atomic_read(&lnk->wr_reg_refcnt)));
+	wait_event(lnk->wr_tx_wait, (!atomic_read(&lnk->wr_tx_refcnt)));
 
 	if (lnk->wr_rx_dma_addr) {
 		ib_dma_unmap_single(ibdev, lnk->wr_rx_dma_addr,
@@ -728,7 +736,9 @@ int smc_wr_create_link(struct smc_link *lnk)
 	memset(lnk->wr_tx_mask, 0,
 	       BITS_TO_LONGS(SMC_WR_BUF_CNT) * sizeof(*lnk->wr_tx_mask));
 	init_waitqueue_head(&lnk->wr_tx_wait);
+	atomic_set(&lnk->wr_tx_refcnt, 0);
 	init_waitqueue_head(&lnk->wr_reg_wait);
+	atomic_set(&lnk->wr_reg_refcnt, 0);
 	return rc;
 
 dma_unmap:
-- 
2.25.1

