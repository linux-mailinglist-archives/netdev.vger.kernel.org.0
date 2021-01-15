Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B00AE2F80E5
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 17:36:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729384AbhAOQft (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 11:35:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727599AbhAOQfr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 11:35:47 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CE94C061793
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 08:35:07 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id n76so6445968ybg.7
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 08:35:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=TN1LUA1x4sVaVDfHOE+EJ0NRfr5zcwFUhpcnRWPGYEc=;
        b=DwyO0oSwOATTls7deS4u7oI4ORA0e/9lREp18bHgo/pitnWs3gAGeV85JzOi6t9US5
         pEjeyBLyD3xGfjtN7MvRRyIOmd7gHhJnVJ5KNjn+WbA4yQB5UNM4yulahRD5OfQmysPv
         dBTH0stheYH5T2ZIbJ3A1Zyv93E3TJoY2Ty7SNBdMoeqfldvwrR0SdbzFVYEIKg51Fya
         tLCS+Luc2WKlyplsM2UUFuojTvHB0LIcE4abVpZyZlusLJv6BTA3lc1LuxLxpRf7Qn3+
         SuuSk6cZUmo64lM5OKfuCEot/1REaH2Mz76b+m1lfLcMrxb2JDfbaN/ApeQ5VB+7OrCh
         jBxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=TN1LUA1x4sVaVDfHOE+EJ0NRfr5zcwFUhpcnRWPGYEc=;
        b=El0EA1CWp616VdEeqyMgJJ3EZ/+kQendmx2jp9Ocp4anMG/T9XdnKbGZHYEjNL6XuJ
         iFC9Vi0uxkKRtkOzn2pjN35r3NoaAe79EyoqfRj7kNF20xP3WO4xXplQIZYIhRq1zQEb
         hQACU01eZyQuciSgAZ+vT/a0/jIzHlfjK708ax2L/tg5XVWXIYYRcoE1CiaY9G2j6QvD
         7KpQQOSWgFtCZk8IgHFJOXShUHtZz8WP7OkdS+EeFDOP6JTZHpmwG0eV4fSQXIjUkp0K
         oBRGBdlKlGYL67I1+cs5i/ByGtmfPSIlvjn0XWsk+/Y/j1viKHtASIY0a6ee7CafkMjE
         MuUQ==
X-Gm-Message-State: AOAM530EJt7hnwx5tCf2Sgv5scEpv4MhRF8RbJRfmao9gwL6w4a4JCCK
        32k1fTDPIIfLr8GFXDG8O0qzd0WOkX9blxwPunsB3fmKVraJhs2jY7sSACtCBGCHtjLOELzNIIT
        Co9D0o6WlpjeSTd97OzdYZVPLT5f9GOa6DsokZBtgawh45LuXFcBDUQ==
X-Google-Smtp-Source: ABdhPJyyR9Wej/HDJLfTu/8CNMpgmpnlV6Nd+kTm/uz/wi+Yq754z3XLcvH79JhoGuMuS1x7Rrf+QAw=
Sender: "sdf via sendgmr" <sdf@sdf2.svl.corp.google.com>
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:1:7220:84ff:fe09:7732])
 (user=sdf job=sendgmr) by 2002:a25:4588:: with SMTP id s130mr11612432yba.281.1610728506582;
 Fri, 15 Jan 2021 08:35:06 -0800 (PST)
Date:   Fri, 15 Jan 2021 08:34:59 -0800
In-Reply-To: <20210115163501.805133-1-sdf@google.com>
Message-Id: <20210115163501.805133-2-sdf@google.com>
Mime-Version: 1.0
References: <20210115163501.805133-1-sdf@google.com>
X-Mailer: git-send-email 2.30.0.284.gd98b1dd5eaa7-goog
Subject: [PATCH bpf-next v9 1/3] bpf: remove extra lock_sock for TCP_ZEROCOPY_RECEIVE
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add custom implementation of getsockopt hook for TCP_ZEROCOPY_RECEIVE.
We skip generic hooks for TCP_ZEROCOPY_RECEIVE and have a custom
call in do_tcp_getsockopt using the on-stack data. This removes
3% overhead for locking/unlocking the socket.

Without this patch:
     3.38%     0.07%  tcp_mmap  [kernel.kallsyms]  [k] __cgroup_bpf_run_filter_getsockopt
            |
             --3.30%--__cgroup_bpf_run_filter_getsockopt
                       |
                        --0.81%--__kmalloc

With the patch applied:
     0.52%     0.12%  tcp_mmap  [kernel.kallsyms]  [k] __cgroup_bpf_run_filter_getsockopt_kern

Note, exporting uapi/tcp.h requires removing netinet/tcp.h
from test_progs.h because those headers have confliciting
definitions.

