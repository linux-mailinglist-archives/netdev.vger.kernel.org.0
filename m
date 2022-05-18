Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2CD052C2E7
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 21:02:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241702AbiERSzs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 14:55:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241698AbiERSzi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 14:55:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0242A1C7418
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 11:55:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AF02FB821AD
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 18:55:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F3A7C385A5;
        Wed, 18 May 2022 18:55:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652900134;
        bh=7/jn81sjC98WWTHY0Po6wsCY3ykaCQNPUUeblyk1QKw=;
        h=From:To:Cc:Subject:Date:From;
        b=oPyCXSWcW1ziRzYLHjMcuBpChnULVRd739OiY6crNC5aFF+nfHKg90hQQiuBmSfgy
         AR1CDT4lsZvePiiBLVJmtfUjVd8GYc8NunI8TZcqf8gkjZoGP+Jjk2BozjBDfFc38e
         LF6w6ldndSzJO1pXmdLZR8rE5e/vFoCaM8Ciu0FvZBAPBlsBLqQhAwE31ilClqR4R5
         DYmKcQrRpAvMvw/c1NcbUKQdU9WhPHbckl3H/6j/LOExwyb78D5ZUN2DWeQ/AG7NOF
         HA8ITJhZwuCOeqDv9efwoa/09TU0WydoCvRDZxCEOc/JV7FjqpVhZXR56AvjQeKj/F
         Eqq3BRl6sLTsg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, pabeni@redhat.com, davem@davemloft.net,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next] net: avoid strange behavior with skb_defer_max == 1
Date:   Wed, 18 May 2022 11:55:22 -0700
Message-Id: <20220518185522.2038683-1-kuba@kernel.org>
X-Mailer: git-send-email 2.34.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When user sets skb_defer_max to 1 the kick threshold is 0
(half of 1). If we increment queue length before the check
the kick will never happen, and the skb may get stranded.
This is likely harmless but can be avoided by moving the
increment after the check. This way skb_defer_max == 1
will always kick. Still a silly config to have, but
somehow that feels more correct.

While at it drop a comment which seems to be outdated
or confusing, and wrap the defer_count write with
a WRITE_ONCE() since it's read on the fast path
that avoids taking the lock.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/core/skbuff.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 1d10bb4adec1..5b3559cb1d82 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -6512,18 +6512,15 @@ nodefer:	__kfree_skb(skb);
 	if (READ_ONCE(sd->defer_count) >= defer_max)
 		goto nodefer;
 
-	/* We do not send an IPI or any signal.
-	 * Remote cpu will eventually call skb_defer_free_flush()
-	 */
 	spin_lock_irqsave(&sd->defer_lock, flags);
+	/* Send an IPI every time queue reaches half capacity. */
+	kick = sd->defer_count == (defer_max >> 1);
+	/* Paired with the READ_ONCE() few lines above */
+	WRITE_ONCE(sd->defer_count, sd->defer_count + 1);
+
 	skb->next = sd->defer_list;
 	/* Paired with READ_ONCE() in skb_defer_free_flush() */
 	WRITE_ONCE(sd->defer_list, skb);
-	sd->defer_count++;
-
-	/* Send an IPI every time queue reaches half capacity. */
-	kick = sd->defer_count == (defer_max >> 1);
-
 	spin_unlock_irqrestore(&sd->defer_lock, flags);
 
 	/* Make sure to trigger NET_RX_SOFTIRQ on the remote CPU
-- 
2.34.3

