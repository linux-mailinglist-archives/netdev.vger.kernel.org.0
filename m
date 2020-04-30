Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 667DB1C0AFC
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 01:31:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726562AbgD3Xb4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 19:31:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726435AbgD3Xb4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 19:31:56 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7C21C035495
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 16:31:54 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id s8so9823644ybj.9
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 16:31:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=P/ZkVzy8srGzpdc1wH5VQEZkZ6K0ju1bsjqWwmQKNss=;
        b=hTeDcqouG+d0dbaPopxWRL9v5H+pDW896PfOfBdGYdbNP9Hi+DVaN/xECgJXq2UzDK
         y5TLjKliiu/s7JhzrAmXuMJ8uiRIaQVgKvdr+W087d/8N73VSVwIuGCyfPfu35jis87k
         bMrHKNhOjE0AB1tbRXOGBWKqdWhGoflMQWCLvUUnud2qu16ziDXNolkVAvdZhvEEnZgS
         wcg5IL6M3puCOSgqAHuBXoe4B7/HRc1UuI+U/itG4M18mUV7HiAXJbXS0Y3zFVb5mc/9
         D18TsyTGU7TXcJ8IVU6rYOxsAQHy1TNWpCmnf42JgCb+X5eOl07XOc34VjcZRHDZsMm1
         f6NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=P/ZkVzy8srGzpdc1wH5VQEZkZ6K0ju1bsjqWwmQKNss=;
        b=BUIPcDAFQEZ3DQsfiZEjrwXWuppFHvSvHN5XILAzOxsS96pAiAGuK1Lz51VXFaUZbs
         Hrzloure/0MAqgYIOR1kMwYPrhrvlPGNh00MA36i/K1s2H/RHACFfh7gmFzPU3yBGLPP
         Gtt+x631q3i0KbIKnIgSHlcJ0HDAuUpcVzgReec+2XVApxVS3zB84b/4zZC89OIiAKeB
         Q+Ji9cE43oVDBlyY6H0df3F/IU/+mu3rjl7nJNS8ByXbSV/ALk9xTiSrenkTjl7D1mPP
         7GZjcdErWZXz3mUVDz9Qz6saU3yzau97AD8vJGTnRsH5R9lc9vEEsTdmN6eecNZnh5Fw
         D9hA==
X-Gm-Message-State: AGi0PubUesy0EEtXxkeWL81VWWaqbZkPaN/OA4C5om/eBtOxC7nFv3Cr
        Y4ZU3r9Pq2ABbIAjfwsGzbMe8MhYD2RsRZID8rbh/XbnMsessuKKC7r4MAlukwijLvWrpg6mvSp
        25oyo5fJisrQmR/ed/+PJ33HjJpQ3sRB4+nyk4YpiDxZ1YUfTJ0La/A==
X-Google-Smtp-Source: APiQypJDNBJ855fNpoNoY05VbLvgyoLzn31gX6fJ9xeOZgattsasn8f/HoyVf1dnFhAofOhu+j24ppo=
X-Received: by 2002:a25:448:: with SMTP id 69mr2151763ybe.187.1588289513703;
 Thu, 30 Apr 2020 16:31:53 -0700 (PDT)
Date:   Thu, 30 Apr 2020 16:31:52 -0700
Message-Id: <20200430233152.199403-1-sdf@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.26.2.526.g744177e7f7-goog
Subject: [PATCH bpf-next v3] bpf: bpf_{g,s}etsockopt for struct bpf_sock_addr
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, bpf_getsockopt and bpf_setsockopt helpers operate on the
'struct bpf_sock_ops' context in BPF_PROG_TYPE_SOCK_OPS program.
Let's generalize them and make them available for 'struct bpf_sock_addr'.
That way, in the future, we can allow those helpers in more places.

As an example, let's expose those 'struct bpf_sock_addr' based helpers to
BPF_CGROUP_INET{4,6}_CONNECT hooks. That way we can override CC before the
connection is made.

v3:
* Expose custom helpers for bpf_sock_addr context instead of doing
  generic bpf_sock argument (as suggested by Daniel). Even with
  try_socket_lock that doesn't sleep we have a problem where context sk
  is already locked and socket lock is non-nestable.

