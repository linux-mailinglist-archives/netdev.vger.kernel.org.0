Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 762255178E8
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 23:12:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387610AbiEBVQS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 17:16:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387587AbiEBVQN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 17:16:13 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B41B726E7;
        Mon,  2 May 2022 14:12:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651525962; x=1683061962;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=w7DmikPOEaCyht0W/XjjvDZXzRCMKS5BeJ10fuKH5eY=;
  b=ZMjQ9D9GRf+wcPlahLevRhr5Usw5UpVXmaBCnJ2Y1jETH9Xl+Zk4Opr3
   kzoRC0I3/fYM0AmUmpeq6wzTs9h5REjTBjRmIbTvRyWUnT3wFdgc3uA5E
   m5XP0V+W/B49s2M0rWdaRIcA+EhlnTMLRw2P0l0Jpt4nJgTfwTrjYqH0l
   z6cfn6Emu6lrM0uSxXGAcOa0CkmdGO39fiW0t5GK3Trr4R2GLrCuKvwG0
   OtAAVXgilNgHmBO/mIbNPWQNEkEHJZJCMi/imik+E2Fa4CPBCbHWL6uR8
   +NUVwdceyRhQNQx0lvW/TN2GUs6f2D/gZrZLDHT7tyKq2XXHb+crieUyn
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10335"; a="247878466"
X-IronPort-AV: E=Sophos;i="5.91,193,1647327600"; 
   d="scan'208";a="247878466"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 May 2022 14:12:41 -0700
X-IronPort-AV: E=Sophos;i="5.91,193,1647327600"; 
   d="scan'208";a="810393793"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.212.141.55])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 May 2022 14:12:41 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     Nicolas Rybowski <nicolas.rybowski@tessares.net>, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, mptcp@lists.linux.dev,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Geliang Tang <geliang.tang@suse.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH bpf-next v3 4/8] selftests: bpf: add MPTCP test base
Date:   Mon,  2 May 2022 14:12:30 -0700
Message-Id: <20220502211235.142250-5-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220502211235.142250-1-mathew.j.martineau@linux.intel.com>
References: <20220502211235.142250-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nicolas Rybowski <nicolas.rybowski@tessares.net>

This patch adds a base for MPTCP specific tests.

It is currently limited to the is_mptcp field in case of plain TCP
connection because there is no easy way to get the subflow sk from a msk
in userspace. This implies that we cannot lookup the sk_storage attached
to the subflow sk in the sockops program.

Acked-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Co-developed-by: Geliang Tang <geliang.tang@suse.com>
Signed-off-by: Geliang Tang <geliang.tang@suse.com>
Signed-off-by: Nicolas Rybowski <nicolas.rybowski@tessares.net>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 MAINTAINERS                                   |   1 +
 tools/testing/selftests/bpf/config            |   1 +
 tools/testing/selftests/bpf/network_helpers.c |  43 ++++--
 tools/testing/selftests/bpf/network_helpers.h |   4 +
 .../testing/selftests/bpf/prog_tests/mptcp.c  | 136 ++++++++++++++++++
 .../testing/selftests/bpf/progs/mptcp_sock.c  |  50 +++++++
 6 files changed, 227 insertions(+), 8 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/mptcp.c
 create mode 100644 tools/testing/selftests/bpf/progs/mptcp_sock.c

diff --git a/MAINTAINERS b/MAINTAINERS
index cc5559a7fb5c..359afc617b92 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13780,6 +13780,7 @@ F:	include/net/mptcp.h
 F:	include/trace/events/mptcp.h
 F:	include/uapi/linux/mptcp.h
 F:	net/mptcp/
