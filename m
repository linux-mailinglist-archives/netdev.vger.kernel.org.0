Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8675231361
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 22:01:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729254AbgG1UAq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 16:00:46 -0400
Received: from mail-eopbgr00081.outbound.protection.outlook.com ([40.107.0.81]:56865
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728267AbgG1UAp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 16:00:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TbPDtX6UESD1pnqYNOkYyYE3UU13U1urb7BySz38tkox+AabwvvjMF8tI3KAZn4bswkLzjO7D0QibyUNpW4Fnx30NPGx/0i8M+ZLcmmkW6h5yuDQ+ptwzYEQ50tk886i46fzkWxzmK72JHD5ulxLl9u5qAHpNhz+TW/FEPFjnAZ8Ppx+093/bHbi+e8eR8IuGwluPccJFmnXxzpwgJLekLhGyVyS6Y3uyfH3xhhpWyItOA5RJOGSa4Io/LaiTLlYlWdKjsFnSOG9iCDT0Ix8O7+4P5k06iLjYG7uDSEjOHl2DwwDAZZIbKJPhI8Xxt83hW8b6Hicr2R6Kkb+jPWhQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DjhaxaNKOx/o/FA4SHNwtMrUSfbIn3A/PpFldpdRVbg=;
 b=Rn8r2ZpAeSSoDjiNz+wey+BCTQ0Eara43I2RYrXwfQ7g2zOhZu3k2OoQIrCMF506mbdo8G6g8MFRmtMjGeZB08WO1hHsZz+aNtWJvWkyGQ/j55B3bmXIsxigJMM6eCsbnJyGHuQjP+hYleZZ22Eg3WgHOLu8Vt9bQMiT/L72/p6WaYLdlc1l5VcbQoq71nCcvzon3cxbtTJewpM82tf4PxM5ziYbIeNV8H+qScGURsvsvV/eaaHBD07bySSgsEz7DLZB1d2YWmRY3UtxRJOaprjc8zRFxsRmOt9i8KTr/TBWOX0AdNUFfxHTkao+em8zunKKNnDdPaBtt8eughyaBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DjhaxaNKOx/o/FA4SHNwtMrUSfbIn3A/PpFldpdRVbg=;
 b=UhPmPbWNc1tN8tO9rwtFygZtcYe+PvQDeunoVXKDeLFX5b/l8kuTwsMjCMHAry+Dc7/5c7mggMlseqQOQK7tCTB23Y/Ima+7zUsqi/FeezMfbzyRs/XYKITTo9K79vQIOVVNS/HcWK9l7fAWMQT28cAfocHCBtMG0YD+FxNMu3k=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR0501MB2592.eurprd05.prod.outlook.com (2603:10a6:800:6f::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.20; Tue, 28 Jul
 2020 20:00:40 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::508a:d074:ad3a:3529]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::508a:d074:ad3a:3529%5]) with mapi id 15.20.3216.034; Tue, 28 Jul 2020
 20:00:40 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Raed Salem <raeds@mellanox.com>,
        Roi Dayan <roid@mellanox.com>, Vu Pham <vuhuong@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net V2 08/11] net/mlx5e: Fix slab-out-of-bounds in mlx5e_rep_is_lag_netdev
