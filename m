Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 565D850079F
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 09:53:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240552AbiDNHzU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 03:55:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240584AbiDNHzU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 03:55:20 -0400
Received: from out30-57.freemail.mail.aliyun.com (out30-57.freemail.mail.aliyun.com [115.124.30.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFEEB396AE;
        Thu, 14 Apr 2022 00:52:55 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04407;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0VA1SqbN_1649922771;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0VA1SqbN_1649922771)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 14 Apr 2022 15:52:52 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     kgraul@linux.ibm.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [PATCH net] net/smc: Fix sock leak when release after smc_shutdown()
Date:   Thu, 14 Apr 2022 15:51:03 +0800
Message-Id: <20220414075102.84366-1-tonylu@linux.alibaba.com>
X-Mailer: git-send-email 2.35.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H4,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since commit e5d5aadcf3cd ("net/smc: fix sk_refcnt underflow on linkdown
and fallback"), for a fallback connection, __smc_release() does not call
sock_put() if its state is already SMC_CLOSED.

When calling smc_shutdown() after falling back, its state is set to
SMC_CLOSED but does not call sock_put(), so this patch calls it.

Reported-and-tested-by: syzbot+6e29a053eb165bd50de5@syzkaller.appspotmail.com
Fixes: e5d5aadcf3cd ("net/smc: fix sk_refcnt underflow on linkdown and fallback")
Signed-off-by: Tony Lu <tonylu@linux.alibaba.com>
---
 net/smc/af_smc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index f0d118e9f155..f842425da6ec 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -2664,8 +2664,10 @@ static int smc_shutdown(struct socket *sock, int how)
 	if (smc->use_fallback) {
 		rc = kernel_sock_shutdown(smc->clcsock, how);
 		sk->sk_shutdown = smc->clcsock->sk->sk_shutdown;
-		if (sk->sk_shutdown == SHUTDOWN_MASK)
+		if (sk->sk_shutdown == SHUTDOWN_MASK) {
 			sk->sk_state = SMC_CLOSED;
+			sock_put(sk);
+		}
 		goto out;
 	}
 	switch (how) {
-- 
2.32.0.3.g01195cf9f

