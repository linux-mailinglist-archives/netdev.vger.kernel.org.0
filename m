Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93D9817EE19
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 02:43:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726557AbgCJBnW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 21:43:22 -0400
Received: from mail-vi1eur05on2057.outbound.protection.outlook.com ([40.107.21.57]:6098
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726368AbgCJBnV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Mar 2020 21:43:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jH91NqAFBbBU+UsS8rweSaXQodr7tHcvNgZc1slXs7C1rKHytUvWYAB487vrtLmwdmY4JfI1JPUmezUJIsE3i94UoVVfGMP9SFWdnwkwQBLba5rq80RgPR8j6XvaYbxx275/iTg35Zxn5iHWxpBdCrYpQh+PByREL2a+l2JANdFc6vuR05aRlPWHchRXymro2Ue4r3HjG4xCROIoSQNAuFbMW0WOwZBJgOCaqpjBTI5rHOqXt2TSA1XLd0S4DUoTe5N+63P3susPfnF8IfZ5JEaAI2jGsqt7+qBIeODy7Fs3OlF0vKIDlMhZs4G1+IHMAaAaf2wMaROXykCZTuqqeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MZRYnpyndJTtxjbmX2cBgf0E9a3N++uIPVuuZEYGB+g=;
 b=MGdWb9ePU3HqeHwvLidu9oq6gPRRk17YOmqoKo1Sow8V6j1CquQWIcAE+H2CC9MYFz/1zVt24mmacM51d8JnpY/wWZA5GeoWJpDOZAEYemR7HsQhxcHaDgHUbA5mC9VXY5Vz2h5bD7LaGQhtOsosZBKaUQirBwXMseP3XYd5YS9rwj6tme09nyvzMmFIBJZzsl/vCGxiKFHqLyHu85S+MWIK94xDmIBmo+VgBDr+8H8EKfHY2qk63szyjk3+7W6l6McwODN7Q718D+zSbo+5BcCUsNknosQ3sIQqAcMXyYgT032ILGJNdWbJ6xKH2lk7gjNCNGRGylANmaijV3ZBfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MZRYnpyndJTtxjbmX2cBgf0E9a3N++uIPVuuZEYGB+g=;
 b=Y10e6QgnLTTN0iwVNA5FbEEs/GF13O+JKx/4XT1kqhOgJP+KfgKhEYkeHI5w85x1VwMFXih7LKowaCPm9gThr6vCczYFv4a0mbcu8ppX1SMxMSx1TBt6MP/tNSFwuaTiyUbErsnW5VlB6TKNN9qna+YuAQW1Nzckxqf9MaWFjjM=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB5533.eurprd05.prod.outlook.com (20.177.201.157) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.17; Tue, 10 Mar 2020 01:43:06 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2793.013; Tue, 10 Mar 2020
 01:43:06 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Mark Bloch <markb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 01/11] net/mlx5: Expose port speed when possible
