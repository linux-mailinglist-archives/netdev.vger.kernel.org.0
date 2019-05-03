Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE1C012A62
	for <lists+netdev@lfdr.de>; Fri,  3 May 2019 11:25:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727331AbfECJZY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 05:25:24 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:51658 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727130AbfECJZO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 May 2019 05:25:14 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hMURM-0005qF-Nb; Fri, 03 May 2019 11:25:12 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH v2 5/8] netlink: remove NLA_EXACT_LEN_WARN
Date:   Fri,  3 May 2019 11:24:58 +0200
Message-Id: <20190503092501.10275-6-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20190503092501.10275-1-johannes@sipsolutions.net>
References: <20190503092501.10275-1-johannes@sipsolutions.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

Use a validation type instead, so we can later expose
the NLA_* values to userspace for policy descriptions.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/netlink.h | 15 ++++++++-------
 lib/nlattr.c          | 16 ++++++++++------
 2 files changed, 18 insertions(+), 13 deletions(-)

diff --git a/include/net/netlink.h b/include/net/netlink.h
index 2b035bf8daf6..3c3bbd2ae2dc 100644
--- a/include/net/netlink.h
+++ b/include/net/netlink.h
@@ -182,7 +182,6 @@ enum {
 	NLA_BITFIELD32,
 	NLA_REJECT,
 	NLA_EXACT_LEN,
-	NLA_EXACT_LEN_WARN,
 	NLA_MIN_LEN,
 	__NLA_TYPE_MAX,
 };
@@ -204,6 +203,7 @@ enum nla_policy_validation {
 	NLA_VALIDATE_MAX,
 	NLA_VALIDATE_RANGE_PTR,
 	NLA_VALIDATE_FUNCTION,
+	NLA_VALIDATE_WARN_TOO_LONG,
 };
 
 /**
@@ -237,10 +237,10 @@ enum nla_policy_validation {
  *                         just like "All other"
  *    NLA_BITFIELD32       Unused
  *    NLA_REJECT           Unused
- *    NLA_EXACT_LEN        Attribute must have exactly this length, otherwise
- *                         it is rejected.
- *    NLA_EXACT_LEN_WARN   Attribute should have exactly this length, a warning
- *                         is logged if it is longer, shorter is rejected.
+ *    NLA_EXACT_LEN        Attribute should have exactly this length, otherwise
+ *                         it is rejected or warned about, the latter happening
+ *                         if and only if the `validation_type' is set to
+ *                         NLA_VALIDATE_WARN_TOO_LONG.
  *    NLA_MIN_LEN          Minimum length of attribute payload
  *    All other            Minimum length of attribute payload
  *
@@ -353,8 +353,9 @@ struct nla_policy {
 };
 
 #define NLA_POLICY_EXACT_LEN(_len)	{ .type = NLA_EXACT_LEN, .len = _len }
-#define NLA_POLICY_EXACT_LEN_WARN(_len)	{ .type = NLA_EXACT_LEN_WARN, \
-					  .len = _len }
+#define NLA_POLICY_EXACT_LEN_WARN(_len) \
+	{ .type = NLA_EXACT_LEN, .len = _len, \
+	  .validation_type = NLA_VALIDATE_WARN_TOO_LONG, }
 #define NLA_POLICY_MIN_LEN(_len)	{ .type = NLA_MIN_LEN, .len = _len }
 
 #define NLA_POLICY_ETH_ADDR		NLA_POLICY_EXACT_LEN(ETH_ALEN)
diff --git a/lib/nlattr.c b/lib/nlattr.c
index c8789de96046..05761d2a74cc 100644
--- a/lib/nlattr.c
+++ b/lib/nlattr.c
@@ -245,7 +245,9 @@ static int validate_nla(const struct nlattr *nla, int maxtype,
 	BUG_ON(pt->type > NLA_TYPE_MAX);
 
 	if ((nla_attr_len[pt->type] && attrlen != nla_attr_len[pt->type]) ||
-	    (pt->type == NLA_EXACT_LEN_WARN && attrlen != pt->len)) {
+	    (pt->type == NLA_EXACT_LEN &&
+	     pt->validation_type == NLA_VALIDATE_WARN_TOO_LONG &&
+	     attrlen != pt->len)) {
 		pr_warn_ratelimited("netlink: '%s': attribute type %d has an invalid length.\n",
 				    current->comm, type);
 		if (validate & NL_VALIDATE_STRICT_ATTRS) {
@@ -256,11 +258,6 @@ static int validate_nla(const struct nlattr *nla, int maxtype,
 	}
 
 	switch (pt->type) {
-	case NLA_EXACT_LEN:
-		if (attrlen != pt->len)
-			goto out_err;
-		break;
-
 	case NLA_REJECT:
 		if (extack && pt->reject_message) {
 			NL_SET_BAD_ATTR(extack, nla);
@@ -373,6 +370,13 @@ static int validate_nla(const struct nlattr *nla, int maxtype,
 			goto out_err;
 		break;
 
+	case NLA_EXACT_LEN:
+		if (pt->validation_type != NLA_VALIDATE_WARN_TOO_LONG) {
+			if (attrlen != pt->len)
+				goto out_err;
+			break;
+		}
+		/* fall through */
 	default:
 		if (pt->len)
 			minlen = pt->len;
-- 
2.17.2

