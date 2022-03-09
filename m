Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4437C4D305D
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 14:48:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230109AbiCINrB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 08:47:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233019AbiCINqb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 08:46:31 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3182D17B8BE;
        Wed,  9 Mar 2022 05:45:24 -0800 (PST)
Received: from fraeml704-chm.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4KDD1g5hg6z6H6mm;
        Wed,  9 Mar 2022 21:43:51 +0800 (CST)
Received: from mscphispre00059.huawei.com (10.123.71.64) by
 fraeml704-chm.china.huawei.com (10.206.15.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.21; Wed, 9 Mar 2022 14:45:21 +0100
From:   Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
To:     <mic@digikod.net>
CC:     <willemdebruijn.kernel@gmail.com>,
        <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
        <artem.kuzin@huawei.com>, <anton.sirazetdinov@huawei.com>
Subject: [RFC PATCH v4 10/15] seltest/landlock: add tests for bind() hooks
Date:   Wed, 9 Mar 2022 21:44:54 +0800
Message-ID: <20220309134459.6448-11-konstantin.meskhidze@huawei.com>
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

Adds two selftests for bind socket action.
The one is with no landlock restrictions:
    - bind_no_restrictions;
The second one is with mixed landlock rules:
    - bind_with_restrictions;

Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
---

Changes since v3:
* Split commit.
* Add helper create_socket.
* Add FIXTURE_SETUP.

---
 .../testing/selftests/landlock/network_test.c | 153 ++++++++++++++++++
 1 file changed, 153 insertions(+)
 create mode 100644 tools/testing/selftests/landlock/network_test.c

diff --git a/tools/testing/selftests/landlock/network_test.c b/tools/testing/selftests/landlock/network_test.c
new file mode 100644
index 000000000000..4c60f6d973a8
--- /dev/null
+++ b/tools/testing/selftests/landlock/network_test.c
@@ -0,0 +1,153 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Landlock tests - Network
+ *
+ * Copyright (C) 2022 Huawei Tech. Co., Ltd.
+ * Author: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
+ *
+ */
+
+#define _GNU_SOURCE
+#include <arpa/inet.h>
+#include <errno.h>
+#include <fcntl.h>
+#include <linux/landlock.h>
+#include <netinet/in.h>
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
+uint port[MAX_SOCKET_NUM];
+struct sockaddr_in addr[MAX_SOCKET_NUM];
+
+const int one = 1;
+
+/* Number pending connections queue to be hold */
+#define BACKLOG 10
+
+static int create_socket(struct __test_metadata *const _metadata)
+{
+
+		int sockfd;
+
+		sockfd = socket(AF_INET, SOCK_STREAM | SOCK_CLOEXEC, 0);
+		ASSERT_LE(0, sockfd);
+		/* Allows to reuse of local address */
+		ASSERT_EQ(0, setsockopt(sockfd, SOL_SOCKET, SO_REUSEADDR, &one, sizeof(one)));
+
+		return sockfd;
+}
+
+static void enforce_ruleset(struct __test_metadata *const _metadata,
+		const int ruleset_fd)
+{
+	ASSERT_EQ(0, prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0));
+	ASSERT_EQ(0, landlock_restrict_self(ruleset_fd, 0)) {
+		TH_LOG("Failed to enforce ruleset: %s", strerror(errno));
+	}
+}
+
+FIXTURE(socket) { };
+
+FIXTURE_SETUP(socket)
+{
+	int i;
+	/* Creates socket addresses */
+	for (i = 0; i < MAX_SOCKET_NUM; i++) {
+		port[i] = SOCK_PORT_START + SOCK_PORT_ADD*i;
+		addr[i].sin_family = AF_INET;
+		addr[i].sin_port = htons(port[i]);
+		addr[i].sin_addr.s_addr = inet_addr(IP_ADDRESS);
+		memset(&(addr[i].sin_zero), '\0', 8);
+	}
+}
+
+FIXTURE_TEARDOWN(socket)
+{ }
+
+TEST_F_FORK(socket, bind_no_restrictions) {
+
+	int sockfd;
+
+	sockfd = create_socket(_metadata);
+	ASSERT_LE(0, sockfd);
+
+	/* Binds a socket to port[0] */
+	ASSERT_EQ(0, bind(sockfd, (struct sockaddr *)&addr[0], sizeof(addr[0])));
+
+	ASSERT_EQ(0, close(sockfd));
+}
+
+TEST_F_FORK(socket, bind_with_restrictions) {
+
+	int sockfd_1, sockfd_2, sockfd_3;
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
+		.allowed_access = LANDLOCK_ACCESS_NET_CONNECT_TCP,
+		.port = port[1],
+	};
+	struct landlock_net_service_attr net_service_3 = {
+		.allowed_access = 0,
+		.port = port[2],
+	};
+
+	const int ruleset_fd = landlock_create_ruleset(&ruleset_attr,
+			sizeof(ruleset_attr), 0);
+	ASSERT_LE(0, ruleset_fd);
+
+	/* Allows connect and bind operations to the port[0] socket. */
+	ASSERT_EQ(0, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_SERVICE,
+				&net_service_1, 0));
+	/* Allows connect and deny bind operations to the port[1] socket. */
+	ASSERT_EQ(0, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_SERVICE,
+				&net_service_2, 0));
+	/* Empty allowed_access (i.e. deny rules) are ignored in network actions
+	 * for port[2] socket.
+	 */
+	ASSERT_EQ(-1, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_SERVICE,
+				&net_service_3, 0));
+	ASSERT_EQ(ENOMSG, errno);
+
+	/* Enforces the ruleset. */
+	enforce_ruleset(_metadata, ruleset_fd);
+
+	sockfd_1 = create_socket(_metadata);
+	ASSERT_LE(0, sockfd_1);
+	/* Binds a socket to port[0] */
+	ASSERT_EQ(0, bind(sockfd_1, (struct sockaddr  *)&addr[0], sizeof(addr[0])));
+
+	/* Close bounded socket*/
+	ASSERT_EQ(0, close(sockfd_1));
+
+	sockfd_2 = create_socket(_metadata);
+	ASSERT_LE(0, sockfd_2);
+	/* Binds a socket to port[1] */
+	ASSERT_EQ(-1, bind(sockfd_2, (struct sockaddr *)&addr[1], sizeof(addr[1])));
+	ASSERT_EQ(EACCES, errno);
+
+	sockfd_3 = create_socket(_metadata);
+	ASSERT_LE(0, sockfd_3);
+	/* Binds a socket to port[2] */
+	ASSERT_EQ(-1, bind(sockfd_3, (struct sockaddr *)&addr[2], sizeof(addr[2])));
+	ASSERT_EQ(EACCES, errno);
+}
+TEST_HARNESS_MAIN
--
2.25.1

