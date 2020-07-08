Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7778218AC1
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 17:05:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730111AbgGHPF2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 11:05:28 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:64758 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730072AbgGHPFZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 11:05:25 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 068F1wuL058378;
        Wed, 8 Jul 2020 11:05:25 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 325g7grhvj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Jul 2020 11:05:22 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 068Ent3w003381;
        Wed, 8 Jul 2020 15:05:20 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03ams.nl.ibm.com with ESMTP id 322hd7vq1h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Jul 2020 15:05:20 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 068F5HqZ21823496
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 8 Jul 2020 15:05:17 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 94E68AE04D;
        Wed,  8 Jul 2020 15:05:17 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 634D1AE057;
        Wed,  8 Jul 2020 15:05:17 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  8 Jul 2020 15:05:17 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net 2/5] net/smc: fix work request handling
Date:   Wed,  8 Jul 2020 17:05:12 +0200
Message-Id: <20200708150515.44938-3-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200708150515.44938-1-kgraul@linux.ibm.com>
References: <20200708150515.44938-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-08_12:2020-07-08,2020-07-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 phishscore=0 mlxlogscore=999 cotscore=-2147483648 suspectscore=3
 mlxscore=0 bulkscore=0 adultscore=0 clxscore=1015 lowpriorityscore=0
 impostorscore=0 spamscore=0 malwarescore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2007080103
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wait for pending sends only when smc_switch_conns() found a link to move
the connections to. Do not wait during link freeing, this can lead to
permanent hang situations. And refuse to provide a new tx slot on an
unusable link.

Fixes: c6f02ebeea3a ("net/smc: switch connections to alternate link")
Reviewed-by: Ursula Braun <ubraun@linux.ibm.com>
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 net/smc/smc_llc.c |  8 ++++----
 net/smc/smc_wr.c  | 10 ++++++----
 2 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/net/smc/smc_llc.c b/net/smc/smc_llc.c
index df164232574b..c1a038689c63 100644
--- a/net/smc/smc_llc.c
+++ b/net/smc/smc_llc.c
@@ -1241,8 +1241,8 @@ static void smc_llc_process_cli_delete_link(struct smc_link_group *lgr)
 	smc_llc_send_message(lnk, &qentry->msg); /* response */
 
 	if (smc_link_downing(&lnk_del->state)) {
-		smc_switch_conns(lgr, lnk_del, false);
-		smc_wr_tx_wait_no_pending_sends(lnk_del);
+		if (smc_switch_conns(lgr, lnk_del, false))
+			smc_wr_tx_wait_no_pending_sends(lnk_del);
 	}
 	smcr_link_clear(lnk_del, true);
 
@@ -1316,8 +1316,8 @@ static void smc_llc_process_srv_delete_link(struct smc_link_group *lgr)
 		goto out; /* asymmetric link already deleted */
 
 	if (smc_link_downing(&lnk_del->state)) {
-		smc_switch_conns(lgr, lnk_del, false);
-		smc_wr_tx_wait_no_pending_sends(lnk_del);
+		if (smc_switch_conns(lgr, lnk_del, false))
+			smc_wr_tx_wait_no_pending_sends(lnk_del);
 	}
 	if (!list_empty(&lgr->list)) {
 		/* qentry is either a request from peer (send it back to
diff --git a/net/smc/smc_wr.c b/net/smc/smc_wr.c
index 7239ba9b99dc..1e23cdd41eb1 100644
--- a/net/smc/smc_wr.c
+++ b/net/smc/smc_wr.c
@@ -169,6 +169,8 @@ void smc_wr_tx_cq_handler(struct ib_cq *ib_cq, void *cq_context)
 static inline int smc_wr_tx_get_free_slot_index(struct smc_link *link, u32 *idx)
 {
 	*idx = link->wr_tx_cnt;
+	if (!smc_link_usable(link))
+		return -ENOLINK;
 	for_each_clear_bit(*idx, link->wr_tx_mask, link->wr_tx_cnt) {
 		if (!test_and_set_bit(*idx, link->wr_tx_mask))
 			return 0;
@@ -560,15 +562,15 @@ void smc_wr_free_link(struct smc_link *lnk)
 {
 	struct ib_device *ibdev;
 
+	if (!lnk->smcibdev)
+		return;
+	ibdev = lnk->smcibdev->ibdev;
+
 	if (smc_wr_tx_wait_no_pending_sends(lnk))
 		memset(lnk->wr_tx_mask, 0,
 		       BITS_TO_LONGS(SMC_WR_BUF_CNT) *
 						sizeof(*lnk->wr_tx_mask));
 
-	if (!lnk->smcibdev)
-		return;
-	ibdev = lnk->smcibdev->ibdev;
-
 	if (lnk->wr_rx_dma_addr) {
 		ib_dma_unmap_single(ibdev, lnk->wr_rx_dma_addr,
 				    SMC_WR_BUF_SIZE * lnk->wr_rx_cnt,
-- 
2.17.1

