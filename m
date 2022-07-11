Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F173E56D787
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 10:14:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229848AbiGKIOp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 04:14:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229810AbiGKIOa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 04:14:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC9D51D31E
        for <netdev@vger.kernel.org>; Mon, 11 Jul 2022 01:14:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7E882B80E47
        for <netdev@vger.kernel.org>; Mon, 11 Jul 2022 08:14:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2639AC341CD;
        Mon, 11 Jul 2022 08:14:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657527261;
        bh=F8iWjOdTb/DWE3YB4pXgL3p5V9HA8xDl0K5JrdZqOCk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KFxXH+HpFvqFu1Iu5Z+iRzbibQm6/wzWgMkX6sr2HW6EIkpR6bHv/xKBXyNIC4Ibl
         5LYc1/I6ubHoHEnpifxSbd6GVkjdzWrPMZevzQGrCjhuYysNphywTgFweWLbu5cO4t
         cYYJKMo2AXmTio/UTec0xkx/1LauebmrvCLFbUgM3ltsKb9CXTP7eEF+G8AN8vcQHT
         Ci/Z4yPp2+6rXmIwvxlQ+V7FwO6fw/qk0VeeeZman0oc6ugA4YHpTvHob6aCwUYRXF
         TmNP3oFIfMpojqo4BCi7njLC5YnU7SbavdxBNWP1wegyK8wMxr6yWQZActm+qpAmf7
         eecPVXyD+2dVw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Moshe Shemesh <moshe@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>
Subject: [PATCH net-next 9/9] devlink: Hold the instance lock in port_new / port_del callbacks
Date:   Mon, 11 Jul 2022 01:14:08 -0700
Message-Id: <20220711081408.69452-10-saeed@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220711081408.69452-1-saeed@kernel.org>
References: <20220711081408.69452-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Moshe Shemesh <moshe@nvidia.com>

Let the core take the devlink instance lock around port_new and port_del
callbacks and remove the now redundant locking in the only driver that
currently use them.

Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c | 4 ----
 net/core/devlink.c                                   | 6 +-----
 2 files changed, 1 insertion(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c
index 2068c22ff367..7d955a4d9f14 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c
@@ -355,9 +355,7 @@ int mlx5_devlink_sf_port_new(struct devlink *devlink,
 				   "Port add is only supported in eswitch switchdev mode or SF ports are disabled.");
 		return -EOPNOTSUPP;
 	}
-	devl_lock(devlink);
 	err = mlx5_sf_add(dev, table, new_attr, extack, new_port_index);
-	devl_unlock(devlink);
 	mlx5_sf_table_put(table);
 	return err;
 }
@@ -402,9 +400,7 @@ int mlx5_devlink_sf_port_del(struct devlink *devlink, unsigned int port_index,
 		goto sf_err;
 	}
 
-	devl_lock(devlink);
 	mlx5_esw_offloads_sf_vport_disable(esw, sf->hw_fn_id);
-	devl_unlock(devlink);
 	mlx5_sf_id_erase(table, sf);
 
 	mutex_lock(&table->sf_state_lock);
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 970e5c2a52bd..e206cc90bec5 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -1712,7 +1712,7 @@ static int devlink_port_new_notifiy(struct devlink *devlink,
 	if (!msg)
 		return -ENOMEM;
 
-	mutex_lock(&devlink->lock);
+	lockdep_assert_held(&devlink->lock);
 	devlink_port = devlink_port_get_by_index(devlink, port_index);
 	if (!devlink_port) {
 		err = -ENODEV;
@@ -1725,11 +1725,9 @@ static int devlink_port_new_notifiy(struct devlink *devlink,
 		goto out;
 
 	err = genlmsg_reply(msg, info);
-	mutex_unlock(&devlink->lock);
 	return err;
 
 out:
-	mutex_unlock(&devlink->lock);
 	nlmsg_free(msg);
 	return err;
 }
@@ -9067,13 +9065,11 @@ static const struct genl_small_ops devlink_nl_ops[] = {
 		.cmd = DEVLINK_CMD_PORT_NEW,
 		.doit = devlink_nl_cmd_port_new_doit,
 		.flags = GENL_ADMIN_PERM,
-		.internal_flags = DEVLINK_NL_FLAG_NO_LOCK,
 	},
 	{
 		.cmd = DEVLINK_CMD_PORT_DEL,
 		.doit = devlink_nl_cmd_port_del_doit,
 		.flags = GENL_ADMIN_PERM,
-		.internal_flags = DEVLINK_NL_FLAG_NO_LOCK,
 	},
 	{
 		.cmd = DEVLINK_CMD_LINECARD_GET,
-- 
2.36.1

