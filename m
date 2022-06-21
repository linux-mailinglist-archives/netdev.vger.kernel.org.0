Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73516552CCD
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 10:24:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243716AbiFUIXj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 04:23:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229955AbiFUIXa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 04:23:30 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02847DE98;
        Tue, 21 Jun 2022 01:23:28 -0700 (PDT)
Received: from fraeml709-chm.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4LRzvW0pVSz6H80V;
        Tue, 21 Jun 2022 16:19:35 +0800 (CST)
Received: from lhreml745-chm.china.huawei.com (10.201.108.195) by
 fraeml709-chm.china.huawei.com (10.206.15.37) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 21 Jun 2022 10:23:25 +0200
Received: from mscphis00759.huawei.com (10.123.66.134) by
 lhreml745-chm.china.huawei.com (10.201.108.195) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 21 Jun 2022 09:23:24 +0100
From:   Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
To:     <mic@digikod.net>
CC:     <willemdebruijn.kernel@gmail.com>,
        <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
        <anton.sirazetdinov@huawei.com>
Subject: [PATCH v6 05/17] landlock: refactors helper functions
Date:   Tue, 21 Jun 2022 16:23:01 +0800
Message-ID: <20220621082313.3330667-6-konstantin.meskhidze@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220621082313.3330667-1-konstantin.meskhidze@huawei.com>
References: <20220621082313.3330667-1-konstantin.meskhidze@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.123.66.134]
X-ClientProxiedBy: mscpeml500001.china.huawei.com (7.188.26.142) To
 lhreml745-chm.china.huawei.com (10.201.108.195)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adds new rule_type argument to
unmask_layers(), init_layer_masks() and
get_handled_accesses() helper functions.
This modification supports implementing new rule
types in the next landlock versions.

Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
---

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
 security/landlock/fs.c      | 45 ++++++++++++++++---------
 security/landlock/ruleset.c | 67 +++++++++++++++++++++++--------------
 security/landlock/ruleset.h | 16 +++++----
 3 files changed, 80 insertions(+), 48 deletions(-)

diff --git a/security/landlock/fs.c b/security/landlock/fs.c
index 42fb02141b9c..10f6c67f5c3b 100644
--- a/security/landlock/fs.c
+++ b/security/landlock/fs.c
@@ -400,7 +400,8 @@ static int check_access_path_dual(
 		 * a superset of the meaningful requested accesses).
 		 */
 		access_masked_parent1 = access_masked_parent2 =
-			get_handled_accesses(domain);
+			get_handled_accesses(domain, LANDLOCK_RULE_PATH_BENEATH,
+					     LANDLOCK_NUM_ACCESS_FS);
 		is_dom_check = true;
 	} else {
 		if (WARN_ON_ONCE(dentry_child1 || dentry_child2))
@@ -414,16 +415,22 @@ static int check_access_path_dual(
 	if (unlikely(dentry_child1)) {
 		unmask_layers(find_rule(domain, dentry_child1),
 			      init_layer_masks(domain, LANDLOCK_MASK_ACCESS_FS,
-					       &_layer_masks_child1),
-			      &_layer_masks_child1);
+					       &_layer_masks_child1,
+					       sizeof(_layer_masks_child1),
+					       LANDLOCK_RULE_PATH_BENEATH),
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
+					       sizeof(_layer_masks_child2),
+					       LANDLOCK_RULE_PATH_BENEATH),
+			      &_layer_masks_child2,
+			      ARRAY_SIZE(_layer_masks_child2));
 		layer_masks_child2 = &_layer_masks_child2;
 		child2_is_directory = d_is_dir(dentry_child2);
 	}
