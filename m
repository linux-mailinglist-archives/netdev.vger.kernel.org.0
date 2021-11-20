Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38775457A27
	for <lists+netdev@lfdr.de>; Sat, 20 Nov 2021 01:30:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235104AbhKTAdz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 19:33:55 -0500
Received: from mail-cusazon11021023.outbound.protection.outlook.com ([52.101.62.23]:6840
        "EHLO na01-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231761AbhKTAdy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Nov 2021 19:33:54 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZmYw1eRjG/Iguvwix59HYbJx/6uMpepUeYhSElhtpgTDw+dfxoCMHbbNIJN1uWnCce8/4Or2bdf4e1NdH+exUeA+4s2lR0/ru+2B7tSjI7mzsNyMdBeCa6POp3lM4K1QVeMs5rzQExJNCvqDP37EWRFWzTBQ6zpRVTSUwZMSlmZQOjnqF/hf4iT94aUa8mN+1aIO/RmhmS4TImkji+ZAp3W0e91KyR6yC9cQGqZ8UU9zdYSrbSGfz8liI9AIq9Vb25oWX4Xstz9tgyDboSBZW8pKO7GzNv94P81iqreN4AT26hMCYYxWi4tDWRZPLQj9LKiseAFbZTIYpvX5St9WzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/lhtBC76+A54BYhyrtXqB1zNG6GAjO2se0xN0Zwpg1g=;
 b=kWWNUzs8A9P2fflIPgvWKC4IVnZeLuTjqzKbVKcJ3Q8QkCACbBaLLcVqdh/BslyY/Q/KY7X0UhJ//Vj1eoSoPg8vsqgAMMn4j32Xo7EeWH6nIJJ0HB47dRiQpCpWE6IF5srjHoPooK7mg3YTNR9dQ2QZRgArmYo7GcHizwCOOeZx6/fglmsr0ZAx+kwrgPVf6sTOKqL/Tfz/JT7gPfwbmDAP9orcDZFOX2uTwAphgsouTSAc0PFjiz3WKJ4MM7HrqIICHArlvttJWj4lB5QNltNmOr5YTVIXW1MvFzDRNUemRJeryHqSToyEZb6iP/kP/EjNKiZo6AfrvTARgdBCFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/lhtBC76+A54BYhyrtXqB1zNG6GAjO2se0xN0Zwpg1g=;
 b=XzuKJoN/U06C9QpGhc6b9M2Dq55847H/mxq/aRMIH72JjOS1mWRnkzcf7MMJ71I/6L0V7IsUvblEHyWzgXj7jQ4o8N5yLRMz9Z/bMvls8JtMj2/UwrDGkVMdgEijBJvt8FsUSKnApPQdqmUyH4NTdwKfMzXsW9pGy28ObtCPr3Y=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from DM6PR21MB1340.namprd21.prod.outlook.com (2603:10b6:5:175::19)
 by DM5PR21MB1544.namprd21.prod.outlook.com (2603:10b6:4:7c::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.9; Sat, 20 Nov
 2021 00:30:49 +0000
Received: from DM6PR21MB1340.namprd21.prod.outlook.com
 ([fe80::e0e4:4bf2:cfdb:b121]) by DM6PR21MB1340.namprd21.prod.outlook.com
 ([fe80::e0e4:4bf2:cfdb:b121%5]) with mapi id 15.20.4734.006; Sat, 20 Nov 2021
 00:30:48 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     linux-hyperv@vger.kernel.org, netdev@vger.kernel.org
Cc:     haiyangz@microsoft.com, kys@microsoft.com, sthemmin@microsoft.com,
        paulros@microsoft.com, shacharr@microsoft.com, olaf@aepfle.de,
        vkuznets@redhat.com, davem@davemloft.net,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next] net: mana: Add XDP support
Date:   Fri, 19 Nov 2021 16:29:53 -0800
Message-Id: <1637368193-24538-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain
X-ClientProxiedBy: CO2PR04CA0194.namprd04.prod.outlook.com
 (2603:10b6:104:5::24) To DM6PR21MB1340.namprd21.prod.outlook.com
 (2603:10b6:5:175::19)
MIME-Version: 1.0
Sender: LKML haiyangz <lkmlhyz@microsoft.com>
X-MS-Exchange-MessageSentRepresentingType: 2
Received: from linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net (13.77.154.182) by CO2PR04CA0194.namprd04.prod.outlook.com (2603:10b6:104:5::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.22 via Frontend Transport; Sat, 20 Nov 2021 00:30:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8f851e8c-3f43-4ce4-c477-08d9abbcff5e
X-MS-TrafficTypeDiagnostic: DM5PR21MB1544:
X-LD-Processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
X-Microsoft-Antispam-PRVS: <DM5PR21MB154449AE3BA775E9BF730562AC9D9@DM5PR21MB1544.namprd21.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3173;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JFKaUBeI2mRgJN/ViY9mpK0/71cYWET0dv4bd70ZSSY+JlSmQwa+SQvIOw+MDtbfB2W8O4EdzYhgV+HCIZz0zL8vC+JRtUaSgnlf26ybMtGmhSRDzQI3pnNRs90TdGoX9M8oykVoGLXdxNMCJvf2OWyw2qHtxiEGE6mFm1GhHB0yljI6sBvCnJ4XMBQLURlP0PlfwYn2SnAy2/s0bQ4DzjsZq+Xtz8v8kf7Aq6LTD+pbgNAWCM99T7qltLB23OlnIVRsPINf3wm4D7si02e7Lzu9OHdUYXN8L0BgYgS8rallrtUCx7wy4YQ1Avxqe5IbGPSf2DL+snD7dIf7lkDnygwYgcqOno1X3ap3e4gy7i+HXpwHiGkhvps+V/qYcjT6TSxLSgiW+lu8NSjSmUqVUi89/5aLaFoxqWS1YUZtj6TCvUVyUo4K91xFy+Z4qNdoidoYxj+Ctj4xRg3NHJSRsQwb9eVEkUidjC5e+MAtSyCfOYfOR1vkbvVgBiz5RDBlK2EsJVXxDQgydq+ECPel2lFM4SoDagGUnmVPgrC4tfiHCYeNeJOfzzBOBtvOQoTmerUF3x+khI8YCCbjRswSptBzn9JLrduRgxZaSJOI2Sc2WCAzQ7rVUjq1rYg5YGkXtLUUUCGE8Vjpoxv+yI7Zf56qV1u4YMMDJOgrBVFyaM7WtG7BsEo2zzQKO0bZFtfespTpo4RthiSigb3//e9z+lI6VR3RyVXSfAU1mXybJqKzcULiDnMlnVhFnGEaPDNo
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR21MB1340.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(36756003)(2906002)(7846003)(66476007)(38100700002)(5660300002)(82960400001)(30864003)(83380400001)(38350700002)(82950400001)(10290500003)(316002)(4326008)(6506007)(8676002)(186003)(26005)(956004)(8936002)(6486002)(6666004)(66946007)(66556008)(52116002)(508600001)(6512007)(2616005)(20210929001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vqnvWAEj4aR7F29hP01RpAzScU74Rcw+GTZ6rhnowkfnD41HU6FQWkMJ44+Q?=
 =?us-ascii?Q?30zSdbv2TWeEUrJMtsEI/wdIWk4Niv6d05Z3UpRDoAVbmuUvqQwSSACmE/R4?=
 =?us-ascii?Q?uZeUy0yq/xe0S77oDBqYj5VOU5S9V/5QyehcAMwV2kVtfQawb1j+NPZgv3He?=
 =?us-ascii?Q?37JA5/LbzocJgOShN4PcJWKqyloY1y+nZ4PECran2l3YsKs9amXhAC79ASjy?=
 =?us-ascii?Q?Dae0EVanLSTtIYN6tMkR6ZhBXqdg/7PrB+NG6MXB7Z5RSyF2RDi/DPFSSpFZ?=
 =?us-ascii?Q?zM/EVzuGOIwWWEvNTlNrl5bXCLFuPak5V3NSEbmkpivRAwe2MiFLbv3jNSAi?=
 =?us-ascii?Q?n5inThTqHnt6KDMS/T1uO0R8fsfbTuQ0BK1zydoeMTPktN63epXxLKrXKJqk?=
 =?us-ascii?Q?C+q9TM0QlSv4K4YvcwlVchdxvM7MTNg1oVpR5qAyzIhZiqE1EZhGzz/8naRt?=
 =?us-ascii?Q?K4A8CL7a+ZPgpJxIftNXdYRV7e0ddcAIrEgYl2MMhUdmOrF0Uc1kziP9LVml?=
 =?us-ascii?Q?Pc7VHH0bYR40OuCclydwA+a/GQIQP39p4CtnQ6TrwU+qqPp2chtjgwsqgwY4?=
 =?us-ascii?Q?GLy+7agwuxi+wMW+erlrb91SN7+DT0PmZcUkNfOJUHfBh7qiidmZVvjnvjJB?=
 =?us-ascii?Q?wVSLzRShe1h2cMz9pOuyVSnUowudFOdBpbJf6qf7fzsBGjE0pn0Ymedd8jvw?=
 =?us-ascii?Q?cWOxdL1UwaB3l+rJVm8VtjVTg2RdYn6eMCEEHEZM6DrcyNBKEUbByM8hkr46?=
 =?us-ascii?Q?GSY3jMU1Ebzzg6alKFoyla6n9HLa+ZxqsH3tU6Azd1By0IYY2dNA2ePjDizP?=
 =?us-ascii?Q?LUhPB8CLDqk6qUKdONGSu7+VwwbENvf09j/ywqSZA3HNWW8MkC0NdBSiKH2P?=
 =?us-ascii?Q?P4QjU8hruT3UT4aONEkArUSgVL41xF2TkFw1kOAIltwlE7gAsZB+3DaAaPcq?=
 =?us-ascii?Q?OJZXql+14taRsQq5JD9NyVzzIiqS6ge/LM5GJNdMUtHmgbBOgVLyBXjfp7OH?=
 =?us-ascii?Q?NP/I5YNqUREnAUjbthmFCq7a9DtoFfxxArOIRf7ebfLU3bEEUvx0GPjpVv6y?=
 =?us-ascii?Q?4FjB5PDcd20QrG8TpznMeH4sphBjb98VdbUbWTsrazlSQwesfdu/ix0mEQa/?=
 =?us-ascii?Q?IAbA9Z/S4idqFThfM3HpuoM9iEKFPs7Tq1iJFFvaiyrNhfLrKsoNUVHLUtEZ?=
 =?us-ascii?Q?HGdSOHIw7qRS0Shylcam8VRfjDnE7rxDKySLGahXiH9cD+WUfd9MPn9G6FTc?=
 =?us-ascii?Q?8SHMBMTtCADqVJHLy7g2Ytl1mUxby+vQmpf5TIwvbWq3unYBt1hH5pPHX/8P?=
 =?us-ascii?Q?x+Uoxa8UwL4FTjmIek2tr1aOj7kr7IEnNbSBM3jWEqCKqS3MgaA5CRFmqj9r?=
 =?us-ascii?Q?7FYGvvBr2SuKjBiLeMWRsxDunZKGCtPvy42/55DPq0pgastqE/XlNbn6tSeq?=
 =?us-ascii?Q?+qnaIoj94HwC4HhIDUKNzsSRWpQCXRkcfRcbHc5osDs187qe0TXqaS1jD4e6?=
 =?us-ascii?Q?9Fxz2puPys45IsHedkALT7F/SZZ4c6ttfdbyAOezKvqTEjkxtLU6JX8Gf3O8?=
 =?us-ascii?Q?plJnLlkZXstR1JZZssG3nFsqhijNLVnRdVfoW3ie2tJdkh5rGPPfOOzIvMH7?=
 =?us-ascii?Q?VQ1GWRIeN0deybEmYRROfAU=3D?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f851e8c-3f43-4ce4-c477-08d9abbcff5e
X-MS-Exchange-CrossTenant-AuthSource: DM6PR21MB1340.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2021 00:30:48.4641
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L5e1JCwiijUNe2yV829yAIXq1oflse5+nYm7ZSGkXaPu8YGS9d456DBTelUWsMbqaSQiveBb8z4TU/gkCRYVmg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR21MB1544
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support of XDP for the MANA driver.

Supported XDP actions:
	XDP_PASS, XDP_TX, XDP_DROP, XDP_ABORTED

XDP actions not yet supported:
	XDP_REDIRECT

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/net/ethernet/microsoft/mana/Makefile  |   2 +-
 drivers/net/ethernet/microsoft/mana/mana.h    |  13 ++
 .../net/ethernet/microsoft/mana/mana_bpf.c    | 162 ++++++++++++++++++
 drivers/net/ethernet/microsoft/mana/mana_en.c |  69 ++++++--
 4 files changed, 235 insertions(+), 11 deletions(-)
 create mode 100644 drivers/net/ethernet/microsoft/mana/mana_bpf.c

diff --git a/drivers/net/ethernet/microsoft/mana/Makefile b/drivers/net/ethernet/microsoft/mana/Makefile
index 0edd5bb685f3..e16a4221f571 100644
--- a/drivers/net/ethernet/microsoft/mana/Makefile
+++ b/drivers/net/ethernet/microsoft/mana/Makefile
@@ -3,4 +3,4 @@
 # Makefile for the Microsoft Azure Network Adapter driver
 
 obj-$(CONFIG_MICROSOFT_MANA) += mana.o
-mana-objs := gdma_main.o shm_channel.o hw_channel.o mana_en.o mana_ethtool.o
+mana-objs := gdma_main.o shm_channel.o hw_channel.o mana_en.o mana_ethtool.o mana_bpf.o
diff --git a/drivers/net/ethernet/microsoft/mana/mana.h b/drivers/net/ethernet/microsoft/mana/mana.h
index d047ee876f12..0c5553887b75 100644
--- a/drivers/net/ethernet/microsoft/mana/mana.h
+++ b/drivers/net/ethernet/microsoft/mana/mana.h
@@ -298,6 +298,9 @@ struct mana_rxq {
 
 	struct mana_stats stats;
 
+	struct bpf_prog __rcu *bpf_prog;
+	struct xdp_rxq_info xdp_rxq;
+
 	/* MUST BE THE LAST MEMBER:
 	 * Each receive buffer has an associated mana_recv_buf_oob.
 	 */
@@ -353,6 +356,8 @@ struct mana_port_context {
 	/* This points to an array of num_queues of RQ pointers. */
 	struct mana_rxq **rxqs;
 
+	struct bpf_prog *bpf_prog;
+
 	/* Create num_queues EQs, SQs, SQ-CQs, RQs and RQ-CQs, respectively. */
 	unsigned int max_queues;
 	unsigned int num_queues;
@@ -367,6 +372,7 @@ struct mana_port_context {
 	struct mana_ethtool_stats eth_stats;
 };
 
+int mana_start_xmit(struct sk_buff *skb, struct net_device *ndev);
 int mana_config_rss(struct mana_port_context *ac, enum TRI_STATE rx,
 		    bool update_hash, bool update_tab);
 
@@ -377,6 +383,13 @@ int mana_detach(struct net_device *ndev, bool from_close);
 int mana_probe(struct gdma_dev *gd, bool resuming);
 void mana_remove(struct gdma_dev *gd, bool suspending);
 
+void mana_xdp_tx(struct sk_buff *skb, struct net_device *ndev);
+u32 mana_run_xdp(struct net_device *ndev, struct mana_rxq *rxq,
+		 struct xdp_buff *xdp, void *buf_va, uint pkt_len);
+struct bpf_prog *mana_xdp_get(struct mana_port_context *apc);
+void mana_chn_setxdp(struct mana_port_context *apc, struct bpf_prog *prog);
+int mana_bpf(struct net_device *ndev, struct netdev_bpf *bpf);
+
 extern const struct ethtool_ops mana_ethtool_ops;
 
 struct mana_obj_spec {
diff --git a/drivers/net/ethernet/microsoft/mana/mana_bpf.c b/drivers/net/ethernet/microsoft/mana/mana_bpf.c
new file mode 100644
index 000000000000..1bc8ff388341
--- /dev/null
+++ b/drivers/net/ethernet/microsoft/mana/mana_bpf.c
@@ -0,0 +1,162 @@
+// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
+/* Copyright (c) 2021, Microsoft Corporation. */
+
+#include <linux/inetdevice.h>
+#include <linux/etherdevice.h>
+#include <linux/mm.h>
+#include <linux/bpf.h>
+#include <linux/bpf_trace.h>
+#include <net/xdp.h>
+
+#include "mana.h"
+
+void mana_xdp_tx(struct sk_buff *skb, struct net_device *ndev)
+{
+	u16 txq_idx = skb_get_queue_mapping(skb);
+	struct netdev_queue *ndevtxq;
+	int rc;
+
+	__skb_push(skb, ETH_HLEN);
+
+	ndevtxq = netdev_get_tx_queue(ndev, txq_idx);
+	__netif_tx_lock(ndevtxq, smp_processor_id());
+
+	rc = mana_start_xmit(skb, ndev);
+
+	__netif_tx_unlock(ndevtxq);
+
+	if (dev_xmit_complete(rc))
+		return;
+
+	dev_kfree_skb_any(skb);
+	ndev->stats.tx_dropped++;
+}
+
+u32 mana_run_xdp(struct net_device *ndev, struct mana_rxq *rxq,
+		 struct xdp_buff *xdp, void *buf_va, uint pkt_len)
+{
+	struct bpf_prog *prog;
+	u32 act = XDP_PASS;
+
+	rcu_read_lock();
+	prog = rcu_dereference(rxq->bpf_prog);
+
+	if (!prog)
+		goto out;
+
+	xdp_init_buff(xdp, PAGE_SIZE, &rxq->xdp_rxq);
+	xdp_prepare_buff(xdp, buf_va, XDP_PACKET_HEADROOM, pkt_len, false);
+
+	act = bpf_prog_run_xdp(prog, xdp);
+
+	switch (act) {
+	case XDP_PASS:
+	case XDP_TX:
+	case XDP_DROP:
+		break;
+
+	case XDP_ABORTED:
+		trace_xdp_exception(ndev, prog, act);
+		break;
+
+	default:
+		bpf_warn_invalid_xdp_action(act);
+	}
+
+out:
+	rcu_read_unlock();
+
+	return act;
+}
+
+static unsigned int mana_xdp_fraglen(unsigned int len)
+{
+	return SKB_DATA_ALIGN(len) +
+	       SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
+}
+
+struct bpf_prog *mana_xdp_get(struct mana_port_context *apc)
+{
+	ASSERT_RTNL();
+
+	return apc->bpf_prog;
+}
+
+static struct bpf_prog *mana_chn_xdp_get(struct mana_port_context *apc)
+{
+	return rtnl_dereference(apc->rxqs[0]->bpf_prog);
+}
+
+/* Set xdp program on channels */
+void mana_chn_setxdp(struct mana_port_context *apc, struct bpf_prog *prog)
+{
+	struct bpf_prog *old_prog = mana_chn_xdp_get(apc);
+	unsigned int num_queues = apc->num_queues;
+	int i;
+
+	ASSERT_RTNL();
+
+	if (old_prog == prog)
+		return;
+
+	if (prog)
+		bpf_prog_add(prog, num_queues);
+
+	for (i = 0; i < num_queues; i++)
+		rcu_assign_pointer(apc->rxqs[i]->bpf_prog, prog);
+
+	if (old_prog)
+		for (i = 0; i < num_queues; i++)
+			bpf_prog_put(old_prog);
+}
+
+static int mana_xdp_set(struct net_device *ndev, struct bpf_prog *prog,
+			struct netlink_ext_ack *extack)
+{
+	struct mana_port_context *apc = netdev_priv(ndev);
+	struct bpf_prog *old_prog;
+	int buf_max;
+
+	old_prog = mana_xdp_get(apc);
+
+	if (!old_prog && !prog)
+		return 0;
+
+	buf_max = XDP_PACKET_HEADROOM + mana_xdp_fraglen(ndev->mtu + ETH_HLEN);
+	if (prog && buf_max > PAGE_SIZE) {
+		netdev_err(ndev, "XDP: mtu:%u too large, buf_max:%u\n",
+			   ndev->mtu, buf_max);
+		NL_SET_ERR_MSG_MOD(extack, "XDP: mtu too large");
+
+		return -EOPNOTSUPP;
+	}
+
+	/* One refcnt of the prog is hold by the caller already, so
+	 * don't increase refcnt for this one.
+	 */
+	apc->bpf_prog = prog;
+
+	if (old_prog)
+		bpf_prog_put(old_prog);
+
+	if (apc->port_is_up)
+		mana_chn_setxdp(apc, prog);
+
+	return 0;
+}
+
+int mana_bpf(struct net_device *ndev, struct netdev_bpf *bpf)
+{
+	struct netlink_ext_ack *extack = bpf->extack;
+	int ret;
+
+	switch (bpf->command) {
+	case XDP_SETUP_PROG:
+		return mana_xdp_set(ndev, bpf->prog, extack);
+
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	return ret;
+}
diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index 72cbf45c42d8..c1d5a374b967 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -125,7 +125,7 @@ static int mana_map_skb(struct sk_buff *skb, struct mana_port_context *apc,
 	return -ENOMEM;
 }
 
-static int mana_start_xmit(struct sk_buff *skb, struct net_device *ndev)
+int mana_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 {
 	enum mana_tx_pkt_format pkt_fmt = MANA_SHORT_PKT_FMT;
 	struct mana_port_context *apc = netdev_priv(ndev);
@@ -378,6 +378,7 @@ static const struct net_device_ops mana_devops = {
 	.ndo_start_xmit		= mana_start_xmit,
 	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_get_stats64	= mana_get_stats64,
+	.ndo_bpf		= mana_bpf,
 };
 
 static void mana_cleanup_port_context(struct mana_port_context *apc)
@@ -906,6 +907,25 @@ static void mana_post_pkt_rxq(struct mana_rxq *rxq)
 	WARN_ON_ONCE(recv_buf_oob->wqe_inf.wqe_size_in_bu != 1);
 }
 
+static struct sk_buff *mana_build_skb(void *buf_va, uint pkt_len,
+				      struct xdp_buff *xdp)
+{
+	struct sk_buff *skb = build_skb(buf_va, PAGE_SIZE);
+
+	if (!skb)
+		return NULL;
+
+	if (xdp->data_hard_start) {
+		skb_reserve(skb, xdp->data - xdp->data_hard_start);
+		skb_put(skb, xdp->data_end - xdp->data);
+	} else {
+		skb_reserve(skb, XDP_PACKET_HEADROOM);
+		skb_put(skb, pkt_len);
+	}
+
+	return skb;
+}
+
 static void mana_rx_skb(void *buf_va, struct mana_rxcomp_oob *cqe,
 			struct mana_rxq *rxq)
 {
@@ -914,8 +934,10 @@ static void mana_rx_skb(void *buf_va, struct mana_rxcomp_oob *cqe,
 	uint pkt_len = cqe->ppi[0].pkt_len;
 	u16 rxq_idx = rxq->rxq_idx;
 	struct napi_struct *napi;
+	struct xdp_buff xdp = {};
 	struct sk_buff *skb;
 	u32 hash_value;
+	u32 act;
 
 	rxq->rx_cq.work_done++;
 	napi = &rxq->rx_cq.napi;
@@ -925,15 +947,16 @@ static void mana_rx_skb(void *buf_va, struct mana_rxcomp_oob *cqe,
 		return;
 	}
 
-	skb = build_skb(buf_va, PAGE_SIZE);
+	act = mana_run_xdp(ndev, rxq, &xdp, buf_va, pkt_len);
 
-	if (!skb) {
-		free_page((unsigned long)buf_va);
-		++ndev->stats.rx_dropped;
-		return;
-	}
+	if (act != XDP_PASS && act != XDP_TX)
+		goto drop;
+
+	skb = mana_build_skb(buf_va, pkt_len, &xdp);
+
+	if (!skb)
+		goto drop;
 
-	skb_put(skb, pkt_len);
 	skb->dev = napi->dev;
 
 	skb->protocol = eth_type_trans(skb, ndev);
@@ -954,12 +977,24 @@ static void mana_rx_skb(void *buf_va, struct mana_rxcomp_oob *cqe,
 			skb_set_hash(skb, hash_value, PKT_HASH_TYPE_L3);
 	}
 
+	if (act == XDP_TX) {
+		skb_set_queue_mapping(skb, rxq_idx);
+		mana_xdp_tx(skb, ndev);
+		return;
+	}
+
 	napi_gro_receive(napi, skb);
 
 	u64_stats_update_begin(&rx_stats->syncp);
 	rx_stats->packets++;
 	rx_stats->bytes += pkt_len;
 	u64_stats_update_end(&rx_stats->syncp);
+	return;
+
+drop:
+	free_page((unsigned long)buf_va);
+	++ndev->stats.rx_dropped;
+	return;
 }
 
 static void mana_process_rx_cqe(struct mana_rxq *rxq, struct mana_cq *cq,
@@ -1016,7 +1051,7 @@ static void mana_process_rx_cqe(struct mana_rxq *rxq, struct mana_cq *cq,
 	new_page = alloc_page(GFP_ATOMIC);
 
 	if (new_page) {
-		da = dma_map_page(dev, new_page, 0, rxq->datasize,
+		da = dma_map_page(dev, new_page, XDP_PACKET_HEADROOM, rxq->datasize,
 				  DMA_FROM_DEVICE);
 
 		if (dma_mapping_error(dev, da)) {
@@ -1291,6 +1326,9 @@ static void mana_destroy_rxq(struct mana_port_context *apc,
 		napi_synchronize(napi);
 
 	napi_disable(napi);
+
+	xdp_rxq_info_unreg(&rxq->xdp_rxq);
+
 	netif_napi_del(napi);
 
 	mana_destroy_wq_obj(apc, GDMA_RQ, rxq->rxobj);
@@ -1342,7 +1380,8 @@ static int mana_alloc_rx_wqe(struct mana_port_context *apc,
 		if (!page)
 			return -ENOMEM;
 
-		da = dma_map_page(dev, page, 0, rxq->datasize, DMA_FROM_DEVICE);
+		da = dma_map_page(dev, page, XDP_PACKET_HEADROOM, rxq->datasize,
+				  DMA_FROM_DEVICE);
 
 		if (dma_mapping_error(dev, da)) {
 			__free_page(page);
@@ -1485,6 +1524,12 @@ static struct mana_rxq *mana_create_rxq(struct mana_port_context *apc,
 	gc->cq_table[cq->gdma_id] = cq->gdma_cq;
 
 	netif_napi_add(ndev, &cq->napi, mana_poll, 1);
+
+	WARN_ON(xdp_rxq_info_reg(&rxq->xdp_rxq, ndev, rxq_idx,
+				 cq->napi.napi_id));
+	WARN_ON(xdp_rxq_info_reg_mem_model(&rxq->xdp_rxq,
+					   MEM_TYPE_PAGE_SHARED, NULL));
+
 	napi_enable(&cq->napi);
 
 	mana_gd_ring_cq(cq->gdma_cq, SET_ARM_BIT);
@@ -1650,6 +1695,8 @@ int mana_alloc_queues(struct net_device *ndev)
 	if (err)
 		goto destroy_vport;
 
+	mana_chn_setxdp(apc, mana_xdp_get(apc));
+
 	return 0;
 
 destroy_vport:
@@ -1698,6 +1745,8 @@ static int mana_dealloc_queues(struct net_device *ndev)
 	if (apc->port_is_up)
 		return -EINVAL;
 
+	mana_chn_setxdp(apc, NULL);
+
 	/* No packet can be transmitted now since apc->port_is_up is false.
 	 * There is still a tiny chance that mana_poll_tx_cq() can re-enable
 	 * a txq because it may not timely see apc->port_is_up being cleared
-- 
2.25.1

