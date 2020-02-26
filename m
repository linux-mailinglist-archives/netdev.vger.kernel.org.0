Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72E5216F4D5
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 02:13:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730038AbgBZBNc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 20:13:32 -0500
Received: from mail-db8eur05on2044.outbound.protection.outlook.com ([40.107.20.44]:6175
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729828AbgBZBNa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Feb 2020 20:13:30 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H/iWyLD4cRY1CdQxmUHGIVoBX0R7i6m2rVDdwbVvnq6Fn0F2VKjApXL002o13EcE1Ga2NPG7V9msdyR2LeC35dUgBJWpDe2Y7jUIMBVcd81OFs+2/yrGTD7GNoSYcBCoo6FXgFvJjxLFdxZnOSBMwUp6aIggmuLDP17tryymkBtqf5Oqo13TZ5ywjqm5sUqIIkHVP2zItNYuHmYsPztiivojIZam2R3/sDBXU0BKdbLtSrHbv97dub3PNjiJIkIe4KixwS2FM5ffFhpvjRernHIaYftfS6at3dpuEkNzLSzS0RdKB8GhbZEdA3ZGcq4Zu2gklz04l8oa3CobzZvn+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lAUAlEzFv/tU3/PIdGSibHjAsd+KwtkMZ4fUezzBsXY=;
 b=a9sTnT4kAAgx/GnOBSw/YAV14iXbYX6zMU1BbYic8WkhM0U+/FsV3urz4YCXfwfiO7WZ6Bqc0m0dGhULzE+pS/PKeAht/LbxxUI19ZniNzBDT+LER7t0K8dGwTlraUY4Meh0sMUngAy8UR4s0BLFBTV3fHGtUbJQS9PDq03W2Xzuf/nogrgBHtlpfwcHum3RNQdZUugEghGahHgD1hegOY3qcY2RcsSDOvi3dmZDWSIPochxo18RejROlmVWsuAloWinDdcjIAVCuNDDBNL361g8YRw1DQuqeg1qb9hqGrewXbeslrGqZiOFNQe/FvJVMbtDeGGy6pHRuS8Ljz4l/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lAUAlEzFv/tU3/PIdGSibHjAsd+KwtkMZ4fUezzBsXY=;
 b=s9nCaFi9M2hpMvzBlD90TpIVbIoHsbewepTLAeER2vKEHCgzfL2HwHXlOvUv5uzwAZ3V2IuqBw8cVsEhjR9GfFy+lO8kvV8VtEpXzGwfRwfh01p1j70bDTYM0S2QVYHXFIVeXpJtVsWUsYleHvfoAgb2i2JFRqXql/1cep2MgFw=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB7038.eurprd05.prod.outlook.com (10.141.234.204) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2750.21; Wed, 26 Feb 2020 01:13:17 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2750.021; Wed, 26 Feb 2020
 01:13:16 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Maxim Mikityanskiy <maximmi@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 03/16] net/mlx5e: Encapsulate updating netdev queues into a function
