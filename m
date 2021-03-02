Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBB8A32A2CD
	for <lists+netdev@lfdr.de>; Tue,  2 Mar 2021 15:59:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1837395AbhCBIdK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 03:33:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240469AbhCBBV6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 20:21:58 -0500
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 274A9C06178A
        for <netdev@vger.kernel.org>; Mon,  1 Mar 2021 17:21:16 -0800 (PST)
Received: by mail-qt1-x84a.google.com with SMTP id a41so12067301qtk.0
        for <netdev@vger.kernel.org>; Mon, 01 Mar 2021 17:21:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=0JL4B2ZJDLib6iFIg9KHqiWewiEhlM2ZBBTqGRjsZFg=;
        b=sRBd4Gk4uYPUWQjO/2aP1cPz0+D5kqoy2hLQuUW5wZPJuiGSJHXWBzVM4XalNeF0r6
         1z6CTubgrav4cnJSotPIjQkuTIwT2bcbB2mJ5ZOf8WeuQIW3leNHcZSpIggN5Jw3rRvp
         hOcleCUbE4xRC6763xL51D7dZ1ZD4xK9blU3N3+ci3+qAXypJPl1S5p0aoHssRl5h75j
         pcnTxOM+Dqvwze5dT24RfR3T7fHsspgAXrUFdkisa4Ra9Of4luyboF4e184XYUf3xgTM
         55ZG6BFHM8JQtx1+2FZ91FP8gEELzvE8MWd8HBeeOIKBst5maNVLcno+D23sA8weoY2d
         DFdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=0JL4B2ZJDLib6iFIg9KHqiWewiEhlM2ZBBTqGRjsZFg=;
        b=T3nh6wE1WNIGfRR8YOVtouidpvhL5y72xijWZR25o00ckIIJ8xd5lAxRo55Glwadf9
         Ia4bpMPGXYJBWiJfxcB2Tn7mGuT1izTeg5LenluNjXa14KiXo6zxfqa5lhgmCTGQZCA3
         u1ExRJ5jYjYcHJrZR/ZwABS+Qa+6Kzn8Vm+KROIEVFEQobGpt2+aE2sp/HeeV/baOgcH
         RhGyDhwDRZVOQYH2F1A/Y9jK6ZYkLkzMqAYNCi+02WiiAVlgql4s7EanZIb6k5Yww/o1
         Uk3OLLAxSGFVBZQXjrgRCuI0LKI3q6Bfs0ML5KsuNPW572oLvM2XHDvCnvSeTE51hnFc
         pk6w==
X-Gm-Message-State: AOAM532wKbLe67OIPb7bkCWpAmj8E66ksIyihEDSo7dPVLXsTRHtCKiS
        kDvFNx5KoweIFyFQlmBoI/6rwc8376Q=
X-Google-Smtp-Source: ABdhPJz8pDgpehhlCaCvw8Pl1ikR5Vix2e6kdrHh02UsFZDsZN203lclnaVrXjPFQKsIw+Xa9R1iy3xTiPQ=
Sender: "weiwan via sendgmr" <weiwan@weiwan.svl.corp.google.com>
X-Received: from weiwan.svl.corp.google.com ([2620:15c:2c4:201:4cf2:2d15:d296:f910])
 (user=weiwan job=sendgmr) by 2002:a0c:90ae:: with SMTP id p43mr1613628qvp.47.1614648075332;
 Mon, 01 Mar 2021 17:21:15 -0800 (PST)
Date:   Mon,  1 Mar 2021 17:21:13 -0800
Message-Id: <20210302012113.1432412-1-weiwan@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH net v3] net: fix race between napi kthread mode and busy poll
From:   Wei Wang <weiwan@google.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Martin Zaharinov <micron10@gmail.com>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, napi_thread_wait() checks for NAPI_STATE_SCHED bit to
determine if the kthread owns this napi and could call napi->poll() on
it. However, if socket busy poll is enabled, it is possible that the
busy poll thread grabs this SCHED bit (after the previous napi->poll()
invokes napi_complete_done() and clears SCHED bit) and tries to poll
on the same napi. napi_disable() could grab the SCHED bit as well.
This patch tries to fix this race by adding a new bit
NAPI_STATE_SCHED_THREADED in napi->state. This bit gets set in
____napi_schedule() if the threaded mode is enabled, and gets cleared
in napi_complete_done(), and we only poll the napi in kthread if this
bit is set. This helps distinguish the ownership of the napi between
kthread and other scenarios and fixes the race issue.

