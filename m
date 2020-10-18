Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DBC0292028
	for <lists+netdev@lfdr.de>; Sun, 18 Oct 2020 23:32:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728202AbgJRVcE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Oct 2020 17:32:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:47004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728084AbgJRVcB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 18 Oct 2020 17:32:01 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CFF53222EA;
        Sun, 18 Oct 2020 21:32:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603056721;
        bh=5ifuAkzKnv6A4Vme/DxuArxYZ/Ig0wqbuCQ7R7EhgHI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d0Bmi6YhcTJ5ZFTWrsaIjIiGDV6Sw0DFs5whldeQr6Z7+B6iZD0FRkIjA/0VPIDt2
         XbofJXSA/qOxGNzOeDNcUyodDBczzgogFUuDYnnH1UM4yOa7+eX13RIXNkmEdRhQ6r
         MRcjWh2KIDYms75IFrgCF1xqdHnFAxxI4XKdmNHs=
From:   Jakub Kicinski <kuba@kernel.org>
To:     mkubecek@suse.cz
Cc:     netdev@vger.kernel.org, kernel-team@fb.com, idosch@idosch.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH ethtool v3 6/7] netlink: use policy dumping to check if stats flag is supported
Date:   Sun, 18 Oct 2020 14:31:50 -0700
Message-Id: <20201018213151.3450437-7-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201018213151.3450437-1-kuba@kernel.org>
References: <20201018213151.3450437-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Older kernels don't support statistics, to avoid retries
make use of netlink policy dumps to figure out which
flags kernel actually supports.

v3:
 - s/ctx/policy_ctx/
 - save the flags in nl_context to be able to reuse them,
   and not have to return errors and values from the policy
   get function

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 netlink/msgbuff.h |   6 ++
 netlink/netlink.c | 154 ++++++++++++++++++++++++++++++++++++++++++++++
 netlink/netlink.h |   4 ++
 3 files changed, 164 insertions(+)

diff --git a/netlink/msgbuff.h b/netlink/msgbuff.h
index 24b99c5a28d7..7d6731fc24a3 100644
--- a/netlink/msgbuff.h
+++ b/netlink/msgbuff.h
@@ -81,6 +81,12 @@ static inline bool ethnla_put_u32(struct nl_msg_buff *msgbuff, uint16_t type,
 	return ethnla_put(msgbuff, type, sizeof(uint32_t), &data);
 }
 
