Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F5F064F6BB
	for <lists+netdev@lfdr.de>; Sat, 17 Dec 2022 02:20:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230034AbiLQBUP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Dec 2022 20:20:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbiLQBUL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Dec 2022 20:20:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03259680A4
        for <netdev@vger.kernel.org>; Fri, 16 Dec 2022 17:20:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8DE77622FB
        for <netdev@vger.kernel.org>; Sat, 17 Dec 2022 01:20:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1108C43398;
        Sat, 17 Dec 2022 01:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671240009;
        bh=UvWKELS3cNFjpAx0SVkS7EB65/NzOCKmew3sy+QW84U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aOPkG3JZOBeIIQG196N6aC8DHsuyLGBg40Mwl31VjDefGYqKhIC5+1L1EEF9xEB52
         TchMvtJou6S/AJYtFeEuH6ddta1n1buo57VFMQmZbZoyIPPHkinE5nESEcnsh1Moht
         8G1enSmE1add6HdiowbTfFA82o/J7Y5mXhSO6BJ+rGraqq3+bXWPBBUZVeHPVGV4GG
         WAc4mn2THVmklLIJSGmKtYjVcXE20+XAnukGEssmT/X2X6jBIJCswdNtgSn4l0VAiV
         9WC8zb0Bmxndpchl7EmOg4TaGEn4MwUNgl2QRDk5/bJAXr29STcIW0iVbVyYNbuPjn
         jfDah+DtljU8Q==
From:   Jakub Kicinski <kuba@kernel.org>
To:     jiri@resnulli.us, jacob.e.keller@intel.com, leon@kernel.org
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [RFC net-next 02/10] devlink: update the code in netns move to latest helpers
Date:   Fri, 16 Dec 2022 17:19:45 -0800
Message-Id: <20221217011953.152487-3-kuba@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221217011953.152487-1-kuba@kernel.org>
References: <20221217011953.152487-1-kuba@kernel.org>
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

devlink_pernet_pre_exit() is the only obvious place which takes
the instance lock without using the devl_ helpers. Update the code
and move the error print after releasing the reference
(having unlock and put together feels slightly idiomatic).

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/devlink/core.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/devlink/core.c b/net/devlink/core.c
index 88c88b8053e2..d3b8336946fd 100644
--- a/net/devlink/core.c
+++ b/net/devlink/core.c
@@ -299,15 +299,16 @@ static void __net_exit devlink_pernet_pre_exit(struct net *net)
 	 */
 	devlinks_xa_for_each_registered_get(net, index, devlink) {
 		WARN_ON(!(devlink->features & DEVLINK_F_RELOAD));
-		mutex_lock(&devlink->lock);
+		devl_lock(devlink);
 		err = devlink_reload(devlink, &init_net,
 				     DEVLINK_RELOAD_ACTION_DRIVER_REINIT,
 				     DEVLINK_RELOAD_LIMIT_UNSPEC,
 				     &actions_performed, NULL);
-		mutex_unlock(&devlink->lock);
+		devl_unlock(devlink);
+		devlink_put(devlink);
+
 		if (err && err != -EOPNOTSUPP)
 			pr_warn("Failed to reload devlink instance into init_net\n");
-		devlink_put(devlink);
 	}
 }
 
-- 
2.38.1

