Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E1FD4E248F
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 11:43:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346450AbiCUKoa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 06:44:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346454AbiCUKoP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 06:44:15 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2131.outbound.protection.outlook.com [40.107.243.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38D1814A934
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 03:42:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IipFA3FR86qkHTSmV27MW9e4AacB9ofGJhfw+kCV6lEuTUoQiGUUfdqUBb7IsGaoSYLi9pvQShR9RF8FALpYOnjATt+7THaZ8gd5KktdkTXUh0O0jx0QO+iK1igUbgJPTTnWahu1tHfgjUnKg6dBPAjXRuCuBXXw+wvmnFhQnmOHqowf4Dlbxojnf/YoQXJN255ROJcGMwt7kSLL1MQ7YFdOB7lyDg6G6sbu58g674sZoJnQ3dzFNmIDHpnVvj4A5yCstvOyX7iZmNAIXZW0rl9akMTy7XhJBIB6p2zCDMZOvZld9uYzPmb1xxCZf5rtmmlFJYiHo9r8Jd0i1Vx7YQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nQoFRJdAOC4cXu/Jd8ySq7TpTh9fzXoy5BzdD2OKtKE=;
 b=JzvqdOJNPRBQOIkFzUqx1x5S9OpgeOs3PzuQ4czLYYbLweU54YNr+rv/2ZzklejqzNhH7OFQ3ZZqTPtQLm6g2W97tq9Cn3Tseu2lEUNaQt/Wunoyta8tF+lDP/B+ChJITghIMJ4VlLvw/xTbe8JutqxSLOEyK5qSdzXM96WS0PQZAwi+mibLX7wzk0s6xPA21gXAgcZWSYNYURHGN6n2REtaHrZwMcb9k393QDnzZ2ANW4YwOp3NH5Lu9apUdE1aSm+kOKNuWLoFdbMDL9HI2UKeSkHCnEG3h2sLSa0eKWjNnhChecabFCGrHtjm+wJCCoBFr7FgJ1fbeD/2v6fG7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nQoFRJdAOC4cXu/Jd8ySq7TpTh9fzXoy5BzdD2OKtKE=;
 b=KOhAcI0Mkunx0QTS5pIfEV6i9tkNxwMcnra2b4L3JppPiqJSR1vThnqeifSaEKb+0GVbRRgrSSystqqZBhb1MoNgNBtfDHvCO7FvwCCgjRckTTafbSa/1pB9WaXVfWwgckl4UbKleR6mPNmqOfMonbwYF5KRf7Ky2jnJTbyzfzc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CY4PR13MB1512.namprd13.prod.outlook.com (2603:10b6:903:12f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.15; Mon, 21 Mar
 2022 10:42:38 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::7077:d057:db6b:3113]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::7077:d057:db6b:3113%4]) with mapi id 15.20.5102.015; Mon, 21 Mar 2022
 10:42:38 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Yinjun Zhang <yinjun.zhang@corigine.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com
Subject: [PATCH net-next v2 09/10] nfp: add support for NFDK data path
Date:   Mon, 21 Mar 2022 11:42:08 +0100
Message-Id: <20220321104209.273535-10-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220321104209.273535-1-simon.horman@corigine.com>
References: <20220321104209.273535-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR02CA0001.eurprd02.prod.outlook.com
 (2603:10a6:208:3e::14) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4556c3f8-306d-4d14-f238-08da0b2784ae