Date:   Tue, 28 Jul 2020 12:59:32 -0700
Message-Id: <20200728195935.155604-9-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200728195935.155604-1-saeedm@mellanox.com>
References: <20200728195935.155604-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR07CA0058.namprd07.prod.outlook.com
 (2603:10b6:a03:60::35) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR07CA0058.namprd07.prod.outlook.com (2603:10b6:a03:60::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.23 via Frontend Transport; Tue, 28 Jul 2020 20:00:38 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: dddd525f-1dc5-4701-93e5-08d83330e6f8
X-MS-TrafficTypeDiagnostic: VI1PR0501MB2592:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0501MB25921AEBF3500CDE51B1BF44BE730@VI1PR0501MB2592.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: q2JU3IVq3szl3MwZbYncTsQYWAJC+oodv138NIwhjM1GCkWwm0fM/auLC+u2JAwZHtJaXpaHRhkgxbmXPVnj9uUr+esPg/xJqhc4eC/9/0muJcRdwO13LD0eM5kHcwZO2oakZqLmirftEN13oSoLmYs0Dyvsfvvjaq1XE/tEjjMsy6vKY2I9vgm1myi1a8cMrw/sJVTSxhMiLvhODIC9SaCrYmkm8hNu73i2ykuErPRYv705t5hBlwReeZ/btkq/XPa9vfMx/Hi+tilV2shBFqAUWWiRCM3GIwpLumMW8bxwdI5oo6vZcfiFmzq1Jtv7nMiH/KQD/X9JXnaoxV7WMKwc50nd68HehXwprg5VYw4J/KGYgTatC+oJT2NfuNRl
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(186003)(6486002)(8676002)(83380400001)(498600001)(6506007)(54906003)(110136005)(107886003)(86362001)(36756003)(16526019)(26005)(1076003)(66556008)(52116002)(6666004)(66476007)(4326008)(66946007)(956004)(8936002)(2616005)(5660300002)(2906002)(6512007)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: E82nIQQZjY6JJcaDGxLc0L6AXqDG6dja/HLijIAa7YEdT+fPiR29/y2eI4Ihkdk/V7NPaNzQyDgEGIr1ReG/FxvRGRyH0fRJRWojZHkcThssjZy8JyoGl6sPbEsr/SoSBWswzYvbmCZ2C3pnHfdIsmZ9oOTFXc8urRVefeZ5qquj6OsZfQ62740lbhQr1c4O3WmMT4l3gigbSfk123onQTjr5Z6aIrrBocWeJJ/cGPaZqm5e8sNb4m/3PHYANSHMDIIz7MBHuWenZpAYoSuga134GbRyozqSTwQfe16knZXe4g1WdySib8sWTTd8w1W9QyC8EQAj9SSGlAVnRD4RhSBhdATubc4q+CbIVMLt9snD3KZXylVy+zFwk3uqGfrhmmyyLJpRbGiHb2tkoij9RAOxAMzW30nxNXQGWCA2x/yVJR5hdVa3U4aLWrrz8AHsUV921F0WFiJMDkyLJTI6u5m9luhDEHKlOiUsGyhtVpc=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dddd525f-1dc5-4701-93e5-08d83330e6f8
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2020 20:00:40.7252
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nR+ylVjRBVg9DJSJlgi0HVmdgtRPg6PIE78nx6BNZbjF5V4Sxt09kYxjUkmFe7J3c81yIztOwlD7uPqoxxdxKg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0501MB2592
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Raed Salem <raeds@mellanox.com>

mlx5e_rep_is_lag_netdev is used as first check as part of netdev events
handler for bond device of non-uplink representors, this handler can get
any netdevice under the same network namespace of mlx5e netdevice. Current
code treats the netdev as mlx5e netdev and only later on verifies this,
hence causes the following Kasan trace:
[15402.744990] ==================================================================
[15402.746942] BUG: KASAN: slab-out-of-bounds in mlx5e_rep_is_lag_netdev+0xcb/0xf0 [mlx5_core]
[15402.749009] Read of size 8 at addr ffff880391f3f6b0 by task ovs-vswitchd/5347

[15402.752065] CPU: 7 PID: 5347 Comm: ovs-vswitchd Kdump: loaded Tainted: G    B      O     --------- -t - 4.18.0-g3dcc204d291d-dirty #1
[15402.755349] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.12.1-0-ga5cab58e9a3f-prebuilt.qemu.org 04/01/2014
[15402.757600] Call Trace:
[15402.758968]  dump_stack+0x71/0xab
[15402.760427]  print_address_description+0x6a/0x270
[15402.761969]  kasan_report+0x179/0x2d0
[15402.763445]  ? mlx5e_rep_is_lag_netdev+0xcb/0xf0 [mlx5_core]
[15402.765121]  mlx5e_rep_is_lag_netdev+0xcb/0xf0 [mlx5_core]
[15402.766782]  mlx5e_rep_esw_bond_netevent+0x129/0x620 [mlx5_core]

Fix by deferring the violating access to be post the netdev verify check.

Fixes: 7e51891a237f ("net/mlx5e: Use netdev events to set/del egress acl forward-to-vport rule")
Signed-off-by: Raed Salem <raeds@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Reviewed-by: Vu Pham <vuhuong@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/rep/bond.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bond.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bond.c
index bdb71332cbf2d..3e44e4d820c51 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bond.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bond.c
@@ -183,13 +183,16 @@ void mlx5e_rep_bond_unslave(struct mlx5_eswitch *esw,
 
 static bool mlx5e_rep_is_lag_netdev(struct net_device *netdev)
 {
-	struct mlx5e_priv *priv = netdev_priv(netdev);
-	struct mlx5e_rep_priv *rpriv = priv->ppriv;
+	struct mlx5e_rep_priv *rpriv;
+	struct mlx5e_priv *priv;
 
 	/* A given netdev is not a representor or not a slave of LAG configuration */
 	if (!mlx5e_eswitch_rep(netdev) || !bond_slave_get_rtnl(netdev))
 		return false;
 
+	priv = netdev_priv(netdev);
+	rpriv = priv->ppriv;
+
 	/* Egress acl forward to vport is supported only non-uplink representor */
 	return rpriv->rep->vport != MLX5_VPORT_UPLINK;
 }
-- 
2.26.2

