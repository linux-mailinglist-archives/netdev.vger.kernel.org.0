Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DDC352889A
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 17:23:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245264AbiEPPVn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 11:21:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245288AbiEPPVL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 11:21:11 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4318E3B550;
        Mon, 16 May 2022 08:21:10 -0700 (PDT)
Received: from fraeml704-chm.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4L22tH6rCzz67n8d;
        Mon, 16 May 2022 23:17:27 +0800 (CST)
Received: from mscphispre00059.huawei.com (10.123.71.64) by
 fraeml704-chm.china.huawei.com (10.206.15.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2375.24; Mon, 16 May 2022 17:21:08 +0200
From:   Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
To:     <mic@digikod.net>
CC:     <willemdebruijn.kernel@gmail.com>,
        <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
        <anton.sirazetdinov@huawei.com>
Subject: [PATCH v5 13/15] seltests/landlock: ruleset expanding test
Date:   Mon, 16 May 2022 23:20:36 +0800
Message-ID: <20220516152038.39594-14-konstantin.meskhidze@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220516152038.39594-1-konstantin.meskhidze@huawei.com>
References: <20220516152038.39594-1-konstantin.meskhidze@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.123.71.64]
X-ClientProxiedBy: mscpeml500001.china.huawei.com (7.188.26.142) To
 fraeml704-chm.china.huawei.com (10.206.15.53)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds expanding rulesets in which
rules are gradually added one by one, restricting
sockets' connections.

Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
---

Changes since v3:
* Add ruleset_expanding test.

Changes since v4:
* Refactoring code with self->port, self->addr4 variables.

---
 tools/testing/selftests/landlock/net_test.c | 152 ++++++++++++++++++++
 1 file changed, 152 insertions(+)

diff --git a/tools/testing/selftests/landlock/net_test.c b/tools/testing/selftests/landlock/net_test.c
index 1d8c9dfdbd48..b1639a55a898 100644
--- a/tools/testing/selftests/landlock/net_test.c
+++ b/tools/testing/selftests/landlock/net_test.c
@@ -728,4 +728,156 @@ TEST_F_FORK(socket_test, ruleset_overlap) {
 	ASSERT_EQ(0, close(sockfd));
 }

