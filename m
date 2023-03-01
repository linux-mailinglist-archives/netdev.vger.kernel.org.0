Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79D396A643F
	for <lists+netdev@lfdr.de>; Wed,  1 Mar 2023 01:29:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229582AbjCAA3E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 19:29:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbjCAA3D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 19:29:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F7262103;
        Tue, 28 Feb 2023 16:29:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 154D4B80ED4;
        Wed,  1 Mar 2023 00:29:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A848C433D2;
        Wed,  1 Mar 2023 00:28:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677630539;
        bh=/LI5yRBD+xU8o3fJ25yJ7tAxnhNvYlM9rrYR42TLgAY=;
        h=From:To:Cc:Subject:Date:From;
        b=Rv1UyHDZGT20ZCmWiR/oXR+Y3M0WRAURtFwscHQrTvES+JBLmG/CZcThlamAQOjs1
         7eTlhRfW/9X2XF3vHKQ2IQrOM3qAdc2kqYPQfyXoWKWbY5CGN7xUbhl4PynUsPzLbt
         lq2u6Bx6+zaxOym6kFfBfs4DNuu8YPS+q7kdDEKjF24KME03+M8q1nIn2ubll6xipy
         9esX2FLXpZHBBzAISP6DgkAYglMM59VPHaXQ3qamLVOBrk5NORqRkistthLCHyR7pT
         PFdidkFmP6M8FaQl8W8xZGRN9krq8/Wi0PG45TOxhP+/4kVG0SR1tCX7xKa2wZDOnI
         IVRQ4h3tbepdA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>,
        syzbot+9c0268252b8ef967c62e@syzkaller.appspotmail.com,
        stable@vger.kernel.org, borisp@nvidia.com,
        john.fastabend@gmail.com, simon.horman@netronome.com
Subject: [PATCH net] net: tls: avoid hanging tasks on the tx_lock
Date:   Tue, 28 Feb 2023 16:28:57 -0800
Message-Id: <20230301002857.2101894-1-kuba@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot sent a hung task report and Eric explains that adversarial
receiver may keep RWIN at 0 for a long time, so we are not guaranteed
to make forward progress. Thread which took tx_lock and went to sleep
may not release tx_lock for hours. Use interruptible sleep where
possible and reschedule the work if it can't take the lock.

Testing: existing selftest passes

Reported-by: syzbot+9c0268252b8ef967c62e@syzkaller.appspotmail.com
Fixes: 79ffe6087e91 ("net/tls: add a TX lock")
Link: https://lore.kernel.org/all/000000000000e412e905f5b46201@google.com/
Cc: stable@vger.kernel.org # wait 4 weeks
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: borisp@nvidia.com
CC: john.fastabend@gmail.com
CC: simon.horman@netronome.com
---
 net/tls/tls_sw.c | 26 +++++++++++++++++++-------
 1 file changed, 19 insertions(+), 7 deletions(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 021d760f9133..635b8bf6b937 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -956,7 +956,9 @@ int tls_sw_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
 			       MSG_CMSG_COMPAT))
 		return -EOPNOTSUPP;
 
-	mutex_lock(&tls_ctx->tx_lock);
+	ret = mutex_lock_interruptible(&tls_ctx->tx_lock);
+	if (ret)
+		return ret;
 	lock_sock(sk);
 
 	if (unlikely(msg->msg_controllen)) {
@@ -1290,7 +1292,9 @@ int tls_sw_sendpage(struct sock *sk, struct page *page,
 		      MSG_SENDPAGE_NOTLAST | MSG_SENDPAGE_NOPOLICY))
 		return -EOPNOTSUPP;
 
-	mutex_lock(&tls_ctx->tx_lock);
+	ret = mutex_lock_interruptible(&tls_ctx->tx_lock);
+	if (ret)
+		return ret;
 	lock_sock(sk);
 	ret = tls_sw_do_sendpage(sk, page, offset, size, flags);
 	release_sock(sk);
@@ -2435,11 +2439,19 @@ static void tx_work_handler(struct work_struct *work)
 
 	if (!test_and_clear_bit(BIT_TX_SCHEDULED, &ctx->tx_bitmask))
 		return;
-	mutex_lock(&tls_ctx->tx_lock);
-	lock_sock(sk);
-	tls_tx_records(sk, -1);
-	release_sock(sk);
-	mutex_unlock(&tls_ctx->tx_lock);
+
+	if (mutex_trylock(&tls_ctx->tx_lock)) {
+		lock_sock(sk);
+		tls_tx_records(sk, -1);
+		release_sock(sk);
+		mutex_unlock(&tls_ctx->tx_lock);
+	} else if (!test_and_set_bit(BIT_TX_SCHEDULED, &ctx->tx_bitmask)) {
+		/* Someone is holding the tx_lock, they will likely run Tx
+		 * and cancel the work on their way out of the lock section.
+		 * Schedule a long delay just in case.
+		 */
+		schedule_delayed_work(&ctx->tx_work.work, msecs_to_jiffies(10));
+	}
 }
 
 static bool tls_is_tx_ready(struct tls_sw_context_tx *ctx)
-- 
2.39.2

