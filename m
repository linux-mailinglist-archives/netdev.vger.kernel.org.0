Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A81F72CE5F0
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 03:48:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726865AbgLDCr5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 21:47:57 -0500
Received: from mail-eopbgr140081.outbound.protection.outlook.com ([40.107.14.81]:37121
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726558AbgLDCr4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Dec 2020 21:47:56 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F0ashuzw67j5K0DdEtt3vWakzuhY5NCIMlp1DVEajR3iFQ6JuN7kL/sxrXQkqwZXxtMqMP9MwPqkGh/1gaVmZdsV1VdPTRaaLxye0pofiA9122ljEPAKr4XEfUImTzOAhM/I/W07ar5ZrriuQi0dapAGgLfVv14aB1Bv2cOhysQRUQgGHJi/WIXgaq4trem+iu0Y83T/JNz/ahO8KZjqBYoq9axY8+MwUFnQtLBpI2zU+xuuV5Y39UELdVknQK4PN2FdvWsjek9cOYC5rB8FrwX9duXuo/BJYSxmxtS3WEApvSqHJ7oVOgmkA18CEaooAB0+DzRx9ENCic12PwpW1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2alYby+BYm+OeHs39H8hqadqbhg1Dg5kKh5UAw988kw=;
 b=nKaO7EZrjJUdZ8mIu8W+3bJ0ywpwiHbtCcRYHojkQfInIH/1pDrOvYJ6sbLPoz6Kg6Zq4oHq3IMGNa3mBSFta5AfPpdveu8FTaK5g/9Bx4mHnSZAG/IoBVwOjoDcUBdACF9LNAkQawHnwZ5D1zgn2tFciaL1mgyvig5+ctXdu3CIla/wfr0SGQhsVercNxYWitpq4eX+D3pr2FelfwB59S7oya5/6IJT7Laj65xa/74BtJK87JXh0qz/sMKE0GZpajr8hTW6Kh2ra0yIzIXUFu5tTx+dkXj3LNRgZNOPKwi539wNM1QKHnWv4somxgPibsEyg50GqtWjeBUk5708gQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2alYby+BYm+OeHs39H8hqadqbhg1Dg5kKh5UAw988kw=;
 b=spE9BjW4wr2nKsEZAU8HacVVuTqWr+5kNSvNux4biNcUlZJg6crq1yakm0AOZBKisQA7/rI9esdemFF5h5ugLgU0IwBt4udApV78p4nB7j0ZnlenG+vmOxinltWn7EJm3VfBmEH2q7H2xa9FYyFhFkVyZD4rgUdCinYJPIfsm0o=
Authentication-Results: st.com; dkim=none (message not signed)
 header.d=none;st.com; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB3PR0402MB3707.eurprd04.prod.outlook.com (2603:10a6:8:2::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.25; Fri, 4 Dec
 2020 02:46:31 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::b83c:2edc:17e8:2666]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::b83c:2edc:17e8:2666%4]) with mapi id 15.20.3632.021; Fri, 4 Dec 2020
 02:46:31 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-imx@nxp.com
