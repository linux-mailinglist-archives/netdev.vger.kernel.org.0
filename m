Return-Path: <netdev+bounces-2704-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D109E703299
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 18:15:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D55DC1C20BC5
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 16:15:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7AFA0FC0F;
	Mon, 15 May 2023 16:14:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69E9BFBF1
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 16:14:21 +0000 (UTC)
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1759DE4;
	Mon, 15 May 2023 09:14:18 -0700 (PDT)
Received: from lhrpeml500004.china.huawei.com (unknown [172.18.147.200])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4QKkq40zKpz6J6wV;
	Tue, 16 May 2023 00:10:08 +0800 (CST)
Received: from mscphis00759.huawei.com (10.123.66.134) by
 lhrpeml500004.china.huawei.com (7.191.163.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 15 May 2023 17:14:15 +0100
From: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
To: <mic@digikod.net>
CC: <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
	<linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
	<netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
	<artem.kuzin@huawei.com>
Subject: [PATCH v11 06/12] landlock: Refactor layer helpers
Date: Tue, 16 May 2023 00:13:33 +0800
Message-ID: <20230515161339.631577-7-konstantin.meskhidze@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230515161339.631577-1-konstantin.meskhidze@huawei.com>
References: <20230515161339.631577-1-konstantin.meskhidze@huawei.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.123.66.134]
X-ClientProxiedBy: mscpeml500002.china.huawei.com (7.188.26.138) To
 lhrpeml500004.china.huawei.com (7.191.163.9)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Add new key_type argument to the landlock_init_layer_masks() helper.
Add a masks_array_size argument to the landlock_unmask_layers() helper.
These modifications support implementing new rule types in the next
Landlock versions.

Signed-off-by: Mickaël Salaün <mic@digikod.net>
Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
---

Changes since v10:
* Minor fix.

Changes since v9:
* Refactors commit message.

Changes since v8:
* None.

Changes since v7:
* Refactors commit message, adds a co-developer.
* Minor fixes.

Changes since v6:
* Removes masks_size attribute from init_layer_masks().
* Refactors init_layer_masks() with new landlock_key_type.

Changes since v5:
* Splits commit.
* Formats code with clang-format-14.

Changes since v4:
* Refactors init_layer_masks(), get_handled_accesses()
and unmask_layers() functions to support multiple rule types.
* Refactors landlock_get_fs_access_mask() function with
LANDLOCK_MASK_ACCESS_FS mask.

Changes since v3:
* Splits commit.
* Refactors landlock_unmask_layers functions.

---
 security/landlock/fs.c      | 43 ++++++++++++++++++---------------
 security/landlock/ruleset.c | 48 +++++++++++++++++++++++++------------
 security/landlock/ruleset.h | 17 ++++++-------
 3 files changed, 66 insertions(+), 42 deletions(-)

diff --git a/security/landlock/fs.c b/security/landlock/fs.c
index db833c995003..81098cb54837 100644
--- a/security/landlock/fs.c
+++ b/security/landlock/fs.c
@@ -442,20 +442,22 @@ static bool is_access_to_paths_allowed(
 	}

 	if (unlikely(dentry_child1)) {
-		landlock_unmask_layers(find_rule(domain, dentry_child1),
-				       landlock_init_layer_masks(
-					       domain, LANDLOCK_MASK_ACCESS_FS,
-					       &_layer_masks_child1),
-				       &_layer_masks_child1);
+		landlock_unmask_layers(
+			find_rule(domain, dentry_child1),
+			landlock_init_layer_masks(
+				domain, LANDLOCK_MASK_ACCESS_FS,
+				&_layer_masks_child1, LANDLOCK_KEY_INODE),
+			&_layer_masks_child1, ARRAY_SIZE(_layer_masks_child1));
 		layer_masks_child1 = &_layer_masks_child1;
 		child1_is_directory = d_is_dir(dentry_child1);
 	}
 	if (unlikely(dentry_child2)) {
-		landlock_unmask_layers(find_rule(domain, dentry_child2),
-				       landlock_init_layer_masks(
-					       domain, LANDLOCK_MASK_ACCESS_FS,
-					       &_layer_masks_child2),
-				       &_layer_masks_child2);
+		landlock_unmask_layers(
+			find_rule(domain, dentry_child2),
+			landlock_init_layer_masks(
+				domain, LANDLOCK_MASK_ACCESS_FS,
+				&_layer_masks_child2, LANDLOCK_KEY_INODE),
+			&_layer_masks_child2, ARRAY_SIZE(_layer_masks_child2));
 		layer_masks_child2 = &_layer_masks_child2;
 		child2_is_directory = d_is_dir(dentry_child2);
 	}
