Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99BFB607A82
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 17:27:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230370AbiJUP1W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 11:27:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230341AbiJUP1F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 11:27:05 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 191AB24BAAB;
        Fri, 21 Oct 2022 08:27:04 -0700 (PDT)
Received: from frapeml100006.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Mv7b32kkMz67yhs;
        Fri, 21 Oct 2022 23:25:51 +0800 (CST)
Received: from lhrpeml500004.china.huawei.com (7.191.163.9) by
 frapeml100006.china.huawei.com (7.182.85.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 21 Oct 2022 17:27:01 +0200
Received: from mscphis00759.huawei.com (10.123.66.134) by
 lhrpeml500004.china.huawei.com (7.191.163.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 21 Oct 2022 16:27:00 +0100
From:   Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
To:     <mic@digikod.net>
CC:     <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
        <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <artem.kuzin@huawei.com>
Subject: [PATCH v8 04/12] landlock: Move unmask_layers() and init_layer_masks()
Date:   Fri, 21 Oct 2022 23:26:36 +0800
Message-ID: <20221021152644.155136-5-konstantin.meskhidze@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221021152644.155136-1-konstantin.meskhidze@huawei.com>
References: <20221021152644.155136-1-konstantin.meskhidze@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.123.66.134]
X-ClientProxiedBy: mscpeml100002.china.huawei.com (7.188.26.75) To
 lhrpeml500004.china.huawei.com (7.191.163.9)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch moves unmask_layers() and init_layer_masks() helpers
to ruleset.c to share with landlock network implementation in
following commits.

Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
---

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
 security/landlock/fs.c      | 103 ------------------------------------
 security/landlock/ruleset.c | 102 +++++++++++++++++++++++++++++++++++
 security/landlock/ruleset.h |  20 +++++++
 3 files changed, 122 insertions(+), 103 deletions(-)

diff --git a/security/landlock/fs.c b/security/landlock/fs.c
index 710cfa1306de..240e42a8f788 100644
--- a/security/landlock/fs.c
+++ b/security/landlock/fs.c
@@ -226,60 +226,6 @@ find_rule(const struct landlock_ruleset *const domain,
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
@@ -303,55 +249,6 @@ get_handled_accesses(const struct landlock_ruleset *const domain)
 	return access_dom & LANDLOCK_MASK_ACCESS_FS;
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
-			/*
-			 * Artificially handles all initially denied by default
-			 * access rights.
-			 */
-			if (BIT_ULL(access_bit) &
-			    (landlock_get_fs_access_mask(domain, layer_level) |
-			     ACCESS_INITIALLY_DENIED)) {
-				(*layer_masks)[access_bit] |=
-					BIT_ULL(layer_level);
-				handled_accesses |= BIT_ULL(access_bit);
-			}
-		}
-	}
-	return handled_accesses;
-}
-
 /*
  * Check that a destination file hierarchy has more restrictions than a source
  * file hierarchy.  This is only used for link and rename actions.
diff --git a/security/landlock/ruleset.c b/security/landlock/ruleset.c
index 961ffe0c709e..02ab14439c43 100644
--- a/security/landlock/ruleset.c
+++ b/security/landlock/ruleset.c
@@ -572,3 +572,105 @@ landlock_find_rule(const struct landlock_ruleset *const ruleset,
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
+bool unmask_layers(const struct landlock_rule *const rule,
+		   const access_mask_t access_request,
+		   layer_mask_t (*const layer_masks)[LANDLOCK_NUM_ACCESS_FS])
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
+ * init_layer_masks - Initialize layer masks from an access request
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
+access_mask_t
+init_layer_masks(const struct landlock_ruleset *const domain,
+		 const access_mask_t access_request,
+		 layer_mask_t (*const layer_masks)[LANDLOCK_NUM_ACCESS_FS])
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
+			/*
+			 * Artificially handles all initially denied by default
+			 * access rights.
+			 */
+			if (BIT_ULL(access_bit) &
+			    (landlock_get_fs_access_mask(domain, layer_level) |
+			     ACCESS_INITIALLY_DENIED)) {
+				(*layer_masks)[access_bit] |=
+					BIT_ULL(layer_level);
+				handled_accesses |= BIT_ULL(access_bit);
+			}
+		}
+	}
+	return handled_accesses;
+}
diff --git a/security/landlock/ruleset.h b/security/landlock/ruleset.h
index 608ab356bc3e..50baff4fcbb4 100644
--- a/security/landlock/ruleset.h
+++ b/security/landlock/ruleset.h
@@ -34,6 +34,16 @@ typedef u16 layer_mask_t;
 /* Makes sure all layers can be checked. */
 static_assert(BITS_PER_TYPE(layer_mask_t) >= LANDLOCK_MAX_NUM_LAYERS);

+/*
+ * All access rights that are denied by default whether they are handled or not
+ * by a ruleset/layer.  This must be ORed with all ruleset->fs_access_masks[]
+ * entries when we need to get the absolute handled access masks.
+ */
+/* clang-format off */
+#define ACCESS_INITIALLY_DENIED ( \
+	LANDLOCK_ACCESS_FS_REFER)
+/* clang-format on */
+
 /**
  * struct landlock_layer - Access rights for a given layer
  */
@@ -246,4 +256,14 @@ landlock_get_fs_access_mask(const struct landlock_ruleset *const ruleset,
 		LANDLOCK_SHIFT_ACCESS_FS) &
 	       LANDLOCK_MASK_ACCESS_FS;
 }
+
+bool unmask_layers(const struct landlock_rule *const rule,
+		   const access_mask_t access_request,
+		   layer_mask_t (*const layer_masks)[LANDLOCK_NUM_ACCESS_FS]);
+
+access_mask_t
+init_layer_masks(const struct landlock_ruleset *const domain,
+		 const access_mask_t access_request,
+		 layer_mask_t (*const layer_masks)[LANDLOCK_NUM_ACCESS_FS]);
+
 #endif /* _SECURITY_LANDLOCK_RULESET_H */
--
2.25.1

