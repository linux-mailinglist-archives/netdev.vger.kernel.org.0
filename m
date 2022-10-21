Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12C3C607A92
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 17:27:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230365AbiJUP13 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 11:27:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230369AbiJUP1W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 11:27:22 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D06425ED2A;
        Fri, 21 Oct 2022 08:27:15 -0700 (PDT)
Received: from fraeml744-chm.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Mv7ZY6Ykqz688y7;
        Fri, 21 Oct 2022 23:25:25 +0800 (CST)
Received: from lhrpeml500004.china.huawei.com (7.191.163.9) by
 fraeml744-chm.china.huawei.com (10.206.15.225) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 21 Oct 2022 17:27:13 +0200
Received: from mscphis00759.huawei.com (10.123.66.134) by
 lhrpeml500004.china.huawei.com (7.191.163.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 21 Oct 2022 16:27:12 +0100
From:   Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
To:     <mic@digikod.net>
CC:     <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
        <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <artem.kuzin@huawei.com>
Subject: [PATCH v8 10/12] selftests/landlock: Add 10 new test suites dedicated to network
Date:   Fri, 21 Oct 2022 23:26:42 +0800
Message-ID: <20221021152644.155136-11-konstantin.meskhidze@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221021152644.155136-1-konstantin.meskhidze@huawei.com>
References: <20221021152644.155136-1-konstantin.meskhidze@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.123.66.134]
X-ClientProxiedBy: mscpeml100002.china.huawei.com (7.188.26.75) To
 lhrpeml500004.china.huawei.com (7.191.163.9)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These test suites try to check edge cases for TCP sockets
bind() and connect() actions.

socket:
* bind_no_restrictions: Tests with non-landlocked ipv4 and ipv6 sockets.
* bind_with_restrictions: Tests with mixed landlock rules for ipv4 and
ipv6 sockets.
* connect_no_restrictions: Tests with non-landlocked ipv4 and ipv6 sockets.
* connect_with_restrictions: Tests with mixed landlock rules for ipv4 and
ipv6 sockets.
* connect_afunspec_no_restrictions: Tests with no landlock restrictions
allowing to disconnect already connected socket with AF_UNSPEC socket
family.
* connect_afunspec_with_restrictions: Tests with landlocked process
refusing to disconnect already connected socket.
* ruleset_overlap: Tests with overlapping rules for one port.
* ruleset_expanding: Tests with expanding rulesets in which rules are
gradually added one by one, restricting sockets' connections.
* inval: Tests with invalid user space supplied data:
    - out of range ruleset attribute;
    - unhandled allowed access;
    - zero port value;
    - zero access value;
    - legitimate access values;

layout1:
* with_net: Tests with network bind() socket action within
filesystem directory access test.

Test coverage for security/landlock is 94.3% of 920 lines according
to gcc/gcov-11.

Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
---

Changes since v7:
* Squashes all selftest commits.
* Adds fs test with network bind() socket action.
* Minor fixes.

---
 security/landlock/ruleset.h                 |   2 -
 tools/testing/selftests/landlock/config     |   4 +
 tools/testing/selftests/landlock/fs_test.c  |  65 ++
 tools/testing/selftests/landlock/net_test.c | 823 ++++++++++++++++++++
 4 files changed, 892 insertions(+), 2 deletions(-)
 create mode 100644 tools/testing/selftests/landlock/net_test.c

diff --git a/security/landlock/ruleset.h b/security/landlock/ruleset.h
index f272d2cd518c..ee1a02a404ce 100644
--- a/security/landlock/ruleset.h
+++ b/security/landlock/ruleset.h
@@ -264,7 +264,6 @@ landlock_add_fs_access_mask(struct landlock_ruleset *const ruleset,

 	/* Should already be checked in sys_landlock_create_ruleset(). */
 	WARN_ON_ONCE(fs_access_mask != fs_mask);
-	// TODO: Add tests to check "|=" and not "="
 	ruleset->access_masks[layer_level] |=
 		(fs_mask << LANDLOCK_SHIFT_ACCESS_FS);
 }
@@ -278,7 +277,6 @@ landlock_add_net_access_mask(struct landlock_ruleset *const ruleset,

 	/* Should already be checked in sys_landlock_create_ruleset(). */
 	WARN_ON_ONCE(net_access_mask != net_mask);
-	// TODO: Add tests to check "|=" and not "="
 	ruleset->access_masks[layer_level] |=
 		(net_mask << LANDLOCK_SHIFT_ACCESS_NET);
 }
diff --git a/tools/testing/selftests/landlock/config b/tools/testing/selftests/landlock/config
index 0f0a65287bac..71f7e9a8a64c 100644
--- a/tools/testing/selftests/landlock/config
+++ b/tools/testing/selftests/landlock/config
@@ -1,3 +1,7 @@
+CONFIG_INET=y
+CONFIG_IPV6=y
+CONFIG_NET=y
+CONFIG_NET_NS=y
 CONFIG_OVERLAY_FS=y
 CONFIG_SECURITY_LANDLOCK=y
 CONFIG_SECURITY_PATH=y
diff --git a/tools/testing/selftests/landlock/fs_test.c b/tools/testing/selftests/landlock/fs_test.c
index 20c1ac8485f1..5c52da1a5a69 100644
--- a/tools/testing/selftests/landlock/fs_test.c
+++ b/tools/testing/selftests/landlock/fs_test.c
@@ -8,14 +8,17 @@
  */

 #define _GNU_SOURCE
