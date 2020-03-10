Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E43E17EE1F
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 02:43:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726677AbgCJBnf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 21:43:35 -0400
Received: from mail-vi1eur05on2047.outbound.protection.outlook.com ([40.107.21.47]:6053
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726637AbgCJBna (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Mar 2020 21:43:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ob0j9KCrszn+tk5VmXnibMDpkTF55t/tTeM5r0+jzlslWlFGuveCzTQFDm28XQwdtfLaz6Q3eV4SSnb1zJBTJGuNJYgirqLi1YXZZ1rXcyaq9POyuq9BAviCSu+NDDTZTryvtgZECHXhURLEdiC35CHmxCEjVCI6CFIFHZllJk/kI1AbxZpR1GY5mKnvrdYpAPzSfkEKjhi115pDC/91eJKNAKF6FNpaNEbKVlAvVmiewJEHs+HIJNGRMbGHbfmZk6IOGog8BmyNJeT7woRJB3BIC5IEgtnTQuke8wik2TYyp3OB8mUxmZkH7zcWKYt63ekTe3mHL8ymWLpm3/GkgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TW8qwlRP3YspFv7XdwnLQYO2DeqWLgb2nMqc7VWxQnc=;
 b=QqAlSFhBCQ0k/KpCTofT+g/FfEhpzO5/A5dBX1WnIXV6YL7fArZSU3tRDXjifyinXQ8IGZUI3NjerPSxQ0aDisyMw7aYnP8XniH/Opi2mjeaEH+o7JI0p1b8+cdo3kgWkNn1xCxhGw7VHc1ZKST/ZarpeAjF3OwmIkQ71zbVAneuTWF5blCF6OZsLrZZRgKOUHTBryABC1roHxw1ENnzY1lbflaHg/tAY2M2/g7/qPWUCzJFFLoQz0nW1L2On9bd+vj9SlGVH8FJM4WXmKRZEJjwhJudr9PoW77dreqNI3dVRS3JX9ZNwisoGXDRnX/VIP2eKwtMBkNL4oL3cb5rYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TW8qwlRP3YspFv7XdwnLQYO2DeqWLgb2nMqc7VWxQnc=;
 b=IFGJWKbhyNofk5otwhFY8/Wq8m9BNflJ3S0TSNczlO5HWJPkeyjKrW0B0ko0SWiUJ/gc3j0R+FGCpIT6Qgt0uTh2BBbAkVaGpFJYYro86DExNvB0mWXyird1yDw6A23T0/XzFaOih/1G9D+hXIb1nltSK1gcWhKZD3Ifk/d+SLQ=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB5533.eurprd05.prod.outlook.com (20.177.201.157) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.17; Tue, 10 Mar 2020 01:43:22 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2793.013; Tue, 10 Mar 2020
 01:43:22 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Vlad Buslov <vladbu@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 09/11] net/mlx5e: Show/set Rx flow indir table and RSS hash key on ul rep
Date:   Mon,  9 Mar 2020 18:42:44 -0700
Message-Id: <20200310014246.30830-10-saeedm@mellanox.com>
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
Received: from smtp.office365.com (73.15.39.150) by BYAPR08CA0068.namprd08.prod.outlook.com (2603:10b6:a03:117::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.15 via Frontend Transport; Tue, 10 Mar 2020 01:43:20 +0000
X-Mailer: git-send-email 2.24.1
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: d8188721-8a07-42f8-0e17-08d7c4946aca
X-MS-TrafficTypeDiagnostic: VI1PR05MB5533:|VI1PR05MB5533:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB55330F61CEEDEABA060D4C6CBEFF0@VI1PR05MB5533.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1751;
X-Forefront-PRVS: 033857D0BD
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(346002)(396003)(136003)(366004)(39860400002)(199004)(189003)(66476007)(16526019)(316002)(1076003)(66946007)(66556008)(8676002)(86362001)(6506007)(478600001)(107886003)(5660300002)(81166006)(81156014)(6486002)(956004)(36756003)(2906002)(6512007)(4326008)(54906003)(8936002)(26005)(2616005)(52116002)(6666004)(186003)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5533;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lnuLRPJK9fYZGyzE5AWrBGi3qQFI1JmQXFOWj0A/RKb1gqS2o8InP+nkXSnqyCfMMN9wdH1/wTbVugsdA/txKSausx+CT0ax1CLVYOlnzes7ZMqymA6ISErX6GNUAw1ImKEeKjIjbXPAg3d00eQWa6Ui5ciopBFuwA9BeaSynERf5VoBuCMS1X/TQqpmU3W20YQ/xvN3Io7AdQcVApbwpcApubL3mXWsktrs1APcQ2NZZ7CBSa9l/xb8HRCu3UMVjxQYPzUkmg23+bEnL62Ggygau6mPxqIrJLWb9GbRZN1C6VKGEeBaF6vFkshn8lM+5SceZJUUGdQ/4s0P5CUrLW7gkxHi4acB7grq/F5gw8SxCgdgUGxhnBPBkFj3nYwIjCa2oMAASZ6FWMjZ/itd558+UeuBu6hZUV0klBBnTmERajw+feUGcBLajH0s3nCXBae1Wi4RKMR+pBphX9HDhs9YLx44AmJP9N420Xhf+qkuWyj7mgm8edXDeZ8bGdKs4mzMvPTeCpmkdvEt8hFiiSdhX0d3N6E3cwnPJHpVMKs=
X-MS-Exchange-AntiSpam-MessageData: umk4zqI1w+an39AsbFArguAQc1/G/m0aQac1neYLoKPAEmqhj8AI7xEyqttOdfBgi0z3R42qXHLF/3gsqxUu0RqDEmVXFApODKzsk2lHIk6ckQKGkw8CvHCiwAUeZThGsvMBXDzDSlCkv1cDPPrFZg==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d8188721-8a07-42f8-0e17-08d7c4946aca
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2020 01:43:22.4074
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fTqacpekp4Or4FUID7fwvyqDCgqV4DS4R0lxCnj+3hc9TmNgxg7YZGBzLN9qfkLuwRgIvqwFxEcWZBTR4CUfRw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5533
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@mellanox.com>

Reuse infrastructure that already exists for pf in legacy mode to show/set
Rx flow hash indirection table and RSS hash key for uplink representors.

Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h         | 3 +++
 drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c | 8 ++++----
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c     | 2 ++
 3 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 02b91aa896b0..0410cdaab475 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -1169,6 +1169,9 @@ int mlx5e_ethtool_get_link_ksettings(struct mlx5e_priv *priv,
 				     struct ethtool_link_ksettings *link_ksettings);
 int mlx5e_ethtool_set_link_ksettings(struct mlx5e_priv *priv,
 				     const struct ethtool_link_ksettings *link_ksettings);
+int mlx5e_get_rxfh(struct net_device *netdev, u32 *indir, u8 *key, u8 *hfunc);
+int mlx5e_set_rxfh(struct net_device *dev, const u32 *indir, const u8 *key,
+		   const u8 hfunc);
 u32 mlx5e_ethtool_get_rxfh_key_size(struct mlx5e_priv *priv);
 u32 mlx5e_ethtool_get_rxfh_indir_size(struct mlx5e_priv *priv);
 int mlx5e_ethtool_get_ts_info(struct mlx5e_priv *priv,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index 4e667608bffd..f28472471315 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -1132,8 +1132,8 @@ static u32 mlx5e_get_rxfh_indir_size(struct net_device *netdev)
 	return mlx5e_ethtool_get_rxfh_indir_size(priv);
 }
 
-static int mlx5e_get_rxfh(struct net_device *netdev, u32 *indir, u8 *key,
-			  u8 *hfunc)
+int mlx5e_get_rxfh(struct net_device *netdev, u32 *indir, u8 *key,
+		   u8 *hfunc)
 {
 	struct mlx5e_priv *priv = netdev_priv(netdev);
 	struct mlx5e_rss_params *rss = &priv->rss_params;
@@ -1152,8 +1152,8 @@ static int mlx5e_get_rxfh(struct net_device *netdev, u32 *indir, u8 *key,
 	return 0;
 }
 
-static int mlx5e_set_rxfh(struct net_device *dev, const u32 *indir,
-			  const u8 *key, const u8 hfunc)
+int mlx5e_set_rxfh(struct net_device *dev, const u32 *indir,
+		   const u8 *key, const u8 hfunc)
 {
 	struct mlx5e_priv *priv = netdev_priv(dev);
 	struct mlx5e_rss_params *rss = &priv->rss_params;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index cffb5f62c304..9ff0a8e6858e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -369,6 +369,8 @@ static const struct ethtool_ops mlx5e_uplink_rep_ethtool_ops = {
 	.set_link_ksettings = mlx5e_uplink_rep_set_link_ksettings,
 	.get_rxfh_key_size   = mlx5e_rep_get_rxfh_key_size,
 	.get_rxfh_indir_size = mlx5e_rep_get_rxfh_indir_size,
+	.get_rxfh          = mlx5e_get_rxfh,
+	.set_rxfh          = mlx5e_set_rxfh,
 	.get_pauseparam    = mlx5e_uplink_rep_get_pauseparam,
 	.set_pauseparam    = mlx5e_uplink_rep_set_pauseparam,
 };
-- 
2.24.1

