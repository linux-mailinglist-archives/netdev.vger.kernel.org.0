Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B46ED612D31
	for <lists+netdev@lfdr.de>; Sun, 30 Oct 2022 23:02:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230048AbiJ3WCo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Oct 2022 18:02:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbiJ3WCc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Oct 2022 18:02:32 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54857BC3E
        for <netdev@vger.kernel.org>; Sun, 30 Oct 2022 15:02:14 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id j12so9235043plj.5
        for <netdev@vger.kernel.org>; Sun, 30 Oct 2022 15:02:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pwT9F3VGgPNDdfJa3yPd0dcN35etavVFYMg4RY5YL0o=;
        b=VIkEe8kfBczuf+b12NGhnxMQuafEN/XF99q0aDh4J9MnhwgaMH7hDBHb9s3jvYnyTg
         ImBJ8HIU6TWGEhH9qVBxjZDvHd8JpOSmpvoktzoCxu2ynpY/0oPVA0ymJRJnbFRRw6KB
         aMxQWidSacHx7htlYYplGXwVmuHkU7evUOXkUvg0EBLxwtSEviMeCodR2MG/Z1Tkhvs+
         6tEMfVStRqMe3+TVpGewnXQoFSZH9DEzI8Mg3D5IbWx4GX0ZSxrF9W31BhGX3xP82rPK
         K1NDqcdmIGhhiCrYTSCEXi6SBeV8LkBSZXCMvpBVgddljCOA/ZuTi0g9v4Z+9HqwnvLB
         p0zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pwT9F3VGgPNDdfJa3yPd0dcN35etavVFYMg4RY5YL0o=;
        b=IH8qHNVEvIXEZJYtGS/kzMFgok+uJu4seWy4aBmA4ltjrjKsQQBQsXHMxVIp/YLmst
         RuIQE//FULrHBvzETt4MoCXCmuuFh4YD6jeOunHMkZtJt7Fo6Qr4UgxHJJBoYeYZIz9d
         cNLbrR/jR5IU+Ty/roon43vo48TB4p4v3/4xBqAEKrH9s0nGH5hujWOBC1KyZyKyka8m
         SD3CRfHem6hh0Jmf8EVll2gxQA1ZyNZp0rTyu2aqTOY174g2syOYfkW8lDbsJgGmk0+B
         0qa8GG0xVoTbtOxWBBFTDtDnPT1uNdn/LGS49ZC/9cIzoe7XA3Wl7TCQRqMkG4U2IU8r
         kwZg==
X-Gm-Message-State: ACrzQf2VglXo9kUE0pva+b9fhlwQDY167eij5WJqJfs+AssDCPnMBFCa
        ZuA+2B1Y6XjRUwxQQvjDKS6DA+X/OPMiJiDN
X-Google-Smtp-Source: AMsMyM5oezGWS2uuaJrw0tYnaqdg8Gzy8DXtwyYycWSJySaDFqjPaO9aeThPTXH6sui2BPFZkTbG0w==
X-Received: by 2002:a17:902:b614:b0:186:940d:7e98 with SMTP id b20-20020a170902b61400b00186940d7e98mr11208913pls.80.1667167333625;
        Sun, 30 Oct 2022 15:02:13 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id y3-20020aa79e03000000b0056d73ef41fdsm562852pfq.75.2022.10.30.15.02.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Oct 2022 15:02:13 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6/6] eventpoll: add support for min-wait
Date:   Sun, 30 Oct 2022 16:02:03 -0600
Message-Id: <20221030220203.31210-7-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221030220203.31210-1-axboe@kernel.dk>
References: <20221030220203.31210-1-axboe@kernel.dk>
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

Rather than just have a timeout value for waiting on events, add
EPOLL_CTL_MIN_WAIT to allow setting a minimum time that epoll_wait()
should always wait for events to arrive.

For medium workload efficiencies, some production workloads inject
artificial timers or sleeps before calling epoll_wait() to get
better batching and higher efficiencies. While this does help, it's
not as efficient as it could be. By adding support for epoll_wait()
for this directly, we can avoids extra context switches and scheduler
and timer overhead.

As an example, running an AB test on an identical workload at about
~370K reqs/second, without this change and with the sleep hack
mentioned above (using 200 usec as the timeout), we're doing 310K-340K
non-voluntary context switches per second. Idle CPU on the host is 27-34%.
With the the sleep hack removed and epoll set to the same 200 usec
value, we're handling the exact same load but at 292K-315k non-voluntary
context switches and idle CPU of 33-41%, a substantial win.

Basic test case:

struct d {
        int p1, p2;
};

static void *fn(void *data)
{
        struct d *d = data;
        char b = 0x89;

	/* Generate 2 events 20 msec apart */
        usleep(10000);
        write(d->p1, &b, sizeof(b));
        usleep(10000);
        write(d->p2, &b, sizeof(b));

        return NULL;
}

