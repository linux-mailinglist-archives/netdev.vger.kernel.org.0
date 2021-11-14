Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E2C644F6FB
	for <lists+netdev@lfdr.de>; Sun, 14 Nov 2021 07:02:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231570AbhKNGFZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Nov 2021 01:05:25 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:59096 "EHLO
        www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbhKNGFZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Nov 2021 01:05:25 -0500
Received: from fsav119.sakura.ne.jp (fsav119.sakura.ne.jp [27.133.134.246])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 1AE62SL7015764;
        Sun, 14 Nov 2021 15:02:28 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav119.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav119.sakura.ne.jp);
 Sun, 14 Nov 2021 15:02:28 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav119.sakura.ne.jp)
Received: from localhost.localdomain (M106072142033.v4.enabler.ne.jp [106.72.142.33])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 1AE62NVd015754
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Sun, 14 Nov 2021 15:02:28 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
From:   Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To:     netdev@vger.kernel.org
Cc:     Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: [PATCH] sock: fix /proc/net/sockstat underflow in sk_clone_lock()
Date:   Sun, 14 Nov 2021 15:02:22 +0900
Message-Id: <20211114060222.3370-1-penguin-kernel@I-love.SAKURA.ne.jp>
X-Mailer: git-send-email 2.18.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sk_clone_lock() needs to call get_net() and sock_inuse_inc() together, or
socket_seq_show() will underflow when __sk_free() from sk_free() from
sk_free_unlock_clone() is called.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 net/core/sock.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index 8f2b2f2c0e7b..41e91d0f7061 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2124,8 +2124,10 @@ struct sock *sk_clone_lock(const struct sock *sk, const gfp_t priority)
 	newsk->sk_prot_creator = prot;
 
 	/* SANITY */
-	if (likely(newsk->sk_net_refcnt))
+	if (likely(newsk->sk_net_refcnt)) {
 		get_net(sock_net(newsk));
+		sock_inuse_add(sock_net(newsk), 1);
+	}
 	sk_node_init(&newsk->sk_node);
 	sock_lock_init(newsk);
 	bh_lock_sock(newsk);
@@ -2197,8 +2199,6 @@ struct sock *sk_clone_lock(const struct sock *sk, const gfp_t priority)
 	newsk->sk_err_soft = 0;
 	newsk->sk_priority = 0;
 	newsk->sk_incoming_cpu = raw_smp_processor_id();
-	if (likely(newsk->sk_net_refcnt))
-		sock_inuse_add(sock_net(newsk), 1);
 
 	/* Before updating sk_refcnt, we must commit prior changes to memory
 	 * (Documentation/RCU/rculist_nulls.rst for details)
-- 
2.32.0

