Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FEB52000D5
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 05:33:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731053AbgFSDdv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 23:33:51 -0400
Received: from mail-eopbgr70089.outbound.protection.outlook.com ([40.107.7.89]:25892
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731007AbgFSDdr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Jun 2020 23:33:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SnTDbd2zEMC91+QAaeCkAHolfq+fMKUYITOoaeoEMDwrKmO7JUp47OH0jrpLB8VdlkX1j3IjnfH9CSANLEv8EIut7HqtEniJulF+LEdG2M7To0/1JfV08qsYByEmWUrF1UefwOvCwslqRmIQft3LdqiUTrkVKNEGpyQFBcFxFiXIRwyjCB4fi0QZA63P0ZgDNkd6aN8xNnqrGKW1Ls7+aFuk95WpZ/eThbhkt7hlj9FSjby45pqd0uefkfkvRM5KASRs6KIhxbwVT0tG2GPiaBmvof0q5YEkQc6egHOubPbhrClEyBTsbF0RYxrrN3bW2O8dgRTJa1QMNiQd3drfAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Oh6LVz8msF0MDh+Y/BcFCiRCLyFc2liw5EHKJhyY0xg=;
 b=PIwpmrmiu3f5AQqwIBkY2I97qkUrqPxOokbwqrE9A8LlseXmbwcRoJMZxa3n3RbPBgzh69A3EU67RehCYw1nQNtANg8+ArfWODzdhVJQ0bRWOB6o4kMasl353pzOdrwOPcwgVrhQBKHfyXWvhmcMuTW5dvkIqrX3BWSd7rxgw6boZEai8dqdCgBwq6noIvXj/QVYfTyzK8dcjGSmOLuiSXXNNPzmVJw8mJl9fVBIMMT3KopPYeE3oweIMSusMBfEsP9f4yTyjw7lOSxuSI5eIW+KIFzL0d7U6mGuBHW4++RLUr2euExMoXtQfMBwiuKRomAP1qEd1iw7ec5wKgpxgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Oh6LVz8msF0MDh+Y/BcFCiRCLyFc2liw5EHKJhyY0xg=;
 b=fZGPj2z+TmPUNPJVY9CJR/xBJk55Q4MNJiQwv9SWkdVuc4GnYGYoejQcJU1z8HKWnTnEPjk5LjCbO3SF38KPTo7RLLkzZ9FaPMdMK/HKiLr/gQvjZuLaVJE8kmP7FIVJFK+Ct/9mb9QgVrzEX6Ait/ceVXqC1zyrwsZo5ySweB0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (2603:10a6:208:c0::32)
 by AM0PR05MB6804.eurprd05.prod.outlook.com (2603:10a6:20b:146::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.21; Fri, 19 Jun
 2020 03:33:32 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::d44d:a804:c730:d2b7]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::d44d:a804:c730:d2b7%2]) with mapi id 15.20.3109.021; Fri, 19 Jun 2020
 03:33:32 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     saeedm@mellanox.com, davem@davemloft.net, kuba@kernel.org,
        jiri@mellanox.com, Parav Pandit <parav@mellanox.com>,
        Roi Dayan <roid@mellanox.com>
