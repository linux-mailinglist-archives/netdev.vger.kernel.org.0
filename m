Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3D251853BF
	for <lists+netdev@lfdr.de>; Sat, 14 Mar 2020 02:16:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727796AbgCNBQ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 21:16:56 -0400
Received: from mail-eopbgr50063.outbound.protection.outlook.com ([40.107.5.63]:20602
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726637AbgCNBQ4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Mar 2020 21:16:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=As+qbyV5nAIO1i1ZLj9gLQwTrXAmzsL+B+G+0hcXVoB6OOs4nh6OObvzAL9cj9OgmPzwjfy2VUTyOgXDj5w3OrbbSlgCXHm/mjoo4LyKPKg673XKoXKPfd5ad2zbFoxHJTmnqAf1AvpPesKMOT886hs6+IfDP1AWd/zgAPjidp5mVM5FNh31+nNrnuFhSY3QxTVv9vv351E1CpgQ1amCxbARZtBc3gWSMSTxwOWmcMi3VQ+Hfgd9qd5jyKKL5BvH6iGSQe+V2J2lHwLxJcHyEyQgChcdHZUeQ8FxVt2yJQpjIH1dfA5ndv4kryvLSJaB5x7j91wWxsQ7Nz+zoZqGvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QsJvbvy5QDL9d+wSJDw4CsUBllvBb+p+l8+Dq0JntuA=;
 b=ZoFhcLFDD0IdQUBv5UIFtNQEDfsoE6efxdMrOkHJK8dX5w1/VPJ20qroPcFNiY5EBpZR3agINQ6C3oppfdgKq/HqwMTBgvNomonidExzKDoubHlsiWBWtoxPpdJzuBcfOCdW9dcITJbygiy7TriKbXH+3hO49NzI6CSGqnq7NtgyMQ+Jbtbd/2/29u8oZt6YSefL5rxt2AAB+vXwQPgu9Eqr9x8ER8EvES2/rTUpB0mYJJsj3lHZ2eGLNSP41EvhFjubAF1f1+MptvxQqbkkwrjmvf9lE8EjDeq4PvExibIy/AN6FIde32bduTPultwxyVrsiz0yHgVagUf7Pi56Qg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QsJvbvy5QDL9d+wSJDw4CsUBllvBb+p+l8+Dq0JntuA=;
 b=NDHqHu38hVPWPbShwSQj2T3KJGmQJ6DOnD/Jb3Qkv8/fGPW4pm4koNVUJ8Q2mrCUoks9DJLSR3H7+MzxuIWOE3poYUp8W83YzC/goBPo1IEiaYJHiBsWtFW/mkdvCnEMtdPPXw0qMLyp36OgDyG2LWScn3Do0c1J6QCgEZSQE08=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB6845.eurprd05.prod.outlook.com (10.186.163.80) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2814.16; Sat, 14 Mar 2020 01:16:52 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2793.018; Sat, 14 Mar 2020
 01:16:52 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        Bodong Wang <bodong@mellanox.com>,
        Parav Pandit <parav@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 05/14] net/mlx5: E-switch, Make vport setup/cleanup sequence symmetric
