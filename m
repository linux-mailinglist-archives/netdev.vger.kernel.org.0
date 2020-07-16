Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 817FD222734
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 17:38:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729231AbgGPPiW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 11:38:22 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:62332 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728837AbgGPPiG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 11:38:06 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06GFYgpW091832;
        Thu, 16 Jul 2020 11:38:05 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32afd6m3xt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Jul 2020 11:38:05 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 06GFYr17013662;
        Thu, 16 Jul 2020 15:38:02 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 327527wrnx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Jul 2020 15:38:02 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 06GFbvcd58327044
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jul 2020 15:37:57 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4139F4204B;
        Thu, 16 Jul 2020 15:37:57 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 01CCE42041;
        Thu, 16 Jul 2020 15:37:57 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 16 Jul 2020 15:37:56 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net 08/10] net/smc: do not call dma sync for unmapped memory
Date:   Thu, 16 Jul 2020 17:37:44 +0200
Message-Id: <20200716153746.77303-9-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200716153746.77303-1-kgraul@linux.ibm.com>
References: <20200716153746.77303-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-16_07:2020-07-16,2020-07-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 priorityscore=1501 mlxlogscore=999 lowpriorityscore=0 mlxscore=0
 spamscore=0 phishscore=0 adultscore=0 bulkscore=0 impostorscore=0
 suspectscore=1 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2007160114
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The dma related ...sync_sg... functions check the link state before the
dma function is actually called. But the check in smc_link_usable()
allows links in ACTIVATING state which are not yet mapped to dma memory.
Under high load it may happen that the sync_sg functions are called for
such a link which results in an debug output like
   DMA-API: mlx5_core 0002:00:00.0: device driver tries to sync
   DMA memory it has not allocated [device address=0x0000000103370000]
   [size=65536 bytes]
To fix that introduce a helper to check for the link state ACTIVE and
use it where appropriate. And move the link state update to ACTIVATING
to the end of smcr_link_init() when most initial setup is done.

