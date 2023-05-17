Return-Path: <netdev+bounces-3316-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4DA55706662
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 13:15:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0835E281714
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 11:15:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACD4818C22;
	Wed, 17 May 2023 11:10:43 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1493154A1
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 11:10:43 +0000 (UTC)
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7832A1B6
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 04:10:41 -0700 (PDT)
From: Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1684321839;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=f7DThjLQsVkwX3u/dNjrL6/7upbhMgjZOKsPkrrKlHg=;
	b=qy3bXRWol6a80HEguNQHaz0nKev2lvZxYIbOdL7TImf5ZoXQpQORNBVv07Dm5irOUvaxxA
	t/47kAK7L9Sf4RoY1JUQ36X4IhcK9I26dC63lr6byZfJ2iGT63ye2N8f3pxrhyKHpsR8Ja
	/NcltXk8HVEw9qx8qaUtesrADYHGsxYQy/Df239ecWq02G2rSuJk1WiGHKXk/ULY03wbp3
	LrGN55RKGTq8EOTkwscFOeCyg0uHYJJLVOiTqIvDligrwXUZ6MvMgY/HxvlTCf66tv2juV
	gs3OF/n9MStDVlMmAzkwdxMPTj+V5VY6T3wTNdA4wuT+q92unlG8Ojq71rzQ7Q==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1684321839;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=f7DThjLQsVkwX3u/dNjrL6/7upbhMgjZOKsPkrrKlHg=;
	b=ezEhZwWQt+SuSORScPpvLyJZj4PqPL61OlFbLD6IbA+A9z95uY7xZxLPw1E3xSIhXmnnJD
	G/uKe+oH7c/Cz3CQ==
To: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	netdev@vger.kernel.org,
	Kurt Kanzenbach <kurt@linutronix.de>
Subject: [PATCH RFC net-next] net/core: Enable socket busy polling on -RT
Date: Wed, 17 May 2023 13:09:50 +0200
Message-Id: <20230517110950.78322-1-kurt@linutronix.de>
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
preemption. It is not possible to acquire sleeping locks with disabled
preemption. For details see commit 20ab39d13e2e ("net/core: disable
NET_RX_BUSY_POLL on PREEMPT_RT").

However, strict cyclic and/or low latency network applications may prefer busy
polling e.g., using AF_XDP instead of interrupt driven communication.

The preempt_disable() is used in order to prevent the poll_lock owner to be
preempted while holding the lock and to ensure progress. To overcome that
problem on -RT, allow busy polling only in case the netconsole (and netpoll) is
not used. No functional change for upstream.

Tested on x86 hardware with v6.1-RT and v6.3-RT on Intel i225 (igc) with
AF_XDP/ZC sockets configured to run in busy polling mode.

Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
---
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


