Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59D322000D4
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 05:33:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731039AbgFSDdu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 23:33:50 -0400
Received: from mail-eopbgr80088.outbound.protection.outlook.com ([40.107.8.88]:57212
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731008AbgFSDdr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Jun 2020 23:33:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZbmUsUc4mPCkhB5XI+OF66be9lR2JNLU5JbZ3P3Vj9MlNbdIWbzOkbQJhIi9DFwmwfj8n71TTijKbD+X5L0eGKZnIgQf3irk/r65F4biM6marmRfTPjmFiw8K/aWoxDEcU90jl34qgM/sUHr8xDU2LaAtmYyyXxOtIekjtBFkqHbjwDjK16CZLj3sbxcc4dES2YGTM9iG+Qcgc/vE1Q+NQC5NR6QGfYPX2D/1/uulRbeaNKH1hOKOpuAazIqKrBVfwvCBaGDiJlTHBxZbNMkURJQYiXUMVj3sxEHQVjewSAbmY9mPLXV1qFpE0dSpfXDamMSQt0qiH7XEBXu+cxx+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xUObjke8/5gjkr7pDSeGQp+f5O8czs+Y3AP2FqFTwI8=;
 b=kqkUiofLCUmMogmTa6gCkLBqb6Mc8pWMnTKPMSNYwg5Jm4R/1f/RICgB2FdFBhoLWg2OlIe+wOK0ruEW71UZLk6Y6htRB+xZyWbSBz5kdz0k8GgDXhcpffxRknBt7GhY6JT20U2gtKyussQBGIFbrHtbWDOWoeDjX4317+cXiWSHZVjpHooKqB+tTRZA1VueMJ/DpqvgrnDzftqLQgUY0lqpSAofah3tXS68XHMJ/ggs4ZERBoW1ug0diOS/tna10qfjEBcBXfbwYxRIxU3lTGs9TWRor3GPzwzRnH06mGAli+EKJzw1X2vPChTehEP8ZN8+Y/dxb/4eVIU0arnjYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xUObjke8/5gjkr7pDSeGQp+f5O8czs+Y3AP2FqFTwI8=;
 b=s2X7nBkiZsZE4SUW+AxZRsJb3Qa68xjgHn6ON1bbcO6Y9qKSLA1tZJEXJPGr1DnISIHIqSSltOaeUPgbyqUueAh5JD8dGviBtH3j3K9X7R198e6f9IHEPITMbWdAY9LvaZm+z4OZbW06SXQV+3cl1mwKB1NT89kRfHBJX3v1TR8=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (2603:10a6:208:c0::32)
 by AM0PR05MB6804.eurprd05.prod.outlook.com (2603:10a6:20b:146::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.21; Fri, 19 Jun
 2020 03:33:33 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::d44d:a804:c730:d2b7]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::d44d:a804:c730:d2b7%2]) with mapi id 15.20.3109.021; Fri, 19 Jun 2020
 03:33:33 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     saeedm@mellanox.com, davem@davemloft.net, kuba@kernel.org,
        jiri@mellanox.com, Parav Pandit <parav@mellanox.com>,
        Roi Dayan <roid@mellanox.com>
