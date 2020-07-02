Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08C8B212F6F
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 00:21:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726451AbgGBWVA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 18:21:00 -0400
Received: from mail-eopbgr70087.outbound.protection.outlook.com ([40.107.7.87]:22294
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726247AbgGBWU7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Jul 2020 18:20:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BlQnvAWO2tXJ3oeW5qsOJofAH2bU4fXGMLV8iaqXNOsh9GJQ2jC1TMAGwQhUy6iDw7G4KwUeWNhlpxGz40XTSZunII3DrduE2/PdcnH2FS9PWwOFKg8zhvUwSB5SUQe5qD7+qEV3B1+DUud2W33HWu6WiDEgr+7CIeKw+r3AumbcmxLc0ZDigZpfZFuo0GO9DwWz6mynLOaxn9OgN9z2wbNq/f+uh5mK/BYioG3SfAJZig55Ge5cv1hDa+/UnF9cbCz8Zzk8kpZ6R7vc7k034INJvE/qrmc9rmVFMyi+LFcQEZ2BJOQ2EbnqeSBxFkKr0rN4VUKG+3XUqtCBM2ckuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z5DNn16WeBHD+jmu4YSewwKN9si3egK9/1YDFXP4P1U=;
 b=js2M9NMWlVbCuVSjlpUA1d9bB+sgdTIT1+jUJnwP3RxbEQwjNlA/d+l9AmOMrWJn7WLIvfoBKUASbQZotPpTpFOtx0pMVbDevMnashh3B1J6ROo2C7iCm8P+j0TpSWugjRSgIONcUIhqZ50gHhuDAnL83IyBlSG2m5s350/fNWlAdoJXjUBLJ52l60tRDORpvP/QC2pg4db4m/TX70YPNPnlcqcKziM1xHjHnHUMPYdc3GmhM4CiIWCO5LjQXpsFZ8Q/wjRUz3k0F86imHyMCQT8tKw+BVH0XkI7BjvFFDwSckiNW0CqMmkw15clj5XsNjs5jvG6euuec47aFRDy1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z5DNn16WeBHD+jmu4YSewwKN9si3egK9/1YDFXP4P1U=;
 b=U9fjMVjbPIJBeeLhMj2lZCq9tRFED1UrQfmentassBvknVV++IiyKaQMtus4K1wNz8e+KvQDUryI27+ochUMAZsTVO/xrhuDLtJK5IJZyMYhhw+AKBP3a9v+Ko+vv7A8yDeYiDqmuwKC/ziHMff/wUVfskm+x31zPpfp3m4mPEU=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB6109.eurprd05.prod.outlook.com (2603:10a6:803:e4::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.22; Thu, 2 Jul
 2020 22:20:48 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3153.023; Thu, 2 Jul 2020
 22:20:48 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Aya Levin <ayal@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 08/11] net/mlx5e: Fix CPU mapping after function reload to avoid aRFS RX crash
Date:   Thu,  2 Jul 2020 15:19:20 -0700
Message-Id: <20200702221923.650779-9-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200702221923.650779-1-saeedm@mellanox.com>
References: <20200702221923.650779-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR04CA0030.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::40) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY5PR04CA0030.namprd04.prod.outlook.com (2603:10b6:a03:1d0::40) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.22 via Frontend Transport; Thu, 2 Jul 2020 22:20:46 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 0aaba238-e4fd-4027-871b-08d81ed62bb6
X-MS-TrafficTypeDiagnostic: VI1PR05MB6109:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB6109862FEEC72184C0E27B3ABE6D0@VI1PR05MB6109.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-Forefront-PRVS: 0452022BE1
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4EXbDjEv6HH0xd/kxK4htqAIVXUQzCv4qkxT9+7Q8h4/6G0MqXTX6/s/qJxgPhZQF4jJZyh08JLWn7KOQv81VYWXwm38EYk/YuJZLGHzJfQADg8o1sRObrksG/9In04ygO95vmvZEy50Z7RT+T3oDgMkOPlttkD+J7snWXnUXvWicGmHjLyOHoiLQORo0MCYxP5ToYJIn2cwOwrGujQhoSGPVHzOIKwp1yal+YdAn/fdhgpHhG4dErojdcOYhNcNOfcyL5qatkrGHPKHB/ppIVQaExZ5hc1xk30f/aXm855K1no+tNq5L51gF3N3azZL9oGrksni/sUbhLcMj2XhwfYM7X6LCwos1icvtU5CgWG3mKmyy5rpxz1+48rRUgt7
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(39860400002)(376002)(346002)(396003)(136003)(26005)(2616005)(316002)(956004)(6666004)(5660300002)(8936002)(86362001)(110136005)(186003)(16526019)(107886003)(83380400001)(4326008)(66946007)(54906003)(8676002)(6506007)(6486002)(1076003)(36756003)(52116002)(6512007)(66476007)(2906002)(66556008)(478600001)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: bi2+UoD8WD4uBcxU28eox5qjWydq4k0o7cCclGPcIVDcoVe83oJFFHPCWMo0sZ5hexyF/BKwiYS4boP2n1pdArWgmGi4zlggHFok8JJ/ZKTNglJctXxDR4WupGKK6Nk2idqa5Ug1kw7EdzSQmv0MwGnhfuDRn67NLi0cipkWFWtQAgLjFoitCcmd+s2OzExRu+TcESRu+JqdNFg+LafBx5P8aFxeSBModviNwDtjP2gEuB5mow/RbveTZ8BmZzh5vVIvQ1Mi7i7vF5hPYJywOyn3RA4HBShagFUDER//mRX0lxM/R0uK5FOxYLykiiROlWnFM3zrDI/XxQTw7wE3+A7dwfRQa4I1h3G7xXsjlJc9Eh1JLcKFrcoRsaWmKjsfzpqapjbxvakMbqGP0yrUXJMWk3XHDJL3lAW5Le0Gy2w27vr3z0DDPmDMjY2zobxJNNa/CZ9YSQj3Zq+7TuWML3QC2j7z9a5Hzxs8DVaS+O8=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0aaba238-e4fd-4027-871b-08d81ed62bb6
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jul 2020 22:20:48.1070
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aCwKu+zoLYzxwUab/CBwY8CclDkYBrMxz24nqMxnesAMtPr4XB9yq1f57y73Ht8YjGBOKfPxPHQRh1kuu7559A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6109
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
index 3193b0e50d2d..a38b79a22d6b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -5112,6 +5112,10 @@ static int mlx5e_init_nic_rx(struct mlx5e_priv *priv)
 	if (err)
 		goto err_destroy_flow_steering;
 
+#ifdef CONFIG_MLX5_EN_ARFS
+	priv->netdev->rx_cpu_rmap =  mlx5_eq_table_get_rmap(priv->mdev);
+#endif
+
 	return 0;
 
 err_destroy_flow_steering:
@@ -5283,10 +5287,6 @@ int mlx5e_netdev_init(struct net_device *netdev,
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

