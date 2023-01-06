Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A76065FB79
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 07:34:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231644AbjAFGeN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 01:34:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231717AbjAFGeJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 01:34:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AB656E0FD
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 22:34:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A06DB61D30
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 06:34:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF204C433D2;
        Fri,  6 Jan 2023 06:34:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672986848;
        bh=/VD5s1TLUEDkyvl/fM7lmnsoMBej8OS/PCfG7nKbmMc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PhB9+diOGRDWW+oHk7EypXKvNZWfN286goBpqofHXXrKaOcrh5y5sw60lsvolKUyz
         TKiOsbUOO+EJ8zwVcFaLI2LG8rtXFf05ngCkbD7EHYNtr6kA1lpd8vabFci2Kjlk1B
         h7/urDfCnpIRT6Us0eRAqO9jMcpXb3MM8nkjFQ97iuQiynXhr+S86hXTzNstqmPTJE
         wR7pZKdVPmhhuGZ9Uk3VQLzdhRLDm+tdYUIKn84OFKUY9gxeY67kagOEWBHt/yTjFZ
         aBuyKkkZE/dLyECoccMc4+MnLX8hXFT/OneH0U0B5lwQL8DU2xxnnOGALIAH1AF3Se
         I6E41Zfxf/eew==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        jacob.e.keller@intel.com, jiri@resnulli.us,
        Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>
Subject: [PATCH net-next 2/9] devlink: update the code in netns move to latest helpers
Date:   Thu,  5 Jan 2023 22:33:55 -0800
Message-Id: <20230106063402.485336-3-kuba@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230106063402.485336-1-kuba@kernel.org>
References: <20230106063402.485336-1-kuba@kernel.org>
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

Reviewed-by: Jiri Pirko <jiri@nvidia.com>
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

