Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E8701D7CF9
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 17:35:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728380AbgERPfl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 11:35:41 -0400
Received: from www62.your-server.de ([213.133.104.62]:34772 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728055AbgERPfj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 11:35:39 -0400
Received: from 75.57.196.178.dynamic.wline.res.cust.swisscom.ch ([178.196.57.75] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jahnj-00029t-Ix; Mon, 18 May 2020 17:35:35 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     ast@kernel.org
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, rdna@fb.com,
        sdf@google.com, Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH bpf-next 4/4] bpf, testing: add get{peer,sock}name selftests to test_progs
Date:   Mon, 18 May 2020 17:35:15 +0200
Message-Id: <1b9869b34027bc0722f4217a0b04f1cccccc5c33.1589813738.git.daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1589813738.git.daniel@iogearbox.net>
References: <cover.1589813738.git.daniel@iogearbox.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25816/Mon May 18 14:17:08 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extend the existing connect_force_port test to assert get{peer,sock}name programs
as well. The workflow for e.g. IPv4 is as follows: i) server binds to concrete
port, ii) client calls getsockname() on server fd which exposes 1.2.3.4:60000 to
client, iii) client connects to service address 1.2.3.4:60000 binds to concrete
local address (127.0.0.1:22222) and remaps service address to a concrete backend
address (127.0.0.1:60123), iv) client then calls getsockname() on its own fd to
verify local address (127.0.0.1:22222) and getpeername() on its own fd which then
publishes service address (1.2.3.4:60000) instead of actual backend. Same workflow
is done for IPv6 just with different address/port tuples.

  # ./test_progs -t connect_force_port
  #14 connect_force_port:OK
  Summary: 1/0 PASSED, 0 SKIPPED, 0 FAILED

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Cc: Andrey Ignatov <rdna@fb.com>
---
 tools/testing/selftests/bpf/network_helpers.c |  11 +-
 tools/testing/selftests/bpf/network_helpers.h |   1 +
 .../bpf/prog_tests/connect_force_port.c       | 107 +++++++++++++-----
 .../selftests/bpf/progs/connect_force_port4.c |  59 +++++++++-
 .../selftests/bpf/progs/connect_force_port6.c |  70 +++++++++++-
 5 files changed, 215 insertions(+), 33 deletions(-)

diff --git a/tools/testing/selftests/bpf/network_helpers.c b/tools/testing/selftests/bpf/network_helpers.c
index 999a775484c1..5caaa59a549f 100644
--- a/tools/testing/selftests/bpf/network_helpers.c
+++ b/tools/testing/selftests/bpf/network_helpers.c
@@ -5,6 +5,8 @@
 #include <string.h>
 #include <unistd.h>
 
+#include <arpa/inet.h>
+
 #include <sys/epoll.h>
 
 #include <linux/err.h>
@@ -35,7 +37,7 @@ struct ipv6_packet pkt_v6 = {
 	.tcp.doff = 5,
 };
 
-int start_server(int family, int type)
+int start_server_with_port(int family, int type, int port)
 {
 	struct sockaddr_storage addr = {};
 	socklen_t len;
@@ -45,11 +47,13 @@ int start_server(int family, int type)
 		struct sockaddr_in *sin = (void *)&addr;
 
 		sin->sin_family = AF_INET;
+		sin->sin_port = htons(port);
 		len = sizeof(*sin);
 	} else {
 		struct sockaddr_in6 *sin6 = (void *)&addr;
 
 		sin6->sin6_family = AF_INET6;
+		sin6->sin6_port = htons(port);
 		len = sizeof(*sin6);
 	}
 
@@ -76,6 +80,11 @@ int start_server(int family, int type)
 	return fd;
 }
 
+int start_server(int family, int type)
+{
+	return start_server_with_port(family, type, 0);
+}
+
 static const struct timeval timeo_sec = { .tv_sec = 3 };
 static const size_t timeo_optlen = sizeof(timeo_sec);
 