int main(int argc, char *argv[])
{
        struct epoll_event ev, events[2];
        pthread_t thread;
        int p1[2], p2[2];
        struct d d;
        int efd, ret;

        efd = epoll_create1(0);
        if (efd < 0) {
                perror("epoll_create");
                return 1;
        }

        if (pipe(p1) < 0) {
                perror("pipe");
                return 1;
        }
        if (pipe(p2) < 0) {
                perror("pipe");
                return 1;
        }

        ev.events = EPOLLIN;
        ev.data.fd = p1[0];
        if (epoll_ctl(efd, EPOLL_CTL_ADD, p1[0], &ev) < 0) {
                perror("epoll add");
                return 1;
        }
        ev.events = EPOLLIN;
        ev.data.fd = p2[0];
        if (epoll_ctl(efd, EPOLL_CTL_ADD, p2[0], &ev) < 0) {
                perror("epoll add");
                return 1;
        }

	/* always wait 200 msec for events */
        ev.data.u64 = 200000;
        if (epoll_ctl(efd, EPOLL_CTL_MIN_WAIT, -1, &ev) < 0) {
                perror("epoll add set timeout");
                return 1;
        }

        d.p1 = p1[1];
        d.p2 = p2[1];
        pthread_create(&thread, NULL, fn, &d);

	/* expect to get 2 events here rather than just 1 */
        ret = epoll_wait(efd, events, 2, -1);
        printf("epoll_wait=%d\n", ret);

        return 0;
}

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/eventpoll.c                 | 97 +++++++++++++++++++++++++++++-----
 include/linux/eventpoll.h      |  2 +-
 include/uapi/linux/eventpoll.h |  1 +
 3 files changed, 85 insertions(+), 15 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 962d897bbfc6..9e00f8780ec5 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -117,6 +117,9 @@ struct eppoll_entry {
 	/* The "base" pointer is set to the container "struct epitem" */
 	struct epitem *base;
 
+	/* min wait time if (min_wait_ts) & 1 != 0 */
+	ktime_t min_wait_ts;
+
 	/*
 	 * Wait queue item that will be linked to the target file wait
 	 * queue head.
@@ -217,6 +220,9 @@ struct eventpoll {
 	u64 gen;
 	struct hlist_head refs;
 
+	/* min wait for epoll_wait() */
+	unsigned int min_wait_ts;
+
 #ifdef CONFIG_NET_RX_BUSY_POLL
 	/* used to track busy poll napi_id */
 	unsigned int napi_id;
@@ -1747,6 +1753,32 @@ static struct timespec64 *ep_timeout_to_timespec(struct timespec64 *to, long ms)
 	return to;
 }
 
+struct epoll_wq {
+	wait_queue_entry_t wait;
+	struct hrtimer timer;
+	ktime_t timeout_ts;
+	ktime_t min_wait_ts;
+	struct eventpoll *ep;
+	bool timed_out;
+	int maxevents;
+	int wakeups;
+};
+
+static bool ep_should_min_wait(struct epoll_wq *ewq)
+{
+	if (ewq->min_wait_ts & 1) {
+		/* just an approximation */
+		if (++ewq->wakeups >= ewq->maxevents)
+			goto stop_wait;
+		if (ktime_before(ktime_get_ns(), ewq->min_wait_ts))
+			return true;
+	}
+
+stop_wait:
+	ewq->min_wait_ts &= ~(u64) 1;
+	return false;
+}
+
 /*
  * autoremove_wake_function, but remove even on failure to wake up, because we
  * know that default_wake_function/ttwu will only fail if the thread is already
@@ -1756,27 +1788,37 @@ static struct timespec64 *ep_timeout_to_timespec(struct timespec64 *to, long ms)
 static int ep_autoremove_wake_function(struct wait_queue_entry *wq_entry,
 				       unsigned int mode, int sync, void *key)
 {
-	int ret = default_wake_function(wq_entry, mode, sync, key);
+	struct epoll_wq *ewq = container_of(wq_entry, struct epoll_wq, wait);
+	int ret;
+
+	/*
+	 * If min wait time hasn't been satisfied yet, keep waiting
+	 */
+	if (ep_should_min_wait(ewq))
+		return 0;
 
+	ret = default_wake_function(wq_entry, mode, sync, key);
 	list_del_init(&wq_entry->entry);
 	return ret;
 }
 