@@ -475,15 +482,16 @@ static int check_access_path_dual(
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
@@ -539,7 +547,9 @@ static inline int check_access_path(const struct landlock_ruleset *const domain,
 {
 	layer_mask_t layer_masks[LANDLOCK_NUM_ACCESS_FS] = {};

-	access_request = init_layer_masks(domain, access_request, &layer_masks);
+	access_request = init_layer_masks(domain, access_request, &layer_masks,
+					  sizeof(layer_masks),
+					  LANDLOCK_RULE_PATH_BENEATH);
 	return check_access_path_dual(domain, path, access_request,
 				      &layer_masks, NULL, 0, NULL, NULL);
 }
@@ -623,7 +633,8 @@ static bool collect_domain_accesses(
 		return true;

 	access_dom = init_layer_masks(domain, LANDLOCK_MASK_ACCESS_FS,
-				      layer_masks_dom);
+				      layer_masks_dom, sizeof(*layer_masks_dom),
+				      LANDLOCK_RULE_PATH_BENEATH);

 	dget(dir);
 	while (true) {
@@ -631,7 +642,8 @@ static bool collect_domain_accesses(

 		/* Gets all layers allowing all domain accesses. */
 		if (unmask_layers(find_rule(domain, dir), access_dom,
-				  layer_masks_dom)) {
+				  layer_masks_dom,
+				  ARRAY_SIZE(*layer_masks_dom))) {
 			/*
 			 * Stops when all handled accesses are allowed by at
 			 * least one rule in each layer.
@@ -747,7 +759,8 @@ static int current_check_refer_path(struct dentry *const old_dentry,
 		 */
 		access_request_parent1 = init_layer_masks(
 			dom, access_request_parent1 | access_request_parent2,
-			&layer_masks_parent1);
+			&layer_masks_parent1, sizeof(layer_masks_parent1),
+			LANDLOCK_RULE_PATH_BENEATH);
 		return check_access_path_dual(dom, new_dir,
 					      access_request_parent1,
 					      &layer_masks_parent1, NULL, 0,
@@ -755,7 +768,9 @@ static int current_check_refer_path(struct dentry *const old_dentry,
 	}

 	/* Backward compatibility: no reparenting support. */
-	if (!(get_handled_accesses(dom) & LANDLOCK_ACCESS_FS_REFER))
+	if (!(get_handled_accesses(dom, LANDLOCK_RULE_PATH_BENEATH,
+				   LANDLOCK_NUM_ACCESS_FS) &
+	      LANDLOCK_ACCESS_FS_REFER))
 		return -EXDEV;

 	access_request_parent1 |= LANDLOCK_ACCESS_FS_REFER;
diff --git a/security/landlock/ruleset.c b/security/landlock/ruleset.c
index 32ec79d6559a..cbca85f5cc6d 100644
--- a/security/landlock/ruleset.c
+++ b/security/landlock/ruleset.c
@@ -578,23 +578,31 @@ landlock_find_rule(const struct landlock_ruleset *const ruleset,
 	return NULL;
 }

-access_mask_t get_handled_accesses(const struct landlock_ruleset *const domain)
+access_mask_t get_handled_accesses(const struct landlock_ruleset *const domain,
+				   u16 rule_type, u16 num_access)
 {
 	access_mask_t access_dom = 0;
 	unsigned long access_bit;

-	for (access_bit = 0; access_bit < LANDLOCK_NUM_ACCESS_FS;
-	     access_bit++) {
-		size_t layer_level;
-
-		for (layer_level = 0; layer_level < domain->num_layers;
-		     layer_level++) {
-			if (landlock_get_fs_access_mask(domain, layer_level) &
-			    BIT_ULL(access_bit)) {
-				access_dom |= BIT_ULL(access_bit);
-				break;
+	switch (rule_type) {
+	case LANDLOCK_RULE_PATH_BENEATH:
+		for (access_bit = 0; access_bit < LANDLOCK_NUM_ACCESS_FS;
+		     access_bit++) {
+			size_t layer_level;
+
+			for (layer_level = 0; layer_level < domain->num_layers;
+			     layer_level++) {
+				if (landlock_get_fs_access_mask(domain,
+								layer_level) &
+				    BIT_ULL(access_bit)) {
+					access_dom |= BIT_ULL(access_bit);
+					break;
+				}
 			}
 		}
+		break;
+	default:
+		break;
 	}
 	return access_dom;
 }
@@ -608,7 +616,7 @@ access_mask_t get_handled_accesses(const struct landlock_ruleset *const domain)
  */
 bool unmask_layers(const struct landlock_rule *const rule,
 		   const access_mask_t access_request,
-		   layer_mask_t (*const layer_masks)[LANDLOCK_NUM_ACCESS_FS])
+		   layer_mask_t (*const layer_masks)[], size_t masks_array_size)
 {
 	size_t layer_level;

@@ -640,8 +648,7 @@ bool unmask_layers(const struct landlock_rule *const rule,
 		 * requested access.
 		 */
 		is_empty = true;
-		for_each_set_bit(access_bit, &access_req,
-				 ARRAY_SIZE(*layer_masks)) {
+		for_each_set_bit(access_bit, &access_req, masks_array_size) {
 			if (layer->access & BIT_ULL(access_bit))
 				(*layer_masks)[access_bit] &= ~layer_bit;
 			is_empty = is_empty && !(*layer_masks)[access_bit];
@@ -652,15 +659,16 @@ bool unmask_layers(const struct landlock_rule *const rule,
 	return false;
 }

-access_mask_t
-init_layer_masks(const struct landlock_ruleset *const domain,
-		 const access_mask_t access_request,
-		 layer_mask_t (*const layer_masks)[LANDLOCK_NUM_ACCESS_FS])
+access_mask_t init_layer_masks(const struct landlock_ruleset *const domain,
+			       const access_mask_t access_request,
+			       layer_mask_t (*const layer_masks)[],
+			       size_t masks_size, u16 rule_type)
 {
 	access_mask_t handled_accesses = 0;
 	size_t layer_level;

-	memset(layer_masks, 0, sizeof(*layer_masks));
+	memset(layer_masks, 0, masks_size);
+
 	/* An empty access request can happen because of O_WRONLY | O_RDWR. */
 	if (!access_request)
 		return 0;
@@ -670,14 +678,21 @@ init_layer_masks(const struct landlock_ruleset *const domain,
 		const unsigned long access_req = access_request;
 		unsigned long access_bit;

-		for_each_set_bit(access_bit, &access_req,
-				 ARRAY_SIZE(*layer_masks)) {
-			if (landlock_get_fs_access_mask(domain, layer_level) &
-			    BIT_ULL(access_bit)) {
-				(*layer_masks)[access_bit] |=
-					BIT_ULL(layer_level);
-				handled_accesses |= BIT_ULL(access_bit);
+		switch (rule_type) {
+		case LANDLOCK_RULE_PATH_BENEATH:
+			for_each_set_bit(access_bit, &access_req,
+					 LANDLOCK_NUM_ACCESS_FS) {
+				if (landlock_get_fs_access_mask(domain,
+								layer_level) &
+				    BIT_ULL(access_bit)) {
+					(*layer_masks)[access_bit] |=
+						BIT_ULL(layer_level);
+					handled_accesses |= BIT_ULL(access_bit);
+				}
 			}
+			break;
+		default:
+			return 0;
 		}
 	}
 	return handled_accesses;
diff --git a/security/landlock/ruleset.h b/security/landlock/ruleset.h
index ea09ab2f27c4..c1cf7cce2cb5 100644
--- a/security/landlock/ruleset.h
+++ b/security/landlock/ruleset.h
@@ -193,18 +193,20 @@ static inline u32
 landlock_get_fs_access_mask(const struct landlock_ruleset *ruleset,
 			    u16 mask_level)
 {
-	return ruleset->access_masks[mask_level];
+	return (ruleset->access_masks[mask_level] & LANDLOCK_MASK_ACCESS_FS);
 }

-access_mask_t get_handled_accesses(const struct landlock_ruleset *const domain);
+access_mask_t get_handled_accesses(const struct landlock_ruleset *const domain,
+				   u16 rule_type, u16 num_access);

 bool unmask_layers(const struct landlock_rule *const rule,
 		   const access_mask_t access_request,
-		   layer_mask_t (*const layer_masks)[LANDLOCK_NUM_ACCESS_FS]);
+		   layer_mask_t (*const layer_masks)[],
+		   size_t masks_array_size);

-access_mask_t
-init_layer_masks(const struct landlock_ruleset *const domain,
-		 const access_mask_t access_request,
-		 layer_mask_t (*const layer_masks)[LANDLOCK_NUM_ACCESS_FS]);
+access_mask_t init_layer_masks(const struct landlock_ruleset *const domain,
+			       const access_mask_t access_request,
+			       layer_mask_t (*const layer_masks)[],
+			       size_t masks_size, u16 rule_type);

 #endif /* _SECURITY_LANDLOCK_RULESET_H */
--
2.25.1

