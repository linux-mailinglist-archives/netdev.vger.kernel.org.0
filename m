Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BC8A5A5295
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 19:04:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231294AbiH2REh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 13:04:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231263AbiH2REW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 13:04:22 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1D699C219;
        Mon, 29 Aug 2022 10:04:18 -0700 (PDT)
Received: from fraeml713-chm.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4MGcBs3kBzz67DRW;
        Tue, 30 Aug 2022 01:00:37 +0800 (CST)
Received: from lhrpeml500004.china.huawei.com (7.191.163.9) by
 fraeml713-chm.china.huawei.com (10.206.15.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 29 Aug 2022 19:04:16 +0200
Received: from mscphis00759.huawei.com (10.123.66.134) by
 lhrpeml500004.china.huawei.com (7.191.163.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 29 Aug 2022 18:04:15 +0100
From:   Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
To:     <mic@digikod.net>
CC:     <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
        <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
        <hukeping@huawei.com>, <anton.sirazetdinov@huawei.com>
Subject: [PATCH v7 05/18] landlock: refactor helper functions
Date:   Tue, 30 Aug 2022 01:03:48 +0800
Message-ID: <20220829170401.834298-6-konstantin.meskhidze@huawei.com>
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

Adds new key_type argument to init_layer_masks() helper functions.
This modification supports implementing new rule types in the next
Landlock versions.

Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
---

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
 security/landlock/fs.c      | 33 +++++++++++++++++-----------
 security/landlock/ruleset.c | 44 +++++++++++++++++++++++++++----------
 security/landlock/ruleset.h | 11 +++++-----
 3 files changed, 58 insertions(+), 30 deletions(-)

diff --git a/security/landlock/fs.c b/security/landlock/fs.c
index b03d6153f628..a4d9aea539cd 100644
--- a/security/landlock/fs.c
+++ b/security/landlock/fs.c
@@ -439,16 +439,20 @@ static int check_access_path_dual(
 	if (unlikely(dentry_child1)) {
 		unmask_layers(find_rule(domain, dentry_child1),
 			      init_layer_masks(domain, LANDLOCK_MASK_ACCESS_FS,
-					       &_layer_masks_child1),
-			      &_layer_masks_child1);
+					       &_layer_masks_child1,
+					       LANDLOCK_KEY_INODE),
+			      &_layer_masks_child1,
+			      ARRAY_SIZE(_layer_masks_child1));
 		layer_masks_child1 = &_layer_masks_child1;
 		child1_is_directory = d_is_dir(dentry_child1);
 	}
 	if (unlikely(dentry_child2)) {
 		unmask_layers(find_rule(domain, dentry_child2),
 			      init_layer_masks(domain, LANDLOCK_MASK_ACCESS_FS,
-					       &_layer_masks_child2),
-			      &_layer_masks_child2);
+					       &_layer_masks_child2,
+					       LANDLOCK_KEY_INODE),
+			      &_layer_masks_child2,
+			      ARRAY_SIZE(_layer_masks_child2));
 		layer_masks_child2 = &_layer_masks_child2;
 		child2_is_directory = d_is_dir(dentry_child2);
 	}
@@ -500,15 +504,16 @@ static int check_access_path_dual(
 		}

 		rule = find_rule(domain, walker_path.dentry);
-		allowed_parent1 = unmask_layers(rule, access_masked_parent1,
-						layer_masks_parent1);
-		allowed_parent2 = unmask_layers(rule, access_masked_parent2,
-						layer_masks_parent2);
+		allowed_parent1 = unmask_layers(
+			rule, access_masked_parent1, layer_masks_parent1,
+			ARRAY_SIZE(*layer_masks_parent1));
+		allowed_parent2 = unmask_layers(
+			rule, access_masked_parent2, layer_masks_parent2,
+			ARRAY_SIZE(*layer_masks_parent2));

 		/* Stops when a rule from each layer grants access. */
 		if (allowed_parent1 && allowed_parent2)
 			break;
