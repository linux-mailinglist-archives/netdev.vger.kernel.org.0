Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3CEB612D2D
	for <lists+netdev@lfdr.de>; Sun, 30 Oct 2022 23:02:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230024AbiJ3WCg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Oct 2022 18:02:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229962AbiJ3WCQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Oct 2022 18:02:16 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53019BCB1
        for <netdev@vger.kernel.org>; Sun, 30 Oct 2022 15:02:11 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id 20so9216386pgc.5
        for <netdev@vger.kernel.org>; Sun, 30 Oct 2022 15:02:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d8OpHlPRST08skeh7BHSZbFN09k6AB6QzxLidf3Pxy0=;
        b=FtnVuw2djVhLJ39B4Iu0YH3QmQxMkIGxXHKnGZA7K1Sw4fYMnyIG96gEfOp4ciSi3F
         cp2w+v7oMMq0Yi2VBZSN6Hrdemo+vuHjooi0IikAo7UQPpKQ88+6759GdWUK+E0kufEv
         JmuhNI176JjjlMg/MU4+jDvC333l9Ozzl1KVuDENgYG8GAaobnWkN8D4i3P+gSnLe3wp
         DwP0mgFKh8mD0/6QaVxqR1lyCrEHmDnbYsdnvwA22dLE7MQLkOCq8F03DuPRZPcY7+uP
         bMXRGPp77FPPOBjK+xLWlYkO6HIx11jiV+KgVJpNw+o0kooBQ3k8mQHdrQSzFG9blCoz
         kwRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=d8OpHlPRST08skeh7BHSZbFN09k6AB6QzxLidf3Pxy0=;
        b=oRAxgZuejq1XsSNbZVrqLg0HtIOhgnK1S2a1zWo5WOQ9OC8ydCE3G8jldgQfgCv+KY
         xI2ekY285UVRX/l0eNH/O7NXT+lSGd2hLTdB/LDautloq9wXaOenTHG3Nj5SNK7aN58w
         DJPHoFHKYNqWXzOBy1HOYvX9O6gSVKKFz65ipUZ7/vzSTlDGh7TcfNzn98xmdTbNfKrB
         HjsnH8MJWxPiH2IOh+WV35WK22PWJc9QSjUgvoG4SmB++vL/85PppnQKAZCPb7SIOHRm
         jJG34476+H416AOaZvR7szVOYDhG9tWbxFaP8pJWwFOhLQ2L+JOry5t5o1NYeR5LVxN1
         wmhg==
X-Gm-Message-State: ACrzQf23ocxQynieEHrOQWOd5jo+GXCTqKAIxzHNttpZaPHZrI/3169w
        /Qn3rektPhzSgDzl69Ch0rF9vGewUaW3yP37
X-Google-Smtp-Source: AMsMyM42vqv1YONW63nh8FnRHNJKmyUOG/hteMSNrrCZTsdp06c1hADrIyNernP/tWI+uBiwCUMByA==
X-Received: by 2002:a05:6a00:1348:b0:56b:f5c0:1d9d with SMTP id k8-20020a056a00134800b0056bf5c01d9dmr10963195pfu.45.1667167330589;
        Sun, 30 Oct 2022 15:02:10 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id y3-20020aa79e03000000b0056d73ef41fdsm562852pfq.75.2022.10.30.15.02.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Oct 2022 15:02:10 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/6] eventpoll: split out wait handling
Date:   Sun, 30 Oct 2022 16:02:00 -0600
Message-Id: <20221030220203.31210-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221030220203.31210-1-axboe@kernel.dk>
References: <20221030220203.31210-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for making changes to how wakeups and sleeps are done,
move the timeout scheduling into a helper and manage it rather than
rely on schedule_hrtimeout_range().

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/eventpoll.c | 68 ++++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 55 insertions(+), 13 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 64d7331353dd..888f565d0c5f 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -1762,6 +1762,47 @@ static int ep_autoremove_wake_function(struct wait_queue_entry *wq_entry,
 	return ret;
 }
 