+static inline bool ethnla_put_u16(struct nl_msg_buff *msgbuff, uint16_t type,
+				  uint16_t data)
+{
+	return ethnla_put(msgbuff, type, sizeof(uint16_t), &data);
+}
+
 static inline bool ethnla_put_u8(struct nl_msg_buff *msgbuff, uint16_t type,
 				 uint8_t data)
 {
diff --git a/netlink/netlink.c b/netlink/netlink.c
index 86dc1efdf5ce..f655f6ea25b7 100644
--- a/netlink/netlink.c
+++ b/netlink/netlink.c
@@ -135,6 +135,160 @@ bool netlink_cmd_check(struct cmd_context *ctx, unsigned int cmd,
 	return !(nlctx->ops_info[cmd].op_flags & cap);
 }
 
+struct ethtool_op_policy_query_ctx {
+	struct nl_context *nlctx;
+	unsigned int op;
+	unsigned int op_hdr_attr;
+
+	bool op_policy_found;
+	bool hdr_policy_found;
+	unsigned int op_policy_idx;
+	unsigned int hdr_policy_idx;
+	uint64_t flag_mask;
+};
+
+static int family_policy_find_op(struct ethtool_op_policy_query_ctx *policy_ctx,
+				 const struct nlattr *op_policy)
+{
+	const struct nlattr *attr;
+	unsigned int type;
+	int ret;
+
+	type = policy_ctx->nlctx->is_dump ?
+		CTRL_ATTR_POLICY_DUMP : CTRL_ATTR_POLICY_DO;
+
+	mnl_attr_for_each_nested(attr, op_policy) {
+		const struct nlattr *tb[CTRL_ATTR_POLICY_DUMP_MAX + 1] = {};
+		DECLARE_ATTR_TB_INFO(tb);
+
+		if (mnl_attr_get_type(attr) != policy_ctx->op)
+			continue;
+
+		ret = mnl_attr_parse_nested(attr, attr_cb, &tb_info);
+		if (ret < 0)
+			return ret;
+
+		if (!tb[type])
+			continue;
+
+		policy_ctx->op_policy_found = true;
+		policy_ctx->op_policy_idx = mnl_attr_get_u32(tb[type]);
+		break;
+	}
+
+	return 0;
+}
+
+static int family_policy_cb(const struct nlmsghdr *nlhdr, void *data)
+{
+	const struct nlattr *tba[NL_POLICY_TYPE_ATTR_MAX + 1] = {};
+	DECLARE_ATTR_TB_INFO(tba);
+	const struct nlattr *tb[CTRL_ATTR_MAX + 1] = {};
+	DECLARE_ATTR_TB_INFO(tb);
+	struct ethtool_op_policy_query_ctx *policy_ctx = data;
+	const struct nlattr *policy_attr, *attr_attr, *attr;
+	unsigned int attr_idx, policy_idx;
+	int ret;
+
+	ret = mnl_attr_parse(nlhdr, GENL_HDRLEN, attr_cb, &tb_info);
+	if (ret < 0)
+		return MNL_CB_ERROR;
+
+	if (!policy_ctx->op_policy_found) {
+		if (!tb[CTRL_ATTR_OP_POLICY]) {
+			fprintf(stderr, "Error: op policy map not present\n");
+			return MNL_CB_ERROR;
+		}
+		ret = family_policy_find_op(policy_ctx, tb[CTRL_ATTR_OP_POLICY]);
+		return ret < 0 ? MNL_CB_ERROR : MNL_CB_OK;
+	}
+
+	if (!tb[CTRL_ATTR_POLICY])
+		return MNL_CB_OK;
+
+	policy_attr = mnl_attr_get_payload(tb[CTRL_ATTR_POLICY]);
+	policy_idx = mnl_attr_get_type(policy_attr);
+	attr_attr = mnl_attr_get_payload(policy_attr);
+	attr_idx = mnl_attr_get_type(attr_attr);
+
+	ret = mnl_attr_parse_nested(attr_attr, attr_cb, &tba_info);
+	if (ret < 0)
+		return MNL_CB_ERROR;
+
+	if (policy_idx == policy_ctx->op_policy_idx &&
+	    attr_idx == policy_ctx->op_hdr_attr) {
+		attr = tba[NL_POLICY_TYPE_ATTR_POLICY_IDX];
+		if (!attr) {
+			fprintf(stderr,	"Error: no policy index in what was expected to be ethtool header attribute\n");
+			return MNL_CB_ERROR;
+		}
+		policy_ctx->hdr_policy_found = true;
+		policy_ctx->hdr_policy_idx = mnl_attr_get_u32(attr);
+	}
+
+	if (policy_ctx->hdr_policy_found &&
+	    policy_ctx->hdr_policy_idx == policy_idx &&
+	    attr_idx == ETHTOOL_A_HEADER_FLAGS) {
+		attr = tba[NL_POLICY_TYPE_ATTR_MASK];
+		if (!attr) {
+			fprintf(stderr,	"Error: validation mask not reported for ethtool header flags\n");
+			return MNL_CB_ERROR;
+		}
+
+		policy_ctx->flag_mask = mnl_attr_get_u64(attr);
+	}
+
+	return MNL_CB_OK;
+}
+
+static int read_flags_policy(struct nl_context *nlctx, struct nl_socket *nlsk,
+			     unsigned int nlcmd, unsigned int hdrattr)
+{
+	struct ethtool_op_policy_query_ctx policy_ctx;
+	struct nl_msg_buff *msgbuff = &nlsk->msgbuff;
+	int ret;
+
+	if (nlctx->ops_info[nlcmd].hdr_policy_loaded)
+		return 0;
+
+	memset(&policy_ctx, 0, sizeof(policy_ctx));
+	policy_ctx.nlctx = nlctx;
+	policy_ctx.op = nlcmd;
+	policy_ctx.op_hdr_attr = hdrattr;
+
+	ret = __msg_init(msgbuff, GENL_ID_CTRL, CTRL_CMD_GETPOLICY,
+			 NLM_F_REQUEST | NLM_F_ACK | NLM_F_DUMP, 1);
+	if (ret < 0)
+		return ret;
+	ret = -EMSGSIZE;
+	if (ethnla_put_u16(msgbuff, CTRL_ATTR_FAMILY_ID, nlctx->ethnl_fam))
+		return ret;
+	if (ethnla_put_u32(msgbuff, CTRL_ATTR_OP, nlcmd))
+		return ret;
+
+	nlsock_sendmsg(nlsk, NULL);
+	nlsock_process_reply(nlsk, family_policy_cb, &policy_ctx);
+
+	nlctx->ops_info[nlcmd].hdr_policy_loaded = 1;
+	nlctx->ops_info[nlcmd].hdr_flags = policy_ctx.flag_mask;
+	return 0;
+}
+
+u32 get_stats_flag(struct nl_context *nlctx, unsigned int nlcmd,
+		   unsigned int hdrattr)
+{
+	if (!nlctx->ctx->show_stats)
+		return 0;
+	if (nlcmd > ETHTOOL_MSG_USER_MAX ||
+	    !(nlctx->ops_info[nlcmd].op_flags & GENL_CMD_CAP_HASPOL))
+		return 0;
+
+	if (read_flags_policy(nlctx, nlctx->ethnl_socket, nlcmd, hdrattr) < 0)
+		return 0;
+
+	return nlctx->ops_info[nlcmd].hdr_flags & ETHTOOL_FLAG_STATS;
+}
+
 /* initialization */
 
 static int genl_read_ops(struct nl_context *nlctx,
diff --git a/netlink/netlink.h b/netlink/netlink.h
index e79143016bd5..c02558540218 100644
--- a/netlink/netlink.h
+++ b/netlink/netlink.h
@@ -27,6 +27,8 @@ enum link_mode_class {
 
 struct nl_op_info {
 	uint32_t		op_flags;
+	uint32_t		hdr_flags;
+	uint8_t			hdr_policy_loaded:1;
 };
 
 struct nl_context {
@@ -70,6 +72,8 @@ bool netlink_cmd_check(struct cmd_context *ctx, unsigned int cmd,
 		       bool allow_wildcard);
 const char *get_dev_name(const struct nlattr *nest);
 int get_dev_info(const struct nlattr *nest, int *ifindex, char *ifname);
+u32 get_stats_flag(struct nl_context *nlctx, unsigned int nlcmd,
+		   unsigned int hdrattr);
 
 int linkmodes_reply_cb(const struct nlmsghdr *nlhdr, void *data);
 int linkinfo_reply_cb(const struct nlmsghdr *nlhdr, void *data);
-- 
2.26.2

