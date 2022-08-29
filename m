Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9B6B5A5299
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 19:04:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231296AbiH2REx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 13:04:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231293AbiH2REg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 13:04:36 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B5619C1F6;
        Mon, 29 Aug 2022 10:04:22 -0700 (PDT)
Received: from fraeml710-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4MGcBw4jtpz67Klm;
        Tue, 30 Aug 2022 01:00:40 +0800 (CST)
Received: from lhrpeml500004.china.huawei.com (7.191.163.9) by
 fraeml710-chm.china.huawei.com (10.206.15.59) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 29 Aug 2022 19:04:19 +0200
Received: from mscphis00759.huawei.com (10.123.66.134) by
 lhrpeml500004.china.huawei.com (7.191.163.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 29 Aug 2022 18:04:19 +0100
From:   Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
To:     <mic@digikod.net>
CC:     <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
        <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
        <hukeping@huawei.com>, <anton.sirazetdinov@huawei.com>
Subject: [PATCH v7 07/18] landlock: user space API network support
Date:   Tue, 30 Aug 2022 01:03:50 +0800
Message-ID: <20220829170401.834298-8-konstantin.meskhidze@huawei.com>
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

Refactors user space API to support network actions. Adds new network
access flags, network rule and network attributes.

Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
---

Changes since v6:
* None.

Changes since v5:
* Formats code with clang-format-14.

Changes since v4:
* None

Changes since v3:
* Splits commit.
* Refactors User API for network rule type.

---
 include/uapi/linux/landlock.h | 49 +++++++++++++++++++++++++++++++++++
 security/landlock/syscalls.c  |  3 ++-
 2 files changed, 51 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/landlock.h b/include/uapi/linux/landlock.h
index 735b1fe8326e..1ce2be6a78af 100644
--- a/include/uapi/linux/landlock.h
+++ b/include/uapi/linux/landlock.h
@@ -31,6 +31,13 @@ struct landlock_ruleset_attr {
 	 * this access right.
 	 */
 	__u64 handled_access_fs;
+
+	/**
+	 * @handled_access_net: Bitmask of actions (cf. `Network flags`_)
+	 * that is handled by this ruleset and should then be forbidden if no
+	 * rule explicitly allow them.
+	 */
+	__u64 handled_access_net;
 };

 /*
@@ -54,6 +61,11 @@ enum landlock_rule_type {
 	 * landlock_path_beneath_attr .
 	 */
 	LANDLOCK_RULE_PATH_BENEATH = 1,
+	/**
+	 * @LANDLOCK_RULE_NET_SERVICE: Type of a &struct
+	 * landlock_net_service_attr .
+	 */
+	LANDLOCK_RULE_NET_SERVICE = 2,
 };

 /**
@@ -79,6 +91,24 @@ struct landlock_path_beneath_attr {
 	 */
 } __attribute__((packed));

+/**
+ * struct landlock_net_service_attr - TCP subnet definition
+ *
+ * Argument of sys_landlock_add_rule().
+ */
+struct landlock_net_service_attr {
+	/**
+	 * @allowed_access: Bitmask of allowed access network for services
+	 * (cf. `Network flags`_).
+	 */
+	__u64 allowed_access;
+	/**
+	 * @port: Network port.
+	 */
+	__u16 port;
+
+} __attribute__((packed));
+
 /**
  * DOC: fs_access
  *
@@ -169,4 +199,23 @@ struct landlock_path_beneath_attr {
 #define LANDLOCK_ACCESS_FS_TRUNCATE			(1ULL << 14)
 /* clang-format on */

+/**
+ * DOC: net_access
+ *
+ * Network flags
+ * ~~~~~~~~~~~~~~~~
+ *
+ * These flags enable to restrict a sandboxed process to a set of network
+ * actions.
+ *
+ * TCP sockets with allowed actions:
+ *
+ * - %LANDLOCK_ACCESS_NET_BIND_TCP: Bind a TCP socket to a local port.
+ * - %LANDLOCK_ACCESS_NET_CONNECT_TCP: Connect an active TCP socket to
+ *   a remote port.
+ */
+/* clang-format off */
+#define LANDLOCK_ACCESS_NET_BIND_TCP			(1ULL << 0)
+#define LANDLOCK_ACCESS_NET_CONNECT_TCP			(1ULL << 1)
+/* clang-format on */
 #endif /* _UAPI_LINUX_LANDLOCK_H */
diff --git a/security/landlock/syscalls.c b/security/landlock/syscalls.c
index 28acc4cef3e8..ffd5805eddd9 100644
--- a/security/landlock/syscalls.c
+++ b/security/landlock/syscalls.c
@@ -82,8 +82,9 @@ static void build_check_abi(void)
 	 * struct size.
 	 */
 	ruleset_size = sizeof(ruleset_attr.handled_access_fs);
+	ruleset_size += sizeof(ruleset_attr.handled_access_net);
 	BUILD_BUG_ON(sizeof(ruleset_attr) != ruleset_size);
-	BUILD_BUG_ON(sizeof(ruleset_attr) != 8);
+	BUILD_BUG_ON(sizeof(ruleset_attr) != 16);

 	path_beneath_size = sizeof(path_beneath_attr.allowed_access);
 	path_beneath_size += sizeof(path_beneath_attr.parent_fd);
--
2.25.1

