Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49C314D9448
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 07:00:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345081AbiCOGBf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 02:01:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345072AbiCOGBc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 02:01:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB03249F2B
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 23:00:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7688A612D5
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 06:00:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 826C8C36AE7;
        Tue, 15 Mar 2022 06:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647324018;
        bh=EXdpx7FwdUXc3hUaLCOnBLjKNrKEj0hZdFACko/kKes=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C/MiBdavO6JnGXSBmkLhtOM/7E4PkKzVJnStxObqTY7p1LRYK9wD430yZu5FLCVLT
         xwext5vQLijwLSfWsGV/NtT3eV2ToykjliraphU8SeZm9r34LuImVXzQ7/MjIrJ0th
         gTD3COPXaA0bvsI5UFcSabt0V+X8No6Mpq71tSPP2uVmPwdt/o08b2e/QTOUmHv2bt
         u4mUzBhI4Vd6FIimbGX5Zg4uxjbQco6BvLoHV3EdMh8AP40f7HGZGdUDBd/I5RGyBS
         Y7Qc2zCkw3RKFiBKs0BCKVV0qpHxM4bjib4J54KUilhKqrfxMonAsIWzUZ5vU5khic
         QKsX1EOjqDfow==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, jiri@nvidia.com, idosch@nvidia.com,
        petrm@nvidia.com, simon.horman@corigine.com,
        louis.peens@corigine.com, leon@kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 6/6] devlink: pass devlink_port to port_split / port_unsplit callbacks
Date:   Mon, 14 Mar 2022 23:00:09 -0700
Message-Id: <20220315060009.1028519-7-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220315060009.1028519-1-kuba@kernel.org>
References: <20220315060009.1028519-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that devlink ports are protected by the instance lock
it seems natural to pass devlink_port as an argument to
the port_split / port_unsplit callbacks.

This should save the drivers from doing a lookup.

In theory drivers may have supported unsplitting ports
which were not registered prior to this change.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/mellanox/mlxsw/core.c    | 32 ++++++-------
 .../net/ethernet/netronome/nfp/nfp_devlink.c  | 15 +++---
 drivers/net/ethernet/netronome/nfp/nfp_port.c | 18 -------
 drivers/net/ethernet/netronome/nfp/nfp_port.h |  2 -
 include/net/devlink.h                         |  4 +-
 net/core/devlink.c                            | 47 +++++--------------
 6 files changed, 35 insertions(+), 83 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index e2a6a759eb6c..b13e0f8d232a 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -1217,36 +1217,37 @@ static void mlxsw_core_fw_params_unregister(struct mlxsw_core *mlxsw_core)
 				  ARRAY_SIZE(mlxsw_core_fw_devlink_params));
 }
 
+static void *__dl_port(struct devlink_port *devlink_port)
+{
+	return container_of(devlink_port, struct mlxsw_core_port, devlink_port);
+}
+
 static int mlxsw_devlink_port_split(struct devlink *devlink,
-				    unsigned int port_index,
+				    struct devlink_port *port,
 				    unsigned int count,
 				    struct netlink_ext_ack *extack)
 {
+	struct mlxsw_core_port *mlxsw_core_port = __dl_port(port);
 	struct mlxsw_core *mlxsw_core = devlink_priv(devlink);
 
-	if (port_index >= mlxsw_core->max_ports) {
-		NL_SET_ERR_MSG_MOD(extack, "Port index exceeds maximum number of ports");
-		return -EINVAL;
-	}
 	if (!mlxsw_core->driver->port_split)
 		return -EOPNOTSUPP;
-	return mlxsw_core->driver->port_split(mlxsw_core, port_index, count,
-					      extack);
+	return mlxsw_core->driver->port_split(mlxsw_core,
+					      mlxsw_core_port->local_port,
+					      count, extack);
 }
 
 static int mlxsw_devlink_port_unsplit(struct devlink *devlink,
-				      unsigned int port_index,
+				      struct devlink_port *port,
 				      struct netlink_ext_ack *extack)
 {
+	struct mlxsw_core_port *mlxsw_core_port = __dl_port(port);
 	struct mlxsw_core *mlxsw_core = devlink_priv(devlink);
 
-	if (port_index >= mlxsw_core->max_ports) {
-		NL_SET_ERR_MSG_MOD(extack, "Port index exceeds maximum number of ports");
-		return -EINVAL;
-	}
 	if (!mlxsw_core->driver->port_unsplit)
 		return -EOPNOTSUPP;
-	return mlxsw_core->driver->port_unsplit(mlxsw_core, port_index,
+	return mlxsw_core->driver->port_unsplit(mlxsw_core,
+						mlxsw_core_port->local_port,
 						extack);
 }
 
@@ -1280,11 +1281,6 @@ mlxsw_devlink_sb_pool_set(struct devlink *devlink,
 					 extack);
 }
 