Reviewed-by: Ursula Braun <ubraun@linux.ibm.com>
Fixes: d854fcbfaeda ("net/smc: add new link state and related helpers")
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 net/smc/af_smc.c   |  2 +-
 net/smc/smc_core.c | 15 +++++++--------
 net/smc/smc_core.h |  5 +++++
 net/smc/smc_llc.c  | 10 +++++-----
 4 files changed, 18 insertions(+), 14 deletions(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index f80591567a3d..d091509b5982 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -352,7 +352,7 @@ static int smcr_lgr_reg_rmbs(struct smc_link *link,
 	 */
 	mutex_lock(&lgr->llc_conf_mutex);
 	for (i = 0; i < SMC_LINKS_PER_LGR_MAX; i++) {
-		if (lgr->lnk[i].state != SMC_LNK_ACTIVE)
+		if (!smc_link_active(&lgr->lnk[i]))
 			continue;
 		rc = smcr_link_reg_rmb(&lgr->lnk[i], rmb_desc);
 		if (rc)
diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index 2e965de7412d..42ba227f3e97 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -318,7 +318,6 @@ int smcr_link_init(struct smc_link_group *lgr, struct smc_link *lnk,
 
 	get_device(&ini->ib_dev->ibdev->dev);
 	atomic_inc(&ini->ib_dev->lnk_cnt);
-	lnk->state = SMC_LNK_ACTIVATING;
 	lnk->link_id = smcr_next_link_id(lgr);
 	lnk->lgr = lgr;
 	lnk->link_idx = link_idx;
@@ -354,6 +353,7 @@ int smcr_link_init(struct smc_link_group *lgr, struct smc_link *lnk,
 	rc = smc_wr_create_link(lnk);
 	if (rc)
 		goto destroy_qp;
+	lnk->state = SMC_LNK_ACTIVATING;
 	return 0;
 
 destroy_qp:
@@ -542,8 +542,7 @@ struct smc_link *smc_switch_conns(struct smc_link_group *lgr,
 	smc_wr_wakeup_tx_wait(from_lnk);
 
 	for (i = 0; i < SMC_LINKS_PER_LGR_MAX; i++) {
-		if (lgr->lnk[i].state != SMC_LNK_ACTIVE ||
-		    i == from_lnk->link_idx)
+		if (!smc_link_active(&lgr->lnk[i]) || i == from_lnk->link_idx)
 			continue;
 		if (is_dev_err && from_lnk->smcibdev == lgr->lnk[i].smcibdev &&
 		    from_lnk->ibport == lgr->lnk[i].ibport) {
@@ -1269,7 +1268,7 @@ static bool smcr_lgr_match(struct smc_link_group *lgr,
 		return false;
 
 	for (i = 0; i < SMC_LINKS_PER_LGR_MAX; i++) {
-		if (lgr->lnk[i].state != SMC_LNK_ACTIVE)
+		if (!smc_link_active(&lgr->lnk[i]))
 			continue;
 		if ((lgr->role == SMC_SERV || lgr->lnk[i].peer_qpn == clcqpn) &&
 		    !memcmp(lgr->lnk[i].peer_gid, &lcl->gid, SMC_GID_SIZE) &&
@@ -1717,14 +1716,14 @@ static int __smc_buf_create(struct smc_sock *smc, bool is_smcd, bool is_rmb)
 
 void smc_sndbuf_sync_sg_for_cpu(struct smc_connection *conn)
 {
-	if (!conn->lgr || conn->lgr->is_smcd || !smc_link_usable(conn->lnk))
+	if (!conn->lgr || conn->lgr->is_smcd || !smc_link_active(conn->lnk))
 		return;
 	smc_ib_sync_sg_for_cpu(conn->lnk, conn->sndbuf_desc, DMA_TO_DEVICE);
 }
 
 void smc_sndbuf_sync_sg_for_device(struct smc_connection *conn)
 {
-	if (!conn->lgr || conn->lgr->is_smcd || !smc_link_usable(conn->lnk))
+	if (!conn->lgr || conn->lgr->is_smcd || !smc_link_active(conn->lnk))
 		return;
 	smc_ib_sync_sg_for_device(conn->lnk, conn->sndbuf_desc, DMA_TO_DEVICE);
 }
@@ -1736,7 +1735,7 @@ void smc_rmb_sync_sg_for_cpu(struct smc_connection *conn)
 	if (!conn->lgr || conn->lgr->is_smcd)
 		return;
 	for (i = 0; i < SMC_LINKS_PER_LGR_MAX; i++) {
-		if (!smc_link_usable(&conn->lgr->lnk[i]))
+		if (!smc_link_active(&conn->lgr->lnk[i]))
 			continue;
 		smc_ib_sync_sg_for_cpu(&conn->lgr->lnk[i], conn->rmb_desc,
 				       DMA_FROM_DEVICE);
@@ -1750,7 +1749,7 @@ void smc_rmb_sync_sg_for_device(struct smc_connection *conn)
 	if (!conn->lgr || conn->lgr->is_smcd)
 		return;
 	for (i = 0; i < SMC_LINKS_PER_LGR_MAX; i++) {
-		if (!smc_link_usable(&conn->lgr->lnk[i]))
+		if (!smc_link_active(&conn->lgr->lnk[i]))
 			continue;
 		smc_ib_sync_sg_for_device(&conn->lgr->lnk[i], conn->rmb_desc,
 					  DMA_FROM_DEVICE);
diff --git a/net/smc/smc_core.h b/net/smc/smc_core.h
index c3ff512fd891..1c4d5439d0ff 100644
--- a/net/smc/smc_core.h
+++ b/net/smc/smc_core.h
@@ -349,6 +349,11 @@ static inline bool smc_link_usable(struct smc_link *lnk)
 	return true;
 }
 
+static inline bool smc_link_active(struct smc_link *lnk)
+{
+	return lnk->state == SMC_LNK_ACTIVE;
+}
+
 struct smc_sock;
 struct smc_clc_msg_accept_confirm;
 struct smc_clc_msg_local;
diff --git a/net/smc/smc_llc.c b/net/smc/smc_llc.c
index fa8cd57a9b32..df5b0a6ea848 100644
--- a/net/smc/smc_llc.c
+++ b/net/smc/smc_llc.c
@@ -428,7 +428,7 @@ static int smc_llc_send_confirm_rkey(struct smc_link *send_link,
 	rtok_ix = 1;
 	for (i = 0; i < SMC_LINKS_PER_LGR_MAX; i++) {
 		link = &send_link->lgr->lnk[i];
-		if (link->state == SMC_LNK_ACTIVE && link != send_link) {
+		if (smc_link_active(link) && link != send_link) {
 			rkeyllc->rtoken[rtok_ix].link_id = link->link_id;
 			rkeyllc->rtoken[rtok_ix].rmb_key =
 				htonl(rmb_desc->mr_rx[link->link_idx]->rkey);
@@ -944,7 +944,7 @@ static int smc_llc_active_link_count(struct smc_link_group *lgr)
 	int i, link_count = 0;
 
 	for (i = 0; i < SMC_LINKS_PER_LGR_MAX; i++) {
-		if (!smc_link_usable(&lgr->lnk[i]))
+		if (!smc_link_active(&lgr->lnk[i]))
 			continue;
 		link_count++;
 	}
@@ -1622,7 +1622,7 @@ static void smc_llc_rx_response(struct smc_link *link,
 
 	switch (llc_type) {
 	case SMC_LLC_TEST_LINK:
-		if (link->state == SMC_LNK_ACTIVE)
+		if (smc_link_active(link))
 			complete(&link->llc_testlink_resp);
 		break;
 	case SMC_LLC_ADD_LINK:
@@ -1706,7 +1706,7 @@ static void smc_llc_testlink_work(struct work_struct *work)
 	u8 user_data[16] = { 0 };
 	int rc;
 
-	if (link->state != SMC_LNK_ACTIVE)
+	if (!smc_link_active(link))
 		return;		/* don't reschedule worker */
 	expire_time = link->wr_rx_tstamp + link->llc_testlink_time;
 	if (time_is_after_jiffies(expire_time)) {
@@ -1718,7 +1718,7 @@ static void smc_llc_testlink_work(struct work_struct *work)
 	/* receive TEST LINK response over RoCE fabric */
 	rc = wait_for_completion_interruptible_timeout(&link->llc_testlink_resp,
 						       SMC_LLC_WAIT_TIME);
-	if (link->state != SMC_LNK_ACTIVE)
+	if (!smc_link_active(link))
 		return;		/* link state changed */
 	if (rc <= 0) {
 		smcr_link_down_cond_sched(link);
-- 
2.17.1

