Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79E5C641D67
	for <lists+netdev@lfdr.de>; Sun,  4 Dec 2022 15:17:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230164AbiLDORm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Dec 2022 09:17:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230142AbiLDOR2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Dec 2022 09:17:28 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2065.outbound.protection.outlook.com [40.107.223.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84A1C178B8
        for <netdev@vger.kernel.org>; Sun,  4 Dec 2022 06:17:16 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JDWGdcusc8JFgZbUNK5B75jjkKnzxXohdtQfpgsCujTRzzaPR7Gu9WHpnTFcml1+19YoKcbZJdaHvsVBI6eHZ0Snb1GLdHUZUQ6oEp/OAg2ogcMxkuGPdsST4hqOL9CyYl7Rn95zNdrDrZ/bGVbaC+ZCfe6AQ77p4UExKsctFsvQnX5US1Mv82+qDBJHbteX/7JBCxqLg15pUNxs3JDOW0H1WY0Dei1RY8gN+bD2jy9ICbQA7I2uLHISYfit6S7Ar7Ss4gqh9ZU+YKOVr/8ItXXAtzuIevJgi4msd8dtl/6yD7evUdAKKJG0e00gQKcsA+rGCY98pe9MGWmSaAPoLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cklU5gEz7jWwCwHiUYw/s1wXGXpvEgzGozGPJEn7yto=;
 b=oa3dabDLwerRr3nfeEjjg/Joo+1/c5FbiU7pthm7xebFjy05KU3LDOwj9TEzULo9dCp9eC3c2olq3R85n2JQnVVPR8EBvkIUeVcghG/SVwxIiiXge9FQAEj8NP1UEUVI9YUcY9la4nXzn3TJV9yo+U1ZVvZqfrZAuAY53g4c3TpABiwkudZOMGWeA6UAgkAmyAC3LQAFIdBTLuE9zEuc+LO89f9uSLIl2jvq4j9np0ebfsoP+p1IHK1EKaISHMJWcOxEOEbkKUezcOyQPxzVm+mpO67H+n/6UvqVF6Z6MAyIbFAIFkuw47oRq1NwkY7nN1NaeLidC0xK7g8JvNnTyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cklU5gEz7jWwCwHiUYw/s1wXGXpvEgzGozGPJEn7yto=;
 b=QXLEeXRhO3q6f17oXbSnmgfi/xnfKcza9KjxuTYHgTcNtYRAwAlCjADt5Zh18gOst0DS9YM58tgnj4C/aG0GHg1TC1yD7MaBOoAaGlgIFjW6ls1xnR4UM28R8gn/UhLxgjgtSaPuGPB5pfDF3cP/CNwMhgoSb6DR8onfZN9JBRlX56vCfWFO4EihuG9CEo8PptqEcbmDKHsfldzaqpWg38itaQReY2n0eqcdFgafq+vWoJuYFR2gYYJsaeOFLqWCor5uJzD9/OqG1eZmWEWT2J9eapCvOumep2pQyqqD2D4ZVdZE3tFHjb6yK6uOlEZGxBc6t7XHDYPgQkZA7O8KkA==
Received: from MW4PR03CA0356.namprd03.prod.outlook.com (2603:10b6:303:dc::31)
 by DS7PR12MB6168.namprd12.prod.outlook.com (2603:10b6:8:97::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.13; Sun, 4 Dec 2022 14:17:14 +0000
Received: from CO1NAM11FT016.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:dc:cafe::6) by MW4PR03CA0356.outlook.office365.com
 (2603:10b6:303:dc::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.13 via Frontend
 Transport; Sun, 4 Dec 2022 14:17:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CO1NAM11FT016.mail.protection.outlook.com (10.13.175.141) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.13 via Frontend Transport; Sun, 4 Dec 2022 14:17:14 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Sun, 4 Dec 2022
 06:17:00 -0800
Received: from nps-server-23.mtl.labs.mlnx (10.126.231.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Sun, 4 Dec 2022 06:16:58 -0800
From:   Shay Drory <shayd@nvidia.com>
To:     <netdev@vger.kernel.org>, <kuba@kernel.org>, <davem@davemloft.net>
CC:     <danielj@nvidia.com>, <yishaih@nvidia.com>, <jiri@nvidia.com>,
        <saeedm@nvidia.com>, <parav@nvidia.com>,
        Shay Drory <shayd@nvidia.com>
Subject: [PATCH net-next V3 6/8] net/mlx5: E-Switch, Implement devlink port function cmds to control RoCE
Date:   Sun, 4 Dec 2022 16:16:30 +0200
Message-ID: <20221204141632.201932-7-shayd@nvidia.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221204141632.201932-1-shayd@nvidia.com>
References: <20221204141632.201932-1-shayd@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT016:EE_|DS7PR12MB6168:EE_
X-MS-Office365-Filtering-Correlation-Id: 54bc4b83-1998-459f-1830-08dad6023e07
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2b6uN3XLrADSw2FCplPnDM+VXx9NRK0s6kStGmn6gZlLzSSgf3Z4bJau0TJZ3uLwDlQYzw994A2U2CeqzbnxU4lobZ3oa+u87Ox9Mz0lVMW1yCOdkZyGn2mi/xabuqU3tulhcVRSyJc48Qrm3LdEpaYIdKHLmZOjeHEEhNRgM4su54eDsdl9ep50tt1XBihDDnmvdMx/2YYtKbUw5W/imNPB8Au8z1onGH8/a83zH8pF1zQwNL6WsciLhtEqBtYsisNxhtZ05MCKJJsXF/l8G+hei6/W8RatpzS8PW3lFzBODt6K7KHUu3Pm3g2cJdI8IiYwkOYwAMfSbQ6tqnBFsecqD8+Y5hiFsHMCZ00hOIh78WUR05yxnGfMGf+b52puzRT299iXANdL/rSrCrWi0Wu53OP8wDz5DZ6ZsEGQLtJbhUNGo5SsPZETj6oPF5lWQdDf5pnhy/QBFIfdCuME3hT/YkqH9rYKhHThybH8lkMi1/Qade0uyukRk8cfCjcZEtMa0K5oJ8+9gazGcc9WeOZFiisi+dY9gP6qbDKkeRxSvYDKDDCR4SkqlIAMsrtdSyUwGWAfKgu4257WuU9vRXK31cSEL+PSnwgyErLcjFS8dzlXRojGPF9djXqrTKV8DehlVBvJFPIHCu7jbAfgY5+nJt4Ez/dRLqy00lh3J1sOO7CM24rto1gdhESTX4Hx6VSgwFqTVUcup8zZmUKpyQ==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(396003)(376002)(346002)(136003)(39860400002)(451199015)(40470700004)(36840700001)(46966006)(336012)(30864003)(16526019)(86362001)(186003)(8936002)(47076005)(426003)(5660300002)(36756003)(316002)(40460700003)(110136005)(54906003)(26005)(2616005)(1076003)(41300700001)(70206006)(70586007)(40480700001)(8676002)(4326008)(36860700001)(6666004)(107886003)(2906002)(478600001)(82310400005)(83380400001)(7636003)(356005)(82740400003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2022 14:17:14.3715
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 54bc4b83-1998-459f-1830-08dad6023e07
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT016.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6168
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yishai Hadas <yishaih@nvidia.com>

Implement devlink port function commands to enable / disable RoCE.
This is used to control the RoCE device capabilities.

This patch implement infrastructure which will be used by downstream
patches that will add additional capabilities.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
Signed-off-by: Daniel Jurgens <danielj@nvidia.com>
Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Acked-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../device_drivers/ethernet/mellanox/mlx5.rst |  10 ++
 .../net/ethernet/mellanox/mlx5/core/devlink.c |   2 +
 .../net/ethernet/mellanox/mlx5/core/eswitch.c |  35 ++++++
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |   6 +-
 .../mellanox/mlx5/core/eswitch_offloads.c     | 108 ++++++++++++++++++
 .../ethernet/mellanox/mlx5/core/mlx5_core.h   |   2 +
 .../net/ethernet/mellanox/mlx5/core/vport.c   |  24 ++++
 7 files changed, 186 insertions(+), 1 deletion(-)

diff --git a/Documentation/networking/device_drivers/ethernet/mellanox/mlx5.rst b/Documentation/networking/device_drivers/ethernet/mellanox/mlx5.rst
index 07cfc1b07db3..8b8f95d1293a 100644
--- a/Documentation/networking/device_drivers/ethernet/mellanox/mlx5.rst
+++ b/Documentation/networking/device_drivers/ethernet/mellanox/mlx5.rst
@@ -354,6 +354,16 @@ MAC address setup
 mlx5 driver support devlink port function attr mechanism to setup MAC
 address. (refer to Documentation/networking/devlink/devlink-port.rst)
 
+RoCE capability setup
+---------------------
+Not all mlx5 PCI devices/SFs require RoCE capability.
+
+When RoCE capability is disabled, it saves 1 Mbytes worth of system memory per
+PCI devices/SF.
+
+mlx5 driver support devlink port function attr mechanism to setup RoCE
+capability. (refer to Documentation/networking/devlink/devlink-port.rst)
+
 SF state setup
 --------------
 To use the SF, the user must activate the SF using the SF function state
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index 751bc4a9edcf..992cdb3b7cc8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -314,6 +314,8 @@ static const struct devlink_ops mlx5_devlink_ops = {
 	.rate_node_new = mlx5_esw_devlink_rate_node_new,
 	.rate_node_del = mlx5_esw_devlink_rate_node_del,
 	.rate_leaf_parent_set = mlx5_esw_devlink_rate_parent_set,
+	.port_function_roce_get = mlx5_devlink_port_function_roce_get,
+	.port_function_roce_set = mlx5_devlink_port_function_roce_set,
 #endif
 #ifdef CONFIG_MLX5_SF_MANAGER
 	.port_new = mlx5_devlink_sf_port_new,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index 374e3fbdc2cf..001fb1e62135 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -772,6 +772,33 @@ static void esw_vport_cleanup_acl(struct mlx5_eswitch *esw,
 		esw_vport_destroy_offloads_acl_tables(esw, vport);
 }
 
+static int mlx5_esw_vport_caps_get(struct mlx5_eswitch *esw, struct mlx5_vport *vport)
+{
+	int query_out_sz = MLX5_ST_SZ_BYTES(query_hca_cap_out);
+	void *query_ctx;
+	void *hca_caps;
+	int err;
+
+	if (!MLX5_CAP_GEN(esw->dev, vhca_resource_manager))
+		return 0;
+
+	query_ctx = kzalloc(query_out_sz, GFP_KERNEL);
+	if (!query_ctx)
+		return -ENOMEM;
+
+	err = mlx5_vport_get_other_func_cap(esw->dev, vport->vport, query_ctx,
+					    MLX5_CAP_GENERAL);
+	if (err)
+		goto out_free;
+
+	hca_caps = MLX5_ADDR_OF(query_hca_cap_out, query_ctx, capability);
+	vport->info.roce_enabled = MLX5_GET(cmd_hca_cap, hca_caps, roce);
+
+out_free:
+	kfree(query_ctx);
+	return err;
+}
+
 static int esw_vport_setup(struct mlx5_eswitch *esw, struct mlx5_vport *vport)
 {
 	u16 vport_num = vport->vport;
@@ -785,6 +812,10 @@ static int esw_vport_setup(struct mlx5_eswitch *esw, struct mlx5_vport *vport)
 	if (mlx5_esw_is_manager_vport(esw, vport_num))
 		return 0;
 
+	err = mlx5_esw_vport_caps_get(esw, vport);
+	if (err)
+		goto err_caps;
+
 	mlx5_modify_vport_admin_state(esw->dev,
 				      MLX5_VPORT_STATE_OP_MOD_ESW_VPORT,
 				      vport_num, 1,
@@ -804,6 +835,10 @@ static int esw_vport_setup(struct mlx5_eswitch *esw, struct mlx5_vport *vport)
 			       vport->info.qos, flags);
 
 	return 0;
+
+err_caps:
+	esw_vport_cleanup_acl(esw, vport);
+	return err;
 }
 
 /* Don't cleanup vport->info, it's needed to restore vport configuration */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index 42d9df417e20..71f27fb35c49 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -153,6 +153,7 @@ struct mlx5_vport_info {
 	u8                      qos;
 	u8                      spoofchk: 1;
 	u8                      trusted: 1;
+	u8                      roce_enabled: 1;
 };
 
 /* Vport context events */
@@ -508,7 +509,10 @@ int mlx5_devlink_port_function_hw_addr_get(struct devlink_port *port,
 int mlx5_devlink_port_function_hw_addr_set(struct devlink_port *port,
 					   const u8 *hw_addr, int hw_addr_len,
 					   struct netlink_ext_ack *extack);
-
+int mlx5_devlink_port_function_roce_get(struct devlink_port *port, bool *is_enabled,
+					struct netlink_ext_ack *extack);
+int mlx5_devlink_port_function_roce_set(struct devlink_port *port, bool enable,
+					struct netlink_ext_ack *extack);
 void *mlx5_eswitch_get_uplink_priv(struct mlx5_eswitch *esw, u8 rep_type);
 
 int mlx5_eswitch_add_vlan_action(struct mlx5_eswitch *esw,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 33dffcb8bdd7..f258fd7e27a8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -4022,3 +4022,111 @@ int mlx5_devlink_port_function_hw_addr_set(struct devlink_port *port,
 
 	return mlx5_eswitch_set_vport_mac(esw, vport_num, hw_addr);
 }
+
+static struct mlx5_vport *
+mlx5_devlink_port_function_get_vport(struct devlink_port *port, struct mlx5_eswitch *esw)
+{
+	u16 vport_num;
+
+	if (!MLX5_CAP_GEN(esw->dev, vhca_resource_manager))
+		return ERR_PTR(-EOPNOTSUPP);
+
+	vport_num = mlx5_esw_devlink_port_index_to_vport_num(port->index);
+	if (!is_port_function_supported(esw, vport_num))
+		return ERR_PTR(-EOPNOTSUPP);
+
+	return mlx5_eswitch_get_vport(esw, vport_num);
+}
+
+int mlx5_devlink_port_function_roce_get(struct devlink_port *port, bool *is_enabled,
+					struct netlink_ext_ack *extack)
+{
+	struct mlx5_eswitch *esw;
+	struct mlx5_vport *vport;
+	int err = -EOPNOTSUPP;
+
+	esw = mlx5_devlink_eswitch_get(port->devlink);
+	if (IS_ERR(esw))
+		return PTR_ERR(esw);
+
+	vport = mlx5_devlink_port_function_get_vport(port, esw);
+	if (IS_ERR(vport)) {
+		NL_SET_ERR_MSG_MOD(extack, "Invalid port");
+		return PTR_ERR(vport);
+	}
+
+	mutex_lock(&esw->state_lock);
+	if (vport->enabled) {
+		*is_enabled = vport->info.roce_enabled;
+		err = 0;
+	}
+	mutex_unlock(&esw->state_lock);
+	return err;
+}
+
+int mlx5_devlink_port_function_roce_set(struct devlink_port *port, bool enable,
+					struct netlink_ext_ack *extack)
+{
+	int query_out_sz = MLX5_ST_SZ_BYTES(query_hca_cap_out);
+	struct mlx5_eswitch *esw;
+	struct mlx5_vport *vport;
+	int err = -EOPNOTSUPP;
+	void *query_ctx;
+	void *hca_caps;
+	u16 vport_num;
+
+	esw = mlx5_devlink_eswitch_get(port->devlink);
+	if (IS_ERR(esw))
+		return PTR_ERR(esw);
+
+	vport = mlx5_devlink_port_function_get_vport(port, esw);
+	if (IS_ERR(vport)) {
+		NL_SET_ERR_MSG_MOD(extack, "Invalid port");
+		return PTR_ERR(vport);
+	}
+	vport_num = vport->vport;
+
+	mutex_lock(&esw->state_lock);
+	if (!vport->enabled) {
+		NL_SET_ERR_MSG_MOD(extack, "Eswitch vport is disabled");
+		goto out;
+	}
+
+	if (vport->info.roce_enabled == enable) {
+		err = 0;
+		goto out;
+	}
+
+	query_ctx = kzalloc(query_out_sz, GFP_KERNEL);
+	if (!query_ctx) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	err = mlx5_vport_get_other_func_cap(esw->dev, vport_num, query_ctx,
+					    MLX5_CAP_GENERAL);
+	if (err) {
+		NL_SET_ERR_MSG_MOD(extack, "Failed getting HCA caps");
+		goto out_free;
+	}
+
+	hca_caps = MLX5_ADDR_OF(query_hca_cap_out, query_ctx, capability);
+	memcpy(hca_caps, MLX5_ADDR_OF(query_hca_cap_out, query_ctx, capability),
+	       MLX5_UN_SZ_BYTES(hca_cap_union));
+	MLX5_SET(cmd_hca_cap, hca_caps, roce, enable);
+
+	err = mlx5_vport_set_other_func_cap(esw->dev, hca_caps, vport_num,
+					    MLX5_SET_HCA_CAP_OP_MOD_GENERAL_DEVICE);
+	if (err) {
+		NL_SET_ERR_MSG_MOD(extack, "Failed setting HCA roce cap");
+		goto out_free;
+	}
+
+	vport->info.roce_enabled = enable;
+
+out_free:
+	kfree(query_ctx);
+out:
+	mutex_unlock(&esw->state_lock);
+	return err;
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
index 09473983778f..029305a8b80a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
@@ -324,6 +324,8 @@ void mlx5_unload_one_devl_locked(struct mlx5_core_dev *dev);
 int mlx5_load_one(struct mlx5_core_dev *dev, bool recovery);
 int mlx5_load_one_devl_locked(struct mlx5_core_dev *dev, bool recovery);
 
+int mlx5_vport_set_other_func_cap(struct mlx5_core_dev *dev, const void *hca_cap, u16 function_id,
+				  u16 opmod);
 #define mlx5_vport_get_other_func_general_cap(dev, fid, out)		\
 	mlx5_vport_get_other_func_cap(dev, fid, out, MLX5_CAP_GENERAL)
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/vport.c b/drivers/net/ethernet/mellanox/mlx5/core/vport.c
index 7eca7582f243..ba7e3df22413 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/vport.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/vport.c
@@ -1173,3 +1173,27 @@ int mlx5_vport_get_other_func_cap(struct mlx5_core_dev *dev, u16 function_id, vo
 	return mlx5_cmd_exec_inout(dev, query_hca_cap, in, out);
 }
 EXPORT_SYMBOL_GPL(mlx5_vport_get_other_func_cap);
+
+int mlx5_vport_set_other_func_cap(struct mlx5_core_dev *dev, const void *hca_cap,
+				  u16 function_id, u16 opmod)
+{
+	int set_sz = MLX5_ST_SZ_BYTES(set_hca_cap_in);
+	void *set_hca_cap;
+	void *set_ctx;
+	int ret;
+
+	set_ctx = kzalloc(set_sz, GFP_KERNEL);
+	if (!set_ctx)
+		return -ENOMEM;
+
+	MLX5_SET(set_hca_cap_in, set_ctx, opcode, MLX5_CMD_OP_SET_HCA_CAP);
+	MLX5_SET(set_hca_cap_in, set_ctx, op_mod, opmod << 1);
+	set_hca_cap = MLX5_ADDR_OF(set_hca_cap_in, set_ctx, capability);
+	memcpy(set_hca_cap, hca_cap, MLX5_ST_SZ_BYTES(cmd_hca_cap));
+	MLX5_SET(set_hca_cap_in, set_ctx, function_id, function_id);
+	MLX5_SET(set_hca_cap_in, set_ctx, other_function, true);
+	ret = mlx5_cmd_exec_in(dev, set_hca_cap, set_ctx);
+
+	kfree(set_ctx);
+	return ret;
+}
-- 
2.38.1

