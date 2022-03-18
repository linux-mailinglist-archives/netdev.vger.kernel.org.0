Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB06B4DD7C7
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 11:14:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234922AbiCRKPS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 06:15:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234884AbiCRKPJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 06:15:09 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2099.outbound.protection.outlook.com [40.107.92.99])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF461103B92
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 03:13:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ubd+sf+F2+hxuC5loqtMFW7YN/VP+w4QhFjIvplQdV2qgC8ftb0NthIVZSs0QXOGlndO/++0Jw3K96+wjtVt6JtKQyLZGS6LZEgfog94UWn26yCKJAW4PcnJQdqkbUOpQzjU/t1IErKxd95NhA3Qxy1wX9JtR+54IZEQZfFL1jLRCBxT++tjwHCpBhjW0kacouOjdXZIxYcGTr1JkF2RkffoT3EY1D2/OUh4c10mSVCiy1a3oMiGPjWzmb/QqPSmOcL2EFica4l5uDna7RmBJtnU/hdn56wCbAmoVTOqqKk+6iCDufwofVb9vsWWis/qHyxY6wCudHNbuYFKw1seHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Bh7xTEhBrgPOuJuXGYPro0CqElhAKmfLANJgqEXKH0U=;
 b=LaTFRGZGH4ufOvlFNAGHnvei/lcyI8Bm6xa9/f1jn/UShfks5S/mPRmWC9R4onuPy/muRSBiU3wv8cSKTdWn90f1ljw/JW+BouSvVZ4dfXfwvjBdf/+gXVbtkzLYocbYry2XHfskYrRjupOxp3J+JKXjsJnVB1vBInKyvH34CRVunp8+EtEAe0iwQ4p3mv8Cl9x1KKgiFaJni2Rji0FsqCecSWHw0BwhUJ8HIf+XPJVZIDR+YqoTpCIGGzKd0fwER6UAz4QwkmCqUmNWrENxaHAf8b9JYXazPAXlHGqRvK9TVMw/W9vRDP4FQ9361dpo576+CSAhFgmg4M8RyHKx9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bh7xTEhBrgPOuJuXGYPro0CqElhAKmfLANJgqEXKH0U=;
 b=ZFlMEfogcXkhVX2+acuruej1oE+HnROfVnPvzgzY1gvG3T8P5M4mZwD06cLex/ZQmYM4kJk8tWD2nbpEON45bj3lyHNrzSTkdKe0+rDPFb0lesGObAWYc0ZPWiZDtdQGf8N119eYFf4+S+IYhPuyxPKxftdo4rsJMmy7MjWHykE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM5PR1301MB2090.namprd13.prod.outlook.com (2603:10b6:4:33::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.7; Fri, 18 Mar
 2022 10:13:34 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::d27:c7d9:8880:a73e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::d27:c7d9:8880:a73e%2]) with mapi id 15.20.5081.015; Fri, 18 Mar 2022
 10:13:34 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com
Subject: [PATCH net-next 02/10] nfp: move the fast path code to separate files
Date:   Fri, 18 Mar 2022 11:12:54 +0100
Message-Id: <20220318101302.113419-3-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220318101302.113419-1-simon.horman@corigine.com>
References: <20220318101302.113419-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR02CA0114.eurprd02.prod.outlook.com
 (2603:10a6:20b:28c::11) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bc7eb62a-3d24-4c0c-e50e-08da08c7f5d5
