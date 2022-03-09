Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A55114D3055
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 14:48:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231390AbiCINrE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 08:47:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232996AbiCINqp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 08:46:45 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98B9317C40E;
        Wed,  9 Mar 2022 05:45:29 -0800 (PST)
Received: from fraeml704-chm.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4KDD1n16wNz6H76Z;
        Wed,  9 Mar 2022 21:43:57 +0800 (CST)
Received: from mscphispre00059.huawei.com (10.123.71.64) by
 fraeml704-chm.china.huawei.com (10.206.15.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.21; Wed, 9 Mar 2022 14:45:27 +0100
From:   Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
To:     <mic@digikod.net>
CC:     <willemdebruijn.kernel@gmail.com>,
        <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
        <artem.kuzin@huawei.com>, <anton.sirazetdinov@huawei.com>
Subject: [RFC PATCH v4 14/15] seltest/landlock: ruleset expanding test
Date:   Wed, 9 Mar 2022 21:44:58 +0800
Message-ID: <20220309134459.6448-15-konstantin.meskhidze@huawei.com>
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

This patch adds expanding rulesets in which
rules are gradually added one by one, restricting
sockets' connections.

Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
---

Changes since v3:
* Add ruleset_expanding test.

---
 .../testing/selftests/landlock/network_test.c | 153 ++++++++++++++++++
 1 file changed, 153 insertions(+)

diff --git a/tools/testing/selftests/landlock/network_test.c b/tools/testing/selftests/landlock/network_test.c
index e1f219fd9f31..8fa2a349329c 100644
--- a/tools/testing/selftests/landlock/network_test.c
+++ b/tools/testing/selftests/landlock/network_test.c
@@ -457,4 +457,157 @@ TEST_F_FORK(socket, ruleset_overlap) {
 	ASSERT_EQ(0, close(sockfd));
 }

+TEST_F_FORK(socket, ruleset_expanding) {
+
+	int sockfd_1, sockfd_2;
+
+	struct landlock_ruleset_attr ruleset_attr_1 = {
+		.handled_access_net = LANDLOCK_ACCESS_NET_BIND_TCP,
+	};
+	struct landlock_net_service_attr net_service_1 = {
+		.allowed_access = LANDLOCK_ACCESS_NET_BIND_TCP,
+
+		.port = port[0],
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
+	sockfd_1 = create_socket(_metadata);
+	ASSERT_LE(0, sockfd_1);
+
+	/* Binds the socket 1 to address with port[0] */
+	ASSERT_EQ(0, bind(sockfd_1, (struct sockaddr *)&addr[0], sizeof(addr[0])));
+
+	/* Makes connection to socket 1 with port[0] */
+	ASSERT_EQ(0, connect(sockfd_1, (struct sockaddr *)&addr[0],
+						   sizeof(addr[0])));
+
+	/* Closes socket 1 */
+	ASSERT_EQ(0, close(sockfd_1));
+
+	/* Creates a socket 2 */
+	sockfd_2 = create_socket(_metadata);
+	ASSERT_LE(0, sockfd_2);
+
+	/*
+	 * Forbids to bind the socket 2 to address with port[1],
+	 * cause there is no rule with bind() access for port[1].
+	 */
+	ASSERT_EQ(-1, bind(sockfd_2, (struct sockaddr *)&addr[1], sizeof(addr[1])));
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
+		.port = port[0],
+	};
+	/* Adds bind() access to port[1] */
+	struct landlock_net_service_attr net_service_3 = {
+		.allowed_access = LANDLOCK_ACCESS_NET_BIND_TCP,
+
+		.port = port[1],
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
+	sockfd_1 = create_socket(_metadata);
+	ASSERT_LE(0, sockfd_1);
+
+	/* Binds the socket 1 to address with port[0] */
+	ASSERT_EQ(0, bind(sockfd_1, (struct sockaddr *)&addr[0], sizeof(addr[0])));
+
+	/* Makes connection to socket 1 with port[0] */
+	ASSERT_EQ(0, connect(sockfd_1, (struct sockaddr *)&addr[0],
+						   sizeof(addr[0])));
+	/* Closes socket 1 */
+	ASSERT_EQ(0, close(sockfd_1));
+
+	/* Creates a socket 2 */
+	sockfd_2 = create_socket(_metadata);
+	ASSERT_LE(0, sockfd_2);
+
+	/*
+	 * Forbids to bind the socket 2 to address with port[1],
+	 * cause just one layer has bind() access rule.
+	 */
+	ASSERT_EQ(-1, bind(sockfd_2, (struct sockaddr *)&addr[1], sizeof(addr[1])));
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
+		.port = port[0],
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
+	sockfd_1 = create_socket(_metadata);
+	ASSERT_LE(0, sockfd_1);
+
+	/* Binds the socket 1 to address with port[0] */
+	ASSERT_EQ(0, bind(sockfd_1, (struct sockaddr *)&addr[0], sizeof(addr[0])));
+
+	/*
+	 * Forbids to bind the socket 1 to address with port[0],
+	 * cause just one layer has connect() access rule.
+	 */
+	ASSERT_EQ(-1, connect(sockfd_1, (struct sockaddr *)&addr[0],
+						   sizeof(addr[0])));
+	ASSERT_EQ(EACCES, errno);
+
+	/* Closes socket 1 */
+	ASSERT_EQ(0, close(sockfd_1));
+}
+
 TEST_HARNESS_MAIN
--
2.25.1