Date:   Tue, 25 Feb 2020 17:12:33 -0800
Message-Id: <20200226011246.70129-4-saeedm@mellanox.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200226011246.70129-1-saeedm@mellanox.com>
References: <20200226011246.70129-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR04CA0019.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::29) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY5PR04CA0019.namprd04.prod.outlook.com (2603:10b6:a03:1d0::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2750.18 via Frontend Transport; Wed, 26 Feb 2020 01:13:14 +0000
X-Mailer: git-send-email 2.24.1
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 95fad0db-6739-4bf6-afc2-08d7ba590f1c
X-MS-TrafficTypeDiagnostic: VI1PR05MB7038:|VI1PR05MB7038:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB7038C9BC8894460DEEC2729DBEEA0@VI1PR05MB7038.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:335;
X-Forefront-PRVS: 0325F6C77B
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(39860400002)(376002)(136003)(366004)(396003)(189003)(199004)(81156014)(66556008)(6666004)(4326008)(36756003)(66946007)(1076003)(5660300002)(66476007)(16526019)(6486002)(186003)(8676002)(81166006)(8936002)(54906003)(6512007)(2906002)(2616005)(86362001)(316002)(956004)(26005)(52116002)(478600001)(107886003)(6506007)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB7038;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: E8fD3GNbrSSeqXUgfjm10bkUu9th6kF36KI7nHa0rzl/df5eTwTOgSwq58gdOsymulHo5I0eGzU+7YWb8WamlN0HyxXoszZEpstjKPfzBw8Jcr2bQSRx8s1R+esrgCvFz8FlWergluo7YO9PLLz6wdY1wIRZ03rioLsYKqzHR6OgmN2yqgXxbbV19uo0797ua70jztQcutJnHicQF1mbJ6rW3d0xoucFZJR+Zb3oUeO21oHxLy5eGHtHxvAXSbpTyA08Oe2I75IxSYKpMq8QhN3JOKMMzFosRilW0zBabXf9zws6pj9HQz0+e+W9TC6VDCoq9THGlloaIc/GWA8wwFZgW4iRaoUrOt9Hzkq0BWPuWoevyT7sOdxfV9zoFY5CYhWEZZNmQ8nt5vQaVZXZDZQktsasWeIu5H3yBOYJRjrpVSrMnN22L8KSj+QgUry5IJV2WfmFWdkcNC/txcSxv+GT2wu7XqFtuc7Qe+m+iw84I9PHI3u6Qw2w9FVtaVhnCDx7LghOXidoY9Xey59KQD0kz6cxcrBx+jU26XIqeWs=
X-MS-Exchange-AntiSpam-MessageData: IqQSra1TSgyvT1pv6+iMJLfqJWSVyXINRdxTQBZzvxdyvaZPuqJ9q1VpSopxLmZDcgZVb2SXH/CvN8U3P8bBHAG0+oXVRNxZZwKvL4IkO5ZCrO7CdeAFoYMG/wL38idNlye/aQfqR7jpHedo9J9IDw==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95fad0db-6739-4bf6-afc2-08d7ba590f1c
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2020 01:13:16.8316
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D72L/ChAx7nLbS8M5+/8R3PzF14YjCCtfW116Xu8NYtyiKD3UQSEGpah2UtBhSVfQz7z9qe7Z85axL15BL85Hg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB7038
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@mellanox.com>

As a preparation for one of the following commits, create a function to
encapsulate the code that notifies the kernel about the new amount of
RX and TX queues. The code will be called multiple times in the next
commit.

Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index a4d3e1b6ab20..85a86ff72aac 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -2869,6 +2869,17 @@ static void mlx5e_netdev_set_tcs(struct net_device *netdev)
 		netdev_set_tc_queue(netdev, tc, nch, 0);
 }
 
+static void mlx5e_update_netdev_queues(struct mlx5e_priv *priv)
+{
+	int num_txqs = priv->channels.num * priv->channels.params.num_tc;
+	int num_rxqs = priv->channels.num * priv->profile->rq_groups;
+	struct net_device *netdev = priv->netdev;
+
+	mlx5e_netdev_set_tcs(netdev);
+	netif_set_real_num_tx_queues(netdev, num_txqs);
+	netif_set_real_num_rx_queues(netdev, num_rxqs);
+}
+
 static void mlx5e_build_txq_maps(struct mlx5e_priv *priv)
 {
 	int i, ch;
@@ -2890,13 +2901,7 @@ static void mlx5e_build_txq_maps(struct mlx5e_priv *priv)
 
 void mlx5e_activate_priv_channels(struct mlx5e_priv *priv)
 {
-	int num_txqs = priv->channels.num * priv->channels.params.num_tc;
-	int num_rxqs = priv->channels.num * priv->profile->rq_groups;
-	struct net_device *netdev = priv->netdev;
-
-	mlx5e_netdev_set_tcs(netdev);
-	netif_set_real_num_tx_queues(netdev, num_txqs);
-	netif_set_real_num_rx_queues(netdev, num_rxqs);
+	mlx5e_update_netdev_queues(priv);
 
 	mlx5e_build_txq_maps(priv);
 	mlx5e_activate_channels(&priv->channels);
-- 
2.24.1

