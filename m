Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE5E91DF391
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 02:41:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387475AbgEWAlU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 20:41:20 -0400
Received: from mail-eopbgr70075.outbound.protection.outlook.com ([40.107.7.75]:1415
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387463AbgEWAlT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 May 2020 20:41:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b0yAVADK1Wp+aGXQ1UxU2r7fodNJP6mTQE0/gYjZgN/IiOtpGQ59oUJIt9Igdfwb0rcbti2ZFgYP8C36EB64zQmPVC8b5KDny0IuY1yHCrn0SjZAlsquYMbytnJY/fOwy3i6Jxtcdtuy7MJU9IGbg2kGZZvMkGkDKXykHbkhQps7HJbBstjEg/eFnhHgQRNYyaKSTwTYCvGP/NIRCtHVN4TD038Q+jJUOQnJzSIG8reQwIPZK7HtUcpYN0mEiJBOBtm/ezutY8YjWCEQLDFZZJZAPISPKygc15S1yjrtJVqIAV5TyzQ3m5HgLFS1OJvlCfmwxEstSXd71h/pKR6Lyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BdvkKk9xpFGKACiRHmE+HesCTkYg9qyFiVwssAvVy3U=;
 b=WbO2pZSlI6ez5WvHmKi1/IWiGtsFCKxH56eCgVFxJWJFcxbA9KY7V0m0uaaPhNGRwPBxneFjQ6mdkzLLdAUxEKhsymImMDblpmeIZFXUZpMsV2vhMKCE/evjjuvb/Qb5eNXjmAsm5yjEX46B58DMr3ZIVW9Q4qXMamo3nhHEQM2rLZdkgMEWOQIHKwiSdtOfy/hlV3K7dOz5k///TtVgMkXiWEsxEyUUbl9OL23fE3jEfH2SKkMQ4vev2bAVfmLqXHW9I5STCOy+JHyrqEgt1lkAxJfC2Lo3Wbl/x3Aq1eFeck2tK+T9XaeoH/UAG+LiLLUgLJ9Q9fxRLzpjK2Jpag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BdvkKk9xpFGKACiRHmE+HesCTkYg9qyFiVwssAvVy3U=;
 b=O1HCBgIpoEJDqEiFqVPF+jYqugl/qLDQ6Lj1JwCzCyrxaYEO2Tzfv0n/C+3jaMzgpB5pNN5MmXocmnLpv0cyjPlFWa0kQyRsGcLqp3Dze+pdMOYMzBCcTbLiNUXHLQg683TzgsB/gaSPI24L8E40R27IWaXcVuobpompe+m/olM=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB5391.eurprd05.prod.outlook.com (2603:10a6:803:95::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.24; Sat, 23 May
 2020 00:41:11 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3021.026; Sat, 23 May 2020
 00:41:11 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Eran Ben Elisha <eranbe@mellanox.com>,
        Moshe Shemesh <moshe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 02/13] net/mlx5: Fix a race when moving command interface to events mode
Date:   Fri, 22 May 2020 17:40:38 -0700
Message-Id: <20200523004049.34832-3-saeedm@mellanox.com>
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
Received: from smtp.office365.com (73.15.39.150) by BYAPR08CA0042.namprd08.prod.outlook.com (2603:10b6:a03:117::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.23 via Frontend Transport; Sat, 23 May 2020 00:41:09 +0000
X-Mailer: git-send-email 2.25.4
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: a9f1c7c0-da9d-4490-a3f5-08d7feb1fd62
X-MS-TrafficTypeDiagnostic: VI1PR05MB5391:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB53911E8A3F5B86DD4B71E407BEB50@VI1PR05MB5391.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 0412A98A59
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SiQXPtHeVbHrC5QqiaD+c7prA85Gsu9hSLCeQ88guavJPLylh1/ZpC3acMV/mjc8im5TqkuR6PiHKO4viggvF1sRUbfkb8jVhS098TUipslKYNDzM10m54aJ1ZUGoIOtVXCAceKdMhOVPQnuv9NzJRVdU0Kivr+RRgePx4orDQXd2DzL/HhZs4O61pGAZmi+8iLD6v7kPNgSFeAY+/1mB5LYDX2Nxj/wQ3X+i4dEJ0/4WEEBEibaaqkqpCdrIC3CVme4jyKI3nYISbeHHN5Otpxcz535KZ5VxOJtHGX9SrpQJFyGOC2+HRi7FI875i7VN5wBUJu39pbAnQAg1x3/k8sKoC32wFvSEnkGgQv90XNVR/js8Jg6QuKQF/8uzoSd
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(376002)(366004)(396003)(39860400002)(136003)(1076003)(8676002)(2616005)(956004)(4326008)(52116002)(186003)(26005)(16526019)(478600001)(6666004)(86362001)(6506007)(6512007)(107886003)(36756003)(316002)(5660300002)(8936002)(6486002)(66946007)(54906003)(66476007)(2906002)(66556008)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: RVScYtgnj50jvUTqllUScRY/ICQ/9fBM+FWQq3FnZ3ThrrgXlUCLl0J5IV/FRP1Kv8DkNTuFHPbfDvxBqN6YwOTvj9DTJLQ/7AmbU4+A8jAI8bH+Q7KiBGKvFbVm1c4C1fl7tgEkPHxGSDjClEv3eHnuIZ4JlvQN8HH6DUMyRp4QisbfpgmV+q/NkOGaWA0SoqDLFIbcdZkjPGgsdS3kCHQ9wG1Js49mCrC1z3okMDdA53y05YWMH06k5VoKn2bu1CJMtFuMlheA2ij5FtCEUxfH75znH/0DXzVcaB+8tN0ax81KOHcKrVoY3jNYeHVWUQcpughNTO4iu8l62LfZBSQEWk0p6zSZqy8d2UDsZfCcb/qFT1rXQy9nM/yFjRIgRxWEdzZWT6+/scNVERZ89A6Z5XJE6khMsbtxhrK33L4DsrGGiUrYxhW5KoCSAPIIl0NTyArnVi+PlJcMmdhVvDLVOrGuWkQxjHYgafcqC3k=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a9f1c7c0-da9d-4490-a3f5-08d7feb1fd62
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2020 00:41:11.1890
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jiS6zxX/SjPYK1grzdk19lse35a23OurTOpHq9qmtiGn8k/S9M32490PkYaJtEPs4HQTkatBeNe6zIyHglemGw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5391
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eran Ben Elisha <eranbe@mellanox.com>

After driver creates (via FW command) an EQ for commands, the driver will
be informed on new commands completion by EQE. However, due to a race in
driver's internal command mode metadata update, some new commands will
still be miss-handled by driver as if we are in polling mode. Such commands
can get two non forced completion, leading to already freed command entry
access.

CREATE_EQ command, that maps EQ to the command queue must be posted to the
command queue while it is empty and no other command should be posted.

Add SW mechanism that once the CREATE_EQ command is about to be executed,
all other commands will return error without being sent to the FW. Allow
sending other commands only after successfully changing the driver's
internal command mode metadata.
We can safely return error to all other commands while creating the command
EQ, as all other commands might be sent from the user/application during
driver load. Application can rerun them later after driver's load was
finished.

Fixes: e126ba97dba9 ("mlx5: Add driver for Mellanox Connect-IB adapters")
Signed-off-by: Eran Ben Elisha <eranbe@mellanox.com>
Signed-off-by: Moshe Shemesh <moshe@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c | 35 ++++++++++++++++---
 drivers/net/ethernet/mellanox/mlx5/core/eq.c  |  3 ++
 include/linux/mlx5/driver.h                   |  6 ++++
 3 files changed, 40 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
index d695b75bc0af..2f3cafdc3b1f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
@@ -848,6 +848,14 @@ static void free_msg(struct mlx5_core_dev *dev, struct mlx5_cmd_msg *msg);
 static void mlx5_free_cmd_msg(struct mlx5_core_dev *dev,
 			      struct mlx5_cmd_msg *msg);
 
+static bool opcode_allowed(struct mlx5_cmd *cmd, u16 opcode)
+{
+	if (cmd->allowed_opcode == CMD_ALLOWED_OPCODE_ALL)
+		return true;
+
+	return cmd->allowed_opcode == opcode;
+}
+
 static void cmd_work_handler(struct work_struct *work)
 {
 	struct mlx5_cmd_work_ent *ent = container_of(work, struct mlx5_cmd_work_ent, work);
@@ -914,7 +922,8 @@ static void cmd_work_handler(struct work_struct *work)
 
 	/* Skip sending command to fw if internal error */
 	if (pci_channel_offline(dev->pdev) ||
-	    dev->state == MLX5_DEVICE_STATE_INTERNAL_ERROR) {
+	    dev->state == MLX5_DEVICE_STATE_INTERNAL_ERROR ||
+	    !opcode_allowed(&dev->cmd, ent->op)) {
 		u8 status = 0;
 		u32 drv_synd;
 
@@ -1405,6 +1414,22 @@ static void create_debugfs_files(struct mlx5_core_dev *dev)
 	mlx5_cmdif_debugfs_init(dev);
 }
 
+void mlx5_cmd_allowed_opcode(struct mlx5_core_dev *dev, u16 opcode)
+{
+	struct mlx5_cmd *cmd = &dev->cmd;
+	int i;
+
+	for (i = 0; i < cmd->max_reg_cmds; i++)
+		down(&cmd->sem);
+	down(&cmd->pages_sem);
+
+	cmd->allowed_opcode = opcode;
+
+	up(&cmd->pages_sem);
+	for (i = 0; i < cmd->max_reg_cmds; i++)
+		up(&cmd->sem);
+}
+
 static void mlx5_cmd_change_mod(struct mlx5_core_dev *dev, int mode)
 {
 	struct mlx5_cmd *cmd = &dev->cmd;
@@ -1681,12 +1706,13 @@ static int cmd_exec(struct mlx5_core_dev *dev, void *in, int in_size, void *out,
 	int err;
 	u8 status = 0;
 	u32 drv_synd;
+	u16 opcode;
 	u8 token;
 
+	opcode = MLX5_GET(mbox_in, in, opcode);
 	if (pci_channel_offline(dev->pdev) ||
-	    dev->state == MLX5_DEVICE_STATE_INTERNAL_ERROR) {
-		u16 opcode = MLX5_GET(mbox_in, in, opcode);
-
+	    dev->state == MLX5_DEVICE_STATE_INTERNAL_ERROR ||
+	    !opcode_allowed(&dev->cmd, opcode)) {
 		err = mlx5_internal_err_ret_value(dev, opcode, &drv_synd, &status);
 		MLX5_SET(mbox_out, out, status, status);
 		MLX5_SET(mbox_out, out, syndrome, drv_synd);
@@ -1988,6 +2014,7 @@ int mlx5_cmd_init(struct mlx5_core_dev *dev)
 	mlx5_core_dbg(dev, "descriptor at dma 0x%llx\n", (unsigned long long)(cmd->dma));
 
 	cmd->mode = CMD_MODE_POLLING;
+	cmd->allowed_opcode = CMD_ALLOWED_OPCODE_ALL;
 
 	create_msg_cache(dev);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eq.c b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
index cccea3a8eddd..ce6c621af043 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
@@ -611,11 +611,13 @@ static int create_async_eqs(struct mlx5_core_dev *dev)
 		.nent = MLX5_NUM_CMD_EQE,
 		.mask[0] = 1ull << MLX5_EVENT_TYPE_CMD,
 	};
+	mlx5_cmd_allowed_opcode(dev, MLX5_CMD_OP_CREATE_EQ);
 	err = setup_async_eq(dev, &table->cmd_eq, &param, "cmd");
 	if (err)
 		goto err1;
 
 	mlx5_cmd_use_events(dev);
+	mlx5_cmd_allowed_opcode(dev, CMD_ALLOWED_OPCODE_ALL);
 
 	param = (struct mlx5_eq_param) {
 		.irq_index = 0,
@@ -645,6 +647,7 @@ static int create_async_eqs(struct mlx5_core_dev *dev)
 	mlx5_cmd_use_polling(dev);
 	cleanup_async_eq(dev, &table->cmd_eq, "cmd");
 err1:
+	mlx5_cmd_allowed_opcode(dev, CMD_ALLOWED_OPCODE_ALL);
 	mlx5_eq_notifier_unregister(dev, &table->cq_err_nb);
 	return err;
 }
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 9b1f29f26c27..c03778c75dfa 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -284,6 +284,7 @@ struct mlx5_cmd {
 	struct semaphore sem;
 	struct semaphore pages_sem;
 	int	mode;
+	u16     allowed_opcode;
 	struct mlx5_cmd_work_ent *ent_arr[MLX5_MAX_COMMANDS];
 	struct dma_pool *pool;
 	struct mlx5_cmd_debug dbg;
@@ -875,10 +876,15 @@ mlx5_frag_buf_get_idx_last_contig_stride(struct mlx5_frag_buf_ctrl *fbc, u32 ix)
 	return min_t(u32, last_frag_stride_idx - fbc->strides_offset, fbc->sz_m1);
 }
 
+enum {
+	CMD_ALLOWED_OPCODE_ALL,
+};
+
 int mlx5_cmd_init(struct mlx5_core_dev *dev);
 void mlx5_cmd_cleanup(struct mlx5_core_dev *dev);
 void mlx5_cmd_use_events(struct mlx5_core_dev *dev);
 void mlx5_cmd_use_polling(struct mlx5_core_dev *dev);
+void mlx5_cmd_allowed_opcode(struct mlx5_core_dev *dev, u16 opcode);
 
 struct mlx5_async_ctx {
 	struct mlx5_core_dev *dev;
-- 
2.25.4