Fixes: 29863d41bb6e ("net: implement threaded-able napi poll loop support")
Reported-by: Martin Zaharinov <micron10@gmail.com>
Suggested-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Wei Wang <weiwan@google.com>
Cc: Alexander Duyck <alexanderduyck@fb.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Hannes Frederic Sowa <hannes@stressinduktion.org>
---
 include/linux/netdevice.h |  2 ++
 net/core/dev.c            | 14 +++++++++++++-
 2 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index ddf4cfc12615..682908707c1a 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -360,6 +360,7 @@ enum {
 	NAPI_STATE_IN_BUSY_POLL,	/* sk_busy_loop() owns this NAPI */
 	NAPI_STATE_PREFER_BUSY_POLL,	/* prefer busy-polling over softirq processing*/
 	NAPI_STATE_THREADED,		/* The poll is performed inside its own thread*/
+	NAPI_STATE_SCHED_THREADED,	/* Napi is currently scheduled in threaded mode */
 };
 
 enum {
@@ -372,6 +373,7 @@ enum {
 	NAPIF_STATE_IN_BUSY_POLL	= BIT(NAPI_STATE_IN_BUSY_POLL),
 	NAPIF_STATE_PREFER_BUSY_POLL	= BIT(NAPI_STATE_PREFER_BUSY_POLL),
 	NAPIF_STATE_THREADED		= BIT(NAPI_STATE_THREADED),
+	NAPIF_STATE_SCHED_THREADED	= BIT(NAPI_STATE_SCHED_THREADED),
 };
 
 enum gro_result {
diff --git a/net/core/dev.c b/net/core/dev.c
index 6c5967e80132..03c4763de351 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4294,6 +4294,8 @@ static inline void ____napi_schedule(struct softnet_data *sd,
 		 */
 		thread = READ_ONCE(napi->thread);
 		if (thread) {
+			if (thread->state != TASK_INTERRUPTIBLE)
+				set_bit(NAPI_STATE_SCHED_THREADED, &napi->state);
 			wake_up_process(thread);
 			return;
 		}
@@ -6486,6 +6488,7 @@ bool napi_complete_done(struct napi_struct *n, int work_done)
 		WARN_ON_ONCE(!(val & NAPIF_STATE_SCHED));
 
 		new = val & ~(NAPIF_STATE_MISSED | NAPIF_STATE_SCHED |
+			      NAPIF_STATE_SCHED_THREADED |
 			      NAPIF_STATE_PREFER_BUSY_POLL);
 
 		/* If STATE_MISSED was set, leave STATE_SCHED set,
@@ -6968,16 +6971,25 @@ static int napi_poll(struct napi_struct *n, struct list_head *repoll)
 
 static int napi_thread_wait(struct napi_struct *napi)
 {
+	bool woken = false;
+
 	set_current_state(TASK_INTERRUPTIBLE);
 
 	while (!kthread_should_stop() && !napi_disable_pending(napi)) {
-		if (test_bit(NAPI_STATE_SCHED, &napi->state)) {
+		/* Testing SCHED_THREADED bit here to make sure the current
+		 * kthread owns this napi and could poll on this napi.
+		 * Testing SCHED bit is not enough because SCHED bit might be
+		 * set by some other busy poll thread or by napi_disable().
+		 */
+		if (test_bit(NAPI_STATE_SCHED_THREADED, &napi->state) || woken) {
 			WARN_ON(!list_empty(&napi->poll_list));
 			__set_current_state(TASK_RUNNING);
 			return 0;
 		}
 
 		schedule();
+		/* woken being true indicates this thread owns this napi. */
+		woken = true;
 		set_current_state(TASK_INTERRUPTIBLE);
 	}
 	__set_current_state(TASK_RUNNING);
-- 
2.30.1.766.gb4fecdf3b7-goog

