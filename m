Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36EBB326ACA
	for <lists+netdev@lfdr.de>; Sat, 27 Feb 2021 01:31:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229863AbhB0Abc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Feb 2021 19:31:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbhB0Aba (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Feb 2021 19:31:30 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A17ADC061574
        for <netdev@vger.kernel.org>; Fri, 26 Feb 2021 16:30:50 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id l10so11782499ybt.6
        for <netdev@vger.kernel.org>; Fri, 26 Feb 2021 16:30:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=zNkOb95Mez51iUey3t8FznRyErvpQgRmJ0V5OBkFo8Y=;
        b=ZETO0bRSND9SLJmu+7tQFApE0/qvKgvdYSp22smp2NeHCB67OHLMMzJpLou0HsNn8A
         v97Wf/QTHtsUmEzIB+jdfAWp8KtYL/Z5Xbv73Mm+dCoDE2ja3apT749/AffS/pHrQNn4
         wVxbv31TEOjhJoVSIAzbQ6TKm8lPnwFYN/UIEPv8OaJqc+uaesNfV7mR951w+FOvZPVd
         irZseIgCGtgbXMmkK39gHeRffTE6mqkOvyOv3cYSgxpTp9Lqagy5ma8U7fMUUXe0Htrk
         KsfaVnkzeaGfRV1G4jDkaOjDLgZIiYnQ9Enkxov+kQ/EW6BlMZOH9mOJmdVJy6ZDLGs2
         sQNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=zNkOb95Mez51iUey3t8FznRyErvpQgRmJ0V5OBkFo8Y=;
        b=Ns1RbNPtiduu7M+fm5yloQYRV/MAClUMzVOB8CMrTlYMiK91we8qAr3EMgPFSLTve/
         ghqKiHFe8OqNjaKL5a38y9wOVUgBUwtU9NVrs62Xjvrs4wXhnVMTeFKg8bU6NOXoIN1j
         YzBMLdokYFogjwiw4GsFjDRzz3lC//Bw/ToBxsHXIscgmWUq7E4V0rEKCGVa8JRw5y3T
         RE5eSyNYpB/u6ge6GgGkSaWelQGzVoyJbV3TegivhBTrp4JIKX9DZYDKjAzH5mu4MGzB
         R0cSeFSm+T5ukeDvI47LBlEqzsgEGcIbF+htUzQH94f2RIxpmqxgyUGD8XqRW/AS27sj
         albg==
X-Gm-Message-State: AOAM532SI+JFs32DU2tJ5J2bTJcxip3de3GacIv19oC5bOiLod6EMA6R
        j1vPx2sddLrEDXq0ihzRJJH7ZqHEaso=
X-Google-Smtp-Source: ABdhPJxzJJwdeqqVsoALpBAYIHZUY5tGnMSPv850Gp07/HlpbWSv/83mOe0YZ2ri6KyyjgyJ+3dpVC0vN78=
Sender: "weiwan via sendgmr" <weiwan@weiwan.svl.corp.google.com>
X-Received: from weiwan.svl.corp.google.com ([2620:15c:2c4:201:408:3f8f:3064:352])
 (user=weiwan job=sendgmr) by 2002:a25:20c2:: with SMTP id g185mr8725749ybg.31.1614385849926;
 Fri, 26 Feb 2021 16:30:49 -0800 (PST)
Date:   Fri, 26 Feb 2021 16:30:47 -0800
Message-Id: <20210227003047.1051347-1-weiwan@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH net v2] net: fix race between napi kthread mode and busy poll
From:   Wei Wang <weiwan@google.com>
To:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
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
Signed-off-by: Wei Wang <weiwan@google.com>
Cc: Alexander Duyck <alexanderduyck@fb.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Hannes Frederic Sowa <hannes@stressinduktion.org>
---
 include/linux/netdevice.h |  2 ++
 net/core/dev.c            | 20 +++++++++++++-------
 2 files changed, 15 insertions(+), 7 deletions(-)

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
index 6c5967e80132..d4ce154c8df5 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1501,15 +1501,14 @@ static int napi_kthread_create(struct napi_struct *n)
 {
 	int err = 0;
 
-	/* Create and wake up the kthread once to put it in
-	 * TASK_INTERRUPTIBLE mode to avoid the blocked task
-	 * warning and work with loadavg.
+	/* Avoid waking up the kthread during creation to prevent
+	 * potential race.
 	 */
-	n->thread = kthread_run(napi_threaded_poll, n, "napi/%s-%d",
-				n->dev->name, n->napi_id);
+	n->thread = kthread_create(napi_threaded_poll, n, "napi/%s-%d",
+				   n->dev->name, n->napi_id);
 	if (IS_ERR(n->thread)) {
 		err = PTR_ERR(n->thread);
-		pr_err("kthread_run failed with err %d\n", err);
+		pr_err("kthread_create failed with err %d\n", err);
 		n->thread = NULL;
 	}
 
@@ -4294,6 +4293,7 @@ static inline void ____napi_schedule(struct softnet_data *sd,
 		 */
 		thread = READ_ONCE(napi->thread);
 		if (thread) {
+			set_bit(NAPI_STATE_SCHED_THREADED, &napi->state);
 			wake_up_process(thread);
 			return;
 		}
@@ -6486,6 +6486,7 @@ bool napi_complete_done(struct napi_struct *n, int work_done)
 		WARN_ON_ONCE(!(val & NAPIF_STATE_SCHED));
 
 		new = val & ~(NAPIF_STATE_MISSED | NAPIF_STATE_SCHED |
+			      NAPIF_STATE_SCHED_THREADED |
 			      NAPIF_STATE_PREFER_BUSY_POLL);
 
 		/* If STATE_MISSED was set, leave STATE_SCHED set,
@@ -6971,7 +6972,12 @@ static int napi_thread_wait(struct napi_struct *napi)
 	set_current_state(TASK_INTERRUPTIBLE);
 
 	while (!kthread_should_stop() && !napi_disable_pending(napi)) {
-		if (test_bit(NAPI_STATE_SCHED, &napi->state)) {
+		/* Testing SCHED_THREADED bit here to make sure the current
+		 * kthread owns this napi and could poll on this napi.
+		 * Testing SCHED bit is not enough because SCHED bit might be
+		 * set by some other busy poll thread or by napi_disable().
+		 */
+		if (test_bit(NAPI_STATE_SCHED_THREADED, &napi->state)) {
 			WARN_ON(!list_empty(&napi->poll_list));
 			__set_current_state(TASK_RUNNING);
 			return 0;
-- 
2.30.1.766.gb4fecdf3b7-goog

