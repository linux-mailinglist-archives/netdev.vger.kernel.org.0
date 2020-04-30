Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46E501C0788
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 22:13:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727779AbgD3UN0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 16:13:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727086AbgD3UNY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 16:13:24 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 599ABC035495;
        Thu, 30 Apr 2020 13:13:24 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.93)
        (envelope-from <johannes@sipsolutions.net>)
        id 1jUFYf-002qzz-Qj; Thu, 30 Apr 2020 22:13:21 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     Antonio Quartulli <a@unstable.cc>, linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH v2 1/8] netlink: remove type-unsafe validation_data pointer
Date:   Thu, 30 Apr 2020 22:13:05 +0200
Message-Id: <20200430221106.01f758365b94.Ib760259c7f93e40ef3dfcb23b187684bc19e4e26@changeid>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200430201312.60143-1-johannes@sipsolutions.net>
References: <20200430201312.60143-1-johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
 include/net/netlink.h | 60 +++++++++++++++++++++++--------------------
 lib/nlattr.c          | 20 +++++++--------
 net/sched/act_api.c   | 13 +++-------
 net/sched/sch_red.c   |  9 +++----
 4 files changed, 49 insertions(+), 53 deletions(-)

diff --git a/include/net/netlink.h b/include/net/netlink.h
index 67c57d6942e3..671b29d170a8 100644
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
@@ -263,29 +261,31 @@ enum nla_policy_validation {
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
- *    NLA_BINARY           Validation function called for the attribute,
- *                         not compatible with use of the validation_data
- *                         as in NLA_BITFIELD32, NLA_REJECT, NLA_NESTED and
- *                         NLA_NESTED_ARRAY.
+ *    NLA_BINARY           Validation function called for the attribute.
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
@@ -293,7 +293,9 @@ struct nla_policy {
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
@@ -329,13 +331,15 @@ struct nla_policy {
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
index cace9b307781..3df05db732ca 100644
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
@@ -206,9 +206,9 @@ static int validate_nla(const struct nlattr *nla, int maxtype,
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
@@ -223,7 +223,7 @@ static int validate_nla(const struct nlattr *nla, int maxtype,
 		if (attrlen != sizeof(struct nla_bitfield32))
 			goto out_err;
 
-		err = validate_nla_bitfield32(nla, pt->validation_data);
+		err = validate_nla_bitfield32(nla, pt->bitfield32_valid);
 		if (err)
 			goto out_err;
 		break;
@@ -268,9 +268,9 @@ static int validate_nla(const struct nlattr *nla, int maxtype,
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
@@ -289,11 +289,11 @@ static int validate_nla(const struct nlattr *nla, int maxtype,
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
index df4560909157..fbbec2e562f5 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -876,19 +876,14 @@ static u8 tcf_action_hw_stats_get(struct nlattr *hw_stats_attr)
 	return hw_stats_bf.value;
 }
 
-static const u32 tca_act_flags_allowed = TCA_ACT_FLAGS_NO_PERCPU_STATS;
-static const u32 tca_act_hw_stats_allowed = TCA_ACT_HW_STATS_ANY;
-
 static const struct nla_policy tcf_action_policy[TCA_ACT_MAX + 1] = {
 	[TCA_ACT_KIND]		= { .type = NLA_STRING },
 	[TCA_ACT_INDEX]		= { .type = NLA_U32 },
 	[TCA_ACT_COOKIE]	= { .type = NLA_BINARY,
 				    .len = TC_COOKIE_MAX_SIZE },
 	[TCA_ACT_OPTIONS]	= { .type = NLA_NESTED },
-	[TCA_ACT_FLAGS]		= { .type = NLA_BITFIELD32,
-				    .validation_data = &tca_act_flags_allowed },
-	[TCA_ACT_HW_STATS]	= { .type = NLA_BITFIELD32,
-				    .validation_data = &tca_act_hw_stats_allowed },
+	[TCA_ACT_FLAGS]		= NLA_POLICY_BITFIELD32(TCA_ACT_FLAGS_NO_PERCPU_STATS),
+	[TCA_ACT_HW_STATS]	= NLA_POLICY_BITFIELD32(TCA_ACT_HW_STATS_ANY),
 };
 
 struct tc_action *tcf_action_init_1(struct net *net, struct tcf_proto *tp,
@@ -1454,10 +1449,8 @@ static int tcf_action_add(struct net *net, struct nlattr *nla,
 	return ret;
 }
 
-static u32 tcaa_root_flags_allowed = TCA_FLAG_LARGE_DUMP_ON;
 static const struct nla_policy tcaa_policy[TCA_ROOT_MAX + 1] = {
-	[TCA_ROOT_FLAGS] = { .type = NLA_BITFIELD32,
-			     .validation_data = &tcaa_root_flags_allowed },
+	[TCA_ROOT_FLAGS] = NLA_POLICY_BITFIELD32(TCA_FLAG_LARGE_DUMP_ON),
 	[TCA_ROOT_TIME_DELTA]      = { .type = NLA_U32 },
 };
 
diff --git a/net/sched/sch_red.c b/net/sched/sch_red.c
index c7de47c942e3..555a1b9e467f 100644
--- a/net/sched/sch_red.c
+++ b/net/sched/sch_red.c
@@ -48,7 +48,7 @@ struct red_sched_data {
 	struct Qdisc		*qdisc;
 };
 
-static const u32 red_supported_flags = TC_RED_HISTORIC_FLAGS | TC_RED_NODROP;
+#define TC_RED_SUPPORTED_FLAGS (TC_RED_HISTORIC_FLAGS | TC_RED_NODROP)
 
 static inline int red_use_ecn(struct red_sched_data *q)
 {
@@ -212,8 +212,7 @@ static const struct nla_policy red_policy[TCA_RED_MAX + 1] = {
 	[TCA_RED_PARMS]	= { .len = sizeof(struct tc_red_qopt) },
 	[TCA_RED_STAB]	= { .len = RED_STAB_SIZE },
 	[TCA_RED_MAX_P] = { .type = NLA_U32 },
-	[TCA_RED_FLAGS] = { .type = NLA_BITFIELD32,
-			    .validation_data = &red_supported_flags },
+	[TCA_RED_FLAGS] = NLA_POLICY_BITFIELD32(TC_RED_SUPPORTED_FLAGS),
 };
 
 static int red_change(struct Qdisc *sch, struct nlattr *opt,
@@ -248,7 +247,7 @@ static int red_change(struct Qdisc *sch, struct nlattr *opt,
 		return -EINVAL;
 
 	err = red_get_flags(ctl->flags, TC_RED_HISTORIC_FLAGS,
-			    tb[TCA_RED_FLAGS], red_supported_flags,
+			    tb[TCA_RED_FLAGS], TC_RED_SUPPORTED_FLAGS,
 			    &flags_bf, &userbits, extack);
 	if (err)
 		return err;
@@ -372,7 +371,7 @@ static int red_dump(struct Qdisc *sch, struct sk_buff *skb)
 	if (nla_put(skb, TCA_RED_PARMS, sizeof(opt), &opt) ||
 	    nla_put_u32(skb, TCA_RED_MAX_P, q->parms.max_P) ||
 	    nla_put_bitfield32(skb, TCA_RED_FLAGS,
-			       q->flags, red_supported_flags))
+			       q->flags, TC_RED_SUPPORTED_FLAGS))
 		goto nla_put_failure;
 	return nla_nest_end(skb, opts);
 
-- 
2.25.1