Date:   Mon,  9 Mar 2020 18:42:36 -0700
Message-Id: <20200310014246.30830-2-saeedm@mellanox.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200310014246.30830-1-saeedm@mellanox.com>
References: <20200310014246.30830-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR08CA0068.namprd08.prod.outlook.com
 (2603:10b6:a03:117::45) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR08CA0068.namprd08.prod.outlook.com (2603:10b6:a03:117::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.15 via Frontend Transport; Tue, 10 Mar 2020 01:43:04 +0000
X-Mailer: git-send-email 2.24.1
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 549b5779-aae5-4b41-0deb-08d7c49460e1
X-MS-TrafficTypeDiagnostic: VI1PR05MB5533:|VI1PR05MB5533:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB55330554940E9AB938113016BEFF0@VI1PR05MB5533.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1122;
X-Forefront-PRVS: 033857D0BD
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(346002)(396003)(136003)(366004)(39860400002)(199004)(189003)(66476007)(16526019)(316002)(1076003)(66946007)(66556008)(8676002)(86362001)(6506007)(478600001)(107886003)(5660300002)(81166006)(81156014)(6486002)(956004)(36756003)(2906002)(6512007)(4326008)(54906003)(8936002)(26005)(2616005)(52116002)(6666004)(186003)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5533;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2sEZaVzk5KlcAg7mVIMaQ11tJjE2uigSTR4gFY9zjnt2v8B3VKQmVx8unDZMBHZD8eEsesVCZChrddF9AitRGH14Cwdmh+f9B9LQuaxziQnIzOvIY5JUWs08usMy3upj2tciR/rZXogyZ8h6FaVRlw+U2l3Z9BoaEKBe4HDlNlkilzMsTXoC0DTwaySPdopsJD8D7MUfUhD4sF6ejFIn7eWw+jNaDGjvZAOhVphLJ2D/IGYeO/IHU6HwbPQj9W0+NcRhYi0l46vX7Qc6MbdOMwQkw5zsPAUm35TwMNPusmn8hg8LS/bCjFIdlxpPpp9+8l9h1hyKvtLaaTNNVhV8GdZE5j7a3f5C8PxV/76Duk8uHJunXrVowlM0AvMmX/7KTM9omigpwizZlPkTp8ZeQt2ZyH2sP8aX60xbimSasidQFtC1YYM+2p33Abz4j+x/LNxcHYgMiM4o27orMuJF/wtfJnT/F880GpsxbRPmyNzMgwa7mxDq1wdQsU5m6hop5+4lfgA34MiQ5p4fVAQBhTJ4bxWXyRD20MMq5a9E3bM=
X-MS-Exchange-AntiSpam-MessageData: 4BVjb5Y0mPJR/ICI7orB8YA54tzCLEakRHjyKprbxbaTITQiIaTsBRia+87QJPJ75Lq+KY/ZTIALzIy2NWL3y07BQ7LxjTR/JHmM9fHhy+KW+Cajku1PprYSL7QzTIJQbOyXsSbJ5KMfvTgpCMavxA==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 549b5779-aae5-4b41-0deb-08d7c49460e1
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2020 01:43:05.9907
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +P8nPP+J3Daxz6FOO4PYV9vq7bWItgU+ZhkM+7ZBiVD9xyWjdZWuzilkj1qFLHPuX6Y6s0EECWqfq0FQV67ShA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5533
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mark Bloch <markb@mellanox.com>

When port speed can't be reported based on ext_eth_proto_capability
or eth_proto_capability instead of reporting speed as unknown check
if the port's speed can be inferred based on the data_rate_oper field.

Signed-off-by: Mark Bloch <markb@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index 01539b874b5e..f4491fba14a0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -773,6 +773,7 @@ static void ptys2ethtool_supported_advertised_port(struct ethtool_link_ksettings
 
 static void get_speed_duplex(struct net_device *netdev,
 			     u32 eth_proto_oper, bool force_legacy,
+			     u16 data_rate_oper,
 			     struct ethtool_link_ksettings *link_ksettings)
 {
 	struct mlx5e_priv *priv = netdev_priv(netdev);
@@ -784,7 +785,10 @@ static void get_speed_duplex(struct net_device *netdev,
 
 	speed = mlx5e_port_ptys2speed(priv->mdev, eth_proto_oper, force_legacy);
 	if (!speed) {
-		speed = SPEED_UNKNOWN;
+		if (data_rate_oper)
+			speed = 100 * data_rate_oper;
+		else
+			speed = SPEED_UNKNOWN;
 		goto out;
 	}
 
@@ -874,6 +878,7 @@ int mlx5e_ethtool_get_link_ksettings(struct mlx5e_priv *priv,
 {
 	struct mlx5_core_dev *mdev = priv->mdev;
 	u32 out[MLX5_ST_SZ_DW(ptys_reg)] = {0};
+	u16 data_rate_oper;
 	u32 rx_pause = 0;
 	u32 tx_pause = 0;
 	u32 eth_proto_cap;
@@ -917,6 +922,7 @@ int mlx5e_ethtool_get_link_ksettings(struct mlx5e_priv *priv,
 	an_disable_admin    = MLX5_GET(ptys_reg, out, an_disable_admin);
 	an_status	    = MLX5_GET(ptys_reg, out, an_status);
 	connector_type	    = MLX5_GET(ptys_reg, out, connector_type);
+	data_rate_oper	    = MLX5_GET(ptys_reg, out, data_rate_oper);
 
 	mlx5_query_port_pause(mdev, &rx_pause, &tx_pause);
 
@@ -927,7 +933,7 @@ int mlx5e_ethtool_get_link_ksettings(struct mlx5e_priv *priv,
 	get_advertising(eth_proto_admin, tx_pause, rx_pause, link_ksettings,
 			admin_ext);
 	get_speed_duplex(priv->netdev, eth_proto_oper, !admin_ext,
-			 link_ksettings);
+			 data_rate_oper, link_ksettings);
 
 	eth_proto_oper = eth_proto_oper ? eth_proto_oper : eth_proto_cap;
 
-- 
2.24.1

