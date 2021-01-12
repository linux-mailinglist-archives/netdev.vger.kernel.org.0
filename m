Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61B1B2F3FE5
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 01:46:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406026AbhALWje (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 17:39:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405922AbhALWjc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 17:39:32 -0500
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 630B4C061795
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 14:38:52 -0800 (PST)
Received: by mail-qv1-xf49.google.com with SMTP id t18so153969qva.6
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 14:38:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=g3y/V6PokWg4hkIl36oGydEWQphTq8UHAbA0JVhYOtc=;
        b=DYH3PUKIkv3jpdsK6t048WnT7AY2L2K3LOP+5NuEkawWq3wtCHPpxQ3N6P4s0T14+M
         2g+g4S/LBcp9RaLhqOgitMN8pLLCwf/kj+plLlS/VbXnGsepg6b8i/1B1VP/w5jIqjJT
         Hst4R2cH4ZRYci85RBEVHclRnUfVl0+hl7BCN1WXsuvLnbS4puqVarBrXxDFwvkUM2Du
         Yn4pFm4szyiEj5q84+C2cEszEdOfNX+TDdHSQ/uQ3JhlVZEIpnMkKabXqArE8tWIqDKR
         4IYRYjKHFazskAMR2pthDC4LHZDt+eQPQh6hed7lhebl4FnG+I5AIMid1rbppudswNha
         DYCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=g3y/V6PokWg4hkIl36oGydEWQphTq8UHAbA0JVhYOtc=;
        b=MxI7OC19yh5BWdt76J2PcvkNAOvaX4F57Ubc2lrFxSy7j3oy8RxsmXPUtR39ZjlTrs
         0FBH099z4q8ls6T5+3O3GeWIV85/gEB+zvD89I/Bbj0IhZHhMYMgjYvioeM7z0rCH0Pf
         gJheJAYQt5c77O9NZJKa+KLxopqOvqGMeDZpPbxWeqra6fqpLGJbvWTzoYEIExB2ACIp
         jwM+19ulO8ZOtaL7yMHCTWxAZb4T4WGe0i5POdSGSr3LiT6ToI+wuKR/7qZSL30omUT0
         Suo+icS0niF5MJUDjhyCTiOaoB3vjwV83Xn2Q6p6PzqhOXSYbzw492+21YnbyB7WuFId
         /r5Q==
X-Gm-Message-State: AOAM531JWLqSgad3uD5D5qkX1IyEklqEYZkEFlK+WaCBiW8ymloqlShD
        AjLhK8ebnWjf4Kdcit359sj85lnxpshpmhDNpRf3h92vF1jXGJUDfvUNbAFS/DcJ4wFOL5hoxPn
        dGAO9gWXjYVTE62k4T2RSCX4Yd95kVsoGOeKia9nrvYYqrrwfmoMtlg==
X-Google-Smtp-Source: ABdhPJzsH3g6cRMWWGMCYHpLi+HYh+6wmDLqIJg4Ltu3TPVTsI7cSZ/7ySrsqDErl7v9aoiBaF/lmns=
Sender: "sdf via sendgmr" <sdf@sdf2.svl.corp.google.com>
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:1:7220:84ff:fe09:7732])
 (user=sdf job=sendgmr) by 2002:ad4:46e7:: with SMTP id h7mr1953797qvw.44.1610491131495;
 Tue, 12 Jan 2021 14:38:51 -0800 (PST)
Date:   Tue, 12 Jan 2021 14:38:44 -0800
In-Reply-To: <20210112223847.1915615-1-sdf@google.com>
Message-Id: <20210112223847.1915615-2-sdf@google.com>
Mime-Version: 1.0
References: <20210112223847.1915615-1-sdf@google.com>
X-Mailer: git-send-email 2.30.0.284.gd98b1dd5eaa7-goog
Subject: [PATCH bpf-next v7 1/4] bpf: remove extra lock_sock for TCP_ZEROCOPY_RECEIVE
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

Signed-off-by: Stanislav Fomichev <sdf@google.com>
Cc: Martin KaFai Lau <kafai@fb.com>
Cc: Song Liu <songliubraving@fb.com>
Cc: Eric Dumazet <edumazet@google.com>
---
 include/linux/bpf-cgroup.h                    | 27 +++++++++--
 include/linux/indirect_call_wrapper.h         |  6 +++
 include/net/sock.h                            |  2 +
 include/net/tcp.h                             |  1 +
 kernel/bpf/cgroup.c                           | 46 +++++++++++++++++++
 net/ipv4/tcp.c                                | 14 ++++++
 net/ipv4/tcp_ipv4.c                           |  1 +
 net/ipv6/tcp_ipv6.c                           |  1 +
 net/socket.c                                  |  3 ++
 .../selftests/bpf/prog_tests/sockopt_sk.c     | 22 +++++++++
 .../testing/selftests/bpf/progs/sockopt_sk.c  | 15 ++++++
 11 files changed, 134 insertions(+), 4 deletions(-)

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
diff --git a/tools/testing/selftests/bpf/prog_tests/sockopt_sk.c b/tools/testing/selftests/bpf/prog_tests/sockopt_sk.c
index b25c9c45c148..6bb18b1d8578 100644
--- a/tools/testing/selftests/bpf/prog_tests/sockopt_sk.c
+++ b/tools/testing/selftests/bpf/prog_tests/sockopt_sk.c
@@ -11,6 +11,7 @@ static int getsetsockopt(void)
 		char u8[4];
 		__u32 u32;
 		char cc[16]; /* TCP_CA_NAME_MAX */
+		struct tcp_zerocopy_receive zc;
 	} buf = {};
 	socklen_t optlen;
 	char *big_buf = NULL;
@@ -154,6 +155,27 @@ static int getsetsockopt(void)
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
index 712df7b49cb1..c726f0763a13 100644
--- a/tools/testing/selftests/bpf/progs/sockopt_sk.c
+++ b/tools/testing/selftests/bpf/progs/sockopt_sk.c
@@ -57,6 +57,21 @@ int _getsockopt(struct bpf_sockopt *ctx)
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
-- 
2.30.0.284.gd98b1dd5eaa7-goog

