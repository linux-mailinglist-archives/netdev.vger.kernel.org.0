Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50864667069
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 12:02:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230113AbjALLCu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 06:02:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230337AbjALLB7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 06:01:59 -0500
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2064.outbound.protection.outlook.com [40.107.6.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BA89517C3
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 02:55:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ag/WeMvdwUdWcFMqRLNMTqWqclYXctlY+sslo8j+MksU48rvlgAoI4+kNMyI9cHZR20DFmm5+Z4zY8nY4yzK56hRc+EbeGpb3n6c3CLPwrz5aZLdO4JWnIqtHaSR0/VH3HrCkMKwwhith6x3X9p64LcUdPFb8NFxDTQgWxoLl0avIDz3bDptmj1InOY6fz8AnjDNX+PzM3jQkx8zyUWp+JSsGQ0Kc2HBwosN0IJGJ+8AFnqG/FujokC1Nb+wgp9EuBU5SgxyZ69P3QflryORentZCS1bsFCr9T1XuX8SxFQe/Sj0/EZ9JX48GbyjAAJJn6bJHzfp+nM9+clOOdgFtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/VxOD0miKpk4kAOT6pAbczjPF6cdOXAjB9KGTd2q/0c=;
 b=bc/LIHCxx4nGoTfaPsz9h18t2Oip84hM+WIl02uytwqyIWtifadKPR4GAha1FxktMG6kfUnZZGvlkYtbpE4lQg1HOnGhfNUg+yZRVQPIVpePyT18x/6I3OGlmC7hWNs3Q94rsOPNscKfpDxQeLN5dxEdsGhgPOLS1UU2q6BMEl+z77dGmIfJd26n05oNlJfb2TMeZSTD804TDoXJSD28iqO825+zdePCMcX0kKPqzMbB1Jx5GwURXHLuviNrGcab0muLRYcoaUeFgT0aqLEPiPTWJIzVQI7VtgdXorR/1m6Ufnxcu+rgENMm1c9CoAudcQ9AyAfZx0eR6Ynj8KKsIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/VxOD0miKpk4kAOT6pAbczjPF6cdOXAjB9KGTd2q/0c=;
 b=LMYSZz63f/qLymKgdsQ5dJJJQGUtFoePi1zqMCB91Rx0I0wnyQB/AQFmzw60QhhIAwjDE+lrV2xwMdnRyB0x6GH5ZNKRXT+hwnsAycEjGC5zH9qgSRmzC4txKPofEJLKiH+vxTay3kOONORFAFSIWFP7LXMgPF+MMGVu4oEi1ZE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DU2PR04MB8696.eurprd04.prod.outlook.com (2603:10a6:10:2df::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.12; Thu, 12 Jan
 2023 10:55:01 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%4]) with mapi id 15.20.5986.018; Thu, 12 Jan 2023
 10:55:01 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "Y . b . Lu" <yangbo.lu@nxp.com>
