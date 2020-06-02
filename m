Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30E541EB6F7
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 10:05:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726184AbgFBIFi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 04:05:38 -0400
Received: from mail-eopbgr00043.outbound.protection.outlook.com ([40.107.0.43]:29101
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725811AbgFBIFh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Jun 2020 04:05:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dYbai/yUeUn/GEqQdE8cON81b7wIYj24mx22By7HwOFLBfTZFXN8arkLhoda+Kdh43ajiQhrcOSgwFj/VIElVCWIVt/fnXiVMJ1gSOX1xk7MGyafxAHJUN93/X+R0lZ8IyOco2mZ5Y0uuoqf5zlSA8gu8p+SFZxe6R+PfQhbcQzMM6e+vkYWcNF7nI7Md/NjFvSQNc2XpK8jYrE7d6q7NikxiYOf2OoWDmVdq8O2rGHcnN9eghenjrQqWUPPf4En2KbMfSyRh9LNZ7c7+j1tysiyovjFPZZ2nP3JBiQy06y1+qU9+v095Ss/d/g19lcfJwAVQOZKyQtawL7oaOZzSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EGdWGY8hbp3kUZDtaK88iH4v9LchZ39xWBKZYuuROxw=;
 b=XiYR0+6UjQNBgwC2OrUuY7r/FDTTT3Xa5l6zGaLcr36O0RojnSJ/GuTySUVGH08LeqbNQJiFgIvtL9kD2k2emV9g/eloszkJJwBOogibOTxnRf0YrFXdNRtE6jmj1R/0X99QLZ2vqR3ZOwV+O/X8thMOEn85yMcQRq8lTxeN84iQttxxodYnU7MdKiIt1t2B7cdwiXE7ZGTjAuCvm8Ato9GkPfFMpVrfiVExH1d7PMIXKt0yIju+3MyuaUCVFFDpyFG+fH3xZQ/6mmTPWqws6toCq8rCzqdH7HVSUMxjlHcbWVosLsrAplJXQ9wsOI5aoyJN+Vqrq6KuP3Xt7OByNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EGdWGY8hbp3kUZDtaK88iH4v9LchZ39xWBKZYuuROxw=;
 b=EA85gc910WUpGfyn0FbMuRYTSh72d71Iycc90TsTnuh3MEH5qt0e6F+BTFvwScINM9KBcqSi6eiiQezwCR09h/EwW4YgSLoQeMu+D5+zoyLunrLouSVt6GP1hvxPhscjFnzlSC2T2Tv8+iQPmJbIjvNc0cKNQ0E75xS/GN90p+w=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from AM6PR0402MB3607.eurprd04.prod.outlook.com
 (2603:10a6:209:12::18) by AM6PR0402MB3558.eurprd04.prod.outlook.com
 (2603:10a6:209:7::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.17; Tue, 2 Jun
 2020 08:05:33 +0000
Received: from AM6PR0402MB3607.eurprd04.prod.outlook.com
 ([fe80::35f8:f020:9b47:9aa1]) by AM6PR0402MB3607.eurprd04.prod.outlook.com
 ([fe80::35f8:f020:9b47:9aa1%7]) with mapi id 15.20.3045.024; Tue, 2 Jun 2020
 08:05:33 +0000
From:   fugang.duan@nxp.com
To:     davem@davemloft.net, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, joabreu@synopsys.com
Cc:     kuba@kernel.org, mcoquelin.stm32@gmail.com, p.zabel@pengutronix.de,
        linux-stm32@st-md-mailman.stormreply.com, netdev@vger.kernel.org,
        fugang.duan@nxp.com
Subject: [PATCH net,stable 1/1] net: ethernet: stmmac: free tx skb buffer in stmmac_resume()
Date:   Tue,  2 Jun 2020 15:58:26 +0800
Message-Id: <20200602075826.20673-1-fugang.duan@nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0044.apcprd02.prod.outlook.com
 (2603:1096:3:18::32) To AM6PR0402MB3607.eurprd04.prod.outlook.com
 (2603:10a6:209:12::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from b38611-OptiPlex-7040.ap.freescale.net (119.31.174.66) by SG2PR02CA0044.apcprd02.prod.outlook.com (2603:1096:3:18::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.27 via Frontend Transport; Tue, 2 Jun 2020 08:05:29 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [119.31.174.66]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 6fa7ad21-5c07-4b05-46b2-08d806cbb919
X-MS-TrafficTypeDiagnostic: AM6PR0402MB3558:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR0402MB35584FB3BECB9A52708BC817FF8B0@AM6PR0402MB3558.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-Forefront-PRVS: 0422860ED4
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YOqMvloME4NjTgz6KptWJr0UelXeHE2nG246YBW54KuFF2w8NDasLcSXE378WJsIgzxtq8xaebd+wkTCc0gjYLjTmd8NIEn2yfFpWyiCBjdVrbR3j1vF/d63N19W2X7MRSCVdHCjOJE3vIW7NAJSuZYO/xcBWy/eK4vg9hoziOC50YlImypf8Q/n14tfy8UT1y78LUsAVWoNPIZgDJx6IdWUjuJnAfSv2TJM5GFW7I+TL9JyibU0Lwr9760mSYLc4DlW9X2qNEeH5GhfR2QL2M+rC4QwfrSc0/2BeObXcOiZiHM/9RH7pGS2AMHIOQ4q21dcJ7RdsZ1xBCHgntlrCCejD7KEjIguddyGJWIX6CDTGxjMYYk5Ypv4hiSiBWp9
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR0402MB3607.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(396003)(346002)(136003)(39860400002)(376002)(5660300002)(36756003)(8936002)(52116002)(1076003)(66556008)(6506007)(26005)(956004)(86362001)(186003)(2616005)(8676002)(66946007)(66476007)(16526019)(4326008)(2906002)(45080400002)(83380400001)(478600001)(9686003)(316002)(6486002)(6666004)(6512007)(142933001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 3RD906f7IdWY1LhGniSdRwBBmEgxRbKFGBa7aB4xs/0wP9M04CVIDXTuPITzAXlwTn4OqQlEJI2cfOVYZkmpOsll7YIL8T04rcgixmeWEvXvJDtMoD+n2krgeHvjX6Jf4e2K7Htff8NjtErizMJOWHWLxUmBNgXcTcMIypebu1zekqTYId1G9zZ9YwS8YfCwYOeuexCFLgu1crpnCZkWLcCL7SbGPqkoUC7ee2kZBxRzX9lnyhmyNJTWRFhDoptDLmYx8mTx5KcK9Q/T/SGXSYbFro20qRjNMcdjacUd2nd/4uy7HaI4i2dZ9i4q/SF72olWWwHAh0hisu1X4gtQyt5zd50HY4KtHHw5RXv0eybYDsHVuxZ1sQHtV+NdG/oTmLKvlGHj9jGNOm8eiiR6A7Sk16i15VonvSnJ/0TaldETovIFcsWiX8dsLUTcO8PgwyFq5WskB55V46rumoXI1QQWBCJVzeiQv1l2d4eC0Is=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6fa7ad21-5c07-4b05-46b2-08d806cbb919
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2020 08:05:33.0621
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W3078SaMnClInL7rKVYcUNoXaUSoDcwBtm5fE4cU9Ce+boSG7Rck0ED9eRmh2NMj3umDpvrRlFA1kyfHmCgW1w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0402MB3558
Sender: netdev-owner@vger.kernel.org
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
the skb should be processed and freed in stmmac_tx_clean().

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
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 73677c3b33b6..3c0a2d8765f9 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -1548,6 +1548,15 @@ static void dma_free_tx_skbufs(struct stmmac_priv *priv, u32 queue)
 		stmmac_free_tx_buffer(priv, queue, i);
 }
 
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
@@ -5186,6 +5195,7 @@ int stmmac_resume(struct device *dev)
 
 	stmmac_reset_queues_param(priv);
 
+	stmmac_free_tx_skbufs(priv);
 	stmmac_clear_descriptors(priv);
 
 	stmmac_hw_setup(ndev, false);
-- 
2.17.1

