Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE11E58B2D0
	for <lists+netdev@lfdr.de>; Sat,  6 Aug 2022 01:42:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241892AbiHEXmI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Aug 2022 19:42:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241713AbiHEXmF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Aug 2022 19:42:05 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 799BA18E2A
        for <netdev@vger.kernel.org>; Fri,  5 Aug 2022 16:42:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659742924; x=1691278924;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xttVxhrx7wNtzIM4coVZJiokUXiUYRuIvL/lFvDXVno=;
  b=iBr7e7NKAKU/4UIUlDz8Vvgl8PBEWt+vCKSomSFN01qum6jXHPyHQ7gd
   OAyvRsjynLlOScLWJvMXuuYwdA1kE/zQMD5Bc2qcsa5VMkkzaBoHv4TgD
   bLAAOCVdh5KMD4zwf/E1pdmGlKn9tyjaO+IeNfqtwrsNNtu1gr1LNLxbB
   +Ub9aqVC7isdK6FirG7wNX2s8Zaj/4gN+SgRbA0O2Cj8qShdM7M8QLsv+
   k6boJDJUZaauYMw78X5CO0MkRtXyw3P3ub0LVpk/zj7ATo9MsWjd3Eo1Z
   8vrG6DaEOn904T/AmBgzZB2HhNZYfHiIflDiley8hjNZrtcG44KmWepUt
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10430"; a="289072934"
X-IronPort-AV: E=Sophos;i="5.93,217,1654585200"; 
   d="scan'208";a="289072934"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2022 16:42:03 -0700
X-IronPort-AV: E=Sophos;i="5.93,217,1654585200"; 
   d="scan'208";a="931401656"
Received: from jekeller-desk.amr.corp.intel.com (HELO jekeller-desk.jekeller.internal) ([10.166.241.7])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2022 16:42:03 -0700
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>,
        Jonathan Corbet <corbet@lwn.net>, Jiri Pirko <jiri@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [RFC iproute2 3/6] mnl_utils: add function to dump command policy
Date:   Fri,  5 Aug 2022 16:41:52 -0700
Message-Id: <20220805234155.2878160-4-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.37.1.208.ge72d93e88cb2
In-Reply-To: <20220805234155.2878160-1-jacob.e.keller@intel.com>
References: <20220805234155.2878160-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce a new mnlu_get_get_op_policy function which can extract the
kernel policy data for a command. This will enable checking policy to
determine whether an attribute is accepted by a netlink command.

The policy data is reported using a new mnlu_attr_policy structure. This
allows getting a single array of policy data for a command making it easy
to check if an attribute is supported. The structure does also contain the
table of pointers to the policy data attributes which would also allow
checking both type and range.

This policy information will be used in a future change to make devlink
ensure attributes it sends are supported by the reported policy for that
command.

Only one layer of policy checking is currently supported, but an additional
mnlu_gen_get_policy_idx function could be added to support nested policy
checking in the future.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
---
 include/mnl_utils.h |  27 +++++
 lib/mnl_utils.c     | 240 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 267 insertions(+)

diff --git a/include/mnl_utils.h b/include/mnl_utils.h
index 2193934849e1..450f304bb302 100644
--- a/include/mnl_utils.h
+++ b/include/mnl_utils.h
@@ -11,6 +11,31 @@ struct mnlu_gen_socket {
 	uint8_t version;
 };
 
+/**
+ * struct mnlu_attr_policy
+ *
+ * Structure representing the policy for a single attribute. Pass an array of
+ * at least nlg->maxattr + 1 to mnlu_gen_get_op_policy to extract the policy
+ * for a netlink op.
+ *
+ * @attr_type: the attribute type, extracted from the NLA data
+ *
+ * @valid: if set, the attribute is accepted by the policy. If not set, the
+ *         attribute is not accepted by the policy.
+ *
+ * @tb: Pointers to the NLA data. Only remains valid until a new netlink
+ *      command is sent, as it points directly to the netlink message buffer.
+ */
+struct mnlu_attr_policy {
+	/* Pointers to the nla attributes describing the policy for this
+	 * attribute. Note that these only remain valid until the next netlink
+	 * message is sent.
+	 */
+	const struct nlattr *tb[NL_POLICY_TYPE_ATTR_MAX + 1];
+	uint32_t attr_type;
+	uint8_t valid : 1;
+};
+
 int mnlu_gen_socket_open(struct mnlu_gen_socket *nlg, const char *family_name,
 			 uint8_t version);
 void mnlu_gen_socket_close(struct mnlu_gen_socket *nlg);
@@ -30,5 +55,7 @@ int mnlu_socket_recv_run(struct mnl_socket *nl, unsigned int seq, void *buf, siz
 			 mnl_cb_t cb, void *data);
 int mnlu_gen_socket_recv_run(struct mnlu_gen_socket *nlg, mnl_cb_t cb,
 			     void *data);
