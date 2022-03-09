Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C41954D3048
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 14:45:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232912AbiCINqX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 08:46:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232807AbiCINqS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 08:46:18 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 567D517B8B1;
        Wed,  9 Mar 2022 05:45:17 -0800 (PST)
Received: from fraeml704-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4KDD1h3RFfz67gYW;
        Wed,  9 Mar 2022 21:43:52 +0800 (CST)
Received: from mscphispre00059.huawei.com (10.123.71.64) by
 fraeml704-chm.china.huawei.com (10.206.15.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.21; Wed, 9 Mar 2022 14:45:14 +0100
From:   Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
To:     <mic@digikod.net>
CC:     <willemdebruijn.kernel@gmail.com>,
        <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
        <artem.kuzin@huawei.com>, <anton.sirazetdinov@huawei.com>
Subject: [RFC PATCH v4 05/15] landlock: unmask_layers() function refactoring
Date:   Wed, 9 Mar 2022 21:44:49 +0800
Message-ID: <20220309134459.6448-6-konstantin.meskhidze@huawei.com>
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

Unmask_layers() helper function moves to ruleset.c and
rule_type argument is added. This modification supports
implementing new rule types into next landlock versions.

Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
---

Changes since v3:
* Split commit.
* Refactoring landlock_unmask_layers functions.

---
 security/landlock/fs.c      | 67 +++++++++----------------------------
 security/landlock/ruleset.c | 44 ++++++++++++++++++++++++
 security/landlock/ruleset.h |  5 +++
 3 files changed, 64 insertions(+), 52 deletions(-)

diff --git a/security/landlock/fs.c b/security/landlock/fs.c
index 1497948d754f..75ebdce5cd16 100644
--- a/security/landlock/fs.c
+++ b/security/landlock/fs.c
@@ -178,51 +178,6 @@ int landlock_append_fs_rule(struct landlock_ruleset *const ruleset,
 	return err;
 }

-/* Access-control management */
-
-static inline u64 unmask_layers(
-		const struct landlock_ruleset *const domain,
-		const struct path *const path, const u32 access_request,
-		u64 layer_mask)
-{
-	const struct landlock_rule *rule;
-	const struct inode *inode;
-	size_t i;
-
-	if (d_is_negative(path->dentry))
-		/* Ignore nonexistent leafs. */
-		return layer_mask;
-	inode = d_backing_inode(path->dentry);
-	rcu_read_lock();
-	rule = landlock_find_rule(domain,
-			(uintptr_t)rcu_dereference(landlock_inode(inode)->object),
-			LANDLOCK_RULE_PATH_BENEATH);
-	rcu_read_unlock();
-	if (!rule)
-		return layer_mask;
-
-	/*
-	 * An access is granted if, for each policy layer, at least one rule
-	 * encountered on the pathwalk grants the requested accesses,
-	 * regardless of their position in the layer stack.  We must then check
-	 * the remaining layers for each inode, from the first added layer to
-	 * the last one.
-	 */
-	for (i = 0; i < rule->num_layers; i++) {
-		const struct landlock_layer *const layer = &rule->layers[i];
-		const u64 layer_level = BIT_ULL(layer->level - 1);
-
-		/* Checks that the layer grants access to the full request. */
-		if ((layer->access & access_request) == access_request) {
-			layer_mask &= ~layer_level;
-
-			if (layer_mask == 0)
-				return layer_mask;
-		}
-	}
-	return layer_mask;
-}
-
 static int check_access_path(const struct landlock_ruleset *const domain,
 		const struct path *const path, u32 access_request)
 {
@@ -268,15 +223,23 @@ static int check_access_path(const struct landlock_ruleset *const domain,
 	 */
 	while (true) {
 		struct dentry *parent_dentry;
+		const struct inode *inode;
+		struct landlock_object *object_ptr;

-		layer_mask = unmask_layers(domain, &walker_path,
-				access_request, layer_mask);
-		if (layer_mask == 0) {
-			/* Stops when a rule from each layer grants access. */
-			allowed = true;
-			break;
+		/* Ignore nonexistent leafs. */
+		if (!d_is_negative(walker_path.dentry)) {
+
+			inode = d_backing_inode(walker_path.dentry);
+			object_ptr = landlock_inode(inode)->object;
+			layer_mask = landlock_unmask_layers(domain, object_ptr,
+							access_request, layer_mask,
+							LANDLOCK_RULE_PATH_BENEATH);
+			if (layer_mask == 0) {
+				/* Stops when a rule from each layer grants access. */
+				allowed = true;
+				break;
+			}
 		}
-
 jump_up:
 		if (walker_path.dentry == walker_path.mnt->mnt_root) {
 			if (follow_up(&walker_path)) {
diff --git a/security/landlock/ruleset.c b/security/landlock/ruleset.c
index f2baa1c96b16..7179b10f3538 100644
--- a/security/landlock/ruleset.c
+++ b/security/landlock/ruleset.c
@@ -582,3 +582,47 @@ const struct landlock_rule *landlock_find_rule(
 	}
 	return NULL;
 }
+
+/* Access-control management */
+u64 landlock_unmask_layers(const struct landlock_ruleset *const domain,
+			   const struct landlock_object *object_ptr,
+			   const u32 access_request, u64 layer_mask,
+			   const u16 rule_type)
+{
+	const struct landlock_rule *rule;
+	size_t i;
+
+	switch (rule_type) {
+	case LANDLOCK_RULE_PATH_BENEATH:
+		rcu_read_lock();
+		rule = landlock_find_rule(domain,
+			(uintptr_t)rcu_dereference(object_ptr),
+			LANDLOCK_RULE_PATH_BENEATH);
+		rcu_read_unlock();
+		break;
+	}
+
+	if (!rule)
+		return layer_mask;
+
+	/*
+	 * An access is granted if, for each policy layer, at least one rule
+	 * encountered on the pathwalk grants the requested accesses,
+	 * regardless of their position in the layer stack.  We must then check
+	 * the remaining layers for each inode, from the first added layer to
+	 * the last one.
+	 */
+	for (i = 0; i < rule->num_layers; i++) {
+		const struct landlock_layer *const layer = &rule->layers[i];
+		const u64 layer_level = BIT_ULL(layer->level - 1);
+
+		/* Checks that the layer grants access to the full request. */
+		if ((layer->access & access_request) == access_request) {
+			layer_mask &= ~layer_level;
+
+			if (layer_mask == 0)
+				return layer_mask;
+		}
+	}
+	return layer_mask;
+}
diff --git a/security/landlock/ruleset.h b/security/landlock/ruleset.h
index 088b8d95f653..0a7d4b1f51fd 100644
--- a/security/landlock/ruleset.h
+++ b/security/landlock/ruleset.h
@@ -183,4 +183,9 @@ void landlock_set_fs_access_mask(struct landlock_ruleset *ruleset,

 u32 landlock_get_fs_access_mask(const struct landlock_ruleset *ruleset, u16 mask_level);

+u64 landlock_unmask_layers(const struct landlock_ruleset *const domain,
+			   const struct landlock_object *object_ptr,
+			   const u32 access_request, u64 layer_mask,
+			   const u16 rule_type);
+
 #endif /* _SECURITY_LANDLOCK_RULESET_H */
--
2.25.1

