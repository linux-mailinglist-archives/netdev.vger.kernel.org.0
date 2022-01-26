Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B4DB49D47F
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 22:28:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232398AbiAZV2a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 16:28:30 -0500
Received: from mail-mw2nam12on2083.outbound.protection.outlook.com ([40.107.244.83]:26657
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231297AbiAZV23 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jan 2022 16:28:29 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Cgadzw7s0YC0ExPnAuTawteR0e2Vu+WZjC/5i5850OTYoNr/HtKlN5zUfrBP6LRxqnqeeX36M4i0I4g/o1J6ACFVzZGhmpW2SlFB2udya0hhTI9PXspf8C+TUgcp34uHQPuaVK+06Kk1pWYomAj7acCC5b/hqnNyPd81V7wIm62rzhDuFwl/KA1WguC5CVWgr7vsud+YlPjO4E8mhyd3fdKrTd6oMiRFb8Z+CG1EG/SrJr02XhjkNXVvUeuFYgHFPQmZcAA6izT767fWZm2JflDW2YqLIkFXWiFeymVB7I9WTLKdyEYbtODsJ7wb3UbVZWnU+uyfDPwFIxq0Ff4sCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3Rx1wueTyoB4x61u0P7Y/8jQuOkj/CeOIW/zolDmcQY=;
 b=oAnH9g5lhc9bowl7tnUdfywLGML12nffCW53IUqn1CTRYSEZ1V08XIpMlSM10+ab0aiz5j7SZWq/vDyyfpR5NCcHWpgIUbCaTd13QZvD7b21ULiMpaKffquy1jpL7eJLP/m8rOw3jgKDkdZf8ots1hsQQB/nZYA0Dc9iETgANv7DsxpyXi8rWKVISXrhgKsfzYD01YAKAr+kj2RnxEv6cEfBzt83Zfb1QH6XYUC0BPuCNpXVmLDTjzgTBLNwZMFJVV4VeXT+MkfhEt8UZpbnZRe9tSPdwMuZy82MiJMh6jSe+ZqLFxqFnNQWHlF2yt4y4VDyfW6rxSsA2alBrn9tGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3Rx1wueTyoB4x61u0P7Y/8jQuOkj/CeOIW/zolDmcQY=;
 b=YwGKmW64WrE9pNuoRYJ8tZ1QPt07xmHbgFo44MSyQo/tErjcXeh62r+3it4bJbGOPaMahjmuBTxLa1IWZN5AfLZxLtYmlPyGs5u13sCprJJq1TbH5x5+TcSMWruJDQvoAwAehaFIXnAInPD1yJlxkUyNiVzwVXwjGHwVpzsLw0V3jpbiMtyE1KyBJiTl0EsxAex/F6/jhm/N+PfBUi1afPKJQSl0CboAJRHr/HPKE3vWG6IeFJDAjNEQo5VV/8HACjqoLCaH9q6ujY6YQ1Put1dEoOP6CUySjgsjzsGXcrOe1PtWxSYSPI9drEP1N9jh/nesYVy3Sy9v0tDQ3WYW3g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by DM6PR12MB3465.namprd12.prod.outlook.com (2603:10b6:5:3a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.8; Wed, 26 Jan
 2022 21:28:27 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::35a1:8b68:d0f7:7496]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::35a1:8b68:d0f7:7496%4]) with mapi id 15.20.4930.017; Wed, 26 Jan 2022
 21:28:27 +0000
