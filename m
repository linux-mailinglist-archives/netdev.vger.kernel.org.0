Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B4B81BDF81
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 15:50:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728040AbgD2NtU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 09:49:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726854AbgD2Ns6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 09:48:58 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91E22C03C1AD;
        Wed, 29 Apr 2020 06:48:58 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.93)
        (envelope-from <johannes@sipsolutions.net>)
        id 1jTn56-001vkM-G4; Wed, 29 Apr 2020 15:48:56 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     Antonio Quartulli <ordex@autistici.org>,
        linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 4/7] netlink: extend policy range validation
Date:   Wed, 29 Apr 2020 15:48:40 +0200
Message-Id: <20200429154836.b86f45043a5e.I7b46d9c85e4d7a99c0b5e0c2f54bb89b5750e6dc@changeid>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200429134843.42224-1-johannes@sipsolutions.net>
References: <20200429134843.42224-1-johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

Using a pointer to a struct indicating the min/max values,
extend the ability to do range validation for arbitrary
values. Small values in the s16 range can be kept in the
policy directly.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/netlink.h |  45 +++++++++++++++++
 lib/nlattr.c          | 112 ++++++++++++++++++++++++++++++++++--------
 2 files changed, 136 insertions(+), 21 deletions(-)

diff --git a/include/net/netlink.h b/include/net/netlink.h
index 671b29d170a8..94a7df4ab122 100644
--- a/include/net/netlink.h
+++ b/include/net/netlink.h
@@ -189,11 +189,20 @@ enum {
 
 #define NLA_TYPE_MAX (__NLA_TYPE_MAX - 1)
 
+struct netlink_range_validation {
+	u64 min, max;
+};
+
+struct netlink_range_validation_signed {
+	s64 min, max;
+};
+
 enum nla_policy_validation {
 	NLA_VALIDATE_NONE,
 	NLA_VALIDATE_RANGE,
 	NLA_VALIDATE_MIN,
 	NLA_VALIDATE_MAX,
+	NLA_VALIDATE_RANGE_PTR,
 	NLA_VALIDATE_FUNCTION,
 };
 
@@ -271,6 +280,22 @@ enum nla_policy_validation {
  *                         of s16 - do that as usual in the code instead.
  *                         Use the NLA_POLICY_MIN(), NLA_POLICY_MAX() and
  *                         NLA_POLICY_RANGE() macros.
+ *    NLA_U8,
+ *    NLA_U16,
+ *    NLA_U32,
+ *    NLA_U64              If the validation_type field instead is set to
+ *                         NLA_VALIDATE_RANGE_PTR, `range' must be a pointer
+ *                         to a struct netlink_range_validation that indicates
+ *                         the min/max values.
+ *                         Use NLA_POLICY_FULL_RANGE().
+ *    NLA_S8,
+ *    NLA_S16,
+ *    NLA_S32,
+ *    NLA_S64              If the validation_type field instead is set to
+ *                         NLA_VALIDATE_RANGE_PTR, `range_signed' must be a
+ *                         pointer to a struct netlink_range_validation_signed
+ *                         that indicates the min/max values.
+ *                         Use NLA_POLICY_FULL_RANGE_SIGNED().
  *    All other            Unused - but note that it's a union
  *
  * Meaning of `validate' field, use via NLA_POLICY_VALIDATE_FN:
@@ -296,6 +321,8 @@ struct nla_policy {
 		const u32 bitfield32_valid;
 		const char *reject_message;
 		const struct nla_policy *nested_policy;
+		struct netlink_range_validation *range;
+		struct netlink_range_validation_signed *range_signed;
 		struct {
 			s16 min, max;
 		};
@@ -342,6 +369,12 @@ struct nla_policy {
 	{ .type = NLA_BITFIELD32, .bitfield32_valid = valid }
 
 #define __NLA_ENSURE(condition) BUILD_BUG_ON_ZERO(!(condition))
+#define NLA_ENSURE_UINT_TYPE(tp)			\
+	(__NLA_ENSURE(tp == NLA_U8 || tp == NLA_U16 ||	\
+		      tp == NLA_U32 || tp == NLA_U64) + tp)
+#define NLA_ENSURE_SINT_TYPE(tp)			\
+	(__NLA_ENSURE(tp == NLA_S8 || tp == NLA_S16  ||	\
+		      tp == NLA_S32 || tp == NLA_S64) + tp)
 #define NLA_ENSURE_INT_TYPE(tp)				\
 	(__NLA_ENSURE(tp == NLA_S8 || tp == NLA_U8 ||	\
 		      tp == NLA_S16 || tp == NLA_U16 ||	\
@@ -360,6 +393,18 @@ struct nla_policy {
 	.max = _max					\
 }
 
+#define NLA_POLICY_FULL_RANGE(tp, _range) {		\
+	.type = NLA_ENSURE_UINT_TYPE(tp),		\
+	.validation_type = NLA_VALIDATE_RANGE_PTR,	\
+	.range = _range,				\
+}
+
+#define NLA_POLICY_FULL_RANGE_SIGNED(tp, _range) {	\
+	.type = NLA_ENSURE_SINT_TYPE(tp),		\
+	.validation_type = NLA_VALIDATE_RANGE_PTR,	\
+	.range_signed = _range,				\
+}
+
 #define NLA_POLICY_MIN(tp, _min) {			\
 	.type = NLA_ENSURE_INT_TYPE(tp),		\
 	.validation_type = NLA_VALIDATE_MIN,		\
diff --git a/lib/nlattr.c b/lib/nlattr.c
index 7f7ebd89caa4..bb66d06cc6f9 100644
--- a/lib/nlattr.c
+++ b/lib/nlattr.c
@@ -111,17 +111,33 @@ static int nla_validate_array(const struct nlattr *head, int len, int maxtype,
 	return 0;
 }
 
-static int nla_validate_int_range(const struct nla_policy *pt,
-				  const struct nlattr *nla,
-				  struct netlink_ext_ack *extack)
+static int nla_validate_int_range_unsigned(const struct nla_policy *pt,
+					   const struct nlattr *nla,
+					   struct netlink_ext_ack *extack)
 {
-	bool validate_min, validate_max;
-	s64 value;
+	struct netlink_range_validation _range = {
+		.min = 0,
+		.max = U64_MAX,
+	}, *range = &_range;
+	u64 value;
 
-	validate_min = pt->validation_type == NLA_VALIDATE_RANGE ||
-		       pt->validation_type == NLA_VALIDATE_MIN;
-	validate_max = pt->validation_type == NLA_VALIDATE_RANGE ||
-		       pt->validation_type == NLA_VALIDATE_MAX;
+	WARN_ON_ONCE(pt->min < 0 || pt->max < 0);
+
+	switch (pt->validation_type) {
+	case NLA_VALIDATE_RANGE:
+		range->min = pt->min;
+		range->max = pt->max;
+		break;
+	case NLA_VALIDATE_RANGE_PTR:
+		range = pt->range;
+		break;
+	case NLA_VALIDATE_MIN:
+		range->min = pt->min;
+		break;
+	case NLA_VALIDATE_MAX:
+		range->max = pt->max;
+		break;
+	}
 
 	switch (pt->type) {
 	case NLA_U8:
@@ -133,6 +149,49 @@ static int nla_validate_int_range(const struct nla_policy *pt,
 	case NLA_U32:
 		value = nla_get_u32(nla);
 		break;
+	case NLA_U64:
+		value = nla_get_u64(nla);
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	if (value < range->min || value > range->max) {
+		NL_SET_ERR_MSG_ATTR(extack, nla,
+				    "integer out of range");
+		return -ERANGE;
+	}
+
+	return 0;
+}
+
+static int nla_validate_int_range_signed(const struct nla_policy *pt,
+					 const struct nlattr *nla,
+					 struct netlink_ext_ack *extack)
+{
+	struct netlink_range_validation_signed _range = {
+		.min = S64_MIN,
+		.max = S64_MAX,
+	}, *range = &_range;
+	s64 value;
+
+	switch (pt->validation_type) {
+	case NLA_VALIDATE_RANGE:
+		range->min = pt->min;
+		range->max = pt->max;
+		break;
+	case NLA_VALIDATE_RANGE_PTR:
+		range = pt->range_signed;
+		break;
+	case NLA_VALIDATE_MIN:
+		range->min = pt->min;
+		break;
+	case NLA_VALIDATE_MAX:
+		range->max = pt->max;
+		break;
+	}
+
+	switch (pt->type) {
 	case NLA_S8:
 		value = nla_get_s8(nla);
 		break;
@@ -145,22 +204,11 @@ static int nla_validate_int_range(const struct nla_policy *pt,
 	case NLA_S64:
 		value = nla_get_s64(nla);
 		break;
-	case NLA_U64:
-		/* treat this one specially, since it may not fit into s64 */
-		if ((validate_min && nla_get_u64(nla) < pt->min) ||
-		    (validate_max && nla_get_u64(nla) > pt->max)) {
-			NL_SET_ERR_MSG_ATTR(extack, nla,
-					    "integer out of range");
-			return -ERANGE;
-		}
-		return 0;
 	default:
-		WARN_ON(1);
 		return -EINVAL;
 	}
 
-	if ((validate_min && value < pt->min) ||
-	    (validate_max && value > pt->max)) {
+	if (value < range->min || value > range->max) {
 		NL_SET_ERR_MSG_ATTR(extack, nla,
 				    "integer out of range");
 		return -ERANGE;
@@ -169,6 +217,27 @@ static int nla_validate_int_range(const struct nla_policy *pt,
 	return 0;
 }
 
+static int nla_validate_int_range(const struct nla_policy *pt,
+				  const struct nlattr *nla,
+				  struct netlink_ext_ack *extack)
+{
+	switch (pt->type) {
+	case NLA_U8:
+	case NLA_U16:
+	case NLA_U32:
+	case NLA_U64:
+		return nla_validate_int_range_unsigned(pt, nla, extack);
+	case NLA_S8:
+	case NLA_S16:
+	case NLA_S32:
+	case NLA_S64:
+		return nla_validate_int_range_signed(pt, nla, extack);
+	default:
+		WARN_ON(1);
+		return -EINVAL;
+	}
+}
+
 static int validate_nla(const struct nlattr *nla, int maxtype,
 			const struct nla_policy *policy, unsigned int validate,
 			struct netlink_ext_ack *extack, unsigned int depth)
@@ -348,6 +417,7 @@ static int validate_nla(const struct nlattr *nla, int maxtype,
 	case NLA_VALIDATE_NONE:
 		/* nothing to do */
 		break;
+	case NLA_VALIDATE_RANGE_PTR:
 	case NLA_VALIDATE_RANGE:
 	case NLA_VALIDATE_MIN:
 	case NLA_VALIDATE_MAX:
-- 
2.25.1

