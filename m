Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A034A1BE4B8
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 19:05:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726621AbgD2RF3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 13:05:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726423AbgD2RF2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 13:05:28 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70926C035493
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 10:05:27 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id l19so3351388qki.14
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 10:05:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=kU0ntdgitq8TD6sFlQwPmnvfvPcmqGtXuzuLOCmXBpo=;
        b=v6gwWsFAVHT1MYBrE+usu3IK2KjeDT4AffFAE9IlDCmSSCLZa0dhBrc5g8ZaE4AKvM
         Y3DpHeOEEChRMTphkqyYDCBRU1D2gzM6OlFhlNPTMxXaeH70jL9vpFOj8QFqzHL0gMF3
         cPjPGNb+MvXH2R6up2g91beYbrUe9RJcBCdhZ1NMM7wEtuEYuzLjsXjZM9iW4MSJNxfZ
         yFO/sdHpmGjrXj4V6mJzPN+t2oE7hg46f4SxXKhtXLkWzTSF2S/KdmvqpF3u2VUCIWF8
         WEU0J/F4xkYQPsbXF1+h11iq0mXqlfhxEET/9uaUna7/jj9GMjT04ch+8gr00ekvkdGN
         91DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=kU0ntdgitq8TD6sFlQwPmnvfvPcmqGtXuzuLOCmXBpo=;
        b=U7ymo2cdaByt2Wg9vYoV9CEeB6rXL3AlfmHqJET6L0aBDubITbLwg2j+WAehZmCesy
         zorzY4fqItcfVBK20DG2nI9nh2ukI8maAZ602P6mru/PgtwBD0i5uuFWnvpDNZIzZ/9w
         HJcsaN62WvtOX3FraCqtcl6YwK9HoRp2Dk++N3J2w4ZbpB7nE5QtvC2ZIF6uwfVojT46
         2LYdQ3pwmpAq7m5aJVBVS5uaP0uxyHwywBflbA6imC/YpI7k7fSfQKiydl/q7DLkp0Md
         CIqXysF/us1uQdWVDlbd98EupTgIZcIBUVY7R8W2TsvHY/4U+8367lzrmQUILzVYJOjN
         nK7w==
X-Gm-Message-State: AGi0Pub1a+w7PlNdwhHT6OKWloIfDTTxkblIaVAJ68T7Zrdxh+SAyZGC
        zvUjUwvWT0AmSjwXcZNhS/JiXf769sao9fze+X9/8gUMvxIBZJKPUXpAgcrm4s8XLoyvyFyFj55
        cc6GEl/oIAWs+p1kshvQpq9XzhRcNgJz2N9Ogv9iHLArjRHxe9UAtvA==
X-Google-Smtp-Source: APiQypLxeBEhrUSi/4gigrIdjmZA8Iht2dxpQRJ9cfHpghgUr+6uJpU/BeCSOVXrvGmggOZOWjoYoCQ=
X-Received: by 2002:a05:6214:158b:: with SMTP id m11mr28704863qvw.168.1588179926270;
 Wed, 29 Apr 2020 10:05:26 -0700 (PDT)
Date:   Wed, 29 Apr 2020 10:05:24 -0700
Message-Id: <20200429170524.217865-1-sdf@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.26.2.303.gf8c07b1a785-goog
Subject: [PATCH bpf-next v2] bpf: bpf_{g,s}etsockopt for struct bpf_sock
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

Currently, bpf_getsocktop and bpf_setsockopt helpers operate on the
'struct bpf_sock_ops' context in BPF_PROG_TYPE_SOCK_OPS program.
Let's generalize them and make the first argument be 'struct bpf_sock'.
That way, in the future, we can allow those helpers in more places.

BPF_PROG_TYPE_SOCK_OPS still has the existing helpers that operate
on 'struct bpf_sock_ops', but we add new bpf_{g,s}etsockopt that work
on 'struct bpf_sock'. [Alternatively, for BPF_PROG_TYPE_SOCK_OPS,
we can enable them both and teach verifier to pick the right one
based on the context (bpf_sock_ops vs bpf_sock).]

