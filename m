Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A99CA31D0B4
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 20:10:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231194AbhBPTJR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 14:09:17 -0500
Received: from mail-bn8nam12on2058.outbound.protection.outlook.com ([40.107.237.58]:51168
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231247AbhBPTI5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Feb 2021 14:08:57 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KBU1My5xoFF1aA8Q51D7+PzPLbBYyQQPVxxCFm6/Xe3ScK00dC17r2za+5Zk7hQFGe2Szxn8IgIqnNXPeqbR4bzgc0GY7gXGfdz0MR8Q2jmEBG/NQybGBse8esa6nuSUoF9EZj1410OUr2ZRAnyw1UmX+m5tyiN4O1nz5v4Y2V7mIuwKT3lFXJM0lyWM1fysgnipuwNeHWk2iW/jEjg66xmL4I2gLkVMZZbDToN5hfopfYURF8vmfAfdlaj1hYH7Gdvnpn3LWpXEo1PcQkydHWT2hJJYCBcubzYGHgVwOoF7IWbiiciatqMa5sMMVaxnxvyDcg0VgYDIiIfXemZ4rQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TIqzXFiat7pbIGtFHKIXloHJf+aIrPnyJzi7SW06kfM=;
 b=HFDreeKrm4HeT0dvxgAeFfI9TDqBaCz5Ll0G+jyXJwpa0NeLKtNOWH/ZQckO2AJcHzGlmlY2vKEw3iaGrMoXd4ufk7gUaXO/QiJV2jSuRKxsUXvMzCevdQlEvCvKIh2LaOygQHSkxUUqngZtpiK01E9Ga4nFLW3Jay86MvlRjE2feWp7ozOg5wB464Yd5N4Ez1QEFnlHEh2dcF4vEgHOWfXcWPCLbasJoYDEg1fuky7EgQbzxwsNEhxBk6zBMnN1xo/Rcq8gNhD86brN3LBJ4RMVlL842skqeOrbYciL7E+fVMZ4gUnmxGGQDSquzSvwEPz7qkbE8hmyg0RjNKEGAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TIqzXFiat7pbIGtFHKIXloHJf+aIrPnyJzi7SW06kfM=;
 b=twq6NePJ44AKqc79SZy8WnItdK4yDWgqmrgc3y44T6nOE8GEPyynSxX09fDLPoHzEcaRrKnZ1bX5KM7LZ22SWOOxG3ZoZx0fq1KFQZ3zR2y3IeKyXKav82rFx2mJS7YrnYyUpXdZZjzNunHK9HTlLNEXbq0GN0mdG3sNv22ENtE=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from BL0PR12MB2484.namprd12.prod.outlook.com (2603:10b6:207:4e::19)
 by MN2PR12MB4112.namprd12.prod.outlook.com (2603:10b6:208:19a::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27; Tue, 16 Feb
 2021 19:08:04 +0000
Received: from BL0PR12MB2484.namprd12.prod.outlook.com
 ([fe80::5883:dfcd:a28:36f2]) by BL0PR12MB2484.namprd12.prod.outlook.com
 ([fe80::5883:dfcd:a28:36f2%6]) with mapi id 15.20.3846.031; Tue, 16 Feb 2021
 19:08:04 +0000
From:   Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
To:     Tom Lendacky <thomas.lendacky@amd.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Sudheesh.Mavila@amd.com,
        Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
        Sudheesh Mavila <sudheesh.mavila@amd.com>
Subject: [net,v2, 2/4] net: amd-xgbe: Fix NETDEV WATCHDOG transmit queue timeout warning
Date:   Wed, 17 Feb 2021 00:37:08 +0530
Message-Id: <20210216190710.2911856-3-Shyam-sundar.S-k@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210216190710.2911856-1-Shyam-sundar.S-k@amd.com>
References: <20210216190710.2911856-1-Shyam-sundar.S-k@amd.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [165.204.156.251]
X-ClientProxiedBy: MAXPR01CA0074.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:49::16) To BL0PR12MB2484.namprd12.prod.outlook.com
 (2603:10b6:207:4e::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from jatayu.amd.com (165.204.156.251) by MAXPR01CA0074.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:49::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Tue, 16 Feb 2021 19:08:01 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c115b4be-3ba9-4052-660c-08d8d2ae2f84
X-MS-TrafficTypeDiagnostic: MN2PR12MB4112:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR12MB4112B971EB53FC74EDC61C7F9A879@MN2PR12MB4112.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: M3nEi2Ko8wWiL9VnG+ngNGP3YAhQxYCDTHpwTutofnXKuIZfxr8aQqIDxki/WlAOwYDJAQOcHh65pzTDGeGD5fruXXbiqkdrosYgl9wTewdfo/oKDI6RiAS7kdRfevNjf2sSiLXrFhLOtvDzYhOm0OyOcCDdVN418BjSrR8p+NE5Vf7iiF1g3ozYdPoK3nDAY54RcHWDIFCHNkwMrYR6ucWqLq7tSi4dDWAg3bvDAMZlLgGO8RFAbu2SX0WFsmt/hBUHmPoOt8WcTX9o2r/dIzOOWiTeuePy5nM6wFXTgW1QoCC6UBbnKivpzu15AEz2gxmLyJJNPBSuSN6Z1LBl/qE2+yB4SNZ0lRiv2LlR0V6psK9wYtbjse8m69ZCwbrsjb9Dnom10FLcH1B5LEmpcGSZr6rrONRIEy7bl90iyR6vuLkHz1B8/LrV9JgL107qMePUJLBVMM/IYjNhdYiRYOBJHJvlWchVsVh7H6ZLB2JkVLVlBtRxq/T/PD8emz9eESS27ORboqiDgPlcEFalQQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB2484.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(376002)(366004)(136003)(396003)(7696005)(54906003)(1076003)(83380400001)(8936002)(86362001)(66476007)(2906002)(4326008)(8676002)(52116002)(5660300002)(478600001)(110136005)(186003)(26005)(956004)(66946007)(2616005)(45080400002)(316002)(16526019)(66556008)(36756003)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?1JqZa2YYajhtsUU+YkMVpTMp2KcJiRE6oLaVzw/tocDVfYKMlnYXRqM7s6kc?=
 =?us-ascii?Q?lzrBeTgfDUHkR0EInmcAA2M7neMuYSQESiczmtoFAB/R0BP9ZJ7Np/ZoNqgG?=
 =?us-ascii?Q?ZbebeUj7DrTCbdvIQjYvkOpq5NC9GGwRbC+XQU1hNZHB/PdCypIf0YXVRwMm?=
 =?us-ascii?Q?Sb6YL/3oKfi8n5yU+GgT6rnO/5jnjZ7remsYeBJoRC0BAYyF+fz/7twQ0M9s?=
 =?us-ascii?Q?qiyJu725tEvTd8/lVyDnbYKhzREyxK1BIUC5n/FRr2QGD2NXA6rlfa+xFzpA?=
 =?us-ascii?Q?Fm+15aGE0hDFZd5lRF+MrP9nkYuB11Z/hJhvcMtUqILWKnjLjOscUijvWYjJ?=
 =?us-ascii?Q?3eqIaPHmd5GdG9SPIJhcDKKQRi4jJg4IB5X0OePKnPF8KhckEThzL7aZQzgu?=
 =?us-ascii?Q?eVnPI4s984rWd1dq7ZvMSk+UEBLkY+O90+XKbrSXzJ3Bt/4gVZCr9tjN1Lat?=
 =?us-ascii?Q?ukX6HGt3j0M3N6MNlRBDfYXsvifUtb7OKHx5G6Sa+lZbj8woK0rcWBZevY+k?=
 =?us-ascii?Q?g9JSW43Fe7tBQIxT7OqWUMstG7jOiIAno2AuBVvUSs6B1BgGrBKEFB7Z36ga?=
 =?us-ascii?Q?PeEakBO5OxSySzVTzqj4/Jg72WXGIQKZqOjMiDSm6TV/YGRwh+MbsMs4RUyl?=
 =?us-ascii?Q?45zhOaCuVbG8Q7uFb11hIDexrpqXNXrir5+c76IEJiO8xmGOsMKsKXFmacAb?=
 =?us-ascii?Q?FPteH3CFvvIzbb1rUlUkNYR93sbZCFMHYvaRL1xmqhgERA2+1Zno/fzMWqEX?=
 =?us-ascii?Q?FI6xZMWE4m7QlqmBQIfkrmS+oPdg7tSyN3M9YS66gL0kaFogyXFgqBmrSp4K?=
 =?us-ascii?Q?mg7RfByE6i79sJub/WBfTH/DceaFHP1Uu5fzesUUQvDEggKkegCAglja4ShD?=
 =?us-ascii?Q?8KXMDpjuXp10w+dpMf7tL2gmiafHNFHModdX2jDF3ii1ePNvsxwi3tXrokyO?=
 =?us-ascii?Q?Ogsf8YxXOo8DBIGawU1ceT4P+vr6UGOEjZjSRHsf+7XIP8xja1QbPylusYcR?=
 =?us-ascii?Q?6dblG0QI0VmcTGFyWVIn22QcH3HmGgea/HJMmeSjY8tcJOy/NAN2haqOlTvk?=
 =?us-ascii?Q?CBnDVzexC06wEOBW7FtDZShmv9uiLTGb1NPYYRuRWsIYubPQQk0Zj7DbrNq2?=
 =?us-ascii?Q?KGPGMXPds4xo6npYeQ5w7kvnhwwBO9IjTvaVlYbR7aacCGPKw8xWd0KndGAi?=
 =?us-ascii?Q?+w2KZUBOm0WK4WFAQ2gB3AH70L2+wFaJkYL3u+pLkdJucQdx6tzgAu/Mu3o+?=
 =?us-ascii?Q?sb4kgDRjXvLx/bKVXnBfAWVHkH4WkuMMc3t+RVyQLOViyZklf+eAnqvWvn8K?=
 =?us-ascii?Q?9cxF8Ttmi2VZpd2FigZb1NZp?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c115b4be-3ba9-4052-660c-08d8d2ae2f84
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB2484.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2021 19:08:03.9351
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xD34UpfB0ovUazhJQjrNRgeGf0+IIWg/1KXkEP6YmBs3xc6rbp6TuqMYklTIiLshLOHFhUT8SLKuLLMbvdLIjw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4112
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current driver calls netif_carrier_off() late in the link tear down
which can result in a netdev watchdog timeout.

Calling netif_carrier_off() immediately after netif_tx_stop_all_queues()
avoids the warning.

 ------------[ cut here ]------------
 NETDEV WATCHDOG: enp3s0f2 (amd-xgbe): transmit queue 0 timed out
 WARNING: CPU: 3 PID: 0 at net/sched/sch_generic.c:461 dev_watchdog+0x20d/0x220
 Modules linked in: amd_xgbe(E)  amd-xgbe 0000:03:00.2 enp3s0f2: Link is Down
 CPU: 3 PID: 0 Comm: swapper/3 Tainted: G            E
 Hardware name: AMD Bilby-RV2/Bilby-RV2, BIOS RBB1202A 10/18/2019
 RIP: 0010:dev_watchdog+0x20d/0x220
 Code: 00 49 63 4e e0 eb 92 4c 89 e7 c6 05 c6 e2 c1 00 01 e8 e7 ce fc ff 89 d9 48
 RSP: 0018:ffff90cfc28c3e88 EFLAGS: 00010286
 RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000006
 RDX: 0000000000000007 RSI: 0000000000000086 RDI: ffff90cfc28d63c0
 RBP: ffff90cfb977845c R08: 0000000000000050 R09: 0000000000196018
 R10: ffff90cfc28c3ef8 R11: 0000000000000000 R12: ffff90cfb9778000
 R13: 0000000000000003 R14: ffff90cfb9778480 R15: 0000000000000010
 FS:  0000000000000000(0000) GS:ffff90cfc28c0000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 00007f240ff2d9d0 CR3: 00000001e3e0a000 CR4: 00000000003406e0
 Call Trace:
  <IRQ>
  ? pfifo_fast_reset+0x100/0x100
  call_timer_fn+0x2b/0x130
  run_timer_softirq+0x3e8/0x440
  ? enqueue_hrtimer+0x39/0x90

Fixes: e722ec82374b ("amd-xgbe: Update the BelFuse quirk to support SGMII")
Co-developed-by: Sudheesh Mavila <sudheesh.mavila@amd.com>
Signed-off-by: Sudheesh Mavila <sudheesh.mavila@amd.com>
Signed-off-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Acked-by: Tom Lendacky <thomas.lendacky@amd.com>
---
v1->v2:
- Add Co-Developed-by: and Fixes: tag
- Commit message changes.

 drivers/net/ethernet/amd/xgbe/xgbe-drv.c  | 1 +
 drivers/net/ethernet/amd/xgbe/xgbe-mdio.c | 1 -
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
index 2709a2db5657..395eb0b52680 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
@@ -1368,6 +1368,7 @@ static void xgbe_stop(struct xgbe_prv_data *pdata)
 		return;
 
 	netif_tx_stop_all_queues(netdev);
+	netif_carrier_off(pdata->netdev);
 
 	xgbe_stop_timers(pdata);
 	flush_workqueue(pdata->dev_workqueue);
diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-mdio.c b/drivers/net/ethernet/amd/xgbe/xgbe-mdio.c
index 93ef5a30cb8d..19ee4db0156d 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-mdio.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-mdio.c
@@ -1396,7 +1396,6 @@ static void xgbe_phy_stop(struct xgbe_prv_data *pdata)
 	pdata->phy_if.phy_impl.stop(pdata);
 
 	pdata->phy.link = 0;
-	netif_carrier_off(pdata->netdev);
 
 	xgbe_phy_adjust_link(pdata);
 }
-- 
2.25.1