X-MS-TrafficTypeDiagnostic: CY4PR13MB1512:EE_
X-Microsoft-Antispam-PRVS: <CY4PR13MB1512114D200E75E892B47913E8169@CY4PR13MB1512.namprd13.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sOn3XPUrcsqn7GEuouLo0lU+Ccr4kKoPqqqYcGKmWxaBQ2PkMMyhfq+iIxAgqu3LTyjYJ042vj0tS3TQAS0C5hQ1CyubwSrA27RFdw6rboMoS2+dWja+XbpBgFToa/a+yXSIwI7ceHrY45lrxYTYfvlx7kvxK9CnaVhmdH1VNSs+WHBIVcQ0GLl0C7NUAQJDGklJcwh44d3sdcYZL0CJS5lgTOzqn0VYnE5ElyP/LPYxsjsQprzGxyfbZRJec0pkyyUdDNORfkEPWUHDl7l1kl6ao5bg3Ibm6eGuHe0xKP/PwQSGwgXWaWV1YoLFwKtQE+OhlH5zdpa0TalDRHeSgo67B2DZ9LeCQ+CNJgZ4nZPzOMYnCJyBKFXupDyGGUcwaBcwGGycOeX0+Y7tZc56q8wYdtfQ3HCCAwTrt0vngvo/82CuIKiZoUNdldOHXZ68dKezHf84A4T6tonq3rHRjSg14uyruMns35zFR/yg2+VbIQ9MuHQGh+1zHcPYHe3zny5gf0R/28MHZwiKzGMNtFO870yTXN6Gz7Fz5rY40iR3OVYYd+4it3gFvzhxZ36H5S0XnhwoL/3aoOq+1/VGzea6y99qiqkBsetxGTt7KB99PLvexQzgOyb/XAzL1OUUWPrHfsklzxEfwLRrGpUkwVu3uGgnQd+0qSUErZyKyWmg0sRTNzJUYYQy3iS4U3Tk0tcd61gGAsTP7hK6+qobbQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(39830400003)(136003)(396003)(376002)(366004)(346002)(8936002)(186003)(1076003)(30864003)(6512007)(110136005)(6506007)(2906002)(8676002)(5660300002)(86362001)(66574015)(52116002)(107886003)(6666004)(6486002)(44832011)(66946007)(4326008)(38100700002)(66556008)(2616005)(66476007)(316002)(83380400001)(508600001)(36756003)(579004)(559001)(309714004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EKImKkzreYSJTLiQzkc+q4McB9OIvtCjrxJWAAbYrkTozupPisq+TKZLK3rN?=
 =?us-ascii?Q?AKVupJq9M5nGZH+P88d8HOKAujSYcSx8ndpy2c6M55zXWwHL9afJaVemTgnX?=
 =?us-ascii?Q?wPSBJ0WzneOIh3h1sOuEqHleApKgU4sd4Fv49orAJAdzpeq0evd+tR4gm0qy?=
 =?us-ascii?Q?NKh5uM0TxwqWaaZPvX39QmB6kR1jVEs+lMcmuuZByS9L+xjf9i8ynN8L9aOy?=
 =?us-ascii?Q?120jHqcjHUcLH/DiBkA40VvS7Rpbxwc+zwDKuek++krhfnBwNfvaihgOfxXg?=
 =?us-ascii?Q?pBZPm+C4nIhcLsY4u+bVgZ2CvWnzsndFvzUsjgSbcNtVYzkFEQDptHlFtIqa?=
 =?us-ascii?Q?8CgZGcX9yVz5RAL+1syLqc7NBWSLjXZCF7BTV2l4vDjo5gBl7mIkQdQSM4N1?=
 =?us-ascii?Q?Y1xuEwFWYJX5La2G3231/U5fiCWe1MjyyXSf26r3p0XR1nMOinq3YK66F9iu?=
 =?us-ascii?Q?P6CEnMcuvUEDptRHSZUw4QgGRReS4fHny2zS9erjZ37UtNRXivS0WuXbM51Z?=
 =?us-ascii?Q?xqLK2JLyuweMlvr9sWHiNpSmOp5CcXAKhy3ucO+gP+dnAGhW5GK1w2HKrK97?=
 =?us-ascii?Q?Mq3T8maWi9AxWJn28T6HfYigX/MEC5UQpVLkRPLMqrQ1pB/EmG9H4CcFIaok?=
 =?us-ascii?Q?raeINU5SfD5+n3OLaT+nWiJJh7v0t4c+xXl+w7Nl4JwQQhtjBvtqi4nYJAQT?=
 =?us-ascii?Q?aIfgh1RKTo3MZOjb7dxljW5JVosS5zqwoPRDbRy8NBnaieALCPweTtCO088j?=
 =?us-ascii?Q?nOma+XopuQWR5XFytJHbEmnz7P22soMHi9UOx9qiTJZt6DMAK+Q6wDAG3q84?=
 =?us-ascii?Q?G7XE6/QzInfCoggmUmglyFbKoVI+i8jPV+bFNK3rYofaCPh2ZRhgwmw7c00H?=
 =?us-ascii?Q?OB12MoNHaZouxaQFaTdgeHtgK/F70rlKjbsTCJc+5Ga++02rbN2Y5894xt2i?=
 =?us-ascii?Q?LraKTewR4c5MnWXTG75K9HxJasXSsUXGa5J/wpoGMDMHkW1Ulb2WSXE7dWmp?=
 =?us-ascii?Q?4U1DBz5xRZ9+SJW4gLMO+iG7+LhNiWgEkW4UNcJTbYmqCE4nkqbsJzVt7zsj?=
 =?us-ascii?Q?hNUpo3DvQRrTQMqbzxdBwuinB9Hly/Nfwp/fyOdCHPuReNKcMWFDwQxFnpeB?=
 =?us-ascii?Q?MeeYK21YfU8G9LgVtHgk4MiwlaKlaDFe1Ffc/wnXP+fZzBrDLy7nya/1IYx1?=
 =?us-ascii?Q?htT2w2xmGbZPLehQVqx8PzeuEJTFpxsMihwsABPbCaEp7jKtUQt2UZRHsYmt?=
 =?us-ascii?Q?Lgjy9PZWO2gF+3pOivAMkdPbwlTH/vOSZoNBqpm4nPj67ckk/FvMAKSpzRVE?=
 =?us-ascii?Q?899FiTMiaXwNp9V2eRMKkPXCKPGiQzQhEXXjntbZ1EQgBjsi16KK/fSpWGXj?=
 =?us-ascii?Q?lWi2mJVgIgpsSWV+lSTZ18ucwwgjDF2GCredcZnBR1UsHgzdPLHhW03yIEMF?=
 =?us-ascii?Q?tR+mvYP4sAhjfE75sm6EDWYaFsOWlLC0vmzqxqGuhjQLMP0SsjOK6S8Pkdxh?=
 =?us-ascii?Q?b1DSt+zHiNraHK5yj09L0XvAI7P+X6gVRU5uhlLQKcn0/slCZlWil1G2IA?=
 =?us-ascii?Q?=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4556c3f8-306d-4d14-f238-08da0b2784ae
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2022 10:42:38.6533
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: u8iTlpuGet1hb2TOlx53UpQ6SS1ZmdX+sg2sSSHvdMk4IKq/DO9vycOIH9mPO7t8Xo8BagYcgqQ015ZYtUxm7O99rlQLBbyi/8vQUlx12eg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR13MB1512
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>

Add new data path.  The TX is completely different, each packet
has multiple descriptor entries (between 2 and 32).  TX ring is
divided into blocks 32 descriptor, and descritors of one packet
can't cross block bounds. The RX side is the same for now.

ABI version 5 or later is required.  There is no support for
VLAN insertion on TX. XDP_TX action and AF_XDP zero-copy is not
implemented in NFDK path.

Changes to Jakub's work:
* Move statistics of hw_csum_tx after jumbo packet's segmentation.
* Set L3_CSUM flag to enable recaculating of L3 header checksum
in ipv4 case.
* Mark the case of TSO a packet with metadata prepended as
unsupported.

Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Xingfeng Hu <xingfeng.hu@corigine.com>
Signed-off-by: Yinjun Zhang <yinjun.zhang@corigine.com>
Signed-off-by: Dianchao Wang <dianchao.wang@corigine.com>
Signed-off-by: Fei Qin <fei.qin@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 drivers/net/ethernet/netronome/nfp/Makefile   |    2 +
 drivers/net/ethernet/netronome/nfp/nfdk/dp.c  | 1338 +++++++++++++++++
 .../net/ethernet/netronome/nfp/nfdk/nfdk.h    |  112 ++
 .../net/ethernet/netronome/nfp/nfdk/rings.c   |  195 +++
 drivers/net/ethernet/netronome/nfp/nfp_net.h  |   27 +-
 .../ethernet/netronome/nfp/nfp_net_common.c   |   40 +
 .../net/ethernet/netronome/nfp/nfp_net_ctrl.h |    1 +
 .../net/ethernet/netronome/nfp/nfp_net_dp.h   |    2 +
 .../net/ethernet/netronome/nfp/nfp_net_xsk.c  |    4 +
 9 files changed, 1715 insertions(+), 6 deletions(-)
 create mode 100644 drivers/net/ethernet/netronome/nfp/nfdk/dp.c
 create mode 100644 drivers/net/ethernet/netronome/nfp/nfdk/nfdk.h
 create mode 100644 drivers/net/ethernet/netronome/nfp/nfdk/rings.c

diff --git a/drivers/net/ethernet/netronome/nfp/Makefile b/drivers/net/ethernet/netronome/nfp/Makefile
index 69168c03606f..9c0861d03634 100644
--- a/drivers/net/ethernet/netronome/nfp/Makefile
+++ b/drivers/net/ethernet/netronome/nfp/Makefile
@@ -23,6 +23,8 @@ nfp-objs := \
 	    nfd3/dp.o \
 	    nfd3/rings.o \
 	    nfd3/xsk.o \
+	    nfdk/dp.o \
+	    nfdk/rings.o \
 	    nfp_app.o \
 	    nfp_app_nic.o \
 	    nfp_devlink.o \
diff --git a/drivers/net/ethernet/netronome/nfp/nfdk/dp.c b/drivers/net/ethernet/netronome/nfp/nfdk/dp.c
new file mode 100644
index 000000000000..f03de6b7988b
--- /dev/null
+++ b/drivers/net/ethernet/netronome/nfp/nfdk/dp.c
@@ -0,0 +1,1338 @@
+// SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+/* Copyright (C) 2015-2019 Netronome Systems, Inc. */
+
+#include <linux/bpf_trace.h>
+#include <linux/netdevice.h>
+#include <linux/overflow.h>
+#include <linux/sizes.h>
+#include <linux/bitfield.h>
+
+#include "../nfp_app.h"
+#include "../nfp_net.h"
+#include "../nfp_net_dp.h"
+#include "../crypto/crypto.h"
+#include "../crypto/fw.h"
+#include "nfdk.h"
+
+static int nfp_nfdk_tx_ring_should_wake(struct nfp_net_tx_ring *tx_ring)
+{
+	return !nfp_net_tx_full(tx_ring, NFDK_TX_DESC_STOP_CNT * 2);
+}
+
+static int nfp_nfdk_tx_ring_should_stop(struct nfp_net_tx_ring *tx_ring)
+{
+	return nfp_net_tx_full(tx_ring, NFDK_TX_DESC_STOP_CNT);
+}
+
+static void nfp_nfdk_tx_ring_stop(struct netdev_queue *nd_q,
+				  struct nfp_net_tx_ring *tx_ring)
+{
+	netif_tx_stop_queue(nd_q);
+
+	/* We can race with the TX completion out of NAPI so recheck */
+	smp_mb();
+	if (unlikely(nfp_nfdk_tx_ring_should_wake(tx_ring)))
+		netif_tx_start_queue(nd_q);
+}
+
+static __le64
+nfp_nfdk_tx_tso(struct nfp_net_r_vector *r_vec, struct nfp_nfdk_tx_buf *txbuf,
+		struct sk_buff *skb)
+{
+	u32 segs, hdrlen, l3_offset, l4_offset;
+	struct nfp_nfdk_tx_desc txd;
+	u16 mss;
+
+	if (!skb->encapsulation) {
+		l3_offset = skb_network_offset(skb);
+		l4_offset = skb_transport_offset(skb);
+		hdrlen = skb_transport_offset(skb) + tcp_hdrlen(skb);
+	} else {
+		l3_offset = skb_inner_network_offset(skb);
+		l4_offset = skb_inner_transport_offset(skb);
+		hdrlen = skb_inner_transport_header(skb) - skb->data +
+			inner_tcp_hdrlen(skb);
+	}
+
+	segs = skb_shinfo(skb)->gso_segs;
+	mss = skb_shinfo(skb)->gso_size & NFDK_DESC_TX_MSS_MASK;
+
+	/* Note: TSO of the packet with metadata prepended to skb is not
+	 * supported yet, in which case l3/l4_offset and lso_hdrlen need
+	 * be correctly handled here.
+	 * Concern:
+	 * The driver doesn't have md_bytes easily available at this point.
+	 * The PCI.IN PD ME won't have md_bytes bytes to add to lso_hdrlen,
+	 * so it needs the full length there.  The app MEs might prefer
+	 * l3_offset and l4_offset relative to the start of packet data,
+	 * but could probably cope with it being relative to the CTM buf
+	 * data offset.
+	 */
+	txd.l3_offset = l3_offset;
+	txd.l4_offset = l4_offset;
+	txd.lso_meta_res = 0;
+	txd.mss = cpu_to_le16(mss);
+	txd.lso_hdrlen = hdrlen;
+	txd.lso_totsegs = segs;
+
+	txbuf->pkt_cnt = segs;
+	txbuf->real_len = skb->len + hdrlen * (txbuf->pkt_cnt - 1);
+
+	u64_stats_update_begin(&r_vec->tx_sync);
+	r_vec->tx_lso++;
+	u64_stats_update_end(&r_vec->tx_sync);
+
+	return txd.raw;
+}
+
+static u8
+nfp_nfdk_tx_csum(struct nfp_net_dp *dp, struct nfp_net_r_vector *r_vec,
+		 unsigned int pkt_cnt, struct sk_buff *skb, u64 flags)
+{
+	struct ipv6hdr *ipv6h;
+	struct iphdr *iph;
+
+	if (!(dp->ctrl & NFP_NET_CFG_CTRL_TXCSUM))
+		return flags;
+
+	if (skb->ip_summed != CHECKSUM_PARTIAL)
+		return flags;
+
+	flags |= NFDK_DESC_TX_L4_CSUM;
+
+	iph = skb->encapsulation ? inner_ip_hdr(skb) : ip_hdr(skb);
+	ipv6h = skb->encapsulation ? inner_ipv6_hdr(skb) : ipv6_hdr(skb);
+
+	/* L3 checksum offloading flag is not required for ipv6 */
+	if (iph->version == 4) {
+		flags |= NFDK_DESC_TX_L3_CSUM;
+	} else if (ipv6h->version != 6) {
+		nn_dp_warn(dp, "partial checksum but ipv=%x!\n", iph->version);
+		return flags;
+	}
+
+	u64_stats_update_begin(&r_vec->tx_sync);
+	if (!skb->encapsulation) {
+		r_vec->hw_csum_tx += pkt_cnt;
+	} else {
+		flags |= NFDK_DESC_TX_ENCAP;
+		r_vec->hw_csum_tx_inner += pkt_cnt;
+	}
+	u64_stats_update_end(&r_vec->tx_sync);
+
+	return flags;
+}
+
+static int
+nfp_nfdk_tx_maybe_close_block(struct nfp_net_tx_ring *tx_ring,
+			      unsigned int nr_frags, struct sk_buff *skb)
+{
+	unsigned int n_descs, wr_p, nop_slots;
+	const skb_frag_t *frag, *fend;
+	struct nfp_nfdk_tx_desc *txd;
+	unsigned int wr_idx;
+	int err;
+
+recount_descs:
+	n_descs = nfp_nfdk_headlen_to_segs(skb_headlen(skb));
+
+	frag = skb_shinfo(skb)->frags;
+	fend = frag + nr_frags;
+	for (; frag < fend; frag++)
+		n_descs += DIV_ROUND_UP(skb_frag_size(frag),
+					NFDK_TX_MAX_DATA_PER_DESC);
+
+	if (unlikely(n_descs > NFDK_TX_DESC_GATHER_MAX)) {
+		if (skb_is_nonlinear(skb)) {
+			err = skb_linearize(skb);
+			if (err)
+				return err;
+			goto recount_descs;
+		}
+		return -EINVAL;
+	}
+
+	/* Under count by 1 (don't count meta) for the round down to work out */
+	n_descs += !!skb_is_gso(skb);
+
+	if (round_down(tx_ring->wr_p, NFDK_TX_DESC_BLOCK_CNT) !=
+	    round_down(tx_ring->wr_p + n_descs, NFDK_TX_DESC_BLOCK_CNT))
+		goto close_block;
+
+	if ((u32)tx_ring->data_pending + skb->len > NFDK_TX_MAX_DATA_PER_BLOCK)
+		goto close_block;
+
+	return 0;
+
+close_block:
+	wr_p = tx_ring->wr_p;
+	nop_slots = D_BLOCK_CPL(wr_p);
+
+	wr_idx = D_IDX(tx_ring, wr_p);
+	tx_ring->ktxbufs[wr_idx].skb = NULL;
+	txd = &tx_ring->ktxds[wr_idx];
+
+	memset(txd, 0, array_size(nop_slots, sizeof(struct nfp_nfdk_tx_desc)));
+
+	tx_ring->data_pending = 0;
+	tx_ring->wr_p += nop_slots;
+	tx_ring->wr_ptr_add += nop_slots;
+
+	return 0;
+}
+
+static int nfp_nfdk_prep_port_id(struct sk_buff *skb)
+{
+	struct metadata_dst *md_dst = skb_metadata_dst(skb);
+	unsigned char *data;
+
+	if (likely(!md_dst))
+		return 0;
+	if (unlikely(md_dst->type != METADATA_HW_PORT_MUX))
+		return 0;
+
+	/* Note: Unsupported case when TSO a skb with metedata prepended.
+	 * See the comments in `nfp_nfdk_tx_tso` for details.
+	 */
+	if (unlikely(md_dst && skb_is_gso(skb)))
+		return -EOPNOTSUPP;
+
+	if (unlikely(skb_cow_head(skb, sizeof(md_dst->u.port_info.port_id))))
+		return -ENOMEM;
+
+	data = skb_push(skb, sizeof(md_dst->u.port_info.port_id));
+	put_unaligned_be32(md_dst->u.port_info.port_id, data);
+
+	return sizeof(md_dst->u.port_info.port_id);
+}
+
+static int
+nfp_nfdk_prep_tx_meta(struct nfp_app *app, struct sk_buff *skb,
+		      struct nfp_net_r_vector *r_vec)
+{
+	unsigned char *data;
+	int res, md_bytes;
+	u32 meta_id = 0;
+
+	res = nfp_nfdk_prep_port_id(skb);
+	if (unlikely(res <= 0))
+		return res;
+
+	md_bytes = res;
+	meta_id = NFP_NET_META_PORTID;
+
+	if (unlikely(skb_cow_head(skb, sizeof(meta_id))))
+		return -ENOMEM;
+
+	md_bytes += sizeof(meta_id);
+
+	meta_id = FIELD_PREP(NFDK_META_LEN, md_bytes) |
+		  FIELD_PREP(NFDK_META_FIELDS, meta_id);
+
+	data = skb_push(skb, sizeof(meta_id));
+	put_unaligned_be32(meta_id, data);
+
+	return NFDK_DESC_TX_CHAIN_META;
+}
+
+/**
+ * nfp_nfdk_tx() - Main transmit entry point
+ * @skb:    SKB to transmit
+ * @netdev: netdev structure
+ *
+ * Return: NETDEV_TX_OK on success.
+ */
+netdev_tx_t nfp_nfdk_tx(struct sk_buff *skb, struct net_device *netdev)
+{
+	struct nfp_net *nn = netdev_priv(netdev);
+	struct nfp_nfdk_tx_buf *txbuf, *etxbuf;
+	u32 cnt, tmp_dlen, dlen_type = 0;
+	struct nfp_net_tx_ring *tx_ring;
+	struct nfp_net_r_vector *r_vec;
+	const skb_frag_t *frag, *fend;
+	struct nfp_nfdk_tx_desc *txd;
+	unsigned int real_len, qidx;
+	unsigned int dma_len, type;
+	struct netdev_queue *nd_q;
+	struct nfp_net_dp *dp;
+	int nr_frags, wr_idx;
+	dma_addr_t dma_addr;
+	u64 metadata;
+
+	dp = &nn->dp;
+	qidx = skb_get_queue_mapping(skb);
+	tx_ring = &dp->tx_rings[qidx];
+	r_vec = tx_ring->r_vec;
+	nd_q = netdev_get_tx_queue(dp->netdev, qidx);
+
+	/* Don't bother counting frags, assume the worst */
+	if (unlikely(nfp_net_tx_full(tx_ring, NFDK_TX_DESC_STOP_CNT))) {
+		nn_dp_warn(dp, "TX ring %d busy. wrp=%u rdp=%u\n",
+			   qidx, tx_ring->wr_p, tx_ring->rd_p);
+		netif_tx_stop_queue(nd_q);
+		nfp_net_tx_xmit_more_flush(tx_ring);
+		u64_stats_update_begin(&r_vec->tx_sync);
+		r_vec->tx_busy++;
+		u64_stats_update_end(&r_vec->tx_sync);
+		return NETDEV_TX_BUSY;
+	}
+
+	metadata = nfp_nfdk_prep_tx_meta(nn->app, skb, r_vec);
+	if (unlikely((int)metadata < 0))
+		goto err_flush;
+
+	nr_frags = skb_shinfo(skb)->nr_frags;
+	if (nfp_nfdk_tx_maybe_close_block(tx_ring, nr_frags, skb))
+		goto err_flush;
+
+	/* DMA map all */
+	wr_idx = D_IDX(tx_ring, tx_ring->wr_p);
+	txd = &tx_ring->ktxds[wr_idx];
+	txbuf = &tx_ring->ktxbufs[wr_idx];
+
+	dma_len = skb_headlen(skb);
+	if (skb_is_gso(skb))
+		type = NFDK_DESC_TX_TYPE_TSO;
+	else if (!nr_frags && dma_len < NFDK_TX_MAX_DATA_PER_HEAD)
+		type = NFDK_DESC_TX_TYPE_SIMPLE;
+	else
+		type = NFDK_DESC_TX_TYPE_GATHER;
+
+	dma_addr = dma_map_single(dp->dev, skb->data, dma_len, DMA_TO_DEVICE);
+	if (dma_mapping_error(dp->dev, dma_addr))
+		goto err_warn_dma;
+
+	txbuf->skb = skb;
+	txbuf++;
+
+	txbuf->dma_addr = dma_addr;
+	txbuf++;
+
+	/* FIELD_PREP() implicitly truncates to chunk */
+	dma_len -= 1;
+	dlen_type = FIELD_PREP(NFDK_DESC_TX_DMA_LEN_HEAD, dma_len) |
+		    FIELD_PREP(NFDK_DESC_TX_TYPE_HEAD, type);
+
+	txd->dma_len_type = cpu_to_le16(dlen_type);
+	nfp_desc_set_dma_addr(txd, dma_addr);
+
+	/* starts at bit 0 */
+	BUILD_BUG_ON(!(NFDK_DESC_TX_DMA_LEN_HEAD & 1));
+
+	/* Preserve the original dlen_type, this way below the EOP logic
+	 * can use dlen_type.
+	 */
+	tmp_dlen = dlen_type & NFDK_DESC_TX_DMA_LEN_HEAD;
+	dma_len -= tmp_dlen;
+	dma_addr += tmp_dlen + 1;
+	txd++;
+
+	/* The rest of the data (if any) will be in larger dma descritors
+	 * and is handled with the fragment loop.
+	 */
+	frag = skb_shinfo(skb)->frags;
+	fend = frag + nr_frags;
+
+	while (true) {
+		while (dma_len > 0) {
+			dma_len -= 1;
+			dlen_type = FIELD_PREP(NFDK_DESC_TX_DMA_LEN, dma_len);
+
+			txd->dma_len_type = cpu_to_le16(dlen_type);
+			nfp_desc_set_dma_addr(txd, dma_addr);
+
+			dma_len -= dlen_type;
+			dma_addr += dlen_type + 1;
+			txd++;
+		}
+
+		if (frag >= fend)
+			break;
+
+		dma_len = skb_frag_size(frag);
+		dma_addr = skb_frag_dma_map(dp->dev, frag, 0, dma_len,
+					    DMA_TO_DEVICE);
+		if (dma_mapping_error(dp->dev, dma_addr))
+			goto err_unmap;
+
+		txbuf->dma_addr = dma_addr;
+		txbuf++;
+
+		frag++;
+	}
+
+	(txd - 1)->dma_len_type = cpu_to_le16(dlen_type | NFDK_DESC_TX_EOP);
+
+	if (!skb_is_gso(skb)) {
+		real_len = skb->len;
+		/* Metadata desc */
+		metadata = nfp_nfdk_tx_csum(dp, r_vec, 1, skb, metadata);
+		txd->raw = cpu_to_le64(metadata);
+		txd++;
+	} else {
+		/* lso desc should be placed after metadata desc */
+		(txd + 1)->raw = nfp_nfdk_tx_tso(r_vec, txbuf, skb);
+		real_len = txbuf->real_len;
+		/* Metadata desc */
+		metadata = nfp_nfdk_tx_csum(dp, r_vec, txbuf->pkt_cnt, skb, metadata);
+		txd->raw = cpu_to_le64(metadata);
+		txd += 2;
+		txbuf++;
+	}
+
+	cnt = txd - tx_ring->ktxds - wr_idx;
+	if (unlikely(round_down(wr_idx, NFDK_TX_DESC_BLOCK_CNT) !=
+		     round_down(wr_idx + cnt - 1, NFDK_TX_DESC_BLOCK_CNT)))
+		goto err_warn_overflow;
+
+	skb_tx_timestamp(skb);
+
+	tx_ring->wr_p += cnt;
+	if (tx_ring->wr_p % NFDK_TX_DESC_BLOCK_CNT)
+		tx_ring->data_pending += skb->len;
+	else
+		tx_ring->data_pending = 0;
+
+	if (nfp_nfdk_tx_ring_should_stop(tx_ring))
+		nfp_nfdk_tx_ring_stop(nd_q, tx_ring);
+
+	tx_ring->wr_ptr_add += cnt;
+	if (__netdev_tx_sent_queue(nd_q, real_len, netdev_xmit_more()))
+		nfp_net_tx_xmit_more_flush(tx_ring);
+
+	return NETDEV_TX_OK;
+
+err_warn_overflow:
+	WARN_ONCE(1, "unable to fit packet into a descriptor wr_idx:%d head:%d frags:%d cnt:%d",
+		  wr_idx, skb_headlen(skb), nr_frags, cnt);
+	if (skb_is_gso(skb))
+		txbuf--;
+err_unmap:
+	/* txbuf pointed to the next-to-use */
+	etxbuf = txbuf;
+	/* first txbuf holds the skb */
+	txbuf = &tx_ring->ktxbufs[wr_idx + 1];
+	if (txbuf < etxbuf) {
+		dma_unmap_single(dp->dev, txbuf->dma_addr,
+				 skb_headlen(skb), DMA_TO_DEVICE);
+		txbuf->raw = 0;
+		txbuf++;
+	}
+	frag = skb_shinfo(skb)->frags;
+	while (etxbuf < txbuf) {
+		dma_unmap_page(dp->dev, txbuf->dma_addr,
+			       skb_frag_size(frag), DMA_TO_DEVICE);
+		txbuf->raw = 0;
+		frag++;
+		txbuf++;
+	}
+err_warn_dma:
+	nn_dp_warn(dp, "Failed to map DMA TX buffer\n");
+err_flush:
+	nfp_net_tx_xmit_more_flush(tx_ring);
+	u64_stats_update_begin(&r_vec->tx_sync);
+	r_vec->tx_errors++;
+	u64_stats_update_end(&r_vec->tx_sync);
+	dev_kfree_skb_any(skb);
+	return NETDEV_TX_OK;
+}
+
+/**
+ * nfp_nfdk_tx_complete() - Handled completed TX packets
+ * @tx_ring:	TX ring structure
+ * @budget:	NAPI budget (only used as bool to determine if in NAPI context)
+ */
+static void nfp_nfdk_tx_complete(struct nfp_net_tx_ring *tx_ring, int budget)
+{
+	struct nfp_net_r_vector *r_vec = tx_ring->r_vec;
+	struct nfp_net_dp *dp = &r_vec->nfp_net->dp;
+	u32 done_pkts = 0, done_bytes = 0;
+	struct nfp_nfdk_tx_buf *ktxbufs;
+	struct device *dev = dp->dev;
+	struct netdev_queue *nd_q;
+	u32 rd_p, qcp_rd_p;
+	int todo;
+
+	rd_p = tx_ring->rd_p;
+	if (tx_ring->wr_p == rd_p)
+		return;
+
+	/* Work out how many descriptors have been transmitted */
+	qcp_rd_p = nfp_net_read_tx_cmpl(tx_ring, dp);
+
+	if (qcp_rd_p == tx_ring->qcp_rd_p)
+		return;
+
+	todo = D_IDX(tx_ring, qcp_rd_p - tx_ring->qcp_rd_p);
+	ktxbufs = tx_ring->ktxbufs;
+
+	while (todo > 0) {
+		const skb_frag_t *frag, *fend;
+		unsigned int size, n_descs = 1;
+		struct nfp_nfdk_tx_buf *txbuf;
+		struct sk_buff *skb;
+
+		txbuf = &ktxbufs[D_IDX(tx_ring, rd_p)];
+		skb = txbuf->skb;
+		txbuf++;
+
+		/* Closed block */
+		if (!skb) {
+			n_descs = D_BLOCK_CPL(rd_p);
+			goto next;
+		}
+
+		/* Unmap head */
+		size = skb_headlen(skb);
+		n_descs += nfp_nfdk_headlen_to_segs(size);
+		dma_unmap_single(dev, txbuf->dma_addr, size, DMA_TO_DEVICE);
+		txbuf++;
+
+		/* Unmap frags */
+		frag = skb_shinfo(skb)->frags;
+		fend = frag + skb_shinfo(skb)->nr_frags;
+		for (; frag < fend; frag++) {
+			size = skb_frag_size(frag);
+			n_descs += DIV_ROUND_UP(size,
+						NFDK_TX_MAX_DATA_PER_DESC);
+			dma_unmap_page(dev, txbuf->dma_addr,
+				       skb_frag_size(frag), DMA_TO_DEVICE);
+			txbuf++;
+		}
+
+		if (!skb_is_gso(skb)) {
+			done_bytes += skb->len;
+			done_pkts++;
+		} else {
+			done_bytes += txbuf->real_len;
+			done_pkts += txbuf->pkt_cnt;
+			n_descs++;
+		}
+
+		napi_consume_skb(skb, budget);
+next:
+		rd_p += n_descs;
+		todo -= n_descs;
+	}
+
+	tx_ring->rd_p = rd_p;
+	tx_ring->qcp_rd_p = qcp_rd_p;
+
+	u64_stats_update_begin(&r_vec->tx_sync);
+	r_vec->tx_bytes += done_bytes;
+	r_vec->tx_pkts += done_pkts;
+	u64_stats_update_end(&r_vec->tx_sync);
+
+	if (!dp->netdev)
+		return;
+
+	nd_q = netdev_get_tx_queue(dp->netdev, tx_ring->idx);
+	netdev_tx_completed_queue(nd_q, done_pkts, done_bytes);
+	if (nfp_nfdk_tx_ring_should_wake(tx_ring)) {
+		/* Make sure TX thread will see updated tx_ring->rd_p */
+		smp_mb();
+
+		if (unlikely(netif_tx_queue_stopped(nd_q)))
+			netif_tx_wake_queue(nd_q);
+	}
+
+	WARN_ONCE(tx_ring->wr_p - tx_ring->rd_p > tx_ring->cnt,
+		  "TX ring corruption rd_p=%u wr_p=%u cnt=%u\n",
+		  tx_ring->rd_p, tx_ring->wr_p, tx_ring->cnt);
+}
+
+static bool nfp_nfdk_xdp_complete(struct nfp_net_tx_ring *tx_ring)
+{
+	return true;
+}
+
+/* Receive processing */
+static void *
+nfp_nfdk_napi_alloc_one(struct nfp_net_dp *dp, dma_addr_t *dma_addr)
+{
+	void *frag;
+
+	if (!dp->xdp_prog) {
+		frag = napi_alloc_frag(dp->fl_bufsz);
+		if (unlikely(!frag))
+			return NULL;
+	} else {
+		struct page *page;
+
+		page = dev_alloc_page();
+		if (unlikely(!page))
+			return NULL;
+		frag = page_address(page);
+	}
+
+	*dma_addr = nfp_net_dma_map_rx(dp, frag);
+	if (dma_mapping_error(dp->dev, *dma_addr)) {
+		nfp_net_free_frag(frag, dp->xdp_prog);
+		nn_dp_warn(dp, "Failed to map DMA RX buffer\n");
+		return NULL;
+	}
+
+	return frag;
+}
+
+/**
+ * nfp_nfdk_rx_give_one() - Put mapped skb on the software and hardware rings
+ * @dp:		NFP Net data path struct
+ * @rx_ring:	RX ring structure
+ * @frag:	page fragment buffer
+ * @dma_addr:	DMA address of skb mapping
+ */
+static void
+nfp_nfdk_rx_give_one(const struct nfp_net_dp *dp,
+		     struct nfp_net_rx_ring *rx_ring,
+		     void *frag, dma_addr_t dma_addr)
+{
+	unsigned int wr_idx;
+
+	wr_idx = D_IDX(rx_ring, rx_ring->wr_p);
+
+	nfp_net_dma_sync_dev_rx(dp, dma_addr);
+
+	/* Stash SKB and DMA address away */
+	rx_ring->rxbufs[wr_idx].frag = frag;
+	rx_ring->rxbufs[wr_idx].dma_addr = dma_addr;
+
+	/* Fill freelist descriptor */
+	rx_ring->rxds[wr_idx].fld.reserved = 0;
+	rx_ring->rxds[wr_idx].fld.meta_len_dd = 0;
+	nfp_desc_set_dma_addr(&rx_ring->rxds[wr_idx].fld,
+			      dma_addr + dp->rx_dma_off);
+
+	rx_ring->wr_p++;
+	if (!(rx_ring->wr_p % NFP_NET_FL_BATCH)) {
+		/* Update write pointer of the freelist queue. Make
+		 * sure all writes are flushed before telling the hardware.
+		 */
+		wmb();
+		nfp_qcp_wr_ptr_add(rx_ring->qcp_fl, NFP_NET_FL_BATCH);
+	}
+}
+
+/**
+ * nfp_nfdk_rx_ring_fill_freelist() - Give buffers from the ring to FW
+ * @dp:	     NFP Net data path struct
+ * @rx_ring: RX ring to fill
+ */
+void nfp_nfdk_rx_ring_fill_freelist(struct nfp_net_dp *dp,
+				    struct nfp_net_rx_ring *rx_ring)
+{
+	unsigned int i;
+
+	for (i = 0; i < rx_ring->cnt - 1; i++)
+		nfp_nfdk_rx_give_one(dp, rx_ring, rx_ring->rxbufs[i].frag,
+				     rx_ring->rxbufs[i].dma_addr);
+}
+
+/**
+ * nfp_nfdk_rx_csum_has_errors() - group check if rxd has any csum errors
+ * @flags: RX descriptor flags field in CPU byte order
+ */
+static int nfp_nfdk_rx_csum_has_errors(u16 flags)
+{
+	u16 csum_all_checked, csum_all_ok;
+
+	csum_all_checked = flags & __PCIE_DESC_RX_CSUM_ALL;
+	csum_all_ok = flags & __PCIE_DESC_RX_CSUM_ALL_OK;
+
+	return csum_all_checked != (csum_all_ok << PCIE_DESC_RX_CSUM_OK_SHIFT);
+}
+
+/**
+ * nfp_nfdk_rx_csum() - set SKB checksum field based on RX descriptor flags
+ * @dp:  NFP Net data path struct
+ * @r_vec: per-ring structure
+ * @rxd: Pointer to RX descriptor
+ * @meta: Parsed metadata prepend
+ * @skb: Pointer to SKB
+ */
+static void
+nfp_nfdk_rx_csum(struct nfp_net_dp *dp, struct nfp_net_r_vector *r_vec,
+		 struct nfp_net_rx_desc *rxd, struct nfp_meta_parsed *meta,
+		 struct sk_buff *skb)
+{
+	skb_checksum_none_assert(skb);
+
+	if (!(dp->netdev->features & NETIF_F_RXCSUM))
+		return;
+
+	if (meta->csum_type) {
+		skb->ip_summed = meta->csum_type;
+		skb->csum = meta->csum;
+		u64_stats_update_begin(&r_vec->rx_sync);
+		r_vec->hw_csum_rx_complete++;
+		u64_stats_update_end(&r_vec->rx_sync);
+		return;
+	}
+
+	if (nfp_nfdk_rx_csum_has_errors(le16_to_cpu(rxd->rxd.flags))) {
+		u64_stats_update_begin(&r_vec->rx_sync);
+		r_vec->hw_csum_rx_error++;
+		u64_stats_update_end(&r_vec->rx_sync);
+		return;
+	}
+
+	/* Assume that the firmware will never report inner CSUM_OK unless outer
+	 * L4 headers were successfully parsed. FW will always report zero UDP
+	 * checksum as CSUM_OK.
+	 */
+	if (rxd->rxd.flags & PCIE_DESC_RX_TCP_CSUM_OK ||
+	    rxd->rxd.flags & PCIE_DESC_RX_UDP_CSUM_OK) {
+		__skb_incr_checksum_unnecessary(skb);
+		u64_stats_update_begin(&r_vec->rx_sync);
+		r_vec->hw_csum_rx_ok++;
+		u64_stats_update_end(&r_vec->rx_sync);
+	}
+
+	if (rxd->rxd.flags & PCIE_DESC_RX_I_TCP_CSUM_OK ||
+	    rxd->rxd.flags & PCIE_DESC_RX_I_UDP_CSUM_OK) {
+		__skb_incr_checksum_unnecessary(skb);
+		u64_stats_update_begin(&r_vec->rx_sync);
+		r_vec->hw_csum_rx_inner_ok++;
+		u64_stats_update_end(&r_vec->rx_sync);
+	}
+}
+
+static void
+nfp_nfdk_set_hash(struct net_device *netdev, struct nfp_meta_parsed *meta,
+		  unsigned int type, __be32 *hash)
+{
+	if (!(netdev->features & NETIF_F_RXHASH))
+		return;
+
+	switch (type) {
+	case NFP_NET_RSS_IPV4:
+	case NFP_NET_RSS_IPV6:
+	case NFP_NET_RSS_IPV6_EX:
+		meta->hash_type = PKT_HASH_TYPE_L3;
+		break;
+	default:
+		meta->hash_type = PKT_HASH_TYPE_L4;
+		break;
+	}
+
+	meta->hash = get_unaligned_be32(hash);
+}
+
+static bool
+nfp_nfdk_parse_meta(struct net_device *netdev, struct nfp_meta_parsed *meta,
+		    void *data, void *pkt, unsigned int pkt_len, int meta_len)
+{
+	u32 meta_info;
+
+	meta_info = get_unaligned_be32(data);
+	data += 4;
+
+	while (meta_info) {
+		switch (meta_info & NFP_NET_META_FIELD_MASK) {
+		case NFP_NET_META_HASH:
+			meta_info >>= NFP_NET_META_FIELD_SIZE;
+			nfp_nfdk_set_hash(netdev, meta,
+					  meta_info & NFP_NET_META_FIELD_MASK,
+					  (__be32 *)data);
+			data += 4;
+			break;
+		case NFP_NET_META_MARK:
+			meta->mark = get_unaligned_be32(data);
+			data += 4;
+			break;
+		case NFP_NET_META_PORTID:
+			meta->portid = get_unaligned_be32(data);
+			data += 4;
+			break;
+		case NFP_NET_META_CSUM:
+			meta->csum_type = CHECKSUM_COMPLETE;
+			meta->csum =
+				(__force __wsum)__get_unaligned_cpu32(data);
+			data += 4;
+			break;
+		case NFP_NET_META_RESYNC_INFO:
+			if (nfp_net_tls_rx_resync_req(netdev, data, pkt,
+						      pkt_len))
+				return false;
+			data += sizeof(struct nfp_net_tls_resync_req);
+			break;
+		default:
+			return true;
+		}
+
+		meta_info >>= NFP_NET_META_FIELD_SIZE;
+	}
+
+	return data != pkt;
+}
+
+static void
+nfp_nfdk_rx_drop(const struct nfp_net_dp *dp, struct nfp_net_r_vector *r_vec,
+		 struct nfp_net_rx_ring *rx_ring, struct nfp_net_rx_buf *rxbuf,
+		 struct sk_buff *skb)
+{
+	u64_stats_update_begin(&r_vec->rx_sync);
+	r_vec->rx_drops++;
+	/* If we have both skb and rxbuf the replacement buffer allocation
+	 * must have failed, count this as an alloc failure.
+	 */
+	if (skb && rxbuf)
+		r_vec->rx_replace_buf_alloc_fail++;
+	u64_stats_update_end(&r_vec->rx_sync);
+
+	/* skb is build based on the frag, free_skb() would free the frag
+	 * so to be able to reuse it we need an extra ref.
+	 */
+	if (skb && rxbuf && skb->head == rxbuf->frag)
+		page_ref_inc(virt_to_head_page(rxbuf->frag));
+	if (rxbuf)
+		nfp_nfdk_rx_give_one(dp, rx_ring, rxbuf->frag, rxbuf->dma_addr);
+	if (skb)
+		dev_kfree_skb_any(skb);
+}
+
+/**
+ * nfp_nfdk_rx() - receive up to @budget packets on @rx_ring
+ * @rx_ring:   RX ring to receive from
+ * @budget:    NAPI budget
+ *
+ * Note, this function is separated out from the napi poll function to
+ * more cleanly separate packet receive code from other bookkeeping
+ * functions performed in the napi poll function.
+ *
+ * Return: Number of packets received.
+ */
+static int nfp_nfdk_rx(struct nfp_net_rx_ring *rx_ring, int budget)
+{
+	struct nfp_net_r_vector *r_vec = rx_ring->r_vec;
+	struct nfp_net_dp *dp = &r_vec->nfp_net->dp;
+	struct nfp_net_tx_ring *tx_ring;
+	struct bpf_prog *xdp_prog;
+	bool xdp_tx_cmpl = false;
+	unsigned int true_bufsz;
+	struct sk_buff *skb;
+	int pkts_polled = 0;
+	struct xdp_buff xdp;
+	int idx;
+
+	xdp_prog = READ_ONCE(dp->xdp_prog);
+	true_bufsz = xdp_prog ? PAGE_SIZE : dp->fl_bufsz;
+	xdp_init_buff(&xdp, PAGE_SIZE - NFP_NET_RX_BUF_HEADROOM,
+		      &rx_ring->xdp_rxq);
+	tx_ring = r_vec->xdp_ring;
+
+	while (pkts_polled < budget) {
+		unsigned int meta_len, data_len, meta_off, pkt_len, pkt_off;
+		struct nfp_net_rx_buf *rxbuf;
+		struct nfp_net_rx_desc *rxd;
+		struct nfp_meta_parsed meta;
+		bool redir_egress = false;
+		struct net_device *netdev;
+		dma_addr_t new_dma_addr;
+		u32 meta_len_xdp = 0;
+		void *new_frag;
+
+		idx = D_IDX(rx_ring, rx_ring->rd_p);
+
+		rxd = &rx_ring->rxds[idx];
+		if (!(rxd->rxd.meta_len_dd & PCIE_DESC_RX_DD))
+			break;
+
+		/* Memory barrier to ensure that we won't do other reads
+		 * before the DD bit.
+		 */
+		dma_rmb();
+
+		memset(&meta, 0, sizeof(meta));
+
+		rx_ring->rd_p++;
+		pkts_polled++;
+
+		rxbuf =	&rx_ring->rxbufs[idx];
+		/*         < meta_len >
+		 *  <-- [rx_offset] -->
+		 *  ---------------------------------------------------------
+		 * | [XX] |  metadata  |             packet           | XXXX |
+		 *  ---------------------------------------------------------
+		 *         <---------------- data_len --------------->
+		 *
+		 * The rx_offset is fixed for all packets, the meta_len can vary
+		 * on a packet by packet basis. If rx_offset is set to zero
+		 * (_RX_OFFSET_DYNAMIC) metadata starts at the beginning of the
+		 * buffer and is immediately followed by the packet (no [XX]).
+		 */
+		meta_len = rxd->rxd.meta_len_dd & PCIE_DESC_RX_META_LEN_MASK;
+		data_len = le16_to_cpu(rxd->rxd.data_len);
+		pkt_len = data_len - meta_len;
+
+		pkt_off = NFP_NET_RX_BUF_HEADROOM + dp->rx_dma_off;
+		if (dp->rx_offset == NFP_NET_CFG_RX_OFFSET_DYNAMIC)
+			pkt_off += meta_len;
+		else
+			pkt_off += dp->rx_offset;
+		meta_off = pkt_off - meta_len;
+
+		/* Stats update */
+		u64_stats_update_begin(&r_vec->rx_sync);
+		r_vec->rx_pkts++;
+		r_vec->rx_bytes += pkt_len;
+		u64_stats_update_end(&r_vec->rx_sync);
+
+		if (unlikely(meta_len > NFP_NET_MAX_PREPEND ||
+			     (dp->rx_offset && meta_len > dp->rx_offset))) {
+			nn_dp_warn(dp, "oversized RX packet metadata %u\n",
+				   meta_len);
+			nfp_nfdk_rx_drop(dp, r_vec, rx_ring, rxbuf, NULL);
+			continue;
+		}
+
+		nfp_net_dma_sync_cpu_rx(dp, rxbuf->dma_addr + meta_off,
+					data_len);
+
+		if (meta_len) {
+			if (unlikely(nfp_nfdk_parse_meta(dp->netdev, &meta,
+							 rxbuf->frag + meta_off,
+							 rxbuf->frag + pkt_off,
+							 pkt_len, meta_len))) {
+				nn_dp_warn(dp, "invalid RX packet metadata\n");
+				nfp_nfdk_rx_drop(dp, r_vec, rx_ring, rxbuf,
+						 NULL);
+				continue;
+			}
+		}
+
+		if (xdp_prog && !meta.portid) {
+			void *orig_data = rxbuf->frag + pkt_off;
+			int act;
+
+			xdp_prepare_buff(&xdp,
+					 rxbuf->frag + NFP_NET_RX_BUF_HEADROOM,
+					 pkt_off - NFP_NET_RX_BUF_HEADROOM,
+					 pkt_len, true);
+
+			act = bpf_prog_run_xdp(xdp_prog, &xdp);
+
+			pkt_len = xdp.data_end - xdp.data;
+			pkt_off += xdp.data - orig_data;
+
+			switch (act) {
+			case XDP_PASS:
+				meta_len_xdp = xdp.data - xdp.data_meta;
+				break;
+			default:
+				bpf_warn_invalid_xdp_action(dp->netdev, xdp_prog, act);
+				fallthrough;
+			case XDP_ABORTED:
+				trace_xdp_exception(dp->netdev, xdp_prog, act);
+				fallthrough;
+			case XDP_DROP:
+				nfp_nfdk_rx_give_one(dp, rx_ring, rxbuf->frag,
+						     rxbuf->dma_addr);
+				continue;
+			}
+		}
+
+		if (likely(!meta.portid)) {
+			netdev = dp->netdev;
+		} else if (meta.portid == NFP_META_PORT_ID_CTRL) {
+			struct nfp_net *nn = netdev_priv(dp->netdev);
+
+			nfp_app_ctrl_rx_raw(nn->app, rxbuf->frag + pkt_off,
+					    pkt_len);
+			nfp_nfdk_rx_give_one(dp, rx_ring, rxbuf->frag,
+					     rxbuf->dma_addr);
+			continue;
+		} else {
+			struct nfp_net *nn;
+
+			nn = netdev_priv(dp->netdev);
+			netdev = nfp_app_dev_get(nn->app, meta.portid,
+						 &redir_egress);
+			if (unlikely(!netdev)) {
+				nfp_nfdk_rx_drop(dp, r_vec, rx_ring, rxbuf,
+						 NULL);
+				continue;
+			}
+
+			if (nfp_netdev_is_nfp_repr(netdev))
+				nfp_repr_inc_rx_stats(netdev, pkt_len);
+		}
+
+		skb = build_skb(rxbuf->frag, true_bufsz);
+		if (unlikely(!skb)) {
+			nfp_nfdk_rx_drop(dp, r_vec, rx_ring, rxbuf, NULL);
+			continue;
+		}
+		new_frag = nfp_nfdk_napi_alloc_one(dp, &new_dma_addr);
+		if (unlikely(!new_frag)) {
+			nfp_nfdk_rx_drop(dp, r_vec, rx_ring, rxbuf, skb);
+			continue;
+		}
+
+		nfp_net_dma_unmap_rx(dp, rxbuf->dma_addr);
+
+		nfp_nfdk_rx_give_one(dp, rx_ring, new_frag, new_dma_addr);
+
+		skb_reserve(skb, pkt_off);
+		skb_put(skb, pkt_len);
+
+		skb->mark = meta.mark;
+		skb_set_hash(skb, meta.hash, meta.hash_type);
+
+		skb_record_rx_queue(skb, rx_ring->idx);
+		skb->protocol = eth_type_trans(skb, netdev);
+
+		nfp_nfdk_rx_csum(dp, r_vec, rxd, &meta, skb);
+
+		if (rxd->rxd.flags & PCIE_DESC_RX_VLAN)
+			__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q),
+					       le16_to_cpu(rxd->rxd.vlan));
+		if (meta_len_xdp)
+			skb_metadata_set(skb, meta_len_xdp);
+
+		if (likely(!redir_egress)) {
+			napi_gro_receive(&rx_ring->r_vec->napi, skb);
+		} else {
+			skb->dev = netdev;
+			skb_reset_network_header(skb);
+			__skb_push(skb, ETH_HLEN);
+			dev_queue_xmit(skb);
+		}
+	}
+
+	if (xdp_prog) {
+		if (tx_ring->wr_ptr_add)
+			nfp_net_tx_xmit_more_flush(tx_ring);
+		else if (unlikely(tx_ring->wr_p != tx_ring->rd_p) &&
+			 !xdp_tx_cmpl)
+			if (!nfp_nfdk_xdp_complete(tx_ring))
+				pkts_polled = budget;
+	}
+
+	return pkts_polled;
+}
+
+/**
+ * nfp_nfdk_poll() - napi poll function
+ * @napi:    NAPI structure
+ * @budget:  NAPI budget
+ *
+ * Return: number of packets polled.
+ */
+int nfp_nfdk_poll(struct napi_struct *napi, int budget)
+{
+	struct nfp_net_r_vector *r_vec =
+		container_of(napi, struct nfp_net_r_vector, napi);
+	unsigned int pkts_polled = 0;
+
+	if (r_vec->tx_ring)
+		nfp_nfdk_tx_complete(r_vec->tx_ring, budget);
+	if (r_vec->rx_ring)
+		pkts_polled = nfp_nfdk_rx(r_vec->rx_ring, budget);
+
+	if (pkts_polled < budget)
+		if (napi_complete_done(napi, pkts_polled))
+			nfp_net_irq_unmask(r_vec->nfp_net, r_vec->irq_entry);
+
+	if (r_vec->nfp_net->rx_coalesce_adapt_on && r_vec->rx_ring) {
+		struct dim_sample dim_sample = {};
+		unsigned int start;
+		u64 pkts, bytes;
+
+		do {
+			start = u64_stats_fetch_begin(&r_vec->rx_sync);
+			pkts = r_vec->rx_pkts;
+			bytes = r_vec->rx_bytes;
+		} while (u64_stats_fetch_retry(&r_vec->rx_sync, start));
+
+		dim_update_sample(r_vec->event_ctr, pkts, bytes, &dim_sample);
+		net_dim(&r_vec->rx_dim, dim_sample);
+	}
+
+	if (r_vec->nfp_net->tx_coalesce_adapt_on && r_vec->tx_ring) {
+		struct dim_sample dim_sample = {};
+		unsigned int start;
+		u64 pkts, bytes;
+
+		do {
+			start = u64_stats_fetch_begin(&r_vec->tx_sync);
+			pkts = r_vec->tx_pkts;
+			bytes = r_vec->tx_bytes;
+		} while (u64_stats_fetch_retry(&r_vec->tx_sync, start));
+
+		dim_update_sample(r_vec->event_ctr, pkts, bytes, &dim_sample);
+		net_dim(&r_vec->tx_dim, dim_sample);
+	}
+
+	return pkts_polled;
+}
+
+/* Control device data path
+ */
+
+bool
+nfp_nfdk_ctrl_tx_one(struct nfp_net *nn, struct nfp_net_r_vector *r_vec,
+		     struct sk_buff *skb, bool old)
+{
+	u32 cnt, tmp_dlen, dlen_type = 0;
+	struct nfp_net_tx_ring *tx_ring;
+	struct nfp_nfdk_tx_buf *txbuf;
+	struct nfp_nfdk_tx_desc *txd;
+	unsigned int dma_len, type;
+	struct nfp_net_dp *dp;
+	dma_addr_t dma_addr;
+	u64 metadata = 0;
+	int wr_idx;
+
+	dp = &r_vec->nfp_net->dp;
+	tx_ring = r_vec->tx_ring;
+
+	if (WARN_ON_ONCE(skb_shinfo(skb)->nr_frags)) {
+		nn_dp_warn(dp, "Driver's CTRL TX does not implement gather\n");
+		goto err_free;
+	}
+
+	/* Don't bother counting frags, assume the worst */
+	if (unlikely(nfp_net_tx_full(tx_ring, NFDK_TX_DESC_STOP_CNT))) {
+		u64_stats_update_begin(&r_vec->tx_sync);
+		r_vec->tx_busy++;
+		u64_stats_update_end(&r_vec->tx_sync);
+		if (!old)
+			__skb_queue_tail(&r_vec->queue, skb);
+		else
+			__skb_queue_head(&r_vec->queue, skb);
+		return NETDEV_TX_BUSY;
+	}
+
+	if (nfp_app_ctrl_has_meta(nn->app)) {
+		if (unlikely(skb_headroom(skb) < 8)) {
+			nn_dp_warn(dp, "CTRL TX on skb without headroom\n");
+			goto err_free;
+		}
+		metadata = NFDK_DESC_TX_CHAIN_META;
+		put_unaligned_be32(NFP_META_PORT_ID_CTRL, skb_push(skb, 4));
+		put_unaligned_be32(FIELD_PREP(NFDK_META_LEN, 8) |
+				   FIELD_PREP(NFDK_META_FIELDS,
+					      NFP_NET_META_PORTID),
+				   skb_push(skb, 4));
+	}
+
+	if (nfp_nfdk_tx_maybe_close_block(tx_ring, 0, skb))
+		goto err_free;
+
+	/* DMA map all */
+	wr_idx = D_IDX(tx_ring, tx_ring->wr_p);
+	txd = &tx_ring->ktxds[wr_idx];
+	txbuf = &tx_ring->ktxbufs[wr_idx];
+
+	dma_len = skb_headlen(skb);
+	if (dma_len < NFDK_TX_MAX_DATA_PER_HEAD)
+		type = NFDK_DESC_TX_TYPE_SIMPLE;
+	else
+		type = NFDK_DESC_TX_TYPE_GATHER;
+
+	dma_addr = dma_map_single(dp->dev, skb->data, dma_len, DMA_TO_DEVICE);
+	if (dma_mapping_error(dp->dev, dma_addr))
+		goto err_warn_dma;
+
+	txbuf->skb = skb;
+	txbuf++;
+
+	txbuf->dma_addr = dma_addr;
+	txbuf++;
+
+	dma_len -= 1;
+	dlen_type = FIELD_PREP(NFDK_DESC_TX_DMA_LEN_HEAD, dma_len) |
+		    FIELD_PREP(NFDK_DESC_TX_TYPE_HEAD, type);
+
+	txd->dma_len_type = cpu_to_le16(dlen_type);
+	nfp_desc_set_dma_addr(txd, dma_addr);
+
+	tmp_dlen = dlen_type & NFDK_DESC_TX_DMA_LEN_HEAD;
+	dma_len -= tmp_dlen;
+	dma_addr += tmp_dlen + 1;
+	txd++;
+
+	while (dma_len > 0) {
+		dma_len -= 1;
+		dlen_type = FIELD_PREP(NFDK_DESC_TX_DMA_LEN, dma_len);
+		txd->dma_len_type = cpu_to_le16(dlen_type);
+		nfp_desc_set_dma_addr(txd, dma_addr);
+
+		dlen_type &= NFDK_DESC_TX_DMA_LEN;
+		dma_len -= dlen_type;
+		dma_addr += dlen_type + 1;
+		txd++;
+	}
+
+	(txd - 1)->dma_len_type = cpu_to_le16(dlen_type | NFDK_DESC_TX_EOP);
+
+	/* Metadata desc */
+	txd->raw = cpu_to_le64(metadata);
+	txd++;
+
+	cnt = txd - tx_ring->ktxds - wr_idx;
+	if (unlikely(round_down(wr_idx, NFDK_TX_DESC_BLOCK_CNT) !=
+		     round_down(wr_idx + cnt - 1, NFDK_TX_DESC_BLOCK_CNT)))
+		goto err_warn_overflow;
+
+	tx_ring->wr_p += cnt;
+	if (tx_ring->wr_p % NFDK_TX_DESC_BLOCK_CNT)
+		tx_ring->data_pending += skb->len;
+	else
+		tx_ring->data_pending = 0;
+
+	tx_ring->wr_ptr_add += cnt;
+	nfp_net_tx_xmit_more_flush(tx_ring);
+
+	return NETDEV_TX_OK;
+
+err_warn_overflow:
+	WARN_ONCE(1, "unable to fit packet into a descriptor wr_idx:%d head:%d frags:%d cnt:%d",
+		  wr_idx, skb_headlen(skb), 0, cnt);
+	txbuf--;
+	dma_unmap_single(dp->dev, txbuf->dma_addr,
+			 skb_headlen(skb), DMA_TO_DEVICE);
+	txbuf->raw = 0;
+err_warn_dma:
+	nn_dp_warn(dp, "Failed to map DMA TX buffer\n");
+err_free:
+	u64_stats_update_begin(&r_vec->tx_sync);
+	r_vec->tx_errors++;
+	u64_stats_update_end(&r_vec->tx_sync);
+	dev_kfree_skb_any(skb);
+	return NETDEV_TX_OK;
+}
+
+static void __nfp_ctrl_tx_queued(struct nfp_net_r_vector *r_vec)
+{
+	struct sk_buff *skb;
+
+	while ((skb = __skb_dequeue(&r_vec->queue)))
+		if (nfp_nfdk_ctrl_tx_one(r_vec->nfp_net, r_vec, skb, true))
+			return;
+}
+
+static bool
+nfp_ctrl_meta_ok(struct nfp_net *nn, void *data, unsigned int meta_len)
+{
+	u32 meta_type, meta_tag;
+
+	if (!nfp_app_ctrl_has_meta(nn->app))
+		return !meta_len;
+
+	if (meta_len != 8)
+		return false;
+
+	meta_type = get_unaligned_be32(data);
+	meta_tag = get_unaligned_be32(data + 4);
+
+	return (meta_type == NFP_NET_META_PORTID &&
+		meta_tag == NFP_META_PORT_ID_CTRL);
+}
+
+static bool
+nfp_ctrl_rx_one(struct nfp_net *nn, struct nfp_net_dp *dp,
+		struct nfp_net_r_vector *r_vec, struct nfp_net_rx_ring *rx_ring)
+{
+	unsigned int meta_len, data_len, meta_off, pkt_len, pkt_off;
+	struct nfp_net_rx_buf *rxbuf;
+	struct nfp_net_rx_desc *rxd;
+	dma_addr_t new_dma_addr;
+	struct sk_buff *skb;
+	void *new_frag;
+	int idx;
+
+	idx = D_IDX(rx_ring, rx_ring->rd_p);
+
+	rxd = &rx_ring->rxds[idx];
+	if (!(rxd->rxd.meta_len_dd & PCIE_DESC_RX_DD))
+		return false;
+
+	/* Memory barrier to ensure that we won't do other reads
+	 * before the DD bit.
+	 */
+	dma_rmb();
+
+	rx_ring->rd_p++;
+
+	rxbuf =	&rx_ring->rxbufs[idx];
+	meta_len = rxd->rxd.meta_len_dd & PCIE_DESC_RX_META_LEN_MASK;
+	data_len = le16_to_cpu(rxd->rxd.data_len);
+	pkt_len = data_len - meta_len;
+
+	pkt_off = NFP_NET_RX_BUF_HEADROOM + dp->rx_dma_off;
+	if (dp->rx_offset == NFP_NET_CFG_RX_OFFSET_DYNAMIC)
+		pkt_off += meta_len;
+	else
+		pkt_off += dp->rx_offset;
+	meta_off = pkt_off - meta_len;
+
+	/* Stats update */
+	u64_stats_update_begin(&r_vec->rx_sync);
+	r_vec->rx_pkts++;
+	r_vec->rx_bytes += pkt_len;
+	u64_stats_update_end(&r_vec->rx_sync);
+
+	nfp_net_dma_sync_cpu_rx(dp, rxbuf->dma_addr + meta_off,	data_len);
+
+	if (unlikely(!nfp_ctrl_meta_ok(nn, rxbuf->frag + meta_off, meta_len))) {
+		nn_dp_warn(dp, "incorrect metadata for ctrl packet (%d)\n",
+			   meta_len);
+		nfp_nfdk_rx_drop(dp, r_vec, rx_ring, rxbuf, NULL);
+		return true;
+	}
+
+	skb = build_skb(rxbuf->frag, dp->fl_bufsz);
+	if (unlikely(!skb)) {
+		nfp_nfdk_rx_drop(dp, r_vec, rx_ring, rxbuf, NULL);
+		return true;
+	}
+	new_frag = nfp_nfdk_napi_alloc_one(dp, &new_dma_addr);
+	if (unlikely(!new_frag)) {
+		nfp_nfdk_rx_drop(dp, r_vec, rx_ring, rxbuf, skb);
+		return true;
+	}
+
+	nfp_net_dma_unmap_rx(dp, rxbuf->dma_addr);
+
+	nfp_nfdk_rx_give_one(dp, rx_ring, new_frag, new_dma_addr);
+
+	skb_reserve(skb, pkt_off);
+	skb_put(skb, pkt_len);
+
+	nfp_app_ctrl_rx(nn->app, skb);
+
+	return true;
+}
+
+static bool nfp_ctrl_rx(struct nfp_net_r_vector *r_vec)
+{
+	struct nfp_net_rx_ring *rx_ring = r_vec->rx_ring;
+	struct nfp_net *nn = r_vec->nfp_net;
+	struct nfp_net_dp *dp = &nn->dp;
+	unsigned int budget = 512;
+
+	while (nfp_ctrl_rx_one(nn, dp, r_vec, rx_ring) && budget--)
+		continue;
+
+	return budget;
+}
+
+void nfp_nfdk_ctrl_poll(struct tasklet_struct *t)
+{
+	struct nfp_net_r_vector *r_vec = from_tasklet(r_vec, t, tasklet);
+
+	spin_lock(&r_vec->lock);
+	nfp_nfdk_tx_complete(r_vec->tx_ring, 0);
+	__nfp_ctrl_tx_queued(r_vec);
+	spin_unlock(&r_vec->lock);
+
+	if (nfp_ctrl_rx(r_vec)) {
+		nfp_net_irq_unmask(r_vec->nfp_net, r_vec->irq_entry);
+	} else {
+		tasklet_schedule(&r_vec->tasklet);
+		nn_dp_warn(&r_vec->nfp_net->dp,
+			   "control message budget exceeded!\n");
+	}
+}
diff --git a/drivers/net/ethernet/netronome/nfp/nfdk/nfdk.h b/drivers/net/ethernet/netronome/nfp/nfdk/nfdk.h
new file mode 100644
index 000000000000..5107c4f03feb
--- /dev/null
+++ b/drivers/net/ethernet/netronome/nfp/nfdk/nfdk.h
@@ -0,0 +1,112 @@
+/* SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause) */
+/* Copyright (C) 2019 Netronome Systems, Inc. */
+
+#ifndef _NFP_DP_NFDK_H_
+#define _NFP_DP_NFDK_H_
+
+#include <linux/bitops.h>
+#include <linux/types.h>
+
+#define NFDK_TX_DESC_PER_SIMPLE_PKT	2
+
+#define NFDK_TX_MAX_DATA_PER_HEAD	SZ_4K
+#define NFDK_TX_MAX_DATA_PER_DESC	SZ_16K
+#define NFDK_TX_DESC_BLOCK_SZ		256
+#define NFDK_TX_DESC_BLOCK_CNT		(NFDK_TX_DESC_BLOCK_SZ /	\
+					 sizeof(struct nfp_nfdk_tx_desc))
+#define NFDK_TX_DESC_STOP_CNT		(NFDK_TX_DESC_BLOCK_CNT *	\
+					 NFDK_TX_DESC_PER_SIMPLE_PKT)
+#define NFDK_TX_MAX_DATA_PER_BLOCK	SZ_64K
+#define NFDK_TX_DESC_GATHER_MAX		17
+
+/* TX descriptor format */
+
+#define NFDK_DESC_TX_MSS_MASK		GENMASK(13, 0)
+
+#define NFDK_DESC_TX_CHAIN_META		BIT(3)
+#define NFDK_DESC_TX_ENCAP		BIT(2)
+#define NFDK_DESC_TX_L4_CSUM		BIT(1)
+#define NFDK_DESC_TX_L3_CSUM		BIT(0)
+
+#define NFDK_DESC_TX_DMA_LEN_HEAD	GENMASK(11, 0)
+#define NFDK_DESC_TX_TYPE_HEAD		GENMASK(15, 12)
+#define NFDK_DESC_TX_DMA_LEN		GENMASK(13, 0)
+#define NFDK_DESC_TX_TYPE_NOP		0
+#define NFDK_DESC_TX_TYPE_GATHER	1
+#define NFDK_DESC_TX_TYPE_TSO		2
+#define NFDK_DESC_TX_TYPE_SIMPLE	8
+#define NFDK_DESC_TX_EOP		BIT(14)
+
+#define NFDK_META_LEN			GENMASK(7, 0)
+#define NFDK_META_FIELDS		GENMASK(31, 8)
+
+#define D_BLOCK_CPL(idx)		(NFDK_TX_DESC_BLOCK_CNT -	\
+					 (idx) % NFDK_TX_DESC_BLOCK_CNT)
+
+struct nfp_nfdk_tx_desc {
+	union {
+		struct {
+			u8 dma_addr_hi;  /* High bits of host buf address */
+			u8 padding;  /* Must be zero */
+			__le16 dma_len_type; /* Length to DMA for this desc */
+			__le32 dma_addr_lo;  /* Low 32bit of host buf addr */
+		};
+
+		struct {
+			__le16 mss;	/* MSS to be used for LSO */
+			u8 lso_hdrlen;  /* LSO, TCP payload offset */
+			u8 lso_totsegs; /* LSO, total segments */
+			u8 l3_offset;   /* L3 header offset */
+			u8 l4_offset;   /* L4 header offset */
+			__le16 lso_meta_res; /* Rsvd bits in TSO metadata */
+		};
+
+		struct {
+			u8 flags;	/* TX Flags, see @NFDK_DESC_TX_* */
+			u8 reserved[7];	/* meta byte placeholder */
+		};
+
+		__le32 vals[2];
+		__le64 raw;
+	};
+};
+
+struct nfp_nfdk_tx_buf {
+	union {
+		/* First slot */
+		union {
+			struct sk_buff *skb;
+			void *frag;
+		};
+
+		/* 1 + nr_frags next slots */
+		dma_addr_t dma_addr;
+
+		/* TSO (optional) */
+		struct {
+			u32 pkt_cnt;
+			u32 real_len;
+		};
+
+		u64 raw;
+	};
+};
+
+static inline int nfp_nfdk_headlen_to_segs(unsigned int headlen)
+{
+	/* First descriptor fits less data, so adjust for that */
+	return DIV_ROUND_UP(headlen +
+			    NFDK_TX_MAX_DATA_PER_DESC -
+			    NFDK_TX_MAX_DATA_PER_HEAD,
+			    NFDK_TX_MAX_DATA_PER_DESC);
+}
+
+int nfp_nfdk_poll(struct napi_struct *napi, int budget);
+netdev_tx_t nfp_nfdk_tx(struct sk_buff *skb, struct net_device *netdev);
+bool
+nfp_nfdk_ctrl_tx_one(struct nfp_net *nn, struct nfp_net_r_vector *r_vec,
+		     struct sk_buff *skb, bool old);
+void nfp_nfdk_ctrl_poll(struct tasklet_struct *t);
+void nfp_nfdk_rx_ring_fill_freelist(struct nfp_net_dp *dp,
+				    struct nfp_net_rx_ring *rx_ring);
+#endif
diff --git a/drivers/net/ethernet/netronome/nfp/nfdk/rings.c b/drivers/net/ethernet/netronome/nfp/nfdk/rings.c
new file mode 100644
index 000000000000..301f11108826
--- /dev/null
+++ b/drivers/net/ethernet/netronome/nfp/nfdk/rings.c
@@ -0,0 +1,195 @@
+// SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+/* Copyright (C) 2019 Netronome Systems, Inc. */
+
+#include <linux/seq_file.h>
+
+#include "../nfp_net.h"
+#include "../nfp_net_dp.h"
+#include "nfdk.h"
+
+static void
+nfp_nfdk_tx_ring_reset(struct nfp_net_dp *dp, struct nfp_net_tx_ring *tx_ring)
+{
+	struct device *dev = dp->dev;
+	struct netdev_queue *nd_q;
+
+	while (!tx_ring->is_xdp && tx_ring->rd_p != tx_ring->wr_p) {
+		const skb_frag_t *frag, *fend;
+		unsigned int size, n_descs = 1;
+		struct nfp_nfdk_tx_buf *txbuf;
+		int nr_frags, rd_idx;
+		struct sk_buff *skb;
+
+		rd_idx = D_IDX(tx_ring, tx_ring->rd_p);
+		txbuf = &tx_ring->ktxbufs[rd_idx];
+
+		skb = txbuf->skb;
+		if (!skb) {
+			n_descs = D_BLOCK_CPL(tx_ring->rd_p);
+			goto next;
+		}
+
+		nr_frags = skb_shinfo(skb)->nr_frags;
+		txbuf++;
+
+		/* Unmap head */
+		size = skb_headlen(skb);
+		dma_unmap_single(dev, txbuf->dma_addr, size, DMA_TO_DEVICE);
+		n_descs += nfp_nfdk_headlen_to_segs(size);
+		txbuf++;
+
+		frag = skb_shinfo(skb)->frags;
+		fend = frag + nr_frags;
+		for (; frag < fend; frag++) {
+			size = skb_frag_size(frag);
+			dma_unmap_page(dev, txbuf->dma_addr,
+				       skb_frag_size(frag), DMA_TO_DEVICE);
+			n_descs += DIV_ROUND_UP(size,
+						NFDK_TX_MAX_DATA_PER_DESC);
+			txbuf++;
+		}
+
+		if (skb_is_gso(skb))
+			n_descs++;
+
+		dev_kfree_skb_any(skb);
+next:
+		tx_ring->rd_p += n_descs;
+	}
+
+	memset(tx_ring->txds, 0, tx_ring->size);
+	tx_ring->data_pending = 0;
+	tx_ring->wr_p = 0;
+	tx_ring->rd_p = 0;
+	tx_ring->qcp_rd_p = 0;
+	tx_ring->wr_ptr_add = 0;
+
+	if (tx_ring->is_xdp || !dp->netdev)
+		return;
+
+	nd_q = netdev_get_tx_queue(dp->netdev, tx_ring->idx);
+	netdev_tx_reset_queue(nd_q);
+}
+
+static void nfp_nfdk_tx_ring_free(struct nfp_net_tx_ring *tx_ring)
+{
+	struct nfp_net_r_vector *r_vec = tx_ring->r_vec;
+	struct nfp_net_dp *dp = &r_vec->nfp_net->dp;
+
+	kvfree(tx_ring->ktxbufs);
+
+	if (tx_ring->ktxds)
+		dma_free_coherent(dp->dev, tx_ring->size,
+				  tx_ring->ktxds, tx_ring->dma);
+
+	tx_ring->cnt = 0;
+	tx_ring->txbufs = NULL;
+	tx_ring->txds = NULL;
+	tx_ring->dma = 0;
+	tx_ring->size = 0;
+}
+
+static int
+nfp_nfdk_tx_ring_alloc(struct nfp_net_dp *dp, struct nfp_net_tx_ring *tx_ring)
+{
+	struct nfp_net_r_vector *r_vec = tx_ring->r_vec;
+
+	tx_ring->cnt = dp->txd_cnt * NFDK_TX_DESC_PER_SIMPLE_PKT;
+	tx_ring->size = array_size(tx_ring->cnt, sizeof(*tx_ring->ktxds));
+	tx_ring->ktxds = dma_alloc_coherent(dp->dev, tx_ring->size,
+					    &tx_ring->dma,
+					    GFP_KERNEL | __GFP_NOWARN);
+	if (!tx_ring->ktxds) {
+		netdev_warn(dp->netdev, "failed to allocate TX descriptor ring memory, requested descriptor count: %d, consider lowering descriptor count\n",
+			    tx_ring->cnt);
+		goto err_alloc;
+	}
+
+	tx_ring->ktxbufs = kvcalloc(tx_ring->cnt, sizeof(*tx_ring->ktxbufs),
+				    GFP_KERNEL);
+	if (!tx_ring->ktxbufs)
+		goto err_alloc;
+
+	if (!tx_ring->is_xdp && dp->netdev)
+		netif_set_xps_queue(dp->netdev, &r_vec->affinity_mask,
+				    tx_ring->idx);
+
+	return 0;
+
+err_alloc:
+	nfp_nfdk_tx_ring_free(tx_ring);
+	return -ENOMEM;
+}
+
+static void
+nfp_nfdk_tx_ring_bufs_free(struct nfp_net_dp *dp,
+			   struct nfp_net_tx_ring *tx_ring)
+{
+}
+
+static int
+nfp_nfdk_tx_ring_bufs_alloc(struct nfp_net_dp *dp,
+			    struct nfp_net_tx_ring *tx_ring)
+{
+	return 0;
+}
+
+static void
+nfp_nfdk_print_tx_descs(struct seq_file *file,
+			struct nfp_net_r_vector *r_vec,
+			struct nfp_net_tx_ring *tx_ring,
+			u32 d_rd_p, u32 d_wr_p)
+{
+	struct nfp_nfdk_tx_desc *txd;
+	u32 txd_cnt = tx_ring->cnt;
+	int i;
+
+	for (i = 0; i < txd_cnt; i++) {
+		txd = &tx_ring->ktxds[i];
+
+		seq_printf(file, "%04d: 0x%08x 0x%08x 0x%016llx", i,
+			   txd->vals[0], txd->vals[1], tx_ring->ktxbufs[i].raw);
+
+		if (i == tx_ring->rd_p % txd_cnt)
+			seq_puts(file, " H_RD");
+		if (i == tx_ring->wr_p % txd_cnt)
+			seq_puts(file, " H_WR");
+		if (i == d_rd_p % txd_cnt)
+			seq_puts(file, " D_RD");
+		if (i == d_wr_p % txd_cnt)
+			seq_puts(file, " D_WR");
+
+		seq_putc(file, '\n');
+	}
+}
+
+#define NFP_NFDK_CFG_CTRL_SUPPORTED					\
+	(NFP_NET_CFG_CTRL_ENABLE | NFP_NET_CFG_CTRL_PROMISC |		\
+	 NFP_NET_CFG_CTRL_L2BC | NFP_NET_CFG_CTRL_L2MC |		\
+	 NFP_NET_CFG_CTRL_RXCSUM | NFP_NET_CFG_CTRL_TXCSUM |		\
+	 NFP_NET_CFG_CTRL_RXVLAN |					\
+	 NFP_NET_CFG_CTRL_GATHER | NFP_NET_CFG_CTRL_LSO |		\
+	 NFP_NET_CFG_CTRL_CTAG_FILTER | NFP_NET_CFG_CTRL_CMSG_DATA |	\
+	 NFP_NET_CFG_CTRL_RINGCFG | NFP_NET_CFG_CTRL_IRQMOD |		\
+	 NFP_NET_CFG_CTRL_TXRWB |					\
+	 NFP_NET_CFG_CTRL_VXLAN | NFP_NET_CFG_CTRL_NVGRE |		\
+	 NFP_NET_CFG_CTRL_BPF | NFP_NET_CFG_CTRL_LSO2 |			\
+	 NFP_NET_CFG_CTRL_RSS2 | NFP_NET_CFG_CTRL_CSUM_COMPLETE |	\
+	 NFP_NET_CFG_CTRL_LIVE_ADDR)
+
+const struct nfp_dp_ops nfp_nfdk_ops = {
+	.version		= NFP_NFD_VER_NFDK,
+	.tx_min_desc_per_pkt	= NFDK_TX_DESC_PER_SIMPLE_PKT,
+	.cap_mask		= NFP_NFDK_CFG_CTRL_SUPPORTED,
+	.poll			= nfp_nfdk_poll,
+	.ctrl_poll		= nfp_nfdk_ctrl_poll,
+	.xmit			= nfp_nfdk_tx,
+	.ctrl_tx_one		= nfp_nfdk_ctrl_tx_one,
+	.rx_ring_fill_freelist	= nfp_nfdk_rx_ring_fill_freelist,
+	.tx_ring_alloc		= nfp_nfdk_tx_ring_alloc,
+	.tx_ring_reset		= nfp_nfdk_tx_ring_reset,
+	.tx_ring_free		= nfp_nfdk_tx_ring_free,
+	.tx_ring_bufs_alloc	= nfp_nfdk_tx_ring_bufs_alloc,
+	.tx_ring_bufs_free	= nfp_nfdk_tx_ring_bufs_free,
+	.print_tx_descs		= nfp_nfdk_print_tx_descs
+};
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net.h b/drivers/net/ethernet/netronome/nfp/nfp_net.h
index e7646377de37..428783b7018b 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net.h
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net.h
@@ -108,6 +108,9 @@ struct xsk_buff_pool;
 struct nfp_nfd3_tx_desc;
 struct nfp_nfd3_tx_buf;
 
