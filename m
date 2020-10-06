Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7170A28516F
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 20:16:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726773AbgJFSQG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 14:16:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726766AbgJFSQF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 14:16:05 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D23F0C0613D1
        for <netdev@vger.kernel.org>; Tue,  6 Oct 2020 11:16:04 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kPrVK-000PRR-NN; Tue, 06 Oct 2020 20:16:02 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, Jakub Kicinski <kuba@kernel.org>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH v2 2/2] netlink: export policy in extended ACK
Date:   Tue,  6 Oct 2020 20:15:55 +0200
Message-Id: <20201006201333.b901bad12976.I6dae2c514a6abc924ee8b3e2befb0d51b086cf70@changeid>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201006181555.103140-1-johannes@sipsolutions.net>
References: <20201006181555.103140-1-johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

Add a new attribute NLMSGERR_ATTR_POLICY to the extended ACK
to advertise the policy, e.g. if an attribute was out of range,
you'll know the range that's permissible.

Add new NL_SET_ERR_MSG_ATTR_POL() and NL_SET_ERR_MSG_ATTR_POL()
macros to set this, since realistically it's only useful to do
this when the bad attribute (offset) is also returned.

Use it in lib/nlattr.c which practically does all the policy
validation.

v2:
 - add and use netlink_policy_dump_attr_size_estimate()

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/linux/netlink.h      | 30 +++++++++++------
 include/net/netlink.h        |  4 +++
 include/uapi/linux/netlink.h |  2 ++
 lib/nlattr.c                 | 35 ++++++++++----------
 net/netlink/af_netlink.c     |  5 +++
 net/netlink/policy.c         | 62 ++++++++++++++++++++++++++++++++++++
 6 files changed, 111 insertions(+), 27 deletions(-)

diff --git a/include/linux/netlink.h b/include/linux/netlink.h
index e3e49f0e5c13..666cd0390699 100644
--- a/include/linux/netlink.h
+++ b/include/linux/netlink.h
@@ -68,12 +68,14 @@ netlink_kernel_create(struct net *net, int unit, struct netlink_kernel_cfg *cfg)
  * @_msg: message string to report - don't access directly, use
  *	%NL_SET_ERR_MSG
  * @bad_attr: attribute with error
+ * @policy: policy for a bad attribute
  * @cookie: cookie data to return to userspace (for success)
  * @cookie_len: actual cookie data length
  */
 struct netlink_ext_ack {
 	const char *_msg;
 	const struct nlattr *bad_attr;
+	const struct nla_policy *policy;
 	u8 cookie[NETLINK_MAX_COOKIE_LEN];
 	u8 cookie_len;
 };
@@ -95,21 +97,29 @@ struct netlink_ext_ack {
 #define NL_SET_ERR_MSG_MOD(extack, msg)			\
 	NL_SET_ERR_MSG((extack), KBUILD_MODNAME ": " msg)
 
-#define NL_SET_BAD_ATTR(extack, attr) do {		\
-	if ((extack))					\
+#define NL_SET_BAD_ATTR_POLICY(extack, attr, pol) do {	\
+	if ((extack)) {					\
 		(extack)->bad_attr = (attr);		\
+		(extack)->policy = (pol);		\
+	}						\
 } while (0)
 
-#define NL_SET_ERR_MSG_ATTR(extack, attr, msg) do {	\
-	static const char __msg[] = msg;		\
-	struct netlink_ext_ack *__extack = (extack);	\
-							\
-	if (__extack) {					\
-		__extack->_msg = __msg;			\
-		__extack->bad_attr = (attr);		\
-	}						\
+#define NL_SET_BAD_ATTR(extack, attr) NL_SET_BAD_ATTR_POLICY(extack, attr, NULL)
+
+#define NL_SET_ERR_MSG_ATTR_POL(extack, attr, pol, msg) do {	\
+	static const char __msg[] = msg;			\
+	struct netlink_ext_ack *__extack = (extack);		\
+								\
+	if (__extack) {						\
+		__extack->_msg = __msg;				\
+		__extack->bad_attr = (attr);			\
+		__extack->policy = (pol);			\
+	}							\
 } while (0)
 