Subject: [PATCH net-next 8/9] net/mlx5: Split mac address setting function for using state_lock
Date:   Fri, 19 Jun 2020 03:32:54 +0000
Message-Id: <20200619033255.163-9-parav@mellanox.com>
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
Received: from sw-mtx-036.mtx.labs.mlnx (208.176.44.194) by SN4PR0401CA0019.namprd04.prod.outlook.com (2603:10b6:803:21::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22 via Frontend Transport; Fri, 19 Jun 2020 03:33:32 +0000
X-Mailer: git-send-email 2.25.4
X-Originating-IP: [208.176.44.194]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 09347809-a18f-4aef-9da1-08d814018b0a
X-MS-TrafficTypeDiagnostic: AM0PR05MB6804:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR05MB6804A22E2BAC75402FF4D307D1980@AM0PR05MB6804.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-Forefront-PRVS: 0439571D1D
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hGVaJWAIa9xSxLXdJpA1lEOlUim3O4RNdYarhfTqLAhomQtz0bYeIwUsmJ4D1mF+SkXGx3/yOCl04hF8ZiW2w8F3fH5yR0F9VBgIsfy31bP0/oXFkmQULwvFw8Y8DRcT+dHVexo4DrlL1c6m0WAR7o4e3LkkMRaBNmyfGkvTc35MHppoQbMLsPYG9yM0bUzGK5sgIyxvUNi9fDa8Qrvcs2YNsOgTi/ys4xnzyydXz6bRwmNLNdT+5AIj2Z02ojBBuUQ3u2Pi6KY8hC+oLVxiq4+22BbsMBAO1AK98Jvvns5488ej4zmKrLLsNj7RQfug
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR05MB4866.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(39860400002)(396003)(366004)(376002)(346002)(8676002)(2616005)(2906002)(4326008)(107886003)(6486002)(478600001)(8936002)(6512007)(5660300002)(6916009)(956004)(6666004)(26005)(66476007)(16526019)(186003)(66556008)(66946007)(83380400001)(316002)(6506007)(54906003)(86362001)(52116002)(36756003)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 2dXyI2MaLJVhL9KhbJbkMz23XjOJQCcqIwwuKBFx/XpV/00j2LZulJnEV1jTgNb+8XwGa0oVxLZvVwei9ulekV1h/L9N84wuobKQ7jpK5W1qbIxElIkYpS6cnM4B6GxIzQaiL6hTCdB6+a8m2nhSG+Rmso/AuaveX56WOHGdliPsA4A6RsgpvNWn407L/q4mvrDPqqrrMMLrxlgvY62QIfhl1zlLC8zlDnd2cMQ5pqGEIp4k+Oy9BarFY0P2czi/H+FGPHJP87Xk9xaZqWbQl5D+lDQhpI8M+zGJxJ4YDRAxOScfxOrwPGLoNkz3DMqiNATrjbLe6JV8nn3yeeoNUcfHrmSP3faDuf6c40N1lKPFEiHF865IYWrXMAi5rkjdvqVXHO1blmSEf0wuLWiQyNlKMAEWbO0Nvcux9C1jG/4Kt3pGM/IFUEpSGDw5apJITe5XeNFy91mHbNXSez9Qpa+lt9r3t5g8Vkog31XlFLMTpz+b+VdmEdPyBn4qieUe
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 09347809-a18f-4aef-9da1-08d814018b0a
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2020 03:33:33.4765
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gNL9T/FXwTj4vaRUsLTix7suG4YTYzcSjkXCL9BQoYH05/ASBOu4gEh1N0ZH0TTyTp1q1GLl2ycRO0bGQHNXDA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB6804
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Refactor mac address setting function to let caller hold the necessary
state_lock mutex, so that subsequent patch and use this helper routine.

Signed-off-by: Parav Pandit <parav@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/eswitch.c | 38 ++++++++++++-------
 1 file changed, 24 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index 999e51656e16..2c08411e34ee 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1801,46 +1801,56 @@ void mlx5_eswitch_cleanup(struct mlx5_eswitch *esw)
 }
 
 /* Vport Administration */
-int mlx5_eswitch_set_vport_mac(struct mlx5_eswitch *esw,
-			       u16 vport, const u8 *mac)
+static int
+mlx5_esw_set_vport_mac_locked(struct mlx5_eswitch *esw,
+			      struct mlx5_vport *evport, const u8 *mac)
 {
-	struct mlx5_vport *evport = mlx5_eswitch_get_vport(esw, vport);
+	u16 vport_num = evport->vport;
 	u64 node_guid;
 	int err = 0;
 
-	if (IS_ERR(evport))
-		return PTR_ERR(evport);
 	if (is_multicast_ether_addr(mac))
 		return -EINVAL;
 
-	mutex_lock(&esw->state_lock);
-
 	if (evport->info.spoofchk && !is_valid_ether_addr(mac))
 		mlx5_core_warn(esw->dev,
 			       "Set invalid MAC while spoofchk is on, vport(%d)\n",
-			       vport);
+			       vport_num);
 
-	err = mlx5_modify_nic_vport_mac_address(esw->dev, vport, mac);
+	err = mlx5_modify_nic_vport_mac_address(esw->dev, vport_num, mac);
 	if (err) {
 		mlx5_core_warn(esw->dev,
 			       "Failed to mlx5_modify_nic_vport_mac vport(%d) err=(%d)\n",
-			       vport, err);
-		goto unlock;
+			       vport_num, err);
+		return err;
 	}
 
 	node_guid_gen_from_mac(&node_guid, mac);
-	err = mlx5_modify_nic_vport_node_guid(esw->dev, vport, node_guid);
+	err = mlx5_modify_nic_vport_node_guid(esw->dev, vport_num, node_guid);
 	if (err)
 		mlx5_core_warn(esw->dev,
 			       "Failed to set vport %d node guid, err = %d. RDMA_CM will not function properly for this VF.\n",
-			       vport, err);
+			       vport_num, err);
 
 	ether_addr_copy(evport->info.mac, mac);
 	evport->info.node_guid = node_guid;
 	if (evport->enabled && esw->mode == MLX5_ESWITCH_LEGACY)
 		err = esw_acl_ingress_lgcy_setup(esw, evport);
 
-unlock:
+	return err;
+}
+
+int mlx5_eswitch_set_vport_mac(struct mlx5_eswitch *esw,
+			       u16 vport, const u8 *mac)
+{
+	struct mlx5_vport *evport = mlx5_eswitch_get_vport(esw, vport);
+	int err = 0;
+
+	if (IS_ERR(evport))
+		return PTR_ERR(evport);
+
+	mutex_lock(&esw->state_lock);
+	err = mlx5_esw_set_vport_mac_locked(esw, evport, mac);
 	mutex_unlock(&esw->state_lock);
 	return err;
 }
-- 
2.19.2

