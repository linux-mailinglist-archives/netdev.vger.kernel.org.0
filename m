Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C31BC614824
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 12:03:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230081AbiKALDd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 07:03:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230013AbiKALD1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 07:03:27 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2127.outbound.protection.outlook.com [40.107.95.127])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99CDCB4B4
        for <netdev@vger.kernel.org>; Tue,  1 Nov 2022 04:03:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XzIBLWCd23YarWIqaVZH7HzuHPVifC6aTJw692StL+INhNYpSjmgvzSgkXwVkJlwwlk9MD+tp71edKNopZyj9NiRdloy3aGdUP2kerLuivvCLcxbypOJ029BBZiekxPn3SRDR4xJtXE1yH9EChp9vSn/rnH7pEAFF3P232SazF2AxrFMGEARHQNqiIH03EbZKS+7HK4/ejMAbxIBvJXgQqx8+573Jus4LT6iAhCc48AJKHcW1Q8wGD2MgiJyWj9kUu0X9wz0sLCuZBJykkVZLE0MRu5RZVrx3tAtLtndxtWL7Od4WxpzuKt1H25HjxYJqehyUL8Iytj7XCLindyOFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OvPKBfkGkbnFgPJDK8q1BOfBlh4n7YMzuNyiBClCR94=;
 b=VUlVik/iKfysyQi7fgHMpw1ygGhqu0F60CK1VykUG7FA8YZ6BrrmaucS2hNSdhnZsSTfxamAiFQqrvoR9Y65rP89EDI+gh3EVkAvgagSTzRz1ZBk+srn8Pw9TB5Mi2ucRiaUWBjQSBTBMDORKAgEHEnBh4it+NyOs3jN2vxlFGwCTf0E655Fhj4STS/dOyDC4FRFKzxz/9r9lzg82sI2Q9SSlRWqH7gzhulgJ8AcWmTBT8Uploiw6C3DhqdahVSxFjGwDet1MCZ+rFbhCdZe8A71vh41EDc5f3FiAGd0bPHoWi8L62UJOmGfkfBYOqPVncko+5ofMJn45hveWCMrKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OvPKBfkGkbnFgPJDK8q1BOfBlh4n7YMzuNyiBClCR94=;
 b=okm0tUuZB4MDmqla/jI9Gmn4omBmP8Rr0k/GxErpXi/zKJ/maqy2Vkun+qxx6QK233UOoxRanHQAIj37FmioPl0IILpIRDms5F76GmyHr/Rew2jQVP3GrVPP8suudAEUltGIN0z+BY6t/6h88P5uCUu1+xE/9w7QsL+4yPzLzLQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BLAPR13MB4578.namprd13.prod.outlook.com (2603:10b6:208:332::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.19; Tue, 1 Nov
 2022 11:03:14 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::483b:9e84:fadc:da30]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::483b:9e84:fadc:da30%7]) with mapi id 15.20.5791.017; Tue, 1 Nov 2022
 11:03:14 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Leon Romanovsky <leon@kernel.org>,
        Chentian Liu <chengtian.liu@corigine.com>,
        Huanhuan Wang <huanhuan.wang@corigine.com>,
        Yinjun Zhang <yinjun.zhang@corigine.com>,
        Louis Peens <louis.peens@corigine.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com
Subject: [PATCH net-next v3 2/3] nfp: add framework to support ipsec offloading
Date:   Tue,  1 Nov 2022 12:02:47 +0100
Message-Id: <20221101110248.423966-3-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221101110248.423966-1-simon.horman@corigine.com>
References: <20221101110248.423966-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0902CA0007.eurprd09.prod.outlook.com
 (2603:10a6:200:9b::17) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BLAPR13MB4578:EE_
