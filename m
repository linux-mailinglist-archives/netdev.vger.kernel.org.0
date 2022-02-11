Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7D5D4B20DD
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 10:01:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238372AbiBKJAh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 04:00:37 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231669AbiBKJAh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 04:00:37 -0500
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D90D218;
        Fri, 11 Feb 2022 01:00:36 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R561e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0V48QsEz_1644570033;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0V48QsEz_1644570033)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 11 Feb 2022 17:00:34 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     raspl@linux.ibm.com
Cc:     kgraul@linux.ibm.com, kuba@kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [PATCH net-next] net/smc: Add comment for smc_tx_pending
Date:   Fri, 11 Feb 2022 14:52:21 +0800
Message-Id: <20220211065220.88196-1-tonylu@linux.alibaba.com>
X-Mailer: git-send-email 2.35.0
In-Reply-To: <74aaa8ce-81a4-b048-cee2-b137279d13d5@linux.ibm.com>
References: <74aaa8ce-81a4-b048-cee2-b137279d13d5@linux.ibm.com>
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

The previous patch introduces a lock-free version of smc_tx_work() to
solve unnecessary lock contention, which is expected to be held lock.
So this adds comment to remind people to keep an eye out for locks.

Suggested-by: Stefan Raspl <raspl@linux.ibm.com>
Signed-off-by: Tony Lu <tonylu@linux.alibaba.com>
---
 net/smc/smc_tx.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/smc/smc_tx.c b/net/smc/smc_tx.c
index a96ce162825e..5df3940d4543 100644
--- a/net/smc/smc_tx.c
+++ b/net/smc/smc_tx.c
@@ -611,6 +611,10 @@ int smc_tx_sndbuf_nonempty(struct smc_connection *conn)
 	return rc;
 }
 
+/* Wakeup sndbuf consumers from process context
+ * since there is more data to transmit. The caller
+ * must hold sock lock.
+ */
 void smc_tx_pending(struct smc_connection *conn)
 {
 	struct smc_sock *smc = container_of(conn, struct smc_sock, conn);
@@ -626,7 +630,8 @@ void smc_tx_pending(struct smc_connection *conn)
 }
 
 /* Wakeup sndbuf consumers from process context
- * since there is more data to transmit
+ * since there is more data to transmit in locked
+ * sock.
  */
 void smc_tx_work(struct work_struct *work)
 {
-- 
2.32.0.3.g01195cf9f

