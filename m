Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02E9760366F
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 01:08:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229886AbiJRXH5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 19:07:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229827AbiJRXHp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 19:07:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB19DBE2F2
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 16:07:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 928B361723
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 23:07:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76F54C433D7;
        Tue, 18 Oct 2022 23:07:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666134461;
        bh=RtKta0cJkreQ92ktt5mTi/lO5SCoKozzwF0MjboUrCE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gjqdhakZBCknyAi03u7iOSNaztv82UTtiTtCPJC8aDm1vV00/NQitBRTxmx8YGeRi
         gxhMc/8qKAyt5xUrxzaZ1P66IV3zUi85fHsLFvo8j62ZDFfQty/rbx6KD5d99T8Qbr
         wFQ/e+MyiFdy6YRjTbJdupTT+bf0x23I8/TFa2sr/LTJ4WHOYUaiikYSYCH6Jn93Tj
         NrUnO9xioSm8ur/w0vc1YvvDHQT4IfoCGV5uLwODHxDWmlVEvNdDzBicdqJi0Uy6aU
         nBaFc0/XAcCaw/0qgPFJ1HtXLhETGbexUYXx1n6Sl/YMP0XRHuIJCYLLL5/TvYGwnj
         MD2fdM8wF0uTA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net, johannes@sipsolutions.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        jiri@resnulli.us, razor@blackwall.org, nicolas.dichtel@6wind.com,
        gnault@redhat.com, jacob.e.keller@intel.com, fw@strlen.de,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 11/13] genetlink: inline old iteration helpers
Date:   Tue, 18 Oct 2022 16:07:26 -0700
Message-Id: <20221018230728.1039524-12-kuba@kernel.org>
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

All dumpers use the iterators now, inline the cmd by index
stuff into iterator code.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/netlink/genetlink.c | 32 +++++++++-----------------------
 1 file changed, 9 insertions(+), 23 deletions(-)

diff --git a/net/netlink/genetlink.c b/net/netlink/genetlink.c
index 63807204805a..301981bae83d 100644
--- a/net/netlink/genetlink.c
+++ b/net/netlink/genetlink.c
@@ -99,11 +99,6 @@ static const struct genl_family *genl_family_find_byname(char *name)
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
@@ -217,18 +212,6 @@ genl_get_cmd(u32 cmd, u8 flags, const struct genl_family *family,
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
@@ -246,22 +229,25 @@ genl_op_iter_init(const struct genl_family *family, struct genl_op_iter *iter)
 
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
2.37.3

