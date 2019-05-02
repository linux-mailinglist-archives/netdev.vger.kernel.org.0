Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 962F911B1A
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 16:16:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726514AbfEBOPk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 May 2019 10:15:40 -0400
Received: from mx2.suse.de ([195.135.220.15]:51398 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726320AbfEBOPM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 May 2019 10:15:12 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 785D9AD7E;
        Thu,  2 May 2019 14:15:11 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id D29B5E0157; Thu,  2 May 2019 16:15:10 +0200 (CEST)
Message-Id: <6b6ead21c5d8436470b82ab40355f6bd7dbbf14b.1556806084.git.mkubecek@suse.cz>
In-Reply-To: <cover.1556806084.git.mkubecek@suse.cz>
References: <cover.1556806084.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH net-next v2 3/3] netlink: add validation of NLA_F_NESTED flag
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Johannes Berg <johannes@sipsolutions.net>,
        David Ahern <dsahern@gmail.com>, linux-kernel@vger.kernel.org
Date:   Thu,  2 May 2019 16:15:10 +0200 (CEST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add new validation flag NL_VALIDATE_NESTED which adds three consistency
checks of NLA_F_NESTED_FLAG:

  - the flag is set on attributes with NLA_NESTED{,_ARRAY} policy
  - the flag is not set on attributes with other policies except NLA_UNSPEC
  - the flag is set on attribute passed to nla_parse_nested()

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>

v2: change error messages to mention NLA_F_NESTED explicitly
---
 include/net/netlink.h | 11 ++++++++++-
 lib/nlattr.c          | 15 +++++++++++++++
 2 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/include/net/netlink.h b/include/net/netlink.h
index 679f649748d4..395b4406f4b0 100644
--- a/include/net/netlink.h
+++ b/include/net/netlink.h
@@ -401,6 +401,8 @@ struct nl_info {
  *	are enforced going forward.
  * @NL_VALIDATE_STRICT_ATTRS: strict attribute policy parsing (e.g.
  *	U8, U16, U32 must have exact size, etc.)
+ * @NL_VALIDATE_NESTED: Check that NLA_F_NESTED is set for NLA_NESTED(_ARRAY)
+ *	and unset for other policies.
  */
 enum netlink_validation {
 	NL_VALIDATE_LIBERAL = 0,
@@ -408,6 +410,7 @@ enum netlink_validation {
 	NL_VALIDATE_MAXTYPE = BIT(1),
 	NL_VALIDATE_UNSPEC = BIT(2),
 	NL_VALIDATE_STRICT_ATTRS = BIT(3),
+	NL_VALIDATE_NESTED = BIT(4),
 };
 
 #define NL_VALIDATE_DEPRECATED_STRICT (NL_VALIDATE_TRAILING |\
@@ -415,7 +418,8 @@ enum netlink_validation {
 #define NL_VALIDATE_STRICT (NL_VALIDATE_TRAILING |\
 			    NL_VALIDATE_MAXTYPE |\
 			    NL_VALIDATE_UNSPEC |\
-			    NL_VALIDATE_STRICT_ATTRS)
+			    NL_VALIDATE_STRICT_ATTRS |\
+			    NL_VALIDATE_NESTED)
 
 int netlink_rcv_skb(struct sk_buff *skb,
 		    int (*cb)(struct sk_buff *, struct nlmsghdr *,
@@ -1132,6 +1136,11 @@ static inline int nla_parse_nested(struct nlattr *tb[], int maxtype,
 				   const struct nla_policy *policy,
 				   struct netlink_ext_ack *extack)
 {
+	if (!(nla->nla_type & NLA_F_NESTED)) {
+		NL_SET_ERR_MSG_ATTR(extack, nla, "NLA_F_NESTED is missing");
+		return -EINVAL;
+	}
+
 	return __nla_parse(tb, maxtype, nla_data(nla), nla_len(nla), policy,
 			   NL_VALIDATE_STRICT, extack);
 }
diff --git a/lib/nlattr.c b/lib/nlattr.c
index adc919b32bf9..cace9b307781 100644
--- a/lib/nlattr.c
+++ b/lib/nlattr.c
@@ -184,6 +184,21 @@ static int validate_nla(const struct nlattr *nla, int maxtype,
 		}
 	}
 
+	if (validate & NL_VALIDATE_NESTED) {
+		if ((pt->type == NLA_NESTED || pt->type == NLA_NESTED_ARRAY) &&
+		    !(nla->nla_type & NLA_F_NESTED)) {
+			NL_SET_ERR_MSG_ATTR(extack, nla,
+					    "NLA_F_NESTED is missing");
+			return -EINVAL;
+		}
+		if (pt->type != NLA_NESTED && pt->type != NLA_NESTED_ARRAY &&
+		    pt->type != NLA_UNSPEC && (nla->nla_type & NLA_F_NESTED)) {
+			NL_SET_ERR_MSG_ATTR(extack, nla,
+					    "NLA_F_NESTED not expected");
+			return -EINVAL;
+		}
+	}
+
 	switch (pt->type) {
 	case NLA_EXACT_LEN:
 		if (attrlen != pt->len)
-- 
2.21.0

