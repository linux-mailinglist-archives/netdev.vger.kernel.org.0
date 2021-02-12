Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 336EB31A427
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 19:02:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231578AbhBLSCF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 13:02:05 -0500
Received: from mail-co1nam11on2056.outbound.protection.outlook.com ([40.107.220.56]:30048
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231426AbhBLSB5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Feb 2021 13:01:57 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gh2WM+oBzZs8UX5y1yTUCOy67JvjHkGwxyXCn75I18LWSEQrPz+NDMix6Ow51BQNTDUNJvOvCOIAVfWjHx6v2F3L5sT2607I6k2Ts1FavGfWLSaZB1/ZLL88Up38zAbZIn5rPpdw1MhIJNEIO9qYYmHUPMpCXxuUAS4RpYgnPOlO+BBTjYcqudCyDumakS2bnoFdT0O1qYUoc+8B5VZOP0ja9t43JE35BIAGhmvQSkaQ3AA6fe1WTW8eMyEZcPXDI7MJPn2zMO6NN4LLt9MgHkJJztwFTJlYQIOMrlwT+nu4fl1fHG6E2MtdJvcw68isajRXVvKDOYuhtvQ34kcRGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L46BZZxPmuYL0WFZfhKTvLKYZ4PAM1AK28xpONHR+3M=;
 b=oZydRQ41e/DnjDRi4Ia4QT/n6CPNyIuPKYDMV7gqAsC8GY5FDHHl1oeVqZlTPJIkVYY/NpLwoPMYzW7qgdqMOygWXX2L+Q4RtO6ipQeOqD/7ikBSzH00BGK1NtfCZTaPKw0h2lrXeaLp8XfUzOU+OefsosYJ5xZNhcpmwvxXaxEABS0C5os8XFOZEjogyIw03xYffPkJ3er/5nAgS4cHTxz1MJNCfmGDdAk3C6925Lmo3BEOXpqZV/HQ6OwDh/3WWQat0TNBoz2qUqvO1AjN3f2GJGYQ22m7HSqtx5f+FJgf+YzO+8jbCIFp1l2Mpy5cEQxVvk4PlBZYwlyKlnQcKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L46BZZxPmuYL0WFZfhKTvLKYZ4PAM1AK28xpONHR+3M=;
 b=lZRmkEkHe6Ud7MxGcdpdi3kwO69G/blsR2heuckQQiOn7ILoQ2Kg9Z5PXp0UlFQXBuw8zEDFsierZ0rTn/quRJHzhARmq3c7snTANzpVn5INyKpDjepfrvELbqfvmXFVzr4V9EfkYwlptelFLtyYoUapD9t85cra4Zh8/Lgrk3o=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2495.namprd12.prod.outlook.com (2603:10b6:802:32::17)
 by SN1PR12MB2399.namprd12.prod.outlook.com (2603:10b6:802:2b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.29; Fri, 12 Feb
 2021 18:00:52 +0000
Received: from SN1PR12MB2495.namprd12.prod.outlook.com
 ([fe80::319c:4e6a:99f1:e451]) by SN1PR12MB2495.namprd12.prod.outlook.com
 ([fe80::319c:4e6a:99f1:e451%3]) with mapi id 15.20.3846.027; Fri, 12 Feb 2021
 18:00:51 +0000
From:   Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
To:     Tom Lendacky <thomas.lendacky@amd.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Sudheesh.Mavila@amd.com,
        Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
        Sudheesh Mavila <sudheesh.mavila@amd.com>
Subject: [PATCH 2/4] amd-xgbe: Fix NETDEV WATCHDOG transmit queue timeout warning
Date:   Fri, 12 Feb 2021 23:30:08 +0530
Message-Id: <20210212180010.221129-3-Shyam-sundar.S-k@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210212180010.221129-1-Shyam-sundar.S-k@amd.com>
References: <20210212180010.221129-1-Shyam-sundar.S-k@amd.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [165.204.156.251]
X-ClientProxiedBy: MAXPR01CA0089.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:49::31) To SN1PR12MB2495.namprd12.prod.outlook.com
 (2603:10b6:802:32::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from jatayu.amd.com (165.204.156.251) by MAXPR01CA0089.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:49::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27 via Frontend Transport; Fri, 12 Feb 2021 18:00:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 89f88554-7dfa-477f-73f3-08d8cf8022ab
X-MS-TrafficTypeDiagnostic: SN1PR12MB2399:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB23990E69A1D086FD9D0C2D2A9A8B9@SN1PR12MB2399.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MPhfdlC845Kp+qwC7lxPP7TFR1aOdRHupBAsq0u4eO6pSs410FcSQWc5IPSvY66wWTds9IqVNy18I2t3GlN2oEKjgjzTxEr8vReBSXvhSOHxT+aviBxyD1qbUO/IC8s0wl5LCv9tMLE0qllTG7iJfYJLa/Po5GNhubF5rkp0QtzPo+FwJ87C7CHXrhSw6QIeUtY5tJys5VASZwZwMJw6Mmk/zuGIqKdv1ARMpTXf7KBzHMnIWJ4+DMvrbM1ZC139QKNGw+DtCXq0bkRKB+CtkOHWvJp+nmXQEZ1bqw/NWiIm9oWFYHdIGjHuhbM86IOPqi+O5BOLmfQgIC+CF01EWE+XF7SJpaL78+wln7G8EBlsFsdtZSwbht3K0wnJs0SMykF/FFNL4YV4vQDBbw+AxUkCVpLmiSyY75JgLr1UsReAHABoAQvQqko/y57rvlmA+uTsmsTiMqIGlrtgeHHGD+uXT2LGiWv9RNF131PmFFVt/c73kI+NxKGP+RmtZXV5GlfESV7iwaxP5l1WWHHuFA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2495.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(136003)(39860400002)(346002)(376002)(66476007)(66556008)(66946007)(956004)(2906002)(45080400002)(6486002)(36756003)(54906003)(52116002)(4326008)(2616005)(186003)(316002)(16526019)(110136005)(6666004)(26005)(86362001)(83380400001)(7696005)(5660300002)(1076003)(8936002)(8676002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?rERYYpmyU+P9mitv39hHDRPdh1mNvKF5s2H7mn11s94I0I7kiP8sANbwRMDQ?=
 =?us-ascii?Q?/X7dhvOJHOyltvxY7aeuPHcacq85R9RNTIg3XrqhyuHniG92hHpoTdlebzS4?=
 =?us-ascii?Q?APA+uQadWRdqYmajd0zFYUmxHalOESO9tqxfaywmEdwOCY31C5vTwkI2Ke27?=
 =?us-ascii?Q?ulqPjbzJI7PLMMHkHI+XxebkoGpRExmtoqpAInR4vssuFrIa28O/6VlUdw2Q?=
 =?us-ascii?Q?imLNlsqzQNZ52ToMzeLuDbJCV0q5d6s/D/RKZjALIbOoPrzicQqZ8CCpqR3X?=
 =?us-ascii?Q?gZoXyLJwyz1y0o3VUerwwlS43uD0mtmZcedIoru+sRCQTOjxDzC91GPpI/+p?=
 =?us-ascii?Q?9gMPqlQ205DOioHlN80ig+uxO+jFjqJA1nqalJ0OK7MzdOJpQA90UVyjl4Ee?=
 =?us-ascii?Q?tLibfoNbi4UOevFwGdOnghL7RdHgUM3GiPQD6d0c6mdZ2nLceuP3m9cMMuVB?=
 =?us-ascii?Q?pPRrNOxH4Bzi2Qpb3mvOb5i7NQCSlEU6wE5plO9mebVxRFpTXC6uSCL+Abdd?=
 =?us-ascii?Q?m5jDp8ubQyJTzXu8NuulzWMNgyCEsj8onazYkh2cttoRs2xXigglevmGf3uE?=
 =?us-ascii?Q?AE4En8oucucqIbbzRSAC1NkHvqZwjLWKqCBk1GRaR6bXKSQaWKXpEqRUv5Yc?=
 =?us-ascii?Q?g1H/ck3o1JXviKRDFIoCENCIJZ4hGBGXgEjFP26fAIF7Iha3LX0IiszVWvEl?=
 =?us-ascii?Q?DozOupyk9xYCgWu2eHIUUxOJzVkA+xJGMS5yrBvbPDoh/q+Fgke4nac0Tq1D?=
 =?us-ascii?Q?hcTjgJD4nRisUDgJCLEw2E8Nh/YI5FfAx75PfqZ0/aDa0Sg5qMfbI2BxP4DP?=
 =?us-ascii?Q?XzVEBvwn+ioVwBC7/eMN3d4ZI/9xWYXgLlTgRsYAd0i3d5WvzDGt+lcFshZK?=
 =?us-ascii?Q?HwU7Ud/yurg5S6CXsAjGQ74YiOjRNumN0AzvR0W2nbd+dyUzR4dSMY9V1iAZ?=
 =?us-ascii?Q?ujr9uo/AR04K9vUkCRIIEcQk1Il5Ev0aYX6hBcJUGByaYxUbGWrGdmtBUSIj?=
 =?us-ascii?Q?J7Tw3GwzJ8cREWiO0j7o/WIlCj6ilwOqti1EpQHWB/CIMpyCAmnhAmo7Ip5M?=
 =?us-ascii?Q?dce5wbJyKquIWNCQiJA8EDVm4XVKg+R4Qi/1nusIeIEoEGexuG716Dh2GAG4?=
 =?us-ascii?Q?5JJ5lY3X9aVYXdxbGzUDM6S1+svXCuqMP8ocAlBkMHNsH5fPtGE66s1mh6yY?=
 =?us-ascii?Q?zGrldNmqvMKHdladsuT7p6Y86gt/fiqPknb8k+1xiKkFRs07aHH9rwj1fmKX?=
 =?us-ascii?Q?QJORn9CX0oLbidN6IWkHmL+EnGh9mtQWGzprBkEf21YVv6yhk0UDTSiTGAiT?=
 =?us-ascii?Q?vZcMMLltYYsbTmQfqX9vBhEmE8DUAbC2yUHd3uvRmCxveQ=3D=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 89f88554-7dfa-477f-73f3-08d8cf8022ab
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2495.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Feb 2021 18:00:51.8849
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aytCE2JIqEtQ+eslXJrTqls5iycybytERmcp8UEQFjy+faz68SjORbLd/n+ZBZotX/Onk3snhhGW1nN6WY/EqQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2399
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Current driver calls the netif_carrier_off() during the later point in
time to tear down the link which causes the netdev watchdog to timeout.

Calling netif_carrier_off() immediately after netif_tx_stop_all_queues()
would avoids the warning.

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

Signed-off-by: Sudheesh Mavila <sudheesh.mavila@amd.com>
Signed-off-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
---
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

