Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9131412A5F
	for <lists+netdev@lfdr.de>; Fri,  3 May 2019 11:25:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727280AbfECJZS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 05:25:18 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:51670 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727252AbfECJZQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 May 2019 05:25:16 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hMURN-0005qF-K5; Fri, 03 May 2019 11:25:13 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH v2 8/8] netlink: limit recursion depth in policy validation
Date:   Fri,  3 May 2019 11:25:01 +0200
Message-Id: <20190503092501.10275-9-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20190503092501.10275-1-johannes@sipsolutions.net>
References: <20190503092501.10275-1-johannes@sipsolutions.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

Now that we have nested policies, we can theoretically
recurse forever parsing attributes if a (sub-)policy
refers back to a higher level one. This is a situation
that has happened in nl80211, and we've avoided it there
by not linking it.

Add some code to netlink parsing to limit recursion depth,
allowing us to safely change nl80211 to actually link the
nested policy, which in turn allows some code cleanups.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 lib/nlattr.c           | 46 +++++++++++++++++++++++++++++++-----------
 net/wireless/nl80211.c | 10 ++++-----
 net/wireless/nl80211.h |  2 --
 net/wireless/pmsr.c    |  3 +--
 4 files changed, 39 insertions(+), 22 deletions(-)

diff --git a/lib/nlattr.c b/lib/nlattr.c
index 3db7a6984cb0..ef06645de56c 100644
--- a/lib/nlattr.c
+++ b/lib/nlattr.c
@@ -44,6 +44,20 @@ static const u8 nla_attr_minlen[NLA_TYPE_MAX+1] = {
 	[NLA_S64]	= sizeof(s64),
 };
 
