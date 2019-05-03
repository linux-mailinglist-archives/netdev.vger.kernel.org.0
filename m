Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A5A212A63
	for <lists+netdev@lfdr.de>; Fri,  3 May 2019 11:25:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727319AbfECJZY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 05:25:24 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:51646 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726391AbfECJZO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 May 2019 05:25:14 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hMURL-0005qF-OW; Fri, 03 May 2019 11:25:11 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH v2 2/8] netlink: remove type-unsafe validation_data pointer
Date:   Fri,  3 May 2019 11:24:55 +0200
Message-Id: <20190503092501.10275-3-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20190503092501.10275-1-johannes@sipsolutions.net>
References: <20190503092501.10275-1-johannes@sipsolutions.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

In the netlink policy, we currently have a void *validation_data
that's pointing to different things:
 * a u32 value for bitfield32,
 * the netlink policy for nested/nested array
 * the string for NLA_REJECT

Remove the pointer and place appropriate type-safe items in the
union instead.

While at it, completely dissolve the pointer for the bitfield32
case and just put the value there directly.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/netlink.h | 55 ++++++++++++++++++++++++-------------------
 lib/nlattr.c          | 20 ++++++++--------
 net/sched/act_api.c   |  4 +---
 3 files changed, 42 insertions(+), 37 deletions(-)

