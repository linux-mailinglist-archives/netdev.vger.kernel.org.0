Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 678B75A52B0
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 19:06:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231384AbiH2RFd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 13:05:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231321AbiH2REx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 13:04:53 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 854329C511;
        Mon, 29 Aug 2022 10:04:31 -0700 (PDT)
Received: from fraeml706-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4MGcC46g2Lz6842f;
        Tue, 30 Aug 2022 01:00:48 +0800 (CST)
Received: from lhrpeml500004.china.huawei.com (7.191.163.9) by
 fraeml706-chm.china.huawei.com (10.206.15.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2375.31; Mon, 29 Aug 2022 19:04:27 +0200
Received: from mscphis00759.huawei.com (10.123.66.134) by
 lhrpeml500004.china.huawei.com (7.191.163.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 29 Aug 2022 18:04:27 +0100
From:   Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
To:     <mic@digikod.net>
CC:     <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
        <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
        <hukeping@huawei.com>, <anton.sirazetdinov@huawei.com>
Subject: [PATCH v7 12/18] seltests/landlock: add tests for connect() hooks
Date:   Tue, 30 Aug 2022 01:03:55 +0800
Message-ID: <20220829170401.834298-13-konstantin.meskhidze@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220829170401.834298-1-konstantin.meskhidze@huawei.com>
References: <20220829170401.834298-1-konstantin.meskhidze@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.123.66.134]
X-ClientProxiedBy: mscpeml100002.china.huawei.com (7.188.26.75) To
 lhrpeml500004.china.huawei.com (7.191.163.9)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adds selftests for connect socket action.
The first are with no landlock restrictions:
    - connect without restrictions for ip4;
    - connect without restrictions for ip6;
The second ones are with mixed landlock rules:
    - connect with restrictions ip4;
    - connect with restrictions ip6;

Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
---

Changes since v6:
* None.

Changes since v5:
* Adds connect_variant() helper.
* Formats code with clang-format-14.

Changes since v4:
* Adds selftests for IP6 family:
    - connect_no_restrictions_ip6.
    - connect_with_restrictions_ip6.
* Refactors code with self->port, self->addr4 and
self->addr6 variables.

Changes since v3:
* Split commit.

---
 tools/testing/selftests/landlock/net_test.c | 174 ++++++++++++++++++++
 1 file changed, 174 insertions(+)

diff --git a/tools/testing/selftests/landlock/net_test.c b/tools/testing/selftests/landlock/net_test.c
index 79c71fa37ddb..9c3d1e425439 100644
--- a/tools/testing/selftests/landlock/net_test.c
+++ b/tools/testing/selftests/landlock/net_test.c
@@ -26,6 +26,9 @@

 #define IP_ADDRESS "127.0.0.1"

+/* Number pending connections queue to be hold */
+#define BACKLOG 10
+
 FIXTURE(socket)
 {
 	uint port[MAX_SOCKET_NUM];
@@ -72,6 +75,19 @@ static int bind_variant(const FIXTURE_VARIANT(socket) *const variant,
 			    sizeof(self->addr6[index]));
 }

+static int connect_variant(const FIXTURE_VARIANT(socket) *const variant,
+			   const int sockfd,
+			   const FIXTURE_DATA(socket) *const self,
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
 FIXTURE_SETUP(socket)
 {
 	int i;
@@ -177,4 +193,162 @@ TEST_F(socket, bind_with_restrictions)
 	ASSERT_EQ(-1, bind_variant(variant, sockfd, self, 2));
 	ASSERT_EQ(EACCES, errno);
 }
+
+TEST_F(socket, connect_no_restrictions)
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
+		/* Create a stream client socket. */
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
+TEST_F(socket, connect_with_restrictions)
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
 TEST_HARNESS_MAIN
--
2.25.1