Subject: [PATCH net-next 7/9] net/mlx5: E-switch, Support querying port function mac address
Date:   Fri, 19 Jun 2020 03:32:53 +0000
Message-Id: <20200619033255.163-8-parav@mellanox.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200619033255.163-1-parav@mellanox.com>
References: <20200619033255.163-1-parav@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SN4PR0401CA0019.namprd04.prod.outlook.com
 (2603:10b6:803:21::29) To AM0PR05MB4866.eurprd05.prod.outlook.com
 (2603:10a6:208:c0::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sw-mtx-036.mtx.labs.mlnx (208.176.44.194) by SN4PR0401CA0019.namprd04.prod.outlook.com (2603:10b6:803:21::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22 via Frontend Transport; Fri, 19 Jun 2020 03:33:30 +0000
X-Mailer: git-send-email 2.25.4
X-Originating-IP: [208.176.44.194]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9d7fc029-5fd6-4061-9564-08d814018a11
X-MS-TrafficTypeDiagnostic: AM0PR05MB6804:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR05MB68048AAFF4E48F3150535459D1980@AM0PR05MB6804.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:962;
X-Forefront-PRVS: 0439571D1D
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NHVSb28x5a63/uIGg9Py2xxUAZgTgKs3FFnPdfHbrc504/gJOukAbEOJ5fFR0hOWNPED+c7/EAQPLO/+SkYKg9JEMJShKP2st3rUEJLzKrHWdwSF5ZvdUdR0wnX0jNLTPjeTzIgWHSZz2Y2q+c9ffahkIvSztMZza11G2KIvewtlVPhTN6AtQnpup4sgaYit2u2FeI3ao4itZ2LJ98IYHP+/Z6jIh9hYpqTPhxSCHL5Znoukt4HNOr1oeXgLeY3Sfw5rWnQWEeJcr9oluejtRnsqSOB+0XIXEDiqit/MS7SGBbxAxfPVdd0RV+WKT47o
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR05MB4866.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(39860400002)(396003)(366004)(376002)(346002)(8676002)(2616005)(2906002)(4326008)(107886003)(6486002)(478600001)(8936002)(6512007)(5660300002)(6916009)(956004)(6666004)(26005)(66476007)(16526019)(186003)(66556008)(66946007)(83380400001)(316002)(6506007)(54906003)(86362001)(52116002)(36756003)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: wVkxLC0FeIgDzG0921lPb+Arw27do1abM67AJmG/EWt48lpLyDLXrV0yvuSoBUY5CqkZRGQlwgCKdjg+nJO6iEmtH82Eun9KZmS7Ua0ER1PIYFNlCb3pNyIyT06TTYOtxaRzXFUSdD6lYLMC+XQgvKVMaJRsjLgMLniX1xseyzKiF9Oa9ZqnwR+rlR/pst3FMxSD2JnPhzLj58kntGWs3Go4J+j+vqUcLuYOGtSV2op+CqwCHKDDL5QYA+3XY3H7v3lXCp/HtSHZlxZhjsL0pKry1mHmj8/nyuOZl9p0Z9tUfyOAQFBrIhgiT6aQS4ZN4+Xp/V98+Z7cri/8cSNVgslohsRtj9Au+NwP8N1hYuQoW7bDCB4s0LD63Orn1NT0K8Ruqx+ZB3tEW87f7GJ+ZMV+uPxqDwBmeQYhqMxJECXW3aiS4iyphwrY3w208Yi2yDeyxEFWgFkX9tYBc+XR1LmreMntncPafjUhaU+MfmAhEfHOz2PZxg5P+K6vKEox
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d7fc029-5fd6-4061-9564-08d814018a11
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2020 03:33:31.8645
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T1muRUJvBm5v0B1fIVU/aO72srYrCEVcvPAl0HLc69UEe9qjU/0MA2AKtdCaj8P+EEroVZPzMnmzTsaRtVjj8A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB6804
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Support querying mac address of the eswitch devlink port function.

Signed-off-by: Parav Pandit <parav@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/devlink.c |  1 +
 .../net/ethernet/mellanox/mlx5/core/eswitch.c | 43 +++++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/eswitch.h | 11 +++++
 3 files changed, 55 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index a99fe4b02b9b..3177d2458fa5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -113,6 +113,7 @@ static const struct devlink_ops mlx5_devlink_ops = {
 	.eswitch_inline_mode_get = mlx5_devlink_eswitch_inline_mode_get,
 	.eswitch_encap_mode_set = mlx5_devlink_eswitch_encap_mode_set,
 	.eswitch_encap_mode_get = mlx5_devlink_eswitch_encap_mode_get,
+	.port_function_hw_addr_get = mlx5_devlink_port_function_hw_addr_get,
 #endif
 	.flash_update = mlx5_devlink_flash_update,
 	.info_get = mlx5_devlink_info_get,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index 9f04fd10cb1e..999e51656e16 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1845,6 +1845,49 @@ int mlx5_eswitch_set_vport_mac(struct mlx5_eswitch *esw,
 	return err;
 }
 
+static bool
+is_port_function_supported(const struct mlx5_eswitch *esw, u16 vport_num)
+{
+	return vport_num == MLX5_VPORT_PF ||
+	       mlx5_eswitch_is_vf_vport(esw, vport_num);
+}
+
+int mlx5_devlink_port_function_hw_addr_get(struct devlink *devlink,
+					   struct devlink_port *port,
+					   u8 *hw_addr, int *hw_addr_len,
+					   struct netlink_ext_ack *extack)
+{
+	struct mlx5_eswitch *esw;
+	struct mlx5_vport *vport;
+	int err = -EOPNOTSUPP;
+	u16 vport_num;
+
+	esw = mlx5_devlink_eswitch_get(devlink);
+	if (IS_ERR(esw))
+		return PTR_ERR(esw);
+
+	vport_num = mlx5_esw_devlink_port_index_to_vport_num(port->index);
+	if (!is_port_function_supported(esw, vport_num))
+		return -EOPNOTSUPP;
+
+	vport = mlx5_eswitch_get_vport(esw, vport_num);
+	if (IS_ERR(vport)) {
+		NL_SET_ERR_MSG_MOD(extack, "Invalid port");
+		return PTR_ERR(vport);
+	}
+
+	mutex_lock(&esw->state_lock);
+	if (vport->enabled) {
+		ether_addr_copy(hw_addr, vport->info.mac);
+		*hw_addr_len = ETH_ALEN;
+		err = 0;
+	} else {
+		NL_SET_ERR_MSG_MOD(extack, "Eswitch vport is disabled");
+	}
+	mutex_unlock(&esw->state_lock);
+	return err;
+}
+
 int mlx5_eswitch_set_vport_state(struct mlx5_eswitch *esw,
 				 u16 vport, int link_state)
 {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index 8f537183e977..19cd0af7afda 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -450,6 +450,11 @@ int mlx5_devlink_eswitch_encap_mode_set(struct devlink *devlink,
 					struct netlink_ext_ack *extack);
 int mlx5_devlink_eswitch_encap_mode_get(struct devlink *devlink,
 					enum devlink_eswitch_encap_mode *encap);
+int mlx5_devlink_port_function_hw_addr_get(struct devlink *devlink,
+					   struct devlink_port *port,
+					   u8 *hw_addr, int *hw_addr_len,
+					   struct netlink_ext_ack *extack);
+
 void *mlx5_eswitch_get_uplink_priv(struct mlx5_eswitch *esw, u8 rep_type);
 
 int mlx5_eswitch_add_vlan_action(struct mlx5_eswitch *esw,
@@ -572,6 +577,12 @@ mlx5_esw_vport_to_devlink_port_index(const struct mlx5_core_dev *dev,
 	return (MLX5_CAP_GEN(dev, vhca_id) << 16) | vport_num;
 }
 
+static inline u16
+mlx5_esw_devlink_port_index_to_vport_num(unsigned int dl_port_index)
+{
+	return dl_port_index & 0xffff;
+}
+
 /* TODO: This mlx5e_tc function shouldn't be called by eswitch */
 void mlx5e_tc_clean_fdb_peer_flows(struct mlx5_eswitch *esw);
 
-- 
2.19.2

