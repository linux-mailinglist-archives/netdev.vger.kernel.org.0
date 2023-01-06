Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CBE865FB84
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 07:34:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232017AbjAFGei (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 01:34:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231725AbjAFGeO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 01:34:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39EDA6E0DF
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 22:34:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DDAC6B81CC9
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 06:34:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05E55C43392;
        Fri,  6 Jan 2023 06:34:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672986851;
        bh=zVx9qS/HAOHmboAXijj66mM369y9T1qBJVMTJnQeMew=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VyLJbMehtM3kXUGEs9ifd79pqu+jzX3hQfwTWrZDMANHBsFbYK/hxQmCzsLfXjVFU
         1fa0P2hazI24D1Mr2TcsEveUSPK/XxdIc2UVaPPwmJ5fDaeTW9aeKDPHgqoAPoNyZV
         da3E8tU1W+/6sLYJqFQ6Wwp/izw8e7CJ08q642WA90R6l1BTdrr6zfF319C49Xju8I
         baxbgNIfWDkeHHhmTrBcOpNo8wzNC6DCsZiEhD/7AzTmagSkHCIUq23Rk9gGZdUdeY
         7Xf1REHOHHUIy+vsovtPViPAUCu44AvXp7DaKYcNDYKWB6bCmtl0XfCnNZyVEZYgq9
         PZa1ysolykyxw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        jacob.e.keller@intel.com, jiri@resnulli.us,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 9/9] netdevsim: move devlink registration under the instance lock
Date:   Thu,  5 Jan 2023 22:34:02 -0800
Message-Id: <20230106063402.485336-10-kuba@kernel.org>
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

To prevent races with netdev code accessing free devlink instances
move the registration under the devlink instance lock.
Core now waits for the instance to be registered before accessing it.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/netdevsim/dev.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index d25f6e86d901..738784fda117 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -1556,10 +1556,14 @@ int nsim_drv_probe(struct nsim_bus_dev *nsim_bus_dev)
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
@@ -1607,7 +1611,6 @@ int nsim_drv_probe(struct nsim_bus_dev *nsim_bus_dev)
 	nsim_dev->esw_mode = DEVLINK_ESWITCH_MODE_LEGACY;
 	devlink_set_features(devlink, DEVLINK_F_RELOAD);
 	devl_unlock(devlink);
-	devlink_register(devlink);
 	return 0;
 
 err_hwstats_exit:
@@ -1631,6 +1634,8 @@ int nsim_drv_probe(struct nsim_bus_dev *nsim_bus_dev)
 				  ARRAY_SIZE(nsim_devlink_params));
 err_resource_unregister:
 	devl_resources_unregister(devlink);
+err_dl_unregister:
+	devl_unregister(devlink);
 err_vfc_free:
 	kfree(nsim_dev->vfconfigs);
 err_devlink_unlock:
@@ -1668,7 +1673,6 @@ void nsim_drv_remove(struct nsim_bus_dev *nsim_bus_dev)
 	struct nsim_dev *nsim_dev = dev_get_drvdata(&nsim_bus_dev->dev);
 	struct devlink *devlink = priv_to_devlink(nsim_dev);
 
-	devlink_unregister(devlink);
 	devl_lock(devlink);
 	nsim_dev_reload_destroy(nsim_dev);
 
@@ -1677,6 +1681,7 @@ void nsim_drv_remove(struct nsim_bus_dev *nsim_bus_dev)
 	devlink_params_unregister(devlink, nsim_devlink_params,
 				  ARRAY_SIZE(nsim_devlink_params));
 	devl_resources_unregister(devlink);
+	devl_unregister(devlink);
 	kfree(nsim_dev->vfconfigs);
 	kfree(nsim_dev->fa_cookie);
 	devl_unlock(devlink);
-- 
2.38.1

