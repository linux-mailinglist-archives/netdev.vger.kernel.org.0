Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5742159C4D
	for <lists+netdev@lfdr.de>; Tue, 11 Feb 2020 23:36:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727691AbgBKWgE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Feb 2020 17:36:04 -0500
Received: from mail-eopbgr130042.outbound.protection.outlook.com ([40.107.13.42]:49622
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727569AbgBKWgD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 Feb 2020 17:36:03 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N3oeqlPJ/dPW+R0+cP+Cf1TuJkJWuZypfNb/pUxFQAIwqGdzFEebn7UuAwbVe/nmsPPnoPIvC6HXqtFM8HNcDPeDMKRVXRar7Po9ddwRW6FwGHRScxENrwNhMwdISQoGdCWAtJV6xT+z7pUqADjkJQ2UrKBWDKxK/wxOvPNQlg3OIxjbMA2j9B0IA3ljGhP/HGvEVVtKRy7PIx91iaAeajakUJ44qdvd1Y6lA6e0dCPAdNnlQA5+s2PcUjX/e502mFNJ8x9WdcqkOKXIzuvDm1VXs/yLqO1THLS0Dm2VHDLS9WVQ8Ou9fD9WMMJT/RUJcftt8Fn3uXVwg7zWokVV7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oewV47ZMmSSqIE5Ps7S+5iCtn61CMJhCem974Vfzvi8=;
 b=ZtjrVCoPHy2QuMaBfuynfBHeME/wFr73vPAzv6/ZAPQbtc6uhVFlPGQQ80Hj/BLgJnrvzvPs/jCdhIhQAyxVZjP5TuKwpPnxxolrhy5T+1hCJyEQfCm5jLguXfyO3mmH46lvTqAT7Ih1u86USxQLS3eTZ3kgMQEq/tyXAaanLn34rjngc/FXbcxrO/Mq3EWutDpUop+opI9GUojDWY158bXClTc9iUH4YuDnbjIGRBwLA0YSAkDIbU65m5HQ9qDJhozh7+owjnaSP2gv+q7Xfw1JluN/8JfeJdiOeuQx6DJaUOMzaQIicwLh11GNGRDK+ikRxT4n5u8A237RsbA0mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oewV47ZMmSSqIE5Ps7S+5iCtn61CMJhCem974Vfzvi8=;
 b=STlBXJVmUSYhu7jcCLsUhhV0D5rIZhB1NwC0FBvPAjEigmzLWvUcgPJpnojy3flBgIyE4R8c+e/tTQ0giDcrOj0hLcvT0xuvuZJtZqHv+4v2PayO7Oz+TpYosCbm/v/jRKSC44P2YDVzTmd+JHIKL9AowuRGClhsfpju6wWxvhw=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4383.eurprd05.prod.outlook.com (52.133.14.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2707.23; Tue, 11 Feb 2020 22:35:41 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2707.030; Tue, 11 Feb 2020
 22:35:41 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Aya Levin <ayal@mellanox.com>,
        Moshe Shemesh <moshe@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next V3 02/13] net/mlx5: Add support for resource dump
Date:   Tue, 11 Feb 2020 14:32:43 -0800
Message-Id: <20200211223254.101641-3-saeedm@mellanox.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200211223254.101641-1-saeedm@mellanox.com>
References: <20200211223254.101641-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR08CA0001.namprd08.prod.outlook.com
 (2603:10b6:a03:100::14) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
Received: from smtp.office365.com (209.116.155.178) by BYAPR08CA0001.namprd08.prod.outlook.com (2603:10b6:a03:100::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2707.21 via Frontend Transport; Tue, 11 Feb 2020 22:35:39 +0000
X-Mailer: git-send-email 2.24.1
X-Originating-IP: [209.116.155.178]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 0c6a4ec9-b18b-4373-d9e0-08d7af42b987
X-MS-TrafficTypeDiagnostic: VI1PR05MB4383:|VI1PR05MB4383:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB4383B9A3DBD5DDF7896A1A5ABE180@VI1PR05MB4383.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1332;
X-Forefront-PRVS: 0310C78181
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(396003)(376002)(136003)(39860400002)(346002)(189003)(199004)(110136005)(36756003)(5660300002)(478600001)(6666004)(81156014)(6512007)(54906003)(1076003)(8936002)(2616005)(8676002)(81166006)(956004)(2906002)(6506007)(30864003)(316002)(4326008)(66476007)(66556008)(52116002)(107886003)(6486002)(86362001)(66946007)(16526019)(26005)(186003)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4383;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: p8JzPkTJ41/6Fqi/niGd1b+FqdOl3YdHeZITE6LVkHulPKceT86WW+yHZ4Nb2NiYGaZJRyCRBMl38XXilvZguQP/lg2xKlx2S8uzR+oyX8xcJcel2v8XGbpOlSoFF6dVz/CPjg4A4C4S5wwhuT/jIrfJHjKUB4aU8qcl2McpszWEqF7OqI+wCwHT5WtswC0Pj62WHBEK63VEXkVT0fQYuAxpcdHqUhYYk+uoRf0p9jFiSGXbtWuf4qYiA3aGzHUd4yVHrHdejqsRyXXcMIKx79zW6czgmyO31FtFyWSjhOiF88zRhIPsjty01eooLbsxJCKC+rH9Wjfg7LJSvcQrOme1jGcvjJNOkvW93qg5Fe7MEcqj/jqc9UzIApcK0wJv+2xQheOFuzbHvOpBVsZkbe2eH+0t+y6HydpZJGwjkAx+4OggxN3VrSNW86STeeRb8IvQSm3ME1RVq/aPat5kbk3YFbWfF99cWCA9UZXZZfOgGQUDM6+ezYGuMrpzC76Lh+q7FqAIsk2sVJpep3cj5/NClOrJsAKN3CG6NMaNfFU=
X-MS-Exchange-AntiSpam-MessageData: KY0trutaQ2hUTg9wyFASrWtks7FKKXeCtLuwhe9NyeiFdHtK7gUrjWLcfF+GCQqgMJsVzf2t1vCPjHHLd0ZbBTS7x8g+PWeLkKPK1Jnhfd4B1JnY1ZNn+6p34YD1GPQrs7lbMUli+dk3qIXDXjTbAg==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c6a4ec9-b18b-4373-d9e0-08d7af42b987
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2020 22:35:41.3623
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sQqnEB7aYM7UPG24r0ytZxOAonnp5LIJusY/3riydfN+ULf+WqW5C/RyJTVAD86rEJTcbkn9fOc9BcpzoqfQWw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4383
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>

On driver load:
- Initialize resource dump data structure and memory access tools (mkey
  & pd).
- Read the resource dump's menu which contains the FW segment
  identifier. Each record is identified by the segment name (ASCII).

During the driver's course of life, users (like reporters) may request
dumps per segment. The user should create a command providing the
segment identifier (SW enumeration) and command keys. In return, the
user receives a command context. In order to receive the dump, the user
should supply the command context and a memory (aligned to a PAGE) on
which the dump content will be written. Since the dump may be larger
than the given memory, the user may resubmit the command until received
an indication of end-of-dump. It is the user's responsibility to destroy
the command.

Signed-off-by: Aya Levin <ayal@mellanox.com>
Reviewed-by: Moshe Shemesh <moshe@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/Makefile  |   2 +-
 .../mellanox/mlx5/core/diag/rsc_dump.c        | 286 ++++++++++++++++++
 .../mellanox/mlx5/core/diag/rsc_dump.h        |  58 ++++
 .../net/ethernet/mellanox/mlx5/core/main.c    |  12 +
 include/linux/mlx5/driver.h                   |   1 +
 5 files changed, 358 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/diag/rsc_dump.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/diag/rsc_dump.h

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
index d3e06cec8317..e0bb8e12356e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -16,7 +16,7 @@ mlx5_core-y :=	main.o cmd.o debugfs.o fw.o eq.o uar.o pagealloc.o \
 		transobj.o vport.o sriov.o fs_cmd.o fs_core.o pci_irq.o \
 		fs_counters.o rl.o lag.o dev.o events.o wq.o lib/gid.o \
 		lib/devcom.o lib/pci_vsc.o lib/dm.o diag/fs_tracepoint.o \
-		diag/fw_tracer.o diag/crdump.o devlink.o
+		diag/fw_tracer.o diag/crdump.o devlink.o diag/rsc_dump.o
 
 #
 # Netdev basic
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/diag/rsc_dump.c b/drivers/net/ethernet/mellanox/mlx5/core/diag/rsc_dump.c
new file mode 100644
index 000000000000..17ab7efe693d
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/diag/rsc_dump.c
@@ -0,0 +1,286 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+/* Copyright (c) 2019 Mellanox Technologies. */
+
+#include "rsc_dump.h"
+#include "lib/mlx5.h"
+
+#define MLX5_SGMT_TYPE(SGMT) MLX5_SGMT_TYPE_##SGMT
+#define MLX5_SGMT_STR_ASSING(SGMT)[MLX5_SGMT_TYPE(SGMT)] = #SGMT
+static const char *const mlx5_rsc_sgmt_name[] = {
+	MLX5_SGMT_STR_ASSING(HW_CQPC),
+	MLX5_SGMT_STR_ASSING(HW_SQPC),
+	MLX5_SGMT_STR_ASSING(HW_RQPC),
+	MLX5_SGMT_STR_ASSING(FULL_SRQC),
+	MLX5_SGMT_STR_ASSING(FULL_CQC),
+	MLX5_SGMT_STR_ASSING(FULL_EQC),
+	MLX5_SGMT_STR_ASSING(FULL_QPC),
+	MLX5_SGMT_STR_ASSING(SND_BUFF),
+	MLX5_SGMT_STR_ASSING(RCV_BUFF),
+	MLX5_SGMT_STR_ASSING(SRQ_BUFF),
+	MLX5_SGMT_STR_ASSING(CQ_BUFF),
+	MLX5_SGMT_STR_ASSING(EQ_BUFF),
+	MLX5_SGMT_STR_ASSING(SX_SLICE),
+	MLX5_SGMT_STR_ASSING(SX_SLICE_ALL),
+	MLX5_SGMT_STR_ASSING(RDB),
+	MLX5_SGMT_STR_ASSING(RX_SLICE_ALL),
+};
+
+struct mlx5_rsc_dump {
+	u32 pdn;
+	struct mlx5_core_mkey mkey;
+	u16 fw_segment_type[MLX5_SGMT_TYPE_NUM];
+};
+
+struct mlx5_rsc_dump_cmd {
+	u64 mem_size;
+	u8 cmd[MLX5_ST_SZ_BYTES(resource_dump)];
+};
+
+static int mlx5_rsc_dump_sgmt_get_by_name(char *name)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(mlx5_rsc_sgmt_name); i++)
+		if (!strcmp(name, mlx5_rsc_sgmt_name[i]))
+			return i;
+
+	return -EINVAL;
+}
+
+static void mlx5_rsc_dump_read_menu_sgmt(struct mlx5_rsc_dump *rsc_dump, struct page *page)
+{
+	void *data = page_address(page);
+	enum mlx5_sgmt_type sgmt_idx;
+	int num_of_items;
+	char *sgmt_name;
+	void *member;
+	void *menu;
+	int i;
+
+	menu = MLX5_ADDR_OF(menu_resource_dump_response, data, menu);
+	num_of_items = MLX5_GET(resource_dump_menu_segment, menu, num_of_records);
+
+	for (i = 0; i < num_of_items; i++) {
+		member = MLX5_ADDR_OF(resource_dump_menu_segment, menu, record[i]);
+		sgmt_name =  MLX5_ADDR_OF(resource_dump_menu_record, member, segment_name);
+		sgmt_idx = mlx5_rsc_dump_sgmt_get_by_name(sgmt_name);
+		if (sgmt_idx == -EINVAL)
+			continue;
+		rsc_dump->fw_segment_type[sgmt_idx] = MLX5_GET(resource_dump_menu_record,
+							       member, segment_type);
+	}
+}
+
+static int mlx5_rsc_dump_trigger(struct mlx5_core_dev *dev, struct mlx5_rsc_dump_cmd *cmd,
+				 struct page *page)
+{
+	struct mlx5_rsc_dump *rsc_dump = dev->rsc_dump;
+	struct device *ddev = &dev->pdev->dev;
+	u32 out_seq_num;
+	u32 in_seq_num;
+	dma_addr_t dma;
+	int err;
+
+	dma = dma_map_page(ddev, page, 0, cmd->mem_size, DMA_FROM_DEVICE);
+	if (unlikely(dma_mapping_error(ddev, dma)))
+		return -ENOMEM;
+
+	in_seq_num = MLX5_GET(resource_dump, cmd->cmd, seq_num);
+	MLX5_SET(resource_dump, cmd->cmd, mkey, rsc_dump->mkey.key);
+	MLX5_SET64(resource_dump, cmd->cmd, address, dma);
+
+	err = mlx5_core_access_reg(dev, cmd->cmd, sizeof(cmd->cmd), cmd->cmd,
+				   sizeof(cmd->cmd), MLX5_REG_RESOURCE_DUMP, 0, 1);
+	if (err) {
+		mlx5_core_err(dev, "Resource dump: Failed to access err %d\n", err);
+		goto out;
+	}
+	out_seq_num = MLX5_GET(resource_dump, cmd->cmd, seq_num);
+	if (out_seq_num && (in_seq_num + 1 != out_seq_num))
+		err = -EIO;
+out:
+	dma_unmap_page(ddev, dma, cmd->mem_size, DMA_FROM_DEVICE);
+	return err;
+}
+
+struct mlx5_rsc_dump_cmd *mlx5_rsc_dump_cmd_create(struct mlx5_core_dev *dev,
+						   struct mlx5_rsc_key *key)
+{
+	struct mlx5_rsc_dump_cmd *cmd;
+	int sgmt_type;
+
+	if (IS_ERR_OR_NULL(dev->rsc_dump))
+		return ERR_PTR(-EOPNOTSUPP);
+
+	sgmt_type = dev->rsc_dump->fw_segment_type[key->rsc];
+	if (!sgmt_type && key->rsc != MLX5_SGMT_TYPE_MENU)
+		return ERR_PTR(-EOPNOTSUPP);
+
+	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
+	if (!cmd) {
+		mlx5_core_err(dev, "Resource dump: Failed to allocate command\n");
+		return ERR_PTR(-ENOMEM);
+	}
+	MLX5_SET(resource_dump, cmd->cmd, segment_type, sgmt_type);
+	MLX5_SET(resource_dump, cmd->cmd, index1, key->index1);
+	MLX5_SET(resource_dump, cmd->cmd, index2, key->index2);
+	MLX5_SET(resource_dump, cmd->cmd, num_of_obj1, key->num_of_obj1);
+	MLX5_SET(resource_dump, cmd->cmd, num_of_obj2, key->num_of_obj2);
+	MLX5_SET(resource_dump, cmd->cmd, size, key->size);
+	cmd->mem_size = key->size;
+	return cmd;
+}
+
+void mlx5_rsc_dump_cmd_destroy(struct mlx5_rsc_dump_cmd *cmd)
+{
+	kfree(cmd);
+}
+
+int mlx5_rsc_dump_next(struct mlx5_core_dev *dev, struct mlx5_rsc_dump_cmd *cmd,
+		       struct page *page, int *size)
+{
+	bool more_dump;
+	int err;
+
+	if (IS_ERR_OR_NULL(dev->rsc_dump))
+		return -EOPNOTSUPP;
+
+	err = mlx5_rsc_dump_trigger(dev, cmd, page);
+	if (err) {
+		mlx5_core_err(dev, "Resource dump: Failed to trigger dump, %d\n", err);
+		return err;
+	}
+	*size = MLX5_GET(resource_dump, cmd->cmd, size);
+	more_dump = MLX5_GET(resource_dump, cmd->cmd, more_dump);
+
+	return more_dump;
+}
+
+#define MLX5_RSC_DUMP_MENU_SEGMENT 0xffff
+static int mlx5_rsc_dump_menu(struct mlx5_core_dev *dev)
+{
+	struct mlx5_rsc_dump_cmd *cmd = NULL;
+	struct mlx5_rsc_key key = {};
+	struct page *page;
+	int size;
+	int err;
+
+	page = alloc_page(GFP_KERNEL);
+	if (!page)
+		return -ENOMEM;
+
+	key.rsc = MLX5_SGMT_TYPE_MENU;
+	key.size = PAGE_SIZE;
+	cmd  = mlx5_rsc_dump_cmd_create(dev, &key);
+	if (IS_ERR(cmd)) {
+		err = PTR_ERR(cmd);
+		goto free_page;
+	}
+	MLX5_SET(resource_dump, cmd->cmd, segment_type, MLX5_RSC_DUMP_MENU_SEGMENT);
+
+	do {
+		err = mlx5_rsc_dump_next(dev, cmd, page, &size);
+		if (err < 0)
+			goto destroy_cmd;
+
+		mlx5_rsc_dump_read_menu_sgmt(dev->rsc_dump, page);
+
+	} while (err > 0);
+
+destroy_cmd:
+	mlx5_rsc_dump_cmd_destroy(cmd);
+free_page:
+	__free_page(page);
+
+	return err;
+}
+
+static int mlx5_rsc_dump_create_mkey(struct mlx5_core_dev *mdev, u32 pdn,
+				     struct mlx5_core_mkey *mkey)
+{
+	int inlen = MLX5_ST_SZ_BYTES(create_mkey_in);
+	void *mkc;
+	u32 *in;
+	int err;
+
+	in = kvzalloc(inlen, GFP_KERNEL);
+	if (!in)
+		return -ENOMEM;
+
+	mkc = MLX5_ADDR_OF(create_mkey_in, in, memory_key_mkey_entry);
+	MLX5_SET(mkc, mkc, access_mode_1_0, MLX5_MKC_ACCESS_MODE_PA);
+	MLX5_SET(mkc, mkc, lw, 1);
+	MLX5_SET(mkc, mkc, lr, 1);
+
+	MLX5_SET(mkc, mkc, pd, pdn);
+	MLX5_SET(mkc, mkc, length64, 1);
+	MLX5_SET(mkc, mkc, qpn, 0xffffff);
+
+	err = mlx5_core_create_mkey(mdev, mkey, in, inlen);
+
+	kvfree(in);
+	return err;
+}
+
+struct mlx5_rsc_dump *mlx5_rsc_dump_create(struct mlx5_core_dev *dev)
+{
+	struct mlx5_rsc_dump *rsc_dump;
+
+	if (!MLX5_CAP_DEBUG(dev, resource_dump)) {
+		mlx5_core_dbg(dev, "Resource dump: capability not present\n");
+		return NULL;
+	}
+	rsc_dump = kzalloc(sizeof(*rsc_dump), GFP_KERNEL);
+	if (!rsc_dump)
+		return ERR_PTR(-ENOMEM);
+
+	return rsc_dump;
+}
+
+void mlx5_rsc_dump_destroy(struct mlx5_core_dev *dev)
+{
+	if (IS_ERR_OR_NULL(dev->rsc_dump))
+		return;
+	kfree(dev->rsc_dump);
+}
+
+int mlx5_rsc_dump_init(struct mlx5_core_dev *dev)
+{
+	struct mlx5_rsc_dump *rsc_dump = dev->rsc_dump;
+	int err;
+
+	if (IS_ERR_OR_NULL(dev->rsc_dump))
+		return 0;
+
+	err = mlx5_core_alloc_pd(dev, &rsc_dump->pdn);
+	if (err) {
+		mlx5_core_warn(dev, "Resource dump: Failed to allocate PD %d\n", err);
+		return err;
+	}
+	err = mlx5_rsc_dump_create_mkey(dev, rsc_dump->pdn, &rsc_dump->mkey);
+	if (err) {
+		mlx5_core_err(dev, "Resource dump: Failed to create mkey, %d\n", err);
+		goto free_pd;
+	}
+	err = mlx5_rsc_dump_menu(dev);
+	if (err) {
+		mlx5_core_err(dev, "Resource dump: Failed to read menu, %d\n", err);
+		goto destroy_mkey;
+	}
+	return err;
+
+destroy_mkey:
+	mlx5_core_destroy_mkey(dev, &rsc_dump->mkey);
+free_pd:
+	mlx5_core_dealloc_pd(dev, rsc_dump->pdn);
+	return err;
+}
+
+void mlx5_rsc_dump_cleanup(struct mlx5_core_dev *dev)
+{
+	if (IS_ERR_OR_NULL(dev->rsc_dump))
+		return;
+
+	mlx5_core_destroy_mkey(dev, &dev->rsc_dump->mkey);
+	mlx5_core_dealloc_pd(dev, dev->rsc_dump->pdn);
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/diag/rsc_dump.h b/drivers/net/ethernet/mellanox/mlx5/core/diag/rsc_dump.h
new file mode 100644
index 000000000000..3b7573461a45
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/diag/rsc_dump.h
@@ -0,0 +1,58 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (c) 2019 Mellanox Technologies. */
+
+#ifndef __MLX5_RSC_DUMP_H
+#define __MLX5_RSC_DUMP__H
+
+#include <linux/mlx5/driver.h>
+#include "mlx5_core.h"
+
+enum mlx5_sgmt_type {
+	MLX5_SGMT_TYPE_HW_CQPC,
+	MLX5_SGMT_TYPE_HW_SQPC,
+	MLX5_SGMT_TYPE_HW_RQPC,
+	MLX5_SGMT_TYPE_FULL_SRQC,
+	MLX5_SGMT_TYPE_FULL_CQC,
+	MLX5_SGMT_TYPE_FULL_EQC,
+	MLX5_SGMT_TYPE_FULL_QPC,
+	MLX5_SGMT_TYPE_SND_BUFF,
+	MLX5_SGMT_TYPE_RCV_BUFF,
+	MLX5_SGMT_TYPE_SRQ_BUFF,
+	MLX5_SGMT_TYPE_CQ_BUFF,
+	MLX5_SGMT_TYPE_EQ_BUFF,
+	MLX5_SGMT_TYPE_SX_SLICE,
+	MLX5_SGMT_TYPE_SX_SLICE_ALL,
+	MLX5_SGMT_TYPE_RDB,
+	MLX5_SGMT_TYPE_RX_SLICE_ALL,
+	MLX5_SGMT_TYPE_MENU,
+	MLX5_SGMT_TYPE_TERMINATE,
+
+	MLX5_SGMT_TYPE_NUM, /* Keep last */
+};
+
+struct mlx5_rsc_key {
+	enum mlx5_sgmt_type rsc;
+	int index1;
+	int index2;
+	int num_of_obj1;
+	int num_of_obj2;
+	int size;
+};
+
+#define MLX5_RSC_DUMP_ALL 0xFFFF
+struct mlx5_rsc_dump_cmd;
+struct mlx5_rsc_dump;
+
+struct mlx5_rsc_dump *mlx5_rsc_dump_create(struct mlx5_core_dev *dev);
+void mlx5_rsc_dump_destroy(struct mlx5_core_dev *dev);
+
+int mlx5_rsc_dump_init(struct mlx5_core_dev *dev);
+void mlx5_rsc_dump_cleanup(struct mlx5_core_dev *dev);
+
+struct mlx5_rsc_dump_cmd *mlx5_rsc_dump_cmd_create(struct mlx5_core_dev *dev,
+						   struct mlx5_rsc_key *key);
+void mlx5_rsc_dump_cmd_destroy(struct mlx5_rsc_dump_cmd *cmd);
+
+int mlx5_rsc_dump_next(struct mlx5_core_dev *dev, struct mlx5_rsc_dump_cmd *cmd,
+		       struct page *page, int *size);
+#endif
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index f554cfddcf4e..204a26bf0a5f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -70,6 +70,7 @@
 #include "diag/fw_tracer.h"
 #include "ecpf.h"
 #include "lib/hv_vhca.h"
+#include "diag/rsc_dump.h"
 
 MODULE_AUTHOR("Eli Cohen <eli@mellanox.com>");
 MODULE_DESCRIPTION("Mellanox 5th generation network adapters (ConnectX series) core driver");
@@ -880,6 +881,7 @@ static int mlx5_init_once(struct mlx5_core_dev *dev)
 
 	dev->tracer = mlx5_fw_tracer_create(dev);
 	dev->hv_vhca = mlx5_hv_vhca_create(dev);
+	dev->rsc_dump = mlx5_rsc_dump_create(dev);
 
 	return 0;
 
@@ -909,6 +911,7 @@ static int mlx5_init_once(struct mlx5_core_dev *dev)
 
 static void mlx5_cleanup_once(struct mlx5_core_dev *dev)
 {
+	mlx5_rsc_dump_destroy(dev);
 	mlx5_hv_vhca_destroy(dev->hv_vhca);
 	mlx5_fw_tracer_destroy(dev->tracer);
 	mlx5_dm_cleanup(dev);
@@ -1079,6 +1082,12 @@ static int mlx5_load(struct mlx5_core_dev *dev)
 
 	mlx5_hv_vhca_init(dev->hv_vhca);
 
+	err = mlx5_rsc_dump_init(dev);
+	if (err) {
+		mlx5_core_err(dev, "Failed to init Resource dump\n");
+		goto err_rsc_dump;
+	}
+
 	err = mlx5_fpga_device_start(dev);
 	if (err) {
 		mlx5_core_err(dev, "fpga device start failed %d\n", err);
@@ -1134,6 +1143,8 @@ static int mlx5_load(struct mlx5_core_dev *dev)
 err_ipsec_start:
 	mlx5_fpga_device_stop(dev);
 err_fpga_start:
+	mlx5_rsc_dump_cleanup(dev);
+err_rsc_dump:
 	mlx5_hv_vhca_cleanup(dev->hv_vhca);
 	mlx5_fw_tracer_cleanup(dev->tracer);
 err_fw_tracer:
@@ -1155,6 +1166,7 @@ static void mlx5_unload(struct mlx5_core_dev *dev)
 	mlx5_accel_ipsec_cleanup(dev);
 	mlx5_accel_tls_cleanup(dev);
 	mlx5_fpga_device_stop(dev);
+	mlx5_rsc_dump_cleanup(dev);
 	mlx5_hv_vhca_cleanup(dev->hv_vhca);
 	mlx5_fw_tracer_cleanup(dev->tracer);
 	mlx5_eq_table_destroy(dev);
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 277a51d3ec40..f99cbe249425 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -722,6 +722,7 @@ struct mlx5_core_dev {
 	struct mlx5_clock        clock;
 	struct mlx5_ib_clock_info  *clock_info;
 	struct mlx5_fw_tracer   *tracer;
+	struct mlx5_rsc_dump    *rsc_dump;
 	u32                      vsc_addr;
 	struct mlx5_hv_vhca	*hv_vhca;
 };
-- 
2.24.1

