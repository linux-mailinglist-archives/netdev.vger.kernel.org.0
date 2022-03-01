Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 742C94C885A
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 10:44:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234007AbiCAJpG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 04:45:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233975AbiCAJpE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 04:45:04 -0500
Received: from out30-44.freemail.mail.aliyun.com (out30-44.freemail.mail.aliyun.com [115.124.30.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82AB63BFA8;
        Tue,  1 Mar 2022 01:44:13 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=dust.li@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0V5wm1LL_1646127850;
Received: from localhost(mailfrom:dust.li@linux.alibaba.com fp:SMTPD_---0V5wm1LL_1646127850)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 01 Mar 2022 17:44:11 +0800
From:   Dust Li <dust.li@linux.alibaba.com>
To:     Karsten Graul <kgraul@linux.ibm.com>,
        Tony Lu <tonylu@linux.alibaba.com>,
        Guangguan Wang <guangguan.wang@linux.alibaba.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: [PATCH net-next 6/7] net/smc: don't req_notify until all CQEs drained
Date:   Tue,  1 Mar 2022 17:44:01 +0800
Message-Id: <20220301094402.14992-7-dust.li@linux.alibaba.com>
X-Mailer: git-send-email 2.19.1.3.ge56e4f7
In-Reply-To: <20220301094402.14992-1-dust.li@linux.alibaba.com>
References: <20220301094402.14992-1-dust.li@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When we are handling softirq workload, enable hardirq may
again interrupt the current routine of softirq, and then
try to raise softirq again. This only wastes CPU cycles
and won't have any real gain.

Since IB_CQ_REPORT_MISSED_EVENTS already make sure if
ib_req_notify_cq() returns 0, it is safe to wait for the
next event, with no need to poll the CQ again in this case.

This patch disables hardirq during the processing of softirq,
and re-arm the CQ after softirq is done. Somehow like NAPI.

Co-developed-by: Guangguan Wang <guangguan.wang@linux.alibaba.com>
Signed-off-by: Guangguan Wang <guangguan.wang@linux.alibaba.com>
Signed-off-by: Dust Li <dust.li@linux.alibaba.com>
---
 net/smc/smc_wr.c | 49 +++++++++++++++++++++++++++---------------------
 1 file changed, 28 insertions(+), 21 deletions(-)

diff --git a/net/smc/smc_wr.c b/net/smc/smc_wr.c
index 24be1d03fef9..34d616406d51 100644
--- a/net/smc/smc_wr.c
+++ b/net/smc/smc_wr.c
@@ -137,25 +137,28 @@ static void smc_wr_tx_tasklet_fn(struct tasklet_struct *t)
 {
 	struct smc_ib_device *dev = from_tasklet(dev, t, send_tasklet);
 	struct ib_wc wc[SMC_WR_MAX_POLL_CQE];
-	int i = 0, rc;
-	int polled = 0;
+	int i, rc;
 
 again:
-	polled++;
 	do {
 		memset(&wc, 0, sizeof(wc));
 		rc = ib_poll_cq(dev->roce_cq_send, SMC_WR_MAX_POLL_CQE, wc);
-		if (polled == 1) {
-			ib_req_notify_cq(dev->roce_cq_send,
-					 IB_CQ_NEXT_COMP |
-					 IB_CQ_REPORT_MISSED_EVENTS);
-		}
-		if (!rc)
-			break;
 		for (i = 0; i < rc; i++)
 			smc_wr_tx_process_cqe(&wc[i]);
+		if (rc < SMC_WR_MAX_POLL_CQE)
+			/* If < SMC_WR_MAX_POLL_CQE, the CQ should have been
+			 * drained, no need to poll again. --Guangguan Wang
+			 */
+			break;
 	} while (rc > 0);
-	if (polled == 1)
+
+	/* IB_CQ_REPORT_MISSED_EVENTS make sure if ib_req_notify_cq() returns
+	 * 0, it is safe to wait for the next event.
+	 * Else we must poll the CQ again to make sure we won't miss any event
+	 */
+	if (ib_req_notify_cq(dev->roce_cq_send,
+			     IB_CQ_NEXT_COMP |
+			     IB_CQ_REPORT_MISSED_EVENTS))
 		goto again;
 }
 
@@ -478,24 +481,28 @@ static void smc_wr_rx_tasklet_fn(struct tasklet_struct *t)
 {
 	struct smc_ib_device *dev = from_tasklet(dev, t, recv_tasklet);
 	struct ib_wc wc[SMC_WR_MAX_POLL_CQE];
-	int polled = 0;
 	int rc;
 
 again:
-	polled++;
 	do {
 		memset(&wc, 0, sizeof(wc));
 		rc = ib_poll_cq(dev->roce_cq_recv, SMC_WR_MAX_POLL_CQE, wc);
-		if (polled == 1) {
-			ib_req_notify_cq(dev->roce_cq_recv,
-					 IB_CQ_SOLICITED_MASK
-					 | IB_CQ_REPORT_MISSED_EVENTS);
-		}
-		if (!rc)
+		if (rc > 0)
+			smc_wr_rx_process_cqes(&wc[0], rc);
+		if (rc < SMC_WR_MAX_POLL_CQE)
+			/* If < SMC_WR_MAX_POLL_CQE, the CQ should have been
+			 * drained, no need to poll again. --Guangguan Wang
+			 */
 			break;
-		smc_wr_rx_process_cqes(&wc[0], rc);
 	} while (rc > 0);
-	if (polled == 1)
+
+	/* IB_CQ_REPORT_MISSED_EVENTS make sure if ib_req_notify_cq() returns
+	 * 0, it is safe to wait for the next event.
+	 * Else we must poll the CQ again to make sure we won't miss any event
+	 */
+	if (ib_req_notify_cq(dev->roce_cq_recv,
+			     IB_CQ_SOLICITED_MASK |
+			     IB_CQ_REPORT_MISSED_EVENTS))
 		goto again;
 }
 
-- 
2.19.1.3.ge56e4f7

