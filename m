Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88C0C2CB7F7
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 10:03:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728532AbgLBJBV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 04:01:21 -0500
Received: from mail-eopbgr40057.outbound.protection.outlook.com ([40.107.4.57]:12974
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727006AbgLBJBV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Dec 2020 04:01:21 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mTRme0VWSbY2p2TyBSH2ed18tOaseDIFdl06WV972h6nOOSs2L40ZGkrLjYkv2TMeCnKhf1+Cx7hRIAVboLhzM4Dl9uTEduhJFTeu5R1Nsju83nYg2ipUqLfLUirqVEWGkcLAkepG2DUu8whJIHPGTyqiTS8Tbtb+w+Ydn6cR8sv7lptSqwaIm46H6itJ7c1Mw47FHPW8zQu+orOoghVssJL4u61a1ySQEHf3ZwyKENkd2yn8yNSBWlu5ZjnnYsY3rI7FoHo+zoSAppgorRdXxcs8T6yZfdNEF9t4pcpNeebyESAcVDQNbrHpFcH+Y0xrO5L6orfp4aeYtEcXtbsKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AgXZvkH0zdmI5ZvDMbgNj4G0j7qXe3zpFaLJywjHaAU=;
 b=oStXdMrl7vvMbO9VSTJk4yC//TnwJe17pQIWl5/KUJwBk7bPZps+BpGQ6lS+y8f7qi9gPgl7y5OxchyjWQ5JWtM+1bSGijSwDN0e4szXmwOzd2xY6YkuuhkVzAW0AHLJMOpewnPrhJLRZvNH7PfK7xpPiIZFTrUnz8ckwLUO5uY0JwbOuOIwl5Tf+kKgWskCzNsFxI0Lh7Utg0P0NOHOre+yBNt5/SlAhqADtxL21aLKj2ZQK49S4grQYt7tG9HQyUtG6B7d/McBtc+atVKffXZG0LJmTLCNnMbGCNSYzs8hBGWKzkCbf8MXTGuNrIO9w3WxMExEFyK0xaGOAFBvOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AgXZvkH0zdmI5ZvDMbgNj4G0j7qXe3zpFaLJywjHaAU=;
 b=Prq+a0AOmkbphacN2RtGblsv5SvWxfX/suIdXSstwctR6wwt4YNeuC1SPCIP9fIEVJEm4oUAk7SL7KjGIqdBStgIzK2T+JTstNaZRd0AB9JcinBv6JkOZ/67mLxuONbmWHhjnpAexAQ6lGEigq/zcLvSqGiuuEqv5wb75a6oqiI=
Authentication-Results: st.com; dkim=none (message not signed)
 header.d=none;st.com; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DBAPR04MB7432.eurprd04.prod.outlook.com (2603:10a6:10:1a9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17; Wed, 2 Dec
 2020 08:59:57 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::b83c:2edc:17e8:2666]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::b83c:2edc:17e8:2666%4]) with mapi id 15.20.3632.017; Wed, 2 Dec 2020
 08:59:57 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-imx@nxp.com
