Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 978C11C078E
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 22:13:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727809AbgD3UNe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 16:13:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726338AbgD3UN0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 16:13:26 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 095DAC08E859;
        Thu, 30 Apr 2020 13:13:26 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.93)
        (envelope-from <johannes@sipsolutions.net>)
        id 1jUFYi-002qzz-8d; Thu, 30 Apr 2020 22:13:24 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     Antonio Quartulli <a@unstable.cc>, linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH v2 8/8] netlink: add infrastructure to expose policies to userspace
Date:   Thu, 30 Apr 2020 22:13:12 +0200
Message-Id: <20200430221106.c28d28d9ddee.Icf6f8aa515bf625608fac70eec24739433b8ebd8@changeid>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200430201312.60143-1-johannes@sipsolutions.net>
References: <20200430201312.60143-1-johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

Add, and use in generic netlink, helpers to dump out a netlink
policy to userspace, including all the range validation data,
nested policies etc.

This lets userspace discover what the kernel understands.

For families/commands other than generic netlink, the helpers
need to be used directly in an appropriate command, or we can
add some infrastructure (a new netlink family) that those can
register their policies with for introspection. I'm not that
familiar with non-generic netlink, so that's left out for now.

The data exposed to userspace also includes min and max length
for binary/string data, I've done that instead of letting the
userspace tools figure out whether min/max is intended based
on the type so that we can extend this later in the kernel, we
might want to just use the range data for example.

Because of this, I opted to not directly expose the NLA_*
values, even if some of them are already exposed via BPF, as
with min/max length we don't need to have different types here
for NLA_BINARY/NLA_MIN_LEN/NLA_EXACT_LEN, we just make them
all NL_ATTR_TYPE_BINARY with min/max length optionally set.

Similarly, we don't really need NLA_MSECS, and perhaps can
remove it in the future - but not if we encode it into the
userspace API now. It gets mapped to NL_ATTR_TYPE_U64 here.

Note that the exposing here corresponds to the strict policy
interpretation, and NLA_UNSPEC items are omitted entirely.
To get those, change them to NLA_MIN_LEN which behaves in
exactly the same way, but is exposed.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/netlink.h          |   6 +
 include/uapi/linux/genetlink.h |   2 +
 include/uapi/linux/netlink.h   | 103 +++++++++++
 net/netlink/Makefile           |   2 +-
 net/netlink/genetlink.c        |  78 +++++++++
 net/netlink/policy.c           | 308 +++++++++++++++++++++++++++++++++
 6 files changed, 498 insertions(+), 1 deletion(-)
 create mode 100644 net/netlink/policy.c