-struct epoll_wq {
-	wait_queue_entry_t wait;
-	struct hrtimer timer;
-	ktime_t timeout_ts;
-	bool timed_out;
-};
-
 static enum hrtimer_restart ep_timer(struct hrtimer *timer)
 {
 	struct epoll_wq *ewq = container_of(timer, struct epoll_wq, timer);
 	struct task_struct *task = ewq->wait.private;
+	const bool is_min_wait = ewq->min_wait_ts & 1;
+
+	if (!is_min_wait || ep_events_available(ewq->ep)) {
+		if (!is_min_wait)
+			ewq->timed_out = true;
+		ewq->min_wait_ts &= ~(u64) 1;
+		wake_up_process(task);
+		return HRTIMER_NORESTART;
+	}
 
-	ewq->timed_out = true;
-	wake_up_process(task);
-	return HRTIMER_NORESTART;
+	ewq->min_wait_ts &= ~(u64) 1;
+	hrtimer_set_expires_range_ns(&ewq->timer, ewq->timeout_ts, 0);
+	return HRTIMER_RESTART;
 }
 
 static void ep_schedule(struct eventpoll *ep, struct epoll_wq *ewq, ktime_t *to,
@@ -1831,12 +1873,16 @@ static int ep_poll(struct eventpoll *ep, struct epoll_event __user *events,
 
 	lockdep_assert_irqs_enabled();
 
+	ewq.min_wait_ts = 0;
+	ewq.ep = ep;
+	ewq.maxevents = maxevents;
 	ewq.timed_out = false;
+	ewq.wakeups = 0;
 
 	if (timeout && (timeout->tv_sec | timeout->tv_nsec)) {
 		slack = select_estimate_accuracy(timeout);
+		ewq.timeout_ts = timespec64_to_ktime(*timeout);
 		to = &ewq.timeout_ts;
-		*to = timespec64_to_ktime(*timeout);
 	} else if (timeout) {
 		/*
 		 * Avoid the unnecessary trip to the wait queue loop, if the
@@ -1845,6 +1891,18 @@ static int ep_poll(struct eventpoll *ep, struct epoll_event __user *events,
 		ewq.timed_out = true;
 	}
 
+	/*
+	 * If min_wait is set for this epoll instance, note the min_wait
+	 * time. Ensure the lowest bit is set in ewq.min_wait_ts, that's
+	 * the state bit for whether or not min_wait is enabled.
+	 */
+	if (ep->min_wait_ts) {
+		ewq.min_wait_ts = ktime_add_us(ktime_get_ns(),
+						ep->min_wait_ts);
+		ewq.min_wait_ts |= (u64) 1;
+		to = &ewq.min_wait_ts;
+	}
+
 	/*
 	 * This call is racy: We may or may not see events that are being added
 	 * to the ready list under the lock (e.g., in IRQ callbacks). For cases
@@ -1913,7 +1971,7 @@ static int ep_poll(struct eventpoll *ep, struct epoll_event __user *events,
 		 * important.
 		 */
 		eavail = ep_events_available(ep);
-		if (!eavail) {
+		if (!eavail || ewq.min_wait_ts & 1) {
 			__add_wait_queue_exclusive(&ep->wq, &ewq.wait);
 			write_unlock_irq(&ep->lock);
 			ep_schedule(ep, &ewq, to, slack);
@@ -2125,6 +2183,17 @@ int do_epoll_ctl(int epfd, int op, int fd, struct epoll_event *epds,
 	 */
 	ep = f.file->private_data;
 
+	/*
+	 * Handle EPOLL_CTL_MIN_WAIT upfront as we don't need to care about
+	 * the fd being passed in.
+	 */
+	if (op == EPOLL_CTL_MIN_WAIT) {
+		/* return old value */
+		error = ep->min_wait_ts;
+		ep->min_wait_ts = epds->data;
+		goto error_fput;
+	}
+
 	/* Get the "struct file *" for the target file */
 	tf = fdget(fd);
 	if (!tf.file)
@@ -2257,7 +2326,7 @@ SYSCALL_DEFINE4(epoll_ctl, int, epfd, int, op, int, fd,
 {
 	struct epoll_event epds;
 
-	if (ep_op_has_event(op) &&
+	if ((ep_op_has_event(op) || op == EPOLL_CTL_MIN_WAIT) &&
 	    copy_from_user(&epds, event, sizeof(struct epoll_event)))
 		return -EFAULT;
 
diff --git a/include/linux/eventpoll.h b/include/linux/eventpoll.h
index 3337745d81bd..cbef635cb7e4 100644
--- a/include/linux/eventpoll.h
+++ b/include/linux/eventpoll.h
@@ -59,7 +59,7 @@ int do_epoll_ctl(int epfd, int op, int fd, struct epoll_event *epds,
 /* Tells if the epoll_ctl(2) operation needs an event copy from userspace */
 static inline int ep_op_has_event(int op)
 {
-	return op != EPOLL_CTL_DEL;
+	return op != EPOLL_CTL_DEL && op != EPOLL_CTL_MIN_WAIT;
 }
 
 #else
diff --git a/include/uapi/linux/eventpoll.h b/include/uapi/linux/eventpoll.h
index 8a3432d0f0dc..81ecb1ca36e0 100644
--- a/include/uapi/linux/eventpoll.h
+++ b/include/uapi/linux/eventpoll.h
@@ -26,6 +26,7 @@
 #define EPOLL_CTL_ADD 1
 #define EPOLL_CTL_DEL 2
 #define EPOLL_CTL_MOD 3
+#define EPOLL_CTL_MIN_WAIT	4
 
 /* Epoll event masks */
 #define EPOLLIN		(__force __poll_t)0x00000001
-- 
2.35.1

