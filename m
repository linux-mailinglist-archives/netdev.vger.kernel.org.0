Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0F66611C93
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 23:43:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230035AbiJ1Vni (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 17:43:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229995AbiJ1Vnc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 17:43:32 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B68524AE26
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 14:43:32 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id t10-20020a17090a4e4a00b0020af4bcae10so5648543pjl.3
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 14:43:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tiguh3u9eggshsoZh3GPe1CsJMkdP/JI4kBBBED1cmY=;
        b=hx1oQADEdyNFaX9tPTLZ7yu68JZNzS/ZRcV4/4ftjbbkrAqlVDlR59NVfME3EASL7q
         SmUZXZegPFn0vYGmx5BxprclqeaTTW4QnM2arglNSSFwKQrl1iodtZu8BXYqFEqnVuFi
         ljvLjzPtuZoTpUh1IE0dt0gDTqUuRuJZSvKmAldJaFcuvir511BxZioWBr8snZtpOmNU
         kGRxJs0HfTGxIVuRLAEQsgxVWerlzfBzFwlw1DdShu+GHUP2kGzSd8BQMNa4mjKlAhrd
         4Xx36O4qXEWvcpXh4xVohKWyW6vQoZAyKJl8g8ZBtW4724mea8IKCS9fUeXxyXQ3S0AK
         SwRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tiguh3u9eggshsoZh3GPe1CsJMkdP/JI4kBBBED1cmY=;
        b=R8FoMSUJLPUFP+gkio1Ezwlcu+twMBsij6WU26R+XFSpk0j2S9Cq5Sx4uuyiUJNrGB
         09sAswPWuRvdvznw1fhoYqIJ1SfrGV/LTLcqn5jvdLpYLnu2iyHY7I4phedwiYncik6B
         JIp7TLBbfvvyC7BudoJlnwxRpOWynrGmwjFwDYChKZnWNbYpEtBD592o1zX1kPTgohKl
         kbjELM4MoK2Xmf1VVupelzN1rJa0qByIErYnFeeORd32WvQR+A++qaqG66yNCe71S17q
         bRyPnro36tIQLkMvZ5MCftwGj1xAirfzGUXU2q+XWjBqJ5ohgwTRlgyHvS+Xqm9bosyV
         OWMg==
X-Gm-Message-State: ACrzQf2WMoVqW3kl8LMYqwG1Qj7VwlPgZrbzWP45wEg33bNlZiJ5kmCQ
        vgZv6gT49ebbgT/LeLc3vMfmhjajC23VvF6l
X-Google-Smtp-Source: AMsMyM5U4tIkoVbAxg2W2YcqNlaUDVW0F08OMYNTQCoxPHT++pYSP5jfFOuq12r/eqpi44eoAgcwGQ==
X-Received: by 2002:a17:90a:4ece:b0:213:1130:ca9c with SMTP id v14-20020a17090a4ece00b002131130ca9cmr17984235pjl.17.1666993411637;
        Fri, 28 Oct 2022 14:43:31 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id u6-20020a17090a1d4600b002130c269b6fsm2993855pju.1.2022.10.28.14.43.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Oct 2022 14:43:31 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/5] eventpoll: split out wait handling
Date:   Fri, 28 Oct 2022 15:43:22 -0600
Message-Id: <20221028214325.13496-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221028214325.13496-1-axboe@kernel.dk>
References: <20221028214325.13496-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
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
 fs/eventpoll.c | 70 ++++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 56 insertions(+), 14 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 3061bdde6cba..f53bb4ec9e91 100644
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
+		ewq.timed_out = 1;
 	}
 
 	/*
@@ -1823,10 +1866,10 @@ static int ep_poll(struct eventpoll *ep, struct epoll_event __user *events,
 				return res;
 		}
 
-		if (timed_out)
+		if (ewq.timed_out)
 			return 0;
 
-		eavail = ep_busy_loop(ep, timed_out);
+		eavail = ep_busy_loop(ep, ewq.timed_out);
 		if (eavail)
 			continue;
 
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

