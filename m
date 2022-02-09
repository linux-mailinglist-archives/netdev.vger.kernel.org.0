Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D1644AF3C7
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 15:11:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234583AbiBIOLS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 09:11:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231311AbiBIOLR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 09:11:17 -0500
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF4B5C061355;
        Wed,  9 Feb 2022 06:11:18 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=guwen@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0V4.d9qH_1644415855;
Received: from e02h04404.eu6sqa(mailfrom:guwen@linux.alibaba.com fp:SMTPD_---0V4.d9qH_1644415855)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 09 Feb 2022 22:11:15 +0800
From:   Wen Gu <guwen@linux.alibaba.com>
To:     kgraul@linux.ibm.com, davem@davemloft.net, kuba@kernel.org
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net] net/smc: Avoid overwriting the copies of clcsock callback functions
Date:   Wed,  9 Feb 2022 22:10:53 +0800
Message-Id: <1644415853-46641-1-git-send-email-guwen@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The callback functions of clcsock will be saved and replaced during
the fallback. But if the fallback happens more than once, then the
copies of these callback functions will be overwritten incorrectly,
resulting in a loop call issue:

clcsk->sk_error_report
 |- smc_fback_error_report() <------------------------------|
     |- smc_fback_forward_wakeup()                          | (loop)
         |- clcsock_callback()  (incorrectly overwritten)   |
             |- smc->clcsk_error_report() ------------------|

So this patch fixes the issue by saving these function pointers only
once in the fallback and avoiding overwriting.

Reported-by: syzbot+4de3c0e8a263e1e499bc@syzkaller.appspotmail.com
Fixes: 341adeec9ada ("net/smc: Forward wakeup to smc socket waitqueue after fallback")
Link: https://lore.kernel.org/r/0000000000006d045e05d78776f6@google.com
Signed-off-by: Wen Gu <guwen@linux.alibaba.com>
---
 net/smc/af_smc.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 8c89d0b..306d9e8c 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -667,14 +667,17 @@ static void smc_fback_error_report(struct sock *clcsk)
 static int smc_switch_to_fallback(struct smc_sock *smc, int reason_code)
 {
 	struct sock *clcsk;
+	int rc = 0;
 
 	mutex_lock(&smc->clcsock_release_lock);
 	if (!smc->clcsock) {
-		mutex_unlock(&smc->clcsock_release_lock);
-		return -EBADF;
+		rc = -EBADF;
+		goto out;
 	}
 	clcsk = smc->clcsock->sk;
 
+	if (smc->use_fallback)
+		goto out;
 	smc->use_fallback = true;
 	smc->fallback_rsn = reason_code;
 	smc_stat_fallback(smc);
@@ -702,8 +705,9 @@ static int smc_switch_to_fallback(struct smc_sock *smc, int reason_code)
 		smc->clcsock->sk->sk_user_data =
 			(void *)((uintptr_t)smc | SK_USER_DATA_NOCOPY);
 	}
+out:
 	mutex_unlock(&smc->clcsock_release_lock);
-	return 0;
+	return rc;
 }
 
 /* fall back during connect */
-- 
1.8.3.1

