Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A01742EF9DC
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 22:05:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729673AbhAHVDK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 16:03:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729557AbhAHVDI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 16:03:08 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60B80C061796
        for <netdev@vger.kernel.org>; Fri,  8 Jan 2021 13:02:28 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id g17so16734873ybh.5
        for <netdev@vger.kernel.org>; Fri, 08 Jan 2021 13:02:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=FS5jwRdkG7ECiUj5zaFntluWc7G1p1NWSA/1gKAG45o=;
        b=L8xgroAGwM1lpUmY4gmyKYiYQQQjcHCEaa4LfajN3PFKoGKzaPOdq1OGylWyi1Lbm0
         qhUwcrqdP5sfcXCgEAy193E2AAO8wKLL98lo9f8rk0aa1TEo1WrZaTmReY21Xw46cFkw
         xG6uT0jbmOenlV7uG5NqPZhfx6Clen2+GyWcrFyPoO1hkNowAj/cf+sCHbanPiV9bFMc
         2va0SO6Vj4NMdoBQuKbYoiMx9u+j1iL5S+kdtqab5MgzBKk2pPnwCdHkFnrCYxCBXerF
         gB2MUx01wFJfVpvG2U7yipOfgrOw0iQrTeL17wAOEMharFqNbIi72XoQSEhktoMFha3w
         fXUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=FS5jwRdkG7ECiUj5zaFntluWc7G1p1NWSA/1gKAG45o=;
        b=rWmyk1iJTKedv3bdpjyIxcen4p8mFUdwF02t/uACIEH9pf6tbq/SsiUYmLkJX4VLSG
         UfTPfqnpXuR3GxT0+d7DL+PP9arhtpOgKuqTlfY+VPmOWwIohbB6ZEQ2NmVXktOCJf23
         OsCEff8pI326RYwuIZ0nAiUkUdP13BiGFpHfjrKiKFeDjqZi8eAUzzUPCFNThqefDc2j
         lwLdge1a4ke8bkxvTlYm7lTUZu68SONyNcxmkjoiOi3YlAScgh0p050qRe4rI7HNR1hk
         yQErYQB071kcRhxvlLnRBHgejhkCaqpFyaKJuYid3B1UQMHpr0vLB4yVZHs+SzNvPmgf
         y5gg==
X-Gm-Message-State: AOAM5332o3fLqlVEyw65A2OKEPwk0tNgsD2GG2Nk8Wj318M5EokBoXZ9
        ZZ6GrTmqRvNCFIxt08ADnmmrnwOEgjj4eAEoiwBPEBhedp9YMt5EBRhiwRfTw9M+Y9QCiF2OOb9
        AO20CHu3YPvCa609ZjWfgGt8NEMJx0IQXKGmca2cAyBVEI273NLkbYw==
X-Google-Smtp-Source: ABdhPJwlfO2gyZUvgikg4+vMmYrpG8iloPPrE86awxoD/MWkxQENrEPYFNrZ/bB/GDSzhAyxeIXLyks=
Sender: "sdf via sendgmr" <sdf@sdf2.svl.corp.google.com>
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:1:7220:84ff:fe09:7732])
 (user=sdf job=sendgmr) by 2002:a5b:482:: with SMTP id n2mr7818566ybp.25.1610139747423;
 Fri, 08 Jan 2021 13:02:27 -0800 (PST)
Date:   Fri,  8 Jan 2021 13:02:21 -0800
In-Reply-To: <20210108210223.972802-1-sdf@google.com>
Message-Id: <20210108210223.972802-2-sdf@google.com>
Mime-Version: 1.0
References: <20210108210223.972802-1-sdf@google.com>
X-Mailer: git-send-email 2.30.0.284.gd98b1dd5eaa7-goog
Subject: [PATCH bpf-next v6 1/3] bpf: remove extra lock_sock for TCP_ZEROCOPY_RECEIVE
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
 include/linux/bpf-cgroup.h                    | 27 +++++++++++--
 include/linux/indirect_call_wrapper.h         |  6 +++
 include/net/sock.h                            |  2 +
 include/net/tcp.h                             |  1 +
 kernel/bpf/cgroup.c                           | 38 +++++++++++++++++++
 net/ipv4/tcp.c                                | 14 +++++++
 net/ipv4/tcp_ipv4.c                           |  1 +
 net/ipv6/tcp_ipv6.c                           |  1 +
 net/socket.c                                  |  3 ++
 .../selftests/bpf/prog_tests/sockopt_sk.c     | 22 +++++++++++
 .../testing/selftests/bpf/progs/sockopt_sk.c  | 15 ++++++++
 11 files changed, 126 insertions(+), 4 deletions(-)

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
index 6ec088a96302..c41bb2f34013 100644
--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -1485,6 +1485,44 @@ int __cgroup_bpf_run_filter_getsockopt(struct sock *sk, int level,
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
index ed42d2193c5c..ef3c895b66c1 100644
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

