Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0FD9416AAB
	for <lists+netdev@lfdr.de>; Fri, 24 Sep 2021 06:02:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230329AbhIXEEa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 00:04:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:41800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229717AbhIXEE2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Sep 2021 00:04:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0F93B610D1;
        Fri, 24 Sep 2021 04:02:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632456175;
        bh=82sodz7FaaT0TOz4dqNTFo1yL+k706Of3KE0gRm+PzI=;
        h=From:To:Cc:Subject:Date:From;
        b=VMKl/s4C+gSGp7wKxtyMO754EBXFAdMhoAi78dd31EaDk4fbTqK1rzO5706qfsFCe
         iuhwFYQuLFJjoAAdJJg+pc+dXl/tsBeZUV4GtGDB0D7TlBQdQ8X/rNJySWUBYCQowx
         LxJB9vqQkSU2E3+R/7iUct9dT5ZxL/+aIP62wCLXPqfeXnJdBiPXTaqNK/Dt8lIjGv
         V4f0QnQ7qb+UV+0ILhjJcCu9luzSG/6Th00Q+fTTRqTp4S8StTuAcLYcJfscG4XDtq
         P4IOXuXELEAXbX2Xg9c2O7UdsicrvtsmC2J5n048G5YZI3UhtOpJlEab8yzkScKydV
         w6Xw/+v8RMiUQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com, weiwan@google.com,
        xuanzhuo@linux.alibaba.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next] net: make napi_disable() symmetric with enable
Date:   Thu, 23 Sep 2021 21:02:51 -0700
Message-Id: <20210924040251.901171-1-kuba@kernel.org>
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

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
Does this look like a reasonable cleanup?

TBH my preference would be to stick to the code we have in
disable, and refactor enable back to single ops just in the
right order. I find the series of atomic ops far easier to read
and cmpxchg is not really required here.
---
 net/core/dev.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 62ddd7d6e00d..0d297423b304 100644
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
+			msleep(1);
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

