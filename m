Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9EA05A52AB
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 19:06:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231332AbiH2RFf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 13:05:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231331AbiH2REx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 13:04:53 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42D719C8EC;
        Mon, 29 Aug 2022 10:04:32 -0700 (PDT)
Received: from fraeml705-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4MGcGj0kn8z67ZgK;
        Tue, 30 Aug 2022 01:03:57 +0800 (CST)
Received: from lhrpeml500004.china.huawei.com (7.191.163.9) by
 fraeml705-chm.china.huawei.com (10.206.15.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2375.31; Mon, 29 Aug 2022 19:04:29 +0200
Received: from mscphis00759.huawei.com (10.123.66.134) by
 lhrpeml500004.china.huawei.com (7.191.163.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 29 Aug 2022 18:04:28 +0100
From:   Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
To:     <mic@digikod.net>
CC:     <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
        <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
        <hukeping@huawei.com>, <anton.sirazetdinov@huawei.com>
Subject: [PATCH v7 13/18] seltests/landlock: add AF_UNSPEC family test
Date:   Tue, 30 Aug 2022 01:03:56 +0800
Message-ID: <20220829170401.834298-14-konstantin.meskhidze@huawei.com>
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

Adds two selftests for connect() action with AF_UNSPEC family flag.
The one is with no landlock restrictions allows to disconnect already
connected socket with connect(..., AF_UNSPEC, ...):
    - connect_afunspec_no_restictions;
The second one refuses landlocked process to disconnect already
connected socket:
    - connect_afunspec_with_restictions;

Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
---

Changes since v6:
* None.

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
index 9c3d1e425439..40aef7c683af 100644
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

