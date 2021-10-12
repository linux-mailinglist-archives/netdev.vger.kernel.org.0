Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA55442A4F2
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 14:52:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236656AbhJLMyj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 08:54:39 -0400
Received: from mail-bn8nam12on2040.outbound.protection.outlook.com ([40.107.237.40]:17120
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236559AbhJLMyj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Oct 2021 08:54:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ntnkvd+WePNwTNA7Zyg/RvI54Igt04Dikj+/a/7QQM8OL7Xsof0ps3Cishi53qogcUmGeROQ6W8PELhvu5U2lUFt25xvcozauaaFO2X06y2BWh5s5y850mg8O4y8BVQg6rXUOcsYU3uySa3qpm1RBCp5/N+PbeMuGRy8ebspBJpervRTwjSRSgyseDndpSMr93TWOgEYNWfLvMoPdBiciwq6wZ+D9ogvfTDlaBVifRGeA5W/cUYCoQ0qnFRePvq473Ky+DN9D5J48bJOxK7BF7IA9qN5Xr05Axq64QIM0bC94MBBovUYqZtsxlLhtufuv/9RfhyGhTkv2dp7Bh9e9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eQhyerLQo9X0fdHLPs91FE+EVOoKRdcd039OVdOJpbs=;
 b=goR/LFqD9E3eYeNYCluOXTpSUw+qA3EdadfhgIQQ2AscSilDaDTeEgtf4fu5BllZUbtCRT+pIRan8cvGI7ZOJ3CoCRYoJxdCTlFj6BGJusWdJK56EVdX+H35xLkaZCZg/bEiFVTl7skiEQJGqGFNZj6RE1QHkx6jcRqLCJGoLOTJxBRjGALOj8OZYSqx1BHO2UDCLle+q7t7P7mogb3Lnry8TTkclIR0+CGsdbIdhYM5CkMua6sMHp/oKCZpBV5/mOcDkZZbPsdaeU5p1mjuds2vLrR6Wm9IObgqeqX2W7Ir8C/2v/u97nNgXVTdwEBQ3g9QuGS+ka7fm+oSy/EZdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eQhyerLQo9X0fdHLPs91FE+EVOoKRdcd039OVdOJpbs=;
 b=NvLfW9MrWuJBiskEUN5JKFfApxN3zNM/wZg2fU6SsFjufGhncFpH5lfQB+cHLdGa2M//AY14sPPvg0tPBMXAVXLaVeVLH4AVu9+fgkZPASQTztf/aGv4jp4qeQQwsnluuhHrDuQoz2XjEbV1VEPYpIJ12mm4xBJBSn7jsVBh1tLOb5WbLGuNtdlPDfTxCyN/oYcxR3gTtzrvOdhAFa7hbjX/dNBeVjs18D4/uWRLUsdPYdLkMoT33AyjAIwFjDrnuTrr1cPnwHeJf20m9Vm3KOX0dQ2VN61Rl5ESevIqp69M7grdj/JwqOoUCk8IF8NtWP67PQw8AFSt4ZPzNL7LAQ==
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5080.namprd12.prod.outlook.com (2603:10b6:208:30a::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.24; Tue, 12 Oct
 2021 12:52:36 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%6]) with mapi id 15.20.4608.014; Tue, 12 Oct 2021
 12:52:36 +0000
Date:   Tue, 12 Oct 2021 09:52:34 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Doug Ledford <dledford@redhat.com>,
        Aharon Landau <aharonl@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Wang <jasowang@redhat.com>, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, Maor Gottlieb <maorg@nvidia.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH mlx5-next 1/7] RDMA/mlx5: Don't set esc_size in user mr
Message-ID: <20211012125234.GU2744544@nvidia.com>
References: <cover.1634033956.git.leonro@nvidia.com>
 <f60a002566ae19014659afe94d7fcb7a10cfb353.1634033956.git.leonro@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f60a002566ae19014659afe94d7fcb7a10cfb353.1634033956.git.leonro@nvidia.com>
