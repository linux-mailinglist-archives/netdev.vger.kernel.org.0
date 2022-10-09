Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B0445F9379
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 01:18:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231786AbiJIXSw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Oct 2022 19:18:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231923AbiJIXS1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Oct 2022 19:18:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CA8B43333;
        Sun,  9 Oct 2022 15:44:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 98E1C60CEC;
        Sun,  9 Oct 2022 22:26:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE2A1C43470;
        Sun,  9 Oct 2022 22:26:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665354366;
        bh=nVSzuQovs1H4xHMD/Wj9kf+7nj6ld5QaE6cREo1lFJI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DqzYZJo24X+Fd5SNwFu9fWjZTUzP/8dY1kHK1dEhG8aO/U17ynnRi5yPoBcrG03xu
         4FgGYYOOBJ/6QRSbVZRC1CqHEVqW/ZjEld0P2CJB+Xpjn8OopggXW9EoT3rQs76nvn
         o5yZi8QnQriY6JjVnBD6xt6oCYPUEA8WIfTTymUl/Z+YpukhxAPx1MJQpEX5F9HN0l
         dDV7jC9sdca1gDslBWVke31Gz69oBmJFRuogxJy1qmR0fjttbYQCl/2kRZwTbaUlkM
         jv7NkQhUwxV3G8bpimyAq3YRsjasCMRxfwZXMLrljENaR2xkLRWgn4mY1HOsXtrtR8
         LJRGlJIefjmhw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        Abhishek Shah <abhishek.shah@columbia.edu>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 04/23] tcp: annotate data-race around tcp_md5sig_pool_populated
Date:   Sun,  9 Oct 2022 18:25:34 -0400
Message-Id: <20221009222557.1219968-4-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009222557.1219968-1-sashal@kernel.org>
References: <20221009222557.1219968-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit aacd467c0a576e5e44d2de4205855dc0fe43f6fb ]

tcp_md5sig_pool_populated can be read while another thread
changes its value.

The race has no consequence because allocations
are protected with tcp_md5sig_mutex.

This patch adds READ_ONCE() and WRITE_ONCE() to document
the race and silence KCSAN.

Reported-by: Abhishek Shah <abhishek.shah@columbia.edu>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index a0fd9ef2d2c6..875c929b5f08 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -3316,12 +3316,16 @@ static void __tcp_alloc_md5sig_pool(void)
 	 * to memory. See smp_rmb() in tcp_get_md5sig_pool()
 	 */
 	smp_wmb();
-	tcp_md5sig_pool_populated = true;
+	/* Paired with READ_ONCE() from tcp_alloc_md5sig_pool()
+	 * and tcp_get_md5sig_pool().
+	*/
+	WRITE_ONCE(tcp_md5sig_pool_populated, true);
 }
 
 bool tcp_alloc_md5sig_pool(void)
 {
-	if (unlikely(!tcp_md5sig_pool_populated)) {
+	/* Paired with WRITE_ONCE() from __tcp_alloc_md5sig_pool() */
+	if (unlikely(!READ_ONCE(tcp_md5sig_pool_populated))) {
 		mutex_lock(&tcp_md5sig_mutex);
 
 		if (!tcp_md5sig_pool_populated)
@@ -3329,7 +3333,8 @@ bool tcp_alloc_md5sig_pool(void)
 
 		mutex_unlock(&tcp_md5sig_mutex);
 	}
-	return tcp_md5sig_pool_populated;
+	/* Paired with WRITE_ONCE() from __tcp_alloc_md5sig_pool() */
+	return READ_ONCE(tcp_md5sig_pool_populated);
 }
 EXPORT_SYMBOL(tcp_alloc_md5sig_pool);
 
@@ -3345,7 +3350,8 @@ struct tcp_md5sig_pool *tcp_get_md5sig_pool(void)
 {
 	local_bh_disable();
 
-	if (tcp_md5sig_pool_populated) {
+	/* Paired with WRITE_ONCE() from __tcp_alloc_md5sig_pool() */
+	if (READ_ONCE(tcp_md5sig_pool_populated)) {
 		/* coupled with smp_wmb() in __tcp_alloc_md5sig_pool() */
 		smp_rmb();
 		return this_cpu_ptr(&tcp_md5sig_pool);
-- 
2.35.1

