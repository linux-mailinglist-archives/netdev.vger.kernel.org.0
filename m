Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FC67283BCC
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 17:58:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728874AbgJEP6K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 11:58:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:56876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728860AbgJEP6I (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Oct 2020 11:58:08 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C6B2B20B80;
        Mon,  5 Oct 2020 15:58:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601913488;
        bh=IKqkisEMW4kh5aF7sM5EiUU+zhLKSMln3BEmEgs42Iw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yBJtF2iTZRjDlYQqwgu1iR7VjXzygj4mP5KRIh3M45QhDBrvqnWx33NtCyPRdsPnW
         VoFerF2LQaqN3Nban/p9ao6Al9IwkCSC0A+As+3cu3ElpWKizNzPvzOHAxiHjPTOQS
         2YDrwGYE81KLVWYImVp4N42XXuOZY7J1Gz/rsjqY=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kernel-team@fb.com,
        johannes@sipsolutions.net, jiri@resnulli.us, andrew@lunn.ch,
        mkubecek@suse.cz, Jakub Kicinski <kuba@kernel.org>,
        dsahern@gmail.com, pablo@netfilter.org
Subject: [PATCH net-next 5/6] netlink: add mask validation
Date:   Mon,  5 Oct 2020 08:57:52 -0700
Message-Id: <20201005155753.2333882-6-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201005155753.2333882-1-kuba@kernel.org>
References: <20201005155753.2333882-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We don't have good validation policy for existing unsigned int attrs
which serve as flags (for new ones we could use NLA_BITFIELD32).
With increased use of policy dumping having the validation be
expressed as part of the policy is important. Add validation
policy in form of a mask of supported/valid bits.

Support u64 in the uAPI to be future-proof, but really for now
the embedded mask member can only hold 32 bits, so anything with
bit 32+ set will always fail validation.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: jiri@resnulli.us
CC: dsahern@gmail.com
CC: pablo@netfilter.org
---
 include/net/netlink.h        | 11 +++++++++++
 include/uapi/linux/netlink.h |  2 ++
 lib/nlattr.c                 | 36 ++++++++++++++++++++++++++++++++++++
 net/netlink/policy.c         |  8 ++++++++
 4 files changed, 57 insertions(+)

diff --git a/include/net/netlink.h b/include/net/netlink.h
index 5a5ff97cc596..844b53dbba68 100644
--- a/include/net/netlink.h
+++ b/include/net/netlink.h
@@ -200,6 +200,7 @@ enum nla_policy_validation {
 	NLA_VALIDATE_RANGE_WARN_TOO_LONG,
 	NLA_VALIDATE_MIN,
 	NLA_VALIDATE_MAX,
+	NLA_VALIDATE_MASK,
 	NLA_VALIDATE_RANGE_PTR,
 	NLA_VALIDATE_FUNCTION,
 };
@@ -317,6 +318,7 @@ struct nla_policy {
 	u16		len;
 	union {
 		const u32 bitfield32_valid;
+		const u32 mask;
 		const char *reject_message;
 		const struct nla_policy *nested_policy;
 		struct netlink_range_validation *range;
@@ -363,6 +365,9 @@ struct nla_policy {
 	{ .type = NLA_BITFIELD32, .bitfield32_valid = valid }
 
 #define __NLA_ENSURE(condition) BUILD_BUG_ON_ZERO(!(condition))
+#define NLA_ENSURE_UINT_TYPE(tp)			\
+	(__NLA_ENSURE(tp == NLA_U8 || tp == NLA_U16 ||	\
+		      tp == NLA_U32 || tp == NLA_U64) + tp)
 #define NLA_ENSURE_UINT_OR_BINARY_TYPE(tp)		\
 	(__NLA_ENSURE(tp == NLA_U8 || tp == NLA_U16 ||	\
 		      tp == NLA_U32 || tp == NLA_U64 ||	\
@@ -415,6 +420,12 @@ struct nla_policy {
 	.max = _max,					\
 }
 
+#define NLA_POLICY_MASK(tp, _mask) {			\
+	.type = NLA_ENSURE_UINT_TYPE(tp),		\
+	.validation_type = NLA_VALIDATE_MASK,		\
+	.mask = _mask,					\
+}
+
 #define NLA_POLICY_VALIDATE_FN(tp, fn, ...) {		\
 	.type = NLA_ENSURE_NO_VALIDATION_PTR(tp),	\
 	.validation_type = NLA_VALIDATE_FUNCTION,	\
diff --git a/include/uapi/linux/netlink.h b/include/uapi/linux/netlink.h
index eac8a6a648ea..d02e472ba54c 100644
--- a/include/uapi/linux/netlink.h
+++ b/include/uapi/linux/netlink.h
@@ -331,6 +331,7 @@ enum netlink_attribute_type {
  *	the index, if limited inside the nesting (U32)
  * @NL_POLICY_TYPE_ATTR_BITFIELD32_MASK: valid mask for the
  *	bitfield32 type (U32)
+ * @NL_POLICY_TYPE_ATTR_MASK: mask of valid bits for unsigned integers (U64)
  * @NL_POLICY_TYPE_ATTR_PAD: pad attribute for 64-bit alignment
  */
 enum netlink_policy_type_attr {
@@ -346,6 +347,7 @@ enum netlink_policy_type_attr {
 	NL_POLICY_TYPE_ATTR_POLICY_MAXTYPE,
 	NL_POLICY_TYPE_ATTR_BITFIELD32_MASK,
 	NL_POLICY_TYPE_ATTR_PAD,
+	NL_POLICY_TYPE_ATTR_MASK,
 
 	/* keep last */
 	__NL_POLICY_TYPE_ATTR_MAX,
diff --git a/lib/nlattr.c b/lib/nlattr.c
index 80ff9fe83696..9c99f5daa4d2 100644
--- a/lib/nlattr.c
+++ b/lib/nlattr.c
@@ -323,6 +323,37 @@ static int nla_validate_int_range(const struct nla_policy *pt,
 	}
 }
 
+static int nla_validate_mask(const struct nla_policy *pt,
+			     const struct nlattr *nla,
+			     struct netlink_ext_ack *extack)
+{
+	u64 value;
+
+	switch (pt->type) {
+	case NLA_U8:
+		value = nla_get_u8(nla);
+		break;
+	case NLA_U16:
+		value = nla_get_u16(nla);
+		break;
+	case NLA_U32:
+		value = nla_get_u32(nla);
+		break;
+	case NLA_U64:
+		value = nla_get_u64(nla);
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	if (value & ~(u64)pt->mask) {
+		NL_SET_ERR_MSG_ATTR(extack, nla, "reserved bit set");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 static int validate_nla(const struct nlattr *nla, int maxtype,
 			const struct nla_policy *policy, unsigned int validate,
 			struct netlink_ext_ack *extack, unsigned int depth)
@@ -503,6 +534,11 @@ static int validate_nla(const struct nlattr *nla, int maxtype,
 		if (err)
 			return err;
 		break;
+	case NLA_VALIDATE_MASK:
+		err = nla_validate_mask(pt, nla, extack);
+		if (err)
+			return err;
+		break;
 	case NLA_VALIDATE_FUNCTION:
 		if (pt->validate) {
 			err = pt->validate(nla, extack);
diff --git a/net/netlink/policy.c b/net/netlink/policy.c
index cf23c0151721..ee26d01328ee 100644
--- a/net/netlink/policy.c
+++ b/net/netlink/policy.c
@@ -263,6 +263,14 @@ int netlink_policy_dump_write(struct sk_buff *skb,
 		else
 			type = NL_ATTR_TYPE_U64;
 
+		if (pt->validation_type == NLA_VALIDATE_MASK) {
+			if (nla_put_u64_64bit(skb, NL_POLICY_TYPE_ATTR_MASK,
+					      pt->mask,
+					      NL_POLICY_TYPE_ATTR_PAD))
+				goto nla_put_failure;
+			break;
+		}
+
 		nla_get_range_unsigned(pt, &range);
 
 		if (nla_put_u64_64bit(skb, NL_POLICY_TYPE_ATTR_MIN_VALUE_U,
-- 
2.26.2

