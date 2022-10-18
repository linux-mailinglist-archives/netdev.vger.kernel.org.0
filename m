Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAABC60366B
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 01:07:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229919AbiJRXHv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 19:07:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229832AbiJRXHr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 19:07:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 371C874342
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 16:07:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C8082B82190
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 23:07:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D4D2C43470;
        Tue, 18 Oct 2022 23:07:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666134459;
        bh=u+tZ7uVquAmDQaEKNLVWwV0FRsVkjHGISxOH5h2u96w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QbcFUQ7SMvvm6LPTFI6hgBEP3aG2WmzdacXL/ompTtOAm7wGYa3p+wset215Z30Qc
         Kn+Hfa1ZwO4pXetF+0zgPy3nuncAv0SCB6cXqF+8LRTFeaN5dqC3zlgBP2Nkp5+sn8
         ZYlWdRedDPOX+ALVa4Oin8CigKpHAoW4iLV4+BIaxQUZSgkhW10TbFxXaxB4pT17BG
         ocQyE945MpbOtTabc4+ce+SBCrOwGKCpdWHXygj427qJlyNZwHA/HTm2jYk5B0h5+H
         YgBuOijtlbRlCuHKpajw3ZCw7+3gdWDZFAB6AYblSiPOrpg41C4g/UPs3RtsgKrids
         ie2/FVhhxIKCA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net, johannes@sipsolutions.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        jiri@resnulli.us, razor@blackwall.org, nicolas.dichtel@6wind.com,
        gnault@redhat.com, jacob.e.keller@intel.com, fw@strlen.de,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 09/13] genetlink: add iterator for walking family ops
Date:   Tue, 18 Oct 2022 16:07:24 -0700
Message-Id: <20221018230728.1039524-10-kuba@kernel.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221018230728.1039524-1-kuba@kernel.org>
References: <20221018230728.1039524-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Subsequent changes will expose split op structures to users,
so walking the family ops with just an index will get harder.
Add a structured iterator, convert the simple cases.
Policy dumping needs more careful conversion.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/netlink/genetlink.c | 114 ++++++++++++++++++++++++++--------------
 1 file changed, 74 insertions(+), 40 deletions(-)