Date:   Fri, 13 Mar 2020 18:16:13 -0700
Message-Id: <20200314011622.64939-6-saeedm@mellanox.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200314011622.64939-1-saeedm@mellanox.com>
References: <20200314011622.64939-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR03CA0005.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::15) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY5PR03CA0005.namprd03.prod.outlook.com (2603:10b6:a03:1e0::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.16 via Frontend Transport; Sat, 14 Mar 2020 01:16:50 +0000
X-Mailer: git-send-email 2.24.1
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f2ece61f-77b5-4e2d-4f25-08d7c7b560a3
X-MS-TrafficTypeDiagnostic: VI1PR05MB6845:|VI1PR05MB6845:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB6845652D766EFB25F0C09A1BBEFB0@VI1PR05MB6845.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1186;
X-Forefront-PRVS: 034215E98F
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(39860400002)(366004)(346002)(376002)(199004)(86362001)(54906003)(6506007)(52116002)(4326008)(6486002)(6512007)(107886003)(2906002)(5660300002)(478600001)(316002)(66476007)(26005)(66946007)(8936002)(66556008)(8676002)(81166006)(81156014)(2616005)(36756003)(956004)(186003)(16526019)(1076003)(6916009)(6666004)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6845;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aIh8hdN6OEcX6MAQZ9h5XJXrHiLMBuFpT8EHzRN1/8SiuT5FVbfObxgujYBN9Mu3tHnfWOn0RHbd4HZAMBophwXdPWnUgveEVm7aHb9xxiltBcjNB0vrD0wP3P7aC0j0wfcEat9+CI8lelQVpNRzIJ0BFMKHRbhwUB14z2K6kfEgonsmsacvDgnMhbEp7H6MpnbuByyEutAqMssYyt8q+CinV3y3AOaW8OQO5D4lcBHOrwN5VBnLJF01245/s8/zaSJGsD99fmF4Uiajhp7cHv7QNNCuVHM0zFD1XP6iUthTwJdZvJ6SVxVLtPEvQkLpr0EtE9h3VyZ5uDRhzLA+vx9kWrbfC6YcaY8Dp6O/WrzdSzHhp4udA7QfiMd7FA8sS/f0SmOWFCRoytsu2LGYGFvglRkK+y0LR72QlL/oltRA0HUd4irdU6t8ZExHka/mkw2J8n9J/N1EaP/5/0Xie/THs8im1Uv59olnnzr3eAch1K0/LSJQouNPJlKsTXcgjLmmI8AiQ/kHErR7DXVoaEXWwlYPC4vFdUA4ajy8rYg=
X-MS-Exchange-AntiSpam-MessageData: zM63NWxTcQK2DDT5KHhevUAbDpX0HVu2dDEWiR+zGjDNP9DviwmugiVjZwOFtNtl97n4n3hb8xJfCx2ZgLAnVkSOTKbrhDJ67jSZZhtCyNB5a/sLG8E5ekw8MY8JUw2dVOxE1tthicYS0Rq43OGUMw==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2ece61f-77b5-4e2d-4f25-08d7c7b560a3
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2020 01:16:52.5764
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 07w8dajQW15b7iwCj42+KKBjIhiYUahbNwyLNEQMVM1cnCxQdCf/IcpBv5l+/Lc6C1/9WMgGxXqfjXgKXPd/Lg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6845
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bodong Wang <bodong@mellanox.com>

Vport enable and disable sequence is incorrect. It should be:
  enable()
  esw_vport_setup_acl,
  esw_vport_setup,
  esw_vport_enable_qos.

  disable()
  esw_vport_disable_qos,
  esw_vport_cleanup,
  esw_vport_cleanup_acl.

Instead of having two setup functions for port and acl, merge
acl setup to port setup function.

Signed-off-by: Bodong Wang <bodong@mellanox.com>
Reviewed-by: Parav Pandit <parav@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/eswitch.c | 101 +++++++++---------
 1 file changed, 53 insertions(+), 48 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index 258141010b62..603286883550 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1670,45 +1670,6 @@ static void node_guid_gen_from_mac(u64 *node_guid, u8 mac[ETH_ALEN])
 	((u8 *)node_guid)[0] = mac[5];
 }
 