Signed-off-by: Stanislav Fomichev <sdf@google.com>
Cc: Martin KaFai Lau <kafai@fb.com>
Cc: Song Liu <songliubraving@fb.com>
Cc: Eric Dumazet <edumazet@google.com>
Acked-by: Martin KaFai Lau <kafai@fb.com>
---
 include/linux/bpf-cgroup.h                    |  27 +-
 include/linux/indirect_call_wrapper.h         |   6 +
 include/net/sock.h                            |   2 +
 include/net/tcp.h                             |   1 +
 kernel/bpf/cgroup.c                           |  46 +++
 net/ipv4/tcp.c                                |  14 +
 net/ipv4/tcp_ipv4.c                           |   1 +
 net/ipv6/tcp_ipv6.c                           |   1 +
 net/socket.c                                  |   3 +
 tools/include/uapi/linux/tcp.h                | 357 ++++++++++++++++++
 .../selftests/bpf/prog_tests/bpf_tcp_ca.c     |   1 +
 .../selftests/bpf/prog_tests/cls_redirect.c   |   1 +
 .../selftests/bpf/prog_tests/sockmap_basic.c  |   1 +
 .../selftests/bpf/prog_tests/sockopt_sk.c     |  28 ++
 .../testing/selftests/bpf/progs/sockopt_sk.c  |  23 +-
 tools/testing/selftests/bpf/test_progs.h      |   1 -
 16 files changed, 506 insertions(+), 7 deletions(-)
 create mode 100644 tools/include/uapi/linux/tcp.h

diff --git a/include/linux/bpf-cgroup.h b/include/linux/bpf-cgroup.h
index 72e69a0e1e8c..bcb2915e6124 100644
--- a/include/linux/bpf-cgroup.h
+++ b/include/linux/bpf-cgroup.h
@@ -147,6 +147,10 @@ int __cgroup_bpf_run_filter_getsockopt(struct sock *sk, int level,
 				       int __user *optlen, int max_optlen,
 				       int retval);
 
+int __cgroup_bpf_run_filter_getsockopt_kern(struct sock *sk, int level,
+					    int optname, void *optval,
+					    int *optlen, int retval);
+
 static inline enum bpf_cgroup_storage_type cgroup_storage_type(
 	struct bpf_map *map)
 {
@@ -364,10 +368,23 @@ int bpf_percpu_cgroup_storage_update(struct bpf_map *map, void *key,
 ({									       \
 	int __ret = retval;						       \
 	if (cgroup_bpf_enabled)						       \
-		__ret = __cgroup_bpf_run_filter_getsockopt(sock, level,	       \
-							   optname, optval,    \
-							   optlen, max_optlen, \
-							   retval);	       \
+		if (!(sock)->sk_prot->bpf_bypass_getsockopt ||		       \
+		    !INDIRECT_CALL_INET_1((sock)->sk_prot->bpf_bypass_getsockopt, \
+					tcp_bpf_bypass_getsockopt,	       \
+					level, optname))		       \
+			__ret = __cgroup_bpf_run_filter_getsockopt(	       \
+				sock, level, optname, optval, optlen,	       \
+				max_optlen, retval);			       \
+	__ret;								       \
+})
+
+#define BPF_CGROUP_RUN_PROG_GETSOCKOPT_KERN(sock, level, optname, optval,      \
+					    optlen, retval)		       \
+({									       \
+	int __ret = retval;						       \
+	if (cgroup_bpf_enabled)						       \
+		__ret = __cgroup_bpf_run_filter_getsockopt_kern(	       \
+			sock, level, optname, optval, optlen, retval);	       \
 	__ret;								       \
 })
 
@@ -452,6 +469,8 @@ static inline int bpf_percpu_cgroup_storage_update(struct bpf_map *map,
 #define BPF_CGROUP_GETSOCKOPT_MAX_OPTLEN(optlen) ({ 0; })
 #define BPF_CGROUP_RUN_PROG_GETSOCKOPT(sock, level, optname, optval, \
 				       optlen, max_optlen, retval) ({ retval; })
+#define BPF_CGROUP_RUN_PROG_GETSOCKOPT_KERN(sock, level, optname, optval, \
+					    optlen, retval) ({ retval; })
 #define BPF_CGROUP_RUN_PROG_SETSOCKOPT(sock, level, optname, optval, optlen, \
 				       kernel_optval) ({ 0; })
 
diff --git a/include/linux/indirect_call_wrapper.h b/include/linux/indirect_call_wrapper.h
index 54c02c84906a..cfcfef37b2f1 100644
--- a/include/linux/indirect_call_wrapper.h
+++ b/include/linux/indirect_call_wrapper.h
@@ -60,4 +60,10 @@
 #define INDIRECT_CALL_INET(f, f2, f1, ...) f(__VA_ARGS__)
 #endif
 
+#if IS_ENABLED(CONFIG_INET)
+#define INDIRECT_CALL_INET_1(f, f1, ...) INDIRECT_CALL_1(f, f1, __VA_ARGS__)
+#else
+#define INDIRECT_CALL_INET_1(f, f1, ...) f(__VA_ARGS__)
+#endif
+
 #endif
