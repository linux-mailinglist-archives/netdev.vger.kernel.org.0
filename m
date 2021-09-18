Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB58541047A
	for <lists+netdev@lfdr.de>; Sat, 18 Sep 2021 08:48:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234941AbhIRGtt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Sep 2021 02:49:49 -0400
Received: from out30-56.freemail.mail.aliyun.com ([115.124.30.56]:36421 "EHLO
        out30-56.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232721AbhIRGts (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Sep 2021 02:49:48 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0UolXxQ6_1631947702;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0UolXxQ6_1631947702)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sat, 18 Sep 2021 14:48:23 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Antoine Tenart <atenart@kernel.org>,
        Alexander Lobakin <alobakin@pm.me>,
        Wei Wang <weiwan@google.com>, Taehee Yoo <ap420073@gmail.com>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        dust.li@linux.alibaba.com
Subject: [PATCH net] napi: fix race inside napi_enable
Date:   Sat, 18 Sep 2021 14:48:22 +0800
Message-Id: <20210918064822.58208-1-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The process will cause napi.state to contain NAPI_STATE_SCHED and
not in the poll_list, which will cause napi_disable() to get stuck.

The prefix "NAPI_STATE_" is removed in the figure below, and
NAPI_STATE_HASHED is ignored in napi.state.

                      CPU0       |                   CPU1       | napi.state
===============================================================================
napi_disable()                   |                              | SCHED | NPSVC
napi_enable()                    |                              |
{                                |                              |
    smp_mb__before_atomic();     |                              |
    clear_bit(SCHED, &n->state); |                              | NPSVC
                                 | napi_schedule_prep()         | SCHED | NPSVC
                                 | napi_poll()                  |
                                 |   napi_complete_done()       |
                                 |   {                          |
                                 |      if (n->state & (NPSVC | | (1)
                                 |               _BUSY_POLL)))  |
                                 |           return false;      |
                                 |     ................         |
                                 |   }                          | SCHED | NPSVC
                                 |                              |
    clear_bit(NPSVC, &n->state); |                              | SCHED
}                                |                              |
                                 |                              |
napi_schedule_prep()             |                              | SCHED | MISSED (2)

(1) Here return direct. Because of NAPI_STATE_NPSVC exists.
(2) NAPI_STATE_SCHED exists. So not add napi.poll_list to sd->poll_list

Since NAPI_STATE_SCHED already exists and napi is not in the
sd->poll_list queue, NAPI_STATE_SCHED cannot be cleared and will always
exist.

1. This will cause this queue to no longer receive packets.
2. If you encounter napi_disable under the protection of rtnl_lock, it
   will cause the entire rtnl_lock to be locked, affecting the overall
   system.

This patch uses cmpxchg to implement napi_enable(), which ensures that
there will be no race due to the separation of clear two bits.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Reviewed-by: Dust Li <dust.li@linux.alibaba.com>
---
 net/core/dev.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 74fd402d26dd..3457ae964b8c 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6923,12 +6923,19 @@ EXPORT_SYMBOL(napi_disable);
  */
 void napi_enable(struct napi_struct *n)
 {
+	unsigned long val, new;
+
 	BUG_ON(!test_bit(NAPI_STATE_SCHED, &n->state));
-	smp_mb__before_atomic();
-	clear_bit(NAPI_STATE_SCHED, &n->state);
-	clear_bit(NAPI_STATE_NPSVC, &n->state);
-	if (n->dev->threaded && n->thread)
-		set_bit(NAPI_STATE_THREADED, &n->state);
+
+	do {
+		val = READ_ONCE(n->state);
+
+		new = val & ~(NAPIF_STATE_SCHED | NAPIF_STATE_NPSVC);
+
+		if (n->dev->threaded && n->thread)
+			new |= NAPIF_STATE_THREADED;
+
+	} while (cmpxchg(&n->state, val, new) != val);
 }
 EXPORT_SYMBOL(napi_enable);
 
-- 
2.31.0

