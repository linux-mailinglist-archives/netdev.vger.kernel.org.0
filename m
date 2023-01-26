Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6596867D152
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 17:25:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229577AbjAZQZY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 11:25:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229639AbjAZQZV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 11:25:21 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2089.outbound.protection.outlook.com [40.107.92.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 328C56F23F
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 08:24:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZhdtvJ7co8vlUivFAsc8HUq4r5gKHeFOg3U1K0ZmTJhdpORj0xrHZJ7i365dIBZ33P86HvJJryNQNfRIDXK6b3BOUN068poJmu/qgFjw4TgyXUequL2afGtEaeBrbQeHVzznANZsNctydFZPBftVdv0SXJ0Uctlk0/VtSpEaPJ9jpaNzZFIrYPfceTda0R5D6yrtcCTAZc8/86TcDbskBgEyRU5AsrqN5ZKOdh1UD9RAqbZJSi+XoA/LLBEsZs4yWka1phqrxbIHyw8CEsIqYt0ZhKnUaYVA97mm8E3W4ncl1IhisYJsBQNVVMguYZbEjgKNHCKWqdcSce49bbc3yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=frZ8+7cWKtArgmDeA3M3gyIsxjFNZwS0sSpJ1ht1F0k=;
 b=VwhQb2CN1FvUFXoYFoHNBBEt3lvDGv6Sxwy6A6C1m4Pz4FaxPubb8DuKk2Ltjvz0CMt36dZ5sDq/xQyF5aGHsbR7vFU8ZW6AIQHByuT5kDQciflIeGiV/ZwK0G5vof/hCc/fpUhjbPemwFmnHGyE/KamTHgUWb+4Psq3F/TC1ZtZ6+WegHjUY25cCcSjuOtd0pWRL2R5NyYzuE7bMGnldBAgfohlBXUfPeqehzQHg0pfUPXDWkPEa42bxcMzg+KelXZwMmi+gEYIg6pFNF9IMlsMDe3sxPatt5FqR/7GSZpacsbPTpjnCEOSXLL76U7KWMJPeEHEcJAg7/IBavDb5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=frZ8+7cWKtArgmDeA3M3gyIsxjFNZwS0sSpJ1ht1F0k=;
 b=CCn7ax06XpEwL2DGhsoYRBCc81Z46ALI0oej5Xj1yUqz8J9B7yaMo4JSTYMF8jNr/+whHS8flBpin+jqIcfAQyR/qahhX9m7LJsQ2lxsB7YFA12omfAvtzJlnop/jR/hqO/KYOVpwuZ8Ey90SCzwDUZ0iuk4ZDWIdcJoYqLOYOCyv8Tsrz+aMi1+HEhB6RPntZxqZQxPRBFOMfOVWWlv09Lb5KKbfRVBtcUzuvgvvbNlTKW6ivR6tLokfiDHl7XSAGTVaav/skLnXBjyXlS4pTUUhWkb/igCXf0YGJC8RSg3W98/PGQOKeGZ84/mTmYm8G9o2yK5CtTEzPqmJPY0Rw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com (2603:10b6:a03:45e::8)
 by PH0PR12MB7792.namprd12.prod.outlook.com (2603:10b6:510:281::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Thu, 26 Jan
 2023 16:23:44 +0000
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::9fd9:dadc:4d8a:2d84]) by SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::9fd9:dadc:4d8a:2d84%6]) with mapi id 15.20.6043.022; Thu, 26 Jan 2023
 16:23:44 +0000
From:   Aurelien Aptel <aaptel@nvidia.com>
To:     linux-nvme@lists.infradead.org, netdev@vger.kernel.org,
        sagi@grimberg.me, hch@lst.de, kbusch@kernel.org, axboe@fb.com,
        chaitanyak@nvidia.com, davem@davemloft.net, kuba@kernel.org
Cc:     Aurelien Aptel <aaptel@nvidia.com>, aurelien.aptel@gmail.com,
        smalin@nvidia.com, malin1024@gmail.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com, borisp@nvidia.com