Subject: [PATCH V2 3/5] net: stmmac: free tx skb buffer in stmmac_resume()
Date:   Fri,  4 Dec 2020 10:46:36 +0800
Message-Id: <20201204024638.31351-4-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201204024638.31351-1-qiangqing.zhang@nxp.com>
References: <20201204024638.31351-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: SG2PR02CA0052.apcprd02.prod.outlook.com
 (2603:1096:4:54::16) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2PR02CA0052.apcprd02.prod.outlook.com (2603:1096:4:54::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17 via Frontend Transport; Fri, 4 Dec 2020 02:46:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 834f4403-538d-49b5-5398-08d897fece78
X-MS-TrafficTypeDiagnostic: DB3PR0402MB3707:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB3PR0402MB3707D2AFBC1A2407B3319D83E6F10@DB3PR0402MB3707.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: b9Tvw/v8rmj/kX3Kg0y8dc942ZYnsXwFAw2gQRWt0IdMhGfZu/iRyOYru6ECKdddPaF+2nt5TBegvfmkjEgLCMkvhxwpZbcaBVkknmpNPn/EQwf4E0aFogWWRY0C92uew2LKFf7LCtTN2EEX60zCpRjpo8K8dEbrVqt/siLffB0SD8jhVOSzo0ZOEQdrk0har2VwjToApIpP0WkO7XGylqTN/2los1IA4k4r8oKMSwQ5bt09KBok7MkOMe76dBiBPj1o34ogTZmhgjsilopNpv9sp9ToLXiKKM2d0LtOzQ3x5O22t7Qu0c2OCu94ljIH9q8lMhxJgWeOq0UbhfdAU82iQnzVloIhxbZYvOMX9INUSW5Yz7zQzQIDfbVNWQBh
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(39860400002)(366004)(346002)(376002)(45080400002)(478600001)(69590400008)(1076003)(6512007)(66946007)(2616005)(4326008)(5660300002)(8676002)(956004)(86362001)(66476007)(66556008)(2906002)(316002)(36756003)(83380400001)(6486002)(26005)(6506007)(52116002)(16526019)(8936002)(6666004)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?S4VlT2cagsfY5VtmmEo9mQvUR5Ir3zDcTh1xX9f7R6qs4ikJaQIMfIPyCr9X?=
 =?us-ascii?Q?TdhIo5QJ+6T8XCh5hIKOwLduvJgbSIlRQF3hHk+ilz0CJawzty/EhZk1UKUn?=
 =?us-ascii?Q?f8qryMehZ3dN2/K3GkRU+0wI7BpFkMZEb9RRbQGAOHoe2Z6wczpwwo3qV9fE?=
 =?us-ascii?Q?Ray28cCUGzWELmPZ+LyIOzQuc/mNZLrIk4NZP9wEU/iBVeaa1Rzkn1HouGG9?=
 =?us-ascii?Q?/Tnu76cFoBusK/gpBj4ku+/nKDkctOb8bZQatzif57GZ3B3EwI1OSP13LdDG?=
 =?us-ascii?Q?NT+OJcNI54L3Rn4DseQLe5XLhDqzE+OeFMIQyDSALBA+Vm7raA132bRmgUxF?=
 =?us-ascii?Q?SVBCKwUP+paRATHQqz3Nzagg01VBFZzpAMZ/MK9PhC6CU9NcDAq++bZ4c6j1?=
 =?us-ascii?Q?7a8rD5sLMRZha1h8M5qhV3x5PzoBnUPLaW8tLzyeXrFI/Ijs7x2wKh37EI7B?=
 =?us-ascii?Q?ojwIfCoF8/tB6WExLJwENNLua42Uf+Md88MLlsV7vlpvwcgoGASSyO+lhHiz?=
 =?us-ascii?Q?uPbBmySN8KUKhMUQmVl9RN/xKNY4pkzzRxZPpYst5pQ2orS/hDl85z8JQIWG?=
 =?us-ascii?Q?hTlbZwdpUpCAwv5GVmY726N9zZwv0LyxFu4mfPVq6FBqCHhQVTqEj4h6UV4a?=
 =?us-ascii?Q?MgtElsWttvTx9C7eWvfg+ysy7t1c1XFef+79chMQSRAyME87zLjY6NvNz3ku?=
 =?us-ascii?Q?4s8wkL0WgRTKZs2mq5M4O6XrXAw5XofFLSWQ8dLx3hgpD+4eFJ+0yOgL2HrM?=
 =?us-ascii?Q?ROZpJau1bVjMIv/gskztwjyu94DRf3MHVeTCbhe8c9vSZ1lQC8roezpMo7Rl?=
 =?us-ascii?Q?hJL7QRSrAtxeQwLE3GSk5lXjSIP7Tahu/PyYAv4agRHnNLnW0KogYvfql2bx?=
 =?us-ascii?Q?hBQBXfWLOImioPb5PQ1MYEeQ/H3+Hn4vsYRgY5j4aKJW2Loa1a7IpSXbLmEl?=
 =?us-ascii?Q?K6DeotlpC27QY7pl2qDFzQ9YlO5sRY+ThkDxzkG2RshC358udLG/yrhmw0+L?=
 =?us-ascii?Q?wW+h?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 834f4403-538d-49b5-5398-08d897fece78
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2020 02:46:31.6853
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FX/gfAhhJ/rdalXnjgSh0fHQAr95fMHeVloswYfqKYxLG4K9rt34AESy/M3VPKpQwkjBi9KRXZVpLCgnZuhVAA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3PR0402MB3707
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Fugang Duan <fugang.duan@nxp.com>

When do suspend/resume test, there have WARN_ON() log dump from
stmmac_xmit() funciton, the code logic:
	entry = tx_q->cur_tx;
	first_entry = entry;
	WARN_ON(tx_q->tx_skbuff[first_entry]);

In normal case, tx_q->tx_skbuff[txq->cur_tx] should be NULL because
the skb should be handled and freed in stmmac_tx_clean().

But stmmac_resume() reset queue parameters like below, skb buffers
may not be freed.
	tx_q->cur_tx = 0;
	tx_q->dirty_tx = 0;

So free tx skb buffer in stmmac_resume() to avoid warning and
memory leak.

log:
[   46.139824] ------------[ cut here ]------------
[   46.144453] WARNING: CPU: 0 PID: 0 at drivers/net/ethernet/stmicro/stmmac/stmmac_main.c:3235 stmmac_xmit+0x7a0/0x9d0
[   46.154969] Modules linked in: crct10dif_ce vvcam(O) flexcan can_dev
[   46.161328] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G           O      5.4.24-2.1.0+g2ad925d15481 #1
[   46.170369] Hardware name: NXP i.MX8MPlus EVK board (DT)
[   46.175677] pstate: 80000005 (Nzcv daif -PAN -UAO)
[   46.180465] pc : stmmac_xmit+0x7a0/0x9d0
[   46.184387] lr : dev_hard_start_xmit+0x94/0x158
[   46.188913] sp : ffff800010003cc0
[   46.192224] x29: ffff800010003cc0 x28: ffff000177e2a100
[   46.197533] x27: ffff000176ef0840 x26: ffff000176ef0090
[   46.202842] x25: 0000000000000000 x24: 0000000000000000
[   46.208151] x23: 0000000000000003 x22: ffff8000119ddd30
[   46.213460] x21: ffff00017636f000 x20: ffff000176ef0cc0
[   46.218769] x19: 0000000000000003 x18: 0000000000000000
[   46.224078] x17: 0000000000000000 x16: 0000000000000000
[   46.229386] x15: 0000000000000079 x14: 0000000000000000
[   46.234695] x13: 0000000000000003 x12: 0000000000000003
[   46.240003] x11: 0000000000000010 x10: 0000000000000010
[   46.245312] x9 : ffff00017002b140 x8 : 0000000000000000
[   46.250621] x7 : ffff00017636f000 x6 : 0000000000000010
[   46.255930] x5 : 0000000000000001 x4 : ffff000176ef0000
[   46.261238] x3 : 0000000000000003 x2 : 00000000ffffffff
[   46.266547] x1 : ffff000177e2a000 x0 : 0000000000000000
[   46.271856] Call trace:
[   46.274302]  stmmac_xmit+0x7a0/0x9d0
[   46.277874]  dev_hard_start_xmit+0x94/0x158
[   46.282056]  sch_direct_xmit+0x11c/0x338
[   46.285976]  __qdisc_run+0x118/0x5f0
[   46.289549]  net_tx_action+0x110/0x198
[   46.293297]  __do_softirq+0x120/0x23c
[   46.296958]  irq_exit+0xb8/0xd8
[   46.300098]  __handle_domain_irq+0x64/0xb8
[   46.304191]  gic_handle_irq+0x5c/0x148
[   46.307936]  el1_irq+0xb8/0x180
[   46.311076]  cpuidle_enter_state+0x84/0x360
[   46.315256]  cpuidle_enter+0x34/0x48
[   46.318829]  call_cpuidle+0x18/0x38
[   46.322314]  do_idle+0x1e0/0x280
[   46.325539]  cpu_startup_entry+0x24/0x40
[   46.329460]  rest_init+0xd4/0xe0
[   46.332687]  arch_call_rest_init+0xc/0x14
[   46.336695]  start_kernel+0x420/0x44c
[   46.340353] ---[ end trace bc1ee695123cbacd ]---

Fixes: 47dd7a540b8a0 ("net: add support for STMicroelectronics Ethernet controllers.")
Signed-off-by: Fugang Duan <fugang.duan@nxp.com>
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 107761ef456a..53c5d77eba57 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -1557,6 +1557,19 @@ static void dma_free_tx_skbufs(struct stmmac_priv *priv, u32 queue)
 		stmmac_free_tx_buffer(priv, queue, i);
 }
 
+/**
+ * stmmac_free_tx_skbufs - free TX skb buffers
+ * @priv: private structure
+ */
+static void stmmac_free_tx_skbufs(struct stmmac_priv *priv)
+{
+	u32 tx_queue_cnt = priv->plat->tx_queues_to_use;
+	u32 queue;
+
+	for (queue = 0; queue < tx_queue_cnt; queue++)
+		dma_free_tx_skbufs(priv, queue);
+}
+
 /**
  * free_dma_rx_desc_resources - free RX dma desc resources
  * @priv: private structure
@@ -5290,6 +5303,7 @@ int stmmac_resume(struct device *dev)
 
 	stmmac_reset_queues_param(priv);
 
+	stmmac_free_tx_skbufs(priv);
 	stmmac_clear_descriptors(priv);
 
 	stmmac_hw_setup(ndev, false);
-- 
2.17.1

