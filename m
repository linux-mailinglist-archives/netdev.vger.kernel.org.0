Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D686F64F6C2
	for <lists+netdev@lfdr.de>; Sat, 17 Dec 2022 02:20:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229658AbiLQBU3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Dec 2022 20:20:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230025AbiLQBUP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Dec 2022 20:20:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32332680B0
        for <netdev@vger.kernel.org>; Fri, 16 Dec 2022 17:20:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C117662300
        for <netdev@vger.kernel.org>; Sat, 17 Dec 2022 01:20:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C86EC43392;
        Sat, 17 Dec 2022 01:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671240012;
        bh=43nzMgfcijWDtcSwA9riazP+5X4AeA0zGjVXyM9fSDA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hnssZoq7pNi/yHFBR3VWkU7y2/MkZe+Acy8IfvetaqjJu0UaaDG6wytk2PQfUhbtI
         y1SxCeNhsTCBghBSf7taOhvM1eZZXsGfoQ+gFOhGKoJvkjUYpOdksk6d6YMg3EzYR6
         smijWmoslqrIZ3VmKrcrDNNzwDawuNnE9Xv2mYXOaLRpMW5FO1wLMMXr5mhRBzPu+j
         Pv9r42RZkk3fRXA3FrEAAU40Rqo/g3qfK2NPSH+ox0TC294/5/km89gR24lkjfJUBX
         wmSYT+H1TXlw8VR61leUEF0lFtbIakljksLWYyhJ2cKLNJ7H+aqukwFUFiQU7gtb+W
         o8uYobsPpPCCQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     jiri@resnulli.us, jacob.e.keller@intel.com, leon@kernel.org
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [RFC net-next 10/10] netdevsim: register devlink instance before sub-objects
Date:   Fri, 16 Dec 2022 17:19:53 -0800
Message-Id: <20221217011953.152487-11-kuba@kernel.org>
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

Move the devlink instance registration up so that all the sub-object
manipulation happens on a valid instance.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/netdevsim/dev.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index c9952a34c39a..738784fda117 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -1556,23 +1556,23 @@ int nsim_drv_probe(struct nsim_bus_dev *nsim_bus_dev)
 		goto err_devlink_unlock;
 	}
 
-	err = nsim_dev_resources_register(devlink);
+	err = devl_register(devlink);
 	if (err)
 		goto err_vfc_free;
 
+	err = nsim_dev_resources_register(devlink);
+	if (err)
+		goto err_dl_unregister;
+
 	err = devlink_params_register(devlink, nsim_devlink_params,
 				      ARRAY_SIZE(nsim_devlink_params));
 	if (err)
 		goto err_resource_unregister;
 	nsim_devlink_set_params_init_values(nsim_dev, devlink);
 
-	err = devl_register(devlink);
-	if (err)
-		goto err_params_unregister;
-
 	err = nsim_dev_dummy_region_init(nsim_dev, devlink);
 	if (err)
-		goto err_dl_unregister;
+		goto err_params_unregister;
 
 	err = nsim_dev_traps_init(devlink);
 	if (err)
@@ -1629,13 +1629,13 @@ int nsim_drv_probe(struct nsim_bus_dev *nsim_bus_dev)
 	nsim_dev_traps_exit(devlink);
 err_dummy_region_exit:
 	nsim_dev_dummy_region_exit(nsim_dev);
-err_dl_unregister:
-	devl_unregister(devlink);
 err_params_unregister:
 	devlink_params_unregister(devlink, nsim_devlink_params,
 				  ARRAY_SIZE(nsim_devlink_params));
 err_resource_unregister:
 	devl_resources_unregister(devlink);
+err_dl_unregister:
+	devl_unregister(devlink);
 err_vfc_free:
 	kfree(nsim_dev->vfconfigs);
 err_devlink_unlock:
@@ -1678,10 +1678,10 @@ void nsim_drv_remove(struct nsim_bus_dev *nsim_bus_dev)
 
 	nsim_bpf_dev_exit(nsim_dev);
 	nsim_dev_debugfs_exit(nsim_dev);
-	devl_unregister(devlink);
 	devlink_params_unregister(devlink, nsim_devlink_params,
 				  ARRAY_SIZE(nsim_devlink_params));
 	devl_resources_unregister(devlink);
+	devl_unregister(devlink);
 	kfree(nsim_dev->vfconfigs);
 	kfree(nsim_dev->fa_cookie);
 	devl_unlock(devlink);
-- 
2.38.1

