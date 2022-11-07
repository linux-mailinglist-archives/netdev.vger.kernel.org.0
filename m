Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 237C061FC19
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 18:54:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232466AbiKGRye (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 12:54:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231712AbiKGRyG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 12:54:06 -0500
Received: from 66-220-144-178.mail-mxout.facebook.com (66-220-144-178.mail-mxout.facebook.com [66.220.144.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11DAD252A6
        for <netdev@vger.kernel.org>; Mon,  7 Nov 2022 09:53:05 -0800 (PST)
Received: by dev0134.prn3.facebook.com (Postfix, from userid 425415)
        id 21936F6B5E4; Mon,  7 Nov 2022 09:52:50 -0800 (PST)
From:   Stefan Roesch <shr@devkernel.io>
To:     kernel-team@fb.com
Cc:     shr@devkernel.io, axboe@kernel.dk, olivier@trillion01.com,
        netdev@vger.kernel.org, io-uring@vger.kernel.org, kuba@kernel.org
Subject: [RFC PATCH v2 1/2] io_uring: add napi busy polling support
Date:   Mon,  7 Nov 2022 09:52:39 -0800
Message-Id: <20221107175240.2725952-2-shr@devkernel.io>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221107175240.2725952-1-shr@devkernel.io>
References: <20221107175240.2725952-1-shr@devkernel.io>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.1 required=5.0 tests=BAYES_00,RDNS_DYNAMIC,
        SPF_HELO_PASS,SPF_NEUTRAL,TVD_RCVD_IP autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds the napi busy polling support in io_uring.c. It adds a new
napi_list to the io_ring_ctx structure. This list contains the list of
napi_id's that are currently enabled for busy polling. The list is
synchronized by the new napi_lock spin lock. The current default napi
busy polling time is stored in napi_busy_poll_to. If napi busy polling
is not enabled, the value is 0.

The busy poll timeout is also stored as part of the io_wait_queue. This
is necessary as for sq polling the poll interval needs to be adjusted
and the napi callback allows only to pass in one value.

Testing has shown that the round-trip times are reduced to 38us from
55us by enabling napi busy polling with a busy poll timeout of 100us.

Signed-off-by: Stefan Roesch <shr@devkernel.io>
Suggested-by: Olivier Langlois <olivier@trillion01.com>
---
 include/linux/io_uring_types.h |   6 +
 io_uring/io_uring.c            | 240 +++++++++++++++++++++++++++++++++
 io_uring/napi.h                |  22 +++
 io_uring/poll.c                |   3 +
 io_uring/sqpoll.c              |   9 ++
 5 files changed, 280 insertions(+)
 create mode 100644 io_uring/napi.h

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_type=
s.h
index f5b687a787a3..84b446b0d215 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -270,6 +270,12 @@ struct io_ring_ctx {
 	struct xarray		personalities;
 	u32			pers_next;
=20
+#ifdef CONFIG_NET_RX_BUSY_POLL
+	struct list_head	napi_list;	/* track busy poll napi_id */
+	spinlock_t		napi_lock;	/* napi_list lock */
+	unsigned int		napi_busy_poll_to; /* napi busy poll default timeout */
+#endif
+
 	struct {
 		/*
 		 * We cache a range of free CQEs we can use, once exhausted it
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index ac8c488e3077..b02bba4ebcbf 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -90,6 +90,7 @@
 #include "rsrc.h"
 #include "cancel.h"
 #include "net.h"
+#include "napi.h"
 #include "notif.h"
=20
 #include "timeout.h"
@@ -327,6 +328,13 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(=
struct io_uring_params *p)
 	INIT_WQ_LIST(&ctx->locked_free_list);
 	INIT_DELAYED_WORK(&ctx->fallback_work, io_fallback_req_func);
 	INIT_WQ_LIST(&ctx->submit_state.compl_reqs);
+
+#ifdef CONFIG_NET_RX_BUSY_POLL
+	INIT_LIST_HEAD(&ctx->napi_list);
+	spin_lock_init(&ctx->napi_lock);
+	ctx->napi_busy_poll_to =3D READ_ONCE(sysctl_net_busy_poll);
+#endif
+
 	return ctx;
 err:
 	kfree(ctx->dummy_ubuf);
@@ -2303,6 +2311,10 @@ struct io_wait_queue {
 	struct io_ring_ctx *ctx;
 	unsigned cq_tail;
 	unsigned nr_timeouts;
+
+#ifdef CONFIG_NET_RX_BUSY_POLL
+	unsigned int busy_poll_to;
+#endif
 };
=20
 static inline bool io_has_work(struct io_ring_ctx *ctx)
@@ -2376,6 +2388,198 @@ static inline int io_cqring_wait_schedule(struct =
io_ring_ctx *ctx,
 	return 1;
 }
=20
+#ifdef CONFIG_NET_RX_BUSY_POLL
+#define NAPI_TIMEOUT		(60 * SEC_CONVERSION)
+
+struct io_napi_entry {
+	struct list_head	list;
+	unsigned int		napi_id;
+	unsigned long		timeout;
+};
+
+static bool io_napi_busy_loop_on(struct io_ring_ctx *ctx)
+{
+	return READ_ONCE(ctx->napi_busy_poll_to);
+}
+
+/*
+ * io_napi_add() - Add napi id to the busy poll list
+ * @file: file pointer for socket
+ * @ctx:  io-uring context
+ *
+ * Add the napi id of the socket to the napi busy poll list.
+ */
+void io_napi_add(struct file *file, struct io_ring_ctx *ctx)
+{
+	unsigned int napi_id;
+	struct socket *sock;
+	struct sock *sk;
+	struct io_napi_entry *ne;
+
+	if (!io_napi_busy_loop_on(ctx))
+		return;
+
+	sock =3D sock_from_file(file);
+	if (!sock)
+		return;
+
+	sk =3D sock->sk;
+	if (!sk)
+		return;
+
+	napi_id =3D READ_ONCE(sk->sk_napi_id);
+
+	/* Non-NAPI IDs can be rejected */
+	if (napi_id < MIN_NAPI_ID)
+		return;
+
+	spin_lock(&ctx->napi_lock);
+	list_for_each_entry(ne, &ctx->napi_list, list) {
+		if (ne->napi_id =3D=3D napi_id) {
+			ne->timeout =3D jiffies + NAPI_TIMEOUT;
+			goto out;
+		}
+	}
+
+	ne =3D kmalloc(sizeof(*ne), GFP_NOWAIT);
+	if (!ne)
+		goto out;
+
+	ne->napi_id =3D napi_id;
+	ne->timeout =3D jiffies + NAPI_TIMEOUT;
+	list_add_tail(&ne->list, &ctx->napi_list);
+
+out:
+	spin_unlock(&ctx->napi_lock);
+}
+
+static void io_napi_free_list(struct io_ring_ctx *ctx)
+{
+	spin_lock(&ctx->napi_lock);
+	while (!list_empty(&ctx->napi_list)) {
+		struct io_napi_entry *ne =3D
+			list_first_entry(&ctx->napi_list,
+					struct io_napi_entry, list);
+
+		list_del(&ne->list);
+		kfree(ne);
+	}
+	spin_unlock(&ctx->napi_lock);
+}
+
+static void io_napi_adjust_busy_loop_timeout(unsigned int poll_to,
+					     struct timespec64 *ts,
+					     unsigned int *new_poll_to)
+{
+	struct timespec64 pollto =3D ns_to_timespec64(1000 * (s64)poll_to);
+
+	if (timespec64_compare(ts, &pollto) > 0) {
+		*ts =3D timespec64_sub(*ts, pollto);
+		*new_poll_to =3D poll_to;
+	} else {
+		u64 to =3D timespec64_to_ns(ts);
+
+		do_div(to, 1000);
+		*new_poll_to =3D to;
+		ts->tv_sec =3D 0;
+		ts->tv_nsec =3D 0;
+	}
+}
+
+static inline bool io_napi_busy_loop_timeout(unsigned long start_time,
+					     unsigned long bp_usec)
+{
+	if (bp_usec) {
+		unsigned long end_time =3D start_time + bp_usec;
+		unsigned long now =3D busy_loop_current_time();
+
+		return time_after(now, end_time);
+	}
+	return true;
+}
+
+static inline void io_napi_check_entry_timeout(struct io_napi_entry *ne)
+{
+	if (time_after(jiffies, ne->timeout)) {
+		list_del(&ne->list);
+		kfree(ne);
+	}
+}
+
+/*
+ * io_napi_busy_loop() - napi busy poll loop
+ * @napi_list: list of napi_id's supporting busy polling
+ *
+ * This invokes the napi busy poll loop if sockets have been added to th=
e
+ * napi busy poll list.
+ *
+ * Returns if all napi-id's in the list have been processed.
+ */
+bool io_napi_busy_loop(struct list_head *napi_list)
+{
+	struct io_napi_entry *ne;
+	struct io_napi_entry *n;
+
+	list_for_each_entry_safe(ne, n, napi_list, list) {
+		napi_busy_loop(ne->napi_id, NULL, NULL, true, BUSY_POLL_BUDGET);
+		io_napi_check_entry_timeout(ne);
+	}
+
+	return !list_empty(napi_list);
+}
+
+static bool io_napi_busy_loop_end(void *p, unsigned long start_time)
+{
+	struct io_wait_queue *iowq =3D p;
+
+	return signal_pending(current) ||
+	       io_should_wake(iowq) ||
+	       io_napi_busy_loop_timeout(start_time, iowq->busy_poll_to);
+}
+
+static void io_napi_blocking_busy_loop(struct list_head *napi_list,
+				       struct io_wait_queue *iowq)
+{
+	unsigned long start_time =3D list_is_singular(napi_list)
+					? 0
+					: busy_loop_current_time();
+
+	do {
+		if (list_is_singular(napi_list)) {
+			struct io_napi_entry *ne =3D
+				list_first_entry(napi_list,
+						 struct io_napi_entry, list);
+
+			napi_busy_loop(ne->napi_id, io_napi_busy_loop_end, iowq,
+				       true, BUSY_POLL_BUDGET);
+			io_napi_check_entry_timeout(ne);
+			break;
+		}
+	} while (io_napi_busy_loop(napi_list) &&
+		 !io_napi_busy_loop_end(iowq, start_time));
+}
+
+static void io_napi_putback_list(struct io_ring_ctx *ctx,
+				 struct list_head *napi_list)
+{
+	struct io_napi_entry *cne;
+	struct io_napi_entry *lne;
+
+	spin_lock(&ctx->napi_lock);
+	list_for_each_entry(cne, &ctx->napi_list, list) {
+		list_for_each_entry(lne, napi_list, list) {
+			if (cne->napi_id =3D=3D lne->napi_id) {
+				list_del(&lne->list);
+				kfree(lne);
+				break;
+			}
+		}
+	}
+	list_splice(napi_list, &ctx->napi_list);
+	spin_unlock(&ctx->napi_lock);
+}
+#endif
+
 /*
  * Wait until events become available, if we don't already have some. Th=
e
  * application must reap them itself, as they reside on the shared cq ri=
ng.
@@ -2388,6 +2592,9 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, =
int min_events,
 	struct io_rings *rings =3D ctx->rings;
 	ktime_t timeout =3D KTIME_MAX;
 	int ret;
+#ifdef CONFIG_NET_RX_BUSY_POLL
+	LIST_HEAD(local_napi_list);
+#endif
=20
 	if (!io_allowed_run_tw(ctx))
 		return -EEXIST;
@@ -2416,13 +2623,34 @@ static int io_cqring_wait(struct io_ring_ctx *ctx=
, int min_events,
 			return ret;
 	}
=20
+#ifdef CONFIG_NET_RX_BUSY_POLL
+	iowq.busy_poll_to =3D 0;
+	if (!(ctx->flags & IORING_SETUP_SQPOLL)) {
+		spin_lock(&ctx->napi_lock);
+		list_splice_init(&ctx->napi_list, &local_napi_list);
+		spin_unlock(&ctx->napi_lock);
+	}
+#endif
+
 	if (uts) {
 		struct timespec64 ts;
=20
 		if (get_timespec64(&ts, uts))
 			return -EFAULT;
+
+#ifdef CONFIG_NET_RX_BUSY_POLL
+		if (!list_empty(&local_napi_list)) {
+			io_napi_adjust_busy_loop_timeout(READ_ONCE(ctx->napi_busy_poll_to),
+						&ts, &iowq.busy_poll_to);
+		}
+#endif
 		timeout =3D ktime_add_ns(timespec64_to_ktime(ts), ktime_get_ns());
 	}
+#ifdef CONFIG_NET_RX_BUSY_POLL
+	else if (!list_empty(&local_napi_list)) {
+		iowq.busy_poll_to =3D READ_ONCE(ctx->napi_busy_poll_to);
+	}
+#endif
=20
 	init_waitqueue_func_entry(&iowq.wq, io_wake_function);
 	iowq.wq.private =3D current;
@@ -2432,6 +2660,15 @@ static int io_cqring_wait(struct io_ring_ctx *ctx,=
 int min_events,
 	iowq.cq_tail =3D READ_ONCE(ctx->rings->cq.head) + min_events;
=20
 	trace_io_uring_cqring_wait(ctx, min_events);
+
+#ifdef CONFIG_NET_RX_BUSY_POLL
+	if (iowq.busy_poll_to)
+		io_napi_blocking_busy_loop(&local_napi_list, &iowq);
+
+	if (!list_empty(&local_napi_list))
+		io_napi_putback_list(ctx, &local_napi_list);
+#endif
+
 	do {
 		/* if we can't even flush overflow, don't wait for more */
 		if (!io_cqring_overflow_flush(ctx)) {
@@ -2631,6 +2868,9 @@ static __cold void io_ring_ctx_free(struct io_ring_=
ctx *ctx)
 	io_req_caches_free(ctx);
 	if (ctx->hash_map)
 		io_wq_put_hash(ctx->hash_map);
+#ifdef CONFIG_NET_RX_BUSY_POLL
+	io_napi_free_list(ctx);
+#endif
 	kfree(ctx->cancel_table.hbs);
 	kfree(ctx->cancel_table_locked.hbs);
 	kfree(ctx->dummy_ubuf);
diff --git a/io_uring/napi.h b/io_uring/napi.h
new file mode 100644
index 000000000000..81ebaff07c68
--- /dev/null
+++ b/io_uring/napi.h
@@ -0,0 +1,22 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#ifndef IOU_NAPI_H
+#define IOU_NAPI_H
+
+#include <linux/kernel.h>
+#include <linux/io_uring.h>
+#include <net/busy_poll.h>
+
+#ifdef CONFIG_NET_RX_BUSY_POLL
+
+void io_napi_add(struct file *file, struct io_ring_ctx *ctx);
+bool io_napi_busy_loop(struct list_head *napi_list);
+
+#else
+
+static inline void io_napi_add(struct file *file, struct io_ring_ctx *ct=
x)
+{
+}
+
+#endif
+#endif
diff --git a/io_uring/poll.c b/io_uring/poll.c
index 0d9f49c575e0..38ed9f254075 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -15,6 +15,7 @@
=20
 #include "io_uring.h"
 #include "refs.h"
+#include "napi.h"
 #include "opdef.h"
 #include "kbuf.h"
 #include "poll.h"
@@ -248,6 +249,7 @@ static int io_poll_check_events(struct io_kiocb *req,=
 bool *locked)
 				io_req_set_res(req, mask, 0);
 				return IOU_POLL_REMOVE_POLL_USE_RES;
 			}
+			io_napi_add(req->file, ctx);
 		} else {
 			ret =3D io_poll_issue(req, locked);
 			if (ret =3D=3D IOU_STOP_MULTISHOT)
@@ -564,6 +566,7 @@ static int __io_arm_poll_handler(struct io_kiocb *req=
,
 		__io_poll_execute(req, mask);
 		return 0;
 	}
+	io_napi_add(req->file, req->ctx);
=20
 	if (ipt->owning) {
 		/*
diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
index 559652380672..8c0a1c09a9a6 100644
--- a/io_uring/sqpoll.c
+++ b/io_uring/sqpoll.c
@@ -15,6 +15,7 @@
 #include <uapi/linux/io_uring.h>
=20
 #include "io_uring.h"
+#include "napi.h"
 #include "sqpoll.h"
=20
 #define IORING_SQPOLL_CAP_ENTRIES_VALUE 8
@@ -193,6 +194,14 @@ static int __io_sq_thread(struct io_ring_ctx *ctx, b=
ool cap_entries)
 			ret =3D io_submit_sqes(ctx, to_submit);
 		mutex_unlock(&ctx->uring_lock);
=20
+#ifdef CONFIG_NET_RX_BUSY_POLL
+		spin_lock(&ctx->napi_lock);
+		if (!list_empty(&ctx->napi_list) &&
+		    io_napi_busy_loop(&ctx->napi_list))
+			++ret;
+		spin_unlock(&ctx->napi_lock);
+#endif
+
 		if (to_submit && wq_has_sleeper(&ctx->sqo_sq_wait))
 			wake_up(&ctx->sqo_sq_wait);
 		if (creds)
--=20
2.30.2