+TEST_F_FORK(socket_test, ruleset_expanding) {
+
+	int sockfd_1, sockfd_2;
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
+	const int ruleset_fd_1 = landlock_create_ruleset(&ruleset_attr_1,
+					sizeof(ruleset_attr_1), 0);
+	ASSERT_LE(0, ruleset_fd_1);
+
+	/* Adds rule to port[0] socket */
+	ASSERT_EQ(0, landlock_add_rule(ruleset_fd_1, LANDLOCK_RULE_NET_SERVICE,
+				       &net_service_1, 0));
+
+	/* Enforces the ruleset. */
+	enforce_ruleset(_metadata, ruleset_fd_1);
+	ASSERT_EQ(0, close(ruleset_fd_1));
+
+	/* Creates a socket 1 */
+	sockfd_1 = create_socket(_metadata, false, true);
+	ASSERT_LE(0, sockfd_1);
+
+	/* Binds the socket 1 to address with port[0] */
+	ASSERT_EQ(0, bind(sockfd_1, (struct sockaddr *)&self->addr4[0], sizeof(self->addr4[0])));
+
+	/* Makes connection to socket 1 with port[0] */
+	ASSERT_EQ(0, connect(sockfd_1, (struct sockaddr *)&self->addr4[0],
+						   sizeof(self->addr4[0])));
+
+	/* Closes socket 1 */
+	ASSERT_EQ(0, close(sockfd_1));
+
+	/* Creates a socket 2 */
+	sockfd_2 = create_socket(_metadata, false, true);
+	ASSERT_LE(0, sockfd_2);
+
+	/*
+	 * Forbids to bind the socket 2 to address with port[1],
+	 * cause there is no rule with bind() access for port[1].
+	 */
+	ASSERT_EQ(-1, bind(sockfd_2, (struct sockaddr *)&self->addr4[1], sizeof(self->addr4[1])));
+	ASSERT_EQ(EACCES, errno);
+
+	/* Expands network mask */
+	struct landlock_ruleset_attr ruleset_attr_2 = {
+		.handled_access_net = LANDLOCK_ACCESS_NET_BIND_TCP |
+				      LANDLOCK_ACCESS_NET_CONNECT_TCP,
+	};
+
+	/* Adds connect() access to port[0] */
+	struct landlock_net_service_attr net_service_2 = {
+		.allowed_access = LANDLOCK_ACCESS_NET_BIND_TCP |
+				  LANDLOCK_ACCESS_NET_CONNECT_TCP,
+
+		.port = self->port[0],
+	};
+	/* Adds bind() access to port[1] */
+	struct landlock_net_service_attr net_service_3 = {
+		.allowed_access = LANDLOCK_ACCESS_NET_BIND_TCP,
+
+		.port = self->port[1],
+	};
+
+	const int ruleset_fd_2 = landlock_create_ruleset(&ruleset_attr_2,
+					sizeof(ruleset_attr_2), 0);
+	ASSERT_LE(0, ruleset_fd_2);
+
+	/* Adds rule to port[0] socket */
+	ASSERT_EQ(0, landlock_add_rule(ruleset_fd_2, LANDLOCK_RULE_NET_SERVICE,
+				       &net_service_2, 0));
+	/* Adds rule to port[1] socket */
+	ASSERT_EQ(0, landlock_add_rule(ruleset_fd_2, LANDLOCK_RULE_NET_SERVICE,
+				       &net_service_3, 0));
+
+	/* Enforces the ruleset. */
+	enforce_ruleset(_metadata, ruleset_fd_2);
+	ASSERT_EQ(0, close(ruleset_fd_2));
+
+	/* Creates a socket 1 */
+	sockfd_1 = create_socket(_metadata, false, true);
+	ASSERT_LE(0, sockfd_1);
+
+	/* Binds the socket 1 to address with port[0] */
+	ASSERT_EQ(0, bind(sockfd_1, (struct sockaddr *)&self->addr4[0], sizeof(self->addr4[0])));
+
+	/* Makes connection to socket 1 with port[0] */
+	ASSERT_EQ(0, connect(sockfd_1, (struct sockaddr *)&self->addr4[0],
+						   sizeof(self->addr4[0])));
+	/* Closes socket 1 */
+	ASSERT_EQ(0, close(sockfd_1));
+
+	/* Creates a socket 2 */
+	sockfd_2 = create_socket(_metadata, false, true);
+	ASSERT_LE(0, sockfd_2);
+
+	/*
+	 * Forbids to bind the socket 2 to address with port[1],
+	 * cause just one layer has bind() access rule.
+	 */
+	ASSERT_EQ(-1, bind(sockfd_2, (struct sockaddr *)&self->addr4[1], sizeof(self->addr4[1])));
+	ASSERT_EQ(EACCES, errno);
+
+	/* Expands network mask */
+	struct landlock_ruleset_attr ruleset_attr_3 = {
+		.handled_access_net = LANDLOCK_ACCESS_NET_BIND_TCP |
+				      LANDLOCK_ACCESS_NET_CONNECT_TCP,
+	};
+
+	/* Restricts connect() access to port[0] */
+	struct landlock_net_service_attr net_service_4 = {
+		.allowed_access = LANDLOCK_ACCESS_NET_BIND_TCP,
+
+		.port = self->port[0],
+	};
+
+	const int ruleset_fd_3 = landlock_create_ruleset(&ruleset_attr_3,
+					sizeof(ruleset_attr_3), 0);
+	ASSERT_LE(0, ruleset_fd_3);
+
+	/* Adds rule to port[0] socket */
+	ASSERT_EQ(0, landlock_add_rule(ruleset_fd_3, LANDLOCK_RULE_NET_SERVICE,
+				       &net_service_4, 0));
+
+	/* Enforces the ruleset. */
+	enforce_ruleset(_metadata, ruleset_fd_3);
+	ASSERT_EQ(0, close(ruleset_fd_3));
+
+	/* Creates a socket 1 */
+	sockfd_1 = create_socket(_metadata, false, true);
+	ASSERT_LE(0, sockfd_1);
+
+	/* Binds the socket 1 to address with port[0] */
+	ASSERT_EQ(0, bind(sockfd_1, (struct sockaddr *)&self->addr4[0], sizeof(self->addr4[0])));
+
+	/*
+	 * Forbids to bind the socket 1 to address with port[0],
+	 * cause just one layer has connect() access rule.
+	 */
+	ASSERT_EQ(-1, connect(sockfd_1, (struct sockaddr *)&self->addr4[0],
+						   sizeof(self->addr4[0])));
+	ASSERT_EQ(EACCES, errno);
+
+	/* Closes socket 1 */
+	ASSERT_EQ(0, close(sockfd_1));
+}
 TEST_HARNESS_MAIN
--
2.25.1

