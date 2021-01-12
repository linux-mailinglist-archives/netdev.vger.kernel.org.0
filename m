Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E25B2F2E12
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 12:38:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729723AbhALLfu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 06:35:50 -0500
Received: from mail-eopbgr20080.outbound.protection.outlook.com ([40.107.2.80]:62622
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729672AbhALLft (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 06:35:49 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JC+tI3s5UfgbdW+lwODwUYdXWcWDkFS6Hq2s9ud7VQ4lMwd8LO2LuLwN/EqaRSV7Zoixa2BbKmy/W3TfWNpd5jdA25Ta6j5wrvakt0zQcrNg2r1MIJFr4hgOOPpPKfqcs1lkvyj3vQTbhbwVvvj2GbqWhA0JKlKHwtxvSwyQ6wF0TXUpE9S+HKAlzMXBx05X/dyY6pv3A1BllYqsNqtyBwmko2/nrL72zmB7CdHJXmDE3xXiOOJBeHznNHIOtK223lGhUctWIIY9lK4Ps8vxv2zxligFYqUriQJI7w5hYNXPgKmGjM7gxLh9R4eQSE8l5bl7o0mCzs6GwGLFeGYB9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/nFpfcf/QftDjDy+VbfIxIEz0YFXCPEZzd7hx1GcbCM=;
 b=d6Vhf+Nd4PCXOsHr1WlqLtoGGzQMTRu+NtEe3avkklLCsN0GdRJsmeYeBQfarQywj6RRHp6S0gU2d0NySrx+ALP/gCTlWXAAxWIF4WG254xYWK3J64UGtNi0Mn8yXCMzz2OLGYfgrq70NwzVbAKGD/KfCU5r/eRtsk+mw5Or8034oQCj56iRb0YScNiBzT2tIPGl7X0yCy2uCegAuFp7GgFVpk8HvCBoEU5AFwFA3yfro8L4Vyv63+Yx9iU2LJ6HCi8vAmUjloOS1IgoCaV4Dpv047luvuhLKMr6MoVTbVSyPCehC+lKRJdU8UB7QDZKUhdVlXAoecr++JIrRhYWmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/nFpfcf/QftDjDy+VbfIxIEz0YFXCPEZzd7hx1GcbCM=;
 b=Qvrx2b3U/LAteZQJB4KenYHStehUR3QWGj2EbQJfdidKAWWb2+hAyBLNTqBNREdCxwjbYAb7z8x5sCNz96BPLYn+HrrPoueWMQuP9H+gqLgvJJjbeZP5oBGW/Z5+W7tuHEqdzwpYHXrjcj6VV4gJWBTWvWyUdAXR96c2AhP5Zuk=
Authentication-Results: st.com; dkim=none (message not signed)
 header.d=none;st.com; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DBBPR04MB6139.eurprd04.prod.outlook.com (2603:10a6:10:ca::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.9; Tue, 12 Jan
 2021 11:34:21 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::b83c:2edc:17e8:2666]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::b83c:2edc:17e8:2666%5]) with mapi id 15.20.3742.012; Tue, 12 Jan 2021
 11:34:21 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-imx@nxp.com, andrew@lunn.ch,
        f.fainelli@gmail.com
Subject: [PATCH V2 net 3/6] net: stmmac: fix watchdog timeout during suspend/resume stress test
Date:   Tue, 12 Jan 2021 19:33:42 +0800
Message-Id: <20210112113345.12937-4-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210112113345.12937-1-qiangqing.zhang@nxp.com>
References: <20210112113345.12937-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: SGAP274CA0016.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b6::28)
 To DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SGAP274CA0016.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b6::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.9 via Frontend Transport; Tue, 12 Jan 2021 11:34:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 1b273f33-01c2-4aff-7ccf-08d8b6ee0153
