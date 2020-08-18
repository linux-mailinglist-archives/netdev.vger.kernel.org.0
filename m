Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32CE2248033
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 10:08:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726482AbgHRIIk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 04:08:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726633AbgHRIIb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 04:08:31 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B3B7C061344
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 01:08:30 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1k7wfS-0067PR-VR; Tue, 18 Aug 2020 10:08:27 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3/3] netlink: make NLA_BINARY validation more flexible
Date:   Tue, 18 Aug 2020 10:08:19 +0200
Message-Id: <20200818100639.fa7ed2ad4fb9.Ieb6502e26920e731a04d414245a28254519a26d8@changeid>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200818080819.10012-1-johannes@sipsolutions.net>
References: <20200818080819.10012-1-johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

Add range validation for NLA_BINARY, allowing validation of any
combination of combination minimum or maximum lengths, using the
existing NLA_POLICY_RANGE()/NLA_POLICY_FULL_RANGE() macros, just
like for integers where the value is checked.

Also make NLA_POLICY_EXACT_LEN(), NLA_POLICY_EXACT_LEN_WARN()
and NLA_POLICY_MIN_LEN() special cases of this, removing the old
types NLA_EXACT_LEN and NLA_MIN_LEN.

This allows us to save some code where both minimum and maximum
lengths are requires, currently the policy only allows maximum
(NLA_BINARY), minimum (NLA_MIN_LEN) or exact (NLA_EXACT_LEN), so
a range of lengths cannot be accepted and must be checked by the
code that consumes the attributes later.

Also, this allows advertising the correct ranges in the policy
export to userspace. Here, NLA_MIN_LEN and NLA_EXACT_LEN already
were special cases of NLA_BINARY with min and min/max length
respectively.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/netlink.h | 58 ++++++++++++++++++++++-------------------
 lib/nlattr.c          | 60 ++++++++++++++++++++++++++++---------------
 net/netlink/policy.c  | 32 +++++++++++++----------
 3 files changed, 89 insertions(+), 61 deletions(-)

diff --git a/include/net/netlink.h b/include/net/netlink.h
index c0411f14fb53..fdd317f8fde4 100644
--- a/include/net/netlink.h
+++ b/include/net/netlink.h
@@ -181,8 +181,6 @@ enum {
 	NLA_S64,
 	NLA_BITFIELD32,
 	NLA_REJECT,
-	NLA_EXACT_LEN,
-	NLA_MIN_LEN,
 	__NLA_TYPE_MAX,
 };
 
