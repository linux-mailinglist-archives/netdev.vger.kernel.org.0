Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDC5E64A92B
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 22:05:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233673AbiLLVE7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 16:04:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233453AbiLLVEk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 16:04:40 -0500
Received: from smtp.smtpout.orange.fr (smtp-24.smtpout.orange.fr [80.12.242.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9C3F192AA
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 13:03:12 -0800 (PST)
Received: from pop-os.home ([86.243.100.34])
        by smtp.orange.fr with ESMTPA
        id 4px6pWxRHfRXa4px6p0kgM; Mon, 12 Dec 2022 22:03:10 +0100
X-ME-Helo: pop-os.home
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Mon, 12 Dec 2022 22:03:10 +0100
X-ME-IP: 86.243.100.34
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jacob Keller <jacob.e.keller@intel.com>
Cc:     linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        netdev@vger.kernel.org
Subject: [PATCH net] genetlink: Fix an error handling path in ctrl_dumppolicy_start()
Date:   Mon, 12 Dec 2022 22:03:06 +0100
Message-Id: <7186dae6d951495f6918c45f8250e6407d71e88f.1670878949.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If this memory allocation fails, some resources need to be freed.
Add the missing goto to the error handling path.

Fixes: b502b3185cd6 ("genetlink: use iterator in the op to policy map dumping")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
This patch is speculative.

This function is a callback and I don't know how the core works and handles
such situation, so review with care!

More-over, should this kmalloc() be a kzalloc()?
genl_op_iter_init() below does not initialize all fields, be they are maybe
set correctly before uses.
---
 net/netlink/genetlink.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/netlink/genetlink.c b/net/netlink/genetlink.c
index 600993c80050..7b9f04bd85a2 100644
--- a/net/netlink/genetlink.c
+++ b/net/netlink/genetlink.c
@@ -1451,8 +1451,10 @@ static int ctrl_dumppolicy_start(struct netlink_callback *cb)
 	}
 
 	ctx->op_iter = kmalloc(sizeof(*ctx->op_iter), GFP_KERNEL);
-	if (!ctx->op_iter)
-		return -ENOMEM;
+	if (!ctx->op_iter) {
+		err = -ENOMEM;
+		goto err_free_state;
+	}
 
 	genl_op_iter_init(rt, ctx->op_iter);
 	ctx->dump_map = genl_op_iter_next(ctx->op_iter);
-- 
2.34.1