diff --git a/include/net/sock.h b/include/net/sock.h
index bdc4323ce53c..ebf44d724845 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1174,6 +1174,8 @@ struct proto {
 
 	int			(*backlog_rcv) (struct sock *sk,
 						struct sk_buff *skb);
+	bool			(*bpf_bypass_getsockopt)(int level,
+							 int optname);
 
 	void		(*release_cb)(struct sock *sk);
 
diff --git a/include/net/tcp.h b/include/net/tcp.h
index 78d13c88720f..4bb42fb19711 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -403,6 +403,7 @@ __poll_t tcp_poll(struct file *file, struct socket *sock,
 		      struct poll_table_struct *wait);
 int tcp_getsockopt(struct sock *sk, int level, int optname,
 		   char __user *optval, int __user *optlen);
+bool tcp_bpf_bypass_getsockopt(int level, int optname);
 int tcp_setsockopt(struct sock *sk, int level, int optname, sockptr_t optval,
 		   unsigned int optlen);
 void tcp_set_keepalive(struct sock *sk, int val);
diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
index 96555a8a2c54..416e7738981b 100644
--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -1486,6 +1486,52 @@ int __cgroup_bpf_run_filter_getsockopt(struct sock *sk, int level,
 	sockopt_free_buf(&ctx);
 	return ret;
 }
+
+int __cgroup_bpf_run_filter_getsockopt_kern(struct sock *sk, int level,
+					    int optname, void *optval,
+					    int *optlen, int retval)
+{
+	struct cgroup *cgrp = sock_cgroup_ptr(&sk->sk_cgrp_data);
+	struct bpf_sockopt_kern ctx = {
+		.sk = sk,
+		.level = level,
+		.optname = optname,
+		.retval = retval,
+		.optlen = *optlen,
+		.optval = optval,
+		.optval_end = optval + *optlen,
+	};
+	int ret;
+
+	/* Note that __cgroup_bpf_run_filter_getsockopt doesn't copy
+	 * user data back into BPF buffer when reval != 0. This is
+	 * done as an optimization to avoid extra copy, assuming
+	 * kernel won't populate the data in case of an error.
+	 * Here we always pass the data and memset() should
+	 * be called if that data shouldn't be "exported".
+	 */
+
+	ret = BPF_PROG_RUN_ARRAY(cgrp->bpf.effective[BPF_CGROUP_GETSOCKOPT],
+				 &ctx, BPF_PROG_RUN);
+	if (!ret)
+		return -EPERM;
+
+	if (ctx.optlen > *optlen)
+		return -EFAULT;
+
+	/* BPF programs only allowed to set retval to 0, not some
+	 * arbitrary value.
+	 */
+	if (ctx.retval != 0 && ctx.retval != retval)
+		return -EFAULT;
+
+	/* BPF programs can shrink the buffer, export the modifications.
+	 */
+	if (ctx.optlen != 0)
+		*optlen = ctx.optlen;
+
+	return ctx.retval;
+}
 #endif
 
 static ssize_t sysctl_cpy_dir(const struct ctl_dir *dir, char **bufp,
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 2267d21c73a6..d434bdac2917 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -4098,6 +4098,8 @@ static int do_tcp_getsockopt(struct sock *sk, int level,
 			return -EFAULT;
 		lock_sock(sk);
 		err = tcp_zerocopy_receive(sk, &zc);
+		err = BPF_CGROUP_RUN_PROG_GETSOCKOPT_KERN(sk, level, optname,
+							  &zc, &len, err);
 		release_sock(sk);
 		if (len >= offsetofend(struct tcp_zerocopy_receive, err))
 			goto zerocopy_rcv_sk_err;
@@ -4132,6 +4134,18 @@ static int do_tcp_getsockopt(struct sock *sk, int level,
 	return 0;
 }
 
+bool tcp_bpf_bypass_getsockopt(int level, int optname)
+{
+	/* TCP do_tcp_getsockopt has optimized getsockopt implementation
+	 * to avoid extra socket lock for TCP_ZEROCOPY_RECEIVE.
+	 */
+	if (level == SOL_TCP && optname == TCP_ZEROCOPY_RECEIVE)
+		return true;
+
+	return false;
+}
+EXPORT_SYMBOL(tcp_bpf_bypass_getsockopt);
+
 int tcp_getsockopt(struct sock *sk, int level, int optname, char __user *optval,
 		   int __user *optlen)
 {
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 58207c7769d0..8b4906980fce 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -2792,6 +2792,7 @@ struct proto tcp_prot = {
 	.shutdown		= tcp_shutdown,
 	.setsockopt		= tcp_setsockopt,
 	.getsockopt		= tcp_getsockopt,
+	.bpf_bypass_getsockopt	= tcp_bpf_bypass_getsockopt,
 	.keepalive		= tcp_set_keepalive,
 	.recvmsg		= tcp_recvmsg,
 	.sendmsg		= tcp_sendmsg,
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 0e1509b02cb3..8539715ff035 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -2121,6 +2121,7 @@ struct proto tcpv6_prot = {
 	.shutdown		= tcp_shutdown,
 	.setsockopt		= tcp_setsockopt,
 	.getsockopt		= tcp_getsockopt,
+	.bpf_bypass_getsockopt	= tcp_bpf_bypass_getsockopt,
 	.keepalive		= tcp_set_keepalive,
 	.recvmsg		= tcp_recvmsg,
 	.sendmsg		= tcp_sendmsg,
diff --git a/net/socket.c b/net/socket.c
index 33e8b6c4e1d3..7f0617ab5437 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -2126,6 +2126,9 @@ SYSCALL_DEFINE5(setsockopt, int, fd, int, level, int, optname,
 	return __sys_setsockopt(fd, level, optname, optval, optlen);
 }
 
+INDIRECT_CALLABLE_DECLARE(bool tcp_bpf_bypass_getsockopt(int level,
+							 int optname));
+
 /*
  *	Get a socket option. Because we don't know the option lengths we have
  *	to pass a user mode parameter for the protocols to sort out.
diff --git a/tools/include/uapi/linux/tcp.h b/tools/include/uapi/linux/tcp.h
new file mode 100644
index 000000000000..13ceeb395eb8
--- /dev/null
+++ b/tools/include/uapi/linux/tcp.h
@@ -0,0 +1,357 @@
+/* SPDX-License-Identifier: GPL-2.0+ WITH Linux-syscall-note */
+/*
+ * INET		An implementation of the TCP/IP protocol suite for the LINUX
+ *		operating system.  INET is implemented using the  BSD Socket
+ *		interface as the means of communication with the user level.
+ *
+ *		Definitions for the TCP protocol.
+ *
+ * Version:	@(#)tcp.h	1.0.2	04/28/93
+ *
+ * Author:	Fred N. van Kempen, <waltje@uWalt.NL.Mugnet.ORG>
+ *
+ *		This program is free software; you can redistribute it and/or
+ *		modify it under the terms of the GNU General Public License
+ *		as published by the Free Software Foundation; either version
+ *		2 of the License, or (at your option) any later version.
+ */
+#ifndef _UAPI_LINUX_TCP_H
+#define _UAPI_LINUX_TCP_H
+
+#include <linux/types.h>
+#include <asm/byteorder.h>
+#include <linux/socket.h>
+
+struct tcphdr {
+	__be16	source;
+	__be16	dest;
+	__be32	seq;
+	__be32	ack_seq;
+#if defined(__LITTLE_ENDIAN_BITFIELD)
+	__u16	res1:4,
+		doff:4,
+		fin:1,
+		syn:1,
+		rst:1,
+		psh:1,
+		ack:1,
+		urg:1,
+		ece:1,
+		cwr:1;
+#elif defined(__BIG_ENDIAN_BITFIELD)
+	__u16	doff:4,
+		res1:4,
+		cwr:1,
+		ece:1,
+		urg:1,
+		ack:1,
+		psh:1,
+		rst:1,
+		syn:1,
+		fin:1;
+#else
+#error	"Adjust your <asm/byteorder.h> defines"
+#endif	
+	__be16	window;
+	__sum16	check;
+	__be16	urg_ptr;
+};
+
+/*
+ *	The union cast uses a gcc extension to avoid aliasing problems
+ *  (union is compatible to any of its members)
+ *  This means this part of the code is -fstrict-aliasing safe now.
+ */
+union tcp_word_hdr { 
+	struct tcphdr hdr;
+	__be32 		  words[5];
+}; 
+
+#define tcp_flag_word(tp) ( ((union tcp_word_hdr *)(tp))->words [3]) 
+
+enum { 
+	TCP_FLAG_CWR = __constant_cpu_to_be32(0x00800000),
+	TCP_FLAG_ECE = __constant_cpu_to_be32(0x00400000),
+	TCP_FLAG_URG = __constant_cpu_to_be32(0x00200000),
+	TCP_FLAG_ACK = __constant_cpu_to_be32(0x00100000),
+	TCP_FLAG_PSH = __constant_cpu_to_be32(0x00080000),
+	TCP_FLAG_RST = __constant_cpu_to_be32(0x00040000),
+	TCP_FLAG_SYN = __constant_cpu_to_be32(0x00020000),
+	TCP_FLAG_FIN = __constant_cpu_to_be32(0x00010000),
+	TCP_RESERVED_BITS = __constant_cpu_to_be32(0x0F000000),
+	TCP_DATA_OFFSET = __constant_cpu_to_be32(0xF0000000)
+}; 
+
+/*
+ * TCP general constants
+ */
+#define TCP_MSS_DEFAULT		 536U	/* IPv4 (RFC1122, RFC2581) */
+#define TCP_MSS_DESIRED		1220U	/* IPv6 (tunneled), EDNS0 (RFC3226) */
+
+/* TCP socket options */
+#define TCP_NODELAY		1	/* Turn off Nagle's algorithm. */
+#define TCP_MAXSEG		2	/* Limit MSS */
+#define TCP_CORK		3	/* Never send partially complete segments */
+#define TCP_KEEPIDLE		4	/* Start keeplives after this period */
+#define TCP_KEEPINTVL		5	/* Interval between keepalives */
+#define TCP_KEEPCNT		6	/* Number of keepalives before death */
+#define TCP_SYNCNT		7	/* Number of SYN retransmits */
+#define TCP_LINGER2		8	/* Life time of orphaned FIN-WAIT-2 state */
+#define TCP_DEFER_ACCEPT	9	/* Wake up listener only when data arrive */
+#define TCP_WINDOW_CLAMP	10	/* Bound advertised window */
+#define TCP_INFO		11	/* Information about this connection. */
+#define TCP_QUICKACK		12	/* Block/reenable quick acks */
+#define TCP_CONGESTION		13	/* Congestion control algorithm */
+#define TCP_MD5SIG		14	/* TCP MD5 Signature (RFC2385) */
+#define TCP_THIN_LINEAR_TIMEOUTS 16      /* Use linear timeouts for thin streams*/
+#define TCP_THIN_DUPACK         17      /* Fast retrans. after 1 dupack */
+#define TCP_USER_TIMEOUT	18	/* How long for loss retry before timeout */
+#define TCP_REPAIR		19	/* TCP sock is under repair right now */
+#define TCP_REPAIR_QUEUE	20
+#define TCP_QUEUE_SEQ		21
+#define TCP_REPAIR_OPTIONS	22
+#define TCP_FASTOPEN		23	/* Enable FastOpen on listeners */
+#define TCP_TIMESTAMP		24
+#define TCP_NOTSENT_LOWAT	25	/* limit number of unsent bytes in write queue */
+#define TCP_CC_INFO		26	/* Get Congestion Control (optional) info */
+#define TCP_SAVE_SYN		27	/* Record SYN headers for new connections */
+#define TCP_SAVED_SYN		28	/* Get SYN headers recorded for connection */
+#define TCP_REPAIR_WINDOW	29	/* Get/set window parameters */
+#define TCP_FASTOPEN_CONNECT	30	/* Attempt FastOpen with connect */
+#define TCP_ULP			31	/* Attach a ULP to a TCP connection */
+#define TCP_MD5SIG_EXT		32	/* TCP MD5 Signature with extensions */
+#define TCP_FASTOPEN_KEY	33	/* Set the key for Fast Open (cookie) */
+#define TCP_FASTOPEN_NO_COOKIE	34	/* Enable TFO without a TFO cookie */
+#define TCP_ZEROCOPY_RECEIVE	35
+#define TCP_INQ			36	/* Notify bytes available to read as a cmsg on read */
+
+#define TCP_CM_INQ		TCP_INQ
+
+#define TCP_TX_DELAY		37	/* delay outgoing packets by XX usec */
+
+
+#define TCP_REPAIR_ON		1
+#define TCP_REPAIR_OFF		0
+#define TCP_REPAIR_OFF_NO_WP	-1	/* Turn off without window probes */
+
+struct tcp_repair_opt {
+	__u32	opt_code;
+	__u32	opt_val;
+};
+
+struct tcp_repair_window {
+	__u32	snd_wl1;
+	__u32	snd_wnd;
+	__u32	max_window;
+
+	__u32	rcv_wnd;
+	__u32	rcv_wup;
+};
+
+enum {
+	TCP_NO_QUEUE,
+	TCP_RECV_QUEUE,
+	TCP_SEND_QUEUE,
+	TCP_QUEUES_NR,
+};
+
+/* why fastopen failed from client perspective */
+enum tcp_fastopen_client_fail {
+	TFO_STATUS_UNSPEC, /* catch-all */
+	TFO_COOKIE_UNAVAILABLE, /* if not in TFO_CLIENT_NO_COOKIE mode */
+	TFO_DATA_NOT_ACKED, /* SYN-ACK did not ack SYN data */
+	TFO_SYN_RETRANSMITTED, /* SYN-ACK did not ack SYN data after timeout */
+};
+
+/* for TCP_INFO socket option */
+#define TCPI_OPT_TIMESTAMPS	1
+#define TCPI_OPT_SACK		2
+#define TCPI_OPT_WSCALE		4
+#define TCPI_OPT_ECN		8 /* ECN was negociated at TCP session init */
+#define TCPI_OPT_ECN_SEEN	16 /* we received at least one packet with ECT */
+#define TCPI_OPT_SYN_DATA	32 /* SYN-ACK acked data in SYN sent or rcvd */
+
+/*
+ * Sender's congestion state indicating normal or abnormal situations
+ * in the last round of packets sent. The state is driven by the ACK
+ * information and timer events.
+ */
+enum tcp_ca_state {
+	/*
+	 * Nothing bad has been observed recently.
+	 * No apparent reordering, packet loss, or ECN marks.
+	 */
+	TCP_CA_Open = 0,
+#define TCPF_CA_Open	(1<<TCP_CA_Open)
+	/*
+	 * The sender enters disordered state when it has received DUPACKs or
+	 * SACKs in the last round of packets sent. This could be due to packet
+	 * loss or reordering but needs further information to confirm packets
+	 * have been lost.
+	 */
+	TCP_CA_Disorder = 1,
+#define TCPF_CA_Disorder (1<<TCP_CA_Disorder)
+	/*
+	 * The sender enters Congestion Window Reduction (CWR) state when it
+	 * has received ACKs with ECN-ECE marks, or has experienced congestion
+	 * or packet discard on the sender host (e.g. qdisc).
+	 */
+	TCP_CA_CWR = 2,
+#define TCPF_CA_CWR	(1<<TCP_CA_CWR)
+	/*
+	 * The sender is in fast recovery and retransmitting lost packets,
+	 * typically triggered by ACK events.
+	 */
+	TCP_CA_Recovery = 3,
+#define TCPF_CA_Recovery (1<<TCP_CA_Recovery)
+	/*
+	 * The sender is in loss recovery triggered by retransmission timeout.
+	 */
+	TCP_CA_Loss = 4
+#define TCPF_CA_Loss	(1<<TCP_CA_Loss)
+};
+
+struct tcp_info {
+	__u8	tcpi_state;
+	__u8	tcpi_ca_state;
+	__u8	tcpi_retransmits;
+	__u8	tcpi_probes;
+	__u8	tcpi_backoff;
+	__u8	tcpi_options;
+	__u8	tcpi_snd_wscale : 4, tcpi_rcv_wscale : 4;
+	__u8	tcpi_delivery_rate_app_limited:1, tcpi_fastopen_client_fail:2;
+
+	__u32	tcpi_rto;
+	__u32	tcpi_ato;
+	__u32	tcpi_snd_mss;
+	__u32	tcpi_rcv_mss;
+
+	__u32	tcpi_unacked;
+	__u32	tcpi_sacked;
+	__u32	tcpi_lost;
+	__u32	tcpi_retrans;
+	__u32	tcpi_fackets;
+
+	/* Times. */
+	__u32	tcpi_last_data_sent;
+	__u32	tcpi_last_ack_sent;     /* Not remembered, sorry. */
+	__u32	tcpi_last_data_recv;
+	__u32	tcpi_last_ack_recv;
+
+	/* Metrics. */
+	__u32	tcpi_pmtu;
+	__u32	tcpi_rcv_ssthresh;
+	__u32	tcpi_rtt;
+	__u32	tcpi_rttvar;
+	__u32	tcpi_snd_ssthresh;
+	__u32	tcpi_snd_cwnd;
+	__u32	tcpi_advmss;
+	__u32	tcpi_reordering;
+
+	__u32	tcpi_rcv_rtt;
+	__u32	tcpi_rcv_space;
+
+	__u32	tcpi_total_retrans;
+
+	__u64	tcpi_pacing_rate;
+	__u64	tcpi_max_pacing_rate;
+	__u64	tcpi_bytes_acked;    /* RFC4898 tcpEStatsAppHCThruOctetsAcked */
+	__u64	tcpi_bytes_received; /* RFC4898 tcpEStatsAppHCThruOctetsReceived */
+	__u32	tcpi_segs_out;	     /* RFC4898 tcpEStatsPerfSegsOut */
+	__u32	tcpi_segs_in;	     /* RFC4898 tcpEStatsPerfSegsIn */
+
+	__u32	tcpi_notsent_bytes;
+	__u32	tcpi_min_rtt;
+	__u32	tcpi_data_segs_in;	/* RFC4898 tcpEStatsDataSegsIn */
+	__u32	tcpi_data_segs_out;	/* RFC4898 tcpEStatsDataSegsOut */
+
+	__u64   tcpi_delivery_rate;
+
+	__u64	tcpi_busy_time;      /* Time (usec) busy sending data */
+	__u64	tcpi_rwnd_limited;   /* Time (usec) limited by receive window */
+	__u64	tcpi_sndbuf_limited; /* Time (usec) limited by send buffer */
+
+	__u32	tcpi_delivered;
+	__u32	tcpi_delivered_ce;
+
+	__u64	tcpi_bytes_sent;     /* RFC4898 tcpEStatsPerfHCDataOctetsOut */
+	__u64	tcpi_bytes_retrans;  /* RFC4898 tcpEStatsPerfOctetsRetrans */
+	__u32	tcpi_dsack_dups;     /* RFC4898 tcpEStatsStackDSACKDups */
+	__u32	tcpi_reord_seen;     /* reordering events seen */
+
+	__u32	tcpi_rcv_ooopack;    /* Out-of-order packets received */
+
+	__u32	tcpi_snd_wnd;	     /* peer's advertised receive window after
+				      * scaling (bytes)
+				      */
+};
+
+/* netlink attributes types for SCM_TIMESTAMPING_OPT_STATS */
+enum {
+	TCP_NLA_PAD,
+	TCP_NLA_BUSY,		/* Time (usec) busy sending data */
+	TCP_NLA_RWND_LIMITED,	/* Time (usec) limited by receive window */
+	TCP_NLA_SNDBUF_LIMITED,	/* Time (usec) limited by send buffer */
+	TCP_NLA_DATA_SEGS_OUT,	/* Data pkts sent including retransmission */
+	TCP_NLA_TOTAL_RETRANS,	/* Data pkts retransmitted */
+	TCP_NLA_PACING_RATE,    /* Pacing rate in bytes per second */
+	TCP_NLA_DELIVERY_RATE,  /* Delivery rate in bytes per second */
+	TCP_NLA_SND_CWND,       /* Sending congestion window */
+	TCP_NLA_REORDERING,     /* Reordering metric */
+	TCP_NLA_MIN_RTT,        /* minimum RTT */
+	TCP_NLA_RECUR_RETRANS,  /* Recurring retransmits for the current pkt */
+	TCP_NLA_DELIVERY_RATE_APP_LMT, /* delivery rate application limited ? */
+	TCP_NLA_SNDQ_SIZE,	/* Data (bytes) pending in send queue */
+	TCP_NLA_CA_STATE,	/* ca_state of socket */
+	TCP_NLA_SND_SSTHRESH,	/* Slow start size threshold */
+	TCP_NLA_DELIVERED,	/* Data pkts delivered incl. out-of-order */
+	TCP_NLA_DELIVERED_CE,	/* Like above but only ones w/ CE marks */
+	TCP_NLA_BYTES_SENT,	/* Data bytes sent including retransmission */
+	TCP_NLA_BYTES_RETRANS,	/* Data bytes retransmitted */
+	TCP_NLA_DSACK_DUPS,	/* DSACK blocks received */
+	TCP_NLA_REORD_SEEN,	/* reordering events seen */
+	TCP_NLA_SRTT,		/* smoothed RTT in usecs */
+	TCP_NLA_TIMEOUT_REHASH, /* Timeout-triggered rehash attempts */
+	TCP_NLA_BYTES_NOTSENT,	/* Bytes in write queue not yet sent */
+	TCP_NLA_EDT,		/* Earliest departure time (CLOCK_MONOTONIC) */
+};
+
+/* for TCP_MD5SIG socket option */
+#define TCP_MD5SIG_MAXKEYLEN	80
+
+/* tcp_md5sig extension flags for TCP_MD5SIG_EXT */
+#define TCP_MD5SIG_FLAG_PREFIX		0x1	/* address prefix length */
+#define TCP_MD5SIG_FLAG_IFINDEX		0x2	/* ifindex set */
+
+struct tcp_md5sig {
+	struct __kernel_sockaddr_storage tcpm_addr;	/* address associated */
+	__u8	tcpm_flags;				/* extension flags */
+	__u8	tcpm_prefixlen;				/* address prefix */
+	__u16	tcpm_keylen;				/* key length */
+	int	tcpm_ifindex;				/* device index for scope */
+	__u8	tcpm_key[TCP_MD5SIG_MAXKEYLEN];		/* key (binary) */
+};
+
+/* INET_DIAG_MD5SIG */
+struct tcp_diag_md5sig {
+	__u8	tcpm_family;
+	__u8	tcpm_prefixlen;
+	__u16	tcpm_keylen;
+	__be32	tcpm_addr[4];
+	__u8	tcpm_key[TCP_MD5SIG_MAXKEYLEN];
+};
+
+/* setsockopt(fd, IPPROTO_TCP, TCP_ZEROCOPY_RECEIVE, ...) */
+
+#define TCP_RECEIVE_ZEROCOPY_FLAG_TLB_CLEAN_HINT 0x1
+struct tcp_zerocopy_receive {
+	__u64 address;		/* in: address of mapping */
+	__u32 length;		/* in/out: number of bytes to map/mapped */
+	__u32 recv_skip_hint;	/* out: amount of bytes to skip */
+	__u32 inq; /* out: amount of bytes in read queue */
+	__s32 err; /* out: socket error */
+	__u64 copybuf_address;	/* in: copybuf address (small reads) */
+	__s32 copybuf_len; /* in/out: copybuf bytes avail/used or error */
+	__u32 flags; /* in: flags */
+};
+#endif /* _UAPI_LINUX_TCP_H */
diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_tcp_ca.c b/tools/testing/selftests/bpf/prog_tests/bpf_tcp_ca.c
index 9a8f47fc0b91..37c5494a0381 100644
--- a/tools/testing/selftests/bpf/prog_tests/bpf_tcp_ca.c
+++ b/tools/testing/selftests/bpf/prog_tests/bpf_tcp_ca.c
@@ -2,6 +2,7 @@
 /* Copyright (c) 2019 Facebook */
 
 #include <linux/err.h>
+#include <netinet/tcp.h>
 #include <test_progs.h>
 #include "bpf_dctcp.skel.h"
 #include "bpf_cubic.skel.h"
diff --git a/tools/testing/selftests/bpf/prog_tests/cls_redirect.c b/tools/testing/selftests/bpf/prog_tests/cls_redirect.c
index 9781d85cb223..e075d03ab630 100644
--- a/tools/testing/selftests/bpf/prog_tests/cls_redirect.c
+++ b/tools/testing/selftests/bpf/prog_tests/cls_redirect.c
@@ -7,6 +7,7 @@
 #include <string.h>
 
 #include <linux/pkt_cls.h>
+#include <netinet/tcp.h>
 
 #include <test_progs.h>
 
diff --git a/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c b/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c
index 85f73261fab0..b8b48cac2ac3 100644
--- a/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c
+++ b/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 // Copyright (c) 2020 Cloudflare
 #include <error.h>
+#include <netinet/tcp.h>
 
 #include "test_progs.h"
 #include "test_skmsg_load_helpers.skel.h"
diff --git a/tools/testing/selftests/bpf/prog_tests/sockopt_sk.c b/tools/testing/selftests/bpf/prog_tests/sockopt_sk.c
index b25c9c45c148..d5b44b135c00 100644
--- a/tools/testing/selftests/bpf/prog_tests/sockopt_sk.c
+++ b/tools/testing/selftests/bpf/prog_tests/sockopt_sk.c
@@ -2,6 +2,12 @@
 #include <test_progs.h>
 #include "cgroup_helpers.h"
 
+#include <linux/tcp.h>
+
+#ifndef SOL_TCP
+#define SOL_TCP IPPROTO_TCP
+#endif
+
 #define SOL_CUSTOM			0xdeadbeef
 
 static int getsetsockopt(void)
@@ -11,6 +17,7 @@ static int getsetsockopt(void)
 		char u8[4];
 		__u32 u32;
 		char cc[16]; /* TCP_CA_NAME_MAX */
+		struct tcp_zerocopy_receive zc;
 	} buf = {};
 	socklen_t optlen;
 	char *big_buf = NULL;
@@ -154,6 +161,27 @@ static int getsetsockopt(void)
 		goto err;
 	}
 
+	/* TCP_ZEROCOPY_RECEIVE triggers */
+	memset(&buf, 0, sizeof(buf));
+	optlen = sizeof(buf.zc);
+	err = getsockopt(fd, SOL_TCP, TCP_ZEROCOPY_RECEIVE, &buf, &optlen);
+	if (err) {
+		log_err("Unexpected getsockopt(TCP_ZEROCOPY_RECEIVE) err=%d errno=%d",
+			err, errno);
+		goto err;
+	}
+
+	memset(&buf, 0, sizeof(buf));
+	buf.zc.address = 12345; /* rejected by BPF */
+	optlen = sizeof(buf.zc);
+	errno = 0;
+	err = getsockopt(fd, SOL_TCP, TCP_ZEROCOPY_RECEIVE, &buf, &optlen);
+	if (errno != EPERM) {
+		log_err("Unexpected getsockopt(TCP_ZEROCOPY_RECEIVE) err=%d errno=%d",
+			err, errno);
+		goto err;
+	}
+
 	free(big_buf);
 	close(fd);
 	return 0;
diff --git a/tools/testing/selftests/bpf/progs/sockopt_sk.c b/tools/testing/selftests/bpf/progs/sockopt_sk.c
index 712df7b49cb1..d3597f81e6e9 100644
--- a/tools/testing/selftests/bpf/progs/sockopt_sk.c
+++ b/tools/testing/selftests/bpf/progs/sockopt_sk.c
@@ -1,8 +1,8 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <string.h>
-#include <netinet/in.h>
-#include <netinet/tcp.h>
+#include <linux/tcp.h>
 #include <linux/bpf.h>
+#include <netinet/in.h>
 #include <bpf/bpf_helpers.h>
 
 char _license[] SEC("license") = "GPL";
@@ -12,6 +12,10 @@ __u32 _version SEC("version") = 1;
 #define PAGE_SIZE 4096
 #endif
 
+#ifndef SOL_TCP
+#define SOL_TCP IPPROTO_TCP
+#endif
+
 #define SOL_CUSTOM			0xdeadbeef
 
 struct sockopt_sk {
@@ -57,6 +61,21 @@ int _getsockopt(struct bpf_sockopt *ctx)
 		return 1;
 	}
 
+	if (ctx->level == SOL_TCP && ctx->optname == TCP_ZEROCOPY_RECEIVE) {
+		/* Verify that TCP_ZEROCOPY_RECEIVE triggers.
+		 * It has a custom implementation for performance
+		 * reasons.
+		 */
+
+		if (optval + sizeof(struct tcp_zerocopy_receive) > optval_end)
+			return 0; /* EPERM, bounds check */
+
+		if (((struct tcp_zerocopy_receive *)optval)->address != 0)
+			return 0; /* EPERM, unexpected data */
+
+		return 1;
+	}
+
 	if (ctx->level == SOL_IP && ctx->optname == IP_FREEBIND) {
 		if (optval + 1 > optval_end)
 			return 0; /* EPERM, bounds check */
diff --git a/tools/testing/selftests/bpf/test_progs.h b/tools/testing/selftests/bpf/test_progs.h
index e49e2fdde942..f7c2fd89d01a 100644
--- a/tools/testing/selftests/bpf/test_progs.h
+++ b/tools/testing/selftests/bpf/test_progs.h
@@ -16,7 +16,6 @@ typedef __u16 __sum16;
 #include <linux/if_packet.h>
 #include <linux/ip.h>
 #include <linux/ipv6.h>
-#include <netinet/tcp.h>
 #include <linux/filter.h>
 #include <linux/perf_event.h>
 #include <linux/socket.h>
-- 
2.30.0.284.gd98b1dd5eaa7-goog

