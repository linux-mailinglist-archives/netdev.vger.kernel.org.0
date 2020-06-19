Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 676382000D2
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 05:33:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731022AbgFSDdo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 23:33:44 -0400
Received: from mail-eopbgr70089.outbound.protection.outlook.com ([40.107.7.89]:25892
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730980AbgFSDdm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Jun 2020 23:33:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SA04nGJ1okzEX7k2qPEod8Eh0m3B8WIMabMUODn4t8ViMSIdZu6BHVsBHQBOOR6RlltPB0aN8jJNJDAEHxZkDn8cpkwc0DEOgkHBRNETIaiTi9wkbxvNFEkNdb06A4NoULIkTQmdtH161DnvS6++PYnS9v+tRjhzcem2IC9I5CgXipHsLYG86wJczi5/2ygyDX4RHxMP/m/sCaVCP/j6JYh0dl1RuCfQo7UEiWu3XEvaePhcROC6rHKbYziMM3ekGekeGNZjRbCglDuKNqojMzTgsaq5G6Gr13SU+NhSDrnN89xoXQBKGSbRuk9SK1LeX2uLkF6OCCWVI238vb4VeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wLV9hOxrFT3/ahRfdI/Rk2wwAdFx3GVRo8pBfzYFyfE=;
 b=TpdBzN9KDU45tCKRYeHnbYE8gZ+PakbjNWnUzRq/kjGOJxEhBC7A/xxfntAiWfUvv3/fu/ML446yb6m1Z3rEjicnB87+K3muVVYNRKsf6z9nYG4iKTbfMRx5WovHG5vYtG1EKAI5zelQxuHsSwIJ9hnwxFn919CVC03xajmbFho3R1wZPYZRJQy4IpKgjQ3fav+xoXAY/TXdkWKKAirnnORJMCeo+G/LuTQFzLZWtj9R2BIBkiEA01a+cYnKkhcOPDQmZAkCD6PzNBd85WTinPDwMVOk6IBjasD2p6gIjRxw3jhg/h9sP7Mu67YneS0+liObor7tvAdrG2gAO02xWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wLV9hOxrFT3/ahRfdI/Rk2wwAdFx3GVRo8pBfzYFyfE=;
 b=f6TUztgnA21rVsoEeqkojATz2BGRKqp7f4dW50OgRoO44uuCig/tc7xQE+ZGsK/0IUSAiaQGpoxL6wI2RZma8X9KN+PZT9UVEYseOh6iIHYh3EWnFNCzkM6KBYejPg6C/eELHLOhn68W+dBYSgCeAM3mluk0/9/QftSCRL2hOIQ=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (2603:10a6:208:c0::32)
 by AM0PR05MB6804.eurprd05.prod.outlook.com (2603:10a6:20b:146::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.21; Fri, 19 Jun
 2020 03:33:30 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::d44d:a804:c730:d2b7]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::d44d:a804:c730:d2b7%2]) with mapi id 15.20.3109.021; Fri, 19 Jun 2020
 03:33:30 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     saeedm@mellanox.com, davem@davemloft.net, kuba@kernel.org,
        jiri@mellanox.com, Parav Pandit <parav@mellanox.com>,
        Roi Dayan <roid@mellanox.com>