@@ -199,11 +197,11 @@ struct netlink_range_validation_signed {
 enum nla_policy_validation {
 	NLA_VALIDATE_NONE,
 	NLA_VALIDATE_RANGE,
+	NLA_VALIDATE_RANGE_WARN_TOO_LONG,
 	NLA_VALIDATE_MIN,
 	NLA_VALIDATE_MAX,
 	NLA_VALIDATE_RANGE_PTR,
 	NLA_VALIDATE_FUNCTION,
-	NLA_VALIDATE_WARN_TOO_LONG,
 };
 
 /**
@@ -222,7 +220,7 @@ enum nla_policy_validation {
  *    NLA_NUL_STRING       Maximum length of string (excluding NUL)
  *    NLA_FLAG             Unused
  *    NLA_BINARY           Maximum length of attribute payload
- *    NLA_MIN_LEN          Minimum length of attribute payload
+ *                         (but see also below with the validation type)
  *    NLA_NESTED,
  *    NLA_NESTED_ARRAY     Length verification is done by checking len of
  *                         nested header (or empty); len field is used if
@@ -237,11 +235,6 @@ enum nla_policy_validation {
  *                         just like "All other"
  *    NLA_BITFIELD32       Unused
  *    NLA_REJECT           Unused
- *    NLA_EXACT_LEN        Attribute should have exactly this length, otherwise
- *                         it is rejected or warned about, the latter happening
- *                         if and only if the `validation_type' is set to
- *                         NLA_VALIDATE_WARN_TOO_LONG.
- *    NLA_MIN_LEN          Minimum length of attribute payload
  *    All other            Minimum length of attribute payload
  *
  * Meaning of validation union:
@@ -296,6 +289,11 @@ enum nla_policy_validation {
  *                         pointer to a struct netlink_range_validation_signed
  *                         that indicates the min/max values.
  *                         Use NLA_POLICY_FULL_RANGE_SIGNED().
+ *
+ *    NLA_BINARY           If the validation type is like the ones for integers
+ *                         above, then the min/max length (not value like for
+ *                         integers) of the attribute is enforced.
+ *
  *    All other            Unused - but note that it's a union
  *
  * Meaning of `validate' field, use via NLA_POLICY_VALIDATE_FN:
@@ -309,7 +307,7 @@ enum nla_policy_validation {
  * static const struct nla_policy my_policy[ATTR_MAX+1] = {
  * 	[ATTR_FOO] = { .type = NLA_U16 },
  *	[ATTR_BAR] = { .type = NLA_STRING, .len = BARSIZ },
- *	[ATTR_BAZ] = { .type = NLA_EXACT_LEN, .len = sizeof(struct mystruct) },
+ *	[ATTR_BAZ] = NLA_POLICY_EXACT_LEN(sizeof(struct mystruct)),
  *	[ATTR_GOO] = NLA_POLICY_BITFIELD32(myvalidflags),
  * };
  */
@@ -335,9 +333,10 @@ struct nla_policy {
 		 * nesting validation starts here.
 		 *
 		 * Additionally, it means that NLA_UNSPEC is actually NLA_REJECT
-		 * for any types >= this, so need to use NLA_MIN_LEN to get the
-		 * previous pure { .len = xyz } behaviour. The advantage of this
-		 * is that types not specified in the policy will be rejected.
+		 * for any types >= this, so need to use NLA_POLICY_MIN_LEN() to
+		 * get the previous pure { .len = xyz } behaviour. The advantage
+		 * of this is that types not specified in the policy will be
+		 * rejected.
 		 *
 		 * For completely new families it should be set to 1 so that the
 		 * validation is enforced for all attributes. For existing ones
@@ -349,12 +348,6 @@ struct nla_policy {
 	};
 };
 
-#define NLA_POLICY_EXACT_LEN(_len)	{ .type = NLA_EXACT_LEN, .len = _len }
-#define NLA_POLICY_EXACT_LEN_WARN(_len) \
-	{ .type = NLA_EXACT_LEN, .len = _len, \
-	  .validation_type = NLA_VALIDATE_WARN_TOO_LONG, }
-#define NLA_POLICY_MIN_LEN(_len)	{ .type = NLA_MIN_LEN, .len = _len }
-
 #define NLA_POLICY_ETH_ADDR		NLA_POLICY_EXACT_LEN(ETH_ALEN)
 #define NLA_POLICY_ETH_ADDR_COMPAT	NLA_POLICY_EXACT_LEN_WARN(ETH_ALEN)
 
@@ -370,19 +363,21 @@ struct nla_policy {
 	{ .type = NLA_BITFIELD32, .bitfield32_valid = valid }
 
 #define __NLA_ENSURE(condition) BUILD_BUG_ON_ZERO(!(condition))
-#define NLA_ENSURE_UINT_TYPE(tp)			\
+#define NLA_ENSURE_UINT_OR_BINARY_TYPE(tp)		\
 	(__NLA_ENSURE(tp == NLA_U8 || tp == NLA_U16 ||	\
 		      tp == NLA_U32 || tp == NLA_U64 ||	\
-		      tp == NLA_MSECS) + tp)
+		      tp == NLA_MSECS ||		\
+		      tp == NLA_BINARY) + tp)
 #define NLA_ENSURE_SINT_TYPE(tp)			\
 	(__NLA_ENSURE(tp == NLA_S8 || tp == NLA_S16  ||	\
 		      tp == NLA_S32 || tp == NLA_S64) + tp)