-
 jump_up:
 		if (walker_path.dentry == walker_path.mnt->mnt_root) {
 			if (follow_up(&walker_path)) {
@@ -564,7 +569,8 @@ static inline int check_access_path(const struct landlock_ruleset *const domain,
 {
 	layer_mask_t layer_masks[LANDLOCK_NUM_ACCESS_FS] = {};

-	access_request = init_layer_masks(domain, access_request, &layer_masks);
+	access_request = init_layer_masks(domain, access_request, &layer_masks,
+					  LANDLOCK_KEY_INODE);
 	return check_access_path_dual(domain, path, access_request,
 				      &layer_masks, NULL, 0, NULL, NULL);
 }
@@ -648,7 +654,7 @@ static bool collect_domain_accesses(
 		return true;

 	access_dom = init_layer_masks(domain, LANDLOCK_MASK_ACCESS_FS,
-				      layer_masks_dom);
+				      layer_masks_dom, LANDLOCK_KEY_INODE);

 	dget(dir);
 	while (true) {
@@ -656,7 +662,8 @@ static bool collect_domain_accesses(

 		/* Gets all layers allowing all domain accesses. */
 		if (unmask_layers(find_rule(domain, dir), access_dom,
-				  layer_masks_dom)) {
+				  layer_masks_dom,
+				  ARRAY_SIZE(*layer_masks_dom))) {
 			/*
 			 * Stops when all handled accesses are allowed by at
 			 * least one rule in each layer.
@@ -772,7 +779,7 @@ static int current_check_refer_path(struct dentry *const old_dentry,
 		 */
 		access_request_parent1 = init_layer_masks(
 			dom, access_request_parent1 | access_request_parent2,
-			&layer_masks_parent1);
+			&layer_masks_parent1, LANDLOCK_KEY_INODE);
 		return check_access_path_dual(dom, new_dir,
 					      access_request_parent1,
 					      &layer_masks_parent1, NULL, 0,
diff --git a/security/landlock/ruleset.c b/security/landlock/ruleset.c
index 671a95e2a345..84fcd8eb30d4 100644
--- a/security/landlock/ruleset.c
+++ b/security/landlock/ruleset.c
@@ -574,7 +574,8 @@ landlock_find_rule(const struct landlock_ruleset *const ruleset,
  */
 bool unmask_layers(const struct landlock_rule *const rule,
 		   const access_mask_t access_request,
-		   layer_mask_t (*const layer_masks)[LANDLOCK_NUM_ACCESS_FS])
+		   layer_mask_t (*const layer_masks)[],
+		   const size_t masks_array_size)
 {
 	size_t layer_level;

@@ -606,8 +607,7 @@ bool unmask_layers(const struct landlock_rule *const rule,
 		 * requested access.
 		 */
 		is_empty = true;
-		for_each_set_bit(access_bit, &access_req,
-				 ARRAY_SIZE(*layer_masks)) {
+		for_each_set_bit(access_bit, &access_req, masks_array_size) {
 			if (layer->access & BIT_ULL(access_bit))
 				(*layer_masks)[access_bit] &= ~layer_bit;
 			is_empty = is_empty && !(*layer_masks)[access_bit];
@@ -618,15 +618,36 @@ bool unmask_layers(const struct landlock_rule *const rule,
 	return false;
 }

-access_mask_t
-init_layer_masks(const struct landlock_ruleset *const domain,
-		 const access_mask_t access_request,
-		 layer_mask_t (*const layer_masks)[LANDLOCK_NUM_ACCESS_FS])
+typedef access_mask_t
+get_access_mask_t(const struct landlock_ruleset *const ruleset,
+		  const u16 layer_level);
+
+/*
+ * @layer_masks must contain LANDLOCK_NUM_ACCESS_FS or LANDLOCK_NUM_ACCESS_NET
+ * elements according to @key_type.
+ */
+access_mask_t init_layer_masks(const struct landlock_ruleset *const domain,
+			       const access_mask_t access_request,
+			       layer_mask_t (*const layer_masks)[],
+			       const enum landlock_key_type key_type)
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
@@ -636,9 +657,8 @@ init_layer_masks(const struct landlock_ruleset *const domain,
 		const unsigned long access_req = access_request;
 		unsigned long access_bit;

-		for_each_set_bit(access_bit, &access_req,
-				 ARRAY_SIZE(*layer_masks)) {
-			if (landlock_get_fs_access_mask(domain, layer_level) &
+		for_each_set_bit(access_bit, &access_req, num_access) {
+			if (get_access_mask(domain, layer_level) &
 			    BIT_ULL(access_bit)) {
 				(*layer_masks)[access_bit] |=
 					BIT_ULL(layer_level);
diff --git a/security/landlock/ruleset.h b/security/landlock/ruleset.h
index d7d9b987829c..2083855bf42d 100644
--- a/security/landlock/ruleset.h
+++ b/security/landlock/ruleset.h
@@ -238,11 +238,12 @@ landlock_get_fs_access_mask(const struct landlock_ruleset *const ruleset,

 bool unmask_layers(const struct landlock_rule *const rule,
 		   const access_mask_t access_request,
-		   layer_mask_t (*const layer_masks)[LANDLOCK_NUM_ACCESS_FS]);
+		   layer_mask_t (*const layer_masks)[],
+		   const size_t masks_array_size);

-access_mask_t
-init_layer_masks(const struct landlock_ruleset *const domain,
-		 const access_mask_t access_request,
-		 layer_mask_t (*const layer_masks)[LANDLOCK_NUM_ACCESS_FS]);
+access_mask_t init_layer_masks(const struct landlock_ruleset *const domain,
+			       const access_mask_t access_request,
+			       layer_mask_t (*const layer_masks)[],
+			       const enum landlock_key_type key_type);

 #endif /* _SECURITY_LANDLOCK_RULESET_H */
--
2.25.1