Subject: [PATCH net] net: enetc: avoid deadlock in enetc_tx_onestep_tstamp()
Date:   Thu, 12 Jan 2023 12:54:40 +0200
Message-Id: <20230112105440.1786799-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE0P281CA0036.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:14::23) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|DU2PR04MB8696:EE_
X-MS-Office365-Filtering-Correlation-Id: e21ba4f5-8168-47dc-c6ff-08daf48b73de
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2QJvz/NhT2apCtR37uaVSLRQJAnBeL5Mb01dJA38dDg69PVlKl1KdYXujFlW4gLFQYQaoz6ilF7pPPBqjxcZ6v1Mqm9atcHDp90Si+KgnlY+fEDsOOY81kXWd3xEQNnOnJDDF26UFoti8/1qlLz6n4WCYjA7ys02WOKQ9qz7BweqfLHCFWTvafmi9UsO9ivoXD6avTeZniSfFdMuKBHpDGwRL8XfPH7ZFjADD9ExS8P92MxllyrC7mGn/7BRRDwhZOPJT9kgxFWbSBCw92taALT+xqhJheve9YRoGwPa2a7EX62mHXE0NhHhIPOutBXe0Y/Ll7nWySYytplVbYd8wiP8TjcALhRRDxClPp3MIJzdJpQGuCm+YUo6FZB3+ZCeBNd2E7z8/dyVGGad8JdYGzXPYeMMqRW+rkYKQKK5GVZTI5uhmU4vPVfondyURz7LIeSN/cbUAshxhWkDHLS0xTNP8TH9DskLcvXaRo4rzp0pppDYjimfHinyJpb0KhfJr4D4WQG41Dcit49+8NQwBaO5Ea134n0tbz2D8FqxTLIBQL7OZLtK5Yy0iL7inWRXtOF/sByVb/yIjU7z9u+FIMh3UjGcpPizAOxjw0YG9iYcVMcfRUrXq84xeEqRB+6cuhftJaRSdDlUBZBet1s4++1tWyNwq8lOj4sU19lF0eq3JZ/fhwX4sLwb0btr8Z0r
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(39860400002)(396003)(376002)(366004)(346002)(451199015)(66556008)(41300700001)(66476007)(6916009)(66946007)(8676002)(4326008)(5660300002)(54906003)(44832011)(316002)(8936002)(2906002)(86362001)(38100700002)(36756003)(478600001)(6486002)(38350700002)(6666004)(52116002)(186003)(26005)(6506007)(1076003)(2616005)(6512007)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3I0P3c+ekncorbjZOiplE5ZhUQXjmtHOgeS6ci3NB8whri3a+OyXeFwR0nWw?=
 =?us-ascii?Q?TiWzlGW4qzjBliU43EqSEYPIU0y5/jl+C/CDynfq/FzBF6vBLM28OYlnB3q6?=
 =?us-ascii?Q?YQIbf/u2S6DQMdRP5dAhrVGhaF7iUE9MeUdI4hObDMUOquF1QI3/kZPfw0SU?=
 =?us-ascii?Q?CoIs/ZjlQOGFaYfjx80xy1HdEQLXcVyPhGTVc8teNCC8jUmCdl/H9BMU0fDS?=
 =?us-ascii?Q?gbG+S6i0yOGdLpiPg3cioHE+k2qDPnrazDyN8rdPN145xvA6cSt19cV858J3?=
 =?us-ascii?Q?EaYoENOnJXbFHvH8Zlc5KoPay1GPsLZutqA1lSjwPOdR9AlY3bGlqHkjKFnV?=
 =?us-ascii?Q?VsofQHl50wlBHqpE03l7ZUhXfRk7GjPMiFch7HE1P7LmQhxiKIUT0DKsDo2T?=
 =?us-ascii?Q?VtJw+jaUkbotG1rBsSDewg9D9QFgFP59aceCA7AXL64psnhVB2ydQP/UAuDB?=
 =?us-ascii?Q?p5xy5wrapa3eVlwYve0aWESKijY+nfyS2Q9bVUxzU9NHfgQRmO7evDD5MukU?=
 =?us-ascii?Q?7ow5xFhohcnh/1wEFeT+/0iS6O/ggn4czXbznGrN5HU8sJGwbVGwAn/9ireg?=
 =?us-ascii?Q?+2e77mvziiJZRCMx2eDQ3KkEIBYTv8ZaPpGlPYNxGlMOgDBPltlED/l1pOc1?=
 =?us-ascii?Q?D48ApsPUQ1r5nbtJgjccA45qJvav+VYC2OKwo31uSIlg8XCMs07CrFn2RPq4?=
 =?us-ascii?Q?FCHSxxUI4yczkHk324J6SaPEJ4SztAMBBrbW4dluJ0rd7gkiWm0AFulRerfy?=
 =?us-ascii?Q?1FsRIXSjj8G2khGh/thImVOqBdMz/VPwLryiEFfT636g4MWCWbuhek9jLPdD?=
 =?us-ascii?Q?fp6c8py20YE4cepqSieclqi+cuk0e9gM4n0U4C3cwwNUivNAjutyXTPap0SA?=
 =?us-ascii?Q?rFJUuPcw9PrNdXLq7CPIgHB6yDzEmwl+kBEeMxSU4WzptzLVo2dBrTHP+bGa?=
 =?us-ascii?Q?rH0PImyRiXAsyy2oEI/P1PgvbFxqQc5wBpcrseETJJbe+yxBt3Ykob0YdwNg?=
 =?us-ascii?Q?LL7waME9HgHbmDpTLRfX2lU6YymwSgBIrHfs5VR7exi4yFzLeBK46xdVeo4E?=
 =?us-ascii?Q?jxEOzg48aza8k7F6eePGQf8rgRP5ddetP8k4L8zrUXeA/g9tzAUg7hNfabkl?=
 =?us-ascii?Q?BH0V/1jfhqsiLfJl0ChCyLtNjwVu9sx1160aR7htJZEwpjhgqPZcaFJhLzn+?=
 =?us-ascii?Q?6v42x8tgT6fPr9pOx+FpTDWOonO97IClPyQMJtYmZkIVhffXUj0ako18D0JK?=
 =?us-ascii?Q?k5Nl5ncVGgzGeqbwS7I3m3Iy1BtbB6YEdKf0c1xrpe1MqqKTv0OuyIQTrXWz?=
 =?us-ascii?Q?/b002WbvU/EIulwYts8PCypSbVYb3dulkS+DG8/e7XezgXGQazwetYsCmt33?=
 =?us-ascii?Q?7Co8XdfLA2yBCkgDcoxHKeaoQA6mpnx3x8P47+pV455xT/Relr23WnA3BCgb?=
 =?us-ascii?Q?JXaYw90v9p6pyiisyIfArAnuIbxe9rzP4iJ9kTVMCtL0f09lOS6mfTl4OWCK?=
 =?us-ascii?Q?ljm7+BOjiQnBUwb1ltNSx3Jz9lN9LRKwMCxobl6AUkVQwkTFC0OjZDw0limD?=
 =?us-ascii?Q?gQQ4Kn5jaODlIyoUWbSl9gr72ZMpW+wOs2U1+r6OKwv/peffCsUuNbO4V63o?=
 =?us-ascii?Q?3g=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e21ba4f5-8168-47dc-c6ff-08daf48b73de
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2023 10:55:00.9832
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C0xvpGTN9GILBq03LGsuasNHO/RsDecrKHFaK7S6UuyrKyTYK8RFSwYqyhK7GiuKLVkVMzZf7sTac6RxcXxDoQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB8696
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This lockdep splat says it better than I could:

