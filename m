Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E7A721AD1B
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 04:31:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727107AbgGJCbP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 22:31:15 -0400
Received: from mail-eopbgr30081.outbound.protection.outlook.com ([40.107.3.81]:54404
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727050AbgGJCbO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jul 2020 22:31:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LI6J9OQIXCpFv7a0ufYOzkvLZcUB2wfJgtvSfV7ryTtHxPqhBFLtjrswA/medF39JXL1lyzMj5ZelDQoi4pLhhPfKS/5HiNGGLkqxysO22QrZBrJ8pnFXtvERFikaa3EseJ7fZOfe7ti5hb/UWmzWE4h5w8UHFM2tdXSY/GhCnOO/8nLzfy28h6Ga7RDAIsh66/KgrUEjnRPebVPcKUXWhCf4mHufo1uI1Ya92HQKWgfNw3ttIj0FXNZ/JQwiw4QCQ2+kApep+8g6ps1FBvJoMdfVSPQFJO5iTumWaR2cAjC9FpeU52AzjWkwr5boaazBM4tSw9fuaUFWU63wbu7lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SZ5iRHmhlV8gRWGDPccowPp++N10dYA2PokiOb4YW1E=;
 b=DTtDxBsMu+Wo54pricQ3z8cc5xWUbpRllOZ84xzwijIm9UPLRALwFUlddlEzkC4Y9y7O21z8JLbMpq+SPWY3DJxDTi8xp4I2xaBDWIbfmEX47R6Q0bkKvbsUT3PFugVV2K1AT/H05J/motwa0dRhkBJz/OqzdHAcwgyQUOMdHnopzCakHwpV2UA/byqax4IweVrHeHCxzYx0N3LyKhK4vIa7L9he0E1yLattR5jXmdQH1UpU02UkU0Msqg9pSiXwUwRYHRjIhLXyd0QmZ2eNElwWdTw+HUCWbcQUq4OSeBBOUzkHLkayxKePaAmqlfj/DfbutLg4jKIq9HYXNviehA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SZ5iRHmhlV8gRWGDPccowPp++N10dYA2PokiOb4YW1E=;
 b=FlOXGaDxQiYAr5koaBDGE66F6CUbBFhtACxPAJIKHhbpKiCg3J4ua4ljZ086yShT23T/Kdfi1sG1JpcoeZLHPm4P9Jsr012erwSW0Y4e2eIlqECs5WE72pfAeulJih3/EvtXCjITdo26zOWsDUPkMbJkCoWAkcUfzMtahsBposc=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB7120.eurprd05.prod.outlook.com (2603:10a6:800:185::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.22; Fri, 10 Jul
 2020 02:31:01 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3174.022; Fri, 10 Jul 2020
 02:31:01 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Aya Levin <ayal@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net V2 6/9] net/mlx5e: Fix CPU mapping after function reload to avoid aRFS RX crash
Date:   Thu,  9 Jul 2020 19:30:15 -0700
Message-Id: <20200710023018.31905-7-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200710023018.31905-1-saeedm@mellanox.com>
References: <20200710023018.31905-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR06CA0064.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::41) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR06CA0064.namprd06.prod.outlook.com (2603:10b6:a03:14b::41) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.21 via Frontend Transport; Fri, 10 Jul 2020 02:30:59 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: af7d9fa3-14c3-46fb-1d69-08d824794953
X-MS-TrafficTypeDiagnostic: VI1PR05MB7120:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB71205433AEB7562A55FA768EBE650@VI1PR05MB7120.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GB9MBYNsFzphapezuN5WouQ/TnAK4uwrpCuPwPxNK6Gae0xeByXci9q2dZlY8KpuyXiJCee4BdY9h0HQDxh97NZEJ7bb6S6xVEFTuvpF3OiCv6P6Ln93Adf4joq2yRrxqWLn5llAH8OL4LtcCXLDizQmIX8mW0RQ4sgQS85eNi4rhkMjjLEdjNBvZSvf3s9QC95ebvFQsd7Ey5RVj6QfdEG3njpGgmFyguu2m4H5SIh26y881b4JUs44wdWYT8DtWRcsXvsc76elrXc8dtZYi4PbnPVqQvipFibw/AQWt8AiqwOcL+g6M2rDhh9M7NbTgK+ql2SH8URII4rt+OwE1n55p5EIMmlcX9jhJjFJf/8uHDKdpw/2jmNQzJQis1jO
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(376002)(136003)(39860400002)(366004)(346002)(478600001)(26005)(4326008)(86362001)(52116002)(83380400001)(956004)(2906002)(186003)(16526019)(6506007)(2616005)(6666004)(5660300002)(8676002)(8936002)(66946007)(107886003)(66556008)(316002)(66476007)(1076003)(6512007)(110136005)(36756003)(6486002)(54906003)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: bLQpEh/lsHolHvbYNet0PGmdLQToqjhgMKUatu9ZwBLp9aOSRofeqy1yMVLJQ2/qjcBg4ywVtxVidb14w0L7MefmJMGADpCdkWO98cc4uXHIP408SKTIvVk/VwI6MJ5rd4Q50ljaHUbzw479UH+8Xk9H3PpE7zCldZGC6AGRjVT3J5UVNXWSSCK6QwBCb6tiatEjj9F3t9rdT/6gJV1kaVzCZ/uqJyd71UNMEBr3QKbBEKuYGL1ENopfXmAhYzbgloAD/r2SYsEv1NxnE0fX6crmacvQlcgA2hX2TCxokSZ/RvndBLf8dcjrH0YgKTmmclQg4xPGsxUINaOEszALGGSSDxUy1RH4DQd2eeuG3hL0VvM5qLGEhLzHKXImrldQe1DOt8BSrHiLVBLXUVpVaS52spa3CPZuHg6kLk8Op8nEJ3vzPPpgdevDRGcbJuZNeALuuy1wrijvkJVM5TzoZQ613esuq+xpjjIgLzdMUrg=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af7d9fa3-14c3-46fb-1d69-08d824794953
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2020 02:31:01.4630
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /MpVN5Edju03DrbCA58x/fOheD88gP7+Ri7gGPUk9Fv2CBEUQ38Sz8ab5V9OV7Fir3clV/Qd/7LEQx9JRzTo3A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB7120
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>

