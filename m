Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D4F74A2B2B
	for <lists+netdev@lfdr.de>; Sat, 29 Jan 2022 03:04:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352145AbiA2CEq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 21:04:46 -0500
Received: from mail-dm6nam12on2094.outbound.protection.outlook.com ([40.107.243.94]:28512
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1344799AbiA2CEn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Jan 2022 21:04:43 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=heXeX4l0G3cpntZwY5IArn3y9WezJubHjSL7N6EgxCTePALcqrzJ5AQaEWWmmqTAFz5ZBaEAcp+6xHKYvBQODaZ88/h62ljHJ4AkTYrCV94cP7C91sSSL5h+AwN45qEyHFw+k51lke/m9QAeAmyjgrWEPTpPbj72ceYP5GayE+5RXJ5Ql2LBU+Db4WbL4iGjfDpscSwGwUIN87eNVR5KdZmEuNzCYv+RfFdTbknM+nC1Y5X7u6eZlWNnQIPPOgwWfVhoQT2Q1JBqR7pQxILzMVpbFEVUFhCdFx8tOQK9skpJhabhvIV4v/5EU7v3qmC8yLZ7cmG2ri1wM4cthkvBhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wT4VPGJxtAHLvWhPlhfrmp7aNRFbCRFErgdIdo/ZqCY=;
 b=kRQHq7xRlDC/Dy1fW146jRjbvs7AcbpZaT+InzxRAGpvy2oiIuFWoB+okLmtygG9lW2aDCAKAMGXR1owW+A+7p2J+8IxubcVTDSLZ8j2uXKnDGbu+7227MLZKdgxLk3x/mydD/ADFpOdPyYWqhmsFLPJrLld6EISkntSLjlgcG+yb7Pmx027DSudGPlAGEFwT5v6q19a1MS5oJwLMZ6zrie+OrQHgTvFSdK7JCQlKBYRtVFJUBNWI6zp7mzd4nTZKeIT1gH1pwpDgmARi3XySKLhxD3S/wx27BpDR11DcXOai5DFwWFr/+9rmaKZgtwGEilF2+DbzM1Ovt3b6uy1Wg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wT4VPGJxtAHLvWhPlhfrmp7aNRFbCRFErgdIdo/ZqCY=;
 b=U9Yg3tQYGtmCLpqECK4uzky4SqK8jMhsLfUQhmgRHss7Txg5Jp9rSWy7xpUzUkvcF/m8fXQlvBt+M2ydLWpfVb+Ip+K05AYxoQPQu/coS7uWu1Wi2Udx51MlW3fNwRIvNZkWBY46lF711vGtW38FI2Jxrju/1CZNuYXyDdLF7ew=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from DM6PR21MB1340.namprd21.prod.outlook.com (2603:10b6:5:175::19)
 by MWHPR21MB0191.namprd21.prod.outlook.com (2603:10b6:300:79::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.7; Sat, 29 Jan
 2022 02:04:37 +0000
Received: from DM6PR21MB1340.namprd21.prod.outlook.com
 ([fe80::1d9b:cd14:e6bb:43fd]) by DM6PR21MB1340.namprd21.prod.outlook.com
 ([fe80::1d9b:cd14:e6bb:43fd%6]) with mapi id 15.20.4951.007; Sat, 29 Jan 2022
 02:04:37 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     linux-hyperv@vger.kernel.org, netdev@vger.kernel.org
Cc:     haiyangz@microsoft.com, decui@microsoft.com, kys@microsoft.com,
        sthemmin@microsoft.com, paulros@microsoft.com,
        shacharr@microsoft.com, olaf@aepfle.de, vkuznets@redhat.com,
        davem@davemloft.net, linux-kernel@vger.kernel.org
Subject: [PATCH net-next, 2/3] net: mana: Add counter for XDP_TX
Date:   Fri, 28 Jan 2022 18:03:37 -0800
Message-Id: <1643421818-14259-3-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1643421818-14259-1-git-send-email-haiyangz@microsoft.com>
References: <1643421818-14259-1-git-send-email-haiyangz@microsoft.com>
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0311.namprd03.prod.outlook.com
 (2603:10b6:303:dd::16) To DM6PR21MB1340.namprd21.prod.outlook.com
 (2603:10b6:5:175::19)
MIME-Version: 1.0
Sender: LKML haiyangz <lkmlhyz@microsoft.com>
X-MS-Exchange-MessageSentRepresentingType: 2
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f7fe4f13-a20e-4974-ad4a-08d9e2cbb3a9
X-MS-TrafficTypeDiagnostic: MWHPR21MB0191:EE_
X-LD-Processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
X-MS-Exchange-AtpMessageProperties: SA|SL
X-Microsoft-Antispam-PRVS: <MWHPR21MB0191D650B4535932EDA9B9B4AC239@MWHPR21MB0191.namprd21.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2582;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nj8b0rLI181suoMN0pDUiRZtUABCaZ7BJ5BbGaF8fQInBhIB9Cn20spmsAxhP94+hhwlXwQGj/tYavYII/aIzJPy+gG+bEIhPTwE13rcdohnvR1AfhdqTciX1rj5TAe8/CSmpalIRhVVIVnrpkfqOINRgZhCCpn43xZbaPjuBrV9K8FOFR9SkRPSYlQCWcP02T5BYz+ONihvMep4mPewUQcwUV637Jo04xpVdaw2HjKVS6TTr0GNzX0iXUDy+blxtQGPHpyiOWvwtbKxfvo6AxPW/x8bmihm4QhLO9Cnxb9RxubObz1EvDmn9Frydn6kbepyY+u0itYAYtO+C+LBfbfxxP4codMwTgyUsG4fN1uN310/8Az1FOlhgpuzLopMriQGNOl9RyOzhDX4BUuioEXK4wvyJykDIlFINJc2dG4Amdj9JeN91nbMVGHCHcbVAI3/weUYtolYLTkCC8pRXIXrpoJH0tYbhR1LbRs4lM+0CUuNQ+AiwkUItU4TxKeM+cB2LIsOEl1o4kuZyvpa+5pJGkZhGrcBYJXkBOGwamdHPBSvWJFWa2TWj6Qv9tJ+EA0Go9qZYDM6tKxgSLlT7Mx05kS1hBBdnXxjuPSkr3zlbnJD3MOcNDLejgh1lmnSzOisqrrpUwHdJ8NZQC55I8F71U5zyUeLWFlWjHsVwS79DzvNH1fruqS9mSfXET1cDNp72VmBtmrfcgQtyK0k+zYOiw+uzNdW/leBpETsk0ZZC17LyPxg9uPF5HGpvapT
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR21MB1340.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66556008)(66946007)(4326008)(66476007)(8676002)(8936002)(5660300002)(38350700002)(38100700002)(82950400001)(316002)(82960400001)(186003)(6512007)(6506007)(26005)(2906002)(2616005)(508600001)(36756003)(7846003)(52116002)(83380400001)(6486002)(10290500003)(20210929001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?F281lrCiyBUdVfdIOqUImpPJ0tvHMlpxOPT2atrD7yQa5LAasZNrVu6pNeq8?=
 =?us-ascii?Q?axw30AEl1EpReqfPX6GeHrQ2CQyHV3clwR8l9nsadPAbURFSjYwyYqNULypo?=
 =?us-ascii?Q?0v/R7+xndgvBZIeKF6Uqc8wNwgSnjwcEZx07IvMwcZSxXALTQzZuOC44bunw?=
 =?us-ascii?Q?M9dFARz4F9Pl3+oXiLoRcY2g0wiX5vPbLWdwzDSRqq/aVitxxxoUo2TQq9Y5?=
 =?us-ascii?Q?5ccbwA0nnCg5q1EQIgyHYiWmnqgqNznuYE+omzHcdx/aq/J/sQGjxDIObS5J?=
 =?us-ascii?Q?o5dAahCjIGERoLCr5zndcZ6sR1w/dcNs3WGyL2OKCOav90/Q3N4ZqK0AJgAG?=
 =?us-ascii?Q?fEztdKgiHiFydm54MrVjhwLgOBwiUDjzrIbqSUBc1dGFKtzMttRHSqKJbrGF?=
 =?us-ascii?Q?zWKUuBEBHcXIrlmb/HumJy083r4G4TZCSI8R8uVYuZe8huvJWkV5kJyZrJSS?=
 =?us-ascii?Q?Aaljj4X6ubdEHyfiP/mXakjbyyZd+vyJYnr6hduxQoqCWdCEOtvkwUjMSXG0?=
 =?us-ascii?Q?ugjdCxdE4DIvHWhVSFA4+Ip2hf9olkK2vDZCpska5jjUk6wmomzohqYXwBip?=
 =?us-ascii?Q?7NDNXvPUcIIr4lVdzLwMaRCa9WWfcQdBKpqCyvsRbEMfiJ47zRqiov8ABlig?=
 =?us-ascii?Q?UDbGz3kInq/2SZDFXZfdfkHdhrptWeBa0oEblm/tBbWprzasywGdxhCqA3Et?=
 =?us-ascii?Q?4meJaJBp2ex8Ztq4Bw0+6BusYYouu8gk82QlhgoGnWJKOWGtyhhkkWJvn5Tc?=
 =?us-ascii?Q?CpmoxD18qkJMcSxrMAgGgiYv6Wh6JiI6wFEgBindKSwL4yZhm7SKO8Jnkopy?=
 =?us-ascii?Q?IiN+zS71P2MHihN5o6CVLQLaCcnsjjAtxLLUeH6H/Aq46uqESpSuy7tDAw3K?=
 =?us-ascii?Q?bRA3uouXcntTuxXe/qmn3L5PqMcnD88HXVV2krAZWU13hGH7iK1Z3w/NUH5R?=
 =?us-ascii?Q?Y30gc7hsJ+COw38nnecf/+5hZaVeU9T44wZ+vyYXLurRzLp8el1TYNvk+h5U?=
 =?us-ascii?Q?3x06Y16lM8xouHRr4sPjcufMmFpjWahkdhli7mA1YqNY37HZsEMYNBCH6WBG?=
 =?us-ascii?Q?6CdD2HpGHDQBAzGMYFdGK+41l/0vNKyzfcZPqtgbuVacbULe9O/c9J5t8exv?=
 =?us-ascii?Q?29ikc4V1NEqYhKqTguD8ZXh0vLZZ202YLfg+psWs8pQqQvDgISeo9gGAll34?=
 =?us-ascii?Q?3iJVsSPCQdN2L1oGhgQLtLrsYZXskQpO6M9soViKQmJmHeaDuYJiQaus5zQw?=
 =?us-ascii?Q?SRjtCEWgrjym6BRIgupWu0H95zi8zvJcpS63DNhQqV1t8Dmk9kcaAGLGul1P?=
 =?us-ascii?Q?XLyAYrhfTEVIElMU8flb0uZMF3Njx6+YOdNkCGm2H4tMug4AFc21ICxwKZ9E?=
 =?us-ascii?Q?/1DAq0kok6rErSYxORgjlYAW4EMgMyWgR8u+hb++4Mm6y9z/tdMfFiLldxi9?=
 =?us-ascii?Q?DkStVb8ugRxouO3HhrhoVSJDhAWKwxPa55TgoH47wk5jewkHd7+snsjU84lC?=
 =?us-ascii?Q?+y0igYEVzXsjkeZWmbXHxjaAtg09yixX/tKNxJxjRg9Yng9qjHrJ0imn4mUC?=
 =?us-ascii?Q?MBKbSUwgBlOSqVnsnr9726AMK5gWHzyQQe8w/T6EHbZcUumxzz0JBqNazSql?=
 =?us-ascii?Q?JAYTX+/EPCwhyGI4TSvf1Wc=3D?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f7fe4f13-a20e-4974-ad4a-08d9e2cbb3a9
X-MS-Exchange-CrossTenant-AuthSource: DM6PR21MB1340.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2022 02:04:37.1665
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JyC5lwn7gdcoMtcbBJc7v7iiHjSR/C/Dn0fgzRdinpYLXWAw6khTje9nvuR1Q7GVLxEet7A0bMPl2OouPBdmXQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR21MB0191
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This counter will show up in ethtool stat. It is the
number of packets received and forwarded by XDP program.

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/net/ethernet/microsoft/mana/mana.h         |  1 +
 drivers/net/ethernet/microsoft/mana/mana_en.c      | 12 ++++++++----
 drivers/net/ethernet/microsoft/mana/mana_ethtool.c |  7 ++++++-
 3 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/mana.h b/drivers/net/ethernet/microsoft/mana/mana.h
index 66fc98d7e1d6..8ead960f898d 100644
--- a/drivers/net/ethernet/microsoft/mana/mana.h
+++ b/drivers/net/ethernet/microsoft/mana/mana.h
@@ -52,6 +52,7 @@ struct mana_stats_rx {
 	u64 packets;
 	u64 bytes;
 	u64 xdp_drop;
+	u64 xdp_tx;
 	struct u64_stats_sync syncp;
 };
 
diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index 878c3d9bb39d..12067bf5b7d6 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -1035,6 +1035,14 @@ static void mana_rx_skb(void *buf_va, struct mana_rxcomp_oob *cqe,
 			skb_set_hash(skb, hash_value, PKT_HASH_TYPE_L3);
 	}
 
+	u64_stats_update_begin(&rx_stats->syncp);
+	rx_stats->packets++;
+	rx_stats->bytes += pkt_len;
+
+	if (act == XDP_TX)
+		rx_stats->xdp_tx++;
+	u64_stats_update_end(&rx_stats->syncp);
+
 	if (act == XDP_TX) {
 		skb_set_queue_mapping(skb, rxq_idx);
 		mana_xdp_tx(skb, ndev);
@@ -1043,10 +1051,6 @@ static void mana_rx_skb(void *buf_va, struct mana_rxcomp_oob *cqe,
 
 	napi_gro_receive(napi, skb);
 
-	u64_stats_update_begin(&rx_stats->syncp);
-	rx_stats->packets++;
-	rx_stats->bytes += pkt_len;
-	u64_stats_update_end(&rx_stats->syncp);
 	return;
 
 drop_xdp:
diff --git a/drivers/net/ethernet/microsoft/mana/mana_ethtool.c b/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
index e1ccb9bf62de..e13f2453eabb 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
@@ -23,7 +23,7 @@ static int mana_get_sset_count(struct net_device *ndev, int stringset)
 	if (stringset != ETH_SS_STATS)
 		return -EINVAL;
 
-	return ARRAY_SIZE(mana_eth_stats) + num_queues * 5;
+	return ARRAY_SIZE(mana_eth_stats) + num_queues * 6;
 }
 
 static void mana_get_strings(struct net_device *ndev, u32 stringset, u8 *data)
@@ -48,6 +48,8 @@ static void mana_get_strings(struct net_device *ndev, u32 stringset, u8 *data)
 		p += ETH_GSTRING_LEN;
 		sprintf(p, "rx_%d_xdp_drop", i);
 		p += ETH_GSTRING_LEN;
+		sprintf(p, "rx_%d_xdp_tx", i);
+		p += ETH_GSTRING_LEN;
 	}
 
 	for (i = 0; i < num_queues; i++) {
@@ -69,6 +71,7 @@ static void mana_get_ethtool_stats(struct net_device *ndev,
 	unsigned int start;
 	u64 packets, bytes;
 	u64 xdp_drop;
+	u64 xdp_tx;
 	int q, i = 0;
 
 	if (!apc->port_is_up)
@@ -85,11 +88,13 @@ static void mana_get_ethtool_stats(struct net_device *ndev,
 			packets = rx_stats->packets;
 			bytes = rx_stats->bytes;
 			xdp_drop = rx_stats->xdp_drop;
+			xdp_tx = rx_stats->xdp_tx;
 		} while (u64_stats_fetch_retry_irq(&rx_stats->syncp, start));
 
 		data[i++] = packets;
 		data[i++] = bytes;
 		data[i++] = xdp_drop;
+		data[i++] = xdp_tx;
 	}
 
 	for (q = 0; q < num_queues; q++) {
-- 
2.25.1