X-MS-Office365-Filtering-Correlation-Id: 60fbce20-c0e8-4813-1192-08dabbf8ac6f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: J6K9on2SsIY7lTlCSp9xmOSSQTXf09P437nuQbgu+uGz0vJbwit1L990sKcDTKqeem/Ys7zyxPZiQue6EiLwwgotV6spYT4r3GQ1WI0giZgT+wkZRV5emucgL+4xRdedK0G2Bp2qnR/2nhhI2GFjGZPyxReRKUNIrUYwrxS5e1mYlCPJ9dJ67wfBVzCisRPO/R9qCfuJXSdurZCcjKT6KLHuoFy8S22MrmopNNbEUcsiLEuOoTdPZ/Z5vnW2xcdzJP8Wcq/G7LmkRIPeH0qcD7M4lqN9DFR6wHxzz5e07KG5G5ls6Bd7EeSrMfBn8X+eepls/KmUGLvQkdrMdGaDhb2tJY6kSM+0dWDfS4Pwl7L6G0JLmnoZpXTtubw5mP9wugkjbeyiWllhu/RZw8veqSNWDSbb0RuGBt1iMnt/q6N87IriEJ47QvNLjvwrN2kcDYgmSfQjTg27V2cB7G4ilfZUjTFczGv8Z4+N7sfng8KVzG6bwSx61CUiVJT2EIWq5S67G7PMRZm2zEBTACy4cD4gD4bvTwtNQvAbkvzg36ZJmu2tvCRhJXm/at370pO9JjjV7x/bKz4JDxKA+w1ge9CTr4Sk5+ROOd0iEnqHMuAoJOaqoOC/cPmWyv/X9ud6Snl7x/IQcmIU9MngQX42AN1QabPjnotMp1OH63hpYYzxvcvGs+6G5Z8QMwJXoPBUXVt1IyM4b2g4qyQqS+qUHYbx6DslUOCMmkFic8/I1O0AzFaTUYS7uTeF4Bnesga+X5n/I2W98lP6F3o/5wl+lQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(136003)(376002)(39830400003)(366004)(396003)(451199015)(41300700001)(2616005)(86362001)(83380400001)(38100700002)(6512007)(316002)(36756003)(5660300002)(6506007)(4326008)(8676002)(66946007)(52116002)(66556008)(66476007)(54906003)(2906002)(186003)(110136005)(6666004)(107886003)(6486002)(30864003)(44832011)(478600001)(1076003)(8936002)(309714004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?I+coBm9EXGe12AtHLmtOJbO0xHhFb4WRX3ALRk9R9MnToQ4jQ1Rca52sKyhI?=
 =?us-ascii?Q?+ElYI8aQLNd3GmJ8WoRIFQXQyBCkg3ew5kxJovRFCKG2sgsgG20qKsTWTIec?=
 =?us-ascii?Q?sLUtoXQqrF4ChI5+CSQXiUm+EjQ08Yb3hCmqdjjPXH/5juvscTpO6uj59j1B?=
 =?us-ascii?Q?fKr65IFmUTrngrytrB34Su7RCCDeW/iqVBULcoPjyeMsX3AKyP9Hygjj+zh9?=
 =?us-ascii?Q?Ecdnq6UEoYK2v4fs5oOWeXFbuLNsIllhqM/uDmkkx/NSfcN+fJZZV8Nf3Hvj?=
 =?us-ascii?Q?S3Edi1ctI6/xkiTJHZelBsGvZZ8bwoHe+wu91wy+67g1I6/UZ1LrVJQ2qY3J?=
 =?us-ascii?Q?x5/rflt0KEEkgtl0CKIKN75DP02Yf2Iomrz9Zu8xdPodixToNirnPHors51J?=
 =?us-ascii?Q?9biDWz81nDQ3bWftnbbjkoyS3aqr8akOI1+YSVGhNRXUWSfErfXImmh0VRVe?=
 =?us-ascii?Q?qOlEhBNjPEMBNmRVUqPo6LJuNgJIo+8cCTLmJUQivluFuoslvmx6rakCzjX1?=
 =?us-ascii?Q?F0x9Bzk8ZL7hVPT0oDASdAkPOCyiQZx+O5mfYh1cICXp9oT7H7OdQ0Lp8prf?=
 =?us-ascii?Q?Oeju9EXZCLTCad0bMgpYdtInNjfG9Hz/bjbwUxi4RmFfeb0/Hv1ia1QPnoq1?=
 =?us-ascii?Q?qxg7hiBllCJS3YWV/ToQrPbKPsypWee3oXOkOM/VHx5pCkpVdSZEtdUdY+Tp?=
 =?us-ascii?Q?ZeBPB/OkrApv8TfBX2X+1SfrYInF/zZhr9IYHHEnzoFVANydnwcoHB74Svhg?=
 =?us-ascii?Q?cUe9ZvIYwfxSNsSTo3XZ20NTUuzeDkoGpKNNprpO9iYs91bTxIeASiZZ5sAS?=
 =?us-ascii?Q?VCBScZThBzF8FSMJuAYtdh0hOoi66BVXL++fmVHr2t8MqqvNMSpQt//9XHeu?=
 =?us-ascii?Q?Ofk87Ydt9au0taaHocYAF/DwnZEi2hoUHpPlC2tQB6kgmtF/kvvN7vq3MkXp?=
 =?us-ascii?Q?nM8NntnYhv7HvYA9RxJmNJrJCgtErCKb5b4X+L+NzDcoGxu9qP8GXRgCv6kY?=
 =?us-ascii?Q?7OAXpDnYZDtYxrM+ZQXWSbO4VHdlSY69TnwYtX0VkZnW2MZJX6WXmoXoFgWW?=
 =?us-ascii?Q?c9tXcmviO4X8lug5POkvK07fpP88Iyxr+ncXXnYdnLD37MN+4hTvTdKbdFKq?=
 =?us-ascii?Q?q2eyF+tB/xOU4t2sevkZsz1jKhvSirBj2m116VgU2ncGQecUtzW+pWvH2RkQ?=
 =?us-ascii?Q?P2dkwRw6HOmbSkL4VC95Nu4c9H4O00TuV+UUZegZ0+k6NWY1DjJ28gqTSXws?=
 =?us-ascii?Q?SBY38UUyuYVIKtn8C3LlvpjmuJ1AiuKsyVBsQrkmh5Mdg8ng/PVZ3pfS+QYf?=
 =?us-ascii?Q?s8HjY6QS0agDfg3U5d/ckvNB4ejKrvvir9YrRxBudnS3emqpGvYxpK1u1kAE?=
 =?us-ascii?Q?9rveXsTzmPz2higMdPW2LV1ZBxujnMoGtHQVmRQ94LGTYzbWuH1kD3pIb+8W?=
 =?us-ascii?Q?OgSddAgJ7r6LJ1Su0XFpXUGP77ElzQvKB7qVbci9RBB3lE8W5bxeXJ+pd4DF?=
 =?us-ascii?Q?LysKoFP/fsCaBqc1oDZSpSf2vTajFr6pbUX4OhicVMOATB/83yW1P474Tijn?=
 =?us-ascii?Q?hqmI6ftoX0cRzrJ0OaRlXbpZtkZvh9rAKd6ho443q5BVZz4p/VV+yExCh0Fp?=
 =?us-ascii?Q?7JTCkU+Kh1RPoP/VELpBbdRl6YPukZD4CHVn09U2LV0BuJYPJeQe7/UlgdrD?=
 =?us-ascii?Q?Tzw5Zw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 60fbce20-c0e8-4813-1192-08dabbf8ac6f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Nov 2022 11:03:14.6996
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YueNYmXCLeLxvw6acOsw1paHgaqu47mEr0U4BqFYjDPxecMXDmMiym1NcwxMm1sK8PEB1UYJdJ/5TLOIQNRqk7UDAj7PnfEQ1cII2s/aSiw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR13MB4578
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Huanhuan Wang <huanhuan.wang@corigine.com>

A new metadata type and config structure are introduced to
interact with firmware to support ipsec offloading. This
feature relies on specific firmware that supports ipsec
encrypt/decrypt by advertising related capability bit.

The xfrm callbacks which interact with upper layer are
implemented in the following patch.

Based on initial work of Norm Bagley <norman.bagley@netronome.com>.

Signed-off-by: Huanhuan Wang <huanhuan.wang@corigine.com>
Reviewed-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 drivers/net/ethernet/netronome/Kconfig        |  11 ++
 drivers/net/ethernet/netronome/nfp/Makefile   |   2 +
 .../ethernet/netronome/nfp/crypto/crypto.h    |  23 ++++
 .../net/ethernet/netronome/nfp/crypto/ipsec.c | 105 ++++++++++++++++++
 drivers/net/ethernet/netronome/nfp/nfd3/dp.c  |  58 ++++++++--
 .../net/ethernet/netronome/nfp/nfd3/ipsec.c   |  18 +++
 .../net/ethernet/netronome/nfp/nfd3/nfd3.h    |   8 ++
 drivers/net/ethernet/netronome/nfp/nfp_net.h  |   9 ++
 .../ethernet/netronome/nfp/nfp_net_common.c   |   3 +
 .../net/ethernet/netronome/nfp/nfp_net_ctrl.h |   4 +
 10 files changed, 231 insertions(+), 10 deletions(-)
 create mode 100644 drivers/net/ethernet/netronome/nfp/crypto/ipsec.c
 create mode 100644 drivers/net/ethernet/netronome/nfp/nfd3/ipsec.c

diff --git a/drivers/net/ethernet/netronome/Kconfig b/drivers/net/ethernet/netronome/Kconfig
index 8844d1ac053a..e785c00b5845 100644
--- a/drivers/net/ethernet/netronome/Kconfig
+++ b/drivers/net/ethernet/netronome/Kconfig
@@ -54,6 +54,17 @@ config NFP_APP_ABM_NIC
 	  functionality.
 	  Code will be built into the nfp.ko driver.
 
+config NFP_NET_IPSEC
+	bool "NFP IPsec crypto offload support"
+	depends on NFP
+	depends on XFRM_OFFLOAD
+	default y
+	help
+	  Enable driver support IPsec crypto offload on NFP NIC.
+	  Say Y, if you are planning to make use of IPsec crypto
+	  offload. NOTE that IPsec crypto offload on NFP NIC
+	  requires specific FW to work.
+
 config NFP_DEBUG
 	bool "Debug support for Netronome(R) NFP4000/NFP6000 NIC drivers"
 	depends on NFP
diff --git a/drivers/net/ethernet/netronome/nfp/Makefile b/drivers/net/ethernet/netronome/nfp/Makefile
index 9c0861d03634..8a250214e289 100644
--- a/drivers/net/ethernet/netronome/nfp/Makefile
+++ b/drivers/net/ethernet/netronome/nfp/Makefile
@@ -80,4 +80,6 @@ nfp-objs += \
 	    abm/main.o
 endif
 
+nfp-$(CONFIG_NFP_NET_IPSEC) += crypto/ipsec.o nfd3/ipsec.o
+
 nfp-$(CONFIG_NFP_DEBUG) += nfp_net_debugfs.o
diff --git a/drivers/net/ethernet/netronome/nfp/crypto/crypto.h b/drivers/net/ethernet/netronome/nfp/crypto/crypto.h
index bffe58bb2f27..1df73d658938 100644
--- a/drivers/net/ethernet/netronome/nfp/crypto/crypto.h
+++ b/drivers/net/ethernet/netronome/nfp/crypto/crypto.h
@@ -39,4 +39,27 @@ nfp_net_tls_rx_resync_req(struct net_device *netdev,
 }
 #endif
 
+/* IPsec related structures and functions */
+struct nfp_ipsec_offload {
+	u32 seq_hi;
+	u32 seq_low;
+	u32 handle;
+};
+
+#ifndef CONFIG_NFP_NET_IPSEC
+static inline void nfp_net_ipsec_init(struct nfp_net *nn)
+{
+}
+
+static inline void nfp_net_ipsec_clean(struct nfp_net *nn)
+{
+}
+#else
+void nfp_net_ipsec_init(struct nfp_net *nn);
+void nfp_net_ipsec_clean(struct nfp_net *nn);
+bool nfp_net_ipsec_tx_prep(struct nfp_net_dp *dp, struct sk_buff *skb,
+			   struct nfp_ipsec_offload *offload_info);
+int nfp_net_ipsec_rx(struct nfp_meta_parsed *meta, struct sk_buff *skb);
+#endif
+
 #endif
diff --git a/drivers/net/ethernet/netronome/nfp/crypto/ipsec.c b/drivers/net/ethernet/netronome/nfp/crypto/ipsec.c
new file mode 100644
index 000000000000..11575a9cb3b0
--- /dev/null
+++ b/drivers/net/ethernet/netronome/nfp/crypto/ipsec.c
@@ -0,0 +1,105 @@
+// SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+/* Copyright (C) 2018 Netronome Systems, Inc */
+/* Copyright (C) 2021 Corigine, Inc */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/netdevice.h>
+#include <asm/unaligned.h>
+#include <linux/ktime.h>
+#include <net/xfrm.h>
+
+#include "../nfp_net_ctrl.h"
+#include "../nfp_net.h"
+#include "crypto.h"
+
+#define NFP_NET_IPSEC_MAX_SA_CNT  (16 * 1024) /* Firmware support a maximum of 16K SA offload */
+
+static int nfp_net_xfrm_add_state(struct xfrm_state *x)
+{
+	return -EOPNOTSUPP;
+}
+
+static void nfp_net_xfrm_del_state(struct xfrm_state *x)
+{
+}
+
+static bool nfp_net_ipsec_offload_ok(struct sk_buff *skb, struct xfrm_state *x)
+{
+	return false;
+}
+
+static const struct xfrmdev_ops nfp_net_ipsec_xfrmdev_ops = {
+	.xdo_dev_state_add = nfp_net_xfrm_add_state,
+	.xdo_dev_state_delete = nfp_net_xfrm_del_state,
+	.xdo_dev_offload_ok = nfp_net_ipsec_offload_ok,
+};
+
+void nfp_net_ipsec_init(struct nfp_net *nn)
+{
+	if (!(nn->cap_w1 & NFP_NET_CFG_CTRL_IPSEC))
+		return;
+
+	xa_init_flags(&nn->xa_ipsec, XA_FLAGS_ALLOC);
+	nn->dp.netdev->xfrmdev_ops = &nfp_net_ipsec_xfrmdev_ops;
+}
+
+void nfp_net_ipsec_clean(struct nfp_net *nn)
+{
+	if (!(nn->cap_w1 & NFP_NET_CFG_CTRL_IPSEC))
+		return;
+	xa_destroy(&nn->xa_ipsec);
+}
+
+bool nfp_net_ipsec_tx_prep(struct nfp_net_dp *dp, struct sk_buff *skb,
+			   struct nfp_ipsec_offload *offload_info)
+{
+	struct xfrm_offload *xo = xfrm_offload(skb);
+	struct xfrm_state *x;
+
+	x = xfrm_input_state(skb);
+	if (!x)
+		return false;
+
+	offload_info->seq_hi = xo->seq.hi;
+	offload_info->seq_low = xo->seq.low;
+	offload_info->handle = x->xso.offload_handle;
+
+	return true;
+}
+
+int nfp_net_ipsec_rx(struct nfp_meta_parsed *meta, struct sk_buff *skb)
+{
+	struct net_device *netdev = skb->dev;
+	struct xfrm_offload *xo;
+	struct xfrm_state *x;
+	struct sec_path *sp;
+	struct nfp_net *nn;
+	u32 saidx;
+
+	nn = netdev_priv(netdev);
+
+	saidx = meta->ipsec_saidx - 1;
+	if (saidx >= NFP_NET_IPSEC_MAX_SA_CNT)
+		return -EINVAL;
+
+	sp = secpath_set(skb);
+	if (unlikely(!sp))
+		return -ENOMEM;
+
+	xa_lock(&nn->xa_ipsec);
+	x = xa_load(&nn->xa_ipsec, saidx);
+	xa_unlock(&nn->xa_ipsec);
+	if (!x)
+		return -EINVAL;
+
+	xfrm_state_hold(x);
+	sp->xvec[sp->len++] = x;
+	sp->olen++;
+	xo = xfrm_offload(skb);
+	xo->flags = CRYPTO_DONE;
+	xo->status = CRYPTO_SUCCESS;
+
+	return 0;
+}
diff --git a/drivers/net/ethernet/netronome/nfp/nfd3/dp.c b/drivers/net/ethernet/netronome/nfp/nfd3/dp.c
index 448c1c1afaee..861082c5dbff 100644
--- a/drivers/net/ethernet/netronome/nfp/nfd3/dp.c
+++ b/drivers/net/ethernet/netronome/nfp/nfd3/dp.c
@@ -4,6 +4,7 @@
 #include <linux/bpf_trace.h>
 #include <linux/netdevice.h>
 #include <linux/bitfield.h>
+#include <net/xfrm.h>
 
 #include "../nfp_app.h"
 #include "../nfp_net.h"
@@ -167,28 +168,34 @@ nfp_nfd3_tx_csum(struct nfp_net_dp *dp, struct nfp_net_r_vector *r_vec,
 	u64_stats_update_end(&r_vec->tx_sync);
 }
 
-static int nfp_nfd3_prep_tx_meta(struct nfp_net_dp *dp, struct sk_buff *skb, u64 tls_handle)
+static int nfp_nfd3_prep_tx_meta(struct nfp_net_dp *dp, struct sk_buff *skb,
+				 u64 tls_handle, bool *ipsec)
 {
 	struct metadata_dst *md_dst = skb_metadata_dst(skb);
+	struct nfp_ipsec_offload offload_info;
 	unsigned char *data;
 	bool vlan_insert;
 	u32 meta_id = 0;
 	int md_bytes;
 
-	if (unlikely(md_dst || tls_handle)) {
-		if (unlikely(md_dst && md_dst->type != METADATA_HW_PORT_MUX))
-			md_dst = NULL;
-	}
+#ifdef CONFIG_NFP_NET_IPSEC
+	if (xfrm_offload(skb))
+		*ipsec = nfp_net_ipsec_tx_prep(dp, skb, &offload_info);
+#endif
+
+	if (unlikely(md_dst && md_dst->type != METADATA_HW_PORT_MUX))
+		md_dst = NULL;
 
 	vlan_insert = skb_vlan_tag_present(skb) && (dp->ctrl & NFP_NET_CFG_CTRL_TXVLAN_V2);
 
-	if (!(md_dst || tls_handle || vlan_insert))
+	if (!(md_dst || tls_handle || vlan_insert || *ipsec))
 		return 0;
 
 	md_bytes = sizeof(meta_id) +
 		   !!md_dst * NFP_NET_META_PORTID_SIZE +
 		   !!tls_handle * NFP_NET_META_CONN_HANDLE_SIZE +
-		   vlan_insert * NFP_NET_META_VLAN_SIZE;
+		   vlan_insert * NFP_NET_META_VLAN_SIZE +
+		   *ipsec * NFP_NET_META_IPSEC_FIELD_SIZE; /* IPsec has 12 bytes of metadata */
 
 	if (unlikely(skb_cow_head(skb, md_bytes)))
 		return -ENOMEM;
@@ -218,6 +225,19 @@ static int nfp_nfd3_prep_tx_meta(struct nfp_net_dp *dp, struct sk_buff *skb, u64
 		meta_id <<= NFP_NET_META_FIELD_SIZE;
 		meta_id |= NFP_NET_META_VLAN;
 	}
+	if (*ipsec) {
+		/* IPsec has three consecutive 4-bit IPsec metadata types,
+		 * so in total IPsec has three 4 bytes of metadata.
+		 */
+		data -= NFP_NET_META_IPSEC_SIZE;
+		put_unaligned_be32(offload_info.seq_hi, data);
+		data -= NFP_NET_META_IPSEC_SIZE;
+		put_unaligned_be32(offload_info.seq_low, data);
+		data -= NFP_NET_META_IPSEC_SIZE;
+		put_unaligned_be32(offload_info.handle - 1, data);
+		meta_id <<= NFP_NET_META_IPSEC_FIELD_SIZE;
+		meta_id |= NFP_NET_META_IPSEC << 8 | NFP_NET_META_IPSEC << 4 | NFP_NET_META_IPSEC;
+	}
 
 	data -= sizeof(meta_id);
 	put_unaligned_be32(meta_id, data);
@@ -246,6 +266,7 @@ netdev_tx_t nfp_nfd3_tx(struct sk_buff *skb, struct net_device *netdev)
 	dma_addr_t dma_addr;
 	unsigned int fsize;
 	u64 tls_handle = 0;
+	bool ipsec = false;
 	u16 qidx;
 
 	dp = &nn->dp;
@@ -273,7 +294,7 @@ netdev_tx_t nfp_nfd3_tx(struct sk_buff *skb, struct net_device *netdev)
 		return NETDEV_TX_OK;
 	}
 
-	md_bytes = nfp_nfd3_prep_tx_meta(dp, skb, tls_handle);
+	md_bytes = nfp_nfd3_prep_tx_meta(dp, skb, tls_handle, &ipsec);
 	if (unlikely(md_bytes < 0))
 		goto err_flush;
 
@@ -312,6 +333,8 @@ netdev_tx_t nfp_nfd3_tx(struct sk_buff *skb, struct net_device *netdev)
 		txd->vlan = cpu_to_le16(skb_vlan_tag_get(skb));
 	}
 