X-MS-TrafficTypeDiagnostic: DM5PR1301MB2090:EE_
X-Microsoft-Antispam-PRVS: <DM5PR1301MB209032977F47F6D655B42F5FE8139@DM5PR1301MB2090.namprd13.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HoN2pYHH5E3yua7CE3aRLmM3Q9x3iHj5GKf1bl+V9Q6ZuZWi0u78yUbtMoFMoAjksxlIkd6uqHHJw/ivONCeuPhxy/Fhe3K33ziX6UEuc7vFYgZjvfOQkdvSVBlQnRbpAI2YQyLAcw3HWflS4PIzaNi+nakoj/vlmc77AxD1Ulmok1iPXN1+IxPDvqyXjw6lYK/fgFjR2+KHcDoVoIGPcO7Als11V3gnshW/4boThECz7ew4NX0dELEjX6OIABg0sDdimmPKTA8TqJdstMeXtfUZrcqXnTSa7kqmh0hey25od5kXo1oMR+3bmSqZ0RcrPRI9YVeAasaREN/kQw4HHaxqzCAKcdP+zBW2GEAxP1vtkvTF9JM1xJVjBtPe3tUdM428kjBDEr1renc0UqZX2HBBrydMu9s2KUP6IXliZl3yaj2jdbjsFVDi5SbROIB6LRnMd9vS60qNFIjyEAV+xJCykcPdumNEkjppuJ7lBktNXLtiaHfLga9nZtjgGANx+oqK9UWUCauD+e2b/0m5S7m+8EcHrt/92XdjfVmWatsdj/mR2TKdJeqeIC6HzWi/alm3mrqcw0E5L0TU00J7EixPQp75cozJr1ZGXsVhQdbzas0iimaT5HEf0+G4/9VINAcOnAMbIpBPNKKlHFgZmQEI7RplDgbvAk+tyei0W5Kbd1jRCkpu3B5CJO7EEpCywY1Wm7nTSlbi9CiBoERAeQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(376002)(396003)(136003)(366004)(39830400003)(346002)(2616005)(107886003)(66574015)(2906002)(186003)(1076003)(8676002)(86362001)(6512007)(36756003)(6506007)(52116002)(508600001)(83380400001)(5660300002)(66946007)(66556008)(66476007)(44832011)(4326008)(6486002)(38100700002)(316002)(6666004)(30864003)(110136005)(8936002)(559001)(579004)(309714004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?s0mqXID0oAPl54LTItY+JoArgBj7NfFWeyTO3kE6rJ5GgNLfJizwBFYq5mND?=
 =?us-ascii?Q?wQ3BwYlmhYi51Xjj1ev8FU+m45/Pov8suTV2vHfq4IBsYdDe7Xr7FXekIGFv?=
 =?us-ascii?Q?QWX8SGDM8nq8PzTs/RIAif2qVqxzS5zO7KZqnZJxsiVPPTeINV9ET/3uOl/h?=
 =?us-ascii?Q?MSdv+9WT89Nr35BdXsTwMVxCxVCGugUrVa3sanzSnbT+U6grqQ09o/xkQveV?=
 =?us-ascii?Q?RNnIIG5eCmmodlSOUgIWorH+SveoYU6TLeaRSD55noVoS8C2L2/wzP0mje/1?=
 =?us-ascii?Q?jUgDYuq9gd94F1+zLDOmKk92k7s38gDcz0RBKHMDKK5zDSYrymtJ44x/QmOB?=
 =?us-ascii?Q?V8icW/7zD1AkxNfhoTjpEeodVm/OzEzFgAVyllJhKNnLEUfDDVGOlKSk+Ml0?=
 =?us-ascii?Q?0S/iPteUa7S4QZyeGcv8DhX1yzyxwzCHhQ+6ibQzY/B2OJi1BemAZCsmhPsT?=
 =?us-ascii?Q?9njQPexXoI2NiA2CN7kQXJULzauA75Z4y9mhSojy4SPiYLfjJZ6nE3T5iJ7H?=
 =?us-ascii?Q?25EwvHtCC28YJ0SV17HDlWAljvSAGxx2bS3cMVp9mArfsi518fHOkULWNP5d?=
 =?us-ascii?Q?9hdChuzVHqulnnYoiDEx910RY8j6UPTWHkzEkaI9WO9yiXKH1WqpPOmeBePj?=
 =?us-ascii?Q?EZeVBSS/V8m3wPXvdp6P4U3CN8gS43iapzTUBj0Eiey9loz9nocOeX04MKri?=
 =?us-ascii?Q?KMFIBtph0EYLI3sut+O6wGN3ahrAwRjDgpdS9F+dPfvK37hinI72zbczw6pR?=
 =?us-ascii?Q?hyF/eiknMfAZpKzPLXXRnJssPS3b/Z11V5FcHypI8WUP6F+4ZaJpP3v3YbKk?=
 =?us-ascii?Q?ggrPYAV1wRGOgGCG3RIkjyyOMSYyQP/mIzkxD6oBC2A9f/18m9tiELe8Hj4X?=
 =?us-ascii?Q?s0pQvDrsIm6NmXIgOc1oTR41UUIEuPPUtTCJL4NKAlz1BUWI0Rlv+17KcOuK?=
 =?us-ascii?Q?S0RI1GD7rAqizNuZJzTycH9n6QrUFaaZ8mdLHjLRTBLADW856wEkL4VO/8jM?=
 =?us-ascii?Q?G3z0cy8TmXAajP8eWdaEJBWaDKF+OJ9ZKhdX6fo/7Odoedi+jPKwRpR3oNW/?=
 =?us-ascii?Q?GPxi9QUKwMQyZxQQ0vozJUmVlfDpOJGtpV0NYNEL31ntbmB0jdCM9LdtxM7F?=
 =?us-ascii?Q?Z1vrDAgqKtrfDCNZJKZ3L3T6aam0TeMgy+5ewPUEIG/Ci6hrkhsD9h0BcPoa?=
 =?us-ascii?Q?gDEc7elke2I8gtFiLb7Eg9eShpVc5aTRLAKELQeZYR8b/heUlrqBjQ0HPUXN?=
 =?us-ascii?Q?4WaBEeWjHuCLFIFk+qOKxK/egcMq3GwCP68uOhyT5DPWYsg8DrePexxrQAwl?=
 =?us-ascii?Q?MnidoFq2Exx5nG+m4wuw3/u5Q7OaGME2uI4XMTL964VMWNJYiLxZci+K1djk?=
 =?us-ascii?Q?w3HLc1lKtzlgpWlkl9wNoDcirdUWhGQ1SEKNuBMTdit9pB7Aw7jjVyMXL8yd?=
 =?us-ascii?Q?wOrI01BYvsEpzu8d8/DemkzasXKQk/Z6fQSb0Ne2hBvRulGuuwIAJX1FcT7n?=
 =?us-ascii?Q?MYBE/FUl8+AZ4UoAUB9gM8mtswzlvLuPSCo671UWlm9iXGhn6Byy4MBrCw?=
 =?us-ascii?Q?=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc7eb62a-3d24-4c0c-e50e-08da08c7f5d5
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2022 10:13:34.6826
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YDXuGaiSI+DzFDNOQJ98+ILxHiX+2Vh7+1WkVN29OxKfS/gqMFBa3eHIauNwQ968H/AABkZKexRq53C0ALCNo4vPcPr6+E9znFrJpNj/qrM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1301MB2090
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>

In preparation for support for a new datapath format move all
ring and fast path logic into separate files. It is basically
a verbatim move with some wrapping functions, no new structures
and functions added.

The current data path is called NFD3 from the initial version
of the driver ABI it used. The non-fast path, but ring related
functions are moved to nfp_net_dp.c file.

Changes to Jakub's work:
* Rebase on xsk related code.
* Split the patch, move the callback changes to next commit.

Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Fei Qin <fei.qin@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 drivers/net/ethernet/netronome/nfp/Makefile   |    4 +
 drivers/net/ethernet/netronome/nfp/nfd3/dp.c  | 1368 +++++++++++
 .../net/ethernet/netronome/nfp/nfd3/nfd3.h    |  126 +
 .../net/ethernet/netronome/nfp/nfd3/rings.c   |  243 ++
 drivers/net/ethernet/netronome/nfp/nfd3/xsk.c |  408 ++++
 drivers/net/ethernet/netronome/nfp/nfp_net.h  |  102 +-
 .../ethernet/netronome/nfp/nfp_net_common.c   | 2041 +----------------
 .../ethernet/netronome/nfp/nfp_net_debugfs.c  |   46 +-
 .../net/ethernet/netronome/nfp/nfp_net_dp.c   |  448 ++++
 .../net/ethernet/netronome/nfp/nfp_net_dp.h   |  120 +
 .../net/ethernet/netronome/nfp/nfp_net_xsk.c  |  436 +---
 .../net/ethernet/netronome/nfp/nfp_net_xsk.h  |   16 +-
 12 files changed, 2782 insertions(+), 2576 deletions(-)
 create mode 100644 drivers/net/ethernet/netronome/nfp/nfd3/dp.c
 create mode 100644 drivers/net/ethernet/netronome/nfp/nfd3/nfd3.h
 create mode 100644 drivers/net/ethernet/netronome/nfp/nfd3/rings.c
 create mode 100644 drivers/net/ethernet/netronome/nfp/nfd3/xsk.c
 create mode 100644 drivers/net/ethernet/netronome/nfp/nfp_net_dp.c
 create mode 100644 drivers/net/ethernet/netronome/nfp/nfp_net_dp.h

diff --git a/drivers/net/ethernet/netronome/nfp/Makefile b/drivers/net/ethernet/netronome/nfp/Makefile
index a35a382441d7..69168c03606f 100644
--- a/drivers/net/ethernet/netronome/nfp/Makefile
+++ b/drivers/net/ethernet/netronome/nfp/Makefile
@@ -20,12 +20,16 @@ nfp-objs := \
 	    ccm_mbox.o \
 	    devlink_param.o \
 	    nfp_asm.o \
+	    nfd3/dp.o \
+	    nfd3/rings.o \
+	    nfd3/xsk.o \
 	    nfp_app.o \
 	    nfp_app_nic.o \
 	    nfp_devlink.o \
 	    nfp_hwmon.o \
 	    nfp_main.o \
 	    nfp_net_common.o \
+	    nfp_net_dp.o \
 	    nfp_net_ctrl.o \
 	    nfp_net_debugdump.o \
 	    nfp_net_ethtool.o \
diff --git a/drivers/net/ethernet/netronome/nfp/nfd3/dp.c b/drivers/net/ethernet/netronome/nfp/nfd3/dp.c
new file mode 100644
index 000000000000..b2a34a09471b
--- /dev/null
+++ b/drivers/net/ethernet/netronome/nfp/nfd3/dp.c
@@ -0,0 +1,1368 @@
+// SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+/* Copyright (C) 2015-2019 Netronome Systems, Inc. */
+
+#include <linux/bpf_trace.h>
+#include <linux/netdevice.h>
+
+#include "../nfp_app.h"
+#include "../nfp_net.h"
+#include "../nfp_net_dp.h"
+#include "../nfp_net_xsk.h"
+#include "../crypto/crypto.h"
+#include "../crypto/fw.h"
+#include "nfd3.h"
+
+/* Transmit processing
+ *
+ * One queue controller peripheral queue is used for transmit.  The
+ * driver en-queues packets for transmit by advancing the write
+ * pointer.  The device indicates that packets have transmitted by
+ * advancing the read pointer.  The driver maintains a local copy of
+ * the read and write pointer in @struct nfp_net_tx_ring.  The driver
+ * keeps @wr_p in sync with the queue controller write pointer and can
+ * determine how many packets have been transmitted by comparing its
+ * copy of the read pointer @rd_p with the read pointer maintained by
+ * the queue controller peripheral.
+ */
+
+/* Wrappers for deciding when to stop and restart TX queues */
+static int nfp_nfd3_tx_ring_should_wake(struct nfp_net_tx_ring *tx_ring)
+{
+	return !nfp_net_tx_full(tx_ring, MAX_SKB_FRAGS * 4);
+}
+
+static int nfp_nfd3_tx_ring_should_stop(struct nfp_net_tx_ring *tx_ring)
+{
+	return nfp_net_tx_full(tx_ring, MAX_SKB_FRAGS + 1);
+}
+
+/**
+ * nfp_nfd3_tx_ring_stop() - stop tx ring
+ * @nd_q:    netdev queue
+ * @tx_ring: driver tx queue structure
+ *
+ * Safely stop TX ring.  Remember that while we are running .start_xmit()
+ * someone else may be cleaning the TX ring completions so we need to be
+ * extra careful here.
+ */
+static void
+nfp_nfd3_tx_ring_stop(struct netdev_queue *nd_q,
+		      struct nfp_net_tx_ring *tx_ring)
+{
+	netif_tx_stop_queue(nd_q);
+
+	/* We can race with the TX completion out of NAPI so recheck */
+	smp_mb();
+	if (unlikely(nfp_nfd3_tx_ring_should_wake(tx_ring)))
+		netif_tx_start_queue(nd_q);
+}
+
+/**
+ * nfp_nfd3_tx_tso() - Set up Tx descriptor for LSO
+ * @r_vec: per-ring structure
+ * @txbuf: Pointer to driver soft TX descriptor
+ * @txd: Pointer to HW TX descriptor
+ * @skb: Pointer to SKB
+ * @md_bytes: Prepend length
+ *
+ * Set up Tx descriptor for LSO, do nothing for non-LSO skbs.
+ * Return error on packet header greater than maximum supported LSO header size.
+ */
+static void
+nfp_nfd3_tx_tso(struct nfp_net_r_vector *r_vec, struct nfp_nfd3_tx_buf *txbuf,
+		struct nfp_nfd3_tx_desc *txd, struct sk_buff *skb, u32 md_bytes)
+{
+	u32 l3_offset, l4_offset, hdrlen;
+	u16 mss;
+
+	if (!skb_is_gso(skb))
+		return;
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
+	txbuf->pkt_cnt = skb_shinfo(skb)->gso_segs;
+	txbuf->real_len += hdrlen * (txbuf->pkt_cnt - 1);
+
+	mss = skb_shinfo(skb)->gso_size & NFD3_DESC_TX_MSS_MASK;
+	txd->l3_offset = l3_offset - md_bytes;
+	txd->l4_offset = l4_offset - md_bytes;
+	txd->lso_hdrlen = hdrlen - md_bytes;
+	txd->mss = cpu_to_le16(mss);
+	txd->flags |= NFD3_DESC_TX_LSO;
+
+	u64_stats_update_begin(&r_vec->tx_sync);
+	r_vec->tx_lso++;
+	u64_stats_update_end(&r_vec->tx_sync);
+}
+
+/**
+ * nfp_nfd3_tx_csum() - Set TX CSUM offload flags in TX descriptor
+ * @dp:  NFP Net data path struct
+ * @r_vec: per-ring structure
+ * @txbuf: Pointer to driver soft TX descriptor
+ * @txd: Pointer to TX descriptor
+ * @skb: Pointer to SKB
+ *
+ * This function sets the TX checksum flags in the TX descriptor based
+ * on the configuration and the protocol of the packet to be transmitted.
+ */
+static void
+nfp_nfd3_tx_csum(struct nfp_net_dp *dp, struct nfp_net_r_vector *r_vec,
+		 struct nfp_nfd3_tx_buf *txbuf, struct nfp_nfd3_tx_desc *txd,
+		 struct sk_buff *skb)
+{
+	struct ipv6hdr *ipv6h;
+	struct iphdr *iph;
+	u8 l4_hdr;
+
+	if (!(dp->ctrl & NFP_NET_CFG_CTRL_TXCSUM))
+		return;
+
+	if (skb->ip_summed != CHECKSUM_PARTIAL)
+		return;
+
+	txd->flags |= NFD3_DESC_TX_CSUM;
+	if (skb->encapsulation)
+		txd->flags |= NFD3_DESC_TX_ENCAP;
+
+	iph = skb->encapsulation ? inner_ip_hdr(skb) : ip_hdr(skb);
+	ipv6h = skb->encapsulation ? inner_ipv6_hdr(skb) : ipv6_hdr(skb);
+
+	if (iph->version == 4) {
+		txd->flags |= NFD3_DESC_TX_IP4_CSUM;
+		l4_hdr = iph->protocol;
+	} else if (ipv6h->version == 6) {
+		l4_hdr = ipv6h->nexthdr;
+	} else {
+		nn_dp_warn(dp, "partial checksum but ipv=%x!\n", iph->version);
+		return;
+	}
+
+	switch (l4_hdr) {
+	case IPPROTO_TCP:
+		txd->flags |= NFD3_DESC_TX_TCP_CSUM;
+		break;
+	case IPPROTO_UDP:
+		txd->flags |= NFD3_DESC_TX_UDP_CSUM;
+		break;
+	default:
+		nn_dp_warn(dp, "partial checksum but l4 proto=%x!\n", l4_hdr);
+		return;
+	}
+
+	u64_stats_update_begin(&r_vec->tx_sync);
+	if (skb->encapsulation)
+		r_vec->hw_csum_tx_inner += txbuf->pkt_cnt;
+	else
+		r_vec->hw_csum_tx += txbuf->pkt_cnt;
+	u64_stats_update_end(&r_vec->tx_sync);
+}
+
+static int nfp_nfd3_prep_tx_meta(struct sk_buff *skb, u64 tls_handle)
+{
+	struct metadata_dst *md_dst = skb_metadata_dst(skb);
+	unsigned char *data;
+	u32 meta_id = 0;
+	int md_bytes;
+
+	if (likely(!md_dst && !tls_handle))
+		return 0;
+	if (unlikely(md_dst && md_dst->type != METADATA_HW_PORT_MUX)) {
+		if (!tls_handle)
+			return 0;
+		md_dst = NULL;
+	}
+
+	md_bytes = 4 + !!md_dst * 4 + !!tls_handle * 8;
+
+	if (unlikely(skb_cow_head(skb, md_bytes)))
+		return -ENOMEM;
+
+	meta_id = 0;
+	data = skb_push(skb, md_bytes) + md_bytes;
+	if (md_dst) {
+		data -= 4;
+		put_unaligned_be32(md_dst->u.port_info.port_id, data);
+		meta_id = NFP_NET_META_PORTID;
+	}
+	if (tls_handle) {
+		/* conn handle is opaque, we just use u64 to be able to quickly
+		 * compare it to zero
+		 */
+		data -= 8;
+		memcpy(data, &tls_handle, sizeof(tls_handle));
+		meta_id <<= NFP_NET_META_FIELD_SIZE;
+		meta_id |= NFP_NET_META_CONN_HANDLE;
+	}
+
+	data -= 4;
+	put_unaligned_be32(meta_id, data);
+
+	return md_bytes;
+}
+
+/**
+ * nfp_nfd3_tx() - Main transmit entry point
+ * @skb:    SKB to transmit
+ * @netdev: netdev structure
+ *
+ * Return: NETDEV_TX_OK on success.
+ */
+netdev_tx_t nfp_nfd3_tx(struct sk_buff *skb, struct net_device *netdev)
+{
+	struct nfp_net *nn = netdev_priv(netdev);
+	int f, nr_frags, wr_idx, md_bytes;
+	struct nfp_net_tx_ring *tx_ring;
+	struct nfp_net_r_vector *r_vec;
+	struct nfp_nfd3_tx_buf *txbuf;
+	struct nfp_nfd3_tx_desc *txd;
+	struct netdev_queue *nd_q;
+	const skb_frag_t *frag;
+	struct nfp_net_dp *dp;
+	dma_addr_t dma_addr;
+	unsigned int fsize;
+	u64 tls_handle = 0;
+	u16 qidx;
+
+	dp = &nn->dp;
+	qidx = skb_get_queue_mapping(skb);
+	tx_ring = &dp->tx_rings[qidx];
+	r_vec = tx_ring->r_vec;
+
+	nr_frags = skb_shinfo(skb)->nr_frags;
+
+	if (unlikely(nfp_net_tx_full(tx_ring, nr_frags + 1))) {
+		nn_dp_warn(dp, "TX ring %d busy. wrp=%u rdp=%u\n",
+			   qidx, tx_ring->wr_p, tx_ring->rd_p);
+		nd_q = netdev_get_tx_queue(dp->netdev, qidx);
+		netif_tx_stop_queue(nd_q);
+		nfp_net_tx_xmit_more_flush(tx_ring);
+		u64_stats_update_begin(&r_vec->tx_sync);
+		r_vec->tx_busy++;
+		u64_stats_update_end(&r_vec->tx_sync);
+		return NETDEV_TX_BUSY;
+	}
+
+	skb = nfp_net_tls_tx(dp, r_vec, skb, &tls_handle, &nr_frags);
+	if (unlikely(!skb)) {
+		nfp_net_tx_xmit_more_flush(tx_ring);
+		return NETDEV_TX_OK;
+	}
+
+	md_bytes = nfp_nfd3_prep_tx_meta(skb, tls_handle);
+	if (unlikely(md_bytes < 0))
+		goto err_flush;
+
+	/* Start with the head skbuf */
+	dma_addr = dma_map_single(dp->dev, skb->data, skb_headlen(skb),
+				  DMA_TO_DEVICE);
+	if (dma_mapping_error(dp->dev, dma_addr))
+		goto err_dma_err;
+
+	wr_idx = D_IDX(tx_ring, tx_ring->wr_p);
+
+	/* Stash the soft descriptor of the head then initialize it */
+	txbuf = &tx_ring->txbufs[wr_idx];
+	txbuf->skb = skb;
+	txbuf->dma_addr = dma_addr;
+	txbuf->fidx = -1;
+	txbuf->pkt_cnt = 1;
+	txbuf->real_len = skb->len;
+
+	/* Build TX descriptor */
+	txd = &tx_ring->txds[wr_idx];
+	txd->offset_eop = (nr_frags ? 0 : NFD3_DESC_TX_EOP) | md_bytes;
+	txd->dma_len = cpu_to_le16(skb_headlen(skb));
+	nfp_desc_set_dma_addr(txd, dma_addr);
+	txd->data_len = cpu_to_le16(skb->len);
+
+	txd->flags = 0;
+	txd->mss = 0;
+	txd->lso_hdrlen = 0;
+
+	/* Do not reorder - tso may adjust pkt cnt, vlan may override fields */
+	nfp_nfd3_tx_tso(r_vec, txbuf, txd, skb, md_bytes);
+	nfp_nfd3_tx_csum(dp, r_vec, txbuf, txd, skb);
+	if (skb_vlan_tag_present(skb) && dp->ctrl & NFP_NET_CFG_CTRL_TXVLAN) {
+		txd->flags |= NFD3_DESC_TX_VLAN;
+		txd->vlan = cpu_to_le16(skb_vlan_tag_get(skb));
+	}
+
+	/* Gather DMA */
+	if (nr_frags > 0) {
+		__le64 second_half;
+
+		/* all descs must match except for in addr, length and eop */
+		second_half = txd->vals8[1];
+
+		for (f = 0; f < nr_frags; f++) {
+			frag = &skb_shinfo(skb)->frags[f];
+			fsize = skb_frag_size(frag);
+
+			dma_addr = skb_frag_dma_map(dp->dev, frag, 0,
+						    fsize, DMA_TO_DEVICE);
+			if (dma_mapping_error(dp->dev, dma_addr))
+				goto err_unmap;
+
+			wr_idx = D_IDX(tx_ring, wr_idx + 1);
+			tx_ring->txbufs[wr_idx].skb = skb;
+			tx_ring->txbufs[wr_idx].dma_addr = dma_addr;
+			tx_ring->txbufs[wr_idx].fidx = f;
+
+			txd = &tx_ring->txds[wr_idx];
+			txd->dma_len = cpu_to_le16(fsize);
+			nfp_desc_set_dma_addr(txd, dma_addr);
+			txd->offset_eop = md_bytes |
+				((f == nr_frags - 1) ? NFD3_DESC_TX_EOP : 0);
+			txd->vals8[1] = second_half;
+		}
+
+		u64_stats_update_begin(&r_vec->tx_sync);
+		r_vec->tx_gather++;
+		u64_stats_update_end(&r_vec->tx_sync);
+	}
+
+	skb_tx_timestamp(skb);
+
+	nd_q = netdev_get_tx_queue(dp->netdev, tx_ring->idx);
+
+	tx_ring->wr_p += nr_frags + 1;
+	if (nfp_nfd3_tx_ring_should_stop(tx_ring))
+		nfp_nfd3_tx_ring_stop(nd_q, tx_ring);
+
+	tx_ring->wr_ptr_add += nr_frags + 1;
+	if (__netdev_tx_sent_queue(nd_q, txbuf->real_len, netdev_xmit_more()))
+		nfp_net_tx_xmit_more_flush(tx_ring);
+
+	return NETDEV_TX_OK;
+
+err_unmap:
+	while (--f >= 0) {
+		frag = &skb_shinfo(skb)->frags[f];
+		dma_unmap_page(dp->dev, tx_ring->txbufs[wr_idx].dma_addr,
+			       skb_frag_size(frag), DMA_TO_DEVICE);
+		tx_ring->txbufs[wr_idx].skb = NULL;
+		tx_ring->txbufs[wr_idx].dma_addr = 0;
+		tx_ring->txbufs[wr_idx].fidx = -2;
+		wr_idx = wr_idx - 1;
+		if (wr_idx < 0)
+			wr_idx += tx_ring->cnt;
+	}
+	dma_unmap_single(dp->dev, tx_ring->txbufs[wr_idx].dma_addr,
+			 skb_headlen(skb), DMA_TO_DEVICE);
+	tx_ring->txbufs[wr_idx].skb = NULL;
+	tx_ring->txbufs[wr_idx].dma_addr = 0;
+	tx_ring->txbufs[wr_idx].fidx = -2;
+err_dma_err:
+	nn_dp_warn(dp, "Failed to map DMA TX buffer\n");
+err_flush:
+	nfp_net_tx_xmit_more_flush(tx_ring);
+	u64_stats_update_begin(&r_vec->tx_sync);
+	r_vec->tx_errors++;
+	u64_stats_update_end(&r_vec->tx_sync);
+	nfp_net_tls_tx_undo(skb, tls_handle);
+	dev_kfree_skb_any(skb);
+	return NETDEV_TX_OK;
+}
+
+/**
+ * nfp_nfd3_tx_complete() - Handled completed TX packets
+ * @tx_ring:	TX ring structure
+ * @budget:	NAPI budget (only used as bool to determine if in NAPI context)
+ */
+void nfp_nfd3_tx_complete(struct nfp_net_tx_ring *tx_ring, int budget)
+{
+	struct nfp_net_r_vector *r_vec = tx_ring->r_vec;
+	struct nfp_net_dp *dp = &r_vec->nfp_net->dp;
+	u32 done_pkts = 0, done_bytes = 0;
+	struct netdev_queue *nd_q;
+	u32 qcp_rd_p;
+	int todo;
+
+	if (tx_ring->wr_p == tx_ring->rd_p)
+		return;
+
+	/* Work out how many descriptors have been transmitted */
+	qcp_rd_p = nfp_qcp_rd_ptr_read(tx_ring->qcp_q);
+
+	if (qcp_rd_p == tx_ring->qcp_rd_p)
+		return;
+
+	todo = D_IDX(tx_ring, qcp_rd_p - tx_ring->qcp_rd_p);
+
+	while (todo--) {
+		const skb_frag_t *frag;
+		struct nfp_nfd3_tx_buf *tx_buf;
+		struct sk_buff *skb;
+		int fidx, nr_frags;
+		int idx;
+
+		idx = D_IDX(tx_ring, tx_ring->rd_p++);
+		tx_buf = &tx_ring->txbufs[idx];
+
+		skb = tx_buf->skb;
+		if (!skb)
+			continue;
+
+		nr_frags = skb_shinfo(skb)->nr_frags;
+		fidx = tx_buf->fidx;
+
+		if (fidx == -1) {
+			/* unmap head */
+			dma_unmap_single(dp->dev, tx_buf->dma_addr,
+					 skb_headlen(skb), DMA_TO_DEVICE);
+
+			done_pkts += tx_buf->pkt_cnt;
+			done_bytes += tx_buf->real_len;
+		} else {
+			/* unmap fragment */
+			frag = &skb_shinfo(skb)->frags[fidx];
+			dma_unmap_page(dp->dev, tx_buf->dma_addr,
+				       skb_frag_size(frag), DMA_TO_DEVICE);
+		}
+
+		/* check for last gather fragment */
+		if (fidx == nr_frags - 1)
+			napi_consume_skb(skb, budget);
+
+		tx_buf->dma_addr = 0;
+		tx_buf->skb = NULL;
+		tx_buf->fidx = -2;
+	}
+
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
+	if (nfp_nfd3_tx_ring_should_wake(tx_ring)) {
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
+static bool nfp_nfd3_xdp_complete(struct nfp_net_tx_ring *tx_ring)
+{
+	struct nfp_net_r_vector *r_vec = tx_ring->r_vec;
+	u32 done_pkts = 0, done_bytes = 0;
+	bool done_all;
+	int idx, todo;
+	u32 qcp_rd_p;
+
+	/* Work out how many descriptors have been transmitted */
+	qcp_rd_p = nfp_qcp_rd_ptr_read(tx_ring->qcp_q);
+
+	if (qcp_rd_p == tx_ring->qcp_rd_p)
+		return true;
+
+	todo = D_IDX(tx_ring, qcp_rd_p - tx_ring->qcp_rd_p);
+
+	done_all = todo <= NFP_NET_XDP_MAX_COMPLETE;
+	todo = min(todo, NFP_NET_XDP_MAX_COMPLETE);
+
+	tx_ring->qcp_rd_p = D_IDX(tx_ring, tx_ring->qcp_rd_p + todo);
+
+	done_pkts = todo;
+	while (todo--) {
+		idx = D_IDX(tx_ring, tx_ring->rd_p);
+		tx_ring->rd_p++;
+
+		done_bytes += tx_ring->txbufs[idx].real_len;
+	}
+
+	u64_stats_update_begin(&r_vec->tx_sync);
+	r_vec->tx_bytes += done_bytes;
+	r_vec->tx_pkts += done_pkts;
+	u64_stats_update_end(&r_vec->tx_sync);
+
+	WARN_ONCE(tx_ring->wr_p - tx_ring->rd_p > tx_ring->cnt,
+		  "XDP TX ring corruption rd_p=%u wr_p=%u cnt=%u\n",
+		  tx_ring->rd_p, tx_ring->wr_p, tx_ring->cnt);
+
+	return done_all;
+}
+
+/* Receive processing
+ */
+
+static void *
+nfp_nfd3_napi_alloc_one(struct nfp_net_dp *dp, dma_addr_t *dma_addr)
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
+ * nfp_nfd3_rx_give_one() - Put mapped skb on the software and hardware rings
+ * @dp:		NFP Net data path struct
+ * @rx_ring:	RX ring structure
+ * @frag:	page fragment buffer
+ * @dma_addr:	DMA address of skb mapping
+ */
+static void
+nfp_nfd3_rx_give_one(const struct nfp_net_dp *dp,
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
+ * nfp_nfd3_rx_ring_fill_freelist() - Give buffers from the ring to FW
+ * @dp:	     NFP Net data path struct
+ * @rx_ring: RX ring to fill
+ */
+void nfp_nfd3_rx_ring_fill_freelist(struct nfp_net_dp *dp,
+				    struct nfp_net_rx_ring *rx_ring)
+{
+	unsigned int i;
+
+	if (nfp_net_has_xsk_pool_slow(dp, rx_ring->idx))
+		return nfp_net_xsk_rx_ring_fill_freelist(rx_ring);
+
+	for (i = 0; i < rx_ring->cnt - 1; i++)
+		nfp_nfd3_rx_give_one(dp, rx_ring, rx_ring->rxbufs[i].frag,
+				     rx_ring->rxbufs[i].dma_addr);
+}
+
+/**
+ * nfp_nfd3_rx_csum_has_errors() - group check if rxd has any csum errors
+ * @flags: RX descriptor flags field in CPU byte order
+ */
+static int nfp_nfd3_rx_csum_has_errors(u16 flags)
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
+ * nfp_nfd3_rx_csum() - set SKB checksum field based on RX descriptor flags
+ * @dp:  NFP Net data path struct
+ * @r_vec: per-ring structure
+ * @rxd: Pointer to RX descriptor
+ * @meta: Parsed metadata prepend
+ * @skb: Pointer to SKB
+ */
+void
+nfp_nfd3_rx_csum(const struct nfp_net_dp *dp, struct nfp_net_r_vector *r_vec,
+		 const struct nfp_net_rx_desc *rxd,
+		 const struct nfp_meta_parsed *meta, struct sk_buff *skb)
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
+	if (nfp_nfd3_rx_csum_has_errors(le16_to_cpu(rxd->rxd.flags))) {
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
+nfp_nfd3_set_hash(struct net_device *netdev, struct nfp_meta_parsed *meta,
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
+static void
+nfp_nfd3_set_hash_desc(struct net_device *netdev, struct nfp_meta_parsed *meta,
+		       void *data, struct nfp_net_rx_desc *rxd)
+{
+	struct nfp_net_rx_hash *rx_hash = data;
+
+	if (!(rxd->rxd.flags & PCIE_DESC_RX_RSS))
+		return;
+
+	nfp_nfd3_set_hash(netdev, meta, get_unaligned_be32(&rx_hash->hash_type),
+			  &rx_hash->hash);
+}
+
+bool
+nfp_nfd3_parse_meta(struct net_device *netdev, struct nfp_meta_parsed *meta,
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
+			nfp_nfd3_set_hash(netdev, meta,
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
+nfp_nfd3_rx_drop(const struct nfp_net_dp *dp, struct nfp_net_r_vector *r_vec,
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
+		nfp_nfd3_rx_give_one(dp, rx_ring, rxbuf->frag, rxbuf->dma_addr);
+	if (skb)
+		dev_kfree_skb_any(skb);
+}
+
+static bool
+nfp_nfd3_tx_xdp_buf(struct nfp_net_dp *dp, struct nfp_net_rx_ring *rx_ring,
+		    struct nfp_net_tx_ring *tx_ring,
+		    struct nfp_net_rx_buf *rxbuf, unsigned int dma_off,
+		    unsigned int pkt_len, bool *completed)
+{
+	unsigned int dma_map_sz = dp->fl_bufsz - NFP_NET_RX_BUF_NON_DATA;
+	struct nfp_nfd3_tx_buf *txbuf;
+	struct nfp_nfd3_tx_desc *txd;
+	int wr_idx;
+
+	/* Reject if xdp_adjust_tail grow packet beyond DMA area */
+	if (pkt_len + dma_off > dma_map_sz)
+		return false;
+
+	if (unlikely(nfp_net_tx_full(tx_ring, 1))) {
+		if (!*completed) {
+			nfp_nfd3_xdp_complete(tx_ring);
+			*completed = true;
+		}
+
+		if (unlikely(nfp_net_tx_full(tx_ring, 1))) {
+			nfp_nfd3_rx_drop(dp, rx_ring->r_vec, rx_ring, rxbuf,
+					 NULL);
+			return false;
+		}
+	}
+
+	wr_idx = D_IDX(tx_ring, tx_ring->wr_p);
+
+	/* Stash the soft descriptor of the head then initialize it */
+	txbuf = &tx_ring->txbufs[wr_idx];
+
+	nfp_nfd3_rx_give_one(dp, rx_ring, txbuf->frag, txbuf->dma_addr);
+
+	txbuf->frag = rxbuf->frag;
+	txbuf->dma_addr = rxbuf->dma_addr;
+	txbuf->fidx = -1;
+	txbuf->pkt_cnt = 1;
+	txbuf->real_len = pkt_len;
+
+	dma_sync_single_for_device(dp->dev, rxbuf->dma_addr + dma_off,
+				   pkt_len, DMA_BIDIRECTIONAL);
+
+	/* Build TX descriptor */
+	txd = &tx_ring->txds[wr_idx];
+	txd->offset_eop = NFD3_DESC_TX_EOP;
+	txd->dma_len = cpu_to_le16(pkt_len);
+	nfp_desc_set_dma_addr(txd, rxbuf->dma_addr + dma_off);
+	txd->data_len = cpu_to_le16(pkt_len);
+
+	txd->flags = 0;
+	txd->mss = 0;
+	txd->lso_hdrlen = 0;
+
+	tx_ring->wr_p++;
+	tx_ring->wr_ptr_add++;
+	return true;
+}
+
+/**
+ * nfp_nfd3_rx() - receive up to @budget packets on @rx_ring
+ * @rx_ring:   RX ring to receive from
+ * @budget:    NAPI budget
+ *
+ * Note, this function is separated out from the napi poll function to
+ * more cleanly separate packet receive code from other bookkeeping
+ * functions performed in the napi poll function.
+ *
+ * Return: Number of packets received.
+ */
+static int nfp_nfd3_rx(struct nfp_net_rx_ring *rx_ring, int budget)
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
+			nfp_nfd3_rx_drop(dp, r_vec, rx_ring, rxbuf, NULL);
+			continue;
+		}
+
+		nfp_net_dma_sync_cpu_rx(dp, rxbuf->dma_addr + meta_off,
+					data_len);
+
+		if (!dp->chained_metadata_format) {
+			nfp_nfd3_set_hash_desc(dp->netdev, &meta,
+					       rxbuf->frag + meta_off, rxd);
+		} else if (meta_len) {
+			if (unlikely(nfp_nfd3_parse_meta(dp->netdev, &meta,
+							 rxbuf->frag + meta_off,
+							 rxbuf->frag + pkt_off,
+							 pkt_len, meta_len))) {
+				nn_dp_warn(dp, "invalid RX packet metadata\n");
+				nfp_nfd3_rx_drop(dp, r_vec, rx_ring, rxbuf,
+						 NULL);
+				continue;
+			}
+		}
+
+		if (xdp_prog && !meta.portid) {
+			void *orig_data = rxbuf->frag + pkt_off;
+			unsigned int dma_off;
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
+			case XDP_TX:
+				dma_off = pkt_off - NFP_NET_RX_BUF_HEADROOM;
+				if (unlikely(!nfp_nfd3_tx_xdp_buf(dp, rx_ring,
+								  tx_ring,
+								  rxbuf,
+								  dma_off,
+								  pkt_len,
+								  &xdp_tx_cmpl)))
+					trace_xdp_exception(dp->netdev,
+							    xdp_prog, act);
+				continue;
+			default:
+				bpf_warn_invalid_xdp_action(dp->netdev, xdp_prog, act);
+				fallthrough;
+			case XDP_ABORTED:
+				trace_xdp_exception(dp->netdev, xdp_prog, act);
+				fallthrough;
+			case XDP_DROP:
+				nfp_nfd3_rx_give_one(dp, rx_ring, rxbuf->frag,
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
+			nfp_nfd3_rx_give_one(dp, rx_ring, rxbuf->frag,
+					     rxbuf->dma_addr);
+			continue;
+		} else {
+			struct nfp_net *nn;
+
+			nn = netdev_priv(dp->netdev);
+			netdev = nfp_app_dev_get(nn->app, meta.portid,
+						 &redir_egress);
+			if (unlikely(!netdev)) {
+				nfp_nfd3_rx_drop(dp, r_vec, rx_ring, rxbuf,
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
+			nfp_nfd3_rx_drop(dp, r_vec, rx_ring, rxbuf, NULL);
+			continue;
+		}
+		new_frag = nfp_nfd3_napi_alloc_one(dp, &new_dma_addr);
+		if (unlikely(!new_frag)) {
+			nfp_nfd3_rx_drop(dp, r_vec, rx_ring, rxbuf, skb);
+			continue;
+		}
+
+		nfp_net_dma_unmap_rx(dp, rxbuf->dma_addr);
+
+		nfp_nfd3_rx_give_one(dp, rx_ring, new_frag, new_dma_addr);
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
+		nfp_nfd3_rx_csum(dp, r_vec, rxd, &meta, skb);
+
+#ifdef CONFIG_TLS_DEVICE
+		if (rxd->rxd.flags & PCIE_DESC_RX_DECRYPTED) {
+			skb->decrypted = true;
+			u64_stats_update_begin(&r_vec->rx_sync);
+			r_vec->hw_tls_rx++;
+			u64_stats_update_end(&r_vec->rx_sync);
+		}
+#endif
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
+			if (!nfp_nfd3_xdp_complete(tx_ring))
+				pkts_polled = budget;
+	}
+
+	return pkts_polled;
+}
+
+/**
+ * nfp_nfd3_poll() - napi poll function
+ * @napi:    NAPI structure
+ * @budget:  NAPI budget
+ *
+ * Return: number of packets polled.
+ */
+int nfp_nfd3_poll(struct napi_struct *napi, int budget)
+{
+	struct nfp_net_r_vector *r_vec =
+		container_of(napi, struct nfp_net_r_vector, napi);
+	unsigned int pkts_polled = 0;
+
+	if (r_vec->tx_ring)
+		nfp_nfd3_tx_complete(r_vec->tx_ring, budget);
+	if (r_vec->rx_ring)
+		pkts_polled = nfp_nfd3_rx(r_vec->rx_ring, budget);
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
+static bool
+nfp_ctrl_tx_one(struct nfp_net *nn, struct nfp_net_r_vector *r_vec,
+		struct sk_buff *skb, bool old)
+{
+	unsigned int real_len = skb->len, meta_len = 0;
+	struct nfp_net_tx_ring *tx_ring;
+	struct nfp_nfd3_tx_buf *txbuf;
+	struct nfp_nfd3_tx_desc *txd;
+	struct nfp_net_dp *dp;
+	dma_addr_t dma_addr;
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
+	if (unlikely(nfp_net_tx_full(tx_ring, 1))) {
+		u64_stats_update_begin(&r_vec->tx_sync);
+		r_vec->tx_busy++;
+		u64_stats_update_end(&r_vec->tx_sync);
+		if (!old)
+			__skb_queue_tail(&r_vec->queue, skb);
+		else
+			__skb_queue_head(&r_vec->queue, skb);
+		return true;
+	}
+
+	if (nfp_app_ctrl_has_meta(nn->app)) {
+		if (unlikely(skb_headroom(skb) < 8)) {
+			nn_dp_warn(dp, "CTRL TX on skb without headroom\n");
+			goto err_free;
+		}
+		meta_len = 8;
+		put_unaligned_be32(NFP_META_PORT_ID_CTRL, skb_push(skb, 4));
+		put_unaligned_be32(NFP_NET_META_PORTID, skb_push(skb, 4));
+	}
+
+	/* Start with the head skbuf */
+	dma_addr = dma_map_single(dp->dev, skb->data, skb_headlen(skb),
+				  DMA_TO_DEVICE);
+	if (dma_mapping_error(dp->dev, dma_addr))
+		goto err_dma_warn;
+
+	wr_idx = D_IDX(tx_ring, tx_ring->wr_p);
+
+	/* Stash the soft descriptor of the head then initialize it */
+	txbuf = &tx_ring->txbufs[wr_idx];
+	txbuf->skb = skb;
+	txbuf->dma_addr = dma_addr;
+	txbuf->fidx = -1;
+	txbuf->pkt_cnt = 1;
+	txbuf->real_len = real_len;
+
+	/* Build TX descriptor */
+	txd = &tx_ring->txds[wr_idx];
+	txd->offset_eop = meta_len | NFD3_DESC_TX_EOP;
+	txd->dma_len = cpu_to_le16(skb_headlen(skb));
+	nfp_desc_set_dma_addr(txd, dma_addr);
+	txd->data_len = cpu_to_le16(skb->len);
+
+	txd->flags = 0;
+	txd->mss = 0;
+	txd->lso_hdrlen = 0;
+
+	tx_ring->wr_p++;
+	tx_ring->wr_ptr_add++;
+	nfp_net_tx_xmit_more_flush(tx_ring);
+
+	return false;
+
+err_dma_warn:
+	nn_dp_warn(dp, "Failed to DMA map TX CTRL buffer\n");
+err_free:
+	u64_stats_update_begin(&r_vec->tx_sync);
+	r_vec->tx_errors++;
+	u64_stats_update_end(&r_vec->tx_sync);
+	dev_kfree_skb_any(skb);
+	return false;
+}
+
+bool __nfp_nfd3_ctrl_tx(struct nfp_net *nn, struct sk_buff *skb)
+{
+	struct nfp_net_r_vector *r_vec = &nn->r_vecs[0];
+
+	return nfp_ctrl_tx_one(nn, r_vec, skb, false);
+}
+
+bool nfp_nfd3_ctrl_tx(struct nfp_net *nn, struct sk_buff *skb)
+{
+	struct nfp_net_r_vector *r_vec = &nn->r_vecs[0];
+	bool ret;
+
+	spin_lock_bh(&r_vec->lock);
+	ret = nfp_ctrl_tx_one(nn, r_vec, skb, false);
+	spin_unlock_bh(&r_vec->lock);
+
+	return ret;
+}
+
+static void __nfp_ctrl_tx_queued(struct nfp_net_r_vector *r_vec)
+{
+	struct sk_buff *skb;
+
+	while ((skb = __skb_dequeue(&r_vec->queue)))
+		if (nfp_ctrl_tx_one(r_vec->nfp_net, r_vec, skb, true))
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
+		nfp_nfd3_rx_drop(dp, r_vec, rx_ring, rxbuf, NULL);
+		return true;
+	}
+
+	skb = build_skb(rxbuf->frag, dp->fl_bufsz);
+	if (unlikely(!skb)) {
+		nfp_nfd3_rx_drop(dp, r_vec, rx_ring, rxbuf, NULL);
+		return true;
+	}
+	new_frag = nfp_nfd3_napi_alloc_one(dp, &new_dma_addr);
+	if (unlikely(!new_frag)) {
+		nfp_nfd3_rx_drop(dp, r_vec, rx_ring, rxbuf, skb);
+		return true;
+	}
+
+	nfp_net_dma_unmap_rx(dp, rxbuf->dma_addr);
+
+	nfp_nfd3_rx_give_one(dp, rx_ring, new_frag, new_dma_addr);
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
+void nfp_nfd3_ctrl_poll(struct tasklet_struct *t)
+{
+	struct nfp_net_r_vector *r_vec = from_tasklet(r_vec, t, tasklet);
+
+	spin_lock(&r_vec->lock);
+	nfp_nfd3_tx_complete(r_vec->tx_ring, 0);
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
diff --git a/drivers/net/ethernet/netronome/nfp/nfd3/nfd3.h b/drivers/net/ethernet/netronome/nfp/nfd3/nfd3.h
new file mode 100644
index 000000000000..0bd597ad6c6e
--- /dev/null
+++ b/drivers/net/ethernet/netronome/nfp/nfd3/nfd3.h
@@ -0,0 +1,126 @@
+/* SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause) */
+/* Copyright (C) 2015-2019 Netronome Systems, Inc. */
+
+#ifndef _NFP_DP_NFD3_H_
+#define _NFP_DP_NFD3_H_
+
+struct sk_buff;
+struct net_device;
+
+/* TX descriptor format */
+
+#define NFD3_DESC_TX_EOP		BIT(7)
+#define NFD3_DESC_TX_OFFSET_MASK	GENMASK(6, 0)
+#define NFD3_DESC_TX_MSS_MASK		GENMASK(13, 0)
+
+/* Flags in the host TX descriptor */
+#define NFD3_DESC_TX_CSUM		BIT(7)
+#define NFD3_DESC_TX_IP4_CSUM		BIT(6)
+#define NFD3_DESC_TX_TCP_CSUM		BIT(5)
+#define NFD3_DESC_TX_UDP_CSUM		BIT(4)
+#define NFD3_DESC_TX_VLAN		BIT(3)
+#define NFD3_DESC_TX_LSO		BIT(2)
+#define NFD3_DESC_TX_ENCAP		BIT(1)
+#define NFD3_DESC_TX_O_IP4_CSUM	BIT(0)
+
+struct nfp_nfd3_tx_desc {
+	union {
+		struct {
+			u8 dma_addr_hi; /* High bits of host buf address */
+			__le16 dma_len;	/* Length to DMA for this desc */
+			u8 offset_eop;	/* Offset in buf where pkt starts +
+					 * highest bit is eop flag.
+					 */
+			__le32 dma_addr_lo; /* Low 32bit of host buf addr */
+
+			__le16 mss;	/* MSS to be used for LSO */
+			u8 lso_hdrlen;	/* LSO, TCP payload offset */
+			u8 flags;	/* TX Flags, see @NFD3_DESC_TX_* */
+			union {
+				struct {
+					u8 l3_offset; /* L3 header offset */
+					u8 l4_offset; /* L4 header offset */
+				};
+				__le16 vlan; /* VLAN tag to add if indicated */
+			};
+			__le16 data_len; /* Length of frame + meta data */
+		} __packed;
+		__le32 vals[4];
+		__le64 vals8[2];
+	};
+};
+
+/**
+ * struct nfp_nfd3_tx_buf - software TX buffer descriptor
+ * @skb:	normal ring, sk_buff associated with this buffer
+ * @frag:	XDP ring, page frag associated with this buffer
+ * @xdp:	XSK buffer pool handle (for AF_XDP)
+ * @dma_addr:	DMA mapping address of the buffer
+ * @fidx:	Fragment index (-1 for the head and [0..nr_frags-1] for frags)
+ * @pkt_cnt:	Number of packets to be produced out of the skb associated
+ *		with this buffer (valid only on the head's buffer).
+ *		Will be 1 for all non-TSO packets.
+ * @is_xsk_tx:	Flag if buffer is a RX buffer after a XDP_TX action and not a
+ *		buffer from the TX queue (for AF_XDP).
+ * @real_len:	Number of bytes which to be produced out of the skb (valid only
+ *		on the head's buffer). Equal to skb->len for non-TSO packets.
+ */
+struct nfp_nfd3_tx_buf {
+	union {
+		struct sk_buff *skb;
+		void *frag;
+		struct xdp_buff *xdp;
+	};
+	dma_addr_t dma_addr;
+	union {
+		struct {
+			short int fidx;
+			u16 pkt_cnt;
+		};
+		struct {
+			bool is_xsk_tx;
+		};
+	};
+	u32 real_len;
+};
+
+void
+nfp_nfd3_rx_csum(const struct nfp_net_dp *dp, struct nfp_net_r_vector *r_vec,
+		 const struct nfp_net_rx_desc *rxd,
+		 const struct nfp_meta_parsed *meta, struct sk_buff *skb);
+bool
+nfp_nfd3_parse_meta(struct net_device *netdev, struct nfp_meta_parsed *meta,
+		    void *data, void *pkt, unsigned int pkt_len, int meta_len);
+void nfp_nfd3_tx_complete(struct nfp_net_tx_ring *tx_ring, int budget);
+int nfp_nfd3_poll(struct napi_struct *napi, int budget);
+void nfp_nfd3_ctrl_poll(struct tasklet_struct *t);
+void nfp_nfd3_rx_ring_fill_freelist(struct nfp_net_dp *dp,
+				    struct nfp_net_rx_ring *rx_ring);
+void nfp_nfd3_xsk_tx_free(struct nfp_nfd3_tx_buf *txbuf);
+int nfp_nfd3_xsk_poll(struct napi_struct *napi, int budget);
+
+void
+nfp_nfd3_tx_ring_reset(struct nfp_net_dp *dp, struct nfp_net_tx_ring *tx_ring);
+void
+nfp_nfd3_rx_ring_fill_freelist(struct nfp_net_dp *dp,
+			       struct nfp_net_rx_ring *rx_ring);
+int
+nfp_nfd3_tx_ring_alloc(struct nfp_net_dp *dp, struct nfp_net_tx_ring *tx_ring);
+void
+nfp_nfd3_tx_ring_free(struct nfp_net_tx_ring *tx_ring);
+int
+nfp_nfd3_tx_ring_bufs_alloc(struct nfp_net_dp *dp,
+			    struct nfp_net_tx_ring *tx_ring);
+void
+nfp_nfd3_tx_ring_bufs_free(struct nfp_net_dp *dp,
+			   struct nfp_net_tx_ring *tx_ring);
+void
+nfp_nfd3_print_tx_descs(struct seq_file *file,
+			struct nfp_net_r_vector *r_vec,
+			struct nfp_net_tx_ring *tx_ring,
+			u32 d_rd_p, u32 d_wr_p);
+netdev_tx_t nfp_nfd3_tx(struct sk_buff *skb, struct net_device *netdev);
+bool nfp_nfd3_ctrl_tx(struct nfp_net *nn, struct sk_buff *skb);
+bool __nfp_nfd3_ctrl_tx(struct nfp_net *nn, struct sk_buff *skb);
+
+#endif
diff --git a/drivers/net/ethernet/netronome/nfp/nfd3/rings.c b/drivers/net/ethernet/netronome/nfp/nfd3/rings.c
new file mode 100644
index 000000000000..4c6aaebb7522
--- /dev/null
+++ b/drivers/net/ethernet/netronome/nfp/nfd3/rings.c
@@ -0,0 +1,243 @@
+// SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+/* Copyright (C) 2015-2019 Netronome Systems, Inc. */
+
+#include <linux/seq_file.h>
+
+#include "../nfp_net.h"
+#include "../nfp_net_dp.h"
+#include "../nfp_net_xsk.h"
+#include "nfd3.h"
+
+static void nfp_nfd3_xsk_tx_bufs_free(struct nfp_net_tx_ring *tx_ring)
+{
+	struct nfp_nfd3_tx_buf *txbuf;
+	unsigned int idx;
+
+	while (tx_ring->rd_p != tx_ring->wr_p) {
+		idx = D_IDX(tx_ring, tx_ring->rd_p);
+		txbuf = &tx_ring->txbufs[idx];
+
+		txbuf->real_len = 0;
+
+		tx_ring->qcp_rd_p++;
+		tx_ring->rd_p++;
+
+		if (tx_ring->r_vec->xsk_pool) {
+			if (txbuf->is_xsk_tx)
+				nfp_nfd3_xsk_tx_free(txbuf);
+
+			xsk_tx_completed(tx_ring->r_vec->xsk_pool, 1);
+		}
+	}
+}
+
+/**
+ * nfp_nfd3_tx_ring_reset() - Free any untransmitted buffers and reset pointers
+ * @dp:		NFP Net data path struct
+ * @tx_ring:	TX ring structure
+ *
+ * Assumes that the device is stopped, must be idempotent.
+ */
+void
+nfp_nfd3_tx_ring_reset(struct nfp_net_dp *dp, struct nfp_net_tx_ring *tx_ring)
+{
+	struct netdev_queue *nd_q;
+	const skb_frag_t *frag;
+
+	while (!tx_ring->is_xdp && tx_ring->rd_p != tx_ring->wr_p) {
+		struct nfp_nfd3_tx_buf *tx_buf;
+		struct sk_buff *skb;
+		int idx, nr_frags;
+
+		idx = D_IDX(tx_ring, tx_ring->rd_p);
+		tx_buf = &tx_ring->txbufs[idx];
+
+		skb = tx_ring->txbufs[idx].skb;
+		nr_frags = skb_shinfo(skb)->nr_frags;
+
+		if (tx_buf->fidx == -1) {
+			/* unmap head */
+			dma_unmap_single(dp->dev, tx_buf->dma_addr,
+					 skb_headlen(skb), DMA_TO_DEVICE);
+		} else {
+			/* unmap fragment */
+			frag = &skb_shinfo(skb)->frags[tx_buf->fidx];
+			dma_unmap_page(dp->dev, tx_buf->dma_addr,
+				       skb_frag_size(frag), DMA_TO_DEVICE);
+		}
+
+		/* check for last gather fragment */
+		if (tx_buf->fidx == nr_frags - 1)
+			dev_kfree_skb_any(skb);
+
+		tx_buf->dma_addr = 0;
+		tx_buf->skb = NULL;
+		tx_buf->fidx = -2;
+
+		tx_ring->qcp_rd_p++;
+		tx_ring->rd_p++;
+	}
+
+	if (tx_ring->is_xdp)
+		nfp_nfd3_xsk_tx_bufs_free(tx_ring);
+
+	memset(tx_ring->txds, 0, tx_ring->size);
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
+/**
+ * nfp_nfd3_tx_ring_free() - Free resources allocated to a TX ring
+ * @tx_ring:   TX ring to free
+ */
+void nfp_nfd3_tx_ring_free(struct nfp_net_tx_ring *tx_ring)
+{
+	struct nfp_net_r_vector *r_vec = tx_ring->r_vec;
+	struct nfp_net_dp *dp = &r_vec->nfp_net->dp;
+
+	kvfree(tx_ring->txbufs);
+
+	if (tx_ring->txds)
+		dma_free_coherent(dp->dev, tx_ring->size,
+				  tx_ring->txds, tx_ring->dma);
+
+	tx_ring->cnt = 0;
+	tx_ring->txbufs = NULL;
+	tx_ring->txds = NULL;
+	tx_ring->dma = 0;
+	tx_ring->size = 0;
+}
+
+/**
+ * nfp_nfd3_tx_ring_alloc() - Allocate resource for a TX ring
+ * @dp:        NFP Net data path struct
+ * @tx_ring:   TX Ring structure to allocate
+ *
+ * Return: 0 on success, negative errno otherwise.
+ */
+int
+nfp_nfd3_tx_ring_alloc(struct nfp_net_dp *dp, struct nfp_net_tx_ring *tx_ring)
+{
+	struct nfp_net_r_vector *r_vec = tx_ring->r_vec;
+
+	tx_ring->cnt = dp->txd_cnt;
+
+	tx_ring->size = array_size(tx_ring->cnt, sizeof(*tx_ring->txds));
+	tx_ring->txds = dma_alloc_coherent(dp->dev, tx_ring->size,
+					   &tx_ring->dma,
+					   GFP_KERNEL | __GFP_NOWARN);
+	if (!tx_ring->txds) {
+		netdev_warn(dp->netdev, "failed to allocate TX descriptor ring memory, requested descriptor count: %d, consider lowering descriptor count\n",
+			    tx_ring->cnt);
+		goto err_alloc;
+	}
+
+	tx_ring->txbufs = kvcalloc(tx_ring->cnt, sizeof(*tx_ring->txbufs),
+				   GFP_KERNEL);
+	if (!tx_ring->txbufs)
+		goto err_alloc;
+
+	if (!tx_ring->is_xdp && dp->netdev)
+		netif_set_xps_queue(dp->netdev, &r_vec->affinity_mask,
+				    tx_ring->idx);
+
+	return 0;
+
+err_alloc:
+	nfp_nfd3_tx_ring_free(tx_ring);
+	return -ENOMEM;
+}
+
+void
+nfp_nfd3_tx_ring_bufs_free(struct nfp_net_dp *dp,
+			   struct nfp_net_tx_ring *tx_ring)
+{
+	unsigned int i;
+
+	if (!tx_ring->is_xdp)
+		return;
+
+	for (i = 0; i < tx_ring->cnt; i++) {
+		if (!tx_ring->txbufs[i].frag)
+			return;
+
+		nfp_net_dma_unmap_rx(dp, tx_ring->txbufs[i].dma_addr);
+		__free_page(virt_to_page(tx_ring->txbufs[i].frag));
+	}
+}
+
+int
+nfp_nfd3_tx_ring_bufs_alloc(struct nfp_net_dp *dp,
+			    struct nfp_net_tx_ring *tx_ring)
+{
+	struct nfp_nfd3_tx_buf *txbufs = tx_ring->txbufs;
+	unsigned int i;
+
+	if (!tx_ring->is_xdp)
+		return 0;
+
+	for (i = 0; i < tx_ring->cnt; i++) {
+		txbufs[i].frag = nfp_net_rx_alloc_one(dp, &txbufs[i].dma_addr);
+		if (!txbufs[i].frag) {
+			nfp_nfd3_tx_ring_bufs_free(dp, tx_ring);
+			return -ENOMEM;
+		}
+	}
+
+	return 0;
+}
+
+void
+nfp_nfd3_print_tx_descs(struct seq_file *file,
+			struct nfp_net_r_vector *r_vec,
+			struct nfp_net_tx_ring *tx_ring,
+			u32 d_rd_p, u32 d_wr_p)
+{
+	struct nfp_nfd3_tx_desc *txd;
+	u32 txd_cnt = tx_ring->cnt;
+	int i;
+
+	for (i = 0; i < txd_cnt; i++) {
+		struct xdp_buff *xdp;
+		struct sk_buff *skb;
+
+		txd = &tx_ring->txds[i];
+		seq_printf(file, "%04d: 0x%08x 0x%08x 0x%08x 0x%08x", i,
+			   txd->vals[0], txd->vals[1],
+			   txd->vals[2], txd->vals[3]);
+
+		if (!tx_ring->is_xdp) {
+			skb = READ_ONCE(tx_ring->txbufs[i].skb);
+			if (skb)
+				seq_printf(file, " skb->head=%p skb->data=%p",
+					   skb->head, skb->data);
+		} else {
+			xdp = READ_ONCE(tx_ring->txbufs[i].xdp);
+			if (xdp)
+				seq_printf(file, " xdp->data=%p", xdp->data);
+		}
+
+		if (tx_ring->txbufs[i].dma_addr)
+			seq_printf(file, " dma_addr=%pad",
+				   &tx_ring->txbufs[i].dma_addr);
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
diff --git a/drivers/net/ethernet/netronome/nfp/nfd3/xsk.c b/drivers/net/ethernet/netronome/nfp/nfd3/xsk.c
new file mode 100644
index 000000000000..c16c4b42ecfd
--- /dev/null
+++ b/drivers/net/ethernet/netronome/nfp/nfd3/xsk.c
@@ -0,0 +1,408 @@
+// SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+/* Copyright (C) 2018 Netronome Systems, Inc */
+/* Copyright (C) 2021 Corigine, Inc */
+
+#include <linux/bpf_trace.h>
+#include <linux/netdevice.h>
+
+#include "../nfp_app.h"
+#include "../nfp_net.h"
+#include "../nfp_net_dp.h"
+#include "../nfp_net_xsk.h"
+#include "nfd3.h"
+
+static bool
+nfp_nfd3_xsk_tx_xdp(const struct nfp_net_dp *dp, struct nfp_net_r_vector *r_vec,
+		    struct nfp_net_rx_ring *rx_ring,
+		    struct nfp_net_tx_ring *tx_ring,
+		    struct nfp_net_xsk_rx_buf *xrxbuf, unsigned int pkt_len,
+		    int pkt_off)
+{
+	struct xsk_buff_pool *pool = r_vec->xsk_pool;
+	struct nfp_nfd3_tx_buf *txbuf;
+	struct nfp_nfd3_tx_desc *txd;
+	unsigned int wr_idx;
+
+	if (nfp_net_tx_space(tx_ring) < 1)
+		return false;
+
+	xsk_buff_raw_dma_sync_for_device(pool, xrxbuf->dma_addr + pkt_off,
+					 pkt_len);
+
+	wr_idx = D_IDX(tx_ring, tx_ring->wr_p);
+
+	txbuf = &tx_ring->txbufs[wr_idx];
+	txbuf->xdp = xrxbuf->xdp;
+	txbuf->real_len = pkt_len;
+	txbuf->is_xsk_tx = true;
+
+	/* Build TX descriptor */
+	txd = &tx_ring->txds[wr_idx];
+	txd->offset_eop = NFD3_DESC_TX_EOP;
+	txd->dma_len = cpu_to_le16(pkt_len);
+	nfp_desc_set_dma_addr(txd, xrxbuf->dma_addr + pkt_off);
+	txd->data_len = cpu_to_le16(pkt_len);
+
+	txd->flags = 0;
+	txd->mss = 0;
+	txd->lso_hdrlen = 0;
+
+	tx_ring->wr_ptr_add++;
+	tx_ring->wr_p++;
+
+	return true;
+}
+
+static void nfp_nfd3_xsk_rx_skb(struct nfp_net_rx_ring *rx_ring,
+				const struct nfp_net_rx_desc *rxd,
+				struct nfp_net_xsk_rx_buf *xrxbuf,
+				const struct nfp_meta_parsed *meta,
+				unsigned int pkt_len,
+				bool meta_xdp,
+				unsigned int *skbs_polled)
+{
+	struct nfp_net_r_vector *r_vec = rx_ring->r_vec;
+	struct nfp_net_dp *dp = &r_vec->nfp_net->dp;
+	struct net_device *netdev;
+	struct sk_buff *skb;
+
+	if (likely(!meta->portid)) {
+		netdev = dp->netdev;
+	} else {
+		struct nfp_net *nn = netdev_priv(dp->netdev);
+
+		netdev = nfp_app_dev_get(nn->app, meta->portid, NULL);
+		if (unlikely(!netdev)) {
+			nfp_net_xsk_rx_drop(r_vec, xrxbuf);
+			return;
+		}
+		nfp_repr_inc_rx_stats(netdev, pkt_len);
+	}
+
+	skb = napi_alloc_skb(&r_vec->napi, pkt_len);
+	if (!skb) {
+		nfp_net_xsk_rx_drop(r_vec, xrxbuf);
+		return;
+	}
+	memcpy(skb_put(skb, pkt_len), xrxbuf->xdp->data, pkt_len);
+
+	skb->mark = meta->mark;
+	skb_set_hash(skb, meta->hash, meta->hash_type);
+
+	skb_record_rx_queue(skb, rx_ring->idx);
+	skb->protocol = eth_type_trans(skb, netdev);
+
+	nfp_nfd3_rx_csum(dp, r_vec, rxd, meta, skb);
+
+	if (rxd->rxd.flags & PCIE_DESC_RX_VLAN)
+		__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q),
+				       le16_to_cpu(rxd->rxd.vlan));
+	if (meta_xdp)
+		skb_metadata_set(skb,
+				 xrxbuf->xdp->data - xrxbuf->xdp->data_meta);
+
+	napi_gro_receive(&rx_ring->r_vec->napi, skb);
+
+	nfp_net_xsk_rx_free(xrxbuf);
+
+	(*skbs_polled)++;
+}
+
+static unsigned int
+nfp_nfd3_xsk_rx(struct nfp_net_rx_ring *rx_ring, int budget,
+		unsigned int *skbs_polled)
+{
+	struct nfp_net_r_vector *r_vec = rx_ring->r_vec;
+	struct nfp_net_dp *dp = &r_vec->nfp_net->dp;
+	struct nfp_net_tx_ring *tx_ring;
+	struct bpf_prog *xdp_prog;
+	bool xdp_redir = false;
+	int pkts_polled = 0;
+
+	xdp_prog = READ_ONCE(dp->xdp_prog);
+	tx_ring = r_vec->xdp_ring;
+
+	while (pkts_polled < budget) {
+		unsigned int meta_len, data_len, pkt_len, pkt_off;
+		struct nfp_net_xsk_rx_buf *xrxbuf;
+		struct nfp_net_rx_desc *rxd;
+		struct nfp_meta_parsed meta;
+		int idx, act;
+
+		idx = D_IDX(rx_ring, rx_ring->rd_p);
+
+		rxd = &rx_ring->rxds[idx];
+		if (!(rxd->rxd.meta_len_dd & PCIE_DESC_RX_DD))
+			break;
+
+		rx_ring->rd_p++;
+		pkts_polled++;
+
+		xrxbuf = &rx_ring->xsk_rxbufs[idx];
+
+		/* If starved of buffers "drop" it and scream. */
+		if (rx_ring->rd_p >= rx_ring->wr_p) {
+			nn_dp_warn(dp, "Starved of RX buffers\n");
+			nfp_net_xsk_rx_drop(r_vec, xrxbuf);
+			break;
+		}
+
+		/* Memory barrier to ensure that we won't do other reads
+		 * before the DD bit.
+		 */
+		dma_rmb();
+
+		memset(&meta, 0, sizeof(meta));
+
+		/* Only supporting AF_XDP with dynamic metadata so buffer layout
+		 * is always:
+		 *
+		 *  ---------------------------------------------------------
+		 * |  off | metadata  |             packet           | XXXX  |
+		 *  ---------------------------------------------------------
+		 */
+		meta_len = rxd->rxd.meta_len_dd & PCIE_DESC_RX_META_LEN_MASK;
+		data_len = le16_to_cpu(rxd->rxd.data_len);
+		pkt_len = data_len - meta_len;
+
+		if (unlikely(meta_len > NFP_NET_MAX_PREPEND)) {
+			nn_dp_warn(dp, "Oversized RX packet metadata %u\n",
+				   meta_len);
+			nfp_net_xsk_rx_drop(r_vec, xrxbuf);
+			continue;
+		}
+
+		/* Stats update. */
+		u64_stats_update_begin(&r_vec->rx_sync);
+		r_vec->rx_pkts++;
+		r_vec->rx_bytes += pkt_len;
+		u64_stats_update_end(&r_vec->rx_sync);
+
+		xrxbuf->xdp->data += meta_len;
+		xrxbuf->xdp->data_end = xrxbuf->xdp->data + pkt_len;
+		xdp_set_data_meta_invalid(xrxbuf->xdp);
+		xsk_buff_dma_sync_for_cpu(xrxbuf->xdp, r_vec->xsk_pool);
+		net_prefetch(xrxbuf->xdp->data);
+
+		if (meta_len) {
+			if (unlikely(nfp_nfd3_parse_meta(dp->netdev, &meta,
+							 xrxbuf->xdp->data -
+							 meta_len,
+							 xrxbuf->xdp->data,
+							 pkt_len, meta_len))) {
+				nn_dp_warn(dp, "Invalid RX packet metadata\n");
+				nfp_net_xsk_rx_drop(r_vec, xrxbuf);
+				continue;
+			}
+
+			if (unlikely(meta.portid)) {
+				struct nfp_net *nn = netdev_priv(dp->netdev);
+
+				if (meta.portid != NFP_META_PORT_ID_CTRL) {
+					nfp_nfd3_xsk_rx_skb(rx_ring, rxd,
+							    xrxbuf, &meta,
+							    pkt_len, false,
+							    skbs_polled);
+					continue;
+				}
+
+				nfp_app_ctrl_rx_raw(nn->app, xrxbuf->xdp->data,
+						    pkt_len);
+				nfp_net_xsk_rx_free(xrxbuf);
+				continue;
+			}
+		}
+
+		act = bpf_prog_run_xdp(xdp_prog, xrxbuf->xdp);
+
+		pkt_len = xrxbuf->xdp->data_end - xrxbuf->xdp->data;
+		pkt_off = xrxbuf->xdp->data - xrxbuf->xdp->data_hard_start;
+
+		switch (act) {
+		case XDP_PASS:
+			nfp_nfd3_xsk_rx_skb(rx_ring, rxd, xrxbuf, &meta, pkt_len,
+					    true, skbs_polled);
+			break;
+		case XDP_TX:
+			if (!nfp_nfd3_xsk_tx_xdp(dp, r_vec, rx_ring, tx_ring,
+						 xrxbuf, pkt_len, pkt_off))
+				nfp_net_xsk_rx_drop(r_vec, xrxbuf);
+			else
+				nfp_net_xsk_rx_unstash(xrxbuf);
+			break;
+		case XDP_REDIRECT:
+			if (xdp_do_redirect(dp->netdev, xrxbuf->xdp, xdp_prog)) {
+				nfp_net_xsk_rx_drop(r_vec, xrxbuf);
+			} else {
+				nfp_net_xsk_rx_unstash(xrxbuf);
+				xdp_redir = true;
+			}
+			break;
+		default:
+			bpf_warn_invalid_xdp_action(dp->netdev, xdp_prog, act);
+			fallthrough;
+		case XDP_ABORTED:
+			trace_xdp_exception(dp->netdev, xdp_prog, act);
+			fallthrough;
+		case XDP_DROP:
+			nfp_net_xsk_rx_drop(r_vec, xrxbuf);
+			break;
+		}
+	}
+
+	nfp_net_xsk_rx_ring_fill_freelist(r_vec->rx_ring);
+
+	if (xdp_redir)
+		xdp_do_flush_map();
+
+	if (tx_ring->wr_ptr_add)
+		nfp_net_tx_xmit_more_flush(tx_ring);
+
+	return pkts_polled;
+}
+
+void nfp_nfd3_xsk_tx_free(struct nfp_nfd3_tx_buf *txbuf)
+{
+	xsk_buff_free(txbuf->xdp);
+
+	txbuf->dma_addr = 0;
+	txbuf->xdp = NULL;
+}
+
+static bool nfp_nfd3_xsk_complete(struct nfp_net_tx_ring *tx_ring)
+{
+	struct nfp_net_r_vector *r_vec = tx_ring->r_vec;
+	u32 done_pkts = 0, done_bytes = 0, reused = 0;
+	bool done_all;
+	int idx, todo;
+	u32 qcp_rd_p;
+
+	if (tx_ring->wr_p == tx_ring->rd_p)
+		return true;
+
+	/* Work out how many descriptors have been transmitted. */
+	qcp_rd_p = nfp_qcp_rd_ptr_read(tx_ring->qcp_q);
+
+	if (qcp_rd_p == tx_ring->qcp_rd_p)
+		return true;
+
+	todo = D_IDX(tx_ring, qcp_rd_p - tx_ring->qcp_rd_p);
+
+	done_all = todo <= NFP_NET_XDP_MAX_COMPLETE;
+	todo = min(todo, NFP_NET_XDP_MAX_COMPLETE);
+
+	tx_ring->qcp_rd_p = D_IDX(tx_ring, tx_ring->qcp_rd_p + todo);
+
+	done_pkts = todo;
+	while (todo--) {
+		struct nfp_nfd3_tx_buf *txbuf;
+
+		idx = D_IDX(tx_ring, tx_ring->rd_p);
+		tx_ring->rd_p++;
+
+		txbuf = &tx_ring->txbufs[idx];
+		if (unlikely(!txbuf->real_len))
+			continue;
+
+		done_bytes += txbuf->real_len;
+		txbuf->real_len = 0;
+
+		if (txbuf->is_xsk_tx) {
+			nfp_nfd3_xsk_tx_free(txbuf);
+			reused++;
+		}
+	}
+
+	u64_stats_update_begin(&r_vec->tx_sync);
+	r_vec->tx_bytes += done_bytes;
+	r_vec->tx_pkts += done_pkts;
+	u64_stats_update_end(&r_vec->tx_sync);
+
+	xsk_tx_completed(r_vec->xsk_pool, done_pkts - reused);
+
+	WARN_ONCE(tx_ring->wr_p - tx_ring->rd_p > tx_ring->cnt,
+		  "XDP TX ring corruption rd_p=%u wr_p=%u cnt=%u\n",
+		  tx_ring->rd_p, tx_ring->wr_p, tx_ring->cnt);
+
+	return done_all;
+}
+
+static void nfp_nfd3_xsk_tx(struct nfp_net_tx_ring *tx_ring)
+{
+	struct nfp_net_r_vector *r_vec = tx_ring->r_vec;
+	struct xdp_desc desc[NFP_NET_XSK_TX_BATCH];
+	struct xsk_buff_pool *xsk_pool;
+	struct nfp_nfd3_tx_desc *txd;
+	u32 pkts = 0, wr_idx;
+	u32 i, got;
+
+	xsk_pool = r_vec->xsk_pool;
+
+	while (nfp_net_tx_space(tx_ring) >= NFP_NET_XSK_TX_BATCH) {
+		for (i = 0; i < NFP_NET_XSK_TX_BATCH; i++)
+			if (!xsk_tx_peek_desc(xsk_pool, &desc[i]))
+				break;
+		got = i;
+		if (!got)
+			break;
+
+		wr_idx = D_IDX(tx_ring, tx_ring->wr_p + i);
+		prefetchw(&tx_ring->txds[wr_idx]);
+
+		for (i = 0; i < got; i++)
+			xsk_buff_raw_dma_sync_for_device(xsk_pool, desc[i].addr,
+							 desc[i].len);
+
+		for (i = 0; i < got; i++) {
+			wr_idx = D_IDX(tx_ring, tx_ring->wr_p + i);
+
+			tx_ring->txbufs[wr_idx].real_len = desc[i].len;
+			tx_ring->txbufs[wr_idx].is_xsk_tx = false;
+
+			/* Build TX descriptor. */
+			txd = &tx_ring->txds[wr_idx];
+			nfp_desc_set_dma_addr(txd,
+					      xsk_buff_raw_get_dma(xsk_pool,
+								   desc[i].addr
+								   ));
+			txd->offset_eop = NFD3_DESC_TX_EOP;
+			txd->dma_len = cpu_to_le16(desc[i].len);
+			txd->data_len = cpu_to_le16(desc[i].len);
+		}
+
+		tx_ring->wr_p += got;
+		pkts += got;
+	}
+
+	if (!pkts)
+		return;
+
+	xsk_tx_release(xsk_pool);
+	/* Ensure all records are visible before incrementing write counter. */
+	wmb();
+	nfp_qcp_wr_ptr_add(tx_ring->qcp_q, pkts);
+}
+
+int nfp_nfd3_xsk_poll(struct napi_struct *napi, int budget)
+{
+	struct nfp_net_r_vector *r_vec =
+		container_of(napi, struct nfp_net_r_vector, napi);
+	unsigned int pkts_polled, skbs = 0;
+
+	pkts_polled = nfp_nfd3_xsk_rx(r_vec->rx_ring, budget, &skbs);
+
+	if (pkts_polled < budget) {
+		if (r_vec->tx_ring)
+			nfp_nfd3_tx_complete(r_vec->tx_ring, budget);
+
+		if (!nfp_nfd3_xsk_complete(r_vec->xdp_ring))
+			pkts_polled = budget;
+
+		nfp_nfd3_xsk_tx(r_vec->xdp_ring);
+
+		if (pkts_polled < budget && napi_complete_done(napi, skbs))
+			nfp_net_irq_unmask(r_vec->nfp_net, r_vec->irq_entry);
+	}
+
+	return pkts_polled;
+}
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net.h b/drivers/net/ethernet/netronome/nfp/nfp_net.h
index 49b5fcb49aef..bffe53f4c2d3 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net.h
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net.h
@@ -104,6 +104,9 @@ struct nfp_net_r_vector;
 struct nfp_port;
 struct xsk_buff_pool;
 
+struct nfp_nfd3_tx_desc;
+struct nfp_nfd3_tx_buf;
+
 /* Convenience macro for wrapping descriptor index on ring size */
 #define D_IDX(ring, idx)	((idx) & ((ring)->cnt - 1))
 
@@ -117,83 +120,6 @@ struct xsk_buff_pool;
 		__d->dma_addr_hi = upper_32_bits(__addr) & 0xff;	\
 	} while (0)
 
-/* TX descriptor format */
-
-#define PCIE_DESC_TX_EOP		BIT(7)
-#define PCIE_DESC_TX_OFFSET_MASK	GENMASK(6, 0)
-#define PCIE_DESC_TX_MSS_MASK		GENMASK(13, 0)
-
-/* Flags in the host TX descriptor */
-#define PCIE_DESC_TX_CSUM		BIT(7)
-#define PCIE_DESC_TX_IP4_CSUM		BIT(6)
-#define PCIE_DESC_TX_TCP_CSUM		BIT(5)
-#define PCIE_DESC_TX_UDP_CSUM		BIT(4)
-#define PCIE_DESC_TX_VLAN		BIT(3)
-#define PCIE_DESC_TX_LSO		BIT(2)
-#define PCIE_DESC_TX_ENCAP		BIT(1)
-#define PCIE_DESC_TX_O_IP4_CSUM	BIT(0)
-
-struct nfp_net_tx_desc {
-	union {
-		struct {
-			u8 dma_addr_hi; /* High bits of host buf address */
-			__le16 dma_len;	/* Length to DMA for this desc */
-			u8 offset_eop;	/* Offset in buf where pkt starts +
-					 * highest bit is eop flag.
-					 */
-			__le32 dma_addr_lo; /* Low 32bit of host buf addr */
-
-			__le16 mss;	/* MSS to be used for LSO */
-			u8 lso_hdrlen;	/* LSO, TCP payload offset */
-			u8 flags;	/* TX Flags, see @PCIE_DESC_TX_* */
-			union {
-				struct {
-					u8 l3_offset; /* L3 header offset */
-					u8 l4_offset; /* L4 header offset */
-				};
-				__le16 vlan; /* VLAN tag to add if indicated */
-			};
-			__le16 data_len; /* Length of frame + meta data */
-		} __packed;
-		__le32 vals[4];
-		__le64 vals8[2];
-	};
-};
-
-/**
- * struct nfp_net_tx_buf - software TX buffer descriptor
- * @skb:	normal ring, sk_buff associated with this buffer
- * @frag:	XDP ring, page frag associated with this buffer
- * @xdp:	XSK buffer pool handle (for AF_XDP)
- * @dma_addr:	DMA mapping address of the buffer
- * @fidx:	Fragment index (-1 for the head and [0..nr_frags-1] for frags)
- * @pkt_cnt:	Number of packets to be produced out of the skb associated
- *		with this buffer (valid only on the head's buffer).
- *		Will be 1 for all non-TSO packets.
- * @is_xsk_tx:	Flag if buffer is a RX buffer after a XDP_TX action and not a
- *		buffer from the TX queue (for AF_XDP).
- * @real_len:	Number of bytes which to be produced out of the skb (valid only
- *		on the head's buffer). Equal to skb->len for non-TSO packets.
- */
-struct nfp_net_tx_buf {
-	union {
-		struct sk_buff *skb;
-		void *frag;
-		struct xdp_buff *xdp;
-	};
-	dma_addr_t dma_addr;
-	union {
-		struct {
-			short int fidx;
-			u16 pkt_cnt;
-		};
-		struct {
-			bool is_xsk_tx;
-		};
-	};
-	u32 real_len;
-};
-
 /**
  * struct nfp_net_tx_ring - TX ring structure
  * @r_vec:      Back pointer to ring vector structure
@@ -226,8 +152,8 @@ struct nfp_net_tx_ring {
 
 	u32 wr_ptr_add;
 
-	struct nfp_net_tx_buf *txbufs;
-	struct nfp_net_tx_desc *txds;
+	struct nfp_nfd3_tx_buf *txbufs;
+	struct nfp_nfd3_tx_desc *txds;
 
 	dma_addr_t dma;
 	size_t size;
@@ -960,7 +886,6 @@ int nfp_net_mbox_reconfig_and_unlock(struct nfp_net *nn, u32 mbox_cmd);
 void nfp_net_mbox_reconfig_post(struct nfp_net *nn, u32 update);
 int nfp_net_mbox_reconfig_wait_posted(struct nfp_net *nn);
 
-void nfp_net_irq_unmask(struct nfp_net *nn, unsigned int entry_nr);
 unsigned int
 nfp_net_irqs_alloc(struct pci_dev *pdev, struct msix_entry *irq_entries,
 		   unsigned int min_irqs, unsigned int want_irqs);
@@ -968,19 +893,10 @@ void nfp_net_irqs_disable(struct pci_dev *pdev);
 void
 nfp_net_irqs_assign(struct nfp_net *nn, struct msix_entry *irq_entries,
 		    unsigned int n);
-
-void nfp_net_tx_xmit_more_flush(struct nfp_net_tx_ring *tx_ring);
-void nfp_net_tx_complete(struct nfp_net_tx_ring *tx_ring, int budget);
-
-bool
-nfp_net_parse_meta(struct net_device *netdev, struct nfp_meta_parsed *meta,
-		   void *data, void *pkt, unsigned int pkt_len, int meta_len);
-
-void nfp_net_rx_csum(const struct nfp_net_dp *dp,
-		     struct nfp_net_r_vector *r_vec,
-		     const struct nfp_net_rx_desc *rxd,
-		     const struct nfp_meta_parsed *meta,
-		     struct sk_buff *skb);
+struct sk_buff *
+nfp_net_tls_tx(struct nfp_net_dp *dp, struct nfp_net_r_vector *r_vec,
+	       struct sk_buff *skb, u64 *tls_handle, int *nr_frags);
+void nfp_net_tls_tx_undo(struct sk_buff *skb, u64 tls_handle);
 
 struct nfp_net_dp *nfp_net_clone_dp(struct nfp_net *nn);
 int nfp_net_ring_reconfig(struct nfp_net *nn, struct nfp_net_dp *new,
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index 50f7ada0dedd..1d3277068301 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
-/* Copyright (C) 2015-2018 Netronome Systems, Inc. */
+/* Copyright (C) 2015-2019 Netronome Systems, Inc. */
 
 /*
  * nfp_net_common.c
@@ -13,7 +13,6 @@
 
 #include <linux/bitfield.h>
 #include <linux/bpf.h>
-#include <linux/bpf_trace.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
@@ -46,6 +45,7 @@
 #include "nfp_app.h"
 #include "nfp_net_ctrl.h"
 #include "nfp_net.h"
+#include "nfp_net_dp.h"
 #include "nfp_net_sriov.h"
 #include "nfp_net_xsk.h"
 #include "nfp_port.h"
@@ -72,35 +72,6 @@ u32 nfp_qcp_queue_offset(const struct nfp_dev_info *dev_info, u16 queue)
 	return dev_info->qc_addr_offset + NFP_QCP_QUEUE_ADDR_SZ * queue;
 }
 
-static dma_addr_t nfp_net_dma_map_rx(struct nfp_net_dp *dp, void *frag)
-{
-	return dma_map_single_attrs(dp->dev, frag + NFP_NET_RX_BUF_HEADROOM,
-				    dp->fl_bufsz - NFP_NET_RX_BUF_NON_DATA,
-				    dp->rx_dma_dir, DMA_ATTR_SKIP_CPU_SYNC);
-}
-
-static void
-nfp_net_dma_sync_dev_rx(const struct nfp_net_dp *dp, dma_addr_t dma_addr)
-{
-	dma_sync_single_for_device(dp->dev, dma_addr,
-				   dp->fl_bufsz - NFP_NET_RX_BUF_NON_DATA,
-				   dp->rx_dma_dir);
-}
-
-static void nfp_net_dma_unmap_rx(struct nfp_net_dp *dp, dma_addr_t dma_addr)
-{
-	dma_unmap_single_attrs(dp->dev, dma_addr,
-			       dp->fl_bufsz - NFP_NET_RX_BUF_NON_DATA,
-			       dp->rx_dma_dir, DMA_ATTR_SKIP_CPU_SYNC);
-}
-
-static void nfp_net_dma_sync_cpu_rx(struct nfp_net_dp *dp, dma_addr_t dma_addr,
-				    unsigned int len)
-{
-	dma_sync_single_for_cpu(dp->dev, dma_addr - NFP_NET_RX_BUF_HEADROOM,
-				len, dp->rx_dma_dir);
-}
-
 /* Firmware reconfig
  *
  * Firmware reconfig may take a while so we have two versions of it -
@@ -383,19 +354,6 @@ int nfp_net_mbox_reconfig_and_unlock(struct nfp_net *nn, u32 mbox_cmd)
 /* Interrupt configuration and handling
  */
 
-/**
- * nfp_net_irq_unmask() - Unmask automasked interrupt
- * @nn:       NFP Network structure
- * @entry_nr: MSI-X table entry
- *
- * Clear the ICR for the IRQ entry.
- */
-void nfp_net_irq_unmask(struct nfp_net *nn, unsigned int entry_nr)
-{
-	nn_writeb(nn, NFP_NET_CFG_ICR(entry_nr), NFP_NET_CFG_ICR_UNMASKED);
-	nn_pci_flush(nn);
-}
-
 /**
  * nfp_net_irqs_alloc() - allocates MSI-X irqs
  * @pdev:        PCI device structure
@@ -577,49 +535,6 @@ static irqreturn_t nfp_net_irq_exn(int irq, void *data)
 	return IRQ_HANDLED;
 }
 
-/**
- * nfp_net_tx_ring_init() - Fill in the boilerplate for a TX ring
- * @tx_ring:  TX ring structure
- * @r_vec:    IRQ vector servicing this ring
- * @idx:      Ring index
- * @is_xdp:   Is this an XDP TX ring?
- */
-static void
-nfp_net_tx_ring_init(struct nfp_net_tx_ring *tx_ring,
-		     struct nfp_net_r_vector *r_vec, unsigned int idx,
-		     bool is_xdp)
-{
-	struct nfp_net *nn = r_vec->nfp_net;
-
-	tx_ring->idx = idx;
-	tx_ring->r_vec = r_vec;
-	tx_ring->is_xdp = is_xdp;
-	u64_stats_init(&tx_ring->r_vec->tx_sync);
-
-	tx_ring->qcidx = tx_ring->idx * nn->stride_tx;
-	tx_ring->qcp_q = nn->tx_bar + NFP_QCP_QUEUE_OFF(tx_ring->qcidx);
-}
-
-/**
- * nfp_net_rx_ring_init() - Fill in the boilerplate for a RX ring
- * @rx_ring:  RX ring structure
- * @r_vec:    IRQ vector servicing this ring
- * @idx:      Ring index
- */
-static void
-nfp_net_rx_ring_init(struct nfp_net_rx_ring *rx_ring,
-		     struct nfp_net_r_vector *r_vec, unsigned int idx)
-{
-	struct nfp_net *nn = r_vec->nfp_net;
-
-	rx_ring->idx = idx;
-	rx_ring->r_vec = r_vec;
-	u64_stats_init(&rx_ring->r_vec->rx_sync);
-
-	rx_ring->fl_qcidx = rx_ring->idx * nn->stride_rx;
-	rx_ring->qcp_fl = nn->rx_bar + NFP_QCP_QUEUE_OFF(rx_ring->fl_qcidx);
-}
-
 /**
  * nfp_net_aux_irq_request() - Request an auxiliary interrupt (LSC or EXN)
  * @nn:		NFP Network structure
@@ -667,178 +582,7 @@ static void nfp_net_aux_irq_free(struct nfp_net *nn, u32 ctrl_offset,
 	free_irq(nn->irq_entries[vector_idx].vector, nn);
 }
 
-/* Transmit
- *
- * One queue controller peripheral queue is used for transmit.  The
- * driver en-queues packets for transmit by advancing the write
- * pointer.  The device indicates that packets have transmitted by
- * advancing the read pointer.  The driver maintains a local copy of
- * the read and write pointer in @struct nfp_net_tx_ring.  The driver
- * keeps @wr_p in sync with the queue controller write pointer and can
- * determine how many packets have been transmitted by comparing its
- * copy of the read pointer @rd_p with the read pointer maintained by
- * the queue controller peripheral.
- */
-
-/**
- * nfp_net_tx_full() - Check if the TX ring is full
- * @tx_ring: TX ring to check
- * @dcnt:    Number of descriptors that need to be enqueued (must be >= 1)
- *
- * This function checks, based on the *host copy* of read/write
- * pointer if a given TX ring is full.  The real TX queue may have
- * some newly made available slots.
- *
- * Return: True if the ring is full.
- */
-static int nfp_net_tx_full(struct nfp_net_tx_ring *tx_ring, int dcnt)
-{
-	return (tx_ring->wr_p - tx_ring->rd_p) >= (tx_ring->cnt - dcnt);
-}
-
-/* Wrappers for deciding when to stop and restart TX queues */
-static int nfp_net_tx_ring_should_wake(struct nfp_net_tx_ring *tx_ring)
-{
-	return !nfp_net_tx_full(tx_ring, MAX_SKB_FRAGS * 4);
-}
-
-static int nfp_net_tx_ring_should_stop(struct nfp_net_tx_ring *tx_ring)
-{
-	return nfp_net_tx_full(tx_ring, MAX_SKB_FRAGS + 1);
-}
-
-/**
- * nfp_net_tx_ring_stop() - stop tx ring
- * @nd_q:    netdev queue
- * @tx_ring: driver tx queue structure
- *
- * Safely stop TX ring.  Remember that while we are running .start_xmit()
- * someone else may be cleaning the TX ring completions so we need to be
- * extra careful here.
- */
-static void nfp_net_tx_ring_stop(struct netdev_queue *nd_q,
-				 struct nfp_net_tx_ring *tx_ring)
-{
-	netif_tx_stop_queue(nd_q);
-
-	/* We can race with the TX completion out of NAPI so recheck */
-	smp_mb();
-	if (unlikely(nfp_net_tx_ring_should_wake(tx_ring)))
-		netif_tx_start_queue(nd_q);
-}
-
-/**
- * nfp_net_tx_tso() - Set up Tx descriptor for LSO
- * @r_vec: per-ring structure
- * @txbuf: Pointer to driver soft TX descriptor
- * @txd: Pointer to HW TX descriptor
- * @skb: Pointer to SKB
- * @md_bytes: Prepend length
- *
- * Set up Tx descriptor for LSO, do nothing for non-LSO skbs.
- * Return error on packet header greater than maximum supported LSO header size.
- */
-static void nfp_net_tx_tso(struct nfp_net_r_vector *r_vec,
-			   struct nfp_net_tx_buf *txbuf,
-			   struct nfp_net_tx_desc *txd, struct sk_buff *skb,
-			   u32 md_bytes)
-{
-	u32 l3_offset, l4_offset, hdrlen;
-	u16 mss;
-
-	if (!skb_is_gso(skb))
-		return;
-
-	if (!skb->encapsulation) {
-		l3_offset = skb_network_offset(skb);
-		l4_offset = skb_transport_offset(skb);
-		hdrlen = skb_transport_offset(skb) + tcp_hdrlen(skb);
-	} else {
-		l3_offset = skb_inner_network_offset(skb);
-		l4_offset = skb_inner_transport_offset(skb);
-		hdrlen = skb_inner_transport_header(skb) - skb->data +
-			inner_tcp_hdrlen(skb);
-	}
-
-	txbuf->pkt_cnt = skb_shinfo(skb)->gso_segs;
-	txbuf->real_len += hdrlen * (txbuf->pkt_cnt - 1);
-
-	mss = skb_shinfo(skb)->gso_size & PCIE_DESC_TX_MSS_MASK;
-	txd->l3_offset = l3_offset - md_bytes;
-	txd->l4_offset = l4_offset - md_bytes;
-	txd->lso_hdrlen = hdrlen - md_bytes;
-	txd->mss = cpu_to_le16(mss);
-	txd->flags |= PCIE_DESC_TX_LSO;
-
-	u64_stats_update_begin(&r_vec->tx_sync);
-	r_vec->tx_lso++;
-	u64_stats_update_end(&r_vec->tx_sync);
-}
-
-/**
- * nfp_net_tx_csum() - Set TX CSUM offload flags in TX descriptor
- * @dp:  NFP Net data path struct
- * @r_vec: per-ring structure
- * @txbuf: Pointer to driver soft TX descriptor
- * @txd: Pointer to TX descriptor
- * @skb: Pointer to SKB
- *
- * This function sets the TX checksum flags in the TX descriptor based
- * on the configuration and the protocol of the packet to be transmitted.
- */
-static void nfp_net_tx_csum(struct nfp_net_dp *dp,
-			    struct nfp_net_r_vector *r_vec,
-			    struct nfp_net_tx_buf *txbuf,
-			    struct nfp_net_tx_desc *txd, struct sk_buff *skb)
-{
-	struct ipv6hdr *ipv6h;
-	struct iphdr *iph;
-	u8 l4_hdr;
-
-	if (!(dp->ctrl & NFP_NET_CFG_CTRL_TXCSUM))
-		return;
-
-	if (skb->ip_summed != CHECKSUM_PARTIAL)
-		return;
-
-	txd->flags |= PCIE_DESC_TX_CSUM;
-	if (skb->encapsulation)
-		txd->flags |= PCIE_DESC_TX_ENCAP;
-
-	iph = skb->encapsulation ? inner_ip_hdr(skb) : ip_hdr(skb);
-	ipv6h = skb->encapsulation ? inner_ipv6_hdr(skb) : ipv6_hdr(skb);
-
-	if (iph->version == 4) {
-		txd->flags |= PCIE_DESC_TX_IP4_CSUM;
-		l4_hdr = iph->protocol;
-	} else if (ipv6h->version == 6) {
-		l4_hdr = ipv6h->nexthdr;
-	} else {
-		nn_dp_warn(dp, "partial checksum but ipv=%x!\n", iph->version);
-		return;
-	}
-
-	switch (l4_hdr) {
-	case IPPROTO_TCP:
-		txd->flags |= PCIE_DESC_TX_TCP_CSUM;
-		break;
-	case IPPROTO_UDP:
-		txd->flags |= PCIE_DESC_TX_UDP_CSUM;
-		break;
-	default:
-		nn_dp_warn(dp, "partial checksum but l4 proto=%x!\n", l4_hdr);
-		return;
-	}
-
-	u64_stats_update_begin(&r_vec->tx_sync);
-	if (skb->encapsulation)
-		r_vec->hw_csum_tx_inner += txbuf->pkt_cnt;
-	else
-		r_vec->hw_csum_tx += txbuf->pkt_cnt;
-	u64_stats_update_end(&r_vec->tx_sync);
-}
-
-static struct sk_buff *
+struct sk_buff *
 nfp_net_tls_tx(struct nfp_net_dp *dp, struct nfp_net_r_vector *r_vec,
 	       struct sk_buff *skb, u64 *tls_handle, int *nr_frags)
 {
@@ -910,7 +654,7 @@ nfp_net_tls_tx(struct nfp_net_dp *dp, struct nfp_net_r_vector *r_vec,
 	return skb;
 }
 
-static void nfp_net_tls_tx_undo(struct sk_buff *skb, u64 tls_handle)
+void nfp_net_tls_tx_undo(struct sk_buff *skb, u64 tls_handle)
 {
 #ifdef CONFIG_TLS_DEVICE
 	struct nfp_net_tls_offload_ctx *ntls;
@@ -932,414 +676,6 @@ static void nfp_net_tls_tx_undo(struct sk_buff *skb, u64 tls_handle)
 #endif
 }
 
-void nfp_net_tx_xmit_more_flush(struct nfp_net_tx_ring *tx_ring)
-{
-	wmb();
-	nfp_qcp_wr_ptr_add(tx_ring->qcp_q, tx_ring->wr_ptr_add);
-	tx_ring->wr_ptr_add = 0;
-}
-
-static int nfp_net_prep_tx_meta(struct sk_buff *skb, u64 tls_handle)
-{
-	struct metadata_dst *md_dst = skb_metadata_dst(skb);
-	unsigned char *data;
-	u32 meta_id = 0;
-	int md_bytes;
-
-	if (likely(!md_dst && !tls_handle))
-		return 0;
-	if (unlikely(md_dst && md_dst->type != METADATA_HW_PORT_MUX)) {
-		if (!tls_handle)
-			return 0;
-		md_dst = NULL;
-	}
-
-	md_bytes = 4 + !!md_dst * 4 + !!tls_handle * 8;
-
-	if (unlikely(skb_cow_head(skb, md_bytes)))
-		return -ENOMEM;
-
-	meta_id = 0;
-	data = skb_push(skb, md_bytes) + md_bytes;
-	if (md_dst) {
-		data -= 4;
-		put_unaligned_be32(md_dst->u.port_info.port_id, data);
-		meta_id = NFP_NET_META_PORTID;
-	}
-	if (tls_handle) {
-		/* conn handle is opaque, we just use u64 to be able to quickly
-		 * compare it to zero
-		 */
-		data -= 8;
-		memcpy(data, &tls_handle, sizeof(tls_handle));
-		meta_id <<= NFP_NET_META_FIELD_SIZE;
-		meta_id |= NFP_NET_META_CONN_HANDLE;
-	}
-
-	data -= 4;
-	put_unaligned_be32(meta_id, data);
-
-	return md_bytes;
-}
-
-/**
- * nfp_net_tx() - Main transmit entry point
- * @skb:    SKB to transmit
- * @netdev: netdev structure
- *
- * Return: NETDEV_TX_OK on success.
- */
-static netdev_tx_t nfp_net_tx(struct sk_buff *skb, struct net_device *netdev)
-{
-	struct nfp_net *nn = netdev_priv(netdev);
-	const skb_frag_t *frag;
-	int f, nr_frags, wr_idx, md_bytes;
-	struct nfp_net_tx_ring *tx_ring;
-	struct nfp_net_r_vector *r_vec;
-	struct nfp_net_tx_buf *txbuf;
-	struct nfp_net_tx_desc *txd;
-	struct netdev_queue *nd_q;
-	struct nfp_net_dp *dp;
-	dma_addr_t dma_addr;
-	unsigned int fsize;
-	u64 tls_handle = 0;
-	u16 qidx;
-
-	dp = &nn->dp;
-	qidx = skb_get_queue_mapping(skb);
-	tx_ring = &dp->tx_rings[qidx];
-	r_vec = tx_ring->r_vec;
-
-	nr_frags = skb_shinfo(skb)->nr_frags;
-
-	if (unlikely(nfp_net_tx_full(tx_ring, nr_frags + 1))) {
-		nn_dp_warn(dp, "TX ring %d busy. wrp=%u rdp=%u\n",
-			   qidx, tx_ring->wr_p, tx_ring->rd_p);
-		nd_q = netdev_get_tx_queue(dp->netdev, qidx);
-		netif_tx_stop_queue(nd_q);
-		nfp_net_tx_xmit_more_flush(tx_ring);
-		u64_stats_update_begin(&r_vec->tx_sync);
-		r_vec->tx_busy++;
-		u64_stats_update_end(&r_vec->tx_sync);
-		return NETDEV_TX_BUSY;
-	}
-
-	skb = nfp_net_tls_tx(dp, r_vec, skb, &tls_handle, &nr_frags);
-	if (unlikely(!skb)) {
-		nfp_net_tx_xmit_more_flush(tx_ring);
-		return NETDEV_TX_OK;
-	}
-
-	md_bytes = nfp_net_prep_tx_meta(skb, tls_handle);
-	if (unlikely(md_bytes < 0))
-		goto err_flush;
-
-	/* Start with the head skbuf */
-	dma_addr = dma_map_single(dp->dev, skb->data, skb_headlen(skb),
-				  DMA_TO_DEVICE);
-	if (dma_mapping_error(dp->dev, dma_addr))
-		goto err_dma_err;
-
-	wr_idx = D_IDX(tx_ring, tx_ring->wr_p);
-
-	/* Stash the soft descriptor of the head then initialize it */
-	txbuf = &tx_ring->txbufs[wr_idx];
-	txbuf->skb = skb;
-	txbuf->dma_addr = dma_addr;
-	txbuf->fidx = -1;
-	txbuf->pkt_cnt = 1;
-	txbuf->real_len = skb->len;
-
-	/* Build TX descriptor */
-	txd = &tx_ring->txds[wr_idx];
-	txd->offset_eop = (nr_frags ? 0 : PCIE_DESC_TX_EOP) | md_bytes;
-	txd->dma_len = cpu_to_le16(skb_headlen(skb));
-	nfp_desc_set_dma_addr(txd, dma_addr);
-	txd->data_len = cpu_to_le16(skb->len);
-
-	txd->flags = 0;
-	txd->mss = 0;
-	txd->lso_hdrlen = 0;
-
-	/* Do not reorder - tso may adjust pkt cnt, vlan may override fields */
-	nfp_net_tx_tso(r_vec, txbuf, txd, skb, md_bytes);
-	nfp_net_tx_csum(dp, r_vec, txbuf, txd, skb);
-	if (skb_vlan_tag_present(skb) && dp->ctrl & NFP_NET_CFG_CTRL_TXVLAN) {
-		txd->flags |= PCIE_DESC_TX_VLAN;
-		txd->vlan = cpu_to_le16(skb_vlan_tag_get(skb));
-	}
-
-	/* Gather DMA */
-	if (nr_frags > 0) {
-		__le64 second_half;
-
-		/* all descs must match except for in addr, length and eop */
-		second_half = txd->vals8[1];
-
-		for (f = 0; f < nr_frags; f++) {
-			frag = &skb_shinfo(skb)->frags[f];
-			fsize = skb_frag_size(frag);
-
-			dma_addr = skb_frag_dma_map(dp->dev, frag, 0,
-						    fsize, DMA_TO_DEVICE);
-			if (dma_mapping_error(dp->dev, dma_addr))
-				goto err_unmap;
-
-			wr_idx = D_IDX(tx_ring, wr_idx + 1);
-			tx_ring->txbufs[wr_idx].skb = skb;
-			tx_ring->txbufs[wr_idx].dma_addr = dma_addr;
-			tx_ring->txbufs[wr_idx].fidx = f;
-
-			txd = &tx_ring->txds[wr_idx];
-			txd->dma_len = cpu_to_le16(fsize);
-			nfp_desc_set_dma_addr(txd, dma_addr);
-			txd->offset_eop = md_bytes |
-				((f == nr_frags - 1) ? PCIE_DESC_TX_EOP : 0);
-			txd->vals8[1] = second_half;
-		}
-
-		u64_stats_update_begin(&r_vec->tx_sync);
-		r_vec->tx_gather++;
-		u64_stats_update_end(&r_vec->tx_sync);
-	}
-
-	skb_tx_timestamp(skb);
-
-	nd_q = netdev_get_tx_queue(dp->netdev, tx_ring->idx);
-
-	tx_ring->wr_p += nr_frags + 1;
-	if (nfp_net_tx_ring_should_stop(tx_ring))
-		nfp_net_tx_ring_stop(nd_q, tx_ring);
-
-	tx_ring->wr_ptr_add += nr_frags + 1;
-	if (__netdev_tx_sent_queue(nd_q, txbuf->real_len, netdev_xmit_more()))
-		nfp_net_tx_xmit_more_flush(tx_ring);
-
-	return NETDEV_TX_OK;
-
-err_unmap:
-	while (--f >= 0) {
-		frag = &skb_shinfo(skb)->frags[f];
-		dma_unmap_page(dp->dev, tx_ring->txbufs[wr_idx].dma_addr,
-			       skb_frag_size(frag), DMA_TO_DEVICE);
-		tx_ring->txbufs[wr_idx].skb = NULL;
-		tx_ring->txbufs[wr_idx].dma_addr = 0;
-		tx_ring->txbufs[wr_idx].fidx = -2;
-		wr_idx = wr_idx - 1;
-		if (wr_idx < 0)
-			wr_idx += tx_ring->cnt;
-	}
-	dma_unmap_single(dp->dev, tx_ring->txbufs[wr_idx].dma_addr,
-			 skb_headlen(skb), DMA_TO_DEVICE);
-	tx_ring->txbufs[wr_idx].skb = NULL;
-	tx_ring->txbufs[wr_idx].dma_addr = 0;
-	tx_ring->txbufs[wr_idx].fidx = -2;
-err_dma_err:
-	nn_dp_warn(dp, "Failed to map DMA TX buffer\n");
-err_flush:
-	nfp_net_tx_xmit_more_flush(tx_ring);
-	u64_stats_update_begin(&r_vec->tx_sync);
-	r_vec->tx_errors++;
-	u64_stats_update_end(&r_vec->tx_sync);
-	nfp_net_tls_tx_undo(skb, tls_handle);
-	dev_kfree_skb_any(skb);
-	return NETDEV_TX_OK;
-}
-
-/**
- * nfp_net_tx_complete() - Handled completed TX packets
- * @tx_ring:	TX ring structure
- * @budget:	NAPI budget (only used as bool to determine if in NAPI context)
- */
-void nfp_net_tx_complete(struct nfp_net_tx_ring *tx_ring, int budget)
-{
-	struct nfp_net_r_vector *r_vec = tx_ring->r_vec;
-	struct nfp_net_dp *dp = &r_vec->nfp_net->dp;
-	struct netdev_queue *nd_q;
-	u32 done_pkts = 0, done_bytes = 0;
-	u32 qcp_rd_p;
-	int todo;
-
-	if (tx_ring->wr_p == tx_ring->rd_p)
-		return;
-
-	/* Work out how many descriptors have been transmitted */
-	qcp_rd_p = nfp_qcp_rd_ptr_read(tx_ring->qcp_q);
-
-	if (qcp_rd_p == tx_ring->qcp_rd_p)
-		return;
-
-	todo = D_IDX(tx_ring, qcp_rd_p - tx_ring->qcp_rd_p);
-
-	while (todo--) {
-		const skb_frag_t *frag;
-		struct nfp_net_tx_buf *tx_buf;
-		struct sk_buff *skb;
-		int fidx, nr_frags;
-		int idx;
-
-		idx = D_IDX(tx_ring, tx_ring->rd_p++);
-		tx_buf = &tx_ring->txbufs[idx];
-
-		skb = tx_buf->skb;
-		if (!skb)
-			continue;
-
-		nr_frags = skb_shinfo(skb)->nr_frags;
-		fidx = tx_buf->fidx;
-
-		if (fidx == -1) {
-			/* unmap head */
-			dma_unmap_single(dp->dev, tx_buf->dma_addr,
-					 skb_headlen(skb), DMA_TO_DEVICE);
-
-			done_pkts += tx_buf->pkt_cnt;
-			done_bytes += tx_buf->real_len;
-		} else {
-			/* unmap fragment */
-			frag = &skb_shinfo(skb)->frags[fidx];
-			dma_unmap_page(dp->dev, tx_buf->dma_addr,
-				       skb_frag_size(frag), DMA_TO_DEVICE);
-		}
-
-		/* check for last gather fragment */
-		if (fidx == nr_frags - 1)
-			napi_consume_skb(skb, budget);
-
-		tx_buf->dma_addr = 0;
-		tx_buf->skb = NULL;
-		tx_buf->fidx = -2;
-	}
-
-	tx_ring->qcp_rd_p = qcp_rd_p;
-
-	u64_stats_update_begin(&r_vec->tx_sync);
-	r_vec->tx_bytes += done_bytes;
-	r_vec->tx_pkts += done_pkts;
-	u64_stats_update_end(&r_vec->tx_sync);
-
-	if (!dp->netdev)
-		return;
-
-	nd_q = netdev_get_tx_queue(dp->netdev, tx_ring->idx);
-	netdev_tx_completed_queue(nd_q, done_pkts, done_bytes);
-	if (nfp_net_tx_ring_should_wake(tx_ring)) {
-		/* Make sure TX thread will see updated tx_ring->rd_p */
-		smp_mb();
-
-		if (unlikely(netif_tx_queue_stopped(nd_q)))
-			netif_tx_wake_queue(nd_q);
-	}
-
-	WARN_ONCE(tx_ring->wr_p - tx_ring->rd_p > tx_ring->cnt,
-		  "TX ring corruption rd_p=%u wr_p=%u cnt=%u\n",
-		  tx_ring->rd_p, tx_ring->wr_p, tx_ring->cnt);
-}
-
-static bool nfp_net_xdp_complete(struct nfp_net_tx_ring *tx_ring)
-{
-	struct nfp_net_r_vector *r_vec = tx_ring->r_vec;
-	u32 done_pkts = 0, done_bytes = 0;
-	bool done_all;
-	int idx, todo;
-	u32 qcp_rd_p;
-
-	/* Work out how many descriptors have been transmitted */
-	qcp_rd_p = nfp_qcp_rd_ptr_read(tx_ring->qcp_q);
-
-	if (qcp_rd_p == tx_ring->qcp_rd_p)
-		return true;
-
-	todo = D_IDX(tx_ring, qcp_rd_p - tx_ring->qcp_rd_p);
-
-	done_all = todo <= NFP_NET_XDP_MAX_COMPLETE;
-	todo = min(todo, NFP_NET_XDP_MAX_COMPLETE);
-
-	tx_ring->qcp_rd_p = D_IDX(tx_ring, tx_ring->qcp_rd_p + todo);
-
-	done_pkts = todo;
-	while (todo--) {
-		idx = D_IDX(tx_ring, tx_ring->rd_p);
-		tx_ring->rd_p++;
-
-		done_bytes += tx_ring->txbufs[idx].real_len;
-	}
-
-	u64_stats_update_begin(&r_vec->tx_sync);
-	r_vec->tx_bytes += done_bytes;
-	r_vec->tx_pkts += done_pkts;
-	u64_stats_update_end(&r_vec->tx_sync);
-
-	WARN_ONCE(tx_ring->wr_p - tx_ring->rd_p > tx_ring->cnt,
-		  "XDP TX ring corruption rd_p=%u wr_p=%u cnt=%u\n",
-		  tx_ring->rd_p, tx_ring->wr_p, tx_ring->cnt);
-
-	return done_all;
-}
-
-/**
- * nfp_net_tx_ring_reset() - Free any untransmitted buffers and reset pointers
- * @dp:		NFP Net data path struct
- * @tx_ring:	TX ring structure
- *
- * Assumes that the device is stopped, must be idempotent.
- */
-static void
-nfp_net_tx_ring_reset(struct nfp_net_dp *dp, struct nfp_net_tx_ring *tx_ring)
-{
-	const skb_frag_t *frag;
-	struct netdev_queue *nd_q;
-
-	while (!tx_ring->is_xdp && tx_ring->rd_p != tx_ring->wr_p) {
-		struct nfp_net_tx_buf *tx_buf;
-		struct sk_buff *skb;
-		int idx, nr_frags;
-
-		idx = D_IDX(tx_ring, tx_ring->rd_p);
-		tx_buf = &tx_ring->txbufs[idx];
-
-		skb = tx_ring->txbufs[idx].skb;
-		nr_frags = skb_shinfo(skb)->nr_frags;
-
-		if (tx_buf->fidx == -1) {
-			/* unmap head */
-			dma_unmap_single(dp->dev, tx_buf->dma_addr,
-					 skb_headlen(skb), DMA_TO_DEVICE);
-		} else {
-			/* unmap fragment */
-			frag = &skb_shinfo(skb)->frags[tx_buf->fidx];
-			dma_unmap_page(dp->dev, tx_buf->dma_addr,
-				       skb_frag_size(frag), DMA_TO_DEVICE);
-		}
-
-		/* check for last gather fragment */
-		if (tx_buf->fidx == nr_frags - 1)
-			dev_kfree_skb_any(skb);
-
-		tx_buf->dma_addr = 0;
-		tx_buf->skb = NULL;
-		tx_buf->fidx = -2;
-
-		tx_ring->qcp_rd_p++;
-		tx_ring->rd_p++;
-	}
-
-	if (tx_ring->is_xdp)
-		nfp_net_xsk_tx_bufs_free(tx_ring);
-
-	memset(tx_ring->txds, 0, tx_ring->size);
-	tx_ring->wr_p = 0;
-	tx_ring->rd_p = 0;
-	tx_ring->qcp_rd_p = 0;
-	tx_ring->wr_ptr_add = 0;
-
-	if (tx_ring->is_xdp || !dp->netdev)
-		return;
-
-	nd_q = netdev_get_tx_queue(dp->netdev, tx_ring->idx);
-	netdev_tx_reset_queue(nd_q);
-}
-
 static void nfp_net_tx_timeout(struct net_device *netdev, unsigned int txqueue)
 {
 	struct nfp_net *nn = netdev_priv(netdev);
@@ -1347,8 +683,7 @@ static void nfp_net_tx_timeout(struct net_device *netdev, unsigned int txqueue)
 	nn_warn(nn, "TX watchdog timeout on ring: %u\n", txqueue);
 }
 
-/* Receive processing
- */
+/* Receive processing */
 static unsigned int
 nfp_net_calc_fl_bufsz_data(struct nfp_net_dp *dp)
 {
@@ -1387,1335 +722,53 @@ static unsigned int nfp_net_calc_fl_bufsz_xsk(struct nfp_net_dp *dp)
 	return fl_bufsz;
 }
 
-static void
-nfp_net_free_frag(void *frag, bool xdp)
-{
-	if (!xdp)
-		skb_free_frag(frag);
-	else
-		__free_page(virt_to_page(frag));
-}
+/* Setup and Configuration
+ */
 
 /**
- * nfp_net_rx_alloc_one() - Allocate and map page frag for RX
- * @dp:		NFP Net data path struct
- * @dma_addr:	Pointer to storage for DMA address (output param)
- *
- * This function will allcate a new page frag, map it for DMA.
- *
- * Return: allocated page frag or NULL on failure.
+ * nfp_net_vecs_init() - Assign IRQs and setup rvecs.
+ * @nn:		NFP Network structure
  */
-static void *nfp_net_rx_alloc_one(struct nfp_net_dp *dp, dma_addr_t *dma_addr)
+static void nfp_net_vecs_init(struct nfp_net *nn)
 {
-	void *frag;
+	struct nfp_net_r_vector *r_vec;
+	int r;
 
-	if (!dp->xdp_prog) {
-		frag = netdev_alloc_frag(dp->fl_bufsz);
-	} else {
-		struct page *page;
+	nn->lsc_handler = nfp_net_irq_lsc;
+	nn->exn_handler = nfp_net_irq_exn;
 
-		page = alloc_page(GFP_KERNEL);
-		frag = page ? page_address(page) : NULL;
-	}
-	if (!frag) {
-		nn_dp_warn(dp, "Failed to alloc receive page frag\n");
-		return NULL;
-	}
+	for (r = 0; r < nn->max_r_vecs; r++) {
+		struct msix_entry *entry;
 
-	*dma_addr = nfp_net_dma_map_rx(dp, frag);
-	if (dma_mapping_error(dp->dev, *dma_addr)) {
-		nfp_net_free_frag(frag, dp->xdp_prog);
-		nn_dp_warn(dp, "Failed to map DMA RX buffer\n");
-		return NULL;
-	}
+		entry = &nn->irq_entries[NFP_NET_NON_Q_VECTORS + r];
 
-	return frag;
-}
+		r_vec = &nn->r_vecs[r];
+		r_vec->nfp_net = nn;
+		r_vec->irq_entry = entry->entry;
+		r_vec->irq_vector = entry->vector;
 
-static void *nfp_net_napi_alloc_one(struct nfp_net_dp *dp, dma_addr_t *dma_addr)
-{
-	void *frag;
+		if (nn->dp.netdev) {
+			r_vec->handler = nfp_net_irq_rxtx;
+		} else {
+			r_vec->handler = nfp_ctrl_irq_rxtx;
 
-	if (!dp->xdp_prog) {
-		frag = napi_alloc_frag(dp->fl_bufsz);
-		if (unlikely(!frag))
-			return NULL;
-	} else {
-		struct page *page;
-
-		page = dev_alloc_page();
-		if (unlikely(!page))
-			return NULL;
-		frag = page_address(page);
-	}
-
-	*dma_addr = nfp_net_dma_map_rx(dp, frag);
-	if (dma_mapping_error(dp->dev, *dma_addr)) {
-		nfp_net_free_frag(frag, dp->xdp_prog);
-		nn_dp_warn(dp, "Failed to map DMA RX buffer\n");
-		return NULL;
-	}
-
-	return frag;
-}
-
-/**
- * nfp_net_rx_give_one() - Put mapped skb on the software and hardware rings
- * @dp:		NFP Net data path struct
- * @rx_ring:	RX ring structure
- * @frag:	page fragment buffer
- * @dma_addr:	DMA address of skb mapping
- */
-static void nfp_net_rx_give_one(const struct nfp_net_dp *dp,
-				struct nfp_net_rx_ring *rx_ring,
-				void *frag, dma_addr_t dma_addr)
-{
-	unsigned int wr_idx;
-
-	wr_idx = D_IDX(rx_ring, rx_ring->wr_p);
-
-	nfp_net_dma_sync_dev_rx(dp, dma_addr);
-
-	/* Stash SKB and DMA address away */
-	rx_ring->rxbufs[wr_idx].frag = frag;
-	rx_ring->rxbufs[wr_idx].dma_addr = dma_addr;
-
-	/* Fill freelist descriptor */
-	rx_ring->rxds[wr_idx].fld.reserved = 0;
-	rx_ring->rxds[wr_idx].fld.meta_len_dd = 0;
-	nfp_desc_set_dma_addr(&rx_ring->rxds[wr_idx].fld,
-			      dma_addr + dp->rx_dma_off);
-
-	rx_ring->wr_p++;
-	if (!(rx_ring->wr_p % NFP_NET_FL_BATCH)) {
-		/* Update write pointer of the freelist queue. Make
-		 * sure all writes are flushed before telling the hardware.
-		 */
-		wmb();
-		nfp_qcp_wr_ptr_add(rx_ring->qcp_fl, NFP_NET_FL_BATCH);
-	}
-}
-
-/**
- * nfp_net_rx_ring_reset() - Reflect in SW state of freelist after disable
- * @rx_ring:	RX ring structure
- *
- * Assumes that the device is stopped, must be idempotent.
- */
-static void nfp_net_rx_ring_reset(struct nfp_net_rx_ring *rx_ring)
-{
-	unsigned int wr_idx, last_idx;
-
-	/* wr_p == rd_p means ring was never fed FL bufs.  RX rings are always
-	 * kept at cnt - 1 FL bufs.
-	 */
-	if (rx_ring->wr_p == 0 && rx_ring->rd_p == 0)
-		return;
-
-	/* Move the empty entry to the end of the list */
-	wr_idx = D_IDX(rx_ring, rx_ring->wr_p);
-	last_idx = rx_ring->cnt - 1;
-	if (rx_ring->r_vec->xsk_pool) {
-		rx_ring->xsk_rxbufs[wr_idx] = rx_ring->xsk_rxbufs[last_idx];
-		memset(&rx_ring->xsk_rxbufs[last_idx], 0,
-		       sizeof(*rx_ring->xsk_rxbufs));
-	} else {
-		rx_ring->rxbufs[wr_idx] = rx_ring->rxbufs[last_idx];
-		memset(&rx_ring->rxbufs[last_idx], 0, sizeof(*rx_ring->rxbufs));
-	}
-
-	memset(rx_ring->rxds, 0, rx_ring->size);
-	rx_ring->wr_p = 0;
-	rx_ring->rd_p = 0;
-}
-
-/**
- * nfp_net_rx_ring_bufs_free() - Free any buffers currently on the RX ring
- * @dp:		NFP Net data path struct
- * @rx_ring:	RX ring to remove buffers from
- *
- * Assumes that the device is stopped and buffers are in [0, ring->cnt - 1)
- * entries.  After device is disabled nfp_net_rx_ring_reset() must be called
- * to restore required ring geometry.
- */
-static void
-nfp_net_rx_ring_bufs_free(struct nfp_net_dp *dp,
-			  struct nfp_net_rx_ring *rx_ring)
-{
-	unsigned int i;
-
-	if (nfp_net_has_xsk_pool_slow(dp, rx_ring->idx))
-		return;
-
-	for (i = 0; i < rx_ring->cnt - 1; i++) {
-		/* NULL skb can only happen when initial filling of the ring
-		 * fails to allocate enough buffers and calls here to free
-		 * already allocated ones.
-		 */
-		if (!rx_ring->rxbufs[i].frag)
-			continue;
-
-		nfp_net_dma_unmap_rx(dp, rx_ring->rxbufs[i].dma_addr);
-		nfp_net_free_frag(rx_ring->rxbufs[i].frag, dp->xdp_prog);
-		rx_ring->rxbufs[i].dma_addr = 0;
-		rx_ring->rxbufs[i].frag = NULL;
-	}
-}
-
-/**
- * nfp_net_rx_ring_bufs_alloc() - Fill RX ring with buffers (don't give to FW)
- * @dp:		NFP Net data path struct
- * @rx_ring:	RX ring to remove buffers from
- */
-static int
-nfp_net_rx_ring_bufs_alloc(struct nfp_net_dp *dp,
-			   struct nfp_net_rx_ring *rx_ring)
-{
-	struct nfp_net_rx_buf *rxbufs;
-	unsigned int i;
-
-	if (nfp_net_has_xsk_pool_slow(dp, rx_ring->idx))
-		return 0;
-
-	rxbufs = rx_ring->rxbufs;
-
-	for (i = 0; i < rx_ring->cnt - 1; i++) {
-		rxbufs[i].frag = nfp_net_rx_alloc_one(dp, &rxbufs[i].dma_addr);
-		if (!rxbufs[i].frag) {
-			nfp_net_rx_ring_bufs_free(dp, rx_ring);
-			return -ENOMEM;
-		}
-	}
-
-	return 0;
-}
-
-/**
- * nfp_net_rx_ring_fill_freelist() - Give buffers from the ring to FW
- * @dp:	     NFP Net data path struct
- * @rx_ring: RX ring to fill
- */
-static void
-nfp_net_rx_ring_fill_freelist(struct nfp_net_dp *dp,
-			      struct nfp_net_rx_ring *rx_ring)
-{
-	unsigned int i;
-
-	if (nfp_net_has_xsk_pool_slow(dp, rx_ring->idx))
-		return nfp_net_xsk_rx_ring_fill_freelist(rx_ring);
-
-	for (i = 0; i < rx_ring->cnt - 1; i++)
-		nfp_net_rx_give_one(dp, rx_ring, rx_ring->rxbufs[i].frag,
-				    rx_ring->rxbufs[i].dma_addr);
-}
-
-/**
- * nfp_net_rx_csum_has_errors() - group check if rxd has any csum errors
- * @flags: RX descriptor flags field in CPU byte order
- */
-static int nfp_net_rx_csum_has_errors(u16 flags)
-{
-	u16 csum_all_checked, csum_all_ok;
-
-	csum_all_checked = flags & __PCIE_DESC_RX_CSUM_ALL;
-	csum_all_ok = flags & __PCIE_DESC_RX_CSUM_ALL_OK;
-
-	return csum_all_checked != (csum_all_ok << PCIE_DESC_RX_CSUM_OK_SHIFT);
-}
-
-/**
- * nfp_net_rx_csum() - set SKB checksum field based on RX descriptor flags
- * @dp:  NFP Net data path struct
- * @r_vec: per-ring structure
- * @rxd: Pointer to RX descriptor
- * @meta: Parsed metadata prepend
- * @skb: Pointer to SKB
- */
-void nfp_net_rx_csum(const struct nfp_net_dp *dp,
-		     struct nfp_net_r_vector *r_vec,
-		     const struct nfp_net_rx_desc *rxd,
-		     const struct nfp_meta_parsed *meta, struct sk_buff *skb)
-{
-	skb_checksum_none_assert(skb);
-
-	if (!(dp->netdev->features & NETIF_F_RXCSUM))
-		return;
-
-	if (meta->csum_type) {
-		skb->ip_summed = meta->csum_type;
-		skb->csum = meta->csum;
-		u64_stats_update_begin(&r_vec->rx_sync);
-		r_vec->hw_csum_rx_complete++;
-		u64_stats_update_end(&r_vec->rx_sync);
-		return;
-	}
-
-	if (nfp_net_rx_csum_has_errors(le16_to_cpu(rxd->rxd.flags))) {
-		u64_stats_update_begin(&r_vec->rx_sync);
-		r_vec->hw_csum_rx_error++;
-		u64_stats_update_end(&r_vec->rx_sync);
-		return;
-	}
-
-	/* Assume that the firmware will never report inner CSUM_OK unless outer
-	 * L4 headers were successfully parsed. FW will always report zero UDP
-	 * checksum as CSUM_OK.
-	 */
-	if (rxd->rxd.flags & PCIE_DESC_RX_TCP_CSUM_OK ||
-	    rxd->rxd.flags & PCIE_DESC_RX_UDP_CSUM_OK) {
-		__skb_incr_checksum_unnecessary(skb);
-		u64_stats_update_begin(&r_vec->rx_sync);
-		r_vec->hw_csum_rx_ok++;
-		u64_stats_update_end(&r_vec->rx_sync);
-	}
-
-	if (rxd->rxd.flags & PCIE_DESC_RX_I_TCP_CSUM_OK ||
-	    rxd->rxd.flags & PCIE_DESC_RX_I_UDP_CSUM_OK) {
-		__skb_incr_checksum_unnecessary(skb);
-		u64_stats_update_begin(&r_vec->rx_sync);
-		r_vec->hw_csum_rx_inner_ok++;
-		u64_stats_update_end(&r_vec->rx_sync);
-	}
-}
-
-static void
-nfp_net_set_hash(struct net_device *netdev, struct nfp_meta_parsed *meta,
-		 unsigned int type, __be32 *hash)
-{
-	if (!(netdev->features & NETIF_F_RXHASH))
-		return;
-
-	switch (type) {
-	case NFP_NET_RSS_IPV4:
-	case NFP_NET_RSS_IPV6:
-	case NFP_NET_RSS_IPV6_EX:
-		meta->hash_type = PKT_HASH_TYPE_L3;
-		break;
-	default:
-		meta->hash_type = PKT_HASH_TYPE_L4;
-		break;
-	}
-
-	meta->hash = get_unaligned_be32(hash);
-}
-
-static void
-nfp_net_set_hash_desc(struct net_device *netdev, struct nfp_meta_parsed *meta,
-		      void *data, struct nfp_net_rx_desc *rxd)
-{
-	struct nfp_net_rx_hash *rx_hash = data;
-
-	if (!(rxd->rxd.flags & PCIE_DESC_RX_RSS))
-		return;
-
-	nfp_net_set_hash(netdev, meta, get_unaligned_be32(&rx_hash->hash_type),
-			 &rx_hash->hash);
-}
-
-bool
-nfp_net_parse_meta(struct net_device *netdev, struct nfp_meta_parsed *meta,
-		   void *data, void *pkt, unsigned int pkt_len, int meta_len)
-{
-	u32 meta_info;
-
-	meta_info = get_unaligned_be32(data);
-	data += 4;
-
-	while (meta_info) {
-		switch (meta_info & NFP_NET_META_FIELD_MASK) {
-		case NFP_NET_META_HASH:
-			meta_info >>= NFP_NET_META_FIELD_SIZE;
-			nfp_net_set_hash(netdev, meta,
-					 meta_info & NFP_NET_META_FIELD_MASK,
-					 (__be32 *)data);
-			data += 4;
-			break;
-		case NFP_NET_META_MARK:
-			meta->mark = get_unaligned_be32(data);
-			data += 4;
-			break;
-		case NFP_NET_META_PORTID:
-			meta->portid = get_unaligned_be32(data);
-			data += 4;
-			break;
-		case NFP_NET_META_CSUM:
-			meta->csum_type = CHECKSUM_COMPLETE;
-			meta->csum =
-				(__force __wsum)__get_unaligned_cpu32(data);
-			data += 4;
-			break;
-		case NFP_NET_META_RESYNC_INFO:
-			if (nfp_net_tls_rx_resync_req(netdev, data, pkt,
-						      pkt_len))
-				return false;
-			data += sizeof(struct nfp_net_tls_resync_req);
-			break;
-		default:
-			return true;
-		}
-
-		meta_info >>= NFP_NET_META_FIELD_SIZE;
-	}
-
-	return data != pkt;
-}
-
-static void
-nfp_net_rx_drop(const struct nfp_net_dp *dp, struct nfp_net_r_vector *r_vec,
-		struct nfp_net_rx_ring *rx_ring, struct nfp_net_rx_buf *rxbuf,
-		struct sk_buff *skb)
-{
-	u64_stats_update_begin(&r_vec->rx_sync);
-	r_vec->rx_drops++;
-	/* If we have both skb and rxbuf the replacement buffer allocation
-	 * must have failed, count this as an alloc failure.
-	 */
-	if (skb && rxbuf)
-		r_vec->rx_replace_buf_alloc_fail++;
-	u64_stats_update_end(&r_vec->rx_sync);
-
-	/* skb is build based on the frag, free_skb() would free the frag
-	 * so to be able to reuse it we need an extra ref.
-	 */
-	if (skb && rxbuf && skb->head == rxbuf->frag)
-		page_ref_inc(virt_to_head_page(rxbuf->frag));
-	if (rxbuf)
-		nfp_net_rx_give_one(dp, rx_ring, rxbuf->frag, rxbuf->dma_addr);
-	if (skb)
-		dev_kfree_skb_any(skb);
-}
-
-static bool
-nfp_net_tx_xdp_buf(struct nfp_net_dp *dp, struct nfp_net_rx_ring *rx_ring,
-		   struct nfp_net_tx_ring *tx_ring,
-		   struct nfp_net_rx_buf *rxbuf, unsigned int dma_off,
-		   unsigned int pkt_len, bool *completed)
-{
-	unsigned int dma_map_sz = dp->fl_bufsz - NFP_NET_RX_BUF_NON_DATA;
-	struct nfp_net_tx_buf *txbuf;
-	struct nfp_net_tx_desc *txd;
-	int wr_idx;
-
-	/* Reject if xdp_adjust_tail grow packet beyond DMA area */
-	if (pkt_len + dma_off > dma_map_sz)
-		return false;
-
-	if (unlikely(nfp_net_tx_full(tx_ring, 1))) {
-		if (!*completed) {
-			nfp_net_xdp_complete(tx_ring);
-			*completed = true;
-		}
-
-		if (unlikely(nfp_net_tx_full(tx_ring, 1))) {
-			nfp_net_rx_drop(dp, rx_ring->r_vec, rx_ring, rxbuf,
-					NULL);
-			return false;
-		}
-	}
-
-	wr_idx = D_IDX(tx_ring, tx_ring->wr_p);
-
-	/* Stash the soft descriptor of the head then initialize it */
-	txbuf = &tx_ring->txbufs[wr_idx];
-
-	nfp_net_rx_give_one(dp, rx_ring, txbuf->frag, txbuf->dma_addr);
-
-	txbuf->frag = rxbuf->frag;
-	txbuf->dma_addr = rxbuf->dma_addr;
-	txbuf->fidx = -1;
-	txbuf->pkt_cnt = 1;
-	txbuf->real_len = pkt_len;
-
-	dma_sync_single_for_device(dp->dev, rxbuf->dma_addr + dma_off,
-				   pkt_len, DMA_BIDIRECTIONAL);
-
-	/* Build TX descriptor */
-	txd = &tx_ring->txds[wr_idx];
-	txd->offset_eop = PCIE_DESC_TX_EOP;
-	txd->dma_len = cpu_to_le16(pkt_len);
-	nfp_desc_set_dma_addr(txd, rxbuf->dma_addr + dma_off);
-	txd->data_len = cpu_to_le16(pkt_len);
-
-	txd->flags = 0;
-	txd->mss = 0;
-	txd->lso_hdrlen = 0;
-
-	tx_ring->wr_p++;
-	tx_ring->wr_ptr_add++;
-	return true;
-}
-
-/**
- * nfp_net_rx() - receive up to @budget packets on @rx_ring
- * @rx_ring:   RX ring to receive from
- * @budget:    NAPI budget
- *
- * Note, this function is separated out from the napi poll function to
- * more cleanly separate packet receive code from other bookkeeping
- * functions performed in the napi poll function.
- *
- * Return: Number of packets received.
- */
-static int nfp_net_rx(struct nfp_net_rx_ring *rx_ring, int budget)
-{
-	struct nfp_net_r_vector *r_vec = rx_ring->r_vec;
-	struct nfp_net_dp *dp = &r_vec->nfp_net->dp;
-	struct nfp_net_tx_ring *tx_ring;
-	struct bpf_prog *xdp_prog;
-	bool xdp_tx_cmpl = false;
-	unsigned int true_bufsz;
-	struct sk_buff *skb;
-	int pkts_polled = 0;
-	struct xdp_buff xdp;
-	int idx;
-
-	xdp_prog = READ_ONCE(dp->xdp_prog);
-	true_bufsz = xdp_prog ? PAGE_SIZE : dp->fl_bufsz;
-	xdp_init_buff(&xdp, PAGE_SIZE - NFP_NET_RX_BUF_HEADROOM,
-		      &rx_ring->xdp_rxq);
-	tx_ring = r_vec->xdp_ring;
-
-	while (pkts_polled < budget) {
-		unsigned int meta_len, data_len, meta_off, pkt_len, pkt_off;
-		struct nfp_net_rx_buf *rxbuf;
-		struct nfp_net_rx_desc *rxd;
-		struct nfp_meta_parsed meta;
-		bool redir_egress = false;
-		struct net_device *netdev;
-		dma_addr_t new_dma_addr;
-		u32 meta_len_xdp = 0;
-		void *new_frag;
-
-		idx = D_IDX(rx_ring, rx_ring->rd_p);
-
-		rxd = &rx_ring->rxds[idx];
-		if (!(rxd->rxd.meta_len_dd & PCIE_DESC_RX_DD))
-			break;
-
-		/* Memory barrier to ensure that we won't do other reads
-		 * before the DD bit.
-		 */
-		dma_rmb();
-
-		memset(&meta, 0, sizeof(meta));
-
-		rx_ring->rd_p++;
-		pkts_polled++;
-
-		rxbuf =	&rx_ring->rxbufs[idx];
-		/*         < meta_len >
-		 *  <-- [rx_offset] -->
-		 *  ---------------------------------------------------------
-		 * | [XX] |  metadata  |             packet           | XXXX |
-		 *  ---------------------------------------------------------
-		 *         <---------------- data_len --------------->
-		 *
-		 * The rx_offset is fixed for all packets, the meta_len can vary
-		 * on a packet by packet basis. If rx_offset is set to zero
-		 * (_RX_OFFSET_DYNAMIC) metadata starts at the beginning of the
-		 * buffer and is immediately followed by the packet (no [XX]).
-		 */
-		meta_len = rxd->rxd.meta_len_dd & PCIE_DESC_RX_META_LEN_MASK;
-		data_len = le16_to_cpu(rxd->rxd.data_len);
-		pkt_len = data_len - meta_len;
-
-		pkt_off = NFP_NET_RX_BUF_HEADROOM + dp->rx_dma_off;
-		if (dp->rx_offset == NFP_NET_CFG_RX_OFFSET_DYNAMIC)
-			pkt_off += meta_len;
-		else
-			pkt_off += dp->rx_offset;
-		meta_off = pkt_off - meta_len;
-
-		/* Stats update */
-		u64_stats_update_begin(&r_vec->rx_sync);
-		r_vec->rx_pkts++;
-		r_vec->rx_bytes += pkt_len;
-		u64_stats_update_end(&r_vec->rx_sync);
-
-		if (unlikely(meta_len > NFP_NET_MAX_PREPEND ||
-			     (dp->rx_offset && meta_len > dp->rx_offset))) {
-			nn_dp_warn(dp, "oversized RX packet metadata %u\n",
-				   meta_len);
-			nfp_net_rx_drop(dp, r_vec, rx_ring, rxbuf, NULL);
-			continue;
-		}
-
-		nfp_net_dma_sync_cpu_rx(dp, rxbuf->dma_addr + meta_off,
-					data_len);
-
-		if (!dp->chained_metadata_format) {
-			nfp_net_set_hash_desc(dp->netdev, &meta,
-					      rxbuf->frag + meta_off, rxd);
-		} else if (meta_len) {
-			if (unlikely(nfp_net_parse_meta(dp->netdev, &meta,
-							rxbuf->frag + meta_off,
-							rxbuf->frag + pkt_off,
-							pkt_len, meta_len))) {
-				nn_dp_warn(dp, "invalid RX packet metadata\n");
-				nfp_net_rx_drop(dp, r_vec, rx_ring, rxbuf,
-						NULL);
-				continue;
-			}
-		}
-
-		if (xdp_prog && !meta.portid) {
-			void *orig_data = rxbuf->frag + pkt_off;
-			unsigned int dma_off;
-			int act;
-
-			xdp_prepare_buff(&xdp,
-					 rxbuf->frag + NFP_NET_RX_BUF_HEADROOM,
-					 pkt_off - NFP_NET_RX_BUF_HEADROOM,
-					 pkt_len, true);
-
-			act = bpf_prog_run_xdp(xdp_prog, &xdp);
-
-			pkt_len = xdp.data_end - xdp.data;
-			pkt_off += xdp.data - orig_data;
-
-			switch (act) {
-			case XDP_PASS:
-				meta_len_xdp = xdp.data - xdp.data_meta;
-				break;
-			case XDP_TX:
-				dma_off = pkt_off - NFP_NET_RX_BUF_HEADROOM;
-				if (unlikely(!nfp_net_tx_xdp_buf(dp, rx_ring,
-								 tx_ring, rxbuf,
-								 dma_off,
-								 pkt_len,
-								 &xdp_tx_cmpl)))
-					trace_xdp_exception(dp->netdev,
-							    xdp_prog, act);
-				continue;
-			default:
-				bpf_warn_invalid_xdp_action(dp->netdev, xdp_prog, act);
-				fallthrough;
-			case XDP_ABORTED:
-				trace_xdp_exception(dp->netdev, xdp_prog, act);
-				fallthrough;
-			case XDP_DROP:
-				nfp_net_rx_give_one(dp, rx_ring, rxbuf->frag,
-						    rxbuf->dma_addr);
-				continue;
-			}
-		}
-
-		if (likely(!meta.portid)) {
-			netdev = dp->netdev;
-		} else if (meta.portid == NFP_META_PORT_ID_CTRL) {
-			struct nfp_net *nn = netdev_priv(dp->netdev);
-
-			nfp_app_ctrl_rx_raw(nn->app, rxbuf->frag + pkt_off,
-					    pkt_len);
-			nfp_net_rx_give_one(dp, rx_ring, rxbuf->frag,
-					    rxbuf->dma_addr);
-			continue;
-		} else {
-			struct nfp_net *nn;
-
-			nn = netdev_priv(dp->netdev);
-			netdev = nfp_app_dev_get(nn->app, meta.portid,
-						 &redir_egress);
-			if (unlikely(!netdev)) {
-				nfp_net_rx_drop(dp, r_vec, rx_ring, rxbuf,
-						NULL);
-				continue;
-			}
-
-			if (nfp_netdev_is_nfp_repr(netdev))
-				nfp_repr_inc_rx_stats(netdev, pkt_len);
-		}
-
-		skb = build_skb(rxbuf->frag, true_bufsz);
-		if (unlikely(!skb)) {
-			nfp_net_rx_drop(dp, r_vec, rx_ring, rxbuf, NULL);
-			continue;
-		}
-		new_frag = nfp_net_napi_alloc_one(dp, &new_dma_addr);
-		if (unlikely(!new_frag)) {
-			nfp_net_rx_drop(dp, r_vec, rx_ring, rxbuf, skb);
-			continue;
-		}
-
-		nfp_net_dma_unmap_rx(dp, rxbuf->dma_addr);
-
-		nfp_net_rx_give_one(dp, rx_ring, new_frag, new_dma_addr);
-
-		skb_reserve(skb, pkt_off);
-		skb_put(skb, pkt_len);
-
-		skb->mark = meta.mark;
-		skb_set_hash(skb, meta.hash, meta.hash_type);
-
-		skb_record_rx_queue(skb, rx_ring->idx);
-		skb->protocol = eth_type_trans(skb, netdev);
-
-		nfp_net_rx_csum(dp, r_vec, rxd, &meta, skb);
-
-#ifdef CONFIG_TLS_DEVICE
-		if (rxd->rxd.flags & PCIE_DESC_RX_DECRYPTED) {
-			skb->decrypted = true;
-			u64_stats_update_begin(&r_vec->rx_sync);
-			r_vec->hw_tls_rx++;
-			u64_stats_update_end(&r_vec->rx_sync);
-		}
-#endif
-
-		if (rxd->rxd.flags & PCIE_DESC_RX_VLAN)
-			__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q),
-					       le16_to_cpu(rxd->rxd.vlan));
-		if (meta_len_xdp)
-			skb_metadata_set(skb, meta_len_xdp);
-
-		if (likely(!redir_egress)) {
-			napi_gro_receive(&rx_ring->r_vec->napi, skb);
-		} else {
-			skb->dev = netdev;
-			skb_reset_network_header(skb);
-			__skb_push(skb, ETH_HLEN);
-			dev_queue_xmit(skb);
-		}
-	}
-
-	if (xdp_prog) {
-		if (tx_ring->wr_ptr_add)
-			nfp_net_tx_xmit_more_flush(tx_ring);
-		else if (unlikely(tx_ring->wr_p != tx_ring->rd_p) &&
-			 !xdp_tx_cmpl)
-			if (!nfp_net_xdp_complete(tx_ring))
-				pkts_polled = budget;
-	}
-
-	return pkts_polled;
-}
-
-/**
- * nfp_net_poll() - napi poll function
- * @napi:    NAPI structure
- * @budget:  NAPI budget
- *
- * Return: number of packets polled.
- */
-static int nfp_net_poll(struct napi_struct *napi, int budget)
-{
-	struct nfp_net_r_vector *r_vec =
-		container_of(napi, struct nfp_net_r_vector, napi);
-	unsigned int pkts_polled = 0;
-
-	if (r_vec->tx_ring)
-		nfp_net_tx_complete(r_vec->tx_ring, budget);
-	if (r_vec->rx_ring)
-		pkts_polled = nfp_net_rx(r_vec->rx_ring, budget);
-
-	if (pkts_polled < budget)
-		if (napi_complete_done(napi, pkts_polled))
-			nfp_net_irq_unmask(r_vec->nfp_net, r_vec->irq_entry);
-
-	if (r_vec->nfp_net->rx_coalesce_adapt_on && r_vec->rx_ring) {
-		struct dim_sample dim_sample = {};
-		unsigned int start;
-		u64 pkts, bytes;
-
-		do {
-			start = u64_stats_fetch_begin(&r_vec->rx_sync);
-			pkts = r_vec->rx_pkts;
-			bytes = r_vec->rx_bytes;
-		} while (u64_stats_fetch_retry(&r_vec->rx_sync, start));
-
-		dim_update_sample(r_vec->event_ctr, pkts, bytes, &dim_sample);
-		net_dim(&r_vec->rx_dim, dim_sample);
-	}
-
-	if (r_vec->nfp_net->tx_coalesce_adapt_on && r_vec->tx_ring) {
-		struct dim_sample dim_sample = {};
-		unsigned int start;
-		u64 pkts, bytes;
-
-		do {
-			start = u64_stats_fetch_begin(&r_vec->tx_sync);
-			pkts = r_vec->tx_pkts;
-			bytes = r_vec->tx_bytes;
-		} while (u64_stats_fetch_retry(&r_vec->tx_sync, start));
-
-		dim_update_sample(r_vec->event_ctr, pkts, bytes, &dim_sample);
-		net_dim(&r_vec->tx_dim, dim_sample);
-	}
-
-	return pkts_polled;
-}
-
-/* Control device data path
- */
-
-static bool
-nfp_ctrl_tx_one(struct nfp_net *nn, struct nfp_net_r_vector *r_vec,
-		struct sk_buff *skb, bool old)
-{
-	unsigned int real_len = skb->len, meta_len = 0;
-	struct nfp_net_tx_ring *tx_ring;
-	struct nfp_net_tx_buf *txbuf;
-	struct nfp_net_tx_desc *txd;
-	struct nfp_net_dp *dp;
-	dma_addr_t dma_addr;
-	int wr_idx;
-
-	dp = &r_vec->nfp_net->dp;
-	tx_ring = r_vec->tx_ring;
-
-	if (WARN_ON_ONCE(skb_shinfo(skb)->nr_frags)) {
-		nn_dp_warn(dp, "Driver's CTRL TX does not implement gather\n");
-		goto err_free;
-	}
-
-	if (unlikely(nfp_net_tx_full(tx_ring, 1))) {
-		u64_stats_update_begin(&r_vec->tx_sync);
-		r_vec->tx_busy++;
-		u64_stats_update_end(&r_vec->tx_sync);
-		if (!old)
-			__skb_queue_tail(&r_vec->queue, skb);
-		else
-			__skb_queue_head(&r_vec->queue, skb);
-		return true;
-	}
-
-	if (nfp_app_ctrl_has_meta(nn->app)) {
-		if (unlikely(skb_headroom(skb) < 8)) {
-			nn_dp_warn(dp, "CTRL TX on skb without headroom\n");
-			goto err_free;
-		}
-		meta_len = 8;
-		put_unaligned_be32(NFP_META_PORT_ID_CTRL, skb_push(skb, 4));
-		put_unaligned_be32(NFP_NET_META_PORTID, skb_push(skb, 4));
-	}
-
-	/* Start with the head skbuf */
-	dma_addr = dma_map_single(dp->dev, skb->data, skb_headlen(skb),
-				  DMA_TO_DEVICE);
-	if (dma_mapping_error(dp->dev, dma_addr))
-		goto err_dma_warn;
-
-	wr_idx = D_IDX(tx_ring, tx_ring->wr_p);
-
-	/* Stash the soft descriptor of the head then initialize it */
-	txbuf = &tx_ring->txbufs[wr_idx];
-	txbuf->skb = skb;
-	txbuf->dma_addr = dma_addr;
-	txbuf->fidx = -1;
-	txbuf->pkt_cnt = 1;
-	txbuf->real_len = real_len;
-
-	/* Build TX descriptor */
-	txd = &tx_ring->txds[wr_idx];
-	txd->offset_eop = meta_len | PCIE_DESC_TX_EOP;
-	txd->dma_len = cpu_to_le16(skb_headlen(skb));
-	nfp_desc_set_dma_addr(txd, dma_addr);
-	txd->data_len = cpu_to_le16(skb->len);
-
-	txd->flags = 0;
-	txd->mss = 0;
-	txd->lso_hdrlen = 0;
-
-	tx_ring->wr_p++;
-	tx_ring->wr_ptr_add++;
-	nfp_net_tx_xmit_more_flush(tx_ring);
-
-	return false;
-
-err_dma_warn:
-	nn_dp_warn(dp, "Failed to DMA map TX CTRL buffer\n");
-err_free:
-	u64_stats_update_begin(&r_vec->tx_sync);
-	r_vec->tx_errors++;
-	u64_stats_update_end(&r_vec->tx_sync);
-	dev_kfree_skb_any(skb);
-	return false;
-}
-
-bool __nfp_ctrl_tx(struct nfp_net *nn, struct sk_buff *skb)
-{
-	struct nfp_net_r_vector *r_vec = &nn->r_vecs[0];
-
-	return nfp_ctrl_tx_one(nn, r_vec, skb, false);
-}
-
-bool nfp_ctrl_tx(struct nfp_net *nn, struct sk_buff *skb)
-{
-	struct nfp_net_r_vector *r_vec = &nn->r_vecs[0];
-	bool ret;
-
-	spin_lock_bh(&r_vec->lock);
-	ret = nfp_ctrl_tx_one(nn, r_vec, skb, false);
-	spin_unlock_bh(&r_vec->lock);
-
-	return ret;
-}
-
-static void __nfp_ctrl_tx_queued(struct nfp_net_r_vector *r_vec)
-{
-	struct sk_buff *skb;
-
-	while ((skb = __skb_dequeue(&r_vec->queue)))
-		if (nfp_ctrl_tx_one(r_vec->nfp_net, r_vec, skb, true))
-			return;
-}
-
-static bool
-nfp_ctrl_meta_ok(struct nfp_net *nn, void *data, unsigned int meta_len)
-{
-	u32 meta_type, meta_tag;
-
-	if (!nfp_app_ctrl_has_meta(nn->app))
-		return !meta_len;
-
-	if (meta_len != 8)
-		return false;
-
-	meta_type = get_unaligned_be32(data);
-	meta_tag = get_unaligned_be32(data + 4);
-
-	return (meta_type == NFP_NET_META_PORTID &&
-		meta_tag == NFP_META_PORT_ID_CTRL);
-}
-
-static bool
-nfp_ctrl_rx_one(struct nfp_net *nn, struct nfp_net_dp *dp,
-		struct nfp_net_r_vector *r_vec, struct nfp_net_rx_ring *rx_ring)
-{
-	unsigned int meta_len, data_len, meta_off, pkt_len, pkt_off;
-	struct nfp_net_rx_buf *rxbuf;
-	struct nfp_net_rx_desc *rxd;
-	dma_addr_t new_dma_addr;
-	struct sk_buff *skb;
-	void *new_frag;
-	int idx;
-
-	idx = D_IDX(rx_ring, rx_ring->rd_p);
-
-	rxd = &rx_ring->rxds[idx];
-	if (!(rxd->rxd.meta_len_dd & PCIE_DESC_RX_DD))
-		return false;
-
-	/* Memory barrier to ensure that we won't do other reads
-	 * before the DD bit.
-	 */
-	dma_rmb();
-
-	rx_ring->rd_p++;
-
-	rxbuf =	&rx_ring->rxbufs[idx];
-	meta_len = rxd->rxd.meta_len_dd & PCIE_DESC_RX_META_LEN_MASK;
-	data_len = le16_to_cpu(rxd->rxd.data_len);
-	pkt_len = data_len - meta_len;
-
-	pkt_off = NFP_NET_RX_BUF_HEADROOM + dp->rx_dma_off;
-	if (dp->rx_offset == NFP_NET_CFG_RX_OFFSET_DYNAMIC)
-		pkt_off += meta_len;
-	else
-		pkt_off += dp->rx_offset;
-	meta_off = pkt_off - meta_len;
-
-	/* Stats update */
-	u64_stats_update_begin(&r_vec->rx_sync);
-	r_vec->rx_pkts++;
-	r_vec->rx_bytes += pkt_len;
-	u64_stats_update_end(&r_vec->rx_sync);
-
-	nfp_net_dma_sync_cpu_rx(dp, rxbuf->dma_addr + meta_off,	data_len);
-
-	if (unlikely(!nfp_ctrl_meta_ok(nn, rxbuf->frag + meta_off, meta_len))) {
-		nn_dp_warn(dp, "incorrect metadata for ctrl packet (%d)\n",
-			   meta_len);
-		nfp_net_rx_drop(dp, r_vec, rx_ring, rxbuf, NULL);
-		return true;
-	}
-
-	skb = build_skb(rxbuf->frag, dp->fl_bufsz);
-	if (unlikely(!skb)) {
-		nfp_net_rx_drop(dp, r_vec, rx_ring, rxbuf, NULL);
-		return true;
-	}
-	new_frag = nfp_net_napi_alloc_one(dp, &new_dma_addr);
-	if (unlikely(!new_frag)) {
-		nfp_net_rx_drop(dp, r_vec, rx_ring, rxbuf, skb);
-		return true;
-	}
-
-	nfp_net_dma_unmap_rx(dp, rxbuf->dma_addr);
-
-	nfp_net_rx_give_one(dp, rx_ring, new_frag, new_dma_addr);
-
-	skb_reserve(skb, pkt_off);
-	skb_put(skb, pkt_len);
-
-	nfp_app_ctrl_rx(nn->app, skb);
-
-	return true;
-}
-
-static bool nfp_ctrl_rx(struct nfp_net_r_vector *r_vec)
-{
-	struct nfp_net_rx_ring *rx_ring = r_vec->rx_ring;
-	struct nfp_net *nn = r_vec->nfp_net;
-	struct nfp_net_dp *dp = &nn->dp;
-	unsigned int budget = 512;
-
-	while (nfp_ctrl_rx_one(nn, dp, r_vec, rx_ring) && budget--)
-		continue;
-
-	return budget;
-}
-
-static void nfp_ctrl_poll(struct tasklet_struct *t)
-{
-	struct nfp_net_r_vector *r_vec = from_tasklet(r_vec, t, tasklet);
-
-	spin_lock(&r_vec->lock);
-	nfp_net_tx_complete(r_vec->tx_ring, 0);
-	__nfp_ctrl_tx_queued(r_vec);
-	spin_unlock(&r_vec->lock);
-
-	if (nfp_ctrl_rx(r_vec)) {
-		nfp_net_irq_unmask(r_vec->nfp_net, r_vec->irq_entry);
-	} else {
-		tasklet_schedule(&r_vec->tasklet);
-		nn_dp_warn(&r_vec->nfp_net->dp,
-			   "control message budget exceeded!\n");
-	}
-}
-
-/* Setup and Configuration
- */
-
-/**
- * nfp_net_vecs_init() - Assign IRQs and setup rvecs.
- * @nn:		NFP Network structure
- */
-static void nfp_net_vecs_init(struct nfp_net *nn)
-{
-	struct nfp_net_r_vector *r_vec;
-	int r;
-
-	nn->lsc_handler = nfp_net_irq_lsc;
-	nn->exn_handler = nfp_net_irq_exn;
-
-	for (r = 0; r < nn->max_r_vecs; r++) {
-		struct msix_entry *entry;
-
-		entry = &nn->irq_entries[NFP_NET_NON_Q_VECTORS + r];
-
-		r_vec = &nn->r_vecs[r];
-		r_vec->nfp_net = nn;
-		r_vec->irq_entry = entry->entry;
-		r_vec->irq_vector = entry->vector;
-
-		if (nn->dp.netdev) {
-			r_vec->handler = nfp_net_irq_rxtx;
-		} else {
-			r_vec->handler = nfp_ctrl_irq_rxtx;
-
-			__skb_queue_head_init(&r_vec->queue);
-			spin_lock_init(&r_vec->lock);
-			tasklet_setup(&r_vec->tasklet, nfp_ctrl_poll);
-			tasklet_disable(&r_vec->tasklet);
-		}
+			__skb_queue_head_init(&r_vec->queue);
+			spin_lock_init(&r_vec->lock);
+			tasklet_setup(&r_vec->tasklet, nfp_nfd3_ctrl_poll);
+			tasklet_disable(&r_vec->tasklet);
+		}
 
 		cpumask_set_cpu(r, &r_vec->affinity_mask);
 	}
 }
 
-/**
- * nfp_net_tx_ring_free() - Free resources allocated to a TX ring
- * @tx_ring:   TX ring to free
- */
-static void nfp_net_tx_ring_free(struct nfp_net_tx_ring *tx_ring)
-{
-	struct nfp_net_r_vector *r_vec = tx_ring->r_vec;
-	struct nfp_net_dp *dp = &r_vec->nfp_net->dp;
-
-	kvfree(tx_ring->txbufs);
-
-	if (tx_ring->txds)
-		dma_free_coherent(dp->dev, tx_ring->size,
-				  tx_ring->txds, tx_ring->dma);
-
-	tx_ring->cnt = 0;
-	tx_ring->txbufs = NULL;
-	tx_ring->txds = NULL;
-	tx_ring->dma = 0;
-	tx_ring->size = 0;
-}
-
-/**
- * nfp_net_tx_ring_alloc() - Allocate resource for a TX ring
- * @dp:        NFP Net data path struct
- * @tx_ring:   TX Ring structure to allocate
- *
- * Return: 0 on success, negative errno otherwise.
- */
-static int
-nfp_net_tx_ring_alloc(struct nfp_net_dp *dp, struct nfp_net_tx_ring *tx_ring)
-{
-	struct nfp_net_r_vector *r_vec = tx_ring->r_vec;
-
-	tx_ring->cnt = dp->txd_cnt;
-
-	tx_ring->size = array_size(tx_ring->cnt, sizeof(*tx_ring->txds));
-	tx_ring->txds = dma_alloc_coherent(dp->dev, tx_ring->size,
-					   &tx_ring->dma,
-					   GFP_KERNEL | __GFP_NOWARN);
-	if (!tx_ring->txds) {
-		netdev_warn(dp->netdev, "failed to allocate TX descriptor ring memory, requested descriptor count: %d, consider lowering descriptor count\n",
-			    tx_ring->cnt);
-		goto err_alloc;
-	}
-
-	tx_ring->txbufs = kvcalloc(tx_ring->cnt, sizeof(*tx_ring->txbufs),
-				   GFP_KERNEL);
-	if (!tx_ring->txbufs)
-		goto err_alloc;
-
-	if (!tx_ring->is_xdp && dp->netdev)
-		netif_set_xps_queue(dp->netdev, &r_vec->affinity_mask,
-				    tx_ring->idx);
-
-	return 0;
-
-err_alloc:
-	nfp_net_tx_ring_free(tx_ring);
-	return -ENOMEM;
-}
-
-static void
-nfp_net_tx_ring_bufs_free(struct nfp_net_dp *dp,
-			  struct nfp_net_tx_ring *tx_ring)
-{
-	unsigned int i;
-
-	if (!tx_ring->is_xdp)
-		return;
-
-	for (i = 0; i < tx_ring->cnt; i++) {
-		if (!tx_ring->txbufs[i].frag)
-			return;
-
-		nfp_net_dma_unmap_rx(dp, tx_ring->txbufs[i].dma_addr);
-		__free_page(virt_to_page(tx_ring->txbufs[i].frag));
-	}
-}
-
-static int
-nfp_net_tx_ring_bufs_alloc(struct nfp_net_dp *dp,
-			   struct nfp_net_tx_ring *tx_ring)
-{
-	struct nfp_net_tx_buf *txbufs = tx_ring->txbufs;
-	unsigned int i;
-
-	if (!tx_ring->is_xdp)
-		return 0;
-
-	for (i = 0; i < tx_ring->cnt; i++) {
-		txbufs[i].frag = nfp_net_rx_alloc_one(dp, &txbufs[i].dma_addr);
-		if (!txbufs[i].frag) {
-			nfp_net_tx_ring_bufs_free(dp, tx_ring);
-			return -ENOMEM;
-		}
-	}
-
-	return 0;
-}
-
-static int nfp_net_tx_rings_prepare(struct nfp_net *nn, struct nfp_net_dp *dp)
-{
-	unsigned int r;
-
-	dp->tx_rings = kcalloc(dp->num_tx_rings, sizeof(*dp->tx_rings),
-			       GFP_KERNEL);
-	if (!dp->tx_rings)
-		return -ENOMEM;
-
-	for (r = 0; r < dp->num_tx_rings; r++) {
-		int bias = 0;
-
-		if (r >= dp->num_stack_tx_rings)
-			bias = dp->num_stack_tx_rings;
-
-		nfp_net_tx_ring_init(&dp->tx_rings[r], &nn->r_vecs[r - bias],
-				     r, bias);
-
-		if (nfp_net_tx_ring_alloc(dp, &dp->tx_rings[r]))
-			goto err_free_prev;
-
-		if (nfp_net_tx_ring_bufs_alloc(dp, &dp->tx_rings[r]))
-			goto err_free_ring;
-	}
-
-	return 0;
-
-err_free_prev:
-	while (r--) {
-		nfp_net_tx_ring_bufs_free(dp, &dp->tx_rings[r]);
-err_free_ring:
-		nfp_net_tx_ring_free(&dp->tx_rings[r]);
-	}
-	kfree(dp->tx_rings);
-	return -ENOMEM;
-}
-
-static void nfp_net_tx_rings_free(struct nfp_net_dp *dp)
-{
-	unsigned int r;
-
-	for (r = 0; r < dp->num_tx_rings; r++) {
-		nfp_net_tx_ring_bufs_free(dp, &dp->tx_rings[r]);
-		nfp_net_tx_ring_free(&dp->tx_rings[r]);
-	}
-
-	kfree(dp->tx_rings);
-}
-
-/**
- * nfp_net_rx_ring_free() - Free resources allocated to a RX ring
- * @rx_ring:  RX ring to free
- */
-static void nfp_net_rx_ring_free(struct nfp_net_rx_ring *rx_ring)
-{
-	struct nfp_net_r_vector *r_vec = rx_ring->r_vec;
-	struct nfp_net_dp *dp = &r_vec->nfp_net->dp;
-
-	if (dp->netdev)
-		xdp_rxq_info_unreg(&rx_ring->xdp_rxq);
-
-	if (nfp_net_has_xsk_pool_slow(dp, rx_ring->idx))
-		kvfree(rx_ring->xsk_rxbufs);
-	else
-		kvfree(rx_ring->rxbufs);
-
-	if (rx_ring->rxds)
-		dma_free_coherent(dp->dev, rx_ring->size,
-				  rx_ring->rxds, rx_ring->dma);
-
-	rx_ring->cnt = 0;
-	rx_ring->rxbufs = NULL;
-	rx_ring->xsk_rxbufs = NULL;
-	rx_ring->rxds = NULL;
-	rx_ring->dma = 0;
-	rx_ring->size = 0;
-}
-
-/**
- * nfp_net_rx_ring_alloc() - Allocate resource for a RX ring
- * @dp:	      NFP Net data path struct
- * @rx_ring:  RX ring to allocate
- *
- * Return: 0 on success, negative errno otherwise.
- */
-static int
-nfp_net_rx_ring_alloc(struct nfp_net_dp *dp, struct nfp_net_rx_ring *rx_ring)
-{
-	enum xdp_mem_type mem_type;
-	size_t rxbuf_sw_desc_sz;
-	int err;
-
-	if (nfp_net_has_xsk_pool_slow(dp, rx_ring->idx)) {
-		mem_type = MEM_TYPE_XSK_BUFF_POOL;
-		rxbuf_sw_desc_sz = sizeof(*rx_ring->xsk_rxbufs);
-	} else {
-		mem_type = MEM_TYPE_PAGE_ORDER0;
-		rxbuf_sw_desc_sz = sizeof(*rx_ring->rxbufs);
-	}
-
-	if (dp->netdev) {
-		err = xdp_rxq_info_reg(&rx_ring->xdp_rxq, dp->netdev,
-				       rx_ring->idx, rx_ring->r_vec->napi.napi_id);
-		if (err < 0)
-			return err;
-
-		err = xdp_rxq_info_reg_mem_model(&rx_ring->xdp_rxq,
-						 mem_type, NULL);
-		if (err)
-			goto err_alloc;
-	}
-
-	rx_ring->cnt = dp->rxd_cnt;
-	rx_ring->size = array_size(rx_ring->cnt, sizeof(*rx_ring->rxds));
-	rx_ring->rxds = dma_alloc_coherent(dp->dev, rx_ring->size,
-					   &rx_ring->dma,
-					   GFP_KERNEL | __GFP_NOWARN);
-	if (!rx_ring->rxds) {
-		netdev_warn(dp->netdev, "failed to allocate RX descriptor ring memory, requested descriptor count: %d, consider lowering descriptor count\n",
-			    rx_ring->cnt);
-		goto err_alloc;
-	}
-
-	if (nfp_net_has_xsk_pool_slow(dp, rx_ring->idx)) {
-		rx_ring->xsk_rxbufs = kvcalloc(rx_ring->cnt, rxbuf_sw_desc_sz,
-					       GFP_KERNEL);
-		if (!rx_ring->xsk_rxbufs)
-			goto err_alloc;
-	} else {
-		rx_ring->rxbufs = kvcalloc(rx_ring->cnt, rxbuf_sw_desc_sz,
-					   GFP_KERNEL);
-		if (!rx_ring->rxbufs)
-			goto err_alloc;
-	}
-
-	return 0;
-
-err_alloc:
-	nfp_net_rx_ring_free(rx_ring);
-	return -ENOMEM;
-}
-
-static int nfp_net_rx_rings_prepare(struct nfp_net *nn, struct nfp_net_dp *dp)
-{
-	unsigned int r;
-
-	dp->rx_rings = kcalloc(dp->num_rx_rings, sizeof(*dp->rx_rings),
-			       GFP_KERNEL);
-	if (!dp->rx_rings)
-		return -ENOMEM;
-
-	for (r = 0; r < dp->num_rx_rings; r++) {
-		nfp_net_rx_ring_init(&dp->rx_rings[r], &nn->r_vecs[r], r);
-
-		if (nfp_net_rx_ring_alloc(dp, &dp->rx_rings[r]))
-			goto err_free_prev;
-
-		if (nfp_net_rx_ring_bufs_alloc(dp, &dp->rx_rings[r]))
-			goto err_free_ring;
-	}
-
-	return 0;
-
-err_free_prev:
-	while (r--) {
-		nfp_net_rx_ring_bufs_free(dp, &dp->rx_rings[r]);
-err_free_ring:
-		nfp_net_rx_ring_free(&dp->rx_rings[r]);
-	}
-	kfree(dp->rx_rings);
-	return -ENOMEM;
-}
-
-static void nfp_net_rx_rings_free(struct nfp_net_dp *dp)
-{
-	unsigned int r;
-
-	for (r = 0; r < dp->num_rx_rings; r++) {
-		nfp_net_rx_ring_bufs_free(dp, &dp->rx_rings[r]);
-		nfp_net_rx_ring_free(&dp->rx_rings[r]);
-	}
-
-	kfree(dp->rx_rings);
-}
-
 static void
 nfp_net_napi_add(struct nfp_net_dp *dp, struct nfp_net_r_vector *r_vec, int idx)
 {
 	if (dp->netdev)
 		netif_napi_add(dp->netdev, &r_vec->napi,
 			       nfp_net_has_xsk_pool_slow(dp, idx) ?
-			       nfp_net_xsk_poll : nfp_net_poll,
+			       nfp_nfd3_xsk_poll : nfp_nfd3_poll,
 			       NAPI_POLL_WEIGHT);
 	else
 		tasklet_enable(&r_vec->tasklet);
@@ -2858,17 +911,6 @@ static void nfp_net_write_mac_addr(struct nfp_net *nn, const u8 *addr)
 	nn_writew(nn, NFP_NET_CFG_MACADDR + 6, get_unaligned_be16(addr + 4));
 }
 
-static void nfp_net_vec_clear_ring_data(struct nfp_net *nn, unsigned int idx)
-{
-	nn_writeq(nn, NFP_NET_CFG_RXR_ADDR(idx), 0);
-	nn_writeb(nn, NFP_NET_CFG_RXR_SZ(idx), 0);
-	nn_writeb(nn, NFP_NET_CFG_RXR_VEC(idx), 0);
-
-	nn_writeq(nn, NFP_NET_CFG_TXR_ADDR(idx), 0);
-	nn_writeb(nn, NFP_NET_CFG_TXR_SZ(idx), 0);
-	nn_writeb(nn, NFP_NET_CFG_TXR_VEC(idx), 0);
-}
-
 /**
  * nfp_net_clear_config_and_disable() - Clear control BAR and disable NFP
  * @nn:      NFP Net device to reconfigure
@@ -2911,25 +953,6 @@ static void nfp_net_clear_config_and_disable(struct nfp_net *nn)
 	nn->dp.ctrl = new_ctrl;
 }
 
-static void
-nfp_net_rx_ring_hw_cfg_write(struct nfp_net *nn,
-			     struct nfp_net_rx_ring *rx_ring, unsigned int idx)
-{
-	/* Write the DMA address, size and MSI-X info to the device */
-	nn_writeq(nn, NFP_NET_CFG_RXR_ADDR(idx), rx_ring->dma);
-	nn_writeb(nn, NFP_NET_CFG_RXR_SZ(idx), ilog2(rx_ring->cnt));
-	nn_writeb(nn, NFP_NET_CFG_RXR_VEC(idx), rx_ring->r_vec->irq_entry);
-}
-
-static void
-nfp_net_tx_ring_hw_cfg_write(struct nfp_net *nn,
-			     struct nfp_net_tx_ring *tx_ring, unsigned int idx)
-{
-	nn_writeq(nn, NFP_NET_CFG_TXR_ADDR(idx), tx_ring->dma);
-	nn_writeb(nn, NFP_NET_CFG_TXR_SZ(idx), ilog2(tx_ring->cnt));
-	nn_writeb(nn, NFP_NET_CFG_TXR_VEC(idx), tx_ring->r_vec->irq_entry);
-}
-
 /**
  * nfp_net_set_config_and_enable() - Write control BAR and enable NFP
  * @nn:      NFP Net device to reconfigure
@@ -3872,7 +1895,7 @@ const struct net_device_ops nfp_net_netdev_ops = {
 	.ndo_uninit		= nfp_app_ndo_uninit,
 	.ndo_open		= nfp_net_netdev_open,
 	.ndo_stop		= nfp_net_netdev_close,
-	.ndo_start_xmit		= nfp_net_tx,
+	.ndo_start_xmit		= nfp_nfd3_tx,
 	.ndo_get_stats64	= nfp_net_stat64,
 	.ndo_vlan_rx_add_vid	= nfp_net_vlan_rx_add_vid,
 	.ndo_vlan_rx_kill_vid	= nfp_net_vlan_rx_kill_vid,
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_debugfs.c b/drivers/net/ethernet/netronome/nfp/nfp_net_debugfs.c
index 2c74b3c5aef9..59b852e18758 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_debugfs.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_debugfs.c
@@ -1,10 +1,11 @@
 // SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
-/* Copyright (C) 2015-2018 Netronome Systems, Inc. */
+/* Copyright (C) 2015-2019 Netronome Systems, Inc. */
 #include <linux/debugfs.h>
 #include <linux/module.h>
 #include <linux/rtnetlink.h>
 
 #include "nfp_net.h"
+#include "nfp_net_dp.h"
 
 static struct dentry *nfp_dir;
 
@@ -80,10 +81,8 @@ static int nfp_tx_q_show(struct seq_file *file, void *data)
 {
 	struct nfp_net_r_vector *r_vec = file->private;
 	struct nfp_net_tx_ring *tx_ring;
-	struct nfp_net_tx_desc *txd;
-	int d_rd_p, d_wr_p, txd_cnt;
 	struct nfp_net *nn;
-	int i;
+	int d_rd_p, d_wr_p;
 
 	rtnl_lock();
 
@@ -97,8 +96,6 @@ static int nfp_tx_q_show(struct seq_file *file, void *data)
 	if (!nfp_net_running(nn))
 		goto out;
 
-	txd_cnt = tx_ring->cnt;
-
 	d_rd_p = nfp_qcp_rd_ptr_read(tx_ring->qcp_q);
 	d_wr_p = nfp_qcp_wr_ptr_read(tx_ring->qcp_q);
 
@@ -108,41 +105,8 @@ static int nfp_tx_q_show(struct seq_file *file, void *data)
 		   tx_ring->cnt, &tx_ring->dma, tx_ring->txds,
 		   tx_ring->rd_p, tx_ring->wr_p, d_rd_p, d_wr_p);
 
-	for (i = 0; i < txd_cnt; i++) {
-		struct xdp_buff *xdp;
-		struct sk_buff *skb;
-
-		txd = &tx_ring->txds[i];
-		seq_printf(file, "%04d: 0x%08x 0x%08x 0x%08x 0x%08x", i,
-			   txd->vals[0], txd->vals[1],
-			   txd->vals[2], txd->vals[3]);
-
-		if (!tx_ring->is_xdp) {
-			skb = READ_ONCE(tx_ring->txbufs[i].skb);
-			if (skb)
-				seq_printf(file, " skb->head=%p skb->data=%p",
-					   skb->head, skb->data);
-		} else {
-			xdp = READ_ONCE(tx_ring->txbufs[i].xdp);
-			if (xdp)
-				seq_printf(file, " xdp->data=%p", xdp->data);
-		}
-
-		if (tx_ring->txbufs[i].dma_addr)
-			seq_printf(file, " dma_addr=%pad",
-				   &tx_ring->txbufs[i].dma_addr);
-
-		if (i == tx_ring->rd_p % txd_cnt)
-			seq_puts(file, " H_RD");
-		if (i == tx_ring->wr_p % txd_cnt)
-			seq_puts(file, " H_WR");
-		if (i == d_rd_p % txd_cnt)
-			seq_puts(file, " D_RD");
-		if (i == d_wr_p % txd_cnt)
-			seq_puts(file, " D_WR");
-
-		seq_putc(file, '\n');
-	}
+	nfp_net_debugfs_print_tx_descs(file, r_vec, tx_ring,
+				       d_rd_p, d_wr_p);
 out:
 	rtnl_unlock();
 	return 0;
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_dp.c b/drivers/net/ethernet/netronome/nfp/nfp_net_dp.c
new file mode 100644
index 000000000000..8fe48569a612
--- /dev/null
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_dp.c
@@ -0,0 +1,448 @@
+// SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+/* Copyright (C) 2015-2019 Netronome Systems, Inc. */
+
+#include "nfp_app.h"
+#include "nfp_net_dp.h"
+#include "nfp_net_xsk.h"
+
+/**
+ * nfp_net_rx_alloc_one() - Allocate and map page frag for RX
+ * @dp:		NFP Net data path struct
+ * @dma_addr:	Pointer to storage for DMA address (output param)
+ *
+ * This function will allcate a new page frag, map it for DMA.
+ *
+ * Return: allocated page frag or NULL on failure.
+ */
+void *nfp_net_rx_alloc_one(struct nfp_net_dp *dp, dma_addr_t *dma_addr)
+{
+	void *frag;
+
+	if (!dp->xdp_prog) {
+		frag = netdev_alloc_frag(dp->fl_bufsz);
+	} else {
+		struct page *page;
+
+		page = alloc_page(GFP_KERNEL);
+		frag = page ? page_address(page) : NULL;
+	}
+	if (!frag) {
+		nn_dp_warn(dp, "Failed to alloc receive page frag\n");
+		return NULL;
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
+ * nfp_net_tx_ring_init() - Fill in the boilerplate for a TX ring
+ * @tx_ring:  TX ring structure
+ * @r_vec:    IRQ vector servicing this ring
+ * @idx:      Ring index
+ * @is_xdp:   Is this an XDP TX ring?
+ */
+static void
+nfp_net_tx_ring_init(struct nfp_net_tx_ring *tx_ring,
+		     struct nfp_net_r_vector *r_vec, unsigned int idx,
+		     bool is_xdp)
+{
+	struct nfp_net *nn = r_vec->nfp_net;
+
+	tx_ring->idx = idx;
+	tx_ring->r_vec = r_vec;
+	tx_ring->is_xdp = is_xdp;
+	u64_stats_init(&tx_ring->r_vec->tx_sync);
+
+	tx_ring->qcidx = tx_ring->idx * nn->stride_tx;
+	tx_ring->qcp_q = nn->tx_bar + NFP_QCP_QUEUE_OFF(tx_ring->qcidx);
+}
+
+/**
+ * nfp_net_rx_ring_init() - Fill in the boilerplate for a RX ring
+ * @rx_ring:  RX ring structure
+ * @r_vec:    IRQ vector servicing this ring
+ * @idx:      Ring index
+ */
+static void
+nfp_net_rx_ring_init(struct nfp_net_rx_ring *rx_ring,
+		     struct nfp_net_r_vector *r_vec, unsigned int idx)
+{
+	struct nfp_net *nn = r_vec->nfp_net;
+
+	rx_ring->idx = idx;
+	rx_ring->r_vec = r_vec;
+	u64_stats_init(&rx_ring->r_vec->rx_sync);
+
+	rx_ring->fl_qcidx = rx_ring->idx * nn->stride_rx;
+	rx_ring->qcp_fl = nn->rx_bar + NFP_QCP_QUEUE_OFF(rx_ring->fl_qcidx);
+}
+
+/**
+ * nfp_net_rx_ring_reset() - Reflect in SW state of freelist after disable
+ * @rx_ring:	RX ring structure
+ *
+ * Assumes that the device is stopped, must be idempotent.
+ */
+void nfp_net_rx_ring_reset(struct nfp_net_rx_ring *rx_ring)
+{
+	unsigned int wr_idx, last_idx;
+
+	/* wr_p == rd_p means ring was never fed FL bufs.  RX rings are always
+	 * kept at cnt - 1 FL bufs.
+	 */
+	if (rx_ring->wr_p == 0 && rx_ring->rd_p == 0)
+		return;
+
+	/* Move the empty entry to the end of the list */
+	wr_idx = D_IDX(rx_ring, rx_ring->wr_p);
+	last_idx = rx_ring->cnt - 1;
+	if (rx_ring->r_vec->xsk_pool) {
+		rx_ring->xsk_rxbufs[wr_idx] = rx_ring->xsk_rxbufs[last_idx];
+		memset(&rx_ring->xsk_rxbufs[last_idx], 0,
+		       sizeof(*rx_ring->xsk_rxbufs));
+	} else {
+		rx_ring->rxbufs[wr_idx] = rx_ring->rxbufs[last_idx];
+		memset(&rx_ring->rxbufs[last_idx], 0, sizeof(*rx_ring->rxbufs));
+	}
+
+	memset(rx_ring->rxds, 0, rx_ring->size);
+	rx_ring->wr_p = 0;
+	rx_ring->rd_p = 0;
+}
+
+/**
+ * nfp_net_rx_ring_bufs_free() - Free any buffers currently on the RX ring
+ * @dp:		NFP Net data path struct
+ * @rx_ring:	RX ring to remove buffers from
+ *
+ * Assumes that the device is stopped and buffers are in [0, ring->cnt - 1)
+ * entries.  After device is disabled nfp_net_rx_ring_reset() must be called
+ * to restore required ring geometry.
+ */
+static void
+nfp_net_rx_ring_bufs_free(struct nfp_net_dp *dp,
+			  struct nfp_net_rx_ring *rx_ring)
+{
+	unsigned int i;
+
+	if (nfp_net_has_xsk_pool_slow(dp, rx_ring->idx))
+		return;
+
+	for (i = 0; i < rx_ring->cnt - 1; i++) {
+		/* NULL skb can only happen when initial filling of the ring
+		 * fails to allocate enough buffers and calls here to free
+		 * already allocated ones.
+		 */
+		if (!rx_ring->rxbufs[i].frag)
+			continue;
+
+		nfp_net_dma_unmap_rx(dp, rx_ring->rxbufs[i].dma_addr);
+		nfp_net_free_frag(rx_ring->rxbufs[i].frag, dp->xdp_prog);
+		rx_ring->rxbufs[i].dma_addr = 0;
+		rx_ring->rxbufs[i].frag = NULL;
+	}
+}
+
+/**
+ * nfp_net_rx_ring_bufs_alloc() - Fill RX ring with buffers (don't give to FW)
+ * @dp:		NFP Net data path struct
+ * @rx_ring:	RX ring to remove buffers from
+ */
+static int
+nfp_net_rx_ring_bufs_alloc(struct nfp_net_dp *dp,
+			   struct nfp_net_rx_ring *rx_ring)
+{
+	struct nfp_net_rx_buf *rxbufs;
+	unsigned int i;
+
+	if (nfp_net_has_xsk_pool_slow(dp, rx_ring->idx))
+		return 0;
+
+	rxbufs = rx_ring->rxbufs;
+
+	for (i = 0; i < rx_ring->cnt - 1; i++) {
+		rxbufs[i].frag = nfp_net_rx_alloc_one(dp, &rxbufs[i].dma_addr);
+		if (!rxbufs[i].frag) {
+			nfp_net_rx_ring_bufs_free(dp, rx_ring);
+			return -ENOMEM;
+		}
+	}
+
+	return 0;
+}
+
+int nfp_net_tx_rings_prepare(struct nfp_net *nn, struct nfp_net_dp *dp)
+{
+	unsigned int r;
+
+	dp->tx_rings = kcalloc(dp->num_tx_rings, sizeof(*dp->tx_rings),
+			       GFP_KERNEL);
+	if (!dp->tx_rings)
+		return -ENOMEM;
+
+	for (r = 0; r < dp->num_tx_rings; r++) {
+		int bias = 0;
+
+		if (r >= dp->num_stack_tx_rings)
+			bias = dp->num_stack_tx_rings;
+
+		nfp_net_tx_ring_init(&dp->tx_rings[r], &nn->r_vecs[r - bias],
+				     r, bias);
+
+		if (nfp_net_tx_ring_alloc(dp, &dp->tx_rings[r]))
+			goto err_free_prev;
+
+		if (nfp_net_tx_ring_bufs_alloc(dp, &dp->tx_rings[r]))
+			goto err_free_ring;
+	}
+
+	return 0;
+
+err_free_prev:
+	while (r--) {
+		nfp_net_tx_ring_bufs_free(dp, &dp->tx_rings[r]);
+err_free_ring:
+		nfp_net_tx_ring_free(dp, &dp->tx_rings[r]);
+	}
+	kfree(dp->tx_rings);
+	return -ENOMEM;
+}
+
+void nfp_net_tx_rings_free(struct nfp_net_dp *dp)
+{
+	unsigned int r;
+
+	for (r = 0; r < dp->num_tx_rings; r++) {
+		nfp_net_tx_ring_bufs_free(dp, &dp->tx_rings[r]);
+		nfp_net_tx_ring_free(dp, &dp->tx_rings[r]);
+	}
+
+	kfree(dp->tx_rings);
+}
+
+/**
+ * nfp_net_rx_ring_free() - Free resources allocated to a RX ring
+ * @rx_ring:  RX ring to free
+ */
+static void nfp_net_rx_ring_free(struct nfp_net_rx_ring *rx_ring)
+{
+	struct nfp_net_r_vector *r_vec = rx_ring->r_vec;
+	struct nfp_net_dp *dp = &r_vec->nfp_net->dp;
+
+	if (dp->netdev)
+		xdp_rxq_info_unreg(&rx_ring->xdp_rxq);
+
+	if (nfp_net_has_xsk_pool_slow(dp, rx_ring->idx))
+		kvfree(rx_ring->xsk_rxbufs);
+	else
+		kvfree(rx_ring->rxbufs);
+
+	if (rx_ring->rxds)
+		dma_free_coherent(dp->dev, rx_ring->size,
+				  rx_ring->rxds, rx_ring->dma);
+
+	rx_ring->cnt = 0;
+	rx_ring->rxbufs = NULL;
+	rx_ring->xsk_rxbufs = NULL;
+	rx_ring->rxds = NULL;
+	rx_ring->dma = 0;
+	rx_ring->size = 0;
+}
+
+/**
+ * nfp_net_rx_ring_alloc() - Allocate resource for a RX ring
+ * @dp:	      NFP Net data path struct
+ * @rx_ring:  RX ring to allocate
+ *
+ * Return: 0 on success, negative errno otherwise.
+ */
+static int
+nfp_net_rx_ring_alloc(struct nfp_net_dp *dp, struct nfp_net_rx_ring *rx_ring)
+{
+	enum xdp_mem_type mem_type;
+	size_t rxbuf_sw_desc_sz;
+	int err;
+
+	if (nfp_net_has_xsk_pool_slow(dp, rx_ring->idx)) {
+		mem_type = MEM_TYPE_XSK_BUFF_POOL;
+		rxbuf_sw_desc_sz = sizeof(*rx_ring->xsk_rxbufs);
+	} else {
+		mem_type = MEM_TYPE_PAGE_ORDER0;
+		rxbuf_sw_desc_sz = sizeof(*rx_ring->rxbufs);
+	}
+
+	if (dp->netdev) {
+		err = xdp_rxq_info_reg(&rx_ring->xdp_rxq, dp->netdev,
+				       rx_ring->idx, rx_ring->r_vec->napi.napi_id);
+		if (err < 0)
+			return err;
+
+		err = xdp_rxq_info_reg_mem_model(&rx_ring->xdp_rxq, mem_type, NULL);
+		if (err)
+			goto err_alloc;
+	}
+
+	rx_ring->cnt = dp->rxd_cnt;
+	rx_ring->size = array_size(rx_ring->cnt, sizeof(*rx_ring->rxds));
+	rx_ring->rxds = dma_alloc_coherent(dp->dev, rx_ring->size,
+					   &rx_ring->dma,
+					   GFP_KERNEL | __GFP_NOWARN);
+	if (!rx_ring->rxds) {
+		netdev_warn(dp->netdev, "failed to allocate RX descriptor ring memory, requested descriptor count: %d, consider lowering descriptor count\n",
+			    rx_ring->cnt);
+		goto err_alloc;
+	}
+
+	if (nfp_net_has_xsk_pool_slow(dp, rx_ring->idx)) {
+		rx_ring->xsk_rxbufs = kvcalloc(rx_ring->cnt, rxbuf_sw_desc_sz,
+					       GFP_KERNEL);
+		if (!rx_ring->xsk_rxbufs)
+			goto err_alloc;
+	} else {
+		rx_ring->rxbufs = kvcalloc(rx_ring->cnt, rxbuf_sw_desc_sz,
+					   GFP_KERNEL);
+		if (!rx_ring->rxbufs)
+			goto err_alloc;
+	}
+
+	return 0;
+
+err_alloc:
+	nfp_net_rx_ring_free(rx_ring);
+	return -ENOMEM;
+}
+
+int nfp_net_rx_rings_prepare(struct nfp_net *nn, struct nfp_net_dp *dp)
+{
+	unsigned int r;
+
+	dp->rx_rings = kcalloc(dp->num_rx_rings, sizeof(*dp->rx_rings),
+			       GFP_KERNEL);
+	if (!dp->rx_rings)
+		return -ENOMEM;
+
+	for (r = 0; r < dp->num_rx_rings; r++) {
+		nfp_net_rx_ring_init(&dp->rx_rings[r], &nn->r_vecs[r], r);
+
+		if (nfp_net_rx_ring_alloc(dp, &dp->rx_rings[r]))
+			goto err_free_prev;
+
+		if (nfp_net_rx_ring_bufs_alloc(dp, &dp->rx_rings[r]))
+			goto err_free_ring;
+	}
+
+	return 0;
+
+err_free_prev:
+	while (r--) {
+		nfp_net_rx_ring_bufs_free(dp, &dp->rx_rings[r]);
+err_free_ring:
+		nfp_net_rx_ring_free(&dp->rx_rings[r]);
+	}
+	kfree(dp->rx_rings);
+	return -ENOMEM;
+}
+
+void nfp_net_rx_rings_free(struct nfp_net_dp *dp)
+{
+	unsigned int r;
+
+	for (r = 0; r < dp->num_rx_rings; r++) {
+		nfp_net_rx_ring_bufs_free(dp, &dp->rx_rings[r]);
+		nfp_net_rx_ring_free(&dp->rx_rings[r]);
+	}
+
+	kfree(dp->rx_rings);
+}
+
+void
+nfp_net_rx_ring_hw_cfg_write(struct nfp_net *nn,
+			     struct nfp_net_rx_ring *rx_ring, unsigned int idx)
+{
+	/* Write the DMA address, size and MSI-X info to the device */
+	nn_writeq(nn, NFP_NET_CFG_RXR_ADDR(idx), rx_ring->dma);
+	nn_writeb(nn, NFP_NET_CFG_RXR_SZ(idx), ilog2(rx_ring->cnt));
+	nn_writeb(nn, NFP_NET_CFG_RXR_VEC(idx), rx_ring->r_vec->irq_entry);
+}
+
+void
+nfp_net_tx_ring_hw_cfg_write(struct nfp_net *nn,
+			     struct nfp_net_tx_ring *tx_ring, unsigned int idx)
+{
+	nn_writeq(nn, NFP_NET_CFG_TXR_ADDR(idx), tx_ring->dma);
+	nn_writeb(nn, NFP_NET_CFG_TXR_SZ(idx), ilog2(tx_ring->cnt));
+	nn_writeb(nn, NFP_NET_CFG_TXR_VEC(idx), tx_ring->r_vec->irq_entry);
+}
+
+void nfp_net_vec_clear_ring_data(struct nfp_net *nn, unsigned int idx)
+{
+	nn_writeq(nn, NFP_NET_CFG_RXR_ADDR(idx), 0);
+	nn_writeb(nn, NFP_NET_CFG_RXR_SZ(idx), 0);
+	nn_writeb(nn, NFP_NET_CFG_RXR_VEC(idx), 0);
+
+	nn_writeq(nn, NFP_NET_CFG_TXR_ADDR(idx), 0);
+	nn_writeb(nn, NFP_NET_CFG_TXR_SZ(idx), 0);
+	nn_writeb(nn, NFP_NET_CFG_TXR_VEC(idx), 0);
+}
+
+void
+nfp_net_tx_ring_reset(struct nfp_net_dp *dp, struct nfp_net_tx_ring *tx_ring)
+{
+	nfp_nfd3_tx_ring_reset(dp, tx_ring);
+}
+
+void nfp_net_rx_ring_fill_freelist(struct nfp_net_dp *dp,
+				   struct nfp_net_rx_ring *rx_ring)
+{
+	nfp_nfd3_rx_ring_fill_freelist(dp, rx_ring);
+}
+
+int
+nfp_net_tx_ring_alloc(struct nfp_net_dp *dp, struct nfp_net_tx_ring *tx_ring)
+{
+	return nfp_nfd3_tx_ring_alloc(dp, tx_ring);
+}
+
+void
+nfp_net_tx_ring_free(struct nfp_net_dp *dp, struct nfp_net_tx_ring *tx_ring)
+{
+	nfp_nfd3_tx_ring_free(tx_ring);
+}
+
+int nfp_net_tx_ring_bufs_alloc(struct nfp_net_dp *dp,
+			       struct nfp_net_tx_ring *tx_ring)
+{
+	return nfp_nfd3_tx_ring_bufs_alloc(dp, tx_ring);
+}
+
+void nfp_net_tx_ring_bufs_free(struct nfp_net_dp *dp,
+			       struct nfp_net_tx_ring *tx_ring)
+{
+	nfp_nfd3_tx_ring_bufs_free(dp, tx_ring);
+}
+
+void
+nfp_net_debugfs_print_tx_descs(struct seq_file *file,
+			       struct nfp_net_r_vector *r_vec,
+			       struct nfp_net_tx_ring *tx_ring,
+			       u32 d_rd_p, u32 d_wr_p)
+{
+	nfp_nfd3_print_tx_descs(file, r_vec, tx_ring, d_rd_p, d_wr_p);
+}
+
+bool __nfp_ctrl_tx(struct nfp_net *nn, struct sk_buff *skb)
+{
+	return __nfp_nfd3_ctrl_tx(nn, skb);
+}
+
+bool nfp_ctrl_tx(struct nfp_net *nn, struct sk_buff *skb)
+{
+	return nfp_nfd3_ctrl_tx(nn, skb);
+}
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_dp.h b/drivers/net/ethernet/netronome/nfp/nfp_net_dp.h
new file mode 100644
index 000000000000..30ccdf5aa819
--- /dev/null
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_dp.h
@@ -0,0 +1,120 @@
+/* SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause) */
+/* Copyright (C) 2019 Netronome Systems, Inc. */
+
+#ifndef _NFP_NET_DP_
+#define _NFP_NET_DP_
+
+#include "nfp_net.h"
+#include "nfd3/nfd3.h"
+
+static inline dma_addr_t nfp_net_dma_map_rx(struct nfp_net_dp *dp, void *frag)
+{
+	return dma_map_single_attrs(dp->dev, frag + NFP_NET_RX_BUF_HEADROOM,
+				    dp->fl_bufsz - NFP_NET_RX_BUF_NON_DATA,
+				    dp->rx_dma_dir, DMA_ATTR_SKIP_CPU_SYNC);
+}
+
+static inline void
+nfp_net_dma_sync_dev_rx(const struct nfp_net_dp *dp, dma_addr_t dma_addr)
+{
+	dma_sync_single_for_device(dp->dev, dma_addr,
+				   dp->fl_bufsz - NFP_NET_RX_BUF_NON_DATA,
+				   dp->rx_dma_dir);
+}
+
+static inline void nfp_net_dma_unmap_rx(struct nfp_net_dp *dp,
+					dma_addr_t dma_addr)
+{
+	dma_unmap_single_attrs(dp->dev, dma_addr,
+			       dp->fl_bufsz - NFP_NET_RX_BUF_NON_DATA,
+			       dp->rx_dma_dir, DMA_ATTR_SKIP_CPU_SYNC);
+}
+
+static inline void nfp_net_dma_sync_cpu_rx(struct nfp_net_dp *dp,
+					   dma_addr_t dma_addr,
+					   unsigned int len)
+{
+	dma_sync_single_for_cpu(dp->dev, dma_addr - NFP_NET_RX_BUF_HEADROOM,
+				len, dp->rx_dma_dir);
+}
+
+/**
+ * nfp_net_tx_full() - check if the TX ring is full
+ * @tx_ring: TX ring to check
+ * @dcnt:    Number of descriptors that need to be enqueued (must be >= 1)
+ *
+ * This function checks, based on the *host copy* of read/write
+ * pointer if a given TX ring is full.  The real TX queue may have
+ * some newly made available slots.
+ *
+ * Return: True if the ring is full.
+ */
+static inline int nfp_net_tx_full(struct nfp_net_tx_ring *tx_ring, int dcnt)
+{
+	return (tx_ring->wr_p - tx_ring->rd_p) >= (tx_ring->cnt - dcnt);
+}
+
+static inline void nfp_net_tx_xmit_more_flush(struct nfp_net_tx_ring *tx_ring)
+{
+	wmb(); /* drain writebuffer */
+	nfp_qcp_wr_ptr_add(tx_ring->qcp_q, tx_ring->wr_ptr_add);
+	tx_ring->wr_ptr_add = 0;
+}
+
+static inline void nfp_net_free_frag(void *frag, bool xdp)
+{
+	if (!xdp)
+		skb_free_frag(frag);
+	else
+		__free_page(virt_to_page(frag));
+}
+
+/**
+ * nfp_net_irq_unmask() - Unmask automasked interrupt
+ * @nn:       NFP Network structure
+ * @entry_nr: MSI-X table entry
+ *
+ * Clear the ICR for the IRQ entry.
+ */
+static inline void nfp_net_irq_unmask(struct nfp_net *nn, unsigned int entry_nr)
+{
+	nn_writeb(nn, NFP_NET_CFG_ICR(entry_nr), NFP_NET_CFG_ICR_UNMASKED);
+	nn_pci_flush(nn);
+}
+
+struct seq_file;
+
+/* Common */
+void
+nfp_net_rx_ring_hw_cfg_write(struct nfp_net *nn,
+			     struct nfp_net_rx_ring *rx_ring, unsigned int idx);
+void
+nfp_net_tx_ring_hw_cfg_write(struct nfp_net *nn,
+			     struct nfp_net_tx_ring *tx_ring, unsigned int idx);
+void nfp_net_vec_clear_ring_data(struct nfp_net *nn, unsigned int idx);
+
+void *nfp_net_rx_alloc_one(struct nfp_net_dp *dp, dma_addr_t *dma_addr);
+int nfp_net_rx_rings_prepare(struct nfp_net *nn, struct nfp_net_dp *dp);
+int nfp_net_tx_rings_prepare(struct nfp_net *nn, struct nfp_net_dp *dp);
+void nfp_net_rx_rings_free(struct nfp_net_dp *dp);
+void nfp_net_tx_rings_free(struct nfp_net_dp *dp);
+void nfp_net_rx_ring_reset(struct nfp_net_rx_ring *rx_ring);
+
+void
+nfp_net_tx_ring_reset(struct nfp_net_dp *dp, struct nfp_net_tx_ring *tx_ring);
+void nfp_net_rx_ring_fill_freelist(struct nfp_net_dp *dp,
+				   struct nfp_net_rx_ring *rx_ring);
+int
+nfp_net_tx_ring_alloc(struct nfp_net_dp *dp, struct nfp_net_tx_ring *tx_ring);
+void
+nfp_net_tx_ring_free(struct nfp_net_dp *dp, struct nfp_net_tx_ring *tx_ring);
+int nfp_net_tx_ring_bufs_alloc(struct nfp_net_dp *dp,
+			       struct nfp_net_tx_ring *tx_ring);
+void nfp_net_tx_ring_bufs_free(struct nfp_net_dp *dp,
+			       struct nfp_net_tx_ring *tx_ring);
+void
+nfp_net_debugfs_print_tx_descs(struct seq_file *file,
+			       struct nfp_net_r_vector *r_vec,
+			       struct nfp_net_tx_ring *tx_ring,
+			       u32 d_rd_p, u32 d_wr_p);
+#endif /* _NFP_NET_DP_ */
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_xsk.c b/drivers/net/ethernet/netronome/nfp/nfp_net_xsk.c
index ab7243277efa..50a59aad70f4 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_xsk.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_xsk.c
@@ -10,204 +10,9 @@
 
 #include "nfp_app.h"
 #include "nfp_net.h"
+#include "nfp_net_dp.h"
 #include "nfp_net_xsk.h"
 
-static int nfp_net_tx_space(struct nfp_net_tx_ring *tx_ring)
-{
-	return tx_ring->cnt - tx_ring->wr_p + tx_ring->rd_p - 1;
-}
-
-static void nfp_net_xsk_tx_free(struct nfp_net_tx_buf *txbuf)
-{
-	xsk_buff_free(txbuf->xdp);
-
-	txbuf->dma_addr = 0;
-	txbuf->xdp = NULL;
-}
-
-void nfp_net_xsk_tx_bufs_free(struct nfp_net_tx_ring *tx_ring)
-{
-	struct nfp_net_tx_buf *txbuf;
-	unsigned int idx;
-
-	while (tx_ring->rd_p != tx_ring->wr_p) {
-		idx = D_IDX(tx_ring, tx_ring->rd_p);
-		txbuf = &tx_ring->txbufs[idx];
-
-		txbuf->real_len = 0;
-
-		tx_ring->qcp_rd_p++;
-		tx_ring->rd_p++;
-
-		if (tx_ring->r_vec->xsk_pool) {
-			if (txbuf->is_xsk_tx)
-				nfp_net_xsk_tx_free(txbuf);
-
-			xsk_tx_completed(tx_ring->r_vec->xsk_pool, 1);
-		}
-	}
-}
-
-static bool nfp_net_xsk_complete(struct nfp_net_tx_ring *tx_ring)
-{
-	struct nfp_net_r_vector *r_vec = tx_ring->r_vec;
-	u32 done_pkts = 0, done_bytes = 0, reused = 0;
-	bool done_all;
-	int idx, todo;
-	u32 qcp_rd_p;
-
-	if (tx_ring->wr_p == tx_ring->rd_p)
-		return true;
-
-	/* Work out how many descriptors have been transmitted. */
-	qcp_rd_p = nfp_qcp_rd_ptr_read(tx_ring->qcp_q);
-
-	if (qcp_rd_p == tx_ring->qcp_rd_p)
-		return true;
-
-	todo = D_IDX(tx_ring, qcp_rd_p - tx_ring->qcp_rd_p);
-
-	done_all = todo <= NFP_NET_XDP_MAX_COMPLETE;
-	todo = min(todo, NFP_NET_XDP_MAX_COMPLETE);
-
-	tx_ring->qcp_rd_p = D_IDX(tx_ring, tx_ring->qcp_rd_p + todo);
-
-	done_pkts = todo;
-	while (todo--) {
-		struct nfp_net_tx_buf *txbuf;
-
-		idx = D_IDX(tx_ring, tx_ring->rd_p);
-		tx_ring->rd_p++;
-
-		txbuf = &tx_ring->txbufs[idx];
-		if (unlikely(!txbuf->real_len))
-			continue;
-
-		done_bytes += txbuf->real_len;
-		txbuf->real_len = 0;
-
-		if (txbuf->is_xsk_tx) {
-			nfp_net_xsk_tx_free(txbuf);
-			reused++;
-		}
-	}
-
-	u64_stats_update_begin(&r_vec->tx_sync);
-	r_vec->tx_bytes += done_bytes;
-	r_vec->tx_pkts += done_pkts;
-	u64_stats_update_end(&r_vec->tx_sync);
-
-	xsk_tx_completed(r_vec->xsk_pool, done_pkts - reused);
-
-	WARN_ONCE(tx_ring->wr_p - tx_ring->rd_p > tx_ring->cnt,
-		  "XDP TX ring corruption rd_p=%u wr_p=%u cnt=%u\n",
-		  tx_ring->rd_p, tx_ring->wr_p, tx_ring->cnt);
-
-	return done_all;
-}
-
-static void nfp_net_xsk_tx(struct nfp_net_tx_ring *tx_ring)
-{
-	struct nfp_net_r_vector *r_vec = tx_ring->r_vec;
-	struct xdp_desc desc[NFP_NET_XSK_TX_BATCH];
-	struct xsk_buff_pool *xsk_pool;
-	struct nfp_net_tx_desc *txd;
-	u32 pkts = 0, wr_idx;
-	u32 i, got;
-
-	xsk_pool = r_vec->xsk_pool;
-
-	while (nfp_net_tx_space(tx_ring) >= NFP_NET_XSK_TX_BATCH) {
-		for (i = 0; i < NFP_NET_XSK_TX_BATCH; i++)
-			if (!xsk_tx_peek_desc(xsk_pool, &desc[i]))
-				break;
-		got = i;
-		if (!got)
-			break;
-
-		wr_idx = D_IDX(tx_ring, tx_ring->wr_p + i);
-		prefetchw(&tx_ring->txds[wr_idx]);
-
-		for (i = 0; i < got; i++)
-			xsk_buff_raw_dma_sync_for_device(xsk_pool, desc[i].addr,
-							 desc[i].len);
-
-		for (i = 0; i < got; i++) {
-			wr_idx = D_IDX(tx_ring, tx_ring->wr_p + i);
-
-			tx_ring->txbufs[wr_idx].real_len = desc[i].len;
-			tx_ring->txbufs[wr_idx].is_xsk_tx = false;
-
-			/* Build TX descriptor. */
-			txd = &tx_ring->txds[wr_idx];
-			nfp_desc_set_dma_addr(txd,
-					      xsk_buff_raw_get_dma(xsk_pool,
-								   desc[i].addr
-								   ));
-			txd->offset_eop = PCIE_DESC_TX_EOP;
-			txd->dma_len = cpu_to_le16(desc[i].len);
-			txd->data_len = cpu_to_le16(desc[i].len);
-		}
-
-		tx_ring->wr_p += got;
-		pkts += got;
-	}
-
-	if (!pkts)
-		return;
-
-	xsk_tx_release(xsk_pool);
-	/* Ensure all records are visible before incrementing write counter. */
-	wmb();
-	nfp_qcp_wr_ptr_add(tx_ring->qcp_q, pkts);
-}
-
-static bool
-nfp_net_xsk_tx_xdp(const struct nfp_net_dp *dp, struct nfp_net_r_vector *r_vec,
-		   struct nfp_net_rx_ring *rx_ring,
-		   struct nfp_net_tx_ring *tx_ring,
-		   struct nfp_net_xsk_rx_buf *xrxbuf, unsigned int pkt_len,
-		   int pkt_off)
-{
-	struct xsk_buff_pool *pool = r_vec->xsk_pool;
-	struct nfp_net_tx_buf *txbuf;
-	struct nfp_net_tx_desc *txd;
-	unsigned int wr_idx;
-
-	if (nfp_net_tx_space(tx_ring) < 1)
-		return false;
-
-	xsk_buff_raw_dma_sync_for_device(pool, xrxbuf->dma_addr + pkt_off, pkt_len);
-
-	wr_idx = D_IDX(tx_ring, tx_ring->wr_p);
-
-	txbuf = &tx_ring->txbufs[wr_idx];
-	txbuf->xdp = xrxbuf->xdp;
-	txbuf->real_len = pkt_len;
-	txbuf->is_xsk_tx = true;
-
-	/* Build TX descriptor */
-	txd = &tx_ring->txds[wr_idx];
-	txd->offset_eop = PCIE_DESC_TX_EOP;
-	txd->dma_len = cpu_to_le16(pkt_len);
-	nfp_desc_set_dma_addr(txd, xrxbuf->dma_addr + pkt_off);
-	txd->data_len = cpu_to_le16(pkt_len);
-
-	txd->flags = 0;
-	txd->mss = 0;
-	txd->lso_hdrlen = 0;
-
-	tx_ring->wr_ptr_add++;
-	tx_ring->wr_p++;
-
-	return true;
-}
-
-static int nfp_net_rx_space(struct nfp_net_rx_ring *rx_ring)
-{
-	return rx_ring->cnt - rx_ring->wr_p + rx_ring->rd_p - 1;
-}
-
 static void
 nfp_net_xsk_rx_bufs_stash(struct nfp_net_rx_ring *rx_ring, unsigned int idx,
 			  struct xdp_buff *xdp)
@@ -224,13 +29,13 @@ nfp_net_xsk_rx_bufs_stash(struct nfp_net_rx_ring *rx_ring, unsigned int idx,
 		xsk_buff_xdp_get_frame_dma(xdp) + headroom;
 }
 
-static void nfp_net_xsk_rx_unstash(struct nfp_net_xsk_rx_buf *rxbuf)
+void nfp_net_xsk_rx_unstash(struct nfp_net_xsk_rx_buf *rxbuf)
 {
 	rxbuf->dma_addr = 0;
 	rxbuf->xdp = NULL;
 }
 
-static void nfp_net_xsk_rx_free(struct nfp_net_xsk_rx_buf *rxbuf)
+void nfp_net_xsk_rx_free(struct nfp_net_xsk_rx_buf *rxbuf)
 {
 	if (rxbuf->xdp)
 		xsk_buff_free(rxbuf->xdp);
@@ -277,8 +82,8 @@ void nfp_net_xsk_rx_ring_fill_freelist(struct nfp_net_rx_ring *rx_ring)
 	nfp_qcp_wr_ptr_add(rx_ring->qcp_fl, wr_ptr_add);
 }
 
-static void nfp_net_xsk_rx_drop(struct nfp_net_r_vector *r_vec,
-				struct nfp_net_xsk_rx_buf *xrxbuf)
+void nfp_net_xsk_rx_drop(struct nfp_net_r_vector *r_vec,
+			 struct nfp_net_xsk_rx_buf *xrxbuf)
 {
 	u64_stats_update_begin(&r_vec->rx_sync);
 	r_vec->rx_drops++;
@@ -287,213 +92,6 @@ static void nfp_net_xsk_rx_drop(struct nfp_net_r_vector *r_vec,
 	nfp_net_xsk_rx_free(xrxbuf);
 }
 
-static void nfp_net_xsk_rx_skb(struct nfp_net_rx_ring *rx_ring,
-			       const struct nfp_net_rx_desc *rxd,
-			       struct nfp_net_xsk_rx_buf *xrxbuf,
-			       const struct nfp_meta_parsed *meta,
-			       unsigned int pkt_len,
-			       bool meta_xdp,
-			       unsigned int *skbs_polled)
-{
-	struct nfp_net_r_vector *r_vec = rx_ring->r_vec;
-	struct nfp_net_dp *dp = &r_vec->nfp_net->dp;
-	struct net_device *netdev;
-	struct sk_buff *skb;
-
-	if (likely(!meta->portid)) {
-		netdev = dp->netdev;
-	} else {
-		struct nfp_net *nn = netdev_priv(dp->netdev);
-
-		netdev = nfp_app_dev_get(nn->app, meta->portid, NULL);
-		if (unlikely(!netdev)) {
-			nfp_net_xsk_rx_drop(r_vec, xrxbuf);
-			return;
-		}
-		nfp_repr_inc_rx_stats(netdev, pkt_len);
-	}
-
-	skb = napi_alloc_skb(&r_vec->napi, pkt_len);
-	if (!skb) {
-		nfp_net_xsk_rx_drop(r_vec, xrxbuf);
-		return;
-	}
-	memcpy(skb_put(skb, pkt_len), xrxbuf->xdp->data, pkt_len);
-
-	skb->mark = meta->mark;
-	skb_set_hash(skb, meta->hash, meta->hash_type);
-
-	skb_record_rx_queue(skb, rx_ring->idx);
-	skb->protocol = eth_type_trans(skb, netdev);
-
-	nfp_net_rx_csum(dp, r_vec, rxd, meta, skb);
-
-	if (rxd->rxd.flags & PCIE_DESC_RX_VLAN)
-		__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q),
-				       le16_to_cpu(rxd->rxd.vlan));
-	if (meta_xdp)
-		skb_metadata_set(skb,
-				 xrxbuf->xdp->data - xrxbuf->xdp->data_meta);
-
-	napi_gro_receive(&rx_ring->r_vec->napi, skb);
-
-	nfp_net_xsk_rx_free(xrxbuf);
-
-	(*skbs_polled)++;
-}
-
-static unsigned int
-nfp_net_xsk_rx(struct nfp_net_rx_ring *rx_ring, int budget,
-	       unsigned int *skbs_polled)
-{
-	struct nfp_net_r_vector *r_vec = rx_ring->r_vec;
-	struct nfp_net_dp *dp = &r_vec->nfp_net->dp;
-	struct nfp_net_tx_ring *tx_ring;
-	struct bpf_prog *xdp_prog;
-	bool xdp_redir = false;
-	int pkts_polled = 0;
-
-	xdp_prog = READ_ONCE(dp->xdp_prog);
-	tx_ring = r_vec->xdp_ring;
-
-	while (pkts_polled < budget) {
-		unsigned int meta_len, data_len, pkt_len, pkt_off;
-		struct nfp_net_xsk_rx_buf *xrxbuf;
-		struct nfp_net_rx_desc *rxd;
-		struct nfp_meta_parsed meta;
-		int idx, act;
-
-		idx = D_IDX(rx_ring, rx_ring->rd_p);
-
-		rxd = &rx_ring->rxds[idx];
-		if (!(rxd->rxd.meta_len_dd & PCIE_DESC_RX_DD))
-			break;
-
-		rx_ring->rd_p++;
-		pkts_polled++;
-
-		xrxbuf = &rx_ring->xsk_rxbufs[idx];
-
-		/* If starved of buffers "drop" it and scream. */
-		if (rx_ring->rd_p >= rx_ring->wr_p) {
-			nn_dp_warn(dp, "Starved of RX buffers\n");
-			nfp_net_xsk_rx_drop(r_vec, xrxbuf);
-			break;
-		}
-
-		/* Memory barrier to ensure that we won't do other reads
-		 * before the DD bit.
-		 */
-		dma_rmb();
-
-		memset(&meta, 0, sizeof(meta));
-
-		/* Only supporting AF_XDP with dynamic metadata so buffer layout
-		 * is always:
-		 *
-		 *  ---------------------------------------------------------
-		 * |  off | metadata  |             packet           | XXXX  |
-		 *  ---------------------------------------------------------
-		 */
-		meta_len = rxd->rxd.meta_len_dd & PCIE_DESC_RX_META_LEN_MASK;
-		data_len = le16_to_cpu(rxd->rxd.data_len);
-		pkt_len = data_len - meta_len;
-
-		if (unlikely(meta_len > NFP_NET_MAX_PREPEND)) {
-			nn_dp_warn(dp, "Oversized RX packet metadata %u\n",
-				   meta_len);
-			nfp_net_xsk_rx_drop(r_vec, xrxbuf);
-			continue;
-		}
-
-		/* Stats update. */
-		u64_stats_update_begin(&r_vec->rx_sync);
-		r_vec->rx_pkts++;
-		r_vec->rx_bytes += pkt_len;
-		u64_stats_update_end(&r_vec->rx_sync);
-
-		xrxbuf->xdp->data += meta_len;
-		xrxbuf->xdp->data_end = xrxbuf->xdp->data + pkt_len;
-		xdp_set_data_meta_invalid(xrxbuf->xdp);
-		xsk_buff_dma_sync_for_cpu(xrxbuf->xdp, r_vec->xsk_pool);
-		net_prefetch(xrxbuf->xdp->data);
-
-		if (meta_len) {
-			if (unlikely(nfp_net_parse_meta(dp->netdev, &meta,
-							xrxbuf->xdp->data -
-							meta_len,
-							xrxbuf->xdp->data,
-							pkt_len, meta_len))) {
-				nn_dp_warn(dp, "Invalid RX packet metadata\n");
-				nfp_net_xsk_rx_drop(r_vec, xrxbuf);
-				continue;
-			}
-
-			if (unlikely(meta.portid)) {
-				struct nfp_net *nn = netdev_priv(dp->netdev);
-
-				if (meta.portid != NFP_META_PORT_ID_CTRL) {
-					nfp_net_xsk_rx_skb(rx_ring, rxd, xrxbuf,
-							   &meta, pkt_len,
-							   false, skbs_polled);
-					continue;
-				}
-
-				nfp_app_ctrl_rx_raw(nn->app, xrxbuf->xdp->data,
-						    pkt_len);
-				nfp_net_xsk_rx_free(xrxbuf);
-				continue;
-			}
-		}
-
-		act = bpf_prog_run_xdp(xdp_prog, xrxbuf->xdp);
-
-		pkt_len = xrxbuf->xdp->data_end - xrxbuf->xdp->data;
-		pkt_off = xrxbuf->xdp->data - xrxbuf->xdp->data_hard_start;
-
-		switch (act) {
-		case XDP_PASS:
-			nfp_net_xsk_rx_skb(rx_ring, rxd, xrxbuf, &meta, pkt_len,
-					   true, skbs_polled);
-			break;
-		case XDP_TX:
-			if (!nfp_net_xsk_tx_xdp(dp, r_vec, rx_ring, tx_ring,
-						xrxbuf, pkt_len, pkt_off))
-				nfp_net_xsk_rx_drop(r_vec, xrxbuf);
-			else
-				nfp_net_xsk_rx_unstash(xrxbuf);
-			break;
-		case XDP_REDIRECT:
-			if (xdp_do_redirect(dp->netdev, xrxbuf->xdp, xdp_prog)) {
-				nfp_net_xsk_rx_drop(r_vec, xrxbuf);
-			} else {
-				nfp_net_xsk_rx_unstash(xrxbuf);
-				xdp_redir = true;
-			}
-			break;
-		default:
-			bpf_warn_invalid_xdp_action(dp->netdev, xdp_prog, act);
-			fallthrough;
-		case XDP_ABORTED:
-			trace_xdp_exception(dp->netdev, xdp_prog, act);
-			fallthrough;
-		case XDP_DROP:
-			nfp_net_xsk_rx_drop(r_vec, xrxbuf);
-			break;
-		}
-	}
-
-	nfp_net_xsk_rx_ring_fill_freelist(r_vec->rx_ring);
-
-	if (xdp_redir)
-		xdp_do_flush_map();
-
-	if (tx_ring->wr_ptr_add)
-		nfp_net_tx_xmit_more_flush(tx_ring);
-
-	return pkts_polled;
-}
-
 static void nfp_net_xsk_pool_unmap(struct device *dev,
 				   struct xsk_buff_pool *pool)
 {
@@ -566,27 +164,3 @@ int nfp_net_xsk_wakeup(struct net_device *netdev, u32 queue_id, u32 flags)
 
 	return 0;
 }
-
-int nfp_net_xsk_poll(struct napi_struct *napi, int budget)
-{
-	struct nfp_net_r_vector *r_vec =
-		container_of(napi, struct nfp_net_r_vector, napi);
-	unsigned int pkts_polled, skbs = 0;
-
-	pkts_polled = nfp_net_xsk_rx(r_vec->rx_ring, budget, &skbs);
-
-	if (pkts_polled < budget) {
-		if (r_vec->tx_ring)
-			nfp_net_tx_complete(r_vec->tx_ring, budget);
-
-		if (!nfp_net_xsk_complete(r_vec->xdp_ring))
-			pkts_polled = budget;
-
-		nfp_net_xsk_tx(r_vec->xdp_ring);
-
-		if (pkts_polled < budget && napi_complete_done(napi, skbs))
-			nfp_net_irq_unmask(r_vec->nfp_net, r_vec->irq_entry);
-	}
-
-	return pkts_polled;
-}
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_xsk.h b/drivers/net/ethernet/netronome/nfp/nfp_net_xsk.h
index 5c8549cb3543..6d281eb2fc1c 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_xsk.h
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_xsk.h
@@ -15,15 +15,27 @@ static inline bool nfp_net_has_xsk_pool_slow(struct nfp_net_dp *dp,
 	return dp->xdp_prog && dp->xsk_pools[qid];
 }
 
+static inline int nfp_net_rx_space(struct nfp_net_rx_ring *rx_ring)
+{
+	return rx_ring->cnt - rx_ring->wr_p + rx_ring->rd_p - 1;
+}
+
+static inline int nfp_net_tx_space(struct nfp_net_tx_ring *tx_ring)
+{
+	return tx_ring->cnt - tx_ring->wr_p + tx_ring->rd_p - 1;
+}
+
+void nfp_net_xsk_rx_unstash(struct nfp_net_xsk_rx_buf *rxbuf);
+void nfp_net_xsk_rx_free(struct nfp_net_xsk_rx_buf *rxbuf);
+void nfp_net_xsk_rx_drop(struct nfp_net_r_vector *r_vec,
+			 struct nfp_net_xsk_rx_buf *xrxbuf);
 int nfp_net_xsk_setup_pool(struct net_device *netdev, struct xsk_buff_pool *pool,
 			   u16 queue_id);
 
-void nfp_net_xsk_tx_bufs_free(struct nfp_net_tx_ring *tx_ring);
 void nfp_net_xsk_rx_bufs_free(struct nfp_net_rx_ring *rx_ring);
 
 void nfp_net_xsk_rx_ring_fill_freelist(struct nfp_net_rx_ring *rx_ring);
 
 int nfp_net_xsk_wakeup(struct net_device *netdev, u32 queue_id, u32 flags);
-int nfp_net_xsk_poll(struct napi_struct *napi, int budget);
 
 #endif /* _NFP_XSK_H_ */
-- 
2.30.2