Date:   Wed, 26 Jan 2022 13:28:25 -0800
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Kees Cook <keescook@chromium.org>
Cc:     Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        bpf@vger.kernel.org, Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH v2 RESEND] net/mlx5e: Avoid field-overflowing memcpy()
Message-ID: <20220126212825.ph3w3umkwvpvtokx@sx1>
References: <20220124172028.2410761-1-keescook@chromium.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20220124172028.2410761-1-keescook@chromium.org>
X-ClientProxiedBy: SJ0PR03CA0155.namprd03.prod.outlook.com
 (2603:10b6:a03:338::10) To BY5PR12MB4209.namprd12.prod.outlook.com
 (2603:10b6:a03:20d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f1989e22-f02e-4cc3-fd08-08d9e112ca4f
X-MS-TrafficTypeDiagnostic: DM6PR12MB3465:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB34650F881788030C2CE85C12B3209@DM6PR12MB3465.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: P5vzU1nJGOChMvdmkYThdWl4/t2gi3WZbrIpCWtNWd4IFXHpHO0x89F9ncqopa9q0CWuD8/C0uvl4EnPWyVHj0V6JqvTk7QOA4EUyqsmwaEkM09mdrhx8v/wuen/sdJd7EKFwDh7HGMU1Fhm5WDLrnDmztX4CVk2f0ps0Z3OT07B45X/SXdpp9H+wL6ormcLwp7CZ4PBaxjqaDD9A3T57MNguiYMAXFV+/Vw2QKKuT+kJcTGO3nZlNmiPJDcWXzLg2sUdMAWVlGe2cta4uf+kCjccbMsQ3FS5TpHu0erOvPMmKh9osv/MQUyjNzdziJCzjougRGCmFBayWk20EON67bqgZuAm6C5gJxpBoYCqINvxLya6RofJdJ7tr7/etaL66XCehVWOOE1jw9Gv1nCNjPyBIUzcZaqGFUR4AEmmqvAZX1z4y3/mlziEYLafCNPRoWNPpym0ybg/tH5OXLlS2tSdIEkmSTo7lE5duy7UdqozqDbwu6//KV3Cdu3ruVVLmt5p111vZ30vyFqs6UMHmZfUmpm0OnEUfreUulFESc6r4zaW/U7z+GGsdPlMyHVUNP/N/c2KR8mYGmcJUY2WbxfSu9c9D0TuNXKCgeUggLPs54Id7mo472cZTfzfkshNmShVfUT05Qgnkwljbe1NBR1eEmCaU9DXi1cToN8tW6wY80VUAgZBdqA+WidASxSQRxECZpqfnvzoT5uiGW0Gw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(6486002)(6916009)(6506007)(186003)(26005)(54906003)(66946007)(9686003)(52116002)(5660300002)(6512007)(1076003)(4326008)(2906002)(8936002)(86362001)(7416002)(8676002)(66476007)(66556008)(38350700002)(33716001)(38100700002)(316002)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?B7DqMBeE7kVM8SHJVG+opUTta3s4g00TJHM0g8EWedxb4y8cUOoULcUsU0Ra?=
 =?us-ascii?Q?0tJx/ALKxYWf7o/pJ7EpOjjSp6j2E+lLToTgJ70rpIO0wtS20OyXDz1d5mXe?=
 =?us-ascii?Q?g6oEEMAlDxYRg9nGFN/G5lv5oO9+NK35eSKZGBLUjuzbnJEFmrI0MGAUIdck?=
 =?us-ascii?Q?4OfQmzJKujTy44rd/MSwjKeJpGuJ2OI+wBeiWt7HlNvXNOJiFw7off7CQ9Cf?=
 =?us-ascii?Q?f88NPwB7+boQOIB0gX78MNRdSP3iuErCajQwm5MtSwBWqwWr6NVanilUsLrN?=
 =?us-ascii?Q?qmPVbOZgF3j09ydukXBA6uq3msMzI9m3aSJijW01oV1x/ulbcCfGUWyiUrnV?=
 =?us-ascii?Q?KhZ+bop0tAg6sBstyxHu58/F+UkqPQjgjCdHGHJg5SICM/31ilByEDLhSReW?=
 =?us-ascii?Q?0FlRH2oqPmE941IflGrbiV12cLuiB1lVo8Pj9XOvStqZQaOoeonY0CYEs/hk?=
 =?us-ascii?Q?oB2Nis86zZVSzGZBrIJv+x9kgpLwPxx3+VDIMsRbeWVckUxdMjBjpMY4P+/V?=
 =?us-ascii?Q?1JGbvHIB69as2PXjfng2a9bCHM0T1ztGGm/KQC65QwbnVbAIZfym9B4jpsxv?=
 =?us-ascii?Q?fX7jJHOGI1nLz6LCJFS62jBNbXqauC47dK0neYZzVFYZs5XbVytDwz4f3g+I?=
 =?us-ascii?Q?BU52Mu7VyyxgRYoNcKS3TYZbpljwa3mPqfNbJ9PAXYJxYtIHUWq/elxJU/8P?=
 =?us-ascii?Q?eTTvo/KdP0Jo0PAhTIu/NXRQ6XnAoNFLKv5XYcjtT8UTPDLCl/P9NEKdff2q?=
 =?us-ascii?Q?lqKTRHDyon58gFwOYP/T/5T9lZHSkgbZ7DBYR3oGtyAYNfUJzEqQf2On63FE?=
 =?us-ascii?Q?UCMx4MG6ZqpSWaIp99eCQv6Hz/MAhntDqv+y/xc4i8aetNkvrzv2CAmlzWcK?=
 =?us-ascii?Q?GbHCrKBLORsFpARyQw8NjsCBAdMQLFOoQm2OyLuoDSFdDTdP+evoiNa1D3X6?=
 =?us-ascii?Q?PR0AA3TVt6QYQWK/7jMCJkUh+8X/PqT9fCVYcLed2SaKoVvti14gYns2B0Jw?=
 =?us-ascii?Q?yLttWDefTiUGGzye1AtaCT/0veLrP0WF6KfW75OEO9EzZsICjPmAoU5gR8eP?=
 =?us-ascii?Q?HTwKi6lfaVs3sadQ6Z0Wv7PaeAHZiDA9U/VCjed37NeUDbAGpc4JTQiElRfC?=
 =?us-ascii?Q?Rs4rQCYHP+osMAb8b9kybvL2mMbcD4oY5bMtHSU1pDWvRzSqDxuvhCV5QMn0?=
 =?us-ascii?Q?y1l5J/S0wuclNJcVwwl97HwM8l9iBNj130tZIg32ef6LduR3KXAO9AcPS7OD?=
 =?us-ascii?Q?aGXkpZ+xCsUwwjOJRGKg5Xg1BD093RePlaJtnnYiRu7MvVNEtW0XFEVDzAkx?=
 =?us-ascii?Q?VBs0btdEb9YhKyD+dWKSayzb7o1aF7DxWQ2tC+ZkwuhxIIXmpkAYZHEKYGte?=
 =?us-ascii?Q?UKeVehvw85/5dTNmY+kwZQEjy7Nj9KubLEki+U/jIR/kmSzOTWRr0VznuOvG?=
 =?us-ascii?Q?6ponuEqKEpqIAf0AJ6djyosdluoGO5K8lmvMlbK8ojjNxZhkDImIr1B6RI95?=
 =?us-ascii?Q?o3jCNetWQID5u+AL0d7Hu5eJyTK2mSKAWN7vAZphE7OA+9wsLTcDatDlarzA?=
 =?us-ascii?Q?V95FBN0Y8Vv8FUED/yEirfs/KZMihlxSpWgMGBxztzOEqVRhSvcWsDqxOhuW?=
 =?us-ascii?Q?KZ3GpA4M9zA4+64Fh8VkpVE=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f1989e22-f02e-4cc3-fd08-08d9e112ca4f
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2022 21:28:27.1737
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UFTCEm83FxUIY6N2I5YMzcpvmwDPE124ynf7m/bVPK1EmjmYD9L8N7NkMcV/HPuNrdZZF+WZC50TjP08cGvx0Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3465
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 24 Jan 09:20, Kees Cook wrote:
>In preparation for FORTIFY_SOURCE performing compile-time and run-time
>field bounds checking for memcpy(), memmove(), and memset(), avoid
>intentionally writing across neighboring fields.
>
>Use flexible arrays instead of zero-element arrays (which look like they
>are always overflowing) and split the cross-field memcpy() into two halves
>that can be appropriately bounds-checked by the compiler.
>
>We were doing:
>
>	#define ETH_HLEN  14
>	#define VLAN_HLEN  4
>	...
>	#define MLX5E_XDP_MIN_INLINE (ETH_HLEN + VLAN_HLEN)
>	...
>        struct mlx5e_tx_wqe      *wqe  = mlx5_wq_cyc_get_wqe(wq, pi);
>	...
>        struct mlx5_wqe_eth_seg  *eseg = &wqe->eth;
>        struct mlx5_wqe_data_seg *dseg = wqe->data;
>	...
>	memcpy(eseg->inline_hdr.start, xdptxd->data, MLX5E_XDP_MIN_INLINE);
>
>target is wqe->eth.inline_hdr.start (which the compiler sees as being
>2 bytes in size), but copying 18, intending to write across start
>(really vlan_tci, 2 bytes). The remaining 16 bytes get written into
>wqe->data[0], covering byte_count (4 bytes), lkey (4 bytes), and addr
>(8 bytes).
>
>struct mlx5e_tx_wqe {
>        struct mlx5_wqe_ctrl_seg   ctrl;                 /*     0    16 */
>        struct mlx5_wqe_eth_seg    eth;                  /*    16    16 */
>        struct mlx5_wqe_data_seg   data[];               /*    32     0 */
>
>        /* size: 32, cachelines: 1, members: 3 */
>        /* last cacheline: 32 bytes */
>};
>
>struct mlx5_wqe_eth_seg {
>        u8                         swp_outer_l4_offset;  /*     0     1 */
>        u8                         swp_outer_l3_offset;  /*     1     1 */
>        u8                         swp_inner_l4_offset;  /*     2     1 */
>        u8                         swp_inner_l3_offset;  /*     3     1 */
>        u8                         cs_flags;             /*     4     1 */
>        u8                         swp_flags;            /*     5     1 */
>        __be16                     mss;                  /*     6     2 */
>        __be32                     flow_table_metadata;  /*     8     4 */
>        union {
>                struct {
>                        __be16     sz;                   /*    12     2 */
>                        u8         start[2];             /*    14     2 */
>                } inline_hdr;                            /*    12     4 */
>                struct {
>                        __be16     type;                 /*    12     2 */
>                        __be16     vlan_tci;             /*    14     2 */
>                } insert;                                /*    12     4 */
>                __be32             trailer;              /*    12     4 */
>        };                                               /*    12     4 */
>
>        /* size: 16, cachelines: 1, members: 9 */
>        /* last cacheline: 16 bytes */
>};
>
>struct mlx5_wqe_data_seg {
>        __be32                     byte_count;           /*     0     4 */
>        __be32                     lkey;                 /*     4     4 */
>        __be64                     addr;                 /*     8     8 */
>
>        /* size: 16, cachelines: 1, members: 3 */
>        /* last cacheline: 16 bytes */
>};
>
>So, split the memcpy() so the compiler can reason about the buffer
>sizes.
>
>"pahole" shows no size nor member offset changes to struct mlx5e_tx_wqe
>nor struct mlx5e_umr_wqe. "objdump -d" shows no meaningful object
>code changes (i.e. only source line number induced differences and
>optimizations).
>
>Cc: Saeed Mahameed <saeedm@nvidia.com>
>Cc: Leon Romanovsky <leon@kernel.org>
>Cc: "David S. Miller" <davem@davemloft.net>
>Cc: Jakub Kicinski <kuba@kernel.org>
>Cc: Alexei Starovoitov <ast@kernel.org>
>Cc: Daniel Borkmann <daniel@iogearbox.net>
>Cc: Jesper Dangaard Brouer <hawk@kernel.org>
>Cc: John Fastabend <john.fastabend@gmail.com>
>Cc: netdev@vger.kernel.org
>Cc: linux-rdma@vger.kernel.org
>Cc: bpf@vger.kernel.org
>Signed-off-by: Kees Cook <keescook@chromium.org>
>---
>Since this results in no binary differences, I will carry this in my tree
>unless someone else wants to pick it up. It's one of the last remaining
>clean-ups needed for the next step in memcpy() hardening.

applied to net-next-mlx5.

Thanks,
Saeed