-static void *__dl_port(struct devlink_port *devlink_port)
-{
-	return container_of(devlink_port, struct mlxsw_core_port, devlink_port);
-}
-
 static int mlxsw_devlink_port_type_set(struct devlink_port *devlink_port,
 				       enum devlink_port_type port_type)
 {
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_devlink.c b/drivers/net/ethernet/netronome/nfp/nfp_devlink.c
index 6bd6f4a67c30..48b95566b52b 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_devlink.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_devlink.c
@@ -26,12 +26,11 @@ nfp_devlink_fill_eth_port(struct nfp_port *port,
 }
 
 static int
-nfp_devlink_fill_eth_port_from_id(struct nfp_pf *pf, unsigned int port_index,
+nfp_devlink_fill_eth_port_from_id(struct nfp_pf *pf,
+				  struct devlink_port *dl_port,
 				  struct nfp_eth_table_port *copy)
 {
-	struct nfp_port *port;
-
-	port = nfp_port_from_id(pf, NFP_PORT_PHYS_PORT, port_index);
+	struct nfp_port *port = container_of(dl_port, struct nfp_port, dl_port);
 
 	return nfp_devlink_fill_eth_port(port, copy);
 }
@@ -62,7 +61,7 @@ nfp_devlink_set_lanes(struct nfp_pf *pf, unsigned int idx, unsigned int lanes)
 }
 
 static int
-nfp_devlink_port_split(struct devlink *devlink, unsigned int port_index,
+nfp_devlink_port_split(struct devlink *devlink, struct devlink_port *port,
 		       unsigned int count, struct netlink_ext_ack *extack)
 {
 	struct nfp_pf *pf = devlink_priv(devlink);
@@ -71,7 +70,7 @@ nfp_devlink_port_split(struct devlink *devlink, unsigned int port_index,
 	int ret;
 
 	rtnl_lock();
-	ret = nfp_devlink_fill_eth_port_from_id(pf, port_index, &eth_port);
+	ret = nfp_devlink_fill_eth_port_from_id(pf, port, &eth_port);
 	rtnl_unlock();
 	if (ret)
 		return ret;
@@ -88,7 +87,7 @@ nfp_devlink_port_split(struct devlink *devlink, unsigned int port_index,
 }
 
 static int
-nfp_devlink_port_unsplit(struct devlink *devlink, unsigned int port_index,
+nfp_devlink_port_unsplit(struct devlink *devlink, struct devlink_port *port,
 			 struct netlink_ext_ack *extack)
 {
 	struct nfp_pf *pf = devlink_priv(devlink);
@@ -97,7 +96,7 @@ nfp_devlink_port_unsplit(struct devlink *devlink, unsigned int port_index,
 	int ret;
 
 	rtnl_lock();
-	ret = nfp_devlink_fill_eth_port_from_id(pf, port_index, &eth_port);
+	ret = nfp_devlink_fill_eth_port_from_id(pf, port, &eth_port);
 	rtnl_unlock();
 	if (ret)
 		return ret;
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_port.c b/drivers/net/ethernet/netronome/nfp/nfp_port.c
index 236cd3c1201f..4f2308570dcf 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_port.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_port.c
@@ -75,24 +75,6 @@ int nfp_port_set_features(struct net_device *netdev, netdev_features_t features)
 	return 0;
 }
 
-struct nfp_port *
-nfp_port_from_id(struct nfp_pf *pf, enum nfp_port_type type, unsigned int id)
-{
-	struct devlink *devlink = priv_to_devlink(pf);
-	struct nfp_port *port;
-
-	devl_assert_locked(devlink);
-
-	if (type != NFP_PORT_PHYS_PORT)
-		return NULL;
-
-	list_for_each_entry(port, &pf->ports, port_list)
-		if (port->eth_id == id)
-			return port;
-
-	return NULL;
-}
-
 struct nfp_eth_table_port *__nfp_port_get_eth_port(struct nfp_port *port)
 {
 	if (!port)
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_port.h b/drivers/net/ethernet/netronome/nfp/nfp_port.h
index df316b9e891d..d1ebe6c72f7f 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_port.h
+++ b/drivers/net/ethernet/netronome/nfp/nfp_port.h
@@ -106,8 +106,6 @@ nfp_port_set_features(struct net_device *netdev, netdev_features_t features);
 struct nfp_port *nfp_port_from_netdev(struct net_device *netdev);
 int nfp_port_get_port_parent_id(struct net_device *netdev,
 				struct netdev_phys_item_id *ppid);
-struct nfp_port *
-nfp_port_from_id(struct nfp_pf *pf, enum nfp_port_type type, unsigned int id);
 struct nfp_eth_table_port *__nfp_port_get_eth_port(struct nfp_port *port);
 struct nfp_eth_table_port *nfp_port_get_eth_port(struct nfp_port *port);
 
diff --git a/include/net/devlink.h b/include/net/devlink.h
index 9de0d091aee9..fd89a17adea1 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -1197,9 +1197,9 @@ struct devlink_ops {
 			 struct netlink_ext_ack *extack);
 	int (*port_type_set)(struct devlink_port *devlink_port,
 			     enum devlink_port_type port_type);
-	int (*port_split)(struct devlink *devlink, unsigned int port_index,
+	int (*port_split)(struct devlink *devlink, struct devlink_port *port,
 			  unsigned int count, struct netlink_ext_ack *extack);
-	int (*port_unsplit)(struct devlink *devlink, unsigned int port_index,
+	int (*port_unsplit)(struct devlink *devlink, struct devlink_port *port,
 			    struct netlink_ext_ack *extack);
 	int (*sb_pool_get)(struct devlink *devlink, unsigned int sb_index,
 			   u16 pool_index,
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 545ae784e9d2..f2a277053ec6 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -1568,35 +1568,20 @@ static int devlink_nl_cmd_port_set_doit(struct sk_buff *skb,
 	return 0;
 }
 
-static int devlink_port_split(struct devlink *devlink, u32 port_index,
-			      u32 count, struct netlink_ext_ack *extack)
-
-{
-	if (devlink->ops->port_split)
-		return devlink->ops->port_split(devlink, port_index, count,
-						extack);
-	return -EOPNOTSUPP;
-}
-
 static int devlink_nl_cmd_port_split_doit(struct sk_buff *skb,
 					  struct genl_info *info)
 {
+	struct devlink_port *devlink_port = info->user_ptr[1];
 	struct devlink *devlink = info->user_ptr[0];
-	struct devlink_port *devlink_port;
-	u32 port_index;
 	u32 count;
 
-	if (!info->attrs[DEVLINK_ATTR_PORT_INDEX] ||
-	    !info->attrs[DEVLINK_ATTR_PORT_SPLIT_COUNT])
+	if (!info->attrs[DEVLINK_ATTR_PORT_SPLIT_COUNT])
 		return -EINVAL;
+	if (!devlink->ops->port_split)
+		return -EOPNOTSUPP;
 
-	devlink_port = devlink_port_get_from_info(devlink, info);
-	port_index = nla_get_u32(info->attrs[DEVLINK_ATTR_PORT_INDEX]);
 	count = nla_get_u32(info->attrs[DEVLINK_ATTR_PORT_SPLIT_COUNT]);
 
-	if (IS_ERR(devlink_port))
-		return -EINVAL;
-
 	if (!devlink_port->attrs.splittable) {
 		/* Split ports cannot be split. */
 		if (devlink_port->attrs.split)
@@ -1611,29 +1596,19 @@ static int devlink_nl_cmd_port_split_doit(struct sk_buff *skb,
 		return -EINVAL;
 	}
 
-	return devlink_port_split(devlink, port_index, count, info->extack);
-}
-
-static int devlink_port_unsplit(struct devlink *devlink, u32 port_index,
-				struct netlink_ext_ack *extack)
-
-{
-	if (devlink->ops->port_unsplit)
-		return devlink->ops->port_unsplit(devlink, port_index, extack);
-	return -EOPNOTSUPP;
+	return devlink->ops->port_split(devlink, devlink_port, count,
+					info->extack);
 }
 
 static int devlink_nl_cmd_port_unsplit_doit(struct sk_buff *skb,
 					    struct genl_info *info)
 {
+	struct devlink_port *devlink_port = info->user_ptr[1];
 	struct devlink *devlink = info->user_ptr[0];
-	u32 port_index;
 
-	if (!info->attrs[DEVLINK_ATTR_PORT_INDEX])
-		return -EINVAL;
-
-	port_index = nla_get_u32(info->attrs[DEVLINK_ATTR_PORT_INDEX]);
-	return devlink_port_unsplit(devlink, port_index, info->extack);
+	if (!devlink->ops->port_unsplit)
+		return -EOPNOTSUPP;
+	return devlink->ops->port_unsplit(devlink, devlink_port, info->extack);
 }
 
 static int devlink_port_new_notifiy(struct devlink *devlink,
@@ -8672,12 +8647,14 @@ static const struct genl_small_ops devlink_nl_ops[] = {
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = devlink_nl_cmd_port_split_doit,
 		.flags = GENL_ADMIN_PERM,
+		.internal_flags = DEVLINK_NL_FLAG_NEED_PORT,
 	},
 	{
 		.cmd = DEVLINK_CMD_PORT_UNSPLIT,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = devlink_nl_cmd_port_unsplit_doit,
 		.flags = GENL_ADMIN_PERM,
+		.internal_flags = DEVLINK_NL_FLAG_NEED_PORT,
 	},
 	{
 		.cmd = DEVLINK_CMD_PORT_NEW,
-- 
2.34.1

