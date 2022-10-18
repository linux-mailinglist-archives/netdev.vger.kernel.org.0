Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23EDA60366D
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 01:07:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229924AbiJRXHy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 19:07:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229841AbiJRXHr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 19:07:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 622315A2EF
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 16:07:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D34E261739
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 23:07:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27B7EC433C1;
        Tue, 18 Oct 2022 23:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666134461;
        bh=Kwc9VeT2vgZ0mLglv0UXQ6unc+yGMRA8Px2MGEo2M90=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d4JSHV8fJJlrZC/xuhhqIf7joIiaxzk4nQpQdUNQbbtmgyIRTQkYEOZEDqXrRxb07
         afNqkylMrm5MiYLt18kYIe9LMFL3IUg26z8GuLkOPzoY4BvDOTxr5Y5EKg+P/N54rg
         31aET2xVpnzyM8Zi8xPehkqZZZIYL0iryVgRc6yiCZQOawultepTozNsuzEqgVwM1a
         uoZX+ncxrjbIlU4Q143uLWdfsRt/SgZlBikPwKwIS7rRRhfbsfMhrjxhesBYYEunXl
         KG/aYOwapQgAtpG6+vyxp3ye6chF9NiwqsIKOgCD44pjp1T2H2TlyN2K6IFVFQI+5p
         ywoNbFbRnhZzA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net, johannes@sipsolutions.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        jiri@resnulli.us, razor@blackwall.org, nicolas.dichtel@6wind.com,
        gnault@redhat.com, jacob.e.keller@intel.com, fw@strlen.de,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 12/13] genetlink: allow families to use split ops directly
Date:   Tue, 18 Oct 2022 16:07:27 -0700
Message-Id: <20221018230728.1039524-13-kuba@kernel.org>
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

Let families to hook in the new split ops.

They are more flexible and should note be much larger than
full ops. Each split op is 40B while full op is 48B.
Devlink for example has 54 dos and 19 dumps, 2 of the dumps
do not have a do -> 56 full commands = 2688B.
Split ops would have taken 2920B, so 9% more space while
allowing individual per/post doit and per-type policies.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 include/net/genetlink.h |   5 ++
 net/netlink/genetlink.c | 158 +++++++++++++++++++++++++++++++++-------
 2 files changed, 137 insertions(+), 26 deletions(-)

diff --git a/include/net/genetlink.h b/include/net/genetlink.h
index 373a99984cfe..38ad0dc89240 100644
--- a/include/net/genetlink.h
+++ b/include/net/genetlink.h
@@ -44,6 +44,9 @@ struct genl_info;
  * @n_ops: number of operations supported by this family
  * @small_ops: the small-struct operations supported by this family
  * @n_small_ops: number of small-struct operations supported by this family