+int mnlu_gen_get_op_policy(struct mnlu_gen_socket *nlg, uint32_t op, bool dump,
+			   struct mnlu_attr_policy *policy);
 
 #endif /* __MNL_UTILS_H__ */
diff --git a/lib/mnl_utils.c b/lib/mnl_utils.c
index 79bac5cfd4de..f9918afd517d 100644
--- a/lib/mnl_utils.c
+++ b/lib/mnl_utils.c
@@ -252,3 +252,243 @@ int mnlu_gen_socket_recv_run(struct mnlu_gen_socket *nlg, mnl_cb_t cb,
 				    MNL_SOCKET_BUFFER_SIZE,
 				    cb, data);
 }
+
+struct policy_info {
+	struct mnlu_gen_socket *nlg;
+	struct mnlu_attr_policy *policy;
+	uint32_t policy_idx;
+	uint32_t op;
+	bool dump;
+};
+
+static int
+parse_policy_idx_cb(const struct nlattr *attr, void *data)
+{
+	const struct nlattr **tb = data;
+	int type = mnl_attr_get_type(attr);
+
+	if (mnl_attr_type_valid(attr, CTRL_ATTR_POLICY_DUMP_MAX) < 0)
+		return MNL_CB_OK;
+
+	switch (type) {
+	case CTRL_ATTR_POLICY_DO:
+	case CTRL_ATTR_POLICY_DUMP:
+		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
+			return MNL_CB_ERROR;
+		break;
+	default:
+		break;
+	}
+	tb[type] = attr;
+	return MNL_CB_OK;
+}
+
+static int
+parse_policy_idx(const struct nlattr *attr, struct policy_info *info)
+{
+	struct nlattr *tb[CTRL_ATTR_POLICY_DUMP_MAX + 1] = {};
+	struct nlattr *idx_attr;
+	uint32_t op;
+
+	/* The type of this nested attribute is the op */
+	op = mnl_attr_get_type(attr);
+
+	/* Skip ops we're not interested in */
+	if (op != info->op)
+		return MNL_CB_OK;
+
+	mnl_attr_parse_nested(attr, parse_policy_idx_cb, tb);
+	if (info->dump)
+		idx_attr = tb[CTRL_ATTR_POLICY_DUMP];
+	else
+		idx_attr = tb[CTRL_ATTR_POLICY_DO];
+	if (!idx_attr)
+		return MNL_CB_ERROR;
+
+	info->policy_idx = mnl_attr_get_u32(idx_attr);
+
+	return MNL_CB_OK;
+}
+
+static int
+parse_policy_attr_data_cb(const struct nlattr *attr, void *data)
+{
+	struct mnlu_attr_policy *policy = data;
+	int type = mnl_attr_get_type(attr);
+
+	/* Unknown policy type attributes are ignored */
+	if (mnl_attr_type_valid(attr, NL_POLICY_TYPE_ATTR_MAX) < 0)
+		return MNL_CB_OK;
+
+	switch (type) {
+	case NL_POLICY_TYPE_ATTR_TYPE:
+		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
+			return MNL_CB_ERROR;
+
+		policy->attr_type = mnl_attr_get_u32(attr);
+		policy->valid = 1;
+		break;
+	case NL_POLICY_TYPE_ATTR_MIN_VALUE_S:
+		/* libmnl doesn't yet have s64 */
+		if (mnl_attr_validate(attr, MNL_TYPE_U64) < 0)
+			return MNL_CB_ERROR;
+		break;
+	case NL_POLICY_TYPE_ATTR_MAX_VALUE_S:
+		/* libmnl doesn't yet have s64 */
+		if (mnl_attr_validate(attr, MNL_TYPE_U64) < 0)
+			return MNL_CB_ERROR;
+		break;
+	case NL_POLICY_TYPE_ATTR_MIN_VALUE_U:
+		if (mnl_attr_validate(attr, MNL_TYPE_U64) < 0)
+			return MNL_CB_ERROR;
+		break;
+	case NL_POLICY_TYPE_ATTR_MAX_VALUE_U:
+		if (mnl_attr_validate(attr, MNL_TYPE_U64) < 0)
+			return MNL_CB_ERROR;
+		break;
+	case NL_POLICY_TYPE_ATTR_MIN_LENGTH:
+		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
+			return MNL_CB_ERROR;
+		break;
+	case NL_POLICY_TYPE_ATTR_MAX_LENGTH:
+		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
+			return MNL_CB_ERROR;
+		break;
+	case NL_POLICY_TYPE_ATTR_POLICY_IDX:
+		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
+			return MNL_CB_ERROR;
+		break;
+	case NL_POLICY_TYPE_ATTR_POLICY_MAXTYPE:
+		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
+			return MNL_CB_ERROR;
+		break;
+	case NL_POLICY_TYPE_ATTR_BITFIELD32_MASK:
+		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
+			return MNL_CB_ERROR;
+		break;
+	case NL_POLICY_TYPE_ATTR_MASK:
+		if (mnl_attr_validate(attr, MNL_TYPE_U64) < 0)
+			return MNL_CB_ERROR;
+		break;
+	default:
+		break;
+	}
+
+	policy->tb[type] = attr;
+
+	return MNL_CB_OK;
+}
+
+static int
+parse_policy_data(const struct nlattr *attr, struct policy_info *info)
+{
+	const struct nlattr *nested_attr;
+	int policy_idx, attr_id;
+
+	/* The type of this nested attribute is the policy index */
+	policy_idx = mnl_attr_get_type(attr);
+
+	/* Skip policies we're not interested in */
+	if (policy_idx != info->policy_idx)
+		return MNL_CB_OK;
+
+	if (mnl_attr_validate(attr, MNL_TYPE_NESTED) < 0)
+		return MNL_CB_ERROR;
+	nested_attr = mnl_attr_get_payload(attr);
+	if (!mnl_attr_ok(nested_attr, mnl_attr_get_payload_len(attr)))
+		return MNL_CB_ERROR;
+	if (mnl_attr_validate(nested_attr, MNL_TYPE_NESTED) < 0)
+		return MNL_CB_ERROR;
+	if (mnl_attr_type_valid(attr, info->nlg->maxattr) < 0)
+		return MNL_CB_ERROR;
+
+	attr_id = mnl_attr_get_type(nested_attr);
+
+	return mnl_attr_parse_nested(nested_attr, parse_policy_attr_data_cb,
+				     &info->policy[attr_id]);
+}
+
+static int get_policy_attrs_cb(const struct nlattr *attr, void *data)
+{
+	int type = mnl_attr_get_type(attr);
+	struct policy_info *info = data;
+	struct nlattr *nested_attr;
+
+	if (mnl_attr_type_valid(attr, CTRL_ATTR_MAX) < 0)
+		return MNL_CB_ERROR;
+
+	switch (type) {
+	case CTRL_ATTR_OP_POLICY:
+	case CTRL_ATTR_POLICY:
+		if (mnl_attr_validate(attr, MNL_TYPE_NESTED) < 0)
+			return MNL_CB_ERROR;
+
+		nested_attr = mnl_attr_get_payload(attr);
+		if (!mnl_attr_ok(nested_attr, mnl_attr_get_payload_len(attr)))
+			return MNL_CB_ERROR;
+
+		if (mnl_attr_validate(nested_attr, MNL_TYPE_NESTED) < 0)
+			return MNL_CB_ERROR;
+
+		if (type == CTRL_ATTR_OP_POLICY)
+			return parse_policy_idx(nested_attr, info);
+
+		return parse_policy_data(nested_attr, info);
+	default:
+		break;
+	}
+
+	return MNL_CB_OK;
+}
+
+static int get_policy_cb(const struct nlmsghdr *nlh, void *data)
+{
+	struct genlmsghdr *genl = mnl_nlmsg_get_payload(nlh);
+
+	return mnl_attr_parse(nlh, sizeof(*genl), get_policy_attrs_cb, data);
+}
+
+/**
+ * mnlu_get_op_policy - Get policy for a specific op.
+ * @nlg: the socket to get policy on
+ * @op: the op to get the policy for
+ * @dump: if true, get the policy NLM_F_DUMP
+ * @policy: an array of size nlg->maxattr used to return policy data
+ *
+ * Uses CTRL_CMD_GETPOLICY to extract policy information from the kernel for
+ * the specified op. The data is extracted into the provided policy buffer
+ * which is expected to be of size nlg->maxattr.
+ *
+ * This function must be called after mnlu_gen_socket_open.
+ */
+int mnlu_gen_get_op_policy(struct mnlu_gen_socket *nlg, uint32_t op, bool dump,
+			   struct mnlu_attr_policy *policy)
+{
+	struct policy_info info = {};
+	struct genlmsghdr hdr = {};
+	struct nlmsghdr *nlh;
+	int err;
+
+	info.nlg = nlg;
+	info.policy = policy;
+	info.dump = dump;
+	info.op = op;
+
+	hdr.cmd = CTRL_CMD_GETPOLICY;
+	hdr.version = 0x1;
+
+	nlh = mnlu_msg_prepare(nlg->buf, GENL_ID_CTRL,
+			       NLM_F_REQUEST | NLM_F_ACK | NLM_F_DUMP,
+			       &hdr, sizeof(hdr));
+
+	mnl_attr_put_u16(nlh, CTRL_ATTR_FAMILY_ID, nlg->family);
+	mnl_attr_put_u32(nlh, CTRL_ATTR_OP, op);
+
+	err = mnl_socket_sendto(nlg->nl, nlh, nlh->nlmsg_len);
+	if (err < 0)
+		return err;
+
+	return mnlu_socket_recv_run(nlg->nl, nlh->nlmsg_seq, nlg->buf,
+				    MNL_SOCKET_BUFFER_SIZE,
+				    get_policy_cb, &info);
+}
-- 
2.37.1.208.ge72d93e88cb2

