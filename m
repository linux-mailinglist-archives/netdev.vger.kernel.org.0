Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C8584D3064
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 14:48:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233331AbiCINrB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 08:47:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233187AbiCINqc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 08:46:32 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3666E17C40D;
        Wed,  9 Mar 2022 05:45:28 -0800 (PST)
Received: from fraeml704-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4KDD1v1J61z67Lqc;
        Wed,  9 Mar 2022 21:44:03 +0800 (CST)
Received: from mscphispre00059.huawei.com (10.123.71.64) by
 fraeml704-chm.china.huawei.com (10.206.15.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.21; Wed, 9 Mar 2022 14:45:25 +0100
From:   Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
To:     <mic@digikod.net>
CC:     <willemdebruijn.kernel@gmail.com>,
        <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
        <artem.kuzin@huawei.com>, <anton.sirazetdinov@huawei.com>
Subject: [RFC PATCH v4 13/15] seltest/landlock: rules overlapping test
Date:   Wed, 9 Mar 2022 21:44:57 +0800
Message-ID: <20220309134459.6448-14-konstantin.meskhidze@huawei.com>
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

This patch adds overlapping rules for one port.
First rule adds just bind() access right for a port.
The second one adds both bind() and connect()
access rights for the same port.

Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
---

Changes since v3:
* Add ruleset_overlap test.

---
 .../testing/selftests/landlock/network_test.c | 51 +++++++++++++++++++
 1 file changed, 51 insertions(+)

diff --git a/tools/testing/selftests/landlock/network_test.c b/tools/testing/selftests/landlock/network_test.c
index 6fce31cad368..e1f219fd9f31 100644
--- a/tools/testing/selftests/landlock/network_test.c
+++ b/tools/testing/selftests/landlock/network_test.c
@@ -406,4 +406,55 @@ TEST_F_FORK(socket, connect_afunspec_with_restictions) {
 	ASSERT_EQ(1, WIFEXITED(status));
 	ASSERT_EQ(EXIT_SUCCESS, WEXITSTATUS(status));
 }
+
+TEST_F_FORK(socket, ruleset_overlap) {
+
+	int sockfd;
+
+	struct landlock_ruleset_attr ruleset_attr = {
+		.handled_access_net = LANDLOCK_ACCESS_NET_BIND_TCP |
+				      LANDLOCK_ACCESS_NET_CONNECT_TCP,
+	};
+	struct landlock_net_service_attr net_service_1 = {
+		.allowed_access = LANDLOCK_ACCESS_NET_BIND_TCP,
+
+		.port = port[0],
+	};
+
+		struct landlock_net_service_attr net_service_2 = {
+		.allowed_access = LANDLOCK_ACCESS_NET_BIND_TCP |
+				  LANDLOCK_ACCESS_NET_CONNECT_TCP,
+
+		.port = port[0],
+	};
+
+	const int ruleset_fd = landlock_create_ruleset(&ruleset_attr,
+					sizeof(ruleset_attr), 0);
+	ASSERT_LE(0, ruleset_fd);
+
+	/* Allows bind operations to the port[0] socket */
+	ASSERT_EQ(0, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_SERVICE,
+				       &net_service_1, 0));
+	/* Allows connect and bind operations to the port[0] socket */
+	ASSERT_EQ(0, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_SERVICE,
+				       &net_service_2, 0));
+
+	/* Enforces the ruleset. */
+	enforce_ruleset(_metadata, ruleset_fd);
+
+	/* Creates a server socket */
+	sockfd = create_socket(_metadata);
+	ASSERT_LE(0, sockfd);
+
+	/* Binds the socket to address with port[0] */
+	ASSERT_EQ(0, bind(sockfd, (struct sockaddr *)&addr[0], sizeof(addr[0])));
+
+	/* Makes connection to socket with port[0] */
+	ASSERT_EQ(0, connect(sockfd, (struct sockaddr *)&addr[0],
+						   sizeof(addr[0])));
+
+	/* Closes socket */
+	ASSERT_EQ(0, close(sockfd));
+}
+
 TEST_HARNESS_MAIN
--
2.25.1