+#define NL_SET_ERR_MSG_ATTR(extack, attr, msg)		\
+	NL_SET_ERR_MSG_ATTR_POL(extack, attr, NULL, msg)
+
 static inline void nl_set_extack_cookie_u64(struct netlink_ext_ack *extack,
 					    u64 cookie)
 {
diff --git a/include/net/netlink.h b/include/net/netlink.h
index 2b9e41075f19..7356f41d23ba 100644
--- a/include/net/netlink.h
+++ b/include/net/netlink.h
@@ -1957,6 +1957,10 @@ int netlink_policy_dump_get_policy_idx(struct netlink_policy_dump_state *state,
 bool netlink_policy_dump_loop(struct netlink_policy_dump_state *state);
 int netlink_policy_dump_write(struct sk_buff *skb,
 			      struct netlink_policy_dump_state *state);
+int netlink_policy_dump_attr_size_estimate(const struct nla_policy *pt);
+int netlink_policy_dump_write_attr(struct sk_buff *skb,
+				   const struct nla_policy *pt,
+				   int nestattr);
 void netlink_policy_dump_free(struct netlink_policy_dump_state *state);
 
 #endif
diff --git a/include/uapi/linux/netlink.h b/include/uapi/linux/netlink.h
index d02e472ba54c..c3816ff7bfc3 100644
--- a/include/uapi/linux/netlink.h
+++ b/include/uapi/linux/netlink.h
@@ -129,6 +129,7 @@ struct nlmsgerr {
  * @NLMSGERR_ATTR_COOKIE: arbitrary subsystem specific cookie to
  *	be used - in the success case - to identify a created
  *	object or operation or similar (binary)
+ * @NLMSGERR_ATTR_POLICY: policy for a rejected attribute
  * @__NLMSGERR_ATTR_MAX: number of attributes
  * @NLMSGERR_ATTR_MAX: highest attribute number
  */
@@ -137,6 +138,7 @@ enum nlmsgerr_attrs {
 	NLMSGERR_ATTR_MSG,
 	NLMSGERR_ATTR_OFFS,
 	NLMSGERR_ATTR_COOKIE,
+	NLMSGERR_ATTR_POLICY,
 
 	__NLMSGERR_ATTR_MAX,
 	NLMSGERR_ATTR_MAX = __NLMSGERR_ATTR_MAX - 1
diff --git a/lib/nlattr.c b/lib/nlattr.c
index 9c99f5daa4d2..74019c8ebf6b 100644
--- a/lib/nlattr.c
+++ b/lib/nlattr.c
@@ -96,8 +96,8 @@ static int nla_validate_array(const struct nlattr *head, int len, int maxtype,
 			continue;
 
 		if (nla_len(entry) < NLA_HDRLEN) {
-			NL_SET_ERR_MSG_ATTR(extack, entry,
-					    "Array element too short");
+			NL_SET_ERR_MSG_ATTR_POL(extack, entry, policy,
+						"Array element too short");
 			return -ERANGE;
 		}
 
@@ -195,8 +195,8 @@ static int nla_validate_range_unsigned(const struct nla_policy *pt,
 		pr_warn_ratelimited("netlink: '%s': attribute type %d has an invalid length.\n",
 				    current->comm, pt->type);
 		if (validate & NL_VALIDATE_STRICT_ATTRS) {
-			NL_SET_ERR_MSG_ATTR(extack, nla,
-					    "invalid attribute length");
+			NL_SET_ERR_MSG_ATTR_POL(extack, nla, pt,
+						"invalid attribute length");
 			return -EINVAL;
 		}
 
@@ -208,11 +208,11 @@ static int nla_validate_range_unsigned(const struct nla_policy *pt,
 		bool binary = pt->type == NLA_BINARY;
 
 		if (binary)
-			NL_SET_ERR_MSG_ATTR(extack, nla,
-					    "binary attribute size out of range");
+			NL_SET_ERR_MSG_ATTR_POL(extack, nla, pt,
+						"binary attribute size out of range");
 		else
-			NL_SET_ERR_MSG_ATTR(extack, nla,
-					    "integer out of range");
+			NL_SET_ERR_MSG_ATTR_POL(extack, nla, pt,
+						"integer out of range");
 
 		return -ERANGE;
 	}
@@ -291,8 +291,8 @@ static int nla_validate_int_range_signed(const struct nla_policy *pt,
 	nla_get_range_signed(pt, &range);
 
 	if (value < range.min || value > range.max) {
-		NL_SET_ERR_MSG_ATTR(extack, nla,
-				    "integer out of range");
+		NL_SET_ERR_MSG_ATTR_POL(extack, nla, pt,
+					"integer out of range");
 		return -ERANGE;
 	}
 
@@ -377,8 +377,8 @@ static int validate_nla(const struct nlattr *nla, int maxtype,
 		pr_warn_ratelimited("netlink: '%s': attribute type %d has an invalid length.\n",
 				    current->comm, type);
 		if (validate & NL_VALIDATE_STRICT_ATTRS) {
-			NL_SET_ERR_MSG_ATTR(extack, nla,
-					    "invalid attribute length");
+			NL_SET_ERR_MSG_ATTR_POL(extack, nla, pt,
+						"invalid attribute length");
 			return -EINVAL;
 		}
 	}
@@ -386,14 +386,14 @@ static int validate_nla(const struct nlattr *nla, int maxtype,
 	if (validate & NL_VALIDATE_NESTED) {
 		if ((pt->type == NLA_NESTED || pt->type == NLA_NESTED_ARRAY) &&
 		    !(nla->nla_type & NLA_F_NESTED)) {
-			NL_SET_ERR_MSG_ATTR(extack, nla,
-					    "NLA_F_NESTED is missing");
+			NL_SET_ERR_MSG_ATTR_POL(extack, nla, pt,
+						"NLA_F_NESTED is missing");
 			return -EINVAL;
 		}
 		if (pt->type != NLA_NESTED && pt->type != NLA_NESTED_ARRAY &&
 		    pt->type != NLA_UNSPEC && (nla->nla_type & NLA_F_NESTED)) {
-			NL_SET_ERR_MSG_ATTR(extack, nla,
-					    "NLA_F_NESTED not expected");
+			NL_SET_ERR_MSG_ATTR_POL(extack, nla, pt,
+						"NLA_F_NESTED not expected");
 			return -EINVAL;
 		}
 	}
@@ -550,7 +550,8 @@ static int validate_nla(const struct nlattr *nla, int maxtype,
 
 	return 0;
 out_err:
-	NL_SET_ERR_MSG_ATTR(extack, nla, "Attribute failed policy validation");
+	NL_SET_ERR_MSG_ATTR_POL(extack, nla, pt,
+				"Attribute failed policy validation");
 	return err;
 }
 
diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index df675a8e1918..daca50d6bb12 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -2420,6 +2420,8 @@ void netlink_ack(struct sk_buff *in_skb, struct nlmsghdr *nlh, int err,
 		tlvlen += nla_total_size(sizeof(u32));
 	if (nlk_has_extack && extack && extack->cookie_len)
 		tlvlen += nla_total_size(extack->cookie_len);
+	if (err && nlk_has_extack && extack && extack->policy)
+		tlvlen += netlink_policy_dump_attr_size_estimate(extack->policy);
 
 	if (tlvlen)
 		flags |= NLM_F_ACK_TLVS;
@@ -2452,6 +2454,9 @@ void netlink_ack(struct sk_buff *in_skb, struct nlmsghdr *nlh, int err,
 		if (extack->cookie_len)
 			WARN_ON(nla_put(skb, NLMSGERR_ATTR_COOKIE,
 					extack->cookie_len, extack->cookie));
+		if (extack->policy)
+			netlink_policy_dump_write_attr(skb, extack->policy,
+						       NLMSGERR_ATTR_POLICY);
 	}
 
 	nlmsg_end(skb, rep);
diff --git a/net/netlink/policy.c b/net/netlink/policy.c
index 181622d60c9d..c5ffeb4816a9 100644
--- a/net/netlink/policy.c
+++ b/net/netlink/policy.c
@@ -196,12 +196,55 @@ bool netlink_policy_dump_loop(struct netlink_policy_dump_state *state)
 	return !netlink_policy_dump_finished(state);
 }
 
+int netlink_policy_dump_attr_size_estimate(const struct nla_policy *pt)
+{
+	/* nested + type */
+	int common = 2 * nla_attr_size(sizeof(u32));
+
+	switch (pt->type) {
+	case NLA_UNSPEC:
+	case NLA_REJECT:
+		/* these actually don't need any space */
+		return 0;
+	case NLA_NESTED:
+	case NLA_NESTED_ARRAY:
+		/* common, policy idx, policy maxattr */
+		return common + 2 * nla_attr_size(sizeof(u32));
+	case NLA_U8:
+	case NLA_U16:
+	case NLA_U32:
+	case NLA_U64:
+	case NLA_MSECS:
+	case NLA_S8:
+	case NLA_S16:
+	case NLA_S32:
+	case NLA_S64:
+		/* maximum is common, u64 min/max with padding */
+		return common +
+		       2 * (nla_attr_size(0) + nla_attr_size(sizeof(u64)));
+		break;
+	case NLA_BITFIELD32:
+		return common + nla_attr_size(sizeof(u32));
+	case NLA_STRING:
+	case NLA_NUL_STRING:
+	case NLA_BINARY:
+		/* maximum is common, u32 min-length/max-length */
+		return common + 2 * nla_attr_size(sizeof(u32));
+	case NLA_FLAG:
+		return common;
+	}
+
+	/* this should then cause a warning later */
+	return 0;
+}
+
 static int
 __netlink_policy_dump_write_attr(struct netlink_policy_dump_state *state,
 				 struct sk_buff *skb,
 				 const struct nla_policy *pt,
 				 int nestattr)
 {
+	int estimate = netlink_policy_dump_attr_size_estimate(pt);
 	enum netlink_attribute_type type;
 	struct nlattr *attr;
 
@@ -334,12 +377,31 @@ __netlink_policy_dump_write_attr(struct netlink_policy_dump_state *state,
 		goto nla_put_failure;
 
 	nla_nest_end(skb, attr);
+	WARN_ON(attr->nla_len > estimate);
+
 	return 0;
 nla_put_failure:
 	nla_nest_cancel(skb, attr);
 	return -ENOBUFS;
 }
 
+/**
+ * netlink_policy_dump_write_attr - write a given attribute policy
+ * @skb: the message skb to write to
+ * @pt: the attribute's policy
+ * @nestattr: the nested attribute ID to use
+ *
+ * Returns: 0 on success, an error code otherwise; -%ENODATA is
+ *	    special, indicating that there's no policy data and
+ *	    the attribute is generally rejected.
+ */
+int netlink_policy_dump_write_attr(struct sk_buff *skb,
+				   const struct nla_policy *pt,
+				   int nestattr)
+{
+	return __netlink_policy_dump_write_attr(NULL, skb, pt, nestattr);
+}
+
 /**
  * netlink_policy_dump_write - write current policy dump attributes
  * @skb: the message skb to write to
-- 
2.26.2