diff --git a/net/netlink/genetlink.c b/net/netlink/genetlink.c
index 9bfb110053c7..c5fcb7b9c383 100644
--- a/net/netlink/genetlink.c
+++ b/net/netlink/genetlink.c
@@ -193,6 +193,7 @@ genl_cmd_full_to_split(struct genl_split_ops *op,
 	op->flags		= full->flags;
 	op->validate		= full->validate;
 
+	/* Make sure flags include the GENL_CMD_CAP_DO / GENL_CMD_CAP_DUMP */
 	op->flags		|= flags;
 
 	return 0;
@@ -228,6 +229,57 @@ static void genl_get_cmd_by_index(unsigned int i,
 		WARN_ON_ONCE(1);
 }
 
+struct genl_op_iter {
+	const struct genl_family *family;
+	struct genl_split_ops doit;
+	struct genl_split_ops dumpit;
+	int i;
+	u32 cmd;
+	u8 flags;
+};
+
+static bool
+genl_op_iter_init(const struct genl_family *family, struct genl_op_iter *iter)
+{
+	iter->family = family;
+	iter->i = 0;
+
+	iter->flags = 0;
+
+	return genl_get_cmd_cnt(iter->family);
+}
+
+static bool genl_op_iter_next(struct genl_op_iter *iter)
+{
+	struct genl_ops op;
+
+	if (iter->i >= genl_get_cmd_cnt(iter->family))
+		return false;
+
+	genl_get_cmd_by_index(iter->i, iter->family, &op);
+	iter->i++;
+
+	genl_cmd_full_to_split(&iter->doit, iter->family, &op, GENL_CMD_CAP_DO);
+	genl_cmd_full_to_split(&iter->dumpit, iter->family,
+			       &op, GENL_CMD_CAP_DUMP);
+
+	iter->cmd = iter->doit.cmd | iter->dumpit.cmd;
+	iter->flags = iter->doit.flags | iter->dumpit.flags;
+
+	return true;
+}
+
+static void
+genl_op_iter_copy(struct genl_op_iter *dst, struct genl_op_iter *src)
+{
+	*dst = *src;
+}
+
+static unsigned int genl_op_iter_idx(struct genl_op_iter *iter)
+{
+	return iter->i;
+}
+
 static int genl_allocate_reserve_groups(int n_groups, int *first_id)
 {
 	unsigned long *new_groups;
@@ -395,23 +447,19 @@ static void genl_unregister_mc_groups(const struct genl_family *family)
 
 static int genl_validate_ops(const struct genl_family *family)
 {
-	int i, j;
+	struct genl_op_iter i, j;
 
 	if (WARN_ON(family->n_ops && !family->ops) ||
 	    WARN_ON(family->n_small_ops && !family->small_ops))
 		return -EINVAL;
 
-	for (i = 0; i < genl_get_cmd_cnt(family); i++) {
-		struct genl_ops op;
-
-		genl_get_cmd_by_index(i, family, &op);
-		if (op.dumpit == NULL && op.doit == NULL)
+	for (genl_op_iter_init(family, &i); genl_op_iter_next(&i); ) {
+		if (!(i.flags & (GENL_CMD_CAP_DO | GENL_CMD_CAP_DUMP)))
 			return -EINVAL;
-		for (j = i + 1; j < genl_get_cmd_cnt(family); j++) {
-			struct genl_ops op2;
 
-			genl_get_cmd_by_index(j, family, &op2);
-			if (op.cmd == op2.cmd)
+		genl_op_iter_copy(&j, &i);
+		while (genl_op_iter_next(&j)) {
+			if (i.cmd == j.cmd)
 				return -EINVAL;
 		}
 	}
@@ -891,6 +939,7 @@ static struct genl_family genl_ctrl;
 static int ctrl_fill_info(const struct genl_family *family, u32 portid, u32 seq,
 			  u32 flags, struct sk_buff *skb, u8 cmd)
 {
+	struct genl_op_iter i;
 	void *hdr;
 
 	hdr = genlmsg_put(skb, portid, seq, &genl_ctrl, flags, cmd);
@@ -904,33 +953,26 @@ static int ctrl_fill_info(const struct genl_family *family, u32 portid, u32 seq,
 	    nla_put_u32(skb, CTRL_ATTR_MAXATTR, family->maxattr))
 		goto nla_put_failure;
 
-	if (genl_get_cmd_cnt(family)) {
+	if (genl_op_iter_init(family, &i)) {
 		struct nlattr *nla_ops;
-		int i;
 
 		nla_ops = nla_nest_start_noflag(skb, CTRL_ATTR_OPS);
 		if (nla_ops == NULL)
 			goto nla_put_failure;
 
-		for (i = 0; i < genl_get_cmd_cnt(family); i++) {
+		while (genl_op_iter_next(&i)) {
 			struct nlattr *nest;
-			struct genl_ops op;
 			u32 op_flags;
 
-			genl_get_cmd_by_index(i, family, &op);
-			op_flags = op.flags;
-			if (op.dumpit)
-				op_flags |= GENL_CMD_CAP_DUMP;
-			if (op.doit)
-				op_flags |= GENL_CMD_CAP_DO;
-			if (op.policy)
+			op_flags = i.flags;
+			if (i.doit.policy || i.dumpit.policy)
 				op_flags |= GENL_CMD_CAP_HASPOL;
 
-			nest = nla_nest_start_noflag(skb, i + 1);
+			nest = nla_nest_start_noflag(skb, genl_op_iter_idx(&i));
 			if (nest == NULL)
 				goto nla_put_failure;
 
-			if (nla_put_u32(skb, CTRL_ATTR_OP_ID, op.cmd) ||
+			if (nla_put_u32(skb, CTRL_ATTR_OP_ID, i.cmd) ||
 			    nla_put_u32(skb, CTRL_ATTR_OP_FLAGS, op_flags))
 				goto nla_put_failure;
 
@@ -1203,8 +1245,8 @@ static int ctrl_dumppolicy_start(struct netlink_callback *cb)
 	struct ctrl_dump_policy_ctx *ctx = (void *)cb->ctx;
 	struct nlattr **tb = info->attrs;
 	const struct genl_family *rt;
-	struct genl_ops op;
-	int err, i;
+	struct genl_op_iter i;
+	int err;
 
 	BUILD_BUG_ON(sizeof(*ctx) > sizeof(cb->ctx));
 
@@ -1259,26 +1301,18 @@ static int ctrl_dumppolicy_start(struct netlink_callback *cb)
 		return 0;
 	}
 
-	for (i = 0; i < genl_get_cmd_cnt(rt); i++) {
-		struct genl_split_ops doit, dumpit;
-
-		genl_get_cmd_by_index(i, rt, &op);
-
-		genl_cmd_full_to_split(&doit, ctx->rt, &op, GENL_CMD_CAP_DO);
-		genl_cmd_full_to_split(&dumpit, ctx->rt,
-				       &op, GENL_CMD_CAP_DUMP);
-
-		if (doit.policy) {
+	for (genl_op_iter_init(rt, &i); genl_op_iter_next(&i); ) {
+		if (i.doit.policy) {
 			err = netlink_policy_dump_add_policy(&ctx->state,
-							     doit.policy,
-							     doit.maxattr);
+							     i.doit.policy,
+							     i.doit.maxattr);
 			if (err)
 				goto err_free_state;
 		}
-		if (dumpit.policy) {
+		if (i.dumpit.policy) {
 			err = netlink_policy_dump_add_policy(&ctx->state,
-							     dumpit.policy,
-							     dumpit.maxattr);
+							     i.dumpit.policy,
+							     i.dumpit.maxattr);
 			if (err)
 				goto err_free_state;
 		}
-- 
2.37.3

