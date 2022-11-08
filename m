Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8D81621DCD
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 21:41:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229831AbiKHUlk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 15:41:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229709AbiKHUlj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 15:41:39 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEED065856
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 12:41:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 0BDE1CE1C6D
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 20:41:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10DEBC433C1;
        Tue,  8 Nov 2022 20:41:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667940091;
        bh=rXcphY6FX9yrJTCaZlfUZqtI+7Etnhk6Ft0CWCP13IM=;
        h=From:To:Cc:Subject:Date:From;
        b=lCweRh3bBVCMiXE2vHHi3/CI05/Ow5CLiDetWedDzg+Q8Ft52YMcn+TyYGrr8xEAL
         INYKb+2WqI0r2AJtokh25kwb+wxjJgWhQYSK7nGhk4wq+BOy1fulYD50Hj53CGcYaX
         vftIVwYy+b8osgWDaerJauKSMeMqJAdC7frDPZOygnq/hluMfgNUhr4tWfkUlGfWpQ
         fRL1h7XXh6TWFWua8t53WSD3tcblBKUiPd7xChK+qtiyV3HK28DTWKtj/qMhdAVivQ
         e0bT+uzMh8iPbvDppz+bXT4xe72Oi18qqcRh9j5sycDNWjhweFSzuvleFH/74qCTYY
         GKOKKKu0O7pBQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>, jacob.e.keller@intel.com
Subject: [PATCH net-next] genetlink: correctly begin the iteration over policies
Date:   Tue,  8 Nov 2022 12:41:28 -0800
Message-Id: <20221108204128.330287-1-kuba@kernel.org>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The return value from genl_op_iter_init() only tells us if
there are any policies but to begin the iteration (and therefore
load the first entry) we need to call genl_op_iter_next().
Note that it's safe to call genl_op_iter_next() on a family
with no ops, it will just return false.

This may lead to various crashes, a warning in
netlink_policy_dump_get_policy_idx() when policy is not found
or.. no problem at all if the kmalloc'ed memory happens to be
zeroed.

Fixes: b502b3185cd6 ("genetlink: use iterator in the op to policy map dumping")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: jacob.e.keller@intel.com

Why KASAN doesn't catch the use of uninit memory here is a mystery :S
---
 net/netlink/genetlink.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/netlink/genetlink.c b/net/netlink/genetlink.c
index 362a61179036..9b7dfc45dd67 100644
--- a/net/netlink/genetlink.c
+++ b/net/netlink/genetlink.c
@@ -1437,7 +1437,9 @@ static int ctrl_dumppolicy_start(struct netlink_callback *cb)
 	ctx->op_iter = kmalloc(sizeof(*ctx->op_iter), GFP_KERNEL);
 	if (!ctx->op_iter)
 		return -ENOMEM;
-	ctx->dump_map = genl_op_iter_init(rt, ctx->op_iter);
+
+	genl_op_iter_init(rt, ctx->op_iter);
+	ctx->dump_map = genl_op_iter_next(ctx->op_iter);
 
 	for (genl_op_iter_init(rt, &i); genl_op_iter_next(&i); ) {
 		if (i.doit.policy) {
-- 
2.38.1

