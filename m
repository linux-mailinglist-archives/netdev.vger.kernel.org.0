Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C851C552CE9
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 10:25:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348225AbiFUIYl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 04:24:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348129AbiFUIYJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 04:24:09 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92B2BBE0E;
        Tue, 21 Jun 2022 01:23:39 -0700 (PDT)
Received: from fraeml704-chm.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4LRzxx6k1nz6F8x6;
        Tue, 21 Jun 2022 16:21:41 +0800 (CST)
Received: from lhreml745-chm.china.huawei.com (10.201.108.195) by
 fraeml704-chm.china.huawei.com (10.206.15.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2375.24; Tue, 21 Jun 2022 10:23:36 +0200
Received: from mscphis00759.huawei.com (10.123.66.134) by
 lhreml745-chm.china.huawei.com (10.201.108.195) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 21 Jun 2022 09:23:35 +0100
From:   Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
To:     <mic@digikod.net>
CC:     <willemdebruijn.kernel@gmail.com>,
        <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
        <anton.sirazetdinov@huawei.com>
Subject: [PATCH v6 13/17] seltests/landlock: adds AF_UNSPEC family test
Date:   Tue, 21 Jun 2022 16:23:09 +0800
Message-ID: <20220621082313.3330667-14-konstantin.meskhidze@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220621082313.3330667-1-konstantin.meskhidze@huawei.com>
References: <20220621082313.3330667-1-konstantin.meskhidze@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.123.66.134]
X-ClientProxiedBy: mscpeml500001.china.huawei.com (7.188.26.142) To
 lhreml745-chm.china.huawei.com (10.201.108.195)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adds two selftests for connect() action with
AF_UNSPEC family flag.
The one is with no landlock restrictions
allows to disconnect already connected socket
with connect(..., AF_UNSPEC, ...):
    - connect_afunspec_no_restictions;
The second one refuses landlocked process
to disconnect already connected socket:
    - connect_afunspec_with_restictions;

Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
---

Changes since v5:
* Formats code with clang-format-14.

Changes since v4:
* Refactors code with self->port, self->addr4 variables.
* Adds bind() hook check for with AF_UNSPEC family.

Changes since v3:
* Adds connect_afunspec_no_restictions test.
* Adds connect_afunspec_with_restictions test.

---
 tools/testing/selftests/landlock/net_test.c | 113 ++++++++++++++++++++
 1 file changed, 113 insertions(+)

diff --git a/tools/testing/selftests/landlock/net_test.c b/tools/testing/selftests/landlock/net_test.c
index ce6fd51a922d..c5fe4284c38f 100644
--- a/tools/testing/selftests/landlock/net_test.c
+++ b/tools/testing/selftests/landlock/net_test.c
@@ -351,4 +351,117 @@ TEST_F(socket, connect_with_restrictions)
 	ASSERT_EQ(1, WIFEXITED(status));
 	ASSERT_EQ(EXIT_SUCCESS, WEXITSTATUS(status));
 }
+
+TEST_F(socket, connect_afunspec_no_restictions)
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
+		struct sockaddr addr_unspec = { .sa_family = AF_UNSPEC };
+
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
+TEST_F(socket, connect_afunspec_with_restictions)
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
+		struct sockaddr addr_unspec = { .sa_family = AF_UNSPEC };
+
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
 TEST_HARNESS_MAIN
--
2.25.1

