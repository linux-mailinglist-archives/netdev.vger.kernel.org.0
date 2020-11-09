Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 302BE2ABBC0
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 14:32:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732351AbgKINaH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 08:30:07 -0500
Received: from mx2.suse.de ([195.135.220.15]:38732 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731704AbgKIN37 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Nov 2020 08:29:59 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 9AA5DACA3;
        Mon,  9 Nov 2020 13:29:56 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 627CB60344; Mon,  9 Nov 2020 14:29:56 +0100 (CET)
Message-Id: <aea4252fb9a62593083d2466797634d742671004.1604928515.git.mkubecek@suse.cz>
In-Reply-To: <cover.1604928515.git.mkubecek@suse.cz>
References: <cover.1604928515.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH ethtool 1/2] netlink: do not send messages and process replies
 in nl_parser()
To:     netdev@vger.kernel.org
Cc:     Ido Schimmel <idosch@idosch.org>, Jakub Kicinski <kuba@kernel.org>,
        Ivan Vecera <ivecera@redhat.com>
Date:   Mon,  9 Nov 2020 14:29:56 +0100 (CET)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When called with group_style = PARSER_GROUP_MSG, nl_parser() not only
parses the command line and composes the messages but also sends them to
kernel and processes the replies. This is inconsistent with other modes and
also impractical as it takes the control over the process from caller where
it belongs.

Modify nl_parser() to pass composed messages back to caller (which is only
nl_sset() at the moment) and let it send requests and process replies. This
will be needed for an upcoming backward compatibility patch which will need
to inspect and possibly modify one of the composed messages.

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 netlink/cable_test.c |  2 +-
 netlink/channels.c   |  2 +-
 netlink/coalesce.c   |  2 +-
 netlink/eee.c        |  2 +-
 netlink/parser.c     | 43 ++++++++++++++++++++++++++++---------------
 netlink/parser.h     |  3 ++-
 netlink/pause.c      |  2 +-
 netlink/rings.c      |  2 +-
 netlink/settings.c   | 35 ++++++++++++++++++++++++++++++-----
 9 files changed, 66 insertions(+), 27 deletions(-)

diff --git a/netlink/cable_test.c b/netlink/cable_test.c
index 8a7145324610..17139f7d297d 100644
--- a/netlink/cable_test.c
+++ b/netlink/cable_test.c
@@ -574,7 +574,7 @@ int nl_cable_test_tdr(struct cmd_context *ctx)
 			       ctx->devname, 0))
 		return -EMSGSIZE;
 
-	ret = nl_parser(nlctx, tdr_params, NULL, PARSER_GROUP_NEST);
+	ret = nl_parser(nlctx, tdr_params, NULL, PARSER_GROUP_NEST, NULL);
 	if (ret < 0)
 		return ret;
 
diff --git a/netlink/channels.c b/netlink/channels.c
index c6002ceeb121..894c74bcc11a 100644
--- a/netlink/channels.c
+++ b/netlink/channels.c
@@ -126,7 +126,7 @@ int nl_schannels(struct cmd_context *ctx)
 			       ctx->devname, 0))
 		return -EMSGSIZE;
 
-	ret = nl_parser(nlctx, schannels_params, NULL, PARSER_GROUP_NONE);
+	ret = nl_parser(nlctx, schannels_params, NULL, PARSER_GROUP_NONE, NULL);
 	if (ret < 0)
 		return 1;
 
diff --git a/netlink/coalesce.c b/netlink/coalesce.c
index 07a92d04b7a1..75922a91c2e7 100644
--- a/netlink/coalesce.c
+++ b/netlink/coalesce.c
@@ -254,7 +254,7 @@ int nl_scoalesce(struct cmd_context *ctx)
 			       ctx->devname, 0))
 		return -EMSGSIZE;
 
-	ret = nl_parser(nlctx, scoalesce_params, NULL, PARSER_GROUP_NONE);
+	ret = nl_parser(nlctx, scoalesce_params, NULL, PARSER_GROUP_NONE, NULL);
 	if (ret < 0)
 		return 1;
 
diff --git a/netlink/eee.c b/netlink/eee.c
index d3135b2094a4..04d8f0bbe3fc 100644
--- a/netlink/eee.c
+++ b/netlink/eee.c
@@ -174,7 +174,7 @@ int nl_seee(struct cmd_context *ctx)
 			       ctx->devname, 0))
 		return -EMSGSIZE;
 
-	ret = nl_parser(nlctx, seee_params, NULL, PARSER_GROUP_NONE);
+	ret = nl_parser(nlctx, seee_params, NULL, PARSER_GROUP_NONE, NULL);
 	if (ret < 0)
 		return 1;
 
