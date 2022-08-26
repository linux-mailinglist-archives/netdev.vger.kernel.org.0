Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7542D5A251D
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 11:53:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344073AbiHZJwm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 05:52:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343698AbiHZJwG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 05:52:06 -0400
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BBBCD86E6;
        Fri, 26 Aug 2022 02:52:04 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R901e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045168;MF=alibuda@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0VNIZJ2f_1661507520;
Received: from localhost(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0VNIZJ2f_1661507520)
          by smtp.aliyun-inc.com;
          Fri, 26 Aug 2022 17:52:01 +0800
From:   "D. Wythe" <alibuda@linux.alibaba.com>
To:     kgraul@linux.ibm.com, wenjia@linux.ibm.com
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org,
        "D. Wythe" <alibuda@linux.alibaba.com>
Subject: [PATCH net-next v2 10/10] net/smc: fix application data exception
Date:   Fri, 26 Aug 2022 17:51:37 +0800
Message-Id: <e590ca91e24d002608df29d100d4139977d0bcb6.1661407821.git.alibuda@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <cover.1661407821.git.alibuda@linux.alibaba.com>
References: <cover.1661407821.git.alibuda@linux.alibaba.com>
X-Spam-Status: No, score=-8.7 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NORMAL_HTTP_TO_IP,NUMERIC_HTTP_ADDR,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
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
 net/smc/smc_core.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index 84bf84c..fdad953 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -1380,8 +1380,9 @@ static void smcr_buf_unuse(struct smc_buf_desc *buf_desc, bool is_rmb,
 
 		smc_buf_free(lgr, is_rmb, buf_desc);
 	} else {
-		buf_desc->used = 0;
-		memset(buf_desc->cpu_addr, 0, buf_desc->len);
+		/* memzero_explicit provides potential memory barrier semantics */
+		memzero_explicit(buf_desc->cpu_addr, buf_desc->len);
+		WRITE_ONCE(buf_desc->used, 0);
 	}
 }
 
-- 
1.8.3.1

