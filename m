Return-Path: <netdev+bounces-2703-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C7238703298
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 18:15:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7EA8A2813D3
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 16:15:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A01AFC04;
	Mon, 15 May 2023 16:14:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39647FBF1
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 16:14:19 +0000 (UTC)
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 796E02D49;
	Mon, 15 May 2023 09:14:16 -0700 (PDT)
Received: from lhrpeml500004.china.huawei.com (unknown [172.18.147.226])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4QKksm5m01z67LHp;
	Tue, 16 May 2023 00:12:28 +0800 (CST)
Received: from mscphis00759.huawei.com (10.123.66.134) by
 lhrpeml500004.china.huawei.com (7.191.163.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 15 May 2023 17:14:13 +0100
From: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
To: <mic@digikod.net>
CC: <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
	<linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
	<netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
	<artem.kuzin@huawei.com>
Subject: [PATCH v11 05/12] landlock: Move and rename layer helpers
Date: Tue, 16 May 2023 00:13:32 +0800
Message-ID: <20230515161339.631577-6-konstantin.meskhidze@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230515161339.631577-1-konstantin.meskhidze@huawei.com>
References: <20230515161339.631577-1-konstantin.meskhidze@huawei.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.123.66.134]
X-ClientProxiedBy: mscpeml500002.china.huawei.com (7.188.26.138) To
 lhrpeml500004.china.huawei.com (7.191.163.9)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

This patch renames and moves landlock_unmask_layers() and
landlock_init_layer_masks() helpers to ruleset.c to share
them with Landlock network implementation in following commits.

Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
---

Changes since v10:
* None.

Changes since v9:
* Minor fixes.

Changes since v8:
* Refactors commit message.
* Adds "landlock_" prefix for moved helpers.

Changes since v7:
* Refactors commit message.

Changes since v6:
* Moves get_handled_accesses() helper from ruleset.c back to fs.c,
  cause it's not used in coming network commits.

Changes since v5:
* Splits commit.
* Moves init_layer_masks() and get_handled_accesses() helpers
to ruleset.c and makes then non-static.
* Formats code with clang-format-14.

---
 security/landlock/fs.c      | 136 ++++++------------------------------
 security/landlock/ruleset.c |  98 ++++++++++++++++++++++++++
 security/landlock/ruleset.h |   9 +++
 3 files changed, 128 insertions(+), 115 deletions(-)

diff --git a/security/landlock/fs.c b/security/landlock/fs.c
index 9a8e70f65a88..db833c995003 100644
--- a/security/landlock/fs.c
+++ b/security/landlock/fs.c
@@ -215,60 +215,6 @@ find_rule(const struct landlock_ruleset *const domain,
 	return rule;
 }

