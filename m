Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7A7A1BDF7A
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 15:49:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727807AbgD2Ns7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 09:48:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726913AbgD2Ns6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 09:48:58 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7F42C03C1AE;
        Wed, 29 Apr 2020 06:48:57 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.93)
        (envelope-from <johannes@sipsolutions.net>)
        id 1jTn55-001vkM-PU; Wed, 29 Apr 2020 15:48:55 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     Antonio Quartulli <ordex@autistici.org>,
        linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 2/7] netlink: limit recursion depth in policy validation
Date:   Wed, 29 Apr 2020 15:48:38 +0200
Message-Id: <20200429154836.e15dc653f1dc.Iddcc303b711eabe6cb41f1647c49714d8792bd55@changeid>
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

Now that we have nested policies, we can theoretically
recurse forever parsing attributes if a (sub-)policy
refers back to a higher level one. This is a situation
that has happened in nl80211, and we've avoided it there
by not linking it.

Add some code to netlink parsing to limit recursion depth.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 lib/nlattr.c | 46 ++++++++++++++++++++++++++++++++++------------
 1 file changed, 34 insertions(+), 12 deletions(-)

diff --git a/lib/nlattr.c b/lib/nlattr.c
index 3df05db732ca..7f7ebd89caa4 100644
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
@@ -156,7 +171,7 @@ static int nla_validate_int_range(const struct nla_policy *pt,
 
 static int validate_nla(const struct nlattr *nla, int maxtype,
 			const struct nla_policy *policy, unsigned int validate,
-			struct netlink_ext_ack *extack)
+			struct netlink_ext_ack *extack, unsigned int depth)
 {
 	u16 strict_start_type = policy[0].strict_start_type;
 	const struct nla_policy *pt;
@@ -269,9 +284,10 @@ static int validate_nla(const struct nlattr *nla, int maxtype,
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
@@ -294,7 +310,7 @@ static int validate_nla(const struct nlattr *nla, int maxtype,
 
 			err = nla_validate_array(nla_data(nla), nla_len(nla),
 						 pt->len, pt->nested_policy,
-						 extack, validate);
+						 extack, validate, depth);
 			if (err < 0) {
 				/*
 				 * return directly to preserve the inner
@@ -358,11 +374,17 @@ static int __nla_validate_parse(const struct nlattr *head, int len, int maxtype,
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
 
@@ -379,7 +401,7 @@ static int __nla_validate_parse(const struct nlattr *head, int len, int maxtype,
 		}
 		if (policy) {
 			int err = validate_nla(nla, maxtype, policy,
-					       validate, extack);
+					       validate, extack, depth);
 
 			if (err < 0)
 				return err;
@@ -421,7 +443,7 @@ int __nla_validate(const struct nlattr *head, int len, int maxtype,
 		   struct netlink_ext_ack *extack)
 {
 	return __nla_validate_parse(head, len, maxtype, policy, validate,
-				    extack, NULL);
+				    extack, NULL, 0);
 }
 EXPORT_SYMBOL(__nla_validate);
 
@@ -476,7 +498,7 @@ int __nla_parse(struct nlattr **tb, int maxtype,
 		struct netlink_ext_ack *extack)
 {
 	return __nla_validate_parse(head, len, maxtype, policy, validate,
-				    extack, tb);
+				    extack, tb, 0);
 }
 EXPORT_SYMBOL(__nla_parse);
 
-- 
2.25.1