+struct nfp_nfdk_tx_desc;
+struct nfp_nfdk_tx_buf;
+
 /* Convenience macro for wrapping descriptor index on ring size */
 #define D_IDX(ring, idx)	((idx) & ((ring)->cnt - 1))
 
@@ -125,6 +128,7 @@ struct nfp_nfd3_tx_buf;
  * struct nfp_net_tx_ring - TX ring structure
  * @r_vec:      Back pointer to ring vector structure
  * @idx:        Ring index from Linux's perspective
+ * @data_pending: number of bytes added to current block (NFDK only)
  * @qcp_q:      Pointer to base of the QCP TX queue
  * @txrwb:	TX pointer write back area
  * @cnt:        Size of the queue in number of descriptors
@@ -133,8 +137,10 @@ struct nfp_nfd3_tx_buf;
  * @qcp_rd_p:   Local copy of QCP TX queue read pointer
  * @wr_ptr_add:	Accumulated number of buffers to add to QCP write pointer
  *		(used for .xmit_more delayed kick)
- * @txbufs:     Array of transmitted TX buffers, to free on transmit
- * @txds:       Virtual address of TX ring in host memory
+ * @txbufs:	Array of transmitted TX buffers, to free on transmit (NFD3)
+ * @ktxbufs:	Array of transmitted TX buffers, to free on transmit (NFDK)
+ * @txds:	Virtual address of TX ring in host memory (NFD3)
+ * @ktxds:	Virtual address of TX ring in host memory (NFDK)
  *
  * @qcidx:      Queue Controller Peripheral (QCP) queue index for the TX queue
  * @dma:        DMA address of the TX ring
