Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C21DD5456CD
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 23:58:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345456AbiFIV6f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 17:58:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345287AbiFIV61 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 17:58:27 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-bgr052101064021.outbound.protection.outlook.com [52.101.64.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0A351611DF;
        Thu,  9 Jun 2022 14:58:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XXy1YjoYq8tn2hzXndGsc6+hfwXrOxx5/pehW/rM/qblvmG2eZs4Ofg1D5ROEc3sns2me+LKkviuwZVwmLyVvEc7NslLEvTX5mwmqPeS7rBjZUlvW2ICv5TkpC9/HwI9i1Y06Sjp2wv8HdNY2Qd0Rw8GqGWGP5qH3yGWZfCpb3xB3IZCi6TVQIfuUeeaz1ON1ac5rDx4Hfyupgv22XbB8oXgAxBSoI90D9jyCBPYfZ2jskDHmwP3goVBAJfdy8AcC7wtJWLucTHmLl+SPrSSTyq/7AiYYhvbHjE8tWhOHtkYSqKaHkGM61vx4xo4Q6I6YPkVyZEAUF+c153bj9Vg+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4meqob99bElykpOK4OBlP4ezpouNq5ojGlxKJ6U/h84=;
 b=YVh0O712UrHgsFBrS1GGQAcxOnr88s8IxdFGojVZXAjCGshaGBeTvb7mHtTAKnNyX9a7NtWLgwOBU0o+huzRxeQnIzkvs+ikyyHwfFIeTn9wuF8z3Xvs/N+M3+OmLHHZ0ii5QvyX3jFP4hUS1A25DI/EF9zov77KlwXUMlK4AyU7JICWuXfrRtrXEJWU8fLJDxhj6WzCmHtWLKQBuEAwzwDTuOr42pZf/b/r/ZuHxsnrFvLGczkjzj2dUb4jL7ODA/8Hp25N5BGNjgl9ZKo3YEM8GfLloHtHNXp8LdJD/0Ph/DAZKybCICXBYWkXYADHYYuhEVrsscAydZ5k58av/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4meqob99bElykpOK4OBlP4ezpouNq5ojGlxKJ6U/h84=;
 b=ELm1UegUxzSQ3Lh/NRz6Ag9MBwm+0iwjQi2gtLRMQnFaYakUbexO6sTmREHKvP7UVQW3UvT5rLceGlLBNSNyRvhwk14BmpZy9MWKs+5tkYMWmjDWBcbv7KwvELr8cpp6wWJGn8vrcISxErdrg3j1WOX23WgQCeqNFkEI81/T6h0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from BYAPR21MB1223.namprd21.prod.outlook.com (2603:10b6:a03:103::11)
 by SJ0PR21MB1871.namprd21.prod.outlook.com (2603:10b6:a03:299::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.6; Thu, 9 Jun
 2022 21:58:23 +0000
Received: from BYAPR21MB1223.namprd21.prod.outlook.com
 ([fe80::7ceb:34aa:b695:d8ac]) by BYAPR21MB1223.namprd21.prod.outlook.com
 ([fe80::7ceb:34aa:b695:d8ac%5]) with mapi id 15.20.5353.001; Thu, 9 Jun 2022
 21:58:23 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     linux-hyperv@vger.kernel.org, netdev@vger.kernel.org
Cc:     haiyangz@microsoft.com, decui@microsoft.com, kys@microsoft.com,
        sthemmin@microsoft.com, paulros@microsoft.com,
        shacharr@microsoft.com, olaf@aepfle.de, vkuznets@redhat.com,
        davem@davemloft.net, linux-kernel@vger.kernel.org
Subject: [PATCH net-next,2/2] net: mana: Add support of XDP_REDIRECT action
Date:   Thu,  9 Jun 2022 14:57:08 -0700
Message-Id: <1654811828-25339-3-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1654811828-25339-1-git-send-email-haiyangz@microsoft.com>
References: <1654811828-25339-1-git-send-email-haiyangz@microsoft.com>
Content-Type: text/plain
X-ClientProxiedBy: MWHPR19CA0060.namprd19.prod.outlook.com
 (2603:10b6:300:94::22) To BYAPR21MB1223.namprd21.prod.outlook.com
 (2603:10b6:a03:103::11)
MIME-Version: 1.0
Sender: LKML haiyangz <lkmlhyz@microsoft.com>
X-MS-Exchange-MessageSentRepresentingType: 2
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5881f5d5-3cfd-43c5-462c-08da4a632c84
X-MS-TrafficTypeDiagnostic: SJ0PR21MB1871:EE_
X-LD-Processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
X-Microsoft-Antispam-PRVS: <SJ0PR21MB187131ABD463EA633C510C41ACA79@SJ0PR21MB1871.namprd21.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mU7bQCbWKwEapNNZhhlEJYeJ/1stoSJAfX0mKWa1X73HbWgSp6NLHCut2EKj4ktKXdQWO3QnENrZtG5mzjHSkRpHhAlQT2C6eT/G3m1iRiVqNY8/65u0Cr0IS5jKRgjhHBM/yCCvoND/519Q+sjnTBEhRyFmslhbSY9biusRTPgwnLo5YYLinazdTNnYGa/khBQGSMXrpRIWmjyjNPeqQrWPkZSn6k101qWjkCPS6rSLBks4WAXzkmCG7sZIRo80Mz1t9gyY7AXY2ujW6LWsj8QqiizA6oHMHu74rXl5mQqkp5nZHUHxdITgSwXXFpuLcsIQUNutyQ8bTFWrTcDQp3yIi4aoUCSAvrJgW9tcmMGVGFeKG07P94kkanlG9MzpKhY9w3LtE6oFjC6Lchbw+BIXgMbzTz9jqh2CAjUEbBYakYjFuYUQmDxvLuuBSknyPL+D2qRwpp6qZpHA/+n7wET2p8wcT1vSjVok0UxZHfgwGSTr2gM7AfxnE8++Q6wmM91AZ3Ei1Vpb91mUN3vKKTcGMw7IvoMtc8AEbPsUymWTQi4WMark+NpuVTq5S5QvlH6hPQt6tzqzgGMs8XARCzdgPgI391XwrWzCbxtlM1M9MqBqz96cumQfFNIaifnVlv2gcYVmZk9uXz03/hsKleo+KYxiXVH2/qZ6ibnI6UVo7EZATxvJ1ydgA4lZm8ugg1h0MVLKr65PH+FNTkqS7oZVDAMPPGwp5ZfCuhGAk38tGFdj6/DgaXj1ptyhc7+r
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR21MB1223.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(451199009)(83380400001)(10290500003)(36756003)(4326008)(38350700002)(6666004)(2906002)(38100700002)(5660300002)(66556008)(66946007)(66476007)(8676002)(186003)(316002)(2616005)(6486002)(7846003)(6506007)(52116002)(82960400001)(6512007)(8936002)(82950400001)(26005)(508600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qWtyLLMXas5stqYl5HOYuVcx/66WBqdJQ+EuTg/DEZwG25fHU79zFvp0J94+?=
 =?us-ascii?Q?KZx8Q4d8HGjKh1PO040GZzH0K0X4R16bTYwm8UtA+GfqG0rzHMgEP3g3g27/?=
 =?us-ascii?Q?DiIx62RfZ9O3MsXZsmuS+NZjrCDEG6MXnGFV+47g3vWkJU9Ytyy/+9JJDFR0?=
 =?us-ascii?Q?Ha8dZPUYu/b4Y9JlG1g+MXqtyk0lSyJUFde+KIuWzesV0Xqy1xi52CTRL9DE?=
 =?us-ascii?Q?nmrFx5E44IyFsRwj6c+oUIh3w+owcbrPa0HD10AR8a7mktSjclJgd6w/b9/R?=
 =?us-ascii?Q?sgCfJnxAYTrN2Wm0WvfnrD68ohD9sb0RML9irpzCaEXeq0kOB9QmCFFYWzkA?=
 =?us-ascii?Q?Ot5iWP16fnmluXLntnRCYajkpkQp86aJL7nEEAJHURII7IHEOGnctTYwaVTB?=
 =?us-ascii?Q?oYsjrrcmqiITCyN6xRwCfi9yn1Rxk7C0by3mumM12ucOAR45KdlRKaoXQcd8?=
 =?us-ascii?Q?t6zTXkzw4RKC6+eRxi12qQUjhHrJUyBFEfgyfQmnZFLoAp+xjlFqxErZcxfp?=
 =?us-ascii?Q?u/8aQ2cE9KG8GOElaWl0Ie0So8YFtMErSP7SKi7pd45sf832ariGnxgZ5+lG?=
 =?us-ascii?Q?U9O3FyVXkkw/J5O6SVEuaZXwCoZa84gg21bz/Xn55D7gYyo/8V4zeO54o/jK?=
 =?us-ascii?Q?aDWZ3b53Z3mQlnludcEMBtiW9BJWsAxiCUSzoqV0rLE8AG7lv3iJzA+woXXp?=
 =?us-ascii?Q?nLM2heCa72Bien/P1g/MquvVyTkaThfqBJ8nsr0C4JZig2ABADR3T86pAGpm?=
 =?us-ascii?Q?lSMWbKDLMeRCqlZxEARsWexsxDOANegbljrNpCXboCw3NudhaK+sGm37ujvU?=
 =?us-ascii?Q?zfQXBfgiM2H1gZ3cWMvhlmt9v8S7lTFZv+HJoh3H9/X+OUHBOFFbHjkJ7V2u?=
 =?us-ascii?Q?1rn3Ez3uiCo/XT99nXXVsekho6MQLjvOe6J6pSMfL7O6m/Xo3mr0VsBGzMI8?=
 =?us-ascii?Q?BNVxrUy/9kvX/VxolhWwk6IrR7aU+V5uxNlHxLoUvHrVkglifI2R7kmRQV9W?=
 =?us-ascii?Q?Hr4ObHjEg+0S2U0JcZ1djcW2mmsjZkXJ4uDmNjVyhyrMGnUv41sPgzgS2kTg?=
 =?us-ascii?Q?gDaWiAWGAacfluBYnN2yIUQxw7UyfVzYUeMFkCZbxm/wzp4v5UN0XU5Sp7R+?=
 =?us-ascii?Q?nS/n2NB/GJ4I1IBrKxQVNSsLdpd6cc6T4CJ+CQwhGjVtn2InTi8il3oYKN0G?=
 =?us-ascii?Q?VdjCQNBDNhooNH4N5Y+IZ9jC4lzISn4y5v/BgF22j6m4Eq0ReBbjDkjxWDEA?=
 =?us-ascii?Q?V5t62JfwyEeRc+NRnqZmz2l3dliTAxffKBCwY1X9P/JuDZ60mk/i6GNh1B55?=
 =?us-ascii?Q?PSkcSeAucXYGlN8BlvRVuQQQELaSvY/6/E8tEA1xXi3pRpDyOmRJyStHGZQn?=
 =?us-ascii?Q?VN7BbAYuPRkE2EwXrttJV2YRlCR42lhy17I6T8YxnVt8+F0SmwbMPvEgYP4t?=
 =?us-ascii?Q?zrvDKo46r/+ctFLUT3lJH05VdGuX0SqLTGzh+ofYdeJERqbUMFOSJX8emfNx?=
 =?us-ascii?Q?W9VyhvPAqqeHu2hrdUtcfKEEx3itfzQEUP4Z5Yv2fR+wNw7DiH2TlfrFUjvU?=
 =?us-ascii?Q?I5nef6dLMHP1JITgVnP78E6C0I5R6ximMomIgC1725Q2uAa7gMym30uHUBSb?=
 =?us-ascii?Q?6SYTO2IYLPq0egsJpU/YwgOZ5rw91mWdq/C7xxhCFXQmhn0mXB0GnAGYdYnA?=
 =?us-ascii?Q?ZAryz8JenVYwM8pM3QS1NLj98/9ISMC3+T2CCfJgxQgzbWv1JB13U4BUw1KP?=
 =?us-ascii?Q?WxElN1KFug=3D=3D?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5881f5d5-3cfd-43c5-462c-08da4a632c84
X-MS-Exchange-CrossTenant-AuthSource: BYAPR21MB1223.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2022 21:58:23.6524
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6y5PB7KY5NXqe49kxruUzOKRY300NIPAqBLkI+02LvfW/ykPfK2fnb7ohWUaEW/FBXoZVWTkO7xlsotS1O4TGw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR21MB1871
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Support XDP_REDIRECT action

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/net/ethernet/microsoft/mana/mana.h    |  6 ++
 .../net/ethernet/microsoft/mana/mana_bpf.c    | 64 +++++++++++++++++++
 drivers/net/ethernet/microsoft/mana/mana_en.c | 13 +++-
 .../ethernet/microsoft/mana/mana_ethtool.c    | 12 +++-
 4 files changed, 93 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/mana.h b/drivers/net/ethernet/microsoft/mana/mana.h
index f198b34c232f..d58be64374c8 100644
--- a/drivers/net/ethernet/microsoft/mana/mana.h
+++ b/drivers/net/ethernet/microsoft/mana/mana.h
@@ -53,12 +53,14 @@ struct mana_stats_rx {
 	u64 bytes;
 	u64 xdp_drop;
 	u64 xdp_tx;
+	u64 xdp_redirect;
 	struct u64_stats_sync syncp;
 };
 
 struct mana_stats_tx {
 	u64 packets;
 	u64 bytes;
+	u64 xdp_xmit;
 	struct u64_stats_sync syncp;
 };
 
@@ -311,6 +313,8 @@ struct mana_rxq {
 	struct bpf_prog __rcu *bpf_prog;
 	struct xdp_rxq_info xdp_rxq;
 	struct page *xdp_save_page;
+	bool xdp_flush;
+	int xdp_rc; /* XDP redirect return code */
 
 	/* MUST BE THE LAST MEMBER:
 	 * Each receive buffer has an associated mana_recv_buf_oob.
@@ -396,6 +400,8 @@ int mana_probe(struct gdma_dev *gd, bool resuming);
 void mana_remove(struct gdma_dev *gd, bool suspending);
 
 void mana_xdp_tx(struct sk_buff *skb, struct net_device *ndev);
+int mana_xdp_xmit(struct net_device *ndev, int n, struct xdp_frame **frames,
+		  u32 flags);
 u32 mana_run_xdp(struct net_device *ndev, struct mana_rxq *rxq,
 		 struct xdp_buff *xdp, void *buf_va, uint pkt_len);
 struct bpf_prog *mana_xdp_get(struct mana_port_context *apc);
diff --git a/drivers/net/ethernet/microsoft/mana/mana_bpf.c b/drivers/net/ethernet/microsoft/mana/mana_bpf.c
index 1d2f948b5c00..421fd39ff3a8 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_bpf.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_bpf.c
@@ -32,9 +32,55 @@ void mana_xdp_tx(struct sk_buff *skb, struct net_device *ndev)
 	ndev->stats.tx_dropped++;
 }
 
+static int mana_xdp_xmit_fm(struct net_device *ndev, struct xdp_frame *frame,
+			    u16 q_idx)
+{
+	struct sk_buff *skb;
+
+	skb = xdp_build_skb_from_frame(frame, ndev);
+	if (unlikely(!skb))
+		return -ENOMEM;
+
+	skb_set_queue_mapping(skb, q_idx);
+
+	mana_xdp_tx(skb, ndev);
+
+	return 0;
+}
+
+int mana_xdp_xmit(struct net_device *ndev, int n, struct xdp_frame **frames,
+		  u32 flags)
+{
+	struct mana_port_context *apc = netdev_priv(ndev);
+	struct mana_stats_tx *tx_stats;
+	int i, count = 0;
+	u16 q_idx;
+
+	if (unlikely(!apc->port_is_up))
+		return 0;
+
+	q_idx = smp_processor_id() % ndev->real_num_tx_queues;
+
+	for (i = 0; i < n; i++) {
+		if (mana_xdp_xmit_fm(ndev, frames[i], q_idx))
+			break;
+
+		count++;
+	}
+
+	tx_stats = &apc->tx_qp[q_idx].txq.stats;
+
+	u64_stats_update_begin(&tx_stats->syncp);
+	tx_stats->xdp_xmit += count;
+	u64_stats_update_end(&tx_stats->syncp);
+
+	return count;
+}
+
 u32 mana_run_xdp(struct net_device *ndev, struct mana_rxq *rxq,
 		 struct xdp_buff *xdp, void *buf_va, uint pkt_len)
 {
+	struct mana_stats_rx *rx_stats;
 	struct bpf_prog *prog;
 	u32 act = XDP_PASS;
 
@@ -49,12 +95,30 @@ u32 mana_run_xdp(struct net_device *ndev, struct mana_rxq *rxq,
 
 	act = bpf_prog_run_xdp(prog, xdp);
 
+	rx_stats = &rxq->stats;
+
 	switch (act) {
 	case XDP_PASS:
 	case XDP_TX:
 	case XDP_DROP:
 		break;
 
+	case XDP_REDIRECT:
+		rxq->xdp_rc = xdp_do_redirect(ndev, xdp, prog);
+		if (!rxq->xdp_rc) {
+			rxq->xdp_flush = true;
+
+			u64_stats_update_begin(&rx_stats->syncp);
+			rx_stats->packets++;
+			rx_stats->bytes += pkt_len;
+			rx_stats->xdp_redirect++;
+			u64_stats_update_end(&rx_stats->syncp);
+
+			break;
+		}
+
+		fallthrough;
+
 	case XDP_ABORTED:
 		trace_xdp_exception(ndev, prog, act);
 		break;
diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index 3ef09e0cdbaa..9259a74eca40 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -6,6 +6,7 @@
 #include <linux/inetdevice.h>
 #include <linux/etherdevice.h>
 #include <linux/ethtool.h>
+#include <linux/filter.h>
 #include <linux/mm.h>
 
 #include <net/checksum.h>
@@ -382,6 +383,7 @@ static const struct net_device_ops mana_devops = {
 	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_get_stats64	= mana_get_stats64,
 	.ndo_bpf		= mana_bpf,
+	.ndo_xdp_xmit		= mana_xdp_xmit,
 };
 
 static void mana_cleanup_port_context(struct mana_port_context *apc)
@@ -1120,6 +1122,9 @@ static void mana_rx_skb(void *buf_va, struct mana_rxcomp_oob *cqe,
 
 	act = mana_run_xdp(ndev, rxq, &xdp, buf_va, pkt_len);
 
+	if (act == XDP_REDIRECT && !rxq->xdp_rc)
+		return;
+
 	if (act != XDP_PASS && act != XDP_TX)
 		goto drop_xdp;
 
@@ -1275,11 +1280,14 @@ static void mana_process_rx_cqe(struct mana_rxq *rxq, struct mana_cq *cq,
 static void mana_poll_rx_cq(struct mana_cq *cq)
 {
 	struct gdma_comp *comp = cq->gdma_comp_buf;
+	struct mana_rxq *rxq = cq->rxq;
 	int comp_read, i;
 
 	comp_read = mana_gd_poll_cq(cq->gdma_cq, comp, CQE_POLLING_BUFFER);
 	WARN_ON_ONCE(comp_read > CQE_POLLING_BUFFER);
 
+	rxq->xdp_flush = false;
+
 	for (i = 0; i < comp_read; i++) {
 		if (WARN_ON_ONCE(comp[i].is_sq))
 			return;
@@ -1288,8 +1296,11 @@ static void mana_poll_rx_cq(struct mana_cq *cq)
 		if (WARN_ON_ONCE(comp[i].wq_num != cq->rxq->gdma_id))
 			return;
 
-		mana_process_rx_cqe(cq->rxq, cq, &comp[i]);
+		mana_process_rx_cqe(rxq, cq, &comp[i]);
 	}
+
+	if (rxq->xdp_flush)
+		xdp_do_flush();
 }
 
 static void mana_cq_handler(void *context, struct gdma_queue *gdma_queue)
diff --git a/drivers/net/ethernet/microsoft/mana/mana_ethtool.c b/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
index e13f2453eabb..c530db76880f 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
@@ -23,7 +23,7 @@ static int mana_get_sset_count(struct net_device *ndev, int stringset)
 	if (stringset != ETH_SS_STATS)
 		return -EINVAL;
 
-	return ARRAY_SIZE(mana_eth_stats) + num_queues * 6;
+	return ARRAY_SIZE(mana_eth_stats) + num_queues * 8;
 }
 
 static void mana_get_strings(struct net_device *ndev, u32 stringset, u8 *data)
@@ -50,6 +50,8 @@ static void mana_get_strings(struct net_device *ndev, u32 stringset, u8 *data)
 		p += ETH_GSTRING_LEN;
 		sprintf(p, "rx_%d_xdp_tx", i);
 		p += ETH_GSTRING_LEN;
+		sprintf(p, "rx_%d_xdp_redirect", i);
+		p += ETH_GSTRING_LEN;
 	}
 
 	for (i = 0; i < num_queues; i++) {
@@ -57,6 +59,8 @@ static void mana_get_strings(struct net_device *ndev, u32 stringset, u8 *data)
 		p += ETH_GSTRING_LEN;
 		sprintf(p, "tx_%d_bytes", i);
 		p += ETH_GSTRING_LEN;
+		sprintf(p, "tx_%d_xdp_xmit", i);
+		p += ETH_GSTRING_LEN;
 	}
 }
 
@@ -70,6 +74,8 @@ static void mana_get_ethtool_stats(struct net_device *ndev,
 	struct mana_stats_tx *tx_stats;
 	unsigned int start;
 	u64 packets, bytes;
+	u64 xdp_redirect;
+	u64 xdp_xmit;
 	u64 xdp_drop;
 	u64 xdp_tx;
 	int q, i = 0;
@@ -89,12 +95,14 @@ static void mana_get_ethtool_stats(struct net_device *ndev,
 			bytes = rx_stats->bytes;
 			xdp_drop = rx_stats->xdp_drop;
 			xdp_tx = rx_stats->xdp_tx;
+			xdp_redirect = rx_stats->xdp_redirect;
 		} while (u64_stats_fetch_retry_irq(&rx_stats->syncp, start));
 
 		data[i++] = packets;
 		data[i++] = bytes;
 		data[i++] = xdp_drop;
 		data[i++] = xdp_tx;
+		data[i++] = xdp_redirect;
 	}
 
 	for (q = 0; q < num_queues; q++) {
@@ -104,10 +112,12 @@ static void mana_get_ethtool_stats(struct net_device *ndev,
 			start = u64_stats_fetch_begin_irq(&tx_stats->syncp);
 			packets = tx_stats->packets;
 			bytes = tx_stats->bytes;
+			xdp_xmit = tx_stats->xdp_xmit;
 		} while (u64_stats_fetch_retry_irq(&tx_stats->syncp, start));
 
 		data[i++] = packets;
 		data[i++] = bytes;
+		data[i++] = xdp_xmit;
 	}
 }
 
-- 
2.25.1

