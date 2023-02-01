Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EAA3687139
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 23:47:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229608AbjBAWrJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 17:47:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230481AbjBAWrI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 17:47:08 -0500
Received: from 66-220-144-178.mail-mxout.facebook.com (66-220-144-178.mail-mxout.facebook.com [66.220.144.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CB6328D05
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 14:47:05 -0800 (PST)
Received: by dev0134.prn3.facebook.com (Postfix, from userid 425415)
        id C623560FCAB8; Wed,  1 Feb 2023 14:23:25 -0800 (PST)
From:   Stefan Roesch <shr@devkernel.io>
To:     kernel-team@fb.com
Cc:     shr@devkernel.io, axboe@kernel.dk, olivier@trillion01.com,
        netdev@vger.kernel.org, io-uring@vger.kernel.org, kuba@kernel.org
Subject: [PATCH v6 1/3] io_uring: add napi busy polling support
Date:   Wed,  1 Feb 2023 14:22:52 -0800
Message-Id: <20230201222254.744422-2-shr@devkernel.io>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230201222254.744422-1-shr@devkernel.io>
References: <20230201222254.744422-1-shr@devkernel.io>
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

In addition there is also a hash table. The hash table store the napi
id ond the pointer to the above list nodes. The hash table is used to
speed up the lookup to the list elements.

The NAPI_TIMEOUT is stored as a timeout to make sure that the time a
napi entry is stored in the napi list is limited.

The busy poll timeout is also stored as part of the io_wait_queue. This
is necessary as for sq polling the poll interval needs to be adjusted
and the napi callback allows only to pass in one value.

This has been tested with two simple programs from the liburing library
repository: the napi client and the napi server program. The client
sends a request, which has a timestamp in its payload and the server
replies with the same payload. The client calculates the roundtrip time
and stores it to calcualte the results.

The client is running on host1 and the server is running on host 2 (in
the same rack). The measured times below are roundtrip times. They are
average times over 5 runs each. Each run measures 1 million roundtrips.

                   no rx coal          rx coal: frames=3D88,usecs=3D33
Default              57us                    56us

client_poll=3D100us    47us                    46us

server_poll=3D100us    51us                    46us

client_poll=3D100us+   40us                    40us
server_poll=3D100us

client_poll=3D100us+   41us                    39us
server_poll=3D100us+
prefer napi busy poll on client

client_poll=3D100us+   41us                    39us
server_poll=3D100us+
prefer napi busy poll on server

client_poll=3D100us+   41us                    39us
server_poll=3D100us+
prefer napi busy poll on client + server

Signed-off-by: Stefan Roesch <shr@devkernel.io>
Suggested-by: Olivier Langlois <olivier@trillion01.com>
Acked-by: Jakub Kicinski <kuba@kernel.org>
---
 include/linux/io_uring_types.h |  10 ++
 io_uring/io_uring.c            | 241 +++++++++++++++++++++++++++++++++
 io_uring/napi.h                |  23 ++++
 io_uring/poll.c                |   2 +
 io_uring/sqpoll.c              |  17 +++
 5 files changed, 293 insertions(+)
 create mode 100644 io_uring/napi.h

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_type=
s.h
index 128a67a40065..d9551790356e 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -2,6 +2,7 @@
 #define IO_URING_TYPES_H
=20
 #include <linux/blkdev.h>
+#include <linux/hashtable.h>
 #include <linux/task_work.h>
 #include <linux/bitmap.h>
 #include <linux/llist.h>
@@ -274,6 +275,15 @@ struct io_ring_ctx {
 	struct xarray		personalities;
 	u32			pers_next;
=20
+#ifdef CONFIG_NET_RX_BUSY_POLL
+	struct list_head	napi_list;	/* track busy poll napi_id */
+	DECLARE_HASHTABLE(napi_ht, 8);
+	spinlock_t		napi_lock;	/* napi_list lock */
+
+	unsigned int		napi_busy_poll_to; /* napi busy poll default timeout */
+	bool			napi_prefer_busy_poll;
+#endif
+
 	struct {
 		/*
 		 * We cache a range of free CQEs we can use, once exhausted it
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index db623b3185c8..96062036db41 100644
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
@@ -335,6 +336,14 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(=
struct io_uring_params *p)
 	INIT_WQ_LIST(&ctx->locked_free_list);
 	INIT_DELAYED_WORK(&ctx->fallback_work, io_fallback_req_func);
 	INIT_WQ_LIST(&ctx->submit_state.compl_reqs);
+
+#ifdef CONFIG_NET_RX_BUSY_POLL
+	INIT_LIST_HEAD(&ctx->napi_list);
+	spin_lock_init(&ctx->napi_lock);
+	ctx->napi_prefer_busy_poll =3D false;
+	ctx->napi_busy_poll_to =3D READ_ONCE(sysctl_net_busy_poll);
+#endif
+
 	return ctx;
 err:
 	kfree(ctx->dummy_ubuf);
@@ -2418,6 +2427,11 @@ struct io_wait_queue {
 	struct io_ring_ctx *ctx;
 	unsigned cq_tail;
 	unsigned nr_timeouts;
+
+#ifdef CONFIG_NET_RX_BUSY_POLL
+	unsigned int napi_busy_poll_to;
+	bool napi_prefer_busy_poll;
+#endif
 };
=20
 static inline bool io_has_work(struct io_ring_ctx *ctx)
@@ -2498,6 +2512,196 @@ static inline int io_cqring_wait_schedule(struct =
io_ring_ctx *ctx,
 	return ret < 0 ? ret : 1;
 }
=20
+#ifdef CONFIG_NET_RX_BUSY_POLL
+#define NAPI_TIMEOUT		(60 * SEC_CONVERSION)
+
+struct io_napi_ht_entry {
+	unsigned int		napi_id;
+	struct list_head	list;
+
+	/* Covered by napi lock spinlock.  */
+	unsigned long		timeout;
+	struct hlist_node	node;
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
+ * Add the napi id of the socket to the napi busy poll list and hash tab=
le.
+ */
+void io_napi_add(struct file *file, struct io_ring_ctx *ctx)
+{
+	unsigned int napi_id;
+	struct socket *sock;
+	struct sock *sk;
+	struct io_napi_ht_entry *he;
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
+	/* Non-NAPI IDs can be rejected. */
+	if (napi_id < MIN_NAPI_ID)
+		return;
+
+	spin_lock(&ctx->napi_lock);
+	hash_for_each_possible(ctx->napi_ht, he, node, napi_id) {
+		if (he->napi_id =3D=3D napi_id) {
+			he->timeout =3D jiffies + NAPI_TIMEOUT;
+			goto out;
+		}
+	}
+
+	he =3D kmalloc(sizeof(*he), GFP_NOWAIT);
+	if (!he)
+		goto out;
+
+	he->napi_id =3D napi_id;
+	he->timeout =3D jiffies + NAPI_TIMEOUT;
+	hash_add(ctx->napi_ht, &he->node, napi_id);
+
+	list_add_tail(&he->list, &ctx->napi_list);
+
+out:
+	spin_unlock(&ctx->napi_lock);
+}
+
+static void io_napi_free_list(struct io_ring_ctx *ctx)
+{
+	unsigned int i;
+	struct io_napi_ht_entry *he;
+	LIST_HEAD(napi_list);
+
+	spin_lock(&ctx->napi_lock);
+	hash_for_each(ctx->napi_ht, i, he, node) {
+		hash_del(&he->node);
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
+/*
+ * io_napi_busy_loop() - napi busy poll loop
+ * @napi_list            : list of napi_id's supporting busy polling
+ * @napi_prefer_busy_poll: prefer napi busy polling
+ *
+ * This invokes the napi busy poll loop if sockets have been added to th=
e
+ * napi busy poll list.
+ *
+ * Returns if all napi id's in the list have been processed.
+ */
+bool io_napi_busy_loop(struct list_head *napi_list, bool prefer_busy_pol=
l)
+{
+	struct io_napi_ht_entry *e;
+	struct io_napi_ht_entry *n;
+
+	list_for_each_entry_safe(e, n, napi_list, list) {
+		napi_busy_loop(e->napi_id, NULL, NULL, prefer_busy_poll,
+			       BUSY_POLL_BUDGET);
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
+	       io_napi_busy_loop_timeout(start_time, iowq->napi_busy_poll_to);
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
+			struct io_napi_ht_entry *ne =3D
+				list_first_entry(napi_list,
+						 struct io_napi_ht_entry, list);
+
+			napi_busy_loop(ne->napi_id, io_napi_busy_loop_end, iowq,
+				       iowq->napi_prefer_busy_poll, BUSY_POLL_BUDGET);
+			break;
+		}
+	} while (io_napi_busy_loop(napi_list, iowq->napi_prefer_busy_poll) &&
+		 !io_napi_busy_loop_end(iowq, start_time));
+}
+
+static void io_napi_remove_stale(struct io_ring_ctx *ctx)
+{
+	unsigned int i;
+	struct io_napi_ht_entry *he;
+
+	hash_for_each(ctx->napi_ht, i, he, node) {
+		if (time_after(jiffies, he->timeout)) {
+			list_del(&he->list);
+			hash_del(&he->node);
+		}
+	}
+
+}
+
+void io_napi_merge_lists(struct io_ring_ctx *ctx, struct list_head *napi=
_list)
+{
+	spin_lock(&ctx->napi_lock);
+	list_splice(napi_list, &ctx->napi_list);
+	io_napi_remove_stale(ctx);
+	spin_unlock(&ctx->napi_lock);
+}
+#endif
+
 /*
  * Wait until events become available, if we don't already have some. Th=
e
  * application must reap them itself, as they reside on the shared cq ri=
ng.
@@ -2510,6 +2714,9 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, =
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
@@ -2539,12 +2746,34 @@ static int io_cqring_wait(struct io_ring_ctx *ctx=
, int min_events,
 			return ret;
 	}
=20
+#ifdef CONFIG_NET_RX_BUSY_POLL
+	iowq.napi_busy_poll_to =3D 0;
+	iowq.napi_prefer_busy_poll =3D READ_ONCE(ctx->napi_prefer_busy_poll);
+
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
+						&ts, &iowq.napi_busy_poll_to);
+		}
+#endif
 		timeout =3D ktime_add_ns(timespec64_to_ktime(ts), ktime_get_ns());
+#ifdef CONFIG_NET_RX_BUSY_POLL
+	} else if (!list_empty(&local_napi_list)) {
+		iowq.napi_busy_poll_to =3D READ_ONCE(ctx->napi_busy_poll_to);
+#endif
 	}
=20
 	init_waitqueue_func_entry(&iowq.wq, io_wake_function);
@@ -2555,6 +2784,15 @@ static int io_cqring_wait(struct io_ring_ctx *ctx,=
 int min_events,
 	iowq.cq_tail =3D READ_ONCE(ctx->rings->cq.head) + min_events;
=20
 	trace_io_uring_cqring_wait(ctx, min_events);
+
+#ifdef CONFIG_NET_RX_BUSY_POLL
+	if (iowq.napi_busy_poll_to)
+		io_napi_blocking_busy_loop(&local_napi_list, &iowq);
+
+	if (!list_empty(&local_napi_list))
+		io_napi_merge_lists(ctx, &local_napi_list);
+#endif
+
 	do {
 		if (test_bit(IO_CHECK_CQ_OVERFLOW_BIT, &ctx->check_cq)) {
 			finish_wait(&ctx->cq_wait, &iowq.wq);
@@ -2754,6 +2992,9 @@ static __cold void io_ring_ctx_free(struct io_ring_=
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
index 000000000000..2abc448dbea0
--- /dev/null
+++ b/io_uring/napi.h
@@ -0,0 +1,23 @@
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
+bool io_napi_busy_loop(struct list_head *napi_list, bool prefer_busy_pol=
l);
+void io_napi_merge_lists(struct io_ring_ctx *ctx, struct list_head *napi=
_list);
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
index 2ac1366adbd7..7cf53db667e2 100644
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
@@ -629,6 +630,7 @@ static int __io_arm_poll_handler(struct io_kiocb *req=
,
 		__io_poll_execute(req, mask);
 		return 0;
 	}
+	io_napi_add(req->file, req->ctx);
=20
 	if (ipt->owning) {
 		/*
diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
index 559652380672..b9fb077de15b 100644
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
@@ -168,6 +169,9 @@ static int __io_sq_thread(struct io_ring_ctx *ctx, bo=
ol cap_entries)
 {
 	unsigned int to_submit;
 	int ret =3D 0;
+#ifdef CONFIG_NET_RX_BUSY_POLL
+	LIST_HEAD(local_napi_list);
+#endif
=20
 	to_submit =3D io_sqring_entries(ctx);
 	/* if we're handling multiple rings, cap submit size for fairness */
@@ -193,6 +197,19 @@ static int __io_sq_thread(struct io_ring_ctx *ctx, b=
ool cap_entries)
 			ret =3D io_submit_sqes(ctx, to_submit);
 		mutex_unlock(&ctx->uring_lock);
=20
+#ifdef CONFIG_NET_RX_BUSY_POLL
+		spin_lock(&ctx->napi_lock);
+		list_splice_init(&ctx->napi_list, &local_napi_list);
+		spin_unlock(&ctx->napi_lock);
+
+		if (!list_empty(&local_napi_list) &&
+		    READ_ONCE(ctx->napi_busy_poll_to) > 0 &&
+		    io_napi_busy_loop(&local_napi_list, ctx->napi_prefer_busy_poll)) {
+			io_napi_merge_lists(ctx, &local_napi_list);
+			++ret;
+		}
+#endif
+
 		if (to_submit && wq_has_sleeper(&ctx->sqo_sq_wait))
 			wake_up(&ctx->sqo_sq_wait);
 		if (creds)
--=20
2.30.2

