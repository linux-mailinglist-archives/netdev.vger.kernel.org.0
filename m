Return-Path: <netdev+bounces-4659-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F0F6F70DB53
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 13:15:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BA6AD1C20D24
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 11:15:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 553204A85D;
	Tue, 23 May 2023 11:15:32 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 486884A840
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 11:15:32 +0000 (UTC)
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B24EA120
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 04:15:29 -0700 (PDT)
From: Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1684840527;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=q5AXjYhCqt8xVutiuDJ26LU0nY4IRtKb+i6KCMvp2JM=;
	b=G6NTctaE2PULd3n9kHfSflui7XGWPWVqTbgAj/zdpeXsq/bP9PZGJlSwSoAxgNcPa6nf/y
	zJiW3QglvICOfsWan4FGJu2fxnYt+hcU8YbOq2mHjOQrcaSoW9utrdqw9CXY4fmNSpKhK7
	ZFHcysCDqxXKsYBQ+bVp7IzRkP5XiB1SvOcxXLjent+bgWF48PO1qD2I3yec/XKjr1YDCD
	w8dxdaStqK1yw6ZVeRi/NTRmEXO+DJslurfrSMzd6gpUTxxkoHgf7SPzDWtGOHb+DyynbA
	12Q6yPCkqXVzUB16tHk/N3xS7LfBwDSMP7NbYbFvkJZpaaSZOZAg3027D/cnxw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1684840527;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=q5AXjYhCqt8xVutiuDJ26LU0nY4IRtKb+i6KCMvp2JM=;
	b=honcKoZ3tMECD+yqiLlDvpHdoKXt53+hizukPZrfK7ui6f+K7AkLpvJqpq2lvu5JULCKW0
	uC11Kj4zPkV3zxDw==
To: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Cc: netdev@vger.kernel.org,
	Kurt Kanzenbach <kurt@linutronix.de>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH net-next] net/core: Enable socket busy polling on -RT
Date: Tue, 23 May 2023 13:15:18 +0200
Message-Id: <20230523111518.21512-1-kurt@linutronix.de>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Busy polling is currently not allowed on PREEMPT_RT, because it disables
preemption while invoking the NAPI callback. It is not possible to acquire
sleeping locks with disabled preemption. For details see commit
20ab39d13e2e ("net/core: disable NET_RX_BUSY_POLL on PREEMPT_RT").

However, strict cyclic and/or low latency network applications may prefer busy
polling e.g., using AF_XDP instead of interrupt driven communication.

The preempt_disable() is used in order to prevent the poll_owner and NAPI owner
to be preempted while owning the resource to ensure progress. Netpoll performs
busy polling in order to acquire the lock. NAPI is locked by setting the
NAPIF_STATE_SCHED flag. There is no busy polling if the flag is set and the
"owner" is preempted. Worst case is that the task owning NAPI gets preempted and
NAPI processing stalls.  This is can be prevented by properly prioritising the
tasks within the system.

Allow RX_BUSY_POLL on PREEMPT_RT if NETPOLL is disabled. Don't disable
preemption on PREEMPT_RT within the busy poll loop.

Tested on x86 hardware with v6.1-RT and v6.3-RT on Intel i225 (igc) with
AF_XDP/ZC sockets configured to run in busy polling mode.

Suggested-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
---

Changes since RFC:

 * Commit message

Previous version:

 * https://lore.kernel.org/all/20230517110950.78322-1-kurt@linutronix.de/

 net/Kconfig    | 2 +-
 net/core/dev.c | 9 ++++++---
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/net/Kconfig b/net/Kconfig
index 7d39c1773eb4..2fb25b534df5 100644
--- a/net/Kconfig
+++ b/net/Kconfig
@@ -324,7 +324,7 @@ config CGROUP_NET_CLASSID
 
 config NET_RX_BUSY_POLL
 	bool
-	default y if !PREEMPT_RT
+	default y if !PREEMPT_RT || (PREEMPT_RT && !NETCONSOLE)
 
 config BQL
 	bool
diff --git a/net/core/dev.c b/net/core/dev.c
index b3c13e041935..3393c2f3dbe8 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6197,7 +6197,8 @@ void napi_busy_loop(unsigned int napi_id,
 	if (!napi)
 		goto out;
 
-	preempt_disable();
+	if (!IS_ENABLED(CONFIG_PREEMPT_RT))
+		preempt_disable();
 	for (;;) {
 		int work = 0;
 
@@ -6239,7 +6240,8 @@ void napi_busy_loop(unsigned int napi_id,
 		if (unlikely(need_resched())) {
 			if (napi_poll)
 				busy_poll_stop(napi, have_poll_lock, prefer_busy_poll, budget);
-			preempt_enable();
+			if (!IS_ENABLED(CONFIG_PREEMPT_RT))
+				preempt_enable();
 			rcu_read_unlock();
 			cond_resched();
 			if (loop_end(loop_end_arg, start_time))
@@ -6250,7 +6252,8 @@ void napi_busy_loop(unsigned int napi_id,
 	}
 	if (napi_poll)
 		busy_poll_stop(napi, have_poll_lock, prefer_busy_poll, budget);
-	preempt_enable();
+	if (!IS_ENABLED(CONFIG_PREEMPT_RT))
+		preempt_enable();
 out:
 	rcu_read_unlock();
 }
-- 
2.30.2