+F:	tools/testing/selftests/bpf/*/*mptcp*.c
 F:	tools/testing/selftests/net/mptcp/
 
 NETWORKING [TCP]
diff --git a/tools/testing/selftests/bpf/config b/tools/testing/selftests/bpf/config
index 8d7faff33c54..a25e15d55918 100644
--- a/tools/testing/selftests/bpf/config
+++ b/tools/testing/selftests/bpf/config
@@ -55,3 +55,4 @@ CONFIG_NF_CONNTRACK=y
 CONFIG_USERFAULTFD=y
 CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
+CONFIG_MPTCP=y
diff --git a/tools/testing/selftests/bpf/network_helpers.c b/tools/testing/selftests/bpf/network_helpers.c
index 2bb1f9b3841d..c9a2e39e34fc 100644
--- a/tools/testing/selftests/bpf/network_helpers.c
+++ b/tools/testing/selftests/bpf/network_helpers.c
@@ -21,6 +21,10 @@
 #include "network_helpers.h"
 #include "test_progs.h"
 
+#ifndef IPPROTO_MPTCP
+#define IPPROTO_MPTCP 262
+#endif
+
 #define clean_errno() (errno == 0 ? "None" : strerror(errno))
 #define log_err(MSG, ...) ({						\
 			int __save = errno;				\
@@ -73,13 +77,13 @@ int settimeo(int fd, int timeout_ms)
 
 #define save_errno_close(fd) ({ int __save = errno; close(fd); errno = __save; })
 
-static int __start_server(int type, const struct sockaddr *addr,
+static int __start_server(int type, int protocol, const struct sockaddr *addr,
 			  socklen_t addrlen, int timeout_ms, bool reuseport)
 {
 	int on = 1;
 	int fd;
 
-	fd = socket(addr->sa_family, type, 0);
+	fd = socket(addr->sa_family, type, protocol);
 	if (fd < 0) {
 		log_err("Failed to create server socket");
 		return -1;
@@ -113,8 +117,8 @@ static int __start_server(int type, const struct sockaddr *addr,
 	return -1;
 }
 
-int start_server(int family, int type, const char *addr_str, __u16 port,
-		 int timeout_ms)
+static int start_server_proto(int family, int type, int protocol,
+			      const char *addr_str, __u16 port, int timeout_ms)
 {
 	struct sockaddr_storage addr;
 	socklen_t addrlen;
@@ -122,10 +126,23 @@ int start_server(int family, int type, const char *addr_str, __u16 port,
 	if (make_sockaddr(family, addr_str, port, &addr, &addrlen))
 		return -1;
 
-	return __start_server(type, (struct sockaddr *)&addr,
+	return __start_server(type, protocol, (struct sockaddr *)&addr,
 			      addrlen, timeout_ms, false);
 }
 
+int start_server(int family, int type, const char *addr_str, __u16 port,
+		 int timeout_ms)
+{
+	return start_server_proto(family, type, 0, addr_str, port, timeout_ms);
+}
+
+int start_mptcp_server(int family, const char *addr_str, __u16 port,
+		       int timeout_ms)
+{
+	return start_server_proto(family, SOCK_STREAM, IPPROTO_MPTCP, addr_str,
+				  port, timeout_ms);
+}
+
 int *start_reuseport_server(int family, int type, const char *addr_str,
 			    __u16 port, int timeout_ms, unsigned int nr_listens)
 {
@@ -144,7 +161,7 @@ int *start_reuseport_server(int family, int type, const char *addr_str,
 	if (!fds)
 		return NULL;
 
-	fds[0] = __start_server(type, (struct sockaddr *)&addr, addrlen,
+	fds[0] = __start_server(type, 0, (struct sockaddr *)&addr, addrlen,
 				timeout_ms, true);
 	if (fds[0] == -1)
 		goto close_fds;
@@ -154,7 +171,7 @@ int *start_reuseport_server(int family, int type, const char *addr_str,
 		goto close_fds;
 
 	for (; nr_fds < nr_listens; nr_fds++) {
-		fds[nr_fds] = __start_server(type, (struct sockaddr *)&addr,
+		fds[nr_fds] = __start_server(type, 0, (struct sockaddr *)&addr,
 					     addrlen, timeout_ms, true);
 		if (fds[nr_fds] == -1)
 			goto close_fds;
@@ -265,7 +282,7 @@ int connect_to_fd_opts(int server_fd, const struct network_helper_opts *opts)
 	}
 
 	addr_in = (struct sockaddr_in *)&addr;
-	fd = socket(addr_in->sin_family, type, 0);
+	fd = socket(addr_in->sin_family, type, opts->protocol);
 	if (fd < 0) {
 		log_err("Failed to create client socket");
 		return -1;
@@ -298,6 +315,16 @@ int connect_to_fd(int server_fd, int timeout_ms)
 	return connect_to_fd_opts(server_fd, &opts);
 }
 
+int connect_to_mptcp_fd(int server_fd, int timeout_ms)
+{
+	struct network_helper_opts opts = {
+		.timeout_ms = timeout_ms,
+		.protocol = IPPROTO_MPTCP,
+	};
+
+	return connect_to_fd_opts(server_fd, &opts);
+}
+
 int connect_fd_to_fd(int client_fd, int server_fd, int timeout_ms)
 {
 	struct sockaddr_storage addr;
diff --git a/tools/testing/selftests/bpf/network_helpers.h b/tools/testing/selftests/bpf/network_helpers.h
index a4b3b2f9877b..e0feb115b2ae 100644
--- a/tools/testing/selftests/bpf/network_helpers.h
+++ b/tools/testing/selftests/bpf/network_helpers.h
@@ -21,6 +21,7 @@ struct network_helper_opts {
 	const char *cc;
 	int timeout_ms;
 	bool must_fail;
+	int protocol;
 };
 
 /* ipv4 test vector */
