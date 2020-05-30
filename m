Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 493271E8DD1
	for <lists+netdev@lfdr.de>; Sat, 30 May 2020 06:27:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728770AbgE3E11 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 May 2020 00:27:27 -0400
Received: from mail-eopbgr130058.outbound.protection.outlook.com ([40.107.13.58]:61765
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725889AbgE3E1Y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 30 May 2020 00:27:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jMtIS0qOH/eYPGsswMGMcAoqEvgymTsUvgBYJV3BQtxUdoDujzKZ5fTULCxDPD29Nw1pKXukt0PYDvPfeIC+ni/GPgq7d2mEY6hoLI3jIMPE+BzU7jEcDLdIYDz/iHpw6yooy68PaUQGMEWAncUFi9xarCn3Z9y97+0Ri/5jmyOKvCNZZiCnbGHhFlWf/pBJ2ElMmh9izQb+x9KP27cBhIaIJLkVjR4LquANAMbAOUvGqTyAMMqhYrbU+1TELF6LOwSu/6UCKlNGbhuU92ztVFH4YoPZBBeDNZEC3lkiDvSgjtY/5IEfyzzqkYf9Oji/6miUWd5igL/f94NMqakXtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tJm3QcmXy0S8Y5P3Y1yZjWwCZWNGDprpllFjxtOELW4=;
 b=hyS4fmmZPbHLeB81VCEUDxctxoQnxNnejZVkK569XSBoOynb1S6r6dEfIwumB51VBj20vpp+53jFc1QgISQj1esnSt0nljQAExwYTBchcZcqHrLwBsTogc/TjWQsjXX9fbZbAO5BV3z2IPSZjQsv5BaG6BSRx23oJfLcpLB2KRFTiv4dwnaV8dh4IMREFvJBdK31M6xCBw7zkMp+W39hkIv9WxZpy29cip0QlRPb5ePC6gnDmQTm0qyk3G9Mb+akgRUo0ZFUeNZpbcGs+X118/Cswa2Qc0u8NstIBSJgTPSzwfAd0UpRsOXsB7YLnPhp85GBUyVgRwJDurcwXMk4/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tJm3QcmXy0S8Y5P3Y1yZjWwCZWNGDprpllFjxtOELW4=;
 b=F/SvCtilhvXwC5IeXODwSSHJD1j5bcfjwvtYs9V3pwtKJ4AxwEo51EoCGscZYWYak6qDpodldhcUkgNxX+T3VNK1d6K2stDU4qwCYkoJTfT04fidlNr5CVyoI1+grfZAs1i7/qE4wR2n8Uo1uLz2NTZvvjThwM0vFgaMxWJQdVM=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB3408.eurprd05.prod.outlook.com (2603:10a6:802:1e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.18; Sat, 30 May
 2020 04:27:09 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3045.018; Sat, 30 May 2020
 04:27:09 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 10/15] net/mlx5: cmd: Fix memset with byte count warning
Date:   Fri, 29 May 2020 21:26:21 -0700
Message-Id: <20200530042626.15837-11-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200530042626.15837-1-saeedm@mellanox.com>
References: <20200530042626.15837-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR05CA0004.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::17) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR05CA0004.namprd05.prod.outlook.com (2603:10b6:a03:c0::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.7 via Frontend Transport; Sat, 30 May 2020 04:27:07 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: b4c711c4-da66-499f-4b17-08d80451b76d
X-MS-TrafficTypeDiagnostic: VI1PR05MB3408:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB340898508E83803AEC387DECBE8C0@VI1PR05MB3408.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:480;
X-Forefront-PRVS: 041963B986
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Bn6TOyQ1lO0hPiUkw9MavydAfPpGvre/I9cY4k2uMVZqViGX9pqN0cKBKf2RIF5ix+2XZrXXyZUqi/cuZFYN6S7UHUrEEWpPpoPBcaizWFacOkxFtr8JZqK9uNwOMaJXNxhMrQCfPkb8rJ+jHEZSXnrvQeKvubQQh0fNDrRmzdZ7fLzUe4oi0jzE9qY/hPv+07ahrxLpnXYhKFsjAYrCR8mCO50SfzzOhttC2RiVtZ3MByDKaAX7el+LZi52URhfJwHM2h+466cK9iLbBZ3yoXWQskp43XxspxMAmCGDLqp9xdEaF+9yWOK0d1jhGLXWzvsEpOq24TLwRgaoKxs8zx5C6mDecyFR3PcquBuRKma4wIseG16UZOwE6adz+Q6B
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(376002)(396003)(136003)(346002)(366004)(52116002)(5660300002)(6666004)(107886003)(186003)(66476007)(26005)(16526019)(66946007)(478600001)(1076003)(8676002)(4326008)(6486002)(66556008)(2906002)(956004)(86362001)(6512007)(83380400001)(316002)(6506007)(36756003)(2616005)(8936002)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: p4P3cVqa0oJFXfLz+q5doTUMV30jrZSkbz+r+ZTJQjw/w27uk4fU7OjJFc8cBv6lvCwriSPo6wrow01RnlMLKVEDDQ4737zSDN7enlengiy5xXNjlyR7L5sXuFWjY3YwDI35dMzZtNYn3TQEGk3a4dR8HdAAHXCUl3CDoImpfxu4z3Zejurf+PMgCbvfKoy1uDkfEce8GRTCZL1LPJrGBbT7jw7aTwDWJBkCUXu3HaQ0GlweiR0Te1ue6d/S19LarLire/uQ6yYUJC119XSe5F8sss8hWewsalj3Xxwc10JwfQXlRouFoFaLaQpi1z91eiDa0MGJBsk5qApgbsVfvTXLk9+9Ir+n0guNKtkxhCzsUJDXffWlZGl1ZEDv58IXJmcE5BYz53UuHUADWaJ9TRX9/+0PRHJY82+e6loqoRSqeJrkkRFBevTmpd7tq76UqH5zTDJU83gpPf4hQHBEGfpzr1bbzIwvkPVF+Q7pI/M=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b4c711c4-da66-499f-4b17-08d80451b76d
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2020 04:27:09.1539
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FjMq7iN+iH9bFeZE1IQ6qk9wrWNYzxMUnVKTBKD7i7BrISx8g/rtJ7WWGPFxYpDRCe84BuPgAkhUcCkZji3ZfA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB3408
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix sparse warning:
drivers/net/ethernet/mellanox/mlx5/core/cmd.c:1949:15:
warning: memset with byte count of 271720

mlx5_cmd_stats array is too big to be held inline in mlx5_cmd.
Allocate it separately.

Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c | 20 +++++++++++++------
 .../net/ethernet/mellanox/mlx5/core/debugfs.c |  2 +-
 include/linux/mlx5/driver.h                   |  2 +-
 3 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
index eca159e8e123b..1d91a0d0ab1d7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
@@ -1072,7 +1072,7 @@ static int mlx5_cmd_invoke(struct mlx5_core_dev *dev, struct mlx5_cmd_msg *in,
 
 	ds = ent->ts2 - ent->ts1;
 	op = MLX5_GET(mbox_in, in->first.data, opcode);
-	if (op < ARRAY_SIZE(cmd->stats)) {
+	if (op < MLX5_CMD_OP_MAX) {
 		stats = &cmd->stats[op];
 		spin_lock_irq(&stats->lock);
 		stats->sum += ds;
@@ -1551,7 +1551,7 @@ static void mlx5_cmd_comp_handler(struct mlx5_core_dev *dev, u64 vec, bool force
 
 			if (ent->callback) {
 				ds = ent->ts2 - ent->ts1;
-				if (ent->op < ARRAY_SIZE(cmd->stats)) {
+				if (ent->op < MLX5_CMD_OP_MAX) {
 					stats = &cmd->stats[ent->op];
 					spin_lock_irqsave(&stats->lock, flags);
 					stats->sum += ds;
@@ -1960,10 +1960,16 @@ int mlx5_cmd_init(struct mlx5_core_dev *dev)
 		return -EINVAL;
 	}
 
-	cmd->pool = dma_pool_create("mlx5_cmd", dev->device, size, align, 0);
-	if (!cmd->pool)
+	cmd->stats = kvzalloc(MLX5_CMD_OP_MAX * sizeof(*cmd->stats), GFP_KERNEL);
+	if (!cmd->stats)
 		return -ENOMEM;
 
+	cmd->pool = dma_pool_create("mlx5_cmd", dev->device, size, align, 0);
+	if (!cmd->pool) {
+		err = -ENOMEM;
+		goto dma_pool_err;
+	}
+
 	err = alloc_cmd_page(dev, cmd);
 	if (err)
 		goto err_free_pool;
@@ -1999,7 +2005,7 @@ int mlx5_cmd_init(struct mlx5_core_dev *dev)
 
 	spin_lock_init(&cmd->alloc_lock);
 	spin_lock_init(&cmd->token_lock);
-	for (i = 0; i < ARRAY_SIZE(cmd->stats); i++)
+	for (i = 0; i < MLX5_CMD_OP_MAX; i++)
 		spin_lock_init(&cmd->stats[i].lock);
 
 	sema_init(&cmd->sem, cmd->max_reg_cmds);
@@ -2046,7 +2052,8 @@ int mlx5_cmd_init(struct mlx5_core_dev *dev)
 
 err_free_pool:
 	dma_pool_destroy(cmd->pool);
-
+dma_pool_err:
+	kvfree(cmd->stats);
 	return err;
 }
 EXPORT_SYMBOL(mlx5_cmd_init);
@@ -2060,6 +2067,7 @@ void mlx5_cmd_cleanup(struct mlx5_core_dev *dev)
 	destroy_msg_cache(dev);
 	free_cmd_page(dev, cmd);
 	dma_pool_destroy(cmd->pool);
+	kvfree(cmd->stats);
 }
 EXPORT_SYMBOL(mlx5_cmd_cleanup);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/debugfs.c b/drivers/net/ethernet/mellanox/mlx5/core/debugfs.c
index d2d57213511be..07c8d9811bc81 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/debugfs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/debugfs.c
@@ -171,7 +171,7 @@ void mlx5_cmdif_debugfs_init(struct mlx5_core_dev *dev)
 	cmd = &dev->priv.cmdif_debugfs;
 	*cmd = debugfs_create_dir("commands", dev->priv.dbg_root);
 
-	for (i = 0; i < ARRAY_SIZE(dev->cmd.stats); i++) {
+	for (i = 0; i < MLX5_CMD_OP_MAX; i++) {
 		stats = &dev->cmd.stats[i];
 		namep = mlx5_command_str(i);
 		if (strcmp(namep, "unknown command opcode")) {
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 6aa6bbd60559b..13c0e4556eda9 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -298,7 +298,7 @@ struct mlx5_cmd {
 	struct mlx5_cmd_debug dbg;
 	struct cmd_msg_cache cache[MLX5_NUM_COMMAND_CACHES];
 	int checksum_disabled;
-	struct mlx5_cmd_stats stats[MLX5_CMD_OP_MAX];
+	struct mlx5_cmd_stats *stats;
 };
 
 struct mlx5_port_caps {
-- 
2.26.2