+ * @split_ops: the split do/dump form of operation definition
+ * @n_split_ops: number of entries in @split_ops, not that with split do/dump
+ *	ops the number of entries is not the same as number of commands
  */
 struct genl_family {
 	unsigned int		hdrsize;
@@ -54,6 +57,7 @@ struct genl_family {
 	u8			parallel_ops:1;
 	u8			n_ops;
 	u8			n_small_ops;
+	u8			n_split_ops;
 	u8			n_mcgrps;
 	u8			resv_start_op;
 	const struct nla_policy *policy;
@@ -65,6 +69,7 @@ struct genl_family {
 					     struct genl_info *info);
 	const struct genl_ops *	ops;
 	const struct genl_small_ops *small_ops;
+	const struct genl_split_ops *split_ops;
 	const struct genl_multicast_group *mcgrps;
 	struct module		*module;
 
diff --git a/net/netlink/genetlink.c b/net/netlink/genetlink.c
index 301981bae83d..53cc5cfcdc57 100644
--- a/net/netlink/genetlink.c
+++ b/net/netlink/genetlink.c
@@ -99,6 +99,16 @@ static const struct genl_family *genl_family_find_byname(char *name)
 	return NULL;
 }
 
+struct genl_op_iter {
+	const struct genl_family *family;
+	struct genl_split_ops doit;
+	struct genl_split_ops dumpit;
+	int cmd_idx;
+	int entry_idx;
+	u32 cmd;
+	u8 flags;
+};
+
 static void genl_op_from_full(const struct genl_family *family,
 			      unsigned int i, struct genl_ops *op)
 {
@@ -153,6 +163,47 @@ static int genl_get_cmd_small(u32 cmd, const struct genl_family *family,
 	return -ENOENT;
 }
 
+static void genl_op_from_split(struct genl_op_iter *iter)
+{
+	const struct genl_family *family = iter->family;
+	int i, cnt = 0;
+
+	i = iter->entry_idx - family->n_ops - family->n_small_ops;
+
+	if (family->split_ops[i + cnt].flags & GENL_CMD_CAP_DO) {
+		iter->doit = family->split_ops[i + cnt];
+		cnt++;
+	} else {
+		memset(&iter->doit, 0, sizeof(iter->doit));
+	}
+
+	if (family->split_ops[i + cnt].flags & GENL_CMD_CAP_DUMP) {
+		iter->dumpit = family->split_ops[i + cnt];
+		cnt++;
+	} else {
+		memset(&iter->dumpit, 0, sizeof(iter->dumpit));
+	}
+
+	WARN_ON(!cnt);
+	iter->entry_idx += cnt;
+}
+
+static int
+genl_get_cmd_split(u32 cmd, u8 flag, const struct genl_family *family,
+		   struct genl_split_ops *op)
+{
+	int i;
+
+	for (i = 0; i < family->n_split_ops; i++)
+		if (family->split_ops[i].cmd == cmd &&
+		    family->split_ops[i].flags & flag) {
+			*op = family->split_ops[i];
+			return 0;
+		}
+
+	return -ENOENT;
+}
+
 static int
 genl_cmd_full_to_split(struct genl_split_ops *op,
 		       const struct genl_family *family,
@@ -204,50 +255,60 @@ genl_get_cmd(u32 cmd, u8 flags, const struct genl_family *family,
 	err = genl_get_cmd_full(cmd, family, &full);
 	if (err == -ENOENT)
 		err = genl_get_cmd_small(cmd, family, &full);
-	if (err) {
-		memset(op, 0, sizeof(*op));
-		return err;
-	}
+	/* Found one of legacy forms */
+	if (err == 0)
+		return genl_cmd_full_to_split(op, family, &full, flags);
 
-	return genl_cmd_full_to_split(op, family, &full, flags);
+	err = genl_get_cmd_split(cmd, flags, family, op);
+	if (err)
+		memset(op, 0, sizeof(*op));
+	return err;
 }
 
-struct genl_op_iter {
-	const struct genl_family *family;
-	struct genl_split_ops doit;
-	struct genl_split_ops dumpit;
-	int i;
-	u32 cmd;
-	u8 flags;
-};
-
 static bool
 genl_op_iter_init(const struct genl_family *family, struct genl_op_iter *iter)
 {
 	iter->family = family;
-	iter->i = 0;
+	iter->cmd_idx = 0;
+	iter->entry_idx = 0;
 
 	iter->flags = 0;
 
-	return iter->family->n_ops + iter->family->n_small_ops;
+	return iter->family->n_ops +
+		iter->family->n_small_ops +
+		iter->family->n_split_ops;
 }
 
 static bool genl_op_iter_next(struct genl_op_iter *iter)
 {
 	const struct genl_family *family = iter->family;
+	bool legacy_op = true;
 	struct genl_ops op;
 
-	if (iter->i < family->n_ops)
-		genl_op_from_full(family, iter->i, &op);
-	else if (iter->i < family->n_ops + family->n_small_ops)
-		genl_op_from_small(family, iter->i - family->n_ops, &op);
-	else
+	if (iter->entry_idx < family->n_ops) {
+		genl_op_from_full(family, iter->entry_idx, &op);
+	} else if (iter->entry_idx < family->n_ops + family->n_small_ops) {
+		genl_op_from_small(family, iter->entry_idx - family->n_ops,
+				   &op);
+	} else if (iter->entry_idx <
+		   family->n_ops + family->n_small_ops + family->n_split_ops) {
+		legacy_op = false;
+		/* updates entry_idx */
+		genl_op_from_split(iter);
+	} else {
 		return false;
+	}
 
-	iter->i++;
+	iter->cmd_idx++;
 
-	genl_cmd_full_to_split(&iter->doit, family, &op, GENL_CMD_CAP_DO);
-	genl_cmd_full_to_split(&iter->dumpit, family, &op, GENL_CMD_CAP_DUMP);
+	if (legacy_op) {
+		iter->entry_idx++;
+
+		genl_cmd_full_to_split(&iter->doit, family,
+				       &op, GENL_CMD_CAP_DO);
+		genl_cmd_full_to_split(&iter->dumpit, family,
+				       &op, GENL_CMD_CAP_DUMP);
+	}
 
 	iter->cmd = iter->doit.cmd | iter->dumpit.cmd;
 	iter->flags = iter->doit.flags | iter->dumpit.flags;
@@ -263,7 +324,7 @@ genl_op_iter_copy(struct genl_op_iter *dst, struct genl_op_iter *src)
 
 static unsigned int genl_op_iter_idx(struct genl_op_iter *iter)
 {
-	return iter->i;
+	return iter->cmd_idx;
 }
 
 static int genl_allocate_reserve_groups(int n_groups, int *first_id)
@@ -431,12 +492,24 @@ static void genl_unregister_mc_groups(const struct genl_family *family)
 	}
 }
 
+static bool genl_split_op_check(const struct genl_split_ops *op)
+{
+	if (WARN_ON(hweight8(op->flags & (GENL_CMD_CAP_DO |
+					  GENL_CMD_CAP_DUMP)) != 1))
+		return true;
+	if (WARN_ON(!op->maxattr || !op->policy))
+		return true;
+	return false;
+}
+
 static int genl_validate_ops(const struct genl_family *family)
 {
 	struct genl_op_iter i, j;
+	unsigned int s;
 
 	if (WARN_ON(family->n_ops && !family->ops) ||
-	    WARN_ON(family->n_small_ops && !family->small_ops))
+	    WARN_ON(family->n_small_ops && !family->small_ops) ||
+	    WARN_ON(family->n_split_ops && !family->split_ops))
 		return -EINVAL;
 
 	for (genl_op_iter_init(family, &i); genl_op_iter_next(&i); ) {
@@ -450,6 +523,39 @@ static int genl_validate_ops(const struct genl_family *family)
 		}
 	}
 
+	if (family->n_split_ops) {
+		if (genl_split_op_check(&family->split_ops[0]))
+			return -EINVAL;
+	}
+
+	for (s = 1; s < family->n_split_ops; s++) {
+		const struct genl_split_ops *a, *b;
+
+		a = &family->split_ops[s - 1];
+		b = &family->split_ops[s];
+
+		if (genl_split_op_check(b))
+			return -EINVAL;
+
+		/* Check sort order */
+		if (a->cmd < b->cmd)
+			continue;
+
+		if (a->internal_flags != b->internal_flags ||
+		    ((a->flags ^ b->flags) & ~(GENL_CMD_CAP_DO |
+					       GENL_CMD_CAP_DUMP))) {
+			WARN_ON(1);
+			return -EINVAL;
+		}
+
+		if ((a->flags & GENL_CMD_CAP_DO) &&
+		    (b->flags & GENL_CMD_CAP_DUMP))
+			continue;
+
+		WARN_ON(1);
+		return -EINVAL;
+	}
+
 	return 0;
 }
 
-- 
2.37.3

