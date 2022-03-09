Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EEA54D305E
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 14:48:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233015AbiCINrH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 08:47:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233103AbiCINqb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 08:46:31 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8158717BC67;
        Wed,  9 Mar 2022 05:45:25 -0800 (PST)
Received: from fraeml704-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4KDD1r4FJxz67gYW;
        Wed,  9 Mar 2022 21:44:00 +0800 (CST)
Received: from mscphispre00059.huawei.com (10.123.71.64) by
 fraeml704-chm.china.huawei.com (10.206.15.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.21; Wed, 9 Mar 2022 14:45:23 +0100
From:   Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
To:     <mic@digikod.net>
CC:     <willemdebruijn.kernel@gmail.com>,
        <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
        <artem.kuzin@huawei.com>, <anton.sirazetdinov@huawei.com>
Subject: [RFC PATCH v4 11/15] seltest/landlock: add tests for connect() hooks
Date:   Wed, 9 Mar 2022 21:44:55 +0800
Message-ID: <20220309134459.6448-12-konstantin.meskhidze@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220309134459.6448-1-konstantin.meskhidze@huawei.com>
References: <20220309134459.6448-1-konstantin.meskhidze@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.123.71.64]
X-ClientProxiedBy: mscpeml500001.china.huawei.com (7.188.26.142) To
 fraeml704-chm.china.huawei.com (10.206.15.53)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adds two selftests for connect socket action.
The one is with no landlock restrictions:
    - connect_no_restrictions;
The second one is with mixed landlock rules:
    - connect_with_restrictions;

Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
---

Changes since v3:
* Split commit.

---
 .../testing/selftests/landlock/network_test.c | 162 ++++++++++++++++++
 1 file changed, 162 insertions(+)

diff --git a/tools/testing/selftests/landlock/network_test.c b/tools/testing/selftests/landlock/network_test.c
index 4c60f6d973a8..20f2d94d6d85 100644
--- a/tools/testing/selftests/landlock/network_test.c
+++ b/tools/testing/selftests/landlock/network_test.c
@@ -150,4 +150,166 @@ TEST_F_FORK(socket, bind_with_restrictions) {
 	ASSERT_EQ(-1, bind(sockfd_3, (struct sockaddr *)&addr[2], sizeof(addr[2])));
 	ASSERT_EQ(EACCES, errno);
 }