As an example, let's allow those 'struct bpf_sock' based helpers to
be called from the BPF_CGROUP_INET{4,6}_CONNECT hooks. That way
we can override CC before the connection is made.

v2:
* s/BPF_PROG_TYPE_CGROUP_SOCKOPT/BPF_PROG_TYPE_SOCK_OPS/

Acked-by: John Fastabend <john.fastabend@gmail.com>
Acked-by: Martin KaFai Lau <kafai@fb.com>
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 include/uapi/linux/bpf.h                      |  12 +-
 net/core/filter.c                             | 113 ++++++++++++++----
 tools/include/uapi/linux/bpf.h                |  12 +-
 tools/testing/selftests/bpf/config            |   1 +
 .../selftests/bpf/progs/connect4_prog.c       |  46 +++++++
 5 files changed, 159 insertions(+), 25 deletions(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 4a6c47f3febe..b50a316c6289 100644
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
@@ -1572,6 +1572,10 @@ union bpf_attr {
  * 		must be specified, see **setsockopt(2)** for more information.
  * 		The option value of length *optlen* is pointed by *optval*.
  *
+ * 		*bpf_socket* should be one of the following:
+ * 		* **struct bpf_sock_ops** for **BPF_PROG_TYPE_SOCK_OPS**.
+ * 		* **struct bpf_sock** for the other types.
+ *
  * 		This helper actually implements a subset of **setsockopt()**.
  * 		It supports the following *level*\ s:
  *
@@ -1766,7 +1770,7 @@ union bpf_attr {
  * 	Return
  * 		0 on success, or a negative error in case of failure.
  *
- * int bpf_getsockopt(struct bpf_sock_ops *bpf_socket, int level, int optname, void *optval, int optlen)
+ * int bpf_getsockopt(void *bpf_socket, int level, int optname, void *optval, int optlen)
  * 	Description
  * 		Emulate a call to **getsockopt()** on the socket associated to
  * 		*bpf_socket*, which must be a full socket. The *level* at
@@ -1775,6 +1779,10 @@ union bpf_attr {
  * 		The retrieved value is stored in the structure pointed by
  * 		*opval* and of length *optlen*.
  *
+ * 		*bpf_socket* should be one of the following:
+ * 		* **struct bpf_sock_ops** for **BPF_PROG_TYPE_SOCK_OPS**.
+ * 		* **struct bpf_sock** for the other types.
+ *
  * 		This helper actually implements a subset of **getsockopt()**.
  * 		It supports the following *level*\ s:
  *
diff --git a/net/core/filter.c b/net/core/filter.c
index da3b7a72c37c..0e8f2c9cfe27 100644
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
@@ -4428,10 +4421,72 @@ BPF_CALL_5(bpf_getsockopt, struct bpf_sock_ops_kern *, bpf_sock,
 	return -EINVAL;
 }
 
+BPF_CALL_5(bpf_setsockopt, struct sock *, sk,
+	   int, level, int, optname, char *, optval, int, optlen)
+{
+	u32 flags = 0;
+	return _bpf_setsockopt(sk, level, optname, optval, optlen, flags);
+}
+
+static const struct bpf_func_proto bpf_setsockopt_proto = {
+	.func		= bpf_setsockopt,
+	.gpl_only	= false,
+	.ret_type	= RET_INTEGER,
+	.arg1_type	= ARG_PTR_TO_SOCKET,
+	.arg2_type	= ARG_ANYTHING,
+	.arg3_type	= ARG_ANYTHING,
+	.arg4_type	= ARG_PTR_TO_MEM,
+	.arg5_type	= ARG_CONST_SIZE,
+};
+
+BPF_CALL_5(bpf_getsockopt, struct sock *, sk,
+	   int, level, int, optname, char *, optval, int, optlen)
+{
+	return _bpf_getsockopt(sk, level, optname, optval, optlen);
+}
+
 static const struct bpf_func_proto bpf_getsockopt_proto = {
 	.func		= bpf_getsockopt,
 	.gpl_only	= false,
 	.ret_type	= RET_INTEGER,
+	.arg1_type	= ARG_PTR_TO_SOCKET,
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
+	.gpl_only	= false,
+	.ret_type	= RET_INTEGER,
 	.arg1_type	= ARG_PTR_TO_CTX,
 	.arg2_type	= ARG_ANYTHING,
 	.arg3_type	= ARG_ANYTHING,
@@ -6043,6 +6098,22 @@ sock_addr_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &bpf_sk_storage_get_proto;
 	case BPF_FUNC_sk_storage_delete:
 		return &bpf_sk_storage_delete_proto;
+	case BPF_FUNC_setsockopt:
+		switch (prog->expected_attach_type) {
+		case BPF_CGROUP_INET4_CONNECT:
+		case BPF_CGROUP_INET6_CONNECT:
+			return &bpf_setsockopt_proto;
+		default:
+			return NULL;
+		}
+	case BPF_FUNC_getsockopt:
+		switch (prog->expected_attach_type) {
+		case BPF_CGROUP_INET4_CONNECT:
+		case BPF_CGROUP_INET6_CONNECT:
+			return &bpf_getsockopt_proto;
+		default:
+			return NULL;
+		}
 	default:
 		return bpf_base_func_proto(func_id);
 	}
@@ -6261,9 +6332,9 @@ sock_ops_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
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
index 4a6c47f3febe..b50a316c6289 100644
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
@@ -1572,6 +1572,10 @@ union bpf_attr {
  * 		must be specified, see **setsockopt(2)** for more information.
  * 		The option value of length *optlen* is pointed by *optval*.
  *
+ * 		*bpf_socket* should be one of the following:
+ * 		* **struct bpf_sock_ops** for **BPF_PROG_TYPE_SOCK_OPS**.
+ * 		* **struct bpf_sock** for the other types.
+ *
  * 		This helper actually implements a subset of **setsockopt()**.
  * 		It supports the following *level*\ s:
  *
@@ -1766,7 +1770,7 @@ union bpf_attr {
  * 	Return
  * 		0 on success, or a negative error in case of failure.
  *
- * int bpf_getsockopt(struct bpf_sock_ops *bpf_socket, int level, int optname, void *optval, int optlen)
+ * int bpf_getsockopt(void *bpf_socket, int level, int optname, void *optval, int optlen)
  * 	Description
  * 		Emulate a call to **getsockopt()** on the socket associated to
  * 		*bpf_socket*, which must be a full socket. The *level* at
@@ -1775,6 +1779,10 @@ union bpf_attr {
  * 		The retrieved value is stored in the structure pointed by
  * 		*opval* and of length *optlen*.
  *
+ * 		*bpf_socket* should be one of the following:
+ * 		* **struct bpf_sock_ops** for **BPF_PROG_TYPE_SOCK_OPS**.
+ * 		* **struct bpf_sock** for the other types.
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
index ad3c498a8150..656eb8c1ffc8 100644
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
 
+static __inline int verify_cc(struct bpf_sock *sk,
+			      char expected[TCP_CA_NAME_MAX])
+{
+	char buf[TCP_CA_NAME_MAX];
+	int i;
+
+	if (bpf_getsockopt(sk, SOL_TCP, TCP_CONGESTION, &buf, sizeof(buf)))
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
+static __inline int set_cc(struct bpf_sock *sk)
+{
+	char dctcp[TCP_CA_NAME_MAX] = "dctcp";
+	char cubic[TCP_CA_NAME_MAX] = "cubic";
+
+	if (bpf_setsockopt(sk, SOL_TCP, TCP_CONGESTION, &dctcp, sizeof(dctcp)))
+		return 1;
+	if (verify_cc(sk, dctcp))
+		return 1;
+
+	if (bpf_setsockopt(sk, SOL_TCP, TCP_CONGESTION, &cubic, sizeof(cubic)))
+		return 1;
+	if (verify_cc(sk, cubic))
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
+	if (ctx->type == SOCK_STREAM && set_cc(ctx->sk))
+		return 0;
+
 	/* Rewrite destination. */
 	ctx->user_ip4 = bpf_htonl(DST_REWRITE_IP4);
 	ctx->user_port = bpf_htons(DST_REWRITE_PORT4);
-- 
2.26.2.303.gf8c07b1a785-goog

