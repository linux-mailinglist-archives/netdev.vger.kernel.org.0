Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 472A5450235
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 11:17:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230519AbhKOKUE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 05:20:04 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:50420 "EHLO
        www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230466AbhKOKUC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 05:20:02 -0500
Received: from fsav118.sakura.ne.jp (fsav118.sakura.ne.jp [27.133.134.245])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 1AFAH1mA012934;
        Mon, 15 Nov 2021 19:17:01 +0900 (JST)
        (envelope-from penguin-kernel@i-love.sakura.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav118.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav118.sakura.ne.jp);
 Mon, 15 Nov 2021 19:17:01 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav118.sakura.ne.jp)
Received: from [192.168.1.9] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 1AFAH1vi012930
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
        Mon, 15 Nov 2021 19:17:01 +0900 (JST)
        (envelope-from penguin-kernel@i-love.sakura.ne.jp)
Message-ID: <8ef55b45-8850-f811-b996-5a16ee4dd97f@i-love.sakura.ne.jp>
Date:   Mon, 15 Nov 2021 19:16:56 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: [PATCH v2] sock: fix /proc/net/sockstat underflow in sk_clone_lock()
Content-Language: en-US
To:     Eric Dumazet <eric.dumazet@gmail.com>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
References: <20211114060222.3370-1-penguin-kernel@I-love.SAKURA.ne.jp>
 <ee46d850-7dcb-b9d5-b61c-56638fa2f9ae@gmail.com>
 <51c40730-5b75-fe91-560b-4c4ec4974c83@i-love.sakura.ne.jp>
 <17179d2c-8dd2-216f-9c32-0f37ddd78cfa@gmail.com>
From:   Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
In-Reply-To: <17179d2c-8dd2-216f-9c32-0f37ddd78cfa@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sk_clone_lock() needs to call sock_inuse_add(1) before entering the
sk_free_unlock_clone() error path, for __sk_free() from sk_free() from
sk_free_unlock_clone() calls sock_inuse_add(-1).

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Fixes: 648845ab7e200993 ("sock: Move the socket inuse to namespace.")
---
Changes in v2:
  Rewrite patch description.

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

