Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47F0B48120A
	for <lists+netdev@lfdr.de>; Wed, 29 Dec 2021 12:33:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236075AbhL2LdJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 06:33:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231327AbhL2LdI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Dec 2021 06:33:08 -0500
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B21F2C061574;
        Wed, 29 Dec 2021 03:33:08 -0800 (PST)
Received: by mail-pj1-x1042.google.com with SMTP id v16so18323746pjn.1;
        Wed, 29 Dec 2021 03:33:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6qpeCRTxtZHolmJQSxtMyLYr0fLZlVflxLfn3dHJSQQ=;
        b=Got6lq4/AARjKO6yDYGiRLaUK8TwwlsRRd4TBP77+VcOdKfbWbGGzH/ksCh46ypgn0
         i6WascHi/r5tyyn7ZfbEDwETu7moyKgHCSeGilZmUW+Kju/PtuWyuyPDjTFat1V5enmj
         +eZo4MJVB2AiDoklOdf5kEWAqM4fd/PCi7JMpfTi72EAuCC7HhpLLSw2x1z4SFl6ZQ5W
         p3wQbZ3c/hAbyZS6XrDwSb7Jm2D3t4lPRhmtpVEp3k3sLaNt+R3o2xM3bddA+btmxO0D
         KLGD8DooXeaaMh0OVaSqs2fhuUkZbOrkAlje50vhxoeEpLkWksZBGmQWTHnZlQWJuvWg
         9L7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6qpeCRTxtZHolmJQSxtMyLYr0fLZlVflxLfn3dHJSQQ=;
        b=jk4g9sBrhUgrOUn5wIFkeF+oLyEIkdm6VWTWEe6EQXvjM/iZAR1TfE2rDWR2TNGK4w
         ZEd+GRAPV1vsuSJkkkDmNMnmkzvTKgzNaqy/YtznX5QdsLVKTdNeZbBwoLhc2hx0FoNT
         LGnpYUPupGK+ZBH+Mp/PTEO+IL+eM1XbxX1omYLHQM9J32cG76UXOAHZNi6VUQXGClLx
         THuoyWoRuDH2xAa54cxbl28trXjyixK6/E2+6zgvHDbT/cCXkW9BhoPvdMKDLTFZzrsN
         a7Gc2RXNew2MLTCcFjQWRmN9r6Umn0oAGwTpMa9oceK4zA7vlRmGcutVnyJKb+r3Mek9
         fL1g==
X-Gm-Message-State: AOAM532FBPE9E2SxEyIC4ebax9mNLlMfbggo9jU5eEAHBrRQo/jIvT3a
        YdtkXczPSCmQra+A3ukXTbw=
X-Google-Smtp-Source: ABdhPJxoux1q4zaQsCL1m3jo5q5ZOLKf/E0HV2dcq85bxE3lLd+v0hQA8I6b+HEpr45qSXYfVv1lGw==
X-Received: by 2002:a17:902:d48b:b0:149:25:4383 with SMTP id c11-20020a170902d48b00b0014900254383mr26251857plg.20.1640777588187;
        Wed, 29 Dec 2021 03:33:08 -0800 (PST)
Received: from localhost.localdomain ([43.132.141.9])
        by smtp.gmail.com with ESMTPSA id v17sm5088988pju.1.2021.12.29.03.33.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Dec 2021 03:33:07 -0800 (PST)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     daniel@iogearbox.net
Cc:     ast@kernel.org, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, davem@davemloft.net, kuba@kernel.org,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, edumazet@google.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, Menglong Dong <imagedong@tencent.com>
Subject: [PATCH net-next] net: bpf: add hook for close of tcp timewait sock
Date:   Wed, 29 Dec 2021 19:32:56 +0800
Message-Id: <20211229113256.299024-1-imagedong@tencent.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Menglong Dong <imagedong@tencent.com>

The cgroup eBPF attach type 'CGROUP_SOCK_OPS' is able to monitor the
state change of a tcp connect with 'BPF_SOCK_OPS_STATE_CB' ops.

However, it can't trace the whole state change of a tcp connect. While
a connect becomes 'TCP_TIME_WAIT' state, this sock will be release and
a tw sock will be created. While tcp sock release, 'TCP_CLOSE' state
change will be passed to eBPF program. Howeven, the real state of this
connect is 'TCP_TIME_WAIT'.

