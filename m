Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E93784CD0E7
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 10:17:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231334AbiCDJSN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 04:18:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237169AbiCDJSL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 04:18:11 -0500
Received: from out30-54.freemail.mail.aliyun.com (out30-54.freemail.mail.aliyun.com [115.124.30.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97A951A6141;
        Fri,  4 Mar 2022 01:17:23 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=dust.li@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0V6BiGIw_1646385440;
Received: from localhost(mailfrom:dust.li@linux.alibaba.com fp:SMTPD_---0V6BiGIw_1646385440)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 04 Mar 2022 17:17:21 +0800
From:   Dust Li <dust.li@linux.alibaba.com>
To:     Karsten Graul <kgraul@linux.ibm.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     Guangguan Wang <guangguan.wang@linux.alibaba.com>,
        Leon Romanovsky <leon@kernel.org>, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: [PATCH net-next] Revert "net/smc: don't req_notify until all CQEs drained"
Date:   Fri,  4 Mar 2022 17:17:19 +0800
Message-Id: <20220304091719.48340-1-dust.li@linux.alibaba.com>
X-Mailer: git-send-email 2.19.1.3.ge56e4f7
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

This reverts commit a505cce6f7cfaf2aa2385aab7286063c96444526.

Leon says:
  We already discussed that. SMC should be changed to use
  RDMA CQ pool API
  drivers/infiniband/core/cq.c.
  ib_poll_handler() has much better implementation (tracing,
  IRQ rescheduling, proper error handling) than this SMC variant.

Since we will switch to ib_poll_handler() in the future,
revert this patch.

Link: https://lore.kernel.org/netdev/20220301105332.GA9417@linux.alibaba.com/
Suggested-by: Leon Romanovsky <leon@kernel.org>
Suggested-by: Karsten Graul <kgraul@linux.ibm.com>
Signed-off-by: Dust Li <dust.li@linux.alibaba.com>
---
 net/smc/smc_wr.c | 49 +++++++++++++++++++++---------------------------
 1 file changed, 21 insertions(+), 28 deletions(-)

diff --git a/net/smc/smc_wr.c b/net/smc/smc_wr.c
index 34d616406d51..24be1d03fef9 100644
--- a/net/smc/smc_wr.c
+++ b/net/smc/smc_wr.c
@@ -137,28 +137,25 @@ static void smc_wr_tx_tasklet_fn(struct tasklet_struct *t)
 {
 	struct smc_ib_device *dev = from_tasklet(dev, t, send_tasklet);
 	struct ib_wc wc[SMC_WR_MAX_POLL_CQE];
-	int i, rc;
+	int i = 0, rc;
+	int polled = 0;
 
 again:
+	polled++;
 	do {
 		memset(&wc, 0, sizeof(wc));
 		rc = ib_poll_cq(dev->roce_cq_send, SMC_WR_MAX_POLL_CQE, wc);
+		if (polled == 1) {
+			ib_req_notify_cq(dev->roce_cq_send,
+					 IB_CQ_NEXT_COMP |
+					 IB_CQ_REPORT_MISSED_EVENTS);
+		}
+		if (!rc)
+			break;
 		for (i = 0; i < rc; i++)
 			smc_wr_tx_process_cqe(&wc[i]);
-		if (rc < SMC_WR_MAX_POLL_CQE)
-			/* If < SMC_WR_MAX_POLL_CQE, the CQ should have been
-			 * drained, no need to poll again. --Guangguan Wang
-			 */
-			break;
 	} while (rc > 0);
-
-	/* IB_CQ_REPORT_MISSED_EVENTS make sure if ib_req_notify_cq() returns
-	 * 0, it is safe to wait for the next event.
-	 * Else we must poll the CQ again to make sure we won't miss any event
-	 */
-	if (ib_req_notify_cq(dev->roce_cq_send,
-			     IB_CQ_NEXT_COMP |
-			     IB_CQ_REPORT_MISSED_EVENTS))
+	if (polled == 1)
 		goto again;
 }
 
@@ -481,28 +478,24 @@ static void smc_wr_rx_tasklet_fn(struct tasklet_struct *t)
 {
 	struct smc_ib_device *dev = from_tasklet(dev, t, recv_tasklet);
 	struct ib_wc wc[SMC_WR_MAX_POLL_CQE];
+	int polled = 0;
 	int rc;
 
 again:
+	polled++;
 	do {
 		memset(&wc, 0, sizeof(wc));
 		rc = ib_poll_cq(dev->roce_cq_recv, SMC_WR_MAX_POLL_CQE, wc);
-		if (rc > 0)
-			smc_wr_rx_process_cqes(&wc[0], rc);
-		if (rc < SMC_WR_MAX_POLL_CQE)
-			/* If < SMC_WR_MAX_POLL_CQE, the CQ should have been
-			 * drained, no need to poll again. --Guangguan Wang
-			 */
+		if (polled == 1) {
+			ib_req_notify_cq(dev->roce_cq_recv,
+					 IB_CQ_SOLICITED_MASK
+					 | IB_CQ_REPORT_MISSED_EVENTS);
+		}
+		if (!rc)
 			break;
+		smc_wr_rx_process_cqes(&wc[0], rc);
 	} while (rc > 0);
-
-	/* IB_CQ_REPORT_MISSED_EVENTS make sure if ib_req_notify_cq() returns
-	 * 0, it is safe to wait for the next event.
-	 * Else we must poll the CQ again to make sure we won't miss any event
-	 */
-	if (ib_req_notify_cq(dev->roce_cq_recv,
-			     IB_CQ_SOLICITED_MASK |
-			     IB_CQ_REPORT_MISSED_EVENTS))
+	if (polled == 1)
 		goto again;
 }
 
-- 
2.19.1.3.ge56e4f7