-static void esw_vport_setup(struct mlx5_eswitch *esw, struct mlx5_vport *vport)
-{
-	u16 vport_num = vport->vport;
-	int flags;
-
-	if (mlx5_esw_is_manager_vport(esw, vport_num))
-		return;
-
-	mlx5_modify_vport_admin_state(esw->dev,
-				      MLX5_VPORT_STATE_OP_MOD_ESW_VPORT,
-				      vport_num, 1,
-				      vport->info.link_state);
-
-	/* Host PF has its own mac/guid. */
-	if (vport_num) {
-		mlx5_modify_nic_vport_mac_address(esw->dev, vport_num,
-						  vport->info.mac);
-		mlx5_modify_nic_vport_node_guid(esw->dev, vport_num,
-						vport->info.node_guid);
-	}
-
-	flags = (vport->info.vlan || vport->info.qos) ?
-		SET_VLAN_STRIP | SET_VLAN_INSERT : 0;
-	modify_esw_vport_cvlan(esw->dev, vport_num, vport->info.vlan, vport->info.qos,
-			       flags);
-}
-
-/* Don't cleanup vport->info, it's needed to restore vport configuration */
-static void esw_vport_cleanup(struct mlx5_eswitch *esw, struct mlx5_vport *vport)
-{
-	u16 vport_num = vport->vport;
-
-	if (!mlx5_esw_is_manager_vport(esw, vport_num))
-		mlx5_modify_vport_admin_state(esw->dev,
-					      MLX5_VPORT_STATE_OP_MOD_ESW_VPORT,
-					      vport_num, 1,
-					      MLX5_VPORT_ADMIN_STATE_DOWN);
-}
-
 static int esw_vport_create_legacy_acl_tables(struct mlx5_eswitch *esw,
 					      struct mlx5_vport *vport)
 {
@@ -1793,6 +1754,58 @@ static void esw_vport_cleanup_acl(struct mlx5_eswitch *esw,
 		esw_vport_destroy_offloads_acl_tables(esw, vport);
 }
 
+static int esw_vport_setup(struct mlx5_eswitch *esw, struct mlx5_vport *vport)
+{
+	u16 vport_num = vport->vport;
+	int flags;
+	int err;
+
+	err = esw_vport_setup_acl(esw, vport);
+	if (err)
+		return err;
+
+	/* Attach vport to the eswitch rate limiter */
+	esw_vport_enable_qos(esw, vport, vport->info.max_rate, vport->qos.bw_share);
+
+	if (mlx5_esw_is_manager_vport(esw, vport_num))
+		return 0;
+
+	mlx5_modify_vport_admin_state(esw->dev,
+				      MLX5_VPORT_STATE_OP_MOD_ESW_VPORT,
+				      vport_num, 1,
+				      vport->info.link_state);
+
+	/* Host PF has its own mac/guid. */
+	if (vport_num) {
+		mlx5_modify_nic_vport_mac_address(esw->dev, vport_num,
+						  vport->info.mac);
+		mlx5_modify_nic_vport_node_guid(esw->dev, vport_num,
+						vport->info.node_guid);
+	}
+
+	flags = (vport->info.vlan || vport->info.qos) ?
+		SET_VLAN_STRIP | SET_VLAN_INSERT : 0;
+	modify_esw_vport_cvlan(esw->dev, vport_num, vport->info.vlan,
+			       vport->info.qos, flags);
+
+	return 0;
+}
+
+/* Don't cleanup vport->info, it's needed to restore vport configuration */
+static void esw_vport_cleanup(struct mlx5_eswitch *esw, struct mlx5_vport *vport)
+{
+	u16 vport_num = vport->vport;
+
+	if (!mlx5_esw_is_manager_vport(esw, vport_num))
+		mlx5_modify_vport_admin_state(esw->dev,
+					      MLX5_VPORT_STATE_OP_MOD_ESW_VPORT,
+					      vport_num, 1,
+					      MLX5_VPORT_ADMIN_STATE_DOWN);
+
+	esw_vport_disable_qos(esw, vport);
+	esw_vport_cleanup_acl(esw, vport);
+}
+
 static int esw_enable_vport(struct mlx5_eswitch *esw, struct mlx5_vport *vport,
 			    enum mlx5_eswitch_vport_event enabled_events)
 {
@@ -1804,16 +1817,10 @@ static int esw_enable_vport(struct mlx5_eswitch *esw, struct mlx5_vport *vport,
 
 	esw_debug(esw->dev, "Enabling VPORT(%d)\n", vport_num);
 
-	/* Restore old vport configuration */
-	esw_vport_setup(esw, vport);
-
-	ret = esw_vport_setup_acl(esw, vport);
+	ret = esw_vport_setup(esw, vport);
 	if (ret)
 		goto done;
 
-	/* Attach vport to the eswitch rate limiter */
-	esw_vport_enable_qos(esw, vport, vport->info.max_rate, vport->qos.bw_share);
-
 	/* Sync with current vport context */
 	vport->enabled_events = enabled_events;
 	vport->enabled = true;
@@ -1855,9 +1862,7 @@ static void esw_disable_vport(struct mlx5_eswitch *esw,
 	 */
 	esw_vport_change_handle_locked(vport);
 	vport->enabled_events = 0;
-	esw_vport_disable_qos(esw, vport);
 	esw_vport_cleanup(esw, vport);
-	esw_vport_cleanup_acl(esw, vport);
 	esw->enabled_vports--;
 
 done:
-- 
2.24.1

