Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6AC5552CC6
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 10:24:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229732AbiFUIXf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 04:23:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229782AbiFUIX2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 04:23:28 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AC85D135;
        Tue, 21 Jun 2022 01:23:26 -0700 (PDT)
Received: from fraeml711-chm.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4LRzxj5HCGz67XGx;
        Tue, 21 Jun 2022 16:21:29 +0800 (CST)
Received: from lhreml745-chm.china.huawei.com (10.201.108.195) by
 fraeml711-chm.china.huawei.com (10.206.15.60) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 21 Jun 2022 10:23:24 +0200
Received: from mscphis00759.huawei.com (10.123.66.134) by
 lhreml745-chm.china.huawei.com (10.201.108.195) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 21 Jun 2022 09:23:23 +0100
From:   Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
To:     <mic@digikod.net>
CC:     <willemdebruijn.kernel@gmail.com>,
        <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
        <anton.sirazetdinov@huawei.com>
Subject: [PATCH v6 04/17] landlock: moves helper functions
Date:   Tue, 21 Jun 2022 16:23:00 +0800
Message-ID: <20220621082313.3330667-5-konstantin.meskhidze@huawei.com>
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

This patch moves unmask_layers(),
init_layer_masks() and get_handled_accesses()
helpers to ruleset.c to share with
landlock network implementation in following
commits.

Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
---

Changes since v5:
* Splits commit.
* Moves init_layer_masks() and get_handled_accesses() helpers
to ruleset.c and makes then non-static.
* Formats code with clang-format-14.

---
 security/landlock/fs.c      | 107 ------------------------------------
 security/landlock/ruleset.c | 105 +++++++++++++++++++++++++++++++++++
 security/landlock/ruleset.h |  12 ++++
 3 files changed, 117 insertions(+), 107 deletions(-)

diff --git a/security/landlock/fs.c b/security/landlock/fs.c
index 46aedc2a05a8..42fb02141b9c 100644
--- a/security/landlock/fs.c
+++ b/security/landlock/fs.c
@@ -212,60 +212,6 @@ find_rule(const struct landlock_ruleset *const domain,
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
@@ -278,59 +224,6 @@ static inline bool is_nouser_or_private(const struct dentry *dentry)
 		unlikely(IS_PRIVATE(d_backing_inode(dentry))));
 }

-static inline access_mask_t
-get_handled_accesses(const struct landlock_ruleset *const domain)
-{
-	access_mask_t access_dom = 0;
-	unsigned long access_bit;
-
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
-			}
-		}
-	}
-	return access_dom;
-}
-
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
-			if (landlock_get_fs_access_mask(domain, layer_level) &
-			    BIT_ULL(access_bit)) {
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
index 820b6e6a4496..32ec79d6559a 100644
--- a/security/landlock/ruleset.c
+++ b/security/landlock/ruleset.c
@@ -577,3 +577,108 @@ landlock_find_rule(const struct landlock_ruleset *const ruleset,
 	}
 	return NULL;
 }
+
+access_mask_t get_handled_accesses(const struct landlock_ruleset *const domain)
+{
+	access_mask_t access_dom = 0;
+	unsigned long access_bit;
+
+	for (access_bit = 0; access_bit < LANDLOCK_NUM_ACCESS_FS;
+	     access_bit++) {
+		size_t layer_level;
+
+		for (layer_level = 0; layer_level < domain->num_layers;
+		     layer_level++) {
+			if (landlock_get_fs_access_mask(domain, layer_level) &
+			    BIT_ULL(access_bit)) {
+				access_dom |= BIT_ULL(access_bit);
+				break;
+			}
+		}
+	}
+	return access_dom;
+}
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
+			if (landlock_get_fs_access_mask(domain, layer_level) &
+			    BIT_ULL(access_bit)) {
+				(*layer_masks)[access_bit] |=
+					BIT_ULL(layer_level);
+				handled_accesses |= BIT_ULL(access_bit);
+			}
+		}
+	}
+	return handled_accesses;
+}
diff --git a/security/landlock/ruleset.h b/security/landlock/ruleset.h
index a22d132c32a7..ea09ab2f27c4 100644
--- a/security/landlock/ruleset.h
+++ b/security/landlock/ruleset.h
@@ -195,4 +195,16 @@ landlock_get_fs_access_mask(const struct landlock_ruleset *ruleset,
 {
 	return ruleset->access_masks[mask_level];
 }
+
+access_mask_t get_handled_accesses(const struct landlock_ruleset *const domain);
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

