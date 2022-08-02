Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A82A8587CB9
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 14:56:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236698AbiHBM4i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Aug 2022 08:56:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236731AbiHBM4f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Aug 2022 08:56:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F70511A32
        for <netdev@vger.kernel.org>; Tue,  2 Aug 2022 05:56:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EED7AB81EFE
        for <netdev@vger.kernel.org>; Tue,  2 Aug 2022 12:56:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31EF2C43142;
        Tue,  2 Aug 2022 12:56:31 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="WOJNvdBc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1659444990;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/ZeVoWm0a7/DLh9vXJVxolr+PEKcOEQOX3WI7nDKWiQ=;
        b=WOJNvdBcy5RK6KJcLpO4tZJ/fl1CQ/o95+kqtqt+36IJPYLo35byZnYHKuyxY6VqOtRZQe
        460Wm06jkN5ox3eIVks9F2u6n6G6ZEAektar50Zk+hLequ2zs6d6bAvwfp8RkrVKu4aSgV
        JyygSt3M+/Pdn9PfFGQulb41iQrKwG0=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id fafa5dae (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Tue, 2 Aug 2022 12:56:30 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     kuba@kernel.org, pablo@netfilter.org, netdev@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH next-next 3/4] wireguard: allowedips: don't corrupt stack when detecting overflow
Date:   Tue,  2 Aug 2022 14:56:12 +0200
Message-Id: <20220802125613.340848-4-Jason@zx2c4.com>
In-Reply-To: <20220802125613.340848-1-Jason@zx2c4.com>
References: <20220802125613.340848-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In case push_rcu() and related functions are buggy, there's a
WARN_ON(len >= 128), which the selftest tries to hit by being tricky. In
case it is hit, we shouldn't corrupt the kernel's stack, though;
otherwise it may be hard to even receive the report that it's buggy. So
conditionalize the stack write based on that WARN_ON()'s return value.

Note that this never *actually* happens anyway. The WARN_ON() in the
first place is bounded by IS_ENABLED(DEBUG), and isn't expected to ever
actually hit. This is just a debugging sanity check.

Additionally, hoist the constant 128 into a named enum,
MAX_ALLOWEDIPS_BITS, so that it's clear why this value is chosen.

Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Link: https://lore.kernel.org/all/CAHk-=wjJZGA6w_DxA+k7Ejbqsq+uGK==koPai3sqdsfJqemvag@mail.gmail.com/
Fixes: e7096c131e51 ("net: WireGuard secure network tunnel")
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 drivers/net/wireguard/allowedips.c          | 9 ++++++---
 drivers/net/wireguard/selftest/allowedips.c | 6 +++---
 2 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireguard/allowedips.c b/drivers/net/wireguard/allowedips.c
index 9a4c8ff32d9d..5bf7822c53f1 100644
--- a/drivers/net/wireguard/allowedips.c
+++ b/drivers/net/wireguard/allowedips.c
@@ -6,6 +6,8 @@
 #include "allowedips.h"
 #include "peer.h"
 
+enum { MAX_ALLOWEDIPS_BITS = 128 };
+
 static struct kmem_cache *node_cache;
 
 static void swap_endian(u8 *dst, const u8 *src, u8 bits)
@@ -40,7 +42,8 @@ static void push_rcu(struct allowedips_node **stack,
 		     struct allowedips_node __rcu *p, unsigned int *len)
 {
 	if (rcu_access_pointer(p)) {
-		WARN_ON(IS_ENABLED(DEBUG) && *len >= 128);
+		if (WARN_ON(IS_ENABLED(DEBUG) && *len >= MAX_ALLOWEDIPS_BITS))
+			return;
 		stack[(*len)++] = rcu_dereference_raw(p);
 	}
 }
@@ -52,7 +55,7 @@ static void node_free_rcu(struct rcu_head *rcu)
 
 static void root_free_rcu(struct rcu_head *rcu)
 {
-	struct allowedips_node *node, *stack[128] = {
+	struct allowedips_node *node, *stack[MAX_ALLOWEDIPS_BITS] = {
 		container_of(rcu, struct allowedips_node, rcu) };
 	unsigned int len = 1;
 
@@ -65,7 +68,7 @@ static void root_free_rcu(struct rcu_head *rcu)
 
 static void root_remove_peer_lists(struct allowedips_node *root)
 {
-	struct allowedips_node *node, *stack[128] = { root };
+	struct allowedips_node *node, *stack[MAX_ALLOWEDIPS_BITS] = { root };
 	unsigned int len = 1;
 
 	while (len > 0 && (node = stack[--len])) {
diff --git a/drivers/net/wireguard/selftest/allowedips.c b/drivers/net/wireguard/selftest/allowedips.c
index e173204ae7d7..41db10f9be49 100644
--- a/drivers/net/wireguard/selftest/allowedips.c
+++ b/drivers/net/wireguard/selftest/allowedips.c
@@ -593,10 +593,10 @@ bool __init wg_allowedips_selftest(void)
 	wg_allowedips_remove_by_peer(&t, a, &mutex);
 	test_negative(4, a, 192, 168, 0, 1);
 
-	/* These will hit the WARN_ON(len >= 128) in free_node if something
-	 * goes wrong.
+	/* These will hit the WARN_ON(len >= MAX_ALLOWEDIPS_BITS) in free_node
+	 * if something goes wrong.
 	 */
-	for (i = 0; i < 128; ++i) {
+	for (i = 0; i < MAX_ALLOWEDIPS_BITS; ++i) {
 		part = cpu_to_be64(~(1LLU << (i % 64)));
 		memset(&ip, 0xff, 16);
 		memcpy((u8 *)&ip + (i < 64) * 8, &part, 8);
-- 
2.35.1