+struct epoll_wq {
+	wait_queue_entry_t wait;
+	struct hrtimer timer;
+	bool timed_out;
+};
+
+static enum hrtimer_restart ep_timer(struct hrtimer *timer)
+{
+	struct epoll_wq *ewq = container_of(timer, struct epoll_wq, timer);
+	struct task_struct *task = ewq->wait.private;
+
+	ewq->timed_out = true;
+	wake_up_process(task);
+	return HRTIMER_NORESTART;
+}
+
+static void ep_schedule(struct eventpoll *ep, struct epoll_wq *ewq, ktime_t *to,
+			u64 slack)
+{
+	if (ewq->timed_out)
+		return;
+	if (to && *to == 0) {
+		ewq->timed_out = true;
+		return;
+	}
+	if (!to) {
+		schedule();
+		return;
+	}
+
+	hrtimer_init_on_stack(&ewq->timer, CLOCK_MONOTONIC, HRTIMER_MODE_ABS);
+	ewq->timer.function = ep_timer;
+	hrtimer_set_expires_range_ns(&ewq->timer, *to, slack);
+	hrtimer_start_expires(&ewq->timer, HRTIMER_MODE_ABS);
+
+	schedule();
+
+	hrtimer_cancel(&ewq->timer);
+	destroy_hrtimer_on_stack(&ewq->timer);
+}
+
 /**
  * ep_poll - Retrieves ready events, and delivers them to the caller-supplied
  *           event buffer.
@@ -1782,13 +1823,15 @@ static int ep_autoremove_wake_function(struct wait_queue_entry *wq_entry,
 static int ep_poll(struct eventpoll *ep, struct epoll_event __user *events,
 		   int maxevents, struct timespec64 *timeout)
 {
-	int res, eavail, timed_out = 0;
+	int res, eavail;
 	u64 slack = 0;
-	wait_queue_entry_t wait;
 	ktime_t expires, *to = NULL;
+	struct epoll_wq ewq;
 
 	lockdep_assert_irqs_enabled();
 
+	ewq.timed_out = false;
+
 	if (timeout && (timeout->tv_sec | timeout->tv_nsec)) {
 		slack = select_estimate_accuracy(timeout);
 		to = &expires;
@@ -1798,7 +1841,7 @@ static int ep_poll(struct eventpoll *ep, struct epoll_event __user *events,
 		 * Avoid the unnecessary trip to the wait queue loop, if the
 		 * caller specified a non blocking operation.
 		 */
-		timed_out = 1;
+		ewq.timed_out = true;
 	}
 
 	/*
@@ -1823,7 +1866,7 @@ static int ep_poll(struct eventpoll *ep, struct epoll_event __user *events,
 				return res;
 		}
 
-		if (timed_out)
+		if (ewq.timed_out)
 			return 0;
 
 		eavail = ep_busy_loop(ep);
@@ -1850,8 +1893,8 @@ static int ep_poll(struct eventpoll *ep, struct epoll_event __user *events,
 		 * performance issue if a process is killed, causing all of its
 		 * threads to wake up without being removed normally.
 		 */
-		init_wait(&wait);
-		wait.func = ep_autoremove_wake_function;
+		init_wait(&ewq.wait);
+		ewq.wait.func = ep_autoremove_wake_function;
 
 		write_lock_irq(&ep->lock);
 		/*
@@ -1870,10 +1913,9 @@ static int ep_poll(struct eventpoll *ep, struct epoll_event __user *events,
 		 */
 		eavail = ep_events_available(ep);
 		if (!eavail) {
-			__add_wait_queue_exclusive(&ep->wq, &wait);
+			__add_wait_queue_exclusive(&ep->wq, &ewq.wait);
 			write_unlock_irq(&ep->lock);
-			timed_out = !schedule_hrtimeout_range(to, slack,
-							      HRTIMER_MODE_ABS);
+			ep_schedule(ep, &ewq, to, slack);
 		} else {
 			write_unlock_irq(&ep->lock);
 		}
@@ -1887,7 +1929,7 @@ static int ep_poll(struct eventpoll *ep, struct epoll_event __user *events,
 		 */
 		eavail = 1;
 
-		if (!list_empty_careful(&wait.entry)) {
+		if (!list_empty_careful(&ewq.wait.entry)) {
 			write_lock_irq(&ep->lock);
 			/*
 			 * If the thread timed out and is not on the wait queue,
@@ -1896,9 +1938,9 @@ static int ep_poll(struct eventpoll *ep, struct epoll_event __user *events,
 			 * Thus, when wait.entry is empty, it needs to harvest
 			 * events.
 			 */
-			if (timed_out)
-				eavail = list_empty(&wait.entry);
-			__remove_wait_queue(&ep->wq, &wait);
+			if (ewq.timed_out)
+				eavail = list_empty(&ewq.wait.entry);
+			__remove_wait_queue(&ep->wq, &ewq.wait);
 			write_unlock_irq(&ep->lock);
 		}
 	}
-- 
2.35.1

