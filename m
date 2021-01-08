Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 641672EF6F3
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 19:04:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728691AbhAHSET (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 13:04:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728684AbhAHSES (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 13:04:18 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12821C0612FD
        for <netdev@vger.kernel.org>; Fri,  8 Jan 2021 10:03:38 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id h75so16122826ybg.18
        for <netdev@vger.kernel.org>; Fri, 08 Jan 2021 10:03:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=jv5E35EQ0i4Dz1vZc6Bw1oiVzHDYXN+09HYw0GystI8=;
        b=k3Ia/ayGpDMSRltpNA7U/Dg+X/JpyPUfDlBqQBYZAkdSaJB4r2a0euWayZi2S3OwP2
         lL8x2Iosi8VPcfZ7FBDmRnOd0emH8oy2nAG9X9DYvSUb735eMTUU6XxgkKBkwIc0ei+3
         Q6wicr2YeKCgxTw6R07VinaQa80QuNJiGfgdds0Kd49ctj/z88iU0Bgl3CY+UJ6VBkmk
         i+0hy13Lmx5H2N2wA4IZwtS3qR6IvkAjx4/4XYhU2iCOQQsB77YSpRFeuF4y3NjnxUBu
         0EVmUdJi/8et8PvOYTenEvBiT0DPz0tWszlfmPOGqPOdcBicNTKxAfaB8SP/khnjDavS
         H8Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=jv5E35EQ0i4Dz1vZc6Bw1oiVzHDYXN+09HYw0GystI8=;
        b=O6eCmXxFfRHaxMdOw1s1lJ7Wq43SIPVvKqdiNI9eHuT/9jFBUw4pr9grEDaSdOdcl4
         MbqYiZZ4sFvtEqlYufiD8wdMf6OJi4wnKhIviYLIJjlxdxN4Tmngck2jt3d6UmlIRSH3
         aC6ATWlB+vkpIXMELLjCv+YvOABUvCzmkqz54L60ORG38xc0XBrfsbreVof+03BpR4y2
         yEja4Yv4tk4iENKIalbN9sjJjbfBbY6xNT6Q1lrhUOKEKdlx3dwX/yvReA7djSSiHTRm
         ywsHbcNgOxATpEFXEd78KDSNJ91RFLIFEP20Lru/LOsk3gBXHJMeu7UwwieSJ+8bETi4
         VdfQ==
X-Gm-Message-State: AOAM532ghjKVt+439dJfcRaIxAfS4ke5seX337dEwJ9lABoI/dk/wHQ/
        gEdQhKsQacV1Nwqr14VBIPoKxZksptUEuOTwN7hHY9/kVvy/7UoOZzri9+5E8vSZQYm0QO9VYiZ
        gYxbxR0KdhZx1LJWbiO2o2yxVCKfsWjxU+tUOmRXyqjUa8cY7gX5QjA==
X-Google-Smtp-Source: ABdhPJxbXlhxKGiTPZ+SIrY0cMiV0VEF2SxPi7nDqBRjYvTwJAERCbL7vaRWs0gkH7egHx6jtint8tI=
Sender: "sdf via sendgmr" <sdf@sdf2.svl.corp.google.com>
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:1:7220:84ff:fe09:7732])
 (user=sdf job=sendgmr) by 2002:a25:ab30:: with SMTP id u45mr7222472ybi.516.1610129017110;
 Fri, 08 Jan 2021 10:03:37 -0800 (PST)
Date:   Fri,  8 Jan 2021 10:03:31 -0800
In-Reply-To: <20210108180333.180906-1-sdf@google.com>
Message-Id: <20210108180333.180906-2-sdf@google.com>
Mime-Version: 1.0
References: <20210108180333.180906-1-sdf@google.com>
X-Mailer: git-send-email 2.29.2.729.g45daf8777d-goog
Subject: [PATCH bpf-next v5 1/3] bpf: remove extra lock_sock for TCP_ZEROCOPY_RECEIVE
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
 include/linux/bpf-cgroup.h                    | 25 ++++++++++--
 include/net/sock.h                            |  2 +
 include/net/tcp.h                             |  1 +
 kernel/bpf/cgroup.c                           | 38 +++++++++++++++++++
 net/ipv4/tcp.c                                | 14 +++++++
 net/ipv4/tcp_ipv4.c                           |  1 +
 net/ipv6/tcp_ipv6.c                           |  1 +
 .../selftests/bpf/prog_tests/sockopt_sk.c     | 22 +++++++++++
 .../testing/selftests/bpf/progs/sockopt_sk.c  | 15 ++++++++
 9 files changed, 115 insertions(+), 4 deletions(-)

diff --git a/include/linux/bpf-cgroup.h b/include/linux/bpf-cgroup.h
index 72e69a0e1e8c..6adaee018c63 100644
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
@@ -364,10 +368,21 @@ int bpf_percpu_cgroup_storage_update(struct bpf_map *map, void *key,
 ({									       \
 	int __ret = retval;						       \
 	if (cgroup_bpf_enabled)						       \
-		__ret = __cgroup_bpf_run_filter_getsockopt(sock, level,	       \
-							   optname, optval,    \
-							   optlen, max_optlen, \
-							   retval);	       \
+		if (!(sock)->sk_prot->bpf_bypass_getsockopt ||		       \
+		    !(sock)->sk_prot->bpf_bypass_getsockopt(level, optname))   \
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
 
@@ -452,6 +467,8 @@ static inline int bpf_percpu_cgroup_storage_update(struct bpf_map *map,
 #define BPF_CGROUP_GETSOCKOPT_MAX_OPTLEN(optlen) ({ 0; })
 #define BPF_CGROUP_RUN_PROG_GETSOCKOPT(sock, level, optname, optval, \
 				       optlen, max_optlen, retval) ({ retval; })
+#define BPF_CGROUP_RUN_PROG_GETSOCKOPT_KERN(sock, level, optname, optval, \
+					    optlen, retval) ({ retval; })
 #define BPF_CGROUP_RUN_PROG_SETSOCKOPT(sock, level, optname, optval, optlen, \
 				       kernel_optval) ({ 0; })
 
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
2.29.2.729.g45daf8777d-goog

