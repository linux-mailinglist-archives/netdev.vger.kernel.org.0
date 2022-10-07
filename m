Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D9FE5F7BDC
	for <lists+netdev@lfdr.de>; Fri,  7 Oct 2022 18:56:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230002AbiJGQ4t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Oct 2022 12:56:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229805AbiJGQ4q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Oct 2022 12:56:46 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05A41604AC
        for <netdev@vger.kernel.org>; Fri,  7 Oct 2022 09:56:45 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id p70so4063602iod.13
        for <netdev@vger.kernel.org>; Fri, 07 Oct 2022 09:56:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RG3Q+CFVM1jwdBZfpkSgMBovuxPpkHVLQimnfbDB7qo=;
        b=Ccn6u7yVrMjm4PfhysRT3eZJKgn/nieVJoC5uVIx4IaYNlhnUM3QK47Us6ax5DQgkJ
         90L+c9/TwnUfzgBXT0g3JoyAkM+vHiRL0xr1TUfB86vmCZE4ALJPTL97tAsqgd5k717M
         c5AzVt5LrbaZJcVczzLXh/1DvVTkNpQGrYsjnlX7zlW+dNB+UAFHe/Cg6pRXnyfTP5Zk
         PTywbUxXsLI1KEtM0yN6pIeIqS7lGG06PG9Z77r5TrvvRR1hYm9PNQYH/8AtrpoeGrQe
         ReUinQgm1CytQaM0wKeLii6nqIgy57XSohHaR/JrdcpRIlu0ReF4jnw2sBXKsC/LAHSp
         DCJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RG3Q+CFVM1jwdBZfpkSgMBovuxPpkHVLQimnfbDB7qo=;
        b=BJtC0rmFj3elYznfR58qDjyL3pCCmvycNsIuh9b1JJfgge5J8D2WIMtFdsOAbM0Gvc
         V8dPfIO6hV6SqOy2iuhqXSiZWJ/linJ2WpWEZjigKj/u/BQ/LskitEAr92iXOg9dNP4O
         +W6uHsZRm9hKb2uUt6OcSZ5CcaYw+e/tEqDugkpjrm//y+/cXstBTZZIW6MGWLBsctif
         zDuL5zolkz+r6L9nudoLNLUcYMmV0NbSPqiIqMjtxWpJY4A/m8dQVQFHsyvJ3idBiRUt
         7bwgAWmjqBy3lc5EW9SDHrcXI33ndYg+i4xCGsoa+PyOhixPZPVG1+t7XMASTevpSx5J
         4Nfw==
X-Gm-Message-State: ACrzQf38FeDud9Z5tQ/jdCxMUj3mGEwBq5ans1q6ZbjHT+dgvjoxeaKC
        +CO5m/rOh5kpG6J6nKPMr7OQFg==
X-Google-Smtp-Source: AMsMyM4yKZrnfwt2NxMdj+RlCbLqnMTEgMZPruyOyr65JkMUdnD3dNvnizz9JoX9XFqH/FAnikkodw==
X-Received: by 2002:a5d:924b:0:b0:6a4:c19d:c5b3 with SMTP id e11-20020a5d924b000000b006a4c19dc5b3mr2740837iol.147.1665161804288;
        Fri, 07 Oct 2022 09:56:44 -0700 (PDT)
Received: from m1max.localdomain ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id a6-20020a056e020e0600b002eb5eb4f8f9sm1055584ilk.77.2022.10.07.09.56.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Oct 2022 09:56:43 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/4] eventpoll: split out wait handling
Date:   Fri,  7 Oct 2022 10:56:35 -0600
Message-Id: <20221007165637.22374-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221007165637.22374-1-axboe@kernel.dk>
References: <20221007165637.22374-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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
index 8a75ae70e312..01b9dab2b68c 100644
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