After function reload, CPU mapping used by aRFS RX is broken, leading to
a kernel panic. Fix by moving initialization of rx_cpu_rmap from
netdev_init to netdev_attach. IRQ table is re-allocated on mlx5_load,
but netdev is not re-initialize.

Trace of the panic:
[ 22.055672] general protection fault, probably for non-canonical address 0x785634120000ff1c: 0000 [#1] SMP PTI
[ 22.065010] CPU: 4 PID: 0 Comm: swapper/4 Not tainted 5.7.0-rc2-for-upstream-perf-2020-04-21_16-34-03-31 #1
[ 22.067967] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.12.1-0-ga5cab58e9a3f-prebuilt.qemu.org 04/01/2014
[ 22.071174] RIP: 0010:get_rps_cpu+0x267/0x300
[ 22.075692] RSP: 0018:ffffc90000244d60 EFLAGS: 00010202
[ 22.076888] RAX: ffff888459b0e400 RBX: 0000000000000000 RCX:0000000000000007
[ 22.078364] RDX: 0000000000008884 RSI: ffff888467cb5b00 RDI:0000000000000000
[ 22.079815] RBP: 00000000ff342b27 R08: 0000000000000007 R09:0000000000000003
[ 22.081289] R10: ffffffffffffffff R11: 00000000000070cc R12:ffff888454900000
[ 22.082767] R13: ffffc90000e5a950 R14: ffffc90000244dc0 R15:0000000000000007
[ 22.084190] FS: 0000000000000000(0000) GS:ffff88846fc80000(0000)knlGS:0000000000000000
[ 22.086161] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 22.087427] CR2: ffffffffffffffff CR3: 0000000464426003 CR4:0000000000760ee0
[ 22.088888] DR0: 0000000000000000 DR1: 0000000000000000 DR2:0000000000000000
[ 22.090336] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:0000000000000400
[ 22.091764] PKRU: 55555554
[ 22.092618] Call Trace:
[ 22.093442] <IRQ>
[ 22.094211] ? kvm_clock_get_cycles+0xd/0x10
[ 22.095272] netif_receive_skb_list_internal+0x258/0x2a0
[ 22.096460] gro_normal_list.part.137+0x19/0x40
[ 22.097547] napi_complete_done+0xc6/0x110
[ 22.098685] mlx5e_napi_poll+0x190/0x670 [mlx5_core]
[ 22.099859] net_rx_action+0x2a0/0x400
[ 22.100848] __do_softirq+0xd8/0x2a8
[ 22.101829] irq_exit+0xa5/0xb0
[ 22.102750] do_IRQ+0x52/0xd0
[ 22.103654] common_interrupt+0xf/0xf
[ 22.104641] </IRQ>

Fixes: 4383cfcc65e7 ("net/mlx5: Add devlink reload")
Signed-off-by: Aya Levin <ayal@mellanox.com>
Reviewed-by: Eran Ben Elisha <eranbe@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 888e38b21c3d..081f15074cac 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -5118,6 +5118,10 @@ static int mlx5e_init_nic_rx(struct mlx5e_priv *priv)
 	if (err)
 		goto err_destroy_flow_steering;
 
+#ifdef CONFIG_MLX5_EN_ARFS
+	priv->netdev->rx_cpu_rmap =  mlx5_eq_table_get_rmap(priv->mdev);
+#endif
+
 	return 0;
 
 err_destroy_flow_steering:
@@ -5289,10 +5293,6 @@ int mlx5e_netdev_init(struct net_device *netdev,
 	/* netdev init */
 	netif_carrier_off(netdev);
 
-#ifdef CONFIG_MLX5_EN_ARFS
-	netdev->rx_cpu_rmap =  mlx5_eq_table_get_rmap(mdev);
-#endif
-
 	return 0;
 
 err_free_cpumask:
-- 
2.26.2