@@ -42,11 +43,14 @@ extern struct ipv6_packet pkt_v6;
 int settimeo(int fd, int timeout_ms);
 int start_server(int family, int type, const char *addr, __u16 port,
 		 int timeout_ms);
+int start_mptcp_server(int family, const char *addr, __u16 port,
+		       int timeout_ms);
 int *start_reuseport_server(int family, int type, const char *addr_str,
 			    __u16 port, int timeout_ms,
 			    unsigned int nr_listens);
 void free_fds(int *fds, unsigned int nr_close_fds);
 int connect_to_fd(int server_fd, int timeout_ms);
+int connect_to_mptcp_fd(int server_fd, int timeout_ms);
 int connect_to_fd_opts(int server_fd, const struct network_helper_opts *opts);
 int connect_fd_to_fd(int client_fd, int server_fd, int timeout_ms);
 int fastopen_connect(int server_fd, const char *data, unsigned int data_len,
diff --git a/tools/testing/selftests/bpf/prog_tests/mptcp.c b/tools/testing/selftests/bpf/prog_tests/mptcp.c
new file mode 100644
index 000000000000..cd548bb2828f
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/mptcp.c
@@ -0,0 +1,136 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2020, Tessares SA. */
+
+#include <test_progs.h>
+#include "cgroup_helpers.h"
+#include "network_helpers.h"
+
+struct mptcp_storage {
+	__u32 invoked;
+	__u32 is_mptcp;
+};
+
+static int verify_sk(int map_fd, int client_fd, const char *msg, __u32 is_mptcp)
+{
+	int err = 0, cfd = client_fd;
+	struct mptcp_storage val;
+
+	if (is_mptcp == 1)
+		return 0;
+
+	if (CHECK_FAIL(bpf_map_lookup_elem(map_fd, &cfd, &val) < 0)) {
+		perror("Failed to read socket storage");
+		return -1;
+	}
+
+	if (val.invoked != 1) {
+		log_err("%s: unexpected invoked count %d != 1",
+			msg, val.invoked);
+		err++;
+	}
+
+	if (val.is_mptcp != 0) {
+		log_err("%s: unexpected bpf_tcp_sock.is_mptcp %d != 0",
+			msg, val.is_mptcp);
+		err++;
+	}
+
+	return err;
+}
+
+static int run_test(int cgroup_fd, int server_fd, bool is_mptcp)
+{
+	int client_fd, prog_fd, map_fd, err;
+	struct bpf_program *prog;
+	struct bpf_object *obj;
+	struct bpf_map *map;
+
+	obj = bpf_object__open("./mptcp_sock.o");
+	if (libbpf_get_error(obj))
+		return -EIO;
+
+	err = bpf_object__load(obj);
+	if (CHECK_FAIL(err))
+		goto out;
+
+	prog = bpf_object__find_program_by_name(obj, "_sockops");
+	if (CHECK_FAIL(!prog)) {
+		err = -EIO;
+		goto out;
+	}
+
+	prog_fd = bpf_program__fd(prog);
+	if (CHECK_FAIL(prog_fd < 0)) {
+		err = -EIO;
+		goto out;
+	}
+
+	map = bpf_object__find_map_by_name(obj, "socket_storage_map");
+	if (CHECK_FAIL(!map)) {
+		err = -EIO;
+		goto out;
+	}
+
+	map_fd = bpf_map__fd(map);
+	if (CHECK_FAIL(map_fd < 0)) {
+		err = -EIO;
+		goto out;
+	}
+
+	err = bpf_prog_attach(prog_fd, cgroup_fd, BPF_CGROUP_SOCK_OPS, 0);
+	if (CHECK_FAIL(err))
+		goto out;
+
+	client_fd = is_mptcp ? connect_to_mptcp_fd(server_fd, 0) :
+			       connect_to_fd(server_fd, 0);
+	if (client_fd < 0) {
+		err = -EIO;
+		goto out;
+	}
+
+	err += is_mptcp ? verify_sk(map_fd, client_fd, "MPTCP subflow socket", 1) :
+			  verify_sk(map_fd, client_fd, "plain TCP socket", 0);
+
+	close(client_fd);
+
+out:
+	bpf_object__close(obj);
+	return err;
+}
+
+void test_base(void)
+{
+	int server_fd, cgroup_fd;
+
+	cgroup_fd = test__join_cgroup("/mptcp");
+	if (CHECK_FAIL(cgroup_fd < 0))
+		return;
+
+	/* without MPTCP */
+	server_fd = start_server(AF_INET, SOCK_STREAM, NULL, 0, 0);
+	if (CHECK_FAIL(server_fd < 0))
+		goto with_mptcp;
+
+	CHECK_FAIL(run_test(cgroup_fd, server_fd, false));
+
+	close(server_fd);
+
+with_mptcp:
+	/* with MPTCP */
+	server_fd = start_mptcp_server(AF_INET, NULL, 0, 0);
+	if (CHECK_FAIL(server_fd < 0))
+		goto close_cgroup_fd;
+
+	CHECK_FAIL(run_test(cgroup_fd, server_fd, true));
+
+	close(server_fd);
+
+close_cgroup_fd:
+	close(cgroup_fd);
+}
+
+void test_mptcp(void)
+{
+	if (test__start_subtest("base"))
+		test_base();
+}
diff --git a/tools/testing/selftests/bpf/progs/mptcp_sock.c b/tools/testing/selftests/bpf/progs/mptcp_sock.c
new file mode 100644
index 000000000000..0d65fb889d03
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/mptcp_sock.c
@@ -0,0 +1,50 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2020, Tessares SA. */
+
+#include <linux/bpf.h>
+#include <bpf/bpf_helpers.h>
+
+char _license[] SEC("license") = "GPL";
+__u32 _version SEC("version") = 1;
+
+struct mptcp_storage {
+	__u32 invoked;
+	__u32 is_mptcp;
+};
+
+struct {
+	__uint(type, BPF_MAP_TYPE_SK_STORAGE);
+	__uint(map_flags, BPF_F_NO_PREALLOC);
+	__type(key, int);
+	__type(value, struct mptcp_storage);
+} socket_storage_map SEC(".maps");
+
+SEC("sockops")
+int _sockops(struct bpf_sock_ops *ctx)
+{
+	struct mptcp_storage *storage;
+	struct bpf_tcp_sock *tcp_sk;
+	int op = (int)ctx->op;
+	struct bpf_sock *sk;
+
+	if (op != BPF_SOCK_OPS_TCP_CONNECT_CB)
+		return 1;
+
+	sk = ctx->sk;
+	if (!sk)
+		return 1;
+
+	tcp_sk = bpf_tcp_sock(sk);
+	if (!tcp_sk)
+		return 1;
+
+	storage = bpf_sk_storage_get(&socket_storage_map, sk, 0,
+				     BPF_SK_STORAGE_GET_F_CREATE);
+	if (!storage)
+		return 1;
+
+	storage->invoked++;
+	storage->is_mptcp = tcp_sk->is_mptcp;
+
+	return 1;
+}
-- 
2.36.0

