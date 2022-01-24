Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB1624979EB
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 09:02:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241983AbiAXIC3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 03:02:29 -0500
Received: from frasgout.his.huawei.com ([185.176.79.56]:4442 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235469AbiAXICY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 03:02:24 -0500
Received: from fraeml704-chm.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Jj2WY0jcCz67tPK;
        Mon, 24 Jan 2022 16:02:01 +0800 (CST)
Received: from mscphispre00059.huawei.com (10.123.71.64) by
 fraeml704-chm.china.huawei.com (10.206.15.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.21; Mon, 24 Jan 2022 09:02:20 +0100
From:   Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
To:     <mic@digikod.net>
CC:     <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter@vger.kernel.org>, <yusongping@huawei.com>,
        <artem.kuzin@huawei.com>
Subject: [RFC PATCH 1/2] landlock: TCP network hooks implementation
Date:   Mon, 24 Jan 2022 16:02:14 +0800
Message-ID: <20220124080215.265538-2-konstantin.meskhidze@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220124080215.265538-1-konstantin.meskhidze@huawei.com>
References: <20220124080215.265538-1-konstantin.meskhidze@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.123.71.64]
X-ClientProxiedBy: mscpeml100002.china.huawei.com (7.188.26.75) To
 fraeml704-chm.china.huawei.com (10.206.15.53)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Support of socket_bind() and socket_connect() hooks.
Current prototype can restrict binding and connecting of TCP
types of sockets. Its just basic idea how Landlock could support
network confinement.

Changes:
1. Access masks array refactored into 1D one and changed
to 32 bits. Filesystem masks occupy 16 lower bits and network
masks reside in 16 upper bits.
2. Refactor API functions in ruleset.c:
    1. Add void *object argument.
    2. Add u16 rule_type argument.
3. Use two rb_trees in ruleset structure:
    1. root_inode - for filesystem objects
    2. root_net_port - for network port objects

Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
---
 include/uapi/linux/landlock.h |  52 ++++++++++
 security/landlock/Makefile    |   2 +-
 security/landlock/fs.c        |  12 ++-
 security/landlock/limits.h    |   6 ++
 security/landlock/net.c       | 175 ++++++++++++++++++++++++++++++++++
 security/landlock/net.h       |  21 ++++
 security/landlock/ruleset.c   | 167 +++++++++++++++++++++++---------
 security/landlock/ruleset.h   |  40 +++++---
 security/landlock/setup.c     |   3 +
 security/landlock/syscalls.c  | 142 +++++++++++++++++++--------
 10 files changed, 514 insertions(+), 106 deletions(-)
 create mode 100644 security/landlock/net.c
 create mode 100644 security/landlock/net.h

diff --git a/include/uapi/linux/landlock.h b/include/uapi/linux/landlock.h
index b3d952067f59..1745a3a2f7a9 100644
--- a/include/uapi/linux/landlock.h
+++ b/include/uapi/linux/landlock.h
@@ -25,6 +25,15 @@ struct landlock_ruleset_attr {
 	 * compatibility reasons.
 	 */
 	__u64 handled_access_fs;
+
+	/**
+	 * @handled_access_net: Bitmask of actions (cf. `Network flags`_)
+	 * that is handled by this ruleset and should then be forbidden if no
+	 * rule explicitly allow them.  This is needed for backward
+	 * compatibility reasons.
+	 */
+	__u64 handled_access_net;
+
 };
 
 /*
@@ -46,6 +55,12 @@ enum landlock_rule_type {
 	 * landlock_path_beneath_attr .
 	 */
 	LANDLOCK_RULE_PATH_BENEATH = 1,
+
+	/**
+	 * @LANDLOCK_RULE_NET_SERVICE: Type of a &struct
+	 * landlock_net_service_attr .
+	 */
+	LANDLOCK_RULE_NET_SERVICE = 2,
 };
 
 /**
@@ -70,6 +85,24 @@ struct landlock_path_beneath_attr {
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
+	 * @port: Network port
+	 */
+	__u16 port;
+
+} __attribute__((packed));
+
 /**
  * DOC: fs_access
  *
@@ -134,4 +167,23 @@ struct landlock_path_beneath_attr {
 #define LANDLOCK_ACCESS_FS_MAKE_BLOCK			(1ULL << 11)
 #define LANDLOCK_ACCESS_FS_MAKE_SYM			(1ULL << 12)
 
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
+ * - %LANDLOCK_ACCESS_NET_BIND_TCP: Bind a TCP socket to a IP address.
+ * - %LANDLOCK_ACCESS_NET_CONNECT_TCP: Connect an active TCP socket to
+ *   a listening one.
+ */
+#define LANDLOCK_ACCESS_NET_BIND_TCP			(1ULL << 0)
+#define LANDLOCK_ACCESS_NET_CONNECT_TCP			(1ULL << 1)
+
+
 #endif /* _UAPI_LINUX_LANDLOCK_H */
diff --git a/security/landlock/Makefile b/security/landlock/Makefile
index 7bbd2f413b3e..afa44baaa83a 100644
--- a/security/landlock/Makefile
+++ b/security/landlock/Makefile
@@ -1,4 +1,4 @@
 obj-$(CONFIG_SECURITY_LANDLOCK) := landlock.o
 
 landlock-y := setup.o syscalls.o object.o ruleset.o \
