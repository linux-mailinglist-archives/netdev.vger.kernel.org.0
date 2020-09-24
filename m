Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90F3327786D
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 20:21:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728777AbgIXSVq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 14:21:46 -0400
Received: from www62.your-server.de ([213.133.104.62]:39324 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728704AbgIXSVj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 14:21:39 -0400
Received: from 75.57.196.178.dynamic.wline.res.cust.swisscom.ch ([178.196.57.75] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1kLVs8-000402-RH; Thu, 24 Sep 2020 20:21:36 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     ast@kernel.org
Cc:     daniel@iogearbox.net, john.fastabend@gmail.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH bpf-next 2/6] bpf, net: rework cookie generator as per-cpu one
Date:   Thu, 24 Sep 2020 20:21:23 +0200
Message-Id: <d4150caecdbef4205178753772e3bc301e908355.1600967205.git.daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1600967205.git.daniel@iogearbox.net>
References: <cover.1600967205.git.daniel@iogearbox.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25937/Thu Sep 24 15:53:11 2020)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With its use in BPF the cookie generator can be called very frequently
in particular when used out of cgroup v2 hooks (e.g. connect / sendmsg)
and attached to the root cgroup, for example, when used in v1/v2 mixed
environments. In particular when there's a high churn on sockets in the
system there can be many parallel requests to the bpf_get_socket_cookie()
and bpf_get_netns_cookie() helpers which then cause contention on the
shared atomic counter. As similarly done in f991bd2e1421 ("fs: introduce
a per-cpu last_ino allocator"), add a small helper library that both can
then use for the 64 bit counters.

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
---
 include/linux/cookie.h   | 41 ++++++++++++++++++++++++++++++++++++++++
 net/core/net_namespace.c |  5 +++--
 net/core/sock_diag.c     |  7 ++++---
 3 files changed, 48 insertions(+), 5 deletions(-)
 create mode 100644 include/linux/cookie.h

diff --git a/include/linux/cookie.h b/include/linux/cookie.h
new file mode 100644
index 000000000000..2488203dc004
--- /dev/null
+++ b/include/linux/cookie.h
@@ -0,0 +1,41 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __LINUX_COOKIE_H
+#define __LINUX_COOKIE_H
+
+#include <linux/atomic.h>
+#include <linux/percpu.h>
+
+struct gen_cookie {
+	u64 __percpu	*local_last;
+	atomic64_t	 shared_last ____cacheline_aligned_in_smp;
+};
+
+#define COOKIE_LOCAL_BATCH	4096
+
+#define DEFINE_COOKIE(name)					\
+	static DEFINE_PER_CPU(u64, __##name);			\
+	static struct gen_cookie name = {			\
+		.local_last	= &__##name,			\
+		.shared_last	= ATOMIC64_INIT(0),		\
+	}
+
+static inline u64 gen_cookie_next(struct gen_cookie *gc)
+{
+	u64 *local_last = &get_cpu_var(*gc->local_last);
+	u64 val = *local_last;
+
+	if (__is_defined(CONFIG_SMP) &&
+	    unlikely((val & (COOKIE_LOCAL_BATCH - 1)) == 0)) {
+		s64 next = atomic64_add_return(COOKIE_LOCAL_BATCH,
+					       &gc->shared_last);
+		val = next - COOKIE_LOCAL_BATCH;
+	}
+	val++;
+	if (unlikely(!val))
+		val++;
+	*local_last = val;
+	put_cpu_var(local_last);
+	return val;
+}
+
+#endif /* __LINUX_COOKIE_H */
diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
index dcd61aca343e..cf29ed8950d1 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -19,6 +19,7 @@
 #include <linux/net_namespace.h>
 #include <linux/sched/task.h>
 #include <linux/uidgid.h>
+#include <linux/cookie.h>
 
 #include <net/sock.h>
 #include <net/netlink.h>
@@ -69,7 +70,7 @@ EXPORT_SYMBOL_GPL(pernet_ops_rwsem);
 
 static unsigned int max_gen_ptrs = INITIAL_NET_GEN_PTRS;
 
-static atomic64_t cookie_gen;
+DEFINE_COOKIE(net_cookie);
 
 u64 net_gen_cookie(struct net *net)
 {
@@ -78,7 +79,7 @@ u64 net_gen_cookie(struct net *net)
 
 		if (res)
 			return res;
-		res = atomic64_inc_return(&cookie_gen);
+		res = gen_cookie_next(&net_cookie);
 		atomic64_cmpxchg(&net->net_cookie, 0, res);
 	}
 }
diff --git a/net/core/sock_diag.c b/net/core/sock_diag.c
index c13ffbd33d8d..4a4180e8dd35 100644
--- a/net/core/sock_diag.c
+++ b/net/core/sock_diag.c
@@ -11,7 +11,7 @@
 #include <linux/tcp.h>
 #include <linux/workqueue.h>
 #include <linux/nospec.h>
-
+#include <linux/cookie.h>
 #include <linux/inet_diag.h>
 #include <linux/sock_diag.h>
 
@@ -19,7 +19,8 @@ static const struct sock_diag_handler *sock_diag_handlers[AF_MAX];
 static int (*inet_rcv_compat)(struct sk_buff *skb, struct nlmsghdr *nlh);
 static DEFINE_MUTEX(sock_diag_table_mutex);
 static struct workqueue_struct *broadcast_wq;
-static atomic64_t cookie_gen;
+
+DEFINE_COOKIE(sock_cookie);
 
 u64 sock_gen_cookie(struct sock *sk)
 {
@@ -28,7 +29,7 @@ u64 sock_gen_cookie(struct sock *sk)
 
 		if (res)
 			return res;
-		res = atomic64_inc_return(&cookie_gen);
+		res = gen_cookie_next(&sock_cookie);
 		atomic64_cmpxchg(&sk->sk_cookie, 0, res);
 	}
 }
-- 
2.21.0

