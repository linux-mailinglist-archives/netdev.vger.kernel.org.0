Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14E7F5288A2
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 17:23:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245247AbiEPPVo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 11:21:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245291AbiEPPVM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 11:21:12 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96C4310571;
        Mon, 16 May 2022 08:21:11 -0700 (PDT)
Received: from fraeml704-chm.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4L22tK2Cy7z67Zm5;
        Mon, 16 May 2022 23:17:29 +0800 (CST)
Received: from mscphispre00059.huawei.com (10.123.71.64) by
 fraeml704-chm.china.huawei.com (10.206.15.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2375.24; Mon, 16 May 2022 17:21:09 +0200
From:   Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
To:     <mic@digikod.net>
CC:     <willemdebruijn.kernel@gmail.com>,
        <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
        <anton.sirazetdinov@huawei.com>
Subject: [PATCH v5 14/15] seltests/landlock: invalid user input data test
Date:   Mon, 16 May 2022 23:20:37 +0800
Message-ID: <20220516152038.39594-15-konstantin.meskhidze@huawei.com>
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

This patch adds rules with invalid user space
supplied data:
    - unhandled allowed access;
    - zero port value;
    - zero access value;

Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
---

Changes since v3:
* Add inval test.

Changes since v4:
* Refactoring code with self->port variable.

---
 tools/testing/selftests/landlock/net_test.c | 52 +++++++++++++++++++++
 1 file changed, 52 insertions(+)

diff --git a/tools/testing/selftests/landlock/net_test.c b/tools/testing/selftests/landlock/net_test.c
index b1639a55a898..ca4b7a7256e8 100644
--- a/tools/testing/selftests/landlock/net_test.c
+++ b/tools/testing/selftests/landlock/net_test.c
@@ -880,4 +880,56 @@ TEST_F_FORK(socket_test, ruleset_expanding) {
 	/* Closes socket 1 */
 	ASSERT_EQ(0, close(sockfd_1));
 }
+
+TEST_F_FORK(socket_test, inval) {
+
+	struct landlock_ruleset_attr ruleset_attr = {
+		.handled_access_net = LANDLOCK_ACCESS_NET_BIND_TCP
+	};
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
+	/* Gets ruleset. */
+	const int ruleset_fd = landlock_create_ruleset(&ruleset_attr,
+			sizeof(ruleset_attr), 0);
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
+					&net_service_4, 0));
+
+	/* Enforces the ruleset. */
+	enforce_ruleset(_metadata, ruleset_fd);
+	ASSERT_EQ(0, close(ruleset_fd));
+}
 TEST_HARNESS_MAIN
--
2.25.1