@@ -508,14 +510,15 @@ static bool is_access_to_paths_allowed(

 		rule = find_rule(domain, walker_path.dentry);
 		allowed_parent1 = landlock_unmask_layers(
-			rule, access_masked_parent1, layer_masks_parent1);
+			rule, access_masked_parent1, layer_masks_parent1,
+			ARRAY_SIZE(*layer_masks_parent1));
 		allowed_parent2 = landlock_unmask_layers(
-			rule, access_masked_parent2, layer_masks_parent2);
+			rule, access_masked_parent2, layer_masks_parent2,
+			ARRAY_SIZE(*layer_masks_parent2));

 		/* Stops when a rule from each layer grants access. */
 		if (allowed_parent1 && allowed_parent2)
 			break;
-
 jump_up:
 		if (walker_path.dentry == walker_path.mnt->mnt_root) {
 			if (follow_up(&walker_path)) {
@@ -554,8 +557,8 @@ static inline int check_access_path(const struct landlock_ruleset *const domain,
 {
 	layer_mask_t layer_masks[LANDLOCK_NUM_ACCESS_FS] = {};

-	access_request =
-		landlock_init_layer_masks(domain, access_request, &layer_masks);
+	access_request = landlock_init_layer_masks(
+		domain, access_request, &layer_masks, LANDLOCK_KEY_INODE);
 	if (is_access_to_paths_allowed(domain, path, access_request,
 				       &layer_masks, NULL, 0, NULL, NULL))
 		return 0;
@@ -641,7 +644,8 @@ static bool collect_domain_accesses(
 		return true;

 	access_dom = landlock_init_layer_masks(domain, LANDLOCK_MASK_ACCESS_FS,
-					       layer_masks_dom);
+					       layer_masks_dom,
+					       LANDLOCK_KEY_INODE);

 	dget(dir);
 	while (true) {
@@ -649,7 +653,8 @@ static bool collect_domain_accesses(

 		/* Gets all layers allowing all domain accesses. */
 		if (landlock_unmask_layers(find_rule(domain, dir), access_dom,
-					   layer_masks_dom)) {
+					   layer_masks_dom,
+					   ARRAY_SIZE(*layer_masks_dom))) {
 			/*
 			 * Stops when all handled accesses are allowed by at
 			 * least one rule in each layer.
@@ -764,7 +769,7 @@ static int current_check_refer_path(struct dentry *const old_dentry,
 		 */
 		access_request_parent1 = landlock_init_layer_masks(
 			dom, access_request_parent1 | access_request_parent2,
-			&layer_masks_parent1);
+			&layer_masks_parent1, LANDLOCK_KEY_INODE);
 		if (is_access_to_paths_allowed(
 			    dom, new_dir, access_request_parent1,
 			    &layer_masks_parent1, NULL, 0, NULL, NULL))
@@ -1140,7 +1145,7 @@ static int hook_file_open(struct file *const file)
 	if (is_access_to_paths_allowed(
 		    dom, &file->f_path,
 		    landlock_init_layer_masks(dom, full_access_request,
-					      &layer_masks),
+					      &layer_masks, LANDLOCK_KEY_INODE),
 		    &layer_masks, NULL, 0, NULL, NULL)) {
 		allowed_access = full_access_request;
 	} else {
diff --git a/security/landlock/ruleset.c b/security/landlock/ruleset.c
index 88b69fa0d7f3..b07ad57ee40a 100644
--- a/security/landlock/ruleset.c
+++ b/security/landlock/ruleset.c
@@ -578,14 +578,15 @@ landlock_find_rule(const struct landlock_ruleset *const ruleset,
 /*
  * @layer_masks is read and may be updated according to the access request and
  * the matching rule.
+ * @masks_array_size must be equal to ARRAY_SIZE(*layer_masks).
  *
  * Returns true if the request is allowed (i.e. relevant layer masks for the
  * request are empty).
  */
-bool landlock_unmask_layers(
-	const struct landlock_rule *const rule,
-	const access_mask_t access_request,
-	layer_mask_t (*const layer_masks)[LANDLOCK_NUM_ACCESS_FS])
+bool landlock_unmask_layers(const struct landlock_rule *const rule,
+			    const access_mask_t access_request,
+			    layer_mask_t (*const layer_masks)[],
+			    const size_t masks_array_size)
 {
 	size_t layer_level;

@@ -617,8 +618,7 @@ bool landlock_unmask_layers(
 		 * requested access.
 		 */
 		is_empty = true;
-		for_each_set_bit(access_bit, &access_req,
-				 ARRAY_SIZE(*layer_masks)) {
+		for_each_set_bit(access_bit, &access_req, masks_array_size) {
 			if (layer->access & BIT_ULL(access_bit))
 				(*layer_masks)[access_bit] &= ~layer_bit;
 			is_empty = is_empty && !(*layer_masks)[access_bit];
@@ -629,6 +629,10 @@ bool landlock_unmask_layers(
 	return false;
 }

+typedef access_mask_t
+get_access_mask_t(const struct landlock_ruleset *const ruleset,
+		  const u16 layer_level);
+
 /**
  * landlock_init_layer_masks - Initialize layer masks from an access request
  *
@@ -638,19 +642,34 @@ bool landlock_unmask_layers(
  * @domain: The domain that defines the current restrictions.
  * @access_request: The requested access rights to check.
  * @layer_masks: The layer masks to populate.
+ * @key_type: The key type to switch between access masks of different types.
  *
  * Returns: An access mask where each access right bit is set which is handled
  * in any of the active layers in @domain.
  */
-access_mask_t landlock_init_layer_masks(
-	const struct landlock_ruleset *const domain,
-	const access_mask_t access_request,
-	layer_mask_t (*const layer_masks)[LANDLOCK_NUM_ACCESS_FS])
+access_mask_t
+landlock_init_layer_masks(const struct landlock_ruleset *const domain,
+			  const access_mask_t access_request,
+			  layer_mask_t (*const layer_masks)[],
+			  const enum landlock_key_type key_type)
 {
 	access_mask_t handled_accesses = 0;
-	size_t layer_level;
+	size_t layer_level, num_access;
+	get_access_mask_t *get_access_mask;
+
+	switch (key_type) {
+	case LANDLOCK_KEY_INODE:
+		get_access_mask = landlock_get_fs_access_mask;
+		num_access = LANDLOCK_NUM_ACCESS_FS;
+		break;
+	default:
+		WARN_ON_ONCE(1);
+		return 0;
+	}
+
+	memset(layer_masks, 0,
+	       array_size(sizeof((*layer_masks)[0]), num_access));

-	memset(layer_masks, 0, sizeof(*layer_masks));
 	/* An empty access request can happen because of O_WRONLY | O_RDWR. */
 	if (!access_request)
 		return 0;
@@ -660,10 +679,9 @@ access_mask_t landlock_init_layer_masks(
 		const unsigned long access_req = access_request;
 		unsigned long access_bit;

-		for_each_set_bit(access_bit, &access_req,
-				 ARRAY_SIZE(*layer_masks)) {
+		for_each_set_bit(access_bit, &access_req, num_access) {
 			if (BIT_ULL(access_bit) &
-			    landlock_get_fs_access_mask(domain, layer_level)) {
+			    get_access_mask(domain, layer_level)) {
 				(*layer_masks)[access_bit] |=
 					BIT_ULL(layer_level);
 				handled_accesses |= BIT_ULL(access_bit);
diff --git a/security/landlock/ruleset.h b/security/landlock/ruleset.h
index 3635e709b20d..2251e6048ccf 100644
--- a/security/landlock/ruleset.h
+++ b/security/landlock/ruleset.h
@@ -266,14 +266,15 @@ landlock_get_fs_access_mask(const struct landlock_ruleset *const ruleset,
 	return landlock_get_raw_fs_access_mask(ruleset, layer_level) |
 	       LANDLOCK_ACCESS_FS_INITIALLY_DENIED;
 }
-bool landlock_unmask_layers(
-	const struct landlock_rule *const rule,
-	const access_mask_t access_request,
-	layer_mask_t (*const layer_masks)[LANDLOCK_NUM_ACCESS_FS]);
+bool landlock_unmask_layers(const struct landlock_rule *const rule,
+			    const access_mask_t access_request,
+			    layer_mask_t (*const layer_masks)[],
+			    const size_t masks_array_size);

-access_mask_t landlock_init_layer_masks(
-	const struct landlock_ruleset *const domain,
-	const access_mask_t access_request,
-	layer_mask_t (*const layer_masks)[LANDLOCK_NUM_ACCESS_FS]);
+access_mask_t
+landlock_init_layer_masks(const struct landlock_ruleset *const domain,
+			  const access_mask_t access_request,
+			  layer_mask_t (*const layer_masks)[],
+			  const enum landlock_key_type key_type);

 #endif /* _SECURITY_LANDLOCK_RULESET_H */
--
2.25.1


