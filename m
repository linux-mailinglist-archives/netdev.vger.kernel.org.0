Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 575BC4D305A
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 14:48:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232965AbiCINqd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 08:46:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232940AbiCINqa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 08:46:30 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2AF917B8AB;
        Wed,  9 Mar 2022 05:45:22 -0800 (PST)
Received: from fraeml704-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4KDD2s1GqCz67bVT;
        Wed,  9 Mar 2022 21:44:53 +0800 (CST)
Received: from mscphispre00059.huawei.com (10.123.71.64) by
 fraeml704-chm.china.huawei.com (10.206.15.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.21; Wed, 9 Mar 2022 14:45:20 +0100
From:   Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
To:     <mic@digikod.net>
CC:     <willemdebruijn.kernel@gmail.com>,
        <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
        <artem.kuzin@huawei.com>, <anton.sirazetdinov@huawei.com>
Subject: [RFC PATCH v4 09/15] landlock: TCP network hooks implementation
Date:   Wed, 9 Mar 2022 21:44:53 +0800
Message-ID: <20220309134459.6448-10-konstantin.meskhidze@huawei.com>
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

Support of socket_bind() and socket_connect() hooks.
Its possible to restrict binding and connecting of TCP
types of sockets to particular ports. Its just basic idea
how Landlock could support network confinement.

Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
---

Changes since v3:
* Split commit.
* Add SECURITY_NETWORK in config.
* Add IS_ENABLED(CONFIG_INET) if a kernel has no INET configuration.
* Add hook_socket_bind and hook_socket_connect hooks.

---
 security/landlock/Kconfig    |   1 +
 security/landlock/Makefile   |   2 +-
 security/landlock/net.c      | 180 +++++++++++++++++++++++++++++++++++
 security/landlock/net.h      |  22 +++++
 security/landlock/ruleset.h  |   6 ++
 security/landlock/setup.c    |   2 +
 security/landlock/syscalls.c |  61 +++++++++++-
 7 files changed, 271 insertions(+), 3 deletions(-)
 create mode 100644 security/landlock/net.c
 create mode 100644 security/landlock/net.h

diff --git a/security/landlock/Kconfig b/security/landlock/Kconfig
index 8e33c4e8ffb8..2741f97169a7 100644
--- a/security/landlock/Kconfig
+++ b/security/landlock/Kconfig
@@ -4,6 +4,7 @@ config SECURITY_LANDLOCK
 	bool "Landlock support"
 	depends on SECURITY && !ARCH_EPHEMERAL_INODES
 	select SECURITY_PATH
+	select SECURITY_NETWORK
 	help
 	  Landlock is a sandboxing mechanism that enables processes to restrict
 	  themselves (and their future children) by gradually enforcing
diff --git a/security/landlock/Makefile b/security/landlock/Makefile
index 7bbd2f413b3e..afa44baaa83a 100644
--- a/security/landlock/Makefile
+++ b/security/landlock/Makefile
@@ -1,4 +1,4 @@
 obj-$(CONFIG_SECURITY_LANDLOCK) := landlock.o

 landlock-y := setup.o syscalls.o object.o ruleset.o \
-	cred.o ptrace.o fs.o
+	cred.o ptrace.o fs.o net.o
diff --git a/security/landlock/net.c b/security/landlock/net.c
new file mode 100644
index 000000000000..7fbb857c39e2
--- /dev/null
+++ b/security/landlock/net.c
@@ -0,0 +1,180 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Landlock LSM - Network management and hooks
+ *
+ * Copyright (C) 2022 Huawei Tech. Co., Ltd.
+ * Author: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
+ *
+ */
+
+#include <linux/in.h>
+#include <linux/net.h>
+#include <linux/socket.h>
+#include <net/ipv6.h>
+
+#include "cred.h"
+#include "limits.h"
+#include "net.h"
+
+int landlock_append_net_rule(struct landlock_ruleset *const ruleset,
+			     u16 port, u32 access_rights)
+{
+	int err;
+
+	/* Transforms relative access rights to absolute ones. */
+	access_rights |= LANDLOCK_MASK_ACCESS_NET &
+			 ~landlock_get_net_access_mask(ruleset, 0);
+
+	mutex_lock(&ruleset->lock);
+	err = landlock_insert_rule(ruleset, NULL, (uintptr_t)port, access_rights,
+				   LANDLOCK_RULE_NET_SERVICE);
+	mutex_unlock(&ruleset->lock);
+
+	return err;
+}
+
+static int check_socket_access(const struct landlock_ruleset *const domain,
+			       u16 port, u32 access_request)
+{
+	bool allowed = false;
+	u64 layer_mask;
+	size_t i;
+
+	/* Make sure all layers can be checked. */
+	BUILD_BUG_ON(BITS_PER_TYPE(layer_mask) < LANDLOCK_MAX_NUM_LAYERS);
+
+	if (WARN_ON_ONCE(!domain))
+		return 0;
+	if (WARN_ON_ONCE(domain->num_layers < 1))
+		return -EACCES;
+
+	/*
+	 * Saves all layers handling a subset of requested
+	 * socket access rules.
+	 */
+	layer_mask = 0;
+	for (i = 0; i < domain->num_layers; i++) {
+		if (landlock_get_net_access_mask(domain, i) & access_request)
+			layer_mask |= BIT_ULL(i);
+	}
+	/* An access request not handled by the domain is allowed. */
+	if (layer_mask == 0)
+		return 0;
+
+	/*
+	 * We need to walk through all the hierarchy to not miss any relevant
+	 * restriction.
+	 */
+	layer_mask = landlock_unmask_layers(domain, NULL, port,
+					    access_request, layer_mask,
+					    LANDLOCK_RULE_NET_SERVICE);
+	if (layer_mask == 0)
+		allowed = true;
+
+	return allowed ? 0 : -EACCES;
+}
+
+static int hook_socket_bind(struct socket *sock, struct sockaddr *address, int addrlen)
+{
+#if IS_ENABLED(CONFIG_INET)
+	short socket_type;
+	struct sockaddr_in *sockaddr;
+	struct sockaddr_in6 *sockaddr_ip6;
+	u16 port;
+	const struct landlock_ruleset *const dom = landlock_get_current_domain();
+
+	if (!dom)
+		return 0;
+
+	/* Check if the hook is AF_INET* socket's action */
+	if ((address->sa_family != AF_INET) && (address->sa_family != AF_INET6))
+		return 0;
+
+	socket_type = sock->type;
+	/* Check if it's a TCP socket */
+	if (socket_type != SOCK_STREAM)
+		return 0;
+
+	/* Get port value in host byte order */
+	switch (address->sa_family) {
+	case AF_INET:
+		sockaddr = (struct sockaddr_in *)address;
+		port = ntohs(sockaddr->sin_port);
+		break;
+	case AF_INET6:
+		sockaddr_ip6 = (struct sockaddr_in6 *)address;
+		port = ntohs(sockaddr_ip6->sin6_port);
+		break;
+	}
+
+	return check_socket_access(dom, port, LANDLOCK_ACCESS_NET_BIND_TCP);
+#else
+	return 0;
+#endif
+}
+
+static int hook_socket_connect(struct socket *sock, struct sockaddr *address, int addrlen)
+{
+#if IS_ENABLED(CONFIG_INET)
+	short socket_type;
+	struct sockaddr_in *sockaddr;
+	struct sockaddr_in6 *sockaddr_ip6;
+	u16 port;
+	const struct landlock_ruleset *const dom = landlock_get_current_domain();
+
+	if (!dom)
+		return 0;
+
+	/* Check if the hook is AF_INET* socket's action */
+	if ((address->sa_family != AF_INET) && (address->sa_family != AF_INET6)) {
+		/* Check if the socket_connect() hook has AF_UNSPEC flag*/
+		if (address->sa_family == AF_UNSPEC) {
+			u16 i;
+			/*
+			 * If just in a layer a mask supports connect access,
+			 * the socket_connect() hook with AF_UNSPEC family flag
+			 * must be banned. This prevents from disconnecting already
+			 * connected sockets.
+			 */
+			for (i = 0; i < dom->num_layers; i++) {
+				if (landlock_get_net_access_mask(dom, i) &
+							LANDLOCK_ACCESS_NET_CONNECT_TCP)
+					return -EACCES;
+			}
+		}
+		return 0;
+	}
+
+	socket_type = sock->type;
+	/* Check if it's a TCP socket */
+	if (socket_type != SOCK_STREAM)
+		return 0;
+
+	/* Get port value in host byte order */
+	switch (address->sa_family) {
+	case AF_INET:
+		sockaddr = (struct sockaddr_in *)address;
+		port = ntohs(sockaddr->sin_port);
+		break;
+	case AF_INET6:
+		sockaddr_ip6 = (struct sockaddr_in6 *)address;
+		port = ntohs(sockaddr_ip6->sin6_port);
+		break;
+	}
+
+	return check_socket_access(dom, port, LANDLOCK_ACCESS_NET_CONNECT_TCP);
+#else
+	return 0;
+#endif
+}
+
+static struct security_hook_list landlock_hooks[] __lsm_ro_after_init = {
+	LSM_HOOK_INIT(socket_bind, hook_socket_bind),
+	LSM_HOOK_INIT(socket_connect, hook_socket_connect),
+};
+
+__init void landlock_add_net_hooks(void)
+{
+	security_add_hooks(landlock_hooks, ARRAY_SIZE(landlock_hooks),
+			LANDLOCK_NAME);
+}
diff --git a/security/landlock/net.h b/security/landlock/net.h
new file mode 100644
index 000000000000..345bdc1dc84f
--- /dev/null
+++ b/security/landlock/net.h
@@ -0,0 +1,22 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Landlock LSM - Network management and hooks
+ *
+ * Copyright (C) 2022 Huawei Tech. Co., Ltd.
+ * Author: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
+ *
+ */
+
+#ifndef _SECURITY_LANDLOCK_NET_H
+#define _SECURITY_LANDLOCK_NET_H
+
+#include "common.h"
+#include "ruleset.h"
+#include "setup.h"
+
+__init void landlock_add_net_hooks(void);
+
+int landlock_append_net_rule(struct landlock_ruleset *const ruleset,
+			     u16 port, u32 access_hierarchy);
+
+#endif /* _SECURITY_LANDLOCK_NET_H */
diff --git a/security/landlock/ruleset.h b/security/landlock/ruleset.h
index abf3e09a65cd..74e9d3d26bd6 100644
--- a/security/landlock/ruleset.h
+++ b/security/landlock/ruleset.h
@@ -193,6 +193,12 @@ void landlock_set_fs_access_mask(struct landlock_ruleset *ruleset,

 u32 landlock_get_fs_access_mask(const struct landlock_ruleset *ruleset, u16 mask_level);

+void landlock_set_net_access_mask(struct landlock_ruleset *ruleset,
+				  const struct landlock_access_mask *access_mask_set,
+				  u16 mask_level);
+
+u32 landlock_get_net_access_mask(const struct landlock_ruleset *ruleset, u16 mask_level);
+
 u64 landlock_unmask_layers(const struct landlock_ruleset *const domain,
 			   const struct landlock_object *object_ptr,
 			   const u16 port, const u32 access_request,
diff --git a/security/landlock/setup.c b/security/landlock/setup.c
index f8e8e980454c..8059dc0b47d3 100644
--- a/security/landlock/setup.c
+++ b/security/landlock/setup.c
@@ -14,6 +14,7 @@
 #include "fs.h"
 #include "ptrace.h"
 #include "setup.h"
+#include "net.h"

 bool landlock_initialized __lsm_ro_after_init = false;

@@ -28,6 +29,7 @@ static int __init landlock_init(void)
 	landlock_add_cred_hooks();
 	landlock_add_ptrace_hooks();
 	landlock_add_fs_hooks();
+	landlock_add_net_hooks();
 	landlock_initialized = true;
 	pr_info("Up and running.\n");
 	return 0;
diff --git a/security/landlock/syscalls.c b/security/landlock/syscalls.c
index b91455a19356..2d45ea94e6d2 100644
--- a/security/landlock/syscalls.c
+++ b/security/landlock/syscalls.c
@@ -29,6 +29,7 @@
 #include "cred.h"
 #include "fs.h"
 #include "limits.h"
+#include "net.h"
 #include "ruleset.h"
 #include "setup.h"

@@ -73,7 +74,8 @@ static void build_check_abi(void)
 {
 	struct landlock_ruleset_attr ruleset_attr;
 	struct landlock_path_beneath_attr path_beneath_attr;
-	size_t ruleset_size, path_beneath_size;
+	struct landlock_net_service_attr net_service_attr;
+	size_t ruleset_size, path_beneath_size, net_service_size;

 	/*
 	 * For each user space ABI structures, first checks that there is no
@@ -89,6 +91,11 @@ static void build_check_abi(void)
 	path_beneath_size += sizeof(path_beneath_attr.parent_fd);
 	BUILD_BUG_ON(sizeof(path_beneath_attr) != path_beneath_size);
 	BUILD_BUG_ON(sizeof(path_beneath_attr) != 12);
+
+	net_service_size = sizeof(net_service_attr.allowed_access);
+	net_service_size += sizeof(net_service_attr.port);
+	BUILD_BUG_ON(sizeof(net_service_attr) != net_service_size);
+	BUILD_BUG_ON(sizeof(net_service_attr) != 10);
 }

 /* Ruleset handling */
@@ -311,7 +318,6 @@ static int add_rule_path_beneath(const int ruleset_fd, const void *const rule_at
 	 * Checks that allowed_access matches the @ruleset constraints
 	 * (ruleset->access_masks[0] is automatically upgraded to 64-bits).
 	 */
-
 	if ((path_beneath_attr.allowed_access | landlock_get_fs_access_mask(ruleset, 0)) !=
 						landlock_get_fs_access_mask(ruleset, 0)) {
 		err = -EINVAL;
@@ -333,6 +339,50 @@ static int add_rule_path_beneath(const int ruleset_fd, const void *const rule_at
 	return err;
 }

+static int add_rule_net_service(const int ruleset_fd, const void *const rule_attr)
+{
+	struct landlock_net_service_attr  net_service_attr;
+	struct landlock_ruleset *ruleset;
+	int res, err;
+
+	/* Copies raw user space buffer, only one type for now. */
+	res = copy_from_user(&net_service_attr, rule_attr,
+			sizeof(net_service_attr));
+	if (res)
+		return -EFAULT;
+
+	/* Gets and checks the ruleset. */
+	ruleset = get_ruleset_from_fd(ruleset_fd, FMODE_CAN_WRITE);
+	if (IS_ERR(ruleset))
+		return PTR_ERR(ruleset);
+
+	/*
+	 * Informs about useless rule: empty allowed_access (i.e. deny rules)
+	 * are ignored by network actions
+	 */
+	if (!net_service_attr.allowed_access) {
+		err = -ENOMSG;
+		goto out_put_ruleset;
+	}
+	/*
+	 * Checks that allowed_access matches the @ruleset constraints
+	 * (ruleset->access_masks[0] is automatically upgraded to 64-bits).
+	 */
+	if ((net_service_attr.allowed_access | landlock_get_net_access_mask(ruleset, 0)) !=
+					       landlock_get_net_access_mask(ruleset, 0)) {
+		err = -EINVAL;
+		goto out_put_ruleset;
+	}
+
+	/* Imports the new rule. */
+	err = landlock_append_net_rule(ruleset, net_service_attr.port,
+				       net_service_attr.allowed_access);
+
+out_put_ruleset:
+	landlock_put_ruleset(ruleset);
+	return err;
+}
+
 /**
  * sys_landlock_add_rule - Add a new rule to a ruleset
  *
@@ -379,6 +429,13 @@ SYSCALL_DEFINE4(landlock_add_rule,
 	case LANDLOCK_RULE_PATH_BENEATH:
 		err = add_rule_path_beneath(ruleset_fd, rule_attr);
 		break;
+	case LANDLOCK_RULE_NET_SERVICE:
+#if IS_ENABLED(CONFIG_INET)
+		err = add_rule_net_service(ruleset_fd, rule_attr);
+#else
+		err = -EOPNOTSUPP;
+#endif
+		break;
 	default:
 		err = -EINVAL;
 	}
--
2.25.1