v2:
* s/BPF_PROG_TYPE_CGROUP_SOCKOPT/BPF_PROG_TYPE_SOCK_OPS/

Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Martin KaFai Lau <kafai@fb.com>
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 include/uapi/linux/bpf.h                      |  14 ++-
 net/core/filter.c                             | 118 ++++++++++++++----
 tools/include/uapi/linux/bpf.h                |  14 ++-
 tools/testing/selftests/bpf/config            |   1 +
 .../selftests/bpf/progs/connect4_prog.c       |  46 +++++++
 5 files changed, 166 insertions(+), 27 deletions(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 4a6c47f3febe..761db1aed891 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -1564,7 +1564,7 @@ union bpf_attr {
  * 	Return
  * 		0
  *
- * int bpf_setsockopt(struct bpf_sock_ops *bpf_socket, int level, int optname, void *optval, int optlen)
+ * int bpf_setsockopt(void *bpf_socket, int level, int optname, void *optval, int optlen)
  * 	Description
  * 		Emulate a call to **setsockopt()** on the socket associated to
  * 		*bpf_socket*, which must be a full socket. The *level* at
@@ -1572,6 +1572,11 @@ union bpf_attr {
  * 		must be specified, see **setsockopt(2)** for more information.
  * 		The option value of length *optlen* is pointed by *optval*.
  *
+ * 		*bpf_socket* should be one of the following:
+ * 		* **struct bpf_sock_ops** for **BPF_PROG_TYPE_SOCK_OPS**.
+ * 		* **struct bpf_sock_addr** for **BPF_CGROUP_INET4_CONNECT**
+ * 		  and **BPF_CGROUP_INET6_CONNECT**.
+ *
  * 		This helper actually implements a subset of **setsockopt()**.
  * 		It supports the following *level*\ s:
  *
@@ -1766,7 +1771,7 @@ union bpf_attr {
  * 	Return
  * 		0 on success, or a negative error in case of failure.
  *
- * int bpf_getsockopt(struct bpf_sock_ops *bpf_socket, int level, int optname, void *optval, int optlen)
+ * int bpf_getsockopt(void *bpf_socket, int level, int optname, void *optval, int optlen)
  * 	Description
  * 		Emulate a call to **getsockopt()** on the socket associated to
  * 		*bpf_socket*, which must be a full socket. The *level* at
@@ -1775,6 +1780,11 @@ union bpf_attr {
  * 		The retrieved value is stored in the structure pointed by
  * 		*opval* and of length *optlen*.
  *
+ * 		*bpf_socket* should be one of the following:
+ * 		* **struct bpf_sock_ops** for **BPF_PROG_TYPE_SOCK_OPS**.
+ * 		* **struct bpf_sock_addr** for **BPF_CGROUP_INET4_CONNECT**
+ * 		  and **BPF_CGROUP_INET6_CONNECT**.
+ *
  * 		This helper actually implements a subset of **getsockopt()**.
  * 		It supports the following *level*\ s:
  *
diff --git a/net/core/filter.c b/net/core/filter.c
index da3b7a72c37c..437bb74dd9a9 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -4194,16 +4194,19 @@ static const struct bpf_func_proto bpf_get_socket_uid_proto = {
 	.arg1_type      = ARG_PTR_TO_CTX,
 };
 
-BPF_CALL_5(bpf_setsockopt, struct bpf_sock_ops_kern *, bpf_sock,
-	   int, level, int, optname, char *, optval, int, optlen)
+#define SOCKOPT_CC_REINIT (1 << 0)
+
+static int _bpf_setsockopt(struct sock *sk, int level, int optname,
+			   char *optval, int optlen, u32 flags)
 {
-	struct sock *sk = bpf_sock->sk;
 	int ret = 0;
 	int val;
 
 	if (!sk_fullsock(sk))
 		return -EINVAL;
 
+	sock_owned_by_me(sk);
+
 	if (level == SOL_SOCKET) {
 		if (optlen != sizeof(int))
 			return -EINVAL;
@@ -4298,7 +4301,7 @@ BPF_CALL_5(bpf_setsockopt, struct bpf_sock_ops_kern *, bpf_sock,
 		   sk->sk_prot->setsockopt == tcp_setsockopt) {
 		if (optname == TCP_CONGESTION) {
 			char name[TCP_CA_NAME_MAX];
-			bool reinit = bpf_sock->op > BPF_SOCK_OPS_NEEDS_ECN;
+			bool reinit = flags & SOCKOPT_CC_REINIT;
 
 			strncpy(name, optval, min_t(long, optlen,
 						    TCP_CA_NAME_MAX-1));
@@ -4345,24 +4348,14 @@ BPF_CALL_5(bpf_setsockopt, struct bpf_sock_ops_kern *, bpf_sock,
 	return ret;
 }
 
-static const struct bpf_func_proto bpf_setsockopt_proto = {
-	.func		= bpf_setsockopt,
-	.gpl_only	= false,
-	.ret_type	= RET_INTEGER,
-	.arg1_type	= ARG_PTR_TO_CTX,
-	.arg2_type	= ARG_ANYTHING,
-	.arg3_type	= ARG_ANYTHING,
-	.arg4_type	= ARG_PTR_TO_MEM,
-	.arg5_type	= ARG_CONST_SIZE,
-};
-
-BPF_CALL_5(bpf_getsockopt, struct bpf_sock_ops_kern *, bpf_sock,
-	   int, level, int, optname, char *, optval, int, optlen)
+static int _bpf_getsockopt(struct sock *sk, int level, int optname,
+			   char *optval, int optlen)
 {
-	struct sock *sk = bpf_sock->sk;
-
 	if (!sk_fullsock(sk))
 		goto err_clear;
+
+	sock_owned_by_me(sk);
+
 #ifdef CONFIG_INET
 	if (level == SOL_TCP && sk->sk_prot->getsockopt == tcp_getsockopt) {
 		struct inet_connection_sock *icsk;
@@ -4428,8 +4421,71 @@ BPF_CALL_5(bpf_getsockopt, struct bpf_sock_ops_kern *, bpf_sock,
 	return -EINVAL;
 }
 
-static const struct bpf_func_proto bpf_getsockopt_proto = {
-	.func		= bpf_getsockopt,
+BPF_CALL_5(bpf_sock_addr_setsockopt, struct bpf_sock_addr_kern *, ctx,
+	   int, level, int, optname, char *, optval, int, optlen)
+{
+	u32 flags = 0;
+	return _bpf_setsockopt(ctx->sk, level, optname, optval, optlen,
+			       flags);
+}
+
+static const struct bpf_func_proto bpf_sock_addr_setsockopt_proto = {
+	.func		= bpf_sock_addr_setsockopt,
+	.gpl_only	= false,
+	.ret_type	= RET_INTEGER,
+	.arg1_type	= ARG_PTR_TO_CTX,
+	.arg2_type	= ARG_ANYTHING,
+	.arg3_type	= ARG_ANYTHING,
+	.arg4_type	= ARG_PTR_TO_MEM,
+	.arg5_type	= ARG_CONST_SIZE,
+};
+
+BPF_CALL_5(bpf_sock_addr_getsockopt, struct bpf_sock_addr_kern *, ctx,
+	   int, level, int, optname, char *, optval, int, optlen)
+{
+	return _bpf_getsockopt(ctx->sk, level, optname, optval, optlen);
+}
+
+static const struct bpf_func_proto bpf_sock_addr_getsockopt_proto = {
+	.func		= bpf_sock_addr_getsockopt,
+	.gpl_only	= false,
+	.ret_type	= RET_INTEGER,
+	.arg1_type	= ARG_PTR_TO_CTX,
+	.arg2_type	= ARG_ANYTHING,
+	.arg3_type	= ARG_ANYTHING,
+	.arg4_type	= ARG_PTR_TO_UNINIT_MEM,
+	.arg5_type	= ARG_CONST_SIZE,
+};
+
+BPF_CALL_5(bpf_sock_ops_setsockopt, struct bpf_sock_ops_kern *, bpf_sock,
+	   int, level, int, optname, char *, optval, int, optlen)
+{
+	u32 flags = 0;
+	if (bpf_sock->op > BPF_SOCK_OPS_NEEDS_ECN)
+		flags |= SOCKOPT_CC_REINIT;
+	return _bpf_setsockopt(bpf_sock->sk, level, optname, optval, optlen,
+			       flags);
+}
+
+static const struct bpf_func_proto bpf_sock_ops_setsockopt_proto = {
+	.func		= bpf_sock_ops_setsockopt,
+	.gpl_only	= false,
+	.ret_type	= RET_INTEGER,
+	.arg1_type	= ARG_PTR_TO_CTX,
+	.arg2_type	= ARG_ANYTHING,
+	.arg3_type	= ARG_ANYTHING,
+	.arg4_type	= ARG_PTR_TO_MEM,
+	.arg5_type	= ARG_CONST_SIZE,
+};
+
+BPF_CALL_5(bpf_sock_ops_getsockopt, struct bpf_sock_ops_kern *, bpf_sock,
+	   int, level, int, optname, char *, optval, int, optlen)
+{
+	return _bpf_getsockopt(bpf_sock->sk, level, optname, optval, optlen);
+}
+
+static const struct bpf_func_proto bpf_sock_ops_getsockopt_proto = {
+	.func		= bpf_sock_ops_getsockopt,
 	.gpl_only	= false,
 	.ret_type	= RET_INTEGER,
 	.arg1_type	= ARG_PTR_TO_CTX,
@@ -6043,6 +6099,22 @@ sock_addr_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &bpf_sk_storage_get_proto;
 	case BPF_FUNC_sk_storage_delete:
 		return &bpf_sk_storage_delete_proto;
+	case BPF_FUNC_setsockopt:
+		switch (prog->expected_attach_type) {
+		case BPF_CGROUP_INET4_CONNECT:
+		case BPF_CGROUP_INET6_CONNECT:
+			return &bpf_sock_addr_setsockopt_proto;
+		default:
+			return NULL;
+		}
+	case BPF_FUNC_getsockopt:
+		switch (prog->expected_attach_type) {
+		case BPF_CGROUP_INET4_CONNECT:
+		case BPF_CGROUP_INET6_CONNECT:
+			return &bpf_sock_addr_getsockopt_proto;
+		default:
+			return NULL;
+		}
 	default:
 		return bpf_base_func_proto(func_id);
 	}
@@ -6261,9 +6333,9 @@ sock_ops_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 {
 	switch (func_id) {
 	case BPF_FUNC_setsockopt:
-		return &bpf_setsockopt_proto;
+		return &bpf_sock_ops_setsockopt_proto;
 	case BPF_FUNC_getsockopt:
-		return &bpf_getsockopt_proto;
+		return &bpf_sock_ops_getsockopt_proto;
 	case BPF_FUNC_sock_ops_cb_flags_set:
 		return &bpf_sock_ops_cb_flags_set_proto;
 	case BPF_FUNC_sock_map_update:
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 4a6c47f3febe..761db1aed891 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -1564,7 +1564,7 @@ union bpf_attr {
  * 	Return
  * 		0
  *
- * int bpf_setsockopt(struct bpf_sock_ops *bpf_socket, int level, int optname, void *optval, int optlen)
+ * int bpf_setsockopt(void *bpf_socket, int level, int optname, void *optval, int optlen)
  * 	Description
  * 		Emulate a call to **setsockopt()** on the socket associated to
  * 		*bpf_socket*, which must be a full socket. The *level* at
@@ -1572,6 +1572,11 @@ union bpf_attr {
  * 		must be specified, see **setsockopt(2)** for more information.
  * 		The option value of length *optlen* is pointed by *optval*.
  *
+ * 		*bpf_socket* should be one of the following:
+ * 		* **struct bpf_sock_ops** for **BPF_PROG_TYPE_SOCK_OPS**.
+ * 		* **struct bpf_sock_addr** for **BPF_CGROUP_INET4_CONNECT**
+ * 		  and **BPF_CGROUP_INET6_CONNECT**.
+ *
  * 		This helper actually implements a subset of **setsockopt()**.
  * 		It supports the following *level*\ s:
  *
@@ -1766,7 +1771,7 @@ union bpf_attr {
  * 	Return
  * 		0 on success, or a negative error in case of failure.
  *
- * int bpf_getsockopt(struct bpf_sock_ops *bpf_socket, int level, int optname, void *optval, int optlen)
+ * int bpf_getsockopt(void *bpf_socket, int level, int optname, void *optval, int optlen)
  * 	Description
  * 		Emulate a call to **getsockopt()** on the socket associated to
  * 		*bpf_socket*, which must be a full socket. The *level* at
@@ -1775,6 +1780,11 @@ union bpf_attr {
  * 		The retrieved value is stored in the structure pointed by
  * 		*opval* and of length *optlen*.
  *
+ * 		*bpf_socket* should be one of the following:
+ * 		* **struct bpf_sock_ops** for **BPF_PROG_TYPE_SOCK_OPS**.
+ * 		* **struct bpf_sock_addr** for **BPF_CGROUP_INET4_CONNECT**
+ * 		  and **BPF_CGROUP_INET6_CONNECT**.
+ *
  * 		This helper actually implements a subset of **getsockopt()**.
  * 		It supports the following *level*\ s:
  *
diff --git a/tools/testing/selftests/bpf/config b/tools/testing/selftests/bpf/config
index 60e3ae5d4e48..6e5b94c036ca 100644
--- a/tools/testing/selftests/bpf/config
+++ b/tools/testing/selftests/bpf/config
@@ -37,3 +37,4 @@ CONFIG_IPV6_SIT=m
 CONFIG_BPF_JIT=y
 CONFIG_BPF_LSM=y
 CONFIG_SECURITY=y
+CONFIG_TCP_CONG_DCTCP=y
diff --git a/tools/testing/selftests/bpf/progs/connect4_prog.c b/tools/testing/selftests/bpf/progs/connect4_prog.c
index ad3c498a8150..972918cd2d7f 100644
--- a/tools/testing/selftests/bpf/progs/connect4_prog.c
+++ b/tools/testing/selftests/bpf/progs/connect4_prog.c
@@ -8,6 +8,7 @@
 #include <linux/in.h>
 #include <linux/in6.h>
 #include <sys/socket.h>
+#include <netinet/tcp.h>
 
 #include <bpf/bpf_helpers.h>
 #include <bpf/bpf_endian.h>
@@ -16,6 +17,10 @@
 #define DST_REWRITE_IP4		0x7f000001U
 #define DST_REWRITE_PORT4	4444
 
+#ifndef TCP_CA_NAME_MAX
+#define TCP_CA_NAME_MAX 16
+#endif
+
 int _version SEC("version") = 1;
 
 __attribute__ ((noinline))
@@ -33,6 +38,43 @@ int do_bind(struct bpf_sock_addr *ctx)
 	return 1;
 }
 
+static __inline int verify_cc(struct bpf_sock_addr *ctx,
+			      char expected[TCP_CA_NAME_MAX])
+{
+	char buf[TCP_CA_NAME_MAX];
+	int i;
+
+	if (bpf_getsockopt(ctx, SOL_TCP, TCP_CONGESTION, &buf, sizeof(buf)))
+		return 1;
+
+	for (i = 0; i < TCP_CA_NAME_MAX; i++) {
+		if (buf[i] != expected[i])
+			return 1;
+		if (buf[i] == 0)
+			break;
+	}
+
+	return 0;
+}
+
+static __inline int set_cc(struct bpf_sock_addr *ctx)
+{
+	char dctcp[TCP_CA_NAME_MAX] = "dctcp";
+	char cubic[TCP_CA_NAME_MAX] = "cubic";
+
+	if (bpf_setsockopt(ctx, SOL_TCP, TCP_CONGESTION, &dctcp, sizeof(dctcp)))
+		return 1;
+	if (verify_cc(ctx, dctcp))
+		return 1;
+
+	if (bpf_setsockopt(ctx, SOL_TCP, TCP_CONGESTION, &cubic, sizeof(cubic)))
+		return 1;
+	if (verify_cc(ctx, cubic))
+		return 1;
+
+	return 0;
+}
+
 SEC("cgroup/connect4")
 int connect_v4_prog(struct bpf_sock_addr *ctx)
 {
@@ -66,6 +108,10 @@ int connect_v4_prog(struct bpf_sock_addr *ctx)
 
 	bpf_sk_release(sk);
 
+	/* Rewrite congestion control. */
+	if (ctx->type == SOCK_STREAM && set_cc(ctx))
+		return 0;
+
 	/* Rewrite destination. */
 	ctx->user_ip4 = bpf_htonl(DST_REWRITE_IP4);
 	ctx->user_port = bpf_htons(DST_REWRITE_PORT4);
-- 
2.26.2.526.g744177e7f7-goog

