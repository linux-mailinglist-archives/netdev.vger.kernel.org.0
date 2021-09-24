Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 701EA417C5B
	for <lists+netdev@lfdr.de>; Fri, 24 Sep 2021 22:25:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344990AbhIXU0n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 16:26:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:56510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344335AbhIXU0a (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Sep 2021 16:26:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4DF1561100;
        Fri, 24 Sep 2021 20:24:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632515096;
        bh=/XQpXLfNoGaoZ0roORdhCHUtfuffenKw8vAOToj3Z8c=;
        h=From:To:Cc:Subject:Date:From;
        b=FopV8iCBwBov1AYaWI6P89b+O1IHNuZvzkZ+z8YuWGjDI3aTSNk3Z2rvIDATCvQ9t
         ZIVW5LNLih3VxMCAbh/5VD87O1i0EhLs0BPWAru+fFrBaT0QwIXtd7XR8u2dnu2Zli
         dLtYPGO9PfZx/gl1pwg/t8Ajpl8naTXXox0E/ry1o+sUX8468bJuvBfeRJqTd0tCab
         6MwXNJe6GSnZwu8Rf1xaJ0cq+kZgTBMYqMhfJCaqYL2OsPnPqr5/t09k1QMt2czcIK
         Z/Emri83nABVMNHqW+OLSGJcwGl4EadiwDy6C8+suX0V+r2JRPBpjbPYF+JDK5AKYi
         zixAOg8YBn8iw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com, weiwan@google.com,
        xuanzhuo@linux.alibaba.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2] net: make napi_disable() symmetric with enable
Date:   Fri, 24 Sep 2021 13:24:53 -0700
Message-Id: <20210924202453.1051687-1-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 3765996e4f0b ("napi: fix race inside napi_enable") fixed
an ordering bug in napi_enable() and made the napi_enable() diverge
from napi_disable(). The state transitions done on disable are
not symmetric to enable.

There is no known bug in napi_disable() this is just refactoring.

Eric suggests we can also replace msleep(1) with a more opportunistic
usleep_range().

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/core/dev.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 62ddd7d6e00d..fa989ab63f29 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6900,19 +6900,25 @@ EXPORT_SYMBOL(netif_napi_add);
 
 void napi_disable(struct napi_struct *n)
 {
+	unsigned long val, new;
+
 	might_sleep();
 	set_bit(NAPI_STATE_DISABLE, &n->state);
 
-	while (test_and_set_bit(NAPI_STATE_SCHED, &n->state))
-		msleep(1);
-	while (test_and_set_bit(NAPI_STATE_NPSVC, &n->state))
-		msleep(1);
+	do {
+		val = READ_ONCE(n->state);
+		if (val & (NAPIF_STATE_SCHED | NAPIF_STATE_NPSVC)) {
+			usleep_range(20, 200);
+			continue;
+		}
+
+		new = val | NAPIF_STATE_SCHED | NAPIF_STATE_NPSVC;
+		new &= ~(NAPIF_STATE_THREADED | NAPIF_STATE_PREFER_BUSY_POLL);
+	} while (cmpxchg(&n->state, val, new) != val);
 
 	hrtimer_cancel(&n->timer);
 
-	clear_bit(NAPI_STATE_PREFER_BUSY_POLL, &n->state);
 	clear_bit(NAPI_STATE_DISABLE, &n->state);
-	clear_bit(NAPI_STATE_THREADED, &n->state);
 }
 EXPORT_SYMBOL(napi_disable);
 
-- 
2.31.1