+	if (ipsec)
+		nfp_nfd3_ipsec_tx(txd, skb);
 	/* Gather DMA */
 	if (nr_frags > 0) {
 		__le64 second_half;
@@ -764,6 +787,15 @@ nfp_nfd3_parse_meta(struct net_device *netdev, struct nfp_meta_parsed *meta,
 				return false;
 			data += sizeof(struct nfp_net_tls_resync_req);
 			break;
+#ifdef CONFIG_NFP_NET_IPSEC
+		case NFP_NET_META_IPSEC:
+			/* Note: IPsec packet will have zero saidx, so need add 1
+			 * to indicate packet is IPsec packet within driver.
+			 */
+			meta->ipsec_saidx = get_unaligned_be32(data) + 1;
+			data += 4;
+			break;
+#endif
 		default:
 			return true;
 		}
@@ -876,12 +908,11 @@ static int nfp_nfd3_rx(struct nfp_net_rx_ring *rx_ring, int budget)
 	struct nfp_net_dp *dp = &r_vec->nfp_net->dp;
 	struct nfp_net_tx_ring *tx_ring;
 	struct bpf_prog *xdp_prog;
+	int idx, pkts_polled = 0;
 	bool xdp_tx_cmpl = false;
 	unsigned int true_bufsz;
 	struct sk_buff *skb;
-	int pkts_polled = 0;
 	struct xdp_buff xdp;
-	int idx;
 
 	xdp_prog = READ_ONCE(dp->xdp_prog);
 	true_bufsz = xdp_prog ? PAGE_SIZE : dp->fl_bufsz;
@@ -1081,6 +1112,13 @@ static int nfp_nfd3_rx(struct nfp_net_rx_ring *rx_ring, int budget)
 			continue;
 		}
 