+
+TEST_F_FORK(socket, connect_no_restrictions) {
+
+	int sockfd, new_fd;
+	pid_t child;
+	int status;
+
+	/* Creates a server socket */
+	sockfd = create_socket(_metadata);
+	ASSERT_LE(0, sockfd);
+
+	/* Binds a socket to port[0] */
+	ASSERT_EQ(0, bind(sockfd, (struct sockaddr *)&addr[0], sizeof(addr[0])));
+
+	/* Makes listening socket */
+	ASSERT_EQ(0, listen(sockfd, BACKLOG));
+
+	child = fork();
+	ASSERT_LE(0, child);
+	if (child == 0) {
+		int child_sockfd;
+
+		/* Closes listening socket for the child */
+		ASSERT_EQ(0, close(sockfd));
+		/* Create a stream client socket */
+		child_sockfd = create_socket(_metadata);
+		ASSERT_LE(0, child_sockfd);
+
+		/* Makes connection to the listening socket */
+		ASSERT_EQ(0, connect(child_sockfd, (struct sockaddr *)&addr[0],
+						   sizeof(addr[0])));
+		_exit(_metadata->passed ? EXIT_SUCCESS : EXIT_FAILURE);
+		return;
+	}
+	/* Accepts connection from the child */
+	new_fd = accept(sockfd, NULL, 0);
+	ASSERT_LE(0, new_fd);
+
+	/* Closes connection */
+	ASSERT_EQ(0, close(new_fd));
+
+	/* Closes listening socket for the parent*/
+	ASSERT_EQ(0, close(sockfd));
+
+	ASSERT_EQ(child, waitpid(child, &status, 0));
+	ASSERT_EQ(1, WIFEXITED(status));
+	ASSERT_EQ(EXIT_SUCCESS, WEXITSTATUS(status));
+}
+
+TEST_F_FORK(socket, connect_with_restrictions) {
+
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
+		.port = port[0],
+	};
+	struct landlock_net_service_attr net_service_2 = {
+		.allowed_access = LANDLOCK_ACCESS_NET_BIND_TCP,
+		.port = port[1],
+	};
+
+	const int ruleset_fd = landlock_create_ruleset(&ruleset_attr,
+			sizeof(ruleset_attr), 0);
+	ASSERT_LE(0, ruleset_fd);
+
+	/* Allows connect and bind operations to the port[0] socket */
+	ASSERT_EQ(0, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_SERVICE,
+				&net_service_1, 0));
+	/* Allows connect and deny bind operations to the port[1] socket */
+	ASSERT_EQ(0, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_SERVICE,
+				&net_service_2, 0));
+
+	/* Enforces the ruleset. */
+	enforce_ruleset(_metadata, ruleset_fd);
+
+	/* Creates a server socket 1 */
+	sockfd_1 = create_socket(_metadata);
+	ASSERT_LE(0, sockfd_1);
+
+	/* Binds the socket 1 to address with port[0] */
+	ASSERT_EQ(0, bind(sockfd_1, (struct sockaddr *)&addr[0], sizeof(addr[0])));
+
+	/* Makes listening socket 1 */
+	ASSERT_EQ(0, listen(sockfd_1, BACKLOG));
+
+	child_1 = fork();
+	ASSERT_LE(0, child_1);
+	if (child_1 == 0) {
+		int child_sockfd;
+
+		/* Closes listening socket for the child */
+		ASSERT_EQ(0, close(sockfd_1));
+		/* Creates a stream client socket */
+		child_sockfd = create_socket(_metadata);
+		ASSERT_LE(0, child_sockfd);
+
+		/* Makes connection to the listening socket */
+		ASSERT_EQ(0, connect(child_sockfd, (struct sockaddr *)&addr[0],
+						   sizeof(addr[0])));
+		_exit(_metadata->passed ? EXIT_SUCCESS : EXIT_FAILURE);
+		return;
+	}
+	/* Accepts connection from the child 1 */
+	new_fd = accept(sockfd_1, NULL, 0);
+	ASSERT_LE(0, new_fd);
+
+	/* Closes connection */
+	ASSERT_EQ(0, close(new_fd));
+
+	/* Closes listening socket 1 for the parent*/
+	ASSERT_EQ(0, close(sockfd_1));
+
+	ASSERT_EQ(child_1, waitpid(child_1, &status, 0));
+	ASSERT_EQ(1, WIFEXITED(status));
+	ASSERT_EQ(EXIT_SUCCESS, WEXITSTATUS(status));
+
+	/* Creates a server socket 2 */
+	sockfd_2 = create_socket(_metadata);
+	ASSERT_LE(0, sockfd_2);
+
+	/* Binds the socket 2 to address with port[1] */
+	ASSERT_EQ(0, bind(sockfd_2, (struct sockaddr *)&addr[1], sizeof(addr[1])));
+
+	/* Makes listening socket 2 */
+	ASSERT_EQ(0, listen(sockfd_2, BACKLOG));
+
+	child_2 = fork();
+	ASSERT_LE(0, child_2);
+	if (child_2 == 0) {
+		int child_sockfd;
+
+		/* Closes listening socket for the child */
+		ASSERT_EQ(0, close(sockfd_2));
+		/* Creates a stream client socket */
+		child_sockfd = create_socket(_metadata);
+		ASSERT_LE(0, child_sockfd);
+
+		/* Makes connection to the listening socket */
+		ASSERT_EQ(-1, connect(child_sockfd, (struct sockaddr *)&addr[1],
+						   sizeof(addr[1])));
+		ASSERT_EQ(EACCES, errno);
+		_exit(_metadata->passed ? EXIT_SUCCESS : EXIT_FAILURE);
+		return;
+	}
+
+	/* Closes listening socket 2 for the parent*/
+	ASSERT_EQ(0, close(sockfd_2));
+
+	ASSERT_EQ(child_2, waitpid(child_2, &status, 0));
+	ASSERT_EQ(1, WIFEXITED(status));
+	ASSERT_EQ(EXIT_SUCCESS, WEXITSTATUS(status));
+}
+
 TEST_HARNESS_MAIN
--
2.25.1