diff --git a/netlink/parser.c b/netlink/parser.c
index 3b25f5d5a88e..c2eae93efb69 100644
--- a/netlink/parser.c
+++ b/netlink/parser.c
@@ -920,7 +920,7 @@ static void __parser_set(uint64_t *map, unsigned int idx)
 }
 
 struct tmp_buff {
-	struct nl_msg_buff	msgbuff;
+	struct nl_msg_buff	*msgbuff;
 	unsigned int		id;
 	unsigned int		orig_len;
 	struct tmp_buff		*next;
@@ -951,7 +951,12 @@ static struct tmp_buff *tmp_buff_find_or_create(struct tmp_buff **phead,
 	if (!new_buff)
 		return NULL;
 	new_buff->id = id;
-	msgbuff_init(&new_buff->msgbuff);
+	new_buff->msgbuff = malloc(sizeof(*new_buff->msgbuff));
+	if (!new_buff->msgbuff) {
+		free(new_buff);
+		return NULL;
+	}
+	msgbuff_init(new_buff->msgbuff);
 	new_buff->next = NULL;
 	*pbuff = new_buff;
 
@@ -965,7 +970,10 @@ static void tmp_buff_destroy(struct tmp_buff *head)
 
 	while (buff) {
 		next = buff->next;
-		msgbuff_done(&buff->msgbuff);
+		if (buff->msgbuff) {
+			msgbuff_done(buff->msgbuff);
+			free(buff->msgbuff);
+		}
 		free(buff);
 		buff = next;
 	}
@@ -980,13 +988,22 @@ static void tmp_buff_destroy(struct tmp_buff *head)
  *               param_parser::offset)
  * @group_style: defines if identifiers in .group represent separate messages,
  *               nested attributes or are not allowed
+ * @msgbuffs:    (only used for @group_style = PARSER_GROUP_MSG) array to store
+ *               pointers to composed messages; caller must make sure this
+ *               array is sufficient, i.e. that it has at least as many entries
+ *               as the number of different .group values in params array;
+ *               entries are filled from the start, remaining entries are not
+ *               modified; caller should zero initialize the array before
+ *               calling nl_parser()
  */
 int nl_parser(struct nl_context *nlctx, const struct param_parser *params,
-	      void *dest, enum parser_group_style group_style)
+	      void *dest, enum parser_group_style group_style,
+	      struct nl_msg_buff **msgbuffs)
 {
 	struct nl_socket *nlsk = nlctx->ethnl_socket;
 	const struct param_parser *parser;
 	struct tmp_buff *buffs = NULL;
+	unsigned int n_msgbuffs = 0;
 	struct tmp_buff *buff;
 	unsigned int n_params;
 	uint64_t *params_seen;
@@ -1004,7 +1021,7 @@ int nl_parser(struct nl_context *nlctx, const struct param_parser *params,
 		buff = tmp_buff_find_or_create(&buffs, parser->group);
 		if (!buff)
 			goto out_free_buffs;
-		msgbuff = &buff->msgbuff;
+		msgbuff = buff->msgbuff;
 		ret = msg_init(nlctx, msgbuff, parser->group,
 			       NLM_F_REQUEST | NLM_F_ACK);
 		if (ret < 0)
@@ -1013,7 +1030,7 @@ int nl_parser(struct nl_context *nlctx, const struct param_parser *params,
 		switch (group_style) {
 		case PARSER_GROUP_NEST:
 			ret = -EMSGSIZE;
-			nest = ethnla_nest_start(&buff->msgbuff, parser->group);
+			nest = ethnla_nest_start(buff->msgbuff, parser->group);
 			if (!nest)
 				goto out_free_buffs;
 			break;
@@ -1062,7 +1079,7 @@ int nl_parser(struct nl_context *nlctx, const struct param_parser *params,
 		buff = NULL;
 		if (parser->group)
 			buff = tmp_buff_find(buffs, parser->group);
-		msgbuff = buff ? &buff->msgbuff : &nlsk->msgbuff;
+		msgbuff = buff ? buff->msgbuff : &nlsk->msgbuff;
 
 		param_dest = dest ? ((char *)dest + parser->dest_offset) : NULL;
 		ret = parser->handler(nlctx, parser->type, parser->handler_data,
@@ -1074,12 +1091,12 @@ int nl_parser(struct nl_context *nlctx, const struct param_parser *params,
 	if (group_style == PARSER_GROUP_MSG) {
 		ret = -EOPNOTSUPP;
 		for (buff = buffs; buff; buff = buff->next)
-			if (msgbuff_len(&buff->msgbuff) > buff->orig_len &&
+			if (msgbuff_len(buff->msgbuff) > buff->orig_len &&
 			    netlink_cmd_check(nlctx->ctx, buff->id, false))
 				goto out_free;
 	}
 	for (buff = buffs; buff; buff = buff->next) {
-		struct nl_msg_buff *msgbuff = &buff->msgbuff;
+		struct nl_msg_buff *msgbuff = buff->msgbuff;
 
 		if (group_style == PARSER_GROUP_NONE ||
 		    msgbuff_len(msgbuff) == buff->orig_len)
@@ -1092,12 +1109,8 @@ int nl_parser(struct nl_context *nlctx, const struct param_parser *params,
 				goto out_free;
 			break;
 		case PARSER_GROUP_MSG:
-			ret = nlsock_sendmsg(nlsk, msgbuff);
-			if (ret < 0)
-				goto out_free;
-			ret = nlsock_process_reply(nlsk, nomsg_reply_cb, NULL);
-			if (ret < 0)
-				goto out_free;
+			msgbuffs[n_msgbuffs++] = msgbuff;
+			buff->msgbuff = NULL;
 			break;
 		default:
 			break;
diff --git a/netlink/parser.h b/netlink/parser.h
index fd55bc768d42..28f26ccc2a1c 100644
--- a/netlink/parser.h
+++ b/netlink/parser.h
@@ -143,6 +143,7 @@ int nl_parse_char_bitset(struct nl_context *nlctx, uint16_t type,
 
 /* main entry point called to parse the command line */
 int nl_parser(struct nl_context *nlctx, const struct param_parser *params,
-	      void *dest, enum parser_group_style group_style);
+	      void *dest, enum parser_group_style group_style,
+	      struct nl_msg_buff **msgbuffs);
 
 #endif /* ETHTOOL_NETLINK_PARSER_H__ */
diff --git a/netlink/pause.c b/netlink/pause.c
index 9bc9a301821f..867d0da71f72 100644
--- a/netlink/pause.c
+++ b/netlink/pause.c
@@ -293,7 +293,7 @@ int nl_spause(struct cmd_context *ctx)
 			       ctx->devname, 0))
 		return -EMSGSIZE;
 
-	ret = nl_parser(nlctx, spause_params, NULL, PARSER_GROUP_NONE);
+	ret = nl_parser(nlctx, spause_params, NULL, PARSER_GROUP_NONE, NULL);
 	if (ret < 0)
 		return 1;
 
diff --git a/netlink/rings.c b/netlink/rings.c
index 4061520212d5..b8c458fce25f 100644
--- a/netlink/rings.c
+++ b/netlink/rings.c
@@ -126,7 +126,7 @@ int nl_sring(struct cmd_context *ctx)
 			       ctx->devname, 0))
 		return -EMSGSIZE;
 
-	ret = nl_parser(nlctx, sring_params, NULL, PARSER_GROUP_NONE);
+	ret = nl_parser(nlctx, sring_params, NULL, PARSER_GROUP_NONE, NULL);
 	if (ret < 0)
 		return 1;
 
diff --git a/netlink/settings.c b/netlink/settings.c
index 41a2e5af1945..dc9280c114b5 100644
--- a/netlink/settings.c
+++ b/netlink/settings.c
@@ -1110,9 +1110,16 @@ static const struct param_parser sset_params[] = {
 	{}
 };
 
+/* Maximum number of request messages sent to kernel; must be equal to the
+ * number of different .group values in sset_params[] array.
+ */
+#define SSET_MAX_MSGS 4
+
 int nl_sset(struct cmd_context *ctx)
 {
+	struct nl_msg_buff *msgbuffs[SSET_MAX_MSGS] = {};
 	struct nl_context *nlctx = ctx->nlctx;
+	unsigned int i;
 	int ret;
 
 	nlctx->cmd = "-s";
@@ -1120,11 +1127,29 @@ int nl_sset(struct cmd_context *ctx)
 	nlctx->argc = ctx->argc;
 	nlctx->devname = ctx->devname;
 
-	ret = nl_parser(nlctx, sset_params, NULL, PARSER_GROUP_MSG);
-	if (ret < 0)
-		return 1;
+	ret = nl_parser(nlctx, sset_params, NULL, PARSER_GROUP_MSG, msgbuffs);
+	if (ret < 0) {
+		ret = 1;
+		goto out_free;
+	}
+
+	for (i = 0; i < SSET_MAX_MSGS && msgbuffs[i]; i++) {
+		struct nl_socket *nlsk = nlctx->ethnl_socket;
 
-	if (ret == 0)
-		return 0;
+		ret = nlsock_sendmsg(nlsk, msgbuffs[i]);
+		if (ret < 0)
+			goto out_free;
+		ret = nlsock_process_reply(nlsk, nomsg_reply_cb, NULL);
+		if (ret < 0)
+			goto out_free;
+	}
+
+out_free:
+	for (i = 0; i < SSET_MAX_MSGS && msgbuffs[i]; i++) {
+		msgbuff_done(msgbuffs[i]);
+		free(msgbuffs[i]);
+	}
+	if (ret >= 0)
+		return ret;
 	return nlctx->exit_code ?: 75;
 }
-- 
2.29.2

