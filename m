Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7837F405E2C
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 22:44:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345763AbhIIUpE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 16:45:04 -0400
Received: from www62.your-server.de ([213.133.104.62]:59744 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345513AbhIIUpB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Sep 2021 16:45:01 -0400
Received: from 65.47.5.85.dynamic.wline.res.cust.swisscom.ch ([85.5.47.65] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1mOQtd-00010x-BS; Thu, 09 Sep 2021 22:43:45 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, tj@kernel.org, davem@davemloft.net,
        m@lambda.lt, alexei.starovoitov@gmail.com, andrii@kernel.org,
        sdf@google.com, Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH bpf v2 3/3] bpf, selftests: Add test case for mixed cgroup v1/v2
Date:   Thu,  9 Sep 2021 22:43:42 +0200
Message-Id: <5a6e78baee7515884b93a90c5d03db601bc9063a.1631219956.git.daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <f36377d0c40cce0cdeaff50031c268bc640d94f0.1631219956.git.daniel@iogearbox.net>
References: <f36377d0c40cce0cdeaff50031c268bc640d94f0.1631219956.git.daniel@iogearbox.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.2/26289/Thu Sep  9 10:20:35 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Minimal selftest which implements a small BPF policy program to the
connect(2) hook which rejects TCP connection requests to port 60123
with EPERM. This is being attached to a non-root cgroup v2 path. The
test asserts that this works under cgroup v2-only and under a mixed
cgroup v1/v2 environment where net_classid is set in the former case.

Before fix:

  # ./test_progs -t cgroup_v1v2
  test_cgroup_v1v2:PASS:server_fd 0 nsec
  test_cgroup_v1v2:PASS:client_fd 0 nsec
  test_cgroup_v1v2:PASS:cgroup_fd 0 nsec
  test_cgroup_v1v2:PASS:server_fd 0 nsec
  run_test:PASS:skel_open 0 nsec
  run_test:PASS:prog_attach 0 nsec
  test_cgroup_v1v2:PASS:cgroup-v2-only 0 nsec
  run_test:PASS:skel_open 0 nsec
  run_test:PASS:prog_attach 0 nsec
  run_test:PASS:join_classid 0 nsec
  (network_helpers.c:219: errno: None) Unexpected success to connect to server
  test_cgroup_v1v2:FAIL:cgroup-v1v2 unexpected error: -1 (errno 0)
  #27 cgroup_v1v2:FAIL
  Summary: 0/0 PASSED, 0 SKIPPED, 1 FAILED

After fix:

  # ./test_progs -t cgroup_v1v2
  #27 cgroup_v1v2:OK
  Summary: 1/0 PASSED, 0 SKIPPED, 0 FAILED

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
---
 tools/testing/selftests/bpf/network_helpers.c | 27 +++++--
 tools/testing/selftests/bpf/network_helpers.h |  1 +
 .../selftests/bpf/prog_tests/cgroup_v1v2.c    | 79 +++++++++++++++++++
 .../selftests/bpf/progs/connect4_dropper.c    | 26 ++++++
 4 files changed, 127 insertions(+), 6 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/cgroup_v1v2.c
 create mode 100644 tools/testing/selftests/bpf/progs/connect4_dropper.c

diff --git a/tools/testing/selftests/bpf/network_helpers.c b/tools/testing/selftests/bpf/network_helpers.c
index 7e9f6375757a..6db1af8fdee7 100644
--- a/tools/testing/selftests/bpf/network_helpers.c
+++ b/tools/testing/selftests/bpf/network_helpers.c
@@ -208,11 +208,26 @@ int fastopen_connect(int server_fd, const char *data, unsigned int data_len,
 
 static int connect_fd_to_addr(int fd,
 			      const struct sockaddr_storage *addr,
-			      socklen_t addrlen)
+			      socklen_t addrlen, const bool must_fail)
 {
-	if (connect(fd, (const struct sockaddr *)addr, addrlen)) {
-		log_err("Failed to connect to server");
-		return -1;
+	int ret;
+
+	errno = 0;
+	ret = connect(fd, (const struct sockaddr *)addr, addrlen);
+	if (must_fail) {
+		if (!ret) {
+			log_err("Unexpected success to connect to server");
+			return -1;
+		}
+		if (errno != EPERM) {
+			log_err("Unexpected error from connect to server");
+			return -1;
+		}
+	} else {
+		if (ret) {
+			log_err("Failed to connect to server");
+			return -1;
+		}
 	}
 
 	return 0;
@@ -257,7 +272,7 @@ int connect_to_fd_opts(int server_fd, const struct network_helper_opts *opts)
 		       strlen(opts->cc) + 1))
 		goto error_close;
 
-	if (connect_fd_to_addr(fd, &addr, addrlen))
+	if (connect_fd_to_addr(fd, &addr, addrlen, opts->must_fail))
 		goto error_close;
 
 	return fd;
@@ -289,7 +304,7 @@ int connect_fd_to_fd(int client_fd, int server_fd, int timeout_ms)
 		return -1;
 	}
 
