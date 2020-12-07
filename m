Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF5532D0E73
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 11:53:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726494AbgLGKwn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 05:52:43 -0500
Received: from mail-db8eur05on2057.outbound.protection.outlook.com ([40.107.20.57]:27758
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726320AbgLGKwm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Dec 2020 05:52:42 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iss7yf3/4nLMUpOVrb2M4r08vIE1BhLe4tlybShoA19y8hiaLfA6iJ9+Rg1cF3VLWvlVN/Uyoi5djG1zkXEfY+NP+krwCq5FXnxPWnTvM5ZOZGiQSxKaLGuWWbHcJJvuGFI2IG5uKzCE0omvfLZd5GWI+coTo065+vLkI8h+8aYyiS/kViLlj67EYZTEmsilHhEmZn9cEW/vaw6m4yWhqIIj6yau3d6E7Bi4dSVnuMthD7CYPDcOWq0CgKIi/1kv/wMjsAt0qNv3hBkFkOFwnI3DEchhWa/lzpBfKpzNCNCy9Fvna8x3+fqtjX5xKeqe4dGVfT7tJ2BorSpEh41T0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kfmJJvxpcTdxHvvAwCBkAl2RjPods4f4wLpMXPMKVyc=;
 b=GK5P7OEYejkJkXlP69TFLDGgicfL1LhMWoinjyfha5LeQNOzlqK6NmoxhnmmVh6DYCxeEUqlaJth6j0mSO1NKUXDmmDSqAwS06GX1Y+hRhYJdOQaKoMC4hbU2j400YBqPDi+ulXNybNyX+Tklgm0zcsFHLWytokeQ8IwmOSheVSUoogMbA45J7IS9kY1HUCxSHmLE9iRU/krEMAH1qvRd+KbJSiOXqMjIP1RWx3cQldDsAwaZ0TA26kvt9e3FjScxHMWuTNqMQ9Ot+RGHssIg7xl1FDarwzosENc4t3lKD5B82u84tT81r2bv22RA3xFurhhpYKejM7UTWswRcsyAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kfmJJvxpcTdxHvvAwCBkAl2RjPods4f4wLpMXPMKVyc=;
 b=bbcReuwjQvJZEYWqHuV2mrNmQXpBZ59OsK91N+UsVuBK7zwli/+RQWhWrSKc36F8ZFYFTyUzm/uYC5AtazKS1TQqtxNuOJ8r+5LH2F4OlpDaz4917XplPRdS7CDZaxNXSnQxMAKHphNmQqmGimHC9E2McE4Hl4hS2SoB4gNArbg=
Authentication-Results: st.com; dkim=none (message not signed)
 header.d=none;st.com; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB6PR0401MB2328.eurprd04.prod.outlook.com (2603:10a6:4:46::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.21; Mon, 7 Dec
 2020 10:51:36 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::b83c:2edc:17e8:2666]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::b83c:2edc:17e8:2666%4]) with mapi id 15.20.3632.023; Mon, 7 Dec 2020
 10:51:36 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-imx@nxp.com
