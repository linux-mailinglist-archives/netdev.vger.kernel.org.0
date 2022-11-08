Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0F6E62206C
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 00:44:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229643AbiKHXoc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 18:44:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229564AbiKHXob (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 18:44:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 583912037D
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 15:44:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0743FB81BAB
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 23:44:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A2D3C433C1;
        Tue,  8 Nov 2022 23:44:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667951067;
        bh=C1o97UD6sMNjKNIvhrkNl31utNruSvs3XPXYfRcks5Y=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=i3gOnF9jcCQ3iTvMQtpufGSJLiK1ahLZ8DTFqwbgqLS43D7N0HZd7mlTkgXupS8IN
         nvH7hAwM7BZZy75T8PgbIhO+UMKkjTTXPZxxYuMEvRPHP68tuzYpE/YuLWKx4YwX5i
         h5pbdtP11i/94rWSSOz3nf7rukLTqrZg8mv9CMwa4K6ua1rj2aR6Wp1cLytk+vBug2
         9HrSymkoVVzUoGoBUI7KvAMGKdRWO5tDjRSZHuTXpWVIPugWubsPFqBp3gTeY5iLza
         9SduMbKgn2nqM54CBTt8AtjWPW9/cuDY7M0rhhSIW8VXKnCAot+5TiBB8WDjaN51EX
         5Mz+hnJ1G7K3Q==
Date:   Tue, 8 Nov 2022 15:44:26 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Keller, Jacob E" <jacob.e.keller@intel.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "Jonathan Lemon" <bsd@meta.com>
Subject: Re: [PATCH net-next] genetlink: fix policy dump for dumps
Message-ID: <20221108154426.3a882067@kernel.org>
In-Reply-To: <CO1PR11MB5089F3CECB59624025A648A3D63F9@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <20221108204041.330172-1-kuba@kernel.org>
        <CO1PR11MB5089F3CECB59624025A648A3D63F9@CO1PR11MB5089.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 8 Nov 2022 20:47:57 +0000 Keller, Jacob E wrote:
> A little bit tricky code here, but it makes sense. We could rewrite this to be a bit more verbose like:
> 
> doit_err = genl_get_cmd(.. GENL_CMD_CAP_DO ..);
> dumpit_err = genl_get_cmd(.. GENL_CMD_CAP_DUMPIT ..);
> if (doit_err && dumpit_err) {
>   ...
> }
> 
> That might be a bit easier to read than the !! ( ) + ( ) < 1 notation.

True, I should not give into the bit math temptations.

How about a helper:

diff --git a/net/netlink/genetlink.c b/net/netlink/genetlink.c
index 9b7dfc45dd67..600993c80050 100644
--- a/net/netlink/genetlink.c
+++ b/net/netlink/genetlink.c
@@ -282,6 +282,7 @@ genl_cmd_full_to_split(struct genl_split_ops *op,
 	return 0;
 }
 
+/* Must make sure that op is initialized to 0 on failure */
 static int
 genl_get_cmd(u32 cmd, u8 flags, const struct genl_family *family,
 	     struct genl_split_ops *op)
@@ -302,6 +303,21 @@ genl_get_cmd(u32 cmd, u8 flags, const struct genl_family *family,
 	return err;
 }
 
+/* For policy dumping only, get ops of both do and dump.
+ * Fail if both are missing, genl_get_cmd() will zero-init in case of failure.
+ */
+static int
+genl_get_cmd_both(u32 cmd, const struct genl_family *family,
+		  struct genl_split_ops *doit, struct genl_split_ops *dumpit)
+{
+	int err1, err2;
+
+	err1 = genl_get_cmd(cmd, GENL_CMD_CAP_DO, family, doit);
+	err2 = genl_get_cmd(cmd, GENL_CMD_CAP_DUMP, family, dumpit);
+
+	return err1 && err2 ? -ENOENT : 0;
+}
+
 static bool
 genl_op_iter_init(const struct genl_family *family, struct genl_op_iter *iter)
 {
@@ -1406,10 +1422,10 @@ static int ctrl_dumppolicy_start(struct netlink_callback *cb)
 		ctx->single_op = true;
 		ctx->op = nla_get_u32(tb[CTRL_ATTR_OP]);
 
-		if (genl_get_cmd(ctx->op, GENL_CMD_CAP_DO, rt, &doit) &&
-		    genl_get_cmd(ctx->op, GENL_CMD_CAP_DUMP, rt, &dump)) {
+		err = genl_get_cmd_both(ctx->op, rt, &doit, &dump);
+		if (err) {
 			NL_SET_BAD_ATTR(cb->extack, tb[CTRL_ATTR_OP]);
-			return -ENOENT;
+			return err;
 		}
 
 		if (doit.policy) {
@@ -1551,13 +1567,9 @@ static int ctrl_dumppolicy(struct sk_buff *skb, struct netlink_callback *cb)
 		if (ctx->single_op) {
 			struct genl_split_ops doit, dumpit;
 
-			if (genl_get_cmd(ctx->op, GENL_CMD_CAP_DO,
-					 ctx->rt, &doit) &&
-			    genl_get_cmd(ctx->op, GENL_CMD_CAP_DUMP,
-					 ctx->rt, &dumpit)) {
-				WARN_ON(1);
+			if (WARN_ON(genl_get_cmd_both(ctx->op, ctx->rt,
+						      &doit, &dumpit)))
 				return -ENOENT;
-			}
 
 			if (ctrl_dumppolicy_put_op(skb, cb, &doit, &dumpit))
 				return skb->len;
-- 
2.38.1

