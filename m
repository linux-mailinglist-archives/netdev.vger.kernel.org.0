Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55247607F19
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 21:35:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229613AbiJUTf4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 15:35:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229719AbiJUTfv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 15:35:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBA6515B301
        for <netdev@vger.kernel.org>; Fri, 21 Oct 2022 12:35:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 171B061F38
        for <netdev@vger.kernel.org>; Fri, 21 Oct 2022 19:35:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24745C433C1;
        Fri, 21 Oct 2022 19:35:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666380946;
        bh=Pgz3n7P2C3NhFXujtJz2Ci4Z63Cb/moas0UjFt3K+54=;
        h=From:To:Cc:Subject:Date:From;
        b=uaKm0BHvDY56OAjw2YfgYRfxQKpW3C1Bao8nmLWD87teBKjqFol6jTC8IRRMud2mL
         fRyKMIkyrVQNskIMxAFc765/yUYWR2qHIr393unMMJVsxNe3a6Idv2Zxz88KtaMLgU
         EFDAg8T/10ELmuqPwI3xcjMV8CrHhRXpmWWT9P3Uuf41eS/ud2+9BSU3ZSpIuIK9TV
         HC3CVNFD04d0O6wYNlvovsaMLT9pElHFjuU0Zqm+G4s/Dog8iDLQuDorMQ5pswReiQ
         5AK/k+HW+MMeSIs2vFFY/0VpguJJ8JpBB9V2odyHeGx8LhsAcBqa42BOJs63nov+QN
         F0shf3N8KuveA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net, johannes@sipsolutions.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        jacob.e.keller@intel.com, fw@strlen.de,
        Jakub Kicinski <kuba@kernel.org>, jiri@nvidia.com
Subject: [PATCH net] genetlink: piggy back on resv_op to default to a reject policy
Date:   Fri, 21 Oct 2022 12:35:32 -0700
Message-Id: <20221021193532.1511293-1-kuba@kernel.org>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To keep backward compatibility we used to leave attribute parsing
to the family if no policy is specified. This becomes tedious as
we move to more strict validation. Families must define reject all
policies if they don't want any attributes accepted.

Piggy back on the resv_start_op field as the switchover point.
AFAICT only ethtool has added new commands since the resv_start_op
was defined, and it has per-op policies so this should be a no-op.

Nonetheless the patch should still go into v6.1 for consistency.

Link: https://lore.kernel.org/all/20221019125745.3f2e7659@kernel.org/
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: jiri@nvidia.com
---
 include/net/genetlink.h | 10 +++++++++-
 net/netlink/genetlink.c | 23 +++++++++++++++++++++++
 2 files changed, 32 insertions(+), 1 deletion(-)

diff --git a/include/net/genetlink.h b/include/net/genetlink.h
index 3d08e67b3cfc..9f97f73615b6 100644
--- a/include/net/genetlink.h
+++ b/include/net/genetlink.h
@@ -41,13 +41,21 @@ struct genl_info;
  * @mcgrps: multicast groups used by this family
  * @n_mcgrps: number of multicast groups
  * @resv_start_op: first operation for which reserved fields of the header
- *	can be validated, new families should leave this field at zero
+ *	can be validated and policies are required (see below);
+ *	new families should leave this field at zero
  * @mcgrp_offset: starting number of multicast group IDs in this family
  *	(private)
  * @ops: the operations supported by this family
  * @n_ops: number of operations supported by this family
  * @small_ops: the small-struct operations supported by this family
  * @n_small_ops: number of small-struct operations supported by this family
+ *
+ * Attribute policies (the combination of @policy and @maxattr fields)
+ * can be attached at the family level or at the operation level.
+ * If both are present the per-operation policy takes precedence.
+ * For operations before @resv_start_op lack of policy means that the core
+ * will perform no attribute parsing or validation. For newer operations
+ * if policy is not provided core will reject all TLV attributes.
  */
 struct genl_family {
 	int			id;		/* private */
diff --git a/net/netlink/genetlink.c b/net/netlink/genetlink.c
index 39b7c00e4cef..b1fd059c9992 100644
--- a/net/netlink/genetlink.c
+++ b/net/netlink/genetlink.c
@@ -78,10 +78,29 @@ static unsigned long mc_group_start = 0x3 | BIT(GENL_ID_CTRL) |
 static unsigned long *mc_groups = &mc_group_start;
 static unsigned long mc_groups_longs = 1;
 
+/* We need the last attribute with non-zero ID therefore a 2-entry array */
+static struct nla_policy genl_policy_reject_all[] = {
+	{ .type = NLA_REJECT },
+	{ .type = NLA_REJECT },
+};
+
 static int genl_ctrl_event(int event, const struct genl_family *family,
 			   const struct genl_multicast_group *grp,
 			   int grp_id);
 
+static void
+genl_op_fill_in_reject_policy(const struct genl_family *family,
+			      struct genl_ops *op)
+{
+	BUILD_BUG_ON(ARRAY_SIZE(genl_policy_reject_all) - 1 != 1);
+
+	if (op->policy || op->cmd < family->resv_start_op)
+		return;
+
+	op->policy = genl_policy_reject_all;
+	op->maxattr = 1;
+}
+
 static const struct genl_family *genl_family_find_byid(unsigned int id)
 {
 	return idr_find(&genl_fam_idr, id);
@@ -113,6 +132,8 @@ static void genl_op_from_full(const struct genl_family *family,
 		op->maxattr = family->maxattr;
 	if (!op->policy)
 		op->policy = family->policy;
+
+	genl_op_fill_in_reject_policy(family, op);
 }
 
 static int genl_get_cmd_full(u32 cmd, const struct genl_family *family,
@@ -142,6 +163,8 @@ static void genl_op_from_small(const struct genl_family *family,
 
 	op->maxattr = family->maxattr;
 	op->policy = family->policy;
+
+	genl_op_fill_in_reject_policy(family, op);
 }
 
 static int genl_get_cmd_small(u32 cmd, const struct genl_family *family,
-- 
2.37.3

