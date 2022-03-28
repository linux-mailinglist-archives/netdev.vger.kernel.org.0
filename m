Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 446EE4E8DDD
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 08:11:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235718AbiC1GMj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 02:12:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238303AbiC1GMf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 02:12:35 -0400
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87D0C515BC;
        Sun, 27 Mar 2022 23:10:52 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04407;MF=guwen@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0V8LmJtm_1648447836;
Received: from e02h04404.eu6sqa(mailfrom:guwen@linux.alibaba.com fp:SMTPD_---0V8LmJtm_1648447836)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 28 Mar 2022 14:10:50 +0800
From:   Wen Gu <guwen@linux.alibaba.com>
To:     kgraul@linux.ibm.com, davem@davemloft.net, kuba@kernel.org,
        dust.li@linux.alibaba.com
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net] net/smc: Send out the remaining data in sndbuf before close
Date:   Mon, 28 Mar 2022 14:10:36 +0800
Message-Id: <1648447836-111521-1-git-send-email-guwen@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
X-Spam-Status: No, score=-10.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current autocork algorithms will delay the data transmission
in BH context to smc_release_cb() when sock_lock is hold by user.

So there is a possibility that when connection is being actively
closed (sock_lock is hold by user now), some corked data still
remains in sndbuf, waiting to be sent by smc_release_cb(). This
will cause:

- smc_close_stream_wait(), which is called under the sock_lock,
  has a high probability of timeout because data transmission is
  delayed until sock_lock is released.

- Unexpected data sends may happen after connction closed and use
  the rtoken which has been deleted by remote peer through
  LLC_DELETE_RKEY messages.

So this patch will try to send out the remaining corked data in
sndbuf before active close process, to ensure data integrity and
avoid unexpected data transmission after close.

Reported-by: Guangguan Wang <guangguan.wang@linux.alibaba.com>
Fixes: 6b88af839d20 ("net/smc: don't send in the BH context if sock_owned_by_user")
Signed-off-by: Wen Gu <guwen@linux.alibaba.com>
---
 net/smc/smc_close.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/smc/smc_close.c b/net/smc/smc_close.c
index 292e4d9..676cb23 100644
--- a/net/smc/smc_close.c
+++ b/net/smc/smc_close.c
@@ -57,6 +57,9 @@ static void smc_close_stream_wait(struct smc_sock *smc, long timeout)
 	if (!smc_tx_prepared_sends(&smc->conn))
 		return;
 
+	/* Send out corked data remaining in sndbuf */
+	smc_tx_pending(&smc->conn);
+
 	smc->wait_close_tx_prepared = 1;
 	add_wait_queue(sk_sleep(sk), &wait);
 	while (!signal_pending(current) && timeout) {
-- 
1.8.3.1