-	cred.o ptrace.o fs.o
+	cred.o ptrace.o fs.o net.o
diff --git a/security/landlock/fs.c b/security/landlock/fs.c
index 97b8e421f617..0cb2548157b5 100644
--- a/security/landlock/fs.c
+++ b/security/landlock/fs.c
@@ -163,12 +163,13 @@ int landlock_append_fs_rule(struct landlock_ruleset *const ruleset,
 		return -EINVAL;
 
 	/* Transforms relative access rights to absolute ones. */
-	access_rights |= LANDLOCK_MASK_ACCESS_FS & ~ruleset->fs_access_masks[0];
+	access_rights |= LANDLOCK_MASK_ACCESS_FS & ~ruleset->access_masks[0];
 	object = get_inode_object(d_backing_inode(path->dentry));
 	if (IS_ERR(object))
 		return PTR_ERR(object);
 	mutex_lock(&ruleset->lock);
-	err = landlock_insert_rule(ruleset, object, access_rights);
+	err = landlock_insert_rule(ruleset, object, access_rights,
+				   LANDLOCK_RULE_PATH_BENEATH);
 	mutex_unlock(&ruleset->lock);
 	/*
 	 * No need to check for an error because landlock_insert_rule()
@@ -195,7 +196,8 @@ static inline u64 unmask_layers(
 	inode = d_backing_inode(path->dentry);
 	rcu_read_lock();
 	rule = landlock_find_rule(domain,
-			rcu_dereference(landlock_inode(inode)->object));
+			rcu_dereference(landlock_inode(inode)->object),
+			LANDLOCK_RULE_PATH_BENEATH);
 	rcu_read_unlock();
 	if (!rule)
 		return layer_mask;
@@ -229,6 +231,7 @@ static int check_access_path(const struct landlock_ruleset *const domain,
 	struct path walker_path;
 	u64 layer_mask;
 	size_t i;
+	u8 rule_fs_type;
 
 	/* Make sure all layers can be checked. */
 	BUILD_BUG_ON(BITS_PER_TYPE(layer_mask) < LANDLOCK_MAX_NUM_LAYERS);
@@ -249,10 +252,11 @@ static int check_access_path(const struct landlock_ruleset *const domain,
 	if (WARN_ON_ONCE(domain->num_layers < 1))
 		return -EACCES;
 
+	rule_fs_type = LANDLOCK_RULE_PATH_BENEATH - 1;
 	/* Saves all layers handling a subset of requested accesses. */
 	layer_mask = 0;
 	for (i = 0; i < domain->num_layers; i++) {
-		if (domain->fs_access_masks[i] & access_request)
+		if (domain->access_masks[i] & access_request)
 			layer_mask |= BIT_ULL(i);
 	}
 	/* An access request not handled by the domain is allowed. */
diff --git a/security/landlock/limits.h b/security/landlock/limits.h
index 2a0a1095ee27..fdbef85e4de0 100644
--- a/security/landlock/limits.h
+++ b/security/landlock/limits.h
@@ -18,4 +18,10 @@
 #define LANDLOCK_LAST_ACCESS_FS		LANDLOCK_ACCESS_FS_MAKE_SYM
 #define LANDLOCK_MASK_ACCESS_FS		((LANDLOCK_LAST_ACCESS_FS << 1) - 1)
 
+#define LANDLOCK_LAST_ACCESS_NET	LANDLOCK_ACCESS_NET_CONNECT_TCP
+#define LANDLOCK_MASK_ACCESS_NET	((LANDLOCK_LAST_ACCESS_NET << 1) - 1)
+#define LANDLOCK_MASK_SHIFT_NET		16
+
+#define LANDLOCK_RULE_TYPE_NUM		LANDLOCK_RULE_NET_SERVICE
+
 #endif /* _SECURITY_LANDLOCK_LIMITS_H */
diff --git a/security/landlock/net.c b/security/landlock/net.c
new file mode 100644
index 000000000000..0b5323d254a7
--- /dev/null
+++ b/security/landlock/net.c
@@ -0,0 +1,175 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Landlock LSM - Filesystem management and hooks
+ *
+ * Copyright © 2016-2020 Mickaël Salaün <mic@digikod.net>
+ * Copyright © 2018-2020 ANSSI
+ */
+
+#include <linux/socket.h>
+#include <linux/net.h>
+#include <linux/in.h>
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
+	access_rights |= LANDLOCK_MASK_ACCESS_NET & ~(ruleset->access_masks[0] >>
+							LANDLOCK_MASK_SHIFT_NET);
+
+	mutex_lock(&ruleset->lock);
+	err = landlock_insert_rule(ruleset, (void *)port, access_rights,
+				   LANDLOCK_RULE_NET_SERVICE);
+	mutex_unlock(&ruleset->lock);
+
+	return err;
+}
+
+/* Access-control management */
+static inline bool unmask_layers(
+		const struct landlock_ruleset *const domain,
+		const u16 port, const u32 access_request, u64 layer_mask)
+{
+	const struct landlock_rule *rule;
+	size_t i;
+	bool allowed = false;
+
+	rule = landlock_find_rule(domain, (void *)port,
+				  LANDLOCK_RULE_NET_SERVICE);
+
+	/* Grant access if there is no rule for an oject */
+	if (!rule)
+		return allowed = true;
+
+	/*
+	 * An access is granted if, for each policy layer, at least one rule
+	 * encountered on network actions requested,
+	 * regardless of their position in the layer stack. We must then check
+	 * the remaining layers, from the first added layer to
+	 * the last one.
+	 */
+	for (i = 0; i < rule->num_layers; i++) {
+		const struct landlock_layer *const layer = &rule->layers[i];
+		const u64 layer_level = BIT_ULL(layer->level - 1);
+
+		/* Checks that the layer grants access to the request. */
+		if ((layer->access & access_request) == access_request) {
+			layer_mask &= ~layer_level;
+			allowed = true;
+
+			if (layer_mask == 0)
+				return allowed;
+		} else {
+			layer_mask &= ~layer_level;
+
+			if (layer_mask == 0)
+				return allowed;
+		}
+	}
+	return allowed;
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
+	/* Saves all layers handling a subset of requested
+	 * socket access rules.
+	 */
+	layer_mask = 0;
+	for (i = 0; i < domain->num_layers; i++) {
+		if ((domain->access_masks[i] >> LANDLOCK_MASK_SHIFT_NET) & access_request)
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
+	allowed = unmask_layers(domain, port, access_request, layer_mask);
+
+	return allowed ? 0 : -EACCES;
+}
+
+static int hook_socket_bind(struct socket *sock, struct sockaddr *address, int addrlen)
+{
+	short socket_type;
+	struct sockaddr_in *sockaddr;
+	u16 port;
+	const struct landlock_ruleset *const dom = landlock_get_current_domain();
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
+	if (!dom)
+		return 0;
+
+	/* Get port value in host byte order */
+	sockaddr = (struct sockaddr_in *)address;
+	port = ntohs(sockaddr->sin_port);
+
+	return check_socket_access(dom, port, LANDLOCK_ACCESS_NET_BIND_TCP);
+}
+
+static int hook_socket_connect(struct socket *sock, struct sockaddr *address, int addrlen)
+{
+	short socket_type;
+	struct sockaddr_in *sockaddr;
+	u16 port;
+	const struct landlock_ruleset *const dom = landlock_get_current_domain();
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
+	if (!dom)
+		return 0;
+
+	/* Get port value in host byte order */
+	sockaddr = (struct sockaddr_in *)address;
+	port = ntohs(sockaddr->sin_port);
+
+	return check_socket_access(dom, port, LANDLOCK_ACCESS_NET_CONNECT_TCP);
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
index 000000000000..cd081808716a
--- /dev/null
+++ b/security/landlock/net.h
@@ -0,0 +1,21 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Landlock LSM - Network management and hooks
+ *
+ * Copyright © 2017-2020 Mickaël Salaün <mic@digikod.net>
+ * Copyright © 2018-2020 ANSSI
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
diff --git a/security/landlock/ruleset.c b/security/landlock/ruleset.c
index ec72b9262bf3..d7e49842b299 100644
--- a/security/landlock/ruleset.c
+++ b/security/landlock/ruleset.c
@@ -28,32 +28,41 @@ static struct landlock_ruleset *create_ruleset(const u32 num_layers)
 {
 	struct landlock_ruleset *new_ruleset;
 
-	new_ruleset = kzalloc(struct_size(new_ruleset, fs_access_masks,
+	new_ruleset = kzalloc(struct_size(new_ruleset, access_masks,
 				num_layers), GFP_KERNEL_ACCOUNT);
+
 	if (!new_ruleset)
 		return ERR_PTR(-ENOMEM);
 	refcount_set(&new_ruleset->usage, 1);
 	mutex_init(&new_ruleset->lock);
-	new_ruleset->root = RB_ROOT;
+	new_ruleset->root_inode = RB_ROOT;
+	new_ruleset->root_net_port = RB_ROOT;
 	new_ruleset->num_layers = num_layers;
 	/*
 	 * hierarchy = NULL
 	 * num_rules = 0
-	 * fs_access_masks[] = 0
+	 * access_masks[] = 0
 	 */
 	return new_ruleset;
 }
 
-struct landlock_ruleset *landlock_create_ruleset(const u32 fs_access_mask)
+struct landlock_ruleset *landlock_create_ruleset(const u32 fs_access_mask,
+						 const u32 net_access_mask)
 {
 	struct landlock_ruleset *new_ruleset;
 
 	/* Informs about useless ruleset. */
-	if (!fs_access_mask)
+	if (!fs_access_mask && !net_access_mask)
 		return ERR_PTR(-ENOMSG);
 	new_ruleset = create_ruleset(1);
-	if (!IS_ERR(new_ruleset))
-		new_ruleset->fs_access_masks[0] = fs_access_mask;
+
+	if (!IS_ERR(new_ruleset) && fs_access_mask)
+		new_ruleset->access_masks[0] = fs_access_mask;
+
+	/* Add network mask by shifting it to upper 16 bits of access_masks */
+	if (!IS_ERR(new_ruleset) && net_access_mask)
+		new_ruleset->access_masks[0] |= (net_access_mask << LANDLOCK_MASK_SHIFT_NET);
+
 	return new_ruleset;
 }
 
@@ -67,10 +76,11 @@ static void build_check_rule(void)
 }
 
 static struct landlock_rule *create_rule(
-		struct landlock_object *const object,
+		void *const object,
 		const struct landlock_layer (*const layers)[],
 		const u32 num_layers,
-		const struct landlock_layer *const new_layer)
+		const struct landlock_layer *const new_layer,
+		const u16 rule_type)
 {
 	struct landlock_rule *new_rule;
 	u32 new_num_layers;
@@ -89,8 +99,11 @@ static struct landlock_rule *create_rule(
 	if (!new_rule)
 		return ERR_PTR(-ENOMEM);
 	RB_CLEAR_NODE(&new_rule->node);
-	landlock_get_object(object);
-	new_rule->object = object;
+
+	if (rule_type == LANDLOCK_RULE_PATH_BENEATH)
+		landlock_get_object(object);
+
+	new_rule->object.ptr = object;
 	new_rule->num_layers = new_num_layers;
 	/* Copies the original layer stack. */
 	memcpy(new_rule->layers, layers,
@@ -101,12 +114,13 @@ static struct landlock_rule *create_rule(
 	return new_rule;
 }
 
-static void free_rule(struct landlock_rule *const rule)
+static void free_rule(struct landlock_rule *const rule, const u16 rule_type)
 {
 	might_sleep();
 	if (!rule)
 		return;
-	landlock_put_object(rule->object);
+	if (rule_type == LANDLOCK_RULE_PATH_BENEATH)
+		landlock_put_object(rule->object.ptr);
 	kfree(rule);
 }
 
@@ -116,11 +130,14 @@ static void build_check_ruleset(void)
 		.num_rules = ~0,
 		.num_layers = ~0,
 	};
-	typeof(ruleset.fs_access_masks[0]) fs_access_mask = ~0;
+
+	typeof(ruleset.access_masks[0]) fs_access_mask = ~0;
+	typeof(ruleset.access_masks[0]) net_access_mask = ~0;
 
 	BUILD_BUG_ON(ruleset.num_rules < LANDLOCK_MAX_NUM_RULES);
 	BUILD_BUG_ON(ruleset.num_layers < LANDLOCK_MAX_NUM_LAYERS);
 	BUILD_BUG_ON(fs_access_mask < LANDLOCK_MASK_ACCESS_FS);
+	BUILD_BUG_ON(net_access_mask < LANDLOCK_MASK_ACCESS_NET);
 }
 
 /**
@@ -142,26 +159,36 @@ static void build_check_ruleset(void)
  * access rights.
  */
 static int insert_rule(struct landlock_ruleset *const ruleset,
-		struct landlock_object *const object,
-		const struct landlock_layer (*const layers)[],
-		size_t num_layers)
+		void *const obj, const struct landlock_layer (*const layers)[],
+		size_t num_layers, const u16 rule_type)
 {
 	struct rb_node **walker_node;
 	struct rb_node *parent_node = NULL;
 	struct landlock_rule *new_rule;
+	struct landlock_object *object;
+	struct rb_root *root;
 
 	might_sleep();
 	lockdep_assert_held(&ruleset->lock);
-	if (WARN_ON_ONCE(!object || !layers))
+	if (WARN_ON_ONCE(!obj || !layers))
 		return -ENOENT;
-	walker_node = &(ruleset->root.rb_node);
+	object = (struct landlock_object *)obj;
+	/* Choose rb_tree structure depending on a rule type */
+	if (rule_type == LANDLOCK_RULE_PATH_BENEATH)
+		root = &ruleset->root_inode;
+	else if (rule_type == LANDLOCK_RULE_NET_SERVICE)
+		root = &ruleset->root_net_port;
+	else
+		return -EINVAL;
+
+	walker_node = &root->rb_node;
 	while (*walker_node) {
 		struct landlock_rule *const this = rb_entry(*walker_node,
 				struct landlock_rule, node);
 
-		if (this->object != object) {
+		if (this->object.ptr != object) {
 			parent_node = *walker_node;
-			if (this->object < object)
+			if (this->object.ptr < object)
 				walker_node = &((*walker_node)->rb_right);
 			else
 				walker_node = &((*walker_node)->rb_left);
@@ -194,11 +221,11 @@ static int insert_rule(struct landlock_ruleset *const ruleset,
 		 * ruleset and a domain.
 		 */
 		new_rule = create_rule(object, &this->layers, this->num_layers,
-				&(*layers)[0]);
+				&(*layers)[0], rule_type);
 		if (IS_ERR(new_rule))
 			return PTR_ERR(new_rule);
-		rb_replace_node(&this->node, &new_rule->node, &ruleset->root);
-		free_rule(this);
+		rb_replace_node(&this->node, &new_rule->node, root);
+		free_rule(this, rule_type);
 		return 0;
 	}
 
@@ -206,11 +233,11 @@ static int insert_rule(struct landlock_ruleset *const ruleset,
 	build_check_ruleset();
 	if (ruleset->num_rules >= LANDLOCK_MAX_NUM_RULES)
 		return -E2BIG;
-	new_rule = create_rule(object, layers, num_layers, NULL);
+	new_rule = create_rule(object, layers, num_layers, NULL, rule_type);
 	if (IS_ERR(new_rule))
 		return PTR_ERR(new_rule);
 	rb_link_node(&new_rule->node, parent_node, walker_node);
-	rb_insert_color(&new_rule->node, &ruleset->root);
+	rb_insert_color(&new_rule->node, root);
 	ruleset->num_rules++;
 	return 0;
 }
@@ -228,7 +255,8 @@ static void build_check_layer(void)
 
 /* @ruleset must be locked by the caller. */
 int landlock_insert_rule(struct landlock_ruleset *const ruleset,
-		struct landlock_object *const object, const u32 access)
+			 void *const object, const u32 access,
+			 const u16 rule_type)
 {
 	struct landlock_layer layers[] = {{
 		.access = access,
@@ -237,7 +265,7 @@ int landlock_insert_rule(struct landlock_ruleset *const ruleset,
 	}};
 
 	build_check_layer();
-	return insert_rule(ruleset, object, &layers, ARRAY_SIZE(layers));
+	return insert_rule(ruleset, object, &layers, ARRAY_SIZE(layers), rule_type);
 }
 
 static inline void get_hierarchy(struct landlock_hierarchy *const hierarchy)
@@ -279,11 +307,13 @@ static int merge_ruleset(struct landlock_ruleset *const dst,
 		err = -EINVAL;
 		goto out_unlock;
 	}
-	dst->fs_access_masks[dst->num_layers - 1] = src->fs_access_masks[0];
+
+	/* Copy access masks. */
+	dst->access_masks[dst->num_layers - 1] = src->access_masks[0];
 
 	/* Merges the @src tree. */
 	rbtree_postorder_for_each_entry_safe(walker_rule, next_rule,
-			&src->root, node) {
+			&src->root_inode, node) {
 		struct landlock_layer layers[] = {{
 			.level = dst->num_layers,
 		}};
@@ -297,8 +327,30 @@ static int merge_ruleset(struct landlock_ruleset *const dst,
 			goto out_unlock;
 		}
 		layers[0].access = walker_rule->layers[0].access;
-		err = insert_rule(dst, walker_rule->object, &layers,
-				ARRAY_SIZE(layers));
+		err = insert_rule(dst, walker_rule->object.ptr, &layers,
+				ARRAY_SIZE(layers), LANDLOCK_RULE_PATH_BENEATH);
+		if (err)
+			goto out_unlock;
+	}
+
+	/* Merges the @src tree. */
+	rbtree_postorder_for_each_entry_safe(walker_rule, next_rule,
+			&src->root_net_port, node) {
+		struct landlock_layer layers[] = {{
+			.level = dst->num_layers,
+		}};
+
+		if (WARN_ON_ONCE(walker_rule->num_layers != 1)) {
+			err = -EINVAL;
+			goto out_unlock;
+		}
+		if (WARN_ON_ONCE(walker_rule->layers[0].level != 0)) {
+			err = -EINVAL;
+			goto out_unlock;
+		}
+		layers[0].access = walker_rule->layers[0].access;
+		err = insert_rule(dst, walker_rule->object.ptr, &layers,
+				ARRAY_SIZE(layers), LANDLOCK_RULE_NET_SERVICE);
 		if (err)
 			goto out_unlock;
 	}
@@ -325,9 +377,20 @@ static int inherit_ruleset(struct landlock_ruleset *const parent,
 
 	/* Copies the @parent tree. */
 	rbtree_postorder_for_each_entry_safe(walker_rule, next_rule,
-			&parent->root, node) {
-		err = insert_rule(child, walker_rule->object,
-				&walker_rule->layers, walker_rule->num_layers);
+			&parent->root_inode, node) {
+		err = insert_rule(child, walker_rule->object.ptr,
+				&walker_rule->layers, walker_rule->num_layers,
+				LANDLOCK_RULE_PATH_BENEATH);
+		if (err)
+			goto out_unlock;
+	}
+
+	/* Copies the @parent tree. */
+	rbtree_postorder_for_each_entry_safe(walker_rule, next_rule,
+			&parent->root_net_port, node) {
+		err = insert_rule(child, walker_rule->object.ptr,
+				&walker_rule->layers, walker_rule->num_layers,
+				LANDLOCK_RULE_NET_SERVICE);
 		if (err)
 			goto out_unlock;
 	}
@@ -336,9 +399,11 @@ static int inherit_ruleset(struct landlock_ruleset *const parent,
 		err = -EINVAL;
 		goto out_unlock;
 	}
-	/* Copies the parent layer stack and leaves a space for the new layer. */
-	memcpy(child->fs_access_masks, parent->fs_access_masks,
-			flex_array_size(parent, fs_access_masks, parent->num_layers));
+	/* Copies the parent layer stack and leaves a space for the new layer.
+	 * Remember to copy num_layers*num_tule_types size.
+	 */
+	memcpy(child->access_masks, parent->access_masks,
+			flex_array_size(parent, access_masks, parent->num_layers));
 
 	if (WARN_ON_ONCE(!parent->hierarchy)) {
 		err = -EINVAL;
@@ -358,9 +423,13 @@ static void free_ruleset(struct landlock_ruleset *const ruleset)
 	struct landlock_rule *freeme, *next;
 
 	might_sleep();
-	rbtree_postorder_for_each_entry_safe(freeme, next, &ruleset->root,
-			node)
-		free_rule(freeme);
+	rbtree_postorder_for_each_entry_safe(freeme, next, &ruleset->root_inode,
+					     node)
+		free_rule(freeme, LANDLOCK_RULE_PATH_BENEATH);
+	rbtree_postorder_for_each_entry_safe(freeme, next, &ruleset->root_net_port,
+					     node)
+		free_rule(freeme, LANDLOCK_RULE_NET_SERVICE);
+
 	put_hierarchy(ruleset->hierarchy);
 	kfree(ruleset);
 }
@@ -451,20 +520,26 @@ struct landlock_ruleset *landlock_merge_ruleset(
  */
 const struct landlock_rule *landlock_find_rule(
 		const struct landlock_ruleset *const ruleset,
-		const struct landlock_object *const object)
+		const void *const obj, const u16 rule_type)
 {
 	const struct rb_node *node;
+	const struct landlock_object *object;
 
-	if (!object)
+	if (!obj)
 		return NULL;
-	node = ruleset->root.rb_node;
+	object = (struct landlock_object *)obj;
+	if (rule_type == LANDLOCK_RULE_PATH_BENEATH)
+		node = ruleset->root_inode.rb_node;
+	else if (rule_type == LANDLOCK_RULE_NET_SERVICE)
+		node = ruleset->root_net_port.rb_node;
+
 	while (node) {
 		struct landlock_rule *this = rb_entry(node,
 				struct landlock_rule, node);
 
-		if (this->object == object)
+		if (this->object.ptr == object)
 			return this;
-		if (this->object < object)
+		if (this->object.ptr < object)
 			node = node->rb_right;
 		else
 			node = node->rb_left;
diff --git a/security/landlock/ruleset.h b/security/landlock/ruleset.h
index 2d3ed7ec5a0a..831e47ac2467 100644
--- a/security/landlock/ruleset.h
+++ b/security/landlock/ruleset.h
@@ -45,7 +45,13 @@ struct landlock_rule {
 	 * and never modified.  It always points to an allocated object because
 	 * each rule increments the refcount of its object.
 	 */
-	struct landlock_object *object;
+	//struct landlock_object *object;
+
+	union {
+		struct landlock_object *ptr;
+		uintptr_t data;
+	} object;
+
 	/**
 	 * @num_layers: Number of entries in @layers.
 	 */
@@ -85,7 +91,13 @@ struct landlock_ruleset {
 	 * nodes.  Once a ruleset is tied to a process (i.e. as a domain), this
 	 * tree is immutable until @usage reaches zero.
 	 */
-	struct rb_root root;
+	struct rb_root root_inode;
+	/**
+	 * @root_net_port: Root of a red-black tree containing object nodes
+	 * for network port.  Once a ruleset is tied to a process (i.e. as a domain),
+	 * this tree is immutable until @usage reaches zero.
+	 */
+	struct rb_root root_net_port;
 	/**
 	 * @hierarchy: Enables hierarchy identification even when a parent
 	 * domain vanishes.  This is needed for the ptrace protection.
@@ -124,29 +136,31 @@ struct landlock_ruleset {
 			 */
 			u32 num_layers;
 			/**
-			 * @fs_access_masks: Contains the subset of filesystem
-			 * actions that are restricted by a ruleset.  A domain
-			 * saves all layers of merged rulesets in a stack
-			 * (FAM), starting from the first layer to the last
-			 * one.  These layers are used when merging rulesets,
-			 * for user space backward compatibility (i.e.
-			 * future-proof), and to properly handle merged
+			 * @access_masks: Contains the subset of filesystem
+			 * or network actions that are restricted by a ruleset.
+			 * A domain saves all layers of merged rulesets in a
+			 * stack(FAM), starting from the first layer to the
+			 * last one. These layers are used when merging
+			 * rulesets, for user space backward compatibility
+			 * (i.e. future-proof), and to properly handle merged
 			 * rulesets without overlapping access rights.  These
 			 * layers are set once and never changed for the
 			 * lifetime of the ruleset.
 			 */
-			u16 fs_access_masks[];
+			u32 access_masks[];
 		};
 	};
 };
 
-struct landlock_ruleset *landlock_create_ruleset(const u32 fs_access_mask);
+struct landlock_ruleset *landlock_create_ruleset(const u32 fs_access_mask,
+						 const u32 net_access_mask);
 
 void landlock_put_ruleset(struct landlock_ruleset *const ruleset);
 void landlock_put_ruleset_deferred(struct landlock_ruleset *const ruleset);
 
 int landlock_insert_rule(struct landlock_ruleset *const ruleset,
-		struct landlock_object *const object, const u32 access);
+			 void *const object, const u32 access,
+			 const u16 rule_type);
 
 struct landlock_ruleset *landlock_merge_ruleset(
 		struct landlock_ruleset *const parent,
@@ -154,7 +168,7 @@ struct landlock_ruleset *landlock_merge_ruleset(
 
 const struct landlock_rule *landlock_find_rule(
 		const struct landlock_ruleset *const ruleset,
-		const struct landlock_object *const object);
+		const void *const obj, const u16 rule_type);
 
 static inline void landlock_get_ruleset(struct landlock_ruleset *const ruleset)
 {
diff --git a/security/landlock/setup.c b/security/landlock/setup.c
index f8e8e980454c..91ab06ec8ce0 100644
--- a/security/landlock/setup.c
+++ b/security/landlock/setup.c
@@ -14,6 +14,7 @@
 #include "fs.h"
 #include "ptrace.h"
 #include "setup.h"
+#include "net.h"
 
 bool landlock_initialized __lsm_ro_after_init = false;
 
@@ -21,6 +22,7 @@ struct lsm_blob_sizes landlock_blob_sizes __lsm_ro_after_init = {
 	.lbs_cred = sizeof(struct landlock_cred_security),
 	.lbs_inode = sizeof(struct landlock_inode_security),
 	.lbs_superblock = sizeof(struct landlock_superblock_security),
+	.lbs_task = sizeof(struct landlock_task_security),
 };
 
 static int __init landlock_init(void)
@@ -28,6 +30,7 @@ static int __init landlock_init(void)
 	landlock_add_cred_hooks();
 	landlock_add_ptrace_hooks();
 	landlock_add_fs_hooks();
+	landlock_add_net_hooks();
 	landlock_initialized = true;
 	pr_info("Up and running.\n");
 	return 0;
diff --git a/security/landlock/syscalls.c b/security/landlock/syscalls.c
index 32396962f04d..e0d7eb07dd76 100644
--- a/security/landlock/syscalls.c
+++ b/security/landlock/syscalls.c
@@ -31,6 +31,7 @@
 #include "limits.h"
 #include "ruleset.h"
 #include "setup.h"
+#include "net.h"
 
 /**
  * copy_min_struct_from_user - Safe future-proof argument copying
@@ -73,7 +74,8 @@ static void build_check_abi(void)
 {
 	struct landlock_ruleset_attr ruleset_attr;
 	struct landlock_path_beneath_attr path_beneath_attr;
-	size_t ruleset_size, path_beneath_size;
+	struct landlock_net_service_attr net_service_attr;
+	size_t ruleset_size, path_beneath_size, net_service_size;
 
 	/*
 	 * For each user space ABI structures, first checks that there is no
@@ -81,17 +83,22 @@ static void build_check_abi(void)
 	 * struct size.
 	 */
 	ruleset_size = sizeof(ruleset_attr.handled_access_fs);
+	ruleset_size += sizeof(ruleset_attr.handled_access_net);
 	BUILD_BUG_ON(sizeof(ruleset_attr) != ruleset_size);
-	BUILD_BUG_ON(sizeof(ruleset_attr) != 8);
+	BUILD_BUG_ON(sizeof(ruleset_attr) != 16);
 
 	path_beneath_size = sizeof(path_beneath_attr.allowed_access);
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
-
 static int fop_ruleset_release(struct inode *const inode,
 		struct file *const filp)
 {
@@ -176,18 +183,24 @@ SYSCALL_DEFINE3(landlock_create_ruleset,
 
 	/* Copies raw user space buffer. */
 	err = copy_min_struct_from_user(&ruleset_attr, sizeof(ruleset_attr),
-			offsetofend(typeof(ruleset_attr), handled_access_fs),
+			offsetofend(typeof(ruleset_attr), handled_access_net),
 			attr, size);
 	if (err)
 		return err;
 
-	/* Checks content (and 32-bits cast). */
+	/* Checks fs content (and 32-bits cast). */
 	if ((ruleset_attr.handled_access_fs | LANDLOCK_MASK_ACCESS_FS) !=
 			LANDLOCK_MASK_ACCESS_FS)
 		return -EINVAL;
 
+	/* Checks network content (and 32-bits cast). */
+	if ((ruleset_attr.handled_access_net | LANDLOCK_MASK_ACCESS_NET) !=
+			LANDLOCK_MASK_ACCESS_NET)
+		return -EINVAL;
+
 	/* Checks arguments and transforms to kernel struct. */
-	ruleset = landlock_create_ruleset(ruleset_attr.handled_access_fs);
+	ruleset = landlock_create_ruleset(ruleset_attr.handled_access_fs,
+					  ruleset_attr.handled_access_net);
 	if (IS_ERR(ruleset))
 		return PTR_ERR(ruleset);
 
@@ -306,6 +319,7 @@ SYSCALL_DEFINE4(landlock_add_rule,
 		const void __user *const, rule_attr, const __u32, flags)
 {
 	struct landlock_path_beneath_attr path_beneath_attr;
+	struct landlock_net_service_attr  net_service_attr;
 	struct path path;
 	struct landlock_ruleset *ruleset;
 	int res, err;
@@ -317,47 +331,91 @@ SYSCALL_DEFINE4(landlock_add_rule,
 	if (flags)
 		return -EINVAL;
 
-	if (rule_type != LANDLOCK_RULE_PATH_BENEATH)
+	if ((rule_type != LANDLOCK_RULE_PATH_BENEATH) &&
+		(rule_type != LANDLOCK_RULE_NET_SERVICE))
 		return -EINVAL;
 
-	/* Copies raw user space buffer, only one type for now. */
-	res = copy_from_user(&path_beneath_attr, rule_attr,
-			sizeof(path_beneath_attr));
-	if (res)
-		return -EFAULT;
-
-	/* Gets and checks the ruleset. */
-	ruleset = get_ruleset_from_fd(ruleset_fd, FMODE_CAN_WRITE);
-	if (IS_ERR(ruleset))
-		return PTR_ERR(ruleset);
-
-	/*
-	 * Informs about useless rule: empty allowed_access (i.e. deny rules)
-	 * are ignored in path walks.
-	 */
-	if (!path_beneath_attr.allowed_access) {
-		err = -ENOMSG;
-		goto out_put_ruleset;
-	}
-	/*
-	 * Checks that allowed_access matches the @ruleset constraints
-	 * (ruleset->fs_access_masks[0] is automatically upgraded to 64-bits).
-	 */
-	if ((path_beneath_attr.allowed_access | ruleset->fs_access_masks[0]) !=
-			ruleset->fs_access_masks[0]) {
-		err = -EINVAL;
-		goto out_put_ruleset;
+	switch (rule_type) {
+	case LANDLOCK_RULE_PATH_BENEATH:
+		/* Copies raw user space buffer, for fs rule type. */
+		res = copy_from_user(&path_beneath_attr, rule_attr,
+					sizeof(path_beneath_attr));
+		if (res)
+			return -EFAULT;
+		break;
+
+	case LANDLOCK_RULE_NET_SERVICE:
+		/* Copies raw user space buffer, for net rule type. */
+		res = copy_from_user(&net_service_attr, rule_attr,
+				sizeof(net_service_attr));
+		if (res)
+			return -EFAULT;
+		break;
 	}
 
-	/* Gets and checks the new rule. */
-	err = get_path_from_fd(path_beneath_attr.parent_fd, &path);
-	if (err)
-		goto out_put_ruleset;
+	if (rule_type == LANDLOCK_RULE_PATH_BENEATH) {
+		/* Gets and checks the ruleset. */
+		ruleset = get_ruleset_from_fd(ruleset_fd, FMODE_CAN_WRITE);
+		if (IS_ERR(ruleset))
+			return PTR_ERR(ruleset);
+
+		/*
+		 * Informs about useless rule: empty allowed_access (i.e. deny rules)
+		 * are ignored in path walks.
+		 */
+		if (!path_beneath_attr.allowed_access) {
+			err = -ENOMSG;
+			goto out_put_ruleset;
+		}
+		/*
+		 * Checks that allowed_access matches the @ruleset constraints
+		 * (ruleset->access_masks[0] is automatically upgraded to 64-bits).
+		 */
+		if ((path_beneath_attr.allowed_access | ruleset->access_masks[0]) !=
+							ruleset->access_masks[0]) {
+			err = -EINVAL;
+			goto out_put_ruleset;
+		}
+
+		/* Gets and checks the new rule. */
+		err = get_path_from_fd(path_beneath_attr.parent_fd, &path);
+		if (err)
+			goto out_put_ruleset;
+
+		/* Imports the new rule. */
+		err = landlock_append_fs_rule(ruleset, &path,
+				path_beneath_attr.allowed_access);
+		path_put(&path);
+	}
 
-	/* Imports the new rule. */
-	err = landlock_append_fs_rule(ruleset, &path,
-			path_beneath_attr.allowed_access);
-	path_put(&path);
+	if (rule_type == LANDLOCK_RULE_NET_SERVICE) {
+		/* Gets and checks the ruleset. */
+		ruleset = get_ruleset_from_fd(ruleset_fd, FMODE_CAN_WRITE);
+		if (IS_ERR(ruleset))
+			return PTR_ERR(ruleset);
+
+		/*
+		 * Informs about useless rule: empty allowed_access (i.e. deny rules)
+		 * are ignored in network actions
+		 */
+		if (!net_service_attr.allowed_access) {
+			err = -ENOMSG;
+			goto out_put_ruleset;
+		}
+		/*
+		 * Checks that allowed_access matches the @ruleset constraints
+		 * (ruleset->access_masks[0] is automatically upgraded to 64-bits).
+		 */
+		if (((net_service_attr.allowed_access << LANDLOCK_MASK_SHIFT_NET) |
+		      ruleset->access_masks[0]) != ruleset->access_masks[0]) {
+			err = -EINVAL;
+			goto out_put_ruleset;
+		}
+
+		/* Imports the new rule. */
+		err = landlock_append_net_rule(ruleset, net_service_attr.port,
+					       net_service_attr.allowed_access);
+	}
 
 out_put_ruleset:
 	landlock_put_ruleset(ruleset);
-- 
2.25.1

