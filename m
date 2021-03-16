Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D9D833E17B
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 23:37:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231370AbhCPWhT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 18:37:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231384AbhCPWgx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 18:36:53 -0400
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0259FC06174A
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 15:36:53 -0700 (PDT)
Received: by mail-qv1-xf49.google.com with SMTP id x20so17262497qvd.21
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 15:36:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=3xeta4wowVb119RJuiFze078LlKv8xYAzsruSvSYj4k=;
        b=lX0Xx/YpNsbVTxM7ZIomZJrDL/mNzKOdwFH6D7Q7W51k/PQ2RAP6mjDWUkqZPFSXPD
         7XMF/SnHvJu8jRpJEfldCL69lVGlOdU9E9NFgxHMLkXFvQocc0+tEocKP4EcF6huooab
         0PJj6HlK2Nxbbjs/90l2d+J/LjcDotgOvXoO2r4PsJtXWXiP0oAll4b+oRwW/ILGacfS
         Kem4A4TnJGHSovnBxt1OLlKH4u+YFbD6ZRqVjrStgrH2zYJfF65D4zC6Q2UtAduFpenW
         dCzDeM+/HQJLvpzVX2eGhTVxLsQb2Vk3UoEIaxRuOWZ4ib4QE5g4XWKkg3iSEBTw6Tri
         /sTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=3xeta4wowVb119RJuiFze078LlKv8xYAzsruSvSYj4k=;
        b=HkQSU2PxOTW13sHSvMg4wY4edZ5RvrsI9NDzrJsX5fWlbUN8cUceR0HkYCILiXuU9J
         9IfV8yjN+X63kwGIOIfjMBAEpr5k7UErxctXqysDVo0660Q7BelVchV5shmE46h8BHUo
         2b8ESML3J/BL+/4uZe4gh9DOYP96yCB5e8hFnOkVrlS9QneChACQhue9EXAYyzlw2AmY
         ZBvxOo4GifrsQirqJv5tR2l0oQtVuGn9VYNuUiWO7/hnkC46Za3y0w24oJJ4IncKU7E2
         leA3K9AovfFQd9tZI78O7GF1lEYmkRFsmiG89L71a5mOdI+LpyubrbHL+F4/HF2l/nfX
         /PZA==
X-Gm-Message-State: AOAM532OJGkWoVwz9LTNGOK53xHGvtMKGCxPChqUeYeif/HI41vcY7jd
        /xj08ZJozfa9VXZ1ZEu6m3tyPgj8Gvw=
X-Google-Smtp-Source: ABdhPJykVio7853ZTEdO9Tn9RuC3nM8ZHrWn/oxQmDnxi4Wbx7uq1DAasDZF64KDFwmVvM/pdBIDtyINYnA=
X-Received: from weiwan.svl.corp.google.com ([2620:15c:2c4:201:c811:e628:b026:5b2d])
 (user=weiwan job=sendgmr) by 2002:a05:6214:1c47:: with SMTP id
 if7mr1930852qvb.50.1615934212184; Tue, 16 Mar 2021 15:36:52 -0700 (PDT)
Date:   Tue, 16 Mar 2021 15:36:47 -0700
Message-Id: <20210316223647.4080796-1-weiwan@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.31.0.rc2.261.g7f71774620-goog
Subject: [PATCH net v4] net: fix race between napi kthread mode and busy poll
From:   Wei Wang <weiwan@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
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
Change since v3:
  - Add READ_ONCE() for thread->state and add comments in
    ____napi_schedule().
  
 include/linux/netdevice.h |  2 ++
 net/core/dev.c            | 19 ++++++++++++++++++-
 2 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 5b67ea89d5f2..87a5d186faff 100644
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
index 6c5967e80132..d3195a95f30e 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4294,6 +4294,13 @@ static inline void ____napi_schedule(struct softnet_data *sd,
 		 */
 		thread = READ_ONCE(napi->thread);
 		if (thread) {
+			/* Avoid doing set_bit() if the thread is in
+			 * INTERRUPTIBLE state, cause napi_thread_wait()
+			 * makes sure to proceed with napi polling
+			 * if the thread is explicitly woken from here.
+			 */
+			if (READ_ONCE(thread->state) != TASK_INTERRUPTIBLE)
+				set_bit(NAPI_STATE_SCHED_THREADED, &napi->state);
 			wake_up_process(thread);
 			return;
 		}
@@ -6486,6 +6493,7 @@ bool napi_complete_done(struct napi_struct *n, int work_done)
 		WARN_ON_ONCE(!(val & NAPIF_STATE_SCHED));
 
 		new = val & ~(NAPIF_STATE_MISSED | NAPIF_STATE_SCHED |
+			      NAPIF_STATE_SCHED_THREADED |
 			      NAPIF_STATE_PREFER_BUSY_POLL);
 
 		/* If STATE_MISSED was set, leave STATE_SCHED set,
@@ -6968,16 +6976,25 @@ static int napi_poll(struct napi_struct *n, struct list_head *repoll)
 
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
2.31.0.rc2.261.g7f71774620-goog