+#ifdef CONFIG_NFP_NET_IPSEC
+		if (meta.ipsec_saidx != 0 && unlikely(nfp_net_ipsec_rx(&meta, skb))) {
+			nfp_nfd3_rx_drop(dp, r_vec, rx_ring, NULL, skb);
+			continue;
+		}
+#endif
+
 		if (meta_len_xdp)
 			skb_metadata_set(skb, meta_len_xdp);
 
diff --git a/drivers/net/ethernet/netronome/nfp/nfd3/ipsec.c b/drivers/net/ethernet/netronome/nfp/nfd3/ipsec.c
new file mode 100644
index 000000000000..e90f8c975903
--- /dev/null
+++ b/drivers/net/ethernet/netronome/nfp/nfd3/ipsec.c
@@ -0,0 +1,18 @@
+// SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+/* Copyright (C) 2018 Netronome Systems, Inc */
+/* Copyright (C) 2021 Corigine, Inc */
+
+#include <net/xfrm.h>
+
+#include "../nfp_net.h"
+#include "nfd3.h"
+
+void nfp_nfd3_ipsec_tx(struct nfp_nfd3_tx_desc *txd, struct sk_buff *skb)
+{
+	struct xfrm_state *x = xfrm_input_state(skb);
+
+	if (x->xso.dev && (x->xso.dev->features & NETIF_F_HW_ESP_TX_CSUM)) {
+		txd->flags |= NFD3_DESC_TX_CSUM | NFD3_DESC_TX_IP4_CSUM |
+			      NFD3_DESC_TX_TCP_CSUM | NFD3_DESC_TX_UDP_CSUM;
+	}
+}
diff --git a/drivers/net/ethernet/netronome/nfp/nfd3/nfd3.h b/drivers/net/ethernet/netronome/nfp/nfd3/nfd3.h
index 7a0df9e6c3c4..9c1c10dcbaee 100644
--- a/drivers/net/ethernet/netronome/nfp/nfd3/nfd3.h
+++ b/drivers/net/ethernet/netronome/nfp/nfd3/nfd3.h
@@ -103,4 +103,12 @@ void nfp_nfd3_rx_ring_fill_freelist(struct nfp_net_dp *dp,
 void nfp_nfd3_xsk_tx_free(struct nfp_nfd3_tx_buf *txbuf);
 int nfp_nfd3_xsk_poll(struct napi_struct *napi, int budget);
 
+#ifndef CONFIG_NFP_NET_IPSEC
+static inline void nfp_nfd3_ipsec_tx(struct nfp_nfd3_tx_desc *txd, struct sk_buff *skb)
+{
+}
+#else
+void nfp_nfd3_ipsec_tx(struct nfp_nfd3_tx_desc *txd, struct sk_buff *skb);
+#endif
+
 #endif
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net.h b/drivers/net/ethernet/netronome/nfp/nfp_net.h
index 0c3e7e2f856d..6c83e47d8b3d 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net.h
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net.h
@@ -263,6 +263,10 @@ struct nfp_meta_parsed {
 		u8 tpid;
 		u16 tci;
 	} vlan;
+
+#ifdef CONFIG_NFP_NET_IPSEC
+	u32 ipsec_saidx;
+#endif
 };
 
 struct nfp_net_rx_hash {
@@ -584,6 +588,7 @@ struct nfp_net_dp {
  * @qcp_cfg:            Pointer to QCP queue used for configuration notification
  * @tx_bar:             Pointer to mapped TX queues
  * @rx_bar:             Pointer to mapped FL/RX queues
+ * @xa_ipsec:           IPsec xarray SA data
  * @tlv_caps:		Parsed TLV capabilities
  * @ktls_tx_conn_cnt:	Number of offloaded kTLS TX connections
  * @ktls_rx_conn_cnt:	Number of offloaded kTLS RX connections
@@ -672,6 +677,10 @@ struct nfp_net {
 	u8 __iomem *tx_bar;
 	u8 __iomem *rx_bar;
 
+#ifdef CONFIG_NFP_NET_IPSEC
+	struct xarray xa_ipsec;
+#endif
+
 	struct nfp_net_tlv_caps tlv_caps;
 
 	unsigned int ktls_tx_conn_cnt;
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index 50bc5f5a40f3..8e9b34b133f4 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -2566,6 +2566,8 @@ int nfp_net_init(struct nfp_net *nn)
 		err = nfp_net_tls_init(nn);
 		if (err)
 			goto err_clean_mbox;
+
+		nfp_net_ipsec_init(nn);
 	}
 
 	nfp_net_vecs_init(nn);
@@ -2589,6 +2591,7 @@ void nfp_net_clean(struct nfp_net *nn)
 		return;
 
 	unregister_netdev(nn->dp.netdev);
+	nfp_net_ipsec_clean(nn);
 	nfp_ccm_mbox_clean(nn);
 	nfp_net_reconfig_wait_posted(nn);
 }
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h b/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h
index bc94d2cf1042..8f75efd9e463 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h
@@ -48,6 +48,7 @@
 #define NFP_NET_META_CSUM		6 /* checksum complete type */
 #define NFP_NET_META_CONN_HANDLE	7
 #define NFP_NET_META_RESYNC_INFO	8 /* RX resync info request */
+#define NFP_NET_META_IPSEC		9 /* IPsec SA index for tx and rx */
 
 #define NFP_META_PORT_ID_CTRL		~0U
 
@@ -55,6 +56,8 @@
 #define NFP_NET_META_VLAN_SIZE			4
 #define NFP_NET_META_PORTID_SIZE		4
 #define NFP_NET_META_CONN_HANDLE_SIZE		8
+#define NFP_NET_META_IPSEC_SIZE			4
+#define NFP_NET_META_IPSEC_FIELD_SIZE		12
 /* Hash type pre-pended when a RSS hash was computed */
 #define NFP_NET_RSS_NONE		0
 #define NFP_NET_RSS_IPV4		1
@@ -263,6 +266,7 @@
  */
 #define NFP_NET_CFG_CTRL_WORD1		0x0098
 #define   NFP_NET_CFG_CTRL_PKT_TYPE	  (0x1 << 0) /* Pkttype offload */
+#define   NFP_NET_CFG_CTRL_IPSEC	  (0x1 << 1) /* IPsec offload */
 
 #define NFP_NET_CFG_CAP_WORD1		0x00a4
 
-- 
2.30.2