Subject: [PATCH v10 19/25] net/mlx5e: TCP flow steering for nvme-tcp acceleration
Date:   Thu, 26 Jan 2023 18:21:30 +0200
Message-Id: <20230126162136.13003-20-aaptel@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230126162136.13003-1-aaptel@nvidia.com>
References: <20230126162136.13003-1-aaptel@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR3P281CA0151.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a2::12) To SJ1PR12MB6075.namprd12.prod.outlook.com
 (2603:10b6:a03:45e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6075:EE_|PH0PR12MB7792:EE_
X-MS-Office365-Filtering-Correlation-Id: c3cfcfd4-d4cd-4177-7ee9-08daffb9b1d9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FWQlVEBpXzfFvMb6llq5A9A/x2a8A08Vqr5nkGEVdZ5xF30WzmvP0zuuQFUCXg2h3R+aGtAVu9PKs4WUFS9kNg5yOZbGK4grNXmVKmC1TXQeZ0yk7SbZa8EGwHalG6CE5h9PkAeETgLJS0a4YJZjQkmR1B4cDP0Wwbvn/np2qIoogrYg6xUUkcXqII2Z9sB2q1m198BXEaYmsJzzL90xHQkwcDHzEUqM6/VntdxKvztNWCMcb0vG6TKEor6CPXrt5KBmee3t0b6AZK1WhwN59J3EXF0qgvoxDDbj8q10HFKgoO7lWn86xnLiMxFxS7NfYfmKeFn2pUduKIHgBpLgYl5lrNmTCSpeE8oHGIxL/zXLU4jMm39O2ag6uhUKW+LMkhXAedGIgziDWdGwJkBzW9gve/qw9WJToSwmczECtUxUr15MPUHDuX3Vv/BnNmO/poXyO9Um3CcgbBaw8d4LcqPa4S3++VS0swvGupLYOR825+NqEI6MJ9qyd9M40Ox2O7WUKt5HDjMPbq/K0bIf/OvmBSKylVXYsasjtznIzjPhXHy6giDCzlf4YUlGOQ6pTCueieNnAOaLMb/dZEu22SEaOrZWdCeoppjk0in4Dv35VRkYng5nAKKUwuV458Gh3Otaq8fY+NNY4gC/sz/W3g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(39860400002)(136003)(396003)(366004)(376002)(451199018)(4326008)(66476007)(316002)(36756003)(66556008)(86362001)(66946007)(8676002)(6512007)(107886003)(478600001)(2616005)(26005)(83380400001)(8936002)(186003)(6666004)(5660300002)(1076003)(6486002)(2906002)(7416002)(38100700002)(6506007)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LJwsoh+7Es5hAKmW8+TE5HEhQxov1BAHWiXT16OFOM0Nn+O7U6nAQAJsyDX/?=
 =?us-ascii?Q?/uqPamSNEMW2Ola7jxlNA6SS4V2xGnUmkiqs6RjukAaUEq5bxHtA8DxCENOO?=
 =?us-ascii?Q?fGHsGdeUNJpZsoYKX1+fCJSNS3/O8yF5jkmDeWieb/Pe4G0j+5SNF/jhLhpK?=
 =?us-ascii?Q?5qebJW+8+xR8+DcOlkXjNX2cMJh+rymmcGa3+aBGZIe1iDX2u8HIudQaY13j?=
 =?us-ascii?Q?86tf7uRf/TcmwgtQkL70f+Bp+00ZWySqYktrOLrgXdxQCpSRbeVzfehxZVZ6?=
 =?us-ascii?Q?Q4HsiwqokMDDwWSUGjsJ2GaQrSGuUcgJnRXtHEgpiueJ5/eiMIXnyQZMXrMX?=
 =?us-ascii?Q?pfcn0Xi+ISwGpGDF1V2p9g3P5TWQfy1UoUH1bCglo4rdrjJbJaqD3fE2FEfg?=
 =?us-ascii?Q?EIU2ss8gD5+wd8a5dqCkV+PcCunhQMcQKORL/xNWFiRqifwoa7pbzAjOhSga?=
 =?us-ascii?Q?UH0IG4b3/aN/bUmNdgbK9ad1sZyqkQdnPhkPSh1Yovvd6iyVeeIfWDRhj9Xv?=
 =?us-ascii?Q?BzBOtkkcTucA5UfrWkJHoc0q4rxeaLhjNOv8PWFCl1WcUndE7koy9sSYThQG?=
 =?us-ascii?Q?78u5PSEmEILfExnPJuC+WY7ZWD99cBqubDmJAipM5OP7SXwizltdZ/GdFJay?=
 =?us-ascii?Q?7WqhuHkAFvVh2Tkslxs6e9BdfzaNvsU9pPYQLU8mB1ptx3YFVxQWuG9AMtuu?=
 =?us-ascii?Q?JrSa7zouM/yIYMFcybi+fIiooMWqtWiswoliIfFb4N2jw3OCl5VF6f64IUjj?=
 =?us-ascii?Q?r5En8Mlahsxw6IcFBlaJrRuETAR1JXrWhk9TVis5JCUu4FVe2qSSik0q0cBb?=
 =?us-ascii?Q?DjSCBZhVMEuyBH7Qeoy10w3W9ACvHVmBqxrHVKCw/bxBAo9aZcUjXjbGefUw?=
 =?us-ascii?Q?iK65WBPi8wI4l5ncjyX2ok1aw43uCfRdBV+Srmh+2iXQEiC11AauuqTnl86S?=
 =?us-ascii?Q?nBlit+sKo2DPofylbrBujte7r5E9igL7Z2bC7/Iw53aLPkbFfPHlyMAhOJQi?=
 =?us-ascii?Q?OBdgUvV5LumegO7/aWRBG9fFqXqyH4+fRvbbbJs/e1OgkTbLYOOGfwnBx3vw?=
 =?us-ascii?Q?pD1tSY3Sj+BpwVcCpu88ieBDWrlgcfyfHCAVJOlzDcyc3aBRQkZbAKtiJP3w?=
 =?us-ascii?Q?OtJeG7F9obq3rQ/5HDkmLNq3/lO6OR9jw9RTI8aP//3DUx4FJdf7Wz4rxY8v?=
 =?us-ascii?Q?FuDizChGN6aQvbGyV7gQ09/d3jAFE0TCLZSz594kmT6nWRnjitgd8Rpxxb80?=
 =?us-ascii?Q?LoosoFiWB6GY/x3FJuRI1c/yXBiLhffgCbbH//jJFrtB49V39VKNx4e5UpRB?=
 =?us-ascii?Q?VjfNkDbUnyBEfoSGeVrSkiZRatVPATFaF13UviMPYYR/7/r8XIP23NkBcBvZ?=
 =?us-ascii?Q?DuFjsKTklzLlg8xXPllTCQptTKTOIm2Iw54EUAZpn1s5Lxk8hu3msqNRQm6E?=
 =?us-ascii?Q?YHNxlgqF/fT/RoLX3HsCqNrs/ukEhNqhDuRWe9Ft+aS+WQz9mvLZTDYyLZDH?=
 =?us-ascii?Q?VqWPO/BUDbQ//hXF6tFAIaQ38Zu1Hjb9Kre3OOBhlZN6igxEQEpMLkut6oWC?=
 =?us-ascii?Q?198ElYz1UoRPxmJsBIondOBlnwbWcPy2dutMpZf1?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3cfcfd4-d4cd-4177-7ee9-08daffb9b1d9
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2023 16:23:44.7181
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MHu17EiTcfFPt/98rrWh0PAAoGv10loqcNLxc8kdNBpbGDI+x6knVMo+kf4D2HU3DM2Rph48LhFiGPkM4X59eg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7792
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Boris Pismenny <borisp@nvidia.com>

Both nvme-tcp and tls acceleration require tcp flow steering.
Add reference counter to share TCP flow steering structure.

Signed-off-by: Boris Pismenny <borisp@nvidia.com>
Signed-off-by: Ben Ben-Ishay <benishay@nvidia.com>
Signed-off-by: Or Gerlitz <ogerlitz@nvidia.com>
Signed-off-by: Yoray Zack <yorayz@nvidia.com>
Signed-off-by: Aurelien Aptel <aaptel@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c    | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c
index 88a5aed9d678..29152d6e80d2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c
@@ -14,6 +14,7 @@ enum accel_fs_tcp_type {
 struct mlx5e_accel_fs_tcp {
 	struct mlx5e_flow_table tables[ACCEL_FS_TCP_NUM_TYPES];
 	struct mlx5_flow_handle *default_rules[ACCEL_FS_TCP_NUM_TYPES];
+	refcount_t user_count;
 };
 
 static enum mlx5_traffic_types fs_accel2tt(enum accel_fs_tcp_type i)
@@ -360,6 +361,9 @@ void mlx5e_accel_fs_tcp_destroy(struct mlx5e_flow_steering *fs)
 	if (!accel_tcp)
 		return;
 
+	if (!refcount_dec_and_test(&accel_tcp->user_count))
+		return;
+
 	accel_fs_tcp_disable(fs);
 
 	for (i = 0; i < ACCEL_FS_TCP_NUM_TYPES; i++)
@@ -371,12 +375,17 @@ void mlx5e_accel_fs_tcp_destroy(struct mlx5e_flow_steering *fs)
 
 int mlx5e_accel_fs_tcp_create(struct mlx5e_flow_steering *fs)
 {
-	struct mlx5e_accel_fs_tcp *accel_tcp;
+	struct mlx5e_accel_fs_tcp *accel_tcp = mlx5e_fs_get_accel_tcp(fs);
 	int i, err;
 
 	if (!MLX5_CAP_FLOWTABLE_NIC_RX(mlx5e_fs_get_mdev(fs), ft_field_support.outer_ip_version))
 		return -EOPNOTSUPP;
 
+	if (accel_tcp) {
+		refcount_inc(&accel_tcp->user_count);
+		return 0;
+	}
+
 	accel_tcp = kzalloc(sizeof(*accel_tcp), GFP_KERNEL);
 	if (!accel_tcp)
 		return -ENOMEM;
@@ -392,6 +401,7 @@ int mlx5e_accel_fs_tcp_create(struct mlx5e_flow_steering *fs)
 	if (err)
 		goto err_destroy_tables;
 
+	refcount_set(&accel_tcp->user_count, 1);
 	return 0;
 
 err_destroy_tables:
-- 
2.31.1

