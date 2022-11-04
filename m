Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D254461A0AA
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 20:14:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229841AbiKDTOe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 15:14:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbiKDTOI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 15:14:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55AF34D5D5
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 12:13:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0DA5EB82F46
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 19:13:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C408C433D6;
        Fri,  4 Nov 2022 19:13:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667589232;
        bh=/qQgjt49tT0y+STbQf8q9CMYiaobhEoz9Zk1corcXm4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B7A9iLzITyozDZzGw0iloDXcHIZwQo2jKZ1n61dEOXy2SwQdU78ULjrWlDLebrFjh
         HyBbO5SL/PLo5lHkYIZ8+1UUDCA+zfG61vKLBkuv2+VcBtYOD+fDTh/4pHjUiweq/D
         WWh5eQ7kvwYJhTFdcPCPuH+uoNwF2EZMPm2bioqYvyaM9CKZ8M4Tper24nDaud8Qp3
         iykp9KR4x/cGbRNo3FsFhT1nX+pvehg1vO06tPnKKKXL0e5Qt3hEHopbuvTeqyg4ui
         jevvJfr4s249BoK58D4UXWWj9zRgdynHVZYZ/3vum1AvVHnNcsH1pm2Q9l1qbBgcJb
         Ywez6Dlt2Uxjg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        jiri@resnulli.us, razor@blackwall.org, nicolas.dichtel@6wind.com,
        gnault@redhat.com, jacob.e.keller@intel.com, fw@strlen.de,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v3 11/13] genetlink: inline old iteration helpers
Date:   Fri,  4 Nov 2022 12:13:41 -0700
Message-Id: <20221104191343.690543-12-kuba@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221104191343.690543-1-kuba@kernel.org>
References: <20221104191343.690543-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

All dumpers use the iterators now, inline the cmd by index
stuff into iterator code.

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/netlink/genetlink.c | 32 +++++++++-----------------------
 1 file changed, 9 insertions(+), 23 deletions(-)

diff --git a/net/netlink/genetlink.c b/net/netlink/genetlink.c
index 4b8c65d9e9d3..0a4f1470f442 100644
--- a/net/netlink/genetlink.c
+++ b/net/netlink/genetlink.c
@@ -118,11 +118,6 @@ static const struct genl_family *genl_family_find_byname(char *name)
 	return NULL;
 }
 
-static int genl_get_cmd_cnt(const struct genl_family *family)
-{
-	return family->n_ops + family->n_small_ops;
-}
-
 static void genl_op_from_full(const struct genl_family *family,
 			      unsigned int i, struct genl_ops *op)
 {
@@ -240,18 +235,6 @@ genl_get_cmd(u32 cmd, u8 flags, const struct genl_family *family,
 	return genl_cmd_full_to_split(op, family, &full, flags);
 }
 
-static void genl_get_cmd_by_index(unsigned int i,
-				  const struct genl_family *family,
-				  struct genl_ops *op)
-{
-	if (i < family->n_ops)
-		genl_op_from_full(family, i, op);
-	else if (i < family->n_ops + family->n_small_ops)
-		genl_op_from_small(family, i - family->n_ops, op);
-	else
-		WARN_ON_ONCE(1);
-}
-
 struct genl_op_iter {
 	const struct genl_family *family;
 	struct genl_split_ops doit;
@@ -269,22 +252,25 @@ genl_op_iter_init(const struct genl_family *family, struct genl_op_iter *iter)
 
 	iter->flags = 0;
 
-	return genl_get_cmd_cnt(iter->family);
+	return iter->family->n_ops + iter->family->n_small_ops;
 }
 
 static bool genl_op_iter_next(struct genl_op_iter *iter)
 {
+	const struct genl_family *family = iter->family;
 	struct genl_ops op;
 
-	if (iter->i >= genl_get_cmd_cnt(iter->family))
+	if (iter->i < family->n_ops)
+		genl_op_from_full(family, iter->i, &op);
+	else if (iter->i < family->n_ops + family->n_small_ops)
+		genl_op_from_small(family, iter->i - family->n_ops, &op);
+	else
 		return false;
 
-	genl_get_cmd_by_index(iter->i, iter->family, &op);
 	iter->i++;
 
-	genl_cmd_full_to_split(&iter->doit, iter->family, &op, GENL_CMD_CAP_DO);
-	genl_cmd_full_to_split(&iter->dumpit, iter->family,
-			       &op, GENL_CMD_CAP_DUMP);
+	genl_cmd_full_to_split(&iter->doit, family, &op, GENL_CMD_CAP_DO);
+	genl_cmd_full_to_split(&iter->dumpit, family, &op, GENL_CMD_CAP_DUMP);
 
 	iter->cmd = iter->doit.cmd | iter->dumpit.cmd;
 	iter->flags = iter->doit.flags | iter->dumpit.flags;
-- 
2.38.1