@@ -144,7 +150,8 @@ struct nfp_nfd3_tx_buf;
 struct nfp_net_tx_ring {
 	struct nfp_net_r_vector *r_vec;
 
-	u32 idx;
+	u16 idx;
+	u16 data_pending;
 	u8 __iomem *qcp_q;
 	u64 *txrwb;
 
@@ -155,8 +162,14 @@ struct nfp_net_tx_ring {
 
 	u32 wr_ptr_add;
 
-	struct nfp_nfd3_tx_buf *txbufs;
-	struct nfp_nfd3_tx_desc *txds;
+	union {
+		struct nfp_nfd3_tx_buf *txbufs;
+		struct nfp_nfdk_tx_buf *ktxbufs;
+	};
+	union {
+		struct nfp_nfd3_tx_desc *txds;
+		struct nfp_nfdk_tx_desc *ktxds;
+	};
 
 	/* Cold data follows */
 	int qcidx;
@@ -860,10 +873,12 @@ static inline void nn_ctrl_bar_unlock(struct nfp_net *nn)
 extern const char nfp_driver_version[];
 
 extern const struct net_device_ops nfp_nfd3_netdev_ops;
+extern const struct net_device_ops nfp_nfdk_netdev_ops;
 
 static inline bool nfp_netdev_is_nfp_net(struct net_device *netdev)
 {
-	return netdev->netdev_ops == &nfp_nfd3_netdev_ops;
+	return netdev->netdev_ops == &nfp_nfd3_netdev_ops ||
+	       netdev->netdev_ops == &nfp_nfdk_netdev_ops;
 }
 
 static inline int nfp_net_coalesce_para_check(u32 usecs, u32 pkts)
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index 0aa91065a7cb..b412670d89b2 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -1920,6 +1920,33 @@ const struct net_device_ops nfp_nfd3_netdev_ops = {
 	.ndo_get_devlink_port	= nfp_devlink_get_devlink_port,
 };
 
+const struct net_device_ops nfp_nfdk_netdev_ops = {
+	.ndo_init		= nfp_app_ndo_init,
+	.ndo_uninit		= nfp_app_ndo_uninit,
+	.ndo_open		= nfp_net_netdev_open,
+	.ndo_stop		= nfp_net_netdev_close,
+	.ndo_start_xmit		= nfp_net_tx,
+	.ndo_get_stats64	= nfp_net_stat64,
+	.ndo_vlan_rx_add_vid	= nfp_net_vlan_rx_add_vid,
+	.ndo_vlan_rx_kill_vid	= nfp_net_vlan_rx_kill_vid,
+	.ndo_set_vf_mac         = nfp_app_set_vf_mac,
+	.ndo_set_vf_vlan        = nfp_app_set_vf_vlan,
+	.ndo_set_vf_spoofchk    = nfp_app_set_vf_spoofchk,
+	.ndo_set_vf_trust	= nfp_app_set_vf_trust,
+	.ndo_get_vf_config	= nfp_app_get_vf_config,
+	.ndo_set_vf_link_state  = nfp_app_set_vf_link_state,
+	.ndo_setup_tc		= nfp_port_setup_tc,
+	.ndo_tx_timeout		= nfp_net_tx_timeout,
+	.ndo_set_rx_mode	= nfp_net_set_rx_mode,
+	.ndo_change_mtu		= nfp_net_change_mtu,
+	.ndo_set_mac_address	= nfp_net_set_mac_address,
+	.ndo_set_features	= nfp_net_set_features,
+	.ndo_features_check	= nfp_net_features_check,
+	.ndo_get_phys_port_name	= nfp_net_get_phys_port_name,
+	.ndo_bpf		= nfp_net_xdp,
+	.ndo_get_devlink_port	= nfp_devlink_get_devlink_port,
+};
+
 static int nfp_udp_tunnel_sync(struct net_device *netdev, unsigned int table)
 {
 	struct nfp_net *nn = netdev_priv(netdev);
@@ -2042,6 +2069,16 @@ nfp_net_alloc(struct pci_dev *pdev, const struct nfp_dev_info *dev_info,
 	case NFP_NET_CFG_VERSION_DP_NFD3:
 		nn->dp.ops = &nfp_nfd3_ops;
 		break;
+	case NFP_NET_CFG_VERSION_DP_NFDK:
+		if (nn->fw_ver.major < 5) {
+			dev_err(&pdev->dev,
+				"NFDK must use ABI 5 or newer, found: %d\n",
+				nn->fw_ver.major);
+			err = -EINVAL;
+			goto err_free_nn;
+		}
+		nn->dp.ops = &nfp_nfdk_ops;
+		break;
 	default:
 		err = -EINVAL;
 		goto err_free_nn;
@@ -2268,6 +2305,9 @@ static void nfp_net_netdev_init(struct nfp_net *nn)
 	case NFP_NFD_VER_NFD3:
 		netdev->netdev_ops = &nfp_nfd3_netdev_ops;
 		break;
+	case NFP_NFD_VER_NFDK:
+		netdev->netdev_ops = &nfp_nfdk_netdev_ops;
+		break;
 	}
 
 	netdev->watchdog_timeo = msecs_to_jiffies(5 * 1000);
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h b/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h
index 7f04a5275a2d..8892a94f00c3 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h
@@ -151,6 +151,7 @@
 #define NFP_NET_CFG_VERSION		0x0030
 #define   NFP_NET_CFG_VERSION_RESERVED_MASK	(0xfe << 24)
 #define   NFP_NET_CFG_VERSION_DP_NFD3		0
+#define   NFP_NET_CFG_VERSION_DP_NFDK		1
 #define   NFP_NET_CFG_VERSION_DP_MASK		1
 #define   NFP_NET_CFG_VERSION_CLASS_MASK  (0xff << 16)
 #define   NFP_NET_CFG_VERSION_CLASS(x)	  (((x) & 0xff) << 16)
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_dp.h b/drivers/net/ethernet/netronome/nfp/nfp_net_dp.h
index 237ca1d9c886..c934cc2d3208 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_dp.h
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_dp.h
@@ -109,6 +109,7 @@ void nfp_net_rx_ring_reset(struct nfp_net_rx_ring *rx_ring);
 
 enum nfp_nfd_version {
 	NFP_NFD_VER_NFD3,
+	NFP_NFD_VER_NFDK,
 };
 
 /**
@@ -207,6 +208,7 @@ nfp_net_debugfs_print_tx_descs(struct seq_file *file, struct nfp_net_dp *dp,
 }
 
 extern const struct nfp_dp_ops nfp_nfd3_ops;
+extern const struct nfp_dp_ops nfp_nfdk_ops;
 
 netdev_tx_t nfp_net_tx(struct sk_buff *skb, struct net_device *netdev);
 
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_xsk.c b/drivers/net/ethernet/netronome/nfp/nfp_net_xsk.c
index 50a59aad70f4..86829446c637 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_xsk.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_xsk.c
@@ -112,6 +112,10 @@ int nfp_net_xsk_setup_pool(struct net_device *netdev,
 	struct nfp_net_dp *dp;
 	int err;
 
+	/* NFDK doesn't implement xsk yet. */
+	if (nn->dp.ops->version == NFP_NFD_VER_NFDK)
+		return -EOPNOTSUPP;
+
 	/* Reject on old FWs so we can drop some checks on datapath. */
 	if (nn->dp.rx_offset != NFP_NET_CFG_RX_OFFSET_DYNAMIC)
 		return -EOPNOTSUPP;
-- 
2.30.2

