Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C6701BDF7B
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 15:49:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727996AbgD2NtE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 09:49:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727934AbgD2Ns7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 09:48:59 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60D87C03C1AD;
        Wed, 29 Apr 2020 06:48:59 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.93)
        (envelope-from <johannes@sipsolutions.net>)
        id 1jTn57-001vkM-N6; Wed, 29 Apr 2020 15:48:57 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     Antonio Quartulli <ordex@autistici.org>,
        linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 7/7] netlink: factor out policy range helpers
Date:   Wed, 29 Apr 2020 15:48:43 +0200
Message-Id: <20200429154836.02b4e60d49a3.Ibb79f28261ecab0dd1de120da488db29cf011389@changeid>
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

Add helpers to get the policy's signed/unsigned range
validation data.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/netlink.h |  5 +++
 lib/nlattr.c          | 95 +++++++++++++++++++++++++++++++++----------
 2 files changed, 79 insertions(+), 21 deletions(-)

diff --git a/include/net/netlink.h b/include/net/netlink.h
index 4d4a733f1e8d..557b67f1db99 100644
--- a/include/net/netlink.h
+++ b/include/net/netlink.h
@@ -1928,4 +1928,9 @@ static inline bool nla_is_last(const struct nlattr *nla, int rem)
 	return nla->nla_len == rem;
 }
 
+void nla_get_range_unsigned(const struct nla_policy *pt,
+			    struct netlink_range_validation *range);
+void nla_get_range_signed(const struct nla_policy *pt,
+			  struct netlink_range_validation_signed *range);
+
 #endif
diff --git a/lib/nlattr.c b/lib/nlattr.c
index 6e4cb9458050..b78495ef6d31 100644
--- a/lib/nlattr.c
+++ b/lib/nlattr.c
@@ -111,25 +111,39 @@ static int nla_validate_array(const struct nlattr *head, int len, int maxtype,
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
@@ -137,7 +151,17 @@ static int nla_validate_int_range_unsigned(const struct nla_policy *pt,
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
@@ -157,7 +181,9 @@ static int nla_validate_int_range_unsigned(const struct nla_policy *pt,
 		return -EINVAL;
 	}
 
-	if (value < range->min || value > range->max) {
+	nla_get_range_unsigned(pt, &range);
+
+	if (value < range.min || value > range.max) {
 		NL_SET_ERR_MSG_ATTR(extack, nla,
 				    "integer out of range");
 		return -ERANGE;
@@ -166,15 +192,30 @@ static int nla_validate_int_range_unsigned(const struct nla_policy *pt,
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
@@ -182,7 +223,7 @@ static int nla_validate_int_range_signed(const struct nla_policy *pt,
 		range->max = pt->max;
 		break;
 	case NLA_VALIDATE_RANGE_PTR:
-		range = pt->range_signed;
+		*range = *pt->range_signed;
 		break;
 	case NLA_VALIDATE_MIN:
 		range->min = pt->min;
@@ -190,7 +231,17 @@ static int nla_validate_int_range_signed(const struct nla_policy *pt,
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
@@ -209,7 +260,9 @@ static int nla_validate_int_range_signed(const struct nla_policy *pt,
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
2.25.1

