Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F27112A61
	for <lists+netdev@lfdr.de>; Fri,  3 May 2019 11:25:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727342AbfECJZZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 05:25:25 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:51662 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727248AbfECJZO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 May 2019 05:25:14 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hMURN-0005qF-0G; Fri, 03 May 2019 11:25:13 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH v2 6/8] netlink: factor out policy range helpers
Date:   Fri,  3 May 2019 11:24:59 +0200
Message-Id: <20190503092501.10275-7-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20190503092501.10275-1-johannes@sipsolutions.net>
References: <20190503092501.10275-1-johannes@sipsolutions.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

Add helpers to get the policy's signed/unsigned range
validation data.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/netlink.h |  5 +++
 lib/nlattr.c          | 95 +++++++++++++++++++++++++++++++++----------
 2 files changed, 79 insertions(+), 21 deletions(-)

diff --git a/include/net/netlink.h b/include/net/netlink.h
index 3c3bbd2ae2dc..c2b4bc819784 100644
--- a/include/net/netlink.h
+++ b/include/net/netlink.h
@@ -1895,4 +1895,9 @@ static inline bool nla_is_last(const struct nlattr *nla, int rem)
 	return nla->nla_len == rem;
 }
 
+void nla_get_range_unsigned(const struct nla_policy *pt,
+			    struct netlink_range_validation *range);
+void nla_get_range_signed(const struct nla_policy *pt,
+			  struct netlink_range_validation_signed *range);
+
 #endif
diff --git a/lib/nlattr.c b/lib/nlattr.c
index 05761d2a74cc..3db7a6984cb0 100644
--- a/lib/nlattr.c
+++ b/lib/nlattr.c
@@ -96,25 +96,39 @@ static int nla_validate_array(const struct nlattr *head, int len, int maxtype,
 	return 0;
 }
 
-static int nla_validate_int_range_unsigned(const struct nla_policy *pt,
-					   const struct nlattr *nla,
-					   struct netlink_ext_ack *extack)
+void nla_get_range_unsigned(const struct nla_policy *pt,
+			    struct netlink_range_validation *range)
 {
-	struct netlink_range_validation _range = {
-		.min = 0,
-		.max = U64_MAX,
-	}, *range = &_range;
-	u64 value;
-
 	WARN_ON_ONCE(pt->min < 0 || pt->max < 0);
 
+	range->min = 0;
+
+	switch (pt->type) {
+	case NLA_U8:
+		range->max = U8_MAX;
+		break;
+	case NLA_U16:
+		range->max = U16_MAX;
+		break;
+	case NLA_U32:
+		range->max = U32_MAX;
+		break;
+	case NLA_U64:
+	case NLA_MSECS:
+		range->max = U64_MAX;
+		break;
+	default:
+		WARN_ON_ONCE(1);
+		return;
+	}
+
 	switch (pt->validation_type) {
 	case NLA_VALIDATE_RANGE:
 		range->min = pt->min;
 		range->max = pt->max;
 		break;
 	case NLA_VALIDATE_RANGE_PTR:
-		range = pt->range;
+		*range = *pt->range;
 		break;
 	case NLA_VALIDATE_MIN:
 		range->min = pt->min;
@@ -122,7 +136,17 @@ static int nla_validate_int_range_unsigned(const struct nla_policy *pt,
 	case NLA_VALIDATE_MAX:
 		range->max = pt->max;
 		break;
+	default:
+		break;
 	}
+}
+
+static int nla_validate_int_range_unsigned(const struct nla_policy *pt,
+					   const struct nlattr *nla,
+					   struct netlink_ext_ack *extack)
+{
+	struct netlink_range_validation range;
+	u64 value;
 
 	switch (pt->type) {
 	case NLA_U8:
@@ -142,7 +166,9 @@ static int nla_validate_int_range_unsigned(const struct nla_policy *pt,
 		return -EINVAL;
 	}
 
-	if (value < range->min || value > range->max) {
+	nla_get_range_unsigned(pt, &range);
+
+	if (value < range.min || value > range.max) {
 		NL_SET_ERR_MSG_ATTR(extack, nla,
 				    "integer out of range");
 		return -ERANGE;
@@ -151,15 +177,30 @@ static int nla_validate_int_range_unsigned(const struct nla_policy *pt,
 	return 0;
 }
 
-static int nla_validate_int_range_signed(const struct nla_policy *pt,
-					 const struct nlattr *nla,
-					 struct netlink_ext_ack *extack)
+void nla_get_range_signed(const struct nla_policy *pt,
+			  struct netlink_range_validation_signed *range)
 {
-	struct netlink_range_validation_signed _range = {
-		.min = S64_MIN,
-		.max = S64_MAX,
-	}, *range = &_range;
-	s64 value;
+	switch (pt->type) {
+	case NLA_S8:
+		range->min = S8_MIN;
+		range->max = S8_MAX;
+		break;
+	case NLA_S16:
+		range->min = S16_MIN;
+		range->max = S16_MAX;
+		break;
+	case NLA_S32:
+		range->min = S32_MIN;
+		range->max = S32_MAX;
+		break;
+	case NLA_S64:
+		range->min = S64_MIN;
+		range->max = S64_MAX;
+		break;
+	default:
+		WARN_ON_ONCE(1);
+		return;
+	}
 
 	switch (pt->validation_type) {
 	case NLA_VALIDATE_RANGE:
@@ -167,7 +208,7 @@ static int nla_validate_int_range_signed(const struct nla_policy *pt,
 		range->max = pt->max;
 		break;
 	case NLA_VALIDATE_RANGE_PTR:
-		range = pt->range_signed;
+		*range = *pt->range_signed;
 		break;
 	case NLA_VALIDATE_MIN:
 		range->min = pt->min;
@@ -175,7 +216,17 @@ static int nla_validate_int_range_signed(const struct nla_policy *pt,
 	case NLA_VALIDATE_MAX:
 		range->max = pt->max;
 		break;
+	default:
+		break;
 	}
+}
+
+static int nla_validate_int_range_signed(const struct nla_policy *pt,
+					 const struct nlattr *nla,
+					 struct netlink_ext_ack *extack)
+{
+	struct netlink_range_validation_signed range;
+	s64 value;
 
 	switch (pt->type) {
 	case NLA_S8:
@@ -194,7 +245,9 @@ static int nla_validate_int_range_signed(const struct nla_policy *pt,
 		return -EINVAL;
 	}
 
-	if (value < range->min || value > range->max) {
+	nla_get_range_signed(pt, &range);
+
+	if (value < range.min || value > range.max) {
 		NL_SET_ERR_MSG_ATTR(extack, nla,
 				    "integer out of range");
 		return -ERANGE;
-- 
2.17.2