+#include <arpa/inet.h>
 #include <fcntl.h>
 #include <linux/landlock.h>
+#include <netinet/in.h>
 #include <sched.h>
 #include <string.h>
 #include <sys/capability.h>
 #include <sys/mount.h>
 #include <sys/prctl.h>
 #include <sys/sendfile.h>
+#include <sys/socket.h>
 #include <sys/stat.h>
 #include <sys/sysmacros.h>
 #include <unistd.h>
@@ -4366,4 +4369,66 @@ TEST_F_FORK(layout2_overlay, same_content_different_file)
 	}
 }

+#define IP_ADDRESS "127.0.0.1"
+
+TEST_F_FORK(layout1, with_net)
+{
+	int sockfd;
+	int sock_port = 15000;
+	struct sockaddr_in addr4;
+
+	addr4.sin_family = AF_INET;
+	addr4.sin_port = htons(sock_port);
+	addr4.sin_addr.s_addr = inet_addr(IP_ADDRESS);
+	memset(&addr4.sin_zero, '\0', 8);
+
+	const struct rule rules[] = {
+		{
+			.path = dir_s1d2,
+			.access = ACCESS_RO,
+		},
+		{},
+	};
+
+	struct landlock_ruleset_attr ruleset_attr_net = {
+		.handled_access_net = LANDLOCK_ACCESS_NET_BIND_TCP |
+				      LANDLOCK_ACCESS_NET_CONNECT_TCP,
+	};
+	struct landlock_net_service_attr net_service = {
+		.allowed_access = LANDLOCK_ACCESS_NET_BIND_TCP,
+
+		.port = sock_port,
+	};
+
+	/* Creates ruleset for network access. */
+	const int ruleset_fd_net = landlock_create_ruleset(
+		&ruleset_attr_net, sizeof(ruleset_attr_net), 0);
+	ASSERT_LE(0, ruleset_fd_net);
+
+	/* Adds a network rule. */
+	ASSERT_EQ(0,
+		  landlock_add_rule(ruleset_fd_net, LANDLOCK_RULE_NET_SERVICE,
+				    &net_service, 0));
+
+	enforce_ruleset(_metadata, ruleset_fd_net);
+	ASSERT_EQ(0, close(ruleset_fd_net));
+
+	const int ruleset_fd = create_ruleset(_metadata, ACCESS_RW, rules);
+	ASSERT_LE(0, ruleset_fd);
+	enforce_ruleset(_metadata, ruleset_fd);
+	ASSERT_EQ(0, close(ruleset_fd));
+
+	/* Tests on a directory with the network rule loaded. */
+	ASSERT_EQ(0, test_open(dir_s1d2, O_RDONLY));
+	ASSERT_EQ(0, test_open(file1_s1d2, O_RDONLY));
+
+	sockfd = socket(AF_INET, SOCK_STREAM | SOCK_CLOEXEC, 0);
+	ASSERT_LE(0, sockfd);
+	/* Binds a socket to port 15000. */
+	ASSERT_EQ(0, bind(sockfd, &addr4, sizeof(addr4)));
+
+	/* Closes bounded socket. */
+	ASSERT_EQ(0, close(sockfd));
+}
+
 TEST_HARNESS_MAIN