Subject: [PATCH 3/4] net: ethernet: stmmac: free tx skb buffer in stmmac_resume()
Date:   Wed,  2 Dec 2020 16:59:48 +0800
Message-Id: <20201202085949.3279-5-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201202085949.3279-1-qiangqing.zhang@nxp.com>
References: <20201202085949.3279-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: SG2PR04CA0132.apcprd04.prod.outlook.com
 (2603:1096:3:16::16) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2PR04CA0132.apcprd04.prod.outlook.com (2603:1096:3:16::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17 via Frontend Transport; Wed, 2 Dec 2020 08:59:55 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: cd39bf5c-6e3f-44cc-1acb-08d896a0a4a8
X-MS-TrafficTypeDiagnostic: DBAPR04MB7432:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DBAPR04MB74326D9CC57768FF29273033E6F30@DBAPR04MB7432.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: psFcxKlQDedFoj3Xt/qIoF57AN1Bwi74b/YbfKUilS4HFiaBEHtW47tc2X/wJ/AdRny4rOMOPkFRJIS6fWxbIGnb2N2ykN2TXWcoeFx/FF2VwwWkvIgoc5YzV0HDqCbLVUMehtxjqIiV/AXXrPb7Cn3OeIfnW8++SUg/rqfOyVY2qaBXA+cLR5zbaomRDUZEtdsspulrGoKS17PlhhewucS4MQA/K6AsKxJXkxeiLnOW6A5GtvD+RFN0yrrbHj8Y3Bfs/XzNsUy6ODIboBzW/Ar1RFaUguEfBXg4+fmuEi/7pEvJzlgyiPQge1wbwrIq1RFiHR87Vyxnmnr5jSRqBeT1d8CBtrn3MkU1prgdfYHnfNhQqn8FSKkjS1CXRNFP
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(366004)(396003)(39860400002)(346002)(8936002)(16526019)(186003)(8676002)(26005)(6506007)(5660300002)(36756003)(83380400001)(52116002)(478600001)(316002)(86362001)(45080400002)(69590400008)(1076003)(956004)(6512007)(66946007)(4326008)(66556008)(66476007)(2616005)(6666004)(2906002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?//NYpU+xYaQfai5Ggs8CAr7/4vqcDNbaOUyoKwcWcR6fUbOW+6r23V4SS63A?=
 =?us-ascii?Q?4OqRcMBpA91tXJhIKShmOKU/YsS8F8BZi7vQZCNcXsRHV85qbGcmCwqABGqb?=
 =?us-ascii?Q?n6StPUrAdsCyxHixCIjc/j8qlnHLfRO4L9UO9rMqWW69R7N0fbsa2hJDEfjE?=
 =?us-ascii?Q?Pin9UgrcwENWclc9SuUqUba3Hf87aJy6aCVH49faO/VCaIYEYeLxf1wIzEvM?=
 =?us-ascii?Q?y+FAum6Z4e6cn7rA4kR4qpVHls1IPevqEktCkaoJiOoYJWpyd98TzMdWqv6P?=
 =?us-ascii?Q?rSDGCRrmsi1ZsSR9lqjChV5x5cmgAqmQaTLLyFe8OHvQKZuVA4elZond86gM?=
 =?us-ascii?Q?si8wXl0ZeCf3pRMguUSAKyz2YDilcyYTAAFEv1NztwkmuBJtLoPL9D/9vPSB?=
 =?us-ascii?Q?7v5jU2sfvX+c9ZNlMGoOnhmFolrHfZxxxHFaTRsrQSwJWNRU8Ea/adAgjYh+?=
 =?us-ascii?Q?utVsMSgHprd2fE5E0Xs6JIQtLW8/TbtAPB1ppBIAni0bQ6AxKb76oIyIhuR6?=
 =?us-ascii?Q?nOvLYWnZRffwVfNxYDD+bxSPSR6oVyntxCYJD85kQtBwklpnryIRvzKpGtZB?=
 =?us-ascii?Q?W06j6Ngd/HKv6lvQ8Aj77g4L8mtATPVQpV5MV6CI2fzlZAb8pAP1NMs6HCWL?=
 =?us-ascii?Q?/7VECuGTBzhA1jCNe/0bDyqh0/nRPUI4LeMYTdK7K0tpJxZZ9o7r9+3Wwo3p?=
 =?us-ascii?Q?07SVGByXpX3bxvbgN2Y6pbRHmRSOGJ+BieGo0pAeg1CGmXCb/bv5MBbJXVMc?=
 =?us-ascii?Q?cOprkrlu3V/ucYAxAt1pQLCQYzfN/I0fusCL8puPr9wPw2YA4d5wk5eLYhNN?=
 =?us-ascii?Q?WywdSEcs7Pz9O8QPeedcveC0wVdyUJSdYYTXEDpmEipqFzQho5hTXWdWav/Q?=
 =?us-ascii?Q?F5qXp9mmDJtoCdGLjdv6ryU4thZPU2RjfA0n5E2Z5/iy804OTJmE4xTmY3ER?=
 =?us-ascii?Q?czpeodROtdxF7+84zq2wpglZ7LINyDcG5sI9B6lhga3XMuNH8Xh/0aNJSc3L?=
 =?us-ascii?Q?VBMG?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd39bf5c-6e3f-44cc-1acb-08d896a0a4a8
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2020 08:59:57.6330
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JUFlRyCEYAIgFbcGPvylF9YubYcthfbYNhbyRX0Mb+XCPWV8lgv++JyT8tgOZcnN5oadUnmUDCla4nCv3Uc3OA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7432
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