Subject: [PATCH net-next 6/9] net/mlx5: Move helper to eswitch layer
Date:   Fri, 19 Jun 2020 03:32:52 +0000
Message-Id: <20200619033255.163-7-parav@mellanox.com>
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
Received: from sw-mtx-036.mtx.labs.mlnx (208.176.44.194) by SN4PR0401CA0019.namprd04.prod.outlook.com (2603:10b6:803:21::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22 via Frontend Transport; Fri, 19 Jun 2020 03:33:28 +0000
X-Mailer: git-send-email 2.25.4
X-Originating-IP: [208.176.44.194]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 6854c6be-9d45-40f9-8aa4-08d8140188ff
X-MS-TrafficTypeDiagnostic: AM0PR05MB6804:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR05MB6804B3A2ED162C257B0443D8D1980@AM0PR05MB6804.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1923;
X-Forefront-PRVS: 0439571D1D
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5ppJrl9o8EquJIsORyD2UI8ZNaMEUFv60/y/0CIkthBvO7QQT+BMrlW4QiD7nCLipHldgoycj4QLdfag5k1P1M6486r3RN8I2yApq2SJoLPZT9gDBM8g0AhXXERp7D/xzlgSiUJdL7JmseA9Lcq/U0UxEVPow7G+Syz/DFBzQkvS9f8DoM8l1A47of5+yZUJNtFc93ZsV/jOL43T5Qz6XYo+aCZIiN7lT5U2iRbklPEwbXAi4BvjCcmhGJQWdWwc4Uab/RSGDtmO/52DxLbIOeGjrVs3Xt+gnFnWHDyOgOEEzP/oglnLwG7wAyvmnxJp
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR05MB4866.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(39860400002)(396003)(366004)(376002)(346002)(8676002)(2616005)(2906002)(4326008)(107886003)(6486002)(478600001)(8936002)(6512007)(5660300002)(6916009)(956004)(6666004)(26005)(66476007)(16526019)(186003)(66556008)(66946007)(83380400001)(316002)(6506007)(54906003)(86362001)(52116002)(36756003)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: W7ETXwO/L+7cWTaT9URwntZWOWqNLTPjc6JiRINRU69iIn5fXTxTnzknY6qndlfwGuQMF92V+zl8qc9T8Bz+fXYIBQRO/FRZdXMoGZYS1vpRu5u1vNqp8QJ6CEES32n1Xdx36FMqD9mb745ZBzqMO8UBX2Yh0QF+wBQBM/qCB785HRQtgzbIBmK4KDezio/KVEkYMF4zqDEgaAC9tf0Xl+fVoRPfm5v3oFn5bJX3VVPWTZLA8dyOmTwW8D6wmDZSnT08xPf3tanMe+FimD9BAarPS7AxmxPCB2m+0Nu8r5cDTA0iR7fHIIoYNhdp8Z3C2U9i32JtIQi4gRHRlGVQYAXwZVcPk9kXhYNExiyQDAgfIsv5qfy++EICeWA9vLeXYRsngTPE41mb+nJ6JlBvD3HcZMzKfoZl2F1S2NqRwu4FpQ2wMjsSpdQQc/bg4gwHLxGTKZx7sPuNd2iEIGryAQtCmYQXFy4AkwEB1tdCMpQ/FXJUg0zqYmSQqcxMSItx
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6854c6be-9d45-40f9-8aa4-08d8140188ff
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2020 03:33:30.1495
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JqmxQqYWpR/ztq9JhPxBS2Km5Hj1gPgTPn67MKhBc7Pc7u9RLswyV7HreHBjYGPiYy0buyqyMtZuQtJO6BD71A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB6804
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To use port number to port index conversion at eswitch level, move it to
eswitch header.

Signed-off-by: Parav Pandit <parav@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c  | 8 +-------
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h | 7 +++++++
 2 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 006807e04eda..20ff8526d212 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -1181,12 +1181,6 @@ is_devlink_port_supported(const struct mlx5_core_dev *dev,
 	       mlx5_eswitch_is_vf_vport(dev->priv.eswitch, rpriv->rep->vport);
 }
 
-static unsigned int
-vport_to_devlink_port_index(const struct mlx5_core_dev *dev, u16 vport_num)
-{
-	return (MLX5_CAP_GEN(dev, vhca_id) << 16) | vport_num;
-}
-
 static int register_devlink_port(struct mlx5_core_dev *dev,
 				 struct mlx5e_rep_priv *rpriv)
 {
@@ -1200,7 +1194,7 @@ static int register_devlink_port(struct mlx5_core_dev *dev,
 		return 0;
 
 	mlx5e_rep_get_port_parent_id(rpriv->netdev, &ppid);
-	dl_port_index = vport_to_devlink_port_index(dev, rep->vport);
+	dl_port_index = mlx5_esw_vport_to_devlink_port_index(dev, rep->vport);
 	pfnum = PCI_FUNC(dev->pdev->devfn);
 
 	if (rep->vport == MLX5_VPORT_UPLINK)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index dde5a36fee9d..8f537183e977 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -565,6 +565,13 @@ static inline u16 mlx5_eswitch_index_to_vport_num(struct mlx5_eswitch *esw,
 	return index;
 }
 
+static inline unsigned int
+mlx5_esw_vport_to_devlink_port_index(const struct mlx5_core_dev *dev,
+				     u16 vport_num)
+{
+	return (MLX5_CAP_GEN(dev, vhca_id) << 16) | vport_num;
+}
+
 /* TODO: This mlx5e_tc function shouldn't be called by eswitch */
 void mlx5e_tc_clean_fdb_peer_flows(struct mlx5_eswitch *esw);
 
-- 
2.19.2