================================
WARNING: inconsistent lock state
6.2.0-rc2-07010-ga9b9500ffaac-dirty #967 Not tainted
--------------------------------
inconsistent {IN-SOFTIRQ-W} -> {SOFTIRQ-ON-W} usage.
kworker/1:3/179 [HC0[0]:SC0[0]:HE1:SE1] takes:
ffff3ec4036ce098 (_xmit_ETHER#2){+.?.}-{3:3}, at: netif_freeze_queues+0x5c/0xc0
{IN-SOFTIRQ-W} state was registered at:
  _raw_spin_lock+0x5c/0xc0
  sch_direct_xmit+0x148/0x37c
  __dev_queue_xmit+0x528/0x111c
  ip6_finish_output2+0x5ec/0xb7c
  ip6_finish_output+0x240/0x3f0
  ip6_output+0x78/0x360
  ndisc_send_skb+0x33c/0x85c
  ndisc_send_rs+0x54/0x12c
  addrconf_rs_timer+0x154/0x260
  call_timer_fn+0xb8/0x3a0
  __run_timers.part.0+0x214/0x26c
  run_timer_softirq+0x3c/0x74
  __do_softirq+0x14c/0x5d8
  ____do_softirq+0x10/0x20
  call_on_irq_stack+0x2c/0x5c
  do_softirq_own_stack+0x1c/0x30
  __irq_exit_rcu+0x168/0x1a0
  irq_exit_rcu+0x10/0x40
  el1_interrupt+0x38/0x64
irq event stamp: 7825
hardirqs last  enabled at (7825): [<ffffdf1f7200cae4>] exit_to_kernel_mode+0x34/0x130
hardirqs last disabled at (7823): [<ffffdf1f708105f0>] __do_softirq+0x550/0x5d8
softirqs last  enabled at (7824): [<ffffdf1f7081050c>] __do_softirq+0x46c/0x5d8
softirqs last disabled at (7811): [<ffffdf1f708166e0>] ____do_softirq+0x10/0x20

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(_xmit_ETHER#2);
  <Interrupt>
    lock(_xmit_ETHER#2);

 *** DEADLOCK ***

3 locks held by kworker/1:3/179:
 #0: ffff3ec400004748 ((wq_completion)events){+.+.}-{0:0}, at: process_one_work+0x1f4/0x6c0
 #1: ffff80000a0bbdc8 ((work_completion)(&priv->tx_onestep_tstamp)){+.+.}-{0:0}, at: process_one_work+0x1f4/0x6c0
 #2: ffff3ec4036cd438 (&dev->tx_global_lock){+.+.}-{3:3}, at: netif_tx_lock+0x1c/0x34

Workqueue: events enetc_tx_onestep_tstamp
Call trace:
 print_usage_bug.part.0+0x208/0x22c
 mark_lock+0x7f0/0x8b0
 __lock_acquire+0x7c4/0x1ce0
 lock_acquire.part.0+0xe0/0x220
 lock_acquire+0x68/0x84
 _raw_spin_lock+0x5c/0xc0
 netif_freeze_queues+0x5c/0xc0
 netif_tx_lock+0x24/0x34
 enetc_tx_onestep_tstamp+0x20/0x100
 process_one_work+0x28c/0x6c0
 worker_thread+0x74/0x450
 kthread+0x118/0x11c

but I'll say it anyway: the enetc_tx_onestep_tstamp() work item runs in
process context, therefore with softirqs enabled (i.o.w., it can be
interrupted by a softirq). If we hold the netif_tx_lock() when there is
an interrupt, and the NET_TX softirq then gets scheduled, this will take
the netif_tx_lock() a second time and deadlock the kernel.

To solve this, use netif_tx_lock_bh(), which blocks softirqs from
running.

Fixes: 7294380c5211 ("enetc: support PTP Sync packet one-step timestamping")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/enetc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index 5ad0b259e623..0a990d35fe58 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -2288,14 +2288,14 @@ static void enetc_tx_onestep_tstamp(struct work_struct *work)
 
 	priv = container_of(work, struct enetc_ndev_priv, tx_onestep_tstamp);
 
-	netif_tx_lock(priv->ndev);
+	netif_tx_lock_bh(priv->ndev);
 
 	clear_bit_unlock(ENETC_TX_ONESTEP_TSTAMP_IN_PROGRESS, &priv->flags);
 	skb = skb_dequeue(&priv->tx_skbs);
 	if (skb)
 		enetc_start_xmit(skb, priv->ndev);
 
-	netif_tx_unlock(priv->ndev);
+	netif_tx_unlock_bh(priv->ndev);
 }
 
 static void enetc_tx_onestep_tstamp_init(struct enetc_ndev_priv *priv)
-- 
2.34.1

