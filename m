Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D40F1DF392
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 02:41:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387481AbgEWAlY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 20:41:24 -0400
Received: from mail-eopbgr70075.outbound.protection.outlook.com ([40.107.7.75]:1415
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387465AbgEWAlX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 May 2020 20:41:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F/m4dsQXfYAHtciDqIPHB3/sF51kSqqFI8YHVRUc7jb0eAJoo5Cbxv0dSmAEB9wHQWxsbfWODiPsrsqqOHu/h0leDU7/jtjilugOWW5o5cQQ+Q7fXqNuhiNHuXVKEX3EKc7/XXixLIzvplzZrITPg6i4II9Ps3HiFRppRM8jn3dlrGaIawdBMWIWCBt7+M9y1sR8x8YqTQvzEPzRrevtCwOLV5yCfNnh/NsFuwOA6gw1D/ZhptLqsRAPFa/0gyjtig8HrFLEUepVj02VR1YmEYWhQ6IsDwv+96PsoquCgq3kYFxS3e1+S1ZPKfmwBCRjR14nM22sYHEY4esFBiHXGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JO2RtBPSUpQciy4VF2zBGLdOCSrMW1ZmdW7DKjt4YFw=;
 b=nWmQRSxU+vQjeo9Q8uJmNMers5eN8DzpOAvFhG+zWXYajbi+T9/hJJV7s6hx5H1BdRvsH5t1TOr5u5QfBlCiOkVozPSD3LG0LEeaoqyhyimwxYg5q4PMsr1+xYAuTtDWdKVt0wAU+o7A5zVmrFqsljKdzx19P+1yWjZHugLCtm4c9tIRV9HhoubbP/TjrW8ur2EWHZrwOPk04sjiryq9cCU5XIEPhm8wlnW8iF3f8kLB/i0D6u6uO+qjAuZ0+8JesQq4NxBVX9N3wtvpOgElw4zvn0gsOYfHZG8PCsAQky5Xj5bphy9aeE/HwTub0hTgxCiSAz0YjdLimYqDeZxNOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JO2RtBPSUpQciy4VF2zBGLdOCSrMW1ZmdW7DKjt4YFw=;
 b=fbak5FMSvINgNCp/jq0HV22ReLF2bRM/NtXH7zdUsO3aPHWSNTzcm+Iwgj6m8KiwMcaMY4Xxjhsdib8T5GZUWvgmW6b+fnErhDwsOihaWoPuYG0Tfc+mneUxdyDYvNfXSa03SB6kBBoooohwNbVoDRJyr8XpkRBxMJE4xUeguak=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB5391.eurprd05.prod.outlook.com (2603:10a6:803:95::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.24; Sat, 23 May
 2020 00:41:13 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3021.026; Sat, 23 May 2020
 00:41:13 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Eran Ben Elisha <eranbe@mellanox.com>,
        Moshe Shemesh <moshe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 03/13] net/mlx5: Avoid processing commands before cmdif is ready
Date:   Fri, 22 May 2020 17:40:39 -0700
Message-Id: <20200523004049.34832-4-saeedm@mellanox.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200523004049.34832-1-saeedm@mellanox.com>
References: <20200523004049.34832-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR08CA0042.namprd08.prod.outlook.com
 (2603:10b6:a03:117::19) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR08CA0042.namprd08.prod.outlook.com (2603:10b6:a03:117::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.23 via Frontend Transport; Sat, 23 May 2020 00:41:11 +0000
X-Mailer: git-send-email 2.25.4
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 1df9311f-b636-4057-3628-08d7feb1feaa
X-MS-TrafficTypeDiagnostic: VI1PR05MB5391:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB5391B2AC2970AED99754D901BEB50@VI1PR05MB5391.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:337;
X-Forefront-PRVS: 0412A98A59
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: I/2QhBmgnVwzLzxgA9a9kPQUjWU9nlvDMc18LMSkqCHmc5vK3PA4Bsu6ZZCCjQzPV5hwNCQiEZ9QzqIcJSdAsVSpzH4AU6h9ArSzTyE4YJiAxoSmf0ewojJhP5ycB6SPK0bVRh+SaZueq+6iJbFXYTz4Lmjr3tntFFP2jdhh4O1Zpy+0o0D649jOzifh/C9PExYtUx9Rl2ww1diNRO9hNitaLUB2IPEjLoCKZ6RRikCpDKfW+Th848ufjEUu/zI6DwPjEgpZZE5yJf+WLoDmtXY7ImvZvOYi1LTXQLDDdu5EYyBWEIyHNqMwbMdkzOh1nvmEh8tnI0f6MhMRn8/BFX6TB9CWaPmeu8WtkqynQPX0KmZh1jqvEoajHjvrqbne
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(376002)(366004)(396003)(39860400002)(136003)(1076003)(8676002)(2616005)(956004)(4326008)(52116002)(186003)(26005)(16526019)(478600001)(6666004)(86362001)(6506007)(6512007)(107886003)(36756003)(316002)(5660300002)(8936002)(6486002)(66946007)(54906003)(66476007)(2906002)(66556008)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: hOuGB9nADQDGCpBzahH7Ws9bCP4O/3c39sto/YokMtzVHBCDLhVj9iiRg3Tqxxw3Ymwmr2QxAH2G//k87+bL/DCY8dOekzQcJ2yG+PgJWCSmO4m5nfxLX9ALxlySATrIjldMaLJknlCvd5GpILCwlVg3xZxhJ4sTlWHr3tnHazJVvnp7MO8FC9t/+DMihaO7TkIXEGgKWbKsu/jRqxyfKjwh48KiiteBqc251cB6AIzqybxK+kEijkYVFnaHtQisM23oUmqDzHkSj+7bofsdwJI+pbTVrt2cQc4XKfCtvbrQxYpuqhkTVs63CpR9dyAR6uCFtzeLyMNUFPqsUXEUWk37og3qzlbVD8Tfr1GPFoM2++YpcooqUknZxd7A7HEz0gIU7t4zZx4e00bDFFhMz4x9vJz2zgU4A/zLyUtTBA0B3SyYZ1Mw2tnRSvTyT+iOYdQKQxaBwR7G4CdZMiMypSKPL3UUwtrR5p7/o+9IzSg=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1df9311f-b636-4057-3628-08d7feb1feaa
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2020 00:41:13.4037
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e5aQDusUqT1hVoNKKU7FiI+LTsEvHS/DjaFd8Bv2puPUFvw8F2p+EITPuq2p8SnNcT+lAqMzCM/gpWGZC4B9AQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5391
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eran Ben Elisha <eranbe@mellanox.com>

When driver is reloading during recovery flow, it can't get new commands
till command interface is up again. Otherwise we may get to null pointer
trying to access non initialized command structures.

Add cmdif state to avoid processing commands while cmdif is not ready.

Fixes: e126ba97dba9 ("mlx5: Add driver for Mellanox Connect-IB adapters")
Signed-off-by: Eran Ben Elisha <eranbe@mellanox.com>
Signed-off-by: Moshe Shemesh <moshe@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c  | 10 ++++++++++
 drivers/net/ethernet/mellanox/mlx5/core/main.c |  4 ++++
 include/linux/mlx5/driver.h                    |  9 +++++++++
 3 files changed, 23 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
index 2f3cafdc3b1f..7a77fe40af3a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
@@ -923,6 +923,7 @@ static void cmd_work_handler(struct work_struct *work)
 	/* Skip sending command to fw if internal error */
 	if (pci_channel_offline(dev->pdev) ||
 	    dev->state == MLX5_DEVICE_STATE_INTERNAL_ERROR ||
+	    cmd->state != MLX5_CMDIF_STATE_UP ||
 	    !opcode_allowed(&dev->cmd, ent->op)) {
 		u8 status = 0;
 		u32 drv_synd;
@@ -1712,6 +1713,7 @@ static int cmd_exec(struct mlx5_core_dev *dev, void *in, int in_size, void *out,
 	opcode = MLX5_GET(mbox_in, in, opcode);
 	if (pci_channel_offline(dev->pdev) ||
 	    dev->state == MLX5_DEVICE_STATE_INTERNAL_ERROR ||
+	    dev->cmd.state != MLX5_CMDIF_STATE_UP ||
 	    !opcode_allowed(&dev->cmd, opcode)) {
 		err = mlx5_internal_err_ret_value(dev, opcode, &drv_synd, &status);
 		MLX5_SET(mbox_out, out, status, status);
@@ -1977,6 +1979,7 @@ int mlx5_cmd_init(struct mlx5_core_dev *dev)
 		goto err_free_page;
 	}
 
+	cmd->state = MLX5_CMDIF_STATE_DOWN;
 	cmd->checksum_disabled = 1;
 	cmd->max_reg_cmds = (1 << cmd->log_sz) - 1;
 	cmd->bitmask = (1UL << cmd->max_reg_cmds) - 1;
@@ -2054,3 +2057,10 @@ void mlx5_cmd_cleanup(struct mlx5_core_dev *dev)
 	dma_pool_destroy(cmd->pool);
 }
 EXPORT_SYMBOL(mlx5_cmd_cleanup);
+
+void mlx5_cmd_set_state(struct mlx5_core_dev *dev,
+			enum mlx5_cmdif_state cmdif_state)
+{
+	dev->cmd.state = cmdif_state;
+}
+EXPORT_SYMBOL(mlx5_cmd_set_state);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 7af4210c1b96..a61e473db7e1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -965,6 +965,8 @@ static int mlx5_function_setup(struct mlx5_core_dev *dev, bool boot)
 		goto err_cmd_cleanup;
 	}
 
+	mlx5_cmd_set_state(dev, MLX5_CMDIF_STATE_UP);
+
 	err = mlx5_core_enable_hca(dev, 0);
 	if (err) {
 		mlx5_core_err(dev, "enable hca failed\n");
@@ -1026,6 +1028,7 @@ static int mlx5_function_setup(struct mlx5_core_dev *dev, bool boot)
 err_disable_hca:
 	mlx5_core_disable_hca(dev, 0);
 err_cmd_cleanup:
+	mlx5_cmd_set_state(dev, MLX5_CMDIF_STATE_DOWN);
 	mlx5_cmd_cleanup(dev);
 
 	return err;
@@ -1043,6 +1046,7 @@ static int mlx5_function_teardown(struct mlx5_core_dev *dev, bool boot)
 	}
 	mlx5_reclaim_startup_pages(dev);
 	mlx5_core_disable_hca(dev, 0);
+	mlx5_cmd_set_state(dev, MLX5_CMDIF_STATE_DOWN);
 	mlx5_cmd_cleanup(dev);
 
 	return 0;
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index c03778c75dfa..8397b6558dc7 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -213,6 +213,12 @@ enum mlx5_port_status {
 	MLX5_PORT_DOWN      = 2,
 };
 
+enum mlx5_cmdif_state {
+	MLX5_CMDIF_STATE_UNINITIALIZED,
+	MLX5_CMDIF_STATE_UP,
+	MLX5_CMDIF_STATE_DOWN,
+};
+
 struct mlx5_cmd_first {
 	__be32		data[4];
 };
@@ -258,6 +264,7 @@ struct mlx5_cmd_stats {
 struct mlx5_cmd {
 	struct mlx5_nb    nb;
 
+	enum mlx5_cmdif_state	state;
 	void	       *cmd_alloc_buf;
 	dma_addr_t	alloc_dma;
 	int		alloc_size;
@@ -882,6 +889,8 @@ enum {
 
 int mlx5_cmd_init(struct mlx5_core_dev *dev);
 void mlx5_cmd_cleanup(struct mlx5_core_dev *dev);
+void mlx5_cmd_set_state(struct mlx5_core_dev *dev,
+			enum mlx5_cmdif_state cmdif_state);
 void mlx5_cmd_use_events(struct mlx5_core_dev *dev);
 void mlx5_cmd_use_polling(struct mlx5_core_dev *dev);
 void mlx5_cmd_allowed_opcode(struct mlx5_core_dev *dev, u16 opcode);
-- 
2.25.4