diff --git a/include/net/netlink.h b/include/net/netlink.h
index 679f649748d4..0dd4546fb68c 100644
--- a/include/net/netlink.h
+++ b/include/net/netlink.h
@@ -217,7 +217,7 @@ enum nla_policy_validation {
  *    NLA_NESTED,
  *    NLA_NESTED_ARRAY     Length verification is done by checking len of
  *                         nested header (or empty); len field is used if
- *                         validation_data is also used, for the max attr
+ *                         nested_policy is also used, for the max attr
  *                         number in the nested policy.
  *    NLA_U8, NLA_U16,
  *    NLA_U32, NLA_U64,
@@ -235,27 +235,25 @@ enum nla_policy_validation {
  *    NLA_MIN_LEN          Minimum length of attribute payload
  *    All other            Minimum length of attribute payload
  *
- * Meaning of `validation_data' field:
+ * Meaning of validation union:
  *    NLA_BITFIELD32       This is a 32-bit bitmap/bitselector attribute and
- *                         validation data must point to a u32 value of valid
- *                         flags
- *    NLA_REJECT           This attribute is always rejected and validation data
+ *                         `bitfield32_valid' is the u32 value of valid flags
+ *    NLA_REJECT           This attribute is always rejected and `reject_message'
  *                         may point to a string to report as the error instead
  *                         of the generic one in extended ACK.
- *    NLA_NESTED           Points to a nested policy to validate, must also set
- *                         `len' to the max attribute number.
+ *    NLA_NESTED           `nested_policy' to a nested policy to validate, must
+ *                         also set `len' to the max attribute number. Use the
+ *                         provided NLA_POLICY_NESTED() macro.
  *                         Note that nla_parse() will validate, but of course not
  *                         parse, the nested sub-policies.
- *    NLA_NESTED_ARRAY     Points to a nested policy to validate, must also set
- *                         `len' to the max attribute number. The difference to
- *                         NLA_NESTED is the structure - NLA_NESTED has the
- *                         nested attributes directly inside, while an array has
- *                         the nested attributes at another level down and the
- *                         attributes directly in the nesting don't matter.
- *    All other            Unused - but note that it's a union
- *
- * Meaning of `min' and `max' fields, use via NLA_POLICY_MIN, NLA_POLICY_MAX
- * and NLA_POLICY_RANGE:
+ *    NLA_NESTED_ARRAY     `nested_policy' points to a nested policy to validate,
+ *                         must also set `len' to the max attribute number. Use
+ *                         the provided NLA_POLICY_NESTED_ARRAY() macro.
+ *                         The difference to NLA_NESTED is the structure:
+ *                         NLA_NESTED has the nested attributes directly inside
+ *                         while an array has the nested attributes at another
+ *                         level down and the attribute types directly in the
+ *                         nesting don't matter.
  *    NLA_U8,
  *    NLA_U16,
  *    NLA_U32,
@@ -263,14 +261,16 @@ enum nla_policy_validation {
  *    NLA_S8,
  *    NLA_S16,
  *    NLA_S32,
- *    NLA_S64              These are used depending on the validation_type
- *                         field, if that is min/max/range then the minimum,
- *                         maximum and both are used (respectively) to check
+ *    NLA_S64              The `min' and `max' fields are used depending on the
+ *                         validation_type field, if that is min/max/range then
+ *                         the min, max or both are used (respectively) to check
  *                         the value of the integer attribute.
  *                         Note that in the interest of code simplicity and
  *                         struct size both limits are s16, so you cannot
  *                         enforce a range that doesn't fall within the range
  *                         of s16 - do that as usual in the code instead.
+ *                         Use the NLA_POLICY_MIN(), NLA_POLICY_MAX() and
+ *                         NLA_POLICY_RANGE() macros.
  *    All other            Unused - but note that it's a union
  *
  * Meaning of `validate' field, use via NLA_POLICY_VALIDATE_FN:
@@ -281,11 +281,14 @@ enum nla_policy_validation {
  *    All other            Unused - but note that it's a union
  *
  * Example:
+ *
+ * static const u32 myvalidflags = 0xff231023;
+ *
  * static const struct nla_policy my_policy[ATTR_MAX+1] = {
  * 	[ATTR_FOO] = { .type = NLA_U16 },
  *	[ATTR_BAR] = { .type = NLA_STRING, .len = BARSIZ },
  *	[ATTR_BAZ] = { .type = NLA_EXACT_LEN, .len = sizeof(struct mystruct) },
- *	[ATTR_GOO] = { .type = NLA_BITFIELD32, .validation_data = &myvalidflags },
+ *	[ATTR_GOO] = NLA_POLICY_BITFIELD32(myvalidflags),
  * };
  */
 struct nla_policy {
@@ -293,7 +296,9 @@ struct nla_policy {
 	u8		validation_type;
 	u16		len;
 	union {
-		const void *validation_data;
+		const u32 bitfield32_valid;
+		const char *reject_message;
+		const struct nla_policy *nested_policy;
 		struct {
 			s16 min, max;
 		};
@@ -329,13 +334,15 @@ struct nla_policy {
 #define NLA_POLICY_ETH_ADDR_COMPAT	NLA_POLICY_EXACT_LEN_WARN(ETH_ALEN)
 
 #define _NLA_POLICY_NESTED(maxattr, policy) \
-	{ .type = NLA_NESTED, .validation_data = policy, .len = maxattr }
+	{ .type = NLA_NESTED, .nested_policy = policy, .len = maxattr }
 #define _NLA_POLICY_NESTED_ARRAY(maxattr, policy) \
-	{ .type = NLA_NESTED_ARRAY, .validation_data = policy, .len = maxattr }
+	{ .type = NLA_NESTED_ARRAY, .nested_policy = policy, .len = maxattr }
 #define NLA_POLICY_NESTED(policy) \
 	_NLA_POLICY_NESTED(ARRAY_SIZE(policy) - 1, policy)
 #define NLA_POLICY_NESTED_ARRAY(policy) \
 	_NLA_POLICY_NESTED_ARRAY(ARRAY_SIZE(policy) - 1, policy)
+#define NLA_POLICY_BITFIELD32(valid) \
+	{ .type = NLA_BITFIELD32, .bitfield32_valid = valid }
 
 #define __NLA_ENSURE(condition) BUILD_BUG_ON_ZERO(!(condition))
 #define NLA_ENSURE_INT_TYPE(tp)				\
diff --git a/lib/nlattr.c b/lib/nlattr.c
index 29f6336e2422..c546db7c72dd 100644
--- a/lib/nlattr.c
+++ b/lib/nlattr.c
@@ -45,7 +45,7 @@ static const u8 nla_attr_minlen[NLA_TYPE_MAX+1] = {
 };
 
 static int validate_nla_bitfield32(const struct nlattr *nla,
-				   const u32 *valid_flags_mask)
+				   const u32 valid_flags_mask)
 {
 	const struct nla_bitfield32 *bf = nla_data(nla);
 
@@ -53,11 +53,11 @@ static int validate_nla_bitfield32(const struct nlattr *nla,
 		return -EINVAL;
 
 	/*disallow invalid bit selector */
-	if (bf->selector & ~*valid_flags_mask)
+	if (bf->selector & ~valid_flags_mask)
 		return -EINVAL;
 
 	/*disallow invalid bit values */
-	if (bf->value & ~*valid_flags_mask)
+	if (bf->value & ~valid_flags_mask)
 		return -EINVAL;
 
 	/*disallow valid bit values that are not selected*/
@@ -191,9 +191,9 @@ static int validate_nla(const struct nlattr *nla, int maxtype,
 		break;
 
 	case NLA_REJECT:
-		if (extack && pt->validation_data) {
+		if (extack && pt->reject_message) {
 			NL_SET_BAD_ATTR(extack, nla);
-			extack->_msg = pt->validation_data;
+			extack->_msg = pt->reject_message;
 			return -EINVAL;
 		}
 		err = -EINVAL;
@@ -208,7 +208,7 @@ static int validate_nla(const struct nlattr *nla, int maxtype,
 		if (attrlen != sizeof(struct nla_bitfield32))
 			goto out_err;
 
-		err = validate_nla_bitfield32(nla, pt->validation_data);
+		err = validate_nla_bitfield32(nla, pt->bitfield32_valid);
 		if (err)
 			goto out_err;
 		break;
@@ -253,9 +253,9 @@ static int validate_nla(const struct nlattr *nla, int maxtype,
 			break;
 		if (attrlen < NLA_HDRLEN)
 			goto out_err;
-		if (pt->validation_data) {
+		if (pt->nested_policy) {
 			err = __nla_validate(nla_data(nla), nla_len(nla), pt->len,
-					     pt->validation_data, validate,
+					     pt->nested_policy, validate,
 					     extack);
 			if (err < 0) {
 				/*
@@ -274,11 +274,11 @@ static int validate_nla(const struct nlattr *nla, int maxtype,
 			break;
 		if (attrlen < NLA_HDRLEN)
 			goto out_err;
-		if (pt->validation_data) {
+		if (pt->nested_policy) {
 			int err;
 
 			err = nla_validate_array(nla_data(nla), nla_len(nla),
-						 pt->len, pt->validation_data,
+						 pt->len, pt->nested_policy,
 						 extack, validate);
 			if (err < 0) {
 				/*
diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index 683fcc00da49..1482017a185d 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -1368,10 +1368,8 @@ static int tcf_action_add(struct net *net, struct nlattr *nla,
 	return ret;
 }
 
-static u32 tcaa_root_flags_allowed = TCA_FLAG_LARGE_DUMP_ON;
 static const struct nla_policy tcaa_policy[TCA_ROOT_MAX + 1] = {
-	[TCA_ROOT_FLAGS] = { .type = NLA_BITFIELD32,
-			     .validation_data = &tcaa_root_flags_allowed },
+	[TCA_ROOT_FLAGS] = NLA_POLICY_BITFIELD32(TCA_FLAG_LARGE_DUMP_ON),
 	[TCA_ROOT_TIME_DELTA]      = { .type = NLA_U32 },
 };
 
-- 
2.17.2