diff --git a/tools/testing/selftests/landlock/net_test.c b/tools/testing/selftests/landlock/net_test.c
new file mode 100644
index 000000000000..d1548bd7ab60
--- /dev/null
+++ b/tools/testing/selftests/landlock/net_test.c
@@ -0,0 +1,823 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Landlock tests - Network
+ *
+ * Copyright (C) 2022 Huawei Tech. Co., Ltd.
+ */
+
+#define _GNU_SOURCE
+#include <arpa/inet.h>
+#include <errno.h>
+#include <fcntl.h>
+#include <linux/landlock.h>
+#include <netinet/in.h>
+#include <sched.h>
+#include <string.h>
+#include <sys/prctl.h>
+#include <sys/socket.h>
+#include <sys/types.h>
+
+#include "common.h"
+
+#define MAX_SOCKET_NUM 10
+
+#define SOCK_PORT_START 3470
+#define SOCK_PORT_ADD 10
+
+#define IP_ADDRESS "127.0.0.1"
+
+/* Number pending connections queue to be hold. */
+#define BACKLOG 10
+
+const struct sockaddr addr_unspec = { .sa_family = AF_UNSPEC };
+
+/* Invalid attribute, out of landlock network access range. */
+#define LANDLOCK_INVAL_ATTR 7
+
+FIXTURE(socket)
+{
+	uint port[MAX_SOCKET_NUM];
+	struct sockaddr_in addr4[MAX_SOCKET_NUM];
+	struct sockaddr_in6 addr6[MAX_SOCKET_NUM];
+};
+
+/* struct _fixture_variant_socket */
+FIXTURE_VARIANT(socket)
+{
+	const bool is_ipv4;
+};
+
+/* clang-format off */
+FIXTURE_VARIANT_ADD(socket, ipv4) {
+	/* clang-format on */
+	.is_ipv4 = true,
+};
+
+/* clang-format off */
+FIXTURE_VARIANT_ADD(socket, ipv6) {
+	/* clang-format on */
+	.is_ipv4 = false,
+};
+
+static int
+create_socket_variant(const struct _fixture_variant_socket *const variant,
+		      const int type)
+{
+	if (variant->is_ipv4)
+		return socket(AF_INET, type | SOCK_CLOEXEC, 0);
+	else
+		return socket(AF_INET6, type | SOCK_CLOEXEC, 0);
+}
+
+static int bind_variant(const struct _fixture_variant_socket *const variant,
+			const int sockfd,
+			const struct _test_data_socket *const self,
+			const size_t index)
+{
+	if (variant->is_ipv4)
+		return bind(sockfd, &self->addr4[index],
+			    sizeof(self->addr4[index]));
+	else
+		return bind(sockfd, &self->addr6[index],
+			    sizeof(self->addr6[index]));
+}
+
+static int connect_variant(const struct _fixture_variant_socket *const variant,
+			   const int sockfd,
+			   const struct _test_data_socket *const self,
+			   const size_t index)
+{
+	if (variant->is_ipv4)
+		return connect(sockfd, &self->addr4[index],
+			       sizeof(self->addr4[index]));
+	else
+		return connect(sockfd, &self->addr6[index],
+			       sizeof(self->addr6[index]));
+}
+
+FIXTURE_SETUP(socket)
+{
+	int i;
+
+	/* Creates IPv4 socket addresses. */
+	for (i = 0; i < MAX_SOCKET_NUM; i++) {
+		self->port[i] = SOCK_PORT_START + SOCK_PORT_ADD * i;
+		self->addr4[i].sin_family = AF_INET;
+		self->addr4[i].sin_port = htons(self->port[i]);
+		self->addr4[i].sin_addr.s_addr = inet_addr(IP_ADDRESS);
+		memset(&(self->addr4[i].sin_zero), '\0', 8);
+	}
+
+	/* Creates IPv6 socket addresses. */
+	for (i = 0; i < MAX_SOCKET_NUM; i++) {
+		self->port[i] = SOCK_PORT_START + SOCK_PORT_ADD * i;
+		self->addr6[i].sin6_family = AF_INET6;
+		self->addr6[i].sin6_port = htons(self->port[i]);
+		inet_pton(AF_INET6, IP_ADDRESS, &(self->addr6[i].sin6_addr));
+	}
+
+	set_cap(_metadata, CAP_SYS_ADMIN);
+	ASSERT_EQ(0, unshare(CLONE_NEWNET));
+	ASSERT_EQ(0, system("ip link set dev lo up"));
+	clear_cap(_metadata, CAP_SYS_ADMIN);
+}
+
+FIXTURE_TEARDOWN(socket)
+{
+}
+
+TEST_F_FORK(socket, bind_no_restrictions)
+{
+	int sockfd;
+
+	sockfd = create_socket_variant(variant, SOCK_STREAM);
+	ASSERT_LE(0, sockfd);
+
+	/* Binds a socket to port[0]. */
+	ASSERT_EQ(0, bind_variant(variant, sockfd, self, 0));
+
+	ASSERT_EQ(0, close(sockfd));
+}
+
+TEST_F_FORK(socket, bind_with_restrictions)
+{
+	int sockfd;
+
+	struct landlock_ruleset_attr ruleset_attr = {
+		.handled_access_net = LANDLOCK_ACCESS_NET_BIND_TCP |
+				      LANDLOCK_ACCESS_NET_CONNECT_TCP,
+	};
+	struct landlock_net_service_attr net_service_1 = {
+		.allowed_access = LANDLOCK_ACCESS_NET_BIND_TCP |
+				  LANDLOCK_ACCESS_NET_CONNECT_TCP,
+		.port = self->port[0],
+	};
+	struct landlock_net_service_attr net_service_2 = {
+		.allowed_access = LANDLOCK_ACCESS_NET_CONNECT_TCP,
+		.port = self->port[1],
+	};
+	struct landlock_net_service_attr net_service_3 = {
+		.allowed_access = 0,
+		.port = self->port[2],
+	};
+
+	const int ruleset_fd =
+		landlock_create_ruleset(&ruleset_attr, sizeof(ruleset_attr), 0);
+	ASSERT_LE(0, ruleset_fd);
+
+	/* Allows connect and bind operations to the port[0] socket. */
+	ASSERT_EQ(0, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_SERVICE,
+				       &net_service_1, 0));
+	/* Allows connect and deny bind operations to the port[1] socket. */
+	ASSERT_EQ(0, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_SERVICE,
+				       &net_service_2, 0));
+	/*
+	 * Empty allowed_access (i.e. deny rules) are ignored in network actions
+	 * for port[2] socket.
+	 */
+	ASSERT_EQ(-1, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_SERVICE,
+					&net_service_3, 0));
+	ASSERT_EQ(ENOMSG, errno);
+
+	/* Enforces the ruleset. */
+	enforce_ruleset(_metadata, ruleset_fd);
+
+	sockfd = create_socket_variant(variant, SOCK_STREAM);
+	ASSERT_LE(0, sockfd);
+	/* Binds a socket to port[0]. */
+	ASSERT_EQ(0, bind_variant(variant, sockfd, self, 0));
+
+	/* Closes bounded socket. */
+	ASSERT_EQ(0, close(sockfd));
+
+	sockfd = create_socket_variant(variant, SOCK_STREAM);
+	ASSERT_LE(0, sockfd);
+	/* Binds a socket to port[1]. */
+	ASSERT_EQ(-1, bind_variant(variant, sockfd, self, 1));
+	ASSERT_EQ(EACCES, errno);
+
+	sockfd = create_socket_variant(variant, SOCK_STREAM);
+	ASSERT_LE(0, sockfd);
+	/* Binds a socket to port[2]. */
+	ASSERT_EQ(-1, bind_variant(variant, sockfd, self, 2));
+	ASSERT_EQ(EACCES, errno);
+}
+
+TEST_F_FORK(socket, connect_no_restrictions)
+{
+	int sockfd, new_fd;
+	pid_t child;
+	int status;
+
+	/* Creates a server socket. */
+	sockfd = create_socket_variant(variant, SOCK_STREAM);
+	ASSERT_LE(0, sockfd);
+
+	/* Binds a socket to port[0]. */
+	ASSERT_EQ(0, bind_variant(variant, sockfd, self, 0));
+
+	/* Makes listening socket. */
+	ASSERT_EQ(0, listen(sockfd, BACKLOG));
+
+	child = fork();
+	ASSERT_LE(0, child);
+	if (child == 0) {
+		int child_sockfd;
+
+		/* Closes listening socket for the child. */
+		ASSERT_EQ(0, close(sockfd));
+		/* Creates a stream client socket. */
+		child_sockfd = create_socket_variant(variant, SOCK_STREAM);
+		ASSERT_LE(0, child_sockfd);
+
+		/* Makes connection to the listening socket with port[0]. */
+		ASSERT_EQ(0, connect_variant(variant, child_sockfd, self, 0));
+		_exit(_metadata->passed ? EXIT_SUCCESS : EXIT_FAILURE);
+		return;
+	}
+	/* Accepts connection from the child. */
+	new_fd = accept(sockfd, NULL, 0);
+	ASSERT_LE(0, new_fd);
+
+	/* Closes connection. */
+	ASSERT_EQ(0, close(new_fd));
+
+	/* Closes listening socket for the parent. */
+	ASSERT_EQ(0, close(sockfd));
+
+	ASSERT_EQ(child, waitpid(child, &status, 0));
+	ASSERT_EQ(1, WIFEXITED(status));
+	ASSERT_EQ(EXIT_SUCCESS, WEXITSTATUS(status));
+}
+
+TEST_F_FORK(socket, connect_with_restrictions)
+{
+	int new_fd;
+	int sockfd_1, sockfd_2;
+	pid_t child_1, child_2;
+	int status;
+
+	struct landlock_ruleset_attr ruleset_attr = {
+		.handled_access_net = LANDLOCK_ACCESS_NET_BIND_TCP |
+				      LANDLOCK_ACCESS_NET_CONNECT_TCP,
+	};
+	struct landlock_net_service_attr net_service_1 = {
+		.allowed_access = LANDLOCK_ACCESS_NET_BIND_TCP |
+				  LANDLOCK_ACCESS_NET_CONNECT_TCP,
+		.port = self->port[0],
+	};
+	struct landlock_net_service_attr net_service_2 = {
+		.allowed_access = LANDLOCK_ACCESS_NET_BIND_TCP,
+		.port = self->port[1],
+	};
+
+	const int ruleset_fd =
+		landlock_create_ruleset(&ruleset_attr, sizeof(ruleset_attr), 0);
+	ASSERT_LE(0, ruleset_fd);
+
+	/* Allows connect and bind operations to the port[0] socket. */
+	ASSERT_EQ(0, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_SERVICE,
+				       &net_service_1, 0));
+	/* Allows connect and deny bind operations to the port[1] socket. */
+	ASSERT_EQ(0, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_SERVICE,
+				       &net_service_2, 0));
+
+	/* Enforces the ruleset. */
+	enforce_ruleset(_metadata, ruleset_fd);
+
+	/* Creates a server socket 1. */
+	sockfd_1 = create_socket_variant(variant, SOCK_STREAM);
+	ASSERT_LE(0, sockfd_1);
+
+	/* Binds the socket 1 to address with port[0]. */
+	ASSERT_EQ(0, bind_variant(variant, sockfd_1, self, 0));
+
+	/* Makes listening socket 1. */
+	ASSERT_EQ(0, listen(sockfd_1, BACKLOG));
+
+	child_1 = fork();
+	ASSERT_LE(0, child_1);
+	if (child_1 == 0) {
+		int child_sockfd;
+
+		/* Closes listening socket for the child. */
+		ASSERT_EQ(0, close(sockfd_1));
+		/* Creates a stream client socket. */
+		child_sockfd = create_socket_variant(variant, SOCK_STREAM);
+		ASSERT_LE(0, child_sockfd);
+
+		/* Makes connection to the listening socket with port[0]. */
+		ASSERT_EQ(0, connect_variant(variant, child_sockfd, self, 0));
+		_exit(_metadata->passed ? EXIT_SUCCESS : EXIT_FAILURE);
+		return;
+	}
+	/* Accepts connection from the child 1. */
+	new_fd = accept(sockfd_1, NULL, 0);
+	ASSERT_LE(0, new_fd);
+
+	/* Closes connection. */
+	ASSERT_EQ(0, close(new_fd));
+
+	/* Closes listening socket 1 for the parent. */
+	ASSERT_EQ(0, close(sockfd_1));
+
+	ASSERT_EQ(child_1, waitpid(child_1, &status, 0));
+	ASSERT_EQ(1, WIFEXITED(status));
+	ASSERT_EQ(EXIT_SUCCESS, WEXITSTATUS(status));
+
+	/* Creates a server socket 2. */
+	sockfd_2 = create_socket_variant(variant, SOCK_STREAM);
+	ASSERT_LE(0, sockfd_2);
+
+	/* Binds the socket 2 to address with port[1]. */
+	ASSERT_EQ(0, bind_variant(variant, sockfd_2, self, 1));
+
+	/* Makes listening socket 2. */
+	ASSERT_EQ(0, listen(sockfd_2, BACKLOG));
+
+	child_2 = fork();
+	ASSERT_LE(0, child_2);
+	if (child_2 == 0) {
+		int child_sockfd;
+
+		/* Closes listening socket for the child. */
+		ASSERT_EQ(0, close(sockfd_2));
+		/* Creates a stream client socket. */
+		child_sockfd = create_socket_variant(variant, SOCK_STREAM);
+		ASSERT_LE(0, child_sockfd);
+
+		/* Makes connection to the listening socket with port[1]. */
+		ASSERT_EQ(-1, connect_variant(variant, child_sockfd, self, 1));
+		ASSERT_EQ(EACCES, errno);
+		_exit(_metadata->passed ? EXIT_SUCCESS : EXIT_FAILURE);
+		return;
+	}
+
+	/* Closes listening socket 2 for the parent. */
+	ASSERT_EQ(0, close(sockfd_2));
+
+	ASSERT_EQ(child_2, waitpid(child_2, &status, 0));
+	ASSERT_EQ(1, WIFEXITED(status));
+	ASSERT_EQ(EXIT_SUCCESS, WEXITSTATUS(status));
+}
+
+TEST_F_FORK(socket, connect_afunspec_no_restrictions)
+{
+	int sockfd;
+	pid_t child;
+	int status;
+
+	/* Creates a server socket 1. */
+	sockfd = create_socket_variant(variant, SOCK_STREAM);
+	ASSERT_LE(0, sockfd);
+
+	/* Binds the socket 1 to address with port[0]. */
+	ASSERT_EQ(0, bind_variant(variant, sockfd, self, 0));
+
+	/* Makes connection to the socket with port[0]. */
+	ASSERT_EQ(0, connect_variant(variant, sockfd, self, 0));
+
+	child = fork();
+	ASSERT_LE(0, child);
+	if (child == 0) {
+		/* Child tries to disconnect already connected socket. */
+		ASSERT_EQ(0, connect(sockfd, (struct sockaddr *)&addr_unspec,
+				     sizeof(addr_unspec)));
+		_exit(_metadata->passed ? EXIT_SUCCESS : EXIT_FAILURE);
+		return;
+	}
+	/* Closes listening socket 1 for the parent. */
+	ASSERT_EQ(0, close(sockfd));
+
+	ASSERT_EQ(child, waitpid(child, &status, 0));
+	ASSERT_EQ(1, WIFEXITED(status));
+	ASSERT_EQ(EXIT_SUCCESS, WEXITSTATUS(status));
+}
+
+TEST_F_FORK(socket, connect_afunspec_with_restrictions)
+{
+	int sockfd;
+	pid_t child;
+	int status;
+
+	struct landlock_ruleset_attr ruleset_attr_1 = {
+		.handled_access_net = LANDLOCK_ACCESS_NET_BIND_TCP,
+	};
+	struct landlock_net_service_attr net_service_1 = {
+		.allowed_access = LANDLOCK_ACCESS_NET_BIND_TCP,
+
+		.port = self->port[0],
+	};
+
+	struct landlock_ruleset_attr ruleset_attr_2 = {
+		.handled_access_net = LANDLOCK_ACCESS_NET_BIND_TCP |
+				      LANDLOCK_ACCESS_NET_CONNECT_TCP,
+	};
+	struct landlock_net_service_attr net_service_2 = {
+		.allowed_access = LANDLOCK_ACCESS_NET_BIND_TCP |
+				  LANDLOCK_ACCESS_NET_CONNECT_TCP,
+
+		.port = self->port[0],
+	};
+
+	const int ruleset_fd_1 = landlock_create_ruleset(
+		&ruleset_attr_1, sizeof(ruleset_attr_1), 0);
+	ASSERT_LE(0, ruleset_fd_1);
+
+	/* Allows bind operations to the port[0] socket. */
+	ASSERT_EQ(0, landlock_add_rule(ruleset_fd_1, LANDLOCK_RULE_NET_SERVICE,
+				       &net_service_1, 0));
+
+	/* Enforces the ruleset. */
+	enforce_ruleset(_metadata, ruleset_fd_1);
+
+	/* Creates a server socket 1. */
+	sockfd = create_socket_variant(variant, SOCK_STREAM);
+	ASSERT_LE(0, sockfd);
+
+	/* Binds the socket 1 to address with port[0]. */
+	ASSERT_EQ(0, bind_variant(variant, sockfd, self, 0));
+
+	/* Makes connection to socket with port[0]. */
+	ASSERT_EQ(0, connect_variant(variant, sockfd, self, 0));
+
+	const int ruleset_fd_2 = landlock_create_ruleset(
+		&ruleset_attr_2, sizeof(ruleset_attr_2), 0);
+	ASSERT_LE(0, ruleset_fd_2);
+
+	/* Allows connect and bind operations to the port[0] socket. */
+	ASSERT_EQ(0, landlock_add_rule(ruleset_fd_2, LANDLOCK_RULE_NET_SERVICE,
+				       &net_service_2, 0));
+
+	/* Enforces the ruleset. */
+	enforce_ruleset(_metadata, ruleset_fd_2);
+
+	child = fork();
+	ASSERT_LE(0, child);
+	if (child == 0) {
+		/* Child tries to disconnect already connected socket. */
+		ASSERT_EQ(-1, connect(sockfd, (struct sockaddr *)&addr_unspec,
+				      sizeof(addr_unspec)));
+		ASSERT_EQ(EACCES, errno);
+		_exit(_metadata->passed ? EXIT_SUCCESS : EXIT_FAILURE);
+		return;
+	}
+	/* Closes listening socket 1 for the parent. */
+	ASSERT_EQ(0, close(sockfd));
+
+	ASSERT_EQ(child, waitpid(child, &status, 0));
+	ASSERT_EQ(1, WIFEXITED(status));
+	ASSERT_EQ(EXIT_SUCCESS, WEXITSTATUS(status));
+}
+
+TEST_F_FORK(socket, ruleset_overlap)
+{
+	int sockfd;
+	int one = 1;
+
+	struct landlock_ruleset_attr ruleset_attr = {
+		.handled_access_net = LANDLOCK_ACCESS_NET_BIND_TCP |
+				      LANDLOCK_ACCESS_NET_CONNECT_TCP,
+	};
+	struct landlock_net_service_attr net_service_1 = {
+		.allowed_access = LANDLOCK_ACCESS_NET_BIND_TCP,
+
+		.port = self->port[0],
+	};
+
+	struct landlock_net_service_attr net_service_2 = {
+		.allowed_access = LANDLOCK_ACCESS_NET_BIND_TCP |
+				  LANDLOCK_ACCESS_NET_CONNECT_TCP,
+
+		.port = self->port[0],
+	};
+
+	int ruleset_fd =
+		landlock_create_ruleset(&ruleset_attr, sizeof(ruleset_attr), 0);
+	ASSERT_LE(0, ruleset_fd);
+
+	/* Allows bind operations to the port[0] socket. */
+	ASSERT_EQ(0, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_SERVICE,
+				       &net_service_1, 0));
+	/* Allows connect and bind operations to the port[0] socket. */
+	ASSERT_EQ(0, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_SERVICE,
+				       &net_service_2, 0));
+
+	/* Enforces the ruleset. */
+	enforce_ruleset(_metadata, ruleset_fd);
+
+	/* Creates a server socket. */
+	sockfd = create_socket_variant(variant, SOCK_STREAM);
+	ASSERT_LE(0, sockfd);
+	/* Allows to reuse of local address. */
+	ASSERT_EQ(0, setsockopt(sockfd, SOL_SOCKET, SO_REUSEADDR, &one,
+				sizeof(one)));
+
+	/* Binds the socket to address with port[0]. */
+	ASSERT_EQ(0, bind_variant(variant, sockfd, self, 0));
+
+	/* Makes connection to socket with port[0]. */
+	ASSERT_EQ(0, connect_variant(variant, sockfd, self, 0));
+
+	/* Closes socket. */
+	ASSERT_EQ(0, close(sockfd));
+
+	/* Creates another ruleset layer. */
+	ruleset_fd =
+		landlock_create_ruleset(&ruleset_attr, sizeof(ruleset_attr), 0);
+	ASSERT_LE(0, ruleset_fd);
+
+	/*
+	 * Allows bind operations to the port[0] socket in
+	 * the new ruleset layer.
+	 */
+	ASSERT_EQ(0, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_SERVICE,
+				       &net_service_1, 0));
+
+	/* Enforces the new ruleset. */
+	enforce_ruleset(_metadata, ruleset_fd);
+
+	/* Creates a server socket. */
+	sockfd = create_socket_variant(variant, SOCK_STREAM);
+	ASSERT_LE(0, sockfd);
+	/* Allows to reuse of local address. */
+	ASSERT_EQ(0, setsockopt(sockfd, SOL_SOCKET, SO_REUSEADDR, &one,
+				sizeof(one)));
+
+	/* Binds the socket to address with port[0]. */
+	ASSERT_EQ(0, bind_variant(variant, sockfd, self, 0));
+
+	/*
+	 * Forbids to connect the socket to address with port[0],
+	 * as just one ruleset layer has connect() access rule.
+	 */
+	ASSERT_EQ(-1, connect_variant(variant, sockfd, self, 0));
+	ASSERT_EQ(EACCES, errno);
+
+	/* Closes socket. */
+	ASSERT_EQ(0, close(sockfd));
+}
+
+TEST_F_FORK(socket, ruleset_expanding)
+{
+	int sockfd_1, sockfd_2;
+	int one = 1;
+
+	struct landlock_ruleset_attr ruleset_attr_1 = {
+		.handled_access_net = LANDLOCK_ACCESS_NET_BIND_TCP,
+	};
+	struct landlock_net_service_attr net_service_1 = {
+		.allowed_access = LANDLOCK_ACCESS_NET_BIND_TCP,
+
+		.port = self->port[0],
+	};
+
+	const int ruleset_fd_1 = landlock_create_ruleset(
+		&ruleset_attr_1, sizeof(ruleset_attr_1), 0);
+	ASSERT_LE(0, ruleset_fd_1);
+
+	/* Adds rule to port[0] socket. */
+	ASSERT_EQ(0, landlock_add_rule(ruleset_fd_1, LANDLOCK_RULE_NET_SERVICE,
+				       &net_service_1, 0));
+
+	/* Enforces the ruleset. */
+	enforce_ruleset(_metadata, ruleset_fd_1);
+	ASSERT_EQ(0, close(ruleset_fd_1));
+
+	/* Creates a socket 1. */
+	sockfd_1 = create_socket_variant(variant, SOCK_STREAM);
+	ASSERT_LE(0, sockfd_1);
+	/* Allows to reuse of local address. */
+	ASSERT_EQ(0, setsockopt(sockfd_1, SOL_SOCKET, SO_REUSEADDR, &one,
+				sizeof(one)));
+
+	/* Binds the socket 1 to address with port[0]. */
+	ASSERT_EQ(0, bind_variant(variant, sockfd_1, self, 0));
+
+	/* Makes connection to socket 1 with port[0]. */
+	ASSERT_EQ(0, connect_variant(variant, sockfd_1, self, 0));
+
+	/* Closes socket 1. */
+	ASSERT_EQ(0, close(sockfd_1));
+
+	/* Creates a socket 2. */
+	sockfd_2 = create_socket_variant(variant, SOCK_STREAM);
+	ASSERT_LE(0, sockfd_2);
+	/* Allows to reuse of local address. */
+	ASSERT_EQ(0, setsockopt(sockfd_2, SOL_SOCKET, SO_REUSEADDR, &one,
+				sizeof(one)));
+
+	/*
+	 * Forbids to bind the socket 2 to address with port[1],
+	 * since there is no rule with bind() access for port[1].
+	 */
+	ASSERT_EQ(-1, bind_variant(variant, sockfd_2, self, 1));
+	ASSERT_EQ(EACCES, errno);
+
+	/* Expands network mask. */
+	struct landlock_ruleset_attr ruleset_attr_2 = {
+		.handled_access_net = LANDLOCK_ACCESS_NET_BIND_TCP |
+				      LANDLOCK_ACCESS_NET_CONNECT_TCP,
+	};
+
+	/* Adds connect() access to port[0]. */
+	struct landlock_net_service_attr net_service_2 = {
+		.allowed_access = LANDLOCK_ACCESS_NET_BIND_TCP |
+				  LANDLOCK_ACCESS_NET_CONNECT_TCP,
+
+		.port = self->port[0],
+	};
+	/* Adds bind() access to port[1]. */
+	struct landlock_net_service_attr net_service_3 = {
+		.allowed_access = LANDLOCK_ACCESS_NET_BIND_TCP,
+
+		.port = self->port[1],
+	};
+
+	const int ruleset_fd_2 = landlock_create_ruleset(
+		&ruleset_attr_2, sizeof(ruleset_attr_2), 0);
+	ASSERT_LE(0, ruleset_fd_2);
+
+	/* Adds rule to port[0] socket. */
+	ASSERT_EQ(0, landlock_add_rule(ruleset_fd_2, LANDLOCK_RULE_NET_SERVICE,
+				       &net_service_2, 0));
+	/* Adds rule to port[1] socket. */
+	ASSERT_EQ(0, landlock_add_rule(ruleset_fd_2, LANDLOCK_RULE_NET_SERVICE,
+				       &net_service_3, 0));
+
+	/* Enforces the ruleset. */
+	enforce_ruleset(_metadata, ruleset_fd_2);
+	ASSERT_EQ(0, close(ruleset_fd_2));
+
+	/* Creates a socket 1. */
+	sockfd_1 = create_socket_variant(variant, SOCK_STREAM);
+	ASSERT_LE(0, sockfd_1);
+	/* Allows to reuse of local address. */
+	ASSERT_EQ(0, setsockopt(sockfd_1, SOL_SOCKET, SO_REUSEADDR, &one,
+				sizeof(one)));
+
+	/* Binds the socket 1 to address with port[0]. */
+	ASSERT_EQ(0, bind_variant(variant, sockfd_1, self, 0));
+
+	/* Makes connection to socket 1 with port[0]. */
+	ASSERT_EQ(0, connect_variant(variant, sockfd_1, self, 0));
+
+	/* Closes socket 1. */
+	ASSERT_EQ(0, close(sockfd_1));
+
+	/* Creates a socket 2. */
+	sockfd_2 = create_socket_variant(variant, SOCK_STREAM);
+	ASSERT_LE(0, sockfd_2);
+	/* Allows to reuse of local address. */
+	ASSERT_EQ(0, setsockopt(sockfd_2, SOL_SOCKET, SO_REUSEADDR, &one,
+				sizeof(one)));
+
+	/*
+	 * Forbids to bind the socket 2 to address with port[1],
+	 * because just one layer has bind() access rule.
+	 */
+	ASSERT_EQ(-1, bind_variant(variant, sockfd_1, self, 1));
+	ASSERT_EQ(EACCES, errno);
+
+	/* Expands network mask. */
+	struct landlock_ruleset_attr ruleset_attr_3 = {
+		.handled_access_net = LANDLOCK_ACCESS_NET_BIND_TCP |
+				      LANDLOCK_ACCESS_NET_CONNECT_TCP,
+	};
+
+	/* Restricts connect() access to port[0]. */
+	struct landlock_net_service_attr net_service_4 = {
+		.allowed_access = LANDLOCK_ACCESS_NET_BIND_TCP,
+
+		.port = self->port[0],
+	};
+
+	const int ruleset_fd_3 = landlock_create_ruleset(
+		&ruleset_attr_3, sizeof(ruleset_attr_3), 0);
+	ASSERT_LE(0, ruleset_fd_3);
+
+	/* Adds rule to port[0] socket. */
+	ASSERT_EQ(0, landlock_add_rule(ruleset_fd_3, LANDLOCK_RULE_NET_SERVICE,
+				       &net_service_4, 0));
+
+	/* Enforces the ruleset. */
+	enforce_ruleset(_metadata, ruleset_fd_3);
+	ASSERT_EQ(0, close(ruleset_fd_3));
+
+	/* Creates a socket 1. */
+	sockfd_1 = create_socket_variant(variant, SOCK_STREAM);
+	ASSERT_LE(0, sockfd_1);
+	/* Allows to reuse of local address. */
+	ASSERT_EQ(0, setsockopt(sockfd_1, SOL_SOCKET, SO_REUSEADDR, &one,
+				sizeof(one)));
+
+	/* Binds the socket 1 to address with port[0]. */
+	ASSERT_EQ(0, bind_variant(variant, sockfd_1, self, 0));
+
+	/*
+	 * Forbids to connect the socket 1 to address with port[0],
+	 * as just one layer has connect() access rule.
+	 */
+	ASSERT_EQ(-1, connect_variant(variant, sockfd_1, self, 0));
+	ASSERT_EQ(EACCES, errno);
+
+	/* Closes socket 1. */
+	ASSERT_EQ(0, close(sockfd_1));
+}
+
+/* clang-format off */
+
+#define ACCESS_LAST LANDLOCK_ACCESS_NET_CONNECT_TCP
+
+#define ACCESS_ALL ( \
+	LANDLOCK_ACCESS_NET_BIND_TCP | \
+	LANDLOCK_ACCESS_NET_CONNECT_TCP)
+
+/* clang-format on */
+
+TEST_F_FORK(socket, inval)
+{
+	__u64 access;
+
+	struct landlock_ruleset_attr ruleset_attr = {
+		.handled_access_net = LANDLOCK_ACCESS_NET_BIND_TCP
+	};
+	struct landlock_ruleset_attr ruleset_attr_inval = {
+		.handled_access_net = LANDLOCK_INVAL_ATTR
+	};
+	struct landlock_ruleset_attr ruleset_attr_all = { .handled_access_net =
+								  ACCESS_ALL };
+
+	struct landlock_net_service_attr net_service_1 = {
+		.allowed_access = LANDLOCK_ACCESS_NET_BIND_TCP |
+				  LANDLOCK_ACCESS_NET_CONNECT_TCP,
+		.port = self->port[0],
+	};
+	struct landlock_net_service_attr net_service_2 = {
+		.allowed_access = LANDLOCK_ACCESS_NET_BIND_TCP,
+		.port = 0,
+	};
+	struct landlock_net_service_attr net_service_3 = {
+		.allowed_access = 0,
+		.port = self->port[1],
+	};
+	struct landlock_net_service_attr net_service_4 = {
+		.allowed_access = LANDLOCK_ACCESS_NET_BIND_TCP,
+		.port = self->port[2],
+	};
+
+	struct landlock_net_service_attr net_service_5 = {};
+
+	/* Checks invalid ruleset attribute. */
+	const int ruleset_fd_inv = landlock_create_ruleset(
+		&ruleset_attr_inval, sizeof(ruleset_attr_inval), 0);
+	ASSERT_EQ(-1, ruleset_fd_inv);
+	ASSERT_EQ(EINVAL, errno);
+
+	/* Gets ruleset. */
+	const int ruleset_fd =
+		landlock_create_ruleset(&ruleset_attr, sizeof(ruleset_attr), 0);
+	ASSERT_LE(0, ruleset_fd);
+
+	/* Checks unhandled allowed_access. */
+	ASSERT_EQ(-1, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_SERVICE,
+					&net_service_1, 0));
+	ASSERT_EQ(EINVAL, errno);
+
+	/* Checks zero port value. */
+	ASSERT_EQ(-1, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_SERVICE,
+					&net_service_2, 0));
+	ASSERT_EQ(EINVAL, errno);
+
+	/* Checks zero access value. */
+	ASSERT_EQ(-1, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_SERVICE,
+					&net_service_3, 0));
+	ASSERT_EQ(ENOMSG, errno);
+
+	/* Adds with legitimate values. */
+	ASSERT_EQ(0, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_SERVICE,
+				       &net_service_4, 0));
+
+	const int ruleset_fd_all = landlock_create_ruleset(
+		&ruleset_attr_all, sizeof(ruleset_attr_all), 0);
+
+	ASSERT_LE(0, ruleset_fd_all);
+
+	/* Tests access rights for all network rules */
+	for (access = 1; access <= ACCESS_LAST; access <<= 1) {
+		net_service_5.allowed_access = access;
+		net_service_5.port = self->port[3];
+
+		ASSERT_EQ(0, landlock_add_rule(ruleset_fd_all,
+					       LANDLOCK_RULE_NET_SERVICE,
+					       &net_service_5, 0));
+	}
+
+	/* Enforces the ruleset. */
+	enforce_ruleset(_metadata, ruleset_fd);
+	ASSERT_EQ(0, close(ruleset_fd));
+
+	enforce_ruleset(_metadata, ruleset_fd_all);
+	ASSERT_EQ(0, close(ruleset_fd_all));
+}
+TEST_HARNESS_MAIN
--
2.25.1