diff --git a/tools/testing/selftests/bpf/network_helpers.h b/tools/testing/selftests/bpf/network_helpers.h
index 86914e6e7b53..186fec1cfec0 100644
--- a/tools/testing/selftests/bpf/network_helpers.h
+++ b/tools/testing/selftests/bpf/network_helpers.h
@@ -34,6 +34,7 @@ struct ipv6_packet {
 extern struct ipv6_packet pkt_v6;
 
 int start_server(int family, int type);
+int start_server_with_port(int family, int type, int port);
 int connect_to_fd(int family, int type, int server_fd);
 int connect_fd_to_fd(int client_fd, int server_fd);
 int connect_wait(int client_fd);
diff --git a/tools/testing/selftests/bpf/prog_tests/connect_force_port.c b/tools/testing/selftests/bpf/prog_tests/connect_force_port.c
index 47fbb20cb6a6..7a0479255db4 100644
--- a/tools/testing/selftests/bpf/prog_tests/connect_force_port.c
+++ b/tools/testing/selftests/bpf/prog_tests/connect_force_port.c
@@ -4,7 +4,8 @@
 #include "cgroup_helpers.h"
 #include "network_helpers.h"
 
-static int verify_port(int family, int fd, int expected)
+static int verify_ports(int family, int fd,
+			int expected_local, int expected_peer)
 {
 	struct sockaddr_storage addr;
 	socklen_t len = sizeof(addr);
@@ -20,9 +21,25 @@ static int verify_port(int family, int fd, int expected)
 	else
 		port = ((struct sockaddr_in6 *)&addr)->sin6_port;
 
-	if (ntohs(port) != expected) {
-		log_err("Unexpected port %d, expected %d", ntohs(port),
-			expected);
+	if (ntohs(port) != expected_local) {
+		log_err("Unexpected local port %d, expected %d", ntohs(port),
+			expected_local);
+		return -1;
+	}
+
+	if (getpeername(fd, (struct sockaddr *)&addr, &len)) {
+		log_err("Failed to get peer addr");
+		return -1;
+	}
+
+	if (family == AF_INET)
+		port = ((struct sockaddr_in *)&addr)->sin_port;
+	else
+		port = ((struct sockaddr_in6 *)&addr)->sin6_port;
+
+	if (ntohs(port) != expected_peer) {
+		log_err("Unexpected peer port %d, expected %d", ntohs(port),
+			expected_peer);
 		return -1;
 	}
 
@@ -31,33 +48,67 @@ static int verify_port(int family, int fd, int expected)
 
 static int run_test(int cgroup_fd, int server_fd, int family, int type)
 {
+	bool v4 = family == AF_INET;
+	int expected_local_port = v4 ? 22222 : 22223;
+	int expected_peer_port = 60000;
 	struct bpf_prog_load_attr attr = {
-		.prog_type = BPF_PROG_TYPE_CGROUP_SOCK_ADDR,
+		.file = v4 ? "./connect_force_port4.o" :
+			     "./connect_force_port6.o",
 	};
+	struct bpf_program *prog;
 	struct bpf_object *obj;
-	int expected_port;
-	int prog_fd;
-	int err;
-	int fd;
-
-	if (family == AF_INET) {
-		attr.file = "./connect_force_port4.o";
-		attr.expected_attach_type = BPF_CGROUP_INET4_CONNECT;
-		expected_port = 22222;
-	} else {
-		attr.file = "./connect_force_port6.o";
-		attr.expected_attach_type = BPF_CGROUP_INET6_CONNECT;
-		expected_port = 22223;
-	}
+	int xlate_fd, fd, err;
+	__u32 duration = 0;
 
-	err = bpf_prog_load_xattr(&attr, &obj, &prog_fd);
+	err = bpf_prog_load_xattr(&attr, &obj, &xlate_fd);
 	if (err) {
 		log_err("Failed to load BPF object");
 		return -1;
 	}
 
-	err = bpf_prog_attach(prog_fd, cgroup_fd, attr.expected_attach_type,
-			      0);
+	prog = bpf_object__find_program_by_title(obj, v4 ?
+						 "cgroup/connect4" :
+						 "cgroup/connect6");
+	if (CHECK(!prog, "find_prog", "connect prog not found\n")) {
+		err = -EIO;
+		goto close_bpf_object;
+	}
+
+	err = bpf_prog_attach(bpf_program__fd(prog), cgroup_fd, v4 ?
+			      BPF_CGROUP_INET4_CONNECT :
+			      BPF_CGROUP_INET6_CONNECT, 0);
+	if (err) {
+		log_err("Failed to attach BPF program");
+		goto close_bpf_object;
+	}
+
+	prog = bpf_object__find_program_by_title(obj, v4 ?
+						 "cgroup/getpeername4" :
+						 "cgroup/getpeername6");
+	if (CHECK(!prog, "find_prog", "getpeername prog not found\n")) {
+		err = -EIO;
+		goto close_bpf_object;
+	}
+
+	err = bpf_prog_attach(bpf_program__fd(prog), cgroup_fd, v4 ?
+			      BPF_CGROUP_INET4_GETPEERNAME :
+			      BPF_CGROUP_INET6_GETPEERNAME, 0);
+	if (err) {
+		log_err("Failed to attach BPF program");
+		goto close_bpf_object;
+	}
+
+	prog = bpf_object__find_program_by_title(obj, v4 ?
+						 "cgroup/getsockname4" :
+						 "cgroup/getsockname6");
+	if (CHECK(!prog, "find_prog", "getsockname prog not found\n")) {
+		err = -EIO;
+		goto close_bpf_object;
+	}
+
+	err = bpf_prog_attach(bpf_program__fd(prog), cgroup_fd, v4 ?
+			      BPF_CGROUP_INET4_GETSOCKNAME :
+			      BPF_CGROUP_INET6_GETSOCKNAME, 0);
 	if (err) {
 		log_err("Failed to attach BPF program");
 		goto close_bpf_object;
@@ -69,8 +120,8 @@ static int run_test(int cgroup_fd, int server_fd, int family, int type)
 		goto close_bpf_object;
 	}
 
-	err = verify_port(family, fd, expected_port);
-
+	err = verify_ports(family, fd, expected_local_port,
+			   expected_peer_port);
 	close(fd);
 
 close_bpf_object:
@@ -86,25 +137,25 @@ void test_connect_force_port(void)
 	if (CHECK_FAIL(cgroup_fd < 0))
 		return;
 
-	server_fd = start_server(AF_INET, SOCK_STREAM);
+	server_fd = start_server_with_port(AF_INET, SOCK_STREAM, 60123);
 	if (CHECK_FAIL(server_fd < 0))
 		goto close_cgroup_fd;
 	CHECK_FAIL(run_test(cgroup_fd, server_fd, AF_INET, SOCK_STREAM));
 	close(server_fd);
 
-	server_fd = start_server(AF_INET6, SOCK_STREAM);
+	server_fd = start_server_with_port(AF_INET6, SOCK_STREAM, 60124);
 	if (CHECK_FAIL(server_fd < 0))
 		goto close_cgroup_fd;
 	CHECK_FAIL(run_test(cgroup_fd, server_fd, AF_INET6, SOCK_STREAM));
 	close(server_fd);
 
-	server_fd = start_server(AF_INET, SOCK_DGRAM);
+	server_fd = start_server_with_port(AF_INET, SOCK_DGRAM, 60123);
 	if (CHECK_FAIL(server_fd < 0))
 		goto close_cgroup_fd;
 	CHECK_FAIL(run_test(cgroup_fd, server_fd, AF_INET, SOCK_DGRAM));
 	close(server_fd);
 
-	server_fd = start_server(AF_INET6, SOCK_DGRAM);
+	server_fd = start_server_with_port(AF_INET6, SOCK_DGRAM, 60124);
 	if (CHECK_FAIL(server_fd < 0))
 		goto close_cgroup_fd;
 	CHECK_FAIL(run_test(cgroup_fd, server_fd, AF_INET6, SOCK_DGRAM));
diff --git a/tools/testing/selftests/bpf/progs/connect_force_port4.c b/tools/testing/selftests/bpf/progs/connect_force_port4.c
index 1b8eb34b2db0..7396308677a3 100644
--- a/tools/testing/selftests/bpf/progs/connect_force_port4.c
+++ b/tools/testing/selftests/bpf/progs/connect_force_port4.c
@@ -1,5 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <string.h>
+#include <stdbool.h>
 
 #include <linux/bpf.h>
 #include <linux/in.h>
@@ -12,17 +13,71 @@
 char _license[] SEC("license") = "GPL";
 int _version SEC("version") = 1;
 
+struct svc_addr {
+	__be32 addr;
+	__be16 port;
+};
+
+struct {
+	__uint(type, BPF_MAP_TYPE_SK_STORAGE);
+	__uint(map_flags, BPF_F_NO_PREALLOC);
+	__type(key, int);
+	__type(value, struct svc_addr);
+} service_mapping SEC(".maps");
+
 SEC("cgroup/connect4")
-int _connect4(struct bpf_sock_addr *ctx)
+int connect4(struct bpf_sock_addr *ctx)
 {
 	struct sockaddr_in sa = {};
+	struct svc_addr *orig;
 
+	/* Force local address to 127.0.0.1:22222. */
 	sa.sin_family = AF_INET;
 	sa.sin_port = bpf_htons(22222);
-	sa.sin_addr.s_addr = bpf_htonl(0x7f000001); /* 127.0.0.1 */
+	sa.sin_addr.s_addr = bpf_htonl(0x7f000001);
 
 	if (bpf_bind(ctx, (struct sockaddr *)&sa, sizeof(sa)) != 0)
 		return 0;
 
+	/* Rewire service 1.2.3.4:60000 to backend 127.0.0.1:60123. */
+	if (ctx->user_port == bpf_htons(60000)) {
+		orig = bpf_sk_storage_get(&service_mapping, ctx->sk, 0,
+					  BPF_SK_STORAGE_GET_F_CREATE);
+		if (!orig)
+			return 0;
+
+		orig->addr = ctx->user_ip4;
+		orig->port = ctx->user_port;
+
+		ctx->user_ip4 = bpf_htonl(0x7f000001);
+		ctx->user_port = bpf_htons(60123);
+	}
+	return 1;
+}
+
+SEC("cgroup/getsockname4")
+int getsockname4(struct bpf_sock_addr *ctx)
+{
+	/* Expose local server as 1.2.3.4:60000 to client. */
+	if (ctx->user_port == bpf_htons(60123)) {
+		ctx->user_ip4 = bpf_htonl(0x01020304);
+		ctx->user_port = bpf_htons(60000);
+	}
+	return 1;
+}
+
+SEC("cgroup/getpeername4")
+int getpeername4(struct bpf_sock_addr *ctx)
+{
+	struct svc_addr *orig;
+
+	/* Expose service 1.2.3.4:60000 as peer instead of backend. */
+	if (ctx->user_port == bpf_htons(60123)) {
+		orig = bpf_sk_storage_get(&service_mapping, ctx->sk, 0, 0);
+		if (orig) {
+			ctx->user_ip4 = orig->addr;
+			ctx->user_port = orig->port;
+		}
+	}
 	return 1;
 }
diff --git a/tools/testing/selftests/bpf/progs/connect_force_port6.c b/tools/testing/selftests/bpf/progs/connect_force_port6.c
index ae6f7d750b4c..c1a2b555e9ad 100644
--- a/tools/testing/selftests/bpf/progs/connect_force_port6.c
+++ b/tools/testing/selftests/bpf/progs/connect_force_port6.c
@@ -12,17 +12,83 @@
 char _license[] SEC("license") = "GPL";
 int _version SEC("version") = 1;
 
+struct svc_addr {
+	__be32 addr[4];
+	__be16 port;
+};
+
+struct {
+	__uint(type, BPF_MAP_TYPE_SK_STORAGE);
+	__uint(map_flags, BPF_F_NO_PREALLOC);
+	__type(key, int);
+	__type(value, struct svc_addr);
+} service_mapping SEC(".maps");
+
 SEC("cgroup/connect6")
-int _connect6(struct bpf_sock_addr *ctx)
+int connect6(struct bpf_sock_addr *ctx)
 {
 	struct sockaddr_in6 sa = {};
+	struct svc_addr *orig;
 
+	/* Force local address to [::1]:22223. */
 	sa.sin6_family = AF_INET6;
 	sa.sin6_port = bpf_htons(22223);
-	sa.sin6_addr.s6_addr32[3] = bpf_htonl(1); /* ::1 */
+	sa.sin6_addr.s6_addr32[3] = bpf_htonl(1);
 
 	if (bpf_bind(ctx, (struct sockaddr *)&sa, sizeof(sa)) != 0)
 		return 0;
 
+	/* Rewire service [fc00::1]:60000 to backend [::1]:60124. */
+	if (ctx->user_port == bpf_htons(60000)) {
+		orig = bpf_sk_storage_get(&service_mapping, ctx->sk, 0,
+					  BPF_SK_STORAGE_GET_F_CREATE);
+		if (!orig)
+			return 0;
+
+		orig->addr[0] = ctx->user_ip6[0];
+		orig->addr[1] = ctx->user_ip6[1];
+		orig->addr[2] = ctx->user_ip6[2];
+		orig->addr[3] = ctx->user_ip6[3];
+		orig->port = ctx->user_port;
+
+		ctx->user_ip6[0] = 0;
+		ctx->user_ip6[1] = 0;
+		ctx->user_ip6[2] = 0;
+		ctx->user_ip6[3] = bpf_htonl(1);
+		ctx->user_port = bpf_htons(60124);
+	}
+	return 1;
+}
+
+SEC("cgroup/getsockname6")
+int getsockname6(struct bpf_sock_addr *ctx)
+{
+	/* Expose local server as [fc00::1]:60000 to client. */
+	if (ctx->user_port == bpf_htons(60124)) {
+		ctx->user_ip6[0] = bpf_htonl(0xfc000000);
+		ctx->user_ip6[1] = 0;
+		ctx->user_ip6[2] = 0;
+		ctx->user_ip6[3] = bpf_htonl(1);
+		ctx->user_port = bpf_htons(60000);
+	}
+	return 1;
+}
+
+SEC("cgroup/getpeername6")
+int getpeername6(struct bpf_sock_addr *ctx)
+{
+	struct svc_addr *orig;
+
+	/* Expose service [fc00::1]:60000 as peer instead of backend. */
+	if (ctx->user_port == bpf_htons(60124)) {
+		orig = bpf_sk_storage_get(&service_mapping, ctx->sk, 0, 0);
+		if (orig) {
+			ctx->user_ip6[0] = orig->addr[0];
+			ctx->user_ip6[1] = orig->addr[1];
+			ctx->user_ip6[2] = orig->addr[2];
+			ctx->user_ip6[3] = orig->addr[3];
+			ctx->user_port = orig->port;
+		}
+	}
 	return 1;
 }
-- 
2.21.0