X-ClientProxiedBy: BL1P223CA0019.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:208:2c4::24) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by BL1P223CA0019.NAMP223.PROD.OUTLOOK.COM (2603:10b6:208:2c4::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.25 via Frontend Transport; Tue, 12 Oct 2021 12:52:35 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1maHGk-00Duup-MF; Tue, 12 Oct 2021 09:52:34 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8d0e75a6-817a-4bfa-3faa-08d98d7f2a26
X-MS-TrafficTypeDiagnostic: BL1PR12MB5080:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB50809EF3BC33FA65D3ABA889C2B69@BL1PR12MB5080.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oQU7IyD77nasmsBalY/cto2oxXmn5b6cZiUVC2gwxdjOltZWbW2npsyMfus8mYKk9vdtUDpH4gjmdeheioxZON3A37B16MMyXC44W0uZA3URxQSDWcK1h9B/Lesa2gvCV9zFU52eVitaWSFLJym9M+knGVBX+4GF85mZcU+fN5IvX4EWGpotWUoZsePJvHm2oJ87DDxoXxe1HsRhWA7Uq3NzjoW19MQFoyyseR+ScvglzOmD8Niel/HSVB/dx4J9Iw0z91VoHoGo8THU8L7hJl+obXi3fHKPhwkK0ZkRMUT0fWvDSiCCMQEKhZPYZhORDAm1NJurrbUJMsgzlKCG6gajXQFMtFn97IT4lzWkfZ6vCOk6XK/sL6kD7j9wKgOWPE1xrtvS/f71NmjOnqxmvG7NCZ+iA7vg1/Deh66UXnHhI1cKgccmWSbUSQmx3t3qifatSFfMAXEwHyxkVtvAIhabiQEI35DXo+oDEB1qFUmld2AeqCT0gb10fZ07jO9ReVtVeJ7dJvhds0oqSRRKuTBeeDVbaod70iTmMj0dwq5OELGd+G/FbGOvwtA89E1Yv2xfsA3Wcd/9fo6rCTTv6R/3vu0A8nmxU18ipDeW83OJ7rV9UcRvCIgOoD/RfXHqa4n+zZXnbHQflzwUzzAUwQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(1076003)(8676002)(9746002)(86362001)(26005)(54906003)(6916009)(426003)(38100700002)(9786002)(186003)(33656002)(5660300002)(316002)(36756003)(2906002)(4326008)(66556008)(7416002)(508600001)(66946007)(66476007)(8936002)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6cXjIcgfR5QTwhoVeBLkOMKEdOBSMYhJlR6cBYvXxNURNinfsO2PTf0IhBVS?=
 =?us-ascii?Q?NJpMmlMpGtDfhkB3LcEQhDPcNxFDrc4JwzxKSRn9ZHOq4TrQKVM7wE8RJ0NB?=
 =?us-ascii?Q?Y6bGqhVS4TrVZrIn5e/SBJC3NN3ZGz5+eNblgpZ8svs5jb7pL9rUcS9RWqEb?=
 =?us-ascii?Q?CAsH3Ie01UKpgg1xwWN8KxRSRnb1CpvcOXg3WwwrX7G3um7thvJ7LSdvmJHd?=
 =?us-ascii?Q?9t98EOl+cNV/MrDnDfFemJFiq7plrvWo2PuroFMVZIv/xh+J0C+q73JWo3oW?=
 =?us-ascii?Q?9tWLwXYlAZ6COiJRL0xJOJJx5H5kjtIJOMwSLhr78pFrcMKkeoGtbUF41STD?=
 =?us-ascii?Q?kZuNLL7ooITbl6jxMnfHY+940zfmQXKrgyfJWgqVSB/FK6MWzpd2DUe8PIIb?=
 =?us-ascii?Q?CpkC4ZnJyEJMVvvBoU0ectSUIYarQ6eAc+vYzFa4S8NH/n0zwdqK6RS6h9lG?=
 =?us-ascii?Q?4oOy16db0fWK5+VM5dFhmx44LsyYSNMlLQJmlVQg3YC4H4n44jhqJyuLXnPo?=
 =?us-ascii?Q?oaAOX56V8uP/cBAwjPT8QA6wIcNc2bkpJYcMttCzJF6gzPdkhIDUM2vJRoT4?=
 =?us-ascii?Q?WZ/Ko8iuSy/wYkAXNWJWwgHl68f0npacxO2wDNG4r5lciV9QPrU1KBtyILtg?=
 =?us-ascii?Q?UwfippQv9Ss47l+vzALpsrxxYnAg7wamOkncfBkVIUjfJbNVBuyMZO8gKQKy?=
 =?us-ascii?Q?zsFlEXHHNP/RcTVa6ludWF8j1vPfkcfIHgYrFSM0nNZ4ATW6ybQzEdBdId4j?=
 =?us-ascii?Q?kZakqTfZ2a8lZhL+4mUnNB0us7RcTh/fPrZdbe/9hUQ+Zyz63XiPENT9v7qi?=
 =?us-ascii?Q?vFd1lmRZORGr+71pexRqBbX2mNLwEfr48uWKySrppuPjvG/evXWZgNeUmNi+?=
 =?us-ascii?Q?nE5bzpFN/JE+1qYMHs+3geQDnFwdC5Gb2gRR7WnddUyMJOO9LMrCdAadjnRV?=
 =?us-ascii?Q?I5QoMS9J+w0Z6ZJ1JzhuaL5sGt2czNEFg2JBwlyp93yCrHB9g1jwGGq7K79X?=
 =?us-ascii?Q?4n6oKIpHdrxooqEQowwGoHYQI1nyuPfHJOWdTyesREA7qLDOzVxQaIxfssVa?=
 =?us-ascii?Q?Zv0JGgeQ5sqjU1NN8G3LWxJpZkUPQd8PonUkVOONS8B/TTutfntcBnxFR/rg?=
 =?us-ascii?Q?BzVTzsgmXO+Isy9HSB/WEDaG9I2Wakh5RmWCneA9h1SdIkVxlcvBR+BnqC9m?=
 =?us-ascii?Q?tSC16bEdUDWxd+lFJ3TTBWXUK5YpAzlqe5ng3seGPqcv6M5BTK1Ir7D4jYpP?=
 =?us-ascii?Q?d94ZMd6BqfVZWlS0TzVrl5shfmtVA3gKsTj5Id134OH6LV6pVI++A9l7Gkb7?=
 =?us-ascii?Q?tnugBvdGIaAOR4i62av2hn4w?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d0e75a6-817a-4bfa-3faa-08d98d7f2a26
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Oct 2021 12:52:35.8960
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Q1HPmQLyNRu+CL4n82WTp0fbrsjnnxIF+78Bfty6RGF6KZ/eMEzYZFyXl0nKnCTv
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5080
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 12, 2021 at 01:26:29PM +0300, Leon Romanovsky wrote:
> From: Aharon Landau <aharonl@nvidia.com>
> 
> reg_create() is used for user MRs only and should not set desc_size at
> all. Attempt to set it causes to the following trace:
> 
> BUG: unable to handle page fault for address: 0000000800000000
> PGD 0 P4D 0
> Oops: 0000 [#1] SMP PTI
> CPU: 5 PID: 890 Comm: ib_write_bw Not tainted 5.15.0-rc4+ #47
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
> RIP: 0010:mlx5_ib_dereg_mr+0x14/0x3b0 [mlx5_ib]
> Code: 48 63 cd 4c 89 f7 48 89 0c 24 e8 37 30 03 e1 48 8b 0c 24 eb a0 90 0f 1f 44 00 00 41 56 41 55 41 54 55 53 48 89 fb 48 83 ec 30 <48> 8b 2f 65 48 8b 04 25 28 00 00 00 48 89 44 24 28 31 c0 8b 87 c8
> RSP: 0018:ffff88811afa3a60 EFLAGS: 00010286
> RAX: 000000000000001c RBX: 0000000800000000 RCX: 0000000000000000
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000800000000
> RBP: 0000000800000000 R08: 0000000000000000 R09: c0000000fffff7ff
> R10: ffff88811afa38f8 R11: ffff88811afa38f0 R12: ffffffffa02c7ac0
> R13: 0000000000000000 R14: ffff88811afa3cd8 R15: ffff88810772fa00
> FS:  00007f47b9080740(0000) GS:ffff88852cd40000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000800000000 CR3: 000000010761e003 CR4: 0000000000370ea0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  mlx5_ib_free_odp_mr+0x95/0xc0 [mlx5_ib]
>  mlx5_ib_dereg_mr+0x128/0x3b0 [mlx5_ib]
>  ib_dereg_mr_user+0x45/0xb0 [ib_core]
>  ? xas_load+0x8/0x80
>  destroy_hw_idr_uobject+0x1a/0x50 [ib_uverbs]
>  uverbs_destroy_uobject+0x2f/0x150 [ib_uverbs]
>  uobj_destroy+0x3c/0x70 [ib_uverbs]
>  ib_uverbs_cmd_verbs+0x467/0xb00 [ib_uverbs]
>  ? uverbs_finalize_object+0x60/0x60 [ib_uverbs]
>  ? ttwu_queue_wakelist+0xa9/0xe0
>  ? pty_write+0x85/0x90
>  ? file_tty_write.isra.33+0x214/0x330
>  ? process_echoes+0x60/0x60
>  ib_uverbs_ioctl+0xa7/0x110 [ib_uverbs]
>  __x64_sys_ioctl+0x10d/0x8e0
>  ? vfs_write+0x17f/0x260
>  do_syscall_64+0x3c/0x80
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> 
> Fixes: a639e66703ee ("RDMA/mlx5: Zero out ODP related items in the mlx5_ib_mr")

Can you explain why this is crashing?

reg_create isn't used on the ODP implicit children path.

Jason
