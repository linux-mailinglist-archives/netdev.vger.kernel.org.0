Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B47AE1938C4
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 07:39:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727801AbgCZGjG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 02:39:06 -0400
Received: from mail-eopbgr130079.outbound.protection.outlook.com ([40.107.13.79]:8291
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727794AbgCZGjF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Mar 2020 02:39:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dvHi/BGbYEoWjjrGR0ARj47kg2HwshvuHvwNFxCzf6A0VzhAggb6Z+/cwM+dF43jFZEPXEwWyyYkcdaAtCUYhLzCLEKjzyZbaAUDj19PHQ6JZwck9Qe6kSHfYanqPJdXmgMmq032xyQU6cBTtvjQppz6Lx8vrwp346YIiUoTmvnqMsjFzPR6uyzEX2DgK3vUP81DF5dFfaAuHxwjSUS37MYC0u+lakBwOYPKhpXh2RBuLBIs3s0TrNmglylNuAQ4iIx3g+nBL1KMSQneeKZViSKw8MwRpTvlTgToQTUW7fP2zb+3iZYRJRNaU2KzjICvk84MUWN1Uhs+mRMaaiOpuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DSWeKbxMBHnELrjCZxXFRE0NOOIf7rqcoOkN41CtQ/k=;
 b=dww7g8LLSyFYQsbcIWCbDhXjlhHEpiWMI76Q3KwHN5O5Cbs7CBchOwrBtetQwcO33pvwLz1H4EhzfBPOLDCmeuHl2d4g3CpJXTfIGFtaXCHWzJegMIMcFMoBbesSAAoxoY3SpaQd3jqHOwSuhimIKYqWLbGzzbqkRi4Z59gyLS2/bDPyYWCeV2kkhX2zt0Jlrcg5PXupJb8V9NbafURly8AvXZg00hLwrus2SxVTOS2igEh+FtXB4tAHXP7LVOliDZDMpYcEqIBqHaIxFHyhXb3H/aXwbcNs9v4PiRZjqWh2RadsQR8iCW46rdxNzsFNY8rlpu28lz1ExB4YIRbHmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DSWeKbxMBHnELrjCZxXFRE0NOOIf7rqcoOkN41CtQ/k=;
 b=OK2WQnMF5y7XeoZHoMW4g0U+wsaTzeEYaEai04AgCiQIhU7jI3Huqh6EKOXs97uUdFbSymeR0EMBBe5tir4053Xx6IYOnjGYfIZGVmwlMUTVbXbGB+1xmT6xi55be+2/i6VfGk3/qQAUOS8mJ26/okcyv+4QRmZ2Q7NzKKQaBtM=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB6479.eurprd05.prod.outlook.com (20.179.25.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2835.23; Thu, 26 Mar 2020 06:38:59 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2835.023; Thu, 26 Mar 2020
 06:38:59 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Jiri Pirko <jiri@mellanox.com>,
        Parav Pandit <parav@mellanox.com>,
        Moshe Shemesh <moshe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 12/16] net/mlx5: Simplify mlx5_unload_one() and its callers
Date:   Wed, 25 Mar 2020 23:38:05 -0700
Message-Id: <20200326063809.139919-13-saeedm@mellanox.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200326063809.139919-1-saeedm@mellanox.com>
References: <20200326063809.139919-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR03CA0020.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::33) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR03CA0020.namprd03.prod.outlook.com (2603:10b6:a02:a8::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.19 via Frontend Transport; Thu, 26 Mar 2020 06:38:57 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 470d80be-181a-44d8-b2f7-08d7d1505db1
X-MS-TrafficTypeDiagnostic: VI1PR05MB6479:|VI1PR05MB6479:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB64793F2B2537CD25B1F0C700BECF0@VI1PR05MB6479.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:883;
X-Forefront-PRVS: 0354B4BED2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(39860400002)(366004)(346002)(396003)(376002)(136003)(478600001)(107886003)(52116002)(6512007)(4326008)(86362001)(6486002)(8936002)(54906003)(6506007)(36756003)(1076003)(81156014)(81166006)(2906002)(316002)(8676002)(6666004)(66946007)(186003)(16526019)(66556008)(66476007)(26005)(5660300002)(2616005)(956004)(54420400002);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2n1MPhAZcMnMLt62R06KRHGt6mWPaZsDa5tNOY4ji6kY5jAPZAPEmae6Oq4GJoDAOjJnMl65/h5DtpcuBe1IH4tyNSv4p56B40Y5IlFYFI+Q7DtOLlBH7husrJLsb5MHNj5SkSnukV6+huICztkaWg2mzP/qvyMi3yvOlememCdCEyf3x/azZOrT5hNNMKskvk7JUMVU2Kpjdk9nYg8EvUKC1tCSsc/kuXemHZvgNA0eLzouIxUR0hwE7K5A85gtYUBqe1M2iDFzwpLmf1xwWcfrrzc+jkMZ365jzSCp6TKgI/NdVD1AI9zJgMlCn+G55SNSbbZpRtXP/51jMA3G/XynqbO9gsHahtmjK1cVvKsISI8d5i3Rm7X6vb6F182TovwRX4jJ+SsELBUUIW66ZtZdvi1HSv24c88j2CEMzMd8g0ChhB2fVNpIPq/x7bp8+l1axA/gqj3sfuzGk7KUi6SRXgXg8CqoTXHBpn47iveEAXWJA3ALoRlb6+YRmP7x
X-MS-Exchange-AntiSpam-MessageData: XIUoRmgcRYlpuUqlvMipaCvyEpUQLZ6pG4hyVjPTgJxZR+E2KSR8Lz9+trw8mrUqBZfWEGlgaGo3u8ru+hkVPlh1FJiLU5kRabnvwxJ+zhSbCYqkwFwPvCc58EqDBY172I202YJl4vT6B+a1keAC8A==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 470d80be-181a-44d8-b2f7-08d7d1505db1
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2020 06:38:59.7709
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XG8KEXN6adPzQwDijcUQfxVpGMfhBCzu7Hdag40wXzy+edUL6hV5ZqZYviQ/wLLSUwWu+Gn0pBbz24ZXENiFfQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6479
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@mellanox.com>

mlx5_unload_one() always returns 0.
Simplify callers of mlx5_unload_one() and remove the dead code.

Reviewed-by: Moshe Shemesh <moshe@mellanox.com>
Signed-off-by: Parav Pandit <parav@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/devlink.c   |  3 ++-
 drivers/net/ethernet/mellanox/mlx5/core/main.c      | 10 ++--------
 drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h |  2 +-
 3 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index b7bb81b8c49b..bdeb291f6b67 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -90,7 +90,8 @@ static int mlx5_devlink_reload_down(struct devlink *devlink, bool netns_change,
 {
 	struct mlx5_core_dev *dev = devlink_priv(devlink);
 
-	return mlx5_unload_one(dev, false);
+	mlx5_unload_one(dev, false);
+	return 0;
 }
 
 static int mlx5_devlink_reload_up(struct devlink *devlink,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index dc58feb5a975..4a9d9cae8628 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1235,7 +1235,7 @@ int mlx5_load_one(struct mlx5_core_dev *dev, bool boot)
 	return err;
 }
 
-int mlx5_unload_one(struct mlx5_core_dev *dev, bool cleanup)
+void mlx5_unload_one(struct mlx5_core_dev *dev, bool cleanup)
 {
 	if (cleanup) {
 		mlx5_unregister_device(dev);
@@ -1264,7 +1264,6 @@ int mlx5_unload_one(struct mlx5_core_dev *dev, bool cleanup)
 	mlx5_function_teardown(dev, cleanup);
 out:
 	mutex_unlock(&dev->intf_state_mutex);
-	return 0;
 }
 
 static int mlx5_mdev_init(struct mlx5_core_dev *dev, int profile_idx)
@@ -1385,12 +1384,7 @@ static void remove_one(struct pci_dev *pdev)
 	mlx5_crdump_disable(dev);
 	mlx5_devlink_unregister(devlink);
 
-	if (mlx5_unload_one(dev, true)) {
-		mlx5_core_err(dev, "mlx5_unload_one failed\n");
-		mlx5_health_flush(dev);
-		return;
-	}
-
+	mlx5_unload_one(dev, true);
 	mlx5_pci_close(dev);
 	mlx5_mdev_uninit(dev);
 	mlx5_devlink_free(devlink);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
index 8c12f1be27ce..a8fb43a85d1d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
@@ -244,6 +244,6 @@ enum {
 u8 mlx5_get_nic_state(struct mlx5_core_dev *dev);
 void mlx5_set_nic_state(struct mlx5_core_dev *dev, u8 state);
 
-int mlx5_unload_one(struct mlx5_core_dev *dev, bool cleanup);
+void mlx5_unload_one(struct mlx5_core_dev *dev, bool cleanup);
 int mlx5_load_one(struct mlx5_core_dev *dev, bool boot);
 #endif /* __MLX5_CORE_H__ */
-- 
2.25.1