To make eBPF get the real state change of a tcp connect, add
'CGROUP_TWSK_CLOSE' cgroup attach type, which will be called when
tw sock release and tcp connect become CLOSE.

Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
 include/linux/bpf-cgroup.h       | 18 ++++++++++++++++++
 include/net/inet_timewait_sock.h |  1 +
 include/uapi/linux/bpf.h         |  4 +++-
 kernel/bpf/cgroup.c              | 16 ++++++++++++++++
 kernel/bpf/syscall.c             |  3 +++
 net/core/filter.c                | 11 +++++++++++
 net/ipv4/inet_timewait_sock.c    |  4 ++++
 net/ipv4/tcp_minisocks.c         |  3 +++
 8 files changed, 59 insertions(+), 1 deletion(-)

diff --git a/include/linux/bpf-cgroup.h b/include/linux/bpf-cgroup.h
index 11820a430d6c..eef4d9ab7701 100644
--- a/include/linux/bpf-cgroup.h
+++ b/include/linux/bpf-cgroup.h
@@ -48,6 +48,7 @@ enum cgroup_bpf_attach_type {
 	CGROUP_INET4_GETSOCKNAME,
 	CGROUP_INET6_GETSOCKNAME,
 	CGROUP_INET_SOCK_RELEASE,
+	CGROUP_TWSK_CLOSE,
 	MAX_CGROUP_BPF_ATTACH_TYPE
 };
 
@@ -81,6 +82,7 @@ to_cgroup_bpf_attach_type(enum bpf_attach_type attach_type)
 	CGROUP_ATYPE(CGROUP_INET4_GETSOCKNAME);
 	CGROUP_ATYPE(CGROUP_INET6_GETSOCKNAME);
 	CGROUP_ATYPE(CGROUP_INET_SOCK_RELEASE);
+	CGROUP_ATYPE(CGROUP_TWSK_CLOSE);
 	default:
 		return CGROUP_BPF_ATTACH_TYPE_INVALID;
 	}