-#define NLA_ENSURE_INT_TYPE(tp)				\
+#define NLA_ENSURE_INT_OR_BINARY_TYPE(tp)		\
 	(__NLA_ENSURE(tp == NLA_S8 || tp == NLA_U8 ||	\
 		      tp == NLA_S16 || tp == NLA_U16 ||	\
 		      tp == NLA_S32 || tp == NLA_U32 ||	\
 		      tp == NLA_S64 || tp == NLA_U64 ||	\
-		      tp == NLA_MSECS) + tp)
+		      tp == NLA_MSECS ||		\
+		      tp == NLA_BINARY) + tp)
 #define NLA_ENSURE_NO_VALIDATION_PTR(tp)		\
 	(__NLA_ENSURE(tp != NLA_BITFIELD32 &&		\
 		      tp != NLA_REJECT &&		\
@@ -390,14 +385,14 @@ struct nla_policy {
 		      tp != NLA_NESTED_ARRAY) + tp)
 
 #define NLA_POLICY_RANGE(tp, _min, _max) {		\
-	.type = NLA_ENSURE_INT_TYPE(tp),		\
+	.type = NLA_ENSURE_INT_OR_BINARY_TYPE(tp),	\
 	.validation_type = NLA_VALIDATE_RANGE,		\
 	.min = _min,					\
 	.max = _max					\
 }
 
 #define NLA_POLICY_FULL_RANGE(tp, _range) {		\
-	.type = NLA_ENSURE_UINT_TYPE(tp),		\
+	.type = NLA_ENSURE_UINT_OR_BINARY_TYPE(tp),	\
 	.validation_type = NLA_VALIDATE_RANGE_PTR,	\
 	.range = _range,				\
 }
@@ -409,13 +404,13 @@ struct nla_policy {
 }
 
 #define NLA_POLICY_MIN(tp, _min) {			\
-	.type = NLA_ENSURE_INT_TYPE(tp),		\
+	.type = NLA_ENSURE_INT_OR_BINARY_TYPE(tp),	\
 	.validation_type = NLA_VALIDATE_MIN,		\
 	.min = _min,					\
 }
 
 #define NLA_POLICY_MAX(tp, _max) {			\
-	.type = NLA_ENSURE_INT_TYPE(tp),		\
+	.type = NLA_ENSURE_INT_OR_BINARY_TYPE(tp),	\
 	.validation_type = NLA_VALIDATE_MAX,		\
 	.max = _max,					\
 }
@@ -427,6 +422,15 @@ struct nla_policy {
 	.len = __VA_ARGS__ + 0,				\
 }
 
