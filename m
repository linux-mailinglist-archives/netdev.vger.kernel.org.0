Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78C91381EA
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 01:49:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727936AbfFFXtX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 19:49:23 -0400
Received: from www62.your-server.de ([213.133.104.62]:47064 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727846AbfFFXtU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 19:49:20 -0400
Received: from [178.197.249.21] (helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hZ28D-0005RC-4s; Fri, 07 Jun 2019 01:49:17 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     alexei.starovoitov@gmail.com
Cc:     kafai@fb.com, rdna@fb.com, m@lambda.lt, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH bpf v3 5/6] bpf: more msg_name rewrite tests to test_sock_addr
Date:   Fri,  7 Jun 2019 01:49:01 +0200
Message-Id: <20190606234902.4300-6-daniel@iogearbox.net>
X-Mailer: git-send-email 2.9.5
In-Reply-To: <20190606234902.4300-1-daniel@iogearbox.net>
References: <20190606234902.4300-1-daniel@iogearbox.net>
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25472/Thu Jun  6 10:09:59 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extend test_sock_addr for recvmsg test cases, bigger parts of the
sendmsg code can be reused for this. Below are the strace view of
the recvmsg rewrites; the sendmsg side does not have a BPF prog
connected to it for the context of this test:

IPv4 test case:

  [pid  4846] bpf(BPF_PROG_ATTACH, {target_fd=3, attach_bpf_fd=4, attach_type=0x13 /* BPF_??? */, attach_flags=BPF_F_ALLOW_OVERRIDE}, 112) = 0
  [pid  4846] socket(AF_INET, SOCK_DGRAM, IPPROTO_IP) = 5
  [pid  4846] bind(5, {sa_family=AF_INET, sin_port=htons(4444), sin_addr=inet_addr("127.0.0.1")}, 128) = 0
  [pid  4846] socket(AF_INET, SOCK_DGRAM, IPPROTO_IP) = 6
  [pid  4846] sendmsg(6, {msg_name={sa_family=AF_INET, sin_port=htons(4444), sin_addr=inet_addr("127.0.0.1")}, msg_namelen=128, msg_iov=[{iov_base="a", iov_len=1}], msg_iovlen=1, msg_controllen=0, msg_flags=0}, 0) = 1
  [pid  4846] select(6, [5], NULL, NULL, {tv_sec=2, tv_usec=0}) = 1 (in [5], left {tv_sec=1, tv_usec=999995})
  [pid  4846] recvmsg(5, {msg_name={sa_family=AF_INET, sin_port=htons(4040), sin_addr=inet_addr("192.168.1.254")}, msg_namelen=128->16, msg_iov=[{iov_base="a", iov_len=64}], msg_iovlen=1, msg_controllen=0, msg_flags=0}, 0) = 1
  [pid  4846] close(6)                    = 0
  [pid  4846] close(5)                    = 0
  [pid  4846] bpf(BPF_PROG_DETACH, {target_fd=3, attach_type=0x13 /* BPF_??? */}, 112) = 0

IPv6 test case:

  [pid  4846] bpf(BPF_PROG_ATTACH, {target_fd=3, attach_bpf_fd=4, attach_type=0x14 /* BPF_??? */, attach_flags=BPF_F_ALLOW_OVERRIDE}, 112) = 0
  [pid  4846] socket(AF_INET6, SOCK_DGRAM, IPPROTO_IP) = 5
  [pid  4846] bind(5, {sa_family=AF_INET6, sin6_port=htons(6666), inet_pton(AF_INET6, "::1", &sin6_addr), sin6_flowinfo=htonl(0), sin6_scope_id=0}, 128) = 0
  [pid  4846] socket(AF_INET6, SOCK_DGRAM, IPPROTO_IP) = 6
  [pid  4846] sendmsg(6, {msg_name={sa_family=AF_INET6, sin6_port=htons(6666), inet_pton(AF_INET6, "::1", &sin6_addr), sin6_flowinfo=htonl(0), sin6_scope_id=0}, msg_namelen=128, msg_iov=[{iov_base="a", iov_len=1}], msg_iovlen=1, msg_controllen=0, msg_flags=0}, 0) = 1
  [pid  4846] select(6, [5], NULL, NULL, {tv_sec=2, tv_usec=0}) = 1 (in [5], left {tv_sec=1, tv_usec=999996})
  [pid  4846] recvmsg(5, {msg_name={sa_family=AF_INET6, sin6_port=htons(6060), inet_pton(AF_INET6, "face:b00c:1234:5678::abcd", &sin6_addr), sin6_flowinfo=htonl(0), sin6_scope_id=0}, msg_namelen=128->28, msg_iov=[{iov_base="a", iov_len=64}], msg_iovlen=1, msg_controllen=0, msg_flags=0}, 0) = 1
  [pid  4846] close(6)                    = 0
  [pid  4846] close(5)                    = 0
  [pid  4846] bpf(BPF_PROG_DETACH, {target_fd=3, attach_type=0x14 /* BPF_??? */}, 112) = 0

test_sock_addr run w/o strace view:

  # ./test_sock_addr.sh
  [...]
  Test case: recvmsg4: return code ok .. [PASS]
  Test case: recvmsg4: return code !ok .. [PASS]
  Test case: recvmsg6: return code ok .. [PASS]
  Test case: recvmsg6: return code !ok .. [PASS]
  Test case: recvmsg4: rewrite IP & port (asm) .. [PASS]
  Test case: recvmsg6: rewrite IP & port (asm) .. [PASS]
  [...]

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Andrey Ignatov <rdna@fb.com>
Acked-by: Martin KaFai Lau <kafai@fb.com>
---
 tools/testing/selftests/bpf/test_sock_addr.c | 213 +++++++++++++++++--
 1 file changed, 197 insertions(+), 16 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_sock_addr.c b/tools/testing/selftests/bpf/test_sock_addr.c
index 3f110eaaf29c..4ecde2392327 100644
--- a/tools/testing/selftests/bpf/test_sock_addr.c
+++ b/tools/testing/selftests/bpf/test_sock_addr.c
@@ -76,6 +76,7 @@ struct sock_addr_test {
 	enum {
 		LOAD_REJECT,
 		ATTACH_REJECT,
+		ATTACH_OKAY,
 		SYSCALL_EPERM,
 		SYSCALL_ENOTSUPP,
 		SUCCESS,
@@ -88,9 +89,13 @@ static int connect4_prog_load(const struct sock_addr_test *test);
 static int connect6_prog_load(const struct sock_addr_test *test);
 static int sendmsg_allow_prog_load(const struct sock_addr_test *test);
 static int sendmsg_deny_prog_load(const struct sock_addr_test *test);
+static int recvmsg_allow_prog_load(const struct sock_addr_test *test);
+static int recvmsg_deny_prog_load(const struct sock_addr_test *test);
 static int sendmsg4_rw_asm_prog_load(const struct sock_addr_test *test);
+static int recvmsg4_rw_asm_prog_load(const struct sock_addr_test *test);
 static int sendmsg4_rw_c_prog_load(const struct sock_addr_test *test);
 static int sendmsg6_rw_asm_prog_load(const struct sock_addr_test *test);
+static int recvmsg6_rw_asm_prog_load(const struct sock_addr_test *test);
 static int sendmsg6_rw_c_prog_load(const struct sock_addr_test *test);
 static int sendmsg6_rw_v4mapped_prog_load(const struct sock_addr_test *test);
 static int sendmsg6_rw_wildcard_prog_load(const struct sock_addr_test *test);
@@ -507,6 +512,92 @@ static struct sock_addr_test tests[] = {
 		SRC6_REWRITE_IP,
 		SYSCALL_EPERM,
 	},
+
+	/* recvmsg */
+	{
+		"recvmsg4: return code ok",
+		recvmsg_allow_prog_load,
+		BPF_CGROUP_UDP4_RECVMSG,
+		BPF_CGROUP_UDP4_RECVMSG,
+		AF_INET,
+		SOCK_DGRAM,
+		NULL,
+		0,
+		NULL,
+		0,
+		NULL,
+		ATTACH_OKAY,
+	},
+	{
+		"recvmsg4: return code !ok",
+		recvmsg_deny_prog_load,
+		BPF_CGROUP_UDP4_RECVMSG,
+		BPF_CGROUP_UDP4_RECVMSG,
+		AF_INET,
+		SOCK_DGRAM,
+		NULL,
+		0,
+		NULL,
+		0,
+		NULL,
+		LOAD_REJECT,
+	},
+	{
+		"recvmsg6: return code ok",
+		recvmsg_allow_prog_load,
+		BPF_CGROUP_UDP6_RECVMSG,
+		BPF_CGROUP_UDP6_RECVMSG,
+		AF_INET6,
+		SOCK_DGRAM,
+		NULL,
+		0,
+		NULL,
+		0,
+		NULL,
+		ATTACH_OKAY,
+	},
+	{
+		"recvmsg6: return code !ok",
+		recvmsg_deny_prog_load,
+		BPF_CGROUP_UDP6_RECVMSG,
+		BPF_CGROUP_UDP6_RECVMSG,
+		AF_INET6,
+		SOCK_DGRAM,
+		NULL,
+		0,
+		NULL,
+		0,
+		NULL,
+		LOAD_REJECT,
+	},
+	{
+		"recvmsg4: rewrite IP & port (asm)",
+		recvmsg4_rw_asm_prog_load,
+		BPF_CGROUP_UDP4_RECVMSG,
+		BPF_CGROUP_UDP4_RECVMSG,
+		AF_INET,
+		SOCK_DGRAM,
+		SERV4_REWRITE_IP,
+		SERV4_REWRITE_PORT,
+		SERV4_REWRITE_IP,
+		SERV4_REWRITE_PORT,
+		SERV4_IP,
+		SUCCESS,
+	},
+	{
+		"recvmsg6: rewrite IP & port (asm)",
+		recvmsg6_rw_asm_prog_load,
+		BPF_CGROUP_UDP6_RECVMSG,
+		BPF_CGROUP_UDP6_RECVMSG,
+		AF_INET6,
+		SOCK_DGRAM,
+		SERV6_REWRITE_IP,
+		SERV6_REWRITE_PORT,
+		SERV6_REWRITE_IP,
+		SERV6_REWRITE_PORT,
+		SERV6_IP,
+		SUCCESS,
+	},
 };
 
 static int mk_sockaddr(int domain, const char *ip, unsigned short port,
@@ -765,8 +856,8 @@ static int connect6_prog_load(const struct sock_addr_test *test)
 	return load_path(test, CONNECT6_PROG_PATH);
 }
 
-static int sendmsg_ret_only_prog_load(const struct sock_addr_test *test,
-				      int32_t rc)
+static int xmsg_ret_only_prog_load(const struct sock_addr_test *test,
+				   int32_t rc)
 {
 	struct bpf_insn insns[] = {
 		/* return rc */
@@ -778,12 +869,22 @@ static int sendmsg_ret_only_prog_load(const struct sock_addr_test *test,
 
 static int sendmsg_allow_prog_load(const struct sock_addr_test *test)
 {
-	return sendmsg_ret_only_prog_load(test, /*rc*/ 1);
+	return xmsg_ret_only_prog_load(test, /*rc*/ 1);
 }
 
 static int sendmsg_deny_prog_load(const struct sock_addr_test *test)
 {
-	return sendmsg_ret_only_prog_load(test, /*rc*/ 0);
+	return xmsg_ret_only_prog_load(test, /*rc*/ 0);
+}
+
+static int recvmsg_allow_prog_load(const struct sock_addr_test *test)
+{
+	return xmsg_ret_only_prog_load(test, /*rc*/ 1);
+}
+
+static int recvmsg_deny_prog_load(const struct sock_addr_test *test)
+{
+	return xmsg_ret_only_prog_load(test, /*rc*/ 0);
 }
 
 static int sendmsg4_rw_asm_prog_load(const struct sock_addr_test *test)
@@ -838,6 +939,47 @@ static int sendmsg4_rw_asm_prog_load(const struct sock_addr_test *test)
 	return load_insns(test, insns, sizeof(insns) / sizeof(struct bpf_insn));
 }
 
+static int recvmsg4_rw_asm_prog_load(const struct sock_addr_test *test)
+{
+	struct sockaddr_in src4_rw_addr;
+
+	if (mk_sockaddr(AF_INET, SERV4_IP, SERV4_PORT,
+			(struct sockaddr *)&src4_rw_addr,
+			sizeof(src4_rw_addr)) == -1)
+		return -1;
+
+	struct bpf_insn insns[] = {
+		BPF_MOV64_REG(BPF_REG_6, BPF_REG_1),
+
+		/* if (sk.family == AF_INET && */
+		BPF_LDX_MEM(BPF_W, BPF_REG_7, BPF_REG_6,
+			    offsetof(struct bpf_sock_addr, family)),
+		BPF_JMP_IMM(BPF_JNE, BPF_REG_7, AF_INET, 6),
+
+		/*     sk.type == SOCK_DGRAM)  { */
+		BPF_LDX_MEM(BPF_W, BPF_REG_7, BPF_REG_6,
+			    offsetof(struct bpf_sock_addr, type)),
+		BPF_JMP_IMM(BPF_JNE, BPF_REG_7, SOCK_DGRAM, 4),
+
+		/*      user_ip4 = src4_rw_addr.sin_addr */
+		BPF_MOV32_IMM(BPF_REG_7, src4_rw_addr.sin_addr.s_addr),
+		BPF_STX_MEM(BPF_W, BPF_REG_6, BPF_REG_7,
+			    offsetof(struct bpf_sock_addr, user_ip4)),
+
+		/*      user_port = src4_rw_addr.sin_port */
+		BPF_MOV32_IMM(BPF_REG_7, src4_rw_addr.sin_port),
+		BPF_STX_MEM(BPF_W, BPF_REG_6, BPF_REG_7,
+			    offsetof(struct bpf_sock_addr, user_port)),
+		/* } */
+
+		/* return 1 */
+		BPF_MOV64_IMM(BPF_REG_0, 1),
+		BPF_EXIT_INSN(),
+	};
+
+	return load_insns(test, insns, sizeof(insns) / sizeof(struct bpf_insn));
+}
+
 static int sendmsg4_rw_c_prog_load(const struct sock_addr_test *test)
 {
 	return load_path(test, SENDMSG4_PROG_PATH);
@@ -901,6 +1043,39 @@ static int sendmsg6_rw_asm_prog_load(const struct sock_addr_test *test)
 	return sendmsg6_rw_dst_asm_prog_load(test, SERV6_REWRITE_IP);
 }
 
+static int recvmsg6_rw_asm_prog_load(const struct sock_addr_test *test)
+{
+	struct sockaddr_in6 src6_rw_addr;
+
+	if (mk_sockaddr(AF_INET6, SERV6_IP, SERV6_PORT,
+			(struct sockaddr *)&src6_rw_addr,
+			sizeof(src6_rw_addr)) == -1)
+		return -1;
+
+	struct bpf_insn insns[] = {
+		BPF_MOV64_REG(BPF_REG_6, BPF_REG_1),
+
+		/* if (sk.family == AF_INET6) { */
+		BPF_LDX_MEM(BPF_W, BPF_REG_7, BPF_REG_6,
+			    offsetof(struct bpf_sock_addr, family)),
+		BPF_JMP_IMM(BPF_JNE, BPF_REG_7, AF_INET6, 10),
+
+		STORE_IPV6(user_ip6, src6_rw_addr.sin6_addr.s6_addr32),
+
+		/*      user_port = dst6_rw_addr.sin6_port */
+		BPF_MOV32_IMM(BPF_REG_7, src6_rw_addr.sin6_port),
+		BPF_STX_MEM(BPF_W, BPF_REG_6, BPF_REG_7,
+			    offsetof(struct bpf_sock_addr, user_port)),
+		/* } */
+
+		/* return 1 */
+		BPF_MOV64_IMM(BPF_REG_0, 1),
+		BPF_EXIT_INSN(),
+	};
+
+	return load_insns(test, insns, sizeof(insns) / sizeof(struct bpf_insn));
+}
+
 static int sendmsg6_rw_v4mapped_prog_load(const struct sock_addr_test *test)
 {
 	return sendmsg6_rw_dst_asm_prog_load(test, SERV6_V4MAPPED_IP);
@@ -1282,13 +1457,13 @@ static int run_connect_test_case(const struct sock_addr_test *test)
 	return err;
 }
 
-static int run_sendmsg_test_case(const struct sock_addr_test *test)
+static int run_xmsg_test_case(const struct sock_addr_test *test, int max_cmsg)
 {
 	socklen_t addr_len = sizeof(struct sockaddr_storage);
-	struct sockaddr_storage expected_src_addr;
-	struct sockaddr_storage requested_addr;
 	struct sockaddr_storage expected_addr;
-	struct sockaddr_storage real_src_addr;
+	struct sockaddr_storage server_addr;
+	struct sockaddr_storage sendmsg_addr;
+	struct sockaddr_storage recvmsg_addr;
 	int clientfd = -1;
 	int servfd = -1;
 	int set_cmsg;
@@ -1297,20 +1472,19 @@ static int run_sendmsg_test_case(const struct sock_addr_test *test)
 	if (test->type != SOCK_DGRAM)
 		goto err;
 
-	if (init_addrs(test, &requested_addr, &expected_addr,
-		       &expected_src_addr))
+	if (init_addrs(test, &sendmsg_addr, &server_addr, &expected_addr))
 		goto err;
 
 	/* Prepare server to sendmsg to */
-	servfd = start_server(test->type, &expected_addr, addr_len);
+	servfd = start_server(test->type, &server_addr, addr_len);
 	if (servfd == -1)
 		goto err;
 
-	for (set_cmsg = 0; set_cmsg <= 1; ++set_cmsg) {
+	for (set_cmsg = 0; set_cmsg <= max_cmsg; ++set_cmsg) {
 		if (clientfd >= 0)
 			close(clientfd);
 
-		clientfd = sendmsg_to_server(test->type, &requested_addr,
+		clientfd = sendmsg_to_server(test->type, &sendmsg_addr,
 					     addr_len, set_cmsg, /*flags*/0,
 					     &err);
 		if (err)
@@ -1330,10 +1504,10 @@ static int run_sendmsg_test_case(const struct sock_addr_test *test)
 		 * specific packet may differ from the one used by default and
 		 * returned by getsockname(2).
 		 */
-		if (recvmsg_from_client(servfd, &real_src_addr) == -1)
+		if (recvmsg_from_client(servfd, &recvmsg_addr) == -1)
 			goto err;
 
-		if (cmp_addr(&real_src_addr, &expected_src_addr, /*cmp_port*/0))
+		if (cmp_addr(&recvmsg_addr, &expected_addr, /*cmp_port*/0))
 			goto err;
 	}
 
@@ -1366,6 +1540,9 @@ static int run_test_case(int cgfd, const struct sock_addr_test *test)
 		goto out;
 	} else if (test->expected_result == ATTACH_REJECT || err) {
 		goto err;
+	} else if (test->expected_result == ATTACH_OKAY) {
+		err = 0;
+		goto out;
 	}
 
 	switch (test->attach_type) {
@@ -1379,7 +1556,11 @@ static int run_test_case(int cgfd, const struct sock_addr_test *test)
 		break;
 	case BPF_CGROUP_UDP4_SENDMSG:
 	case BPF_CGROUP_UDP6_SENDMSG:
-		err = run_sendmsg_test_case(test);
+		err = run_xmsg_test_case(test, 1);
+		break;
+	case BPF_CGROUP_UDP4_RECVMSG:
+	case BPF_CGROUP_UDP6_RECVMSG:
+		err = run_xmsg_test_case(test, 0);
 		break;
 	default:
 		goto err;
-- 
2.17.1