@@ -164,6 +166,9 @@ int __cgroup_bpf_run_filter_skb(struct sock *sk,
 int __cgroup_bpf_run_filter_sk(struct sock *sk,
 			       enum cgroup_bpf_attach_type atype);
 
+int __cgroup_bpf_run_filter_twsk(struct sock *sk,
+				 enum cgroup_bpf_attach_type atype);
+
 int __cgroup_bpf_run_filter_sock_addr(struct sock *sk,
 				      struct sockaddr *uaddr,
 				      enum cgroup_bpf_attach_type atype,
@@ -251,6 +256,15 @@ int bpf_percpu_cgroup_storage_update(struct bpf_map *map, void *key,
 	__ret;								       \
 })
 
+#define BPF_CGROUP_RUN_TWSK_PROG(sk, atype)				       \
+({									       \
+	int __ret = 0;							       \
+	if (cgroup_bpf_enabled(atype)) {				       \
+		__ret = __cgroup_bpf_run_filter_twsk(sk, atype);	       \
+	}								       \
+	__ret;								       \
+})
+
 #define BPF_CGROUP_RUN_PROG_INET_SOCK(sk)				       \
 	BPF_CGROUP_RUN_SK_PROG(sk, CGROUP_INET_SOCK_CREATE)
 
@@ -263,6 +277,9 @@ int bpf_percpu_cgroup_storage_update(struct bpf_map *map, void *key,
 #define BPF_CGROUP_RUN_PROG_INET6_POST_BIND(sk)				       \
 	BPF_CGROUP_RUN_SK_PROG(sk, CGROUP_INET6_POST_BIND)
 
+#define BPF_CGROUP_RUN_PROG_TWSK_CLOSE(sk)			\
+	BPF_CGROUP_RUN_TWSK_PROG(sk, CGROUP_TWSK_CLOSE)
+
 #define BPF_CGROUP_RUN_SA_PROG(sk, uaddr, atype)				       \
 ({									       \
 	u32 __unused_flags;						       \
@@ -524,6 +541,7 @@ static inline int bpf_percpu_cgroup_storage_update(struct bpf_map *map,
 					    optlen, retval) ({ retval; })
 #define BPF_CGROUP_RUN_PROG_SETSOCKOPT(sock, level, optname, optval, optlen, \
 				       kernel_optval) ({ 0; })
+#define BPF_CGROUP_RUN_PROG_TWSK_CLOSE(sk) ({ 0; })
 
 #define for_each_cgroup_storage_type(stype) for (; false; )
 
diff --git a/include/net/inet_timewait_sock.h b/include/net/inet_timewait_sock.h
index dfd919b3119e..7427219b0796 100644
--- a/include/net/inet_timewait_sock.h
+++ b/include/net/inet_timewait_sock.h
@@ -74,6 +74,7 @@ struct inet_timewait_sock {
 	u32			tw_priority;
 	struct timer_list	tw_timer;
 	struct inet_bind_bucket	*tw_tb;
+	struct sock_cgroup_data	tw_cgrp_data;
 };
 #define tw_tclass tw_tos
 
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index c26871263f1f..641113b87f9d 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -995,6 +995,7 @@ enum bpf_attach_type {
 	BPF_SK_REUSEPORT_SELECT,
 	BPF_SK_REUSEPORT_SELECT_OR_MIGRATE,
 	BPF_PERF_EVENT,
+	BPF_CGROUP_TWSK_CLOSE,
 	__MAX_BPF_ATTACH_TYPE
 };
 
@@ -5917,8 +5918,9 @@ enum {
 	 * options first before the BPF program does.
 	 */
 	BPF_SOCK_OPS_WRITE_HDR_OPT_CB_FLAG = (1<<6),
+	BPF_SOCK_OPS_TW_CLOSE_FLAG = (1<<7),
 /* Mask of all currently supported cb flags */
-	BPF_SOCK_OPS_ALL_CB_FLAGS       = 0x7F,
+	BPF_SOCK_OPS_ALL_CB_FLAGS       = 0xFF,
 };
 
 /* List of known BPF sock_ops operators.
diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
index 43eb3501721b..2c32652e47d6 100644
--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -16,6 +16,7 @@
 #include <linux/bpf-cgroup.h>
 #include <net/sock.h>
 #include <net/bpf_sk_storage.h>
+#include <net/inet_timewait_sock.h>
 
 #include "../cgroup/cgroup-internal.h"
 
@@ -1114,6 +1115,21 @@ int __cgroup_bpf_run_filter_sk(struct sock *sk,
 }
 EXPORT_SYMBOL(__cgroup_bpf_run_filter_sk);
 
+int __cgroup_bpf_run_filter_twsk(struct sock *sk,
+				 enum cgroup_bpf_attach_type atype)
+{
+	struct inet_timewait_sock *twsk;
+	struct cgroup *cgrp;
+	int ret;
+
+	twsk = (struct inet_timewait_sock *)sk;
+	cgrp = sock_cgroup_ptr(&twsk->tw_cgrp_data);
+
+	ret = BPF_PROG_RUN_ARRAY_CG(cgrp->bpf.effective[atype], sk, bpf_prog_run);
+	return ret == 1 ? 0 : -EPERM;
+}
+EXPORT_SYMBOL(__cgroup_bpf_run_filter_twsk);
+
 /**
  * __cgroup_bpf_run_filter_sock_addr() - Run a program on a sock and
  *                                       provided by user sockaddr
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index ddd81d543203..da4b6ed192f4 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -2088,6 +2088,7 @@ bpf_prog_load_check_attach(enum bpf_prog_type prog_type,
 		case BPF_CGROUP_INET_SOCK_RELEASE:
 		case BPF_CGROUP_INET4_POST_BIND:
 		case BPF_CGROUP_INET6_POST_BIND:
+		case BPF_CGROUP_TWSK_CLOSE:
 			return 0;
 		default:
 			return -EINVAL;
@@ -3140,6 +3141,7 @@ attach_type_to_prog_type(enum bpf_attach_type attach_type)
 	case BPF_CGROUP_INET_SOCK_RELEASE:
 	case BPF_CGROUP_INET4_POST_BIND:
 	case BPF_CGROUP_INET6_POST_BIND:
+	case BPF_CGROUP_TWSK_CLOSE:
 		return BPF_PROG_TYPE_CGROUP_SOCK;
 	case BPF_CGROUP_INET4_BIND:
 	case BPF_CGROUP_INET6_BIND:
@@ -3311,6 +3313,7 @@ static int bpf_prog_query(const union bpf_attr *attr,
 	case BPF_CGROUP_SYSCTL:
 	case BPF_CGROUP_GETSOCKOPT:
 	case BPF_CGROUP_SETSOCKOPT:
+	case BPF_CGROUP_TWSK_CLOSE:
 		return cgroup_bpf_prog_query(attr, uattr);
 	case BPF_LIRC_MODE2:
 		return lirc_prog_query(attr, uattr);
diff --git a/net/core/filter.c b/net/core/filter.c
index e4cc3aff5bf7..4d3847053a78 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -7927,6 +7927,7 @@ static bool __sock_filter_check_attach_type(int off,
 	case bpf_ctx_range(struct bpf_sock, src_ip4):
 		switch (attach_type) {
 		case BPF_CGROUP_INET4_POST_BIND:
+		case BPF_CGROUP_TWSK_CLOSE:
 			goto read_only;
 		default:
 			return false;
@@ -7934,6 +7935,7 @@ static bool __sock_filter_check_attach_type(int off,
 	case bpf_ctx_range_till(struct bpf_sock, src_ip6[0], src_ip6[3]):
 		switch (attach_type) {
 		case BPF_CGROUP_INET6_POST_BIND:
+		case BPF_CGROUP_TWSK_CLOSE:
 			goto read_only;
 		default:
 			return false;
@@ -7942,10 +7944,19 @@ static bool __sock_filter_check_attach_type(int off,
 		switch (attach_type) {
 		case BPF_CGROUP_INET4_POST_BIND:
 		case BPF_CGROUP_INET6_POST_BIND:
+		case BPF_CGROUP_TWSK_CLOSE:
 			goto read_only;
 		default:
 			return false;
 		}
+	case bpf_ctx_range(struct bpf_sock, protocol):
+	case bpf_ctx_range(struct bpf_sock, type):
+		switch (attach_type) {
+		case BPF_CGROUP_TWSK_CLOSE:
+			return false;
+		default:
+			break;
+		}
 	}
 read_only:
 	return access_type == BPF_READ;
diff --git a/net/ipv4/inet_timewait_sock.c b/net/ipv4/inet_timewait_sock.c
index 437afe392e66..1fc4c9190a79 100644
--- a/net/ipv4/inet_timewait_sock.c
+++ b/net/ipv4/inet_timewait_sock.c
@@ -47,6 +47,8 @@ static void inet_twsk_kill(struct inet_timewait_sock *tw)
 	spinlock_t *lock = inet_ehash_lockp(hashinfo, tw->tw_hash);
 	struct inet_bind_hashbucket *bhead;
 
+	BPF_CGROUP_RUN_PROG_TWSK_CLOSE((struct sock *)tw);
+
 	spin_lock(lock);
 	sk_nulls_del_node_init_rcu((struct sock *)tw);
 	spin_unlock(lock);
@@ -184,6 +186,7 @@ struct inet_timewait_sock *inet_twsk_alloc(const struct sock *sk,
 		tw->tw_ipv6only	    = 0;
 		tw->tw_transparent  = inet->transparent;
 		tw->tw_prot	    = sk->sk_prot_creator;
+		tw->tw_cgrp_data    = sk->sk_cgrp_data;
 		atomic64_set(&tw->tw_cookie, atomic64_read(&sk->sk_cookie));
 		twsk_net_set(tw, sock_net(sk));
 		timer_setup(&tw->tw_timer, tw_timer_handler, TIMER_PINNED);
@@ -195,6 +198,7 @@ struct inet_timewait_sock *inet_twsk_alloc(const struct sock *sk,
 		refcount_set(&tw->tw_refcnt, 0);
 
 		__module_get(tw->tw_prot->owner);
+
 	}
 
 	return tw;
diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
index 7c2d3ac2363a..1fc88e12ba95 100644
--- a/net/ipv4/tcp_minisocks.c
+++ b/net/ipv4/tcp_minisocks.c
@@ -310,6 +310,9 @@ void tcp_time_wait(struct sock *sk, int state, int timeo)
 		if (state == TCP_TIME_WAIT)
 			timeo = TCP_TIMEWAIT_LEN;
 
+		if (BPF_SOCK_OPS_TEST_FLAG(tcp_sk(sk), BPF_SOCK_OPS_TW_CLOSE_FLAG))
+			tcp_sk(sk)->bpf_sock_ops_cb_flags &= ~BPF_SOCK_OPS_STATE_CB_FLAG;
+
 		/* tw_timer is pinned, so we need to make sure BH are disabled
 		 * in following section, otherwise timer handler could run before
 		 * we complete the initialization.
-- 
2.30.2

