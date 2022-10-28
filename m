Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC2A3611C96
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 23:43:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230047AbiJ1Vnp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 17:43:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230049AbiJ1Vng (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 17:43:36 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F70924BA84
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 14:43:35 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id h14so5725345pjv.4
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 14:43:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2NM4YfZaBNFzd1+6iQahn7Cz4qt0108M3OXrThmpXB0=;
        b=QSevLRS9OTiO72mHM8DveErxfnY+PPoTQqAemtA7ZmP7zXeOfUkue/zXHJ8/mkdf0m
         sXP4l2vc/RUP6ag7sC0cZVDBjKTWfOMOdb8zhLO+kQ+58pJPfBkkDKUlAI9KsZN5MNzD
         AWVJfLl1GYoZJrFJCyW2UjuBirgE9HkkKejDzGQ8Ks9YfPMiZm62NK7f6LcuARcx0NUC
         aojtrmB9RMAf0YVCzztXWbarybI2q8PTtvsHH2nluNW8M8IbNGqbXW/r2R/npCK4kwA4
         9a3OW6U/OJalaH0ZSbjkGoArC/dCB1UWBi5VTLtUNwt4/5m4Nxd8OcKP4KcyUC5nUqk0
         JhTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2NM4YfZaBNFzd1+6iQahn7Cz4qt0108M3OXrThmpXB0=;
        b=f/AqYSoCneJ0b1upteD1L6yRJCyzTry3GrX7kGDAGhBFfzAJKea7v4rA/c9pz251kw
         ZZqTHzZXpc+0wgmvjZfGu88Vnm7ATVWW+fMJ6ldVVx6QM2uKrM4+Kc5TQJBnjwJT9xfF
         awDfq/uLKbN+gBd4d+wiLVZvC713OTxStHkcZBR1mr8xuwiHQIuw8KZcJ7fYQTdtpo/g
         6gXoyi5KlgiEHMWEJmtR+9kp8rCijG7oJ/rGsMUpgEv3YlA9NLwsg4Pj5eExsw79rlJt
         v/yJn3y8dF/Y9zHBUFs6evwlx+DWLOkmIn+e03L6Rq1NXeVPmt5SX9EZWNT/1rjB0fpF
         4AgQ==
X-Gm-Message-State: ACrzQf2DPyTj2jpFNWRdctagbO7hrhqRlmzNO2BmaZuR4DmGuPXX/vlU
        2ngSgEvI/sFifx8YiRTgGuCGWA==
X-Google-Smtp-Source: AMsMyM6LQH2gxKLwOMt+h2s5d9RZvAV6b+cGrRjw9AcZ9pW1VpZyCPZ73M780Aw8h/mrCYvFXtE2DA==
X-Received: by 2002:a17:90b:1d0f:b0:20d:1ec3:f732 with SMTP id on15-20020a17090b1d0f00b0020d1ec3f732mr1385609pjb.84.1666993415000;
        Fri, 28 Oct 2022 14:43:35 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id u6-20020a17090a1d4600b002130c269b6fsm2993855pju.1.2022.10.28.14.43.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Oct 2022 14:43:34 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5/5] eventpoll: add support for min-wait
Date:   Fri, 28 Oct 2022 15:43:25 -0600
Message-Id: <20221028214325.13496-6-axboe@kernel.dk>
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
 fs/eventpoll.c                 | 100 ++++++++++++++++++++++++++++-----
 include/linux/eventpoll.h      |   2 +-
 include/uapi/linux/eventpoll.h |   1 +
 3 files changed, 87 insertions(+), 16 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index cd2138d02bda..828e2b9771d6 100644
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
@@ -1831,12 +1873,14 @@ static int ep_poll(struct eventpoll *ep, struct epoll_event __user *events,
 
 	lockdep_assert_irqs_enabled();
 
+	ewq.ep = ep;
 	ewq.timed_out = false;
+	ewq.maxevents = maxevents;
+	ewq.wakeups = 0;
 
 	if (timeout && (timeout->tv_sec | timeout->tv_nsec)) {
 		slack = select_estimate_accuracy(timeout);
-		to = &ewq.timeout_ts;
-		*to = timespec64_to_ktime(*timeout);
+		ewq.timeout_ts = timespec64_to_ktime(*timeout);
 	} else if (timeout) {
 		/*
 		 * Avoid the unnecessary trip to the wait queue loop, if the
@@ -1845,6 +1889,21 @@ static int ep_poll(struct eventpoll *ep, struct epoll_event __user *events,
 		ewq.timed_out = 1;
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
+	} else {
+		ewq.min_wait_ts = 0;
+		to = &ewq.timeout_ts;
+	}
+
 	/*
 	 * This call is racy: We may or may not see events that are being added
 	 * to the ready list under the lock (e.g., in IRQ callbacks). For cases
@@ -1913,7 +1972,7 @@ static int ep_poll(struct eventpoll *ep, struct epoll_event __user *events,
 		 * important.
 		 */
 		eavail = ep_events_available(ep);
-		if (!eavail) {
+		if (!eavail || ewq.min_wait_ts & 1) {
 			__add_wait_queue_exclusive(&ep->wq, &ewq.wait);
 			write_unlock_irq(&ep->lock);
 			ep_schedule(ep, &ewq, to, slack);
@@ -2125,6 +2184,17 @@ int do_epoll_ctl(int epfd, int op, int fd, struct epoll_event *epds,
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
@@ -2257,7 +2327,7 @@ SYSCALL_DEFINE4(epoll_ctl, int, epfd, int, op, int, fd,
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

