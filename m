Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F248B1D5C25
	for <lists+netdev@lfdr.de>; Sat, 16 May 2020 00:17:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726707AbgEOWRe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 18:17:34 -0400
Received: from mail-db8eur05on2063.outbound.protection.outlook.com ([40.107.20.63]:6026
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726183AbgEOWRd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 May 2020 18:17:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HQXiEl8RMbyJUKd8ZyRL337gqmmhqmxMM4YmYZhNNkheGAcPrSlYQw4+Mx8QcyGc1CGclf83Dex5MDFW6Ze2995+dc7AzUDa2i7ohx8KAs2xZFbCYuzBQxnj2VArfSjoeVWXRfa7AWrtpdSIKVlplT+ezqIkS+NtjHapKO4Mu4Cr7RovzzvPbcwpoj1wYrOJLozkJvK83pbeW6V3sg5QVGuZ7w0lOS1Z/eiDOXQfCP/MXidBSwa6FdDkfTq/CT2UP1bamNIkPHbZQw4Dhis+h/uh/r3XfLVGjyeV73IUmWozHtDzYeHIYPEBpfVdmFOASYOH/YJ/595bZdecMx1puQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1ApQYwAF5IUuW8ksOhPGHRXYKPre4kgfB8X7NzPmN9s=;
 b=QwDTwIununEp8o2P9p7eyo3m9bylR3WImUNypyT1Gz78vJpwmWPER71b6oBi0YcC9EUdmfJIUfX29/HL0zAEHSLTqqsqKXsFzh2yfD+hgW9H9UHNwZH2AjW2g00CYIYMfkWliTudEs7j+ozuor/eBL5qZRSaObgSNCAcQj5Zp5EGSvht210I2yCM9ldh9TolKP67odiY22BOxATJCCuumxIh00iUuPifu8IACHrYvmf9JG9T9+ahsUuRGuPZP5LrKi9MzTs1tPg66rA+lGUQLqjpO7WaGVppEWko3ymVsYG0EXFUORpkzhCZ7dwUamwAQJPVsEIr+cgcD6+usshfHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1ApQYwAF5IUuW8ksOhPGHRXYKPre4kgfB8X7NzPmN9s=;
 b=DirU09WYALhtIhR+CbijW5q6tUcYf/iW1TVgk2qvloX13XizV4t1hlftSRinYvDoEWUZrY9ZAf2rFfBp0wnqsIp3SRSIHpY7x/1jf3DbPo0PAc67xHUFPIjKzAbR3Ytljc51um0BypPXI4hu5tTuZU2yDOkKOF8CY1lVcFez9Dg=
Authentication-Results: mellanox.com; dkim=none (message not signed)
 header.d=none;mellanox.com; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB4301.eurprd05.prod.outlook.com (2603:10a6:803:41::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.25; Fri, 15 May
 2020 22:17:27 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3000.022; Fri, 15 May 2020
 22:17:27 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        Parav Pandit <parav@mellanox.com>
Subject: [PATCH mlx5-next 2/3] net/mlx5: Move iseg access helper routines close to mlx5_core driver
Date:   Fri, 15 May 2020 15:16:53 -0700
Message-Id: <20200515221654.14224-3-saeedm@mellanox.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200515221654.14224-1-saeedm@mellanox.com>
References: <20200515221654.14224-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR01CA0047.prod.exchangelabs.com (2603:10b6:a03:94::24)
 To VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR01CA0047.prod.exchangelabs.com (2603:10b6:a03:94::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.20 via Frontend Transport; Fri, 15 May 2020 22:17:26 +0000
X-Mailer: git-send-email 2.25.4
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 8cba2fd8-e379-40d1-daa6-08d7f91dc07d
X-MS-TrafficTypeDiagnostic: VI1PR05MB4301:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB4301CB16B8D061DF47F36417BEBD0@VI1PR05MB4301.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:669;
X-Forefront-PRVS: 04041A2886
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fKHhvBeu5hFoU/+q9QK6ISzl/J3IpgGKMwWS0PbDswWaXza8jnWUw7P+0afqRwJmiQ/XtpZ/IboYwgdXFXKhtO++zAEU3tQjE0ybMH3tmKqAIUcCwt2EMjc5FXo83SDF+XnMhq3EsGIor1yf2L0Fov54tra1P508J8EH5U9bl2eSFA8aV8WWImLQdaXkR185LUs68GmUp/6LX8+fMlHj2SdAPETVTj5pca+rv1vqcTQDONYkYHltyjA9PZJFrapCdpAserQ2zOUo5Lm5C/g66ZGTmTaULH4LAKnSsPFRjJ9rBQv+KVORfHFt6unzlLICLWPhnH+BA1kSC7wJnugB89kuz76e6Phx80zD//6k7h0DWhBrm2pxHOgDEjxSyksrzOQiccr2aTfs+gb5Mptu6CiLT08EP7CW3oPh6/TuaNXXiRRvcZr0WaFYNHqaQhOw2PrUbFc5YMuyywNxw49lrnXn/2T2VhojJ+bg37tR9lA39UHnYYslKT5NSNSQWB3s
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(366004)(396003)(39860400002)(376002)(346002)(107886003)(86362001)(6512007)(450100002)(4326008)(8676002)(5660300002)(478600001)(6486002)(6636002)(1076003)(66946007)(316002)(66556008)(66476007)(110136005)(52116002)(6506007)(8936002)(16526019)(26005)(186003)(2616005)(36756003)(956004)(2906002)(6666004)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: J3rwcn9x/cP6vw7XxMCEk468vTzGbyp+BkZObKokOn6ofNjTzzflLo2ZYI7X21JiRz3L6VZK3DLfgP2U1Xf4BGLjkGDcmGrVRy2ePO48A6lPwiopsmyW6utqJhfvoZE2EuYmaED6UdjTS8twheZdpDh20uz4RCOjseneJDpu/XSDgCjFjQOhic6ZXUIZKSiHql6kGZKY4VGan9Ba0h74Rg9p5F9wwuRqJqneESOgHi2EaoEoVJibIx8+OwlkUmfpgx91OsjVUy54JFU9wj2tyxkZM/3oie2d+FJCcR49EqvWz58ljL3QkwZHQZDxaCfgIZrGrNzZlpM3/eWQXhR4HinzyfF0zHIUukuPCIQfZhkHqT+rXrdnNdpKHpwyzH7tJRtE0SKFdbZl1a1KuPyNODgD/hQTbpqAQ0Bi+hSO375q7dy2MWlc0wua1JzcZgjggeKGJ6/FwLdzNKN28Dz2x1ubF6H5pR3EE4vrIniu5XE=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8cba2fd8-e379-40d1-daa6-08d7f91dc07d
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2020 22:17:27.8124
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eZzbbxpM5PtgzamVKOjmgAumUKo2Vg9AUpmYkRO86Vis0grAf56kCOdiofmyc6tM0JzdY1jaENOd1r6KGcb+ag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4301
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@mellanox.com>

Only mlx5_core driver handles fw initialization check and command
interface revision check.
Hence move them inside the mlx5_core driver where it is used.
This avoid exposing these helpers to all mlx5 drivers.

Signed-off-by: Parav Pandit <parav@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c  |  5 +++++
 drivers/net/ethernet/mellanox/mlx5/core/main.c |  5 +++++
 include/linux/mlx5/driver.h                    | 10 ----------
 3 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
index 34cba97f7bf4..e6567d5570ba 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
@@ -1890,6 +1890,11 @@ static void free_cmd_page(struct mlx5_core_dev *dev, struct mlx5_cmd *cmd)
 			  cmd->alloc_dma);
 }
 
+static u16 cmdif_rev(struct mlx5_core_dev *dev)
+{
+	return ioread32be(&dev->iseg->cmdif_rev_fw_sub) >> 16;
+}
+
 int mlx5_cmd_init(struct mlx5_core_dev *dev)
 {
 	int size = sizeof(struct mlx5_cmd_prot_block);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 061b69ea9cc4..8a375e3ed5c1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -177,6 +177,11 @@ static struct mlx5_profile profile[] = {
 #define FW_PRE_INIT_TIMEOUT_MILI	120000
 #define FW_INIT_WARN_MESSAGE_INTERVAL	20000
 
+static int fw_initializing(struct mlx5_core_dev *dev)
+{
+	return ioread32be(&dev->iseg->initializing) >> 31;
+}
+
 static int wait_fw_init(struct mlx5_core_dev *dev, u32 max_wait_mili,
 			u32 warn_time_mili)
 {
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 24e04901f92e..a988eb405aa6 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -823,11 +823,6 @@ static inline u16 fw_rev_sub(struct mlx5_core_dev *dev)
 	return ioread32be(&dev->iseg->cmdif_rev_fw_sub) & 0xffff;
 }
 
-static inline u16 cmdif_rev(struct mlx5_core_dev *dev)
-{
-	return ioread32be(&dev->iseg->cmdif_rev_fw_sub) >> 16;
-}
-
 static inline u32 mlx5_base_mkey(const u32 key)
 {
 	return key & 0xffffff00u;
@@ -1012,11 +1007,6 @@ int mlx5_core_roce_gid_set(struct mlx5_core_dev *dev, unsigned int index,
 			   u8 roce_version, u8 roce_l3_type, const u8 *gid,
 			   const u8 *mac, bool vlan, u16 vlan_id, u8 port_num);
 
-static inline int fw_initializing(struct mlx5_core_dev *dev)
-{
-	return ioread32be(&dev->iseg->initializing) >> 31;
-}
-
 static inline u32 mlx5_mkey_to_idx(u32 mkey)
 {
 	return mkey >> 8;
-- 
2.25.4

