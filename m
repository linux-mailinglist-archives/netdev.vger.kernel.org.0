Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBB1B64F6C1
	for <lists+netdev@lfdr.de>; Sat, 17 Dec 2022 02:20:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbiLQBU1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Dec 2022 20:20:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229995AbiLQBUN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Dec 2022 20:20:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5FB0680AE
        for <netdev@vger.kernel.org>; Fri, 16 Dec 2022 17:20:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8378862321
        for <netdev@vger.kernel.org>; Sat, 17 Dec 2022 01:20:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB3B8C433F2;
        Sat, 17 Dec 2022 01:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671240011;
        bh=Wx5x0gqV3sZMQ/k3MedwzjCB18pvUhhOQeeyFL8Wsnk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IX7dtC0Sr/uQjZkC2O3qdJmhUifWTAnCP9TgQTPG7TUrvO3uaQ98NzjcDfv9tY9q/
         uHYHhuALi5ZtQ21KkUIplGIEGGf4HHJQtrkrTIa/13iikioI6jtVGjIvTxgtJSgBA7
         SrXwvZ0wUP3sTJZuAwSgWwElpEWzvN4dMY8l1oWY3g8OTPZPQdR6NGurLiK1DxCfkQ
         8wfHrq6nkwm4PwnFz/Z7TzDfmwOtt15bKrwHONGK1fuaqHVbxWkWqbApSXkqPwnWut
         uXshbGIZ6jguUS7LE5oRH496tIr/qhfHO46C0TWwB7ONpKMMZ65XeKgyTYMUVohydu
         efHUOSfhVb9lw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     jiri@resnulli.us, jacob.e.keller@intel.com, leon@kernel.org
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [RFC net-next 08/10] netdevsim: move devlink registration under the instance lock
Date:   Fri, 16 Dec 2022 17:19:51 -0800
Message-Id: <20221217011953.152487-9-kuba@kernel.org>
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

To prevent races with netdev code accessing free devlink instances
move the registration under the devlink instance lock.
Core now waits for the instance to be registered before accessing it.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/netdevsim/dev.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index d25f6e86d901..c9952a34c39a 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -1566,10 +1566,14 @@ int nsim_drv_probe(struct nsim_bus_dev *nsim_bus_dev)
 		goto err_resource_unregister;
 	nsim_devlink_set_params_init_values(nsim_dev, devlink);
 
-	err = nsim_dev_dummy_region_init(nsim_dev, devlink);
+	err = devl_register(devlink);
 	if (err)
 		goto err_params_unregister;
 
+	err = nsim_dev_dummy_region_init(nsim_dev, devlink);
+	if (err)
+		goto err_dl_unregister;
+
 	err = nsim_dev_traps_init(devlink);
 	if (err)
 		goto err_dummy_region_exit;
@@ -1607,7 +1611,6 @@ int nsim_drv_probe(struct nsim_bus_dev *nsim_bus_dev)
 	nsim_dev->esw_mode = DEVLINK_ESWITCH_MODE_LEGACY;
 	devlink_set_features(devlink, DEVLINK_F_RELOAD);
 	devl_unlock(devlink);
-	devlink_register(devlink);
 	return 0;
 
 err_hwstats_exit:
@@ -1626,6 +1629,8 @@ int nsim_drv_probe(struct nsim_bus_dev *nsim_bus_dev)
 	nsim_dev_traps_exit(devlink);
 err_dummy_region_exit:
 	nsim_dev_dummy_region_exit(nsim_dev);
+err_dl_unregister:
+	devl_unregister(devlink);
 err_params_unregister:
 	devlink_params_unregister(devlink, nsim_devlink_params,
 				  ARRAY_SIZE(nsim_devlink_params));
@@ -1668,12 +1673,12 @@ void nsim_drv_remove(struct nsim_bus_dev *nsim_bus_dev)
 	struct nsim_dev *nsim_dev = dev_get_drvdata(&nsim_bus_dev->dev);
 	struct devlink *devlink = priv_to_devlink(nsim_dev);
 
-	devlink_unregister(devlink);
 	devl_lock(devlink);
 	nsim_dev_reload_destroy(nsim_dev);
 
 	nsim_bpf_dev_exit(nsim_dev);
 	nsim_dev_debugfs_exit(nsim_dev);
+	devl_unregister(devlink);
 	devlink_params_unregister(devlink, nsim_devlink_params,
 				  ARRAY_SIZE(nsim_devlink_params));
 	devl_resources_unregister(devlink);
-- 
2.38.1