-/*
- * @layer_masks is read and may be updated according to the access request and
- * the matching rule.
- *
- * Returns true if the request is allowed (i.e. relevant layer masks for the
- * request are empty).
- */
-static inline bool
-unmask_layers(const struct landlock_rule *const rule,
-	      const access_mask_t access_request,
-	      layer_mask_t (*const layer_masks)[LANDLOCK_NUM_ACCESS_FS])
-{
-	size_t layer_level;
-
-	if (!access_request || !layer_masks)
-		return true;
-	if (!rule)
-		return false;
-
-	/*
-	 * An access is granted if, for each policy layer, at least one rule
-	 * encountered on the pathwalk grants the requested access,
-	 * regardless of its position in the layer stack.  We must then check
-	 * the remaining layers for each inode, from the first added layer to
-	 * the last one.  When there is multiple requested accesses, for each
-	 * policy layer, the full set of requested accesses may not be granted
-	 * by only one rule, but by the union (binary OR) of multiple rules.
-	 * E.g. /a/b <execute> + /a <read> => /a/b <execute + read>
-	 */
-	for (layer_level = 0; layer_level < rule->num_layers; layer_level++) {
-		const struct landlock_layer *const layer =
-			&rule->layers[layer_level];
-		const layer_mask_t layer_bit = BIT_ULL(layer->level - 1);
-		const unsigned long access_req = access_request;
-		unsigned long access_bit;
-		bool is_empty;
-
-		/*
-		 * Records in @layer_masks which layer grants access to each
-		 * requested access.
-		 */
-		is_empty = true;
-		for_each_set_bit(access_bit, &access_req,
-				 ARRAY_SIZE(*layer_masks)) {
-			if (layer->access & BIT_ULL(access_bit))
-				(*layer_masks)[access_bit] &= ~layer_bit;
-			is_empty = is_empty && !(*layer_masks)[access_bit];
-		}
-		if (is_empty)
-			return true;
-	}
-	return false;
-}
-
 /*
  * Allows access to pseudo filesystems that will never be mountable (e.g.
  * sockfs, pipefs), but can still be reachable through
@@ -293,50 +239,6 @@ get_raw_handled_fs_accesses(const struct landlock_ruleset *const domain)
 	return access_dom;
 }

-/**
- * init_layer_masks - Initialize layer masks from an access request
- *
- * Populates @layer_masks such that for each access right in @access_request,
- * the bits for all the layers are set where this access right is handled.
- *
- * @domain: The domain that defines the current restrictions.
- * @access_request: The requested access rights to check.
- * @layer_masks: The layer masks to populate.
- *
- * Returns: An access mask where each access right bit is set which is handled
- * in any of the active layers in @domain.
- */
-static inline access_mask_t
-init_layer_masks(const struct landlock_ruleset *const domain,
-		 const access_mask_t access_request,
-		 layer_mask_t (*const layer_masks)[LANDLOCK_NUM_ACCESS_FS])
-{
-	access_mask_t handled_accesses = 0;
-	size_t layer_level;
-
-	memset(layer_masks, 0, sizeof(*layer_masks));
-	/* An empty access request can happen because of O_WRONLY | O_RDWR. */
-	if (!access_request)
-		return 0;
-
-	/* Saves all handled accesses per layer. */
-	for (layer_level = 0; layer_level < domain->num_layers; layer_level++) {
-		const unsigned long access_req = access_request;
-		unsigned long access_bit;
-
-		for_each_set_bit(access_bit, &access_req,
-				 ARRAY_SIZE(*layer_masks)) {
-			if (BIT_ULL(access_bit) &
-			    landlock_get_fs_access_mask(domain, layer_level)) {
-				(*layer_masks)[access_bit] |=
-					BIT_ULL(layer_level);
-				handled_accesses |= BIT_ULL(access_bit);
-			}
-		}
-	}
-	return handled_accesses;
-}
-
 static access_mask_t
 get_handled_fs_accesses(const struct landlock_ruleset *const domain)
 {
@@ -540,18 +442,20 @@ static bool is_access_to_paths_allowed(
 	}

 	if (unlikely(dentry_child1)) {
-		unmask_layers(find_rule(domain, dentry_child1),
-			      init_layer_masks(domain, LANDLOCK_MASK_ACCESS_FS,
+		landlock_unmask_layers(find_rule(domain, dentry_child1),
+				       landlock_init_layer_masks(
+					       domain, LANDLOCK_MASK_ACCESS_FS,
 					       &_layer_masks_child1),
-			      &_layer_masks_child1);
+				       &_layer_masks_child1);
 		layer_masks_child1 = &_layer_masks_child1;
 		child1_is_directory = d_is_dir(dentry_child1);
 	}
 	if (unlikely(dentry_child2)) {
-		unmask_layers(find_rule(domain, dentry_child2),
-			      init_layer_masks(domain, LANDLOCK_MASK_ACCESS_FS,
+		landlock_unmask_layers(find_rule(domain, dentry_child2),
+				       landlock_init_layer_masks(
+					       domain, LANDLOCK_MASK_ACCESS_FS,
 					       &_layer_masks_child2),
-			      &_layer_masks_child2);
+				       &_layer_masks_child2);
 		layer_masks_child2 = &_layer_masks_child2;
 		child2_is_directory = d_is_dir(dentry_child2);
 	}
@@ -603,10 +507,10 @@ static bool is_access_to_paths_allowed(
 		}

 		rule = find_rule(domain, walker_path.dentry);
-		allowed_parent1 = unmask_layers(rule, access_masked_parent1,
-						layer_masks_parent1);
-		allowed_parent2 = unmask_layers(rule, access_masked_parent2,
-						layer_masks_parent2);
+		allowed_parent1 = landlock_unmask_layers(
+			rule, access_masked_parent1, layer_masks_parent1);
+		allowed_parent2 = landlock_unmask_layers(
+			rule, access_masked_parent2, layer_masks_parent2);

 		/* Stops when a rule from each layer grants access. */
 		if (allowed_parent1 && allowed_parent2)
@@ -650,7 +554,8 @@ static inline int check_access_path(const struct landlock_ruleset *const domain,
 {
 	layer_mask_t layer_masks[LANDLOCK_NUM_ACCESS_FS] = {};

-	access_request = init_layer_masks(domain, access_request, &layer_masks);
+	access_request =
+		landlock_init_layer_masks(domain, access_request, &layer_masks);
 	if (is_access_to_paths_allowed(domain, path, access_request,
 				       &layer_masks, NULL, 0, NULL, NULL))
 		return 0;
@@ -735,16 +640,16 @@ static bool collect_domain_accesses(
 	if (is_nouser_or_private(dir))
 		return true;

-	access_dom = init_layer_masks(domain, LANDLOCK_MASK_ACCESS_FS,
-				      layer_masks_dom);
+	access_dom = landlock_init_layer_masks(domain, LANDLOCK_MASK_ACCESS_FS,
+					       layer_masks_dom);

 	dget(dir);
 	while (true) {
 		struct dentry *parent_dentry;

 		/* Gets all layers allowing all domain accesses. */
-		if (unmask_layers(find_rule(domain, dir), access_dom,
-				  layer_masks_dom)) {
+		if (landlock_unmask_layers(find_rule(domain, dir), access_dom,
+					   layer_masks_dom)) {
 			/*
 			 * Stops when all handled accesses are allowed by at
 			 * least one rule in each layer.
@@ -857,7 +762,7 @@ static int current_check_refer_path(struct dentry *const old_dentry,
 		 * The LANDLOCK_ACCESS_FS_REFER access right is not required
 		 * for same-directory referer (i.e. no reparenting).
 		 */
-		access_request_parent1 = init_layer_masks(
+		access_request_parent1 = landlock_init_layer_masks(
 			dom, access_request_parent1 | access_request_parent2,
 			&layer_masks_parent1);
 		if (is_access_to_paths_allowed(
@@ -1234,7 +1139,8 @@ static int hook_file_open(struct file *const file)

 	if (is_access_to_paths_allowed(
 		    dom, &file->f_path,
-		    init_layer_masks(dom, full_access_request, &layer_masks),
+		    landlock_init_layer_masks(dom, full_access_request,
+					      &layer_masks),
 		    &layer_masks, NULL, 0, NULL, NULL)) {
 		allowed_access = full_access_request;
 	} else {
diff --git a/security/landlock/ruleset.c b/security/landlock/ruleset.c
index e4f449fdd6dd..88b69fa0d7f3 100644
--- a/security/landlock/ruleset.c
+++ b/security/landlock/ruleset.c
@@ -574,3 +574,101 @@ landlock_find_rule(const struct landlock_ruleset *const ruleset,
 	}
 	return NULL;
 }
+
+/*
+ * @layer_masks is read and may be updated according to the access request and
+ * the matching rule.
+ *
+ * Returns true if the request is allowed (i.e. relevant layer masks for the
+ * request are empty).
+ */
+bool landlock_unmask_layers(
+	const struct landlock_rule *const rule,
+	const access_mask_t access_request,
+	layer_mask_t (*const layer_masks)[LANDLOCK_NUM_ACCESS_FS])
+{
+	size_t layer_level;
+
+	if (!access_request || !layer_masks)
+		return true;
+	if (!rule)
+		return false;
+
+	/*
+	 * An access is granted if, for each policy layer, at least one rule
+	 * encountered on the pathwalk grants the requested access,
+	 * regardless of its position in the layer stack.  We must then check
+	 * the remaining layers for each inode, from the first added layer to
+	 * the last one.  When there is multiple requested accesses, for each
+	 * policy layer, the full set of requested accesses may not be granted
+	 * by only one rule, but by the union (binary OR) of multiple rules.
+	 * E.g. /a/b <execute> + /a <read> => /a/b <execute + read>
+	 */
+	for (layer_level = 0; layer_level < rule->num_layers; layer_level++) {
+		const struct landlock_layer *const layer =
+			&rule->layers[layer_level];
+		const layer_mask_t layer_bit = BIT_ULL(layer->level - 1);
+		const unsigned long access_req = access_request;
+		unsigned long access_bit;
+		bool is_empty;
+
+		/*
+		 * Records in @layer_masks which layer grants access to each
+		 * requested access.
+		 */
+		is_empty = true;
+		for_each_set_bit(access_bit, &access_req,
+				 ARRAY_SIZE(*layer_masks)) {
+			if (layer->access & BIT_ULL(access_bit))
+				(*layer_masks)[access_bit] &= ~layer_bit;
+			is_empty = is_empty && !(*layer_masks)[access_bit];
+		}
+		if (is_empty)
+			return true;
+	}
+	return false;
+}
+
+/**
+ * landlock_init_layer_masks - Initialize layer masks from an access request
+ *
+ * Populates @layer_masks such that for each access right in @access_request,
+ * the bits for all the layers are set where this access right is handled.
+ *
+ * @domain: The domain that defines the current restrictions.
+ * @access_request: The requested access rights to check.
+ * @layer_masks: The layer masks to populate.
+ *
+ * Returns: An access mask where each access right bit is set which is handled
+ * in any of the active layers in @domain.
+ */
+access_mask_t landlock_init_layer_masks(
+	const struct landlock_ruleset *const domain,
+	const access_mask_t access_request,
+	layer_mask_t (*const layer_masks)[LANDLOCK_NUM_ACCESS_FS])
+{
+	access_mask_t handled_accesses = 0;
+	size_t layer_level;
+
+	memset(layer_masks, 0, sizeof(*layer_masks));
+	/* An empty access request can happen because of O_WRONLY | O_RDWR. */
+	if (!access_request)
+		return 0;
+
+	/* Saves all handled accesses per layer. */
+	for (layer_level = 0; layer_level < domain->num_layers; layer_level++) {
+		const unsigned long access_req = access_request;
+		unsigned long access_bit;
+
+		for_each_set_bit(access_bit, &access_req,
+				 ARRAY_SIZE(*layer_masks)) {
+			if (BIT_ULL(access_bit) &
+			    landlock_get_fs_access_mask(domain, layer_level)) {
+				(*layer_masks)[access_bit] |=
+					BIT_ULL(layer_level);
+				handled_accesses |= BIT_ULL(access_bit);
+			}
+		}
+	}
+	return handled_accesses;
+}
diff --git a/security/landlock/ruleset.h b/security/landlock/ruleset.h
index 5e1b1b25def0..3635e709b20d 100644
--- a/security/landlock/ruleset.h
+++ b/security/landlock/ruleset.h
@@ -266,5 +266,14 @@ landlock_get_fs_access_mask(const struct landlock_ruleset *const ruleset,
 	return landlock_get_raw_fs_access_mask(ruleset, layer_level) |
 	       LANDLOCK_ACCESS_FS_INITIALLY_DENIED;
 }
+bool landlock_unmask_layers(
+	const struct landlock_rule *const rule,
+	const access_mask_t access_request,
+	layer_mask_t (*const layer_masks)[LANDLOCK_NUM_ACCESS_FS]);
+
+access_mask_t landlock_init_layer_masks(
+	const struct landlock_ruleset *const domain,
+	const access_mask_t access_request,
+	layer_mask_t (*const layer_masks)[LANDLOCK_NUM_ACCESS_FS]);

 #endif /* _SECURITY_LANDLOCK_RULESET_H */
--
2.25.1