-	if (connect_fd_to_addr(client_fd, &addr, len))
+	if (connect_fd_to_addr(client_fd, &addr, len, false))
 		return -1;
 
 	return 0;
diff --git a/tools/testing/selftests/bpf/network_helpers.h b/tools/testing/selftests/bpf/network_helpers.h
index da7e132657d5..d198181a5648 100644
--- a/tools/testing/selftests/bpf/network_helpers.h
+++ b/tools/testing/selftests/bpf/network_helpers.h
@@ -20,6 +20,7 @@ typedef __u16 __sum16;
 struct network_helper_opts {
 	const char *cc;
 	int timeout_ms;
+	bool must_fail;
 };
 
 /* ipv4 test vector */
diff --git a/tools/testing/selftests/bpf/prog_tests/cgroup_v1v2.c b/tools/testing/selftests/bpf/prog_tests/cgroup_v1v2.c
new file mode 100644
index 000000000000..ab3b9bc5e6d1
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/cgroup_v1v2.c
@@ -0,0 +1,79 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <test_progs.h>
+
+#include "connect4_dropper.skel.h"
+
+#include "cgroup_helpers.h"
+#include "network_helpers.h"
+
+static int run_test(int cgroup_fd, int server_fd, bool classid)
+{
+	struct network_helper_opts opts = {
+		.must_fail = true,
+	};
+	struct connect4_dropper *skel;
+	int fd, err = 0;
+
+	skel = connect4_dropper__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "skel_open"))
+		return -1;
+
+	skel->links.connect_v4_dropper =
+		bpf_program__attach_cgroup(skel->progs.connect_v4_dropper,
+					   cgroup_fd);
+	if (!ASSERT_OK_PTR(skel->links.connect_v4_dropper, "prog_attach")) {
+		err = -1;
+		goto out;
+	}
+
+	if (classid && !ASSERT_OK(join_classid(), "join_classid")) {
+		err = -1;
+		goto out;
+	}
+
+	fd = connect_to_fd_opts(server_fd, &opts);
+	if (fd < 0)
+		err = -1;
+	else
+		close(fd);
+out:
+	connect4_dropper__destroy(skel);
+	return err;
+}
+
+void test_cgroup_v1v2(void)
+{
+	struct network_helper_opts opts = {};
+	int server_fd, client_fd, cgroup_fd;
+	static const int port = 60123;
+
+	/* Step 1: Check base connectivity works without any BPF. */
+	server_fd = start_server(AF_INET, SOCK_STREAM, NULL, port, 0);
+	if (!ASSERT_GE(server_fd, 0, "server_fd"))
+		return;
+	client_fd = connect_to_fd_opts(server_fd, &opts);
+	if (!ASSERT_GE(client_fd, 0, "client_fd")) {
+		close(server_fd);
+		return;
+	}
+	close(client_fd);
+	close(server_fd);
+
+	/* Step 2: Check BPF policy prog attached to cgroups drops connectivity. */
+	cgroup_fd = test__join_cgroup("/connect_dropper");
+	if (!ASSERT_GE(cgroup_fd, 0, "cgroup_fd"))
+		return;
+	server_fd = start_server(AF_INET, SOCK_STREAM, NULL, port, 0);
+	if (!ASSERT_GE(server_fd, 0, "server_fd")) {
+		close(cgroup_fd);
+		return;
+	}
+	ASSERT_OK(run_test(cgroup_fd, server_fd, false), "cgroup-v2-only");
+	setup_classid_environment();
+	set_classid(42);
+	ASSERT_OK(run_test(cgroup_fd, server_fd, true), "cgroup-v1v2");
+	cleanup_classid_environment();
+	close(server_fd);
+	close(cgroup_fd);
+}
diff --git a/tools/testing/selftests/bpf/progs/connect4_dropper.c b/tools/testing/selftests/bpf/progs/connect4_dropper.c
new file mode 100644
index 000000000000..b565d997810a
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/connect4_dropper.c
@@ -0,0 +1,26 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <string.h>
+
+#include <linux/stddef.h>
+#include <linux/bpf.h>
+
+#include <sys/socket.h>
+
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_endian.h>
+
+#define VERDICT_REJECT	0
+#define VERDICT_PROCEED	1
+
+SEC("cgroup/connect4")
+int connect_v4_dropper(struct bpf_sock_addr *ctx)
+{
+	if (ctx->type != SOCK_STREAM)
+		return VERDICT_PROCEED;
+	if (ctx->user_port == bpf_htons(60123))
+		return VERDICT_REJECT;
+	return VERDICT_PROCEED;
+}
+
+char _license[] SEC("license") = "GPL";
-- 
2.21.0