Subject: [PATCH V3 3/5] net: stmmac: free tx skb buffer in stmmac_resume()
Date:   Mon,  7 Dec 2020 18:51:39 +0800
Message-Id: <20201207105141.12550-4-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201207105141.12550-1-qiangqing.zhang@nxp.com>
References: <20201207105141.12550-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: SG2PR0601CA0018.apcprd06.prod.outlook.com (2603:1096:3::28)
 To DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2PR0601CA0018.apcprd06.prod.outlook.com (2603:1096:3::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17 via Frontend Transport; Mon, 7 Dec 2020 10:51:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c95e2b6b-6606-44ab-32ec-08d89a9e1166
X-MS-TrafficTypeDiagnostic: DB6PR0401MB2328:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB6PR0401MB23280764F9311A8721042732E6CE0@DB6PR0401MB2328.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZiUoX3SkCZFyKAvxCwbgUS17nlgQBAf8zL1xPmvT1yuAqMSfZMoWNjJJHaYaKO4ZvXFfk0zYQeB4miZDZGCBe4YIyqRbNtof3EyaI+tkJ3Nk9SNRSNo9RDSIO0S3OyZDCQ001VV8BlofVov02J/GpgFPhVsDwOpbGG+Ftpj2KsOFUmVXN7nnOBs1Ydbm1Hc0xJ9hbbK+wgl7yB0HNhi7M1To+RqIP4d4QnKHXkFLDxb/lNUIbZK1L9kVQFD6rf4GPbni8OpUhU1iP1H5sLrH98S7akYjszWwLg0i4LYjBfYSPhLeDgWRPMAz6BGwQ0vGZ5lmCh81SEO1WnjUpAY32SGbcWdHiQbRb31qlfbMVl8NhvD2cqbFBrT6YEjKZoMY
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(396003)(346002)(136003)(376002)(66556008)(45080400002)(66476007)(6486002)(186003)(956004)(16526019)(6506007)(8936002)(1076003)(86362001)(26005)(4326008)(8676002)(66946007)(316002)(83380400001)(2906002)(52116002)(478600001)(69590400008)(5660300002)(6512007)(36756003)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?rkI93DfEdzIiW9kupi8Kffw55Kjpv7FADmCKJPAFvSLAfbkNqV4lOAjSvh20?=
 =?us-ascii?Q?dNBSU3ZZI6Sw8+upd/zApHK+bKIMp4ja6eDMYdmi6ShZfy7o5gMs0wY0IPx3?=
 =?us-ascii?Q?jnHLfW9glGwttns/NS8wTPkdRgRF03cOHtTgGn0MzBM0o30EliakJz5XEwtq?=
 =?us-ascii?Q?/kHeQqpOb+tErf543yNq3qeMOOUhnF8+O1R6YhxydB8iyynt6NBDpQL0uTEI?=
 =?us-ascii?Q?lzRxf6OwiZt8Pm4053rvig1YvgfN3WcK+42hnNJP+fMLFKoK7WxNuA25AxNd?=
 =?us-ascii?Q?QD42YRBFih/bG0SDodfYIh2lSAKEWZVYN6ODN6s3yBKLEU92q9Kq+j9qQEUI?=
 =?us-ascii?Q?iZ6sAM8HoXAuru9++QdpjezrQQjPN03zUnKGXBhyWCzzj9lNYm/FEzhmmpDi?=
 =?us-ascii?Q?XhKknYA+IdRjhbllQhBQWQqgIOv6LhTWopfBMhKHlL20hdav3TMHKwh7T0/d?=
 =?us-ascii?Q?hLxejqD8vMXAu+F/4imi9DtO+9VSr2/fg7Zcz2hfbNRNoEDlyRypkZ6nYwv2?=
 =?us-ascii?Q?+qs2zQmea2IjFrl7W2oSDvqUi5nN0fpRi5WXS58nHbjMXRFd1cc5IFYL+aGY?=
 =?us-ascii?Q?TVPGhCvy5UDNpAlqZl3hCxuTvFXxDT4lKf4nLnPizIeFRJNtNK75zVKGvv/L?=
 =?us-ascii?Q?qw1IkCiZsMKK+51xwyqq4TXgQQLdZ/2XV61j1hxmKzEJpqgmoTHbFDWroK9a?=
 =?us-ascii?Q?j+KoKGpi1kOfhGTkVt96eo1NU6WDlEkSzK6jOKTRfT5baEMTSFhkTTz6z3s0?=
 =?us-ascii?Q?VuuVe23ru9OBrXCxYFUpgkx1YHnoxA6i7J7FCzZ+DXivXIlHPG1h/IHh/uvt?=
 =?us-ascii?Q?xjdcx/b/nkGnMoaeRMdojcpKH3zEF80FFHcNYfoj7ur5u+70gHXZkb+3SLRr?=
 =?us-ascii?Q?K/w2+fYVKOM5dFJGHmHcy3MlA58UaN7SNndHR8+JDvH9qEgZWnGbdQvXI/hp?=
 =?us-ascii?Q?vLboU0F+7lODxk9mJB+asiimxyL4o/xyqskvUdU5JZk8+uU+onh6FSzdJX3+?=
 =?us-ascii?Q?LI4J?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c95e2b6b-6606-44ab-32ec-08d89a9e1166
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2020 10:51:36.2327
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fWV15BoFXLHFCoi/BPYY4m0oi6xgNu085pJ4qUI3saEZNU46Pv+FJJZefgKoWnKkjyFZabNjct05pdO5MeGW+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0401MB2328
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
index 0cef414f1289..7452f3c1cab9 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -1533,6 +1533,19 @@ static void dma_free_tx_skbufs(struct stmmac_priv *priv, u32 queue)
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
@@ -5260,6 +5273,7 @@ int stmmac_resume(struct device *dev)
 
 	stmmac_reset_queues_param(priv);
 
+	stmmac_free_tx_skbufs(priv);
 	stmmac_clear_descriptors(priv);
 
 	stmmac_hw_setup(ndev, false);
-- 
2.17.1

