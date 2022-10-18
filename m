Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85C05603662
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 01:07:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229574AbiJRXHi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 19:07:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiJRXHh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 19:07:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 526B629342
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 16:07:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7A329616B6
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 23:07:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A676C433C1;
        Tue, 18 Oct 2022 23:07:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666134453;
        bh=fhafUmhbolJXUXvAfB438CqoF0o+pw10oMsb9Yqut1s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L5G90phqpOMH43cLrZEV4VGWn4iR5LL0v90g8U888J12jhqkr2q2rI2fsxke5QEi6
         biaLexfexbB2nEtk8EgNuvyZVKJlnjHl9b12STHLXGF0PA+6wYUVKKUloaRCCqryxr
         vWLRFfgiJ3DMXIu5ALrsf8LPnwovD1kSuK0XlUQyjiqWBqppMrBTrYcEiWS/mMzHIU
         KxZEevtY6/BQ29ndKjsx1sHdoSou4+SXZQDb2nmHXkdKqh7qjp2zyYmxWE2LoE2bRz
         4K8hMdm4tIWhEcYgdMGVU2pEhVg/bkwo7Ktx91GEs4B+5nhL5iVXCgkAjpWg2xfV/h
         8ghSI/mDp8tpw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net, johannes@sipsolutions.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        jiri@resnulli.us, razor@blackwall.org, nicolas.dichtel@6wind.com,
        gnault@redhat.com, jacob.e.keller@intel.com, fw@strlen.de,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 01/13] genetlink: refactor the cmd <> policy mapping dump
Date:   Tue, 18 Oct 2022 16:07:16 -0700
Message-Id: <20221018230728.1039524-2-kuba@kernel.org>
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

The code at the top of ctrl_dumppolicy() dumps mappings between
ops and policies. It supports dumping both the entire family and
single op if dump is filtered. But both of those cases are handled
inside a loop, which makes the logic harder to follow and change.
Refactor to split the two cases more clearly.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/netlink/genetlink.c | 26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff --git a/net/netlink/genetlink.c b/net/netlink/genetlink.c
index 39b7c00e4cef..43cc31fb3d25 100644
--- a/net/netlink/genetlink.c
+++ b/net/netlink/genetlink.c
@@ -1294,21 +1294,23 @@ static int ctrl_dumppolicy(struct sk_buff *skb, struct netlink_callback *cb)
 	void *hdr;
 
 	if (!ctx->policies) {
-		while (ctx->opidx < genl_get_cmd_cnt(ctx->rt)) {
-			struct genl_ops op;
+		struct genl_ops op;
 
-			if (ctx->single_op) {
-				int err;
+		if (ctx->single_op) {
+			int err;
 
-				err = genl_get_cmd(ctx->op, ctx->rt, &op);
-				if (WARN_ON(err))
-					return skb->len;
+			err = genl_get_cmd(ctx->op, ctx->rt, &op);
+			if (WARN_ON(err))
+				return err;
 
-				/* break out of the loop after this one */
-				ctx->opidx = genl_get_cmd_cnt(ctx->rt);
-			} else {
-				genl_get_cmd_by_index(ctx->opidx, ctx->rt, &op);
-			}
+			if (ctrl_dumppolicy_put_op(skb, cb, &op))
+				return skb->len;
+
+			ctx->opidx = genl_get_cmd_cnt(ctx->rt);
+		}
+
+		while (ctx->opidx < genl_get_cmd_cnt(ctx->rt)) {
+			genl_get_cmd_by_index(ctx->opidx, ctx->rt, &op);
 
 			if (ctrl_dumppolicy_put_op(skb, cb, &op))
 				return skb->len;
-- 
2.37.3

