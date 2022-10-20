Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBF2E6057A5
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 08:45:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230195AbiJTGoW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 02:44:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230190AbiJTGoH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 02:44:07 -0400
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBD4B1C25CC;
        Wed, 19 Oct 2022 23:44:05 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R861e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046050;MF=alibuda@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0VSdzyKD_1666248242;
Received: from j66a10360.sqa.eu95.tbsite.net(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0VSdzyKD_1666248242)
          by smtp.aliyun-inc.com;
          Thu, 20 Oct 2022 14:44:03 +0800
From:   "D.Wythe" <alibuda@linux.alibaba.com>
To:     kgraul@linux.ibm.com, wenjia@linux.ibm.com, jaka@linux.ibm.com
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: [PATCH net-next v3 10/10] net/smc: fix application data exception
Date:   Thu, 20 Oct 2022 14:43:52 +0800
Message-Id: <1666248232-63751-11-git-send-email-alibuda@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1666248232-63751-1-git-send-email-alibuda@linux.alibaba.com>
References: <1666248232-63751-1-git-send-email-alibuda@linux.alibaba.com>
X-Spam-Status: No, score=-8.7 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NORMAL_HTTP_TO_IP,NUMERIC_HTTP_ADDR,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
        URIBL_BLOCKED,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "D. Wythe" <alibuda@linux.alibaba.com>

After we optimize the parallel capability of SMC-R connection
establishment, There is a certain probability that following
exceptions will occur in the wrk benchmark test:

Running 10s test @ http://11.213.45.6:80
  8 threads and 64 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency     3.72ms   13.94ms 245.33ms   94.17%
    Req/Sec     1.96k   713.67     5.41k    75.16%
  155262 requests in 10.10s, 23.10MB read
Non-2xx or 3xx responses: 3

We will find that the error is HTTP 400 error, which is a serious
exception in our test, which means the application data was
corrupted.

Consider the following scenarios:

CPU0                            CPU1

buf_desc->used = 0;
                                cmpxchg(buf_desc->used, 0, 1)
                                deal_with(buf_desc)

memset(buf_desc->cpu_addr,0);

This will cause the data received by a victim connection to be cleared,
thus triggering an HTTP 400 error in the server.

This patch exchange the order between clear used and memset, add
barrier to ensure memory consistency.

Fixes: 1c5526968e27 ("net/smc: Clear memory when release and reuse buffer")
Signed-off-by: D. Wythe <alibuda@linux.alibaba.com>
---
 net/smc/smc_core.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index 42f3aae..d20a6dd 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -1401,8 +1401,9 @@ static void smcr_buf_unuse(struct smc_buf_desc *buf_desc, bool is_rmb,
 
 		smc_buf_free(lgr, is_rmb, buf_desc);
 	} else {
-		buf_desc->used = 0;
-		memset(buf_desc->cpu_addr, 0, buf_desc->len);
+		/* memzero_explicit provides potential memory barrier semantics */
+		memzero_explicit(buf_desc->cpu_addr, buf_desc->len);
+		WRITE_ONCE(buf_desc->used, 0);
 	}
 }
 
@@ -1413,19 +1414,17 @@ static void smc_buf_unuse(struct smc_connection *conn,
 		if (!lgr->is_smcd && conn->sndbuf_desc->is_vm) {
 			smcr_buf_unuse(conn->sndbuf_desc, false, lgr);
 		} else {
-			conn->sndbuf_desc->used = 0;
-			memset(conn->sndbuf_desc->cpu_addr, 0,
-			       conn->sndbuf_desc->len);
+			memzero_explicit(conn->sndbuf_desc->cpu_addr, conn->sndbuf_desc->len);
+			WRITE_ONCE(conn->sndbuf_desc->used, 0);
 		}
 	}
 	if (conn->rmb_desc) {
 		if (!lgr->is_smcd) {
 			smcr_buf_unuse(conn->rmb_desc, true, lgr);
 		} else {
-			conn->rmb_desc->used = 0;
-			memset(conn->rmb_desc->cpu_addr, 0,
-			       conn->rmb_desc->len +
-			       sizeof(struct smcd_cdc_msg));
+			memzero_explicit(conn->rmb_desc->cpu_addr,
+					 conn->rmb_desc->len + sizeof(struct smcd_cdc_msg));
+			WRITE_ONCE(conn->rmb_desc->used, 0);
 		}
 	}
 }
-- 
1.8.3.1