+#define NLA_POLICY_EXACT_LEN(_len)	NLA_POLICY_RANGE(NLA_BINARY, _len, _len)
+#define NLA_POLICY_EXACT_LEN_WARN(_len) {			\
+	.type = NLA_BINARY,					\
+	.validation_type = NLA_VALIDATE_RANGE_WARN_TOO_LONG,	\
+	.min = _len,						\
+	.max = _len						\
+}
+#define NLA_POLICY_MIN_LEN(_len)	NLA_POLICY_MIN(NLA_BINARY, _len)
+
 /**
  * struct nl_info - netlink source information
  * @nlh: Netlink message header of original request
diff --git a/lib/nlattr.c b/lib/nlattr.c
index bc5b5cf608c4..d0d8526ff3f0 100644
--- a/lib/nlattr.c
+++ b/lib/nlattr.c
@@ -124,6 +124,7 @@ void nla_get_range_unsigned(const struct nla_policy *pt,
 		range->max = U8_MAX;
 		break;
 	case NLA_U16:
+	case NLA_BINARY:
 		range->max = U16_MAX;
 		break;
 	case NLA_U32:
@@ -140,6 +141,7 @@ void nla_get_range_unsigned(const struct nla_policy *pt,
 
 	switch (pt->validation_type) {
 	case NLA_VALIDATE_RANGE:
+	case NLA_VALIDATE_RANGE_WARN_TOO_LONG:
 		range->min = pt->min;
 		range->max = pt->max;
 		break;
@@ -157,9 +159,10 @@ void nla_get_range_unsigned(const struct nla_policy *pt,
 	}
 }
 
-static int nla_validate_int_range_unsigned(const struct nla_policy *pt,
-					   const struct nlattr *nla,
-					   struct netlink_ext_ack *extack)
+static int nla_validate_range_unsigned(const struct nla_policy *pt,
+				       const struct nlattr *nla,
+				       struct netlink_ext_ack *extack,
+				       unsigned int validate)
 {
 	struct netlink_range_validation range;
 	u64 value;
@@ -178,15 +181,39 @@ static int nla_validate_int_range_unsigned(const struct nla_policy *pt,
 	case NLA_MSECS:
 		value = nla_get_u64(nla);
 		break;
+	case NLA_BINARY:
+		value = nla_len(nla);
+		break;
 	default:
 		return -EINVAL;
 	}
 
 	nla_get_range_unsigned(pt, &range);
 
+	if (pt->validation_type == NLA_VALIDATE_RANGE_WARN_TOO_LONG &&
+	    pt->type == NLA_BINARY && value > range.max) {
+		pr_warn_ratelimited("netlink: '%s': attribute type %d has an invalid length.\n",
+				    current->comm, pt->type);
+		if (validate & NL_VALIDATE_STRICT_ATTRS) {
+			NL_SET_ERR_MSG_ATTR(extack, nla,
+					    "invalid attribute length");
+			return -EINVAL;
+		}
+
+		/* this assumes min < max (don't validate against min) */
+		return 0;
+	}
+
 	if (value < range.min || value > range.max) {
-		NL_SET_ERR_MSG_ATTR(extack, nla,
-				    "integer out of range");
+		bool binary = pt->type == NLA_BINARY;
+
+		if (binary)
+			NL_SET_ERR_MSG_ATTR(extack, nla,
+					    "binary attribute size out of range");
+		else
+			NL_SET_ERR_MSG_ATTR(extack, nla,
+					    "integer out of range");
+
 		return -ERANGE;
 	}
 
