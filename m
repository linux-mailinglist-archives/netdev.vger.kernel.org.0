Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C92D02F119A
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 12:39:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729831AbhAKLhu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 06:37:50 -0500
Received: from mail-eopbgr40076.outbound.protection.outlook.com ([40.107.4.76]:22789
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729760AbhAKLht (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Jan 2021 06:37:49 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iBIRwXLweHrn0Wac+gmob06pS+6eUGAjLKkdRGLZF4+HZPoOAl8yNRO3Jmn31xemipmY133NGGBuqnbFKSNxYEOWgQLyU8ApK+H4FmyIm9/1QvgJFs4BM9bkPJo1sHQTpRuozTZOwJBPVZsl0tpUD4tu9YIGsM4O2+K7vdA/fsNFGVbBdYr4fjkopFa88uaEVNKXLJlvhaPaqhih5n5cETMo8+mroB2b/mv11i3+ztOrE7982kkiiDMsl8o0m0lnmng9iTGhRTOHxPj8dnmR85EZbKzga6EDbbP/PxntUlcH4sxE+FdDvVK/cXpKZzP2xYOkLzz6ZdWTIFe54N49Qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/nFpfcf/QftDjDy+VbfIxIEz0YFXCPEZzd7hx1GcbCM=;
 b=W+XK574q/TTN3lpN+cDejpvOcHMpcoW8/PZL7GToLNtnuD2bH4S9asa5pApJu0qvw7l+5gvnA3jqjzrrcktPKQvmfM5JnQuaayQQ3nh0WgIBzlm4b8FJog0H8o5hL01NSdm9nX8ropnmxc4ARTmoSbLQkVTPzRLvxK4GRzVtMpYPM39bRZE7C2Bh/SwGHRXJoMS6gaQHlQqc4fdL7cjeAIsCgIXE0JYi4kewWCqCt4eBzkmDoi7lfG7zXZoR+mPyK5pkzVTZeiL5doyxAu6iVRp+2zm9L8dsIPjpXMmkoM3CMj+rKvI93kXtxv87Av2WP+kWVQZV7ltO6LjaSL78VQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/nFpfcf/QftDjDy+VbfIxIEz0YFXCPEZzd7hx1GcbCM=;
 b=L1MsplRSZiJxYD4YnZe8Xw5cuVFeD3eTcMXzXu7pZMFkaO3X8wpvnAgp9Q034OAq5KLRcGVU9q/fo9TN3qpoLjXshLlVAideadVmq/5f5YWC/6zb1qybNjbiEoFLdxt4C8XsIhlA7CQItSO8kbPPYIG+Sut1Jn0zkU0i26IC3nA=
Authentication-Results: st.com; dkim=none (message not signed)
 header.d=none;st.com; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB6PR0401MB2326.eurprd04.prod.outlook.com (2603:10a6:4:47::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.12; Mon, 11 Jan
 2021 11:36:24 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::b83c:2edc:17e8:2666]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::b83c:2edc:17e8:2666%5]) with mapi id 15.20.3742.012; Mon, 11 Jan 2021
 11:36:24 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-imx@nxp.com
