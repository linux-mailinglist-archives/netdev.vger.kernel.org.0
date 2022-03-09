Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 364D74D306D
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 14:48:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232871AbiCINqd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 08:46:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232932AbiCINqa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 08:46:30 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A07CB17B8A5;
        Wed,  9 Mar 2022 05:45:21 -0800 (PST)
Received: from fraeml704-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4KDD1m5Dr0z67Nc8;
        Wed,  9 Mar 2022 21:43:56 +0800 (CST)
Received: from mscphispre00059.huawei.com (10.123.71.64) by
 fraeml704-chm.china.huawei.com (10.206.15.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.21; Wed, 9 Mar 2022 14:45:19 +0100
From:   Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
To:     <mic@digikod.net>
CC:     <willemdebruijn.kernel@gmail.com>,
        <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
        <artem.kuzin@huawei.com>, <anton.sirazetdinov@huawei.com>
Subject: [RFC PATCH v4 08/15] landlock: add support network rules
Date:   Wed, 9 Mar 2022 21:44:52 +0800
Message-ID: <20220309134459.6448-9-konstantin.meskhidze@huawei.com>
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

This modification adds network rules support
in internal landlock functions (presented in ruleset.c)
and landlock_create_ruleset syscall.

Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
---

Changes since v3:
* Split commit.
* Add network rule support for internal landlock functions.
* Add set_masks and get_masks for network.
* Add rb_root root_net_port.

---
 security/landlock/fs.c       |  2 +-
 security/landlock/limits.h   |  6 +++
 security/landlock/ruleset.c  | 88 +++++++++++++++++++++++++++++++++---
 security/landlock/ruleset.h  | 14 +++++-
 security/landlock/syscalls.c | 10 +++-
 5 files changed, 109 insertions(+), 11 deletions(-)

diff --git a/security/landlock/fs.c b/security/landlock/fs.c
index 75ebdce5cd16..5cd339061cdb 100644
--- a/security/landlock/fs.c
+++ b/security/landlock/fs.c
@@ -231,7 +231,7 @@ static int check_access_path(const struct landlock_ruleset *const domain,

 			inode = d_backing_inode(walker_path.dentry);
 			object_ptr = landlock_inode(inode)->object;
-			layer_mask = landlock_unmask_layers(domain, object_ptr,
+			layer_mask = landlock_unmask_layers(domain, object_ptr, 0,
 							access_request, layer_mask,
 							LANDLOCK_RULE_PATH_BENEATH);
 			if (layer_mask == 0) {
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
diff --git a/security/landlock/ruleset.c b/security/landlock/ruleset.c
index 7179b10f3538..1cecca59a942 100644
--- a/security/landlock/ruleset.c
+++ b/security/landlock/ruleset.c
@@ -35,6 +35,7 @@ static struct landlock_ruleset *create_ruleset(const u32 num_layers)
 	refcount_set(&new_ruleset->usage, 1);
 	mutex_init(&new_ruleset->lock);
 	new_ruleset->root_inode = RB_ROOT;
+	new_ruleset->root_net_port = RB_ROOT;
 	new_ruleset->num_layers = num_layers;
 	/*
 	 * hierarchy = NULL
@@ -58,16 +59,32 @@ u32 landlock_get_fs_access_mask(const struct landlock_ruleset *ruleset, u16 mask
 	return ruleset->access_masks[mask_level];
 }

+/* A helper function to set a network mask */
+void landlock_set_net_access_mask(struct landlock_ruleset *ruleset,
+				  const struct landlock_access_mask *access_mask_set,
+				  u16 mask_level)
+{
+	ruleset->access_masks[mask_level] |= (access_mask_set->net << LANDLOCK_MASK_SHIFT_NET);
+}
+
+/* A helper function to get a network mask */
+u32 landlock_get_net_access_mask(const struct landlock_ruleset *ruleset, u16 mask_level)
+{
+	return (ruleset->access_masks[mask_level] >> LANDLOCK_MASK_SHIFT_NET);
+}
+
 struct landlock_ruleset *landlock_create_ruleset(const struct landlock_access_mask *access_mask_set)
 {
 	struct landlock_ruleset *new_ruleset;

 	/* Informs about useless ruleset. */
-	if (!access_mask_set->fs)
+	if (!access_mask_set->fs && !access_mask_set->net)
 		return ERR_PTR(-ENOMSG);
 	new_ruleset = create_ruleset(1);
-	if (!IS_ERR(new_ruleset))
+	if (!IS_ERR(new_ruleset) && access_mask_set->fs)
 		landlock_set_fs_access_mask(new_ruleset, access_mask_set, 0);
+	if (!IS_ERR(new_ruleset) && access_mask_set->net)
+		landlock_set_net_access_mask(new_ruleset, access_mask_set, 0);
 	return new_ruleset;
 }

@@ -111,6 +128,9 @@ static struct landlock_rule *create_rule(
 		landlock_get_object(object_ptr);
 		new_rule->object.ptr = object_ptr;
 		break;
+	case LANDLOCK_RULE_NET_SERVICE:
+		new_rule->object.data = object_data;
+		break;
 	default:
 		return ERR_PTR(-EINVAL);
 	}
@@ -145,10 +165,12 @@ static void build_check_ruleset(void)
 		.num_layers = ~0,
 	};
 	typeof(ruleset.access_masks[0]) fs_access_mask = ~0;
+	typeof(ruleset.access_masks[0]) net_access_mask = ~0;

 	BUILD_BUG_ON(ruleset.num_rules < LANDLOCK_MAX_NUM_RULES);
 	BUILD_BUG_ON(ruleset.num_layers < LANDLOCK_MAX_NUM_LAYERS);
 	BUILD_BUG_ON(fs_access_mask < LANDLOCK_MASK_ACCESS_FS);
+	BUILD_BUG_ON(net_access_mask < LANDLOCK_MASK_ACCESS_NET);
 }

 /**
@@ -191,6 +213,12 @@ static int insert_rule(struct landlock_ruleset *const ruleset,
 		object = (uintptr_t)object_ptr;
 		root = &ruleset->root_inode;
 		break;
+	case LANDLOCK_RULE_NET_SERVICE:
+		if (WARN_ON_ONCE(!object_data || !layers))
+			return -ENOENT;
+		object = object_data;
+		root = &ruleset->root_net_port;
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -242,6 +270,14 @@ static int insert_rule(struct landlock_ruleset *const ruleset,
 			rb_replace_node(&this->node, &new_rule->node, &ruleset->root_inode);
 			free_rule(this, rule_type);
 			break;
+		case LANDLOCK_RULE_NET_SERVICE:
+			new_rule = create_rule(NULL, object_data, &this->layers, this->num_layers,
+					       &(*layers)[0], rule_type);
+			if (IS_ERR(new_rule))
+				return PTR_ERR(new_rule);
+			rb_replace_node(&this->node, &new_rule->node, &ruleset->root_net_port);
+			free_rule(this, rule_type);
+			break;
 		}
 		return 0;
 	}
@@ -259,6 +295,14 @@ static int insert_rule(struct landlock_ruleset *const ruleset,
 		rb_insert_color(&new_rule->node, &ruleset->root_inode);
 		ruleset->num_rules++;
 		break;
+	case LANDLOCK_RULE_NET_SERVICE:
+		new_rule = create_rule(NULL, object_data, layers, num_layers, NULL, rule_type);
+		if (IS_ERR(new_rule))
+			return PTR_ERR(new_rule);
+		rb_link_node(&new_rule->node, parent_node, walker_node);
+		rb_insert_color(&new_rule->node, &ruleset->root_net_port);
+		ruleset->num_rules++;
+		break;
 	}
 	return 0;
 }
@@ -319,6 +363,9 @@ static int tree_merge(struct landlock_ruleset *const src,
 	case LANDLOCK_RULE_PATH_BENEATH:
 		src_root = &src->root_inode;
 		break;
+	case LANDLOCK_RULE_NET_SERVICE:
+		src_root = &src->root_net_port;
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -338,11 +385,14 @@ static int tree_merge(struct landlock_ruleset *const src,
 			return err;
 		}
 		layers[0].access = walker_rule->layers[0].access;
-
 		switch (rule_type) {
 		case LANDLOCK_RULE_PATH_BENEATH:
 			err = insert_rule(dst, walker_rule->object.ptr, 0, &layers,
-				ARRAY_SIZE(layers), rule_type);
+					ARRAY_SIZE(layers), rule_type);
+			break;
+		case LANDLOCK_RULE_NET_SERVICE:
+			err = insert_rule(dst, NULL, walker_rule->object.data, &layers,
+					ARRAY_SIZE(layers), rule_type);
 			break;
 		}
 		if (err)
@@ -379,6 +429,10 @@ static int merge_ruleset(struct landlock_ruleset *const dst,
 	err = tree_merge(src, dst, LANDLOCK_RULE_PATH_BENEATH);
 	if (err)
 		goto out_unlock;
+	/* Merges the @src network tree. */
+	err = tree_merge(src, dst, LANDLOCK_RULE_NET_SERVICE);
+	if (err)
+		goto out_unlock;

 out_unlock:
 	mutex_unlock(&src->lock);
@@ -398,6 +452,9 @@ static int tree_copy(struct landlock_ruleset *const parent,
 	case LANDLOCK_RULE_PATH_BENEATH:
 		parent_root = &parent->root_inode;
 		break;
+	case LANDLOCK_RULE_NET_SERVICE:
+		parent_root = &parent->root_net_port;
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -410,6 +467,11 @@ static int tree_copy(struct landlock_ruleset *const parent,
 				  &walker_rule->layers, walker_rule->num_layers,
 				  rule_type);
 			break;
+		case LANDLOCK_RULE_NET_SERVICE:
+			err = insert_rule(child, NULL, walker_rule->object.data,
+				  &walker_rule->layers, walker_rule->num_layers,
+				  rule_type);
+			break;
 		}
 		if (err)
 			return err;
@@ -432,6 +494,10 @@ static int inherit_ruleset(struct landlock_ruleset *const parent,

 	/* Copies the @parent inode tree. */
 	err = tree_copy(parent, child, LANDLOCK_RULE_PATH_BENEATH);
+	if (err)
+		goto out_unlock;
+	/* Copies the @parent inode tree. */
+	err = tree_copy(parent, child, LANDLOCK_RULE_NET_SERVICE);
 	if (err)
 		goto out_unlock;

@@ -464,6 +530,9 @@ static void free_ruleset(struct landlock_ruleset *const ruleset)
 	rbtree_postorder_for_each_entry_safe(freeme, next, &ruleset->root_inode,
 			node)
 		free_rule(freeme, LANDLOCK_RULE_PATH_BENEATH);
+	rbtree_postorder_for_each_entry_safe(freeme, next, &ruleset->root_net_port,
+			node)
+		free_rule(freeme, LANDLOCK_RULE_NET_SERVICE);
 	put_hierarchy(ruleset->hierarchy);
 	kfree(ruleset);
 }
@@ -565,6 +634,9 @@ const struct landlock_rule *landlock_find_rule(
 	case LANDLOCK_RULE_PATH_BENEATH:
 		node = ruleset->root_inode.rb_node;
 		break;
+	case LANDLOCK_RULE_NET_SERVICE:
+		node = ruleset->root_net_port.rb_node;
+		break;
 	default:
 		return ERR_PTR(-EINVAL);
 	}
@@ -586,8 +658,8 @@ const struct landlock_rule *landlock_find_rule(
 /* Access-control management */
 u64 landlock_unmask_layers(const struct landlock_ruleset *const domain,
 			   const struct landlock_object *object_ptr,
-			   const u32 access_request, u64 layer_mask,
-			   const u16 rule_type)
+			   const u16 port, const u32 access_request,
+			   u64 layer_mask, const u16 rule_type)
 {
 	const struct landlock_rule *rule;
 	size_t i;
@@ -600,6 +672,10 @@ u64 landlock_unmask_layers(const struct landlock_ruleset *const domain,
 			LANDLOCK_RULE_PATH_BENEATH);
 		rcu_read_unlock();
 		break;
+	case LANDLOCK_RULE_NET_SERVICE:
+		rule = landlock_find_rule(domain, (uintptr_t)port,
+					LANDLOCK_RULE_NET_SERVICE);
+		break;
 	}

 	if (!rule)
diff --git a/security/landlock/ruleset.h b/security/landlock/ruleset.h
index 0a7d4b1f51fd..abf3e09a65cd 100644
--- a/security/landlock/ruleset.h
+++ b/security/landlock/ruleset.h
@@ -24,6 +24,10 @@ struct landlock_access_mask {
 	 * @fs: Filesystem access mask.
 	 */
 	u16 fs;
+	/**
+	 * @net: Network access mask.
+	 */
+	u16 net;
 };

 /**
@@ -98,6 +102,12 @@ struct landlock_ruleset {
 	 * tree is immutable until @usage reaches zero.
 	 */
 	struct rb_root root_inode;
+	/**
+	 * @root_net_port: Root of a red-black tree containing object nodes
+	 * for network port. Once a ruleset is tied to a process (i.e. as a domain),
+	 * this tree is immutable until @usage reaches zero.
+	 */
+	struct rb_root root_net_port;
 	/**
 	 * @hierarchy: Enables hierarchy identification even when a parent
 	 * domain vanishes.  This is needed for the ptrace protection.
@@ -185,7 +195,7 @@ u32 landlock_get_fs_access_mask(const struct landlock_ruleset *ruleset, u16 mask

 u64 landlock_unmask_layers(const struct landlock_ruleset *const domain,
 			   const struct landlock_object *object_ptr,
-			   const u32 access_request, u64 layer_mask,
-			   const u16 rule_type);
+			   const u16 port, const u32 access_request,
+			   u64 layer_mask, const u16 rule_type);

 #endif /* _SECURITY_LANDLOCK_RULESET_H */
diff --git a/security/landlock/syscalls.c b/security/landlock/syscalls.c
index fcbce83d64ef..b91455a19356 100644
--- a/security/landlock/syscalls.c
+++ b/security/landlock/syscalls.c
@@ -160,7 +160,7 @@ SYSCALL_DEFINE3(landlock_create_ruleset,
 {
 	struct landlock_ruleset_attr ruleset_attr;
 	struct landlock_ruleset *ruleset;
-	struct landlock_access_mask access_mask_set = {.fs = 0};
+	struct landlock_access_mask access_mask_set = {.fs = 0, .net = 0};
 	int err, ruleset_fd;

 	/* Build-time checks. */
@@ -187,8 +187,14 @@ SYSCALL_DEFINE3(landlock_create_ruleset,
 	if ((ruleset_attr.handled_access_fs | LANDLOCK_MASK_ACCESS_FS) !=
 			 LANDLOCK_MASK_ACCESS_FS)
 		return -EINVAL;
-	access_mask_set.fs = ruleset_attr.handled_access_fs;

+	/* Checks network content (and 32-bits cast). */
+	if ((ruleset_attr.handled_access_net | LANDLOCK_MASK_ACCESS_NET) !=
+			LANDLOCK_MASK_ACCESS_NET)
+		return -EINVAL;
+
+	access_mask_set.fs = ruleset_attr.handled_access_fs;
+	access_mask_set.net = ruleset_attr.handled_access_net;
 	/* Checks arguments and transforms to kernel struct. */
 	ruleset = landlock_create_ruleset(&access_mask_set);
 	if (IS_ERR(ruleset))
--
2.25.1