@@ -274,7 +301,8 @@ static int nla_validate_int_range_signed(const struct nla_policy *pt,
 
 static int nla_validate_int_range(const struct nla_policy *pt,
 				  const struct nlattr *nla,
-				  struct netlink_ext_ack *extack)
+				  struct netlink_ext_ack *extack,
+				  unsigned int validate)
 {
 	switch (pt->type) {
 	case NLA_U8:
@@ -282,7 +310,8 @@ static int nla_validate_int_range(const struct nla_policy *pt,
 	case NLA_U32:
 	case NLA_U64:
 	case NLA_MSECS:
-		return nla_validate_int_range_unsigned(pt, nla, extack);
+	case NLA_BINARY:
+		return nla_validate_range_unsigned(pt, nla, extack, validate);
 	case NLA_S8:
 	case NLA_S16:
 	case NLA_S32:
@@ -313,10 +342,7 @@ static int validate_nla(const struct nlattr *nla, int maxtype,
 
 	BUG_ON(pt->type > NLA_TYPE_MAX);
 
-	if ((nla_attr_len[pt->type] && attrlen != nla_attr_len[pt->type]) ||
-	    (pt->type == NLA_EXACT_LEN &&
-	     pt->validation_type == NLA_VALIDATE_WARN_TOO_LONG &&
-	     attrlen != pt->len)) {
+	if (nla_attr_len[pt->type] && attrlen != nla_attr_len[pt->type]) {
 		pr_warn_ratelimited("netlink: '%s': attribute type %d has an invalid length.\n",
 				    current->comm, type);
 		if (validate & NL_VALIDATE_STRICT_ATTRS) {
@@ -449,19 +475,10 @@ static int validate_nla(const struct nlattr *nla, int maxtype,
 					    "Unsupported attribute");
 			return -EINVAL;
 		}
-		/* fall through */
-	case NLA_MIN_LEN:
 		if (attrlen < pt->len)
 			goto out_err;
 		break;
 
-	case NLA_EXACT_LEN:
-		if (pt->validation_type != NLA_VALIDATE_WARN_TOO_LONG) {
-			if (attrlen != pt->len)
-				goto out_err;
-			break;
-		}
-		/* fall through */
 	default:
 		if (pt->len)
 			minlen = pt->len;
@@ -479,9 +496,10 @@ static int validate_nla(const struct nlattr *nla, int maxtype,
 		break;
 	case NLA_VALIDATE_RANGE_PTR:
 	case NLA_VALIDATE_RANGE:
+	case NLA_VALIDATE_RANGE_WARN_TOO_LONG:
 	case NLA_VALIDATE_MIN:
 	case NLA_VALIDATE_MAX:
-		err = nla_validate_int_range(pt, nla, extack);
+		err = nla_validate_int_range(pt, nla, extack, validate);
 		if (err)
 			return err;
 		break;
diff --git a/net/netlink/policy.c b/net/netlink/policy.c
index f6491853c797..46c11c9c212a 100644
--- a/net/netlink/policy.c
+++ b/net/netlink/policy.c
@@ -251,12 +251,6 @@ int netlink_policy_dump_write(struct sk_buff *skb, unsigned long _state)
 				pt->bitfield32_valid))
 			goto nla_put_failure;
 		break;
-	case NLA_EXACT_LEN:
-		type = NL_ATTR_TYPE_BINARY;
-		if (nla_put_u32(skb, NL_POLICY_TYPE_ATTR_MIN_LENGTH, pt->len) ||
-		    nla_put_u32(skb, NL_POLICY_TYPE_ATTR_MAX_LENGTH, pt->len))
-			goto nla_put_failure;
-		break;
 	case NLA_STRING:
 	case NLA_NUL_STRING:
 	case NLA_BINARY:
@@ -266,14 +260,26 @@ int netlink_policy_dump_write(struct sk_buff *skb, unsigned long _state)
 			type = NL_ATTR_TYPE_NUL_STRING;
 		else
 			type = NL_ATTR_TYPE_BINARY;
-		if (pt->len && nla_put_u32(skb, NL_POLICY_TYPE_ATTR_MAX_LENGTH,
-					   pt->len))
-			goto nla_put_failure;
-		break;
-	case NLA_MIN_LEN:
-		type = NL_ATTR_TYPE_BINARY;
-		if (nla_put_u32(skb, NL_POLICY_TYPE_ATTR_MIN_LENGTH, pt->len))
+
+		if (pt->validation_type != NLA_VALIDATE_NONE) {
+			struct netlink_range_validation range;
+
+			nla_get_range_unsigned(pt, &range);
+
+			if (range.min &&
+			    nla_put_u32(skb, NL_POLICY_TYPE_ATTR_MIN_LENGTH,
+					range.min))
+				goto nla_put_failure;
+
+			if (range.max < U16_MAX &&
+			    nla_put_u32(skb, NL_POLICY_TYPE_ATTR_MAX_LENGTH,
+					range.max))
+				goto nla_put_failure;
+		} else if (pt->len &&
+			   nla_put_u32(skb, NL_POLICY_TYPE_ATTR_MAX_LENGTH,
+				       pt->len)) {
 			goto nla_put_failure;
+		}
 		break;
 	case NLA_FLAG:
 		type = NL_ATTR_TYPE_FLAG;
-- 
2.26.2

