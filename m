Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DE78603668
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 01:07:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229868AbiJRXHs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 19:07:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbiJRXHm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 19:07:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CE6129342
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 16:07:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2FB54B82177
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 23:07:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63CE3C4347C;
        Tue, 18 Oct 2022 23:07:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666134456;
        bh=VL8sJfoWNNjI9RnXpz9Jpye/setrSS6uoWMMpRgxDfY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CyoAEuKpXWTNSpZydnzQbYONsPUm6MWQexajxeY6xTsSNQC9cJMxX+nVF7C14Y+4t
         d7/mEXqG35ntkBIuIsbKXk5gU6dxRrVDLrVIsVcyh1FBB9e5eDTyyhTGJO0KZwrbLG
         AV5ycLWT6o5FB/79zzABnLV8IaB26TwYlHF0gy3naKW9SR4+tBJot9k2QnKaOa3h8j
         H+3j8i3TCzOHwAHbi+CGXu3YPjAedcsziDBAJsSJ2f8yFeJ/elD+0U1eyjTYr65TQO
         KPdezEgLPHFesTjrMg7edqComIcgSK3DUk/j2WGGY/4Ru7tHCz/3CfCfxzjkPfZKNU
         CrBtlrFZPZu2g==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net, johannes@sipsolutions.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        jiri@resnulli.us, razor@blackwall.org, nicolas.dichtel@6wind.com,
        gnault@redhat.com, jacob.e.keller@intel.com, fw@strlen.de,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 05/13] genetlink: check for callback type at op load time
Date:   Tue, 18 Oct 2022 16:07:20 -0700
Message-Id: <20221018230728.1039524-6-kuba@kernel.org>
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

Now that genl_get_cmd_split() is informed what type of callback
user is trying to access (do or dump) we can check that this
callback is indeed available and return an error early.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/netlink/genetlink.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/net/netlink/genetlink.c b/net/netlink/genetlink.c
index 26ddbd23549d..9dfb3cf89b97 100644
--- a/net/netlink/genetlink.c
+++ b/net/netlink/genetlink.c
@@ -166,11 +166,17 @@ static int genl_get_cmd(u32 cmd, const struct genl_family *family,
 	return genl_get_cmd_small(cmd, family, op);
 }
 
-static void
+static int
 genl_cmd_full_to_split(struct genl_split_ops *op,
 		       const struct genl_family *family,
 		       const struct genl_ops *full, u8 flags)
 {
+	if ((flags & GENL_CMD_CAP_DO && !full->doit) ||
+	    (flags & GENL_CMD_CAP_DUMP && !full->dumpit)) {
+		memset(op, 0, sizeof(*op));
+		return -ENOENT;
+	}
+
 	if (flags & GENL_CMD_CAP_DUMP) {
 		op->start	= full->start;
 		op->dumpit	= full->dumpit;
@@ -196,6 +202,8 @@ genl_cmd_full_to_split(struct genl_split_ops *op,
 	op->validate		= full->validate;
 
 	op->flags		|= flags;
+
+	return 0;
 }
 
 static int
@@ -211,9 +219,7 @@ genl_get_cmd_split(u32 cmd, u8 flags, const struct genl_family *family,
 		return err;
 	}
 
-	genl_cmd_full_to_split(op, family, &full, flags);
-
-	return 0;
+	return genl_cmd_full_to_split(op, family, &full, flags);
 }
 
 static void genl_get_cmd_by_index(unsigned int i,
@@ -704,9 +710,6 @@ static int genl_family_rcv_msg_dumpit(const struct genl_family *family,
 	struct genl_start_context ctx;
 	int err;
 
-	if (!ops->dumpit)
-		return -EOPNOTSUPP;
-
 	ctx.family = family;
 	ctx.nlh = nlh;
 	ctx.extack = extack;
@@ -751,9 +754,6 @@ static int genl_family_rcv_msg_doit(const struct genl_family *family,
 	struct genl_info info;
 	int err;
 
-	if (!ops->doit)
-		return -EOPNOTSUPP;
-
 	attrbuf = genl_family_rcv_msg_attrs_parse(family, nlh, extack,
 						  ops, hdrlen,
 						  GENL_DONT_VALIDATE_STRICT);
-- 
2.37.3

