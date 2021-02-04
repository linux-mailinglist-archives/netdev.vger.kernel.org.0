Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BF2530F1F7
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 12:24:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235726AbhBDLWl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 06:22:41 -0500
Received: from mail-eopbgr140074.outbound.protection.outlook.com ([40.107.14.74]:47262
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235653AbhBDLWe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Feb 2021 06:22:34 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gh3r1wL0PkPqBONnBxhon+U1VgNA5E5AhpMpEkssXo4NRuOcj0+F0QzeQK58GaabqqBGehRDQBf4xbg8cbxevZSlUN27v4QxZhz2MJ0V9fvvRs91lPYCy4lJo9kdAj17T4qk6JlH1f0X90yR1RavurJGvLvnpPKaEx7UJWvFZsVQI2h4ZhU5QjdQdAgdjieJ8nCfhOFk7cgAPE85cXbKiPLGk+X5ay11ws56iTl0ByUVh4vjFZVd7CRRriVzPj6i26ICJPzfh/vJywl1ItZQ47h/kqS26aLNZffjNC9J37W0VknhDrrAx61CgtXzvOLlb6C1F9V7/C5VDwHxkifRGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uvY4SXst9mvSQ73QepaPMdp5mAe89Cw6XdSkVbFx0e4=;
 b=knHseEFQFpudiWkXgqY+tcyJ7GN/JSSWdFAcDFN39pgy9C2oa6LQmpbC1zTuz/v8Vcz8avoLeMHFEGPbE4jMU6hBbgu701/iMCHcWrR7per5kvhGy02sa+/mYXcFI70uBxb4/M9UfjBjN4X0N/HwCYo45IuF3i7xgc4tC5nxLbte9wuohLJ0QPtQpBKMmBYut0KIg6zaXEgjkgp54mZh1mzvyeCunoZZJnDZhZFw4Mn2DBktMeiRb9nNrqFPmjtdwdqb4UnfKmjqSPyJVYjfQigmGgZDPR0+JNB0Wknb8tm/FBoqVpjM6elP4uYRxnO0DXL13Rf4MKbrutLs3Za4Qw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uvY4SXst9mvSQ73QepaPMdp5mAe89Cw6XdSkVbFx0e4=;
 b=fZTVb/nyjutmpR926/OukUoHfDwe2Udg1g6nOpia+Z/perDqXUhYrxQD5SO67y1fKPWj3eT84YzNGTy/wIOrnr+o0hqJtsM92Ant3xTzg4Hewj+DdZUOzGHOqSjjiiA34OC7olHCMz5TAntsDf6a1Vr7g+D85zVWy+Tfp2/rj/w=
Authentication-Results: st.com; dkim=none (message not signed)
 header.d=none;st.com; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB6800.eurprd04.prod.outlook.com (2603:10a6:803:133::16)
 by VI1PR04MB6157.eurprd04.prod.outlook.com (2603:10a6:803:f2::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.24; Thu, 4 Feb
 2021 11:21:45 +0000
Received: from VI1PR04MB6800.eurprd04.prod.outlook.com
 ([fe80::6958:79d5:16bf:5f14]) by VI1PR04MB6800.eurprd04.prod.outlook.com
 ([fe80::6958:79d5:16bf:5f14%9]) with mapi id 15.20.3825.019; Thu, 4 Feb 2021
 11:21:45 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-imx@nxp.com
Subject: [PATCH V4 net 2/5] net: stmmac: fix watchdog timeout during suspend/resume stress test
Date:   Thu,  4 Feb 2021 19:21:41 +0800
Message-Id: <20210204112144.24163-3-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210204112144.24163-1-qiangqing.zhang@nxp.com>
References: <20210204112144.24163-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: SG2PR03CA0128.apcprd03.prod.outlook.com
 (2603:1096:4:91::32) To VI1PR04MB6800.eurprd04.prod.outlook.com
 (2603:10a6:803:133::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2PR03CA0128.apcprd03.prod.outlook.com (2603:1096:4:91::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.11 via Frontend Transport; Thu, 4 Feb 2021 11:21:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 69332026-f6a1-4718-0b04-08d8c8ff0e06
X-MS-TrafficTypeDiagnostic: VI1PR04MB6157:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB61577969D64D9D0B00ACA509E6B39@VI1PR04MB6157.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hS4FMQdyURTKMsQBJzvtt/lxbWn+Y2IiblxY+LS9dnwGZSwtJq0RkNIWFWaTdcD4EXsSTFmx0/9AIsqkHiw1uukY42MXHZxcqwY6kEjXnpQegnkx5Cd/pkdmstReVJK+FF89icW6xMo5ez+OQ8JcAz8+N6vXQx9jg6o16dfxVrTdRtAGKm4QW/2vtR4M/XcY0KDwvHv8FbcyuZTakPpOxvG2UiiduB1WM85leLA10eRE3imjfQ+V/DiPfgSwQypRFcjdf86Gy5l4tP2ryZ5Cc+Oeutlg8iCXUmJHOVo7owFBbenfAwA1jCsbIJwDqF8uz8BtG4ltoPmUh605AjOvJfA3vhHZ2mmggXRFTlUPVNl2xpQOh6jeHP7sse0BTyMimsv/yqxvJYiy+ueY3pnJ5I/cqLSsEPgG0Gc9Rc/X8hWBRUKRfJIRAsRskKyImPF0KBErt9VEASTqflsH4Pu8CZ+ezjCsBbotDWsiBmk2vn9nOrATl1yDq8o4TMPsny7aeY//P+jMUD0qbjfE3XK38ZJITpSZg2hKiA1BsuYs4dPVhVzf8oYpFawHx9kFRD/BkD3Tqj2qAw0m7AN5Dvzijw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB6800.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(136003)(366004)(39860400002)(396003)(86362001)(69590400011)(8936002)(6486002)(1076003)(16526019)(956004)(2906002)(5660300002)(316002)(66556008)(26005)(186003)(2616005)(8676002)(4326008)(6512007)(15650500001)(66476007)(478600001)(83380400001)(52116002)(6506007)(36756003)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?968pumlPGFnHuhp3rjsK0Rd+xkiaY3HNiazbb+xV9iRKYdCp9HeweIYmSSLK?=
 =?us-ascii?Q?00i2E9GTWnXTSl1HPZtFAv5cAMD2eJptE1absuJjzzCZAvQw8nX6kXH4vTMl?=
 =?us-ascii?Q?WXUtOS3tHKHhfzky9kVP7nRObLETpyTj/lJxUB37upGTWSKDwsM5V92rPdxG?=
 =?us-ascii?Q?k0dlc7ENxTUFxCk4wj9eTcuawemLl2I2prfxs2iwBUKRj7D+xjV4auETCVIW?=
 =?us-ascii?Q?qMAHsxgyRB4dliVucnuc0nZ7gel+QXxcRq72iL5C7qO3ill+2qFjyOYcT6lC?=
 =?us-ascii?Q?EboQoVITMtgbaKRvPE0UGGQy84l0axfPKuF9PUCBGr/EEUOI+rtxdPiIXYKt?=
 =?us-ascii?Q?a8DY+p0hL2avaX3FayOPFOlgFQGpcQJLFfYjN+m3l215gputiu1WuARQZyqj?=
 =?us-ascii?Q?4F/zbXiDYsuZEUwre7KrEorEmKi6CIDd2JdcPa+UhkB/x4MdtOFzTvHKtN45?=
 =?us-ascii?Q?GJsAAcIjMDvHQMd9W/PT8Lp4EXFXTZFo2eAbKYbRXpzHPUM4xaoPaXNSry4G?=
 =?us-ascii?Q?jjvEcmZWzm4bH5GdIvS0bO2jMwDKLdEncJfeAhhb1JNyoaHyY+3YCim4IctP?=
 =?us-ascii?Q?xd1zcNR+Rueh/YgWTKyBZsZm5Ifwj8quIwAOl+6qlF42zvE/slPfIKGIj2nH?=
 =?us-ascii?Q?M0pdJLW51/SUWfnvY883ZcNspPJiGuUaKrwS/Eu0naOfdw/q+FUtZfS62lGC?=
 =?us-ascii?Q?atw4PSrU8+P+yU5coxNLVepSf/6yOR7mXC0r77c3j44VSX23/I42rv/+cj2h?=
 =?us-ascii?Q?LzszymqFBUXd3ODEkGufejfXrypevyyP40c4ZC8JPovD25GJqqQPxc1CPkAk?=
 =?us-ascii?Q?vCPsesoyM3bkzoajhRxY6C+ADiWX9WNErnSX4FkvwdFBmvJIdzZ1UHC998fr?=
 =?us-ascii?Q?7gLyVGcwdnXmOdHUc80YsuCX+vRCJ4+ghXqD0RWSANZx/HFbULUMkh8I6XI+?=
 =?us-ascii?Q?1fjFspITEep7d1CrEffQqRoUtfoioywmoZusUpgV7tucJzzhyp4aP6I6KJzY?=
 =?us-ascii?Q?NkSX6VxjQzEGVHQN+5MpBbgnzSxUtVK359LEW85y0tx5emlvDxUccPRxdra9?=
 =?us-ascii?Q?MAMZgHiK?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69332026-f6a1-4718-0b04-08d8c8ff0e06
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB6800.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2021 11:21:45.2757
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: H5WZyz7BZ0GscfzbZXKHypXIyr0iqRtmjIN8h3grGYWaNWNLkl5B5ZkWicWJovpmvMvaDjNzmddByloWuQEepg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6157
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
index 26b971cd4da5..12ed337a239b 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -5257,6 +5257,8 @@ static void stmmac_reset_queues_param(struct stmmac_priv *priv)
 		tx_q->cur_tx = 0;
 		tx_q->dirty_tx = 0;
 		tx_q->mss = 0;
+
+		netdev_tx_reset_queue(netdev_get_tx_queue(priv->dev, queue));
 	}
 }
 
-- 
2.17.1