diff --git a/include/net/netlink.h b/include/net/netlink.h
index 557b67f1db99..c0411f14fb53 100644
--- a/include/net/netlink.h
+++ b/include/net/netlink.h
@@ -1933,4 +1933,10 @@ void nla_get_range_unsigned(const struct nla_policy *pt,
 void nla_get_range_signed(const struct nla_policy *pt,
 			  struct netlink_range_validation_signed *range);
 
+int netlink_policy_dump_start(const struct nla_policy *policy,
+			      unsigned int maxtype,
+			      unsigned long *state);
+bool netlink_policy_dump_loop(unsigned long *state);
+int netlink_policy_dump_write(struct sk_buff *skb, unsigned long state);
+
 #endif
diff --git a/include/uapi/linux/genetlink.h b/include/uapi/linux/genetlink.h
index 877f7fa95466..9c0636ec2286 100644
--- a/include/uapi/linux/genetlink.h
+++ b/include/uapi/linux/genetlink.h
@@ -48,6 +48,7 @@ enum {
 	CTRL_CMD_NEWMCAST_GRP,
 	CTRL_CMD_DELMCAST_GRP,
 	CTRL_CMD_GETMCAST_GRP, /* unused */
+	CTRL_CMD_GETPOLICY,
 	__CTRL_CMD_MAX,
 };
 
@@ -62,6 +63,7 @@ enum {
 	CTRL_ATTR_MAXATTR,
 	CTRL_ATTR_OPS,
 	CTRL_ATTR_MCAST_GROUPS,
+	CTRL_ATTR_POLICY,
 	__CTRL_ATTR_MAX,
 };
 
diff --git a/include/uapi/linux/netlink.h b/include/uapi/linux/netlink.h
index 0a4d73317759..eac8a6a648ea 100644
--- a/include/uapi/linux/netlink.h
+++ b/include/uapi/linux/netlink.h
@@ -249,4 +249,107 @@ struct nla_bitfield32 {
 	__u32 selector;
 };
 
+/*
+ * policy descriptions - it's specific to each family how this is used
+ * Normally, it should be retrieved via a dump inside another attribute
+ * specifying where it applies.
+ */
+
+/**
+ * enum netlink_attribute_type - type of an attribute
+ * @NL_ATTR_TYPE_INVALID: unused
+ * @NL_ATTR_TYPE_FLAG: flag attribute (present/not present)
+ * @NL_ATTR_TYPE_U8: 8-bit unsigned attribute
+ * @NL_ATTR_TYPE_U16: 16-bit unsigned attribute
+ * @NL_ATTR_TYPE_U32: 32-bit unsigned attribute
+ * @NL_ATTR_TYPE_U64: 64-bit unsigned attribute
+ * @NL_ATTR_TYPE_S8: 8-bit signed attribute
+ * @NL_ATTR_TYPE_S16: 16-bit signed attribute
+ * @NL_ATTR_TYPE_S32: 32-bit signed attribute
+ * @NL_ATTR_TYPE_S64: 64-bit signed attribute
+ * @NL_ATTR_TYPE_BINARY: binary data, min/max length may be specified
+ * @NL_ATTR_TYPE_STRING: string, min/max length may be specified
+ * @NL_ATTR_TYPE_NUL_STRING: NUL-terminated string,
+ *	min/max length may be specified
+ * @NL_ATTR_TYPE_NESTED: nested, i.e. the content of this attribute
+ *	consists of sub-attributes. The nested policy and maxtype
+ *	inside may be specified.
+ * @NL_ATTR_TYPE_NESTED_ARRAY: nested array, i.e. the content of this
+ *	attribute contains sub-attributes whose type is irrelevant
+ *	(just used to separate the array entries) and each such array
+ *	entry has attributes again, the policy for those inner ones
+ *	and the corresponding maxtype may be specified.
+ * @NL_ATTR_TYPE_BITFIELD32: &struct nla_bitfield32 attribute
+ */
+enum netlink_attribute_type {
+	NL_ATTR_TYPE_INVALID,
+
+	NL_ATTR_TYPE_FLAG,
+
+	NL_ATTR_TYPE_U8,
+	NL_ATTR_TYPE_U16,
+	NL_ATTR_TYPE_U32,
+	NL_ATTR_TYPE_U64,
+
+	NL_ATTR_TYPE_S8,
+	NL_ATTR_TYPE_S16,
+	NL_ATTR_TYPE_S32,
+	NL_ATTR_TYPE_S64,
+
+	NL_ATTR_TYPE_BINARY,
+	NL_ATTR_TYPE_STRING,
+	NL_ATTR_TYPE_NUL_STRING,
+
+	NL_ATTR_TYPE_NESTED,
+	NL_ATTR_TYPE_NESTED_ARRAY,
+
+	NL_ATTR_TYPE_BITFIELD32,
+};
+
+/**
+ * enum netlink_policy_type_attr - policy type attributes
+ * @NL_POLICY_TYPE_ATTR_UNSPEC: unused
+ * @NL_POLICY_TYPE_ATTR_TYPE: type of the attribute,
+ *	&enum netlink_attribute_type (U32)
+ * @NL_POLICY_TYPE_ATTR_MIN_VALUE_S: minimum value for signed
+ *	integers (S64)
+ * @NL_POLICY_TYPE_ATTR_MAX_VALUE_S: maximum value for signed
+ *	integers (S64)
+ * @NL_POLICY_TYPE_ATTR_MIN_VALUE_U: minimum value for unsigned
+ *	integers (U64)
+ * @NL_POLICY_TYPE_ATTR_MAX_VALUE_U: maximum value for unsigned
+ *	integers (U64)
+ * @NL_POLICY_TYPE_ATTR_MIN_LENGTH: minimum length for binary
+ *	attributes, no minimum if not given (U32)
+ * @NL_POLICY_TYPE_ATTR_MAX_LENGTH: maximum length for binary
+ *	attributes, no maximum if not given (U32)
+ * @NL_POLICY_TYPE_ATTR_POLICY_IDX: sub policy for nested and
+ *	nested array types (U32)
+ * @NL_POLICY_TYPE_ATTR_POLICY_MAXTYPE: maximum sub policy
+ *	attribute for nested and nested array types, this can
+ *	in theory be < the size of the policy pointed to by
+ *	the index, if limited inside the nesting (U32)
+ * @NL_POLICY_TYPE_ATTR_BITFIELD32_MASK: valid mask for the
+ *	bitfield32 type (U32)
+ * @NL_POLICY_TYPE_ATTR_PAD: pad attribute for 64-bit alignment
+ */
+enum netlink_policy_type_attr {
+	NL_POLICY_TYPE_ATTR_UNSPEC,
+	NL_POLICY_TYPE_ATTR_TYPE,
+	NL_POLICY_TYPE_ATTR_MIN_VALUE_S,
+	NL_POLICY_TYPE_ATTR_MAX_VALUE_S,
+	NL_POLICY_TYPE_ATTR_MIN_VALUE_U,
+	NL_POLICY_TYPE_ATTR_MAX_VALUE_U,
+	NL_POLICY_TYPE_ATTR_MIN_LENGTH,
+	NL_POLICY_TYPE_ATTR_MAX_LENGTH,
+	NL_POLICY_TYPE_ATTR_POLICY_IDX,
+	NL_POLICY_TYPE_ATTR_POLICY_MAXTYPE,
+	NL_POLICY_TYPE_ATTR_BITFIELD32_MASK,
+	NL_POLICY_TYPE_ATTR_PAD,
+
+	/* keep last */
+	__NL_POLICY_TYPE_ATTR_MAX,
+	NL_POLICY_TYPE_ATTR_MAX = __NL_POLICY_TYPE_ATTR_MAX - 1
+};
+
 #endif /* _UAPI__LINUX_NETLINK_H */
diff --git a/net/netlink/Makefile b/net/netlink/Makefile
index de42df7f0068..e05202708c90 100644
--- a/net/netlink/Makefile
+++ b/net/netlink/Makefile
@@ -3,7 +3,7 @@
 # Makefile for the netlink driver.
 #
 
-obj-y  				:= af_netlink.o genetlink.o
+obj-y  				:= af_netlink.o genetlink.o policy.o
 
 obj-$(CONFIG_NETLINK_DIAG)	+= netlink_diag.o
 netlink_diag-y			:= diag.o
diff --git a/net/netlink/genetlink.c b/net/netlink/genetlink.c
index 9f357aa22b94..2f049692e012 100644
--- a/net/netlink/genetlink.c
+++ b/net/netlink/genetlink.c
@@ -1043,6 +1043,80 @@ static int genl_ctrl_event(int event, const struct genl_family *family,
 	return 0;
 }
 
+static int ctrl_dumppolicy(struct sk_buff *skb, struct netlink_callback *cb)
+{
+	const struct genl_family *rt;
+	unsigned int fam_id = cb->args[0];
+	int err;
+
+	if (!fam_id) {
+		struct nlattr *tb[CTRL_ATTR_MAX + 1];
+
+		err = genlmsg_parse(cb->nlh, &genl_ctrl, tb,
+				    genl_ctrl.maxattr,
+				    genl_ctrl.policy, cb->extack);
+		if (err)
+			return err;
+
+		if (!tb[CTRL_ATTR_FAMILY_ID] && !tb[CTRL_ATTR_FAMILY_NAME])
+			return -EINVAL;
+
+		if (tb[CTRL_ATTR_FAMILY_ID]) {
+			fam_id = nla_get_u16(tb[CTRL_ATTR_FAMILY_ID]);
+		} else {
+			rt = genl_family_find_byname(
+				nla_data(tb[CTRL_ATTR_FAMILY_NAME]));
+			if (!rt)
+				return -ENOENT;
+			fam_id = rt->id;
+		}
+	}
+
+	rt = genl_family_find_byid(fam_id);
+	if (!rt)
+		return -ENOENT;
+
+	if (!rt->policy)
+		return -ENODATA;
+
+	err = netlink_policy_dump_start(rt->policy, rt->maxattr, &cb->args[1]);
+	if (err)
+		return err;
+
+	while (netlink_policy_dump_loop(&cb->args[1])) {
+		void *hdr;
+		struct nlattr *nest;
+
+		hdr = genlmsg_put(skb, NETLINK_CB(cb->skb).portid,
+				  cb->nlh->nlmsg_seq, &genl_ctrl,
+				  NLM_F_MULTI, CTRL_CMD_GETPOLICY);
+		if (!hdr)
+			goto nla_put_failure;
+
+		if (nla_put_u16(skb, CTRL_ATTR_FAMILY_ID, rt->id))
+			goto nla_put_failure;
+
+		nest = nla_nest_start(skb, CTRL_ATTR_POLICY);
+		if (!nest)
+			goto nla_put_failure;
+
+		if (netlink_policy_dump_write(skb, cb->args[1]))
+			goto nla_put_failure;
+
+		nla_nest_end(skb, nest);
+
+		genlmsg_end(skb, hdr);
+		continue;
+
+nla_put_failure:
+		genlmsg_cancel(skb, hdr);
+		break;
+	}
+
+	cb->args[0] = fam_id;
+	return skb->len;
+}
+
 static const struct genl_ops genl_ctrl_ops[] = {
 	{
 		.cmd		= CTRL_CMD_GETFAMILY,
@@ -1050,6 +1124,10 @@ static const struct genl_ops genl_ctrl_ops[] = {
 		.doit		= ctrl_getfamily,
 		.dumpit		= ctrl_dumpfamily,
 	},
+	{
+		.cmd		= CTRL_CMD_GETPOLICY,
+		.dumpit		= ctrl_dumppolicy,
+	},
 };
 
 static const struct genl_multicast_group genl_ctrl_groups[] = {
diff --git a/net/netlink/policy.c b/net/netlink/policy.c
new file mode 100644
index 000000000000..f6491853c797
--- /dev/null
+++ b/net/netlink/policy.c
@@ -0,0 +1,308 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * NETLINK      Policy advertisement to userspace
+ *
+ * 		Authors:	Johannes Berg <johannes@sipsolutions.net>
+ *
+ * Copyright 2019 Intel Corporation
+ */
+
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/types.h>
+#include <net/netlink.h>
+
+#define INITIAL_POLICIES_ALLOC	10
+
+struct nl_policy_dump {
+	unsigned int policy_idx;
+	unsigned int attr_idx;
+	unsigned int n_alloc;
+	struct {
+		const struct nla_policy *policy;
+		unsigned int maxtype;
+	} policies[];
+};
+
+static int add_policy(struct nl_policy_dump **statep,
+		      const struct nla_policy *policy,
+		      unsigned int maxtype)
+{
+	struct nl_policy_dump *state = *statep;
+	unsigned int n_alloc, i;
+
+	if (!policy || !maxtype)
+		return 0;
+
+	for (i = 0; i < state->n_alloc; i++) {
+		if (state->policies[i].policy == policy)
+			return 0;
+
+		if (!state->policies[i].policy) {
+			state->policies[i].policy = policy;
+			state->policies[i].maxtype = maxtype;
+			return 0;
+		}
+	}
+
+	n_alloc = state->n_alloc + INITIAL_POLICIES_ALLOC;
+	state = krealloc(state, struct_size(state, policies, n_alloc),
+			 GFP_KERNEL);
+	if (!state)
+		return -ENOMEM;
+
+	state->policies[state->n_alloc].policy = policy;
+	state->policies[state->n_alloc].maxtype = maxtype;
+	state->n_alloc = n_alloc;
+	*statep = state;
+
+	return 0;
+}
+
+static unsigned int get_policy_idx(struct nl_policy_dump *state,
+				   const struct nla_policy *policy)
+{
+	unsigned int i;
+
+	for (i = 0; i < state->n_alloc; i++) {
+		if (state->policies[i].policy == policy)
+			return i;
+	}
+
+	WARN_ON_ONCE(1);
+	return -1;
+}
+
+int netlink_policy_dump_start(const struct nla_policy *policy,
+			      unsigned int maxtype,
+                              unsigned long *_state)
+{
+	struct nl_policy_dump *state;
+	unsigned int policy_idx;
+	int err;
+
+	/* also returns 0 if "*_state" is our ERR_PTR() end marker */
+	if (*_state)
+		return 0;
+
+	/*
+	 * walk the policies and nested ones first, and build
+	 * a linear list of them.
+	 */
+
+	state = kzalloc(struct_size(state, policies, INITIAL_POLICIES_ALLOC),
+			GFP_KERNEL);
+	if (!state)
+		return -ENOMEM;
+	state->n_alloc = INITIAL_POLICIES_ALLOC;
+
+	err = add_policy(&state, policy, maxtype);
+	if (err)
+		return err;
+
+	for (policy_idx = 0;
+	     policy_idx < state->n_alloc && state->policies[policy_idx].policy;
+	     policy_idx++) {
+		const struct nla_policy *policy;
+		unsigned int type;
+
+		policy = state->policies[policy_idx].policy;
+
+		for (type = 0;
+		     type <= state->policies[policy_idx].maxtype;
+		     type++) {
+			switch (policy[type].type) {
+			case NLA_NESTED:
+			case NLA_NESTED_ARRAY:
+				err = add_policy(&state,
+						 policy[type].nested_policy,
+						 policy[type].len);
+				if (err)
+					return err;
+				break;
+			default:
+				break;
+			}
+		}
+	}
+
+	*_state = (unsigned long)state;
+
+	return 0;
+}
+
+static bool netlink_policy_dump_finished(struct nl_policy_dump *state)
+{
+	return state->policy_idx >= state->n_alloc ||
+	       !state->policies[state->policy_idx].policy;
+}
+
+bool netlink_policy_dump_loop(unsigned long *_state)
+{
+	struct nl_policy_dump *state = (void *)*_state;
+
+	if (IS_ERR(state))
+		return false;
+
+	if (netlink_policy_dump_finished(state)) {
+		kfree(state);
+		/* store end marker instead of freed state */
+		*_state = (unsigned long)ERR_PTR(-ENOENT);
+		return false;
+	}
+
+	return true;
+}
+
+int netlink_policy_dump_write(struct sk_buff *skb, unsigned long _state)
+{
+	struct nl_policy_dump *state = (void *)_state;
+	const struct nla_policy *pt;
+	struct nlattr *policy, *attr;
+	enum netlink_attribute_type type;
+	bool again;
+
+send_attribute:
+	again = false;
+
+	pt = &state->policies[state->policy_idx].policy[state->attr_idx];
+
+	policy = nla_nest_start(skb, state->policy_idx);
+	if (!policy)
+		return -ENOBUFS;
+
+	attr = nla_nest_start(skb, state->attr_idx);
+	if (!attr)
+		goto nla_put_failure;
+
+	switch (pt->type) {
+	default:
+	case NLA_UNSPEC:
+	case NLA_REJECT:
+		/* skip - use NLA_MIN_LEN to advertise such */
+		nla_nest_cancel(skb, policy);
+		again = true;
+		goto next;
+	case NLA_NESTED:
+		type = NL_ATTR_TYPE_NESTED;
+		/* fall through */
+	case NLA_NESTED_ARRAY:
+		if (pt->type == NLA_NESTED_ARRAY)
+			type = NL_ATTR_TYPE_NESTED_ARRAY;
+		if (pt->nested_policy && pt->len &&
+		    (nla_put_u32(skb, NL_POLICY_TYPE_ATTR_POLICY_IDX,
+				 get_policy_idx(state, pt->nested_policy)) ||
+		     nla_put_u32(skb, NL_POLICY_TYPE_ATTR_POLICY_MAXTYPE,
+				 pt->len)))
+			goto nla_put_failure;
+		break;
+	case NLA_U8:
+	case NLA_U16:
+	case NLA_U32:
+	case NLA_U64:
+	case NLA_MSECS: {
+		struct netlink_range_validation range;
+
+		if (pt->type == NLA_U8)
+			type = NL_ATTR_TYPE_U8;
+		else if (pt->type == NLA_U16)
+			type = NL_ATTR_TYPE_U16;
+		else if (pt->type == NLA_U32)
+			type = NL_ATTR_TYPE_U32;
+		else
+			type = NL_ATTR_TYPE_U64;
+
+		nla_get_range_unsigned(pt, &range);
+
+		if (nla_put_u64_64bit(skb, NL_POLICY_TYPE_ATTR_MIN_VALUE_U,
+				      range.min, NL_POLICY_TYPE_ATTR_PAD) ||
+		    nla_put_u64_64bit(skb, NL_POLICY_TYPE_ATTR_MAX_VALUE_U,
+				      range.max, NL_POLICY_TYPE_ATTR_PAD))
+			goto nla_put_failure;
+		break;
+	}
+	case NLA_S8:
+	case NLA_S16:
+	case NLA_S32:
+	case NLA_S64: {
+		struct netlink_range_validation_signed range;
+
+		if (pt->type == NLA_S8)
+			type = NL_ATTR_TYPE_S8;
+		else if (pt->type == NLA_S16)
+			type = NL_ATTR_TYPE_S16;
+		else if (pt->type == NLA_S32)
+			type = NL_ATTR_TYPE_S32;
+		else
+			type = NL_ATTR_TYPE_S64;
+
+		nla_get_range_signed(pt, &range);
+
+		if (nla_put_s64(skb, NL_POLICY_TYPE_ATTR_MIN_VALUE_S,
+				range.min, NL_POLICY_TYPE_ATTR_PAD) ||
+		    nla_put_s64(skb, NL_POLICY_TYPE_ATTR_MAX_VALUE_S,
+				range.max, NL_POLICY_TYPE_ATTR_PAD))
+			goto nla_put_failure;
+		break;
+	}
+	case NLA_BITFIELD32:
+		type = NL_ATTR_TYPE_BITFIELD32;
+		if (nla_put_u32(skb, NL_POLICY_TYPE_ATTR_BITFIELD32_MASK,
+				pt->bitfield32_valid))
+			goto nla_put_failure;
+		break;
+	case NLA_EXACT_LEN:
+		type = NL_ATTR_TYPE_BINARY;
+		if (nla_put_u32(skb, NL_POLICY_TYPE_ATTR_MIN_LENGTH, pt->len) ||
+		    nla_put_u32(skb, NL_POLICY_TYPE_ATTR_MAX_LENGTH, pt->len))
+			goto nla_put_failure;
+		break;
+	case NLA_STRING:
+	case NLA_NUL_STRING:
+	case NLA_BINARY:
+		if (pt->type == NLA_STRING)
+			type = NL_ATTR_TYPE_STRING;
+		else if (pt->type == NLA_NUL_STRING)
+			type = NL_ATTR_TYPE_NUL_STRING;
+		else
+			type = NL_ATTR_TYPE_BINARY;
+		if (pt->len && nla_put_u32(skb, NL_POLICY_TYPE_ATTR_MAX_LENGTH,
+					   pt->len))
+			goto nla_put_failure;
+		break;
+	case NLA_MIN_LEN:
+		type = NL_ATTR_TYPE_BINARY;
+		if (nla_put_u32(skb, NL_POLICY_TYPE_ATTR_MIN_LENGTH, pt->len))
+			goto nla_put_failure;
+		break;
+	case NLA_FLAG:
+		type = NL_ATTR_TYPE_FLAG;
+		break;
+	}
+
+	if (nla_put_u32(skb, NL_POLICY_TYPE_ATTR_TYPE, type))
+		goto nla_put_failure;
+
+	/* finish and move state to next attribute */
+	nla_nest_end(skb, attr);
+	nla_nest_end(skb, policy);
+
+next:
+	state->attr_idx += 1;
+	if (state->attr_idx > state->policies[state->policy_idx].maxtype) {
+		state->attr_idx = 0;
+		state->policy_idx++;
+	}
+
+	if (again) {
+		if (netlink_policy_dump_finished(state))
+			return -ENODATA;
+		goto send_attribute;
+	}
+
+	return 0;
+
+nla_put_failure:
+	nla_nest_cancel(skb, policy);
+	return -ENOBUFS;
+}
-- 
2.25.1