X-MS-TrafficTypeDiagnostic: DBBPR04MB6139:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DBBPR04MB6139862A50085EAA209D79A2E6AA0@DBBPR04MB6139.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qQbqCpwqXmBlKThZqUsvQRVeQx5XPrx0rM81vZ1c+XJfIadMccCW4TBT7yBBRArd4Bv55z8jCCoYa3GxGsmA08Fve2zA8t86RyRWIFHHpR9gcqI1i82KbiifcH/1TjaWTRnVpexEuAVyUosZ33yQyqLQUZBTrE0gFLy6ul3HR3SrV2A7IWzCtcWuqf3e2AFn0gs9XBa53Mp4/hAHKFSBtEtkcOlbNwflOUjBw01/5gqGnGXQh562Ipi9wZ0j9sUmGDf9QK8YPW8k0E18jO9JMyjtV2GtTEjRcTFCwvgMbwe8UlBvJZN4SAQPX+B0h3XFMtEk0OLY6+q7yNEAyog7uTMP3XmUJbmAD1WTXklBudgnBhjXlzBIAzhPNuoE9Ig7XHqeKmT4hS3luUwrWJvVj1jM//As3/q+UhIIH7CVDjRrIKEdeoDxvmbuusIn/umPQ+h3YJhK6aoE0hNX4qUExA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(15650500001)(69590400011)(66946007)(8936002)(26005)(8676002)(6666004)(66556008)(66476007)(1076003)(186003)(2616005)(6506007)(498600001)(83380400001)(6512007)(16526019)(956004)(2906002)(86362001)(36756003)(6486002)(4326008)(5660300002)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?7pMoHu+qf9hd2gYV9XtCrsPTebH+9VUrze6GDgugq3zymv9ufIGe76AB+qRE?=
 =?us-ascii?Q?+dDKNxnOGhIFpylxTjrwxQ6ri27bgOHK+eA0CzO/oBzCKpGyJPK+XQk37Aqr?=
 =?us-ascii?Q?Unw2v+Dwka6YR9hSWxyWaTeAB3Sjs9MRN5q5GXXLVcBbiOdYzurs4RAB57LU?=
 =?us-ascii?Q?rpX8+nTAM5sVwJNp3kg9MyF3gswBADqwVIDo0+Jo1MINmOlbh1iOk6ER2U2w?=
 =?us-ascii?Q?F42ziWcrlbCSSQ2+3k7AKdYgqiP4nA1elqSCmzbwF8AHA3WQjtjVmft5GBrI?=
 =?us-ascii?Q?pubF3LR7zTebUpzvoBPtX0SIL8nu25lS8O/NSK1GJd3cbviOSc+Y1JAPGTL4?=
 =?us-ascii?Q?Q+AI8W3wlhy4bwDWB7joZpnbtYgVu90EI6mVzyvaRoAs54oT51sJBcJchMsG?=
 =?us-ascii?Q?RTlyac04Ge5ISfQ3HPQTX9Mx9FmvO4Czl0QMu9wpZY0mcFdz+4Y789oLRS3+?=
 =?us-ascii?Q?j/6+j3FcmVW29XqLi2BLROZEhBRO3I56s0QumxMphoueciUMgVrDj8/hJdtr?=
 =?us-ascii?Q?VceQ0tDLfNEW0bAALt3iumAODDdKqrG7m64IH18xmW/WC2UAAZP4CdmLZ0OD?=
 =?us-ascii?Q?+rUqH1gdHTAveAWMlw8cnkMcFw+LK363E6EH0nIbXmTv1curpXmgjM85Fz46?=
 =?us-ascii?Q?v84I/9WPDg0386slXkiBFBJXyu5d/9Nwe+ahDQ0jlF1rrc/J7+z/t3fsHQOi?=
 =?us-ascii?Q?BDNDg5FWFxf5uWAqLMsNr7JnUmPP33nKB0TWYSIXzUqweVJm9POe8+vS35YQ?=
 =?us-ascii?Q?2gPZ05eBMW0FW+zl6+LCpQlB6S7CUkITvil7pQvUUT/Sysx67lobpNCn6jnE?=
 =?us-ascii?Q?VWMJzL3JYTMcZ3MU3NqglRJmJhT+YCz1rUnf20sV0kq5DgmwT8V4Zl2fJi09?=
 =?us-ascii?Q?b/GtxOWVq2B28hNIb+azSZIVKVQcLvlIAIet38ws7UMdWEqC5g3IkYCR+JK1?=
 =?us-ascii?Q?vHKjSeMSKLp8lKdxFqk6sqKeXEdCrFXtHHwfnWAW1wa6MhjixTtTDrTQR3S6?=
 =?us-ascii?Q?rV5D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2021 11:34:21.2530
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b273f33-01c2-4aff-7ccf-08d8b6ee0153
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KMO9t0PAbfbrZfuAp47SkJTZDCrRdww5FYumqqpQNOqOzxOa5PB5CreX4mvUsYrESyDVKJ7mi/fzHBNjzS6MPg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB6139
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