Subject: [PATCH 3/6] ethernet: stmmac: fix watchdog timeout during suspend/resume stress test
Date:   Mon, 11 Jan 2021 19:35:35 +0800
Message-Id: <20210111113538.12077-4-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210111113538.12077-1-qiangqing.zhang@nxp.com>
References: <20210111113538.12077-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: SG2PR0601CA0018.apcprd06.prod.outlook.com (2603:1096:3::28)
 To DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2PR0601CA0018.apcprd06.prod.outlook.com (2603:1096:3::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6 via Frontend Transport; Mon, 11 Jan 2021 11:36:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 7f887960-92f4-4d02-672f-08d8b625202e
X-MS-TrafficTypeDiagnostic: DB6PR0401MB2326:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB6PR0401MB232645E32921035C59CCCBD6E6AB0@DB6PR0401MB2326.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1FiqoZARSowvscDyBj3f7EymUwRddY0/m/QrGocCWz1PDVkZbSwYwcbUt+2b9F7k0sbw5B3/ZF070Z/CmZYns6BIxq/NhAe2vv3Ynqes2oD9mtlm7YTlhwC4z3nlGvBAExoomQgkPo4yp/NoDKoEveIVN6CnuanrcUOfJJ4Oce4DZoLxKwg52XxbxwLzWimPdRjYinLPycjVq5YwId6NvD5ZJKwD+Lw1IRfylbzroZqWRUs8ilwyHO31F7qZhlWrfilYR1kC5IG8jLbrjBvG0BhzU6fMp+8FpwizrMf6Zs6khkJDnB82MBTm+Pkxc9xldWfKXbwdxxtcwxrn+WiXxE+3dUofdIk4LB/rkzdItJBKThQXkws1BAasXvKwO8002LRnSA187gRqWGwHMJo1PUO+5Iq64KbuFVMSSWHSzFuc3QbFXGQCJ6C2xMDQf8qs5X1lsNLgE1e2Wk14xAhFnQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39860400002)(396003)(136003)(366004)(346002)(66476007)(4326008)(15650500001)(66556008)(8676002)(86362001)(316002)(1076003)(69590400011)(6512007)(6486002)(52116002)(5660300002)(36756003)(478600001)(8936002)(16526019)(956004)(186003)(2616005)(26005)(2906002)(6506007)(83380400001)(6666004)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?5nnIz4dMQaTcLUzbdjpEB+11vsqqU0kdRQykfKMMvh82OmYRPTfxKh5vPVcL?=
 =?us-ascii?Q?+jT/m15TGh5MfyvrycvmyNGsEhnylsxsQYneL3sQP0AS21DxDMONj2fBQtqs?=
 =?us-ascii?Q?Cp96wyrC91VZxNT2eYuuARz9bY+CP4DoEDrifSmmIk2rDYnZKNmJetRfiXAG?=
 =?us-ascii?Q?jdTSpR/AreL+yUOOUOcAwY6mucp6BlH092KxcNgT20DVN0N1kC+EoHZpPSTX?=
 =?us-ascii?Q?4I5LP/vHw5ao3N6fvT4La87GvsAf6AuFbQrzNh3TmpdtiVzddBS68dxCCQKk?=
 =?us-ascii?Q?cir2yFuCwZyojKop1OvPRBuZyM1KdD9twlhm5yCSi52FzNE0yc3Hk5CXZO4r?=
 =?us-ascii?Q?hzi9FvCIkgwSVFq3UTlPICsomKJ6Rr0jgQmbfujEqaByWnzcd6iBAaRI98qe?=
 =?us-ascii?Q?2ZPjCpBIKMDF9hXY9c8IESjU3dgMsf3WLjuVu9i6qDt1O4/7whRfOMmyAB8j?=
 =?us-ascii?Q?Bnjjmr5V7w+ySksiWeQU6V+E1KRZdhCZnyH4D7lQ06QE0DoXlPvchwdP3NNo?=
 =?us-ascii?Q?VUBNxY2D4jfGB7g2ZSJeH3s9kBJwzL3dHZxoN+KluEzwUEmT1jl093P8u7PK?=
 =?us-ascii?Q?fmrMO6KiqBK6MfSV4NQ9B4ve/GGYygokPFvpj3Ofc+VIlTGrDeAMgHESuayG?=
 =?us-ascii?Q?osY8IY/rHt9rHBkAJbsxqXAuXBbK80RK0G56E2iAFt/4+QrHm2L9Az2Qs8cG?=
 =?us-ascii?Q?loVMfo38X31KDtDOaPil0risqnkGYBm5koLDQNmcAZvJNT8VTK04TPEhTYsM?=
 =?us-ascii?Q?ZMYG7EGWKJ5dq+wxq4z8ZR8rUO/pnPAZvC0+Xu2CTYlXEnWHc+Jk/FIoGSE1?=
 =?us-ascii?Q?12KtLAOsSKBhdRhH2FnWjISpOLCXwPLkOF8sncdrQ4pzyggYaXFy91/HK4jt?=
 =?us-ascii?Q?D8OpIOfMk4XnTimLdMmUyNvgN8MfXttmyFJEYD5CdLpP8fDLaNxZsef2uERC?=
 =?us-ascii?Q?ljCbFPDkRV+siPcjpxBGZT7MnI+bdO1nBevYEk0cv0WcJrilbaCret2boSr1?=
 =?us-ascii?Q?Cs4w?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2021 11:36:24.2334
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f887960-92f4-4d02-672f-08d8b625202e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jnR8t0G8l/xHs0JL1ace0P73vVpTwzvypUfKyqkNZPE15PNGHtkfHsy/J35u4pqd8KhGAv2x1B9ZVaHNUBoAbA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0401MB2326
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

stmmac_xmit() call stmmac_tx_timer_arm() at the end to modify tx timer to
do the transmission cleanup work. Imagine such a situation, stmmac enters
suspend immediately after tx timer modified, it's expire callback
stmmac_tx_clean() would not be invoked. This could affect BQL, since
netdev_tx_sent_queue() has been called, but netdev_tx_completed_queue()
have not been involved, as a result, dql_avail(&dev_queue->dql) finally always
return a negative value.

__dev_queue_xmit->__dev_xmit_skb->qdisc_run->__qdisc_run->qdisc_restart->dequeue_skb:
	if ((q->flags & TCQ_F_ONETXQUEUE) &&
		netif_xmit_frozen_or_stopped(txq)) // __QUEUE_STATE_STACK_XOFF is set

Net core will stop transmitting any more. Finillay, net watchdong would timeout.
To fix this issue, we should call netdev_tx_reset_queue() in stmmac_resume().

Fixes: 54139cf3bb33 ("net: stmmac: adding multiple buffers for rx")
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index a0bd064a8421..41d9a5a3cc9a 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -5256,6 +5256,8 @@ static void stmmac_reset_queues_param(struct stmmac_priv *priv)
 		tx_q->cur_tx = 0;
 		tx_q->dirty_tx = 0;
 		tx_q->mss = 0;
+
+		netdev_tx_reset_queue(netdev_get_tx_queue(priv->dev, queue));
 	}
 }
 
-- 
2.17.1