+/*
+ * Nested policies might refer back to the original
+ * policy in some cases, and userspace could try to
+ * abuse that and recurse by nesting in the right
+ * ways. Limit recursion to avoid this problem.
+ */
+#define MAX_POLICY_RECURSION_DEPTH	10
+
+static int __nla_validate_parse(const struct nlattr *head, int len, int maxtype,
+				const struct nla_policy *policy,
+				unsigned int validate,
+				struct netlink_ext_ack *extack,
+				struct nlattr **tb, unsigned int depth);
+
 static int validate_nla_bitfield32(const struct nlattr *nla,
 				   const u32 valid_flags_mask)
 {
@@ -70,7 +84,7 @@ static int validate_nla_bitfield32(const struct nlattr *nla,
 static int nla_validate_array(const struct nlattr *head, int len, int maxtype,
 			      const struct nla_policy *policy,
 			      struct netlink_ext_ack *extack,
-			      unsigned int validate)
+			      unsigned int validate, unsigned int depth)
 {
 	const struct nlattr *entry;
 	int rem;
@@ -87,8 +101,9 @@ static int nla_validate_array(const struct nlattr *head, int len, int maxtype,
 			return -ERANGE;
 		}
 
-		ret = __nla_validate(nla_data(entry), nla_len(entry),
-				     maxtype, policy, validate, extack);
+		ret = __nla_validate_parse(nla_data(entry), nla_len(entry),
+					   maxtype, policy, validate, extack,
+					   NULL, depth + 1);
 		if (ret < 0)
 			return ret;
 	}
@@ -280,7 +295,7 @@ static int nla_validate_int_range(const struct nla_policy *pt,
 
 static int validate_nla(const struct nlattr *nla, int maxtype,
 			const struct nla_policy *policy, unsigned int validate,
-			struct netlink_ext_ack *extack)
+			struct netlink_ext_ack *extack, unsigned int depth)
 {
 	u16 strict_start_type = policy[0].strict_start_type;
 	const struct nla_policy *pt;
@@ -375,9 +390,10 @@ static int validate_nla(const struct nlattr *nla, int maxtype,
 		if (attrlen < NLA_HDRLEN)
 			goto out_err;
 		if (pt->nested_policy) {
-			err = __nla_validate(nla_data(nla), nla_len(nla), pt->len,
-					     pt->nested_policy, validate,
-					     extack);
+			err = __nla_validate_parse(nla_data(nla), nla_len(nla),
+						   pt->len, pt->nested_policy,
+						   validate, extack, NULL,
+						   depth + 1);
 			if (err < 0) {
 				/*
 				 * return directly to preserve the inner
@@ -400,7 +416,7 @@ static int validate_nla(const struct nlattr *nla, int maxtype,
 
 			err = nla_validate_array(nla_data(nla), nla_len(nla),
 						 pt->len, pt->nested_policy,
-						 extack, validate);
+						 extack, validate, depth);
 			if (err < 0) {
 				/*
 				 * return directly to preserve the inner
@@ -472,11 +488,17 @@ static int __nla_validate_parse(const struct nlattr *head, int len, int maxtype,
 				const struct nla_policy *policy,
 				unsigned int validate,
 				struct netlink_ext_ack *extack,
-				struct nlattr **tb)
+				struct nlattr **tb, unsigned int depth)
 {
 	const struct nlattr *nla;
 	int rem;
 
+	if (depth >= MAX_POLICY_RECURSION_DEPTH) {
+		NL_SET_ERR_MSG(extack,
+			       "allowed policy recursion depth exceeded");
+		return -EINVAL;
+	}
+
 	if (tb)
 		memset(tb, 0, sizeof(struct nlattr *) * (maxtype + 1));
 
@@ -492,7 +514,7 @@ static int __nla_validate_parse(const struct nlattr *head, int len, int maxtype,
 		}
 		if (policy) {
 			int err = validate_nla(nla, maxtype, policy,
-					       validate, extack);
+					       validate, extack, depth);
 
 			if (err < 0)
 				return err;
@@ -534,7 +556,7 @@ int __nla_validate(const struct nlattr *head, int len, int maxtype,
 		   struct netlink_ext_ack *extack)
 {
 	return __nla_validate_parse(head, len, maxtype, policy, validate,
-				    extack, NULL);
+				    extack, NULL, 0);
 }
 EXPORT_SYMBOL(__nla_validate);
 
@@ -589,7 +611,7 @@ int __nla_parse(struct nlattr **tb, int maxtype,
 		struct netlink_ext_ack *extack)
 {
 	return __nla_validate_parse(head, len, maxtype, policy, validate,
-				    extack, tb);
+				    extack, tb, 0);
 }
 EXPORT_SYMBOL(__nla_parse);
 
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index f40a004ec6f2..d47629214705 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -219,6 +219,8 @@ static int validate_ie_attr(const struct nlattr *attr,
 }
 
 /* policy for the attributes */
+static const struct nla_policy nl80211_policy[NUM_NL80211_ATTR];
+
 static const struct nla_policy
 nl80211_ftm_responder_policy[NL80211_FTM_RESP_ATTR_MAX + 1] = {
 	[NL80211_FTM_RESP_ATTR_ENABLED] = { .type = NLA_FLAG, },
@@ -260,11 +262,7 @@ nl80211_pmsr_req_attr_policy[NL80211_PMSR_REQ_ATTR_MAX + 1] = {
 static const struct nla_policy
 nl80211_psmr_peer_attr_policy[NL80211_PMSR_PEER_ATTR_MAX + 1] = {
 	[NL80211_PMSR_PEER_ATTR_ADDR] = NLA_POLICY_ETH_ADDR,
-	/*
-	 * we could specify this again to be the top-level policy,
-	 * but that would open us up to recursion problems ...
-	 */
-	[NL80211_PMSR_PEER_ATTR_CHAN] = { .type = NLA_NESTED },
+	[NL80211_PMSR_PEER_ATTR_CHAN] = NLA_POLICY_NESTED(nl80211_policy),
 	[NL80211_PMSR_PEER_ATTR_REQ] =
 		NLA_POLICY_NESTED(nl80211_pmsr_req_attr_policy),
 	[NL80211_PMSR_PEER_ATTR_RESP] = { .type = NLA_REJECT },
@@ -280,7 +278,7 @@ nl80211_pmsr_attr_policy[NL80211_PMSR_ATTR_MAX + 1] = {
 		NLA_POLICY_NESTED_ARRAY(nl80211_psmr_peer_attr_policy),
 };
 
-const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] = {
+static const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] = {
 	[NL80211_ATTR_WIPHY] = { .type = NLA_U32 },
 	[NL80211_ATTR_WIPHY_NAME] = { .type = NLA_NUL_STRING,
 				      .len = 20-1 },
diff --git a/net/wireless/nl80211.h b/net/wireless/nl80211.h
index a41e94a49a89..d3e8e426c486 100644
--- a/net/wireless/nl80211.h
+++ b/net/wireless/nl80211.h
@@ -11,8 +11,6 @@
 int nl80211_init(void);
 void nl80211_exit(void);
 
-extern const struct nla_policy nl80211_policy[NUM_NL80211_ATTR];
-
 void *nl80211hdr_put(struct sk_buff *skb, u32 portid, u32 seq,
 		     int flags, u8 cmd);
 bool nl80211_put_sta_rate(struct sk_buff *msg, struct rate_info *info,
diff --git a/net/wireless/pmsr.c b/net/wireless/pmsr.c
index 1b190475359a..69f64b36d379 100644
--- a/net/wireless/pmsr.c
+++ b/net/wireless/pmsr.c
@@ -155,10 +155,9 @@ static int pmsr_parse_peer(struct cfg80211_registered_device *rdev,
 
 	/* reuse info->attrs */
 	memset(info->attrs, 0, sizeof(*info->attrs) * (NL80211_ATTR_MAX + 1));
-	/* need to validate here, we don't want to have validation recursion */
 	err = nla_parse_nested_deprecated(info->attrs, NL80211_ATTR_MAX,
 					  tb[NL80211_PMSR_PEER_ATTR_CHAN],
-					  nl80211_policy, info->extack);
+					  NULL, info->extack);
 	if (err)
 		return err;
 
-- 
2.17.2

