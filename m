Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EA39284E98
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 17:04:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726487AbgJFPEn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 11:04:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:45392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725970AbgJFPEe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Oct 2020 11:04:34 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1832F20866;
        Tue,  6 Oct 2020 15:04:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601996673;
        bh=cIYqrxHVVxN/iXJWISgqFegkRrH+qOGyf2ripFmIdoY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Co6X9tWUvfKsrQF1lJg2YTgcWSrNadQvbaj1h2wNRr4Xp+7sIH/NvNVW6kxcRn3oa
         5YWl+nFLahjQ2DMjQzAUf+H+C4eF/EYAv+/invtTffMhNaGnSwZaRjFCj3ZgOuhSlP
         ti4moC+ndhxScGyz+HRTFEfO1wkl66BU3AWNf8tk=
From:   Jakub Kicinski <kuba@kernel.org>
To:     mkubecek@suse.cz
Cc:     netdev@vger.kernel.org, kernel-team@fb.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH ethtool-next v2 5/6] netlink: use policy dumping to check if stats flag is supported
Date:   Tue,  6 Oct 2020 08:04:24 -0700
Message-Id: <20201006150425.2631432-6-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201006150425.2631432-1-kuba@kernel.org>
References: <20201006150425.2631432-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Older kernels don't support statistics, to avoid retries
make use of netlink policy dumps to figure out which
flags kernel actually supports.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 netlink/msgbuff.h |   6 ++
 netlink/netlink.c | 151 ++++++++++++++++++++++++++++++++++++++++++++++
 netlink/netlink.h |   2 +
 3 files changed, 159 insertions(+)

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
index e42d57076a4b..f79da12d3eee 100644
--- a/netlink/netlink.c
+++ b/netlink/netlink.c
@@ -135,6 +135,157 @@ bool netlink_cmd_check(struct cmd_context *ctx, unsigned int cmd,
 	return !(nlctx->ops_flags[cmd] & cap);
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
+static int family_policy_find_op(struct ethtool_op_policy_query_ctx *ctx,
+				 const struct nlattr *op_policy)
+{
+	const struct nlattr *attr;
+	unsigned int type;
+	int ret;
+
+	type = ctx->nlctx->is_dump ?
+		CTRL_ATTR_POLICY_DUMP : CTRL_ATTR_POLICY_DO;
+
+	mnl_attr_for_each_nested(attr, op_policy) {
+		const struct nlattr *tb[CTRL_ATTR_POLICY_DUMP_MAX + 1] = {};
+		DECLARE_ATTR_TB_INFO(tb);
+
+		if (mnl_attr_get_type(attr) != ctx->op)
+			continue;
+
+		ret = mnl_attr_parse_nested(attr, attr_cb, &tb_info);
+		if (ret < 0)
+			return ret;
+
+		if (!tb[type])
+			continue;
+
+		ctx->op_policy_found = true;
+		ctx->op_policy_idx = mnl_attr_get_u32(tb[type]);
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
+	const struct nlattr *policy_attr, *attr_attr, *attr;
+	struct ethtool_op_policy_query_ctx *ctx = data;
+	unsigned int attr_idx, policy_idx;
+	int ret;
+
+	ret = mnl_attr_parse(nlhdr, GENL_HDRLEN, attr_cb, &tb_info);
+	if (ret < 0)
+		return MNL_CB_ERROR;
+
+	if (!ctx->op_policy_found) {
+		if (!tb[CTRL_ATTR_OP_POLICY]) {
+			fprintf(stderr, "Error: op policy map not present\n");
+			return MNL_CB_ERROR;
+		}
+		ret = family_policy_find_op(ctx, tb[CTRL_ATTR_OP_POLICY]);
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
+	if (policy_idx == ctx->op_policy_idx && attr_idx == ctx->op_hdr_attr) {
+		attr = tba[NL_POLICY_TYPE_ATTR_POLICY_IDX];
+		if (!attr) {
+			fprintf(stderr,	"Error: no policy index in what was expected to be ethtool header attribute\n");
+			return MNL_CB_ERROR;
+		}
+		ctx->hdr_policy_found = true;
+		ctx->hdr_policy_idx = mnl_attr_get_u32(attr);
+	}
+
+	if (ctx->hdr_policy_found && ctx->hdr_policy_idx == policy_idx &&
+	    attr_idx == ETHTOOL_A_HEADER_FLAGS) {
+		attr = tba[NL_POLICY_TYPE_ATTR_MASK];
+		if (!attr) {
+			fprintf(stderr,	"Error: validation mask not reported for ethtool header flags\n");
+			return MNL_CB_ERROR;
+		}
+
+		ctx->flag_mask = mnl_attr_get_u64(attr);
+	}
+
+	return MNL_CB_OK;
+}
+
+static int get_flags_policy(struct nl_context *nlctx, struct nl_socket *nlsk,
+			    unsigned int nlcmd, unsigned int hdrattr)
+{
+	struct nl_msg_buff *msgbuff = &nlsk->msgbuff;
+	struct ethtool_op_policy_query_ctx ctx;
+	int ret;
+
+	memset(&ctx, 0, sizeof(ctx));
+	ctx.nlctx = nlctx;
+	ctx.op = nlcmd;
+	ctx.op_hdr_attr = hdrattr;
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
+	nlsock_process_reply(nlsk, family_policy_cb, &ctx);
+
+	ret = ctx.flag_mask;
+	return ret;
+}
+
+u32 get_stats_flag(struct nl_context *nlctx, unsigned int nlcmd,
+		   unsigned int hdrattr)
+{
+	int ret;
+
+	if (!nlctx->ctx->show_stats)
+		return 0;
+	if (nlcmd > ETHTOOL_MSG_USER_MAX ||
+	    !(nlctx->ops_flags[nlcmd] & GENL_CMD_CAP_HASPOL))
+		return 0;
+
+	ret = get_flags_policy(nlctx, nlctx->ethnl_socket, nlcmd, hdrattr);
+	if (ret < 0)
+		return 0;
+
+	return ret & ETHTOOL_FLAG_STATS;
+}
+
 /* initialization */
 
 static int genl_read_ops(struct nl_context *nlctx,
diff --git a/netlink/netlink.h b/netlink/netlink.h
index 1012e8e32cd8..799f2556cb31 100644
--- a/netlink/netlink.h
+++ b/netlink/netlink.h
@@ -66,6 +66,8 @@ bool netlink_cmd_check(struct cmd_context *ctx, unsigned int cmd,
 		       bool allow_wildcard);
 const char *get_dev_name(const struct nlattr *nest);
 int get_dev_info(const struct nlattr *nest, int *ifindex, char *ifname);
+u32 get_stats_flag(struct nl_context *nlctx, unsigned int nlcmd,
+		   unsigned int hdrattr);
 
 int linkmodes_reply_cb(const struct nlmsghdr *nlhdr, void *data);
 int linkinfo_reply_cb(const struct nlmsghdr *nlhdr, void *data);
-- 
2.26.2

